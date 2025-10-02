
user/_mkdir:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
 * @argv: array of arguments from command line
 * @argc: number of arguments from the arguments array
 */
int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  int i;
  // Check for valid number of arguments
  // if less than 2, print usage message (description) and exit
  if(argc < 2){
   8:	4785                	li	a5,1
   a:	02a7dd63          	bge	a5,a0,44 <main+0x44>
   e:	e426                	sd	s1,8(sp)
  10:	e04a                	sd	s2,0(sp)
  12:	00858493          	addi	s1,a1,8
  16:	ffe5091b          	addiw	s2,a0,-2
  1a:	02091793          	slli	a5,s2,0x20
  1e:	01d7d913          	srli	s2,a5,0x1d
  22:	05c1                	addi	a1,a1,16
  24:	992e                	add	s2,s2,a1
  // Iterate over each argument and create a directory except "mkdir"
  // If mkdir fails, print an error message and exit
  // calls mkdir function from user.h which makes the system call
  
  for(i = 1; i < argc; i++){
    if(mkdir(argv[i]) < 0){
  26:	6088                	ld	a0,0(s1)
  28:	00000097          	auipc	ra,0x0
  2c:	348080e7          	jalr	840(ra) # 370 <mkdir>
  30:	02054a63          	bltz	a0,64 <main+0x64>
  for(i = 1; i < argc; i++){
  34:	04a1                	addi	s1,s1,8
  36:	ff2498e3          	bne	s1,s2,26 <main+0x26>
      fprintf(2, "mkdir: %s failed to create\n", argv[i]);
      break;
    }
  }
  // Exit with success code
  exit(0);
  3a:	4501                	li	a0,0
  3c:	00000097          	auipc	ra,0x0
  40:	2cc080e7          	jalr	716(ra) # 308 <exit>
  44:	e426                	sd	s1,8(sp)
  46:	e04a                	sd	s2,0(sp)
    fprintf(2, "Usage: mkdir files...\n");
  48:	00000597          	auipc	a1,0x0
  4c:	7f058593          	addi	a1,a1,2032 # 838 <malloc+0xfe>
  50:	4509                	li	a0,2
  52:	00000097          	auipc	ra,0x0
  56:	5fe080e7          	jalr	1534(ra) # 650 <fprintf>
    exit(1);
  5a:	4505                	li	a0,1
  5c:	00000097          	auipc	ra,0x0
  60:	2ac080e7          	jalr	684(ra) # 308 <exit>
      fprintf(2, "mkdir: %s failed to create\n", argv[i]);
  64:	6090                	ld	a2,0(s1)
  66:	00000597          	auipc	a1,0x0
  6a:	7ea58593          	addi	a1,a1,2026 # 850 <malloc+0x116>
  6e:	4509                	li	a0,2
  70:	00000097          	auipc	ra,0x0
  74:	5e0080e7          	jalr	1504(ra) # 650 <fprintf>
      break;
  78:	b7c9                	j	3a <main+0x3a>

000000000000007a <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  7a:	1141                	addi	sp,sp,-16
  7c:	e406                	sd	ra,8(sp)
  7e:	e022                	sd	s0,0(sp)
  80:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  82:	87aa                	mv	a5,a0
  84:	0585                	addi	a1,a1,1
  86:	0785                	addi	a5,a5,1
  88:	fff5c703          	lbu	a4,-1(a1)
  8c:	fee78fa3          	sb	a4,-1(a5)
  90:	fb75                	bnez	a4,84 <strcpy+0xa>
    ;
  return os;
}
  92:	60a2                	ld	ra,8(sp)
  94:	6402                	ld	s0,0(sp)
  96:	0141                	addi	sp,sp,16
  98:	8082                	ret

000000000000009a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  9a:	1141                	addi	sp,sp,-16
  9c:	e406                	sd	ra,8(sp)
  9e:	e022                	sd	s0,0(sp)
  a0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  a2:	00054783          	lbu	a5,0(a0)
  a6:	cb91                	beqz	a5,ba <strcmp+0x20>
  a8:	0005c703          	lbu	a4,0(a1)
  ac:	00f71763          	bne	a4,a5,ba <strcmp+0x20>
    p++, q++;
  b0:	0505                	addi	a0,a0,1
  b2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  b4:	00054783          	lbu	a5,0(a0)
  b8:	fbe5                	bnez	a5,a8 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  ba:	0005c503          	lbu	a0,0(a1)
}
  be:	40a7853b          	subw	a0,a5,a0
  c2:	60a2                	ld	ra,8(sp)
  c4:	6402                	ld	s0,0(sp)
  c6:	0141                	addi	sp,sp,16
  c8:	8082                	ret

00000000000000ca <strlen>:

