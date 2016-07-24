/*
 * Placeholder PetaLinux user application.
 *
 * Replace this with your application code
 */
#include <iostream>
#include "LiquidCrystal_I2C.h"
using namespace std;

/* Configure I2C Master Interface with Linux I2C Interface. */
linuxi2c i2cobj( 0 );

/* Configure LCD over I2C Master Interface. */
LiquidCrystal_I2C lcd( i2cobj, 0x3f, 2, 1, 0, 4, 5, 6, 7, 3, POSITIVE );

int main(int argc, char *argv[])
{
	/* Let the world know hello! */
	cout << "Hello, PetaLinux World!\n";
	
	/* Start the LCD. */
	lcd.begin( 20, 4, LCD_5x8DOTS );
	lcd.home();        

	/* Print message to user.*/
	lcd.print( "Hello World!" );
	lcd.home();

	/* Print each character to LCD. */
	buffer_toggle::off();
	while ( true )
	{
		lcd.print( ( char ) cin.get() );	
	}

	
	return 0;
}


