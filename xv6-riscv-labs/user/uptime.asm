
user/_uptime:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <uptime_decimal>:
    printf("up %d clock ticks\n", ticks);

    exit(0);
} */

void uptime_decimal(int n){
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
   8:	85aa                	mv	a1,a0
    printf("up %d clock ticks\n", n);
   a:	00001517          	auipc	a0,0x1
   e:	88e50513          	addi	a0,a0,-1906 # 898 <malloc+0x100>
  12:	00000097          	auipc	ra,0x0
  16:	6ca080e7          	jalr	1738(ra) # 6dc <printf>
}
  1a:	60a2                	ld	ra,8(sp)
  1c:	6402                	ld	s0,0(sp)
  1e:	0141                	addi	sp,sp,16
  20:	8082                	ret

0000000000000022 <uptime_hex>:

void uptime_hex(int n){
  22:	1141                	addi	sp,sp,-16
  24:	e406                	sd	ra,8(sp)
  26:	e022                	sd	s0,0(sp)
  28:	0800                	addi	s0,sp,16
  2a:	85aa                	mv	a1,a0
    printf("up 0x%x clock ticks\n", n);
  2c:	00001517          	auipc	a0,0x1
  30:	88450513          	addi	a0,a0,-1916 # 8b0 <malloc+0x118>
  34:	00000097          	auipc	ra,0x0
  38:	6a8080e7          	jalr	1704(ra) # 6dc <printf>
}
  3c:	60a2                	ld	ra,8(sp)
  3e:	6402                	ld	s0,0(sp)
  40:	0141                	addi	sp,sp,16
  42:	8082                	ret

0000000000000044 <main>:
 * This program retrieves and displays the system uptime in ticks.
 * It supports optional command-line arguments to format the output:
 * - No arguments: displays uptime in decimal format.
 * - -h: displays uptime in hexadecimal format.
 */
int main(int argc, char *argv[]){
  44:	7179                	addi	sp,sp,-48
  46:	f406                	sd	ra,40(sp)
  48:	f022                	sd	s0,32(sp)
  4a:	e84a                	sd	s2,16(sp)
  4c:	e44e                	sd	s3,8(sp)
  4e:	1800                	addi	s0,sp,48
  50:	892a                	mv	s2,a0
  52:	89ae                	mv	s3,a1
    // Retrieve uptime in ticks using the uptime system call from the user.h header file
    int ticks = uptime();
  54:	00000097          	auipc	ra,0x0
  58:	3b2080e7          	jalr	946(ra) # 406 <uptime>

    // Error handling for uptime system call

    if(ticks < 0){
  5c:	02054f63          	bltz	a0,9a <main+0x56>
  60:	ec26                	sd	s1,24(sp)
  62:	84aa                	mv	s1,a0
        exit(1);
    }
    // Handle command-line arguments for output format
    // Default to decimal if no arguments are provided

    if(argc == 1){
  64:	4785                	li	a5,1
  66:	04f90963          	beq	s2,a5,b8 <main+0x74>
       uptime_decimal(ticks);
    }
    // Check for specific flags and call corresponding functions
    // strcmp is used to compare strings

    if(argc > 1){
  6a:	4785                	li	a5,1
  6c:	0327d263          	bge	a5,s2,90 <main+0x4c>
        if(strcmp(argv[1], "-h") == 0){
  70:	00001597          	auipc	a1,0x1
  74:	87858593          	addi	a1,a1,-1928 # 8e8 <malloc+0x150>
  78:	0089b503          	ld	a0,8(s3)
  7c:	00000097          	auipc	ra,0x0
  80:	084080e7          	jalr	132(ra) # 100 <strcmp>
  84:	ed1d                	bnez	a0,c2 <main+0x7e>
            uptime_hex(ticks);
  86:	8526                	mv	a0,s1
  88:	00000097          	auipc	ra,0x0
  8c:	f9a080e7          	jalr	-102(ra) # 22 <uptime_hex>
            printf("Unknown flag: \"%s\"\n", argv[1]);
            exit(1);
        }
    }
    
    exit(0);
  90:	4501                	li	a0,0
  92:	00000097          	auipc	ra,0x0
  96:	2dc080e7          	jalr	732(ra) # 36e <exit>
  9a:	ec26                	sd	s1,24(sp)
        fprintf(2, "uptime: error getting uptime\n");
  9c:	00001597          	auipc	a1,0x1
  a0:	82c58593          	addi	a1,a1,-2004 # 8c8 <malloc+0x130>
  a4:	4509                	li	a0,2
  a6:	00000097          	auipc	ra,0x0
  aa:	608080e7          	jalr	1544(ra) # 6ae <fprintf>
        exit(1);
  ae:	4505                	li	a0,1
  b0:	00000097          	auipc	ra,0x0
  b4:	2be080e7          	jalr	702(ra) # 36e <exit>
       uptime_decimal(ticks);
  b8:	00000097          	auipc	ra,0x0
  bc:	f48080e7          	jalr	-184(ra) # 0 <uptime_decimal>
    if(argc > 1){
  c0:	bfc1                	j	90 <main+0x4c>
            printf("Unknown flag: \"%s\"\n", argv[1]);
  c2:	0089b583          	ld	a1,8(s3)
  c6:	00001517          	auipc	a0,0x1
  ca:	82a50513          	addi	a0,a0,-2006 # 8f0 <malloc+0x158>
  ce:	00000097          	auipc	ra,0x0
  d2:	60e080e7          	jalr	1550(ra) # 6dc <printf>
            exit(1);
  d6:	4505                	li	a0,1
  d8:	00000097          	auipc	ra,0x0
  dc:	296080e7          	jalr	662(ra) # 36e <exit>

00000000000000e0 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  e0:	1141                	addi	sp,sp,-16
  e2:	e406                	sd	ra,8(sp)
  e4:	e022                	sd	s0,0(sp)
  e6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  e8:	87aa                	mv	a5,a0
  ea:	0585                	addi	a1,a1,1
  ec:	0785                	addi	a5,a5,1
  ee:	fff5c703          	lbu	a4,-1(a1)
  f2:	fee78fa3          	sb	a4,-1(a5)
  f6:	fb75                	bnez	a4,ea <strcpy+0xa>
    ;
  return os;
}
  f8:	60a2                	ld	ra,8(sp)
  fa:	6402                	ld	s0,0(sp)
  fc:	0141                	addi	sp,sp,16
  fe:	8082                	ret

0000000000000100 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 100:	1141                	addi	sp,sp,-16
 102:	e406                	sd	ra,8(sp)
 104:	e022                	sd	s0,0(sp)
 106:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 108:	00054783          	lbu	a5,0(a0)
 10c:	cb91                	beqz	a5,120 <strcmp+0x20>
 10e:	0005c703          	lbu	a4,0(a1)
 112:	00f71763          	bne	a4,a5,120 <strcmp+0x20>
    p++, q++;
 116:	0505                	addi	a0,a0,1
 118:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 11a:	00054783          	lbu	a5,0(a0)
 11e:	fbe5                	bnez	a5,10e <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 120:	0005c503          	lbu	a0,0(a1)
}
 124:	40a7853b          	subw	a0,a5,a0
 128:	60a2                	ld	ra,8(sp)
 12a:	6402                	ld	s0,0(sp)
 12c:	0141                	addi	sp,sp,16
 12e:	8082                	ret

