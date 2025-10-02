
user/_sleep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user/user.h"

int
main(int argc, char **argv)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if(argc != 2){
   8:	4789                	li	a5,2
   a:	02f50063          	beq	a0,a5,2a <main+0x2a>
    fprintf(2, "usage: sleep <ticks>\n");
   e:	00000597          	auipc	a1,0x0
  12:	7f258593          	addi	a1,a1,2034 # 800 <malloc+0xfa>
  16:	853e                	mv	a0,a5
  18:	00000097          	auipc	ra,0x0
  1c:	604080e7          	jalr	1540(ra) # 61c <fprintf>
    exit(1);
  20:	4505                	li	a0,1
  22:	00000097          	auipc	ra,0x0
  26:	2b2080e7          	jalr	690(ra) # 2d4 <exit>
  }
  sleep(atoi(argv[1]));
  2a:	6588                	ld	a0,8(a1)
  2c:	00000097          	auipc	ra,0x0
  30:	1a6080e7          	jalr	422(ra) # 1d2 <atoi>
  34:	00000097          	auipc	ra,0x0
  38:	330080e7          	jalr	816(ra) # 364 <sleep>
  exit(0);
  3c:	4501                	li	a0,0
  3e:	00000097          	auipc	ra,0x0
  42:	296080e7          	jalr	662(ra) # 2d4 <exit>

0000000000000046 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  46:	1141                	addi	sp,sp,-16
  48:	e406                	sd	ra,8(sp)
  4a:	e022                	sd	s0,0(sp)
  4c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  4e:	87aa                	mv	a5,a0
  50:	0585                	addi	a1,a1,1
  52:	0785                	addi	a5,a5,1
  54:	fff5c703          	lbu	a4,-1(a1)
  58:	fee78fa3          	sb	a4,-1(a5)
  5c:	fb75                	bnez	a4,50 <strcpy+0xa>
    ;
  return os;
}
  5e:	60a2                	ld	ra,8(sp)
  60:	6402                	ld	s0,0(sp)
  62:	0141                	addi	sp,sp,16
  64:	8082                	ret

0000000000000066 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  66:	1141                	addi	sp,sp,-16
  68:	e406                	sd	ra,8(sp)
  6a:	e022                	sd	s0,0(sp)
  6c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  6e:	00054783          	lbu	a5,0(a0)
  72:	cb91                	beqz	a5,86 <strcmp+0x20>
  74:	0005c703          	lbu	a4,0(a1)
  78:	00f71763          	bne	a4,a5,86 <strcmp+0x20>
    p++, q++;
  7c:	0505                	addi	a0,a0,1
  7e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  80:	00054783          	lbu	a5,0(a0)
  84:	fbe5                	bnez	a5,74 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  86:	0005c503          	lbu	a0,0(a1)
}
  8a:	40a7853b          	subw	a0,a5,a0
  8e:	60a2                	ld	ra,8(sp)
  90:	6402                	ld	s0,0(sp)
  92:	0141                	addi	sp,sp,16
  94:	8082                	ret

0000000000000096 <strlen>:

uint
strlen(const char *s)
{
  96:	1141                	addi	sp,sp,-16
  98:	e406                	sd	ra,8(sp)
  9a:	e022                	sd	s0,0(sp)
  9c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  9e:	00054783          	lbu	a5,0(a0)
  a2:	cf91                	beqz	a5,be <strlen+0x28>
  a4:	00150793          	addi	a5,a0,1
  a8:	86be                	mv	a3,a5
  aa:	0785                	addi	a5,a5,1
  ac:	fff7c703          	lbu	a4,-1(a5)
  b0:	ff65                	bnez	a4,a8 <strlen+0x12>
  b2:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  b6:	60a2                	ld	ra,8(sp)
  b8:	6402                	ld	s0,0(sp)
  ba:	0141                	addi	sp,sp,16
  bc:	8082                	ret
  for(n = 0; s[n]; n++)
  be:	4501                	li	a0,0
  c0:	bfdd                	j	b6 <strlen+0x20>

00000000000000c2 <memset>:

void*
memset(void *dst, int c, uint n)
{
  c2:	1141                	addi	sp,sp,-16
  c4:	e406                	sd	ra,8(sp)
  c6:	e022                	sd	s0,0(sp)
  c8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  ca:	ca19                	beqz	a2,e0 <memset+0x1e>
  cc:	87aa                	mv	a5,a0
  ce:	1602                	slli	a2,a2,0x20
  d0:	9201                	srli	a2,a2,0x20
  d2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  d6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  da:	0785                	addi	a5,a5,1
  dc:	fee79de3          	bne	a5,a4,d6 <memset+0x14>
  }
  return dst;
}
  e0:	60a2                	ld	ra,8(sp)
  e2:	6402                	ld	s0,0(sp)
  e4:	0141                	addi	sp,sp,16
  e6:	8082                	ret

00000000000000e8 <strchr>:

char*
strchr(const char *s, char c)
{
  e8:	1141                	addi	sp,sp,-16
  ea:	e406                	sd	ra,8(sp)
  ec:	e022                	sd	s0,0(sp)
  ee:	0800                	addi	s0,sp,16
  for(; *s; s++)
  f0:	00054783          	lbu	a5,0(a0)
  f4:	cf81                	beqz	a5,10c <strchr+0x24>
    if(*s == c)
  f6:	00f58763          	beq	a1,a5,104 <strchr+0x1c>
  for(; *s; s++)
  fa:	0505                	addi	a0,a0,1
  fc:	00054783          	lbu	a5,0(a0)
 100:	fbfd                	bnez	a5,f6 <strchr+0xe>
      return (char*)s;
  return 0;
 102:	4501                	li	a0,0
}
 104:	60a2                	ld	ra,8(sp)
 106:	6402                	ld	s0,0(sp)
 108:	0141                	addi	sp,sp,16
 10a:	8082                	ret
  return 0;
 10c:	4501                	li	a0,0
 10e:	bfdd                	j	104 <strchr+0x1c>

0000000000000110 <gets>:

char*
gets(char *buf, int max)
{
 110:	711d                	addi	sp,sp,-96
 112:	ec86                	sd	ra,88(sp)
 114:	e8a2                	sd	s0,80(sp)
 116:	e4a6                	sd	s1,72(sp)
 118:	e0ca                	sd	s2,64(sp)
 11a:	fc4e                	sd	s3,56(sp)
 11c:	f852                	sd	s4,48(sp)
 11e:	f456                	sd	s5,40(sp)
 120:	f05a                	sd	s6,32(sp)
 122:	ec5e                	sd	s7,24(sp)
 124:	e862                	sd	s8,16(sp)
 126:	1080                	addi	s0,sp,96
 128:	8baa                	mv	s7,a0
 12a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 12c:	892a                	mv	s2,a0
 12e:	4481                	li	s1,0
    cc = read(0, &c, 1);
 130:	faf40b13          	addi	s6,s0,-81
 134:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 136:	8c26                	mv	s8,s1
 138:	0014899b          	addiw	s3,s1,1
 13c:	84ce                	mv	s1,s3
 13e:	0349d663          	bge	s3,s4,16a <gets+0x5a>
    cc = read(0, &c, 1);
 142:	8656                	mv	a2,s5
 144:	85da                	mv	a1,s6
 146:	4501                	li	a0,0
 148:	00000097          	auipc	ra,0x0
 14c:	1a4080e7          	jalr	420(ra) # 2ec <read>
    if(cc < 1)
 150:	00a05d63          	blez	a0,16a <gets+0x5a>
      break;
    buf[i++] = c;
 154:	faf44783          	lbu	a5,-81(s0)
 158:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 15c:	0905                	addi	s2,s2,1
 15e:	ff678713          	addi	a4,a5,-10
 162:	c319                	beqz	a4,168 <gets+0x58>
 164:	17cd                	addi	a5,a5,-13
 166:	fbe1                	bnez	a5,136 <gets+0x26>
    buf[i++] = c;
 168:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 16a:	9c5e                	add	s8,s8,s7
 16c:	000c0023          	sb	zero,0(s8)
  return buf;
}
 170:	855e                	mv	a0,s7
 172:	60e6                	ld	ra,88(sp)
 174:	6446                	ld	s0,80(sp)
 176:	64a6                	ld	s1,72(sp)
 178:	6906                	ld	s2,64(sp)
 17a:	79e2                	ld	s3,56(sp)
 17c:	7a42                	ld	s4,48(sp)
 17e:	7aa2                	ld	s5,40(sp)
 180:	7b02                	ld	s6,32(sp)
 182:	6be2                	ld	s7,24(sp)
 184:	6c42                	ld	s8,16(sp)
 186:	6125                	addi	sp,sp,96
 188:	8082                	ret

000000000000018a <stat>:

int
stat(const char *n, struct stat *st)
{
 18a:	1101                	addi	sp,sp,-32
 18c:	ec06                	sd	ra,24(sp)
 18e:	e822                	sd	s0,16(sp)
 190:	e04a                	sd	s2,0(sp)
 192:	1000                	addi	s0,sp,32
 194:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 196:	4581                	li	a1,0
 198:	00000097          	auipc	ra,0x0
 19c:	17c080e7          	jalr	380(ra) # 314 <open>
  if(fd < 0)
 1a0:	02054663          	bltz	a0,1cc <stat+0x42>
 1a4:	e426                	sd	s1,8(sp)
 1a6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1a8:	85ca                	mv	a1,s2
 1aa:	00000097          	auipc	ra,0x0
 1ae:	182080e7          	jalr	386(ra) # 32c <fstat>
 1b2:	892a                	mv	s2,a0
  close(fd);
 1b4:	8526                	mv	a0,s1
 1b6:	00000097          	auipc	ra,0x0
 1ba:	146080e7          	jalr	326(ra) # 2fc <close>
  return r;
 1be:	64a2                	ld	s1,8(sp)
}
 1c0:	854a                	mv	a0,s2
 1c2:	60e2                	ld	ra,24(sp)
 1c4:	6442                	ld	s0,16(sp)
 1c6:	6902                	ld	s2,0(sp)
 1c8:	6105                	addi	sp,sp,32
 1ca:	8082                	ret
    return -1;
 1cc:	57fd                	li	a5,-1
 1ce:	893e                	mv	s2,a5
 1d0:	bfc5                	j	1c0 <stat+0x36>

