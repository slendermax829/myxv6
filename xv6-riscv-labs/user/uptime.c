# include "kernel/types.h"
# include "kernel/stat.h"
# include "user/user.h"



/* int main(){

    int ticks = uptime();

    if(ticks < 0){
        
        fprintf(2, "uptime: error getting uptime\n");
        exit(1);
    }

    printf("up %d clock ticks\n", ticks);

    exit(0);
} */

void uptime_decimal(int n){
    printf("up %d clock ticks\n", n);
}

void uptime_hex(int n){
    printf("up 0x%x clock ticks\n", n);
}

/**
 * uptime - display the system uptime in ticks
 * @argv: array of arguments from command line
 * @argc: number of arguments from the arguments array
 * 
 * This program retrieves and displays the system uptime in ticks.
 * It supports optional command-line arguments to format the output:
 * - No arguments: displays uptime in decimal format.
 * - -h: displays uptime in hexadecimal format.
 */
int main(int argc, char *argv[]){
    // Retrieve uptime in ticks using the uptime system call from the user.h header file
    int ticks = uptime();

    // Error handling for uptime system call

    if(ticks < 0){
        fprintf(2, "uptime: error getting uptime\n");
        exit(1);
    }
    // Handle command-line arguments for output format
    // Default to decimal if no arguments are provided

    if(argc == 1){
       uptime_decimal(ticks);
    }
    // Check for specific flags and call corresponding functions
    // strcmp is used to compare strings

    if(argc > 1){
        if(strcmp(argv[1], "-h") == 0){
            uptime_hex(ticks);
        }
        else{
            printf("Unknown flag: \"%s\"\n", argv[1]);
            exit(1);
        }
    }
    
    exit(0);
}