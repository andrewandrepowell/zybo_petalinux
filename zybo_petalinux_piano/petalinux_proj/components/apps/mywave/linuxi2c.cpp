#include "linuxi2c.h"

linuxi2c::linuxi2c( int adapter_number )
{
	const size_t BUFF_SIZE = 32;
	char buff[ BUFF_SIZE ];
	snprintf( buff, BUFF_SIZE-1, "/dev/i2c-%d", adapter_number );
	file = ::open( buff, O_RDWR );
	if ( file < 0 )
	{
		throw std::runtime_error( "Couldn't open i2c adapter." );
	}
}

linuxi2c::~linuxi2c( )
{
	if ( ::close( file ) < 0 ) 
	{
		throw std::runtime_error( "Couldn't close i2c adapter properly. ");
	}
}

void linuxi2c::set_slave( uint8_t slave_addr )
{
	if ( ::ioctl( file, I2C_SLAVE, slave_addr ) < 0 )
	{
		throw std::runtime_error( "Couldn't set the slave address in the i2c adapter.");
	}
}

void linuxi2c::write( const uint8_t* data, size_t size )
{
	if ( ::write( file, data, size ) < 0 )
	{
		throw std::runtime_error( "Data wasn't properly transmitted over the i2c adapter.");
	}
}

void linuxi2c::read( uint8_t* data, size_t size )
{
	if ( ::read( file, data, size ) < 0 )
	{
		throw std::runtime_error( "Data wasn't properly recevied from the i2c adapter.");
	}
}
