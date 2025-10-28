#define NPROC        64  // maximum number of processes
#define NCPU          8  // maximum number of CPUs
#define NOFILE       16  // open files per process
#define NFILE       100  // open files per system
#define NINODE       50  // maximum number of active i-nodes
#define NDEV         10  // maximum major device number
#define ROOTDEV       1  // device number of file system root disk
#define MAXARG       32  // max exec arguments
#define MAXOPBLOCKS  10  // max # of blocks any FS op writes
#define LOGSIZE      (MAXOPBLOCKS*3)  // max data blocks in on-disk log
#define NBUF         (MAXOPBLOCKS*3)  // size of disk block cache
#define FSSIZE       1000  // size of file system in blocks
#define MAXPATH      128   // maximum file path name

#define PRIORITY_SCHEDULING 1  // priority scheduling
#define ROUND_ROBIN_SCHEDULING 0 // round robin scheduling

#define SCHEDULE_POLICY PRIORITY_SCHEDULING // scheduling policy 

#define AGING_POLICY 1 // aging policy 1 = enabled 0 = disabled
#define AGING_THRESHOLD 20 // threshold for aging in ticks

enum procstate { UNUSED, USED, SLEEPING, RUNNABLE, RUNNING, ZOMBIE };