# include "kernel/types.h"
# include "kernel/stat.h"
# include "user/user.h"
# include "kernel/pstat.h" // Include the definition for struct rusage
/**
 * time2: A program that measures the time taken by a command to execute,
 *       the CPU time used by the command, and the percentage of CPU usage.
 *      @argc: number of command-line arguments
 *     @argv: array of command-line arguments
 */
int main(int argc, char *argv[]){

    if(argc == 1){ // Check if at least one argument is provided
        printf("Usage: time2 [args]\n");
        exit(1);
    }

    int startTime = uptime(); // Get the start time in ticks
    int childPID = fork(); // Create a child process

    if(childPID < 0){ // Error handling for fork failure
        fprintf(2, "time2: fork failed\n"); 
        exit(1);
    }
    else if(childPID == 0){ // Child process; execute the command
        exec(argv[1], &argv[1]);

        fprintf(2, "time1: exec %s failed\n", argv[1]);
        exit(1);
    } 
    else { // Parent process; wait for the child to finish
        
       struct rusage rusage; // Struct to hold resource usage info

       wait2(0, &rusage); // Using wait2 to wait for the child process to finish and get rusage info

       int parentTime = uptime(); // Get the end time in ticks
       int cputime = rusage.cputime; // Get CPU time from rusage struct
       int percentCPU = (cputime * 100) / (parentTime - startTime); // Calculate CPU usage percentage
       
       printf("Time elapsed: %d ticks\n", parentTime - startTime);
       printf("CPU time: %d ticks\n", cputime);
       printf("%d%% CPU\n", percentCPU);
    }

    exit(0); 
}