#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
/**
 * echo: A program that prints its command-line arguments to standard output.
 * @argc: number of command-line arguments
 * @argv: array of command-line arguments
 * This program iterates over each command-line argument and prints them
 * to standard output, separated by spaces. A newline is printed at the end.
 */
int
main(int argc, char *argv[])
{
  int i;

  for(i = 1; i < argc; i++){
    write(1, argv[i], strlen(argv[i]));
    if(i + 1 < argc){
      write(1, " ", 1);
    } else {
      write(1, "\n", 1);
    }
  }
  exit(0);
}
