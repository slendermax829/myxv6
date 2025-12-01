# include "types.h"
# include "riscv.h"
# include "param.h"
# include "defs.h"
# include "spinlock.h"

struct semtab semtable;

/**
 * Initialize the semaphore table
 * This function initializes the semaphore table by setting up the lock for the semaphore table
 */
void seminit(void) 
{
    initlock(&semtable.lock, "semtable");
    for(int i = 0; i < NSEM; i++)
    {
        initlock(&semtable.sem[i].lock, "sem");
    }   
}

/**
 * Allocate a semaphore from the semaphore table
 * This function searches for a free semaphore in the semaphore table and returns its index.
 * If no free semaphore is found, it returns -1.
 * A semaphore is considered free if its 'valid' field is 0.
 * A semaphore is allocated by setting its 'valid' field to 1.
 */
int semalloc(void) 
{
    int index = -1;

    acquire(&semtable.lock);

    for(int i = 0; i < NSEM; i++)
    {
        if(semtable.sem[i].valid == 0){ // found a free semaphore
            index = i;
            break;
        }
    }
    release(&semtable.lock);

    return index;
}
/**
 * Deallocate a semaphore from the semaphore table
 * This function deallocates a semaphore by setting its 'valid' field to 0.
 * It takes the index of the semaphore to be deallocated as an argument.
 * If the index is invalid, it returns -1.
 */
int semdealloc(int index)
{
    if(index < 0 || index >= NSEM)
    {
        return -1; // invalid index
    }

    acquire(&semtable.lock);

    if(index >= 0 && index < NSEM) // valid index
    {
        if(semtable.sem[index].valid == 1) // semaphore is allocated
        {
            semtable.sem[index].valid = 0;
        }
    }

    release(&semtable.lock);

    return 0; 
}