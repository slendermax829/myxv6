#include "types.h"
/**
 * rusage: Struct to hold process resource usage information (might update later)
 * @cputime: Total CPU time used by the process in ticks
 */
struct rusage{

    uint64 cputime;
};