#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
/**
 * rm - remove (delete) files
 * @argv: array of arguments from command line
 * @argc: number of arguments from the arguments array
 * 
 * This program removes (deletes) files specified as command line arguments.
 * It takes multiple file names as arguments and attempts to delete each one.
 */
int
main(int argc, char *argv[])
{
  int i;
  // Check for valid number of arguments
  // if less than 2, print usage message (description) and exit
  if(argc < 2){
    fprintf(2, "Usage: rm files...\n");
    exit(1);
  }
  // Iterate over each argument and remove (delete) the file
  // If unlink fails, print an error message and exit
  // calls unlink function from user.h which makes the system call
  for(i = 1; i < argc; i++){
    if(unlink(argv[i]) < 0){
      fprintf(2, "rm: %s failed to delete\n", argv[i]);
      break;
    }
  }

  exit(0);
}
