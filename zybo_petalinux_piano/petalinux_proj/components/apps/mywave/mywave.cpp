/*
 * mywave - by Andrew Powell
 * This a basic application that allows the user to play a single octove of the C scale,
 * starting from middle C. The user can also read a value from the Digilent PmodMIC's SPI interface.
 * In software, the application depends on an user-space driver developed for the ADI I2S core which 
 * drives the I2S interface of the SSM2603 audio codec on the Zybo.
 *
 * The primary reason why this application was created had been to get more practice using Linux
 * drivers for embedded applications ( e.g. this example application depends on the SysFs interfaces
 * for I2C and SPI ) and also learn how an application running in user-space can access physical 
 * locations in memory. However, the real challenge of this project was booting from flash. To recap,
 * the following are the commands needed to boot a prebuilt image with jtag:
 *
 * petalinux-build
 * petalinux-package --prebuilt 
 * petalinux-boot --jtag --fpga --bitstream <BITSTREAM PATH>
 *
 * Seems simple enough. The command for creating the boot file ( *.bin ) should be the following.
 * 
 * petalinux-package --boot --fsbl <FSBL PATH> --fpga <BITSTREAM PATH> --u-boot --kernel <IMAGE PATH> --offset <IMAGE LOCATION IN FLASH>
 *
 * After programming the flash with the boot file and restarting the board, the boot process stops at u-boot.
 * u-boot reports an error, stating the image is in an incorrect format. Couldn't figure out for the live 
 * of me why petalinux-package was generating an incorrect boot file. 
 *
 * The solution? Within the SDK, the correct boot file is generated with the bootgen tool. The BIF file
 * should look similar to the following template:

 * //arch = zynq; split = false; format = BIN
 * the_ROM_image:
 * {
 *	[bootloader] <FSBL PATH>
 *	<BITSTREAM PATH>
 *	<U-BOOT PATH>
 *	[offset = <IMAGE LOCATION IN FLASH>] <IMAGE PATH>
 * }
 *
 * The resultant boot file from bootgen works as intended! 
 */

/* C++ Includes. */
#include <iostream>
#include <stdexcept>

/* C / Linux Includes. */
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <unistd.h>
#include <time.h>
#include <math.h>
#include <pthread.h>

/* User-defined Includes. */
#include "audio_cppwrap.h"
#include "linuxi2c.h"
#include "linuxspi.h"
#include "linuxmisc.h"

/* Important definitions. */
#define AUDIO_PHY_ADDR		( 0x43C00000 )
#define AUDIO_PHY_SIZE		( 64*1024 ) 
#define AUDIO_SAMPLE_RATE_HZ	( 48000 )
#define AUDIO_SAMPLE_PERIOD_US	( 1000000 / AUDIO_SAMPLE_RATE_HZ )
#define SAMPLES_TOTAL		( AUDIO_SAMPLE_RATE_HZ * 4 )
#define SINE_SCALAR		( static_cast<double>( 1 << 20 ) )

using namespace std;

/* This derivative class is necessary to implement the low-level I2C operations. */
class audio_driver : public audio_cppwrap
{
private:
	void mem_access( audio_dir dir, uint32_t phy_addr, uint32_t* data, void* param );
	void i2c_trans( audio_dir dir, uint8_t slave_addr, uint8_t* data, size_t len, void* param );
	void i2c_delay( unsigned int ms, void* param );
};

/* This class handles the virtual memory management. */
class memory_map
{
public:
	memory_map( off_t offset, size_t len );
	~memory_map();
	void write_mem( off_t offset_addr, uint32_t data ) 
	{
		uint8_t* vaddr = &mem[ page_offset + offset_addr ];
		*( reinterpret_cast<volatile uint32_t*>( vaddr ) ) = data; 
	}
	uint32_t read_mem( off_t offset_addr ) 
	{ 
		uint8_t* vaddr = &mem[ page_offset + offset_addr ];
		uint32_t data = *( reinterpret_cast<volatile uint32_t*>( vaddr ) );
		return data; 
	}
private:
	off_t page_base, page_offset;
	size_t len;
	uint8_t* mem;
	int fd;
};

