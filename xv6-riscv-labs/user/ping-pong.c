#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[])
{
    int p[2];
    pipe(p);
    if (fork() == 0)
    {
        close(1);
        dup(p[1]);
        close(p[0]);
        close(p[1]);
        exec("ping", argv);
        fprintf(2, "exec ping failed\n");
    }
    else
    {
        close(0);
        dup(p[0]);
        close(p[0]);
        close(p[1]);
        exec("pong", argv);
        fprintf(2, "exec pong failed\n");
    }
    exit(0);
}