0000000000000130 <strlen>:

uint
strlen(const char *s)
{
 130:	1141                	addi	sp,sp,-16
 132:	e406                	sd	ra,8(sp)
 134:	e022                	sd	s0,0(sp)
 136:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 138:	00054783          	lbu	a5,0(a0)
 13c:	cf91                	beqz	a5,158 <strlen+0x28>
 13e:	00150793          	addi	a5,a0,1
 142:	86be                	mv	a3,a5
 144:	0785                	addi	a5,a5,1
 146:	fff7c703          	lbu	a4,-1(a5)
 14a:	ff65                	bnez	a4,142 <strlen+0x12>
 14c:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 150:	60a2                	ld	ra,8(sp)
 152:	6402                	ld	s0,0(sp)
 154:	0141                	addi	sp,sp,16
 156:	8082                	ret
  for(n = 0; s[n]; n++)
 158:	4501                	li	a0,0
 15a:	bfdd                	j	150 <strlen+0x20>

000000000000015c <memset>:

void*
memset(void *dst, int c, uint n)
{
 15c:	1141                	addi	sp,sp,-16
 15e:	e406                	sd	ra,8(sp)
 160:	e022                	sd	s0,0(sp)
 162:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 164:	ca19                	beqz	a2,17a <memset+0x1e>
 166:	87aa                	mv	a5,a0
 168:	1602                	slli	a2,a2,0x20
 16a:	9201                	srli	a2,a2,0x20
 16c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 170:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 174:	0785                	addi	a5,a5,1
 176:	fee79de3          	bne	a5,a4,170 <memset+0x14>
  }
  return dst;
}
 17a:	60a2                	ld	ra,8(sp)
 17c:	6402                	ld	s0,0(sp)
 17e:	0141                	addi	sp,sp,16
 180:	8082                	ret

0000000000000182 <strchr>:

char*
strchr(const char *s, char c)
{
 182:	1141                	addi	sp,sp,-16
 184:	e406                	sd	ra,8(sp)
 186:	e022                	sd	s0,0(sp)
 188:	0800                	addi	s0,sp,16
  for(; *s; s++)
 18a:	00054783          	lbu	a5,0(a0)
 18e:	cf81                	beqz	a5,1a6 <strchr+0x24>
    if(*s == c)
 190:	00f58763          	beq	a1,a5,19e <strchr+0x1c>
  for(; *s; s++)
 194:	0505                	addi	a0,a0,1
 196:	00054783          	lbu	a5,0(a0)
 19a:	fbfd                	bnez	a5,190 <strchr+0xe>
      return (char*)s;
  return 0;
 19c:	4501                	li	a0,0
}
 19e:	60a2                	ld	ra,8(sp)
 1a0:	6402                	ld	s0,0(sp)
 1a2:	0141                	addi	sp,sp,16
 1a4:	8082                	ret
  return 0;
 1a6:	4501                	li	a0,0
 1a8:	bfdd                	j	19e <strchr+0x1c>

00000000000001aa <gets>:

char*
gets(char *buf, int max)
{
 1aa:	711d                	addi	sp,sp,-96
 1ac:	ec86                	sd	ra,88(sp)
 1ae:	e8a2                	sd	s0,80(sp)
 1b0:	e4a6                	sd	s1,72(sp)
 1b2:	e0ca                	sd	s2,64(sp)
 1b4:	fc4e                	sd	s3,56(sp)
 1b6:	f852                	sd	s4,48(sp)
 1b8:	f456                	sd	s5,40(sp)
 1ba:	f05a                	sd	s6,32(sp)
 1bc:	ec5e                	sd	s7,24(sp)
 1be:	e862                	sd	s8,16(sp)
 1c0:	1080                	addi	s0,sp,96
 1c2:	8baa                	mv	s7,a0
 1c4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c6:	892a                	mv	s2,a0
 1c8:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1ca:	faf40b13          	addi	s6,s0,-81
 1ce:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 1d0:	8c26                	mv	s8,s1
 1d2:	0014899b          	addiw	s3,s1,1
 1d6:	84ce                	mv	s1,s3
 1d8:	0349d663          	bge	s3,s4,204 <gets+0x5a>
    cc = read(0, &c, 1);
 1dc:	8656                	mv	a2,s5
 1de:	85da                	mv	a1,s6
 1e0:	4501                	li	a0,0
 1e2:	00000097          	auipc	ra,0x0
 1e6:	1a4080e7          	jalr	420(ra) # 386 <read>
    if(cc < 1)
 1ea:	00a05d63          	blez	a0,204 <gets+0x5a>
      break;
    buf[i++] = c;
 1ee:	faf44783          	lbu	a5,-81(s0)
 1f2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1f6:	0905                	addi	s2,s2,1
 1f8:	ff678713          	addi	a4,a5,-10
 1fc:	c319                	beqz	a4,202 <gets+0x58>
 1fe:	17cd                	addi	a5,a5,-13
 200:	fbe1                	bnez	a5,1d0 <gets+0x26>
    buf[i++] = c;
 202:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 204:	9c5e                	add	s8,s8,s7
 206:	000c0023          	sb	zero,0(s8)
  return buf;
}
 20a:	855e                	mv	a0,s7
 20c:	60e6                	ld	ra,88(sp)
 20e:	6446                	ld	s0,80(sp)
 210:	64a6                	ld	s1,72(sp)
 212:	6906                	ld	s2,64(sp)
 214:	79e2                	ld	s3,56(sp)
 216:	7a42                	ld	s4,48(sp)
 218:	7aa2                	ld	s5,40(sp)
 21a:	7b02                	ld	s6,32(sp)
 21c:	6be2                	ld	s7,24(sp)
 21e:	6c42                	ld	s8,16(sp)
 220:	6125                	addi	sp,sp,96
 222:	8082                	ret

0000000000000224 <stat>:

int
stat(const char *n, struct stat *st)
{
 224:	1101                	addi	sp,sp,-32
 226:	ec06                	sd	ra,24(sp)
 228:	e822                	sd	s0,16(sp)
 22a:	e04a                	sd	s2,0(sp)
 22c:	1000                	addi	s0,sp,32
 22e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 230:	4581                	li	a1,0
 232:	00000097          	auipc	ra,0x0
 236:	17c080e7          	jalr	380(ra) # 3ae <open>
  if(fd < 0)
 23a:	02054663          	bltz	a0,266 <stat+0x42>
 23e:	e426                	sd	s1,8(sp)
 240:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 242:	85ca                	mv	a1,s2
 244:	00000097          	auipc	ra,0x0
 248:	182080e7          	jalr	386(ra) # 3c6 <fstat>
 24c:	892a                	mv	s2,a0
  close(fd);
 24e:	8526                	mv	a0,s1
 250:	00000097          	auipc	ra,0x0
 254:	146080e7          	jalr	326(ra) # 396 <close>
  return r;
 258:	64a2                	ld	s1,8(sp)
}
 25a:	854a                	mv	a0,s2
 25c:	60e2                	ld	ra,24(sp)
 25e:	6442                	ld	s0,16(sp)
 260:	6902                	ld	s2,0(sp)
 262:	6105                	addi	sp,sp,32
 264:	8082                	ret
    return -1;
 266:	57fd                	li	a5,-1
 268:	893e                	mv	s2,a5
 26a:	bfc5                	j	25a <stat+0x36>

000000000000026c <atoi>:

int
atoi(const char *s)
{
 26c:	1141                	addi	sp,sp,-16
 26e:	e406                	sd	ra,8(sp)
 270:	e022                	sd	s0,0(sp)
 272:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 274:	00054683          	lbu	a3,0(a0)
 278:	fd06879b          	addiw	a5,a3,-48
 27c:	0ff7f793          	zext.b	a5,a5
 280:	4625                	li	a2,9
 282:	02f66963          	bltu	a2,a5,2b4 <atoi+0x48>
 286:	872a                	mv	a4,a0
  n = 0;
 288:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 28a:	0705                	addi	a4,a4,1
 28c:	0025179b          	slliw	a5,a0,0x2
 290:	9fa9                	addw	a5,a5,a0
 292:	0017979b          	slliw	a5,a5,0x1
 296:	9fb5                	addw	a5,a5,a3
 298:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 29c:	00074683          	lbu	a3,0(a4)
 2a0:	fd06879b          	addiw	a5,a3,-48
 2a4:	0ff7f793          	zext.b	a5,a5
 2a8:	fef671e3          	bgeu	a2,a5,28a <atoi+0x1e>
  return n;
}
 2ac:	60a2                	ld	ra,8(sp)
 2ae:	6402                	ld	s0,0(sp)
 2b0:	0141                	addi	sp,sp,16
 2b2:	8082                	ret
  n = 0;
 2b4:	4501                	li	a0,0
 2b6:	bfdd                	j	2ac <atoi+0x40>

