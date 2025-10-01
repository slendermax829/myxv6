
user/_time1:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
# include "kernel/types.h"
# include "kernel/stat.h"
# include "user/user.h"

int main(int argc, char *argv[]){
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32

    
    if(argc == 1){
   8:	4785                	li	a5,1
   a:	04f50763          	beq	a0,a5,58 <main+0x58>
   e:	e426                	sd	s1,8(sp)
  10:	e04a                	sd	s2,0(sp)
  12:	84ae                	mv	s1,a1
        printf("Usage: time1 [args]\n");
        exit(1);
    }

    int startTime = uptime();
  14:	00000097          	auipc	ra,0x0
  18:	3d4080e7          	jalr	980(ra) # 3e8 <uptime>
  1c:	892a                	mv	s2,a0

    int childPID = fork();
  1e:	00000097          	auipc	ra,0x0
  22:	32a080e7          	jalr	810(ra) # 348 <fork>

    if(childPID < 0){
  26:	04054863          	bltz	a0,76 <main+0x76>
        fprintf(2, "time1: fork failed\n");
        exit(1);
    }

    if(childPID == 0){
  2a:	e525                	bnez	a0,92 <main+0x92>

        exec(argv[1], &argv[1]);
  2c:	00848593          	addi	a1,s1,8
  30:	6488                	ld	a0,8(s1)
  32:	00000097          	auipc	ra,0x0
  36:	356080e7          	jalr	854(ra) # 388 <exec>

        fprintf(2, "time1: exec %s failed\n", argv[1]);
  3a:	6490                	ld	a2,8(s1)
  3c:	00001597          	auipc	a1,0x1
  40:	87458593          	addi	a1,a1,-1932 # 8b0 <malloc+0x12e>
  44:	4509                	li	a0,2
  46:	00000097          	auipc	ra,0x0
  4a:	652080e7          	jalr	1618(ra) # 698 <fprintf>
        exit(1);
  4e:	4505                	li	a0,1
  50:	00000097          	auipc	ra,0x0
  54:	300080e7          	jalr	768(ra) # 350 <exit>
  58:	e426                	sd	s1,8(sp)
  5a:	e04a                	sd	s2,0(sp)
        printf("Usage: time1 [args]\n");
  5c:	00001517          	auipc	a0,0x1
  60:	82450513          	addi	a0,a0,-2012 # 880 <malloc+0xfe>
  64:	00000097          	auipc	ra,0x0
  68:	662080e7          	jalr	1634(ra) # 6c6 <printf>
        exit(1);
  6c:	4505                	li	a0,1
  6e:	00000097          	auipc	ra,0x0
  72:	2e2080e7          	jalr	738(ra) # 350 <exit>
        fprintf(2, "time1: fork failed\n");
  76:	00001597          	auipc	a1,0x1
  7a:	82258593          	addi	a1,a1,-2014 # 898 <malloc+0x116>
  7e:	4509                	li	a0,2
  80:	00000097          	auipc	ra,0x0
  84:	618080e7          	jalr	1560(ra) # 698 <fprintf>
        exit(1);
  88:	4505                	li	a0,1
  8a:	00000097          	auipc	ra,0x0
  8e:	2c6080e7          	jalr	710(ra) # 350 <exit>
       

    } else {
        
       wait(0);
  92:	4501                	li	a0,0
  94:	00000097          	auipc	ra,0x0
  98:	2c4080e7          	jalr	708(ra) # 358 <wait>

       int parentTime = uptime();
  9c:	00000097          	auipc	ra,0x0
  a0:	34c080e7          	jalr	844(ra) # 3e8 <uptime>
       
       printf("Time elapsed: %d ticks\n", parentTime - startTime);
  a4:	412505bb          	subw	a1,a0,s2
  a8:	00001517          	auipc	a0,0x1
  ac:	82050513          	addi	a0,a0,-2016 # 8c8 <malloc+0x146>
  b0:	00000097          	auipc	ra,0x0
  b4:	616080e7          	jalr	1558(ra) # 6c6 <printf>

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

00000000000003f0 <cputime>:
.global cputime
cputime:
 li a7, SYS_cputime
 3f0:	48d9                	li	a7,22
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <wait2>:
.global wait2
wait2:
 li a7, SYS_wait2
 3f8:	48dd                	li	a7,23
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 400:	1101                	addi	sp,sp,-32
 402:	ec06                	sd	ra,24(sp)
 404:	e822                	sd	s0,16(sp)
 406:	1000                	addi	s0,sp,32
 408:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 40c:	4605                	li	a2,1
 40e:	fef40593          	addi	a1,s0,-17
 412:	00000097          	auipc	ra,0x0
 416:	f5e080e7          	jalr	-162(ra) # 370 <write>
}
 41a:	60e2                	ld	ra,24(sp)
 41c:	6442                	ld	s0,16(sp)
 41e:	6105                	addi	sp,sp,32
 420:	8082                	ret

0000000000000422 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 422:	7139                	addi	sp,sp,-64
 424:	fc06                	sd	ra,56(sp)
 426:	f822                	sd	s0,48(sp)
 428:	f04a                	sd	s2,32(sp)
 42a:	ec4e                	sd	s3,24(sp)
 42c:	0080                	addi	s0,sp,64
 42e:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 430:	cad9                	beqz	a3,4c6 <printint+0xa4>
 432:	01f5d79b          	srliw	a5,a1,0x1f
 436:	cbc1                	beqz	a5,4c6 <printint+0xa4>
    neg = 1;
    x = -xx;
 438:	40b005bb          	negw	a1,a1
    neg = 1;
 43c:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 43e:	fc040993          	addi	s3,s0,-64
  neg = 0;
 442:	86ce                	mv	a3,s3
  i = 0;
 444:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 446:	00000817          	auipc	a6,0x0
 44a:	4fa80813          	addi	a6,a6,1274 # 940 <digits>
 44e:	88ba                	mv	a7,a4
 450:	0017051b          	addiw	a0,a4,1
 454:	872a                	mv	a4,a0
 456:	02c5f7bb          	remuw	a5,a1,a2
 45a:	1782                	slli	a5,a5,0x20
 45c:	9381                	srli	a5,a5,0x20
 45e:	97c2                	add	a5,a5,a6
 460:	0007c783          	lbu	a5,0(a5)
 464:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 468:	87ae                	mv	a5,a1
 46a:	02c5d5bb          	divuw	a1,a1,a2
 46e:	0685                	addi	a3,a3,1
 470:	fcc7ffe3          	bgeu	a5,a2,44e <printint+0x2c>
  if(neg)
 474:	00030c63          	beqz	t1,48c <printint+0x6a>
    buf[i++] = '-';
 478:	fd050793          	addi	a5,a0,-48
 47c:	00878533          	add	a0,a5,s0
 480:	02d00793          	li	a5,45
 484:	fef50823          	sb	a5,-16(a0)
 488:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 48c:	02e05763          	blez	a4,4ba <printint+0x98>
 490:	f426                	sd	s1,40(sp)
 492:	377d                	addiw	a4,a4,-1
 494:	00e984b3          	add	s1,s3,a4
 498:	19fd                	addi	s3,s3,-1
 49a:	99ba                	add	s3,s3,a4
 49c:	1702                	slli	a4,a4,0x20
 49e:	9301                	srli	a4,a4,0x20
 4a0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4a4:	0004c583          	lbu	a1,0(s1)
 4a8:	854a                	mv	a0,s2
 4aa:	00000097          	auipc	ra,0x0
 4ae:	f56080e7          	jalr	-170(ra) # 400 <putc>
  while(--i >= 0)
 4b2:	14fd                	addi	s1,s1,-1
 4b4:	ff3498e3          	bne	s1,s3,4a4 <printint+0x82>
 4b8:	74a2                	ld	s1,40(sp)
}
 4ba:	70e2                	ld	ra,56(sp)
 4bc:	7442                	ld	s0,48(sp)
 4be:	7902                	ld	s2,32(sp)
 4c0:	69e2                	ld	s3,24(sp)
 4c2:	6121                	addi	sp,sp,64
 4c4:	8082                	ret
  neg = 0;
 4c6:	4301                	li	t1,0
 4c8:	bf9d                	j	43e <printint+0x1c>