uint
strlen(const char *s)
{
  ca:	1141                	addi	sp,sp,-16
  cc:	e406                	sd	ra,8(sp)
  ce:	e022                	sd	s0,0(sp)
  d0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  d2:	00054783          	lbu	a5,0(a0)
  d6:	cf91                	beqz	a5,f2 <strlen+0x28>
  d8:	00150793          	addi	a5,a0,1
  dc:	86be                	mv	a3,a5
  de:	0785                	addi	a5,a5,1
  e0:	fff7c703          	lbu	a4,-1(a5)
  e4:	ff65                	bnez	a4,dc <strlen+0x12>
  e6:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  ea:	60a2                	ld	ra,8(sp)
  ec:	6402                	ld	s0,0(sp)
  ee:	0141                	addi	sp,sp,16
  f0:	8082                	ret
  for(n = 0; s[n]; n++)
  f2:	4501                	li	a0,0
  f4:	bfdd                	j	ea <strlen+0x20>

00000000000000f6 <memset>:

void*
memset(void *dst, int c, uint n)
{
  f6:	1141                	addi	sp,sp,-16
  f8:	e406                	sd	ra,8(sp)
  fa:	e022                	sd	s0,0(sp)
  fc:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  fe:	ca19                	beqz	a2,114 <memset+0x1e>
 100:	87aa                	mv	a5,a0
 102:	1602                	slli	a2,a2,0x20
 104:	9201                	srli	a2,a2,0x20
 106:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 10a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 10e:	0785                	addi	a5,a5,1
 110:	fee79de3          	bne	a5,a4,10a <memset+0x14>
  }
  return dst;
}
 114:	60a2                	ld	ra,8(sp)
 116:	6402                	ld	s0,0(sp)
 118:	0141                	addi	sp,sp,16
 11a:	8082                	ret

000000000000011c <strchr>:

char*
strchr(const char *s, char c)
{
 11c:	1141                	addi	sp,sp,-16
 11e:	e406                	sd	ra,8(sp)
 120:	e022                	sd	s0,0(sp)
 122:	0800                	addi	s0,sp,16
  for(; *s; s++)
 124:	00054783          	lbu	a5,0(a0)
 128:	cf81                	beqz	a5,140 <strchr+0x24>
    if(*s == c)
 12a:	00f58763          	beq	a1,a5,138 <strchr+0x1c>
  for(; *s; s++)
 12e:	0505                	addi	a0,a0,1
 130:	00054783          	lbu	a5,0(a0)
 134:	fbfd                	bnez	a5,12a <strchr+0xe>
      return (char*)s;
  return 0;
 136:	4501                	li	a0,0
}
 138:	60a2                	ld	ra,8(sp)
 13a:	6402                	ld	s0,0(sp)
 13c:	0141                	addi	sp,sp,16
 13e:	8082                	ret
  return 0;
 140:	4501                	li	a0,0
 142:	bfdd                	j	138 <strchr+0x1c>

0000000000000144 <gets>:

char*
gets(char *buf, int max)
{
 144:	711d                	addi	sp,sp,-96
 146:	ec86                	sd	ra,88(sp)
 148:	e8a2                	sd	s0,80(sp)
 14a:	e4a6                	sd	s1,72(sp)
 14c:	e0ca                	sd	s2,64(sp)
 14e:	fc4e                	sd	s3,56(sp)
 150:	f852                	sd	s4,48(sp)
 152:	f456                	sd	s5,40(sp)
 154:	f05a                	sd	s6,32(sp)
 156:	ec5e                	sd	s7,24(sp)
 158:	e862                	sd	s8,16(sp)
 15a:	1080                	addi	s0,sp,96
 15c:	8baa                	mv	s7,a0
 15e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 160:	892a                	mv	s2,a0
 162:	4481                	li	s1,0
    cc = read(0, &c, 1);
 164:	faf40b13          	addi	s6,s0,-81
 168:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 16a:	8c26                	mv	s8,s1
 16c:	0014899b          	addiw	s3,s1,1
 170:	84ce                	mv	s1,s3
 172:	0349d663          	bge	s3,s4,19e <gets+0x5a>
    cc = read(0, &c, 1);
 176:	8656                	mv	a2,s5
 178:	85da                	mv	a1,s6
 17a:	4501                	li	a0,0
 17c:	00000097          	auipc	ra,0x0
 180:	1a4080e7          	jalr	420(ra) # 320 <read>
    if(cc < 1)
 184:	00a05d63          	blez	a0,19e <gets+0x5a>
      break;
    buf[i++] = c;
 188:	faf44783          	lbu	a5,-81(s0)
 18c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 190:	0905                	addi	s2,s2,1
 192:	ff678713          	addi	a4,a5,-10
 196:	c319                	beqz	a4,19c <gets+0x58>
 198:	17cd                	addi	a5,a5,-13
 19a:	fbe1                	bnez	a5,16a <gets+0x26>
    buf[i++] = c;
 19c:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 19e:	9c5e                	add	s8,s8,s7
 1a0:	000c0023          	sb	zero,0(s8)
  return buf;
}
 1a4:	855e                	mv	a0,s7
 1a6:	60e6                	ld	ra,88(sp)
 1a8:	6446                	ld	s0,80(sp)
 1aa:	64a6                	ld	s1,72(sp)
 1ac:	6906                	ld	s2,64(sp)
 1ae:	79e2                	ld	s3,56(sp)
 1b0:	7a42                	ld	s4,48(sp)
 1b2:	7aa2                	ld	s5,40(sp)
 1b4:	7b02                	ld	s6,32(sp)
 1b6:	6be2                	ld	s7,24(sp)
 1b8:	6c42                	ld	s8,16(sp)
 1ba:	6125                	addi	sp,sp,96
 1bc:	8082                	ret

