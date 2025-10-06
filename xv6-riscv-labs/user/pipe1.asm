
user/_pipe1:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[])
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	1800                	addi	s0,sp,48
    int p[2]; // p[0] is read end, p[1] is write end
    char *childargV[2];
    childargV[0] = "wc";
   8:	00001797          	auipc	a5,0x1
   c:	8d078793          	addi	a5,a5,-1840 # 8d8 <malloc+0xfc>
  10:	fcf43c23          	sd	a5,-40(s0)
    childargV[1] = 0;
  14:	fe043023          	sd	zero,-32(s0)
    pipe(p);
  18:	fe840513          	addi	a0,s0,-24
  1c:	00000097          	auipc	ra,0x0
  20:	3a6080e7          	jalr	934(ra) # 3c2 <pipe>

    if (fork() == 0)
  24:	00000097          	auipc	ra,0x0
  28:	386080e7          	jalr	902(ra) # 3aa <fork>
  2c:	ed39                	bnez	a0,8a <main+0x8a>
    {
        close(0); // close stdin
  2e:	00000097          	auipc	ra,0x0
  32:	3ac080e7          	jalr	940(ra) # 3da <close>
        dup(p[0]); // duplicate read end to stdin
  36:	fe842503          	lw	a0,-24(s0)
  3a:	00000097          	auipc	ra,0x0
  3e:	3f0080e7          	jalr	1008(ra) # 42a <dup>
        close(p[0]); // close original read end
  42:	fe842503          	lw	a0,-24(s0)
  46:	00000097          	auipc	ra,0x0
  4a:	394080e7          	jalr	916(ra) # 3da <close>
        close(p[1]); // close write end in child
  4e:	fec42503          	lw	a0,-20(s0)
  52:	00000097          	auipc	ra,0x0
  56:	388080e7          	jalr	904(ra) # 3da <close>
        exec("wc", childargV);  // execute wc
  5a:	fd840593          	addi	a1,s0,-40
  5e:	00001517          	auipc	a0,0x1
  62:	87a50513          	addi	a0,a0,-1926 # 8d8 <malloc+0xfc>
  66:	00000097          	auipc	ra,0x0
  6a:	384080e7          	jalr	900(ra) # 3ea <exec>
        fprintf(2, "exec wc failed\n"); // if exec fails
  6e:	00001597          	auipc	a1,0x1
  72:	87258593          	addi	a1,a1,-1934 # 8e0 <malloc+0x104>
  76:	4509                	li	a0,2
  78:	00000097          	auipc	ra,0x0
  7c:	67a080e7          	jalr	1658(ra) # 6f2 <fprintf>
        write(p[1], "hello PIPE\n", 11);
        close(p[1]); // close write end to send EOF to wc
        wait(0); // wait for child to finish
        exit(0);
    }
  80:	4501                	li	a0,0
  82:	70a2                	ld	ra,40(sp)
  84:	7402                	ld	s0,32(sp)
  86:	6145                	addi	sp,sp,48
  88:	8082                	ret
        close(p[0]); // close read end in parent
  8a:	fe842503          	lw	a0,-24(s0)
  8e:	00000097          	auipc	ra,0x0
  92:	34c080e7          	jalr	844(ra) # 3da <close>
        write(p[1], "hello world\n", 12); // write to pipe
  96:	4631                	li	a2,12
  98:	00001597          	auipc	a1,0x1
  9c:	85858593          	addi	a1,a1,-1960 # 8f0 <malloc+0x114>
  a0:	fec42503          	lw	a0,-20(s0)
  a4:	00000097          	auipc	ra,0x0
  a8:	32e080e7          	jalr	814(ra) # 3d2 <write>
        write(p[1], "hello UTEP\n", 11);
  ac:	462d                	li	a2,11
  ae:	00001597          	auipc	a1,0x1
  b2:	85258593          	addi	a1,a1,-1966 # 900 <malloc+0x124>
  b6:	fec42503          	lw	a0,-20(s0)
  ba:	00000097          	auipc	ra,0x0
  be:	318080e7          	jalr	792(ra) # 3d2 <write>
        write(p[1], "hello CS4375\n", 13);
  c2:	4635                	li	a2,13
  c4:	00001597          	auipc	a1,0x1
  c8:	84c58593          	addi	a1,a1,-1972 # 910 <malloc+0x134>
  cc:	fec42503          	lw	a0,-20(s0)
  d0:	00000097          	auipc	ra,0x0
  d4:	302080e7          	jalr	770(ra) # 3d2 <write>
        write(p[1], "hello OS\n", 9);
  d8:	4625                	li	a2,9
  da:	00001597          	auipc	a1,0x1
  de:	84658593          	addi	a1,a1,-1978 # 920 <malloc+0x144>
  e2:	fec42503          	lw	a0,-20(s0)
  e6:	00000097          	auipc	ra,0x0
  ea:	2ec080e7          	jalr	748(ra) # 3d2 <write>
        write(p[1], "hello PIPE\n", 11);
  ee:	462d                	li	a2,11
  f0:	00001597          	auipc	a1,0x1
  f4:	84058593          	addi	a1,a1,-1984 # 930 <malloc+0x154>
  f8:	fec42503          	lw	a0,-20(s0)
  fc:	00000097          	auipc	ra,0x0
 100:	2d6080e7          	jalr	726(ra) # 3d2 <write>
        close(p[1]); // close write end to send EOF to wc
 104:	fec42503          	lw	a0,-20(s0)
 108:	00000097          	auipc	ra,0x0
 10c:	2d2080e7          	jalr	722(ra) # 3da <close>
        wait(0); // wait for child to finish
 110:	4501                	li	a0,0
 112:	00000097          	auipc	ra,0x0
 116:	2a8080e7          	jalr	680(ra) # 3ba <wait>
        exit(0);
 11a:	4501                	li	a0,0
 11c:	00000097          	auipc	ra,0x0
 120:	296080e7          	jalr	662(ra) # 3b2 <exit>

