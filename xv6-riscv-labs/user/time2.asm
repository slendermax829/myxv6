
user/_time2:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
 * time2: A program that measures the time taken by a command to execute,
 *       the CPU time used by the command, and the percentage of CPU usage.
 *      @argc: number of command-line arguments
 *     @argv: array of command-line arguments
 */
int main(int argc, char *argv[]){
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	0080                	addi	s0,sp,64

    if(argc == 1){ // Check if at least one argument is provided
   8:	4785                	li	a5,1
   a:	04f50863          	beq	a0,a5,5a <main+0x5a>
   e:	f426                	sd	s1,40(sp)
  10:	ec4e                	sd	s3,24(sp)
  12:	84ae                	mv	s1,a1
        printf("Usage: time2 [args]\n");
        exit(1);
    }

    int startTime = uptime(); // Get the start time in ticks
  14:	00000097          	auipc	ra,0x0
  18:	414080e7          	jalr	1044(ra) # 428 <uptime>
  1c:	89aa                	mv	s3,a0
    int childPID = fork(); // Create a child process
  1e:	00000097          	auipc	ra,0x0
  22:	36a080e7          	jalr	874(ra) # 388 <fork>

    if(childPID < 0){ // Error handling for fork failure
  26:	04054a63          	bltz	a0,7a <main+0x7a>
        fprintf(2, "time2: fork failed\n"); 
        exit(1);
    }
    else if(childPID == 0){ // Child process; execute the command
  2a:	e53d                	bnez	a0,98 <main+0x98>
  2c:	f04a                	sd	s2,32(sp)
        exec(argv[1], &argv[1]);
  2e:	00848593          	addi	a1,s1,8
  32:	6488                	ld	a0,8(s1)
  34:	00000097          	auipc	ra,0x0
  38:	394080e7          	jalr	916(ra) # 3c8 <exec>

        fprintf(2, "time1: exec %s failed\n", argv[1]);
  3c:	6490                	ld	a2,8(s1)
  3e:	00001597          	auipc	a1,0x1
  42:	8ba58593          	addi	a1,a1,-1862 # 8f8 <malloc+0x136>
  46:	4509                	li	a0,2
  48:	00000097          	auipc	ra,0x0
  4c:	690080e7          	jalr	1680(ra) # 6d8 <fprintf>
        exit(1);
  50:	4505                	li	a0,1
  52:	00000097          	auipc	ra,0x0
  56:	33e080e7          	jalr	830(ra) # 390 <exit>
  5a:	f426                	sd	s1,40(sp)
  5c:	f04a                	sd	s2,32(sp)
  5e:	ec4e                	sd	s3,24(sp)
        printf("Usage: time2 [args]\n");
  60:	00001517          	auipc	a0,0x1
  64:	86050513          	addi	a0,a0,-1952 # 8c0 <malloc+0xfe>
  68:	00000097          	auipc	ra,0x0
  6c:	69e080e7          	jalr	1694(ra) # 706 <printf>
        exit(1);
  70:	4505                	li	a0,1
  72:	00000097          	auipc	ra,0x0
  76:	31e080e7          	jalr	798(ra) # 390 <exit>
  7a:	f04a                	sd	s2,32(sp)
        fprintf(2, "time2: fork failed\n"); 
  7c:	00001597          	auipc	a1,0x1
  80:	86458593          	addi	a1,a1,-1948 # 8e0 <malloc+0x11e>
  84:	4509                	li	a0,2
  86:	00000097          	auipc	ra,0x0
  8a:	652080e7          	jalr	1618(ra) # 6d8 <fprintf>
        exit(1);
  8e:	4505                	li	a0,1
  90:	00000097          	auipc	ra,0x0
  94:	300080e7          	jalr	768(ra) # 390 <exit>
  98:	f04a                	sd	s2,32(sp)
    } 
    else { // Parent process; wait for the child to finish
        
       struct rusage rusage; // Struct to hold resource usage info

       wait2(0, &rusage); // Using wait2 to wait for the child process to finish and get rusage info
  9a:	fc840593          	addi	a1,s0,-56
  9e:	4501                	li	a0,0
  a0:	00000097          	auipc	ra,0x0
  a4:	398080e7          	jalr	920(ra) # 438 <wait2>

       int parentTime = uptime(); // Get the end time in ticks
  a8:	00000097          	auipc	ra,0x0
  ac:	380080e7          	jalr	896(ra) # 428 <uptime>
       int cputime = rusage.cputime; // Get CPU time from rusage struct
  b0:	fc842903          	lw	s2,-56(s0)
       int percentCPU = (cputime * 100) / (parentTime - startTime); // Calculate CPU usage percentage
  b4:	413505bb          	subw	a1,a0,s3
  b8:	06400493          	li	s1,100
  bc:	029904bb          	mulw	s1,s2,s1
  c0:	02b4c4bb          	divw	s1,s1,a1
       
       printf("Time elapsed: %d ticks\n", parentTime - startTime);
  c4:	00001517          	auipc	a0,0x1
  c8:	84c50513          	addi	a0,a0,-1972 # 910 <malloc+0x14e>
  cc:	00000097          	auipc	ra,0x0
  d0:	63a080e7          	jalr	1594(ra) # 706 <printf>
       printf("CPU time: %d ticks\n", cputime);
  d4:	85ca                	mv	a1,s2
  d6:	00001517          	auipc	a0,0x1
  da:	85250513          	addi	a0,a0,-1966 # 928 <malloc+0x166>
  de:	00000097          	auipc	ra,0x0
  e2:	628080e7          	jalr	1576(ra) # 706 <printf>
       printf("%d%% CPU\n", percentCPU);
  e6:	85a6                	mv	a1,s1
  e8:	00001517          	auipc	a0,0x1
  ec:	85850513          	addi	a0,a0,-1960 # 940 <malloc+0x17e>
  f0:	00000097          	auipc	ra,0x0
  f4:	616080e7          	jalr	1558(ra) # 706 <printf>
    }

    exit(0); 
  f8:	4501                	li	a0,0
  fa:	00000097          	auipc	ra,0x0
  fe:	296080e7          	jalr	662(ra) # 390 <exit>

0000000000000102 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 102:	1141                	addi	sp,sp,-16
 104:	e406                	sd	ra,8(sp)
 106:	e022                	sd	s0,0(sp)
 108:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 10a:	87aa                	mv	a5,a0
 10c:	0585                	addi	a1,a1,1
 10e:	0785                	addi	a5,a5,1
 110:	fff5c703          	lbu	a4,-1(a1)
 114:	fee78fa3          	sb	a4,-1(a5)
 118:	fb75                	bnez	a4,10c <strcpy+0xa>
    ;
  return os;
}
 11a:	60a2                	ld	ra,8(sp)
 11c:	6402                	ld	s0,0(sp)
 11e:	0141                	addi	sp,sp,16
 120:	8082                	ret

