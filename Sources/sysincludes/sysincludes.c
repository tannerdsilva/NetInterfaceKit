#include "sysincludes.h"

/* make an ioctl call to a network interface and return the result */
int ioctlCall(int sock, int32_t cmd, struct ifreq *req) {
  return ioctl(sock, cmd, req); /* call ioctl with the given socket, command, and request struct */
}

/* get the MAC address of a network interface and format it as a string */
void getHWAddr(struct ifreq *req, macstr_t *outstr) {
  /* format the MAC address as a string and write it to the output string */
  sprintf((*outstr).data, "%02x:%02x:%02x:%02x:%02x:%02x", 
          (unsigned char)req->ifr_hwaddr.sa_data[0],
          (unsigned char)req->ifr_hwaddr.sa_data[1],
          (unsigned char)req->ifr_hwaddr.sa_data[2],
          (unsigned char)req->ifr_hwaddr.sa_data[3],
          (unsigned char)req->ifr_hwaddr.sa_data[4],
          (unsigned char)req->ifr_hwaddr.sa_data[5]);
}

char* macstrToCstr(macstr_t *macstruct) {
	return (*macstruct).data;
}