0000000000000124 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 124:	1141                	addi	sp,sp,-16
 126:	e406                	sd	ra,8(sp)
 128:	e022                	sd	s0,0(sp)
 12a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 12c:	87aa                	mv	a5,a0
 12e:	0585                	addi	a1,a1,1
 130:	0785                	addi	a5,a5,1
 132:	fff5c703          	lbu	a4,-1(a1)
 136:	fee78fa3          	sb	a4,-1(a5)
 13a:	fb75                	bnez	a4,12e <strcpy+0xa>
    ;
  return os;
}
 13c:	60a2                	ld	ra,8(sp)
 13e:	6402                	ld	s0,0(sp)
 140:	0141                	addi	sp,sp,16
 142:	8082                	ret

0000000000000144 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 144:	1141                	addi	sp,sp,-16
 146:	e406                	sd	ra,8(sp)
 148:	e022                	sd	s0,0(sp)
 14a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 14c:	00054783          	lbu	a5,0(a0)
 150:	cb91                	beqz	a5,164 <strcmp+0x20>
 152:	0005c703          	lbu	a4,0(a1)
 156:	00f71763          	bne	a4,a5,164 <strcmp+0x20>
    p++, q++;
 15a:	0505                	addi	a0,a0,1
 15c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 15e:	00054783          	lbu	a5,0(a0)
 162:	fbe5                	bnez	a5,152 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 164:	0005c503          	lbu	a0,0(a1)
}
 168:	40a7853b          	subw	a0,a5,a0
 16c:	60a2                	ld	ra,8(sp)
 16e:	6402                	ld	s0,0(sp)
 170:	0141                	addi	sp,sp,16
 172:	8082                	ret

0000000000000174 <strlen>:

uint
strlen(const char *s)
{
 174:	1141                	addi	sp,sp,-16
 176:	e406                	sd	ra,8(sp)
 178:	e022                	sd	s0,0(sp)
 17a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 17c:	00054783          	lbu	a5,0(a0)
 180:	cf91                	beqz	a5,19c <strlen+0x28>
 182:	00150793          	addi	a5,a0,1
 186:	86be                	mv	a3,a5
 188:	0785                	addi	a5,a5,1
 18a:	fff7c703          	lbu	a4,-1(a5)
 18e:	ff65                	bnez	a4,186 <strlen+0x12>
 190:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 194:	60a2                	ld	ra,8(sp)
 196:	6402                	ld	s0,0(sp)
 198:	0141                	addi	sp,sp,16
 19a:	8082                	ret
  for(n = 0; s[n]; n++)
 19c:	4501                	li	a0,0
 19e:	bfdd                	j	194 <strlen+0x20>

00000000000001a0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1a0:	1141                	addi	sp,sp,-16
 1a2:	e406                	sd	ra,8(sp)
 1a4:	e022                	sd	s0,0(sp)
 1a6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1a8:	ca19                	beqz	a2,1be <memset+0x1e>
 1aa:	87aa                	mv	a5,a0
 1ac:	1602                	slli	a2,a2,0x20
 1ae:	9201                	srli	a2,a2,0x20
 1b0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1b4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1b8:	0785                	addi	a5,a5,1
 1ba:	fee79de3          	bne	a5,a4,1b4 <memset+0x14>
  }
  return dst;
}
 1be:	60a2                	ld	ra,8(sp)
 1c0:	6402                	ld	s0,0(sp)
 1c2:	0141                	addi	sp,sp,16
 1c4:	8082                	ret

00000000000001c6 <strchr>:

char*
strchr(const char *s, char c)
{
 1c6:	1141                	addi	sp,sp,-16
 1c8:	e406                	sd	ra,8(sp)
 1ca:	e022                	sd	s0,0(sp)
 1cc:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1ce:	00054783          	lbu	a5,0(a0)
 1d2:	cf81                	beqz	a5,1ea <strchr+0x24>
    if(*s == c)
 1d4:	00f58763          	beq	a1,a5,1e2 <strchr+0x1c>
  for(; *s; s++)
 1d8:	0505                	addi	a0,a0,1
 1da:	00054783          	lbu	a5,0(a0)
 1de:	fbfd                	bnez	a5,1d4 <strchr+0xe>
      return (char*)s;
  return 0;
 1e0:	4501                	li	a0,0
}
 1e2:	60a2                	ld	ra,8(sp)
 1e4:	6402                	ld	s0,0(sp)
 1e6:	0141                	addi	sp,sp,16
 1e8:	8082                	ret
  return 0;
 1ea:	4501                	li	a0,0
 1ec:	bfdd                	j	1e2 <strchr+0x1c>

00000000000001ee <gets>:

char*
gets(char *buf, int max)
{
 1ee:	711d                	addi	sp,sp,-96
 1f0:	ec86                	sd	ra,88(sp)
 1f2:	e8a2                	sd	s0,80(sp)
 1f4:	e4a6                	sd	s1,72(sp)
 1f6:	e0ca                	sd	s2,64(sp)
 1f8:	fc4e                	sd	s3,56(sp)
 1fa:	f852                	sd	s4,48(sp)
 1fc:	f456                	sd	s5,40(sp)
 1fe:	f05a                	sd	s6,32(sp)
 200:	ec5e                	sd	s7,24(sp)
 202:	e862                	sd	s8,16(sp)
 204:	1080                	addi	s0,sp,96
 206:	8baa                	mv	s7,a0
 208:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 20a:	892a                	mv	s2,a0
 20c:	4481                	li	s1,0
    cc = read(0, &c, 1);
 20e:	faf40b13          	addi	s6,s0,-81
 212:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 214:	8c26                	mv	s8,s1
 216:	0014899b          	addiw	s3,s1,1
 21a:	84ce                	mv	s1,s3
 21c:	0349d663          	bge	s3,s4,248 <gets+0x5a>
    cc = read(0, &c, 1);
 220:	8656                	mv	a2,s5
 222:	85da                	mv	a1,s6
 224:	4501                	li	a0,0
 226:	00000097          	auipc	ra,0x0
 22a:	1a4080e7          	jalr	420(ra) # 3ca <read>
    if(cc < 1)
 22e:	00a05d63          	blez	a0,248 <gets+0x5a>
      break;
    buf[i++] = c;
 232:	faf44783          	lbu	a5,-81(s0)
 236:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 23a:	0905                	addi	s2,s2,1
 23c:	ff678713          	addi	a4,a5,-10
 240:	c319                	beqz	a4,246 <gets+0x58>
 242:	17cd                	addi	a5,a5,-13
 244:	fbe1                	bnez	a5,214 <gets+0x26>
    buf[i++] = c;
 246:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 248:	9c5e                	add	s8,s8,s7
 24a:	000c0023          	sb	zero,0(s8)
  return buf;
}
 24e:	855e                	mv	a0,s7
 250:	60e6                	ld	ra,88(sp)
 252:	6446                	ld	s0,80(sp)
 254:	64a6                	ld	s1,72(sp)
 256:	6906                	ld	s2,64(sp)
 258:	79e2                	ld	s3,56(sp)
 25a:	7a42                	ld	s4,48(sp)
 25c:	7aa2                	ld	s5,40(sp)
 25e:	7b02                	ld	s6,32(sp)
 260:	6be2                	ld	s7,24(sp)
 262:	6c42                	ld	s8,16(sp)
 264:	6125                	addi	sp,sp,96
 266:	8082                	ret

0000000000000268 <stat>:

int
stat(const char *n, struct stat *st)
{
 268:	1101                	addi	sp,sp,-32
 26a:	ec06                	sd	ra,24(sp)
 26c:	e822                	sd	s0,16(sp)
 26e:	e04a                	sd	s2,0(sp)
 270:	1000                	addi	s0,sp,32
 272:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 274:	4581                	li	a1,0
 276:	00000097          	auipc	ra,0x0
 27a:	17c080e7          	jalr	380(ra) # 3f2 <open>
  if(fd < 0)
 27e:	02054663          	bltz	a0,2aa <stat+0x42>
 282:	e426                	sd	s1,8(sp)
 284:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 286:	85ca                	mv	a1,s2
 288:	00000097          	auipc	ra,0x0
 28c:	182080e7          	jalr	386(ra) # 40a <fstat>
 290:	892a                	mv	s2,a0
  close(fd);
 292:	8526                	mv	a0,s1
 294:	00000097          	auipc	ra,0x0
 298:	146080e7          	jalr	326(ra) # 3da <close>
  return r;
 29c:	64a2                	ld	s1,8(sp)
}
 29e:	854a                	mv	a0,s2
 2a0:	60e2                	ld	ra,24(sp)
 2a2:	6442                	ld	s0,16(sp)
 2a4:	6902                	ld	s2,0(sp)
 2a6:	6105                	addi	sp,sp,32
 2a8:	8082                	ret
    return -1;
 2aa:	57fd                	li	a5,-1
 2ac:	893e                	mv	s2,a5
 2ae:	bfc5                	j	29e <stat+0x36>

00000000000002b0 <atoi>:

int
atoi(const char *s)
{
 2b0:	1141                	addi	sp,sp,-16
 2b2:	e406                	sd	ra,8(sp)
 2b4:	e022                	sd	s0,0(sp)
 2b6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2b8:	00054683          	lbu	a3,0(a0)
 2bc:	fd06879b          	addiw	a5,a3,-48
 2c0:	0ff7f793          	zext.b	a5,a5
 2c4:	4625                	li	a2,9
 2c6:	02f66963          	bltu	a2,a5,2f8 <atoi+0x48>
 2ca:	872a                	mv	a4,a0
  n = 0;
 2cc:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2ce:	0705                	addi	a4,a4,1
 2d0:	0025179b          	slliw	a5,a0,0x2
 2d4:	9fa9                	addw	a5,a5,a0
 2d6:	0017979b          	slliw	a5,a5,0x1
 2da:	9fb5                	addw	a5,a5,a3
 2dc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2e0:	00074683          	lbu	a3,0(a4)
 2e4:	fd06879b          	addiw	a5,a3,-48
 2e8:	0ff7f793          	zext.b	a5,a5
 2ec:	fef671e3          	bgeu	a2,a5,2ce <atoi+0x1e>
  return n;
}
 2f0:	60a2                	ld	ra,8(sp)
 2f2:	6402                	ld	s0,0(sp)
 2f4:	0141                	addi	sp,sp,16
 2f6:	8082                	ret
  n = 0;
 2f8:	4501                	li	a0,0
 2fa:	bfdd                	j	2f0 <atoi+0x40>