0000000000000122 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 122:	1141                	addi	sp,sp,-16
 124:	e406                	sd	ra,8(sp)
 126:	e022                	sd	s0,0(sp)
 128:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 12a:	00054783          	lbu	a5,0(a0)
 12e:	cb91                	beqz	a5,142 <strcmp+0x20>
 130:	0005c703          	lbu	a4,0(a1)
 134:	00f71763          	bne	a4,a5,142 <strcmp+0x20>
    p++, q++;
 138:	0505                	addi	a0,a0,1
 13a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 13c:	00054783          	lbu	a5,0(a0)
 140:	fbe5                	bnez	a5,130 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 142:	0005c503          	lbu	a0,0(a1)
}
 146:	40a7853b          	subw	a0,a5,a0
 14a:	60a2                	ld	ra,8(sp)
 14c:	6402                	ld	s0,0(sp)
 14e:	0141                	addi	sp,sp,16
 150:	8082                	ret

0000000000000152 <strlen>:

uint
strlen(const char *s)
{
 152:	1141                	addi	sp,sp,-16
 154:	e406                	sd	ra,8(sp)
 156:	e022                	sd	s0,0(sp)
 158:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 15a:	00054783          	lbu	a5,0(a0)
 15e:	cf91                	beqz	a5,17a <strlen+0x28>
 160:	00150793          	addi	a5,a0,1
 164:	86be                	mv	a3,a5
 166:	0785                	addi	a5,a5,1
 168:	fff7c703          	lbu	a4,-1(a5)
 16c:	ff65                	bnez	a4,164 <strlen+0x12>
 16e:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 172:	60a2                	ld	ra,8(sp)
 174:	6402                	ld	s0,0(sp)
 176:	0141                	addi	sp,sp,16
 178:	8082                	ret
  for(n = 0; s[n]; n++)
 17a:	4501                	li	a0,0
 17c:	bfdd                	j	172 <strlen+0x20>

000000000000017e <memset>:

void*
memset(void *dst, int c, uint n)
{
 17e:	1141                	addi	sp,sp,-16
 180:	e406                	sd	ra,8(sp)
 182:	e022                	sd	s0,0(sp)
 184:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 186:	ca19                	beqz	a2,19c <memset+0x1e>
 188:	87aa                	mv	a5,a0
 18a:	1602                	slli	a2,a2,0x20
 18c:	9201                	srli	a2,a2,0x20
 18e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 192:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 196:	0785                	addi	a5,a5,1
 198:	fee79de3          	bne	a5,a4,192 <memset+0x14>
  }
  return dst;
}
 19c:	60a2                	ld	ra,8(sp)
 19e:	6402                	ld	s0,0(sp)
 1a0:	0141                	addi	sp,sp,16
 1a2:	8082                	ret

00000000000001a4 <strchr>:

char*
strchr(const char *s, char c)
{
 1a4:	1141                	addi	sp,sp,-16
 1a6:	e406                	sd	ra,8(sp)
 1a8:	e022                	sd	s0,0(sp)
 1aa:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1ac:	00054783          	lbu	a5,0(a0)
 1b0:	cf81                	beqz	a5,1c8 <strchr+0x24>
    if(*s == c)
 1b2:	00f58763          	beq	a1,a5,1c0 <strchr+0x1c>
  for(; *s; s++)
 1b6:	0505                	addi	a0,a0,1
 1b8:	00054783          	lbu	a5,0(a0)
 1bc:	fbfd                	bnez	a5,1b2 <strchr+0xe>
      return (char*)s;
  return 0;
 1be:	4501                	li	a0,0
}
 1c0:	60a2                	ld	ra,8(sp)
 1c2:	6402                	ld	s0,0(sp)
 1c4:	0141                	addi	sp,sp,16
 1c6:	8082                	ret
  return 0;
 1c8:	4501                	li	a0,0
 1ca:	bfdd                	j	1c0 <strchr+0x1c>

00000000000001cc <gets>:

char*
gets(char *buf, int max)
{
 1cc:	711d                	addi	sp,sp,-96
 1ce:	ec86                	sd	ra,88(sp)
 1d0:	e8a2                	sd	s0,80(sp)
 1d2:	e4a6                	sd	s1,72(sp)
 1d4:	e0ca                	sd	s2,64(sp)
 1d6:	fc4e                	sd	s3,56(sp)
 1d8:	f852                	sd	s4,48(sp)
 1da:	f456                	sd	s5,40(sp)
 1dc:	f05a                	sd	s6,32(sp)
 1de:	ec5e                	sd	s7,24(sp)
 1e0:	e862                	sd	s8,16(sp)
 1e2:	1080                	addi	s0,sp,96
 1e4:	8baa                	mv	s7,a0
 1e6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e8:	892a                	mv	s2,a0
 1ea:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1ec:	faf40b13          	addi	s6,s0,-81
 1f0:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 1f2:	8c26                	mv	s8,s1
 1f4:	0014899b          	addiw	s3,s1,1
 1f8:	84ce                	mv	s1,s3
 1fa:	0349d663          	bge	s3,s4,226 <gets+0x5a>
    cc = read(0, &c, 1);
 1fe:	8656                	mv	a2,s5
 200:	85da                	mv	a1,s6
 202:	4501                	li	a0,0
 204:	00000097          	auipc	ra,0x0
 208:	1a4080e7          	jalr	420(ra) # 3a8 <read>
    if(cc < 1)
 20c:	00a05d63          	blez	a0,226 <gets+0x5a>
      break;
    buf[i++] = c;
 210:	faf44783          	lbu	a5,-81(s0)
 214:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 218:	0905                	addi	s2,s2,1
 21a:	ff678713          	addi	a4,a5,-10
 21e:	c319                	beqz	a4,224 <gets+0x58>
 220:	17cd                	addi	a5,a5,-13
 222:	fbe1                	bnez	a5,1f2 <gets+0x26>
    buf[i++] = c;
 224:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 226:	9c5e                	add	s8,s8,s7
 228:	000c0023          	sb	zero,0(s8)
  return buf;
}
 22c:	855e                	mv	a0,s7
 22e:	60e6                	ld	ra,88(sp)
 230:	6446                	ld	s0,80(sp)
 232:	64a6                	ld	s1,72(sp)
 234:	6906                	ld	s2,64(sp)
 236:	79e2                	ld	s3,56(sp)
 238:	7a42                	ld	s4,48(sp)
 23a:	7aa2                	ld	s5,40(sp)
 23c:	7b02                	ld	s6,32(sp)
 23e:	6be2                	ld	s7,24(sp)
 240:	6c42                	ld	s8,16(sp)
 242:	6125                	addi	sp,sp,96
 244:	8082                	ret

0000000000000246 <stat>:

int
stat(const char *n, struct stat *st)
{
 246:	1101                	addi	sp,sp,-32
 248:	ec06                	sd	ra,24(sp)
 24a:	e822                	sd	s0,16(sp)
 24c:	e04a                	sd	s2,0(sp)
 24e:	1000                	addi	s0,sp,32
 250:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 252:	4581                	li	a1,0
 254:	00000097          	auipc	ra,0x0
 258:	17c080e7          	jalr	380(ra) # 3d0 <open>
  if(fd < 0)
 25c:	02054663          	bltz	a0,288 <stat+0x42>
 260:	e426                	sd	s1,8(sp)
 262:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 264:	85ca                	mv	a1,s2
 266:	00000097          	auipc	ra,0x0
 26a:	182080e7          	jalr	386(ra) # 3e8 <fstat>
 26e:	892a                	mv	s2,a0
  close(fd);
 270:	8526                	mv	a0,s1
 272:	00000097          	auipc	ra,0x0
 276:	146080e7          	jalr	326(ra) # 3b8 <close>
  return r;
 27a:	64a2                	ld	s1,8(sp)
}
 27c:	854a                	mv	a0,s2
 27e:	60e2                	ld	ra,24(sp)
 280:	6442                	ld	s0,16(sp)
 282:	6902                	ld	s2,0(sp)
 284:	6105                	addi	sp,sp,32
 286:	8082                	ret
    return -1;
 288:	57fd                	li	a5,-1
 28a:	893e                	mv	s2,a5
 28c:	bfc5                	j	27c <stat+0x36>

000000000000028e <atoi>:

int
atoi(const char *s)
{
 28e:	1141                	addi	sp,sp,-16
 290:	e406                	sd	ra,8(sp)
 292:	e022                	sd	s0,0(sp)
 294:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 296:	00054683          	lbu	a3,0(a0)
 29a:	fd06879b          	addiw	a5,a3,-48
 29e:	0ff7f793          	zext.b	a5,a5
 2a2:	4625                	li	a2,9
 2a4:	02f66963          	bltu	a2,a5,2d6 <atoi+0x48>
 2a8:	872a                	mv	a4,a0
  n = 0;
 2aa:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2ac:	0705                	addi	a4,a4,1
 2ae:	0025179b          	slliw	a5,a0,0x2
 2b2:	9fa9                	addw	a5,a5,a0
 2b4:	0017979b          	slliw	a5,a5,0x1
 2b8:	9fb5                	addw	a5,a5,a3
 2ba:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2be:	00074683          	lbu	a3,0(a4)
 2c2:	fd06879b          	addiw	a5,a3,-48
 2c6:	0ff7f793          	zext.b	a5,a5
 2ca:	fef671e3          	bgeu	a2,a5,2ac <atoi+0x1e>
  return n;
}
 2ce:	60a2                	ld	ra,8(sp)
 2d0:	6402                	ld	s0,0(sp)
 2d2:	0141                	addi	sp,sp,16
 2d4:	8082                	ret
  n = 0;
 2d6:	4501                	li	a0,0
 2d8:	bfdd                	j	2ce <atoi+0x40>