00000000000001d2 <atoi>:

int
atoi(const char *s)
{
 1d2:	1141                	addi	sp,sp,-16
 1d4:	e406                	sd	ra,8(sp)
 1d6:	e022                	sd	s0,0(sp)
 1d8:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1da:	00054683          	lbu	a3,0(a0)
 1de:	fd06879b          	addiw	a5,a3,-48
 1e2:	0ff7f793          	zext.b	a5,a5
 1e6:	4625                	li	a2,9
 1e8:	02f66963          	bltu	a2,a5,21a <atoi+0x48>
 1ec:	872a                	mv	a4,a0
  n = 0;
 1ee:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1f0:	0705                	addi	a4,a4,1
 1f2:	0025179b          	slliw	a5,a0,0x2
 1f6:	9fa9                	addw	a5,a5,a0
 1f8:	0017979b          	slliw	a5,a5,0x1
 1fc:	9fb5                	addw	a5,a5,a3
 1fe:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 202:	00074683          	lbu	a3,0(a4)
 206:	fd06879b          	addiw	a5,a3,-48
 20a:	0ff7f793          	zext.b	a5,a5
 20e:	fef671e3          	bgeu	a2,a5,1f0 <atoi+0x1e>
  return n;
}
 212:	60a2                	ld	ra,8(sp)
 214:	6402                	ld	s0,0(sp)
 216:	0141                	addi	sp,sp,16
 218:	8082                	ret
  n = 0;
 21a:	4501                	li	a0,0
 21c:	bfdd                	j	212 <atoi+0x40>

000000000000021e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 21e:	1141                	addi	sp,sp,-16
 220:	e406                	sd	ra,8(sp)
 222:	e022                	sd	s0,0(sp)
 224:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 226:	02b57563          	bgeu	a0,a1,250 <memmove+0x32>
    while(n-- > 0)
 22a:	00c05f63          	blez	a2,248 <memmove+0x2a>
 22e:	1602                	slli	a2,a2,0x20
 230:	9201                	srli	a2,a2,0x20
 232:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 236:	872a                	mv	a4,a0
      *dst++ = *src++;
 238:	0585                	addi	a1,a1,1
 23a:	0705                	addi	a4,a4,1
 23c:	fff5c683          	lbu	a3,-1(a1)
 240:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 244:	fee79ae3          	bne	a5,a4,238 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 248:	60a2                	ld	ra,8(sp)
 24a:	6402                	ld	s0,0(sp)
 24c:	0141                	addi	sp,sp,16
 24e:	8082                	ret
    while(n-- > 0)
 250:	fec05ce3          	blez	a2,248 <memmove+0x2a>
    dst += n;
 254:	00c50733          	add	a4,a0,a2
    src += n;
 258:	95b2                	add	a1,a1,a2
 25a:	fff6079b          	addiw	a5,a2,-1
 25e:	1782                	slli	a5,a5,0x20
 260:	9381                	srli	a5,a5,0x20
 262:	fff7c793          	not	a5,a5
 266:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 268:	15fd                	addi	a1,a1,-1
 26a:	177d                	addi	a4,a4,-1
 26c:	0005c683          	lbu	a3,0(a1)
 270:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 274:	fef71ae3          	bne	a4,a5,268 <memmove+0x4a>
 278:	bfc1                	j	248 <memmove+0x2a>

000000000000027a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 27a:	1141                	addi	sp,sp,-16
 27c:	e406                	sd	ra,8(sp)
 27e:	e022                	sd	s0,0(sp)
 280:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 282:	c61d                	beqz	a2,2b0 <memcmp+0x36>
 284:	1602                	slli	a2,a2,0x20
 286:	9201                	srli	a2,a2,0x20
 288:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 28c:	00054783          	lbu	a5,0(a0)
 290:	0005c703          	lbu	a4,0(a1)
 294:	00e79863          	bne	a5,a4,2a4 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 298:	0505                	addi	a0,a0,1
    p2++;
 29a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 29c:	fed518e3          	bne	a0,a3,28c <memcmp+0x12>
  }
  return 0;
 2a0:	4501                	li	a0,0
 2a2:	a019                	j	2a8 <memcmp+0x2e>
      return *p1 - *p2;
 2a4:	40e7853b          	subw	a0,a5,a4
}
 2a8:	60a2                	ld	ra,8(sp)
 2aa:	6402                	ld	s0,0(sp)
 2ac:	0141                	addi	sp,sp,16
 2ae:	8082                	ret
  return 0;
 2b0:	4501                	li	a0,0
 2b2:	bfdd                	j	2a8 <memcmp+0x2e>