00000000000001be <stat>:

int
stat(const char *n, struct stat *st)
{
 1be:	1101                	addi	sp,sp,-32
 1c0:	ec06                	sd	ra,24(sp)
 1c2:	e822                	sd	s0,16(sp)
 1c4:	e04a                	sd	s2,0(sp)
 1c6:	1000                	addi	s0,sp,32
 1c8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ca:	4581                	li	a1,0
 1cc:	00000097          	auipc	ra,0x0
 1d0:	17c080e7          	jalr	380(ra) # 348 <open>
  if(fd < 0)
 1d4:	02054663          	bltz	a0,200 <stat+0x42>
 1d8:	e426                	sd	s1,8(sp)
 1da:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1dc:	85ca                	mv	a1,s2
 1de:	00000097          	auipc	ra,0x0
 1e2:	182080e7          	jalr	386(ra) # 360 <fstat>
 1e6:	892a                	mv	s2,a0
  close(fd);
 1e8:	8526                	mv	a0,s1
 1ea:	00000097          	auipc	ra,0x0
 1ee:	146080e7          	jalr	326(ra) # 330 <close>
  return r;
 1f2:	64a2                	ld	s1,8(sp)
}
 1f4:	854a                	mv	a0,s2
 1f6:	60e2                	ld	ra,24(sp)
 1f8:	6442                	ld	s0,16(sp)
 1fa:	6902                	ld	s2,0(sp)
 1fc:	6105                	addi	sp,sp,32
 1fe:	8082                	ret
    return -1;
 200:	57fd                	li	a5,-1
 202:	893e                	mv	s2,a5
 204:	bfc5                	j	1f4 <stat+0x36>

0000000000000206 <atoi>:

int
atoi(const char *s)
{
 206:	1141                	addi	sp,sp,-16
 208:	e406                	sd	ra,8(sp)
 20a:	e022                	sd	s0,0(sp)
 20c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 20e:	00054683          	lbu	a3,0(a0)
 212:	fd06879b          	addiw	a5,a3,-48
 216:	0ff7f793          	zext.b	a5,a5
 21a:	4625                	li	a2,9
 21c:	02f66963          	bltu	a2,a5,24e <atoi+0x48>
 220:	872a                	mv	a4,a0
  n = 0;
 222:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 224:	0705                	addi	a4,a4,1
 226:	0025179b          	slliw	a5,a0,0x2
 22a:	9fa9                	addw	a5,a5,a0
 22c:	0017979b          	slliw	a5,a5,0x1
 230:	9fb5                	addw	a5,a5,a3
 232:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 236:	00074683          	lbu	a3,0(a4)
 23a:	fd06879b          	addiw	a5,a3,-48
 23e:	0ff7f793          	zext.b	a5,a5
 242:	fef671e3          	bgeu	a2,a5,224 <atoi+0x1e>
  return n;
}
 246:	60a2                	ld	ra,8(sp)
 248:	6402                	ld	s0,0(sp)
 24a:	0141                	addi	sp,sp,16
 24c:	8082                	ret
  n = 0;
 24e:	4501                	li	a0,0
 250:	bfdd                	j	246 <atoi+0x40>

0000000000000252 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 252:	1141                	addi	sp,sp,-16
 254:	e406                	sd	ra,8(sp)
 256:	e022                	sd	s0,0(sp)
 258:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 25a:	02b57563          	bgeu	a0,a1,284 <memmove+0x32>
    while(n-- > 0)
 25e:	00c05f63          	blez	a2,27c <memmove+0x2a>
 262:	1602                	slli	a2,a2,0x20
 264:	9201                	srli	a2,a2,0x20
 266:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 26a:	872a                	mv	a4,a0
      *dst++ = *src++;
 26c:	0585                	addi	a1,a1,1
 26e:	0705                	addi	a4,a4,1
 270:	fff5c683          	lbu	a3,-1(a1)
 274:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 278:	fee79ae3          	bne	a5,a4,26c <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 27c:	60a2                	ld	ra,8(sp)
 27e:	6402                	ld	s0,0(sp)
 280:	0141                	addi	sp,sp,16
 282:	8082                	ret
    while(n-- > 0)
 284:	fec05ce3          	blez	a2,27c <memmove+0x2a>
    dst += n;
 288:	00c50733          	add	a4,a0,a2
    src += n;
 28c:	95b2                	add	a1,a1,a2
 28e:	fff6079b          	addiw	a5,a2,-1
 292:	1782                	slli	a5,a5,0x20
 294:	9381                	srli	a5,a5,0x20
 296:	fff7c793          	not	a5,a5
 29a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 29c:	15fd                	addi	a1,a1,-1
 29e:	177d                	addi	a4,a4,-1
 2a0:	0005c683          	lbu	a3,0(a1)
 2a4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2a8:	fef71ae3          	bne	a4,a5,29c <memmove+0x4a>
 2ac:	bfc1                	j	27c <memmove+0x2a>

