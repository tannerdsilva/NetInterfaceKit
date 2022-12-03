#include <sys/socket.h>
#include <sys/ioctl.h>
#include <net/if.h>
#include <netinet/in.h>
#include <unistd.h>
#include <string.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>

/* define a typedef for a static-length string of MAC address characters */
typedef struct macstring {
  char data[18]; /* array of 18 characters to hold the MAC address string */
} macstr_t; /* the new type is called "macstr_t" */

/* function prototype for a function that makes an ioctl call to a network interface */
int ioctlCall(int, int32_t, struct ifreq*);

/* function prototype for a function that gets the MAC address of a network interface */
void getHWAddr(struct ifreq *req, macstr_t*);

/* function prototype for a function that returns a char* pointer to the data contained within a given macstr_t */
char* macstrToCstr(macstr_t *);