// Create a zombie process that
// must be reparented at exit.

#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
/**
 * This program creates a zombie process that must be reparented at exit.
 * When the child process exits, it becomes a zombie until the parent process
 * calls wait() to read its exit status. If the parent sleeps for a while
 * before exiting, the child process will be reparented to init (PID 1),
 */
int
main(void)
{
  if(fork() > 0)
    sleep(5);  // Let child exit before parent.
  exit(0);
}
