#include "audio.h"

void audio_setup( audio* ptr, 
	uint32_t phy_base_addr, audio_mem_access perform_mem_access, 
	audio_i2c_trans perform_i2c_trans, audio_i2c_delay perform_delay, void* param )
{
	/* Assign important variables. */
	ptr->phy_base_addr = phy_base_addr;
	ptr->perform_mem_access = perform_mem_access;
	ptr->perform_i2c_trans = perform_i2c_trans;
	ptr->param = param;

	/* Configure hardware via its I2C interface. */
	audio_i2c_write_reg( ptr, AUDIO_REG_SOFT_RESET, 	0b000000000 ); /* Perform reset. */
	perform_delay( 75, param );
	audio_i2c_write_reg( ptr, AUDIO_REG_POW_MAN,		0b000110000 ); /* Power on DAC, ADC, MIC, and LineIn. */
	audio_i2c_write_reg( ptr, AUDIO_REG_L_CH_ADC_VOL,	0b000010111 ); /* Set Right Channel ADC Volume. */
	audio_i2c_write_reg( ptr, AUDIO_REG_R_CH_ADC_VOL,	0b000010111 ); /* Set left Channel ADC Volume. */
	audio_i2c_write_reg( ptr, AUDIO_REG_L_CH_DAC_VOL,	0b101111001 ); /* Set the DAC Volume for both Channels. */
	audio_i2c_write_reg( ptr, AUDIO_REG_ANA_AUD_PATH,	0b000010000 ); /* Connect DAC to Output. */
	audio_i2c_write_reg( ptr, AUDIO_REG_DIG_AUD_PATH,	0b000000000 ); /* Leave all the defaults. */
	audio_i2c_write_reg( ptr, AUDIO_REG_DIG_AUD_IF, 	0b000001010 ); /* 24 bits in the typical I2S Format. */
	audio_i2c_write_reg( ptr, AUDIO_REG_SAMPLE_RATE,	0b000000000 ); /* Leave all the defaults. */
	perform_delay( 75, param );
	audio_i2c_write_reg( ptr, AUDIO_REG_ACTIVE, 		0b000000001 ); /* Let's turn this guy on! */
	audio_i2c_write_reg( ptr, AUDIO_REG_POW_MAN,		0b000100000 ); /* Turn on output power. */

	/* Configure ADI Core. */
	audio_write_mem( ptr, AUDIO_REG_I2S_CLK_CTRL, 		( 31 << 16 ) | ( 1 ) ); /* LRCLK = BCLK / 64 and BCLK = MCLK / 4. */	 
}

void audio_i2c_reg( audio* ptr, audio_dir dir, uint8_t reg_addr, uint16_t* data )
{
	uint8_t buff[ 2 ];
	audio_i2c_trans perform_i2c_trans = ptr->perform_i2c_trans;
	void* param = ptr->param;
	switch ( dir )
	{
	case audio_dir_WRITE:
		{
			buff[ 0 ] = ( reg_addr << 1 ) | ( ( *data >> 8 ) & 0x1 );
			buff[ 1 ] = ( *data & 0xff );
			perform_i2c_trans( audio_dir_WRITE, AUDIO_I2C_ADDR, buff, 2, param );
		}
		break;
	case audio_dir_READ:
		{
			buff[ 0 ] = reg_addr << 1;
			perform_i2c_trans( audio_dir_WRITE, AUDIO_I2C_ADDR, buff, 1, param );
			perform_i2c_trans( audio_dir_READ, AUDIO_I2C_ADDR, buff, 2, param );
			*data = ( buff[ 1 ] << 8 ) | buff[ 0 ];
		}
		break;
	}
}

void audio_write_mem_sample( audio* ptr, uint32_t sample )
{
	while ( audio_read_mem( ptr, AUDIO_REG_I2S_FIFO_STS ) & 0b0010 )
		continue;
	audio_write_mem( ptr, AUDIO_REG_I2S_TX_FIFO, sample << 8 );
}

void audio_write_mem_sample_lr( audio* ptr, uint32_t* samples )
{
	audio_write_mem_sample( ptr, samples[ 0 ] );
	audio_write_mem_sample( ptr, samples[ 1 ] );
}

uint32_t audio_read_mem_sample( audio* ptr )
{
	while ( audio_read_mem( ptr, AUDIO_REG_I2S_FIFO_STS ) & 0b0100 )
		continue;
	return audio_read_mem( ptr, AUDIO_REG_I2S_RX_FIFO ) >> 8;
}

uint32_t* audio_read_mem_sample_lr( audio* ptr )
{
	static uint32_t sample_lr[ 2 ];
	sample_lr[ 0 ] = audio_read_mem_sample( ptr );
	sample_lr[ 1 ] = audio_read_mem_sample( ptr );
	return sample_lr;
}