00000000000002fc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2fc:	1141                	addi	sp,sp,-16
 2fe:	e406                	sd	ra,8(sp)
 300:	e022                	sd	s0,0(sp)
 302:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 304:	02b57563          	bgeu	a0,a1,32e <memmove+0x32>
    while(n-- > 0)
 308:	00c05f63          	blez	a2,326 <memmove+0x2a>
 30c:	1602                	slli	a2,a2,0x20
 30e:	9201                	srli	a2,a2,0x20
 310:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 314:	872a                	mv	a4,a0
      *dst++ = *src++;
 316:	0585                	addi	a1,a1,1
 318:	0705                	addi	a4,a4,1
 31a:	fff5c683          	lbu	a3,-1(a1)
 31e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 322:	fee79ae3          	bne	a5,a4,316 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 326:	60a2                	ld	ra,8(sp)
 328:	6402                	ld	s0,0(sp)
 32a:	0141                	addi	sp,sp,16
 32c:	8082                	ret
    while(n-- > 0)
 32e:	fec05ce3          	blez	a2,326 <memmove+0x2a>
    dst += n;
 332:	00c50733          	add	a4,a0,a2
    src += n;
 336:	95b2                	add	a1,a1,a2
 338:	fff6079b          	addiw	a5,a2,-1
 33c:	1782                	slli	a5,a5,0x20
 33e:	9381                	srli	a5,a5,0x20
 340:	fff7c793          	not	a5,a5
 344:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 346:	15fd                	addi	a1,a1,-1
 348:	177d                	addi	a4,a4,-1
 34a:	0005c683          	lbu	a3,0(a1)
 34e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 352:	fef71ae3          	bne	a4,a5,346 <memmove+0x4a>
 356:	bfc1                	j	326 <memmove+0x2a>

0000000000000358 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 358:	1141                	addi	sp,sp,-16
 35a:	e406                	sd	ra,8(sp)
 35c:	e022                	sd	s0,0(sp)
 35e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 360:	c61d                	beqz	a2,38e <memcmp+0x36>
 362:	1602                	slli	a2,a2,0x20
 364:	9201                	srli	a2,a2,0x20
 366:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 36a:	00054783          	lbu	a5,0(a0)
 36e:	0005c703          	lbu	a4,0(a1)
 372:	00e79863          	bne	a5,a4,382 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 376:	0505                	addi	a0,a0,1
    p2++;
 378:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 37a:	fed518e3          	bne	a0,a3,36a <memcmp+0x12>
  }
  return 0;
 37e:	4501                	li	a0,0
 380:	a019                	j	386 <memcmp+0x2e>
      return *p1 - *p2;
 382:	40e7853b          	subw	a0,a5,a4
}
 386:	60a2                	ld	ra,8(sp)
 388:	6402                	ld	s0,0(sp)
 38a:	0141                	addi	sp,sp,16
 38c:	8082                	ret
  return 0;
 38e:	4501                	li	a0,0
 390:	bfdd                	j	386 <memcmp+0x2e>

0000000000000392 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 392:	1141                	addi	sp,sp,-16
 394:	e406                	sd	ra,8(sp)
 396:	e022                	sd	s0,0(sp)
 398:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 39a:	00000097          	auipc	ra,0x0
 39e:	f62080e7          	jalr	-158(ra) # 2fc <memmove>
}
 3a2:	60a2                	ld	ra,8(sp)
 3a4:	6402                	ld	s0,0(sp)
 3a6:	0141                	addi	sp,sp,16
 3a8:	8082                	ret

00000000000003aa <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3aa:	4885                	li	a7,1
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3b2:	4889                	li	a7,2
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <wait>:
.global wait
wait:
 li a7, SYS_wait
 3ba:	488d                	li	a7,3
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3c2:	4891                	li	a7,4
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <read>:
.global read
read:
 li a7, SYS_read
 3ca:	4895                	li	a7,5
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <write>:
.global write
write:
 li a7, SYS_write
 3d2:	48c1                	li	a7,16
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <close>:
.global close
close:
 li a7, SYS_close
 3da:	48d5                	li	a7,21
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3e2:	4899                	li	a7,6
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <exec>:
.global exec
exec:
 li a7, SYS_exec
 3ea:	489d                	li	a7,7
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <open>:
.global open
open:
 li a7, SYS_open
 3f2:	48bd                	li	a7,15
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3fa:	48c5                	li	a7,17
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 402:	48c9                	li	a7,18
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 40a:	48a1                	li	a7,8
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <link>:
.global link
link:
 li a7, SYS_link
 412:	48cd                	li	a7,19
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 41a:	48d1                	li	a7,20
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 422:	48a5                	li	a7,9
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <dup>:
.global dup
dup:
 li a7, SYS_dup
 42a:	48a9                	li	a7,10
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 432:	48ad                	li	a7,11
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 43a:	48b1                	li	a7,12
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 442:	48b5                	li	a7,13
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 44a:	48b9                	li	a7,14
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <wait2>:
.global wait2
wait2:
 li a7, SYS_wait2
 452:	48dd                	li	a7,23
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 45a:	1101                	addi	sp,sp,-32
 45c:	ec06                	sd	ra,24(sp)
 45e:	e822                	sd	s0,16(sp)
 460:	1000                	addi	s0,sp,32
 462:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 466:	4605                	li	a2,1
 468:	fef40593          	addi	a1,s0,-17
 46c:	00000097          	auipc	ra,0x0
 470:	f66080e7          	jalr	-154(ra) # 3d2 <write>
}
 474:	60e2                	ld	ra,24(sp)
 476:	6442                	ld	s0,16(sp)
 478:	6105                	addi	sp,sp,32
 47a:	8082                	ret

