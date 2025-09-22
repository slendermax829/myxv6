#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
/**
 * mkdir - create a new directory
 * @argv: array of arguments from command line
 * @argc: number of arguments from the arguments array
 */
int
main(int argc, char *argv[])
{
  int i;
  // Check for valid number of arguments
  // if less than 2, print usage message (description) and exit
  if(argc < 2){
    fprintf(2, "Usage: mkdir files...\n");
    exit(1);
  }
  // Iterate over each argument and create a directory except "mkdir"
  // If mkdir fails, print an error message and exit
  // calls mkdir function from user.h which makes the system call
  
  for(i = 1; i < argc; i++){
    if(mkdir(argv[i]) < 0){
      fprintf(2, "mkdir: %s failed to create\n", argv[i]);
      break;
    }
  }
  // Exit with success code
  exit(0);
}