00000000000002ae <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2ae:	1141                	addi	sp,sp,-16
 2b0:	e406                	sd	ra,8(sp)
 2b2:	e022                	sd	s0,0(sp)
 2b4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2b6:	c61d                	beqz	a2,2e4 <memcmp+0x36>
 2b8:	1602                	slli	a2,a2,0x20
 2ba:	9201                	srli	a2,a2,0x20
 2bc:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 2c0:	00054783          	lbu	a5,0(a0)
 2c4:	0005c703          	lbu	a4,0(a1)
 2c8:	00e79863          	bne	a5,a4,2d8 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 2cc:	0505                	addi	a0,a0,1
    p2++;
 2ce:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2d0:	fed518e3          	bne	a0,a3,2c0 <memcmp+0x12>
  }
  return 0;
 2d4:	4501                	li	a0,0
 2d6:	a019                	j	2dc <memcmp+0x2e>
      return *p1 - *p2;
 2d8:	40e7853b          	subw	a0,a5,a4
}
 2dc:	60a2                	ld	ra,8(sp)
 2de:	6402                	ld	s0,0(sp)
 2e0:	0141                	addi	sp,sp,16
 2e2:	8082                	ret
  return 0;
 2e4:	4501                	li	a0,0
 2e6:	bfdd                	j	2dc <memcmp+0x2e>

00000000000002e8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2e8:	1141                	addi	sp,sp,-16
 2ea:	e406                	sd	ra,8(sp)
 2ec:	e022                	sd	s0,0(sp)
 2ee:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2f0:	00000097          	auipc	ra,0x0
 2f4:	f62080e7          	jalr	-158(ra) # 252 <memmove>
}
 2f8:	60a2                	ld	ra,8(sp)
 2fa:	6402                	ld	s0,0(sp)
 2fc:	0141                	addi	sp,sp,16
 2fe:	8082                	ret

0000000000000300 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 300:	4885                	li	a7,1
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <exit>:
.global exit
exit:
 li a7, SYS_exit
 308:	4889                	li	a7,2
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <wait>:
.global wait
wait:
 li a7, SYS_wait
 310:	488d                	li	a7,3
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 318:	4891                	li	a7,4
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <read>:
.global read
read:
 li a7, SYS_read
 320:	4895                	li	a7,5
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <write>:
.global write
write:
 li a7, SYS_write
 328:	48c1                	li	a7,16
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <close>:
.global close
close:
 li a7, SYS_close
 330:	48d5                	li	a7,21
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <kill>:
.global kill
kill:
 li a7, SYS_kill
 338:	4899                	li	a7,6
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <exec>:
.global exec
exec:
 li a7, SYS_exec
 340:	489d                	li	a7,7
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <open>:
.global open
open:
 li a7, SYS_open
 348:	48bd                	li	a7,15
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 350:	48c5                	li	a7,17
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 358:	48c9                	li	a7,18
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 360:	48a1                	li	a7,8
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <link>:
.global link
link:
 li a7, SYS_link
 368:	48cd                	li	a7,19
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 370:	48d1                	li	a7,20
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 378:	48a5                	li	a7,9
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <dup>:
.global dup
dup:
 li a7, SYS_dup
 380:	48a9                	li	a7,10
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 388:	48ad                	li	a7,11
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 390:	48b1                	li	a7,12
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 398:	48b5                	li	a7,13
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3a0:	48b9                	li	a7,14
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <cputime>:
.global cputime
cputime:
 li a7, SYS_cputime
 3a8:	48d9                	li	a7,22
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <wait2>:
.global wait2
wait2:
 li a7, SYS_wait2
 3b0:	48dd                	li	a7,23
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3b8:	1101                	addi	sp,sp,-32
 3ba:	ec06                	sd	ra,24(sp)
 3bc:	e822                	sd	s0,16(sp)
 3be:	1000                	addi	s0,sp,32
 3c0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3c4:	4605                	li	a2,1
 3c6:	fef40593          	addi	a1,s0,-17
 3ca:	00000097          	auipc	ra,0x0
 3ce:	f5e080e7          	jalr	-162(ra) # 328 <write>
}
 3d2:	60e2                	ld	ra,24(sp)
 3d4:	6442                	ld	s0,16(sp)
 3d6:	6105                	addi	sp,sp,32
 3d8:	8082                	ret