00000000000002b4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2b4:	1141                	addi	sp,sp,-16
 2b6:	e406                	sd	ra,8(sp)
 2b8:	e022                	sd	s0,0(sp)
 2ba:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2bc:	00000097          	auipc	ra,0x0
 2c0:	f62080e7          	jalr	-158(ra) # 21e <memmove>
}
 2c4:	60a2                	ld	ra,8(sp)
 2c6:	6402                	ld	s0,0(sp)
 2c8:	0141                	addi	sp,sp,16
 2ca:	8082                	ret

00000000000002cc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2cc:	4885                	li	a7,1
 ecall
 2ce:	00000073          	ecall
 ret
 2d2:	8082                	ret

00000000000002d4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2d4:	4889                	li	a7,2
 ecall
 2d6:	00000073          	ecall
 ret
 2da:	8082                	ret

00000000000002dc <wait>:
.global wait
wait:
 li a7, SYS_wait
 2dc:	488d                	li	a7,3
 ecall
 2de:	00000073          	ecall
 ret
 2e2:	8082                	ret

00000000000002e4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2e4:	4891                	li	a7,4
 ecall
 2e6:	00000073          	ecall
 ret
 2ea:	8082                	ret

00000000000002ec <read>:
.global read
read:
 li a7, SYS_read
 2ec:	4895                	li	a7,5
 ecall
 2ee:	00000073          	ecall
 ret
 2f2:	8082                	ret

00000000000002f4 <write>:
.global write
write:
 li a7, SYS_write
 2f4:	48c1                	li	a7,16
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <close>:
.global close
close:
 li a7, SYS_close
 2fc:	48d5                	li	a7,21
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <kill>:
.global kill
kill:
 li a7, SYS_kill
 304:	4899                	li	a7,6
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <exec>:
.global exec
exec:
 li a7, SYS_exec
 30c:	489d                	li	a7,7
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <open>:
.global open
open:
 li a7, SYS_open
 314:	48bd                	li	a7,15
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 31c:	48c5                	li	a7,17
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 324:	48c9                	li	a7,18
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 32c:	48a1                	li	a7,8
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <link>:
.global link
link:
 li a7, SYS_link
 334:	48cd                	li	a7,19
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 33c:	48d1                	li	a7,20
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 344:	48a5                	li	a7,9
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <dup>:
.global dup
dup:
 li a7, SYS_dup
 34c:	48a9                	li	a7,10
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 354:	48ad                	li	a7,11
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 35c:	48b1                	li	a7,12
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 364:	48b5                	li	a7,13
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 36c:	48b9                	li	a7,14
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <cputime>:
.global cputime
cputime:
 li a7, SYS_cputime
 374:	48d9                	li	a7,22
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <wait2>:
.global wait2
wait2:
 li a7, SYS_wait2
 37c:	48dd                	li	a7,23
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 384:	1101                	addi	sp,sp,-32
 386:	ec06                	sd	ra,24(sp)
 388:	e822                	sd	s0,16(sp)
 38a:	1000                	addi	s0,sp,32
 38c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 390:	4605                	li	a2,1
 392:	fef40593          	addi	a1,s0,-17
 396:	00000097          	auipc	ra,0x0
 39a:	f5e080e7          	jalr	-162(ra) # 2f4 <write>
}
 39e:	60e2                	ld	ra,24(sp)
 3a0:	6442                	ld	s0,16(sp)
 3a2:	6105                	addi	sp,sp,32
 3a4:	8082                	ret

00000000000003a6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3a6:	7139                	addi	sp,sp,-64
 3a8:	fc06                	sd	ra,56(sp)
 3aa:	f822                	sd	s0,48(sp)
 3ac:	f04a                	sd	s2,32(sp)
 3ae:	ec4e                	sd	s3,24(sp)
 3b0:	0080                	addi	s0,sp,64
 3b2:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3b4:	cad9                	beqz	a3,44a <printint+0xa4>
 3b6:	01f5d79b          	srliw	a5,a1,0x1f
 3ba:	cbc1                	beqz	a5,44a <printint+0xa4>
    neg = 1;
    x = -xx;
 3bc:	40b005bb          	negw	a1,a1
    neg = 1;
 3c0:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 3c2:	fc040993          	addi	s3,s0,-64
  neg = 0;
 3c6:	86ce                	mv	a3,s3
  i = 0;
 3c8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3ca:	00000817          	auipc	a6,0x0
 3ce:	4ae80813          	addi	a6,a6,1198 # 878 <digits>
 3d2:	88ba                	mv	a7,a4
 3d4:	0017051b          	addiw	a0,a4,1
 3d8:	872a                	mv	a4,a0
 3da:	02c5f7bb          	remuw	a5,a1,a2
 3de:	1782                	slli	a5,a5,0x20
 3e0:	9381                	srli	a5,a5,0x20
 3e2:	97c2                	add	a5,a5,a6
 3e4:	0007c783          	lbu	a5,0(a5)
 3e8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3ec:	87ae                	mv	a5,a1
 3ee:	02c5d5bb          	divuw	a1,a1,a2
 3f2:	0685                	addi	a3,a3,1
 3f4:	fcc7ffe3          	bgeu	a5,a2,3d2 <printint+0x2c>
  if(neg)
 3f8:	00030c63          	beqz	t1,410 <printint+0x6a>
    buf[i++] = '-';
 3fc:	fd050793          	addi	a5,a0,-48
 400:	00878533          	add	a0,a5,s0
 404:	02d00793          	li	a5,45
 408:	fef50823          	sb	a5,-16(a0)
 40c:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 410:	02e05763          	blez	a4,43e <printint+0x98>
 414:	f426                	sd	s1,40(sp)
 416:	377d                	addiw	a4,a4,-1
 418:	00e984b3          	add	s1,s3,a4
 41c:	19fd                	addi	s3,s3,-1
 41e:	99ba                	add	s3,s3,a4
 420:	1702                	slli	a4,a4,0x20
 422:	9301                	srli	a4,a4,0x20
 424:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 428:	0004c583          	lbu	a1,0(s1)
 42c:	854a                	mv	a0,s2
 42e:	00000097          	auipc	ra,0x0
 432:	f56080e7          	jalr	-170(ra) # 384 <putc>
  while(--i >= 0)
 436:	14fd                	addi	s1,s1,-1
 438:	ff3498e3          	bne	s1,s3,428 <printint+0x82>
 43c:	74a2                	ld	s1,40(sp)
}
 43e:	70e2                	ld	ra,56(sp)
 440:	7442                	ld	s0,48(sp)
 442:	7902                	ld	s2,32(sp)
 444:	69e2                	ld	s3,24(sp)
 446:	6121                	addi	sp,sp,64
 448:	8082                	ret
  neg = 0;
 44a:	4301                	li	t1,0
 44c:	bf9d                	j	3c2 <printint+0x1c>

