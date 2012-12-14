#include "syscall.h"
#include "stdio.h"
#include "stdlib.h"

#define BUFSIZE 1024

int main(int argc, char** argv)
{
  char c[100];
  int i;
  readline(c, 100);
  printf(c);
  return 0;
}