00000000000003da <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3da:	7139                	addi	sp,sp,-64
 3dc:	fc06                	sd	ra,56(sp)
 3de:	f822                	sd	s0,48(sp)
 3e0:	f04a                	sd	s2,32(sp)
 3e2:	ec4e                	sd	s3,24(sp)
 3e4:	0080                	addi	s0,sp,64
 3e6:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3e8:	cad9                	beqz	a3,47e <printint+0xa4>
 3ea:	01f5d79b          	srliw	a5,a1,0x1f
 3ee:	cbc1                	beqz	a5,47e <printint+0xa4>
    neg = 1;
    x = -xx;
 3f0:	40b005bb          	negw	a1,a1
    neg = 1;
 3f4:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 3f6:	fc040993          	addi	s3,s0,-64
  neg = 0;
 3fa:	86ce                	mv	a3,s3
  i = 0;
 3fc:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3fe:	00000817          	auipc	a6,0x0
 402:	4d280813          	addi	a6,a6,1234 # 8d0 <digits>
 406:	88ba                	mv	a7,a4
 408:	0017051b          	addiw	a0,a4,1
 40c:	872a                	mv	a4,a0
 40e:	02c5f7bb          	remuw	a5,a1,a2
 412:	1782                	slli	a5,a5,0x20
 414:	9381                	srli	a5,a5,0x20
 416:	97c2                	add	a5,a5,a6
 418:	0007c783          	lbu	a5,0(a5)
 41c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 420:	87ae                	mv	a5,a1
 422:	02c5d5bb          	divuw	a1,a1,a2
 426:	0685                	addi	a3,a3,1
 428:	fcc7ffe3          	bgeu	a5,a2,406 <printint+0x2c>
  if(neg)
 42c:	00030c63          	beqz	t1,444 <printint+0x6a>
    buf[i++] = '-';
 430:	fd050793          	addi	a5,a0,-48
 434:	00878533          	add	a0,a5,s0
 438:	02d00793          	li	a5,45
 43c:	fef50823          	sb	a5,-16(a0)
 440:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 444:	02e05763          	blez	a4,472 <printint+0x98>
 448:	f426                	sd	s1,40(sp)
 44a:	377d                	addiw	a4,a4,-1
 44c:	00e984b3          	add	s1,s3,a4
 450:	19fd                	addi	s3,s3,-1
 452:	99ba                	add	s3,s3,a4
 454:	1702                	slli	a4,a4,0x20
 456:	9301                	srli	a4,a4,0x20
 458:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 45c:	0004c583          	lbu	a1,0(s1)
 460:	854a                	mv	a0,s2
 462:	00000097          	auipc	ra,0x0
 466:	f56080e7          	jalr	-170(ra) # 3b8 <putc>
  while(--i >= 0)
 46a:	14fd                	addi	s1,s1,-1
 46c:	ff3498e3          	bne	s1,s3,45c <printint+0x82>
 470:	74a2                	ld	s1,40(sp)
}
 472:	70e2                	ld	ra,56(sp)
 474:	7442                	ld	s0,48(sp)
 476:	7902                	ld	s2,32(sp)
 478:	69e2                	ld	s3,24(sp)
 47a:	6121                	addi	sp,sp,64
 47c:	8082                	ret
  neg = 0;
 47e:	4301                	li	t1,0
 480:	bf9d                	j	3f6 <printint+0x1c>

