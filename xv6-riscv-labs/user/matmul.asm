
user/_matmul:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "user/user.h"

#define ROWS 1000
#define COLUMNS 1000

int main(int argc, char **argv) {
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	84aa                	mv	s1,a0
  10:	89ae                	mv	s3,a1
  double a[ROWS][COLUMNS];
  double b[ROWS][COLUMNS];
  double c[ROWS][COLUMNS];
 
  /* Start timing */
  int start_time = uptime(); 
  12:	00000097          	auipc	ra,0x0
  16:	39c080e7          	jalr	924(ra) # 3ae <uptime>
  1a:	892a                	mv	s2,a0

  iterations = 1;
  if (argc == 2)
  1c:	4789                	li	a5,2
  iterations = 1;
  1e:	4605                	li	a2,1
  if (argc == 2)
  20:	04f48a63          	beq	s1,a5,74 <main+0x74>
  iterations = 1;
  24:	4581                	li	a1,0
int main(int argc, char **argv) {
  26:	3e800693          	li	a3,1000
  2a:	8736                	mv	a4,a3
  2c:	87b6                	mv	a5,a3
    iterations = atoi(argv[1]);

  for (ii = 0; ii < iterations; ii++) {
  /* Initialize */
  for (i=0; i<ROWS; i++) {
    for (j=0; j<COLUMNS; j++) {
  2e:	37fd                	addiw	a5,a5,-1
  30:	fffd                	bnez	a5,2e <main+0x2e>
  for (i=0; i<ROWS; i++) {
  32:	377d                	addiw	a4,a4,-1
  34:	ff65                	bnez	a4,2c <main+0x2c>
  36:	8536                	mv	a0,a3
int main(int argc, char **argv) {
  38:	8736                	mv	a4,a3
  3a:	87b6                	mv	a5,a3
    Multiply Matrices 
    (SQUARE)
  */
  for (i=0; i<ROWS; i++) {
    for (j=0; j<COLUMNS; j++) {
      for (k=0; k<COLUMNS; k++) {
  3c:	37fd                	addiw	a5,a5,-1
  3e:	fffd                	bnez	a5,3c <main+0x3c>
    for (j=0; j<COLUMNS; j++) {
  40:	377d                	addiw	a4,a4,-1
  42:	ff65                	bnez	a4,3a <main+0x3a>
  for (i=0; i<ROWS; i++) {
  44:	357d                	addiw	a0,a0,-1
  46:	f96d                	bnez	a0,38 <main+0x38>
  for (ii = 0; ii < iterations; ii++) {
  48:	2585                	addiw	a1,a1,1
  4a:	fec590e3          	bne	a1,a2,2a <main+0x2a>
      printf("\n");
    }
  }
  }
  /* Stop Timing */
  int end_time = uptime();
  4e:	00000097          	auipc	ra,0x0
  52:	360080e7          	jalr	864(ra) # 3ae <uptime>

  /* Report Time */
  printf("Time: %d ticks\n", end_time - start_time);
  56:	412505bb          	subw	a1,a0,s2
  5a:	00000517          	auipc	a0,0x0
  5e:	7e650513          	addi	a0,a0,2022 # 840 <malloc+0x100>
  62:	00000097          	auipc	ra,0x0
  66:	622080e7          	jalr	1570(ra) # 684 <printf>

  exit(0);
  6a:	4501                	li	a0,0
  6c:	00000097          	auipc	ra,0x0
  70:	2aa080e7          	jalr	682(ra) # 316 <exit>
    iterations = atoi(argv[1]);
  74:	0089b503          	ld	a0,8(s3)
  78:	00000097          	auipc	ra,0x0
  7c:	19c080e7          	jalr	412(ra) # 214 <atoi>
  80:	862a                	mv	a2,a0
  for (ii = 0; ii < iterations; ii++) {
  82:	fca056e3          	blez	a0,4e <main+0x4e>
  86:	bf79                	j	24 <main+0x24>

0000000000000088 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  88:	1141                	addi	sp,sp,-16
  8a:	e406                	sd	ra,8(sp)
  8c:	e022                	sd	s0,0(sp)
  8e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  90:	87aa                	mv	a5,a0
  92:	0585                	addi	a1,a1,1
  94:	0785                	addi	a5,a5,1
  96:	fff5c703          	lbu	a4,-1(a1)
  9a:	fee78fa3          	sb	a4,-1(a5)
  9e:	fb75                	bnez	a4,92 <strcpy+0xa>
    ;
  return os;
}
  a0:	60a2                	ld	ra,8(sp)
  a2:	6402                	ld	s0,0(sp)
  a4:	0141                	addi	sp,sp,16
  a6:	8082                	ret

00000000000000a8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  a8:	1141                	addi	sp,sp,-16
  aa:	e406                	sd	ra,8(sp)
  ac:	e022                	sd	s0,0(sp)
  ae:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  b0:	00054783          	lbu	a5,0(a0)
  b4:	cb91                	beqz	a5,c8 <strcmp+0x20>
  b6:	0005c703          	lbu	a4,0(a1)
  ba:	00f71763          	bne	a4,a5,c8 <strcmp+0x20>
    p++, q++;
  be:	0505                	addi	a0,a0,1
  c0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  c2:	00054783          	lbu	a5,0(a0)
  c6:	fbe5                	bnez	a5,b6 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  c8:	0005c503          	lbu	a0,0(a1)
}
  cc:	40a7853b          	subw	a0,a5,a0
  d0:	60a2                	ld	ra,8(sp)
  d2:	6402                	ld	s0,0(sp)
  d4:	0141                	addi	sp,sp,16
  d6:	8082                	ret

00000000000000d8 <strlen>:

uint
strlen(const char *s)
{
  d8:	1141                	addi	sp,sp,-16
  da:	e406                	sd	ra,8(sp)
  dc:	e022                	sd	s0,0(sp)
  de:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  e0:	00054783          	lbu	a5,0(a0)
  e4:	cf91                	beqz	a5,100 <strlen+0x28>
  e6:	00150793          	addi	a5,a0,1
  ea:	86be                	mv	a3,a5
  ec:	0785                	addi	a5,a5,1
  ee:	fff7c703          	lbu	a4,-1(a5)
  f2:	ff65                	bnez	a4,ea <strlen+0x12>
  f4:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  f8:	60a2                	ld	ra,8(sp)
  fa:	6402                	ld	s0,0(sp)
  fc:	0141                	addi	sp,sp,16
  fe:	8082                	ret
  for(n = 0; s[n]; n++)
 100:	4501                	li	a0,0
 102:	bfdd                	j	f8 <strlen+0x20>

0000000000000104 <memset>:

void*
memset(void *dst, int c, uint n)
{
 104:	1141                	addi	sp,sp,-16
 106:	e406                	sd	ra,8(sp)
 108:	e022                	sd	s0,0(sp)
 10a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 10c:	ca19                	beqz	a2,122 <memset+0x1e>
 10e:	87aa                	mv	a5,a0
 110:	1602                	slli	a2,a2,0x20
 112:	9201                	srli	a2,a2,0x20
 114:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 118:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 11c:	0785                	addi	a5,a5,1
 11e:	fee79de3          	bne	a5,a4,118 <memset+0x14>
  }
  return dst;
}
 122:	60a2                	ld	ra,8(sp)
 124:	6402                	ld	s0,0(sp)
 126:	0141                	addi	sp,sp,16
 128:	8082                	ret

000000000000012a <strchr>:

char*
strchr(const char *s, char c)
{
 12a:	1141                	addi	sp,sp,-16
 12c:	e406                	sd	ra,8(sp)
 12e:	e022                	sd	s0,0(sp)
 130:	0800                	addi	s0,sp,16
  for(; *s; s++)
 132:	00054783          	lbu	a5,0(a0)
 136:	cf81                	beqz	a5,14e <strchr+0x24>
    if(*s == c)
 138:	00f58763          	beq	a1,a5,146 <strchr+0x1c>
  for(; *s; s++)
 13c:	0505                	addi	a0,a0,1
 13e:	00054783          	lbu	a5,0(a0)
 142:	fbfd                	bnez	a5,138 <strchr+0xe>
      return (char*)s;
  return 0;
 144:	4501                	li	a0,0
}
 146:	60a2                	ld	ra,8(sp)
 148:	6402                	ld	s0,0(sp)
 14a:	0141                	addi	sp,sp,16
 14c:	8082                	ret
  return 0;
 14e:	4501                	li	a0,0
 150:	bfdd                	j	146 <strchr+0x1c>

0000000000000152 <gets>:

char*
gets(char *buf, int max)
{
 152:	711d                	addi	sp,sp,-96
 154:	ec86                	sd	ra,88(sp)
 156:	e8a2                	sd	s0,80(sp)
 158:	e4a6                	sd	s1,72(sp)
 15a:	e0ca                	sd	s2,64(sp)
 15c:	fc4e                	sd	s3,56(sp)
 15e:	f852                	sd	s4,48(sp)
 160:	f456                	sd	s5,40(sp)
 162:	f05a                	sd	s6,32(sp)
 164:	ec5e                	sd	s7,24(sp)
 166:	e862                	sd	s8,16(sp)
 168:	1080                	addi	s0,sp,96
 16a:	8baa                	mv	s7,a0
 16c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 16e:	892a                	mv	s2,a0
 170:	4481                	li	s1,0
    cc = read(0, &c, 1);
 172:	faf40b13          	addi	s6,s0,-81
 176:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 178:	8c26                	mv	s8,s1
 17a:	0014899b          	addiw	s3,s1,1
 17e:	84ce                	mv	s1,s3
 180:	0349d663          	bge	s3,s4,1ac <gets+0x5a>
    cc = read(0, &c, 1);
 184:	8656                	mv	a2,s5
 186:	85da                	mv	a1,s6
 188:	4501                	li	a0,0
 18a:	00000097          	auipc	ra,0x0
 18e:	1a4080e7          	jalr	420(ra) # 32e <read>
    if(cc < 1)
 192:	00a05d63          	blez	a0,1ac <gets+0x5a>
      break;
    buf[i++] = c;
 196:	faf44783          	lbu	a5,-81(s0)
 19a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 19e:	0905                	addi	s2,s2,1
 1a0:	ff678713          	addi	a4,a5,-10
 1a4:	c319                	beqz	a4,1aa <gets+0x58>
 1a6:	17cd                	addi	a5,a5,-13
 1a8:	fbe1                	bnez	a5,178 <gets+0x26>
    buf[i++] = c;
 1aa:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 1ac:	9c5e                	add	s8,s8,s7
 1ae:	000c0023          	sb	zero,0(s8)
  return buf;
}
 1b2:	855e                	mv	a0,s7
 1b4:	60e6                	ld	ra,88(sp)
 1b6:	6446                	ld	s0,80(sp)
 1b8:	64a6                	ld	s1,72(sp)
 1ba:	6906                	ld	s2,64(sp)
 1bc:	79e2                	ld	s3,56(sp)
 1be:	7a42                	ld	s4,48(sp)
 1c0:	7aa2                	ld	s5,40(sp)
 1c2:	7b02                	ld	s6,32(sp)
 1c4:	6be2                	ld	s7,24(sp)
 1c6:	6c42                	ld	s8,16(sp)
 1c8:	6125                	addi	sp,sp,96
 1ca:	8082                	ret

00000000000001cc <stat>:

int
stat(const char *n, struct stat *st)
{
 1cc:	1101                	addi	sp,sp,-32
 1ce:	ec06                	sd	ra,24(sp)
 1d0:	e822                	sd	s0,16(sp)
 1d2:	e04a                	sd	s2,0(sp)
 1d4:	1000                	addi	s0,sp,32
 1d6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1d8:	4581                	li	a1,0
 1da:	00000097          	auipc	ra,0x0
 1de:	17c080e7          	jalr	380(ra) # 356 <open>
  if(fd < 0)
 1e2:	02054663          	bltz	a0,20e <stat+0x42>
 1e6:	e426                	sd	s1,8(sp)
 1e8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1ea:	85ca                	mv	a1,s2
 1ec:	00000097          	auipc	ra,0x0
 1f0:	182080e7          	jalr	386(ra) # 36e <fstat>
 1f4:	892a                	mv	s2,a0
  close(fd);
 1f6:	8526                	mv	a0,s1
 1f8:	00000097          	auipc	ra,0x0
 1fc:	146080e7          	jalr	326(ra) # 33e <close>
  return r;
 200:	64a2                	ld	s1,8(sp)
}
 202:	854a                	mv	a0,s2
 204:	60e2                	ld	ra,24(sp)
 206:	6442                	ld	s0,16(sp)
 208:	6902                	ld	s2,0(sp)
 20a:	6105                	addi	sp,sp,32
 20c:	8082                	ret
    return -1;
 20e:	57fd                	li	a5,-1
 210:	893e                	mv	s2,a5
 212:	bfc5                	j	202 <stat+0x36>

0000000000000214 <atoi>:

int
atoi(const char *s)
{
 214:	1141                	addi	sp,sp,-16
 216:	e406                	sd	ra,8(sp)
 218:	e022                	sd	s0,0(sp)
 21a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 21c:	00054683          	lbu	a3,0(a0)
 220:	fd06879b          	addiw	a5,a3,-48
 224:	0ff7f793          	zext.b	a5,a5
 228:	4625                	li	a2,9
 22a:	02f66963          	bltu	a2,a5,25c <atoi+0x48>
 22e:	872a                	mv	a4,a0
  n = 0;
 230:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 232:	0705                	addi	a4,a4,1
 234:	0025179b          	slliw	a5,a0,0x2
 238:	9fa9                	addw	a5,a5,a0
 23a:	0017979b          	slliw	a5,a5,0x1
 23e:	9fb5                	addw	a5,a5,a3
 240:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 244:	00074683          	lbu	a3,0(a4)
 248:	fd06879b          	addiw	a5,a3,-48
 24c:	0ff7f793          	zext.b	a5,a5
 250:	fef671e3          	bgeu	a2,a5,232 <atoi+0x1e>
  return n;
}
 254:	60a2                	ld	ra,8(sp)
 256:	6402                	ld	s0,0(sp)
 258:	0141                	addi	sp,sp,16
 25a:	8082                	ret
  n = 0;
 25c:	4501                	li	a0,0
 25e:	bfdd                	j	254 <atoi+0x40>

0000000000000260 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 260:	1141                	addi	sp,sp,-16
 262:	e406                	sd	ra,8(sp)
 264:	e022                	sd	s0,0(sp)
 266:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 268:	02b57563          	bgeu	a0,a1,292 <memmove+0x32>
    while(n-- > 0)
 26c:	00c05f63          	blez	a2,28a <memmove+0x2a>
 270:	1602                	slli	a2,a2,0x20
 272:	9201                	srli	a2,a2,0x20
 274:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 278:	872a                	mv	a4,a0
      *dst++ = *src++;
 27a:	0585                	addi	a1,a1,1
 27c:	0705                	addi	a4,a4,1
 27e:	fff5c683          	lbu	a3,-1(a1)
 282:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 286:	fee79ae3          	bne	a5,a4,27a <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 28a:	60a2                	ld	ra,8(sp)
 28c:	6402                	ld	s0,0(sp)
 28e:	0141                	addi	sp,sp,16
 290:	8082                	ret
    while(n-- > 0)
 292:	fec05ce3          	blez	a2,28a <memmove+0x2a>
    dst += n;
 296:	00c50733          	add	a4,a0,a2
    src += n;
 29a:	95b2                	add	a1,a1,a2
 29c:	fff6079b          	addiw	a5,a2,-1
 2a0:	1782                	slli	a5,a5,0x20
 2a2:	9381                	srli	a5,a5,0x20
 2a4:	fff7c793          	not	a5,a5
 2a8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2aa:	15fd                	addi	a1,a1,-1
 2ac:	177d                	addi	a4,a4,-1
 2ae:	0005c683          	lbu	a3,0(a1)
 2b2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2b6:	fef71ae3          	bne	a4,a5,2aa <memmove+0x4a>
 2ba:	bfc1                	j	28a <memmove+0x2a>

00000000000002bc <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2bc:	1141                	addi	sp,sp,-16
 2be:	e406                	sd	ra,8(sp)
 2c0:	e022                	sd	s0,0(sp)
 2c2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2c4:	c61d                	beqz	a2,2f2 <memcmp+0x36>
 2c6:	1602                	slli	a2,a2,0x20
 2c8:	9201                	srli	a2,a2,0x20
 2ca:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 2ce:	00054783          	lbu	a5,0(a0)
 2d2:	0005c703          	lbu	a4,0(a1)
 2d6:	00e79863          	bne	a5,a4,2e6 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 2da:	0505                	addi	a0,a0,1
    p2++;
 2dc:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2de:	fed518e3          	bne	a0,a3,2ce <memcmp+0x12>
  }
  return 0;
 2e2:	4501                	li	a0,0
 2e4:	a019                	j	2ea <memcmp+0x2e>
      return *p1 - *p2;
 2e6:	40e7853b          	subw	a0,a5,a4
}
 2ea:	60a2                	ld	ra,8(sp)
 2ec:	6402                	ld	s0,0(sp)
 2ee:	0141                	addi	sp,sp,16
 2f0:	8082                	ret
  return 0;
 2f2:	4501                	li	a0,0
 2f4:	bfdd                	j	2ea <memcmp+0x2e>

00000000000002f6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2f6:	1141                	addi	sp,sp,-16
 2f8:	e406                	sd	ra,8(sp)
 2fa:	e022                	sd	s0,0(sp)
 2fc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2fe:	00000097          	auipc	ra,0x0
 302:	f62080e7          	jalr	-158(ra) # 260 <memmove>
}
 306:	60a2                	ld	ra,8(sp)
 308:	6402                	ld	s0,0(sp)
 30a:	0141                	addi	sp,sp,16
 30c:	8082                	ret

000000000000030e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 30e:	4885                	li	a7,1
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <exit>:
.global exit
exit:
 li a7, SYS_exit
 316:	4889                	li	a7,2
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <wait>:
.global wait
wait:
 li a7, SYS_wait
 31e:	488d                	li	a7,3
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 326:	4891                	li	a7,4
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <read>:
.global read
read:
 li a7, SYS_read
 32e:	4895                	li	a7,5
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <write>:
.global write
write:
 li a7, SYS_write
 336:	48c1                	li	a7,16
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <close>:
.global close
close:
 li a7, SYS_close
 33e:	48d5                	li	a7,21
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <kill>:
.global kill
kill:
 li a7, SYS_kill
 346:	4899                	li	a7,6
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <exec>:
.global exec
exec:
 li a7, SYS_exec
 34e:	489d                	li	a7,7
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <open>:
.global open
open:
 li a7, SYS_open
 356:	48bd                	li	a7,15
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 35e:	48c5                	li	a7,17
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 366:	48c9                	li	a7,18
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 36e:	48a1                	li	a7,8
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <link>:
.global link
link:
 li a7, SYS_link
 376:	48cd                	li	a7,19
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 37e:	48d1                	li	a7,20
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 386:	48a5                	li	a7,9
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <dup>:
.global dup
dup:
 li a7, SYS_dup
 38e:	48a9                	li	a7,10
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 396:	48ad                	li	a7,11
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 39e:	48b1                	li	a7,12
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3a6:	48b5                	li	a7,13
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3ae:	48b9                	li	a7,14
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <wait2>:
.global wait2
wait2:
 li a7, SYS_wait2
 3b6:	48dd                	li	a7,23
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3be:	1101                	addi	sp,sp,-32
 3c0:	ec06                	sd	ra,24(sp)
 3c2:	e822                	sd	s0,16(sp)
 3c4:	1000                	addi	s0,sp,32
 3c6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3ca:	4605                	li	a2,1
 3cc:	fef40593          	addi	a1,s0,-17
 3d0:	00000097          	auipc	ra,0x0
 3d4:	f66080e7          	jalr	-154(ra) # 336 <write>
}
 3d8:	60e2                	ld	ra,24(sp)
 3da:	6442                	ld	s0,16(sp)
 3dc:	6105                	addi	sp,sp,32
 3de:	8082                	ret

00000000000003e0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3e0:	7139                	addi	sp,sp,-64
 3e2:	fc06                	sd	ra,56(sp)
 3e4:	f822                	sd	s0,48(sp)
 3e6:	f04a                	sd	s2,32(sp)
 3e8:	ec4e                	sd	s3,24(sp)
 3ea:	0080                	addi	s0,sp,64
 3ec:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3ee:	cad9                	beqz	a3,484 <printint+0xa4>
 3f0:	01f5d79b          	srliw	a5,a1,0x1f
 3f4:	cbc1                	beqz	a5,484 <printint+0xa4>
    neg = 1;
    x = -xx;
 3f6:	40b005bb          	negw	a1,a1
    neg = 1;
 3fa:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 3fc:	fc040993          	addi	s3,s0,-64
  neg = 0;
 400:	86ce                	mv	a3,s3
  i = 0;
 402:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 404:	00000817          	auipc	a6,0x0
 408:	4ac80813          	addi	a6,a6,1196 # 8b0 <digits>
 40c:	88ba                	mv	a7,a4
 40e:	0017051b          	addiw	a0,a4,1
 412:	872a                	mv	a4,a0
 414:	02c5f7bb          	remuw	a5,a1,a2
 418:	1782                	slli	a5,a5,0x20
 41a:	9381                	srli	a5,a5,0x20
 41c:	97c2                	add	a5,a5,a6
 41e:	0007c783          	lbu	a5,0(a5)
 422:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 426:	87ae                	mv	a5,a1
 428:	02c5d5bb          	divuw	a1,a1,a2
 42c:	0685                	addi	a3,a3,1
 42e:	fcc7ffe3          	bgeu	a5,a2,40c <printint+0x2c>
  if(neg)
 432:	00030c63          	beqz	t1,44a <printint+0x6a>
    buf[i++] = '-';
 436:	fd050793          	addi	a5,a0,-48
 43a:	00878533          	add	a0,a5,s0
 43e:	02d00793          	li	a5,45
 442:	fef50823          	sb	a5,-16(a0)
 446:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 44a:	02e05763          	blez	a4,478 <printint+0x98>
 44e:	f426                	sd	s1,40(sp)
 450:	377d                	addiw	a4,a4,-1
 452:	00e984b3          	add	s1,s3,a4
 456:	19fd                	addi	s3,s3,-1
 458:	99ba                	add	s3,s3,a4
 45a:	1702                	slli	a4,a4,0x20
 45c:	9301                	srli	a4,a4,0x20
 45e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 462:	0004c583          	lbu	a1,0(s1)
 466:	854a                	mv	a0,s2
 468:	00000097          	auipc	ra,0x0
 46c:	f56080e7          	jalr	-170(ra) # 3be <putc>
  while(--i >= 0)
 470:	14fd                	addi	s1,s1,-1
 472:	ff3498e3          	bne	s1,s3,462 <printint+0x82>
 476:	74a2                	ld	s1,40(sp)
}
 478:	70e2                	ld	ra,56(sp)
 47a:	7442                	ld	s0,48(sp)
 47c:	7902                	ld	s2,32(sp)
 47e:	69e2                	ld	s3,24(sp)
 480:	6121                	addi	sp,sp,64
 482:	8082                	ret
  neg = 0;
 484:	4301                	li	t1,0
 486:	bf9d                	j	3fc <printint+0x1c>

0000000000000488 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 488:	715d                	addi	sp,sp,-80
 48a:	e486                	sd	ra,72(sp)
 48c:	e0a2                	sd	s0,64(sp)
 48e:	f84a                	sd	s2,48(sp)
 490:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 492:	0005c903          	lbu	s2,0(a1)
 496:	1a090b63          	beqz	s2,64c <vprintf+0x1c4>
 49a:	fc26                	sd	s1,56(sp)
 49c:	f44e                	sd	s3,40(sp)
 49e:	f052                	sd	s4,32(sp)
 4a0:	ec56                	sd	s5,24(sp)
 4a2:	e85a                	sd	s6,16(sp)
 4a4:	e45e                	sd	s7,8(sp)
 4a6:	8aaa                	mv	s5,a0
 4a8:	8bb2                	mv	s7,a2
 4aa:	00158493          	addi	s1,a1,1
  state = 0;
 4ae:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4b0:	02500a13          	li	s4,37
 4b4:	4b55                	li	s6,21
 4b6:	a839                	j	4d4 <vprintf+0x4c>
        putc(fd, c);
 4b8:	85ca                	mv	a1,s2
 4ba:	8556                	mv	a0,s5
 4bc:	00000097          	auipc	ra,0x0
 4c0:	f02080e7          	jalr	-254(ra) # 3be <putc>
 4c4:	a019                	j	4ca <vprintf+0x42>
    } else if(state == '%'){
 4c6:	01498d63          	beq	s3,s4,4e0 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 4ca:	0485                	addi	s1,s1,1
 4cc:	fff4c903          	lbu	s2,-1(s1)
 4d0:	16090863          	beqz	s2,640 <vprintf+0x1b8>
    if(state == 0){
 4d4:	fe0999e3          	bnez	s3,4c6 <vprintf+0x3e>
      if(c == '%'){
 4d8:	ff4910e3          	bne	s2,s4,4b8 <vprintf+0x30>
        state = '%';
 4dc:	89d2                	mv	s3,s4
 4de:	b7f5                	j	4ca <vprintf+0x42>
      if(c == 'd'){
 4e0:	13490563          	beq	s2,s4,60a <vprintf+0x182>
 4e4:	f9d9079b          	addiw	a5,s2,-99
 4e8:	0ff7f793          	zext.b	a5,a5
 4ec:	12fb6863          	bltu	s6,a5,61c <vprintf+0x194>
 4f0:	f9d9079b          	addiw	a5,s2,-99
 4f4:	0ff7f713          	zext.b	a4,a5
 4f8:	12eb6263          	bltu	s6,a4,61c <vprintf+0x194>
 4fc:	00271793          	slli	a5,a4,0x2
 500:	00000717          	auipc	a4,0x0
 504:	35870713          	addi	a4,a4,856 # 858 <malloc+0x118>
 508:	97ba                	add	a5,a5,a4
 50a:	439c                	lw	a5,0(a5)
 50c:	97ba                	add	a5,a5,a4
 50e:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 510:	008b8913          	addi	s2,s7,8
 514:	4685                	li	a3,1
 516:	4629                	li	a2,10
 518:	000ba583          	lw	a1,0(s7)
 51c:	8556                	mv	a0,s5
 51e:	00000097          	auipc	ra,0x0
 522:	ec2080e7          	jalr	-318(ra) # 3e0 <printint>
 526:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 528:	4981                	li	s3,0
 52a:	b745                	j	4ca <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 52c:	008b8913          	addi	s2,s7,8
 530:	4681                	li	a3,0
 532:	4629                	li	a2,10
 534:	000ba583          	lw	a1,0(s7)
 538:	8556                	mv	a0,s5
 53a:	00000097          	auipc	ra,0x0
 53e:	ea6080e7          	jalr	-346(ra) # 3e0 <printint>
 542:	8bca                	mv	s7,s2
      state = 0;
 544:	4981                	li	s3,0
 546:	b751                	j	4ca <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 548:	008b8913          	addi	s2,s7,8
 54c:	4681                	li	a3,0
 54e:	4641                	li	a2,16
 550:	000ba583          	lw	a1,0(s7)
 554:	8556                	mv	a0,s5
 556:	00000097          	auipc	ra,0x0
 55a:	e8a080e7          	jalr	-374(ra) # 3e0 <printint>
 55e:	8bca                	mv	s7,s2
      state = 0;
 560:	4981                	li	s3,0
 562:	b7a5                	j	4ca <vprintf+0x42>
 564:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 566:	008b8793          	addi	a5,s7,8
 56a:	8c3e                	mv	s8,a5
 56c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 570:	03000593          	li	a1,48
 574:	8556                	mv	a0,s5
 576:	00000097          	auipc	ra,0x0
 57a:	e48080e7          	jalr	-440(ra) # 3be <putc>
  putc(fd, 'x');
 57e:	07800593          	li	a1,120
 582:	8556                	mv	a0,s5
 584:	00000097          	auipc	ra,0x0
 588:	e3a080e7          	jalr	-454(ra) # 3be <putc>
 58c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 58e:	00000b97          	auipc	s7,0x0
 592:	322b8b93          	addi	s7,s7,802 # 8b0 <digits>
 596:	03c9d793          	srli	a5,s3,0x3c
 59a:	97de                	add	a5,a5,s7
 59c:	0007c583          	lbu	a1,0(a5)
 5a0:	8556                	mv	a0,s5
 5a2:	00000097          	auipc	ra,0x0
 5a6:	e1c080e7          	jalr	-484(ra) # 3be <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5aa:	0992                	slli	s3,s3,0x4
 5ac:	397d                	addiw	s2,s2,-1
 5ae:	fe0914e3          	bnez	s2,596 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 5b2:	8be2                	mv	s7,s8
      state = 0;
 5b4:	4981                	li	s3,0
 5b6:	6c02                	ld	s8,0(sp)
 5b8:	bf09                	j	4ca <vprintf+0x42>
        s = va_arg(ap, char*);
 5ba:	008b8993          	addi	s3,s7,8
 5be:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 5c2:	02090163          	beqz	s2,5e4 <vprintf+0x15c>
        while(*s != 0){
 5c6:	00094583          	lbu	a1,0(s2)
 5ca:	c9a5                	beqz	a1,63a <vprintf+0x1b2>
          putc(fd, *s);
 5cc:	8556                	mv	a0,s5
 5ce:	00000097          	auipc	ra,0x0
 5d2:	df0080e7          	jalr	-528(ra) # 3be <putc>
          s++;
 5d6:	0905                	addi	s2,s2,1
        while(*s != 0){
 5d8:	00094583          	lbu	a1,0(s2)
 5dc:	f9e5                	bnez	a1,5cc <vprintf+0x144>
        s = va_arg(ap, char*);
 5de:	8bce                	mv	s7,s3
      state = 0;
 5e0:	4981                	li	s3,0
 5e2:	b5e5                	j	4ca <vprintf+0x42>
          s = "(null)";
 5e4:	00000917          	auipc	s2,0x0
 5e8:	26c90913          	addi	s2,s2,620 # 850 <malloc+0x110>
        while(*s != 0){
 5ec:	02800593          	li	a1,40
 5f0:	bff1                	j	5cc <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 5f2:	008b8913          	addi	s2,s7,8
 5f6:	000bc583          	lbu	a1,0(s7)
 5fa:	8556                	mv	a0,s5
 5fc:	00000097          	auipc	ra,0x0
 600:	dc2080e7          	jalr	-574(ra) # 3be <putc>
 604:	8bca                	mv	s7,s2
      state = 0;
 606:	4981                	li	s3,0
 608:	b5c9                	j	4ca <vprintf+0x42>
        putc(fd, c);
 60a:	02500593          	li	a1,37
 60e:	8556                	mv	a0,s5
 610:	00000097          	auipc	ra,0x0
 614:	dae080e7          	jalr	-594(ra) # 3be <putc>
      state = 0;
 618:	4981                	li	s3,0
 61a:	bd45                	j	4ca <vprintf+0x42>
        putc(fd, '%');
 61c:	02500593          	li	a1,37
 620:	8556                	mv	a0,s5
 622:	00000097          	auipc	ra,0x0
 626:	d9c080e7          	jalr	-612(ra) # 3be <putc>
        putc(fd, c);
 62a:	85ca                	mv	a1,s2
 62c:	8556                	mv	a0,s5
 62e:	00000097          	auipc	ra,0x0
 632:	d90080e7          	jalr	-624(ra) # 3be <putc>
      state = 0;
 636:	4981                	li	s3,0
 638:	bd49                	j	4ca <vprintf+0x42>
        s = va_arg(ap, char*);
 63a:	8bce                	mv	s7,s3
      state = 0;
 63c:	4981                	li	s3,0
 63e:	b571                	j	4ca <vprintf+0x42>
 640:	74e2                	ld	s1,56(sp)
 642:	79a2                	ld	s3,40(sp)
 644:	7a02                	ld	s4,32(sp)
 646:	6ae2                	ld	s5,24(sp)
 648:	6b42                	ld	s6,16(sp)
 64a:	6ba2                	ld	s7,8(sp)
    }
  }
}
 64c:	60a6                	ld	ra,72(sp)
 64e:	6406                	ld	s0,64(sp)
 650:	7942                	ld	s2,48(sp)
 652:	6161                	addi	sp,sp,80
 654:	8082                	ret

0000000000000656 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 656:	715d                	addi	sp,sp,-80
 658:	ec06                	sd	ra,24(sp)
 65a:	e822                	sd	s0,16(sp)
 65c:	1000                	addi	s0,sp,32
 65e:	e010                	sd	a2,0(s0)
 660:	e414                	sd	a3,8(s0)
 662:	e818                	sd	a4,16(s0)
 664:	ec1c                	sd	a5,24(s0)
 666:	03043023          	sd	a6,32(s0)
 66a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 66e:	8622                	mv	a2,s0
 670:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 674:	00000097          	auipc	ra,0x0
 678:	e14080e7          	jalr	-492(ra) # 488 <vprintf>
}
 67c:	60e2                	ld	ra,24(sp)
 67e:	6442                	ld	s0,16(sp)
 680:	6161                	addi	sp,sp,80
 682:	8082                	ret

0000000000000684 <printf>:

void
printf(const char *fmt, ...)
{
 684:	711d                	addi	sp,sp,-96
 686:	ec06                	sd	ra,24(sp)
 688:	e822                	sd	s0,16(sp)
 68a:	1000                	addi	s0,sp,32
 68c:	e40c                	sd	a1,8(s0)
 68e:	e810                	sd	a2,16(s0)
 690:	ec14                	sd	a3,24(s0)
 692:	f018                	sd	a4,32(s0)
 694:	f41c                	sd	a5,40(s0)
 696:	03043823          	sd	a6,48(s0)
 69a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 69e:	00840613          	addi	a2,s0,8
 6a2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6a6:	85aa                	mv	a1,a0
 6a8:	4505                	li	a0,1
 6aa:	00000097          	auipc	ra,0x0
 6ae:	dde080e7          	jalr	-546(ra) # 488 <vprintf>
}
 6b2:	60e2                	ld	ra,24(sp)
 6b4:	6442                	ld	s0,16(sp)
 6b6:	6125                	addi	sp,sp,96
 6b8:	8082                	ret

00000000000006ba <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6ba:	1141                	addi	sp,sp,-16
 6bc:	e406                	sd	ra,8(sp)
 6be:	e022                	sd	s0,0(sp)
 6c0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6c2:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c6:	00000797          	auipc	a5,0x0
 6ca:	2027b783          	ld	a5,514(a5) # 8c8 <freep>
 6ce:	a039                	j	6dc <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6d0:	6398                	ld	a4,0(a5)
 6d2:	00e7e463          	bltu	a5,a4,6da <free+0x20>
 6d6:	00e6ea63          	bltu	a3,a4,6ea <free+0x30>
{
 6da:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6dc:	fed7fae3          	bgeu	a5,a3,6d0 <free+0x16>
 6e0:	6398                	ld	a4,0(a5)
 6e2:	00e6e463          	bltu	a3,a4,6ea <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6e6:	fee7eae3          	bltu	a5,a4,6da <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6ea:	ff852583          	lw	a1,-8(a0)
 6ee:	6390                	ld	a2,0(a5)
 6f0:	02059813          	slli	a6,a1,0x20
 6f4:	01c85713          	srli	a4,a6,0x1c
 6f8:	9736                	add	a4,a4,a3
 6fa:	02e60563          	beq	a2,a4,724 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 6fe:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 702:	4790                	lw	a2,8(a5)
 704:	02061593          	slli	a1,a2,0x20
 708:	01c5d713          	srli	a4,a1,0x1c
 70c:	973e                	add	a4,a4,a5
 70e:	02e68263          	beq	a3,a4,732 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 712:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 714:	00000717          	auipc	a4,0x0
 718:	1af73a23          	sd	a5,436(a4) # 8c8 <freep>
}
 71c:	60a2                	ld	ra,8(sp)
 71e:	6402                	ld	s0,0(sp)
 720:	0141                	addi	sp,sp,16
 722:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 724:	4618                	lw	a4,8(a2)
 726:	9f2d                	addw	a4,a4,a1
 728:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 72c:	6398                	ld	a4,0(a5)
 72e:	6310                	ld	a2,0(a4)
 730:	b7f9                	j	6fe <free+0x44>
    p->s.size += bp->s.size;
 732:	ff852703          	lw	a4,-8(a0)
 736:	9f31                	addw	a4,a4,a2
 738:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 73a:	ff053683          	ld	a3,-16(a0)
 73e:	bfd1                	j	712 <free+0x58>

0000000000000740 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 740:	7139                	addi	sp,sp,-64
 742:	fc06                	sd	ra,56(sp)
 744:	f822                	sd	s0,48(sp)
 746:	f04a                	sd	s2,32(sp)
 748:	ec4e                	sd	s3,24(sp)
 74a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 74c:	02051993          	slli	s3,a0,0x20
 750:	0209d993          	srli	s3,s3,0x20
 754:	09bd                	addi	s3,s3,15
 756:	0049d993          	srli	s3,s3,0x4
 75a:	2985                	addiw	s3,s3,1
 75c:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 75e:	00000517          	auipc	a0,0x0
 762:	16a53503          	ld	a0,362(a0) # 8c8 <freep>
 766:	c905                	beqz	a0,796 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 768:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 76a:	4798                	lw	a4,8(a5)
 76c:	09377a63          	bgeu	a4,s3,800 <malloc+0xc0>
 770:	f426                	sd	s1,40(sp)
 772:	e852                	sd	s4,16(sp)
 774:	e456                	sd	s5,8(sp)
 776:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 778:	8a4e                	mv	s4,s3
 77a:	6705                	lui	a4,0x1
 77c:	00e9f363          	bgeu	s3,a4,782 <malloc+0x42>
 780:	6a05                	lui	s4,0x1
 782:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 786:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 78a:	00000497          	auipc	s1,0x0
 78e:	13e48493          	addi	s1,s1,318 # 8c8 <freep>
  if(p == (char*)-1)
 792:	5afd                	li	s5,-1
 794:	a089                	j	7d6 <malloc+0x96>
 796:	f426                	sd	s1,40(sp)
 798:	e852                	sd	s4,16(sp)
 79a:	e456                	sd	s5,8(sp)
 79c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 79e:	00000797          	auipc	a5,0x0
 7a2:	13278793          	addi	a5,a5,306 # 8d0 <base>
 7a6:	00000717          	auipc	a4,0x0
 7aa:	12f73123          	sd	a5,290(a4) # 8c8 <freep>
 7ae:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7b0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7b4:	b7d1                	j	778 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 7b6:	6398                	ld	a4,0(a5)
 7b8:	e118                	sd	a4,0(a0)
 7ba:	a8b9                	j	818 <malloc+0xd8>
  hp->s.size = nu;
 7bc:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7c0:	0541                	addi	a0,a0,16
 7c2:	00000097          	auipc	ra,0x0
 7c6:	ef8080e7          	jalr	-264(ra) # 6ba <free>
  return freep;
 7ca:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 7cc:	c135                	beqz	a0,830 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ce:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7d0:	4798                	lw	a4,8(a5)
 7d2:	03277363          	bgeu	a4,s2,7f8 <malloc+0xb8>
    if(p == freep)
 7d6:	6098                	ld	a4,0(s1)
 7d8:	853e                	mv	a0,a5
 7da:	fef71ae3          	bne	a4,a5,7ce <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 7de:	8552                	mv	a0,s4
 7e0:	00000097          	auipc	ra,0x0
 7e4:	bbe080e7          	jalr	-1090(ra) # 39e <sbrk>
  if(p == (char*)-1)
 7e8:	fd551ae3          	bne	a0,s5,7bc <malloc+0x7c>
        return 0;
 7ec:	4501                	li	a0,0
 7ee:	74a2                	ld	s1,40(sp)
 7f0:	6a42                	ld	s4,16(sp)
 7f2:	6aa2                	ld	s5,8(sp)
 7f4:	6b02                	ld	s6,0(sp)
 7f6:	a03d                	j	824 <malloc+0xe4>
 7f8:	74a2                	ld	s1,40(sp)
 7fa:	6a42                	ld	s4,16(sp)
 7fc:	6aa2                	ld	s5,8(sp)
 7fe:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 800:	fae90be3          	beq	s2,a4,7b6 <malloc+0x76>
        p->s.size -= nunits;
 804:	4137073b          	subw	a4,a4,s3
 808:	c798                	sw	a4,8(a5)
        p += p->s.size;
 80a:	02071693          	slli	a3,a4,0x20
 80e:	01c6d713          	srli	a4,a3,0x1c
 812:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 814:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 818:	00000717          	auipc	a4,0x0
 81c:	0aa73823          	sd	a0,176(a4) # 8c8 <freep>
      return (void*)(p + 1);
 820:	01078513          	addi	a0,a5,16
  }
}
 824:	70e2                	ld	ra,56(sp)
 826:	7442                	ld	s0,48(sp)
 828:	7902                	ld	s2,32(sp)
 82a:	69e2                	ld	s3,24(sp)
 82c:	6121                	addi	sp,sp,64
 82e:	8082                	ret
 830:	74a2                	ld	s1,40(sp)
 832:	6a42                	ld	s4,16(sp)
 834:	6aa2                	ld	s5,8(sp)
 836:	6b02                	ld	s6,0(sp)
 838:	b7f5                	j	824 <malloc+0xe4>
