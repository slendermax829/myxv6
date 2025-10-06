
user/_time1:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
/** time1: measure the time a command(program) takes to run 
 * @argc: number of command-line arguments
 * @argv: array of command-line arguments
*/

int main(int argc, char *argv[]){
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32

    // Check if at least one argument is provided
    if(argc == 1){
   8:	4785                	li	a5,1
   a:	04f50763          	beq	a0,a5,58 <main+0x58>
   e:	e426                	sd	s1,8(sp)
  10:	e04a                	sd	s2,0(sp)
  12:	84ae                	mv	s1,a1
        printf("Usage: time1 [args]\n");
        exit(1);
    }
    // Get the intial start time in ticks
    int startTime = uptime();
  14:	00000097          	auipc	ra,0x0
  18:	3d4080e7          	jalr	980(ra) # 3e8 <uptime>
  1c:	892a                	mv	s2,a0
    // Create a child process
    int childPID = fork();
  1e:	00000097          	auipc	ra,0x0
  22:	32a080e7          	jalr	810(ra) # 348 <fork>

    // Error handling for fork failure
    if(childPID < 0){
  26:	04054863          	bltz	a0,76 <main+0x76>
        exit(1);
    }

    // Child process; execute the command
    else
    if(childPID == 0){
  2a:	e525                	bnez	a0,92 <main+0x92>
        // Execute the command that was passed as an argument
        exec(argv[1], &argv[1]);
  2c:	00848593          	addi	a1,s1,8
  30:	6488                	ld	a0,8(s1)
  32:	00000097          	auipc	ra,0x0
  36:	356080e7          	jalr	854(ra) # 388 <exec>

        // If exec fails, print an error message and exit
        fprintf(2, "time1: exec %s failed\n", argv[1]);
  3a:	6490                	ld	a2,8(s1)
  3c:	00001597          	auipc	a1,0x1
  40:	86c58593          	addi	a1,a1,-1940 # 8a8 <malloc+0x12e>
  44:	4509                	li	a0,2
  46:	00000097          	auipc	ra,0x0
  4a:	64a080e7          	jalr	1610(ra) # 690 <fprintf>
        exit(1);
  4e:	4505                	li	a0,1
  50:	00000097          	auipc	ra,0x0
  54:	300080e7          	jalr	768(ra) # 350 <exit>
  58:	e426                	sd	s1,8(sp)
  5a:	e04a                	sd	s2,0(sp)
        printf("Usage: time1 [args]\n");
  5c:	00001517          	auipc	a0,0x1
  60:	81c50513          	addi	a0,a0,-2020 # 878 <malloc+0xfe>
  64:	00000097          	auipc	ra,0x0
  68:	65a080e7          	jalr	1626(ra) # 6be <printf>
        exit(1);
  6c:	4505                	li	a0,1
  6e:	00000097          	auipc	ra,0x0
  72:	2e2080e7          	jalr	738(ra) # 350 <exit>
        fprintf(2, "time1: fork failed\n");
  76:	00001597          	auipc	a1,0x1
  7a:	81a58593          	addi	a1,a1,-2022 # 890 <malloc+0x116>
  7e:	4509                	li	a0,2
  80:	00000097          	auipc	ra,0x0
  84:	610080e7          	jalr	1552(ra) # 690 <fprintf>
        exit(1);
  88:	4505                	li	a0,1
  8a:	00000097          	auipc	ra,0x0
  8e:	2c6080e7          	jalr	710(ra) # 350 <exit>
       

    } else {
       // Parent process; wait for the child to finish
       // Using wait to wait for the child process to finish
       wait(0);
  92:	4501                	li	a0,0
  94:	00000097          	auipc	ra,0x0
  98:	2c4080e7          	jalr	708(ra) # 358 <wait>
       
       // Get the parent process end time in ticks
       int parentTime = uptime();
  9c:	00000097          	auipc	ra,0x0
  a0:	34c080e7          	jalr	844(ra) # 3e8 <uptime>

       // Print the time elapsed by calculating the difference
       printf("Time elapsed: %d ticks\n", parentTime - startTime);
  a4:	412505bb          	subw	a1,a0,s2
  a8:	00001517          	auipc	a0,0x1
  ac:	81850513          	addi	a0,a0,-2024 # 8c0 <malloc+0x146>
  b0:	00000097          	auipc	ra,0x0
  b4:	60e080e7          	jalr	1550(ra) # 6be <printf>

    }

    exit(0); // success
  b8:	4501                	li	a0,0
  ba:	00000097          	auipc	ra,0x0
  be:	296080e7          	jalr	662(ra) # 350 <exit>

00000000000000c2 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  c2:	1141                	addi	sp,sp,-16
  c4:	e406                	sd	ra,8(sp)
  c6:	e022                	sd	s0,0(sp)
  c8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  ca:	87aa                	mv	a5,a0
  cc:	0585                	addi	a1,a1,1
  ce:	0785                	addi	a5,a5,1
  d0:	fff5c703          	lbu	a4,-1(a1)
  d4:	fee78fa3          	sb	a4,-1(a5)
  d8:	fb75                	bnez	a4,cc <strcpy+0xa>
    ;
  return os;
}
  da:	60a2                	ld	ra,8(sp)
  dc:	6402                	ld	s0,0(sp)
  de:	0141                	addi	sp,sp,16
  e0:	8082                	ret

