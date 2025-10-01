
user/_cputime:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(){
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16

    exit(0);
   8:	4501                	li	a0,0
   a:	00000097          	auipc	ra,0x0
   e:	296080e7          	jalr	662(ra) # 2a0 <exit>

0000000000000012 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  12:	1141                	addi	sp,sp,-16
  14:	e406                	sd	ra,8(sp)
  16:	e022                	sd	s0,0(sp)
  18:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  1a:	87aa                	mv	a5,a0
  1c:	0585                	addi	a1,a1,1
  1e:	0785                	addi	a5,a5,1
  20:	fff5c703          	lbu	a4,-1(a1)
  24:	fee78fa3          	sb	a4,-1(a5)
  28:	fb75                	bnez	a4,1c <strcpy+0xa>
    ;
  return os;
}
  2a:	60a2                	ld	ra,8(sp)
  2c:	6402                	ld	s0,0(sp)
  2e:	0141                	addi	sp,sp,16
  30:	8082                	ret

0000000000000032 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  32:	1141                	addi	sp,sp,-16
  34:	e406                	sd	ra,8(sp)
  36:	e022                	sd	s0,0(sp)
  38:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  3a:	00054783          	lbu	a5,0(a0)
  3e:	cb91                	beqz	a5,52 <strcmp+0x20>
  40:	0005c703          	lbu	a4,0(a1)
  44:	00f71763          	bne	a4,a5,52 <strcmp+0x20>
    p++, q++;
  48:	0505                	addi	a0,a0,1
  4a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  4c:	00054783          	lbu	a5,0(a0)
  50:	fbe5                	bnez	a5,40 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  52:	0005c503          	lbu	a0,0(a1)
}
  56:	40a7853b          	subw	a0,a5,a0
  5a:	60a2                	ld	ra,8(sp)
  5c:	6402                	ld	s0,0(sp)
  5e:	0141                	addi	sp,sp,16
  60:	8082                	ret

0000000000000062 <strlen>:

uint
strlen(const char *s)
{
  62:	1141                	addi	sp,sp,-16
  64:	e406                	sd	ra,8(sp)
  66:	e022                	sd	s0,0(sp)
  68:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  6a:	00054783          	lbu	a5,0(a0)
  6e:	cf91                	beqz	a5,8a <strlen+0x28>
  70:	00150793          	addi	a5,a0,1
  74:	86be                	mv	a3,a5
  76:	0785                	addi	a5,a5,1
  78:	fff7c703          	lbu	a4,-1(a5)
  7c:	ff65                	bnez	a4,74 <strlen+0x12>
  7e:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  82:	60a2                	ld	ra,8(sp)
  84:	6402                	ld	s0,0(sp)
  86:	0141                	addi	sp,sp,16
  88:	8082                	ret
  for(n = 0; s[n]; n++)
  8a:	4501                	li	a0,0
  8c:	bfdd                	j	82 <strlen+0x20>

000000000000008e <memset>:

void*
memset(void *dst, int c, uint n)
{
  8e:	1141                	addi	sp,sp,-16
  90:	e406                	sd	ra,8(sp)
  92:	e022                	sd	s0,0(sp)
  94:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  96:	ca19                	beqz	a2,ac <memset+0x1e>
  98:	87aa                	mv	a5,a0
  9a:	1602                	slli	a2,a2,0x20
  9c:	9201                	srli	a2,a2,0x20
  9e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  a2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  a6:	0785                	addi	a5,a5,1
  a8:	fee79de3          	bne	a5,a4,a2 <memset+0x14>
  }
  return dst;
}
  ac:	60a2                	ld	ra,8(sp)
  ae:	6402                	ld	s0,0(sp)
  b0:	0141                	addi	sp,sp,16
  b2:	8082                	ret

00000000000000b4 <strchr>:

char*
strchr(const char *s, char c)
{
  b4:	1141                	addi	sp,sp,-16
  b6:	e406                	sd	ra,8(sp)
  b8:	e022                	sd	s0,0(sp)
  ba:	0800                	addi	s0,sp,16
  for(; *s; s++)
  bc:	00054783          	lbu	a5,0(a0)
  c0:	cf81                	beqz	a5,d8 <strchr+0x24>
    if(*s == c)
  c2:	00f58763          	beq	a1,a5,d0 <strchr+0x1c>
  for(; *s; s++)
  c6:	0505                	addi	a0,a0,1
  c8:	00054783          	lbu	a5,0(a0)
  cc:	fbfd                	bnez	a5,c2 <strchr+0xe>
      return (char*)s;
  return 0;
  ce:	4501                	li	a0,0
}
  d0:	60a2                	ld	ra,8(sp)
  d2:	6402                	ld	s0,0(sp)
  d4:	0141                	addi	sp,sp,16
  d6:	8082                	ret
  return 0;
  d8:	4501                	li	a0,0
  da:	bfdd                	j	d0 <strchr+0x1c>

00000000000000dc <gets>:

char*
gets(char *buf, int max)
{
  dc:	711d                	addi	sp,sp,-96
  de:	ec86                	sd	ra,88(sp)
  e0:	e8a2                	sd	s0,80(sp)
  e2:	e4a6                	sd	s1,72(sp)
  e4:	e0ca                	sd	s2,64(sp)
  e6:	fc4e                	sd	s3,56(sp)
  e8:	f852                	sd	s4,48(sp)
  ea:	f456                	sd	s5,40(sp)
  ec:	f05a                	sd	s6,32(sp)
  ee:	ec5e                	sd	s7,24(sp)
  f0:	e862                	sd	s8,16(sp)
  f2:	1080                	addi	s0,sp,96
  f4:	8baa                	mv	s7,a0
  f6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  f8:	892a                	mv	s2,a0
  fa:	4481                	li	s1,0
    cc = read(0, &c, 1);
  fc:	faf40b13          	addi	s6,s0,-81
 100:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 102:	8c26                	mv	s8,s1
 104:	0014899b          	addiw	s3,s1,1
 108:	84ce                	mv	s1,s3
 10a:	0349d663          	bge	s3,s4,136 <gets+0x5a>
    cc = read(0, &c, 1);
 10e:	8656                	mv	a2,s5
 110:	85da                	mv	a1,s6
 112:	4501                	li	a0,0
 114:	00000097          	auipc	ra,0x0
 118:	1a4080e7          	jalr	420(ra) # 2b8 <read>
    if(cc < 1)
 11c:	00a05d63          	blez	a0,136 <gets+0x5a>
      break;
    buf[i++] = c;
 120:	faf44783          	lbu	a5,-81(s0)
 124:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 128:	0905                	addi	s2,s2,1
 12a:	ff678713          	addi	a4,a5,-10
 12e:	c319                	beqz	a4,134 <gets+0x58>
 130:	17cd                	addi	a5,a5,-13
 132:	fbe1                	bnez	a5,102 <gets+0x26>
    buf[i++] = c;
 134:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 136:	9c5e                	add	s8,s8,s7
 138:	000c0023          	sb	zero,0(s8)
  return buf;
}
 13c:	855e                	mv	a0,s7
 13e:	60e6                	ld	ra,88(sp)
 140:	6446                	ld	s0,80(sp)
 142:	64a6                	ld	s1,72(sp)
 144:	6906                	ld	s2,64(sp)
 146:	79e2                	ld	s3,56(sp)
 148:	7a42                	ld	s4,48(sp)
 14a:	7aa2                	ld	s5,40(sp)
 14c:	7b02                	ld	s6,32(sp)
 14e:	6be2                	ld	s7,24(sp)
 150:	6c42                	ld	s8,16(sp)
 152:	6125                	addi	sp,sp,96
 154:	8082                	ret

0000000000000156 <stat>:

int
stat(const char *n, struct stat *st)
{
 156:	1101                	addi	sp,sp,-32
 158:	ec06                	sd	ra,24(sp)
 15a:	e822                	sd	s0,16(sp)
 15c:	e04a                	sd	s2,0(sp)
 15e:	1000                	addi	s0,sp,32
 160:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 162:	4581                	li	a1,0
 164:	00000097          	auipc	ra,0x0
 168:	17c080e7          	jalr	380(ra) # 2e0 <open>
  if(fd < 0)
 16c:	02054663          	bltz	a0,198 <stat+0x42>
 170:	e426                	sd	s1,8(sp)
 172:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 174:	85ca                	mv	a1,s2
 176:	00000097          	auipc	ra,0x0
 17a:	182080e7          	jalr	386(ra) # 2f8 <fstat>
 17e:	892a                	mv	s2,a0
  close(fd);
 180:	8526                	mv	a0,s1
 182:	00000097          	auipc	ra,0x0
 186:	146080e7          	jalr	326(ra) # 2c8 <close>
  return r;
 18a:	64a2                	ld	s1,8(sp)
}
 18c:	854a                	mv	a0,s2
 18e:	60e2                	ld	ra,24(sp)
 190:	6442                	ld	s0,16(sp)
 192:	6902                	ld	s2,0(sp)
 194:	6105                	addi	sp,sp,32
 196:	8082                	ret
    return -1;
 198:	57fd                	li	a5,-1
 19a:	893e                	mv	s2,a5
 19c:	bfc5                	j	18c <stat+0x36>

000000000000019e <atoi>:

int
atoi(const char *s)
{
 19e:	1141                	addi	sp,sp,-16
 1a0:	e406                	sd	ra,8(sp)
 1a2:	e022                	sd	s0,0(sp)
 1a4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1a6:	00054683          	lbu	a3,0(a0)
 1aa:	fd06879b          	addiw	a5,a3,-48
 1ae:	0ff7f793          	zext.b	a5,a5
 1b2:	4625                	li	a2,9
 1b4:	02f66963          	bltu	a2,a5,1e6 <atoi+0x48>
 1b8:	872a                	mv	a4,a0
  n = 0;
 1ba:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1bc:	0705                	addi	a4,a4,1
 1be:	0025179b          	slliw	a5,a0,0x2
 1c2:	9fa9                	addw	a5,a5,a0
 1c4:	0017979b          	slliw	a5,a5,0x1
 1c8:	9fb5                	addw	a5,a5,a3
 1ca:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1ce:	00074683          	lbu	a3,0(a4)
 1d2:	fd06879b          	addiw	a5,a3,-48
 1d6:	0ff7f793          	zext.b	a5,a5
 1da:	fef671e3          	bgeu	a2,a5,1bc <atoi+0x1e>
  return n;
}
 1de:	60a2                	ld	ra,8(sp)
 1e0:	6402                	ld	s0,0(sp)
 1e2:	0141                	addi	sp,sp,16
 1e4:	8082                	ret
  n = 0;
 1e6:	4501                	li	a0,0
 1e8:	bfdd                	j	1de <atoi+0x40>

00000000000001ea <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1ea:	1141                	addi	sp,sp,-16
 1ec:	e406                	sd	ra,8(sp)
 1ee:	e022                	sd	s0,0(sp)
 1f0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1f2:	02b57563          	bgeu	a0,a1,21c <memmove+0x32>
    while(n-- > 0)
 1f6:	00c05f63          	blez	a2,214 <memmove+0x2a>
 1fa:	1602                	slli	a2,a2,0x20
 1fc:	9201                	srli	a2,a2,0x20
 1fe:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 202:	872a                	mv	a4,a0
      *dst++ = *src++;
 204:	0585                	addi	a1,a1,1
 206:	0705                	addi	a4,a4,1
 208:	fff5c683          	lbu	a3,-1(a1)
 20c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 210:	fee79ae3          	bne	a5,a4,204 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 214:	60a2                	ld	ra,8(sp)
 216:	6402                	ld	s0,0(sp)
 218:	0141                	addi	sp,sp,16
 21a:	8082                	ret
    while(n-- > 0)
 21c:	fec05ce3          	blez	a2,214 <memmove+0x2a>
    dst += n;
 220:	00c50733          	add	a4,a0,a2
    src += n;
 224:	95b2                	add	a1,a1,a2
 226:	fff6079b          	addiw	a5,a2,-1
 22a:	1782                	slli	a5,a5,0x20
 22c:	9381                	srli	a5,a5,0x20
 22e:	fff7c793          	not	a5,a5
 232:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 234:	15fd                	addi	a1,a1,-1
 236:	177d                	addi	a4,a4,-1
 238:	0005c683          	lbu	a3,0(a1)
 23c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 240:	fef71ae3          	bne	a4,a5,234 <memmove+0x4a>
 244:	bfc1                	j	214 <memmove+0x2a>

0000000000000246 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 246:	1141                	addi	sp,sp,-16
 248:	e406                	sd	ra,8(sp)
 24a:	e022                	sd	s0,0(sp)
 24c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 24e:	c61d                	beqz	a2,27c <memcmp+0x36>
 250:	1602                	slli	a2,a2,0x20
 252:	9201                	srli	a2,a2,0x20
 254:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 258:	00054783          	lbu	a5,0(a0)
 25c:	0005c703          	lbu	a4,0(a1)
 260:	00e79863          	bne	a5,a4,270 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 264:	0505                	addi	a0,a0,1
    p2++;
 266:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 268:	fed518e3          	bne	a0,a3,258 <memcmp+0x12>
  }
  return 0;
 26c:	4501                	li	a0,0
 26e:	a019                	j	274 <memcmp+0x2e>
      return *p1 - *p2;
 270:	40e7853b          	subw	a0,a5,a4
}
 274:	60a2                	ld	ra,8(sp)
 276:	6402                	ld	s0,0(sp)
 278:	0141                	addi	sp,sp,16
 27a:	8082                	ret
  return 0;
 27c:	4501                	li	a0,0
 27e:	bfdd                	j	274 <memcmp+0x2e>

0000000000000280 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 280:	1141                	addi	sp,sp,-16
 282:	e406                	sd	ra,8(sp)
 284:	e022                	sd	s0,0(sp)
 286:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 288:	00000097          	auipc	ra,0x0
 28c:	f62080e7          	jalr	-158(ra) # 1ea <memmove>
}
 290:	60a2                	ld	ra,8(sp)
 292:	6402                	ld	s0,0(sp)
 294:	0141                	addi	sp,sp,16
 296:	8082                	ret

0000000000000298 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 298:	4885                	li	a7,1
 ecall
 29a:	00000073          	ecall
 ret
 29e:	8082                	ret

00000000000002a0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2a0:	4889                	li	a7,2
 ecall
 2a2:	00000073          	ecall
 ret
 2a6:	8082                	ret

00000000000002a8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2a8:	488d                	li	a7,3
 ecall
 2aa:	00000073          	ecall
 ret
 2ae:	8082                	ret