00000000000004ca <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4ca:	715d                	addi	sp,sp,-80
 4cc:	e486                	sd	ra,72(sp)
 4ce:	e0a2                	sd	s0,64(sp)
 4d0:	f84a                	sd	s2,48(sp)
 4d2:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4d4:	0005c903          	lbu	s2,0(a1)
 4d8:	1a090b63          	beqz	s2,68e <vprintf+0x1c4>
 4dc:	fc26                	sd	s1,56(sp)
 4de:	f44e                	sd	s3,40(sp)
 4e0:	f052                	sd	s4,32(sp)
 4e2:	ec56                	sd	s5,24(sp)
 4e4:	e85a                	sd	s6,16(sp)
 4e6:	e45e                	sd	s7,8(sp)
 4e8:	8aaa                	mv	s5,a0
 4ea:	8bb2                	mv	s7,a2
 4ec:	00158493          	addi	s1,a1,1
  state = 0;
 4f0:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4f2:	02500a13          	li	s4,37
 4f6:	4b55                	li	s6,21
 4f8:	a839                	j	516 <vprintf+0x4c>
        putc(fd, c);
 4fa:	85ca                	mv	a1,s2
 4fc:	8556                	mv	a0,s5
 4fe:	00000097          	auipc	ra,0x0
 502:	f02080e7          	jalr	-254(ra) # 400 <putc>
 506:	a019                	j	50c <vprintf+0x42>
    } else if(state == '%'){
 508:	01498d63          	beq	s3,s4,522 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 50c:	0485                	addi	s1,s1,1
 50e:	fff4c903          	lbu	s2,-1(s1)
 512:	16090863          	beqz	s2,682 <vprintf+0x1b8>
    if(state == 0){
 516:	fe0999e3          	bnez	s3,508 <vprintf+0x3e>
      if(c == '%'){
 51a:	ff4910e3          	bne	s2,s4,4fa <vprintf+0x30>
        state = '%';
 51e:	89d2                	mv	s3,s4
 520:	b7f5                	j	50c <vprintf+0x42>
      if(c == 'd'){
 522:	13490563          	beq	s2,s4,64c <vprintf+0x182>
 526:	f9d9079b          	addiw	a5,s2,-99
 52a:	0ff7f793          	zext.b	a5,a5
 52e:	12fb6863          	bltu	s6,a5,65e <vprintf+0x194>
 532:	f9d9079b          	addiw	a5,s2,-99
 536:	0ff7f713          	zext.b	a4,a5
 53a:	12eb6263          	bltu	s6,a4,65e <vprintf+0x194>
 53e:	00271793          	slli	a5,a4,0x2
 542:	00000717          	auipc	a4,0x0
 546:	3a670713          	addi	a4,a4,934 # 8e8 <malloc+0x166>
 54a:	97ba                	add	a5,a5,a4
 54c:	439c                	lw	a5,0(a5)
 54e:	97ba                	add	a5,a5,a4
 550:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 552:	008b8913          	addi	s2,s7,8
 556:	4685                	li	a3,1
 558:	4629                	li	a2,10
 55a:	000ba583          	lw	a1,0(s7)
 55e:	8556                	mv	a0,s5
 560:	00000097          	auipc	ra,0x0
 564:	ec2080e7          	jalr	-318(ra) # 422 <printint>
 568:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 56a:	4981                	li	s3,0
 56c:	b745                	j	50c <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 56e:	008b8913          	addi	s2,s7,8
 572:	4681                	li	a3,0
 574:	4629                	li	a2,10
 576:	000ba583          	lw	a1,0(s7)
 57a:	8556                	mv	a0,s5
 57c:	00000097          	auipc	ra,0x0
 580:	ea6080e7          	jalr	-346(ra) # 422 <printint>
 584:	8bca                	mv	s7,s2
      state = 0;
 586:	4981                	li	s3,0
 588:	b751                	j	50c <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 58a:	008b8913          	addi	s2,s7,8
 58e:	4681                	li	a3,0
 590:	4641                	li	a2,16
 592:	000ba583          	lw	a1,0(s7)
 596:	8556                	mv	a0,s5
 598:	00000097          	auipc	ra,0x0
 59c:	e8a080e7          	jalr	-374(ra) # 422 <printint>
 5a0:	8bca                	mv	s7,s2
      state = 0;
 5a2:	4981                	li	s3,0
 5a4:	b7a5                	j	50c <vprintf+0x42>
 5a6:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5a8:	008b8793          	addi	a5,s7,8
 5ac:	8c3e                	mv	s8,a5
 5ae:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5b2:	03000593          	li	a1,48
 5b6:	8556                	mv	a0,s5
 5b8:	00000097          	auipc	ra,0x0
 5bc:	e48080e7          	jalr	-440(ra) # 400 <putc>
  putc(fd, 'x');
 5c0:	07800593          	li	a1,120
 5c4:	8556                	mv	a0,s5
 5c6:	00000097          	auipc	ra,0x0
 5ca:	e3a080e7          	jalr	-454(ra) # 400 <putc>
 5ce:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5d0:	00000b97          	auipc	s7,0x0
 5d4:	370b8b93          	addi	s7,s7,880 # 940 <digits>
 5d8:	03c9d793          	srli	a5,s3,0x3c
 5dc:	97de                	add	a5,a5,s7
 5de:	0007c583          	lbu	a1,0(a5)
 5e2:	8556                	mv	a0,s5
 5e4:	00000097          	auipc	ra,0x0
 5e8:	e1c080e7          	jalr	-484(ra) # 400 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5ec:	0992                	slli	s3,s3,0x4
 5ee:	397d                	addiw	s2,s2,-1
 5f0:	fe0914e3          	bnez	s2,5d8 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 5f4:	8be2                	mv	s7,s8
      state = 0;
 5f6:	4981                	li	s3,0
 5f8:	6c02                	ld	s8,0(sp)
 5fa:	bf09                	j	50c <vprintf+0x42>
        s = va_arg(ap, char*);
 5fc:	008b8993          	addi	s3,s7,8
 600:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 604:	02090163          	beqz	s2,626 <vprintf+0x15c>
        while(*s != 0){
 608:	00094583          	lbu	a1,0(s2)
 60c:	c9a5                	beqz	a1,67c <vprintf+0x1b2>
          putc(fd, *s);
 60e:	8556                	mv	a0,s5
 610:	00000097          	auipc	ra,0x0
 614:	df0080e7          	jalr	-528(ra) # 400 <putc>
          s++;
 618:	0905                	addi	s2,s2,1
        while(*s != 0){
 61a:	00094583          	lbu	a1,0(s2)
 61e:	f9e5                	bnez	a1,60e <vprintf+0x144>
        s = va_arg(ap, char*);
 620:	8bce                	mv	s7,s3
      state = 0;
 622:	4981                	li	s3,0
 624:	b5e5                	j	50c <vprintf+0x42>
          s = "(null)";
 626:	00000917          	auipc	s2,0x0
 62a:	2ba90913          	addi	s2,s2,698 # 8e0 <malloc+0x15e>
        while(*s != 0){
 62e:	02800593          	li	a1,40
 632:	bff1                	j	60e <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 634:	008b8913          	addi	s2,s7,8
 638:	000bc583          	lbu	a1,0(s7)
 63c:	8556                	mv	a0,s5
 63e:	00000097          	auipc	ra,0x0
 642:	dc2080e7          	jalr	-574(ra) # 400 <putc>
 646:	8bca                	mv	s7,s2
      state = 0;
 648:	4981                	li	s3,0
 64a:	b5c9                	j	50c <vprintf+0x42>
        putc(fd, c);
 64c:	02500593          	li	a1,37
 650:	8556                	mv	a0,s5
 652:	00000097          	auipc	ra,0x0
 656:	dae080e7          	jalr	-594(ra) # 400 <putc>
      state = 0;
 65a:	4981                	li	s3,0
 65c:	bd45                	j	50c <vprintf+0x42>
        putc(fd, '%');
 65e:	02500593          	li	a1,37
 662:	8556                	mv	a0,s5
 664:	00000097          	auipc	ra,0x0
 668:	d9c080e7          	jalr	-612(ra) # 400 <putc>
        putc(fd, c);
 66c:	85ca                	mv	a1,s2
 66e:	8556                	mv	a0,s5
 670:	00000097          	auipc	ra,0x0
 674:	d90080e7          	jalr	-624(ra) # 400 <putc>
      state = 0;
 678:	4981                	li	s3,0
 67a:	bd49                	j	50c <vprintf+0x42>
        s = va_arg(ap, char*);
 67c:	8bce                	mv	s7,s3
      state = 0;
 67e:	4981                	li	s3,0
 680:	b571                	j	50c <vprintf+0x42>
 682:	74e2                	ld	s1,56(sp)
 684:	79a2                	ld	s3,40(sp)
 686:	7a02                	ld	s4,32(sp)
 688:	6ae2                	ld	s5,24(sp)
 68a:	6b42                	ld	s6,16(sp)
 68c:	6ba2                	ld	s7,8(sp)
    }
  }
}
 68e:	60a6                	ld	ra,72(sp)
 690:	6406                	ld	s0,64(sp)
 692:	7942                	ld	s2,48(sp)
 694:	6161                	addi	sp,sp,80
 696:	8082                	ret

0000000000000698 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 698:	715d                	addi	sp,sp,-80
 69a:	ec06                	sd	ra,24(sp)
 69c:	e822                	sd	s0,16(sp)
 69e:	1000                	addi	s0,sp,32
 6a0:	e010                	sd	a2,0(s0)
 6a2:	e414                	sd	a3,8(s0)
 6a4:	e818                	sd	a4,16(s0)
 6a6:	ec1c                	sd	a5,24(s0)
 6a8:	03043023          	sd	a6,32(s0)
 6ac:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6b0:	8622                	mv	a2,s0
 6b2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6b6:	00000097          	auipc	ra,0x0
 6ba:	e14080e7          	jalr	-492(ra) # 4ca <vprintf>
}
 6be:	60e2                	ld	ra,24(sp)
 6c0:	6442                	ld	s0,16(sp)
 6c2:	6161                	addi	sp,sp,80
 6c4:	8082                	ret

00000000000006c6 <printf>:

void
printf(const char *fmt, ...)
{
 6c6:	711d                	addi	sp,sp,-96
 6c8:	ec06                	sd	ra,24(sp)
 6ca:	e822                	sd	s0,16(sp)
 6cc:	1000                	addi	s0,sp,32
 6ce:	e40c                	sd	a1,8(s0)
 6d0:	e810                	sd	a2,16(s0)
 6d2:	ec14                	sd	a3,24(s0)
 6d4:	f018                	sd	a4,32(s0)
 6d6:	f41c                	sd	a5,40(s0)
 6d8:	03043823          	sd	a6,48(s0)
 6dc:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6e0:	00840613          	addi	a2,s0,8
 6e4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6e8:	85aa                	mv	a1,a0
 6ea:	4505                	li	a0,1
 6ec:	00000097          	auipc	ra,0x0
 6f0:	dde080e7          	jalr	-546(ra) # 4ca <vprintf>
}
 6f4:	60e2                	ld	ra,24(sp)
 6f6:	6442                	ld	s0,16(sp)
 6f8:	6125                	addi	sp,sp,96
 6fa:	8082                	ret

00000000000006fc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6fc:	1141                	addi	sp,sp,-16
 6fe:	e406                	sd	ra,8(sp)
 700:	e022                	sd	s0,0(sp)
 702:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 704:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 708:	00000797          	auipc	a5,0x0
 70c:	2507b783          	ld	a5,592(a5) # 958 <freep>
 710:	a039                	j	71e <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 712:	6398                	ld	a4,0(a5)
 714:	00e7e463          	bltu	a5,a4,71c <free+0x20>
 718:	00e6ea63          	bltu	a3,a4,72c <free+0x30>
{
 71c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 71e:	fed7fae3          	bgeu	a5,a3,712 <free+0x16>
 722:	6398                	ld	a4,0(a5)
 724:	00e6e463          	bltu	a3,a4,72c <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 728:	fee7eae3          	bltu	a5,a4,71c <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 72c:	ff852583          	lw	a1,-8(a0)
 730:	6390                	ld	a2,0(a5)
 732:	02059813          	slli	a6,a1,0x20
 736:	01c85713          	srli	a4,a6,0x1c
 73a:	9736                	add	a4,a4,a3
 73c:	02e60563          	beq	a2,a4,766 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 740:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 744:	4790                	lw	a2,8(a5)
 746:	02061593          	slli	a1,a2,0x20
 74a:	01c5d713          	srli	a4,a1,0x1c
 74e:	973e                	add	a4,a4,a5
 750:	02e68263          	beq	a3,a4,774 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 754:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 756:	00000717          	auipc	a4,0x0
 75a:	20f73123          	sd	a5,514(a4) # 958 <freep>
}
 75e:	60a2                	ld	ra,8(sp)
 760:	6402                	ld	s0,0(sp)
 762:	0141                	addi	sp,sp,16
 764:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 766:	4618                	lw	a4,8(a2)
 768:	9f2d                	addw	a4,a4,a1
 76a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 76e:	6398                	ld	a4,0(a5)
 770:	6310                	ld	a2,0(a4)
 772:	b7f9                	j	740 <free+0x44>
    p->s.size += bp->s.size;
 774:	ff852703          	lw	a4,-8(a0)
 778:	9f31                	addw	a4,a4,a2
 77a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 77c:	ff053683          	ld	a3,-16(a0)
 780:	bfd1                	j	754 <free+0x58>

0000000000000782 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 782:	7139                	addi	sp,sp,-64
 784:	fc06                	sd	ra,56(sp)
 786:	f822                	sd	s0,48(sp)
 788:	f04a                	sd	s2,32(sp)
 78a:	ec4e                	sd	s3,24(sp)
 78c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 78e:	02051993          	slli	s3,a0,0x20
 792:	0209d993          	srli	s3,s3,0x20
 796:	09bd                	addi	s3,s3,15
 798:	0049d993          	srli	s3,s3,0x4
 79c:	2985                	addiw	s3,s3,1
 79e:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 7a0:	00000517          	auipc	a0,0x0
 7a4:	1b853503          	ld	a0,440(a0) # 958 <freep>
 7a8:	c905                	beqz	a0,7d8 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7aa:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7ac:	4798                	lw	a4,8(a5)
 7ae:	09377a63          	bgeu	a4,s3,842 <malloc+0xc0>
 7b2:	f426                	sd	s1,40(sp)
 7b4:	e852                	sd	s4,16(sp)
 7b6:	e456                	sd	s5,8(sp)
 7b8:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7ba:	8a4e                	mv	s4,s3
 7bc:	6705                	lui	a4,0x1
 7be:	00e9f363          	bgeu	s3,a4,7c4 <malloc+0x42>
 7c2:	6a05                	lui	s4,0x1
 7c4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7c8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7cc:	00000497          	auipc	s1,0x0
 7d0:	18c48493          	addi	s1,s1,396 # 958 <freep>
  if(p == (char*)-1)
 7d4:	5afd                	li	s5,-1
 7d6:	a089                	j	818 <malloc+0x96>
 7d8:	f426                	sd	s1,40(sp)
 7da:	e852                	sd	s4,16(sp)
 7dc:	e456                	sd	s5,8(sp)
 7de:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7e0:	00000797          	auipc	a5,0x0
 7e4:	18078793          	addi	a5,a5,384 # 960 <base>
 7e8:	00000717          	auipc	a4,0x0
 7ec:	16f73823          	sd	a5,368(a4) # 958 <freep>
 7f0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7f2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7f6:	b7d1                	j	7ba <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 7f8:	6398                	ld	a4,0(a5)
 7fa:	e118                	sd	a4,0(a0)
 7fc:	a8b9                	j	85a <malloc+0xd8>
  hp->s.size = nu;
 7fe:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 802:	0541                	addi	a0,a0,16
 804:	00000097          	auipc	ra,0x0
 808:	ef8080e7          	jalr	-264(ra) # 6fc <free>
  return freep;
 80c:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 80e:	c135                	beqz	a0,872 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 810:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 812:	4798                	lw	a4,8(a5)
 814:	03277363          	bgeu	a4,s2,83a <malloc+0xb8>
    if(p == freep)
 818:	6098                	ld	a4,0(s1)
 81a:	853e                	mv	a0,a5
 81c:	fef71ae3          	bne	a4,a5,810 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 820:	8552                	mv	a0,s4
 822:	00000097          	auipc	ra,0x0
 826:	bb6080e7          	jalr	-1098(ra) # 3d8 <sbrk>
  if(p == (char*)-1)
 82a:	fd551ae3          	bne	a0,s5,7fe <malloc+0x7c>
        return 0;
 82e:	4501                	li	a0,0
 830:	74a2                	ld	s1,40(sp)
 832:	6a42                	ld	s4,16(sp)
 834:	6aa2                	ld	s5,8(sp)
 836:	6b02                	ld	s6,0(sp)
 838:	a03d                	j	866 <malloc+0xe4>
 83a:	74a2                	ld	s1,40(sp)
 83c:	6a42                	ld	s4,16(sp)
 83e:	6aa2                	ld	s5,8(sp)
 840:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 842:	fae90be3          	beq	s2,a4,7f8 <malloc+0x76>
        p->s.size -= nunits;
 846:	4137073b          	subw	a4,a4,s3
 84a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 84c:	02071693          	slli	a3,a4,0x20
 850:	01c6d713          	srli	a4,a3,0x1c
 854:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 856:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 85a:	00000717          	auipc	a4,0x0
 85e:	0ea73f23          	sd	a0,254(a4) # 958 <freep>
      return (void*)(p + 1);
 862:	01078513          	addi	a0,a5,16
  }
}
 866:	70e2                	ld	ra,56(sp)
 868:	7442                	ld	s0,48(sp)
 86a:	7902                	ld	s2,32(sp)
 86c:	69e2                	ld	s3,24(sp)
 86e:	6121                	addi	sp,sp,64
 870:	8082                	ret
 872:	74a2                	ld	s1,40(sp)
 874:	6a42                	ld	s4,16(sp)
 876:	6aa2                	ld	s5,8(sp)
 878:	6b02                	ld	s6,0(sp)
 87a:	b7f5                	j	866 <malloc+0xe4>
