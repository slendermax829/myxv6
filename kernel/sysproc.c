#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
  int n;
  if(argint(0, &n) < 0)
    return -1;
  exit(n);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return fork();
}

uint64
sys_wait(void)
{
  uint64 p;
  if(argaddr(0, &p) < 0)
    return -1;
  return wait(p);
}

uint64
sys_sbrk(void)
{
  int addr;
  int n;
  struct proc *p = myproc();

  if(argint(0, &n) < 0)
    return -1;

  addr = p->sz;
  if (n == 0)
    return addr;

  uint64 new_sz = addr + n;
  if(new_sz < p->sz){
    return (uint64)-1;
  }
  p->sz = new_sz;
  /*old eager allocatoin, we don't call growproc right away for lazy allocatoin*/
  /*if(growproc(n) < 0)
    return -1;*/
  return addr;
}

uint64
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

uint64
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

uint64
sys_freepmem(void)
{
  uint64 pages = kfreepages_count();
  return pages * PGSIZE;
}
/**
 * initialize a semaphore
 */
uint64
sys_sem_init(void)
{
  uint64 sem_addr;  // user address of semaphore
  int pshared;      // ignored (not used in xv6)
  uint value;       // initial value
  
  // Get arguments
  if(argaddr(0, &sem_addr) < 0 || argint(1, &pshared) < 0 || argint(2, (int*)&value) < 0)
    return -1;
    
  // Allocate semaphore from kernel table
  int sem_id = semalloc();
  if(sem_id < 0)
    return -1;  // No free semaphores
    
  // Initialize the semaphore
  acquire(&semtable.sem[sem_id].lock);
  semtable.sem[sem_id].count = value;
  semtable.sem[sem_id].valid = 1;
  release(&semtable.sem[sem_id].lock);
  
  // Copy semaphore ID back to user space
  if(copyout(myproc()->pagetable, sem_addr, (char*)&sem_id, sizeof(sem_id)) < 0) {
    semdealloc(sem_id);
    return -1;
  }
  
  return 0;
}
/**
 * destroy a semaphore
 */
uint64
sys_sem_destroy(void)
{
  uint64 sem_addr;
  sem_t sem_id;
  
  // Get semaphore address from user
  if(argaddr(0, &sem_addr) < 0)
    return -1;
    
  // Copy semaphore ID from user space
  if(copyin(myproc()->pagetable, (char*)&sem_id, sem_addr, sizeof(sem_id)) < 0)
    return -1;
    
  // Validate semaphore ID
  if(sem_id < 0 || sem_id >= NSEM)
    return -1;
    
  // Check if semaphore is valid and deallocate
  acquire(&semtable.sem[sem_id].lock);
  if(semtable.sem[sem_id].valid == 0) {
    release(&semtable.sem[sem_id].lock);
    return -1;
  }
  release(&semtable.sem[sem_id].lock);
  
  // Deallocate semaphore
  semdealloc(sem_id);
  
  return 0;
}
/**
 * wait (P) operation on a semaphore
 */
uint64
sys_sem_wait(void)
{
  uint64 sem_addr;
  sem_t sem_id;
  
  // Get semaphore address from user
  if(argaddr(0, &sem_addr) < 0)
    return -1;
    
  // Copy semaphore ID from user space
  if(copyin(myproc()->pagetable, (char*)&sem_id, sem_addr, sizeof(sem_id)) < 0)
    return -1;
    
  // Validate semaphore ID
  if(sem_id < 0 || sem_id >= NSEM)
    return -1;
    
  // Wait on semaphore
  acquire(&semtable.sem[sem_id].lock);
  
  // Check if semaphore is still valid
  if(semtable.sem[sem_id].valid == 0) {
    release(&semtable.sem[sem_id].lock);
    return -1;
  }
  
  // Wait while count is 0
  while(semtable.sem[sem_id].count == 0) {
    sleep(&semtable.sem[sem_id], &semtable.sem[sem_id].lock);
    // Check if semaphore is still valid after waking up
    if(semtable.sem[sem_id].valid == 0) {
      release(&semtable.sem[sem_id].lock);
      return -1;
    }
  }
  
  // Decrement count
  semtable.sem[sem_id].count--;
  release(&semtable.sem[sem_id].lock);
  
  return 0;
}

/**
 * post (V) operation on a semaphore
 */
uint64
sys_sem_post(void)
{
  uint64 sem_addr;
  sem_t sem_id;
  
  // Get semaphore address from user
  if(argaddr(0, &sem_addr) < 0)
    return -1;
    
  // Copy semaphore ID from user space
  if(copyin(myproc()->pagetable, (char*)&sem_id, sem_addr, sizeof(sem_id)) < 0)
    return -1;
    
  // Validate semaphore ID
  if(sem_id < 0 || sem_id >= NSEM)
    return -1;
    
  // Post to semaphore
  acquire(&semtable.sem[sem_id].lock);
  
  // Check if semaphore is still valid
  if(semtable.sem[sem_id].valid == 0) {
    release(&semtable.sem[sem_id].lock);
    return -1;
  }
  
  // Increment count
  semtable.sem[sem_id].count++;
  
  // Wake up any waiting processes
  wakeup(&semtable.sem[sem_id]);
  
  release(&semtable.sem[sem_id].lock);
  
  return 0;
}