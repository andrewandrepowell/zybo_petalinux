/*
 * Placeholder PetaLinux user application.
 *
 * Replace this with your application code
 */
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>
#include <fcntl.h>
#include <signal.h>
#include <poll.h>

#define GPIO_ROOT 		"/sys/class/gpio"
#define GPIO_BASE_OUTS		902
#define GPIO_BASE_INS		893
#define GPIO_OUTS_NPINS		4
#define GPIO_INS_NPINS		9
#define GPIO_INS_PBS_BASE	0
#define GPIO_INS_SWS_BASE	4
#define GPIO_INS_PBS_SWS_NPINS	4

/* The following functions simplify utilization of the GPIO driver. These
 functions were taken from a Xilinx example. It recently occurred to me 
 many of these functions don't safely close file descriptors upon error. */
static int open_gpio_channel( int gpio_base );
static int close_gpio_channel( int gpio_base );
static int set_gpio_direction( int gpio_base, int nchannel, char *direction );
static int set_gpio_edge( int gpio_base, int nchannel, char *edge ); /* This function was added by Andrew Powell in order to utilize the GPIO interrupt. */
static int set_gpio_value( int gpio_base, int nchannel, int value );
static int get_gpio_value( int gpio_base, int nchannel );
static int poll_gpio_value( int gpio_base, int nchannel ); /* This function was added by Andrew Powell in order to utilize the GPIO interrupt. */

/* Signal handler is needed to ensure gpio is closed
 properly when the program ends. This signal handler should
 probably be modified to close file descriptors upon unexpected shutdown. */
static void signal_handler(int sig);

int main(int argc, char *argv[])
{
	int outs_npins, ins_npins;

	/* Open the GPIO with the Sys Interface. */
	outs_npins = open_gpio_channel( GPIO_BASE_OUTS );
	ins_npins =  open_gpio_channel( GPIO_BASE_INS );

	/* Setting the signal handler is needed to ensure the GPIO
	 is closed properly if the program ends unexpectedly. */
	signal( SIGTERM, signal_handler ); 	/* catch kill signal */
	signal( SIGHUP, signal_handler ); 	/* catch hang up signal */
	signal( SIGQUIT, signal_handler ); 	/* catch quit signal */
	signal( SIGINT, signal_handler ); 	/* catch a CTRL-c signal */

	/* As a way to check the right base gpio values are assigned,
	 check the npins since we know the true values. */
	if ( outs_npins != GPIO_OUTS_NPINS )
	{
		fprintf( stderr, "Computed outs_npins ( %d ) doesn't match expected value.\n", outs_npins );
		exit( 1 );
	}
	if ( ins_npins != GPIO_INS_NPINS )
	{
		fprintf( stderr, "Computed ins_npins ( %d ) doesn't match expected value.\n", ins_npins );
		exit( 1 );		
	}

	/* Set the directions of the gpio. */
	if ( ( set_gpio_direction( GPIO_BASE_OUTS, GPIO_OUTS_NPINS, "out" ) < 0 ) ||
		( set_gpio_direction( GPIO_BASE_INS, GPIO_INS_NPINS, "in" ) < 0 ) )
	{
		fprintf( stderr, "Setting the direction failed.\n" );
		exit( 1 );
	}

	/* Configure the use of the interrupt within the GPIO SysFs driver. 
	 Unlike the other gpio functions which came from an example, the
	 set_gpio_edge function was defined specifically for this zybo project. */
	if ( set_gpio_edge( GPIO_BASE_INS, GPIO_INS_NPINS, "rising" ) < 0 )
	{
		fprintf( stderr, "Setting the edge failed.\n" );
		exit( 1 );
	}
	

	/* This program runs indefinitely until the user forces the program to end. */
	while ( true )
	{
		int ins_pbs, ins_sws, outs, ins;

		/* Poll from GPIO ( relies on interrupt ). */
		ins = poll_gpio_value( GPIO_BASE_INS, GPIO_INS_NPINS );
		if ( ins < 0 )
		{
			fprintf( stderr, "Reading from gpio failed.\n" );
			exit( 1 );
		}
		ins_pbs = ins & 0x0f;
		ins_sws = ( ins & 0xf0 ) >> 4;

		/* Write to GPIO. */
		outs = ins_pbs ^ ins_sws;
		if ( set_gpio_value( GPIO_BASE_OUTS, GPIO_OUTS_NPINS, outs ) < 0 )
		{
			fprintf( stderr, "Writing to gpio failed.\n" );
			exit( 1 );
		}	

		/* Report to consol. */
		printf( "ins_pbs: %d,\tins_sws: %d,\t outs: %d\n", ins_pbs, ins_sws, outs ); 	
		continue;
	}

	return 0;
}