00000000000002da <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2da:	1141                	addi	sp,sp,-16
 2dc:	e406                	sd	ra,8(sp)
 2de:	e022                	sd	s0,0(sp)
 2e0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2e2:	02b57563          	bgeu	a0,a1,30c <memmove+0x32>
    while(n-- > 0)
 2e6:	00c05f63          	blez	a2,304 <memmove+0x2a>
 2ea:	1602                	slli	a2,a2,0x20
 2ec:	9201                	srli	a2,a2,0x20
 2ee:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2f2:	872a                	mv	a4,a0
      *dst++ = *src++;
 2f4:	0585                	addi	a1,a1,1
 2f6:	0705                	addi	a4,a4,1
 2f8:	fff5c683          	lbu	a3,-1(a1)
 2fc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 300:	fee79ae3          	bne	a5,a4,2f4 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 304:	60a2                	ld	ra,8(sp)
 306:	6402                	ld	s0,0(sp)
 308:	0141                	addi	sp,sp,16
 30a:	8082                	ret
    while(n-- > 0)
 30c:	fec05ce3          	blez	a2,304 <memmove+0x2a>
    dst += n;
 310:	00c50733          	add	a4,a0,a2
    src += n;
 314:	95b2                	add	a1,a1,a2
 316:	fff6079b          	addiw	a5,a2,-1
 31a:	1782                	slli	a5,a5,0x20
 31c:	9381                	srli	a5,a5,0x20
 31e:	fff7c793          	not	a5,a5
 322:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 324:	15fd                	addi	a1,a1,-1
 326:	177d                	addi	a4,a4,-1
 328:	0005c683          	lbu	a3,0(a1)
 32c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 330:	fef71ae3          	bne	a4,a5,324 <memmove+0x4a>
 334:	bfc1                	j	304 <memmove+0x2a>

0000000000000336 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 336:	1141                	addi	sp,sp,-16
 338:	e406                	sd	ra,8(sp)
 33a:	e022                	sd	s0,0(sp)
 33c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 33e:	c61d                	beqz	a2,36c <memcmp+0x36>
 340:	1602                	slli	a2,a2,0x20
 342:	9201                	srli	a2,a2,0x20
 344:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 348:	00054783          	lbu	a5,0(a0)
 34c:	0005c703          	lbu	a4,0(a1)
 350:	00e79863          	bne	a5,a4,360 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 354:	0505                	addi	a0,a0,1
    p2++;
 356:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 358:	fed518e3          	bne	a0,a3,348 <memcmp+0x12>
  }
  return 0;
 35c:	4501                	li	a0,0
 35e:	a019                	j	364 <memcmp+0x2e>
      return *p1 - *p2;
 360:	40e7853b          	subw	a0,a5,a4
}
 364:	60a2                	ld	ra,8(sp)
 366:	6402                	ld	s0,0(sp)
 368:	0141                	addi	sp,sp,16
 36a:	8082                	ret
  return 0;
 36c:	4501                	li	a0,0
 36e:	bfdd                	j	364 <memcmp+0x2e>

0000000000000370 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 370:	1141                	addi	sp,sp,-16
 372:	e406                	sd	ra,8(sp)
 374:	e022                	sd	s0,0(sp)
 376:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 378:	00000097          	auipc	ra,0x0
 37c:	f62080e7          	jalr	-158(ra) # 2da <memmove>
}
 380:	60a2                	ld	ra,8(sp)
 382:	6402                	ld	s0,0(sp)
 384:	0141                	addi	sp,sp,16
 386:	8082                	ret

0000000000000388 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 388:	4885                	li	a7,1
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <exit>:
.global exit
exit:
 li a7, SYS_exit
 390:	4889                	li	a7,2
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <wait>:
.global wait
wait:
 li a7, SYS_wait
 398:	488d                	li	a7,3
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3a0:	4891                	li	a7,4
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <read>:
.global read
read:
 li a7, SYS_read
 3a8:	4895                	li	a7,5
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <write>:
.global write
write:
 li a7, SYS_write
 3b0:	48c1                	li	a7,16
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <close>:
.global close
close:
 li a7, SYS_close
 3b8:	48d5                	li	a7,21
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3c0:	4899                	li	a7,6
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3c8:	489d                	li	a7,7
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <open>:
.global open
open:
 li a7, SYS_open
 3d0:	48bd                	li	a7,15
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3d8:	48c5                	li	a7,17
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3e0:	48c9                	li	a7,18
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3e8:	48a1                	li	a7,8
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <link>:
.global link
link:
 li a7, SYS_link
 3f0:	48cd                	li	a7,19
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3f8:	48d1                	li	a7,20
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 400:	48a5                	li	a7,9
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <dup>:
.global dup
dup:
 li a7, SYS_dup
 408:	48a9                	li	a7,10
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 410:	48ad                	li	a7,11
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 418:	48b1                	li	a7,12
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 420:	48b5                	li	a7,13
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 428:	48b9                	li	a7,14
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <cputime>:
.global cputime
cputime:
 li a7, SYS_cputime
 430:	48d9                	li	a7,22
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <wait2>:
.global wait2
wait2:
 li a7, SYS_wait2
 438:	48dd                	li	a7,23
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 440:	1101                	addi	sp,sp,-32
 442:	ec06                	sd	ra,24(sp)
 444:	e822                	sd	s0,16(sp)
 446:	1000                	addi	s0,sp,32
 448:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 44c:	4605                	li	a2,1
 44e:	fef40593          	addi	a1,s0,-17
 452:	00000097          	auipc	ra,0x0
 456:	f5e080e7          	jalr	-162(ra) # 3b0 <write>
}
 45a:	60e2                	ld	ra,24(sp)
 45c:	6442                	ld	s0,16(sp)
 45e:	6105                	addi	sp,sp,32
 460:	8082                	ret