00000000000002b0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2b0:	4891                	li	a7,4
 ecall
 2b2:	00000073          	ecall
 ret
 2b6:	8082                	ret

00000000000002b8 <read>:
.global read
read:
 li a7, SYS_read
 2b8:	4895                	li	a7,5
 ecall
 2ba:	00000073          	ecall
 ret
 2be:	8082                	ret

00000000000002c0 <write>:
.global write
write:
 li a7, SYS_write
 2c0:	48c1                	li	a7,16
 ecall
 2c2:	00000073          	ecall
 ret
 2c6:	8082                	ret

00000000000002c8 <close>:
.global close
close:
 li a7, SYS_close
 2c8:	48d5                	li	a7,21
 ecall
 2ca:	00000073          	ecall
 ret
 2ce:	8082                	ret

00000000000002d0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2d0:	4899                	li	a7,6
 ecall
 2d2:	00000073          	ecall
 ret
 2d6:	8082                	ret

00000000000002d8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2d8:	489d                	li	a7,7
 ecall
 2da:	00000073          	ecall
 ret
 2de:	8082                	ret

00000000000002e0 <open>:
.global open
open:
 li a7, SYS_open
 2e0:	48bd                	li	a7,15
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2e8:	48c5                	li	a7,17
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2f0:	48c9                	li	a7,18
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2f8:	48a1                	li	a7,8
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <link>:
.global link
link:
 li a7, SYS_link
 300:	48cd                	li	a7,19
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 308:	48d1                	li	a7,20
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 310:	48a5                	li	a7,9
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <dup>:
.global dup
dup:
 li a7, SYS_dup
 318:	48a9                	li	a7,10
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 320:	48ad                	li	a7,11
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 328:	48b1                	li	a7,12
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 330:	48b5                	li	a7,13
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 338:	48b9                	li	a7,14
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <cputime>:
.global cputime
cputime:
 li a7, SYS_cputime
 340:	48d9                	li	a7,22
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <wait2>:
.global wait2
wait2:
 li a7, SYS_wait2
 348:	48dd                	li	a7,23
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 350:	1101                	addi	sp,sp,-32
 352:	ec06                	sd	ra,24(sp)
 354:	e822                	sd	s0,16(sp)
 356:	1000                	addi	s0,sp,32
 358:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 35c:	4605                	li	a2,1
 35e:	fef40593          	addi	a1,s0,-17
 362:	00000097          	auipc	ra,0x0
 366:	f5e080e7          	jalr	-162(ra) # 2c0 <write>
}
 36a:	60e2                	ld	ra,24(sp)
 36c:	6442                	ld	s0,16(sp)
 36e:	6105                	addi	sp,sp,32
 370:	8082                	ret

0000000000000372 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 372:	7139                	addi	sp,sp,-64
 374:	fc06                	sd	ra,56(sp)
 376:	f822                	sd	s0,48(sp)
 378:	f04a                	sd	s2,32(sp)
 37a:	ec4e                	sd	s3,24(sp)
 37c:	0080                	addi	s0,sp,64
 37e:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 380:	cad9                	beqz	a3,416 <printint+0xa4>
 382:	01f5d79b          	srliw	a5,a1,0x1f
 386:	cbc1                	beqz	a5,416 <printint+0xa4>
    neg = 1;
    x = -xx;
 388:	40b005bb          	negw	a1,a1
    neg = 1;
 38c:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 38e:	fc040993          	addi	s3,s0,-64
  neg = 0;
 392:	86ce                	mv	a3,s3
  i = 0;
 394:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 396:	00000817          	auipc	a6,0x0
 39a:	49a80813          	addi	a6,a6,1178 # 830 <digits>
 39e:	88ba                	mv	a7,a4
 3a0:	0017051b          	addiw	a0,a4,1
 3a4:	872a                	mv	a4,a0
 3a6:	02c5f7bb          	remuw	a5,a1,a2
 3aa:	1782                	slli	a5,a5,0x20
 3ac:	9381                	srli	a5,a5,0x20
 3ae:	97c2                	add	a5,a5,a6
 3b0:	0007c783          	lbu	a5,0(a5)
 3b4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3b8:	87ae                	mv	a5,a1
 3ba:	02c5d5bb          	divuw	a1,a1,a2
 3be:	0685                	addi	a3,a3,1
 3c0:	fcc7ffe3          	bgeu	a5,a2,39e <printint+0x2c>
  if(neg)
 3c4:	00030c63          	beqz	t1,3dc <printint+0x6a>
    buf[i++] = '-';
 3c8:	fd050793          	addi	a5,a0,-48
 3cc:	00878533          	add	a0,a5,s0
 3d0:	02d00793          	li	a5,45
 3d4:	fef50823          	sb	a5,-16(a0)
 3d8:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 3dc:	02e05763          	blez	a4,40a <printint+0x98>
 3e0:	f426                	sd	s1,40(sp)
 3e2:	377d                	addiw	a4,a4,-1
 3e4:	00e984b3          	add	s1,s3,a4
 3e8:	19fd                	addi	s3,s3,-1
 3ea:	99ba                	add	s3,s3,a4
 3ec:	1702                	slli	a4,a4,0x20
 3ee:	9301                	srli	a4,a4,0x20
 3f0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3f4:	0004c583          	lbu	a1,0(s1)
 3f8:	854a                	mv	a0,s2
 3fa:	00000097          	auipc	ra,0x0
 3fe:	f56080e7          	jalr	-170(ra) # 350 <putc>
  while(--i >= 0)
 402:	14fd                	addi	s1,s1,-1
 404:	ff3498e3          	bne	s1,s3,3f4 <printint+0x82>
 408:	74a2                	ld	s1,40(sp)
}
 40a:	70e2                	ld	ra,56(sp)
 40c:	7442                	ld	s0,48(sp)
 40e:	7902                	ld	s2,32(sp)
 410:	69e2                	ld	s3,24(sp)
 412:	6121                	addi	sp,sp,64
 414:	8082                	ret
  neg = 0;
 416:	4301                	li	t1,0
 418:	bf9d                	j	38e <printint+0x1c>