00000000000000e2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  e2:	1141                	addi	sp,sp,-16
  e4:	e406                	sd	ra,8(sp)
  e6:	e022                	sd	s0,0(sp)
  e8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  ea:	00054783          	lbu	a5,0(a0)
  ee:	cb91                	beqz	a5,102 <strcmp+0x20>
  f0:	0005c703          	lbu	a4,0(a1)
  f4:	00f71763          	bne	a4,a5,102 <strcmp+0x20>
    p++, q++;
  f8:	0505                	addi	a0,a0,1
  fa:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  fc:	00054783          	lbu	a5,0(a0)
 100:	fbe5                	bnez	a5,f0 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 102:	0005c503          	lbu	a0,0(a1)
}
 106:	40a7853b          	subw	a0,a5,a0
 10a:	60a2                	ld	ra,8(sp)
 10c:	6402                	ld	s0,0(sp)
 10e:	0141                	addi	sp,sp,16
 110:	8082                	ret

0000000000000112 <strlen>:

uint
strlen(const char *s)
{
 112:	1141                	addi	sp,sp,-16
 114:	e406                	sd	ra,8(sp)
 116:	e022                	sd	s0,0(sp)
 118:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 11a:	00054783          	lbu	a5,0(a0)
 11e:	cf91                	beqz	a5,13a <strlen+0x28>
 120:	00150793          	addi	a5,a0,1
 124:	86be                	mv	a3,a5
 126:	0785                	addi	a5,a5,1
 128:	fff7c703          	lbu	a4,-1(a5)
 12c:	ff65                	bnez	a4,124 <strlen+0x12>
 12e:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 132:	60a2                	ld	ra,8(sp)
 134:	6402                	ld	s0,0(sp)
 136:	0141                	addi	sp,sp,16
 138:	8082                	ret
  for(n = 0; s[n]; n++)
 13a:	4501                	li	a0,0
 13c:	bfdd                	j	132 <strlen+0x20>

000000000000013e <memset>:

void*
memset(void *dst, int c, uint n)
{
 13e:	1141                	addi	sp,sp,-16
 140:	e406                	sd	ra,8(sp)
 142:	e022                	sd	s0,0(sp)
 144:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 146:	ca19                	beqz	a2,15c <memset+0x1e>
 148:	87aa                	mv	a5,a0
 14a:	1602                	slli	a2,a2,0x20
 14c:	9201                	srli	a2,a2,0x20
 14e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 152:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 156:	0785                	addi	a5,a5,1
 158:	fee79de3          	bne	a5,a4,152 <memset+0x14>
  }
  return dst;
}
 15c:	60a2                	ld	ra,8(sp)
 15e:	6402                	ld	s0,0(sp)
 160:	0141                	addi	sp,sp,16
 162:	8082                	ret

0000000000000164 <strchr>:

char*
strchr(const char *s, char c)
{
 164:	1141                	addi	sp,sp,-16
 166:	e406                	sd	ra,8(sp)
 168:	e022                	sd	s0,0(sp)
 16a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 16c:	00054783          	lbu	a5,0(a0)
 170:	cf81                	beqz	a5,188 <strchr+0x24>
    if(*s == c)
 172:	00f58763          	beq	a1,a5,180 <strchr+0x1c>
  for(; *s; s++)
 176:	0505                	addi	a0,a0,1
 178:	00054783          	lbu	a5,0(a0)
 17c:	fbfd                	bnez	a5,172 <strchr+0xe>
      return (char*)s;
  return 0;
 17e:	4501                	li	a0,0
}
 180:	60a2                	ld	ra,8(sp)
 182:	6402                	ld	s0,0(sp)
 184:	0141                	addi	sp,sp,16
 186:	8082                	ret
  return 0;
 188:	4501                	li	a0,0
 18a:	bfdd                	j	180 <strchr+0x1c>

000000000000018c <gets>:

char*
gets(char *buf, int max)
{
 18c:	711d                	addi	sp,sp,-96
 18e:	ec86                	sd	ra,88(sp)
 190:	e8a2                	sd	s0,80(sp)
 192:	e4a6                	sd	s1,72(sp)
 194:	e0ca                	sd	s2,64(sp)
 196:	fc4e                	sd	s3,56(sp)
 198:	f852                	sd	s4,48(sp)
 19a:	f456                	sd	s5,40(sp)
 19c:	f05a                	sd	s6,32(sp)
 19e:	ec5e                	sd	s7,24(sp)
 1a0:	e862                	sd	s8,16(sp)
 1a2:	1080                	addi	s0,sp,96
 1a4:	8baa                	mv	s7,a0
 1a6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1a8:	892a                	mv	s2,a0
 1aa:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1ac:	faf40b13          	addi	s6,s0,-81
 1b0:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 1b2:	8c26                	mv	s8,s1
 1b4:	0014899b          	addiw	s3,s1,1
 1b8:	84ce                	mv	s1,s3
 1ba:	0349d663          	bge	s3,s4,1e6 <gets+0x5a>
    cc = read(0, &c, 1);
 1be:	8656                	mv	a2,s5
 1c0:	85da                	mv	a1,s6
 1c2:	4501                	li	a0,0
 1c4:	00000097          	auipc	ra,0x0
 1c8:	1a4080e7          	jalr	420(ra) # 368 <read>
    if(cc < 1)
 1cc:	00a05d63          	blez	a0,1e6 <gets+0x5a>
      break;
    buf[i++] = c;
 1d0:	faf44783          	lbu	a5,-81(s0)
 1d4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1d8:	0905                	addi	s2,s2,1
 1da:	ff678713          	addi	a4,a5,-10
 1de:	c319                	beqz	a4,1e4 <gets+0x58>
 1e0:	17cd                	addi	a5,a5,-13
 1e2:	fbe1                	bnez	a5,1b2 <gets+0x26>
    buf[i++] = c;
 1e4:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 1e6:	9c5e                	add	s8,s8,s7
 1e8:	000c0023          	sb	zero,0(s8)
  return buf;
}
 1ec:	855e                	mv	a0,s7
 1ee:	60e6                	ld	ra,88(sp)
 1f0:	6446                	ld	s0,80(sp)
 1f2:	64a6                	ld	s1,72(sp)
 1f4:	6906                	ld	s2,64(sp)
 1f6:	79e2                	ld	s3,56(sp)
 1f8:	7a42                	ld	s4,48(sp)
 1fa:	7aa2                	ld	s5,40(sp)
 1fc:	7b02                	ld	s6,32(sp)
 1fe:	6be2                	ld	s7,24(sp)
 200:	6c42                	ld	s8,16(sp)
 202:	6125                	addi	sp,sp,96
 204:	8082                	ret

