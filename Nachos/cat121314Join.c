#include "syscall.h"
#include "stdio.h"
#include "stdlib.h"

#define BUFSIZE 1024

char buf[BUFSIZE];

int main(int argc, char** argv)
{
  int fd, amount, p1, p2, s;

  if (argc!=2) {
    printf("Usage: cat <file>\n");
    return 1;
  }

  fd = open(argv[1]);
  if (fd==-1) {
    printf("Unable to open %s\n", argv[1]);
    return 1;
  }
  argv[1] = "13.txt";
  p1 = exec("cat.coff", 2, argv);
  argv[1] = "14.txt";
  p2 = exec("cat.coff", 2, argv); 
  join(p1, &s);
  join(p2, &s);
  while ((amount = read(fd, buf, BUFSIZE))>0) {
    write(1, buf, amount);
  }
  
  close(fd);

  return 0;
}