int open_gpio_channel(int gpio_base)
{
	char gpio_nchan_file[128];
	int gpio_nchan_fd;
	int gpio_max;
	int nchannel;
	char nchannel_str[5];
	char *cptr;
	int c;
	char channel_str[5];

	char *gpio_export_file = "/sys/class/gpio/export";
	int export_fd=0;

	/* Check how many channels the GPIO chip has */
	sprintf(gpio_nchan_file, "%s/gpiochip%d/ngpio", GPIO_ROOT, gpio_base);
	gpio_nchan_fd = open(gpio_nchan_file, O_RDONLY);
	if (gpio_nchan_fd < 0) {
		fprintf(stderr, "Failed to open %s: %s\n", gpio_nchan_file, strerror(errno)); 
		return -1;
	}
	read(gpio_nchan_fd, nchannel_str, sizeof(nchannel_str));
	close(gpio_nchan_fd);
	nchannel=(int)strtoul(nchannel_str, &cptr, 0);
	if (cptr == nchannel_str) {
		fprintf(stderr, "Failed to change %s into GPIO channel number\n", nchannel_str);
		exit(1);
	}

	/* Open files for each GPIO channel */
	export_fd=open(gpio_export_file, O_WRONLY);
	if (export_fd < 0) {
		fprintf(stderr, "Cannot open GPIO to export %d\n", gpio_base);
		return -1;
	}

	gpio_max = gpio_base + nchannel;	
	for(c = gpio_base; c < gpio_max; c++) {
		sprintf(channel_str, "%d", c);
		write(export_fd, channel_str, (strlen(channel_str)+1));
	}
	close(export_fd);
	return nchannel;
}

int close_gpio_channel(int gpio_base)
{
	char gpio_nchan_file[128];
	int gpio_nchan_fd;
	int gpio_max;
	int nchannel;
	char nchannel_str[5];
	char *cptr;
	int c;
	char channel_str[5];

	char *gpio_unexport_file = "/sys/class/gpio/unexport";
	int unexport_fd=0;

	/* Check how many channels the GPIO chip has */
	sprintf(gpio_nchan_file, "%s/gpiochip%d/ngpio", GPIO_ROOT, gpio_base);
	gpio_nchan_fd = open(gpio_nchan_file, O_RDONLY);
	if (gpio_nchan_fd < 0) {
		fprintf(stderr, "Failed to open %s: %s\n", gpio_nchan_file, strerror(errno)); 
		return -1;
	}
	read(gpio_nchan_fd, nchannel_str, sizeof(nchannel_str));
	close(gpio_nchan_fd);
	nchannel=(int)strtoul(nchannel_str, &cptr, 0);
	if (cptr == nchannel_str) {
		fprintf(stderr, "Failed to change %s into GPIO channel number\n", nchannel_str);
		exit(1);
	}

	/* Close opened files for each GPIO channel */
	unexport_fd=open(gpio_unexport_file, O_WRONLY);
	if (unexport_fd < 0) {
		fprintf(stderr, "Cannot close GPIO by writing unexport %d\n", gpio_base);
		return -1;
	}

	gpio_max = gpio_base + nchannel;	
	for(c = gpio_base; c < gpio_max; c++) {
		sprintf(channel_str, "%d", c);
		write(unexport_fd, channel_str, (strlen(channel_str)+1));
	}
	close(unexport_fd);
	return 0;
}

int set_gpio_direction(int gpio_base, int nchannel, char *direction)
{
	char gpio_dir_file[128];
	int direction_fd=0;
	int gpio_max;
	int c;

	gpio_max = gpio_base + nchannel;
	for(c = gpio_base; c < gpio_max; c++) {
		sprintf(gpio_dir_file, "/sys/class/gpio/gpio%d/direction",c);
		direction_fd=open(gpio_dir_file, O_RDWR);
		if (direction_fd < 0) {
			fprintf(stderr, "Cannot open the direction file for GPIO %d\n", c);
			return -1;
		}
		write(direction_fd, direction, (strlen(direction)+1));
		close(direction_fd);
	}
	return 0;
}

