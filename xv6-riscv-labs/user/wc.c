#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

char buf[512];

void
wc(int fd, char *name)
{
  // Declare iterator and number of bytes read
  int i, n;
  // Declare line, word, character, and inword counters
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  // Read from file descriptor into buffer
  // For each byte read, increment character count
  // If byte is newline, increment line count
  // If byte is whitespace and not in a word, set inword to 0
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
        inword = 0;
      else if(!inword){
        w++;
        inword = 1;
      }
    }
  }
  if(n < 0){
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
}
/**
 * wc - word count
 * @argv: array of arguments from command line
 * @argc: number of arguments from the arguments array
 * 
 * This program counts the number of lines, words, and characters in files.
 * If no files are specified, it reads from standard input.
 */
int
main(int argc, char *argv[])
{
  // Declare file descriptor and iterator
  int fd, i;

  if(argc <= 1){
    wc(0, "");
    exit(0);
  }
  // Iterate over each file provided as command line argument
  // Open the file, if it fails print an error message and exit
  // Call wc function to count lines, words, and characters
  // Close the file after processing
  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    // Call wc function to count lines, words, and characters
    wc(fd, argv[i]);
    close(fd);
  }
  exit(0);
}