0000000000000206 <stat>:

int
stat(const char *n, struct stat *st)
{
 206:	1101                	addi	sp,sp,-32
 208:	ec06                	sd	ra,24(sp)
 20a:	e822                	sd	s0,16(sp)
 20c:	e04a                	sd	s2,0(sp)
 20e:	1000                	addi	s0,sp,32
 210:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 212:	4581                	li	a1,0
 214:	00000097          	auipc	ra,0x0
 218:	17c080e7          	jalr	380(ra) # 390 <open>
  if(fd < 0)
 21c:	02054663          	bltz	a0,248 <stat+0x42>
 220:	e426                	sd	s1,8(sp)
 222:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 224:	85ca                	mv	a1,s2
 226:	00000097          	auipc	ra,0x0
 22a:	182080e7          	jalr	386(ra) # 3a8 <fstat>
 22e:	892a                	mv	s2,a0
  close(fd);
 230:	8526                	mv	a0,s1
 232:	00000097          	auipc	ra,0x0
 236:	146080e7          	jalr	326(ra) # 378 <close>
  return r;
 23a:	64a2                	ld	s1,8(sp)
}
 23c:	854a                	mv	a0,s2
 23e:	60e2                	ld	ra,24(sp)
 240:	6442                	ld	s0,16(sp)
 242:	6902                	ld	s2,0(sp)
 244:	6105                	addi	sp,sp,32
 246:	8082                	ret
    return -1;
 248:	57fd                	li	a5,-1
 24a:	893e                	mv	s2,a5
 24c:	bfc5                	j	23c <stat+0x36>

000000000000024e <atoi>:

int
atoi(const char *s)
{
 24e:	1141                	addi	sp,sp,-16
 250:	e406                	sd	ra,8(sp)
 252:	e022                	sd	s0,0(sp)
 254:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 256:	00054683          	lbu	a3,0(a0)
 25a:	fd06879b          	addiw	a5,a3,-48
 25e:	0ff7f793          	zext.b	a5,a5
 262:	4625                	li	a2,9
 264:	02f66963          	bltu	a2,a5,296 <atoi+0x48>
 268:	872a                	mv	a4,a0
  n = 0;
 26a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 26c:	0705                	addi	a4,a4,1
 26e:	0025179b          	slliw	a5,a0,0x2
 272:	9fa9                	addw	a5,a5,a0
 274:	0017979b          	slliw	a5,a5,0x1
 278:	9fb5                	addw	a5,a5,a3
 27a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 27e:	00074683          	lbu	a3,0(a4)
 282:	fd06879b          	addiw	a5,a3,-48
 286:	0ff7f793          	zext.b	a5,a5
 28a:	fef671e3          	bgeu	a2,a5,26c <atoi+0x1e>
  return n;
}
 28e:	60a2                	ld	ra,8(sp)
 290:	6402                	ld	s0,0(sp)
 292:	0141                	addi	sp,sp,16
 294:	8082                	ret
  n = 0;
 296:	4501                	li	a0,0
 298:	bfdd                	j	28e <atoi+0x40>

000000000000029a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 29a:	1141                	addi	sp,sp,-16
 29c:	e406                	sd	ra,8(sp)
 29e:	e022                	sd	s0,0(sp)
 2a0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2a2:	02b57563          	bgeu	a0,a1,2cc <memmove+0x32>
    while(n-- > 0)
 2a6:	00c05f63          	blez	a2,2c4 <memmove+0x2a>
 2aa:	1602                	slli	a2,a2,0x20
 2ac:	9201                	srli	a2,a2,0x20
 2ae:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2b2:	872a                	mv	a4,a0
      *dst++ = *src++;
 2b4:	0585                	addi	a1,a1,1
 2b6:	0705                	addi	a4,a4,1
 2b8:	fff5c683          	lbu	a3,-1(a1)
 2bc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2c0:	fee79ae3          	bne	a5,a4,2b4 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2c4:	60a2                	ld	ra,8(sp)
 2c6:	6402                	ld	s0,0(sp)
 2c8:	0141                	addi	sp,sp,16
 2ca:	8082                	ret
    while(n-- > 0)
 2cc:	fec05ce3          	blez	a2,2c4 <memmove+0x2a>
    dst += n;
 2d0:	00c50733          	add	a4,a0,a2
    src += n;
 2d4:	95b2                	add	a1,a1,a2
 2d6:	fff6079b          	addiw	a5,a2,-1
 2da:	1782                	slli	a5,a5,0x20
 2dc:	9381                	srli	a5,a5,0x20
 2de:	fff7c793          	not	a5,a5
 2e2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2e4:	15fd                	addi	a1,a1,-1
 2e6:	177d                	addi	a4,a4,-1
 2e8:	0005c683          	lbu	a3,0(a1)
 2ec:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2f0:	fef71ae3          	bne	a4,a5,2e4 <memmove+0x4a>
 2f4:	bfc1                	j	2c4 <memmove+0x2a>

