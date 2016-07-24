#ifndef LINUXWRAPPER_H_
#define LINUXWRAPPER_H_

#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <time.h>
#include <stdint.h>
#include <linux/i2c-dev.h>
#include <termios.h>
#include <stdexcept>

#define HIGH 0x1
#define LOW  0x0

#define INPUT 0x0
#define OUTPUT 0x1

#define true 0x1
#define false 0x0

typedef uint8_t byte;

void delay( unsigned int ms );
void delayMicroseconds( unsigned int us );

class linuxi2c
{
public:
	/* Configures Linux I2C Master Interface. */
	linuxi2c( int adapter_number );
	~linuxi2c( );
	
	/* Performs operations on the I2C Master Interface. */
	void set_slave( uint8_t slave_addr );
	void write( const uint8_t* data, size_t size );
	void read( uint8_t* data, size_t size );
private:
	int file;

	/* User should not try to copy on object of this class. */
	linuxi2c( linuxi2c& obj ) { }
	linuxi2c& operator=( linuxi2c& obj) { return *this; }
};

/* Based on the following link:
 www.cplusplus.com/forum/general/29137 */
namespace buffer_toggle
{
	void on();
	void off();
};

#endif