000000000000047c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 47c:	7139                	addi	sp,sp,-64
 47e:	fc06                	sd	ra,56(sp)
 480:	f822                	sd	s0,48(sp)
 482:	f04a                	sd	s2,32(sp)
 484:	ec4e                	sd	s3,24(sp)
 486:	0080                	addi	s0,sp,64
 488:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 48a:	cad9                	beqz	a3,520 <printint+0xa4>
 48c:	01f5d79b          	srliw	a5,a1,0x1f
 490:	cbc1                	beqz	a5,520 <printint+0xa4>
    neg = 1;
    x = -xx;
 492:	40b005bb          	negw	a1,a1
    neg = 1;
 496:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 498:	fc040993          	addi	s3,s0,-64
  neg = 0;
 49c:	86ce                	mv	a3,s3
  i = 0;
 49e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4a0:	00000817          	auipc	a6,0x0
 4a4:	50080813          	addi	a6,a6,1280 # 9a0 <digits>
 4a8:	88ba                	mv	a7,a4
 4aa:	0017051b          	addiw	a0,a4,1
 4ae:	872a                	mv	a4,a0
 4b0:	02c5f7bb          	remuw	a5,a1,a2
 4b4:	1782                	slli	a5,a5,0x20
 4b6:	9381                	srli	a5,a5,0x20
 4b8:	97c2                	add	a5,a5,a6
 4ba:	0007c783          	lbu	a5,0(a5)
 4be:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4c2:	87ae                	mv	a5,a1
 4c4:	02c5d5bb          	divuw	a1,a1,a2
 4c8:	0685                	addi	a3,a3,1
 4ca:	fcc7ffe3          	bgeu	a5,a2,4a8 <printint+0x2c>
  if(neg)
 4ce:	00030c63          	beqz	t1,4e6 <printint+0x6a>
    buf[i++] = '-';
 4d2:	fd050793          	addi	a5,a0,-48
 4d6:	00878533          	add	a0,a5,s0
 4da:	02d00793          	li	a5,45
 4de:	fef50823          	sb	a5,-16(a0)
 4e2:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 4e6:	02e05763          	blez	a4,514 <printint+0x98>
 4ea:	f426                	sd	s1,40(sp)
 4ec:	377d                	addiw	a4,a4,-1
 4ee:	00e984b3          	add	s1,s3,a4
 4f2:	19fd                	addi	s3,s3,-1
 4f4:	99ba                	add	s3,s3,a4
 4f6:	1702                	slli	a4,a4,0x20
 4f8:	9301                	srli	a4,a4,0x20
 4fa:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4fe:	0004c583          	lbu	a1,0(s1)
 502:	854a                	mv	a0,s2
 504:	00000097          	auipc	ra,0x0
 508:	f56080e7          	jalr	-170(ra) # 45a <putc>
  while(--i >= 0)
 50c:	14fd                	addi	s1,s1,-1
 50e:	ff3498e3          	bne	s1,s3,4fe <printint+0x82>
 512:	74a2                	ld	s1,40(sp)
}
 514:	70e2                	ld	ra,56(sp)
 516:	7442                	ld	s0,48(sp)
 518:	7902                	ld	s2,32(sp)
 51a:	69e2                	ld	s3,24(sp)
 51c:	6121                	addi	sp,sp,64
 51e:	8082                	ret
  neg = 0;
 520:	4301                	li	t1,0
 522:	bf9d                	j	498 <printint+0x1c>