00000000000002f6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2f6:	1141                	addi	sp,sp,-16
 2f8:	e406                	sd	ra,8(sp)
 2fa:	e022                	sd	s0,0(sp)
 2fc:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2fe:	c61d                	beqz	a2,32c <memcmp+0x36>
 300:	1602                	slli	a2,a2,0x20
 302:	9201                	srli	a2,a2,0x20
 304:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 308:	00054783          	lbu	a5,0(a0)
 30c:	0005c703          	lbu	a4,0(a1)
 310:	00e79863          	bne	a5,a4,320 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 314:	0505                	addi	a0,a0,1
    p2++;
 316:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 318:	fed518e3          	bne	a0,a3,308 <memcmp+0x12>
  }
  return 0;
 31c:	4501                	li	a0,0
 31e:	a019                	j	324 <memcmp+0x2e>
      return *p1 - *p2;
 320:	40e7853b          	subw	a0,a5,a4
}
 324:	60a2                	ld	ra,8(sp)
 326:	6402                	ld	s0,0(sp)
 328:	0141                	addi	sp,sp,16
 32a:	8082                	ret
  return 0;
 32c:	4501                	li	a0,0
 32e:	bfdd                	j	324 <memcmp+0x2e>

0000000000000330 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 330:	1141                	addi	sp,sp,-16
 332:	e406                	sd	ra,8(sp)
 334:	e022                	sd	s0,0(sp)
 336:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 338:	00000097          	auipc	ra,0x0
 33c:	f62080e7          	jalr	-158(ra) # 29a <memmove>
}
 340:	60a2                	ld	ra,8(sp)
 342:	6402                	ld	s0,0(sp)
 344:	0141                	addi	sp,sp,16
 346:	8082                	ret

0000000000000348 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 348:	4885                	li	a7,1
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <exit>:
.global exit
exit:
 li a7, SYS_exit
 350:	4889                	li	a7,2
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <wait>:
.global wait
wait:
 li a7, SYS_wait
 358:	488d                	li	a7,3
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 360:	4891                	li	a7,4
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <read>:
.global read
read:
 li a7, SYS_read
 368:	4895                	li	a7,5
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <write>:
.global write
write:
 li a7, SYS_write
 370:	48c1                	li	a7,16
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <close>:
.global close
close:
 li a7, SYS_close
 378:	48d5                	li	a7,21
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <kill>:
.global kill
kill:
 li a7, SYS_kill
 380:	4899                	li	a7,6
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <exec>:
.global exec
exec:
 li a7, SYS_exec
 388:	489d                	li	a7,7
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <open>:
.global open
open:
 li a7, SYS_open
 390:	48bd                	li	a7,15
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 398:	48c5                	li	a7,17
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3a0:	48c9                	li	a7,18
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3a8:	48a1                	li	a7,8
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <link>:
.global link
link:
 li a7, SYS_link
 3b0:	48cd                	li	a7,19
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3b8:	48d1                	li	a7,20
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3c0:	48a5                	li	a7,9
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3c8:	48a9                	li	a7,10
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3d0:	48ad                	li	a7,11
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3d8:	48b1                	li	a7,12
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3e0:	48b5                	li	a7,13
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3e8:	48b9                	li	a7,14
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <wait2>:
.global wait2
wait2:
 li a7, SYS_wait2
 3f0:	48dd                	li	a7,23
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3f8:	1101                	addi	sp,sp,-32
 3fa:	ec06                	sd	ra,24(sp)
 3fc:	e822                	sd	s0,16(sp)
 3fe:	1000                	addi	s0,sp,32
 400:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 404:	4605                	li	a2,1
 406:	fef40593          	addi	a1,s0,-17
 40a:	00000097          	auipc	ra,0x0
 40e:	f66080e7          	jalr	-154(ra) # 370 <write>
}
 412:	60e2                	ld	ra,24(sp)
 414:	6442                	ld	s0,16(sp)
 416:	6105                	addi	sp,sp,32
 418:	8082                	ret