00000000000002b8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2b8:	1141                	addi	sp,sp,-16
 2ba:	e406                	sd	ra,8(sp)
 2bc:	e022                	sd	s0,0(sp)
 2be:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2c0:	02b57563          	bgeu	a0,a1,2ea <memmove+0x32>
    while(n-- > 0)
 2c4:	00c05f63          	blez	a2,2e2 <memmove+0x2a>
 2c8:	1602                	slli	a2,a2,0x20
 2ca:	9201                	srli	a2,a2,0x20
 2cc:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2d0:	872a                	mv	a4,a0
      *dst++ = *src++;
 2d2:	0585                	addi	a1,a1,1
 2d4:	0705                	addi	a4,a4,1
 2d6:	fff5c683          	lbu	a3,-1(a1)
 2da:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2de:	fee79ae3          	bne	a5,a4,2d2 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2e2:	60a2                	ld	ra,8(sp)
 2e4:	6402                	ld	s0,0(sp)
 2e6:	0141                	addi	sp,sp,16
 2e8:	8082                	ret
    while(n-- > 0)
 2ea:	fec05ce3          	blez	a2,2e2 <memmove+0x2a>
    dst += n;
 2ee:	00c50733          	add	a4,a0,a2
    src += n;
 2f2:	95b2                	add	a1,a1,a2
 2f4:	fff6079b          	addiw	a5,a2,-1
 2f8:	1782                	slli	a5,a5,0x20
 2fa:	9381                	srli	a5,a5,0x20
 2fc:	fff7c793          	not	a5,a5
 300:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 302:	15fd                	addi	a1,a1,-1
 304:	177d                	addi	a4,a4,-1
 306:	0005c683          	lbu	a3,0(a1)
 30a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 30e:	fef71ae3          	bne	a4,a5,302 <memmove+0x4a>
 312:	bfc1                	j	2e2 <memmove+0x2a>

0000000000000314 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 314:	1141                	addi	sp,sp,-16
 316:	e406                	sd	ra,8(sp)
 318:	e022                	sd	s0,0(sp)
 31a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 31c:	c61d                	beqz	a2,34a <memcmp+0x36>
 31e:	1602                	slli	a2,a2,0x20
 320:	9201                	srli	a2,a2,0x20
 322:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 326:	00054783          	lbu	a5,0(a0)
 32a:	0005c703          	lbu	a4,0(a1)
 32e:	00e79863          	bne	a5,a4,33e <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 332:	0505                	addi	a0,a0,1
    p2++;
 334:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 336:	fed518e3          	bne	a0,a3,326 <memcmp+0x12>
  }
  return 0;
 33a:	4501                	li	a0,0
 33c:	a019                	j	342 <memcmp+0x2e>
      return *p1 - *p2;
 33e:	40e7853b          	subw	a0,a5,a4
}
 342:	60a2                	ld	ra,8(sp)
 344:	6402                	ld	s0,0(sp)
 346:	0141                	addi	sp,sp,16
 348:	8082                	ret
  return 0;
 34a:	4501                	li	a0,0
 34c:	bfdd                	j	342 <memcmp+0x2e>

000000000000034e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 34e:	1141                	addi	sp,sp,-16
 350:	e406                	sd	ra,8(sp)
 352:	e022                	sd	s0,0(sp)
 354:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 356:	00000097          	auipc	ra,0x0
 35a:	f62080e7          	jalr	-158(ra) # 2b8 <memmove>
}
 35e:	60a2                	ld	ra,8(sp)
 360:	6402                	ld	s0,0(sp)
 362:	0141                	addi	sp,sp,16
 364:	8082                	ret

0000000000000366 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 366:	4885                	li	a7,1
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <exit>:
.global exit
exit:
 li a7, SYS_exit
 36e:	4889                	li	a7,2
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <wait>:
.global wait
wait:
 li a7, SYS_wait
 376:	488d                	li	a7,3
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 37e:	4891                	li	a7,4
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <read>:
.global read
read:
 li a7, SYS_read
 386:	4895                	li	a7,5
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <write>:
.global write
write:
 li a7, SYS_write
 38e:	48c1                	li	a7,16
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <close>:
.global close
close:
 li a7, SYS_close
 396:	48d5                	li	a7,21
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <kill>:
.global kill
kill:
 li a7, SYS_kill
 39e:	4899                	li	a7,6
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3a6:	489d                	li	a7,7
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <open>:
.global open
open:
 li a7, SYS_open
 3ae:	48bd                	li	a7,15
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3b6:	48c5                	li	a7,17
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3be:	48c9                	li	a7,18
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3c6:	48a1                	li	a7,8
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <link>:
.global link
link:
 li a7, SYS_link
 3ce:	48cd                	li	a7,19
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3d6:	48d1                	li	a7,20
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3de:	48a5                	li	a7,9
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3e6:	48a9                	li	a7,10
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3ee:	48ad                	li	a7,11
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3f6:	48b1                	li	a7,12
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3fe:	48b5                	li	a7,13
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 406:	48b9                	li	a7,14
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <wait2>:
.global wait2
wait2:
 li a7, SYS_wait2
 40e:	48dd                	li	a7,23
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 416:	1101                	addi	sp,sp,-32
 418:	ec06                	sd	ra,24(sp)
 41a:	e822                	sd	s0,16(sp)
 41c:	1000                	addi	s0,sp,32
 41e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 422:	4605                	li	a2,1
 424:	fef40593          	addi	a1,s0,-17
 428:	00000097          	auipc	ra,0x0
 42c:	f66080e7          	jalr	-154(ra) # 38e <write>
}
 430:	60e2                	ld	ra,24(sp)
 432:	6442                	ld	s0,16(sp)
 434:	6105                	addi	sp,sp,32
 436:	8082                	ret

