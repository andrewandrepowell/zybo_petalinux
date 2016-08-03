#include "linuxspi.h"

linuxspi::linuxspi( int busmaster, int chipselect )
{
	const size_t BUFF_SIZE = 32;
	char buff[ BUFF_SIZE ];
	snprintf( buff, BUFF_SIZE-1, "/dev/spidev%d.%d", busmaster, chipselect );
	file = ::open( buff, O_RDWR );
	if ( file < 0 )
	{
		throw std::runtime_error( "Couldn't open spidev adapter." );
	}
}

linuxspi::~linuxspi()
{
	if ( ::close( file ) < 0 ) 
	{
		throw std::runtime_error( "Couldn't close spidev adapter properly. ");
	}
}

void linuxspi::perform_trans( uint8_t* write_buff, uint8_t* read_buff, size_t size )
{
	struct spi_ioc_transfer xfer[ 2 ];

	memset( xfer, 0, sizeof( xfer ) );
	xfer[ 0 ].tx_buf = reinterpret_cast<unsigned long>( write_buff );
	xfer[ 0 ].len = size;
	xfer[ 1 ].rx_buf = reinterpret_cast<unsigned long>( read_buff );
	xfer[ 1 ].len = size;

	if ( ::ioctl( file, SPI_IOC_MESSAGE( 2 ), xfer ) < 0 )
	{
		throw std::runtime_error( "Couldn't perform full-duplex SPI transaction with spidev adapter.");
	}
}

void linuxspi::write( const uint8_t* data, size_t size )
{
	if ( ::write( file, data, size ) < 0 )
	{
		throw std::runtime_error( "Data wasn't properly transmitted over the spidev adapter.");
	}
}

void linuxspi::read( uint8_t* data, size_t size )
{
	if ( ::read( file, data, size ) < 0 )
	{
		throw std::runtime_error( "Data wasn't properly recevied from the spidev adapter.");
	}
}