000000000000041a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 41a:	7139                	addi	sp,sp,-64
 41c:	fc06                	sd	ra,56(sp)
 41e:	f822                	sd	s0,48(sp)
 420:	f04a                	sd	s2,32(sp)
 422:	ec4e                	sd	s3,24(sp)
 424:	0080                	addi	s0,sp,64
 426:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 428:	cad9                	beqz	a3,4be <printint+0xa4>
 42a:	01f5d79b          	srliw	a5,a1,0x1f
 42e:	cbc1                	beqz	a5,4be <printint+0xa4>
    neg = 1;
    x = -xx;
 430:	40b005bb          	negw	a1,a1
    neg = 1;
 434:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 436:	fc040993          	addi	s3,s0,-64
  neg = 0;
 43a:	86ce                	mv	a3,s3
  i = 0;
 43c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 43e:	00000817          	auipc	a6,0x0
 442:	4fa80813          	addi	a6,a6,1274 # 938 <digits>
 446:	88ba                	mv	a7,a4
 448:	0017051b          	addiw	a0,a4,1
 44c:	872a                	mv	a4,a0
 44e:	02c5f7bb          	remuw	a5,a1,a2
 452:	1782                	slli	a5,a5,0x20
 454:	9381                	srli	a5,a5,0x20
 456:	97c2                	add	a5,a5,a6
 458:	0007c783          	lbu	a5,0(a5)
 45c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 460:	87ae                	mv	a5,a1
 462:	02c5d5bb          	divuw	a1,a1,a2
 466:	0685                	addi	a3,a3,1
 468:	fcc7ffe3          	bgeu	a5,a2,446 <printint+0x2c>
  if(neg)
 46c:	00030c63          	beqz	t1,484 <printint+0x6a>
    buf[i++] = '-';
 470:	fd050793          	addi	a5,a0,-48
 474:	00878533          	add	a0,a5,s0
 478:	02d00793          	li	a5,45
 47c:	fef50823          	sb	a5,-16(a0)
 480:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 484:	02e05763          	blez	a4,4b2 <printint+0x98>
 488:	f426                	sd	s1,40(sp)
 48a:	377d                	addiw	a4,a4,-1
 48c:	00e984b3          	add	s1,s3,a4
 490:	19fd                	addi	s3,s3,-1
 492:	99ba                	add	s3,s3,a4
 494:	1702                	slli	a4,a4,0x20
 496:	9301                	srli	a4,a4,0x20
 498:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 49c:	0004c583          	lbu	a1,0(s1)
 4a0:	854a                	mv	a0,s2
 4a2:	00000097          	auipc	ra,0x0
 4a6:	f56080e7          	jalr	-170(ra) # 3f8 <putc>
  while(--i >= 0)
 4aa:	14fd                	addi	s1,s1,-1
 4ac:	ff3498e3          	bne	s1,s3,49c <printint+0x82>
 4b0:	74a2                	ld	s1,40(sp)
}
 4b2:	70e2                	ld	ra,56(sp)
 4b4:	7442                	ld	s0,48(sp)
 4b6:	7902                	ld	s2,32(sp)
 4b8:	69e2                	ld	s3,24(sp)
 4ba:	6121                	addi	sp,sp,64
 4bc:	8082                	ret
  neg = 0;
 4be:	4301                	li	t1,0
 4c0:	bf9d                	j	436 <printint+0x1c>