000000000000041a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 41a:	715d                	addi	sp,sp,-80
 41c:	e486                	sd	ra,72(sp)
 41e:	e0a2                	sd	s0,64(sp)
 420:	f84a                	sd	s2,48(sp)
 422:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 424:	0005c903          	lbu	s2,0(a1)
 428:	1a090b63          	beqz	s2,5de <vprintf+0x1c4>
 42c:	fc26                	sd	s1,56(sp)
 42e:	f44e                	sd	s3,40(sp)
 430:	f052                	sd	s4,32(sp)
 432:	ec56                	sd	s5,24(sp)
 434:	e85a                	sd	s6,16(sp)
 436:	e45e                	sd	s7,8(sp)
 438:	8aaa                	mv	s5,a0
 43a:	8bb2                	mv	s7,a2
 43c:	00158493          	addi	s1,a1,1
  state = 0;
 440:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 442:	02500a13          	li	s4,37
 446:	4b55                	li	s6,21
 448:	a839                	j	466 <vprintf+0x4c>
        putc(fd, c);
 44a:	85ca                	mv	a1,s2
 44c:	8556                	mv	a0,s5
 44e:	00000097          	auipc	ra,0x0
 452:	f02080e7          	jalr	-254(ra) # 350 <putc>
 456:	a019                	j	45c <vprintf+0x42>
    } else if(state == '%'){
 458:	01498d63          	beq	s3,s4,472 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 45c:	0485                	addi	s1,s1,1
 45e:	fff4c903          	lbu	s2,-1(s1)
 462:	16090863          	beqz	s2,5d2 <vprintf+0x1b8>
    if(state == 0){
 466:	fe0999e3          	bnez	s3,458 <vprintf+0x3e>
      if(c == '%'){
 46a:	ff4910e3          	bne	s2,s4,44a <vprintf+0x30>
        state = '%';
 46e:	89d2                	mv	s3,s4
 470:	b7f5                	j	45c <vprintf+0x42>
      if(c == 'd'){
 472:	13490563          	beq	s2,s4,59c <vprintf+0x182>
 476:	f9d9079b          	addiw	a5,s2,-99
 47a:	0ff7f793          	zext.b	a5,a5
 47e:	12fb6863          	bltu	s6,a5,5ae <vprintf+0x194>
 482:	f9d9079b          	addiw	a5,s2,-99
 486:	0ff7f713          	zext.b	a4,a5
 48a:	12eb6263          	bltu	s6,a4,5ae <vprintf+0x194>
 48e:	00271793          	slli	a5,a4,0x2
 492:	00000717          	auipc	a4,0x0
 496:	34670713          	addi	a4,a4,838 # 7d8 <malloc+0x106>
 49a:	97ba                	add	a5,a5,a4
 49c:	439c                	lw	a5,0(a5)
 49e:	97ba                	add	a5,a5,a4
 4a0:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4a2:	008b8913          	addi	s2,s7,8
 4a6:	4685                	li	a3,1
 4a8:	4629                	li	a2,10
 4aa:	000ba583          	lw	a1,0(s7)
 4ae:	8556                	mv	a0,s5
 4b0:	00000097          	auipc	ra,0x0
 4b4:	ec2080e7          	jalr	-318(ra) # 372 <printint>
 4b8:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4ba:	4981                	li	s3,0
 4bc:	b745                	j	45c <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4be:	008b8913          	addi	s2,s7,8
 4c2:	4681                	li	a3,0
 4c4:	4629                	li	a2,10
 4c6:	000ba583          	lw	a1,0(s7)
 4ca:	8556                	mv	a0,s5
 4cc:	00000097          	auipc	ra,0x0
 4d0:	ea6080e7          	jalr	-346(ra) # 372 <printint>
 4d4:	8bca                	mv	s7,s2
      state = 0;
 4d6:	4981                	li	s3,0
 4d8:	b751                	j	45c <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 4da:	008b8913          	addi	s2,s7,8
 4de:	4681                	li	a3,0
 4e0:	4641                	li	a2,16
 4e2:	000ba583          	lw	a1,0(s7)
 4e6:	8556                	mv	a0,s5
 4e8:	00000097          	auipc	ra,0x0
 4ec:	e8a080e7          	jalr	-374(ra) # 372 <printint>
 4f0:	8bca                	mv	s7,s2
      state = 0;
 4f2:	4981                	li	s3,0
 4f4:	b7a5                	j	45c <vprintf+0x42>
 4f6:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 4f8:	008b8793          	addi	a5,s7,8
 4fc:	8c3e                	mv	s8,a5
 4fe:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 502:	03000593          	li	a1,48
 506:	8556                	mv	a0,s5
 508:	00000097          	auipc	ra,0x0
 50c:	e48080e7          	jalr	-440(ra) # 350 <putc>
  putc(fd, 'x');
 510:	07800593          	li	a1,120
 514:	8556                	mv	a0,s5
 516:	00000097          	auipc	ra,0x0
 51a:	e3a080e7          	jalr	-454(ra) # 350 <putc>
 51e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 520:	00000b97          	auipc	s7,0x0
 524:	310b8b93          	addi	s7,s7,784 # 830 <digits>
 528:	03c9d793          	srli	a5,s3,0x3c
 52c:	97de                	add	a5,a5,s7
 52e:	0007c583          	lbu	a1,0(a5)
 532:	8556                	mv	a0,s5
 534:	00000097          	auipc	ra,0x0
 538:	e1c080e7          	jalr	-484(ra) # 350 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 53c:	0992                	slli	s3,s3,0x4
 53e:	397d                	addiw	s2,s2,-1
 540:	fe0914e3          	bnez	s2,528 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 544:	8be2                	mv	s7,s8
      state = 0;
 546:	4981                	li	s3,0
 548:	6c02                	ld	s8,0(sp)
 54a:	bf09                	j	45c <vprintf+0x42>
        s = va_arg(ap, char*);
 54c:	008b8993          	addi	s3,s7,8
 550:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 554:	02090163          	beqz	s2,576 <vprintf+0x15c>
        while(*s != 0){
 558:	00094583          	lbu	a1,0(s2)
 55c:	c9a5                	beqz	a1,5cc <vprintf+0x1b2>
          putc(fd, *s);
 55e:	8556                	mv	a0,s5
 560:	00000097          	auipc	ra,0x0
 564:	df0080e7          	jalr	-528(ra) # 350 <putc>
          s++;
 568:	0905                	addi	s2,s2,1
        while(*s != 0){
 56a:	00094583          	lbu	a1,0(s2)
 56e:	f9e5                	bnez	a1,55e <vprintf+0x144>
        s = va_arg(ap, char*);
 570:	8bce                	mv	s7,s3
      state = 0;
 572:	4981                	li	s3,0
 574:	b5e5                	j	45c <vprintf+0x42>
          s = "(null)";
 576:	00000917          	auipc	s2,0x0
 57a:	25a90913          	addi	s2,s2,602 # 7d0 <malloc+0xfe>
        while(*s != 0){
 57e:	02800593          	li	a1,40
 582:	bff1                	j	55e <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 584:	008b8913          	addi	s2,s7,8
 588:	000bc583          	lbu	a1,0(s7)
 58c:	8556                	mv	a0,s5
 58e:	00000097          	auipc	ra,0x0
 592:	dc2080e7          	jalr	-574(ra) # 350 <putc>
 596:	8bca                	mv	s7,s2
      state = 0;
 598:	4981                	li	s3,0
 59a:	b5c9                	j	45c <vprintf+0x42>
        putc(fd, c);
 59c:	02500593          	li	a1,37
 5a0:	8556                	mv	a0,s5
 5a2:	00000097          	auipc	ra,0x0
 5a6:	dae080e7          	jalr	-594(ra) # 350 <putc>
      state = 0;
 5aa:	4981                	li	s3,0
 5ac:	bd45                	j	45c <vprintf+0x42>
        putc(fd, '%');
 5ae:	02500593          	li	a1,37
 5b2:	8556                	mv	a0,s5
 5b4:	00000097          	auipc	ra,0x0
 5b8:	d9c080e7          	jalr	-612(ra) # 350 <putc>
        putc(fd, c);
 5bc:	85ca                	mv	a1,s2
 5be:	8556                	mv	a0,s5
 5c0:	00000097          	auipc	ra,0x0
 5c4:	d90080e7          	jalr	-624(ra) # 350 <putc>
      state = 0;
 5c8:	4981                	li	s3,0
 5ca:	bd49                	j	45c <vprintf+0x42>
        s = va_arg(ap, char*);
 5cc:	8bce                	mv	s7,s3
      state = 0;
 5ce:	4981                	li	s3,0
 5d0:	b571                	j	45c <vprintf+0x42>
 5d2:	74e2                	ld	s1,56(sp)
 5d4:	79a2                	ld	s3,40(sp)
 5d6:	7a02                	ld	s4,32(sp)
 5d8:	6ae2                	ld	s5,24(sp)
 5da:	6b42                	ld	s6,16(sp)
 5dc:	6ba2                	ld	s7,8(sp)
    }
  }
}
 5de:	60a6                	ld	ra,72(sp)
 5e0:	6406                	ld	s0,64(sp)
 5e2:	7942                	ld	s2,48(sp)
 5e4:	6161                	addi	sp,sp,80
 5e6:	8082                	ret

00000000000005e8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 5e8:	715d                	addi	sp,sp,-80
 5ea:	ec06                	sd	ra,24(sp)
 5ec:	e822                	sd	s0,16(sp)
 5ee:	1000                	addi	s0,sp,32
 5f0:	e010                	sd	a2,0(s0)
 5f2:	e414                	sd	a3,8(s0)
 5f4:	e818                	sd	a4,16(s0)
 5f6:	ec1c                	sd	a5,24(s0)
 5f8:	03043023          	sd	a6,32(s0)
 5fc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 600:	8622                	mv	a2,s0
 602:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 606:	00000097          	auipc	ra,0x0
 60a:	e14080e7          	jalr	-492(ra) # 41a <vprintf>
}
 60e:	60e2                	ld	ra,24(sp)
 610:	6442                	ld	s0,16(sp)
 612:	6161                	addi	sp,sp,80
 614:	8082                	ret

0000000000000616 <printf>:

void
printf(const char *fmt, ...)
{
 616:	711d                	addi	sp,sp,-96
 618:	ec06                	sd	ra,24(sp)
 61a:	e822                	sd	s0,16(sp)
 61c:	1000                	addi	s0,sp,32
 61e:	e40c                	sd	a1,8(s0)
 620:	e810                	sd	a2,16(s0)
 622:	ec14                	sd	a3,24(s0)
 624:	f018                	sd	a4,32(s0)
 626:	f41c                	sd	a5,40(s0)
 628:	03043823          	sd	a6,48(s0)
 62c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 630:	00840613          	addi	a2,s0,8
 634:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 638:	85aa                	mv	a1,a0
 63a:	4505                	li	a0,1
 63c:	00000097          	auipc	ra,0x0
 640:	dde080e7          	jalr	-546(ra) # 41a <vprintf>
}
 644:	60e2                	ld	ra,24(sp)
 646:	6442                	ld	s0,16(sp)
 648:	6125                	addi	sp,sp,96
 64a:	8082                	ret

000000000000064c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 64c:	1141                	addi	sp,sp,-16
 64e:	e406                	sd	ra,8(sp)
 650:	e022                	sd	s0,0(sp)
 652:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 654:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 658:	00000797          	auipc	a5,0x0
 65c:	1f07b783          	ld	a5,496(a5) # 848 <freep>
 660:	a039                	j	66e <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 662:	6398                	ld	a4,0(a5)
 664:	00e7e463          	bltu	a5,a4,66c <free+0x20>
 668:	00e6ea63          	bltu	a3,a4,67c <free+0x30>
{
 66c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 66e:	fed7fae3          	bgeu	a5,a3,662 <free+0x16>
 672:	6398                	ld	a4,0(a5)
 674:	00e6e463          	bltu	a3,a4,67c <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 678:	fee7eae3          	bltu	a5,a4,66c <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 67c:	ff852583          	lw	a1,-8(a0)
 680:	6390                	ld	a2,0(a5)
 682:	02059813          	slli	a6,a1,0x20
 686:	01c85713          	srli	a4,a6,0x1c
 68a:	9736                	add	a4,a4,a3
 68c:	02e60563          	beq	a2,a4,6b6 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 690:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 694:	4790                	lw	a2,8(a5)
 696:	02061593          	slli	a1,a2,0x20
 69a:	01c5d713          	srli	a4,a1,0x1c
 69e:	973e                	add	a4,a4,a5
 6a0:	02e68263          	beq	a3,a4,6c4 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 6a4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 6a6:	00000717          	auipc	a4,0x0
 6aa:	1af73123          	sd	a5,418(a4) # 848 <freep>
}
 6ae:	60a2                	ld	ra,8(sp)
 6b0:	6402                	ld	s0,0(sp)
 6b2:	0141                	addi	sp,sp,16
 6b4:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 6b6:	4618                	lw	a4,8(a2)
 6b8:	9f2d                	addw	a4,a4,a1
 6ba:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6be:	6398                	ld	a4,0(a5)
 6c0:	6310                	ld	a2,0(a4)
 6c2:	b7f9                	j	690 <free+0x44>
    p->s.size += bp->s.size;
 6c4:	ff852703          	lw	a4,-8(a0)
 6c8:	9f31                	addw	a4,a4,a2
 6ca:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 6cc:	ff053683          	ld	a3,-16(a0)
 6d0:	bfd1                	j	6a4 <free+0x58>

00000000000006d2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6d2:	7139                	addi	sp,sp,-64
 6d4:	fc06                	sd	ra,56(sp)
 6d6:	f822                	sd	s0,48(sp)
 6d8:	f04a                	sd	s2,32(sp)
 6da:	ec4e                	sd	s3,24(sp)
 6dc:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6de:	02051993          	slli	s3,a0,0x20
 6e2:	0209d993          	srli	s3,s3,0x20
 6e6:	09bd                	addi	s3,s3,15
 6e8:	0049d993          	srli	s3,s3,0x4
 6ec:	2985                	addiw	s3,s3,1
 6ee:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 6f0:	00000517          	auipc	a0,0x0
 6f4:	15853503          	ld	a0,344(a0) # 848 <freep>
 6f8:	c905                	beqz	a0,728 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6fa:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 6fc:	4798                	lw	a4,8(a5)
 6fe:	09377a63          	bgeu	a4,s3,792 <malloc+0xc0>
 702:	f426                	sd	s1,40(sp)
 704:	e852                	sd	s4,16(sp)
 706:	e456                	sd	s5,8(sp)
 708:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 70a:	8a4e                	mv	s4,s3
 70c:	6705                	lui	a4,0x1
 70e:	00e9f363          	bgeu	s3,a4,714 <malloc+0x42>
 712:	6a05                	lui	s4,0x1
 714:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 718:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 71c:	00000497          	auipc	s1,0x0
 720:	12c48493          	addi	s1,s1,300 # 848 <freep>
  if(p == (char*)-1)
 724:	5afd                	li	s5,-1
 726:	a089                	j	768 <malloc+0x96>
 728:	f426                	sd	s1,40(sp)
 72a:	e852                	sd	s4,16(sp)
 72c:	e456                	sd	s5,8(sp)
 72e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 730:	00000797          	auipc	a5,0x0
 734:	12078793          	addi	a5,a5,288 # 850 <base>
 738:	00000717          	auipc	a4,0x0
 73c:	10f73823          	sd	a5,272(a4) # 848 <freep>
 740:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 742:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 746:	b7d1                	j	70a <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 748:	6398                	ld	a4,0(a5)
 74a:	e118                	sd	a4,0(a0)
 74c:	a8b9                	j	7aa <malloc+0xd8>
  hp->s.size = nu;
 74e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 752:	0541                	addi	a0,a0,16
 754:	00000097          	auipc	ra,0x0
 758:	ef8080e7          	jalr	-264(ra) # 64c <free>
  return freep;
 75c:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 75e:	c135                	beqz	a0,7c2 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 760:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 762:	4798                	lw	a4,8(a5)
 764:	03277363          	bgeu	a4,s2,78a <malloc+0xb8>
    if(p == freep)
 768:	6098                	ld	a4,0(s1)
 76a:	853e                	mv	a0,a5
 76c:	fef71ae3          	bne	a4,a5,760 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 770:	8552                	mv	a0,s4
 772:	00000097          	auipc	ra,0x0
 776:	bb6080e7          	jalr	-1098(ra) # 328 <sbrk>
  if(p == (char*)-1)
 77a:	fd551ae3          	bne	a0,s5,74e <malloc+0x7c>
        return 0;
 77e:	4501                	li	a0,0
 780:	74a2                	ld	s1,40(sp)
 782:	6a42                	ld	s4,16(sp)
 784:	6aa2                	ld	s5,8(sp)
 786:	6b02                	ld	s6,0(sp)
 788:	a03d                	j	7b6 <malloc+0xe4>
 78a:	74a2                	ld	s1,40(sp)
 78c:	6a42                	ld	s4,16(sp)
 78e:	6aa2                	ld	s5,8(sp)
 790:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 792:	fae90be3          	beq	s2,a4,748 <malloc+0x76>
        p->s.size -= nunits;
 796:	4137073b          	subw	a4,a4,s3
 79a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 79c:	02071693          	slli	a3,a4,0x20
 7a0:	01c6d713          	srli	a4,a3,0x1c
 7a4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7a6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7aa:	00000717          	auipc	a4,0x0
 7ae:	08a73f23          	sd	a0,158(a4) # 848 <freep>
      return (void*)(p + 1);
 7b2:	01078513          	addi	a0,a5,16
  }
}
 7b6:	70e2                	ld	ra,56(sp)
 7b8:	7442                	ld	s0,48(sp)
 7ba:	7902                	ld	s2,32(sp)
 7bc:	69e2                	ld	s3,24(sp)
 7be:	6121                	addi	sp,sp,64
 7c0:	8082                	ret
 7c2:	74a2                	ld	s1,40(sp)
 7c4:	6a42                	ld	s4,16(sp)
 7c6:	6aa2                	ld	s5,8(sp)
 7c8:	6b02                	ld	s6,0(sp)
 7ca:	b7f5                	j	7b6 <malloc+0xe4>
