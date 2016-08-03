#ifndef LINUXSPI_H_
#define LINUXSPI_H_

#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <linux/types.h>
#include <linux/spi/spidev.h>
#include <stdexcept>

class linuxspi
{
public:
	linuxspi( int busmaster, int chipselect );
	~linuxspi();
	void perform_trans( uint8_t* write_buff, uint8_t* read_buff, size_t size );
	void write( const uint8_t* data, size_t size );
	void read( uint8_t* data, size_t size );
private:
	int file;

	/* User should not try to copy on object of this class. */
	linuxspi( linuxspi& obj ) { }
	linuxspi& operator=( linuxspi& obj) { return *this; }
};

#endif
