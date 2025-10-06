
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
  12:	7ea58593          	addi	a1,a1,2026 # 7f8 <malloc+0xfa>
  16:	853e                	mv	a0,a5
  18:	00000097          	auipc	ra,0x0
  1c:	5fc080e7          	jalr	1532(ra) # 614 <fprintf>
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

0000000000000374 <wait2>:
.global wait2
wait2:
 li a7, SYS_wait2
 374:	48dd                	li	a7,23
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 37c:	1101                	addi	sp,sp,-32
 37e:	ec06                	sd	ra,24(sp)
 380:	e822                	sd	s0,16(sp)
 382:	1000                	addi	s0,sp,32
 384:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 388:	4605                	li	a2,1
 38a:	fef40593          	addi	a1,s0,-17
 38e:	00000097          	auipc	ra,0x0
 392:	f66080e7          	jalr	-154(ra) # 2f4 <write>
}
 396:	60e2                	ld	ra,24(sp)
 398:	6442                	ld	s0,16(sp)
 39a:	6105                	addi	sp,sp,32
 39c:	8082                	ret

000000000000039e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 39e:	7139                	addi	sp,sp,-64
 3a0:	fc06                	sd	ra,56(sp)
 3a2:	f822                	sd	s0,48(sp)
 3a4:	f04a                	sd	s2,32(sp)
 3a6:	ec4e                	sd	s3,24(sp)
 3a8:	0080                	addi	s0,sp,64
 3aa:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3ac:	cad9                	beqz	a3,442 <printint+0xa4>
 3ae:	01f5d79b          	srliw	a5,a1,0x1f
 3b2:	cbc1                	beqz	a5,442 <printint+0xa4>
    neg = 1;
    x = -xx;
 3b4:	40b005bb          	negw	a1,a1
    neg = 1;
 3b8:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 3ba:	fc040993          	addi	s3,s0,-64
  neg = 0;
 3be:	86ce                	mv	a3,s3
  i = 0;
 3c0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3c2:	00000817          	auipc	a6,0x0
 3c6:	4ae80813          	addi	a6,a6,1198 # 870 <digits>
 3ca:	88ba                	mv	a7,a4
 3cc:	0017051b          	addiw	a0,a4,1
 3d0:	872a                	mv	a4,a0
 3d2:	02c5f7bb          	remuw	a5,a1,a2
 3d6:	1782                	slli	a5,a5,0x20
 3d8:	9381                	srli	a5,a5,0x20
 3da:	97c2                	add	a5,a5,a6
 3dc:	0007c783          	lbu	a5,0(a5)
 3e0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3e4:	87ae                	mv	a5,a1
 3e6:	02c5d5bb          	divuw	a1,a1,a2
 3ea:	0685                	addi	a3,a3,1
 3ec:	fcc7ffe3          	bgeu	a5,a2,3ca <printint+0x2c>
  if(neg)
 3f0:	00030c63          	beqz	t1,408 <printint+0x6a>
    buf[i++] = '-';
 3f4:	fd050793          	addi	a5,a0,-48
 3f8:	00878533          	add	a0,a5,s0
 3fc:	02d00793          	li	a5,45
 400:	fef50823          	sb	a5,-16(a0)
 404:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 408:	02e05763          	blez	a4,436 <printint+0x98>
 40c:	f426                	sd	s1,40(sp)
 40e:	377d                	addiw	a4,a4,-1
 410:	00e984b3          	add	s1,s3,a4
 414:	19fd                	addi	s3,s3,-1
 416:	99ba                	add	s3,s3,a4
 418:	1702                	slli	a4,a4,0x20
 41a:	9301                	srli	a4,a4,0x20
 41c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 420:	0004c583          	lbu	a1,0(s1)
 424:	854a                	mv	a0,s2
 426:	00000097          	auipc	ra,0x0
 42a:	f56080e7          	jalr	-170(ra) # 37c <putc>
  while(--i >= 0)
 42e:	14fd                	addi	s1,s1,-1
 430:	ff3498e3          	bne	s1,s3,420 <printint+0x82>
 434:	74a2                	ld	s1,40(sp)
}
 436:	70e2                	ld	ra,56(sp)
 438:	7442                	ld	s0,48(sp)
 43a:	7902                	ld	s2,32(sp)
 43c:	69e2                	ld	s3,24(sp)
 43e:	6121                	addi	sp,sp,64
 440:	8082                	ret
  neg = 0;
 442:	4301                	li	t1,0
 444:	bf9d                	j	3ba <printint+0x1c>

