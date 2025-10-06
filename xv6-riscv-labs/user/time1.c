# include "kernel/types.h"
# include "kernel/stat.h"
# include "user/user.h"

/** time1: measure the time a command(program) takes to run 
 * @argc: number of command-line arguments
 * @argv: array of command-line arguments
*/

int main(int argc, char *argv[]){

    // Check if at least one argument is provided
    if(argc == 1){
        printf("Usage: time1 [args]\n");
        exit(1);
    }
    // Get the intial start time in ticks
    int startTime = uptime();
    // Create a child process
    int childPID = fork();

    // Error handling for fork failure
    if(childPID < 0){
        fprintf(2, "time1: fork failed\n");
        exit(1);
    }

    // Child process; execute the command
    else
    if(childPID == 0){
        // Execute the command that was passed as an argument
        exec(argv[1], &argv[1]);

        // If exec fails, print an error message and exit
        fprintf(2, "time1: exec %s failed\n", argv[1]);
        exit(1);
       

    } else {
       // Parent process; wait for the child to finish
       // Using wait to wait for the child process to finish
       wait(0);
       
       // Get the parent process end time in ticks
       int parentTime = uptime();

       // Print the time elapsed by calculating the difference
       printf("Time elapsed: %d ticks\n", parentTime - startTime);

    }

    exit(0); // success

}