000000000000044e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 44e:	715d                	addi	sp,sp,-80
 450:	e486                	sd	ra,72(sp)
 452:	e0a2                	sd	s0,64(sp)
 454:	f84a                	sd	s2,48(sp)
 456:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 458:	0005c903          	lbu	s2,0(a1)
 45c:	1a090b63          	beqz	s2,612 <vprintf+0x1c4>
 460:	fc26                	sd	s1,56(sp)
 462:	f44e                	sd	s3,40(sp)
 464:	f052                	sd	s4,32(sp)
 466:	ec56                	sd	s5,24(sp)
 468:	e85a                	sd	s6,16(sp)
 46a:	e45e                	sd	s7,8(sp)
 46c:	8aaa                	mv	s5,a0
 46e:	8bb2                	mv	s7,a2
 470:	00158493          	addi	s1,a1,1
  state = 0;
 474:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 476:	02500a13          	li	s4,37
 47a:	4b55                	li	s6,21
 47c:	a839                	j	49a <vprintf+0x4c>
        putc(fd, c);
 47e:	85ca                	mv	a1,s2
 480:	8556                	mv	a0,s5
 482:	00000097          	auipc	ra,0x0
 486:	f02080e7          	jalr	-254(ra) # 384 <putc>
 48a:	a019                	j	490 <vprintf+0x42>
    } else if(state == '%'){
 48c:	01498d63          	beq	s3,s4,4a6 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 490:	0485                	addi	s1,s1,1
 492:	fff4c903          	lbu	s2,-1(s1)
 496:	16090863          	beqz	s2,606 <vprintf+0x1b8>
    if(state == 0){
 49a:	fe0999e3          	bnez	s3,48c <vprintf+0x3e>
      if(c == '%'){
 49e:	ff4910e3          	bne	s2,s4,47e <vprintf+0x30>
        state = '%';
 4a2:	89d2                	mv	s3,s4
 4a4:	b7f5                	j	490 <vprintf+0x42>
      if(c == 'd'){
 4a6:	13490563          	beq	s2,s4,5d0 <vprintf+0x182>
 4aa:	f9d9079b          	addiw	a5,s2,-99
 4ae:	0ff7f793          	zext.b	a5,a5
 4b2:	12fb6863          	bltu	s6,a5,5e2 <vprintf+0x194>
 4b6:	f9d9079b          	addiw	a5,s2,-99
 4ba:	0ff7f713          	zext.b	a4,a5
 4be:	12eb6263          	bltu	s6,a4,5e2 <vprintf+0x194>
 4c2:	00271793          	slli	a5,a4,0x2
 4c6:	00000717          	auipc	a4,0x0
 4ca:	35a70713          	addi	a4,a4,858 # 820 <malloc+0x11a>
 4ce:	97ba                	add	a5,a5,a4
 4d0:	439c                	lw	a5,0(a5)
 4d2:	97ba                	add	a5,a5,a4
 4d4:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4d6:	008b8913          	addi	s2,s7,8
 4da:	4685                	li	a3,1
 4dc:	4629                	li	a2,10
 4de:	000ba583          	lw	a1,0(s7)
 4e2:	8556                	mv	a0,s5
 4e4:	00000097          	auipc	ra,0x0
 4e8:	ec2080e7          	jalr	-318(ra) # 3a6 <printint>
 4ec:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4ee:	4981                	li	s3,0
 4f0:	b745                	j	490 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4f2:	008b8913          	addi	s2,s7,8
 4f6:	4681                	li	a3,0
 4f8:	4629                	li	a2,10
 4fa:	000ba583          	lw	a1,0(s7)
 4fe:	8556                	mv	a0,s5
 500:	00000097          	auipc	ra,0x0
 504:	ea6080e7          	jalr	-346(ra) # 3a6 <printint>
 508:	8bca                	mv	s7,s2
      state = 0;
 50a:	4981                	li	s3,0
 50c:	b751                	j	490 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 50e:	008b8913          	addi	s2,s7,8
 512:	4681                	li	a3,0
 514:	4641                	li	a2,16
 516:	000ba583          	lw	a1,0(s7)
 51a:	8556                	mv	a0,s5
 51c:	00000097          	auipc	ra,0x0
 520:	e8a080e7          	jalr	-374(ra) # 3a6 <printint>
 524:	8bca                	mv	s7,s2
      state = 0;
 526:	4981                	li	s3,0
 528:	b7a5                	j	490 <vprintf+0x42>
 52a:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 52c:	008b8793          	addi	a5,s7,8
 530:	8c3e                	mv	s8,a5
 532:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 536:	03000593          	li	a1,48
 53a:	8556                	mv	a0,s5
 53c:	00000097          	auipc	ra,0x0
 540:	e48080e7          	jalr	-440(ra) # 384 <putc>
  putc(fd, 'x');
 544:	07800593          	li	a1,120
 548:	8556                	mv	a0,s5
 54a:	00000097          	auipc	ra,0x0
 54e:	e3a080e7          	jalr	-454(ra) # 384 <putc>
 552:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 554:	00000b97          	auipc	s7,0x0
 558:	324b8b93          	addi	s7,s7,804 # 878 <digits>
 55c:	03c9d793          	srli	a5,s3,0x3c
 560:	97de                	add	a5,a5,s7
 562:	0007c583          	lbu	a1,0(a5)
 566:	8556                	mv	a0,s5
 568:	00000097          	auipc	ra,0x0
 56c:	e1c080e7          	jalr	-484(ra) # 384 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 570:	0992                	slli	s3,s3,0x4
 572:	397d                	addiw	s2,s2,-1
 574:	fe0914e3          	bnez	s2,55c <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 578:	8be2                	mv	s7,s8
      state = 0;
 57a:	4981                	li	s3,0
 57c:	6c02                	ld	s8,0(sp)
 57e:	bf09                	j	490 <vprintf+0x42>
        s = va_arg(ap, char*);
 580:	008b8993          	addi	s3,s7,8
 584:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 588:	02090163          	beqz	s2,5aa <vprintf+0x15c>
        while(*s != 0){
 58c:	00094583          	lbu	a1,0(s2)
 590:	c9a5                	beqz	a1,600 <vprintf+0x1b2>
          putc(fd, *s);
 592:	8556                	mv	a0,s5
 594:	00000097          	auipc	ra,0x0
 598:	df0080e7          	jalr	-528(ra) # 384 <putc>
          s++;
 59c:	0905                	addi	s2,s2,1
        while(*s != 0){
 59e:	00094583          	lbu	a1,0(s2)
 5a2:	f9e5                	bnez	a1,592 <vprintf+0x144>
        s = va_arg(ap, char*);
 5a4:	8bce                	mv	s7,s3
      state = 0;
 5a6:	4981                	li	s3,0
 5a8:	b5e5                	j	490 <vprintf+0x42>
          s = "(null)";
 5aa:	00000917          	auipc	s2,0x0
 5ae:	26e90913          	addi	s2,s2,622 # 818 <malloc+0x112>
        while(*s != 0){
 5b2:	02800593          	li	a1,40
 5b6:	bff1                	j	592 <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 5b8:	008b8913          	addi	s2,s7,8
 5bc:	000bc583          	lbu	a1,0(s7)
 5c0:	8556                	mv	a0,s5
 5c2:	00000097          	auipc	ra,0x0
 5c6:	dc2080e7          	jalr	-574(ra) # 384 <putc>
 5ca:	8bca                	mv	s7,s2
      state = 0;
 5cc:	4981                	li	s3,0
 5ce:	b5c9                	j	490 <vprintf+0x42>
        putc(fd, c);
 5d0:	02500593          	li	a1,37
 5d4:	8556                	mv	a0,s5
 5d6:	00000097          	auipc	ra,0x0
 5da:	dae080e7          	jalr	-594(ra) # 384 <putc>
      state = 0;
 5de:	4981                	li	s3,0
 5e0:	bd45                	j	490 <vprintf+0x42>
        putc(fd, '%');
 5e2:	02500593          	li	a1,37
 5e6:	8556                	mv	a0,s5
 5e8:	00000097          	auipc	ra,0x0
 5ec:	d9c080e7          	jalr	-612(ra) # 384 <putc>
        putc(fd, c);
 5f0:	85ca                	mv	a1,s2
 5f2:	8556                	mv	a0,s5
 5f4:	00000097          	auipc	ra,0x0
 5f8:	d90080e7          	jalr	-624(ra) # 384 <putc>
      state = 0;
 5fc:	4981                	li	s3,0
 5fe:	bd49                	j	490 <vprintf+0x42>
        s = va_arg(ap, char*);
 600:	8bce                	mv	s7,s3
      state = 0;
 602:	4981                	li	s3,0
 604:	b571                	j	490 <vprintf+0x42>
 606:	74e2                	ld	s1,56(sp)
 608:	79a2                	ld	s3,40(sp)
 60a:	7a02                	ld	s4,32(sp)
 60c:	6ae2                	ld	s5,24(sp)
 60e:	6b42                	ld	s6,16(sp)
 610:	6ba2                	ld	s7,8(sp)
    }
  }
}
 612:	60a6                	ld	ra,72(sp)
 614:	6406                	ld	s0,64(sp)
 616:	7942                	ld	s2,48(sp)
 618:	6161                	addi	sp,sp,80
 61a:	8082                	ret

000000000000061c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 61c:	715d                	addi	sp,sp,-80
 61e:	ec06                	sd	ra,24(sp)
 620:	e822                	sd	s0,16(sp)
 622:	1000                	addi	s0,sp,32
 624:	e010                	sd	a2,0(s0)
 626:	e414                	sd	a3,8(s0)
 628:	e818                	sd	a4,16(s0)
 62a:	ec1c                	sd	a5,24(s0)
 62c:	03043023          	sd	a6,32(s0)
 630:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 634:	8622                	mv	a2,s0
 636:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 63a:	00000097          	auipc	ra,0x0
 63e:	e14080e7          	jalr	-492(ra) # 44e <vprintf>
}
 642:	60e2                	ld	ra,24(sp)
 644:	6442                	ld	s0,16(sp)
 646:	6161                	addi	sp,sp,80
 648:	8082                	ret

000000000000064a <printf>:

void
printf(const char *fmt, ...)
{
 64a:	711d                	addi	sp,sp,-96
 64c:	ec06                	sd	ra,24(sp)
 64e:	e822                	sd	s0,16(sp)
 650:	1000                	addi	s0,sp,32
 652:	e40c                	sd	a1,8(s0)
 654:	e810                	sd	a2,16(s0)
 656:	ec14                	sd	a3,24(s0)
 658:	f018                	sd	a4,32(s0)
 65a:	f41c                	sd	a5,40(s0)
 65c:	03043823          	sd	a6,48(s0)
 660:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 664:	00840613          	addi	a2,s0,8
 668:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 66c:	85aa                	mv	a1,a0
 66e:	4505                	li	a0,1
 670:	00000097          	auipc	ra,0x0
 674:	dde080e7          	jalr	-546(ra) # 44e <vprintf>
}
 678:	60e2                	ld	ra,24(sp)
 67a:	6442                	ld	s0,16(sp)
 67c:	6125                	addi	sp,sp,96
 67e:	8082                	ret

0000000000000680 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 680:	1141                	addi	sp,sp,-16
 682:	e406                	sd	ra,8(sp)
 684:	e022                	sd	s0,0(sp)
 686:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 688:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 68c:	00000797          	auipc	a5,0x0
 690:	2047b783          	ld	a5,516(a5) # 890 <freep>
 694:	a039                	j	6a2 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 696:	6398                	ld	a4,0(a5)
 698:	00e7e463          	bltu	a5,a4,6a0 <free+0x20>
 69c:	00e6ea63          	bltu	a3,a4,6b0 <free+0x30>
{
 6a0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a2:	fed7fae3          	bgeu	a5,a3,696 <free+0x16>
 6a6:	6398                	ld	a4,0(a5)
 6a8:	00e6e463          	bltu	a3,a4,6b0 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6ac:	fee7eae3          	bltu	a5,a4,6a0 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6b0:	ff852583          	lw	a1,-8(a0)
 6b4:	6390                	ld	a2,0(a5)
 6b6:	02059813          	slli	a6,a1,0x20
 6ba:	01c85713          	srli	a4,a6,0x1c
 6be:	9736                	add	a4,a4,a3
 6c0:	02e60563          	beq	a2,a4,6ea <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 6c4:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 6c8:	4790                	lw	a2,8(a5)
 6ca:	02061593          	slli	a1,a2,0x20
 6ce:	01c5d713          	srli	a4,a1,0x1c
 6d2:	973e                	add	a4,a4,a5
 6d4:	02e68263          	beq	a3,a4,6f8 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 6d8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 6da:	00000717          	auipc	a4,0x0
 6de:	1af73b23          	sd	a5,438(a4) # 890 <freep>
}
 6e2:	60a2                	ld	ra,8(sp)
 6e4:	6402                	ld	s0,0(sp)
 6e6:	0141                	addi	sp,sp,16
 6e8:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 6ea:	4618                	lw	a4,8(a2)
 6ec:	9f2d                	addw	a4,a4,a1
 6ee:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6f2:	6398                	ld	a4,0(a5)
 6f4:	6310                	ld	a2,0(a4)
 6f6:	b7f9                	j	6c4 <free+0x44>
    p->s.size += bp->s.size;
 6f8:	ff852703          	lw	a4,-8(a0)
 6fc:	9f31                	addw	a4,a4,a2
 6fe:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 700:	ff053683          	ld	a3,-16(a0)
 704:	bfd1                	j	6d8 <free+0x58>

0000000000000706 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 706:	7139                	addi	sp,sp,-64
 708:	fc06                	sd	ra,56(sp)
 70a:	f822                	sd	s0,48(sp)
 70c:	f04a                	sd	s2,32(sp)
 70e:	ec4e                	sd	s3,24(sp)
 710:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 712:	02051993          	slli	s3,a0,0x20
 716:	0209d993          	srli	s3,s3,0x20
 71a:	09bd                	addi	s3,s3,15
 71c:	0049d993          	srli	s3,s3,0x4
 720:	2985                	addiw	s3,s3,1
 722:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 724:	00000517          	auipc	a0,0x0
 728:	16c53503          	ld	a0,364(a0) # 890 <freep>
 72c:	c905                	beqz	a0,75c <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 72e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 730:	4798                	lw	a4,8(a5)
 732:	09377a63          	bgeu	a4,s3,7c6 <malloc+0xc0>
 736:	f426                	sd	s1,40(sp)
 738:	e852                	sd	s4,16(sp)
 73a:	e456                	sd	s5,8(sp)
 73c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 73e:	8a4e                	mv	s4,s3
 740:	6705                	lui	a4,0x1
 742:	00e9f363          	bgeu	s3,a4,748 <malloc+0x42>
 746:	6a05                	lui	s4,0x1
 748:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 74c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 750:	00000497          	auipc	s1,0x0
 754:	14048493          	addi	s1,s1,320 # 890 <freep>
  if(p == (char*)-1)
 758:	5afd                	li	s5,-1
 75a:	a089                	j	79c <malloc+0x96>
 75c:	f426                	sd	s1,40(sp)
 75e:	e852                	sd	s4,16(sp)
 760:	e456                	sd	s5,8(sp)
 762:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 764:	00000797          	auipc	a5,0x0
 768:	13478793          	addi	a5,a5,308 # 898 <base>
 76c:	00000717          	auipc	a4,0x0
 770:	12f73223          	sd	a5,292(a4) # 890 <freep>
 774:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 776:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 77a:	b7d1                	j	73e <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 77c:	6398                	ld	a4,0(a5)
 77e:	e118                	sd	a4,0(a0)
 780:	a8b9                	j	7de <malloc+0xd8>
  hp->s.size = nu;
 782:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 786:	0541                	addi	a0,a0,16
 788:	00000097          	auipc	ra,0x0
 78c:	ef8080e7          	jalr	-264(ra) # 680 <free>
  return freep;
 790:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 792:	c135                	beqz	a0,7f6 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 794:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 796:	4798                	lw	a4,8(a5)
 798:	03277363          	bgeu	a4,s2,7be <malloc+0xb8>
    if(p == freep)
 79c:	6098                	ld	a4,0(s1)
 79e:	853e                	mv	a0,a5
 7a0:	fef71ae3          	bne	a4,a5,794 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 7a4:	8552                	mv	a0,s4
 7a6:	00000097          	auipc	ra,0x0
 7aa:	bb6080e7          	jalr	-1098(ra) # 35c <sbrk>
  if(p == (char*)-1)
 7ae:	fd551ae3          	bne	a0,s5,782 <malloc+0x7c>
        return 0;
 7b2:	4501                	li	a0,0
 7b4:	74a2                	ld	s1,40(sp)
 7b6:	6a42                	ld	s4,16(sp)
 7b8:	6aa2                	ld	s5,8(sp)
 7ba:	6b02                	ld	s6,0(sp)
 7bc:	a03d                	j	7ea <malloc+0xe4>
 7be:	74a2                	ld	s1,40(sp)
 7c0:	6a42                	ld	s4,16(sp)
 7c2:	6aa2                	ld	s5,8(sp)
 7c4:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 7c6:	fae90be3          	beq	s2,a4,77c <malloc+0x76>
        p->s.size -= nunits;
 7ca:	4137073b          	subw	a4,a4,s3
 7ce:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7d0:	02071693          	slli	a3,a4,0x20
 7d4:	01c6d713          	srli	a4,a3,0x1c
 7d8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7da:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7de:	00000717          	auipc	a4,0x0
 7e2:	0aa73923          	sd	a0,178(a4) # 890 <freep>
      return (void*)(p + 1);
 7e6:	01078513          	addi	a0,a5,16
  }
}
 7ea:	70e2                	ld	ra,56(sp)
 7ec:	7442                	ld	s0,48(sp)
 7ee:	7902                	ld	s2,32(sp)
 7f0:	69e2                	ld	s3,24(sp)
 7f2:	6121                	addi	sp,sp,64
 7f4:	8082                	ret
 7f6:	74a2                	ld	s1,40(sp)
 7f8:	6a42                	ld	s4,16(sp)
 7fa:	6aa2                	ld	s5,8(sp)
 7fc:	6b02                	ld	s6,0(sp)
 7fe:	b7f5                	j	7ea <malloc+0xe4>