void* inthread( void* param );

/* Objects for communicating with SSM2603 / ADI core. */
linuxi2c i2c_obj( 0 );
memory_map mm_obj( AUDIO_PHY_ADDR, AUDIO_PHY_SIZE );
audio_driver audio_obj;

/* Objects for receiving input from user in a separate thread. */
pthread_t inthread_obj;
pthread_mutex_t inmutex_obj;

/* Objects for generating Sine Wave according to user input. */
enum Note { C, D, E, F, G, A, B, HI_C, NOTE_TOTAL, grab_spidev } input_note = C;
double freqs[ NOTE_TOTAL ] = { 261.63, 293.66, 329.63, 349.23, 392.00, 440.00, 493.88, 523.25 };
size_t curr_sample = 0;

/* Objects for recording / playing. 

 Unlike the I2CDev SysFs driver, the SPIDev SysFs driver becomes visible through the
 following steps.
 
 Enter kernel configurations with the following: petalinux-config -c kernel 
 Find the drivers for SPI through the following menus: Device Drivers / SPI Support 
 Enable support for SPI device in user mode: User mode SPI device driver support 

 Enter u-boot configurations with the following: petalinux-config -c u-boot
 Find the drivers for SPI through the following menus: Device Drivers / SPI Support
 Enable SPI driver for Zynq: Zynq SPI driver 
 It should be noted the soft AXI SPI core would have likely needed Xilinx SPI driver. 

 Once the kernel and u-boot are configured, it's important the following is added to 
 the spi entry in the system device tree for the PS:

 	spidev: spidev@0 {
		compatible = "linux,spidev";
		spi-max-frequency = <1000000>;
		reg = <0>;
	}; */
linuxspi spi_obj( 32766, 0 );

int main(int argc, char *argv[])
{
	/* Send a friendly message to the user! */
	cout << "Hello World! This is supposed to be a test program for the AXI I2S ADI Core!" << endl;

	/* Initialize the audio codec through its I2C interface and initialize the ADI core's TX buffer. */
	audio_obj.start( 0, NULL );

	/* Start thread for receiving user input. */
	if ( pthread_mutex_init( &inmutex_obj, NULL ) > 0 )
	{
		throw runtime_error( "Mutex could not be created." );
	}
	if ( pthread_create( &inthread_obj, NULL, inthread, NULL ) > 0 )
	{
		throw runtime_error( "The input thread could not be created. ");
	}

	/* Write signal to TX buffer of ADI core. */
	audio_obj.write_mem_reset_tx();
	
	while ( true )
	{
		/* Get note from input. */
		pthread_mutex_lock( &inmutex_obj );
		Note note = input_note;
		pthread_mutex_unlock( &inmutex_obj );

		/* Perform an operation based on the note ( which is more a command ). */
		switch ( note )
		{
			/* Only play actual notes. */
			case C: case D: case E: case F: 
			case G: case A: case B: case HI_C:
			{
				/* Generate new value for sine wave. */
				double val;
				val = sin( static_cast<double>( curr_sample++ ) * freqs[ note ] * ( 2.0 * M_PI / AUDIO_SAMPLE_RATE_HZ ) );
				val = SINE_SCALAR*val + SINE_SCALAR;
	
				/* Write note the TX buffer of ADI core. */
				uint32_t samples[] = { static_cast<uint32_t>( val ), static_cast<uint32_t>( val ) };
				audio_obj.write_mem_sample_lr( samples );
			}	
			break;
			case grab_spidev:
			{
				/* Whelp, as it turns out, real-time operations seem very difficult
				 to accomplish without buffers or another means of helping the OS. 
				 Specifically, I tried using Linux API timers and I still couldn't 
				 consistently sample data from the PmodMIC in accordance to my sample
				 rate. Maybe I'm doing something wrong. But, in the future, the likely
				 solution will be to create a core, much similar to the ADI I2S core,
				 that can buffer samples according to my sample rate. 

				 For now, a single sample is taken from the PmodMIC as way to demonstrate
				 the SPIdev SysFs driver works as it should. */

				/* Sleep for half a second. */
				struct timespec ts;
				ts.tv_sec = 0;
				ts.tv_nsec = 500000000;
				if ( nanosleep( &ts, NULL ) < 0 )
				{
					throw runtime_error( "Nanosleep failed." );
				}
		
				/* Sample from PmodMIC. */
				uint8_t buff[ 2 ];
				spi_obj.read( buff, 2 );
				uint16_t val = ( buff[ 0 ] << 8 ) | buff[ 1 ];
				cout << "spidev value: " << val << endl;
				
			}
			break;
			default: break;
		}
	
	}

	return 0;
}