0000000000000438 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 438:	7139                	addi	sp,sp,-64
 43a:	fc06                	sd	ra,56(sp)
 43c:	f822                	sd	s0,48(sp)
 43e:	f04a                	sd	s2,32(sp)
 440:	ec4e                	sd	s3,24(sp)
 442:	0080                	addi	s0,sp,64
 444:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 446:	cad9                	beqz	a3,4dc <printint+0xa4>
 448:	01f5d79b          	srliw	a5,a1,0x1f
 44c:	cbc1                	beqz	a5,4dc <printint+0xa4>
    neg = 1;
    x = -xx;
 44e:	40b005bb          	negw	a1,a1
    neg = 1;
 452:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 454:	fc040993          	addi	s3,s0,-64
  neg = 0;
 458:	86ce                	mv	a3,s3
  i = 0;
 45a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 45c:	00000817          	auipc	a6,0x0
 460:	50c80813          	addi	a6,a6,1292 # 968 <digits>
 464:	88ba                	mv	a7,a4
 466:	0017051b          	addiw	a0,a4,1
 46a:	872a                	mv	a4,a0
 46c:	02c5f7bb          	remuw	a5,a1,a2
 470:	1782                	slli	a5,a5,0x20
 472:	9381                	srli	a5,a5,0x20
 474:	97c2                	add	a5,a5,a6
 476:	0007c783          	lbu	a5,0(a5)
 47a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 47e:	87ae                	mv	a5,a1
 480:	02c5d5bb          	divuw	a1,a1,a2
 484:	0685                	addi	a3,a3,1
 486:	fcc7ffe3          	bgeu	a5,a2,464 <printint+0x2c>
  if(neg)
 48a:	00030c63          	beqz	t1,4a2 <printint+0x6a>
    buf[i++] = '-';
 48e:	fd050793          	addi	a5,a0,-48
 492:	00878533          	add	a0,a5,s0
 496:	02d00793          	li	a5,45
 49a:	fef50823          	sb	a5,-16(a0)
 49e:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 4a2:	02e05763          	blez	a4,4d0 <printint+0x98>
 4a6:	f426                	sd	s1,40(sp)
 4a8:	377d                	addiw	a4,a4,-1
 4aa:	00e984b3          	add	s1,s3,a4
 4ae:	19fd                	addi	s3,s3,-1
 4b0:	99ba                	add	s3,s3,a4
 4b2:	1702                	slli	a4,a4,0x20
 4b4:	9301                	srli	a4,a4,0x20
 4b6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4ba:	0004c583          	lbu	a1,0(s1)
 4be:	854a                	mv	a0,s2
 4c0:	00000097          	auipc	ra,0x0
 4c4:	f56080e7          	jalr	-170(ra) # 416 <putc>
  while(--i >= 0)
 4c8:	14fd                	addi	s1,s1,-1
 4ca:	ff3498e3          	bne	s1,s3,4ba <printint+0x82>
 4ce:	74a2                	ld	s1,40(sp)
}
 4d0:	70e2                	ld	ra,56(sp)
 4d2:	7442                	ld	s0,48(sp)
 4d4:	7902                	ld	s2,32(sp)
 4d6:	69e2                	ld	s3,24(sp)
 4d8:	6121                	addi	sp,sp,64
 4da:	8082                	ret
  neg = 0;
 4dc:	4301                	li	t1,0
 4de:	bf9d                	j	454 <printint+0x1c>