0000000000000462 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 462:	7139                	addi	sp,sp,-64
 464:	fc06                	sd	ra,56(sp)
 466:	f822                	sd	s0,48(sp)
 468:	f04a                	sd	s2,32(sp)
 46a:	ec4e                	sd	s3,24(sp)
 46c:	0080                	addi	s0,sp,64
 46e:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 470:	cad9                	beqz	a3,506 <printint+0xa4>
 472:	01f5d79b          	srliw	a5,a1,0x1f
 476:	cbc1                	beqz	a5,506 <printint+0xa4>
    neg = 1;
    x = -xx;
 478:	40b005bb          	negw	a1,a1
    neg = 1;
 47c:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 47e:	fc040993          	addi	s3,s0,-64
  neg = 0;
 482:	86ce                	mv	a3,s3
  i = 0;
 484:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 486:	00000817          	auipc	a6,0x0
 48a:	52a80813          	addi	a6,a6,1322 # 9b0 <digits>
 48e:	88ba                	mv	a7,a4
 490:	0017051b          	addiw	a0,a4,1
 494:	872a                	mv	a4,a0
 496:	02c5f7bb          	remuw	a5,a1,a2
 49a:	1782                	slli	a5,a5,0x20
 49c:	9381                	srli	a5,a5,0x20
 49e:	97c2                	add	a5,a5,a6
 4a0:	0007c783          	lbu	a5,0(a5)
 4a4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4a8:	87ae                	mv	a5,a1
 4aa:	02c5d5bb          	divuw	a1,a1,a2
 4ae:	0685                	addi	a3,a3,1
 4b0:	fcc7ffe3          	bgeu	a5,a2,48e <printint+0x2c>
  if(neg)
 4b4:	00030c63          	beqz	t1,4cc <printint+0x6a>
    buf[i++] = '-';
 4b8:	fd050793          	addi	a5,a0,-48
 4bc:	00878533          	add	a0,a5,s0
 4c0:	02d00793          	li	a5,45
 4c4:	fef50823          	sb	a5,-16(a0)
 4c8:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 4cc:	02e05763          	blez	a4,4fa <printint+0x98>
 4d0:	f426                	sd	s1,40(sp)
 4d2:	377d                	addiw	a4,a4,-1
 4d4:	00e984b3          	add	s1,s3,a4
 4d8:	19fd                	addi	s3,s3,-1
 4da:	99ba                	add	s3,s3,a4
 4dc:	1702                	slli	a4,a4,0x20
 4de:	9301                	srli	a4,a4,0x20
 4e0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4e4:	0004c583          	lbu	a1,0(s1)
 4e8:	854a                	mv	a0,s2
 4ea:	00000097          	auipc	ra,0x0
 4ee:	f56080e7          	jalr	-170(ra) # 440 <putc>
  while(--i >= 0)
 4f2:	14fd                	addi	s1,s1,-1
 4f4:	ff3498e3          	bne	s1,s3,4e4 <printint+0x82>
 4f8:	74a2                	ld	s1,40(sp)
}
 4fa:	70e2                	ld	ra,56(sp)
 4fc:	7442                	ld	s0,48(sp)
 4fe:	7902                	ld	s2,32(sp)
 500:	69e2                	ld	s3,24(sp)
 502:	6121                	addi	sp,sp,64
 504:	8082                	ret
  neg = 0;
 506:	4301                	li	t1,0
 508:	bf9d                	j	47e <printint+0x1c>