0000000000000524 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 524:	715d                	addi	sp,sp,-80
 526:	e486                	sd	ra,72(sp)
 528:	e0a2                	sd	s0,64(sp)
 52a:	f84a                	sd	s2,48(sp)
 52c:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 52e:	0005c903          	lbu	s2,0(a1)
 532:	1a090b63          	beqz	s2,6e8 <vprintf+0x1c4>
 536:	fc26                	sd	s1,56(sp)
 538:	f44e                	sd	s3,40(sp)
 53a:	f052                	sd	s4,32(sp)
 53c:	ec56                	sd	s5,24(sp)
 53e:	e85a                	sd	s6,16(sp)
 540:	e45e                	sd	s7,8(sp)
 542:	8aaa                	mv	s5,a0
 544:	8bb2                	mv	s7,a2
 546:	00158493          	addi	s1,a1,1
  state = 0;
 54a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 54c:	02500a13          	li	s4,37
 550:	4b55                	li	s6,21
 552:	a839                	j	570 <vprintf+0x4c>
        putc(fd, c);
 554:	85ca                	mv	a1,s2
 556:	8556                	mv	a0,s5
 558:	00000097          	auipc	ra,0x0
 55c:	f02080e7          	jalr	-254(ra) # 45a <putc>
 560:	a019                	j	566 <vprintf+0x42>
    } else if(state == '%'){
 562:	01498d63          	beq	s3,s4,57c <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 566:	0485                	addi	s1,s1,1
 568:	fff4c903          	lbu	s2,-1(s1)
 56c:	16090863          	beqz	s2,6dc <vprintf+0x1b8>
    if(state == 0){
 570:	fe0999e3          	bnez	s3,562 <vprintf+0x3e>
      if(c == '%'){
 574:	ff4910e3          	bne	s2,s4,554 <vprintf+0x30>
        state = '%';
 578:	89d2                	mv	s3,s4
 57a:	b7f5                	j	566 <vprintf+0x42>
      if(c == 'd'){
 57c:	13490563          	beq	s2,s4,6a6 <vprintf+0x182>
 580:	f9d9079b          	addiw	a5,s2,-99
 584:	0ff7f793          	zext.b	a5,a5
 588:	12fb6863          	bltu	s6,a5,6b8 <vprintf+0x194>
 58c:	f9d9079b          	addiw	a5,s2,-99
 590:	0ff7f713          	zext.b	a4,a5
 594:	12eb6263          	bltu	s6,a4,6b8 <vprintf+0x194>
 598:	00271793          	slli	a5,a4,0x2
 59c:	00000717          	auipc	a4,0x0
 5a0:	3ac70713          	addi	a4,a4,940 # 948 <malloc+0x16c>
 5a4:	97ba                	add	a5,a5,a4
 5a6:	439c                	lw	a5,0(a5)
 5a8:	97ba                	add	a5,a5,a4
 5aa:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5ac:	008b8913          	addi	s2,s7,8
 5b0:	4685                	li	a3,1
 5b2:	4629                	li	a2,10
 5b4:	000ba583          	lw	a1,0(s7)
 5b8:	8556                	mv	a0,s5
 5ba:	00000097          	auipc	ra,0x0
 5be:	ec2080e7          	jalr	-318(ra) # 47c <printint>
 5c2:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5c4:	4981                	li	s3,0
 5c6:	b745                	j	566 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5c8:	008b8913          	addi	s2,s7,8
 5cc:	4681                	li	a3,0
 5ce:	4629                	li	a2,10
 5d0:	000ba583          	lw	a1,0(s7)
 5d4:	8556                	mv	a0,s5
 5d6:	00000097          	auipc	ra,0x0
 5da:	ea6080e7          	jalr	-346(ra) # 47c <printint>
 5de:	8bca                	mv	s7,s2
      state = 0;
 5e0:	4981                	li	s3,0
 5e2:	b751                	j	566 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 5e4:	008b8913          	addi	s2,s7,8
 5e8:	4681                	li	a3,0
 5ea:	4641                	li	a2,16
 5ec:	000ba583          	lw	a1,0(s7)
 5f0:	8556                	mv	a0,s5
 5f2:	00000097          	auipc	ra,0x0
 5f6:	e8a080e7          	jalr	-374(ra) # 47c <printint>
 5fa:	8bca                	mv	s7,s2
      state = 0;
 5fc:	4981                	li	s3,0
 5fe:	b7a5                	j	566 <vprintf+0x42>
 600:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 602:	008b8793          	addi	a5,s7,8
 606:	8c3e                	mv	s8,a5
 608:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 60c:	03000593          	li	a1,48
 610:	8556                	mv	a0,s5
 612:	00000097          	auipc	ra,0x0
 616:	e48080e7          	jalr	-440(ra) # 45a <putc>
  putc(fd, 'x');
 61a:	07800593          	li	a1,120
 61e:	8556                	mv	a0,s5
 620:	00000097          	auipc	ra,0x0
 624:	e3a080e7          	jalr	-454(ra) # 45a <putc>
 628:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 62a:	00000b97          	auipc	s7,0x0
 62e:	376b8b93          	addi	s7,s7,886 # 9a0 <digits>
 632:	03c9d793          	srli	a5,s3,0x3c
 636:	97de                	add	a5,a5,s7
 638:	0007c583          	lbu	a1,0(a5)
 63c:	8556                	mv	a0,s5
 63e:	00000097          	auipc	ra,0x0
 642:	e1c080e7          	jalr	-484(ra) # 45a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 646:	0992                	slli	s3,s3,0x4
 648:	397d                	addiw	s2,s2,-1
 64a:	fe0914e3          	bnez	s2,632 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 64e:	8be2                	mv	s7,s8
      state = 0;
 650:	4981                	li	s3,0
 652:	6c02                	ld	s8,0(sp)
 654:	bf09                	j	566 <vprintf+0x42>
        s = va_arg(ap, char*);
 656:	008b8993          	addi	s3,s7,8
 65a:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 65e:	02090163          	beqz	s2,680 <vprintf+0x15c>
        while(*s != 0){
 662:	00094583          	lbu	a1,0(s2)
 666:	c9a5                	beqz	a1,6d6 <vprintf+0x1b2>
          putc(fd, *s);
 668:	8556                	mv	a0,s5
 66a:	00000097          	auipc	ra,0x0
 66e:	df0080e7          	jalr	-528(ra) # 45a <putc>
          s++;
 672:	0905                	addi	s2,s2,1
        while(*s != 0){
 674:	00094583          	lbu	a1,0(s2)
 678:	f9e5                	bnez	a1,668 <vprintf+0x144>
        s = va_arg(ap, char*);
 67a:	8bce                	mv	s7,s3
      state = 0;
 67c:	4981                	li	s3,0
 67e:	b5e5                	j	566 <vprintf+0x42>
          s = "(null)";
 680:	00000917          	auipc	s2,0x0
 684:	2c090913          	addi	s2,s2,704 # 940 <malloc+0x164>
        while(*s != 0){
 688:	02800593          	li	a1,40
 68c:	bff1                	j	668 <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 68e:	008b8913          	addi	s2,s7,8
 692:	000bc583          	lbu	a1,0(s7)
 696:	8556                	mv	a0,s5
 698:	00000097          	auipc	ra,0x0
 69c:	dc2080e7          	jalr	-574(ra) # 45a <putc>
 6a0:	8bca                	mv	s7,s2
      state = 0;
 6a2:	4981                	li	s3,0
 6a4:	b5c9                	j	566 <vprintf+0x42>
        putc(fd, c);
 6a6:	02500593          	li	a1,37
 6aa:	8556                	mv	a0,s5
 6ac:	00000097          	auipc	ra,0x0
 6b0:	dae080e7          	jalr	-594(ra) # 45a <putc>
      state = 0;
 6b4:	4981                	li	s3,0
 6b6:	bd45                	j	566 <vprintf+0x42>
        putc(fd, '%');
 6b8:	02500593          	li	a1,37
 6bc:	8556                	mv	a0,s5
 6be:	00000097          	auipc	ra,0x0
 6c2:	d9c080e7          	jalr	-612(ra) # 45a <putc>
        putc(fd, c);
 6c6:	85ca                	mv	a1,s2
 6c8:	8556                	mv	a0,s5
 6ca:	00000097          	auipc	ra,0x0
 6ce:	d90080e7          	jalr	-624(ra) # 45a <putc>
      state = 0;
 6d2:	4981                	li	s3,0
 6d4:	bd49                	j	566 <vprintf+0x42>
        s = va_arg(ap, char*);
 6d6:	8bce                	mv	s7,s3
      state = 0;
 6d8:	4981                	li	s3,0
 6da:	b571                	j	566 <vprintf+0x42>
 6dc:	74e2                	ld	s1,56(sp)
 6de:	79a2                	ld	s3,40(sp)
 6e0:	7a02                	ld	s4,32(sp)
 6e2:	6ae2                	ld	s5,24(sp)
 6e4:	6b42                	ld	s6,16(sp)
 6e6:	6ba2                	ld	s7,8(sp)
    }
  }
}
 6e8:	60a6                	ld	ra,72(sp)
 6ea:	6406                	ld	s0,64(sp)
 6ec:	7942                	ld	s2,48(sp)
 6ee:	6161                	addi	sp,sp,80
 6f0:	8082                	ret

00000000000006f2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6f2:	715d                	addi	sp,sp,-80
 6f4:	ec06                	sd	ra,24(sp)
 6f6:	e822                	sd	s0,16(sp)
 6f8:	1000                	addi	s0,sp,32
 6fa:	e010                	sd	a2,0(s0)
 6fc:	e414                	sd	a3,8(s0)
 6fe:	e818                	sd	a4,16(s0)
 700:	ec1c                	sd	a5,24(s0)
 702:	03043023          	sd	a6,32(s0)
 706:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 70a:	8622                	mv	a2,s0
 70c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 710:	00000097          	auipc	ra,0x0
 714:	e14080e7          	jalr	-492(ra) # 524 <vprintf>
}
 718:	60e2                	ld	ra,24(sp)
 71a:	6442                	ld	s0,16(sp)
 71c:	6161                	addi	sp,sp,80
 71e:	8082                	ret

0000000000000720 <printf>:

void
printf(const char *fmt, ...)
{
 720:	711d                	addi	sp,sp,-96
 722:	ec06                	sd	ra,24(sp)
 724:	e822                	sd	s0,16(sp)
 726:	1000                	addi	s0,sp,32
 728:	e40c                	sd	a1,8(s0)
 72a:	e810                	sd	a2,16(s0)
 72c:	ec14                	sd	a3,24(s0)
 72e:	f018                	sd	a4,32(s0)
 730:	f41c                	sd	a5,40(s0)
 732:	03043823          	sd	a6,48(s0)
 736:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 73a:	00840613          	addi	a2,s0,8
 73e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 742:	85aa                	mv	a1,a0
 744:	4505                	li	a0,1
 746:	00000097          	auipc	ra,0x0
 74a:	dde080e7          	jalr	-546(ra) # 524 <vprintf>
}
 74e:	60e2                	ld	ra,24(sp)
 750:	6442                	ld	s0,16(sp)
 752:	6125                	addi	sp,sp,96
 754:	8082                	ret

0000000000000756 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 756:	1141                	addi	sp,sp,-16
 758:	e406                	sd	ra,8(sp)
 75a:	e022                	sd	s0,0(sp)
 75c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 75e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 762:	00000797          	auipc	a5,0x0
 766:	2567b783          	ld	a5,598(a5) # 9b8 <freep>
 76a:	a039                	j	778 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 76c:	6398                	ld	a4,0(a5)
 76e:	00e7e463          	bltu	a5,a4,776 <free+0x20>
 772:	00e6ea63          	bltu	a3,a4,786 <free+0x30>
{
 776:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 778:	fed7fae3          	bgeu	a5,a3,76c <free+0x16>
 77c:	6398                	ld	a4,0(a5)
 77e:	00e6e463          	bltu	a3,a4,786 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 782:	fee7eae3          	bltu	a5,a4,776 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 786:	ff852583          	lw	a1,-8(a0)
 78a:	6390                	ld	a2,0(a5)
 78c:	02059813          	slli	a6,a1,0x20
 790:	01c85713          	srli	a4,a6,0x1c
 794:	9736                	add	a4,a4,a3
 796:	02e60563          	beq	a2,a4,7c0 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 79a:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 79e:	4790                	lw	a2,8(a5)
 7a0:	02061593          	slli	a1,a2,0x20
 7a4:	01c5d713          	srli	a4,a1,0x1c
 7a8:	973e                	add	a4,a4,a5
 7aa:	02e68263          	beq	a3,a4,7ce <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7ae:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7b0:	00000717          	auipc	a4,0x0
 7b4:	20f73423          	sd	a5,520(a4) # 9b8 <freep>
}
 7b8:	60a2                	ld	ra,8(sp)
 7ba:	6402                	ld	s0,0(sp)
 7bc:	0141                	addi	sp,sp,16
 7be:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 7c0:	4618                	lw	a4,8(a2)
 7c2:	9f2d                	addw	a4,a4,a1
 7c4:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7c8:	6398                	ld	a4,0(a5)
 7ca:	6310                	ld	a2,0(a4)
 7cc:	b7f9                	j	79a <free+0x44>
    p->s.size += bp->s.size;
 7ce:	ff852703          	lw	a4,-8(a0)
 7d2:	9f31                	addw	a4,a4,a2
 7d4:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7d6:	ff053683          	ld	a3,-16(a0)
 7da:	bfd1                	j	7ae <free+0x58>

00000000000007dc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7dc:	7139                	addi	sp,sp,-64
 7de:	fc06                	sd	ra,56(sp)
 7e0:	f822                	sd	s0,48(sp)
 7e2:	f04a                	sd	s2,32(sp)
 7e4:	ec4e                	sd	s3,24(sp)
 7e6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7e8:	02051993          	slli	s3,a0,0x20
 7ec:	0209d993          	srli	s3,s3,0x20
 7f0:	09bd                	addi	s3,s3,15
 7f2:	0049d993          	srli	s3,s3,0x4
 7f6:	2985                	addiw	s3,s3,1
 7f8:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 7fa:	00000517          	auipc	a0,0x0
 7fe:	1be53503          	ld	a0,446(a0) # 9b8 <freep>
 802:	c905                	beqz	a0,832 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 804:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 806:	4798                	lw	a4,8(a5)
 808:	09377a63          	bgeu	a4,s3,89c <malloc+0xc0>
 80c:	f426                	sd	s1,40(sp)
 80e:	e852                	sd	s4,16(sp)
 810:	e456                	sd	s5,8(sp)
 812:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 814:	8a4e                	mv	s4,s3
 816:	6705                	lui	a4,0x1
 818:	00e9f363          	bgeu	s3,a4,81e <malloc+0x42>
 81c:	6a05                	lui	s4,0x1
 81e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 822:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 826:	00000497          	auipc	s1,0x0
 82a:	19248493          	addi	s1,s1,402 # 9b8 <freep>
  if(p == (char*)-1)
 82e:	5afd                	li	s5,-1
 830:	a089                	j	872 <malloc+0x96>
 832:	f426                	sd	s1,40(sp)
 834:	e852                	sd	s4,16(sp)
 836:	e456                	sd	s5,8(sp)
 838:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 83a:	00000797          	auipc	a5,0x0
 83e:	18678793          	addi	a5,a5,390 # 9c0 <base>
 842:	00000717          	auipc	a4,0x0
 846:	16f73b23          	sd	a5,374(a4) # 9b8 <freep>
 84a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 84c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 850:	b7d1                	j	814 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 852:	6398                	ld	a4,0(a5)
 854:	e118                	sd	a4,0(a0)
 856:	a8b9                	j	8b4 <malloc+0xd8>
  hp->s.size = nu;
 858:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 85c:	0541                	addi	a0,a0,16
 85e:	00000097          	auipc	ra,0x0
 862:	ef8080e7          	jalr	-264(ra) # 756 <free>
  return freep;
 866:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 868:	c135                	beqz	a0,8cc <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 86a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 86c:	4798                	lw	a4,8(a5)
 86e:	03277363          	bgeu	a4,s2,894 <malloc+0xb8>
    if(p == freep)
 872:	6098                	ld	a4,0(s1)
 874:	853e                	mv	a0,a5
 876:	fef71ae3          	bne	a4,a5,86a <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 87a:	8552                	mv	a0,s4
 87c:	00000097          	auipc	ra,0x0
 880:	bbe080e7          	jalr	-1090(ra) # 43a <sbrk>
  if(p == (char*)-1)
 884:	fd551ae3          	bne	a0,s5,858 <malloc+0x7c>
        return 0;
 888:	4501                	li	a0,0
 88a:	74a2                	ld	s1,40(sp)
 88c:	6a42                	ld	s4,16(sp)
 88e:	6aa2                	ld	s5,8(sp)
 890:	6b02                	ld	s6,0(sp)
 892:	a03d                	j	8c0 <malloc+0xe4>
 894:	74a2                	ld	s1,40(sp)
 896:	6a42                	ld	s4,16(sp)
 898:	6aa2                	ld	s5,8(sp)
 89a:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 89c:	fae90be3          	beq	s2,a4,852 <malloc+0x76>
        p->s.size -= nunits;
 8a0:	4137073b          	subw	a4,a4,s3
 8a4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8a6:	02071693          	slli	a3,a4,0x20
 8aa:	01c6d713          	srli	a4,a3,0x1c
 8ae:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8b0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8b4:	00000717          	auipc	a4,0x0
 8b8:	10a73223          	sd	a0,260(a4) # 9b8 <freep>
      return (void*)(p + 1);
 8bc:	01078513          	addi	a0,a5,16
  }
}
 8c0:	70e2                	ld	ra,56(sp)
 8c2:	7442                	ld	s0,48(sp)
 8c4:	7902                	ld	s2,32(sp)
 8c6:	69e2                	ld	s3,24(sp)
 8c8:	6121                	addi	sp,sp,64
 8ca:	8082                	ret
 8cc:	74a2                	ld	s1,40(sp)
 8ce:	6a42                	ld	s4,16(sp)
 8d0:	6aa2                	ld	s5,8(sp)
 8d2:	6b02                	ld	s6,0(sp)
 8d4:	b7f5                	j	8c0 <malloc+0xe4>
