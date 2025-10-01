# include "kernel/types.h"
# include "kernel/stat.h"
# include "user/user.h"

int main(int argc, char *argv[]){

    
    if(argc == 1){
        printf("Usage: time1 [args]\n");
        exit(1);
    }

    int startTime = uptime();

    int childPID = fork();

    if(childPID < 0){
        fprintf(2, "time1: fork failed\n");
        exit(1);
    }

    if(childPID == 0){

        exec(argv[1], &argv[1]);

        fprintf(2, "time1: exec %s failed\n", argv[1]);
        exit(1);
       

    } else {
        
       wait(0);

       int parentTime = uptime();
       
       printf("Time elapsed: %d ticks\n", parentTime - startTime);

    }

    exit(0); // success

}