0000000000000482 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 482:	715d                	addi	sp,sp,-80
 484:	e486                	sd	ra,72(sp)
 486:	e0a2                	sd	s0,64(sp)
 488:	f84a                	sd	s2,48(sp)
 48a:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 48c:	0005c903          	lbu	s2,0(a1)
 490:	1a090b63          	beqz	s2,646 <vprintf+0x1c4>
 494:	fc26                	sd	s1,56(sp)
 496:	f44e                	sd	s3,40(sp)
 498:	f052                	sd	s4,32(sp)
 49a:	ec56                	sd	s5,24(sp)
 49c:	e85a                	sd	s6,16(sp)
 49e:	e45e                	sd	s7,8(sp)
 4a0:	8aaa                	mv	s5,a0
 4a2:	8bb2                	mv	s7,a2
 4a4:	00158493          	addi	s1,a1,1
  state = 0;
 4a8:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4aa:	02500a13          	li	s4,37
 4ae:	4b55                	li	s6,21
 4b0:	a839                	j	4ce <vprintf+0x4c>
        putc(fd, c);
 4b2:	85ca                	mv	a1,s2
 4b4:	8556                	mv	a0,s5
 4b6:	00000097          	auipc	ra,0x0
 4ba:	f02080e7          	jalr	-254(ra) # 3b8 <putc>
 4be:	a019                	j	4c4 <vprintf+0x42>
    } else if(state == '%'){
 4c0:	01498d63          	beq	s3,s4,4da <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 4c4:	0485                	addi	s1,s1,1
 4c6:	fff4c903          	lbu	s2,-1(s1)
 4ca:	16090863          	beqz	s2,63a <vprintf+0x1b8>
    if(state == 0){
 4ce:	fe0999e3          	bnez	s3,4c0 <vprintf+0x3e>
      if(c == '%'){
 4d2:	ff4910e3          	bne	s2,s4,4b2 <vprintf+0x30>
        state = '%';
 4d6:	89d2                	mv	s3,s4
 4d8:	b7f5                	j	4c4 <vprintf+0x42>
      if(c == 'd'){
 4da:	13490563          	beq	s2,s4,604 <vprintf+0x182>
 4de:	f9d9079b          	addiw	a5,s2,-99
 4e2:	0ff7f793          	zext.b	a5,a5
 4e6:	12fb6863          	bltu	s6,a5,616 <vprintf+0x194>
 4ea:	f9d9079b          	addiw	a5,s2,-99
 4ee:	0ff7f713          	zext.b	a4,a5
 4f2:	12eb6263          	bltu	s6,a4,616 <vprintf+0x194>
 4f6:	00271793          	slli	a5,a4,0x2
 4fa:	00000717          	auipc	a4,0x0
 4fe:	37e70713          	addi	a4,a4,894 # 878 <malloc+0x13e>
 502:	97ba                	add	a5,a5,a4
 504:	439c                	lw	a5,0(a5)
 506:	97ba                	add	a5,a5,a4
 508:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 50a:	008b8913          	addi	s2,s7,8
 50e:	4685                	li	a3,1
 510:	4629                	li	a2,10
 512:	000ba583          	lw	a1,0(s7)
 516:	8556                	mv	a0,s5
 518:	00000097          	auipc	ra,0x0
 51c:	ec2080e7          	jalr	-318(ra) # 3da <printint>
 520:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 522:	4981                	li	s3,0
 524:	b745                	j	4c4 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 526:	008b8913          	addi	s2,s7,8
 52a:	4681                	li	a3,0
 52c:	4629                	li	a2,10
 52e:	000ba583          	lw	a1,0(s7)
 532:	8556                	mv	a0,s5
 534:	00000097          	auipc	ra,0x0
 538:	ea6080e7          	jalr	-346(ra) # 3da <printint>
 53c:	8bca                	mv	s7,s2
      state = 0;
 53e:	4981                	li	s3,0
 540:	b751                	j	4c4 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 542:	008b8913          	addi	s2,s7,8
 546:	4681                	li	a3,0
 548:	4641                	li	a2,16
 54a:	000ba583          	lw	a1,0(s7)
 54e:	8556                	mv	a0,s5
 550:	00000097          	auipc	ra,0x0
 554:	e8a080e7          	jalr	-374(ra) # 3da <printint>
 558:	8bca                	mv	s7,s2
      state = 0;
 55a:	4981                	li	s3,0
 55c:	b7a5                	j	4c4 <vprintf+0x42>
 55e:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 560:	008b8793          	addi	a5,s7,8
 564:	8c3e                	mv	s8,a5
 566:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 56a:	03000593          	li	a1,48
 56e:	8556                	mv	a0,s5
 570:	00000097          	auipc	ra,0x0
 574:	e48080e7          	jalr	-440(ra) # 3b8 <putc>
  putc(fd, 'x');
 578:	07800593          	li	a1,120
 57c:	8556                	mv	a0,s5
 57e:	00000097          	auipc	ra,0x0
 582:	e3a080e7          	jalr	-454(ra) # 3b8 <putc>
 586:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 588:	00000b97          	auipc	s7,0x0
 58c:	348b8b93          	addi	s7,s7,840 # 8d0 <digits>
 590:	03c9d793          	srli	a5,s3,0x3c
 594:	97de                	add	a5,a5,s7
 596:	0007c583          	lbu	a1,0(a5)
 59a:	8556                	mv	a0,s5
 59c:	00000097          	auipc	ra,0x0
 5a0:	e1c080e7          	jalr	-484(ra) # 3b8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5a4:	0992                	slli	s3,s3,0x4
 5a6:	397d                	addiw	s2,s2,-1
 5a8:	fe0914e3          	bnez	s2,590 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 5ac:	8be2                	mv	s7,s8
      state = 0;
 5ae:	4981                	li	s3,0
 5b0:	6c02                	ld	s8,0(sp)
 5b2:	bf09                	j	4c4 <vprintf+0x42>
        s = va_arg(ap, char*);
 5b4:	008b8993          	addi	s3,s7,8
 5b8:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 5bc:	02090163          	beqz	s2,5de <vprintf+0x15c>
        while(*s != 0){
 5c0:	00094583          	lbu	a1,0(s2)
 5c4:	c9a5                	beqz	a1,634 <vprintf+0x1b2>
          putc(fd, *s);
 5c6:	8556                	mv	a0,s5
 5c8:	00000097          	auipc	ra,0x0
 5cc:	df0080e7          	jalr	-528(ra) # 3b8 <putc>
          s++;
 5d0:	0905                	addi	s2,s2,1
        while(*s != 0){
 5d2:	00094583          	lbu	a1,0(s2)
 5d6:	f9e5                	bnez	a1,5c6 <vprintf+0x144>
        s = va_arg(ap, char*);
 5d8:	8bce                	mv	s7,s3
      state = 0;
 5da:	4981                	li	s3,0
 5dc:	b5e5                	j	4c4 <vprintf+0x42>
          s = "(null)";
 5de:	00000917          	auipc	s2,0x0
 5e2:	29290913          	addi	s2,s2,658 # 870 <malloc+0x136>
        while(*s != 0){
 5e6:	02800593          	li	a1,40
 5ea:	bff1                	j	5c6 <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 5ec:	008b8913          	addi	s2,s7,8
 5f0:	000bc583          	lbu	a1,0(s7)
 5f4:	8556                	mv	a0,s5
 5f6:	00000097          	auipc	ra,0x0
 5fa:	dc2080e7          	jalr	-574(ra) # 3b8 <putc>
 5fe:	8bca                	mv	s7,s2
      state = 0;
 600:	4981                	li	s3,0
 602:	b5c9                	j	4c4 <vprintf+0x42>
        putc(fd, c);
 604:	02500593          	li	a1,37
 608:	8556                	mv	a0,s5
 60a:	00000097          	auipc	ra,0x0
 60e:	dae080e7          	jalr	-594(ra) # 3b8 <putc>
      state = 0;
 612:	4981                	li	s3,0
 614:	bd45                	j	4c4 <vprintf+0x42>
        putc(fd, '%');
 616:	02500593          	li	a1,37
 61a:	8556                	mv	a0,s5
 61c:	00000097          	auipc	ra,0x0
 620:	d9c080e7          	jalr	-612(ra) # 3b8 <putc>
        putc(fd, c);
 624:	85ca                	mv	a1,s2
 626:	8556                	mv	a0,s5
 628:	00000097          	auipc	ra,0x0
 62c:	d90080e7          	jalr	-624(ra) # 3b8 <putc>
      state = 0;
 630:	4981                	li	s3,0
 632:	bd49                	j	4c4 <vprintf+0x42>
        s = va_arg(ap, char*);
 634:	8bce                	mv	s7,s3
      state = 0;
 636:	4981                	li	s3,0
 638:	b571                	j	4c4 <vprintf+0x42>
 63a:	74e2                	ld	s1,56(sp)
 63c:	79a2                	ld	s3,40(sp)
 63e:	7a02                	ld	s4,32(sp)
 640:	6ae2                	ld	s5,24(sp)
 642:	6b42                	ld	s6,16(sp)
 644:	6ba2                	ld	s7,8(sp)
    }
  }
}
 646:	60a6                	ld	ra,72(sp)
 648:	6406                	ld	s0,64(sp)
 64a:	7942                	ld	s2,48(sp)
 64c:	6161                	addi	sp,sp,80
 64e:	8082                	ret

0000000000000650 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 650:	715d                	addi	sp,sp,-80
 652:	ec06                	sd	ra,24(sp)
 654:	e822                	sd	s0,16(sp)
 656:	1000                	addi	s0,sp,32
 658:	e010                	sd	a2,0(s0)
 65a:	e414                	sd	a3,8(s0)
 65c:	e818                	sd	a4,16(s0)
 65e:	ec1c                	sd	a5,24(s0)
 660:	03043023          	sd	a6,32(s0)
 664:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 668:	8622                	mv	a2,s0
 66a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 66e:	00000097          	auipc	ra,0x0
 672:	e14080e7          	jalr	-492(ra) # 482 <vprintf>
}
 676:	60e2                	ld	ra,24(sp)
 678:	6442                	ld	s0,16(sp)
 67a:	6161                	addi	sp,sp,80
 67c:	8082                	ret

000000000000067e <printf>:

void
printf(const char *fmt, ...)
{
 67e:	711d                	addi	sp,sp,-96
 680:	ec06                	sd	ra,24(sp)
 682:	e822                	sd	s0,16(sp)
 684:	1000                	addi	s0,sp,32
 686:	e40c                	sd	a1,8(s0)
 688:	e810                	sd	a2,16(s0)
 68a:	ec14                	sd	a3,24(s0)
 68c:	f018                	sd	a4,32(s0)
 68e:	f41c                	sd	a5,40(s0)
 690:	03043823          	sd	a6,48(s0)
 694:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 698:	00840613          	addi	a2,s0,8
 69c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6a0:	85aa                	mv	a1,a0
 6a2:	4505                	li	a0,1
 6a4:	00000097          	auipc	ra,0x0
 6a8:	dde080e7          	jalr	-546(ra) # 482 <vprintf>
}
 6ac:	60e2                	ld	ra,24(sp)
 6ae:	6442                	ld	s0,16(sp)
 6b0:	6125                	addi	sp,sp,96
 6b2:	8082                	ret

00000000000006b4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6b4:	1141                	addi	sp,sp,-16
 6b6:	e406                	sd	ra,8(sp)
 6b8:	e022                	sd	s0,0(sp)
 6ba:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6bc:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c0:	00000797          	auipc	a5,0x0
 6c4:	2287b783          	ld	a5,552(a5) # 8e8 <freep>
 6c8:	a039                	j	6d6 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6ca:	6398                	ld	a4,0(a5)
 6cc:	00e7e463          	bltu	a5,a4,6d4 <free+0x20>
 6d0:	00e6ea63          	bltu	a3,a4,6e4 <free+0x30>
{
 6d4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d6:	fed7fae3          	bgeu	a5,a3,6ca <free+0x16>
 6da:	6398                	ld	a4,0(a5)
 6dc:	00e6e463          	bltu	a3,a4,6e4 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6e0:	fee7eae3          	bltu	a5,a4,6d4 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6e4:	ff852583          	lw	a1,-8(a0)
 6e8:	6390                	ld	a2,0(a5)
 6ea:	02059813          	slli	a6,a1,0x20
 6ee:	01c85713          	srli	a4,a6,0x1c
 6f2:	9736                	add	a4,a4,a3
 6f4:	02e60563          	beq	a2,a4,71e <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 6f8:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 6fc:	4790                	lw	a2,8(a5)
 6fe:	02061593          	slli	a1,a2,0x20
 702:	01c5d713          	srli	a4,a1,0x1c
 706:	973e                	add	a4,a4,a5
 708:	02e68263          	beq	a3,a4,72c <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 70c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 70e:	00000717          	auipc	a4,0x0
 712:	1cf73d23          	sd	a5,474(a4) # 8e8 <freep>
}
 716:	60a2                	ld	ra,8(sp)
 718:	6402                	ld	s0,0(sp)
 71a:	0141                	addi	sp,sp,16
 71c:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 71e:	4618                	lw	a4,8(a2)
 720:	9f2d                	addw	a4,a4,a1
 722:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 726:	6398                	ld	a4,0(a5)
 728:	6310                	ld	a2,0(a4)
 72a:	b7f9                	j	6f8 <free+0x44>
    p->s.size += bp->s.size;
 72c:	ff852703          	lw	a4,-8(a0)
 730:	9f31                	addw	a4,a4,a2
 732:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 734:	ff053683          	ld	a3,-16(a0)
 738:	bfd1                	j	70c <free+0x58>

000000000000073a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 73a:	7139                	addi	sp,sp,-64
 73c:	fc06                	sd	ra,56(sp)
 73e:	f822                	sd	s0,48(sp)
 740:	f04a                	sd	s2,32(sp)
 742:	ec4e                	sd	s3,24(sp)
 744:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 746:	02051993          	slli	s3,a0,0x20
 74a:	0209d993          	srli	s3,s3,0x20
 74e:	09bd                	addi	s3,s3,15
 750:	0049d993          	srli	s3,s3,0x4
 754:	2985                	addiw	s3,s3,1
 756:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 758:	00000517          	auipc	a0,0x0
 75c:	19053503          	ld	a0,400(a0) # 8e8 <freep>
 760:	c905                	beqz	a0,790 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 762:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 764:	4798                	lw	a4,8(a5)
 766:	09377a63          	bgeu	a4,s3,7fa <malloc+0xc0>
 76a:	f426                	sd	s1,40(sp)
 76c:	e852                	sd	s4,16(sp)
 76e:	e456                	sd	s5,8(sp)
 770:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 772:	8a4e                	mv	s4,s3
 774:	6705                	lui	a4,0x1
 776:	00e9f363          	bgeu	s3,a4,77c <malloc+0x42>
 77a:	6a05                	lui	s4,0x1
 77c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 780:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 784:	00000497          	auipc	s1,0x0
 788:	16448493          	addi	s1,s1,356 # 8e8 <freep>
  if(p == (char*)-1)
 78c:	5afd                	li	s5,-1
 78e:	a089                	j	7d0 <malloc+0x96>
 790:	f426                	sd	s1,40(sp)
 792:	e852                	sd	s4,16(sp)
 794:	e456                	sd	s5,8(sp)
 796:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 798:	00000797          	auipc	a5,0x0
 79c:	15878793          	addi	a5,a5,344 # 8f0 <base>
 7a0:	00000717          	auipc	a4,0x0
 7a4:	14f73423          	sd	a5,328(a4) # 8e8 <freep>
 7a8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7aa:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7ae:	b7d1                	j	772 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 7b0:	6398                	ld	a4,0(a5)
 7b2:	e118                	sd	a4,0(a0)
 7b4:	a8b9                	j	812 <malloc+0xd8>
  hp->s.size = nu;
 7b6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7ba:	0541                	addi	a0,a0,16
 7bc:	00000097          	auipc	ra,0x0
 7c0:	ef8080e7          	jalr	-264(ra) # 6b4 <free>
  return freep;
 7c4:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 7c6:	c135                	beqz	a0,82a <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7c8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7ca:	4798                	lw	a4,8(a5)
 7cc:	03277363          	bgeu	a4,s2,7f2 <malloc+0xb8>
    if(p == freep)
 7d0:	6098                	ld	a4,0(s1)
 7d2:	853e                	mv	a0,a5
 7d4:	fef71ae3          	bne	a4,a5,7c8 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 7d8:	8552                	mv	a0,s4
 7da:	00000097          	auipc	ra,0x0
 7de:	bb6080e7          	jalr	-1098(ra) # 390 <sbrk>
  if(p == (char*)-1)
 7e2:	fd551ae3          	bne	a0,s5,7b6 <malloc+0x7c>
        return 0;
 7e6:	4501                	li	a0,0
 7e8:	74a2                	ld	s1,40(sp)
 7ea:	6a42                	ld	s4,16(sp)
 7ec:	6aa2                	ld	s5,8(sp)
 7ee:	6b02                	ld	s6,0(sp)
 7f0:	a03d                	j	81e <malloc+0xe4>
 7f2:	74a2                	ld	s1,40(sp)
 7f4:	6a42                	ld	s4,16(sp)
 7f6:	6aa2                	ld	s5,8(sp)
 7f8:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 7fa:	fae90be3          	beq	s2,a4,7b0 <malloc+0x76>
        p->s.size -= nunits;
 7fe:	4137073b          	subw	a4,a4,s3
 802:	c798                	sw	a4,8(a5)
        p += p->s.size;
 804:	02071693          	slli	a3,a4,0x20
 808:	01c6d713          	srli	a4,a3,0x1c
 80c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 80e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 812:	00000717          	auipc	a4,0x0
 816:	0ca73b23          	sd	a0,214(a4) # 8e8 <freep>
      return (void*)(p + 1);
 81a:	01078513          	addi	a0,a5,16
  }
}
 81e:	70e2                	ld	ra,56(sp)
 820:	7442                	ld	s0,48(sp)
 822:	7902                	ld	s2,32(sp)
 824:	69e2                	ld	s3,24(sp)
 826:	6121                	addi	sp,sp,64
 828:	8082                	ret
 82a:	74a2                	ld	s1,40(sp)
 82c:	6a42                	ld	s4,16(sp)
 82e:	6aa2                	ld	s5,8(sp)
 830:	6b02                	ld	s6,0(sp)
 832:	b7f5                	j	81e <malloc+0xe4>