00000000000004e0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4e0:	715d                	addi	sp,sp,-80
 4e2:	e486                	sd	ra,72(sp)
 4e4:	e0a2                	sd	s0,64(sp)
 4e6:	f84a                	sd	s2,48(sp)
 4e8:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4ea:	0005c903          	lbu	s2,0(a1)
 4ee:	1a090b63          	beqz	s2,6a4 <vprintf+0x1c4>
 4f2:	fc26                	sd	s1,56(sp)
 4f4:	f44e                	sd	s3,40(sp)
 4f6:	f052                	sd	s4,32(sp)
 4f8:	ec56                	sd	s5,24(sp)
 4fa:	e85a                	sd	s6,16(sp)
 4fc:	e45e                	sd	s7,8(sp)
 4fe:	8aaa                	mv	s5,a0
 500:	8bb2                	mv	s7,a2
 502:	00158493          	addi	s1,a1,1
  state = 0;
 506:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 508:	02500a13          	li	s4,37
 50c:	4b55                	li	s6,21
 50e:	a839                	j	52c <vprintf+0x4c>
        putc(fd, c);
 510:	85ca                	mv	a1,s2
 512:	8556                	mv	a0,s5
 514:	00000097          	auipc	ra,0x0
 518:	f02080e7          	jalr	-254(ra) # 416 <putc>
 51c:	a019                	j	522 <vprintf+0x42>
    } else if(state == '%'){
 51e:	01498d63          	beq	s3,s4,538 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 522:	0485                	addi	s1,s1,1
 524:	fff4c903          	lbu	s2,-1(s1)
 528:	16090863          	beqz	s2,698 <vprintf+0x1b8>
    if(state == 0){
 52c:	fe0999e3          	bnez	s3,51e <vprintf+0x3e>
      if(c == '%'){
 530:	ff4910e3          	bne	s2,s4,510 <vprintf+0x30>
        state = '%';
 534:	89d2                	mv	s3,s4
 536:	b7f5                	j	522 <vprintf+0x42>
      if(c == 'd'){
 538:	13490563          	beq	s2,s4,662 <vprintf+0x182>
 53c:	f9d9079b          	addiw	a5,s2,-99
 540:	0ff7f793          	zext.b	a5,a5
 544:	12fb6863          	bltu	s6,a5,674 <vprintf+0x194>
 548:	f9d9079b          	addiw	a5,s2,-99
 54c:	0ff7f713          	zext.b	a4,a5
 550:	12eb6263          	bltu	s6,a4,674 <vprintf+0x194>
 554:	00271793          	slli	a5,a4,0x2
 558:	00000717          	auipc	a4,0x0
 55c:	3b870713          	addi	a4,a4,952 # 910 <malloc+0x178>
 560:	97ba                	add	a5,a5,a4
 562:	439c                	lw	a5,0(a5)
 564:	97ba                	add	a5,a5,a4
 566:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 568:	008b8913          	addi	s2,s7,8
 56c:	4685                	li	a3,1
 56e:	4629                	li	a2,10
 570:	000ba583          	lw	a1,0(s7)
 574:	8556                	mv	a0,s5
 576:	00000097          	auipc	ra,0x0
 57a:	ec2080e7          	jalr	-318(ra) # 438 <printint>
 57e:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 580:	4981                	li	s3,0
 582:	b745                	j	522 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 584:	008b8913          	addi	s2,s7,8
 588:	4681                	li	a3,0
 58a:	4629                	li	a2,10
 58c:	000ba583          	lw	a1,0(s7)
 590:	8556                	mv	a0,s5
 592:	00000097          	auipc	ra,0x0
 596:	ea6080e7          	jalr	-346(ra) # 438 <printint>
 59a:	8bca                	mv	s7,s2
      state = 0;
 59c:	4981                	li	s3,0
 59e:	b751                	j	522 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 5a0:	008b8913          	addi	s2,s7,8
 5a4:	4681                	li	a3,0
 5a6:	4641                	li	a2,16
 5a8:	000ba583          	lw	a1,0(s7)
 5ac:	8556                	mv	a0,s5
 5ae:	00000097          	auipc	ra,0x0
 5b2:	e8a080e7          	jalr	-374(ra) # 438 <printint>
 5b6:	8bca                	mv	s7,s2
      state = 0;
 5b8:	4981                	li	s3,0
 5ba:	b7a5                	j	522 <vprintf+0x42>
 5bc:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5be:	008b8793          	addi	a5,s7,8
 5c2:	8c3e                	mv	s8,a5
 5c4:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5c8:	03000593          	li	a1,48
 5cc:	8556                	mv	a0,s5
 5ce:	00000097          	auipc	ra,0x0
 5d2:	e48080e7          	jalr	-440(ra) # 416 <putc>
  putc(fd, 'x');
 5d6:	07800593          	li	a1,120
 5da:	8556                	mv	a0,s5
 5dc:	00000097          	auipc	ra,0x0
 5e0:	e3a080e7          	jalr	-454(ra) # 416 <putc>
 5e4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5e6:	00000b97          	auipc	s7,0x0
 5ea:	382b8b93          	addi	s7,s7,898 # 968 <digits>
 5ee:	03c9d793          	srli	a5,s3,0x3c
 5f2:	97de                	add	a5,a5,s7
 5f4:	0007c583          	lbu	a1,0(a5)
 5f8:	8556                	mv	a0,s5
 5fa:	00000097          	auipc	ra,0x0
 5fe:	e1c080e7          	jalr	-484(ra) # 416 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 602:	0992                	slli	s3,s3,0x4
 604:	397d                	addiw	s2,s2,-1
 606:	fe0914e3          	bnez	s2,5ee <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 60a:	8be2                	mv	s7,s8
      state = 0;
 60c:	4981                	li	s3,0
 60e:	6c02                	ld	s8,0(sp)
 610:	bf09                	j	522 <vprintf+0x42>
        s = va_arg(ap, char*);
 612:	008b8993          	addi	s3,s7,8
 616:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 61a:	02090163          	beqz	s2,63c <vprintf+0x15c>
        while(*s != 0){
 61e:	00094583          	lbu	a1,0(s2)
 622:	c9a5                	beqz	a1,692 <vprintf+0x1b2>
          putc(fd, *s);
 624:	8556                	mv	a0,s5
 626:	00000097          	auipc	ra,0x0
 62a:	df0080e7          	jalr	-528(ra) # 416 <putc>
          s++;
 62e:	0905                	addi	s2,s2,1
        while(*s != 0){
 630:	00094583          	lbu	a1,0(s2)
 634:	f9e5                	bnez	a1,624 <vprintf+0x144>
        s = va_arg(ap, char*);
 636:	8bce                	mv	s7,s3
      state = 0;
 638:	4981                	li	s3,0
 63a:	b5e5                	j	522 <vprintf+0x42>
          s = "(null)";
 63c:	00000917          	auipc	s2,0x0
 640:	2cc90913          	addi	s2,s2,716 # 908 <malloc+0x170>
        while(*s != 0){
 644:	02800593          	li	a1,40
 648:	bff1                	j	624 <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 64a:	008b8913          	addi	s2,s7,8
 64e:	000bc583          	lbu	a1,0(s7)
 652:	8556                	mv	a0,s5
 654:	00000097          	auipc	ra,0x0
 658:	dc2080e7          	jalr	-574(ra) # 416 <putc>
 65c:	8bca                	mv	s7,s2
      state = 0;
 65e:	4981                	li	s3,0
 660:	b5c9                	j	522 <vprintf+0x42>
        putc(fd, c);
 662:	02500593          	li	a1,37
 666:	8556                	mv	a0,s5
 668:	00000097          	auipc	ra,0x0
 66c:	dae080e7          	jalr	-594(ra) # 416 <putc>
      state = 0;
 670:	4981                	li	s3,0
 672:	bd45                	j	522 <vprintf+0x42>
        putc(fd, '%');
 674:	02500593          	li	a1,37
 678:	8556                	mv	a0,s5
 67a:	00000097          	auipc	ra,0x0
 67e:	d9c080e7          	jalr	-612(ra) # 416 <putc>
        putc(fd, c);
 682:	85ca                	mv	a1,s2
 684:	8556                	mv	a0,s5
 686:	00000097          	auipc	ra,0x0
 68a:	d90080e7          	jalr	-624(ra) # 416 <putc>
      state = 0;
 68e:	4981                	li	s3,0
 690:	bd49                	j	522 <vprintf+0x42>
        s = va_arg(ap, char*);
 692:	8bce                	mv	s7,s3
      state = 0;
 694:	4981                	li	s3,0
 696:	b571                	j	522 <vprintf+0x42>
 698:	74e2                	ld	s1,56(sp)
 69a:	79a2                	ld	s3,40(sp)
 69c:	7a02                	ld	s4,32(sp)
 69e:	6ae2                	ld	s5,24(sp)
 6a0:	6b42                	ld	s6,16(sp)
 6a2:	6ba2                	ld	s7,8(sp)
    }
  }
}
 6a4:	60a6                	ld	ra,72(sp)
 6a6:	6406                	ld	s0,64(sp)
 6a8:	7942                	ld	s2,48(sp)
 6aa:	6161                	addi	sp,sp,80
 6ac:	8082                	ret

00000000000006ae <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6ae:	715d                	addi	sp,sp,-80
 6b0:	ec06                	sd	ra,24(sp)
 6b2:	e822                	sd	s0,16(sp)
 6b4:	1000                	addi	s0,sp,32
 6b6:	e010                	sd	a2,0(s0)
 6b8:	e414                	sd	a3,8(s0)
 6ba:	e818                	sd	a4,16(s0)
 6bc:	ec1c                	sd	a5,24(s0)
 6be:	03043023          	sd	a6,32(s0)
 6c2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6c6:	8622                	mv	a2,s0
 6c8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6cc:	00000097          	auipc	ra,0x0
 6d0:	e14080e7          	jalr	-492(ra) # 4e0 <vprintf>
}
 6d4:	60e2                	ld	ra,24(sp)
 6d6:	6442                	ld	s0,16(sp)
 6d8:	6161                	addi	sp,sp,80
 6da:	8082                	ret

00000000000006dc <printf>:

void
printf(const char *fmt, ...)
{
 6dc:	711d                	addi	sp,sp,-96
 6de:	ec06                	sd	ra,24(sp)
 6e0:	e822                	sd	s0,16(sp)
 6e2:	1000                	addi	s0,sp,32
 6e4:	e40c                	sd	a1,8(s0)
 6e6:	e810                	sd	a2,16(s0)
 6e8:	ec14                	sd	a3,24(s0)
 6ea:	f018                	sd	a4,32(s0)
 6ec:	f41c                	sd	a5,40(s0)
 6ee:	03043823          	sd	a6,48(s0)
 6f2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6f6:	00840613          	addi	a2,s0,8
 6fa:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6fe:	85aa                	mv	a1,a0
 700:	4505                	li	a0,1
 702:	00000097          	auipc	ra,0x0
 706:	dde080e7          	jalr	-546(ra) # 4e0 <vprintf>
}
 70a:	60e2                	ld	ra,24(sp)
 70c:	6442                	ld	s0,16(sp)
 70e:	6125                	addi	sp,sp,96
 710:	8082                	ret

0000000000000712 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 712:	1141                	addi	sp,sp,-16
 714:	e406                	sd	ra,8(sp)
 716:	e022                	sd	s0,0(sp)
 718:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 71a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 71e:	00000797          	auipc	a5,0x0
 722:	2627b783          	ld	a5,610(a5) # 980 <freep>
 726:	a039                	j	734 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 728:	6398                	ld	a4,0(a5)
 72a:	00e7e463          	bltu	a5,a4,732 <free+0x20>
 72e:	00e6ea63          	bltu	a3,a4,742 <free+0x30>
{
 732:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 734:	fed7fae3          	bgeu	a5,a3,728 <free+0x16>
 738:	6398                	ld	a4,0(a5)
 73a:	00e6e463          	bltu	a3,a4,742 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 73e:	fee7eae3          	bltu	a5,a4,732 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 742:	ff852583          	lw	a1,-8(a0)
 746:	6390                	ld	a2,0(a5)
 748:	02059813          	slli	a6,a1,0x20
 74c:	01c85713          	srli	a4,a6,0x1c
 750:	9736                	add	a4,a4,a3
 752:	02e60563          	beq	a2,a4,77c <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 756:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 75a:	4790                	lw	a2,8(a5)
 75c:	02061593          	slli	a1,a2,0x20
 760:	01c5d713          	srli	a4,a1,0x1c
 764:	973e                	add	a4,a4,a5
 766:	02e68263          	beq	a3,a4,78a <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 76a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 76c:	00000717          	auipc	a4,0x0
 770:	20f73a23          	sd	a5,532(a4) # 980 <freep>
}
 774:	60a2                	ld	ra,8(sp)
 776:	6402                	ld	s0,0(sp)
 778:	0141                	addi	sp,sp,16
 77a:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 77c:	4618                	lw	a4,8(a2)
 77e:	9f2d                	addw	a4,a4,a1
 780:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 784:	6398                	ld	a4,0(a5)
 786:	6310                	ld	a2,0(a4)
 788:	b7f9                	j	756 <free+0x44>
    p->s.size += bp->s.size;
 78a:	ff852703          	lw	a4,-8(a0)
 78e:	9f31                	addw	a4,a4,a2
 790:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 792:	ff053683          	ld	a3,-16(a0)
 796:	bfd1                	j	76a <free+0x58>

0000000000000798 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 798:	7139                	addi	sp,sp,-64
 79a:	fc06                	sd	ra,56(sp)
 79c:	f822                	sd	s0,48(sp)
 79e:	f04a                	sd	s2,32(sp)
 7a0:	ec4e                	sd	s3,24(sp)
 7a2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7a4:	02051993          	slli	s3,a0,0x20
 7a8:	0209d993          	srli	s3,s3,0x20
 7ac:	09bd                	addi	s3,s3,15
 7ae:	0049d993          	srli	s3,s3,0x4
 7b2:	2985                	addiw	s3,s3,1
 7b4:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 7b6:	00000517          	auipc	a0,0x0
 7ba:	1ca53503          	ld	a0,458(a0) # 980 <freep>
 7be:	c905                	beqz	a0,7ee <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7c0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7c2:	4798                	lw	a4,8(a5)
 7c4:	09377a63          	bgeu	a4,s3,858 <malloc+0xc0>
 7c8:	f426                	sd	s1,40(sp)
 7ca:	e852                	sd	s4,16(sp)
 7cc:	e456                	sd	s5,8(sp)
 7ce:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7d0:	8a4e                	mv	s4,s3
 7d2:	6705                	lui	a4,0x1
 7d4:	00e9f363          	bgeu	s3,a4,7da <malloc+0x42>
 7d8:	6a05                	lui	s4,0x1
 7da:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7de:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7e2:	00000497          	auipc	s1,0x0
 7e6:	19e48493          	addi	s1,s1,414 # 980 <freep>
  if(p == (char*)-1)
 7ea:	5afd                	li	s5,-1
 7ec:	a089                	j	82e <malloc+0x96>
 7ee:	f426                	sd	s1,40(sp)
 7f0:	e852                	sd	s4,16(sp)
 7f2:	e456                	sd	s5,8(sp)
 7f4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7f6:	00000797          	auipc	a5,0x0
 7fa:	19278793          	addi	a5,a5,402 # 988 <base>
 7fe:	00000717          	auipc	a4,0x0
 802:	18f73123          	sd	a5,386(a4) # 980 <freep>
 806:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 808:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 80c:	b7d1                	j	7d0 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 80e:	6398                	ld	a4,0(a5)
 810:	e118                	sd	a4,0(a0)
 812:	a8b9                	j	870 <malloc+0xd8>
  hp->s.size = nu;
 814:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 818:	0541                	addi	a0,a0,16
 81a:	00000097          	auipc	ra,0x0
 81e:	ef8080e7          	jalr	-264(ra) # 712 <free>
  return freep;
 822:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 824:	c135                	beqz	a0,888 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 826:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 828:	4798                	lw	a4,8(a5)
 82a:	03277363          	bgeu	a4,s2,850 <malloc+0xb8>
    if(p == freep)
 82e:	6098                	ld	a4,0(s1)
 830:	853e                	mv	a0,a5
 832:	fef71ae3          	bne	a4,a5,826 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 836:	8552                	mv	a0,s4
 838:	00000097          	auipc	ra,0x0
 83c:	bbe080e7          	jalr	-1090(ra) # 3f6 <sbrk>
  if(p == (char*)-1)
 840:	fd551ae3          	bne	a0,s5,814 <malloc+0x7c>
        return 0;
 844:	4501                	li	a0,0
 846:	74a2                	ld	s1,40(sp)
 848:	6a42                	ld	s4,16(sp)
 84a:	6aa2                	ld	s5,8(sp)
 84c:	6b02                	ld	s6,0(sp)
 84e:	a03d                	j	87c <malloc+0xe4>
 850:	74a2                	ld	s1,40(sp)
 852:	6a42                	ld	s4,16(sp)
 854:	6aa2                	ld	s5,8(sp)
 856:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 858:	fae90be3          	beq	s2,a4,80e <malloc+0x76>
        p->s.size -= nunits;
 85c:	4137073b          	subw	a4,a4,s3
 860:	c798                	sw	a4,8(a5)
        p += p->s.size;
 862:	02071693          	slli	a3,a4,0x20
 866:	01c6d713          	srli	a4,a3,0x1c
 86a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 86c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 870:	00000717          	auipc	a4,0x0
 874:	10a73823          	sd	a0,272(a4) # 980 <freep>
      return (void*)(p + 1);
 878:	01078513          	addi	a0,a5,16
  }
}
 87c:	70e2                	ld	ra,56(sp)
 87e:	7442                	ld	s0,48(sp)
 880:	7902                	ld	s2,32(sp)
 882:	69e2                	ld	s3,24(sp)
 884:	6121                	addi	sp,sp,64
 886:	8082                	ret
 888:	74a2                	ld	s1,40(sp)
 88a:	6a42                	ld	s4,16(sp)
 88c:	6aa2                	ld	s5,8(sp)
 88e:	6b02                	ld	s6,0(sp)
 890:	b7f5                	j	87c <malloc+0xe4>