0000000000000446 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 446:	715d                	addi	sp,sp,-80
 448:	e486                	sd	ra,72(sp)
 44a:	e0a2                	sd	s0,64(sp)
 44c:	f84a                	sd	s2,48(sp)
 44e:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 450:	0005c903          	lbu	s2,0(a1)
 454:	1a090b63          	beqz	s2,60a <vprintf+0x1c4>
 458:	fc26                	sd	s1,56(sp)
 45a:	f44e                	sd	s3,40(sp)
 45c:	f052                	sd	s4,32(sp)
 45e:	ec56                	sd	s5,24(sp)
 460:	e85a                	sd	s6,16(sp)
 462:	e45e                	sd	s7,8(sp)
 464:	8aaa                	mv	s5,a0
 466:	8bb2                	mv	s7,a2
 468:	00158493          	addi	s1,a1,1
  state = 0;
 46c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 46e:	02500a13          	li	s4,37
 472:	4b55                	li	s6,21
 474:	a839                	j	492 <vprintf+0x4c>
        putc(fd, c);
 476:	85ca                	mv	a1,s2
 478:	8556                	mv	a0,s5
 47a:	00000097          	auipc	ra,0x0
 47e:	f02080e7          	jalr	-254(ra) # 37c <putc>
 482:	a019                	j	488 <vprintf+0x42>
    } else if(state == '%'){
 484:	01498d63          	beq	s3,s4,49e <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 488:	0485                	addi	s1,s1,1
 48a:	fff4c903          	lbu	s2,-1(s1)
 48e:	16090863          	beqz	s2,5fe <vprintf+0x1b8>
    if(state == 0){
 492:	fe0999e3          	bnez	s3,484 <vprintf+0x3e>
      if(c == '%'){
 496:	ff4910e3          	bne	s2,s4,476 <vprintf+0x30>
        state = '%';
 49a:	89d2                	mv	s3,s4
 49c:	b7f5                	j	488 <vprintf+0x42>
      if(c == 'd'){
 49e:	13490563          	beq	s2,s4,5c8 <vprintf+0x182>
 4a2:	f9d9079b          	addiw	a5,s2,-99
 4a6:	0ff7f793          	zext.b	a5,a5
 4aa:	12fb6863          	bltu	s6,a5,5da <vprintf+0x194>
 4ae:	f9d9079b          	addiw	a5,s2,-99
 4b2:	0ff7f713          	zext.b	a4,a5
 4b6:	12eb6263          	bltu	s6,a4,5da <vprintf+0x194>
 4ba:	00271793          	slli	a5,a4,0x2
 4be:	00000717          	auipc	a4,0x0
 4c2:	35a70713          	addi	a4,a4,858 # 818 <malloc+0x11a>
 4c6:	97ba                	add	a5,a5,a4
 4c8:	439c                	lw	a5,0(a5)
 4ca:	97ba                	add	a5,a5,a4
 4cc:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4ce:	008b8913          	addi	s2,s7,8
 4d2:	4685                	li	a3,1
 4d4:	4629                	li	a2,10
 4d6:	000ba583          	lw	a1,0(s7)
 4da:	8556                	mv	a0,s5
 4dc:	00000097          	auipc	ra,0x0
 4e0:	ec2080e7          	jalr	-318(ra) # 39e <printint>
 4e4:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4e6:	4981                	li	s3,0
 4e8:	b745                	j	488 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4ea:	008b8913          	addi	s2,s7,8
 4ee:	4681                	li	a3,0
 4f0:	4629                	li	a2,10
 4f2:	000ba583          	lw	a1,0(s7)
 4f6:	8556                	mv	a0,s5
 4f8:	00000097          	auipc	ra,0x0
 4fc:	ea6080e7          	jalr	-346(ra) # 39e <printint>
 500:	8bca                	mv	s7,s2
      state = 0;
 502:	4981                	li	s3,0
 504:	b751                	j	488 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 506:	008b8913          	addi	s2,s7,8
 50a:	4681                	li	a3,0
 50c:	4641                	li	a2,16
 50e:	000ba583          	lw	a1,0(s7)
 512:	8556                	mv	a0,s5
 514:	00000097          	auipc	ra,0x0
 518:	e8a080e7          	jalr	-374(ra) # 39e <printint>
 51c:	8bca                	mv	s7,s2
      state = 0;
 51e:	4981                	li	s3,0
 520:	b7a5                	j	488 <vprintf+0x42>
 522:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 524:	008b8793          	addi	a5,s7,8
 528:	8c3e                	mv	s8,a5
 52a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 52e:	03000593          	li	a1,48
 532:	8556                	mv	a0,s5
 534:	00000097          	auipc	ra,0x0
 538:	e48080e7          	jalr	-440(ra) # 37c <putc>
  putc(fd, 'x');
 53c:	07800593          	li	a1,120
 540:	8556                	mv	a0,s5
 542:	00000097          	auipc	ra,0x0
 546:	e3a080e7          	jalr	-454(ra) # 37c <putc>
 54a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 54c:	00000b97          	auipc	s7,0x0
 550:	324b8b93          	addi	s7,s7,804 # 870 <digits>
 554:	03c9d793          	srli	a5,s3,0x3c
 558:	97de                	add	a5,a5,s7
 55a:	0007c583          	lbu	a1,0(a5)
 55e:	8556                	mv	a0,s5
 560:	00000097          	auipc	ra,0x0
 564:	e1c080e7          	jalr	-484(ra) # 37c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 568:	0992                	slli	s3,s3,0x4
 56a:	397d                	addiw	s2,s2,-1
 56c:	fe0914e3          	bnez	s2,554 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 570:	8be2                	mv	s7,s8
      state = 0;
 572:	4981                	li	s3,0
 574:	6c02                	ld	s8,0(sp)
 576:	bf09                	j	488 <vprintf+0x42>
        s = va_arg(ap, char*);
 578:	008b8993          	addi	s3,s7,8
 57c:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 580:	02090163          	beqz	s2,5a2 <vprintf+0x15c>
        while(*s != 0){
 584:	00094583          	lbu	a1,0(s2)
 588:	c9a5                	beqz	a1,5f8 <vprintf+0x1b2>
          putc(fd, *s);
 58a:	8556                	mv	a0,s5
 58c:	00000097          	auipc	ra,0x0
 590:	df0080e7          	jalr	-528(ra) # 37c <putc>
          s++;
 594:	0905                	addi	s2,s2,1
        while(*s != 0){
 596:	00094583          	lbu	a1,0(s2)
 59a:	f9e5                	bnez	a1,58a <vprintf+0x144>
        s = va_arg(ap, char*);
 59c:	8bce                	mv	s7,s3
      state = 0;
 59e:	4981                	li	s3,0
 5a0:	b5e5                	j	488 <vprintf+0x42>
          s = "(null)";
 5a2:	00000917          	auipc	s2,0x0
 5a6:	26e90913          	addi	s2,s2,622 # 810 <malloc+0x112>
        while(*s != 0){
 5aa:	02800593          	li	a1,40
 5ae:	bff1                	j	58a <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 5b0:	008b8913          	addi	s2,s7,8
 5b4:	000bc583          	lbu	a1,0(s7)
 5b8:	8556                	mv	a0,s5
 5ba:	00000097          	auipc	ra,0x0
 5be:	dc2080e7          	jalr	-574(ra) # 37c <putc>
 5c2:	8bca                	mv	s7,s2
      state = 0;
 5c4:	4981                	li	s3,0
 5c6:	b5c9                	j	488 <vprintf+0x42>
        putc(fd, c);
 5c8:	02500593          	li	a1,37
 5cc:	8556                	mv	a0,s5
 5ce:	00000097          	auipc	ra,0x0
 5d2:	dae080e7          	jalr	-594(ra) # 37c <putc>
      state = 0;
 5d6:	4981                	li	s3,0
 5d8:	bd45                	j	488 <vprintf+0x42>
        putc(fd, '%');
 5da:	02500593          	li	a1,37
 5de:	8556                	mv	a0,s5
 5e0:	00000097          	auipc	ra,0x0
 5e4:	d9c080e7          	jalr	-612(ra) # 37c <putc>
        putc(fd, c);
 5e8:	85ca                	mv	a1,s2
 5ea:	8556                	mv	a0,s5
 5ec:	00000097          	auipc	ra,0x0
 5f0:	d90080e7          	jalr	-624(ra) # 37c <putc>
      state = 0;
 5f4:	4981                	li	s3,0
 5f6:	bd49                	j	488 <vprintf+0x42>
        s = va_arg(ap, char*);
 5f8:	8bce                	mv	s7,s3
      state = 0;
 5fa:	4981                	li	s3,0
 5fc:	b571                	j	488 <vprintf+0x42>
 5fe:	74e2                	ld	s1,56(sp)
 600:	79a2                	ld	s3,40(sp)
 602:	7a02                	ld	s4,32(sp)
 604:	6ae2                	ld	s5,24(sp)
 606:	6b42                	ld	s6,16(sp)
 608:	6ba2                	ld	s7,8(sp)
    }
  }
}
 60a:	60a6                	ld	ra,72(sp)
 60c:	6406                	ld	s0,64(sp)
 60e:	7942                	ld	s2,48(sp)
 610:	6161                	addi	sp,sp,80
 612:	8082                	ret

0000000000000614 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 614:	715d                	addi	sp,sp,-80
 616:	ec06                	sd	ra,24(sp)
 618:	e822                	sd	s0,16(sp)
 61a:	1000                	addi	s0,sp,32
 61c:	e010                	sd	a2,0(s0)
 61e:	e414                	sd	a3,8(s0)
 620:	e818                	sd	a4,16(s0)
 622:	ec1c                	sd	a5,24(s0)
 624:	03043023          	sd	a6,32(s0)
 628:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 62c:	8622                	mv	a2,s0
 62e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 632:	00000097          	auipc	ra,0x0
 636:	e14080e7          	jalr	-492(ra) # 446 <vprintf>
}
 63a:	60e2                	ld	ra,24(sp)
 63c:	6442                	ld	s0,16(sp)
 63e:	6161                	addi	sp,sp,80
 640:	8082                	ret

0000000000000642 <printf>:

void
printf(const char *fmt, ...)
{
 642:	711d                	addi	sp,sp,-96
 644:	ec06                	sd	ra,24(sp)
 646:	e822                	sd	s0,16(sp)
 648:	1000                	addi	s0,sp,32
 64a:	e40c                	sd	a1,8(s0)
 64c:	e810                	sd	a2,16(s0)
 64e:	ec14                	sd	a3,24(s0)
 650:	f018                	sd	a4,32(s0)
 652:	f41c                	sd	a5,40(s0)
 654:	03043823          	sd	a6,48(s0)
 658:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 65c:	00840613          	addi	a2,s0,8
 660:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 664:	85aa                	mv	a1,a0
 666:	4505                	li	a0,1
 668:	00000097          	auipc	ra,0x0
 66c:	dde080e7          	jalr	-546(ra) # 446 <vprintf>
}
 670:	60e2                	ld	ra,24(sp)
 672:	6442                	ld	s0,16(sp)
 674:	6125                	addi	sp,sp,96
 676:	8082                	ret

0000000000000678 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 678:	1141                	addi	sp,sp,-16
 67a:	e406                	sd	ra,8(sp)
 67c:	e022                	sd	s0,0(sp)
 67e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 680:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 684:	00000797          	auipc	a5,0x0
 688:	2047b783          	ld	a5,516(a5) # 888 <freep>
 68c:	a039                	j	69a <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 68e:	6398                	ld	a4,0(a5)
 690:	00e7e463          	bltu	a5,a4,698 <free+0x20>
 694:	00e6ea63          	bltu	a3,a4,6a8 <free+0x30>
{
 698:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 69a:	fed7fae3          	bgeu	a5,a3,68e <free+0x16>
 69e:	6398                	ld	a4,0(a5)
 6a0:	00e6e463          	bltu	a3,a4,6a8 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6a4:	fee7eae3          	bltu	a5,a4,698 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6a8:	ff852583          	lw	a1,-8(a0)
 6ac:	6390                	ld	a2,0(a5)
 6ae:	02059813          	slli	a6,a1,0x20
 6b2:	01c85713          	srli	a4,a6,0x1c
 6b6:	9736                	add	a4,a4,a3
 6b8:	02e60563          	beq	a2,a4,6e2 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 6bc:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 6c0:	4790                	lw	a2,8(a5)
 6c2:	02061593          	slli	a1,a2,0x20
 6c6:	01c5d713          	srli	a4,a1,0x1c
 6ca:	973e                	add	a4,a4,a5
 6cc:	02e68263          	beq	a3,a4,6f0 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 6d0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 6d2:	00000717          	auipc	a4,0x0
 6d6:	1af73b23          	sd	a5,438(a4) # 888 <freep>
}
 6da:	60a2                	ld	ra,8(sp)
 6dc:	6402                	ld	s0,0(sp)
 6de:	0141                	addi	sp,sp,16
 6e0:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 6e2:	4618                	lw	a4,8(a2)
 6e4:	9f2d                	addw	a4,a4,a1
 6e6:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6ea:	6398                	ld	a4,0(a5)
 6ec:	6310                	ld	a2,0(a4)
 6ee:	b7f9                	j	6bc <free+0x44>
    p->s.size += bp->s.size;
 6f0:	ff852703          	lw	a4,-8(a0)
 6f4:	9f31                	addw	a4,a4,a2
 6f6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 6f8:	ff053683          	ld	a3,-16(a0)
 6fc:	bfd1                	j	6d0 <free+0x58>

00000000000006fe <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6fe:	7139                	addi	sp,sp,-64
 700:	fc06                	sd	ra,56(sp)
 702:	f822                	sd	s0,48(sp)
 704:	f04a                	sd	s2,32(sp)
 706:	ec4e                	sd	s3,24(sp)
 708:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 70a:	02051993          	slli	s3,a0,0x20
 70e:	0209d993          	srli	s3,s3,0x20
 712:	09bd                	addi	s3,s3,15
 714:	0049d993          	srli	s3,s3,0x4
 718:	2985                	addiw	s3,s3,1
 71a:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 71c:	00000517          	auipc	a0,0x0
 720:	16c53503          	ld	a0,364(a0) # 888 <freep>
 724:	c905                	beqz	a0,754 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 726:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 728:	4798                	lw	a4,8(a5)
 72a:	09377a63          	bgeu	a4,s3,7be <malloc+0xc0>
 72e:	f426                	sd	s1,40(sp)
 730:	e852                	sd	s4,16(sp)
 732:	e456                	sd	s5,8(sp)
 734:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 736:	8a4e                	mv	s4,s3
 738:	6705                	lui	a4,0x1
 73a:	00e9f363          	bgeu	s3,a4,740 <malloc+0x42>
 73e:	6a05                	lui	s4,0x1
 740:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 744:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 748:	00000497          	auipc	s1,0x0
 74c:	14048493          	addi	s1,s1,320 # 888 <freep>
  if(p == (char*)-1)
 750:	5afd                	li	s5,-1
 752:	a089                	j	794 <malloc+0x96>
 754:	f426                	sd	s1,40(sp)
 756:	e852                	sd	s4,16(sp)
 758:	e456                	sd	s5,8(sp)
 75a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 75c:	00000797          	auipc	a5,0x0
 760:	13478793          	addi	a5,a5,308 # 890 <base>
 764:	00000717          	auipc	a4,0x0
 768:	12f73223          	sd	a5,292(a4) # 888 <freep>
 76c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 76e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 772:	b7d1                	j	736 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 774:	6398                	ld	a4,0(a5)
 776:	e118                	sd	a4,0(a0)
 778:	a8b9                	j	7d6 <malloc+0xd8>
  hp->s.size = nu;
 77a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 77e:	0541                	addi	a0,a0,16
 780:	00000097          	auipc	ra,0x0
 784:	ef8080e7          	jalr	-264(ra) # 678 <free>
  return freep;
 788:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 78a:	c135                	beqz	a0,7ee <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 78c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 78e:	4798                	lw	a4,8(a5)
 790:	03277363          	bgeu	a4,s2,7b6 <malloc+0xb8>
    if(p == freep)
 794:	6098                	ld	a4,0(s1)
 796:	853e                	mv	a0,a5
 798:	fef71ae3          	bne	a4,a5,78c <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 79c:	8552                	mv	a0,s4
 79e:	00000097          	auipc	ra,0x0
 7a2:	bbe080e7          	jalr	-1090(ra) # 35c <sbrk>
  if(p == (char*)-1)
 7a6:	fd551ae3          	bne	a0,s5,77a <malloc+0x7c>
        return 0;
 7aa:	4501                	li	a0,0
 7ac:	74a2                	ld	s1,40(sp)
 7ae:	6a42                	ld	s4,16(sp)
 7b0:	6aa2                	ld	s5,8(sp)
 7b2:	6b02                	ld	s6,0(sp)
 7b4:	a03d                	j	7e2 <malloc+0xe4>
 7b6:	74a2                	ld	s1,40(sp)
 7b8:	6a42                	ld	s4,16(sp)
 7ba:	6aa2                	ld	s5,8(sp)
 7bc:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 7be:	fae90be3          	beq	s2,a4,774 <malloc+0x76>
        p->s.size -= nunits;
 7c2:	4137073b          	subw	a4,a4,s3
 7c6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7c8:	02071693          	slli	a3,a4,0x20
 7cc:	01c6d713          	srli	a4,a3,0x1c
 7d0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7d2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7d6:	00000717          	auipc	a4,0x0
 7da:	0aa73923          	sd	a0,178(a4) # 888 <freep>
      return (void*)(p + 1);
 7de:	01078513          	addi	a0,a5,16
  }
}
 7e2:	70e2                	ld	ra,56(sp)
 7e4:	7442                	ld	s0,48(sp)
 7e6:	7902                	ld	s2,32(sp)
 7e8:	69e2                	ld	s3,24(sp)
 7ea:	6121                	addi	sp,sp,64
 7ec:	8082                	ret
 7ee:	74a2                	ld	s1,40(sp)
 7f0:	6a42                	ld	s4,16(sp)
 7f2:	6aa2                	ld	s5,8(sp)
 7f4:	6b02                	ld	s6,0(sp)
 7f6:	b7f5                	j	7e2 <malloc+0xe4>