int set_gpio_edge( int gpio_base, int nchannel, char *edge ) /* This function was added by Andrew Powell in order to utilize the GPIO interrupt. */
{
	char gpio_dir_file[128];
	int direction_fd=0;
	int gpio_max;
	int c;

	gpio_max = gpio_base + nchannel;
	for(c = gpio_base; c < gpio_max; c++) {
		sprintf(gpio_dir_file, "/sys/class/gpio/gpio%d/edge",c);
		direction_fd=open(gpio_dir_file, O_RDWR);
		if (direction_fd < 0) {
			fprintf(stderr, "Cannot open the edge file for GPIO %d\n", c);
			return -1;
		}
		write(direction_fd, edge, (strlen(edge)+1));
		close(direction_fd);
	}
	return 0;
}

int set_gpio_value(int gpio_base, int nchannel, int value)
{
	char gpio_val_file[128];
	int val_fd=0;
	int gpio_max;
	char val_str[2];
	int c;

	gpio_max = gpio_base + nchannel;

	for(c = gpio_base; c < gpio_max; c++) {
		sprintf(gpio_val_file, "/sys/class/gpio/gpio%d/value",c);
		val_fd=open(gpio_val_file, O_RDWR);
		if (val_fd < 0) {
			fprintf(stderr, "Cannot open the value file of GPIO %d\n", c);
			return -1;
		}
		sprintf(val_str,"%d", (value & 1));
		write(val_fd, val_str, sizeof(val_str));
		close(val_fd);
		value >>= 1;
	}
	return 0;
}

int get_gpio_value(int gpio_base, int nchannel)
{
	char gpio_val_file[128];
	int val_fd=0;
	int gpio_max;
	char val_str[2];
	char *cptr;
	int value = 0;
	int c;

	gpio_max = gpio_base + nchannel;

	for(c = gpio_max-1; c >= gpio_base; c--) {
		sprintf(gpio_val_file, "/sys/class/gpio/gpio%d/value",c);
		val_fd=open(gpio_val_file, O_RDWR);
		if (val_fd < 0) {
			fprintf(stderr, "Cannot open the value file of GPIO %d\n", c);
			return -1;
		}
		read(val_fd, val_str, sizeof(val_str));
		value <<= 1;
		value += (int)strtoul(val_str, &cptr, 0);
		if (cptr == optarg) {
			fprintf(stderr, "Failed to change %s into integer", val_str);
		}
		close(val_fd);
	}
	return value;
}

int poll_gpio_value( int gpio_base, int nchannel )
{
	char gpio_val_file[128];
	int val_fd=0;
	int gpio_max;
	char val_str[2];
	char *cptr;
	int value = 0;
	int c;

	struct pollfd* fds;
	nfds_t nfds, fds_index;

	/* Allocate space for polling file descriptor structures. */
	nfds = 	nchannel;
	fds = malloc( sizeof( struct pollfd ) * nfds );
	if ( fds == NULL )
	{
		fprintf(stderr, "Memory allocation in poll_gpio_value failed.\n" );
		return -1;
	}

	/* Configure each structure with each file descriptor. */
	gpio_max = gpio_base + nchannel;
	for(c = gpio_base, fds_index = 0; c < gpio_max; c++, fds_index++ ) 
	{
		sprintf(gpio_val_file, "/sys/class/gpio/gpio%d/value",c);
		val_fd=open(gpio_val_file, O_RDWR);
		if (val_fd < 0) 
		{
			free( fds );
			fprintf(stderr, "Cannot open GPIO to export %d\n", c);
			return -1;
		}
		read( val_fd, val_str, sizeof(val_str) ); /* Perform dummy read. */
		fds[ fds_index ].fd = val_fd;
		fds[ fds_index ].events = POLLPRI | POLLERR;
	}

	/* Block indefinitely on poll(2). */
	if ( poll( fds, nfds, -1 ) < 0 )
	{
		free( fds );
		fprintf(stderr, "poll(2) failed.\n" );
		return -1;
	}

	/* Read from each file descriptor. */
	for ( fds_index = 0; fds_index < nfds; fds_index++ )
	{
		nfds_t fds_rindex = nfds-1-fds_index;
		lseek( fds[ fds_rindex ].fd, 0, SEEK_SET );
		read( fds[ fds_rindex ].fd, val_str, sizeof(val_str) );
		value <<= 1;
		value += (int)strtoul(val_str, &cptr, 0);
		if (cptr == optarg) {
			fprintf(stderr, "Failed to change %s into integer", val_str);
		}
		close( fds[ fds_rindex ].fd );
	}

	free( fds );
	return value;
}

void signal_handler(int sig)
{
	switch ( sig ) {
		case SIGTERM:
		case SIGHUP:
		case SIGQUIT:
		case SIGINT:
			close_gpio_channel( GPIO_BASE_OUTS );
			close_gpio_channel( GPIO_BASE_INS );
			exit(0) ;
		default:
			break;
	}
}
