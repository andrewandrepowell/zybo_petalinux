#ifndef AUDIO_H_
#define AUDIO_H_

#include <stdint.h>
#include <string.h>

/* I2C Slave Interface Memory-Map for SSM2603. */
#define AUDIO_I2C_ADDR			( 0x1a ) //( 0b011010 ) 
#define AUDIO_REG_L_CH_ADC_VOL 		( 0x00 )
#define AUDIO_REG_R_CH_ADC_VOL		( 0x01 )
#define AUDIO_REG_L_CH_DAC_VOL		( 0x02 )
#define AUDIO_REG_R_CH_DAC_VAL		( 0x03 )
#define AUDIO_REG_ANA_AUD_PATH		( 0x04 )
#define AUDIO_REG_DIG_AUD_PATH		( 0x05 )
#define AUDIO_REG_POW_MAN		( 0x06 )
#define AUDIO_REG_DIG_AUD_IF		( 0x07 )
#define AUDIO_REG_SAMPLE_RATE		( 0x08 )
#define AUDIO_REG_ACTIVE		( 0x09 )
#define AUDIO_REG_SOFT_RESET		( 0x0f )
#define AUDIO_REG_ALC_CNTRL_1		( 0x10 )
#define AUDIO_REG_ALC_CNTRL_2		( 0x11 )
#define AUDIO_REG_NOISE_GATE		( 0x12 )

/* ADI Core Memory-Map. Sample Rate = 48 KHz */
#define AUDIO_REG_I2S_RESET 		( 0x00 )
#define AUDIO_REG_I2S_CTRL		( 0x04 )
#define AUDIO_REG_I2S_CLK_CTRL 		( 0x08 )
#define AUDIO_REG_I2S_FIFO_STS 		( 0x20 )
#define AUDIO_REG_I2S_RX_FIFO 		( 0x28 )
#define AUDIO_REG_I2S_TX_FIFO 		( 0x2C )

#ifdef __cplusplus
extern "C"
{
#endif

	typedef 
	enum { audio_dir_WRITE, audio_dir_READ }
	audio_dir;

	typedef void ( *audio_mem_access )( audio_dir dir, uint32_t phy_addr, uint32_t* data, void* param );
	typedef void ( *audio_i2c_trans )( audio_dir dir, uint8_t slave_addr, uint8_t* data, size_t len, void* param );
	typedef void ( *audio_i2c_delay )( unsigned int ms, void* param );

	typedef 
	struct 
	{
		uint32_t phy_base_addr;
		audio_mem_access perform_mem_access;
		audio_i2c_trans perform_i2c_trans;
		void* param;
	}
	audio;

	void audio_setup( audio* ptr, 
		uint32_t phy_base_addr, audio_mem_access perform_mem_access, 
		audio_i2c_trans perform_i2c_trans, audio_i2c_delay perform_delay, void* param );

	void audio_i2c_reg( audio* ptr, audio_dir dir, uint8_t reg_addr, uint16_t* data );

	static inline __attribute__ ( ( always_inline ) )
	void audio_write_mem( audio* ptr, uint32_t phy_addr, uint32_t data )
	{
		ptr->perform_mem_access( audio_dir_WRITE, ( ptr->phy_base_addr + phy_addr ), &data, ptr->param );
	}

	static inline __attribute__ ( ( always_inline ) )
	uint32_t audio_read_mem( audio* ptr, uint32_t phy_addr )
	{
		uint32_t data;
		ptr->perform_mem_access( audio_dir_READ, ( ptr->phy_base_addr + phy_addr ), &data, ptr->param );
		return data;
	}

	static inline __attribute__ ( ( always_inline ) )
	void audio_i2c_write_reg( audio* ptr, uint8_t reg_addr, uint16_t data )
	{
		audio_i2c_reg( ptr, audio_dir_WRITE, reg_addr, &data );
	}

	static inline __attribute__ ( ( always_inline ) )
	uint16_t audio_i2c_read_reg( audio* ptr, uint8_t reg_addr )
	{
		uint16_t data;
		audio_i2c_reg( ptr, audio_dir_READ, reg_addr, &data );
		return data;
	}

	void audio_write_mem_sample( audio* ptr, uint32_t sample );

	void audio_write_mem_sample_lr( audio* ptr, uint32_t* samples );

	uint32_t audio_read_mem_sample( audio* ptr );

	uint32_t* audio_read_mem_sample_lr( audio* ptr );	

	static inline __attribute__ ( ( always_inline ) )
	void audio_write_mem_reset_tx( audio* ptr )
	{
		audio_write_mem( ptr, AUDIO_REG_I2S_RESET, 0b010 ); /* Reset TX Fifo. */
		audio_write_mem( ptr, AUDIO_REG_I2S_CTRL, 0b001 ); /* Enable TX Fifo and disable MUTEEN. */
	}
	
	static inline __attribute__ ( ( always_inline ) )
	void audio_write_mem_reset_rx( audio* ptr )
	{
		audio_write_mem( ptr, AUDIO_REG_I2S_RESET, 0b100 ); /* Reset RX Fifo. */
		audio_write_mem( ptr, AUDIO_REG_I2S_CTRL, 0b010 ); /* Enable RX Fifo and disable MUTEEN. */
	}

#ifdef __cplusplus
}
#endif

#endif