00000000000004c2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4c2:	715d                	addi	sp,sp,-80
 4c4:	e486                	sd	ra,72(sp)
 4c6:	e0a2                	sd	s0,64(sp)
 4c8:	f84a                	sd	s2,48(sp)
 4ca:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4cc:	0005c903          	lbu	s2,0(a1)
 4d0:	1a090b63          	beqz	s2,686 <vprintf+0x1c4>
 4d4:	fc26                	sd	s1,56(sp)
 4d6:	f44e                	sd	s3,40(sp)
 4d8:	f052                	sd	s4,32(sp)
 4da:	ec56                	sd	s5,24(sp)
 4dc:	e85a                	sd	s6,16(sp)
 4de:	e45e                	sd	s7,8(sp)
 4e0:	8aaa                	mv	s5,a0
 4e2:	8bb2                	mv	s7,a2
 4e4:	00158493          	addi	s1,a1,1
  state = 0;
 4e8:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4ea:	02500a13          	li	s4,37
 4ee:	4b55                	li	s6,21
 4f0:	a839                	j	50e <vprintf+0x4c>
        putc(fd, c);
 4f2:	85ca                	mv	a1,s2
 4f4:	8556                	mv	a0,s5
 4f6:	00000097          	auipc	ra,0x0
 4fa:	f02080e7          	jalr	-254(ra) # 3f8 <putc>
 4fe:	a019                	j	504 <vprintf+0x42>
    } else if(state == '%'){
 500:	01498d63          	beq	s3,s4,51a <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 504:	0485                	addi	s1,s1,1
 506:	fff4c903          	lbu	s2,-1(s1)
 50a:	16090863          	beqz	s2,67a <vprintf+0x1b8>
    if(state == 0){
 50e:	fe0999e3          	bnez	s3,500 <vprintf+0x3e>
      if(c == '%'){
 512:	ff4910e3          	bne	s2,s4,4f2 <vprintf+0x30>
        state = '%';
 516:	89d2                	mv	s3,s4
 518:	b7f5                	j	504 <vprintf+0x42>
      if(c == 'd'){
 51a:	13490563          	beq	s2,s4,644 <vprintf+0x182>
 51e:	f9d9079b          	addiw	a5,s2,-99
 522:	0ff7f793          	zext.b	a5,a5
 526:	12fb6863          	bltu	s6,a5,656 <vprintf+0x194>
 52a:	f9d9079b          	addiw	a5,s2,-99
 52e:	0ff7f713          	zext.b	a4,a5
 532:	12eb6263          	bltu	s6,a4,656 <vprintf+0x194>
 536:	00271793          	slli	a5,a4,0x2
 53a:	00000717          	auipc	a4,0x0
 53e:	3a670713          	addi	a4,a4,934 # 8e0 <malloc+0x166>
 542:	97ba                	add	a5,a5,a4
 544:	439c                	lw	a5,0(a5)
 546:	97ba                	add	a5,a5,a4
 548:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 54a:	008b8913          	addi	s2,s7,8
 54e:	4685                	li	a3,1
 550:	4629                	li	a2,10
 552:	000ba583          	lw	a1,0(s7)
 556:	8556                	mv	a0,s5
 558:	00000097          	auipc	ra,0x0
 55c:	ec2080e7          	jalr	-318(ra) # 41a <printint>
 560:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 562:	4981                	li	s3,0
 564:	b745                	j	504 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 566:	008b8913          	addi	s2,s7,8
 56a:	4681                	li	a3,0
 56c:	4629                	li	a2,10
 56e:	000ba583          	lw	a1,0(s7)
 572:	8556                	mv	a0,s5
 574:	00000097          	auipc	ra,0x0
 578:	ea6080e7          	jalr	-346(ra) # 41a <printint>
 57c:	8bca                	mv	s7,s2
      state = 0;
 57e:	4981                	li	s3,0
 580:	b751                	j	504 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 582:	008b8913          	addi	s2,s7,8
 586:	4681                	li	a3,0
 588:	4641                	li	a2,16
 58a:	000ba583          	lw	a1,0(s7)
 58e:	8556                	mv	a0,s5
 590:	00000097          	auipc	ra,0x0
 594:	e8a080e7          	jalr	-374(ra) # 41a <printint>
 598:	8bca                	mv	s7,s2
      state = 0;
 59a:	4981                	li	s3,0
 59c:	b7a5                	j	504 <vprintf+0x42>
 59e:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5a0:	008b8793          	addi	a5,s7,8
 5a4:	8c3e                	mv	s8,a5
 5a6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5aa:	03000593          	li	a1,48
 5ae:	8556                	mv	a0,s5
 5b0:	00000097          	auipc	ra,0x0
 5b4:	e48080e7          	jalr	-440(ra) # 3f8 <putc>
  putc(fd, 'x');
 5b8:	07800593          	li	a1,120
 5bc:	8556                	mv	a0,s5
 5be:	00000097          	auipc	ra,0x0
 5c2:	e3a080e7          	jalr	-454(ra) # 3f8 <putc>
 5c6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5c8:	00000b97          	auipc	s7,0x0
 5cc:	370b8b93          	addi	s7,s7,880 # 938 <digits>
 5d0:	03c9d793          	srli	a5,s3,0x3c
 5d4:	97de                	add	a5,a5,s7
 5d6:	0007c583          	lbu	a1,0(a5)
 5da:	8556                	mv	a0,s5
 5dc:	00000097          	auipc	ra,0x0
 5e0:	e1c080e7          	jalr	-484(ra) # 3f8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5e4:	0992                	slli	s3,s3,0x4
 5e6:	397d                	addiw	s2,s2,-1
 5e8:	fe0914e3          	bnez	s2,5d0 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 5ec:	8be2                	mv	s7,s8
      state = 0;
 5ee:	4981                	li	s3,0
 5f0:	6c02                	ld	s8,0(sp)
 5f2:	bf09                	j	504 <vprintf+0x42>
        s = va_arg(ap, char*);
 5f4:	008b8993          	addi	s3,s7,8
 5f8:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 5fc:	02090163          	beqz	s2,61e <vprintf+0x15c>
        while(*s != 0){
 600:	00094583          	lbu	a1,0(s2)
 604:	c9a5                	beqz	a1,674 <vprintf+0x1b2>
          putc(fd, *s);
 606:	8556                	mv	a0,s5
 608:	00000097          	auipc	ra,0x0
 60c:	df0080e7          	jalr	-528(ra) # 3f8 <putc>
          s++;
 610:	0905                	addi	s2,s2,1
        while(*s != 0){
 612:	00094583          	lbu	a1,0(s2)
 616:	f9e5                	bnez	a1,606 <vprintf+0x144>
        s = va_arg(ap, char*);
 618:	8bce                	mv	s7,s3
      state = 0;
 61a:	4981                	li	s3,0
 61c:	b5e5                	j	504 <vprintf+0x42>
          s = "(null)";
 61e:	00000917          	auipc	s2,0x0
 622:	2ba90913          	addi	s2,s2,698 # 8d8 <malloc+0x15e>
        while(*s != 0){
 626:	02800593          	li	a1,40
 62a:	bff1                	j	606 <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 62c:	008b8913          	addi	s2,s7,8
 630:	000bc583          	lbu	a1,0(s7)
 634:	8556                	mv	a0,s5
 636:	00000097          	auipc	ra,0x0
 63a:	dc2080e7          	jalr	-574(ra) # 3f8 <putc>
 63e:	8bca                	mv	s7,s2
      state = 0;
 640:	4981                	li	s3,0
 642:	b5c9                	j	504 <vprintf+0x42>
        putc(fd, c);
 644:	02500593          	li	a1,37
 648:	8556                	mv	a0,s5
 64a:	00000097          	auipc	ra,0x0
 64e:	dae080e7          	jalr	-594(ra) # 3f8 <putc>
      state = 0;
 652:	4981                	li	s3,0
 654:	bd45                	j	504 <vprintf+0x42>
        putc(fd, '%');
 656:	02500593          	li	a1,37
 65a:	8556                	mv	a0,s5
 65c:	00000097          	auipc	ra,0x0
 660:	d9c080e7          	jalr	-612(ra) # 3f8 <putc>
        putc(fd, c);
 664:	85ca                	mv	a1,s2
 666:	8556                	mv	a0,s5
 668:	00000097          	auipc	ra,0x0
 66c:	d90080e7          	jalr	-624(ra) # 3f8 <putc>
      state = 0;
 670:	4981                	li	s3,0
 672:	bd49                	j	504 <vprintf+0x42>
        s = va_arg(ap, char*);
 674:	8bce                	mv	s7,s3
      state = 0;
 676:	4981                	li	s3,0
 678:	b571                	j	504 <vprintf+0x42>
 67a:	74e2                	ld	s1,56(sp)
 67c:	79a2                	ld	s3,40(sp)
 67e:	7a02                	ld	s4,32(sp)
 680:	6ae2                	ld	s5,24(sp)
 682:	6b42                	ld	s6,16(sp)
 684:	6ba2                	ld	s7,8(sp)
    }
  }
}
 686:	60a6                	ld	ra,72(sp)
 688:	6406                	ld	s0,64(sp)
 68a:	7942                	ld	s2,48(sp)
 68c:	6161                	addi	sp,sp,80
 68e:	8082                	ret

0000000000000690 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 690:	715d                	addi	sp,sp,-80
 692:	ec06                	sd	ra,24(sp)
 694:	e822                	sd	s0,16(sp)
 696:	1000                	addi	s0,sp,32
 698:	e010                	sd	a2,0(s0)
 69a:	e414                	sd	a3,8(s0)
 69c:	e818                	sd	a4,16(s0)
 69e:	ec1c                	sd	a5,24(s0)
 6a0:	03043023          	sd	a6,32(s0)
 6a4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6a8:	8622                	mv	a2,s0
 6aa:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6ae:	00000097          	auipc	ra,0x0
 6b2:	e14080e7          	jalr	-492(ra) # 4c2 <vprintf>
}
 6b6:	60e2                	ld	ra,24(sp)
 6b8:	6442                	ld	s0,16(sp)
 6ba:	6161                	addi	sp,sp,80
 6bc:	8082                	ret

00000000000006be <printf>:

void
printf(const char *fmt, ...)
{
 6be:	711d                	addi	sp,sp,-96
 6c0:	ec06                	sd	ra,24(sp)
 6c2:	e822                	sd	s0,16(sp)
 6c4:	1000                	addi	s0,sp,32
 6c6:	e40c                	sd	a1,8(s0)
 6c8:	e810                	sd	a2,16(s0)
 6ca:	ec14                	sd	a3,24(s0)
 6cc:	f018                	sd	a4,32(s0)
 6ce:	f41c                	sd	a5,40(s0)
 6d0:	03043823          	sd	a6,48(s0)
 6d4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6d8:	00840613          	addi	a2,s0,8
 6dc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6e0:	85aa                	mv	a1,a0
 6e2:	4505                	li	a0,1
 6e4:	00000097          	auipc	ra,0x0
 6e8:	dde080e7          	jalr	-546(ra) # 4c2 <vprintf>
}
 6ec:	60e2                	ld	ra,24(sp)
 6ee:	6442                	ld	s0,16(sp)
 6f0:	6125                	addi	sp,sp,96
 6f2:	8082                	ret

00000000000006f4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6f4:	1141                	addi	sp,sp,-16
 6f6:	e406                	sd	ra,8(sp)
 6f8:	e022                	sd	s0,0(sp)
 6fa:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6fc:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 700:	00000797          	auipc	a5,0x0
 704:	2507b783          	ld	a5,592(a5) # 950 <freep>
 708:	a039                	j	716 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 70a:	6398                	ld	a4,0(a5)
 70c:	00e7e463          	bltu	a5,a4,714 <free+0x20>
 710:	00e6ea63          	bltu	a3,a4,724 <free+0x30>
{
 714:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 716:	fed7fae3          	bgeu	a5,a3,70a <free+0x16>
 71a:	6398                	ld	a4,0(a5)
 71c:	00e6e463          	bltu	a3,a4,724 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 720:	fee7eae3          	bltu	a5,a4,714 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 724:	ff852583          	lw	a1,-8(a0)
 728:	6390                	ld	a2,0(a5)
 72a:	02059813          	slli	a6,a1,0x20
 72e:	01c85713          	srli	a4,a6,0x1c
 732:	9736                	add	a4,a4,a3
 734:	02e60563          	beq	a2,a4,75e <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 738:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 73c:	4790                	lw	a2,8(a5)
 73e:	02061593          	slli	a1,a2,0x20
 742:	01c5d713          	srli	a4,a1,0x1c
 746:	973e                	add	a4,a4,a5
 748:	02e68263          	beq	a3,a4,76c <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 74c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 74e:	00000717          	auipc	a4,0x0
 752:	20f73123          	sd	a5,514(a4) # 950 <freep>
}
 756:	60a2                	ld	ra,8(sp)
 758:	6402                	ld	s0,0(sp)
 75a:	0141                	addi	sp,sp,16
 75c:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 75e:	4618                	lw	a4,8(a2)
 760:	9f2d                	addw	a4,a4,a1
 762:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 766:	6398                	ld	a4,0(a5)
 768:	6310                	ld	a2,0(a4)
 76a:	b7f9                	j	738 <free+0x44>
    p->s.size += bp->s.size;
 76c:	ff852703          	lw	a4,-8(a0)
 770:	9f31                	addw	a4,a4,a2
 772:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 774:	ff053683          	ld	a3,-16(a0)
 778:	bfd1                	j	74c <free+0x58>

000000000000077a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 77a:	7139                	addi	sp,sp,-64
 77c:	fc06                	sd	ra,56(sp)
 77e:	f822                	sd	s0,48(sp)
 780:	f04a                	sd	s2,32(sp)
 782:	ec4e                	sd	s3,24(sp)
 784:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 786:	02051993          	slli	s3,a0,0x20
 78a:	0209d993          	srli	s3,s3,0x20
 78e:	09bd                	addi	s3,s3,15
 790:	0049d993          	srli	s3,s3,0x4
 794:	2985                	addiw	s3,s3,1
 796:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 798:	00000517          	auipc	a0,0x0
 79c:	1b853503          	ld	a0,440(a0) # 950 <freep>
 7a0:	c905                	beqz	a0,7d0 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7a4:	4798                	lw	a4,8(a5)
 7a6:	09377a63          	bgeu	a4,s3,83a <malloc+0xc0>
 7aa:	f426                	sd	s1,40(sp)
 7ac:	e852                	sd	s4,16(sp)
 7ae:	e456                	sd	s5,8(sp)
 7b0:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7b2:	8a4e                	mv	s4,s3
 7b4:	6705                	lui	a4,0x1
 7b6:	00e9f363          	bgeu	s3,a4,7bc <malloc+0x42>
 7ba:	6a05                	lui	s4,0x1
 7bc:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7c0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7c4:	00000497          	auipc	s1,0x0
 7c8:	18c48493          	addi	s1,s1,396 # 950 <freep>
  if(p == (char*)-1)
 7cc:	5afd                	li	s5,-1
 7ce:	a089                	j	810 <malloc+0x96>
 7d0:	f426                	sd	s1,40(sp)
 7d2:	e852                	sd	s4,16(sp)
 7d4:	e456                	sd	s5,8(sp)
 7d6:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7d8:	00000797          	auipc	a5,0x0
 7dc:	18078793          	addi	a5,a5,384 # 958 <base>
 7e0:	00000717          	auipc	a4,0x0
 7e4:	16f73823          	sd	a5,368(a4) # 950 <freep>
 7e8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7ea:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7ee:	b7d1                	j	7b2 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 7f0:	6398                	ld	a4,0(a5)
 7f2:	e118                	sd	a4,0(a0)
 7f4:	a8b9                	j	852 <malloc+0xd8>
  hp->s.size = nu;
 7f6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7fa:	0541                	addi	a0,a0,16
 7fc:	00000097          	auipc	ra,0x0
 800:	ef8080e7          	jalr	-264(ra) # 6f4 <free>
  return freep;
 804:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 806:	c135                	beqz	a0,86a <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 808:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 80a:	4798                	lw	a4,8(a5)
 80c:	03277363          	bgeu	a4,s2,832 <malloc+0xb8>
    if(p == freep)
 810:	6098                	ld	a4,0(s1)
 812:	853e                	mv	a0,a5
 814:	fef71ae3          	bne	a4,a5,808 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 818:	8552                	mv	a0,s4
 81a:	00000097          	auipc	ra,0x0
 81e:	bbe080e7          	jalr	-1090(ra) # 3d8 <sbrk>
  if(p == (char*)-1)
 822:	fd551ae3          	bne	a0,s5,7f6 <malloc+0x7c>
        return 0;
 826:	4501                	li	a0,0
 828:	74a2                	ld	s1,40(sp)
 82a:	6a42                	ld	s4,16(sp)
 82c:	6aa2                	ld	s5,8(sp)
 82e:	6b02                	ld	s6,0(sp)
 830:	a03d                	j	85e <malloc+0xe4>
 832:	74a2                	ld	s1,40(sp)
 834:	6a42                	ld	s4,16(sp)
 836:	6aa2                	ld	s5,8(sp)
 838:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 83a:	fae90be3          	beq	s2,a4,7f0 <malloc+0x76>
        p->s.size -= nunits;
 83e:	4137073b          	subw	a4,a4,s3
 842:	c798                	sw	a4,8(a5)
        p += p->s.size;
 844:	02071693          	slli	a3,a4,0x20
 848:	01c6d713          	srli	a4,a3,0x1c
 84c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 84e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 852:	00000717          	auipc	a4,0x0
 856:	0ea73f23          	sd	a0,254(a4) # 950 <freep>
      return (void*)(p + 1);
 85a:	01078513          	addi	a0,a5,16
  }
}
 85e:	70e2                	ld	ra,56(sp)
 860:	7442                	ld	s0,48(sp)
 862:	7902                	ld	s2,32(sp)
 864:	69e2                	ld	s3,24(sp)
 866:	6121                	addi	sp,sp,64
 868:	8082                	ret
 86a:	74a2                	ld	s1,40(sp)
 86c:	6a42                	ld	s4,16(sp)
 86e:	6aa2                	ld	s5,8(sp)
 870:	6b02                	ld	s6,0(sp)
 872:	b7f5                	j	85e <malloc+0xe4>