void* inthread( void* param )
{
	/* Let the user know what their possible options are! */
	cout << "The following are the valid input..." << endl;
	cout << "Keyboard | Operation\n"
		"a        | C note is played\n"
		"s        | D note is played\n"
		"d        | E note is played\n"
		"f        | F note is played\n"
		"g        | G note is played\n"
		"h        | A note is played\n"
		"j        | B note is played\n"
		"k        | C note is played\n"
		"z        | Grab samples from spidev driver\n";

	/* User shouldn't have to hit enter. */
	linuxstdin_bufoff();

	/* The input thread should run indefinitely. */
	while ( true )
	{
		char input = cin.get();
		pthread_mutex_lock( &inmutex_obj );
		switch ( input )
		{
		case 'a': input_note = C; break;
		case 's': input_note = D; break;
		case 'd': input_note = E; break;
		case 'f': input_note = F; break;
		case 'g': input_note = G; break;
		case 'h': input_note = A; break;
		case 'j': input_note = B; break;
		case 'k': input_note = HI_C; break;
		case 'z': input_note = grab_spidev; break;
		default: break;
		}
		pthread_mutex_unlock( &inmutex_obj );
	}
	return NULL;
}


void audio_driver::mem_access( audio_dir dir, uint32_t phy_addr, uint32_t* data, void* param )
{
	( void ) param;
	switch ( dir )
	{
		case audio_dir_WRITE:
		{
			mm_obj.write_mem( static_cast<off_t>( phy_addr ), *data );
		}
		break;
	
		case audio_dir_READ:
		{
			*data = mm_obj.read_mem( static_cast<off_t>( phy_addr ) );
		}
		break;
	}
}

void audio_driver::i2c_trans( audio_dir dir, uint8_t slave_addr, uint8_t* data, size_t len, void* param )
{
	( void ) param;
	i2c_obj.set_slave( slave_addr );
	switch ( dir )
	{
		case audio_dir_WRITE:
		{
			i2c_obj.write( data, len );
		}
		break;

		case audio_dir_READ:
		{
			i2c_obj.read( data, len );
		}
		break;
	}
}

void audio_driver::i2c_delay( unsigned int ms, void* param )
{
	( void ) param;
	struct timespec ts;
	ts.tv_sec = ms / 1000;
	ts.tv_nsec = ( ms % 1000 ) * 1000000;
	if ( nanosleep( &ts, NULL ) < 0 )
	{
		throw runtime_error( "Nanosleep failed." );
	}
	
}

memory_map::memory_map( off_t offset, size_t len ) : len( len )
{
	/* Memory-mapped virtual addresses are acquired in pages. */
	size_t pagesize = sysconf( _SC_PAGE_SIZE );
	page_base = ( offset / pagesize ) * pagesize;
	page_offset = offset - page_base;

	/* Perform the memory map between physical and virtual address. */
	fd = open( "/dev/mem", O_SYNC | O_RDWR );
	mem = reinterpret_cast<uint8_t*>( 
		mmap( NULL, page_offset + len, 
		PROT_READ | PROT_WRITE, MAP_SHARED, fd, page_base ) );
	if ( mem == MAP_FAILED ) 
	{
		throw runtime_error( "Memory mapping couldn't be performed." );
	}
}

memory_map::~memory_map()
{
	if ( munmap( mem, page_offset + len ) < 0 )
	{
		throw runtime_error( "Unmapping the memory couldn't be performed." );
	}
	if ( close( fd ) < 0 )
	{
		throw runtime_error( "Couldn't close file descriptor to memory." );
	}
}