000000000000050a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 50a:	715d                	addi	sp,sp,-80
 50c:	e486                	sd	ra,72(sp)
 50e:	e0a2                	sd	s0,64(sp)
 510:	f84a                	sd	s2,48(sp)
 512:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 514:	0005c903          	lbu	s2,0(a1)
 518:	1a090b63          	beqz	s2,6ce <vprintf+0x1c4>
 51c:	fc26                	sd	s1,56(sp)
 51e:	f44e                	sd	s3,40(sp)
 520:	f052                	sd	s4,32(sp)
 522:	ec56                	sd	s5,24(sp)
 524:	e85a                	sd	s6,16(sp)
 526:	e45e                	sd	s7,8(sp)
 528:	8aaa                	mv	s5,a0
 52a:	8bb2                	mv	s7,a2
 52c:	00158493          	addi	s1,a1,1
  state = 0;
 530:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 532:	02500a13          	li	s4,37
 536:	4b55                	li	s6,21
 538:	a839                	j	556 <vprintf+0x4c>
        putc(fd, c);
 53a:	85ca                	mv	a1,s2
 53c:	8556                	mv	a0,s5
 53e:	00000097          	auipc	ra,0x0
 542:	f02080e7          	jalr	-254(ra) # 440 <putc>
 546:	a019                	j	54c <vprintf+0x42>
    } else if(state == '%'){
 548:	01498d63          	beq	s3,s4,562 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 54c:	0485                	addi	s1,s1,1
 54e:	fff4c903          	lbu	s2,-1(s1)
 552:	16090863          	beqz	s2,6c2 <vprintf+0x1b8>
    if(state == 0){
 556:	fe0999e3          	bnez	s3,548 <vprintf+0x3e>
      if(c == '%'){
 55a:	ff4910e3          	bne	s2,s4,53a <vprintf+0x30>
        state = '%';
 55e:	89d2                	mv	s3,s4
 560:	b7f5                	j	54c <vprintf+0x42>
      if(c == 'd'){
 562:	13490563          	beq	s2,s4,68c <vprintf+0x182>
 566:	f9d9079b          	addiw	a5,s2,-99
 56a:	0ff7f793          	zext.b	a5,a5
 56e:	12fb6863          	bltu	s6,a5,69e <vprintf+0x194>
 572:	f9d9079b          	addiw	a5,s2,-99
 576:	0ff7f713          	zext.b	a4,a5
 57a:	12eb6263          	bltu	s6,a4,69e <vprintf+0x194>
 57e:	00271793          	slli	a5,a4,0x2
 582:	00000717          	auipc	a4,0x0
 586:	3d670713          	addi	a4,a4,982 # 958 <malloc+0x196>
 58a:	97ba                	add	a5,a5,a4
 58c:	439c                	lw	a5,0(a5)
 58e:	97ba                	add	a5,a5,a4
 590:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 592:	008b8913          	addi	s2,s7,8
 596:	4685                	li	a3,1
 598:	4629                	li	a2,10
 59a:	000ba583          	lw	a1,0(s7)
 59e:	8556                	mv	a0,s5
 5a0:	00000097          	auipc	ra,0x0
 5a4:	ec2080e7          	jalr	-318(ra) # 462 <printint>
 5a8:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5aa:	4981                	li	s3,0
 5ac:	b745                	j	54c <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ae:	008b8913          	addi	s2,s7,8
 5b2:	4681                	li	a3,0
 5b4:	4629                	li	a2,10
 5b6:	000ba583          	lw	a1,0(s7)
 5ba:	8556                	mv	a0,s5
 5bc:	00000097          	auipc	ra,0x0
 5c0:	ea6080e7          	jalr	-346(ra) # 462 <printint>
 5c4:	8bca                	mv	s7,s2
      state = 0;
 5c6:	4981                	li	s3,0
 5c8:	b751                	j	54c <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 5ca:	008b8913          	addi	s2,s7,8
 5ce:	4681                	li	a3,0
 5d0:	4641                	li	a2,16
 5d2:	000ba583          	lw	a1,0(s7)
 5d6:	8556                	mv	a0,s5
 5d8:	00000097          	auipc	ra,0x0
 5dc:	e8a080e7          	jalr	-374(ra) # 462 <printint>
 5e0:	8bca                	mv	s7,s2
      state = 0;
 5e2:	4981                	li	s3,0
 5e4:	b7a5                	j	54c <vprintf+0x42>
 5e6:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5e8:	008b8793          	addi	a5,s7,8
 5ec:	8c3e                	mv	s8,a5
 5ee:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5f2:	03000593          	li	a1,48
 5f6:	8556                	mv	a0,s5
 5f8:	00000097          	auipc	ra,0x0
 5fc:	e48080e7          	jalr	-440(ra) # 440 <putc>
  putc(fd, 'x');
 600:	07800593          	li	a1,120
 604:	8556                	mv	a0,s5
 606:	00000097          	auipc	ra,0x0
 60a:	e3a080e7          	jalr	-454(ra) # 440 <putc>
 60e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 610:	00000b97          	auipc	s7,0x0
 614:	3a0b8b93          	addi	s7,s7,928 # 9b0 <digits>
 618:	03c9d793          	srli	a5,s3,0x3c
 61c:	97de                	add	a5,a5,s7
 61e:	0007c583          	lbu	a1,0(a5)
 622:	8556                	mv	a0,s5
 624:	00000097          	auipc	ra,0x0
 628:	e1c080e7          	jalr	-484(ra) # 440 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 62c:	0992                	slli	s3,s3,0x4
 62e:	397d                	addiw	s2,s2,-1
 630:	fe0914e3          	bnez	s2,618 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 634:	8be2                	mv	s7,s8
      state = 0;
 636:	4981                	li	s3,0
 638:	6c02                	ld	s8,0(sp)
 63a:	bf09                	j	54c <vprintf+0x42>
        s = va_arg(ap, char*);
 63c:	008b8993          	addi	s3,s7,8
 640:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 644:	02090163          	beqz	s2,666 <vprintf+0x15c>
        while(*s != 0){
 648:	00094583          	lbu	a1,0(s2)
 64c:	c9a5                	beqz	a1,6bc <vprintf+0x1b2>
          putc(fd, *s);
 64e:	8556                	mv	a0,s5
 650:	00000097          	auipc	ra,0x0
 654:	df0080e7          	jalr	-528(ra) # 440 <putc>
          s++;
 658:	0905                	addi	s2,s2,1
        while(*s != 0){
 65a:	00094583          	lbu	a1,0(s2)
 65e:	f9e5                	bnez	a1,64e <vprintf+0x144>
        s = va_arg(ap, char*);
 660:	8bce                	mv	s7,s3
      state = 0;
 662:	4981                	li	s3,0
 664:	b5e5                	j	54c <vprintf+0x42>
          s = "(null)";
 666:	00000917          	auipc	s2,0x0
 66a:	2ea90913          	addi	s2,s2,746 # 950 <malloc+0x18e>
        while(*s != 0){
 66e:	02800593          	li	a1,40
 672:	bff1                	j	64e <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 674:	008b8913          	addi	s2,s7,8
 678:	000bc583          	lbu	a1,0(s7)
 67c:	8556                	mv	a0,s5
 67e:	00000097          	auipc	ra,0x0
 682:	dc2080e7          	jalr	-574(ra) # 440 <putc>
 686:	8bca                	mv	s7,s2
      state = 0;
 688:	4981                	li	s3,0
 68a:	b5c9                	j	54c <vprintf+0x42>
        putc(fd, c);
 68c:	02500593          	li	a1,37
 690:	8556                	mv	a0,s5
 692:	00000097          	auipc	ra,0x0
 696:	dae080e7          	jalr	-594(ra) # 440 <putc>
      state = 0;
 69a:	4981                	li	s3,0
 69c:	bd45                	j	54c <vprintf+0x42>
        putc(fd, '%');
 69e:	02500593          	li	a1,37
 6a2:	8556                	mv	a0,s5
 6a4:	00000097          	auipc	ra,0x0
 6a8:	d9c080e7          	jalr	-612(ra) # 440 <putc>
        putc(fd, c);
 6ac:	85ca                	mv	a1,s2
 6ae:	8556                	mv	a0,s5
 6b0:	00000097          	auipc	ra,0x0
 6b4:	d90080e7          	jalr	-624(ra) # 440 <putc>
      state = 0;
 6b8:	4981                	li	s3,0
 6ba:	bd49                	j	54c <vprintf+0x42>
        s = va_arg(ap, char*);
 6bc:	8bce                	mv	s7,s3
      state = 0;
 6be:	4981                	li	s3,0
 6c0:	b571                	j	54c <vprintf+0x42>
 6c2:	74e2                	ld	s1,56(sp)
 6c4:	79a2                	ld	s3,40(sp)
 6c6:	7a02                	ld	s4,32(sp)
 6c8:	6ae2                	ld	s5,24(sp)
 6ca:	6b42                	ld	s6,16(sp)
 6cc:	6ba2                	ld	s7,8(sp)
    }
  }
}
 6ce:	60a6                	ld	ra,72(sp)
 6d0:	6406                	ld	s0,64(sp)
 6d2:	7942                	ld	s2,48(sp)
 6d4:	6161                	addi	sp,sp,80
 6d6:	8082                	ret

00000000000006d8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6d8:	715d                	addi	sp,sp,-80
 6da:	ec06                	sd	ra,24(sp)
 6dc:	e822                	sd	s0,16(sp)
 6de:	1000                	addi	s0,sp,32
 6e0:	e010                	sd	a2,0(s0)
 6e2:	e414                	sd	a3,8(s0)
 6e4:	e818                	sd	a4,16(s0)
 6e6:	ec1c                	sd	a5,24(s0)
 6e8:	03043023          	sd	a6,32(s0)
 6ec:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6f0:	8622                	mv	a2,s0
 6f2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6f6:	00000097          	auipc	ra,0x0
 6fa:	e14080e7          	jalr	-492(ra) # 50a <vprintf>
}
 6fe:	60e2                	ld	ra,24(sp)
 700:	6442                	ld	s0,16(sp)
 702:	6161                	addi	sp,sp,80
 704:	8082                	ret

0000000000000706 <printf>:

void
printf(const char *fmt, ...)
{
 706:	711d                	addi	sp,sp,-96
 708:	ec06                	sd	ra,24(sp)
 70a:	e822                	sd	s0,16(sp)
 70c:	1000                	addi	s0,sp,32
 70e:	e40c                	sd	a1,8(s0)
 710:	e810                	sd	a2,16(s0)
 712:	ec14                	sd	a3,24(s0)
 714:	f018                	sd	a4,32(s0)
 716:	f41c                	sd	a5,40(s0)
 718:	03043823          	sd	a6,48(s0)
 71c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 720:	00840613          	addi	a2,s0,8
 724:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 728:	85aa                	mv	a1,a0
 72a:	4505                	li	a0,1
 72c:	00000097          	auipc	ra,0x0
 730:	dde080e7          	jalr	-546(ra) # 50a <vprintf>
}
 734:	60e2                	ld	ra,24(sp)
 736:	6442                	ld	s0,16(sp)
 738:	6125                	addi	sp,sp,96
 73a:	8082                	ret

000000000000073c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 73c:	1141                	addi	sp,sp,-16
 73e:	e406                	sd	ra,8(sp)
 740:	e022                	sd	s0,0(sp)
 742:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 744:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 748:	00000797          	auipc	a5,0x0
 74c:	2807b783          	ld	a5,640(a5) # 9c8 <freep>
 750:	a039                	j	75e <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 752:	6398                	ld	a4,0(a5)
 754:	00e7e463          	bltu	a5,a4,75c <free+0x20>
 758:	00e6ea63          	bltu	a3,a4,76c <free+0x30>
{
 75c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 75e:	fed7fae3          	bgeu	a5,a3,752 <free+0x16>
 762:	6398                	ld	a4,0(a5)
 764:	00e6e463          	bltu	a3,a4,76c <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 768:	fee7eae3          	bltu	a5,a4,75c <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 76c:	ff852583          	lw	a1,-8(a0)
 770:	6390                	ld	a2,0(a5)
 772:	02059813          	slli	a6,a1,0x20
 776:	01c85713          	srli	a4,a6,0x1c
 77a:	9736                	add	a4,a4,a3
 77c:	02e60563          	beq	a2,a4,7a6 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 780:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 784:	4790                	lw	a2,8(a5)
 786:	02061593          	slli	a1,a2,0x20
 78a:	01c5d713          	srli	a4,a1,0x1c
 78e:	973e                	add	a4,a4,a5
 790:	02e68263          	beq	a3,a4,7b4 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 794:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 796:	00000717          	auipc	a4,0x0
 79a:	22f73923          	sd	a5,562(a4) # 9c8 <freep>
}
 79e:	60a2                	ld	ra,8(sp)
 7a0:	6402                	ld	s0,0(sp)
 7a2:	0141                	addi	sp,sp,16
 7a4:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 7a6:	4618                	lw	a4,8(a2)
 7a8:	9f2d                	addw	a4,a4,a1
 7aa:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7ae:	6398                	ld	a4,0(a5)
 7b0:	6310                	ld	a2,0(a4)
 7b2:	b7f9                	j	780 <free+0x44>
    p->s.size += bp->s.size;
 7b4:	ff852703          	lw	a4,-8(a0)
 7b8:	9f31                	addw	a4,a4,a2
 7ba:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7bc:	ff053683          	ld	a3,-16(a0)
 7c0:	bfd1                	j	794 <free+0x58>

00000000000007c2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7c2:	7139                	addi	sp,sp,-64
 7c4:	fc06                	sd	ra,56(sp)
 7c6:	f822                	sd	s0,48(sp)
 7c8:	f04a                	sd	s2,32(sp)
 7ca:	ec4e                	sd	s3,24(sp)
 7cc:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7ce:	02051993          	slli	s3,a0,0x20
 7d2:	0209d993          	srli	s3,s3,0x20
 7d6:	09bd                	addi	s3,s3,15
 7d8:	0049d993          	srli	s3,s3,0x4
 7dc:	2985                	addiw	s3,s3,1
 7de:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 7e0:	00000517          	auipc	a0,0x0
 7e4:	1e853503          	ld	a0,488(a0) # 9c8 <freep>
 7e8:	c905                	beqz	a0,818 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ea:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7ec:	4798                	lw	a4,8(a5)
 7ee:	09377a63          	bgeu	a4,s3,882 <malloc+0xc0>
 7f2:	f426                	sd	s1,40(sp)
 7f4:	e852                	sd	s4,16(sp)
 7f6:	e456                	sd	s5,8(sp)
 7f8:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7fa:	8a4e                	mv	s4,s3
 7fc:	6705                	lui	a4,0x1
 7fe:	00e9f363          	bgeu	s3,a4,804 <malloc+0x42>
 802:	6a05                	lui	s4,0x1
 804:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 808:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 80c:	00000497          	auipc	s1,0x0
 810:	1bc48493          	addi	s1,s1,444 # 9c8 <freep>
  if(p == (char*)-1)
 814:	5afd                	li	s5,-1
 816:	a089                	j	858 <malloc+0x96>
 818:	f426                	sd	s1,40(sp)
 81a:	e852                	sd	s4,16(sp)
 81c:	e456                	sd	s5,8(sp)
 81e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 820:	00000797          	auipc	a5,0x0
 824:	1b078793          	addi	a5,a5,432 # 9d0 <base>
 828:	00000717          	auipc	a4,0x0
 82c:	1af73023          	sd	a5,416(a4) # 9c8 <freep>
 830:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 832:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 836:	b7d1                	j	7fa <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 838:	6398                	ld	a4,0(a5)
 83a:	e118                	sd	a4,0(a0)
 83c:	a8b9                	j	89a <malloc+0xd8>
  hp->s.size = nu;
 83e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 842:	0541                	addi	a0,a0,16
 844:	00000097          	auipc	ra,0x0
 848:	ef8080e7          	jalr	-264(ra) # 73c <free>
  return freep;
 84c:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 84e:	c135                	beqz	a0,8b2 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 850:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 852:	4798                	lw	a4,8(a5)
 854:	03277363          	bgeu	a4,s2,87a <malloc+0xb8>
    if(p == freep)
 858:	6098                	ld	a4,0(s1)
 85a:	853e                	mv	a0,a5
 85c:	fef71ae3          	bne	a4,a5,850 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 860:	8552                	mv	a0,s4
 862:	00000097          	auipc	ra,0x0
 866:	bb6080e7          	jalr	-1098(ra) # 418 <sbrk>
  if(p == (char*)-1)
 86a:	fd551ae3          	bne	a0,s5,83e <malloc+0x7c>
        return 0;
 86e:	4501                	li	a0,0
 870:	74a2                	ld	s1,40(sp)
 872:	6a42                	ld	s4,16(sp)
 874:	6aa2                	ld	s5,8(sp)
 876:	6b02                	ld	s6,0(sp)
 878:	a03d                	j	8a6 <malloc+0xe4>
 87a:	74a2                	ld	s1,40(sp)
 87c:	6a42                	ld	s4,16(sp)
 87e:	6aa2                	ld	s5,8(sp)
 880:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 882:	fae90be3          	beq	s2,a4,838 <malloc+0x76>
        p->s.size -= nunits;
 886:	4137073b          	subw	a4,a4,s3
 88a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 88c:	02071693          	slli	a3,a4,0x20
 890:	01c6d713          	srli	a4,a3,0x1c
 894:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 896:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 89a:	00000717          	auipc	a4,0x0
 89e:	12a73723          	sd	a0,302(a4) # 9c8 <freep>
      return (void*)(p + 1);
 8a2:	01078513          	addi	a0,a5,16
  }
}
 8a6:	70e2                	ld	ra,56(sp)
 8a8:	7442                	ld	s0,48(sp)
 8aa:	7902                	ld	s2,32(sp)
 8ac:	69e2                	ld	s3,24(sp)
 8ae:	6121                	addi	sp,sp,64
 8b0:	8082                	ret
 8b2:	74a2                	ld	s1,40(sp)
 8b4:	6a42                	ld	s4,16(sp)
 8b6:	6aa2                	ld	s5,8(sp)
 8b8:	6b02                	ld	s6,0(sp)
 8ba:	b7f5                	j	8a6 <malloc+0xe4>
