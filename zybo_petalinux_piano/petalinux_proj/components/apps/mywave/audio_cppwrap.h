#ifndef AUDIO_CPPWRAP_H_
#define AUDIO_CPPWRAP_H_

#include "audio.h"

/* This is a cpp wrapper class. The c driver for the SSM2603 codec / ADI core can be
 found in audio.h/c.

 To take advantage of this wrapper class, simply create a child class of this class and
 define the virtual functions. */
class audio_cppwrap
{
public:
	audio_cppwrap() { }
	void start( uint32_t phy_base_addr, void* param )
	{
		this->param = param;
		audio_setup( &obj, phy_base_addr, 
			audio_cppwrap::audio_mem_access_def, 
			audio_cppwrap::audio_i2c_trans_def, 
			audio_cppwrap::audio_i2c_delay_def,
			this );
	} 
	void write_mem_sample_lr( uint32_t* samples ) { audio_write_mem_sample_lr( &obj, samples ); }
	uint32_t* read_mem_sample_lr() { return audio_read_mem_sample_lr( &obj ); }
	void write_mem_reset_tx() { audio_write_mem_reset_tx( &obj ); }
	void write_mem_reset_rx() { audio_write_mem_reset_rx( &obj ); }
private:
	audio obj;
	void* param;

	audio_cppwrap( const audio_cppwrap& ref ) { }
	audio_cppwrap& operator=( const audio_cppwrap& ref ) { return *this; }

	virtual void mem_access( audio_dir dir, uint32_t phy_addr, uint32_t* data, void* param ) = 0;
	virtual void i2c_trans( audio_dir dir, uint8_t slave_addr, uint8_t* data, size_t len, void* param ) = 0;
	virtual void i2c_delay( unsigned int ms, void* param ) = 0;

	static void audio_mem_access_def( audio_dir dir, uint32_t phy_addr, uint32_t* data, void* param )
	{
		audio_cppwrap* ptr = reinterpret_cast<audio_cppwrap*>( param );
		ptr->mem_access( dir, phy_addr, data, ptr->param );
	}
	static void audio_i2c_trans_def( audio_dir dir, uint8_t slave_addr, uint8_t* data, size_t len, void* param )
	{
		audio_cppwrap* ptr = reinterpret_cast<audio_cppwrap*>( param );
		ptr->i2c_trans( dir, slave_addr, data, len, ptr->param );
	}
	static void audio_i2c_delay_def( unsigned int ms, void* param )
	{
		audio_cppwrap* ptr = reinterpret_cast<audio_cppwrap*>( param );
		ptr->i2c_delay( ms, ptr->param );
	}
};

#endif

