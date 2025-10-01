
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	18010113          	addi	sp,sp,384 # 80009180 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	078000ef          	jal	8000008e <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e406                	sd	ra,8(sp)
    80000020:	e022                	sd	s0,0(sp)
    80000022:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000024:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80000028:	2781                	sext.w	a5,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000002a:	0037961b          	slliw	a2,a5,0x3
    8000002e:	02004737          	lui	a4,0x2004
    80000032:	963a                	add	a2,a2,a4
    80000034:	0200c737          	lui	a4,0x200c
    80000038:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000003c:	000f46b7          	lui	a3,0xf4
    80000040:	24068693          	addi	a3,a3,576 # f4240 <_entry-0x7ff0bdc0>
    80000044:	9736                	add	a4,a4,a3
    80000046:	e218                	sd	a4,0(a2)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000048:	00279713          	slli	a4,a5,0x2
    8000004c:	973e                	add	a4,a4,a5
    8000004e:	070e                	slli	a4,a4,0x3
    80000050:	00009797          	auipc	a5,0x9
    80000054:	ff078793          	addi	a5,a5,-16 # 80009040 <timer_scratch>
    80000058:	97ba                	add	a5,a5,a4
  scratch[3] = CLINT_MTIMECMP(id);
    8000005a:	ef90                	sd	a2,24(a5)
  scratch[4] = interval;
    8000005c:	f394                	sd	a3,32(a5)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000005e:	34079073          	csrw	mscratch,a5
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000062:	00006797          	auipc	a5,0x6
    80000066:	eae78793          	addi	a5,a5,-338 # 80005f10 <timervec>
    8000006a:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000006e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000072:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000076:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000007a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000007e:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80000082:	30479073          	csrw	mie,a5
}
    80000086:	60a2                	ld	ra,8(sp)
    80000088:	6402                	ld	s0,0(sp)
    8000008a:	0141                	addi	sp,sp,16
    8000008c:	8082                	ret

000000008000008e <start>:
{
    8000008e:	1141                	addi	sp,sp,-16
    80000090:	e406                	sd	ra,8(sp)
    80000092:	e022                	sd	s0,0(sp)
    80000094:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000096:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000009a:	7779                	lui	a4,0xffffe
    8000009c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd87ff>
    800000a0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a2:	6705                	lui	a4,0x1
    800000a4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000aa:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ae:	00001797          	auipc	a5,0x1
    800000b2:	e5878793          	addi	a5,a5,-424 # 80000f06 <main>
    800000b6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000ba:	4781                	li	a5,0
    800000bc:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000c0:	67c1                	lui	a5,0x10
    800000c2:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800000c4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000cc:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000d0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000d4:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000d8:	57fd                	li	a5,-1
    800000da:	83a9                	srli	a5,a5,0xa
    800000dc:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000e0:	47bd                	li	a5,15
    800000e2:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000e6:	00000097          	auipc	ra,0x0
    800000ea:	f36080e7          	jalr	-202(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000ee:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000f2:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000f4:	823e                	mv	tp,a5
  asm volatile("mret");
    800000f6:	30200073          	mret
}
    800000fa:	60a2                	ld	ra,8(sp)
    800000fc:	6402                	ld	s0,0(sp)
    800000fe:	0141                	addi	sp,sp,16
    80000100:	8082                	ret

0000000080000102 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80000102:	711d                	addi	sp,sp,-96
    80000104:	ec86                	sd	ra,88(sp)
    80000106:	e8a2                	sd	s0,80(sp)
    80000108:	e0ca                	sd	s2,64(sp)
    8000010a:	1080                	addi	s0,sp,96
  int i;

  for(i = 0; i < n; i++){
    8000010c:	04c05b63          	blez	a2,80000162 <consolewrite+0x60>
    80000110:	e4a6                	sd	s1,72(sp)
    80000112:	fc4e                	sd	s3,56(sp)
    80000114:	f852                	sd	s4,48(sp)
    80000116:	f456                	sd	s5,40(sp)
    80000118:	f05a                	sd	s6,32(sp)
    8000011a:	ec5e                	sd	s7,24(sp)
    8000011c:	8a2a                	mv	s4,a0
    8000011e:	84ae                	mv	s1,a1
    80000120:	89b2                	mv	s3,a2
    80000122:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80000124:	faf40b93          	addi	s7,s0,-81
    80000128:	4b05                	li	s6,1
    8000012a:	5afd                	li	s5,-1
    8000012c:	86da                	mv	a3,s6
    8000012e:	8626                	mv	a2,s1
    80000130:	85d2                	mv	a1,s4
    80000132:	855e                	mv	a0,s7
    80000134:	00002097          	auipc	ra,0x2
    80000138:	418080e7          	jalr	1048(ra) # 8000254c <either_copyin>
    8000013c:	03550563          	beq	a0,s5,80000166 <consolewrite+0x64>
      break;
    uartputc(c);
    80000140:	faf44503          	lbu	a0,-81(s0)
    80000144:	00000097          	auipc	ra,0x0
    80000148:	7d0080e7          	jalr	2000(ra) # 80000914 <uartputc>
  for(i = 0; i < n; i++){
    8000014c:	2905                	addiw	s2,s2,1
    8000014e:	0485                	addi	s1,s1,1
    80000150:	fd299ee3          	bne	s3,s2,8000012c <consolewrite+0x2a>
    80000154:	64a6                	ld	s1,72(sp)
    80000156:	79e2                	ld	s3,56(sp)
    80000158:	7a42                	ld	s4,48(sp)
    8000015a:	7aa2                	ld	s5,40(sp)
    8000015c:	7b02                	ld	s6,32(sp)
    8000015e:	6be2                	ld	s7,24(sp)
    80000160:	a809                	j	80000172 <consolewrite+0x70>
    80000162:	4901                	li	s2,0
    80000164:	a039                	j	80000172 <consolewrite+0x70>
    80000166:	64a6                	ld	s1,72(sp)
    80000168:	79e2                	ld	s3,56(sp)
    8000016a:	7a42                	ld	s4,48(sp)
    8000016c:	7aa2                	ld	s5,40(sp)
    8000016e:	7b02                	ld	s6,32(sp)
    80000170:	6be2                	ld	s7,24(sp)
  }

  return i;
}
    80000172:	854a                	mv	a0,s2
    80000174:	60e6                	ld	ra,88(sp)
    80000176:	6446                	ld	s0,80(sp)
    80000178:	6906                	ld	s2,64(sp)
    8000017a:	6125                	addi	sp,sp,96
    8000017c:	8082                	ret

000000008000017e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000017e:	711d                	addi	sp,sp,-96
    80000180:	ec86                	sd	ra,88(sp)
    80000182:	e8a2                	sd	s0,80(sp)
    80000184:	e4a6                	sd	s1,72(sp)
    80000186:	e0ca                	sd	s2,64(sp)
    80000188:	fc4e                	sd	s3,56(sp)
    8000018a:	f852                	sd	s4,48(sp)
    8000018c:	f05a                	sd	s6,32(sp)
    8000018e:	ec5e                	sd	s7,24(sp)
    80000190:	1080                	addi	s0,sp,96
    80000192:	8b2a                	mv	s6,a0
    80000194:	8a2e                	mv	s4,a1
    80000196:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000198:	8bb2                	mv	s7,a2
  acquire(&cons.lock);
    8000019a:	00011517          	auipc	a0,0x11
    8000019e:	fe650513          	addi	a0,a0,-26 # 80011180 <cons>
    800001a2:	00001097          	auipc	ra,0x1
    800001a6:	ab2080e7          	jalr	-1358(ra) # 80000c54 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800001aa:	00011497          	auipc	s1,0x11
    800001ae:	fd648493          	addi	s1,s1,-42 # 80011180 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001b2:	00011917          	auipc	s2,0x11
    800001b6:	06690913          	addi	s2,s2,102 # 80011218 <cons+0x98>
  while(n > 0){
    800001ba:	0d305263          	blez	s3,8000027e <consoleread+0x100>
    while(cons.r == cons.w){
    800001be:	0984a783          	lw	a5,152(s1)
    800001c2:	09c4a703          	lw	a4,156(s1)
    800001c6:	0af71763          	bne	a4,a5,80000274 <consoleread+0xf6>
      if(myproc()->killed){
    800001ca:	00002097          	auipc	ra,0x2
    800001ce:	8bc080e7          	jalr	-1860(ra) # 80001a86 <myproc>
    800001d2:	551c                	lw	a5,40(a0)
    800001d4:	e7ad                	bnez	a5,8000023e <consoleread+0xc0>
      sleep(&cons.r, &cons.lock);
    800001d6:	85a6                	mv	a1,s1
    800001d8:	854a                	mv	a0,s2
    800001da:	00002097          	auipc	ra,0x2
    800001de:	f7a080e7          	jalr	-134(ra) # 80002154 <sleep>
    while(cons.r == cons.w){
    800001e2:	0984a783          	lw	a5,152(s1)
    800001e6:	09c4a703          	lw	a4,156(s1)
    800001ea:	fef700e3          	beq	a4,a5,800001ca <consoleread+0x4c>
    800001ee:	f456                	sd	s5,40(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF];
    800001f0:	00011717          	auipc	a4,0x11
    800001f4:	f9070713          	addi	a4,a4,-112 # 80011180 <cons>
    800001f8:	0017869b          	addiw	a3,a5,1
    800001fc:	08d72c23          	sw	a3,152(a4)
    80000200:	07f7f693          	andi	a3,a5,127
    80000204:	9736                	add	a4,a4,a3
    80000206:	01874703          	lbu	a4,24(a4)
    8000020a:	00070a9b          	sext.w	s5,a4

    if(c == C('D')){  // end-of-file
    8000020e:	4691                	li	a3,4
    80000210:	04da8a63          	beq	s5,a3,80000264 <consoleread+0xe6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80000214:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000218:	4685                	li	a3,1
    8000021a:	faf40613          	addi	a2,s0,-81
    8000021e:	85d2                	mv	a1,s4
    80000220:	855a                	mv	a0,s6
    80000222:	00002097          	auipc	ra,0x2
    80000226:	2d4080e7          	jalr	724(ra) # 800024f6 <either_copyout>
    8000022a:	57fd                	li	a5,-1
    8000022c:	04f50863          	beq	a0,a5,8000027c <consoleread+0xfe>
      break;

    dst++;
    80000230:	0a05                	addi	s4,s4,1
    --n;
    80000232:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80000234:	47a9                	li	a5,10
    80000236:	04fa8f63          	beq	s5,a5,80000294 <consoleread+0x116>
    8000023a:	7aa2                	ld	s5,40(sp)
    8000023c:	bfbd                	j	800001ba <consoleread+0x3c>
        release(&cons.lock);
    8000023e:	00011517          	auipc	a0,0x11
    80000242:	f4250513          	addi	a0,a0,-190 # 80011180 <cons>
    80000246:	00001097          	auipc	ra,0x1
    8000024a:	abe080e7          	jalr	-1346(ra) # 80000d04 <release>
        return -1;
    8000024e:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80000250:	60e6                	ld	ra,88(sp)
    80000252:	6446                	ld	s0,80(sp)
    80000254:	64a6                	ld	s1,72(sp)
    80000256:	6906                	ld	s2,64(sp)
    80000258:	79e2                	ld	s3,56(sp)
    8000025a:	7a42                	ld	s4,48(sp)
    8000025c:	7b02                	ld	s6,32(sp)
    8000025e:	6be2                	ld	s7,24(sp)
    80000260:	6125                	addi	sp,sp,96
    80000262:	8082                	ret
      if(n < target){
    80000264:	0179fa63          	bgeu	s3,s7,80000278 <consoleread+0xfa>
        cons.r--;
    80000268:	00011717          	auipc	a4,0x11
    8000026c:	faf72823          	sw	a5,-80(a4) # 80011218 <cons+0x98>
    80000270:	7aa2                	ld	s5,40(sp)
    80000272:	a031                	j	8000027e <consoleread+0x100>
    80000274:	f456                	sd	s5,40(sp)
    80000276:	bfad                	j	800001f0 <consoleread+0x72>
    80000278:	7aa2                	ld	s5,40(sp)
    8000027a:	a011                	j	8000027e <consoleread+0x100>
    8000027c:	7aa2                	ld	s5,40(sp)
  release(&cons.lock);
    8000027e:	00011517          	auipc	a0,0x11
    80000282:	f0250513          	addi	a0,a0,-254 # 80011180 <cons>
    80000286:	00001097          	auipc	ra,0x1
    8000028a:	a7e080e7          	jalr	-1410(ra) # 80000d04 <release>
  return target - n;
    8000028e:	413b853b          	subw	a0,s7,s3
    80000292:	bf7d                	j	80000250 <consoleread+0xd2>
    80000294:	7aa2                	ld	s5,40(sp)
    80000296:	b7e5                	j	8000027e <consoleread+0x100>

0000000080000298 <consputc>:
{
    80000298:	1141                	addi	sp,sp,-16
    8000029a:	e406                	sd	ra,8(sp)
    8000029c:	e022                	sd	s0,0(sp)
    8000029e:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800002a0:	10000793          	li	a5,256
    800002a4:	00f50a63          	beq	a0,a5,800002b8 <consputc+0x20>
    uartputc_sync(c);
    800002a8:	00000097          	auipc	ra,0x0
    800002ac:	58e080e7          	jalr	1422(ra) # 80000836 <uartputc_sync>
}
    800002b0:	60a2                	ld	ra,8(sp)
    800002b2:	6402                	ld	s0,0(sp)
    800002b4:	0141                	addi	sp,sp,16
    800002b6:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800002b8:	4521                	li	a0,8
    800002ba:	00000097          	auipc	ra,0x0
    800002be:	57c080e7          	jalr	1404(ra) # 80000836 <uartputc_sync>
    800002c2:	02000513          	li	a0,32
    800002c6:	00000097          	auipc	ra,0x0
    800002ca:	570080e7          	jalr	1392(ra) # 80000836 <uartputc_sync>
    800002ce:	4521                	li	a0,8
    800002d0:	00000097          	auipc	ra,0x0
    800002d4:	566080e7          	jalr	1382(ra) # 80000836 <uartputc_sync>
    800002d8:	bfe1                	j	800002b0 <consputc+0x18>

00000000800002da <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002da:	1101                	addi	sp,sp,-32
    800002dc:	ec06                	sd	ra,24(sp)
    800002de:	e822                	sd	s0,16(sp)
    800002e0:	e426                	sd	s1,8(sp)
    800002e2:	1000                	addi	s0,sp,32
    800002e4:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002e6:	00011517          	auipc	a0,0x11
    800002ea:	e9a50513          	addi	a0,a0,-358 # 80011180 <cons>
    800002ee:	00001097          	auipc	ra,0x1
    800002f2:	966080e7          	jalr	-1690(ra) # 80000c54 <acquire>

  switch(c){
    800002f6:	47d5                	li	a5,21
    800002f8:	0af48263          	beq	s1,a5,8000039c <consoleintr+0xc2>
    800002fc:	0297c963          	blt	a5,s1,8000032e <consoleintr+0x54>
    80000300:	47a1                	li	a5,8
    80000302:	0ef48963          	beq	s1,a5,800003f4 <consoleintr+0x11a>
    80000306:	47c1                	li	a5,16
    80000308:	10f49c63          	bne	s1,a5,80000420 <consoleintr+0x146>
  case C('P'):  // Print process list.
    procdump();
    8000030c:	00002097          	auipc	ra,0x2
    80000310:	296080e7          	jalr	662(ra) # 800025a2 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80000314:	00011517          	auipc	a0,0x11
    80000318:	e6c50513          	addi	a0,a0,-404 # 80011180 <cons>
    8000031c:	00001097          	auipc	ra,0x1
    80000320:	9e8080e7          	jalr	-1560(ra) # 80000d04 <release>
}
    80000324:	60e2                	ld	ra,24(sp)
    80000326:	6442                	ld	s0,16(sp)
    80000328:	64a2                	ld	s1,8(sp)
    8000032a:	6105                	addi	sp,sp,32
    8000032c:	8082                	ret
  switch(c){
    8000032e:	07f00793          	li	a5,127
    80000332:	0cf48163          	beq	s1,a5,800003f4 <consoleintr+0x11a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80000336:	00011717          	auipc	a4,0x11
    8000033a:	e4a70713          	addi	a4,a4,-438 # 80011180 <cons>
    8000033e:	0a072783          	lw	a5,160(a4)
    80000342:	09872703          	lw	a4,152(a4)
    80000346:	9f99                	subw	a5,a5,a4
    80000348:	07f00713          	li	a4,127
    8000034c:	fcf764e3          	bltu	a4,a5,80000314 <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    80000350:	47b5                	li	a5,13
    80000352:	0cf48a63          	beq	s1,a5,80000426 <consoleintr+0x14c>
      consputc(c);
    80000356:	8526                	mv	a0,s1
    80000358:	00000097          	auipc	ra,0x0
    8000035c:	f40080e7          	jalr	-192(ra) # 80000298 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000360:	00011717          	auipc	a4,0x11
    80000364:	e2070713          	addi	a4,a4,-480 # 80011180 <cons>
    80000368:	0a072683          	lw	a3,160(a4)
    8000036c:	0016879b          	addiw	a5,a3,1
    80000370:	863e                	mv	a2,a5
    80000372:	0af72023          	sw	a5,160(a4)
    80000376:	07f6f693          	andi	a3,a3,127
    8000037a:	9736                	add	a4,a4,a3
    8000037c:	00970c23          	sb	s1,24(a4)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80000380:	ff648713          	addi	a4,s1,-10
    80000384:	c779                	beqz	a4,80000452 <consoleintr+0x178>
    80000386:	14f1                	addi	s1,s1,-4
    80000388:	c4e9                	beqz	s1,80000452 <consoleintr+0x178>
    8000038a:	00011797          	auipc	a5,0x11
    8000038e:	e8e7a783          	lw	a5,-370(a5) # 80011218 <cons+0x98>
    80000392:	0807879b          	addiw	a5,a5,128
    80000396:	f6f61fe3          	bne	a2,a5,80000314 <consoleintr+0x3a>
    8000039a:	a865                	j	80000452 <consoleintr+0x178>
    8000039c:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    8000039e:	00011717          	auipc	a4,0x11
    800003a2:	de270713          	addi	a4,a4,-542 # 80011180 <cons>
    800003a6:	0a072783          	lw	a5,160(a4)
    800003aa:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800003ae:	00011497          	auipc	s1,0x11
    800003b2:	dd248493          	addi	s1,s1,-558 # 80011180 <cons>
    while(cons.e != cons.w &&
    800003b6:	4929                	li	s2,10
    800003b8:	02f70a63          	beq	a4,a5,800003ec <consoleintr+0x112>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800003bc:	37fd                	addiw	a5,a5,-1
    800003be:	07f7f713          	andi	a4,a5,127
    800003c2:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003c4:	01874703          	lbu	a4,24(a4)
    800003c8:	03270463          	beq	a4,s2,800003f0 <consoleintr+0x116>
      cons.e--;
    800003cc:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003d0:	10000513          	li	a0,256
    800003d4:	00000097          	auipc	ra,0x0
    800003d8:	ec4080e7          	jalr	-316(ra) # 80000298 <consputc>
    while(cons.e != cons.w &&
    800003dc:	0a04a783          	lw	a5,160(s1)
    800003e0:	09c4a703          	lw	a4,156(s1)
    800003e4:	fcf71ce3          	bne	a4,a5,800003bc <consoleintr+0xe2>
    800003e8:	6902                	ld	s2,0(sp)
    800003ea:	b72d                	j	80000314 <consoleintr+0x3a>
    800003ec:	6902                	ld	s2,0(sp)
    800003ee:	b71d                	j	80000314 <consoleintr+0x3a>
    800003f0:	6902                	ld	s2,0(sp)
    800003f2:	b70d                	j	80000314 <consoleintr+0x3a>
    if(cons.e != cons.w){
    800003f4:	00011717          	auipc	a4,0x11
    800003f8:	d8c70713          	addi	a4,a4,-628 # 80011180 <cons>
    800003fc:	0a072783          	lw	a5,160(a4)
    80000400:	09c72703          	lw	a4,156(a4)
    80000404:	f0f708e3          	beq	a4,a5,80000314 <consoleintr+0x3a>
      cons.e--;
    80000408:	37fd                	addiw	a5,a5,-1
    8000040a:	00011717          	auipc	a4,0x11
    8000040e:	e0f72b23          	sw	a5,-490(a4) # 80011220 <cons+0xa0>
      consputc(BACKSPACE);
    80000412:	10000513          	li	a0,256
    80000416:	00000097          	auipc	ra,0x0
    8000041a:	e82080e7          	jalr	-382(ra) # 80000298 <consputc>
    8000041e:	bddd                	j	80000314 <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80000420:	ee048ae3          	beqz	s1,80000314 <consoleintr+0x3a>
    80000424:	bf09                	j	80000336 <consoleintr+0x5c>
      consputc(c);
    80000426:	4529                	li	a0,10
    80000428:	00000097          	auipc	ra,0x0
    8000042c:	e70080e7          	jalr	-400(ra) # 80000298 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000430:	00011717          	auipc	a4,0x11
    80000434:	d5070713          	addi	a4,a4,-688 # 80011180 <cons>
    80000438:	0a072683          	lw	a3,160(a4)
    8000043c:	0016861b          	addiw	a2,a3,1
    80000440:	87b2                	mv	a5,a2
    80000442:	0ac72023          	sw	a2,160(a4)
    80000446:	07f6f693          	andi	a3,a3,127
    8000044a:	9736                	add	a4,a4,a3
    8000044c:	46a9                	li	a3,10
    8000044e:	00d70c23          	sb	a3,24(a4)
        cons.w = cons.e;
    80000452:	00011717          	auipc	a4,0x11
    80000456:	dcf72523          	sw	a5,-566(a4) # 8001121c <cons+0x9c>
        wakeup(&cons.r);
    8000045a:	00011517          	auipc	a0,0x11
    8000045e:	dbe50513          	addi	a0,a0,-578 # 80011218 <cons+0x98>
    80000462:	00002097          	auipc	ra,0x2
    80000466:	e78080e7          	jalr	-392(ra) # 800022da <wakeup>
    8000046a:	b56d                	j	80000314 <consoleintr+0x3a>

000000008000046c <consoleinit>:

void
consoleinit(void)
{
    8000046c:	1141                	addi	sp,sp,-16
    8000046e:	e406                	sd	ra,8(sp)
    80000470:	e022                	sd	s0,0(sp)
    80000472:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000474:	00008597          	auipc	a1,0x8
    80000478:	b8c58593          	addi	a1,a1,-1140 # 80008000 <etext>
    8000047c:	00011517          	auipc	a0,0x11
    80000480:	d0450513          	addi	a0,a0,-764 # 80011180 <cons>
    80000484:	00000097          	auipc	ra,0x0
    80000488:	736080e7          	jalr	1846(ra) # 80000bba <initlock>

  uartinit();
    8000048c:	00000097          	auipc	ra,0x0
    80000490:	350080e7          	jalr	848(ra) # 800007dc <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000494:	00021797          	auipc	a5,0x21
    80000498:	08478793          	addi	a5,a5,132 # 80021518 <devsw>
    8000049c:	00000717          	auipc	a4,0x0
    800004a0:	ce270713          	addi	a4,a4,-798 # 8000017e <consoleread>
    800004a4:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800004a6:	00000717          	auipc	a4,0x0
    800004aa:	c5c70713          	addi	a4,a4,-932 # 80000102 <consolewrite>
    800004ae:	ef98                	sd	a4,24(a5)
}
    800004b0:	60a2                	ld	ra,8(sp)
    800004b2:	6402                	ld	s0,0(sp)
    800004b4:	0141                	addi	sp,sp,16
    800004b6:	8082                	ret

00000000800004b8 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800004b8:	7179                	addi	sp,sp,-48
    800004ba:	f406                	sd	ra,40(sp)
    800004bc:	f022                	sd	s0,32(sp)
    800004be:	e84a                	sd	s2,16(sp)
    800004c0:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004c2:	c219                	beqz	a2,800004c8 <printint+0x10>
    800004c4:	08054563          	bltz	a0,8000054e <printint+0x96>
    x = -xx;
  else
    x = xx;
    800004c8:	4301                	li	t1,0

  i = 0;
    800004ca:	fd040913          	addi	s2,s0,-48
    x = xx;
    800004ce:	86ca                	mv	a3,s2
  i = 0;
    800004d0:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004d2:	00008817          	auipc	a6,0x8
    800004d6:	22680813          	addi	a6,a6,550 # 800086f8 <digits>
    800004da:	88ba                	mv	a7,a4
    800004dc:	0017061b          	addiw	a2,a4,1
    800004e0:	8732                	mv	a4,a2
    800004e2:	02b577bb          	remuw	a5,a0,a1
    800004e6:	1782                	slli	a5,a5,0x20
    800004e8:	9381                	srli	a5,a5,0x20
    800004ea:	97c2                	add	a5,a5,a6
    800004ec:	0007c783          	lbu	a5,0(a5)
    800004f0:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004f4:	87aa                	mv	a5,a0
    800004f6:	02b5553b          	divuw	a0,a0,a1
    800004fa:	0685                	addi	a3,a3,1
    800004fc:	fcb7ffe3          	bgeu	a5,a1,800004da <printint+0x22>

  if(sign)
    80000500:	00030c63          	beqz	t1,80000518 <printint+0x60>
    buf[i++] = '-';
    80000504:	fe060793          	addi	a5,a2,-32
    80000508:	00878633          	add	a2,a5,s0
    8000050c:	02d00793          	li	a5,45
    80000510:	fef60823          	sb	a5,-16(a2)
    80000514:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
    80000518:	02e05663          	blez	a4,80000544 <printint+0x8c>
    8000051c:	ec26                	sd	s1,24(sp)
    8000051e:	377d                	addiw	a4,a4,-1
    80000520:	00e904b3          	add	s1,s2,a4
    80000524:	197d                	addi	s2,s2,-1
    80000526:	993a                	add	s2,s2,a4
    80000528:	1702                	slli	a4,a4,0x20
    8000052a:	9301                	srli	a4,a4,0x20
    8000052c:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80000530:	0004c503          	lbu	a0,0(s1)
    80000534:	00000097          	auipc	ra,0x0
    80000538:	d64080e7          	jalr	-668(ra) # 80000298 <consputc>
  while(--i >= 0)
    8000053c:	14fd                	addi	s1,s1,-1
    8000053e:	ff2499e3          	bne	s1,s2,80000530 <printint+0x78>
    80000542:	64e2                	ld	s1,24(sp)
}
    80000544:	70a2                	ld	ra,40(sp)
    80000546:	7402                	ld	s0,32(sp)
    80000548:	6942                	ld	s2,16(sp)
    8000054a:	6145                	addi	sp,sp,48
    8000054c:	8082                	ret
    x = -xx;
    8000054e:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80000552:	4305                	li	t1,1
    x = -xx;
    80000554:	bf9d                	j	800004ca <printint+0x12>

0000000080000556 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80000556:	1101                	addi	sp,sp,-32
    80000558:	ec06                	sd	ra,24(sp)
    8000055a:	e822                	sd	s0,16(sp)
    8000055c:	e426                	sd	s1,8(sp)
    8000055e:	1000                	addi	s0,sp,32
    80000560:	84aa                	mv	s1,a0
  pr.locking = 0;
    80000562:	00011797          	auipc	a5,0x11
    80000566:	cc07af23          	sw	zero,-802(a5) # 80011240 <pr+0x18>
  printf("panic: ");
    8000056a:	00008517          	auipc	a0,0x8
    8000056e:	a9e50513          	addi	a0,a0,-1378 # 80008008 <etext+0x8>
    80000572:	00000097          	auipc	ra,0x0
    80000576:	02e080e7          	jalr	46(ra) # 800005a0 <printf>
  printf(s);
    8000057a:	8526                	mv	a0,s1
    8000057c:	00000097          	auipc	ra,0x0
    80000580:	024080e7          	jalr	36(ra) # 800005a0 <printf>
  printf("\n");
    80000584:	00008517          	auipc	a0,0x8
    80000588:	a8c50513          	addi	a0,a0,-1396 # 80008010 <etext+0x10>
    8000058c:	00000097          	auipc	ra,0x0
    80000590:	014080e7          	jalr	20(ra) # 800005a0 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80000594:	4785                	li	a5,1
    80000596:	00009717          	auipc	a4,0x9
    8000059a:	a6f72523          	sw	a5,-1430(a4) # 80009000 <panicked>
  for(;;)
    8000059e:	a001                	j	8000059e <panic+0x48>

00000000800005a0 <printf>:
{
    800005a0:	7131                	addi	sp,sp,-192
    800005a2:	fc86                	sd	ra,120(sp)
    800005a4:	f8a2                	sd	s0,112(sp)
    800005a6:	e8d2                	sd	s4,80(sp)
    800005a8:	ec6e                	sd	s11,24(sp)
    800005aa:	0100                	addi	s0,sp,128
    800005ac:	8a2a                	mv	s4,a0
    800005ae:	e40c                	sd	a1,8(s0)
    800005b0:	e810                	sd	a2,16(s0)
    800005b2:	ec14                	sd	a3,24(s0)
    800005b4:	f018                	sd	a4,32(s0)
    800005b6:	f41c                	sd	a5,40(s0)
    800005b8:	03043823          	sd	a6,48(s0)
    800005bc:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005c0:	00011d97          	auipc	s11,0x11
    800005c4:	c80dad83          	lw	s11,-896(s11) # 80011240 <pr+0x18>
  if(locking)
    800005c8:	040d9463          	bnez	s11,80000610 <printf+0x70>
  if (fmt == 0)
    800005cc:	040a0b63          	beqz	s4,80000622 <printf+0x82>
  va_start(ap, fmt);
    800005d0:	00840793          	addi	a5,s0,8
    800005d4:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005d8:	000a4503          	lbu	a0,0(s4)
    800005dc:	18050c63          	beqz	a0,80000774 <printf+0x1d4>
    800005e0:	f4a6                	sd	s1,104(sp)
    800005e2:	f0ca                	sd	s2,96(sp)
    800005e4:	ecce                	sd	s3,88(sp)
    800005e6:	e4d6                	sd	s5,72(sp)
    800005e8:	e0da                	sd	s6,64(sp)
    800005ea:	fc5e                	sd	s7,56(sp)
    800005ec:	f862                	sd	s8,48(sp)
    800005ee:	f466                	sd	s9,40(sp)
    800005f0:	f06a                	sd	s10,32(sp)
    800005f2:	4981                	li	s3,0
    if(c != '%'){
    800005f4:	02500b13          	li	s6,37
    switch(c){
    800005f8:	07000b93          	li	s7,112
  consputc('x');
    800005fc:	07800c93          	li	s9,120
    80000600:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80000602:	00008a97          	auipc	s5,0x8
    80000606:	0f6a8a93          	addi	s5,s5,246 # 800086f8 <digits>
    switch(c){
    8000060a:	07300c13          	li	s8,115
    8000060e:	a0b9                	j	8000065c <printf+0xbc>
    acquire(&pr.lock);
    80000610:	00011517          	auipc	a0,0x11
    80000614:	c1850513          	addi	a0,a0,-1000 # 80011228 <pr>
    80000618:	00000097          	auipc	ra,0x0
    8000061c:	63c080e7          	jalr	1596(ra) # 80000c54 <acquire>
    80000620:	b775                	j	800005cc <printf+0x2c>
    80000622:	f4a6                	sd	s1,104(sp)
    80000624:	f0ca                	sd	s2,96(sp)
    80000626:	ecce                	sd	s3,88(sp)
    80000628:	e4d6                	sd	s5,72(sp)
    8000062a:	e0da                	sd	s6,64(sp)
    8000062c:	fc5e                	sd	s7,56(sp)
    8000062e:	f862                	sd	s8,48(sp)
    80000630:	f466                	sd	s9,40(sp)
    80000632:	f06a                	sd	s10,32(sp)
    panic("null fmt");
    80000634:	00008517          	auipc	a0,0x8
    80000638:	9ec50513          	addi	a0,a0,-1556 # 80008020 <etext+0x20>
    8000063c:	00000097          	auipc	ra,0x0
    80000640:	f1a080e7          	jalr	-230(ra) # 80000556 <panic>
      consputc(c);
    80000644:	00000097          	auipc	ra,0x0
    80000648:	c54080e7          	jalr	-940(ra) # 80000298 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8000064c:	0019879b          	addiw	a5,s3,1
    80000650:	89be                	mv	s3,a5
    80000652:	97d2                	add	a5,a5,s4
    80000654:	0007c503          	lbu	a0,0(a5)
    80000658:	10050563          	beqz	a0,80000762 <printf+0x1c2>
    if(c != '%'){
    8000065c:	ff6514e3          	bne	a0,s6,80000644 <printf+0xa4>
    c = fmt[++i] & 0xff;
    80000660:	0019879b          	addiw	a5,s3,1
    80000664:	89be                	mv	s3,a5
    80000666:	97d2                	add	a5,a5,s4
    80000668:	0007c783          	lbu	a5,0(a5)
    8000066c:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80000670:	10078a63          	beqz	a5,80000784 <printf+0x1e4>
    switch(c){
    80000674:	05778a63          	beq	a5,s7,800006c8 <printf+0x128>
    80000678:	02fbf463          	bgeu	s7,a5,800006a0 <printf+0x100>
    8000067c:	09878763          	beq	a5,s8,8000070a <printf+0x16a>
    80000680:	0d979663          	bne	a5,s9,8000074c <printf+0x1ac>
      printint(va_arg(ap, int), 16, 1);
    80000684:	f8843783          	ld	a5,-120(s0)
    80000688:	00878713          	addi	a4,a5,8
    8000068c:	f8e43423          	sd	a4,-120(s0)
    80000690:	4605                	li	a2,1
    80000692:	85ea                	mv	a1,s10
    80000694:	4388                	lw	a0,0(a5)
    80000696:	00000097          	auipc	ra,0x0
    8000069a:	e22080e7          	jalr	-478(ra) # 800004b8 <printint>
      break;
    8000069e:	b77d                	j	8000064c <printf+0xac>
    switch(c){
    800006a0:	0b678063          	beq	a5,s6,80000740 <printf+0x1a0>
    800006a4:	06400713          	li	a4,100
    800006a8:	0ae79263          	bne	a5,a4,8000074c <printf+0x1ac>
      printint(va_arg(ap, int), 10, 1);
    800006ac:	f8843783          	ld	a5,-120(s0)
    800006b0:	00878713          	addi	a4,a5,8
    800006b4:	f8e43423          	sd	a4,-120(s0)
    800006b8:	4605                	li	a2,1
    800006ba:	45a9                	li	a1,10
    800006bc:	4388                	lw	a0,0(a5)
    800006be:	00000097          	auipc	ra,0x0
    800006c2:	dfa080e7          	jalr	-518(ra) # 800004b8 <printint>
      break;
    800006c6:	b759                	j	8000064c <printf+0xac>
      printptr(va_arg(ap, uint64));
    800006c8:	f8843783          	ld	a5,-120(s0)
    800006cc:	00878713          	addi	a4,a5,8
    800006d0:	f8e43423          	sd	a4,-120(s0)
    800006d4:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800006d8:	03000513          	li	a0,48
    800006dc:	00000097          	auipc	ra,0x0
    800006e0:	bbc080e7          	jalr	-1092(ra) # 80000298 <consputc>
  consputc('x');
    800006e4:	8566                	mv	a0,s9
    800006e6:	00000097          	auipc	ra,0x0
    800006ea:	bb2080e7          	jalr	-1102(ra) # 80000298 <consputc>
    800006ee:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006f0:	03c95793          	srli	a5,s2,0x3c
    800006f4:	97d6                	add	a5,a5,s5
    800006f6:	0007c503          	lbu	a0,0(a5)
    800006fa:	00000097          	auipc	ra,0x0
    800006fe:	b9e080e7          	jalr	-1122(ra) # 80000298 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80000702:	0912                	slli	s2,s2,0x4
    80000704:	34fd                	addiw	s1,s1,-1
    80000706:	f4ed                	bnez	s1,800006f0 <printf+0x150>
    80000708:	b791                	j	8000064c <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    8000070a:	f8843783          	ld	a5,-120(s0)
    8000070e:	00878713          	addi	a4,a5,8
    80000712:	f8e43423          	sd	a4,-120(s0)
    80000716:	6384                	ld	s1,0(a5)
    80000718:	cc89                	beqz	s1,80000732 <printf+0x192>
      for(; *s; s++)
    8000071a:	0004c503          	lbu	a0,0(s1)
    8000071e:	d51d                	beqz	a0,8000064c <printf+0xac>
        consputc(*s);
    80000720:	00000097          	auipc	ra,0x0
    80000724:	b78080e7          	jalr	-1160(ra) # 80000298 <consputc>
      for(; *s; s++)
    80000728:	0485                	addi	s1,s1,1
    8000072a:	0004c503          	lbu	a0,0(s1)
    8000072e:	f96d                	bnez	a0,80000720 <printf+0x180>
    80000730:	bf31                	j	8000064c <printf+0xac>
        s = "(null)";
    80000732:	00008497          	auipc	s1,0x8
    80000736:	8e648493          	addi	s1,s1,-1818 # 80008018 <etext+0x18>
      for(; *s; s++)
    8000073a:	02800513          	li	a0,40
    8000073e:	b7cd                	j	80000720 <printf+0x180>
      consputc('%');
    80000740:	855a                	mv	a0,s6
    80000742:	00000097          	auipc	ra,0x0
    80000746:	b56080e7          	jalr	-1194(ra) # 80000298 <consputc>
      break;
    8000074a:	b709                	j	8000064c <printf+0xac>
      consputc('%');
    8000074c:	855a                	mv	a0,s6
    8000074e:	00000097          	auipc	ra,0x0
    80000752:	b4a080e7          	jalr	-1206(ra) # 80000298 <consputc>
      consputc(c);
    80000756:	8526                	mv	a0,s1
    80000758:	00000097          	auipc	ra,0x0
    8000075c:	b40080e7          	jalr	-1216(ra) # 80000298 <consputc>
      break;
    80000760:	b5f5                	j	8000064c <printf+0xac>
    80000762:	74a6                	ld	s1,104(sp)
    80000764:	7906                	ld	s2,96(sp)
    80000766:	69e6                	ld	s3,88(sp)
    80000768:	6aa6                	ld	s5,72(sp)
    8000076a:	6b06                	ld	s6,64(sp)
    8000076c:	7be2                	ld	s7,56(sp)
    8000076e:	7c42                	ld	s8,48(sp)
    80000770:	7ca2                	ld	s9,40(sp)
    80000772:	7d02                	ld	s10,32(sp)
  if(locking)
    80000774:	020d9263          	bnez	s11,80000798 <printf+0x1f8>
}
    80000778:	70e6                	ld	ra,120(sp)
    8000077a:	7446                	ld	s0,112(sp)
    8000077c:	6a46                	ld	s4,80(sp)
    8000077e:	6de2                	ld	s11,24(sp)
    80000780:	6129                	addi	sp,sp,192
    80000782:	8082                	ret
    80000784:	74a6                	ld	s1,104(sp)
    80000786:	7906                	ld	s2,96(sp)
    80000788:	69e6                	ld	s3,88(sp)
    8000078a:	6aa6                	ld	s5,72(sp)
    8000078c:	6b06                	ld	s6,64(sp)
    8000078e:	7be2                	ld	s7,56(sp)
    80000790:	7c42                	ld	s8,48(sp)
    80000792:	7ca2                	ld	s9,40(sp)
    80000794:	7d02                	ld	s10,32(sp)
    80000796:	bff9                	j	80000774 <printf+0x1d4>
    release(&pr.lock);
    80000798:	00011517          	auipc	a0,0x11
    8000079c:	a9050513          	addi	a0,a0,-1392 # 80011228 <pr>
    800007a0:	00000097          	auipc	ra,0x0
    800007a4:	564080e7          	jalr	1380(ra) # 80000d04 <release>
}
    800007a8:	bfc1                	j	80000778 <printf+0x1d8>

00000000800007aa <printfinit>:
    ;
}

void
printfinit(void)
{
    800007aa:	1141                	addi	sp,sp,-16
    800007ac:	e406                	sd	ra,8(sp)
    800007ae:	e022                	sd	s0,0(sp)
    800007b0:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    800007b2:	00008597          	auipc	a1,0x8
    800007b6:	87e58593          	addi	a1,a1,-1922 # 80008030 <etext+0x30>
    800007ba:	00011517          	auipc	a0,0x11
    800007be:	a6e50513          	addi	a0,a0,-1426 # 80011228 <pr>
    800007c2:	00000097          	auipc	ra,0x0
    800007c6:	3f8080e7          	jalr	1016(ra) # 80000bba <initlock>
  pr.locking = 1;
    800007ca:	4785                	li	a5,1
    800007cc:	00011717          	auipc	a4,0x11
    800007d0:	a6f72a23          	sw	a5,-1420(a4) # 80011240 <pr+0x18>
}
    800007d4:	60a2                	ld	ra,8(sp)
    800007d6:	6402                	ld	s0,0(sp)
    800007d8:	0141                	addi	sp,sp,16
    800007da:	8082                	ret

00000000800007dc <uartinit>:

void uartstart();

void
uartinit(void)
{
    800007dc:	1141                	addi	sp,sp,-16
    800007de:	e406                	sd	ra,8(sp)
    800007e0:	e022                	sd	s0,0(sp)
    800007e2:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007e4:	100007b7          	lui	a5,0x10000
    800007e8:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007ec:	10000737          	lui	a4,0x10000
    800007f0:	f8000693          	li	a3,-128
    800007f4:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007f8:	468d                	li	a3,3
    800007fa:	10000637          	lui	a2,0x10000
    800007fe:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80000802:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80000806:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000080a:	8732                	mv	a4,a2
    8000080c:	461d                	li	a2,7
    8000080e:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80000812:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80000816:	00008597          	auipc	a1,0x8
    8000081a:	82258593          	addi	a1,a1,-2014 # 80008038 <etext+0x38>
    8000081e:	00011517          	auipc	a0,0x11
    80000822:	a2a50513          	addi	a0,a0,-1494 # 80011248 <uart_tx_lock>
    80000826:	00000097          	auipc	ra,0x0
    8000082a:	394080e7          	jalr	916(ra) # 80000bba <initlock>
}
    8000082e:	60a2                	ld	ra,8(sp)
    80000830:	6402                	ld	s0,0(sp)
    80000832:	0141                	addi	sp,sp,16
    80000834:	8082                	ret

0000000080000836 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000836:	1101                	addi	sp,sp,-32
    80000838:	ec06                	sd	ra,24(sp)
    8000083a:	e822                	sd	s0,16(sp)
    8000083c:	e426                	sd	s1,8(sp)
    8000083e:	1000                	addi	s0,sp,32
    80000840:	84aa                	mv	s1,a0
  push_off();
    80000842:	00000097          	auipc	ra,0x0
    80000846:	3c2080e7          	jalr	962(ra) # 80000c04 <push_off>

  if(panicked){
    8000084a:	00008797          	auipc	a5,0x8
    8000084e:	7b67a783          	lw	a5,1974(a5) # 80009000 <panicked>
    80000852:	eb85                	bnez	a5,80000882 <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000854:	10000737          	lui	a4,0x10000
    80000858:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    8000085a:	00074783          	lbu	a5,0(a4)
    8000085e:	0207f793          	andi	a5,a5,32
    80000862:	dfe5                	beqz	a5,8000085a <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80000864:	0ff4f513          	zext.b	a0,s1
    80000868:	100007b7          	lui	a5,0x10000
    8000086c:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000870:	00000097          	auipc	ra,0x0
    80000874:	438080e7          	jalr	1080(ra) # 80000ca8 <pop_off>
}
    80000878:	60e2                	ld	ra,24(sp)
    8000087a:	6442                	ld	s0,16(sp)
    8000087c:	64a2                	ld	s1,8(sp)
    8000087e:	6105                	addi	sp,sp,32
    80000880:	8082                	ret
    for(;;)
    80000882:	a001                	j	80000882 <uartputc_sync+0x4c>

0000000080000884 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80000884:	00008797          	auipc	a5,0x8
    80000888:	7847b783          	ld	a5,1924(a5) # 80009008 <uart_tx_r>
    8000088c:	00008717          	auipc	a4,0x8
    80000890:	78473703          	ld	a4,1924(a4) # 80009010 <uart_tx_w>
    80000894:	06f70f63          	beq	a4,a5,80000912 <uartstart+0x8e>
{
    80000898:	7139                	addi	sp,sp,-64
    8000089a:	fc06                	sd	ra,56(sp)
    8000089c:	f822                	sd	s0,48(sp)
    8000089e:	f426                	sd	s1,40(sp)
    800008a0:	f04a                	sd	s2,32(sp)
    800008a2:	ec4e                	sd	s3,24(sp)
    800008a4:	e852                	sd	s4,16(sp)
    800008a6:	e456                	sd	s5,8(sp)
    800008a8:	e05a                	sd	s6,0(sp)
    800008aa:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008ac:	10000937          	lui	s2,0x10000
    800008b0:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008b2:	00011a97          	auipc	s5,0x11
    800008b6:	996a8a93          	addi	s5,s5,-1642 # 80011248 <uart_tx_lock>
    uart_tx_r += 1;
    800008ba:	00008497          	auipc	s1,0x8
    800008be:	74e48493          	addi	s1,s1,1870 # 80009008 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008c2:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008c6:	00008997          	auipc	s3,0x8
    800008ca:	74a98993          	addi	s3,s3,1866 # 80009010 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008ce:	00094703          	lbu	a4,0(s2)
    800008d2:	02077713          	andi	a4,a4,32
    800008d6:	c705                	beqz	a4,800008fe <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008d8:	01f7f713          	andi	a4,a5,31
    800008dc:	9756                	add	a4,a4,s5
    800008de:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    800008e2:	0785                	addi	a5,a5,1
    800008e4:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    800008e6:	8526                	mv	a0,s1
    800008e8:	00002097          	auipc	ra,0x2
    800008ec:	9f2080e7          	jalr	-1550(ra) # 800022da <wakeup>
    WriteReg(THR, c);
    800008f0:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    800008f4:	609c                	ld	a5,0(s1)
    800008f6:	0009b703          	ld	a4,0(s3)
    800008fa:	fcf71ae3          	bne	a4,a5,800008ce <uartstart+0x4a>
  }
}
    800008fe:	70e2                	ld	ra,56(sp)
    80000900:	7442                	ld	s0,48(sp)
    80000902:	74a2                	ld	s1,40(sp)
    80000904:	7902                	ld	s2,32(sp)
    80000906:	69e2                	ld	s3,24(sp)
    80000908:	6a42                	ld	s4,16(sp)
    8000090a:	6aa2                	ld	s5,8(sp)
    8000090c:	6b02                	ld	s6,0(sp)
    8000090e:	6121                	addi	sp,sp,64
    80000910:	8082                	ret
    80000912:	8082                	ret

0000000080000914 <uartputc>:
{
    80000914:	7179                	addi	sp,sp,-48
    80000916:	f406                	sd	ra,40(sp)
    80000918:	f022                	sd	s0,32(sp)
    8000091a:	e052                	sd	s4,0(sp)
    8000091c:	1800                	addi	s0,sp,48
    8000091e:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80000920:	00011517          	auipc	a0,0x11
    80000924:	92850513          	addi	a0,a0,-1752 # 80011248 <uart_tx_lock>
    80000928:	00000097          	auipc	ra,0x0
    8000092c:	32c080e7          	jalr	812(ra) # 80000c54 <acquire>
  if(panicked){
    80000930:	00008797          	auipc	a5,0x8
    80000934:	6d07a783          	lw	a5,1744(a5) # 80009000 <panicked>
    80000938:	c391                	beqz	a5,8000093c <uartputc+0x28>
    for(;;)
    8000093a:	a001                	j	8000093a <uartputc+0x26>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000093c:	00008717          	auipc	a4,0x8
    80000940:	6d473703          	ld	a4,1748(a4) # 80009010 <uart_tx_w>
    80000944:	00008797          	auipc	a5,0x8
    80000948:	6c47b783          	ld	a5,1732(a5) # 80009008 <uart_tx_r>
    8000094c:	02078793          	addi	a5,a5,32
    80000950:	04e79163          	bne	a5,a4,80000992 <uartputc+0x7e>
    80000954:	ec26                	sd	s1,24(sp)
    80000956:	e84a                	sd	s2,16(sp)
    80000958:	e44e                	sd	s3,8(sp)
      sleep(&uart_tx_r, &uart_tx_lock);
    8000095a:	00011997          	auipc	s3,0x11
    8000095e:	8ee98993          	addi	s3,s3,-1810 # 80011248 <uart_tx_lock>
    80000962:	00008497          	auipc	s1,0x8
    80000966:	6a648493          	addi	s1,s1,1702 # 80009008 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000096a:	00008917          	auipc	s2,0x8
    8000096e:	6a690913          	addi	s2,s2,1702 # 80009010 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80000972:	85ce                	mv	a1,s3
    80000974:	8526                	mv	a0,s1
    80000976:	00001097          	auipc	ra,0x1
    8000097a:	7de080e7          	jalr	2014(ra) # 80002154 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000097e:	00093703          	ld	a4,0(s2)
    80000982:	609c                	ld	a5,0(s1)
    80000984:	02078793          	addi	a5,a5,32
    80000988:	fee785e3          	beq	a5,a4,80000972 <uartputc+0x5e>
    8000098c:	64e2                	ld	s1,24(sp)
    8000098e:	6942                	ld	s2,16(sp)
    80000990:	69a2                	ld	s3,8(sp)
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000992:	01f77693          	andi	a3,a4,31
    80000996:	00011797          	auipc	a5,0x11
    8000099a:	8b278793          	addi	a5,a5,-1870 # 80011248 <uart_tx_lock>
    8000099e:	97b6                	add	a5,a5,a3
    800009a0:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    800009a4:	0705                	addi	a4,a4,1
    800009a6:	00008797          	auipc	a5,0x8
    800009aa:	66e7b523          	sd	a4,1642(a5) # 80009010 <uart_tx_w>
      uartstart();
    800009ae:	00000097          	auipc	ra,0x0
    800009b2:	ed6080e7          	jalr	-298(ra) # 80000884 <uartstart>
      release(&uart_tx_lock);
    800009b6:	00011517          	auipc	a0,0x11
    800009ba:	89250513          	addi	a0,a0,-1902 # 80011248 <uart_tx_lock>
    800009be:	00000097          	auipc	ra,0x0
    800009c2:	346080e7          	jalr	838(ra) # 80000d04 <release>
}
    800009c6:	70a2                	ld	ra,40(sp)
    800009c8:	7402                	ld	s0,32(sp)
    800009ca:	6a02                	ld	s4,0(sp)
    800009cc:	6145                	addi	sp,sp,48
    800009ce:	8082                	ret

00000000800009d0 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800009d0:	1141                	addi	sp,sp,-16
    800009d2:	e406                	sd	ra,8(sp)
    800009d4:	e022                	sd	s0,0(sp)
    800009d6:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800009d8:	100007b7          	lui	a5,0x10000
    800009dc:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800009e0:	8b85                	andi	a5,a5,1
    800009e2:	cb89                	beqz	a5,800009f4 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800009e4:	100007b7          	lui	a5,0x10000
    800009e8:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800009ec:	60a2                	ld	ra,8(sp)
    800009ee:	6402                	ld	s0,0(sp)
    800009f0:	0141                	addi	sp,sp,16
    800009f2:	8082                	ret
    return -1;
    800009f4:	557d                	li	a0,-1
    800009f6:	bfdd                	j	800009ec <uartgetc+0x1c>

00000000800009f8 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800009f8:	1101                	addi	sp,sp,-32
    800009fa:	ec06                	sd	ra,24(sp)
    800009fc:	e822                	sd	s0,16(sp)
    800009fe:	e426                	sd	s1,8(sp)
    80000a00:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000a02:	54fd                	li	s1,-1
    int c = uartgetc();
    80000a04:	00000097          	auipc	ra,0x0
    80000a08:	fcc080e7          	jalr	-52(ra) # 800009d0 <uartgetc>
    if(c == -1)
    80000a0c:	00950763          	beq	a0,s1,80000a1a <uartintr+0x22>
      break;
    consoleintr(c);
    80000a10:	00000097          	auipc	ra,0x0
    80000a14:	8ca080e7          	jalr	-1846(ra) # 800002da <consoleintr>
  while(1){
    80000a18:	b7f5                	j	80000a04 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000a1a:	00011517          	auipc	a0,0x11
    80000a1e:	82e50513          	addi	a0,a0,-2002 # 80011248 <uart_tx_lock>
    80000a22:	00000097          	auipc	ra,0x0
    80000a26:	232080e7          	jalr	562(ra) # 80000c54 <acquire>
  uartstart();
    80000a2a:	00000097          	auipc	ra,0x0
    80000a2e:	e5a080e7          	jalr	-422(ra) # 80000884 <uartstart>
  release(&uart_tx_lock);
    80000a32:	00011517          	auipc	a0,0x11
    80000a36:	81650513          	addi	a0,a0,-2026 # 80011248 <uart_tx_lock>
    80000a3a:	00000097          	auipc	ra,0x0
    80000a3e:	2ca080e7          	jalr	714(ra) # 80000d04 <release>
}
    80000a42:	60e2                	ld	ra,24(sp)
    80000a44:	6442                	ld	s0,16(sp)
    80000a46:	64a2                	ld	s1,8(sp)
    80000a48:	6105                	addi	sp,sp,32
    80000a4a:	8082                	ret

0000000080000a4c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a4c:	1101                	addi	sp,sp,-32
    80000a4e:	ec06                	sd	ra,24(sp)
    80000a50:	e822                	sd	s0,16(sp)
    80000a52:	e426                	sd	s1,8(sp)
    80000a54:	e04a                	sd	s2,0(sp)
    80000a56:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a58:	00025797          	auipc	a5,0x25
    80000a5c:	5a878793          	addi	a5,a5,1448 # 80026000 <end>
    80000a60:	00f53733          	sltu	a4,a0,a5
    80000a64:	47c5                	li	a5,17
    80000a66:	07ee                	slli	a5,a5,0x1b
    80000a68:	17fd                	addi	a5,a5,-1
    80000a6a:	00a7b7b3          	sltu	a5,a5,a0
    80000a6e:	8fd9                	or	a5,a5,a4
    80000a70:	e7a1                	bnez	a5,80000ab8 <kfree+0x6c>
    80000a72:	84aa                	mv	s1,a0
    80000a74:	03451793          	slli	a5,a0,0x34
    80000a78:	e3a1                	bnez	a5,80000ab8 <kfree+0x6c>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a7a:	6605                	lui	a2,0x1
    80000a7c:	4585                	li	a1,1
    80000a7e:	00000097          	auipc	ra,0x0
    80000a82:	2ce080e7          	jalr	718(ra) # 80000d4c <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a86:	00010917          	auipc	s2,0x10
    80000a8a:	7fa90913          	addi	s2,s2,2042 # 80011280 <kmem>
    80000a8e:	854a                	mv	a0,s2
    80000a90:	00000097          	auipc	ra,0x0
    80000a94:	1c4080e7          	jalr	452(ra) # 80000c54 <acquire>
  r->next = kmem.freelist;
    80000a98:	01893783          	ld	a5,24(s2)
    80000a9c:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a9e:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000aa2:	854a                	mv	a0,s2
    80000aa4:	00000097          	auipc	ra,0x0
    80000aa8:	260080e7          	jalr	608(ra) # 80000d04 <release>
}
    80000aac:	60e2                	ld	ra,24(sp)
    80000aae:	6442                	ld	s0,16(sp)
    80000ab0:	64a2                	ld	s1,8(sp)
    80000ab2:	6902                	ld	s2,0(sp)
    80000ab4:	6105                	addi	sp,sp,32
    80000ab6:	8082                	ret
    panic("kfree");
    80000ab8:	00007517          	auipc	a0,0x7
    80000abc:	58850513          	addi	a0,a0,1416 # 80008040 <etext+0x40>
    80000ac0:	00000097          	auipc	ra,0x0
    80000ac4:	a96080e7          	jalr	-1386(ra) # 80000556 <panic>

0000000080000ac8 <freerange>:
{
    80000ac8:	7179                	addi	sp,sp,-48
    80000aca:	f406                	sd	ra,40(sp)
    80000acc:	f022                	sd	s0,32(sp)
    80000ace:	ec26                	sd	s1,24(sp)
    80000ad0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000ad2:	6785                	lui	a5,0x1
    80000ad4:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000ad8:	00e504b3          	add	s1,a0,a4
    80000adc:	777d                	lui	a4,0xfffff
    80000ade:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ae0:	94be                	add	s1,s1,a5
    80000ae2:	0295e463          	bltu	a1,s1,80000b0a <freerange+0x42>
    80000ae6:	e84a                	sd	s2,16(sp)
    80000ae8:	e44e                	sd	s3,8(sp)
    80000aea:	e052                	sd	s4,0(sp)
    80000aec:	892e                	mv	s2,a1
    kfree(p);
    80000aee:	8a3a                	mv	s4,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000af0:	89be                	mv	s3,a5
    kfree(p);
    80000af2:	01448533          	add	a0,s1,s4
    80000af6:	00000097          	auipc	ra,0x0
    80000afa:	f56080e7          	jalr	-170(ra) # 80000a4c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000afe:	94ce                	add	s1,s1,s3
    80000b00:	fe9979e3          	bgeu	s2,s1,80000af2 <freerange+0x2a>
    80000b04:	6942                	ld	s2,16(sp)
    80000b06:	69a2                	ld	s3,8(sp)
    80000b08:	6a02                	ld	s4,0(sp)
}
    80000b0a:	70a2                	ld	ra,40(sp)
    80000b0c:	7402                	ld	s0,32(sp)
    80000b0e:	64e2                	ld	s1,24(sp)
    80000b10:	6145                	addi	sp,sp,48
    80000b12:	8082                	ret

0000000080000b14 <kinit>:
{
    80000b14:	1141                	addi	sp,sp,-16
    80000b16:	e406                	sd	ra,8(sp)
    80000b18:	e022                	sd	s0,0(sp)
    80000b1a:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000b1c:	00007597          	auipc	a1,0x7
    80000b20:	52c58593          	addi	a1,a1,1324 # 80008048 <etext+0x48>
    80000b24:	00010517          	auipc	a0,0x10
    80000b28:	75c50513          	addi	a0,a0,1884 # 80011280 <kmem>
    80000b2c:	00000097          	auipc	ra,0x0
    80000b30:	08e080e7          	jalr	142(ra) # 80000bba <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b34:	45c5                	li	a1,17
    80000b36:	05ee                	slli	a1,a1,0x1b
    80000b38:	00025517          	auipc	a0,0x25
    80000b3c:	4c850513          	addi	a0,a0,1224 # 80026000 <end>
    80000b40:	00000097          	auipc	ra,0x0
    80000b44:	f88080e7          	jalr	-120(ra) # 80000ac8 <freerange>
}
    80000b48:	60a2                	ld	ra,8(sp)
    80000b4a:	6402                	ld	s0,0(sp)
    80000b4c:	0141                	addi	sp,sp,16
    80000b4e:	8082                	ret

0000000080000b50 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b50:	1101                	addi	sp,sp,-32
    80000b52:	ec06                	sd	ra,24(sp)
    80000b54:	e822                	sd	s0,16(sp)
    80000b56:	e426                	sd	s1,8(sp)
    80000b58:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b5a:	00010517          	auipc	a0,0x10
    80000b5e:	72650513          	addi	a0,a0,1830 # 80011280 <kmem>
    80000b62:	00000097          	auipc	ra,0x0
    80000b66:	0f2080e7          	jalr	242(ra) # 80000c54 <acquire>
  r = kmem.freelist;
    80000b6a:	00010497          	auipc	s1,0x10
    80000b6e:	72e4b483          	ld	s1,1838(s1) # 80011298 <kmem+0x18>
  if(r)
    80000b72:	c89d                	beqz	s1,80000ba8 <kalloc+0x58>
    kmem.freelist = r->next;
    80000b74:	609c                	ld	a5,0(s1)
    80000b76:	00010717          	auipc	a4,0x10
    80000b7a:	72f73123          	sd	a5,1826(a4) # 80011298 <kmem+0x18>
  release(&kmem.lock);
    80000b7e:	00010517          	auipc	a0,0x10
    80000b82:	70250513          	addi	a0,a0,1794 # 80011280 <kmem>
    80000b86:	00000097          	auipc	ra,0x0
    80000b8a:	17e080e7          	jalr	382(ra) # 80000d04 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b8e:	6605                	lui	a2,0x1
    80000b90:	4595                	li	a1,5
    80000b92:	8526                	mv	a0,s1
    80000b94:	00000097          	auipc	ra,0x0
    80000b98:	1b8080e7          	jalr	440(ra) # 80000d4c <memset>
  return (void*)r;
}
    80000b9c:	8526                	mv	a0,s1
    80000b9e:	60e2                	ld	ra,24(sp)
    80000ba0:	6442                	ld	s0,16(sp)
    80000ba2:	64a2                	ld	s1,8(sp)
    80000ba4:	6105                	addi	sp,sp,32
    80000ba6:	8082                	ret
  release(&kmem.lock);
    80000ba8:	00010517          	auipc	a0,0x10
    80000bac:	6d850513          	addi	a0,a0,1752 # 80011280 <kmem>
    80000bb0:	00000097          	auipc	ra,0x0
    80000bb4:	154080e7          	jalr	340(ra) # 80000d04 <release>
  if(r)
    80000bb8:	b7d5                	j	80000b9c <kalloc+0x4c>

0000000080000bba <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000bba:	1141                	addi	sp,sp,-16
    80000bbc:	e406                	sd	ra,8(sp)
    80000bbe:	e022                	sd	s0,0(sp)
    80000bc0:	0800                	addi	s0,sp,16
  lk->name = name;
    80000bc2:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000bc4:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000bc8:	00053823          	sd	zero,16(a0)
}
    80000bcc:	60a2                	ld	ra,8(sp)
    80000bce:	6402                	ld	s0,0(sp)
    80000bd0:	0141                	addi	sp,sp,16
    80000bd2:	8082                	ret

0000000080000bd4 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000bd4:	411c                	lw	a5,0(a0)
    80000bd6:	e399                	bnez	a5,80000bdc <holding+0x8>
    80000bd8:	4501                	li	a0,0
  return r;
}
    80000bda:	8082                	ret
{
    80000bdc:	1101                	addi	sp,sp,-32
    80000bde:	ec06                	sd	ra,24(sp)
    80000be0:	e822                	sd	s0,16(sp)
    80000be2:	e426                	sd	s1,8(sp)
    80000be4:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000be6:	691c                	ld	a5,16(a0)
    80000be8:	84be                	mv	s1,a5
    80000bea:	00001097          	auipc	ra,0x1
    80000bee:	e7c080e7          	jalr	-388(ra) # 80001a66 <mycpu>
    80000bf2:	40a48533          	sub	a0,s1,a0
    80000bf6:	00153513          	seqz	a0,a0
}
    80000bfa:	60e2                	ld	ra,24(sp)
    80000bfc:	6442                	ld	s0,16(sp)
    80000bfe:	64a2                	ld	s1,8(sp)
    80000c00:	6105                	addi	sp,sp,32
    80000c02:	8082                	ret

0000000080000c04 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000c04:	1101                	addi	sp,sp,-32
    80000c06:	ec06                	sd	ra,24(sp)
    80000c08:	e822                	sd	s0,16(sp)
    80000c0a:	e426                	sd	s1,8(sp)
    80000c0c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c0e:	100027f3          	csrr	a5,sstatus
    80000c12:	84be                	mv	s1,a5
    80000c14:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000c18:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c1a:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000c1e:	00001097          	auipc	ra,0x1
    80000c22:	e48080e7          	jalr	-440(ra) # 80001a66 <mycpu>
    80000c26:	5d3c                	lw	a5,120(a0)
    80000c28:	cf89                	beqz	a5,80000c42 <push_off+0x3e>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000c2a:	00001097          	auipc	ra,0x1
    80000c2e:	e3c080e7          	jalr	-452(ra) # 80001a66 <mycpu>
    80000c32:	5d3c                	lw	a5,120(a0)
    80000c34:	2785                	addiw	a5,a5,1
    80000c36:	dd3c                	sw	a5,120(a0)
}
    80000c38:	60e2                	ld	ra,24(sp)
    80000c3a:	6442                	ld	s0,16(sp)
    80000c3c:	64a2                	ld	s1,8(sp)
    80000c3e:	6105                	addi	sp,sp,32
    80000c40:	8082                	ret
    mycpu()->intena = old;
    80000c42:	00001097          	auipc	ra,0x1
    80000c46:	e24080e7          	jalr	-476(ra) # 80001a66 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000c4a:	0014d793          	srli	a5,s1,0x1
    80000c4e:	8b85                	andi	a5,a5,1
    80000c50:	dd7c                	sw	a5,124(a0)
    80000c52:	bfe1                	j	80000c2a <push_off+0x26>

0000000080000c54 <acquire>:
{
    80000c54:	1101                	addi	sp,sp,-32
    80000c56:	ec06                	sd	ra,24(sp)
    80000c58:	e822                	sd	s0,16(sp)
    80000c5a:	e426                	sd	s1,8(sp)
    80000c5c:	1000                	addi	s0,sp,32
    80000c5e:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c60:	00000097          	auipc	ra,0x0
    80000c64:	fa4080e7          	jalr	-92(ra) # 80000c04 <push_off>
  if(holding(lk))
    80000c68:	8526                	mv	a0,s1
    80000c6a:	00000097          	auipc	ra,0x0
    80000c6e:	f6a080e7          	jalr	-150(ra) # 80000bd4 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c72:	4705                	li	a4,1
  if(holding(lk))
    80000c74:	e115                	bnez	a0,80000c98 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c76:	87ba                	mv	a5,a4
    80000c78:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c7c:	2781                	sext.w	a5,a5
    80000c7e:	ffe5                	bnez	a5,80000c76 <acquire+0x22>
  __sync_synchronize();
    80000c80:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80000c84:	00001097          	auipc	ra,0x1
    80000c88:	de2080e7          	jalr	-542(ra) # 80001a66 <mycpu>
    80000c8c:	e888                	sd	a0,16(s1)
}
    80000c8e:	60e2                	ld	ra,24(sp)
    80000c90:	6442                	ld	s0,16(sp)
    80000c92:	64a2                	ld	s1,8(sp)
    80000c94:	6105                	addi	sp,sp,32
    80000c96:	8082                	ret
    panic("acquire");
    80000c98:	00007517          	auipc	a0,0x7
    80000c9c:	3b850513          	addi	a0,a0,952 # 80008050 <etext+0x50>
    80000ca0:	00000097          	auipc	ra,0x0
    80000ca4:	8b6080e7          	jalr	-1866(ra) # 80000556 <panic>

0000000080000ca8 <pop_off>:

void
pop_off(void)
{
    80000ca8:	1141                	addi	sp,sp,-16
    80000caa:	e406                	sd	ra,8(sp)
    80000cac:	e022                	sd	s0,0(sp)
    80000cae:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000cb0:	00001097          	auipc	ra,0x1
    80000cb4:	db6080e7          	jalr	-586(ra) # 80001a66 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000cb8:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000cbc:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000cbe:	e39d                	bnez	a5,80000ce4 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000cc0:	5d3c                	lw	a5,120(a0)
    80000cc2:	02f05963          	blez	a5,80000cf4 <pop_off+0x4c>
    panic("pop_off");
  c->noff -= 1;
    80000cc6:	37fd                	addiw	a5,a5,-1
    80000cc8:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000cca:	eb89                	bnez	a5,80000cdc <pop_off+0x34>
    80000ccc:	5d7c                	lw	a5,124(a0)
    80000cce:	c799                	beqz	a5,80000cdc <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000cd0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000cd4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000cd8:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000cdc:	60a2                	ld	ra,8(sp)
    80000cde:	6402                	ld	s0,0(sp)
    80000ce0:	0141                	addi	sp,sp,16
    80000ce2:	8082                	ret
    panic("pop_off - interruptible");
    80000ce4:	00007517          	auipc	a0,0x7
    80000ce8:	37450513          	addi	a0,a0,884 # 80008058 <etext+0x58>
    80000cec:	00000097          	auipc	ra,0x0
    80000cf0:	86a080e7          	jalr	-1942(ra) # 80000556 <panic>
    panic("pop_off");
    80000cf4:	00007517          	auipc	a0,0x7
    80000cf8:	37c50513          	addi	a0,a0,892 # 80008070 <etext+0x70>
    80000cfc:	00000097          	auipc	ra,0x0
    80000d00:	85a080e7          	jalr	-1958(ra) # 80000556 <panic>

0000000080000d04 <release>:
{
    80000d04:	1101                	addi	sp,sp,-32
    80000d06:	ec06                	sd	ra,24(sp)
    80000d08:	e822                	sd	s0,16(sp)
    80000d0a:	e426                	sd	s1,8(sp)
    80000d0c:	1000                	addi	s0,sp,32
    80000d0e:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000d10:	00000097          	auipc	ra,0x0
    80000d14:	ec4080e7          	jalr	-316(ra) # 80000bd4 <holding>
    80000d18:	c115                	beqz	a0,80000d3c <release+0x38>
  lk->cpu = 0;
    80000d1a:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000d1e:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80000d22:	0310000f          	fence	rw,w
    80000d26:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000d2a:	00000097          	auipc	ra,0x0
    80000d2e:	f7e080e7          	jalr	-130(ra) # 80000ca8 <pop_off>
}
    80000d32:	60e2                	ld	ra,24(sp)
    80000d34:	6442                	ld	s0,16(sp)
    80000d36:	64a2                	ld	s1,8(sp)
    80000d38:	6105                	addi	sp,sp,32
    80000d3a:	8082                	ret
    panic("release");
    80000d3c:	00007517          	auipc	a0,0x7
    80000d40:	33c50513          	addi	a0,a0,828 # 80008078 <etext+0x78>
    80000d44:	00000097          	auipc	ra,0x0
    80000d48:	812080e7          	jalr	-2030(ra) # 80000556 <panic>

0000000080000d4c <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000d4c:	1141                	addi	sp,sp,-16
    80000d4e:	e406                	sd	ra,8(sp)
    80000d50:	e022                	sd	s0,0(sp)
    80000d52:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000d54:	ca19                	beqz	a2,80000d6a <memset+0x1e>
    80000d56:	87aa                	mv	a5,a0
    80000d58:	1602                	slli	a2,a2,0x20
    80000d5a:	9201                	srli	a2,a2,0x20
    80000d5c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000d60:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000d64:	0785                	addi	a5,a5,1
    80000d66:	fee79de3          	bne	a5,a4,80000d60 <memset+0x14>
  }
  return dst;
}
    80000d6a:	60a2                	ld	ra,8(sp)
    80000d6c:	6402                	ld	s0,0(sp)
    80000d6e:	0141                	addi	sp,sp,16
    80000d70:	8082                	ret

0000000080000d72 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000d72:	1141                	addi	sp,sp,-16
    80000d74:	e406                	sd	ra,8(sp)
    80000d76:	e022                	sd	s0,0(sp)
    80000d78:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000d7a:	c61d                	beqz	a2,80000da8 <memcmp+0x36>
    80000d7c:	1602                	slli	a2,a2,0x20
    80000d7e:	9201                	srli	a2,a2,0x20
    80000d80:	00c506b3          	add	a3,a0,a2
    if(*s1 != *s2)
    80000d84:	00054783          	lbu	a5,0(a0)
    80000d88:	0005c703          	lbu	a4,0(a1)
    80000d8c:	00e79863          	bne	a5,a4,80000d9c <memcmp+0x2a>
      return *s1 - *s2;
    s1++, s2++;
    80000d90:	0505                	addi	a0,a0,1
    80000d92:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d94:	fed518e3          	bne	a0,a3,80000d84 <memcmp+0x12>
  }

  return 0;
    80000d98:	4501                	li	a0,0
    80000d9a:	a019                	j	80000da0 <memcmp+0x2e>
      return *s1 - *s2;
    80000d9c:	40e7853b          	subw	a0,a5,a4
}
    80000da0:	60a2                	ld	ra,8(sp)
    80000da2:	6402                	ld	s0,0(sp)
    80000da4:	0141                	addi	sp,sp,16
    80000da6:	8082                	ret
  return 0;
    80000da8:	4501                	li	a0,0
    80000daa:	bfdd                	j	80000da0 <memcmp+0x2e>

0000000080000dac <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000dac:	1141                	addi	sp,sp,-16
    80000dae:	e406                	sd	ra,8(sp)
    80000db0:	e022                	sd	s0,0(sp)
    80000db2:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000db4:	c205                	beqz	a2,80000dd4 <memmove+0x28>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000db6:	02a5e363          	bltu	a1,a0,80000ddc <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000dba:	1602                	slli	a2,a2,0x20
    80000dbc:	9201                	srli	a2,a2,0x20
    80000dbe:	00c587b3          	add	a5,a1,a2
{
    80000dc2:	872a                	mv	a4,a0
      *d++ = *s++;
    80000dc4:	0585                	addi	a1,a1,1
    80000dc6:	0705                	addi	a4,a4,1
    80000dc8:	fff5c683          	lbu	a3,-1(a1)
    80000dcc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000dd0:	feb79ae3          	bne	a5,a1,80000dc4 <memmove+0x18>

  return dst;
}
    80000dd4:	60a2                	ld	ra,8(sp)
    80000dd6:	6402                	ld	s0,0(sp)
    80000dd8:	0141                	addi	sp,sp,16
    80000dda:	8082                	ret
  if(s < d && s + n > d){
    80000ddc:	02061693          	slli	a3,a2,0x20
    80000de0:	9281                	srli	a3,a3,0x20
    80000de2:	00d58733          	add	a4,a1,a3
    80000de6:	fce57ae3          	bgeu	a0,a4,80000dba <memmove+0xe>
    d += n;
    80000dea:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000dec:	fff6079b          	addiw	a5,a2,-1 # fff <_entry-0x7ffff001>
    80000df0:	1782                	slli	a5,a5,0x20
    80000df2:	9381                	srli	a5,a5,0x20
    80000df4:	fff7c793          	not	a5,a5
    80000df8:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000dfa:	177d                	addi	a4,a4,-1
    80000dfc:	16fd                	addi	a3,a3,-1
    80000dfe:	00074603          	lbu	a2,0(a4)
    80000e02:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000e06:	fee79ae3          	bne	a5,a4,80000dfa <memmove+0x4e>
    80000e0a:	b7e9                	j	80000dd4 <memmove+0x28>

0000000080000e0c <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000e0c:	1141                	addi	sp,sp,-16
    80000e0e:	e406                	sd	ra,8(sp)
    80000e10:	e022                	sd	s0,0(sp)
    80000e12:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000e14:	00000097          	auipc	ra,0x0
    80000e18:	f98080e7          	jalr	-104(ra) # 80000dac <memmove>
}
    80000e1c:	60a2                	ld	ra,8(sp)
    80000e1e:	6402                	ld	s0,0(sp)
    80000e20:	0141                	addi	sp,sp,16
    80000e22:	8082                	ret

0000000080000e24 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000e24:	1141                	addi	sp,sp,-16
    80000e26:	e406                	sd	ra,8(sp)
    80000e28:	e022                	sd	s0,0(sp)
    80000e2a:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000e2c:	ce11                	beqz	a2,80000e48 <strncmp+0x24>
    80000e2e:	00054783          	lbu	a5,0(a0)
    80000e32:	cf89                	beqz	a5,80000e4c <strncmp+0x28>
    80000e34:	0005c703          	lbu	a4,0(a1)
    80000e38:	00f71a63          	bne	a4,a5,80000e4c <strncmp+0x28>
    n--, p++, q++;
    80000e3c:	367d                	addiw	a2,a2,-1
    80000e3e:	0505                	addi	a0,a0,1
    80000e40:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000e42:	f675                	bnez	a2,80000e2e <strncmp+0xa>
  if(n == 0)
    return 0;
    80000e44:	4501                	li	a0,0
    80000e46:	a801                	j	80000e56 <strncmp+0x32>
    80000e48:	4501                	li	a0,0
    80000e4a:	a031                	j	80000e56 <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    80000e4c:	00054503          	lbu	a0,0(a0)
    80000e50:	0005c783          	lbu	a5,0(a1)
    80000e54:	9d1d                	subw	a0,a0,a5
}
    80000e56:	60a2                	ld	ra,8(sp)
    80000e58:	6402                	ld	s0,0(sp)
    80000e5a:	0141                	addi	sp,sp,16
    80000e5c:	8082                	ret

0000000080000e5e <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000e5e:	1141                	addi	sp,sp,-16
    80000e60:	e406                	sd	ra,8(sp)
    80000e62:	e022                	sd	s0,0(sp)
    80000e64:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000e66:	87aa                	mv	a5,a0
    80000e68:	a011                	j	80000e6c <strncpy+0xe>
    80000e6a:	8636                	mv	a2,a3
    80000e6c:	02c05863          	blez	a2,80000e9c <strncpy+0x3e>
    80000e70:	fff6069b          	addiw	a3,a2,-1
    80000e74:	8836                	mv	a6,a3
    80000e76:	0785                	addi	a5,a5,1
    80000e78:	0005c703          	lbu	a4,0(a1)
    80000e7c:	fee78fa3          	sb	a4,-1(a5)
    80000e80:	0585                	addi	a1,a1,1
    80000e82:	f765                	bnez	a4,80000e6a <strncpy+0xc>
    ;
  while(n-- > 0)
    80000e84:	873e                	mv	a4,a5
    80000e86:	01005b63          	blez	a6,80000e9c <strncpy+0x3e>
    80000e8a:	9fb1                	addw	a5,a5,a2
    80000e8c:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    80000e8e:	0705                	addi	a4,a4,1
    80000e90:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000e94:	40e786bb          	subw	a3,a5,a4
    80000e98:	fed04be3          	bgtz	a3,80000e8e <strncpy+0x30>
  return os;
}
    80000e9c:	60a2                	ld	ra,8(sp)
    80000e9e:	6402                	ld	s0,0(sp)
    80000ea0:	0141                	addi	sp,sp,16
    80000ea2:	8082                	ret

0000000080000ea4 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000ea4:	1141                	addi	sp,sp,-16
    80000ea6:	e406                	sd	ra,8(sp)
    80000ea8:	e022                	sd	s0,0(sp)
    80000eaa:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000eac:	02c05363          	blez	a2,80000ed2 <safestrcpy+0x2e>
    80000eb0:	fff6069b          	addiw	a3,a2,-1
    80000eb4:	1682                	slli	a3,a3,0x20
    80000eb6:	9281                	srli	a3,a3,0x20
    80000eb8:	96ae                	add	a3,a3,a1
    80000eba:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000ebc:	00d58963          	beq	a1,a3,80000ece <safestrcpy+0x2a>
    80000ec0:	0585                	addi	a1,a1,1
    80000ec2:	0785                	addi	a5,a5,1
    80000ec4:	fff5c703          	lbu	a4,-1(a1)
    80000ec8:	fee78fa3          	sb	a4,-1(a5)
    80000ecc:	fb65                	bnez	a4,80000ebc <safestrcpy+0x18>
    ;
  *s = 0;
    80000ece:	00078023          	sb	zero,0(a5)
  return os;
}
    80000ed2:	60a2                	ld	ra,8(sp)
    80000ed4:	6402                	ld	s0,0(sp)
    80000ed6:	0141                	addi	sp,sp,16
    80000ed8:	8082                	ret

0000000080000eda <strlen>:

int
strlen(const char *s)
{
    80000eda:	1141                	addi	sp,sp,-16
    80000edc:	e406                	sd	ra,8(sp)
    80000ede:	e022                	sd	s0,0(sp)
    80000ee0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000ee2:	00054783          	lbu	a5,0(a0)
    80000ee6:	cf91                	beqz	a5,80000f02 <strlen+0x28>
    80000ee8:	00150793          	addi	a5,a0,1
    80000eec:	86be                	mv	a3,a5
    80000eee:	0785                	addi	a5,a5,1
    80000ef0:	fff7c703          	lbu	a4,-1(a5)
    80000ef4:	ff65                	bnez	a4,80000eec <strlen+0x12>
    80000ef6:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
    80000efa:	60a2                	ld	ra,8(sp)
    80000efc:	6402                	ld	s0,0(sp)
    80000efe:	0141                	addi	sp,sp,16
    80000f00:	8082                	ret
  for(n = 0; s[n]; n++)
    80000f02:	4501                	li	a0,0
    80000f04:	bfdd                	j	80000efa <strlen+0x20>

0000000080000f06 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000f06:	1141                	addi	sp,sp,-16
    80000f08:	e406                	sd	ra,8(sp)
    80000f0a:	e022                	sd	s0,0(sp)
    80000f0c:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000f0e:	00001097          	auipc	ra,0x1
    80000f12:	b44080e7          	jalr	-1212(ra) # 80001a52 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000f16:	00008717          	auipc	a4,0x8
    80000f1a:	10270713          	addi	a4,a4,258 # 80009018 <started>
  if(cpuid() == 0){
    80000f1e:	c139                	beqz	a0,80000f64 <main+0x5e>
    while(started == 0)
    80000f20:	431c                	lw	a5,0(a4)
    80000f22:	2781                	sext.w	a5,a5
    80000f24:	dff5                	beqz	a5,80000f20 <main+0x1a>
      ;
    __sync_synchronize();
    80000f26:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000f2a:	00001097          	auipc	ra,0x1
    80000f2e:	b28080e7          	jalr	-1240(ra) # 80001a52 <cpuid>
    80000f32:	85aa                	mv	a1,a0
    80000f34:	00007517          	auipc	a0,0x7
    80000f38:	16450513          	addi	a0,a0,356 # 80008098 <etext+0x98>
    80000f3c:	fffff097          	auipc	ra,0xfffff
    80000f40:	664080e7          	jalr	1636(ra) # 800005a0 <printf>
    kvminithart();    // turn on paging
    80000f44:	00000097          	auipc	ra,0x0
    80000f48:	0d8080e7          	jalr	216(ra) # 8000101c <kvminithart>
    trapinithart();   // install kernel trap vector
    80000f4c:	00002097          	auipc	ra,0x2
    80000f50:	902080e7          	jalr	-1790(ra) # 8000284e <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000f54:	00005097          	auipc	ra,0x5
    80000f58:	000080e7          	jalr	ra # 80005f54 <plicinithart>
  }

  scheduler();        
    80000f5c:	00001097          	auipc	ra,0x1
    80000f60:	044080e7          	jalr	68(ra) # 80001fa0 <scheduler>
    consoleinit();
    80000f64:	fffff097          	auipc	ra,0xfffff
    80000f68:	508080e7          	jalr	1288(ra) # 8000046c <consoleinit>
    printfinit();
    80000f6c:	00000097          	auipc	ra,0x0
    80000f70:	83e080e7          	jalr	-1986(ra) # 800007aa <printfinit>
    printf("\n");
    80000f74:	00007517          	auipc	a0,0x7
    80000f78:	09c50513          	addi	a0,a0,156 # 80008010 <etext+0x10>
    80000f7c:	fffff097          	auipc	ra,0xfffff
    80000f80:	624080e7          	jalr	1572(ra) # 800005a0 <printf>
    printf("xv6 kernel is booting\n");
    80000f84:	00007517          	auipc	a0,0x7
    80000f88:	0fc50513          	addi	a0,a0,252 # 80008080 <etext+0x80>
    80000f8c:	fffff097          	auipc	ra,0xfffff
    80000f90:	614080e7          	jalr	1556(ra) # 800005a0 <printf>
    printf("\n");
    80000f94:	00007517          	auipc	a0,0x7
    80000f98:	07c50513          	addi	a0,a0,124 # 80008010 <etext+0x10>
    80000f9c:	fffff097          	auipc	ra,0xfffff
    80000fa0:	604080e7          	jalr	1540(ra) # 800005a0 <printf>
    kinit();         // physical page allocator
    80000fa4:	00000097          	auipc	ra,0x0
    80000fa8:	b70080e7          	jalr	-1168(ra) # 80000b14 <kinit>
    kvminit();       // create kernel page table
    80000fac:	00000097          	auipc	ra,0x0
    80000fb0:	320080e7          	jalr	800(ra) # 800012cc <kvminit>
    kvminithart();   // turn on paging
    80000fb4:	00000097          	auipc	ra,0x0
    80000fb8:	068080e7          	jalr	104(ra) # 8000101c <kvminithart>
    procinit();      // process table
    80000fbc:	00001097          	auipc	ra,0x1
    80000fc0:	9d8080e7          	jalr	-1576(ra) # 80001994 <procinit>
    trapinit();      // trap vectors
    80000fc4:	00002097          	auipc	ra,0x2
    80000fc8:	862080e7          	jalr	-1950(ra) # 80002826 <trapinit>
    trapinithart();  // install kernel trap vector
    80000fcc:	00002097          	auipc	ra,0x2
    80000fd0:	882080e7          	jalr	-1918(ra) # 8000284e <trapinithart>
    plicinit();      // set up interrupt controller
    80000fd4:	00005097          	auipc	ra,0x5
    80000fd8:	f66080e7          	jalr	-154(ra) # 80005f3a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000fdc:	00005097          	auipc	ra,0x5
    80000fe0:	f78080e7          	jalr	-136(ra) # 80005f54 <plicinithart>
    binit();         // buffer cache
    80000fe4:	00002097          	auipc	ra,0x2
    80000fe8:	03c080e7          	jalr	60(ra) # 80003020 <binit>
    iinit();         // inode table
    80000fec:	00002097          	auipc	ra,0x2
    80000ff0:	69a080e7          	jalr	1690(ra) # 80003686 <iinit>
    fileinit();      // file table
    80000ff4:	00003097          	auipc	ra,0x3
    80000ff8:	67c080e7          	jalr	1660(ra) # 80004670 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000ffc:	00005097          	auipc	ra,0x5
    80001000:	078080e7          	jalr	120(ra) # 80006074 <virtio_disk_init>
    userinit();      // first user process
    80001004:	00001097          	auipc	ra,0x1
    80001008:	d60080e7          	jalr	-672(ra) # 80001d64 <userinit>
    __sync_synchronize();
    8000100c:	0330000f          	fence	rw,rw
    started = 1;
    80001010:	4785                	li	a5,1
    80001012:	00008717          	auipc	a4,0x8
    80001016:	00f72323          	sw	a5,6(a4) # 80009018 <started>
    8000101a:	b789                	j	80000f5c <main+0x56>

000000008000101c <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000101c:	1141                	addi	sp,sp,-16
    8000101e:	e406                	sd	ra,8(sp)
    80001020:	e022                	sd	s0,0(sp)
    80001022:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80001024:	00008797          	auipc	a5,0x8
    80001028:	ffc7b783          	ld	a5,-4(a5) # 80009020 <kernel_pagetable>
    8000102c:	83b1                	srli	a5,a5,0xc
    8000102e:	577d                	li	a4,-1
    80001030:	177e                	slli	a4,a4,0x3f
    80001032:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80001034:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80001038:	12000073          	sfence.vma
  sfence_vma();
}
    8000103c:	60a2                	ld	ra,8(sp)
    8000103e:	6402                	ld	s0,0(sp)
    80001040:	0141                	addi	sp,sp,16
    80001042:	8082                	ret

0000000080001044 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80001044:	7139                	addi	sp,sp,-64
    80001046:	fc06                	sd	ra,56(sp)
    80001048:	f822                	sd	s0,48(sp)
    8000104a:	f426                	sd	s1,40(sp)
    8000104c:	f04a                	sd	s2,32(sp)
    8000104e:	ec4e                	sd	s3,24(sp)
    80001050:	e852                	sd	s4,16(sp)
    80001052:	e456                	sd	s5,8(sp)
    80001054:	e05a                	sd	s6,0(sp)
    80001056:	0080                	addi	s0,sp,64
    80001058:	84aa                	mv	s1,a0
    8000105a:	89ae                	mv	s3,a1
    8000105c:	8b32                	mv	s6,a2
  if(va >= MAXVA)
    8000105e:	57fd                	li	a5,-1
    80001060:	83e9                	srli	a5,a5,0x1a
    80001062:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80001064:	4ab1                	li	s5,12
  if(va >= MAXVA)
    80001066:	04b7e263          	bltu	a5,a1,800010aa <walk+0x66>
    pte_t *pte = &pagetable[PX(level, va)];
    8000106a:	0149d933          	srl	s2,s3,s4
    8000106e:	1ff97913          	andi	s2,s2,511
    80001072:	090e                	slli	s2,s2,0x3
    80001074:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80001076:	00093483          	ld	s1,0(s2)
    8000107a:	0014f793          	andi	a5,s1,1
    8000107e:	cf95                	beqz	a5,800010ba <walk+0x76>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80001080:	80a9                	srli	s1,s1,0xa
    80001082:	04b2                	slli	s1,s1,0xc
  for(int level = 2; level > 0; level--) {
    80001084:	3a5d                	addiw	s4,s4,-9
    80001086:	ff5a12e3          	bne	s4,s5,8000106a <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    8000108a:	00c9d513          	srli	a0,s3,0xc
    8000108e:	1ff57513          	andi	a0,a0,511
    80001092:	050e                	slli	a0,a0,0x3
    80001094:	9526                	add	a0,a0,s1
}
    80001096:	70e2                	ld	ra,56(sp)
    80001098:	7442                	ld	s0,48(sp)
    8000109a:	74a2                	ld	s1,40(sp)
    8000109c:	7902                	ld	s2,32(sp)
    8000109e:	69e2                	ld	s3,24(sp)
    800010a0:	6a42                	ld	s4,16(sp)
    800010a2:	6aa2                	ld	s5,8(sp)
    800010a4:	6b02                	ld	s6,0(sp)
    800010a6:	6121                	addi	sp,sp,64
    800010a8:	8082                	ret
    panic("walk");
    800010aa:	00007517          	auipc	a0,0x7
    800010ae:	00650513          	addi	a0,a0,6 # 800080b0 <etext+0xb0>
    800010b2:	fffff097          	auipc	ra,0xfffff
    800010b6:	4a4080e7          	jalr	1188(ra) # 80000556 <panic>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800010ba:	020b0663          	beqz	s6,800010e6 <walk+0xa2>
    800010be:	00000097          	auipc	ra,0x0
    800010c2:	a92080e7          	jalr	-1390(ra) # 80000b50 <kalloc>
    800010c6:	84aa                	mv	s1,a0
    800010c8:	d579                	beqz	a0,80001096 <walk+0x52>
      memset(pagetable, 0, PGSIZE);
    800010ca:	6605                	lui	a2,0x1
    800010cc:	4581                	li	a1,0
    800010ce:	00000097          	auipc	ra,0x0
    800010d2:	c7e080e7          	jalr	-898(ra) # 80000d4c <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800010d6:	00c4d793          	srli	a5,s1,0xc
    800010da:	07aa                	slli	a5,a5,0xa
    800010dc:	0017e793          	ori	a5,a5,1
    800010e0:	00f93023          	sd	a5,0(s2)
    800010e4:	b745                	j	80001084 <walk+0x40>
        return 0;
    800010e6:	4501                	li	a0,0
    800010e8:	b77d                	j	80001096 <walk+0x52>

00000000800010ea <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800010ea:	57fd                	li	a5,-1
    800010ec:	83e9                	srli	a5,a5,0x1a
    800010ee:	00b7f463          	bgeu	a5,a1,800010f6 <walkaddr+0xc>
    return 0;
    800010f2:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800010f4:	8082                	ret
{
    800010f6:	1141                	addi	sp,sp,-16
    800010f8:	e406                	sd	ra,8(sp)
    800010fa:	e022                	sd	s0,0(sp)
    800010fc:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800010fe:	4601                	li	a2,0
    80001100:	00000097          	auipc	ra,0x0
    80001104:	f44080e7          	jalr	-188(ra) # 80001044 <walk>
  if(pte == 0)
    80001108:	c901                	beqz	a0,80001118 <walkaddr+0x2e>
  if((*pte & PTE_V) == 0)
    8000110a:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000110c:	0117f693          	andi	a3,a5,17
    80001110:	4745                	li	a4,17
    return 0;
    80001112:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80001114:	00e68663          	beq	a3,a4,80001120 <walkaddr+0x36>
}
    80001118:	60a2                	ld	ra,8(sp)
    8000111a:	6402                	ld	s0,0(sp)
    8000111c:	0141                	addi	sp,sp,16
    8000111e:	8082                	ret
  pa = PTE2PA(*pte);
    80001120:	83a9                	srli	a5,a5,0xa
    80001122:	00c79513          	slli	a0,a5,0xc
  return pa;
    80001126:	bfcd                	j	80001118 <walkaddr+0x2e>

0000000080001128 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001128:	715d                	addi	sp,sp,-80
    8000112a:	e486                	sd	ra,72(sp)
    8000112c:	e0a2                	sd	s0,64(sp)
    8000112e:	fc26                	sd	s1,56(sp)
    80001130:	f84a                	sd	s2,48(sp)
    80001132:	f44e                	sd	s3,40(sp)
    80001134:	f052                	sd	s4,32(sp)
    80001136:	ec56                	sd	s5,24(sp)
    80001138:	e85a                	sd	s6,16(sp)
    8000113a:	e45e                	sd	s7,8(sp)
    8000113c:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000113e:	ca21                	beqz	a2,8000118e <mappages+0x66>
    80001140:	8a2a                	mv	s4,a0
    80001142:	8aba                	mv	s5,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80001144:	777d                	lui	a4,0xfffff
    80001146:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    8000114a:	fff58913          	addi	s2,a1,-1
    8000114e:	9932                	add	s2,s2,a2
    80001150:	00e97933          	and	s2,s2,a4
  a = PGROUNDDOWN(va);
    80001154:	84be                	mv	s1,a5
  for(;;){
    if((pte = walk(pagetable, a, 1)) == 0)
    80001156:	4b05                	li	s6,1
    80001158:	40f689b3          	sub	s3,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000115c:	6b85                	lui	s7,0x1
    if((pte = walk(pagetable, a, 1)) == 0)
    8000115e:	865a                	mv	a2,s6
    80001160:	85a6                	mv	a1,s1
    80001162:	8552                	mv	a0,s4
    80001164:	00000097          	auipc	ra,0x0
    80001168:	ee0080e7          	jalr	-288(ra) # 80001044 <walk>
    8000116c:	c129                	beqz	a0,800011ae <mappages+0x86>
    if(*pte & PTE_V)
    8000116e:	611c                	ld	a5,0(a0)
    80001170:	8b85                	andi	a5,a5,1
    80001172:	e795                	bnez	a5,8000119e <mappages+0x76>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001174:	013487b3          	add	a5,s1,s3
    80001178:	83b1                	srli	a5,a5,0xc
    8000117a:	07aa                	slli	a5,a5,0xa
    8000117c:	0157e7b3          	or	a5,a5,s5
    80001180:	0017e793          	ori	a5,a5,1
    80001184:	e11c                	sd	a5,0(a0)
    if(a == last)
    80001186:	05248063          	beq	s1,s2,800011c6 <mappages+0x9e>
    a += PGSIZE;
    8000118a:	94de                	add	s1,s1,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    8000118c:	bfc9                	j	8000115e <mappages+0x36>
    panic("mappages: size");
    8000118e:	00007517          	auipc	a0,0x7
    80001192:	f2a50513          	addi	a0,a0,-214 # 800080b8 <etext+0xb8>
    80001196:	fffff097          	auipc	ra,0xfffff
    8000119a:	3c0080e7          	jalr	960(ra) # 80000556 <panic>
      panic("mappages: remap");
    8000119e:	00007517          	auipc	a0,0x7
    800011a2:	f2a50513          	addi	a0,a0,-214 # 800080c8 <etext+0xc8>
    800011a6:	fffff097          	auipc	ra,0xfffff
    800011aa:	3b0080e7          	jalr	944(ra) # 80000556 <panic>
      return -1;
    800011ae:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800011b0:	60a6                	ld	ra,72(sp)
    800011b2:	6406                	ld	s0,64(sp)
    800011b4:	74e2                	ld	s1,56(sp)
    800011b6:	7942                	ld	s2,48(sp)
    800011b8:	79a2                	ld	s3,40(sp)
    800011ba:	7a02                	ld	s4,32(sp)
    800011bc:	6ae2                	ld	s5,24(sp)
    800011be:	6b42                	ld	s6,16(sp)
    800011c0:	6ba2                	ld	s7,8(sp)
    800011c2:	6161                	addi	sp,sp,80
    800011c4:	8082                	ret
  return 0;
    800011c6:	4501                	li	a0,0
    800011c8:	b7e5                	j	800011b0 <mappages+0x88>

00000000800011ca <kvmmap>:
{
    800011ca:	1141                	addi	sp,sp,-16
    800011cc:	e406                	sd	ra,8(sp)
    800011ce:	e022                	sd	s0,0(sp)
    800011d0:	0800                	addi	s0,sp,16
    800011d2:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800011d4:	86b2                	mv	a3,a2
    800011d6:	863e                	mv	a2,a5
    800011d8:	00000097          	auipc	ra,0x0
    800011dc:	f50080e7          	jalr	-176(ra) # 80001128 <mappages>
    800011e0:	e509                	bnez	a0,800011ea <kvmmap+0x20>
}
    800011e2:	60a2                	ld	ra,8(sp)
    800011e4:	6402                	ld	s0,0(sp)
    800011e6:	0141                	addi	sp,sp,16
    800011e8:	8082                	ret
    panic("kvmmap");
    800011ea:	00007517          	auipc	a0,0x7
    800011ee:	eee50513          	addi	a0,a0,-274 # 800080d8 <etext+0xd8>
    800011f2:	fffff097          	auipc	ra,0xfffff
    800011f6:	364080e7          	jalr	868(ra) # 80000556 <panic>

00000000800011fa <kvmmake>:
{
    800011fa:	1101                	addi	sp,sp,-32
    800011fc:	ec06                	sd	ra,24(sp)
    800011fe:	e822                	sd	s0,16(sp)
    80001200:	e426                	sd	s1,8(sp)
    80001202:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80001204:	00000097          	auipc	ra,0x0
    80001208:	94c080e7          	jalr	-1716(ra) # 80000b50 <kalloc>
    8000120c:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000120e:	6605                	lui	a2,0x1
    80001210:	4581                	li	a1,0
    80001212:	00000097          	auipc	ra,0x0
    80001216:	b3a080e7          	jalr	-1222(ra) # 80000d4c <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000121a:	4719                	li	a4,6
    8000121c:	6685                	lui	a3,0x1
    8000121e:	10000637          	lui	a2,0x10000
    80001222:	85b2                	mv	a1,a2
    80001224:	8526                	mv	a0,s1
    80001226:	00000097          	auipc	ra,0x0
    8000122a:	fa4080e7          	jalr	-92(ra) # 800011ca <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000122e:	4719                	li	a4,6
    80001230:	6685                	lui	a3,0x1
    80001232:	10001637          	lui	a2,0x10001
    80001236:	85b2                	mv	a1,a2
    80001238:	8526                	mv	a0,s1
    8000123a:	00000097          	auipc	ra,0x0
    8000123e:	f90080e7          	jalr	-112(ra) # 800011ca <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80001242:	4719                	li	a4,6
    80001244:	004006b7          	lui	a3,0x400
    80001248:	0c000637          	lui	a2,0xc000
    8000124c:	85b2                	mv	a1,a2
    8000124e:	8526                	mv	a0,s1
    80001250:	00000097          	auipc	ra,0x0
    80001254:	f7a080e7          	jalr	-134(ra) # 800011ca <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001258:	4729                	li	a4,10
    8000125a:	80007697          	auipc	a3,0x80007
    8000125e:	da668693          	addi	a3,a3,-602 # 8000 <_entry-0x7fff8000>
    80001262:	4605                	li	a2,1
    80001264:	067e                	slli	a2,a2,0x1f
    80001266:	85b2                	mv	a1,a2
    80001268:	8526                	mv	a0,s1
    8000126a:	00000097          	auipc	ra,0x0
    8000126e:	f60080e7          	jalr	-160(ra) # 800011ca <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001272:	4719                	li	a4,6
    80001274:	00007697          	auipc	a3,0x7
    80001278:	d8c68693          	addi	a3,a3,-628 # 80008000 <etext>
    8000127c:	47c5                	li	a5,17
    8000127e:	07ee                	slli	a5,a5,0x1b
    80001280:	40d786b3          	sub	a3,a5,a3
    80001284:	00007617          	auipc	a2,0x7
    80001288:	d7c60613          	addi	a2,a2,-644 # 80008000 <etext>
    8000128c:	85b2                	mv	a1,a2
    8000128e:	8526                	mv	a0,s1
    80001290:	00000097          	auipc	ra,0x0
    80001294:	f3a080e7          	jalr	-198(ra) # 800011ca <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001298:	4729                	li	a4,10
    8000129a:	6685                	lui	a3,0x1
    8000129c:	00006617          	auipc	a2,0x6
    800012a0:	d6460613          	addi	a2,a2,-668 # 80007000 <_trampoline>
    800012a4:	040005b7          	lui	a1,0x4000
    800012a8:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800012aa:	05b2                	slli	a1,a1,0xc
    800012ac:	8526                	mv	a0,s1
    800012ae:	00000097          	auipc	ra,0x0
    800012b2:	f1c080e7          	jalr	-228(ra) # 800011ca <kvmmap>
  proc_mapstacks(kpgtbl);
    800012b6:	8526                	mv	a0,s1
    800012b8:	00000097          	auipc	ra,0x0
    800012bc:	62c080e7          	jalr	1580(ra) # 800018e4 <proc_mapstacks>
}
    800012c0:	8526                	mv	a0,s1
    800012c2:	60e2                	ld	ra,24(sp)
    800012c4:	6442                	ld	s0,16(sp)
    800012c6:	64a2                	ld	s1,8(sp)
    800012c8:	6105                	addi	sp,sp,32
    800012ca:	8082                	ret

00000000800012cc <kvminit>:
{
    800012cc:	1141                	addi	sp,sp,-16
    800012ce:	e406                	sd	ra,8(sp)
    800012d0:	e022                	sd	s0,0(sp)
    800012d2:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800012d4:	00000097          	auipc	ra,0x0
    800012d8:	f26080e7          	jalr	-218(ra) # 800011fa <kvmmake>
    800012dc:	00008797          	auipc	a5,0x8
    800012e0:	d4a7b223          	sd	a0,-700(a5) # 80009020 <kernel_pagetable>
}
    800012e4:	60a2                	ld	ra,8(sp)
    800012e6:	6402                	ld	s0,0(sp)
    800012e8:	0141                	addi	sp,sp,16
    800012ea:	8082                	ret

00000000800012ec <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800012ec:	715d                	addi	sp,sp,-80
    800012ee:	e486                	sd	ra,72(sp)
    800012f0:	e0a2                	sd	s0,64(sp)
    800012f2:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800012f4:	03459793          	slli	a5,a1,0x34
    800012f8:	e39d                	bnez	a5,8000131e <uvmunmap+0x32>
    800012fa:	f84a                	sd	s2,48(sp)
    800012fc:	f44e                	sd	s3,40(sp)
    800012fe:	f052                	sd	s4,32(sp)
    80001300:	ec56                	sd	s5,24(sp)
    80001302:	e85a                	sd	s6,16(sp)
    80001304:	e45e                	sd	s7,8(sp)
    80001306:	8a2a                	mv	s4,a0
    80001308:	892e                	mv	s2,a1
    8000130a:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000130c:	0632                	slli	a2,a2,0xc
    8000130e:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80001312:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001314:	6b05                	lui	s6,0x1
    80001316:	0935fb63          	bgeu	a1,s3,800013ac <uvmunmap+0xc0>
    8000131a:	fc26                	sd	s1,56(sp)
    8000131c:	a8a9                	j	80001376 <uvmunmap+0x8a>
    8000131e:	fc26                	sd	s1,56(sp)
    80001320:	f84a                	sd	s2,48(sp)
    80001322:	f44e                	sd	s3,40(sp)
    80001324:	f052                	sd	s4,32(sp)
    80001326:	ec56                	sd	s5,24(sp)
    80001328:	e85a                	sd	s6,16(sp)
    8000132a:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    8000132c:	00007517          	auipc	a0,0x7
    80001330:	db450513          	addi	a0,a0,-588 # 800080e0 <etext+0xe0>
    80001334:	fffff097          	auipc	ra,0xfffff
    80001338:	222080e7          	jalr	546(ra) # 80000556 <panic>
      panic("uvmunmap: walk");
    8000133c:	00007517          	auipc	a0,0x7
    80001340:	dbc50513          	addi	a0,a0,-580 # 800080f8 <etext+0xf8>
    80001344:	fffff097          	auipc	ra,0xfffff
    80001348:	212080e7          	jalr	530(ra) # 80000556 <panic>
      panic("uvmunmap: not mapped");
    8000134c:	00007517          	auipc	a0,0x7
    80001350:	dbc50513          	addi	a0,a0,-580 # 80008108 <etext+0x108>
    80001354:	fffff097          	auipc	ra,0xfffff
    80001358:	202080e7          	jalr	514(ra) # 80000556 <panic>
      panic("uvmunmap: not a leaf");
    8000135c:	00007517          	auipc	a0,0x7
    80001360:	dc450513          	addi	a0,a0,-572 # 80008120 <etext+0x120>
    80001364:	fffff097          	auipc	ra,0xfffff
    80001368:	1f2080e7          	jalr	498(ra) # 80000556 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    8000136c:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001370:	995a                	add	s2,s2,s6
    80001372:	03397c63          	bgeu	s2,s3,800013aa <uvmunmap+0xbe>
    if((pte = walk(pagetable, a, 0)) == 0)
    80001376:	4601                	li	a2,0
    80001378:	85ca                	mv	a1,s2
    8000137a:	8552                	mv	a0,s4
    8000137c:	00000097          	auipc	ra,0x0
    80001380:	cc8080e7          	jalr	-824(ra) # 80001044 <walk>
    80001384:	84aa                	mv	s1,a0
    80001386:	d95d                	beqz	a0,8000133c <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    80001388:	6108                	ld	a0,0(a0)
    8000138a:	00157793          	andi	a5,a0,1
    8000138e:	dfdd                	beqz	a5,8000134c <uvmunmap+0x60>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001390:	3ff57793          	andi	a5,a0,1023
    80001394:	fd7784e3          	beq	a5,s7,8000135c <uvmunmap+0x70>
    if(do_free){
    80001398:	fc0a8ae3          	beqz	s5,8000136c <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    8000139c:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    8000139e:	0532                	slli	a0,a0,0xc
    800013a0:	fffff097          	auipc	ra,0xfffff
    800013a4:	6ac080e7          	jalr	1708(ra) # 80000a4c <kfree>
    800013a8:	b7d1                	j	8000136c <uvmunmap+0x80>
    800013aa:	74e2                	ld	s1,56(sp)
    800013ac:	7942                	ld	s2,48(sp)
    800013ae:	79a2                	ld	s3,40(sp)
    800013b0:	7a02                	ld	s4,32(sp)
    800013b2:	6ae2                	ld	s5,24(sp)
    800013b4:	6b42                	ld	s6,16(sp)
    800013b6:	6ba2                	ld	s7,8(sp)
  }
}
    800013b8:	60a6                	ld	ra,72(sp)
    800013ba:	6406                	ld	s0,64(sp)
    800013bc:	6161                	addi	sp,sp,80
    800013be:	8082                	ret

00000000800013c0 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800013c0:	1101                	addi	sp,sp,-32
    800013c2:	ec06                	sd	ra,24(sp)
    800013c4:	e822                	sd	s0,16(sp)
    800013c6:	e426                	sd	s1,8(sp)
    800013c8:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800013ca:	fffff097          	auipc	ra,0xfffff
    800013ce:	786080e7          	jalr	1926(ra) # 80000b50 <kalloc>
    800013d2:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800013d4:	c519                	beqz	a0,800013e2 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800013d6:	6605                	lui	a2,0x1
    800013d8:	4581                	li	a1,0
    800013da:	00000097          	auipc	ra,0x0
    800013de:	972080e7          	jalr	-1678(ra) # 80000d4c <memset>
  return pagetable;
}
    800013e2:	8526                	mv	a0,s1
    800013e4:	60e2                	ld	ra,24(sp)
    800013e6:	6442                	ld	s0,16(sp)
    800013e8:	64a2                	ld	s1,8(sp)
    800013ea:	6105                	addi	sp,sp,32
    800013ec:	8082                	ret

00000000800013ee <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    800013ee:	7179                	addi	sp,sp,-48
    800013f0:	f406                	sd	ra,40(sp)
    800013f2:	f022                	sd	s0,32(sp)
    800013f4:	ec26                	sd	s1,24(sp)
    800013f6:	e84a                	sd	s2,16(sp)
    800013f8:	e44e                	sd	s3,8(sp)
    800013fa:	e052                	sd	s4,0(sp)
    800013fc:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800013fe:	6785                	lui	a5,0x1
    80001400:	04f67863          	bgeu	a2,a5,80001450 <uvminit+0x62>
    80001404:	89aa                	mv	s3,a0
    80001406:	8a2e                	mv	s4,a1
    80001408:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    8000140a:	fffff097          	auipc	ra,0xfffff
    8000140e:	746080e7          	jalr	1862(ra) # 80000b50 <kalloc>
    80001412:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80001414:	6605                	lui	a2,0x1
    80001416:	4581                	li	a1,0
    80001418:	00000097          	auipc	ra,0x0
    8000141c:	934080e7          	jalr	-1740(ra) # 80000d4c <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80001420:	4779                	li	a4,30
    80001422:	86ca                	mv	a3,s2
    80001424:	6605                	lui	a2,0x1
    80001426:	4581                	li	a1,0
    80001428:	854e                	mv	a0,s3
    8000142a:	00000097          	auipc	ra,0x0
    8000142e:	cfe080e7          	jalr	-770(ra) # 80001128 <mappages>
  memmove(mem, src, sz);
    80001432:	8626                	mv	a2,s1
    80001434:	85d2                	mv	a1,s4
    80001436:	854a                	mv	a0,s2
    80001438:	00000097          	auipc	ra,0x0
    8000143c:	974080e7          	jalr	-1676(ra) # 80000dac <memmove>
}
    80001440:	70a2                	ld	ra,40(sp)
    80001442:	7402                	ld	s0,32(sp)
    80001444:	64e2                	ld	s1,24(sp)
    80001446:	6942                	ld	s2,16(sp)
    80001448:	69a2                	ld	s3,8(sp)
    8000144a:	6a02                	ld	s4,0(sp)
    8000144c:	6145                	addi	sp,sp,48
    8000144e:	8082                	ret
    panic("inituvm: more than a page");
    80001450:	00007517          	auipc	a0,0x7
    80001454:	ce850513          	addi	a0,a0,-792 # 80008138 <etext+0x138>
    80001458:	fffff097          	auipc	ra,0xfffff
    8000145c:	0fe080e7          	jalr	254(ra) # 80000556 <panic>

0000000080001460 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001460:	1101                	addi	sp,sp,-32
    80001462:	ec06                	sd	ra,24(sp)
    80001464:	e822                	sd	s0,16(sp)
    80001466:	e426                	sd	s1,8(sp)
    80001468:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000146a:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000146c:	00b67d63          	bgeu	a2,a1,80001486 <uvmdealloc+0x26>
    80001470:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80001472:	6785                	lui	a5,0x1
    80001474:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001476:	00f60733          	add	a4,a2,a5
    8000147a:	76fd                	lui	a3,0xfffff
    8000147c:	8f75                	and	a4,a4,a3
    8000147e:	97ae                	add	a5,a5,a1
    80001480:	8ff5                	and	a5,a5,a3
    80001482:	00f76863          	bltu	a4,a5,80001492 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001486:	8526                	mv	a0,s1
    80001488:	60e2                	ld	ra,24(sp)
    8000148a:	6442                	ld	s0,16(sp)
    8000148c:	64a2                	ld	s1,8(sp)
    8000148e:	6105                	addi	sp,sp,32
    80001490:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001492:	8f99                	sub	a5,a5,a4
    80001494:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001496:	4685                	li	a3,1
    80001498:	0007861b          	sext.w	a2,a5
    8000149c:	85ba                	mv	a1,a4
    8000149e:	00000097          	auipc	ra,0x0
    800014a2:	e4e080e7          	jalr	-434(ra) # 800012ec <uvmunmap>
    800014a6:	b7c5                	j	80001486 <uvmdealloc+0x26>

00000000800014a8 <uvmalloc>:
  if(newsz < oldsz)
    800014a8:	0ab66c63          	bltu	a2,a1,80001560 <uvmalloc+0xb8>
{
    800014ac:	715d                	addi	sp,sp,-80
    800014ae:	e486                	sd	ra,72(sp)
    800014b0:	e0a2                	sd	s0,64(sp)
    800014b2:	f84a                	sd	s2,48(sp)
    800014b4:	f052                	sd	s4,32(sp)
    800014b6:	ec56                	sd	s5,24(sp)
    800014b8:	e45e                	sd	s7,8(sp)
    800014ba:	0880                	addi	s0,sp,80
    800014bc:	8aaa                	mv	s5,a0
    800014be:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800014c0:	6785                	lui	a5,0x1
    800014c2:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800014c4:	95be                	add	a1,a1,a5
    800014c6:	77fd                	lui	a5,0xfffff
    800014c8:	00f5f933          	and	s2,a1,a5
    800014cc:	8bca                	mv	s7,s2
  for(a = oldsz; a < newsz; a += PGSIZE){
    800014ce:	08c97b63          	bgeu	s2,a2,80001564 <uvmalloc+0xbc>
    800014d2:	fc26                	sd	s1,56(sp)
    800014d4:	f44e                	sd	s3,40(sp)
    800014d6:	e85a                	sd	s6,16(sp)
    memset(mem, 0, PGSIZE);
    800014d8:	6985                	lui	s3,0x1
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800014da:	4b79                	li	s6,30
    mem = kalloc();
    800014dc:	fffff097          	auipc	ra,0xfffff
    800014e0:	674080e7          	jalr	1652(ra) # 80000b50 <kalloc>
    800014e4:	84aa                	mv	s1,a0
    if(mem == 0){
    800014e6:	c90d                	beqz	a0,80001518 <uvmalloc+0x70>
    memset(mem, 0, PGSIZE);
    800014e8:	864e                	mv	a2,s3
    800014ea:	4581                	li	a1,0
    800014ec:	00000097          	auipc	ra,0x0
    800014f0:	860080e7          	jalr	-1952(ra) # 80000d4c <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800014f4:	875a                	mv	a4,s6
    800014f6:	86a6                	mv	a3,s1
    800014f8:	864e                	mv	a2,s3
    800014fa:	85ca                	mv	a1,s2
    800014fc:	8556                	mv	a0,s5
    800014fe:	00000097          	auipc	ra,0x0
    80001502:	c2a080e7          	jalr	-982(ra) # 80001128 <mappages>
    80001506:	ed05                	bnez	a0,8000153e <uvmalloc+0x96>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001508:	994e                	add	s2,s2,s3
    8000150a:	fd4969e3          	bltu	s2,s4,800014dc <uvmalloc+0x34>
  return newsz;
    8000150e:	8552                	mv	a0,s4
    80001510:	74e2                	ld	s1,56(sp)
    80001512:	79a2                	ld	s3,40(sp)
    80001514:	6b42                	ld	s6,16(sp)
    80001516:	a821                	j	8000152e <uvmalloc+0x86>
      uvmdealloc(pagetable, a, oldsz);
    80001518:	865e                	mv	a2,s7
    8000151a:	85ca                	mv	a1,s2
    8000151c:	8556                	mv	a0,s5
    8000151e:	00000097          	auipc	ra,0x0
    80001522:	f42080e7          	jalr	-190(ra) # 80001460 <uvmdealloc>
      return 0;
    80001526:	4501                	li	a0,0
    80001528:	74e2                	ld	s1,56(sp)
    8000152a:	79a2                	ld	s3,40(sp)
    8000152c:	6b42                	ld	s6,16(sp)
}
    8000152e:	60a6                	ld	ra,72(sp)
    80001530:	6406                	ld	s0,64(sp)
    80001532:	7942                	ld	s2,48(sp)
    80001534:	7a02                	ld	s4,32(sp)
    80001536:	6ae2                	ld	s5,24(sp)
    80001538:	6ba2                	ld	s7,8(sp)
    8000153a:	6161                	addi	sp,sp,80
    8000153c:	8082                	ret
      kfree(mem);
    8000153e:	8526                	mv	a0,s1
    80001540:	fffff097          	auipc	ra,0xfffff
    80001544:	50c080e7          	jalr	1292(ra) # 80000a4c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001548:	865e                	mv	a2,s7
    8000154a:	85ca                	mv	a1,s2
    8000154c:	8556                	mv	a0,s5
    8000154e:	00000097          	auipc	ra,0x0
    80001552:	f12080e7          	jalr	-238(ra) # 80001460 <uvmdealloc>
      return 0;
    80001556:	4501                	li	a0,0
    80001558:	74e2                	ld	s1,56(sp)
    8000155a:	79a2                	ld	s3,40(sp)
    8000155c:	6b42                	ld	s6,16(sp)
    8000155e:	bfc1                	j	8000152e <uvmalloc+0x86>
    return oldsz;
    80001560:	852e                	mv	a0,a1
}
    80001562:	8082                	ret
  return newsz;
    80001564:	8532                	mv	a0,a2
    80001566:	b7e1                	j	8000152e <uvmalloc+0x86>

0000000080001568 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001568:	7179                	addi	sp,sp,-48
    8000156a:	f406                	sd	ra,40(sp)
    8000156c:	f022                	sd	s0,32(sp)
    8000156e:	ec26                	sd	s1,24(sp)
    80001570:	e84a                	sd	s2,16(sp)
    80001572:	e44e                	sd	s3,8(sp)
    80001574:	1800                	addi	s0,sp,48
    80001576:	89aa                	mv	s3,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80001578:	84aa                	mv	s1,a0
    8000157a:	6905                	lui	s2,0x1
    8000157c:	992a                	add	s2,s2,a0
    8000157e:	a821                	j	80001596 <freewalk+0x2e>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
      freewalk((pagetable_t)child);
      pagetable[i] = 0;
    } else if(pte & PTE_V){
      panic("freewalk: leaf");
    80001580:	00007517          	auipc	a0,0x7
    80001584:	bd850513          	addi	a0,a0,-1064 # 80008158 <etext+0x158>
    80001588:	fffff097          	auipc	ra,0xfffff
    8000158c:	fce080e7          	jalr	-50(ra) # 80000556 <panic>
  for(int i = 0; i < 512; i++){
    80001590:	04a1                	addi	s1,s1,8
    80001592:	03248363          	beq	s1,s2,800015b8 <freewalk+0x50>
    pte_t pte = pagetable[i];
    80001596:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001598:	0017f713          	andi	a4,a5,1
    8000159c:	db75                	beqz	a4,80001590 <freewalk+0x28>
    8000159e:	00e7f713          	andi	a4,a5,14
    800015a2:	ff79                	bnez	a4,80001580 <freewalk+0x18>
      uint64 child = PTE2PA(pte);
    800015a4:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800015a6:	00c79513          	slli	a0,a5,0xc
    800015aa:	00000097          	auipc	ra,0x0
    800015ae:	fbe080e7          	jalr	-66(ra) # 80001568 <freewalk>
      pagetable[i] = 0;
    800015b2:	0004b023          	sd	zero,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800015b6:	bfe9                	j	80001590 <freewalk+0x28>
    }
  }
  kfree((void*)pagetable);
    800015b8:	854e                	mv	a0,s3
    800015ba:	fffff097          	auipc	ra,0xfffff
    800015be:	492080e7          	jalr	1170(ra) # 80000a4c <kfree>
}
    800015c2:	70a2                	ld	ra,40(sp)
    800015c4:	7402                	ld	s0,32(sp)
    800015c6:	64e2                	ld	s1,24(sp)
    800015c8:	6942                	ld	s2,16(sp)
    800015ca:	69a2                	ld	s3,8(sp)
    800015cc:	6145                	addi	sp,sp,48
    800015ce:	8082                	ret

00000000800015d0 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800015d0:	1101                	addi	sp,sp,-32
    800015d2:	ec06                	sd	ra,24(sp)
    800015d4:	e822                	sd	s0,16(sp)
    800015d6:	e426                	sd	s1,8(sp)
    800015d8:	1000                	addi	s0,sp,32
    800015da:	84aa                	mv	s1,a0
  if(sz > 0)
    800015dc:	e999                	bnez	a1,800015f2 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800015de:	8526                	mv	a0,s1
    800015e0:	00000097          	auipc	ra,0x0
    800015e4:	f88080e7          	jalr	-120(ra) # 80001568 <freewalk>
}
    800015e8:	60e2                	ld	ra,24(sp)
    800015ea:	6442                	ld	s0,16(sp)
    800015ec:	64a2                	ld	s1,8(sp)
    800015ee:	6105                	addi	sp,sp,32
    800015f0:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800015f2:	6785                	lui	a5,0x1
    800015f4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800015f6:	95be                	add	a1,a1,a5
    800015f8:	4685                	li	a3,1
    800015fa:	00c5d613          	srli	a2,a1,0xc
    800015fe:	4581                	li	a1,0
    80001600:	00000097          	auipc	ra,0x0
    80001604:	cec080e7          	jalr	-788(ra) # 800012ec <uvmunmap>
    80001608:	bfd9                	j	800015de <uvmfree+0xe>

000000008000160a <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    8000160a:	c669                	beqz	a2,800016d4 <uvmcopy+0xca>
{
    8000160c:	715d                	addi	sp,sp,-80
    8000160e:	e486                	sd	ra,72(sp)
    80001610:	e0a2                	sd	s0,64(sp)
    80001612:	fc26                	sd	s1,56(sp)
    80001614:	f84a                	sd	s2,48(sp)
    80001616:	f44e                	sd	s3,40(sp)
    80001618:	f052                	sd	s4,32(sp)
    8000161a:	ec56                	sd	s5,24(sp)
    8000161c:	e85a                	sd	s6,16(sp)
    8000161e:	e45e                	sd	s7,8(sp)
    80001620:	0880                	addi	s0,sp,80
    80001622:	8b2a                	mv	s6,a0
    80001624:	8aae                	mv	s5,a1
    80001626:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001628:	4901                	li	s2,0
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    8000162a:	6985                	lui	s3,0x1
    if((pte = walk(old, i, 0)) == 0)
    8000162c:	4601                	li	a2,0
    8000162e:	85ca                	mv	a1,s2
    80001630:	855a                	mv	a0,s6
    80001632:	00000097          	auipc	ra,0x0
    80001636:	a12080e7          	jalr	-1518(ra) # 80001044 <walk>
    8000163a:	c139                	beqz	a0,80001680 <uvmcopy+0x76>
    if((*pte & PTE_V) == 0)
    8000163c:	00053b83          	ld	s7,0(a0)
    80001640:	001bf793          	andi	a5,s7,1
    80001644:	c7b1                	beqz	a5,80001690 <uvmcopy+0x86>
    if((mem = kalloc()) == 0)
    80001646:	fffff097          	auipc	ra,0xfffff
    8000164a:	50a080e7          	jalr	1290(ra) # 80000b50 <kalloc>
    8000164e:	84aa                	mv	s1,a0
    80001650:	cd29                	beqz	a0,800016aa <uvmcopy+0xa0>
    pa = PTE2PA(*pte);
    80001652:	00abd593          	srli	a1,s7,0xa
    memmove(mem, (char*)pa, PGSIZE);
    80001656:	864e                	mv	a2,s3
    80001658:	05b2                	slli	a1,a1,0xc
    8000165a:	fffff097          	auipc	ra,0xfffff
    8000165e:	752080e7          	jalr	1874(ra) # 80000dac <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80001662:	3ffbf713          	andi	a4,s7,1023
    80001666:	86a6                	mv	a3,s1
    80001668:	864e                	mv	a2,s3
    8000166a:	85ca                	mv	a1,s2
    8000166c:	8556                	mv	a0,s5
    8000166e:	00000097          	auipc	ra,0x0
    80001672:	aba080e7          	jalr	-1350(ra) # 80001128 <mappages>
    80001676:	e50d                	bnez	a0,800016a0 <uvmcopy+0x96>
  for(i = 0; i < sz; i += PGSIZE){
    80001678:	994e                	add	s2,s2,s3
    8000167a:	fb4969e3          	bltu	s2,s4,8000162c <uvmcopy+0x22>
    8000167e:	a081                	j	800016be <uvmcopy+0xb4>
      panic("uvmcopy: pte should exist");
    80001680:	00007517          	auipc	a0,0x7
    80001684:	ae850513          	addi	a0,a0,-1304 # 80008168 <etext+0x168>
    80001688:	fffff097          	auipc	ra,0xfffff
    8000168c:	ece080e7          	jalr	-306(ra) # 80000556 <panic>
      panic("uvmcopy: page not present");
    80001690:	00007517          	auipc	a0,0x7
    80001694:	af850513          	addi	a0,a0,-1288 # 80008188 <etext+0x188>
    80001698:	fffff097          	auipc	ra,0xfffff
    8000169c:	ebe080e7          	jalr	-322(ra) # 80000556 <panic>
      kfree(mem);
    800016a0:	8526                	mv	a0,s1
    800016a2:	fffff097          	auipc	ra,0xfffff
    800016a6:	3aa080e7          	jalr	938(ra) # 80000a4c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800016aa:	4685                	li	a3,1
    800016ac:	00c95613          	srli	a2,s2,0xc
    800016b0:	4581                	li	a1,0
    800016b2:	8556                	mv	a0,s5
    800016b4:	00000097          	auipc	ra,0x0
    800016b8:	c38080e7          	jalr	-968(ra) # 800012ec <uvmunmap>
  return -1;
    800016bc:	557d                	li	a0,-1
}
    800016be:	60a6                	ld	ra,72(sp)
    800016c0:	6406                	ld	s0,64(sp)
    800016c2:	74e2                	ld	s1,56(sp)
    800016c4:	7942                	ld	s2,48(sp)
    800016c6:	79a2                	ld	s3,40(sp)
    800016c8:	7a02                	ld	s4,32(sp)
    800016ca:	6ae2                	ld	s5,24(sp)
    800016cc:	6b42                	ld	s6,16(sp)
    800016ce:	6ba2                	ld	s7,8(sp)
    800016d0:	6161                	addi	sp,sp,80
    800016d2:	8082                	ret
  return 0;
    800016d4:	4501                	li	a0,0
}
    800016d6:	8082                	ret

00000000800016d8 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800016d8:	1141                	addi	sp,sp,-16
    800016da:	e406                	sd	ra,8(sp)
    800016dc:	e022                	sd	s0,0(sp)
    800016de:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800016e0:	4601                	li	a2,0
    800016e2:	00000097          	auipc	ra,0x0
    800016e6:	962080e7          	jalr	-1694(ra) # 80001044 <walk>
  if(pte == 0)
    800016ea:	c901                	beqz	a0,800016fa <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800016ec:	611c                	ld	a5,0(a0)
    800016ee:	9bbd                	andi	a5,a5,-17
    800016f0:	e11c                	sd	a5,0(a0)
}
    800016f2:	60a2                	ld	ra,8(sp)
    800016f4:	6402                	ld	s0,0(sp)
    800016f6:	0141                	addi	sp,sp,16
    800016f8:	8082                	ret
    panic("uvmclear");
    800016fa:	00007517          	auipc	a0,0x7
    800016fe:	aae50513          	addi	a0,a0,-1362 # 800081a8 <etext+0x1a8>
    80001702:	fffff097          	auipc	ra,0xfffff
    80001706:	e54080e7          	jalr	-428(ra) # 80000556 <panic>

000000008000170a <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    8000170a:	c6bd                	beqz	a3,80001778 <copyout+0x6e>
{
    8000170c:	715d                	addi	sp,sp,-80
    8000170e:	e486                	sd	ra,72(sp)
    80001710:	e0a2                	sd	s0,64(sp)
    80001712:	fc26                	sd	s1,56(sp)
    80001714:	f84a                	sd	s2,48(sp)
    80001716:	f44e                	sd	s3,40(sp)
    80001718:	f052                	sd	s4,32(sp)
    8000171a:	ec56                	sd	s5,24(sp)
    8000171c:	e85a                	sd	s6,16(sp)
    8000171e:	e45e                	sd	s7,8(sp)
    80001720:	e062                	sd	s8,0(sp)
    80001722:	0880                	addi	s0,sp,80
    80001724:	8b2a                	mv	s6,a0
    80001726:	8c2e                	mv	s8,a1
    80001728:	8a32                	mv	s4,a2
    8000172a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    8000172c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    8000172e:	6a85                	lui	s5,0x1
    80001730:	a015                	j	80001754 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001732:	9562                	add	a0,a0,s8
    80001734:	0004861b          	sext.w	a2,s1
    80001738:	85d2                	mv	a1,s4
    8000173a:	41250533          	sub	a0,a0,s2
    8000173e:	fffff097          	auipc	ra,0xfffff
    80001742:	66e080e7          	jalr	1646(ra) # 80000dac <memmove>

    len -= n;
    80001746:	409989b3          	sub	s3,s3,s1
    src += n;
    8000174a:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    8000174c:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001750:	02098263          	beqz	s3,80001774 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80001754:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001758:	85ca                	mv	a1,s2
    8000175a:	855a                	mv	a0,s6
    8000175c:	00000097          	auipc	ra,0x0
    80001760:	98e080e7          	jalr	-1650(ra) # 800010ea <walkaddr>
    if(pa0 == 0)
    80001764:	cd01                	beqz	a0,8000177c <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80001766:	418904b3          	sub	s1,s2,s8
    8000176a:	94d6                	add	s1,s1,s5
    if(n > len)
    8000176c:	fc99f3e3          	bgeu	s3,s1,80001732 <copyout+0x28>
    80001770:	84ce                	mv	s1,s3
    80001772:	b7c1                	j	80001732 <copyout+0x28>
  }
  return 0;
    80001774:	4501                	li	a0,0
    80001776:	a021                	j	8000177e <copyout+0x74>
    80001778:	4501                	li	a0,0
}
    8000177a:	8082                	ret
      return -1;
    8000177c:	557d                	li	a0,-1
}
    8000177e:	60a6                	ld	ra,72(sp)
    80001780:	6406                	ld	s0,64(sp)
    80001782:	74e2                	ld	s1,56(sp)
    80001784:	7942                	ld	s2,48(sp)
    80001786:	79a2                	ld	s3,40(sp)
    80001788:	7a02                	ld	s4,32(sp)
    8000178a:	6ae2                	ld	s5,24(sp)
    8000178c:	6b42                	ld	s6,16(sp)
    8000178e:	6ba2                	ld	s7,8(sp)
    80001790:	6c02                	ld	s8,0(sp)
    80001792:	6161                	addi	sp,sp,80
    80001794:	8082                	ret

0000000080001796 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001796:	caa5                	beqz	a3,80001806 <copyin+0x70>
{
    80001798:	715d                	addi	sp,sp,-80
    8000179a:	e486                	sd	ra,72(sp)
    8000179c:	e0a2                	sd	s0,64(sp)
    8000179e:	fc26                	sd	s1,56(sp)
    800017a0:	f84a                	sd	s2,48(sp)
    800017a2:	f44e                	sd	s3,40(sp)
    800017a4:	f052                	sd	s4,32(sp)
    800017a6:	ec56                	sd	s5,24(sp)
    800017a8:	e85a                	sd	s6,16(sp)
    800017aa:	e45e                	sd	s7,8(sp)
    800017ac:	e062                	sd	s8,0(sp)
    800017ae:	0880                	addi	s0,sp,80
    800017b0:	8b2a                	mv	s6,a0
    800017b2:	8a2e                	mv	s4,a1
    800017b4:	8c32                	mv	s8,a2
    800017b6:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    800017b8:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800017ba:	6a85                	lui	s5,0x1
    800017bc:	a01d                	j	800017e2 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    800017be:	018505b3          	add	a1,a0,s8
    800017c2:	0004861b          	sext.w	a2,s1
    800017c6:	412585b3          	sub	a1,a1,s2
    800017ca:	8552                	mv	a0,s4
    800017cc:	fffff097          	auipc	ra,0xfffff
    800017d0:	5e0080e7          	jalr	1504(ra) # 80000dac <memmove>

    len -= n;
    800017d4:	409989b3          	sub	s3,s3,s1
    dst += n;
    800017d8:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    800017da:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800017de:	02098263          	beqz	s3,80001802 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    800017e2:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800017e6:	85ca                	mv	a1,s2
    800017e8:	855a                	mv	a0,s6
    800017ea:	00000097          	auipc	ra,0x0
    800017ee:	900080e7          	jalr	-1792(ra) # 800010ea <walkaddr>
    if(pa0 == 0)
    800017f2:	cd01                	beqz	a0,8000180a <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    800017f4:	418904b3          	sub	s1,s2,s8
    800017f8:	94d6                	add	s1,s1,s5
    if(n > len)
    800017fa:	fc99f2e3          	bgeu	s3,s1,800017be <copyin+0x28>
    800017fe:	84ce                	mv	s1,s3
    80001800:	bf7d                	j	800017be <copyin+0x28>
  }
  return 0;
    80001802:	4501                	li	a0,0
    80001804:	a021                	j	8000180c <copyin+0x76>
    80001806:	4501                	li	a0,0
}
    80001808:	8082                	ret
      return -1;
    8000180a:	557d                	li	a0,-1
}
    8000180c:	60a6                	ld	ra,72(sp)
    8000180e:	6406                	ld	s0,64(sp)
    80001810:	74e2                	ld	s1,56(sp)
    80001812:	7942                	ld	s2,48(sp)
    80001814:	79a2                	ld	s3,40(sp)
    80001816:	7a02                	ld	s4,32(sp)
    80001818:	6ae2                	ld	s5,24(sp)
    8000181a:	6b42                	ld	s6,16(sp)
    8000181c:	6ba2                	ld	s7,8(sp)
    8000181e:	6c02                	ld	s8,0(sp)
    80001820:	6161                	addi	sp,sp,80
    80001822:	8082                	ret

0000000080001824 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001824:	cad5                	beqz	a3,800018d8 <copyinstr+0xb4>
{
    80001826:	715d                	addi	sp,sp,-80
    80001828:	e486                	sd	ra,72(sp)
    8000182a:	e0a2                	sd	s0,64(sp)
    8000182c:	fc26                	sd	s1,56(sp)
    8000182e:	f84a                	sd	s2,48(sp)
    80001830:	f44e                	sd	s3,40(sp)
    80001832:	f052                	sd	s4,32(sp)
    80001834:	ec56                	sd	s5,24(sp)
    80001836:	e85a                	sd	s6,16(sp)
    80001838:	e45e                	sd	s7,8(sp)
    8000183a:	0880                	addi	s0,sp,80
    8000183c:	8aaa                	mv	s5,a0
    8000183e:	84ae                	mv	s1,a1
    80001840:	8bb2                	mv	s7,a2
    80001842:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001844:	7b7d                	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001846:	6a05                	lui	s4,0x1
    80001848:	a82d                	j	80001882 <copyinstr+0x5e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    8000184a:	00078023          	sb	zero,0(a5)
        got_null = 1;
    8000184e:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001850:	0017c793          	xori	a5,a5,1
    80001854:	40f0053b          	negw	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80001858:	60a6                	ld	ra,72(sp)
    8000185a:	6406                	ld	s0,64(sp)
    8000185c:	74e2                	ld	s1,56(sp)
    8000185e:	7942                	ld	s2,48(sp)
    80001860:	79a2                	ld	s3,40(sp)
    80001862:	7a02                	ld	s4,32(sp)
    80001864:	6ae2                	ld	s5,24(sp)
    80001866:	6b42                	ld	s6,16(sp)
    80001868:	6ba2                	ld	s7,8(sp)
    8000186a:	6161                	addi	sp,sp,80
    8000186c:	8082                	ret
    8000186e:	fff98713          	addi	a4,s3,-1 # fff <_entry-0x7ffff001>
    80001872:	9726                	add	a4,a4,s1
      --max;
    80001874:	40b709b3          	sub	s3,a4,a1
    srcva = va0 + PGSIZE;
    80001878:	01490bb3          	add	s7,s2,s4
  while(got_null == 0 && max > 0){
    8000187c:	04e58663          	beq	a1,a4,800018c8 <copyinstr+0xa4>
{
    80001880:	84be                	mv	s1,a5
    va0 = PGROUNDDOWN(srcva);
    80001882:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
    80001886:	85ca                	mv	a1,s2
    80001888:	8556                	mv	a0,s5
    8000188a:	00000097          	auipc	ra,0x0
    8000188e:	860080e7          	jalr	-1952(ra) # 800010ea <walkaddr>
    if(pa0 == 0)
    80001892:	cd0d                	beqz	a0,800018cc <copyinstr+0xa8>
    n = PGSIZE - (srcva - va0);
    80001894:	417906b3          	sub	a3,s2,s7
    80001898:	96d2                	add	a3,a3,s4
    if(n > max)
    8000189a:	00d9f363          	bgeu	s3,a3,800018a0 <copyinstr+0x7c>
    8000189e:	86ce                	mv	a3,s3
    while(n > 0){
    800018a0:	ca85                	beqz	a3,800018d0 <copyinstr+0xac>
    char *p = (char *) (pa0 + (srcva - va0));
    800018a2:	01750633          	add	a2,a0,s7
    800018a6:	41260633          	sub	a2,a2,s2
    800018aa:	87a6                	mv	a5,s1
      if(*p == '\0'){
    800018ac:	8e05                	sub	a2,a2,s1
    while(n > 0){
    800018ae:	96a6                	add	a3,a3,s1
    800018b0:	85be                	mv	a1,a5
      if(*p == '\0'){
    800018b2:	00f60733          	add	a4,a2,a5
    800018b6:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd9000>
    800018ba:	db41                	beqz	a4,8000184a <copyinstr+0x26>
        *dst = *p;
    800018bc:	00e78023          	sb	a4,0(a5)
      dst++;
    800018c0:	0785                	addi	a5,a5,1
    while(n > 0){
    800018c2:	fed797e3          	bne	a5,a3,800018b0 <copyinstr+0x8c>
    800018c6:	b765                	j	8000186e <copyinstr+0x4a>
    800018c8:	4781                	li	a5,0
    800018ca:	b759                	j	80001850 <copyinstr+0x2c>
      return -1;
    800018cc:	557d                	li	a0,-1
    800018ce:	b769                	j	80001858 <copyinstr+0x34>
    srcva = va0 + PGSIZE;
    800018d0:	6b85                	lui	s7,0x1
    800018d2:	9bca                	add	s7,s7,s2
    800018d4:	87a6                	mv	a5,s1
    800018d6:	b76d                	j	80001880 <copyinstr+0x5c>
  int got_null = 0;
    800018d8:	4781                	li	a5,0
  if(got_null){
    800018da:	0017c793          	xori	a5,a5,1
    800018de:	40f0053b          	negw	a0,a5
}
    800018e2:	8082                	ret

00000000800018e4 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    800018e4:	715d                	addi	sp,sp,-80
    800018e6:	e486                	sd	ra,72(sp)
    800018e8:	e0a2                	sd	s0,64(sp)
    800018ea:	fc26                	sd	s1,56(sp)
    800018ec:	f84a                	sd	s2,48(sp)
    800018ee:	f44e                	sd	s3,40(sp)
    800018f0:	f052                	sd	s4,32(sp)
    800018f2:	ec56                	sd	s5,24(sp)
    800018f4:	e85a                	sd	s6,16(sp)
    800018f6:	e45e                	sd	s7,8(sp)
    800018f8:	e062                	sd	s8,0(sp)
    800018fa:	0880                	addi	s0,sp,80
    800018fc:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    800018fe:	00010497          	auipc	s1,0x10
    80001902:	dd248493          	addi	s1,s1,-558 # 800116d0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80001906:	8c26                	mv	s8,s1
    80001908:	ff4df937          	lui	s2,0xff4df
    8000190c:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4b89bd>
    80001910:	0936                	slli	s2,s2,0xd
    80001912:	6f590913          	addi	s2,s2,1781
    80001916:	0936                	slli	s2,s2,0xd
    80001918:	bd390913          	addi	s2,s2,-1069
    8000191c:	0932                	slli	s2,s2,0xc
    8000191e:	7a790913          	addi	s2,s2,1959
    80001922:	040009b7          	lui	s3,0x4000
    80001926:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001928:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    8000192a:	4b99                	li	s7,6
    8000192c:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    8000192e:	00016a97          	auipc	s5,0x16
    80001932:	9a2a8a93          	addi	s5,s5,-1630 # 800172d0 <tickslock>
    char *pa = kalloc();
    80001936:	fffff097          	auipc	ra,0xfffff
    8000193a:	21a080e7          	jalr	538(ra) # 80000b50 <kalloc>
    8000193e:	862a                	mv	a2,a0
    if(pa == 0)
    80001940:	c131                	beqz	a0,80001984 <proc_mapstacks+0xa0>
    uint64 va = KSTACK((int) (p - proc));
    80001942:	418485b3          	sub	a1,s1,s8
    80001946:	8591                	srai	a1,a1,0x4
    80001948:	032585b3          	mul	a1,a1,s2
    8000194c:	05b6                	slli	a1,a1,0xd
    8000194e:	6789                	lui	a5,0x2
    80001950:	9dbd                	addw	a1,a1,a5
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001952:	875e                	mv	a4,s7
    80001954:	86da                	mv	a3,s6
    80001956:	40b985b3          	sub	a1,s3,a1
    8000195a:	8552                	mv	a0,s4
    8000195c:	00000097          	auipc	ra,0x0
    80001960:	86e080e7          	jalr	-1938(ra) # 800011ca <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001964:	17048493          	addi	s1,s1,368
    80001968:	fd5497e3          	bne	s1,s5,80001936 <proc_mapstacks+0x52>
  }
}
    8000196c:	60a6                	ld	ra,72(sp)
    8000196e:	6406                	ld	s0,64(sp)
    80001970:	74e2                	ld	s1,56(sp)
    80001972:	7942                	ld	s2,48(sp)
    80001974:	79a2                	ld	s3,40(sp)
    80001976:	7a02                	ld	s4,32(sp)
    80001978:	6ae2                	ld	s5,24(sp)
    8000197a:	6b42                	ld	s6,16(sp)
    8000197c:	6ba2                	ld	s7,8(sp)
    8000197e:	6c02                	ld	s8,0(sp)
    80001980:	6161                	addi	sp,sp,80
    80001982:	8082                	ret
      panic("kalloc");
    80001984:	00007517          	auipc	a0,0x7
    80001988:	83450513          	addi	a0,a0,-1996 # 800081b8 <etext+0x1b8>
    8000198c:	fffff097          	auipc	ra,0xfffff
    80001990:	bca080e7          	jalr	-1078(ra) # 80000556 <panic>

0000000080001994 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80001994:	7139                	addi	sp,sp,-64
    80001996:	fc06                	sd	ra,56(sp)
    80001998:	f822                	sd	s0,48(sp)
    8000199a:	f426                	sd	s1,40(sp)
    8000199c:	f04a                	sd	s2,32(sp)
    8000199e:	ec4e                	sd	s3,24(sp)
    800019a0:	e852                	sd	s4,16(sp)
    800019a2:	e456                	sd	s5,8(sp)
    800019a4:	e05a                	sd	s6,0(sp)
    800019a6:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    800019a8:	00007597          	auipc	a1,0x7
    800019ac:	81858593          	addi	a1,a1,-2024 # 800081c0 <etext+0x1c0>
    800019b0:	00010517          	auipc	a0,0x10
    800019b4:	8f050513          	addi	a0,a0,-1808 # 800112a0 <pid_lock>
    800019b8:	fffff097          	auipc	ra,0xfffff
    800019bc:	202080e7          	jalr	514(ra) # 80000bba <initlock>
  initlock(&wait_lock, "wait_lock");
    800019c0:	00007597          	auipc	a1,0x7
    800019c4:	80858593          	addi	a1,a1,-2040 # 800081c8 <etext+0x1c8>
    800019c8:	00010517          	auipc	a0,0x10
    800019cc:	8f050513          	addi	a0,a0,-1808 # 800112b8 <wait_lock>
    800019d0:	fffff097          	auipc	ra,0xfffff
    800019d4:	1ea080e7          	jalr	490(ra) # 80000bba <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    800019d8:	00010497          	auipc	s1,0x10
    800019dc:	cf848493          	addi	s1,s1,-776 # 800116d0 <proc>
      initlock(&p->lock, "proc");
    800019e0:	00006b17          	auipc	s6,0x6
    800019e4:	7f8b0b13          	addi	s6,s6,2040 # 800081d8 <etext+0x1d8>
      p->kstack = KSTACK((int) (p - proc));
    800019e8:	8aa6                	mv	s5,s1
    800019ea:	ff4df937          	lui	s2,0xff4df
    800019ee:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4b89bd>
    800019f2:	0936                	slli	s2,s2,0xd
    800019f4:	6f590913          	addi	s2,s2,1781
    800019f8:	0936                	slli	s2,s2,0xd
    800019fa:	bd390913          	addi	s2,s2,-1069
    800019fe:	0932                	slli	s2,s2,0xc
    80001a00:	7a790913          	addi	s2,s2,1959
    80001a04:	040009b7          	lui	s3,0x4000
    80001a08:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001a0a:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a0c:	00016a17          	auipc	s4,0x16
    80001a10:	8c4a0a13          	addi	s4,s4,-1852 # 800172d0 <tickslock>
      initlock(&p->lock, "proc");
    80001a14:	85da                	mv	a1,s6
    80001a16:	8526                	mv	a0,s1
    80001a18:	fffff097          	auipc	ra,0xfffff
    80001a1c:	1a2080e7          	jalr	418(ra) # 80000bba <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80001a20:	415487b3          	sub	a5,s1,s5
    80001a24:	8791                	srai	a5,a5,0x4
    80001a26:	032787b3          	mul	a5,a5,s2
    80001a2a:	07b6                	slli	a5,a5,0xd
    80001a2c:	6709                	lui	a4,0x2
    80001a2e:	9fb9                	addw	a5,a5,a4
    80001a30:	40f987b3          	sub	a5,s3,a5
    80001a34:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a36:	17048493          	addi	s1,s1,368
    80001a3a:	fd449de3          	bne	s1,s4,80001a14 <procinit+0x80>
  }
}
    80001a3e:	70e2                	ld	ra,56(sp)
    80001a40:	7442                	ld	s0,48(sp)
    80001a42:	74a2                	ld	s1,40(sp)
    80001a44:	7902                	ld	s2,32(sp)
    80001a46:	69e2                	ld	s3,24(sp)
    80001a48:	6a42                	ld	s4,16(sp)
    80001a4a:	6aa2                	ld	s5,8(sp)
    80001a4c:	6b02                	ld	s6,0(sp)
    80001a4e:	6121                	addi	sp,sp,64
    80001a50:	8082                	ret

0000000080001a52 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001a52:	1141                	addi	sp,sp,-16
    80001a54:	e406                	sd	ra,8(sp)
    80001a56:	e022                	sd	s0,0(sp)
    80001a58:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001a5a:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001a5c:	2501                	sext.w	a0,a0
    80001a5e:	60a2                	ld	ra,8(sp)
    80001a60:	6402                	ld	s0,0(sp)
    80001a62:	0141                	addi	sp,sp,16
    80001a64:	8082                	ret

0000000080001a66 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80001a66:	1141                	addi	sp,sp,-16
    80001a68:	e406                	sd	ra,8(sp)
    80001a6a:	e022                	sd	s0,0(sp)
    80001a6c:	0800                	addi	s0,sp,16
    80001a6e:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001a70:	2781                	sext.w	a5,a5
    80001a72:	079e                	slli	a5,a5,0x7
  return c;
}
    80001a74:	00010517          	auipc	a0,0x10
    80001a78:	85c50513          	addi	a0,a0,-1956 # 800112d0 <cpus>
    80001a7c:	953e                	add	a0,a0,a5
    80001a7e:	60a2                	ld	ra,8(sp)
    80001a80:	6402                	ld	s0,0(sp)
    80001a82:	0141                	addi	sp,sp,16
    80001a84:	8082                	ret

0000000080001a86 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80001a86:	1101                	addi	sp,sp,-32
    80001a88:	ec06                	sd	ra,24(sp)
    80001a8a:	e822                	sd	s0,16(sp)
    80001a8c:	e426                	sd	s1,8(sp)
    80001a8e:	1000                	addi	s0,sp,32
  push_off();
    80001a90:	fffff097          	auipc	ra,0xfffff
    80001a94:	174080e7          	jalr	372(ra) # 80000c04 <push_off>
    80001a98:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001a9a:	2781                	sext.w	a5,a5
    80001a9c:	079e                	slli	a5,a5,0x7
    80001a9e:	00010717          	auipc	a4,0x10
    80001aa2:	80270713          	addi	a4,a4,-2046 # 800112a0 <pid_lock>
    80001aa6:	97ba                	add	a5,a5,a4
    80001aa8:	7b9c                	ld	a5,48(a5)
    80001aaa:	84be                	mv	s1,a5
  pop_off();
    80001aac:	fffff097          	auipc	ra,0xfffff
    80001ab0:	1fc080e7          	jalr	508(ra) # 80000ca8 <pop_off>
  return p;
}
    80001ab4:	8526                	mv	a0,s1
    80001ab6:	60e2                	ld	ra,24(sp)
    80001ab8:	6442                	ld	s0,16(sp)
    80001aba:	64a2                	ld	s1,8(sp)
    80001abc:	6105                	addi	sp,sp,32
    80001abe:	8082                	ret

0000000080001ac0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001ac0:	1141                	addi	sp,sp,-16
    80001ac2:	e406                	sd	ra,8(sp)
    80001ac4:	e022                	sd	s0,0(sp)
    80001ac6:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001ac8:	00000097          	auipc	ra,0x0
    80001acc:	fbe080e7          	jalr	-66(ra) # 80001a86 <myproc>
    80001ad0:	fffff097          	auipc	ra,0xfffff
    80001ad4:	234080e7          	jalr	564(ra) # 80000d04 <release>

  if (first) {
    80001ad8:	00007797          	auipc	a5,0x7
    80001adc:	d487a783          	lw	a5,-696(a5) # 80008820 <first.1>
    80001ae0:	eb89                	bnez	a5,80001af2 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001ae2:	00001097          	auipc	ra,0x1
    80001ae6:	d88080e7          	jalr	-632(ra) # 8000286a <usertrapret>
}
    80001aea:	60a2                	ld	ra,8(sp)
    80001aec:	6402                	ld	s0,0(sp)
    80001aee:	0141                	addi	sp,sp,16
    80001af0:	8082                	ret
    first = 0;
    80001af2:	00007797          	auipc	a5,0x7
    80001af6:	d207a723          	sw	zero,-722(a5) # 80008820 <first.1>
    fsinit(ROOTDEV);
    80001afa:	4505                	li	a0,1
    80001afc:	00002097          	auipc	ra,0x2
    80001b00:	b0c080e7          	jalr	-1268(ra) # 80003608 <fsinit>
    80001b04:	bff9                	j	80001ae2 <forkret+0x22>

0000000080001b06 <allocpid>:
allocpid() {
    80001b06:	1101                	addi	sp,sp,-32
    80001b08:	ec06                	sd	ra,24(sp)
    80001b0a:	e822                	sd	s0,16(sp)
    80001b0c:	e426                	sd	s1,8(sp)
    80001b0e:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001b10:	0000f517          	auipc	a0,0xf
    80001b14:	79050513          	addi	a0,a0,1936 # 800112a0 <pid_lock>
    80001b18:	fffff097          	auipc	ra,0xfffff
    80001b1c:	13c080e7          	jalr	316(ra) # 80000c54 <acquire>
  pid = nextpid;
    80001b20:	00007797          	auipc	a5,0x7
    80001b24:	d0478793          	addi	a5,a5,-764 # 80008824 <nextpid>
    80001b28:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001b2a:	0014871b          	addiw	a4,s1,1
    80001b2e:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001b30:	0000f517          	auipc	a0,0xf
    80001b34:	77050513          	addi	a0,a0,1904 # 800112a0 <pid_lock>
    80001b38:	fffff097          	auipc	ra,0xfffff
    80001b3c:	1cc080e7          	jalr	460(ra) # 80000d04 <release>
}
    80001b40:	8526                	mv	a0,s1
    80001b42:	60e2                	ld	ra,24(sp)
    80001b44:	6442                	ld	s0,16(sp)
    80001b46:	64a2                	ld	s1,8(sp)
    80001b48:	6105                	addi	sp,sp,32
    80001b4a:	8082                	ret

0000000080001b4c <proc_pagetable>:
{
    80001b4c:	1101                	addi	sp,sp,-32
    80001b4e:	ec06                	sd	ra,24(sp)
    80001b50:	e822                	sd	s0,16(sp)
    80001b52:	e426                	sd	s1,8(sp)
    80001b54:	e04a                	sd	s2,0(sp)
    80001b56:	1000                	addi	s0,sp,32
    80001b58:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001b5a:	00000097          	auipc	ra,0x0
    80001b5e:	866080e7          	jalr	-1946(ra) # 800013c0 <uvmcreate>
    80001b62:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001b64:	c121                	beqz	a0,80001ba4 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001b66:	4729                	li	a4,10
    80001b68:	00005697          	auipc	a3,0x5
    80001b6c:	49868693          	addi	a3,a3,1176 # 80007000 <_trampoline>
    80001b70:	6605                	lui	a2,0x1
    80001b72:	040005b7          	lui	a1,0x4000
    80001b76:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001b78:	05b2                	slli	a1,a1,0xc
    80001b7a:	fffff097          	auipc	ra,0xfffff
    80001b7e:	5ae080e7          	jalr	1454(ra) # 80001128 <mappages>
    80001b82:	02054863          	bltz	a0,80001bb2 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001b86:	4719                	li	a4,6
    80001b88:	05893683          	ld	a3,88(s2)
    80001b8c:	6605                	lui	a2,0x1
    80001b8e:	020005b7          	lui	a1,0x2000
    80001b92:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001b94:	05b6                	slli	a1,a1,0xd
    80001b96:	8526                	mv	a0,s1
    80001b98:	fffff097          	auipc	ra,0xfffff
    80001b9c:	590080e7          	jalr	1424(ra) # 80001128 <mappages>
    80001ba0:	02054163          	bltz	a0,80001bc2 <proc_pagetable+0x76>
}
    80001ba4:	8526                	mv	a0,s1
    80001ba6:	60e2                	ld	ra,24(sp)
    80001ba8:	6442                	ld	s0,16(sp)
    80001baa:	64a2                	ld	s1,8(sp)
    80001bac:	6902                	ld	s2,0(sp)
    80001bae:	6105                	addi	sp,sp,32
    80001bb0:	8082                	ret
    uvmfree(pagetable, 0);
    80001bb2:	4581                	li	a1,0
    80001bb4:	8526                	mv	a0,s1
    80001bb6:	00000097          	auipc	ra,0x0
    80001bba:	a1a080e7          	jalr	-1510(ra) # 800015d0 <uvmfree>
    return 0;
    80001bbe:	4481                	li	s1,0
    80001bc0:	b7d5                	j	80001ba4 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001bc2:	4681                	li	a3,0
    80001bc4:	4605                	li	a2,1
    80001bc6:	040005b7          	lui	a1,0x4000
    80001bca:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001bcc:	05b2                	slli	a1,a1,0xc
    80001bce:	8526                	mv	a0,s1
    80001bd0:	fffff097          	auipc	ra,0xfffff
    80001bd4:	71c080e7          	jalr	1820(ra) # 800012ec <uvmunmap>
    uvmfree(pagetable, 0);
    80001bd8:	4581                	li	a1,0
    80001bda:	8526                	mv	a0,s1
    80001bdc:	00000097          	auipc	ra,0x0
    80001be0:	9f4080e7          	jalr	-1548(ra) # 800015d0 <uvmfree>
    return 0;
    80001be4:	4481                	li	s1,0
    80001be6:	bf7d                	j	80001ba4 <proc_pagetable+0x58>

0000000080001be8 <proc_freepagetable>:
{
    80001be8:	1101                	addi	sp,sp,-32
    80001bea:	ec06                	sd	ra,24(sp)
    80001bec:	e822                	sd	s0,16(sp)
    80001bee:	e426                	sd	s1,8(sp)
    80001bf0:	e04a                	sd	s2,0(sp)
    80001bf2:	1000                	addi	s0,sp,32
    80001bf4:	84aa                	mv	s1,a0
    80001bf6:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001bf8:	4681                	li	a3,0
    80001bfa:	4605                	li	a2,1
    80001bfc:	040005b7          	lui	a1,0x4000
    80001c00:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001c02:	05b2                	slli	a1,a1,0xc
    80001c04:	fffff097          	auipc	ra,0xfffff
    80001c08:	6e8080e7          	jalr	1768(ra) # 800012ec <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001c0c:	4681                	li	a3,0
    80001c0e:	4605                	li	a2,1
    80001c10:	020005b7          	lui	a1,0x2000
    80001c14:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001c16:	05b6                	slli	a1,a1,0xd
    80001c18:	8526                	mv	a0,s1
    80001c1a:	fffff097          	auipc	ra,0xfffff
    80001c1e:	6d2080e7          	jalr	1746(ra) # 800012ec <uvmunmap>
  uvmfree(pagetable, sz);
    80001c22:	85ca                	mv	a1,s2
    80001c24:	8526                	mv	a0,s1
    80001c26:	00000097          	auipc	ra,0x0
    80001c2a:	9aa080e7          	jalr	-1622(ra) # 800015d0 <uvmfree>
}
    80001c2e:	60e2                	ld	ra,24(sp)
    80001c30:	6442                	ld	s0,16(sp)
    80001c32:	64a2                	ld	s1,8(sp)
    80001c34:	6902                	ld	s2,0(sp)
    80001c36:	6105                	addi	sp,sp,32
    80001c38:	8082                	ret

0000000080001c3a <freeproc>:
{
    80001c3a:	1101                	addi	sp,sp,-32
    80001c3c:	ec06                	sd	ra,24(sp)
    80001c3e:	e822                	sd	s0,16(sp)
    80001c40:	e426                	sd	s1,8(sp)
    80001c42:	1000                	addi	s0,sp,32
    80001c44:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001c46:	6d28                	ld	a0,88(a0)
    80001c48:	c509                	beqz	a0,80001c52 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001c4a:	fffff097          	auipc	ra,0xfffff
    80001c4e:	e02080e7          	jalr	-510(ra) # 80000a4c <kfree>
  p->trapframe = 0;
    80001c52:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001c56:	68a8                	ld	a0,80(s1)
    80001c58:	c511                	beqz	a0,80001c64 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001c5a:	64ac                	ld	a1,72(s1)
    80001c5c:	00000097          	auipc	ra,0x0
    80001c60:	f8c080e7          	jalr	-116(ra) # 80001be8 <proc_freepagetable>
  p->pagetable = 0;
    80001c64:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001c68:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001c6c:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001c70:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001c74:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001c78:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001c7c:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001c80:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001c84:	0004ac23          	sw	zero,24(s1)
}
    80001c88:	60e2                	ld	ra,24(sp)
    80001c8a:	6442                	ld	s0,16(sp)
    80001c8c:	64a2                	ld	s1,8(sp)
    80001c8e:	6105                	addi	sp,sp,32
    80001c90:	8082                	ret

0000000080001c92 <allocproc>:
{
    80001c92:	1101                	addi	sp,sp,-32
    80001c94:	ec06                	sd	ra,24(sp)
    80001c96:	e822                	sd	s0,16(sp)
    80001c98:	e426                	sd	s1,8(sp)
    80001c9a:	e04a                	sd	s2,0(sp)
    80001c9c:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c9e:	00010497          	auipc	s1,0x10
    80001ca2:	a3248493          	addi	s1,s1,-1486 # 800116d0 <proc>
    80001ca6:	00015917          	auipc	s2,0x15
    80001caa:	62a90913          	addi	s2,s2,1578 # 800172d0 <tickslock>
    acquire(&p->lock);
    80001cae:	8526                	mv	a0,s1
    80001cb0:	fffff097          	auipc	ra,0xfffff
    80001cb4:	fa4080e7          	jalr	-92(ra) # 80000c54 <acquire>
    if(p->state == UNUSED) {
    80001cb8:	4c9c                	lw	a5,24(s1)
    80001cba:	cf81                	beqz	a5,80001cd2 <allocproc+0x40>
      release(&p->lock);
    80001cbc:	8526                	mv	a0,s1
    80001cbe:	fffff097          	auipc	ra,0xfffff
    80001cc2:	046080e7          	jalr	70(ra) # 80000d04 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001cc6:	17048493          	addi	s1,s1,368
    80001cca:	ff2492e3          	bne	s1,s2,80001cae <allocproc+0x1c>
  return 0;
    80001cce:	4481                	li	s1,0
    80001cd0:	a899                	j	80001d26 <allocproc+0x94>
  p->pid = allocpid();
    80001cd2:	00000097          	auipc	ra,0x0
    80001cd6:	e34080e7          	jalr	-460(ra) # 80001b06 <allocpid>
    80001cda:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001cdc:	4785                	li	a5,1
    80001cde:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001ce0:	fffff097          	auipc	ra,0xfffff
    80001ce4:	e70080e7          	jalr	-400(ra) # 80000b50 <kalloc>
    80001ce8:	892a                	mv	s2,a0
    80001cea:	eca8                	sd	a0,88(s1)
    80001cec:	c521                	beqz	a0,80001d34 <allocproc+0xa2>
  p->pagetable = proc_pagetable(p);
    80001cee:	8526                	mv	a0,s1
    80001cf0:	00000097          	auipc	ra,0x0
    80001cf4:	e5c080e7          	jalr	-420(ra) # 80001b4c <proc_pagetable>
    80001cf8:	892a                	mv	s2,a0
    80001cfa:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001cfc:	c921                	beqz	a0,80001d4c <allocproc+0xba>
  memset(&p->context, 0, sizeof(p->context));
    80001cfe:	07000613          	li	a2,112
    80001d02:	4581                	li	a1,0
    80001d04:	06048513          	addi	a0,s1,96
    80001d08:	fffff097          	auipc	ra,0xfffff
    80001d0c:	044080e7          	jalr	68(ra) # 80000d4c <memset>
  p->context.ra = (uint64)forkret;
    80001d10:	00000797          	auipc	a5,0x0
    80001d14:	db078793          	addi	a5,a5,-592 # 80001ac0 <forkret>
    80001d18:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001d1a:	60bc                	ld	a5,64(s1)
    80001d1c:	6705                	lui	a4,0x1
    80001d1e:	97ba                	add	a5,a5,a4
    80001d20:	f4bc                	sd	a5,104(s1)
  p->cputime = 0; // Initialize cputime to 0
    80001d22:	1604b423          	sd	zero,360(s1)
}
    80001d26:	8526                	mv	a0,s1
    80001d28:	60e2                	ld	ra,24(sp)
    80001d2a:	6442                	ld	s0,16(sp)
    80001d2c:	64a2                	ld	s1,8(sp)
    80001d2e:	6902                	ld	s2,0(sp)
    80001d30:	6105                	addi	sp,sp,32
    80001d32:	8082                	ret
    freeproc(p);
    80001d34:	8526                	mv	a0,s1
    80001d36:	00000097          	auipc	ra,0x0
    80001d3a:	f04080e7          	jalr	-252(ra) # 80001c3a <freeproc>
    release(&p->lock);
    80001d3e:	8526                	mv	a0,s1
    80001d40:	fffff097          	auipc	ra,0xfffff
    80001d44:	fc4080e7          	jalr	-60(ra) # 80000d04 <release>
    return 0;
    80001d48:	84ca                	mv	s1,s2
    80001d4a:	bff1                	j	80001d26 <allocproc+0x94>
    freeproc(p);
    80001d4c:	8526                	mv	a0,s1
    80001d4e:	00000097          	auipc	ra,0x0
    80001d52:	eec080e7          	jalr	-276(ra) # 80001c3a <freeproc>
    release(&p->lock);
    80001d56:	8526                	mv	a0,s1
    80001d58:	fffff097          	auipc	ra,0xfffff
    80001d5c:	fac080e7          	jalr	-84(ra) # 80000d04 <release>
    return 0;
    80001d60:	84ca                	mv	s1,s2
    80001d62:	b7d1                	j	80001d26 <allocproc+0x94>

0000000080001d64 <userinit>:
{
    80001d64:	1101                	addi	sp,sp,-32
    80001d66:	ec06                	sd	ra,24(sp)
    80001d68:	e822                	sd	s0,16(sp)
    80001d6a:	e426                	sd	s1,8(sp)
    80001d6c:	1000                	addi	s0,sp,32
  p = allocproc();
    80001d6e:	00000097          	auipc	ra,0x0
    80001d72:	f24080e7          	jalr	-220(ra) # 80001c92 <allocproc>
    80001d76:	84aa                	mv	s1,a0
  initproc = p;
    80001d78:	00007797          	auipc	a5,0x7
    80001d7c:	2aa7b823          	sd	a0,688(a5) # 80009028 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001d80:	03400613          	li	a2,52
    80001d84:	00007597          	auipc	a1,0x7
    80001d88:	aac58593          	addi	a1,a1,-1364 # 80008830 <initcode>
    80001d8c:	6928                	ld	a0,80(a0)
    80001d8e:	fffff097          	auipc	ra,0xfffff
    80001d92:	660080e7          	jalr	1632(ra) # 800013ee <uvminit>
  p->sz = PGSIZE;
    80001d96:	6785                	lui	a5,0x1
    80001d98:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001d9a:	6cb8                	ld	a4,88(s1)
    80001d9c:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001da0:	6cb8                	ld	a4,88(s1)
    80001da2:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001da4:	4641                	li	a2,16
    80001da6:	00006597          	auipc	a1,0x6
    80001daa:	43a58593          	addi	a1,a1,1082 # 800081e0 <etext+0x1e0>
    80001dae:	15848513          	addi	a0,s1,344
    80001db2:	fffff097          	auipc	ra,0xfffff
    80001db6:	0f2080e7          	jalr	242(ra) # 80000ea4 <safestrcpy>
  p->cwd = namei("/");
    80001dba:	00006517          	auipc	a0,0x6
    80001dbe:	43650513          	addi	a0,a0,1078 # 800081f0 <etext+0x1f0>
    80001dc2:	00002097          	auipc	ra,0x2
    80001dc6:	2aa080e7          	jalr	682(ra) # 8000406c <namei>
    80001dca:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001dce:	478d                	li	a5,3
    80001dd0:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001dd2:	8526                	mv	a0,s1
    80001dd4:	fffff097          	auipc	ra,0xfffff
    80001dd8:	f30080e7          	jalr	-208(ra) # 80000d04 <release>
}
    80001ddc:	60e2                	ld	ra,24(sp)
    80001dde:	6442                	ld	s0,16(sp)
    80001de0:	64a2                	ld	s1,8(sp)
    80001de2:	6105                	addi	sp,sp,32
    80001de4:	8082                	ret

0000000080001de6 <growproc>:
{
    80001de6:	1101                	addi	sp,sp,-32
    80001de8:	ec06                	sd	ra,24(sp)
    80001dea:	e822                	sd	s0,16(sp)
    80001dec:	e426                	sd	s1,8(sp)
    80001dee:	e04a                	sd	s2,0(sp)
    80001df0:	1000                	addi	s0,sp,32
    80001df2:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001df4:	00000097          	auipc	ra,0x0
    80001df8:	c92080e7          	jalr	-878(ra) # 80001a86 <myproc>
    80001dfc:	892a                	mv	s2,a0
  sz = p->sz;
    80001dfe:	652c                	ld	a1,72(a0)
    80001e00:	0005879b          	sext.w	a5,a1
  if(n > 0){
    80001e04:	00904f63          	bgtz	s1,80001e22 <growproc+0x3c>
  } else if(n < 0){
    80001e08:	0204cd63          	bltz	s1,80001e42 <growproc+0x5c>
  p->sz = sz;
    80001e0c:	1782                	slli	a5,a5,0x20
    80001e0e:	9381                	srli	a5,a5,0x20
    80001e10:	04f93423          	sd	a5,72(s2)
  return 0;
    80001e14:	4501                	li	a0,0
}
    80001e16:	60e2                	ld	ra,24(sp)
    80001e18:	6442                	ld	s0,16(sp)
    80001e1a:	64a2                	ld	s1,8(sp)
    80001e1c:	6902                	ld	s2,0(sp)
    80001e1e:	6105                	addi	sp,sp,32
    80001e20:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001e22:	00f4863b          	addw	a2,s1,a5
    80001e26:	1602                	slli	a2,a2,0x20
    80001e28:	9201                	srli	a2,a2,0x20
    80001e2a:	1582                	slli	a1,a1,0x20
    80001e2c:	9181                	srli	a1,a1,0x20
    80001e2e:	6928                	ld	a0,80(a0)
    80001e30:	fffff097          	auipc	ra,0xfffff
    80001e34:	678080e7          	jalr	1656(ra) # 800014a8 <uvmalloc>
    80001e38:	0005079b          	sext.w	a5,a0
    80001e3c:	fbe1                	bnez	a5,80001e0c <growproc+0x26>
      return -1;
    80001e3e:	557d                	li	a0,-1
    80001e40:	bfd9                	j	80001e16 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001e42:	00f4863b          	addw	a2,s1,a5
    80001e46:	1602                	slli	a2,a2,0x20
    80001e48:	9201                	srli	a2,a2,0x20
    80001e4a:	1582                	slli	a1,a1,0x20
    80001e4c:	9181                	srli	a1,a1,0x20
    80001e4e:	6928                	ld	a0,80(a0)
    80001e50:	fffff097          	auipc	ra,0xfffff
    80001e54:	610080e7          	jalr	1552(ra) # 80001460 <uvmdealloc>
    80001e58:	0005079b          	sext.w	a5,a0
    80001e5c:	bf45                	j	80001e0c <growproc+0x26>

0000000080001e5e <fork>:
{
    80001e5e:	7139                	addi	sp,sp,-64
    80001e60:	fc06                	sd	ra,56(sp)
    80001e62:	f822                	sd	s0,48(sp)
    80001e64:	f426                	sd	s1,40(sp)
    80001e66:	e456                	sd	s5,8(sp)
    80001e68:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001e6a:	00000097          	auipc	ra,0x0
    80001e6e:	c1c080e7          	jalr	-996(ra) # 80001a86 <myproc>
    80001e72:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001e74:	00000097          	auipc	ra,0x0
    80001e78:	e1e080e7          	jalr	-482(ra) # 80001c92 <allocproc>
    80001e7c:	12050063          	beqz	a0,80001f9c <fork+0x13e>
    80001e80:	e852                	sd	s4,16(sp)
    80001e82:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001e84:	048ab603          	ld	a2,72(s5)
    80001e88:	692c                	ld	a1,80(a0)
    80001e8a:	050ab503          	ld	a0,80(s5)
    80001e8e:	fffff097          	auipc	ra,0xfffff
    80001e92:	77c080e7          	jalr	1916(ra) # 8000160a <uvmcopy>
    80001e96:	04054863          	bltz	a0,80001ee6 <fork+0x88>
    80001e9a:	f04a                	sd	s2,32(sp)
    80001e9c:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80001e9e:	048ab783          	ld	a5,72(s5)
    80001ea2:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001ea6:	058ab683          	ld	a3,88(s5)
    80001eaa:	87b6                	mv	a5,a3
    80001eac:	058a3703          	ld	a4,88(s4)
    80001eb0:	12068693          	addi	a3,a3,288
    80001eb4:	6388                	ld	a0,0(a5)
    80001eb6:	678c                	ld	a1,8(a5)
    80001eb8:	6b90                	ld	a2,16(a5)
    80001eba:	e308                	sd	a0,0(a4)
    80001ebc:	e70c                	sd	a1,8(a4)
    80001ebe:	eb10                	sd	a2,16(a4)
    80001ec0:	6f90                	ld	a2,24(a5)
    80001ec2:	ef10                	sd	a2,24(a4)
    80001ec4:	02078793          	addi	a5,a5,32 # 1020 <_entry-0x7fffefe0>
    80001ec8:	02070713          	addi	a4,a4,32
    80001ecc:	fed794e3          	bne	a5,a3,80001eb4 <fork+0x56>
  np->trapframe->a0 = 0;
    80001ed0:	058a3783          	ld	a5,88(s4)
    80001ed4:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001ed8:	0d0a8493          	addi	s1,s5,208
    80001edc:	0d0a0913          	addi	s2,s4,208
    80001ee0:	150a8993          	addi	s3,s5,336
    80001ee4:	a015                	j	80001f08 <fork+0xaa>
    freeproc(np);
    80001ee6:	8552                	mv	a0,s4
    80001ee8:	00000097          	auipc	ra,0x0
    80001eec:	d52080e7          	jalr	-686(ra) # 80001c3a <freeproc>
    release(&np->lock);
    80001ef0:	8552                	mv	a0,s4
    80001ef2:	fffff097          	auipc	ra,0xfffff
    80001ef6:	e12080e7          	jalr	-494(ra) # 80000d04 <release>
    return -1;
    80001efa:	54fd                	li	s1,-1
    80001efc:	6a42                	ld	s4,16(sp)
    80001efe:	a841                	j	80001f8e <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    80001f00:	04a1                	addi	s1,s1,8
    80001f02:	0921                	addi	s2,s2,8
    80001f04:	01348b63          	beq	s1,s3,80001f1a <fork+0xbc>
    if(p->ofile[i])
    80001f08:	6088                	ld	a0,0(s1)
    80001f0a:	d97d                	beqz	a0,80001f00 <fork+0xa2>
      np->ofile[i] = filedup(p->ofile[i]);
    80001f0c:	00002097          	auipc	ra,0x2
    80001f10:	7f6080e7          	jalr	2038(ra) # 80004702 <filedup>
    80001f14:	00a93023          	sd	a0,0(s2)
    80001f18:	b7e5                	j	80001f00 <fork+0xa2>
  np->cwd = idup(p->cwd);
    80001f1a:	150ab503          	ld	a0,336(s5)
    80001f1e:	00002097          	auipc	ra,0x2
    80001f22:	91e080e7          	jalr	-1762(ra) # 8000383c <idup>
    80001f26:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001f2a:	4641                	li	a2,16
    80001f2c:	158a8593          	addi	a1,s5,344
    80001f30:	158a0513          	addi	a0,s4,344
    80001f34:	fffff097          	auipc	ra,0xfffff
    80001f38:	f70080e7          	jalr	-144(ra) # 80000ea4 <safestrcpy>
  pid = np->pid;
    80001f3c:	030a2483          	lw	s1,48(s4)
  release(&np->lock);
    80001f40:	8552                	mv	a0,s4
    80001f42:	fffff097          	auipc	ra,0xfffff
    80001f46:	dc2080e7          	jalr	-574(ra) # 80000d04 <release>
  acquire(&wait_lock);
    80001f4a:	0000f517          	auipc	a0,0xf
    80001f4e:	36e50513          	addi	a0,a0,878 # 800112b8 <wait_lock>
    80001f52:	fffff097          	auipc	ra,0xfffff
    80001f56:	d02080e7          	jalr	-766(ra) # 80000c54 <acquire>
  np->parent = p;
    80001f5a:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001f5e:	0000f517          	auipc	a0,0xf
    80001f62:	35a50513          	addi	a0,a0,858 # 800112b8 <wait_lock>
    80001f66:	fffff097          	auipc	ra,0xfffff
    80001f6a:	d9e080e7          	jalr	-610(ra) # 80000d04 <release>
  acquire(&np->lock);
    80001f6e:	8552                	mv	a0,s4
    80001f70:	fffff097          	auipc	ra,0xfffff
    80001f74:	ce4080e7          	jalr	-796(ra) # 80000c54 <acquire>
  np->state = RUNNABLE;
    80001f78:	478d                	li	a5,3
    80001f7a:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001f7e:	8552                	mv	a0,s4
    80001f80:	fffff097          	auipc	ra,0xfffff
    80001f84:	d84080e7          	jalr	-636(ra) # 80000d04 <release>
  return pid;
    80001f88:	7902                	ld	s2,32(sp)
    80001f8a:	69e2                	ld	s3,24(sp)
    80001f8c:	6a42                	ld	s4,16(sp)
}
    80001f8e:	8526                	mv	a0,s1
    80001f90:	70e2                	ld	ra,56(sp)
    80001f92:	7442                	ld	s0,48(sp)
    80001f94:	74a2                	ld	s1,40(sp)
    80001f96:	6aa2                	ld	s5,8(sp)
    80001f98:	6121                	addi	sp,sp,64
    80001f9a:	8082                	ret
    return -1;
    80001f9c:	54fd                	li	s1,-1
    80001f9e:	bfc5                	j	80001f8e <fork+0x130>

0000000080001fa0 <scheduler>:
{
    80001fa0:	7139                	addi	sp,sp,-64
    80001fa2:	fc06                	sd	ra,56(sp)
    80001fa4:	f822                	sd	s0,48(sp)
    80001fa6:	f426                	sd	s1,40(sp)
    80001fa8:	f04a                	sd	s2,32(sp)
    80001faa:	ec4e                	sd	s3,24(sp)
    80001fac:	e852                	sd	s4,16(sp)
    80001fae:	e456                	sd	s5,8(sp)
    80001fb0:	e05a                	sd	s6,0(sp)
    80001fb2:	0080                	addi	s0,sp,64
    80001fb4:	8792                	mv	a5,tp
  int id = r_tp();
    80001fb6:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001fb8:	00779a93          	slli	s5,a5,0x7
    80001fbc:	0000f717          	auipc	a4,0xf
    80001fc0:	2e470713          	addi	a4,a4,740 # 800112a0 <pid_lock>
    80001fc4:	9756                	add	a4,a4,s5
    80001fc6:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001fca:	0000f717          	auipc	a4,0xf
    80001fce:	30e70713          	addi	a4,a4,782 # 800112d8 <cpus+0x8>
    80001fd2:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001fd4:	498d                	li	s3,3
        p->state = RUNNING;
    80001fd6:	4b11                	li	s6,4
        c->proc = p;
    80001fd8:	079e                	slli	a5,a5,0x7
    80001fda:	0000fa17          	auipc	s4,0xf
    80001fde:	2c6a0a13          	addi	s4,s4,710 # 800112a0 <pid_lock>
    80001fe2:	9a3e                	add	s4,s4,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fe4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001fe8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001fec:	10079073          	csrw	sstatus,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001ff0:	0000f497          	auipc	s1,0xf
    80001ff4:	6e048493          	addi	s1,s1,1760 # 800116d0 <proc>
    80001ff8:	00015917          	auipc	s2,0x15
    80001ffc:	2d890913          	addi	s2,s2,728 # 800172d0 <tickslock>
    80002000:	a811                	j	80002014 <scheduler+0x74>
      release(&p->lock);
    80002002:	8526                	mv	a0,s1
    80002004:	fffff097          	auipc	ra,0xfffff
    80002008:	d00080e7          	jalr	-768(ra) # 80000d04 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000200c:	17048493          	addi	s1,s1,368
    80002010:	fd248ae3          	beq	s1,s2,80001fe4 <scheduler+0x44>
      acquire(&p->lock);
    80002014:	8526                	mv	a0,s1
    80002016:	fffff097          	auipc	ra,0xfffff
    8000201a:	c3e080e7          	jalr	-962(ra) # 80000c54 <acquire>
      if(p->state == RUNNABLE) {
    8000201e:	4c9c                	lw	a5,24(s1)
    80002020:	ff3791e3          	bne	a5,s3,80002002 <scheduler+0x62>
        p->state = RUNNING;
    80002024:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80002028:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000202c:	06048593          	addi	a1,s1,96
    80002030:	8556                	mv	a0,s5
    80002032:	00000097          	auipc	ra,0x0
    80002036:	78a080e7          	jalr	1930(ra) # 800027bc <swtch>
        c->proc = 0;
    8000203a:	020a3823          	sd	zero,48(s4)
    8000203e:	b7d1                	j	80002002 <scheduler+0x62>

0000000080002040 <sched>:
{
    80002040:	7179                	addi	sp,sp,-48
    80002042:	f406                	sd	ra,40(sp)
    80002044:	f022                	sd	s0,32(sp)
    80002046:	ec26                	sd	s1,24(sp)
    80002048:	e84a                	sd	s2,16(sp)
    8000204a:	e44e                	sd	s3,8(sp)
    8000204c:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000204e:	00000097          	auipc	ra,0x0
    80002052:	a38080e7          	jalr	-1480(ra) # 80001a86 <myproc>
    80002056:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80002058:	fffff097          	auipc	ra,0xfffff
    8000205c:	b7c080e7          	jalr	-1156(ra) # 80000bd4 <holding>
    80002060:	cd25                	beqz	a0,800020d8 <sched+0x98>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002062:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80002064:	2781                	sext.w	a5,a5
    80002066:	079e                	slli	a5,a5,0x7
    80002068:	0000f717          	auipc	a4,0xf
    8000206c:	23870713          	addi	a4,a4,568 # 800112a0 <pid_lock>
    80002070:	97ba                	add	a5,a5,a4
    80002072:	0a87a703          	lw	a4,168(a5)
    80002076:	4785                	li	a5,1
    80002078:	06f71863          	bne	a4,a5,800020e8 <sched+0xa8>
  if(p->state == RUNNING)
    8000207c:	4c98                	lw	a4,24(s1)
    8000207e:	4791                	li	a5,4
    80002080:	06f70c63          	beq	a4,a5,800020f8 <sched+0xb8>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002084:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002088:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000208a:	efbd                	bnez	a5,80002108 <sched+0xc8>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000208c:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000208e:	0000f917          	auipc	s2,0xf
    80002092:	21290913          	addi	s2,s2,530 # 800112a0 <pid_lock>
    80002096:	2781                	sext.w	a5,a5
    80002098:	079e                	slli	a5,a5,0x7
    8000209a:	97ca                	add	a5,a5,s2
    8000209c:	0ac7a983          	lw	s3,172(a5)
    800020a0:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800020a2:	2781                	sext.w	a5,a5
    800020a4:	079e                	slli	a5,a5,0x7
    800020a6:	07a1                	addi	a5,a5,8
    800020a8:	0000f597          	auipc	a1,0xf
    800020ac:	22858593          	addi	a1,a1,552 # 800112d0 <cpus>
    800020b0:	95be                	add	a1,a1,a5
    800020b2:	06048513          	addi	a0,s1,96
    800020b6:	00000097          	auipc	ra,0x0
    800020ba:	706080e7          	jalr	1798(ra) # 800027bc <swtch>
    800020be:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800020c0:	2781                	sext.w	a5,a5
    800020c2:	079e                	slli	a5,a5,0x7
    800020c4:	993e                	add	s2,s2,a5
    800020c6:	0b392623          	sw	s3,172(s2)
}
    800020ca:	70a2                	ld	ra,40(sp)
    800020cc:	7402                	ld	s0,32(sp)
    800020ce:	64e2                	ld	s1,24(sp)
    800020d0:	6942                	ld	s2,16(sp)
    800020d2:	69a2                	ld	s3,8(sp)
    800020d4:	6145                	addi	sp,sp,48
    800020d6:	8082                	ret
    panic("sched p->lock");
    800020d8:	00006517          	auipc	a0,0x6
    800020dc:	12050513          	addi	a0,a0,288 # 800081f8 <etext+0x1f8>
    800020e0:	ffffe097          	auipc	ra,0xffffe
    800020e4:	476080e7          	jalr	1142(ra) # 80000556 <panic>
    panic("sched locks");
    800020e8:	00006517          	auipc	a0,0x6
    800020ec:	12050513          	addi	a0,a0,288 # 80008208 <etext+0x208>
    800020f0:	ffffe097          	auipc	ra,0xffffe
    800020f4:	466080e7          	jalr	1126(ra) # 80000556 <panic>
    panic("sched running");
    800020f8:	00006517          	auipc	a0,0x6
    800020fc:	12050513          	addi	a0,a0,288 # 80008218 <etext+0x218>
    80002100:	ffffe097          	auipc	ra,0xffffe
    80002104:	456080e7          	jalr	1110(ra) # 80000556 <panic>
    panic("sched interruptible");
    80002108:	00006517          	auipc	a0,0x6
    8000210c:	12050513          	addi	a0,a0,288 # 80008228 <etext+0x228>
    80002110:	ffffe097          	auipc	ra,0xffffe
    80002114:	446080e7          	jalr	1094(ra) # 80000556 <panic>

0000000080002118 <yield>:
{
    80002118:	1101                	addi	sp,sp,-32
    8000211a:	ec06                	sd	ra,24(sp)
    8000211c:	e822                	sd	s0,16(sp)
    8000211e:	e426                	sd	s1,8(sp)
    80002120:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002122:	00000097          	auipc	ra,0x0
    80002126:	964080e7          	jalr	-1692(ra) # 80001a86 <myproc>
    8000212a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000212c:	fffff097          	auipc	ra,0xfffff
    80002130:	b28080e7          	jalr	-1240(ra) # 80000c54 <acquire>
  p->state = RUNNABLE;
    80002134:	478d                	li	a5,3
    80002136:	cc9c                	sw	a5,24(s1)
  sched();
    80002138:	00000097          	auipc	ra,0x0
    8000213c:	f08080e7          	jalr	-248(ra) # 80002040 <sched>
  release(&p->lock);
    80002140:	8526                	mv	a0,s1
    80002142:	fffff097          	auipc	ra,0xfffff
    80002146:	bc2080e7          	jalr	-1086(ra) # 80000d04 <release>
}
    8000214a:	60e2                	ld	ra,24(sp)
    8000214c:	6442                	ld	s0,16(sp)
    8000214e:	64a2                	ld	s1,8(sp)
    80002150:	6105                	addi	sp,sp,32
    80002152:	8082                	ret

0000000080002154 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80002154:	7179                	addi	sp,sp,-48
    80002156:	f406                	sd	ra,40(sp)
    80002158:	f022                	sd	s0,32(sp)
    8000215a:	ec26                	sd	s1,24(sp)
    8000215c:	e84a                	sd	s2,16(sp)
    8000215e:	e44e                	sd	s3,8(sp)
    80002160:	1800                	addi	s0,sp,48
    80002162:	89aa                	mv	s3,a0
    80002164:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002166:	00000097          	auipc	ra,0x0
    8000216a:	920080e7          	jalr	-1760(ra) # 80001a86 <myproc>
    8000216e:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80002170:	fffff097          	auipc	ra,0xfffff
    80002174:	ae4080e7          	jalr	-1308(ra) # 80000c54 <acquire>
  release(lk);
    80002178:	854a                	mv	a0,s2
    8000217a:	fffff097          	auipc	ra,0xfffff
    8000217e:	b8a080e7          	jalr	-1142(ra) # 80000d04 <release>

  // Go to sleep.
  p->chan = chan;
    80002182:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80002186:	4789                	li	a5,2
    80002188:	cc9c                	sw	a5,24(s1)

  sched();
    8000218a:	00000097          	auipc	ra,0x0
    8000218e:	eb6080e7          	jalr	-330(ra) # 80002040 <sched>

  // Tidy up.
  p->chan = 0;
    80002192:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80002196:	8526                	mv	a0,s1
    80002198:	fffff097          	auipc	ra,0xfffff
    8000219c:	b6c080e7          	jalr	-1172(ra) # 80000d04 <release>
  acquire(lk);
    800021a0:	854a                	mv	a0,s2
    800021a2:	fffff097          	auipc	ra,0xfffff
    800021a6:	ab2080e7          	jalr	-1358(ra) # 80000c54 <acquire>
}
    800021aa:	70a2                	ld	ra,40(sp)
    800021ac:	7402                	ld	s0,32(sp)
    800021ae:	64e2                	ld	s1,24(sp)
    800021b0:	6942                	ld	s2,16(sp)
    800021b2:	69a2                	ld	s3,8(sp)
    800021b4:	6145                	addi	sp,sp,48
    800021b6:	8082                	ret

00000000800021b8 <wait>:
{
    800021b8:	715d                	addi	sp,sp,-80
    800021ba:	e486                	sd	ra,72(sp)
    800021bc:	e0a2                	sd	s0,64(sp)
    800021be:	fc26                	sd	s1,56(sp)
    800021c0:	f84a                	sd	s2,48(sp)
    800021c2:	f44e                	sd	s3,40(sp)
    800021c4:	f052                	sd	s4,32(sp)
    800021c6:	ec56                	sd	s5,24(sp)
    800021c8:	e85a                	sd	s6,16(sp)
    800021ca:	e45e                	sd	s7,8(sp)
    800021cc:	0880                	addi	s0,sp,80
    800021ce:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    800021d0:	00000097          	auipc	ra,0x0
    800021d4:	8b6080e7          	jalr	-1866(ra) # 80001a86 <myproc>
    800021d8:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800021da:	0000f517          	auipc	a0,0xf
    800021de:	0de50513          	addi	a0,a0,222 # 800112b8 <wait_lock>
    800021e2:	fffff097          	auipc	ra,0xfffff
    800021e6:	a72080e7          	jalr	-1422(ra) # 80000c54 <acquire>
        if(np->state == ZOMBIE){
    800021ea:	4a15                	li	s4,5
        havekids = 1;
    800021ec:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    800021ee:	00015997          	auipc	s3,0x15
    800021f2:	0e298993          	addi	s3,s3,226 # 800172d0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800021f6:	0000fb17          	auipc	s6,0xf
    800021fa:	0c2b0b13          	addi	s6,s6,194 # 800112b8 <wait_lock>
    800021fe:	a875                	j	800022ba <wait+0x102>
          pid = np->pid;
    80002200:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80002204:	000b8e63          	beqz	s7,80002220 <wait+0x68>
    80002208:	4691                	li	a3,4
    8000220a:	02c48613          	addi	a2,s1,44
    8000220e:	85de                	mv	a1,s7
    80002210:	05093503          	ld	a0,80(s2)
    80002214:	fffff097          	auipc	ra,0xfffff
    80002218:	4f6080e7          	jalr	1270(ra) # 8000170a <copyout>
    8000221c:	04054063          	bltz	a0,8000225c <wait+0xa4>
          freeproc(np);
    80002220:	8526                	mv	a0,s1
    80002222:	00000097          	auipc	ra,0x0
    80002226:	a18080e7          	jalr	-1512(ra) # 80001c3a <freeproc>
          release(&np->lock);
    8000222a:	8526                	mv	a0,s1
    8000222c:	fffff097          	auipc	ra,0xfffff
    80002230:	ad8080e7          	jalr	-1320(ra) # 80000d04 <release>
          release(&wait_lock);
    80002234:	0000f517          	auipc	a0,0xf
    80002238:	08450513          	addi	a0,a0,132 # 800112b8 <wait_lock>
    8000223c:	fffff097          	auipc	ra,0xfffff
    80002240:	ac8080e7          	jalr	-1336(ra) # 80000d04 <release>
}
    80002244:	854e                	mv	a0,s3
    80002246:	60a6                	ld	ra,72(sp)
    80002248:	6406                	ld	s0,64(sp)
    8000224a:	74e2                	ld	s1,56(sp)
    8000224c:	7942                	ld	s2,48(sp)
    8000224e:	79a2                	ld	s3,40(sp)
    80002250:	7a02                	ld	s4,32(sp)
    80002252:	6ae2                	ld	s5,24(sp)
    80002254:	6b42                	ld	s6,16(sp)
    80002256:	6ba2                	ld	s7,8(sp)
    80002258:	6161                	addi	sp,sp,80
    8000225a:	8082                	ret
            release(&np->lock);
    8000225c:	8526                	mv	a0,s1
    8000225e:	fffff097          	auipc	ra,0xfffff
    80002262:	aa6080e7          	jalr	-1370(ra) # 80000d04 <release>
            release(&wait_lock);
    80002266:	0000f517          	auipc	a0,0xf
    8000226a:	05250513          	addi	a0,a0,82 # 800112b8 <wait_lock>
    8000226e:	fffff097          	auipc	ra,0xfffff
    80002272:	a96080e7          	jalr	-1386(ra) # 80000d04 <release>
            return -1;
    80002276:	59fd                	li	s3,-1
    80002278:	b7f1                	j	80002244 <wait+0x8c>
    for(np = proc; np < &proc[NPROC]; np++){
    8000227a:	17048493          	addi	s1,s1,368
    8000227e:	03348463          	beq	s1,s3,800022a6 <wait+0xee>
      if(np->parent == p){
    80002282:	7c9c                	ld	a5,56(s1)
    80002284:	ff279be3          	bne	a5,s2,8000227a <wait+0xc2>
        acquire(&np->lock);
    80002288:	8526                	mv	a0,s1
    8000228a:	fffff097          	auipc	ra,0xfffff
    8000228e:	9ca080e7          	jalr	-1590(ra) # 80000c54 <acquire>
        if(np->state == ZOMBIE){
    80002292:	4c9c                	lw	a5,24(s1)
    80002294:	f74786e3          	beq	a5,s4,80002200 <wait+0x48>
        release(&np->lock);
    80002298:	8526                	mv	a0,s1
    8000229a:	fffff097          	auipc	ra,0xfffff
    8000229e:	a6a080e7          	jalr	-1430(ra) # 80000d04 <release>
        havekids = 1;
    800022a2:	8756                	mv	a4,s5
    800022a4:	bfd9                	j	8000227a <wait+0xc2>
    if(!havekids || p->killed){
    800022a6:	c305                	beqz	a4,800022c6 <wait+0x10e>
    800022a8:	02892783          	lw	a5,40(s2)
    800022ac:	ef89                	bnez	a5,800022c6 <wait+0x10e>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800022ae:	85da                	mv	a1,s6
    800022b0:	854a                	mv	a0,s2
    800022b2:	00000097          	auipc	ra,0x0
    800022b6:	ea2080e7          	jalr	-350(ra) # 80002154 <sleep>
    havekids = 0;
    800022ba:	4701                	li	a4,0
    for(np = proc; np < &proc[NPROC]; np++){
    800022bc:	0000f497          	auipc	s1,0xf
    800022c0:	41448493          	addi	s1,s1,1044 # 800116d0 <proc>
    800022c4:	bf7d                	j	80002282 <wait+0xca>
      release(&wait_lock);
    800022c6:	0000f517          	auipc	a0,0xf
    800022ca:	ff250513          	addi	a0,a0,-14 # 800112b8 <wait_lock>
    800022ce:	fffff097          	auipc	ra,0xfffff
    800022d2:	a36080e7          	jalr	-1482(ra) # 80000d04 <release>
      return -1;
    800022d6:	59fd                	li	s3,-1
    800022d8:	b7b5                	j	80002244 <wait+0x8c>

00000000800022da <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800022da:	7139                	addi	sp,sp,-64
    800022dc:	fc06                	sd	ra,56(sp)
    800022de:	f822                	sd	s0,48(sp)
    800022e0:	f426                	sd	s1,40(sp)
    800022e2:	f04a                	sd	s2,32(sp)
    800022e4:	ec4e                	sd	s3,24(sp)
    800022e6:	e852                	sd	s4,16(sp)
    800022e8:	e456                	sd	s5,8(sp)
    800022ea:	0080                	addi	s0,sp,64
    800022ec:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800022ee:	0000f497          	auipc	s1,0xf
    800022f2:	3e248493          	addi	s1,s1,994 # 800116d0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800022f6:	4989                	li	s3,2
        p->state = RUNNABLE;
    800022f8:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800022fa:	00015917          	auipc	s2,0x15
    800022fe:	fd690913          	addi	s2,s2,-42 # 800172d0 <tickslock>
    80002302:	a811                	j	80002316 <wakeup+0x3c>
      }
      release(&p->lock);
    80002304:	8526                	mv	a0,s1
    80002306:	fffff097          	auipc	ra,0xfffff
    8000230a:	9fe080e7          	jalr	-1538(ra) # 80000d04 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000230e:	17048493          	addi	s1,s1,368
    80002312:	03248663          	beq	s1,s2,8000233e <wakeup+0x64>
    if(p != myproc()){
    80002316:	fffff097          	auipc	ra,0xfffff
    8000231a:	770080e7          	jalr	1904(ra) # 80001a86 <myproc>
    8000231e:	fe9508e3          	beq	a0,s1,8000230e <wakeup+0x34>
      acquire(&p->lock);
    80002322:	8526                	mv	a0,s1
    80002324:	fffff097          	auipc	ra,0xfffff
    80002328:	930080e7          	jalr	-1744(ra) # 80000c54 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000232c:	4c9c                	lw	a5,24(s1)
    8000232e:	fd379be3          	bne	a5,s3,80002304 <wakeup+0x2a>
    80002332:	709c                	ld	a5,32(s1)
    80002334:	fd4798e3          	bne	a5,s4,80002304 <wakeup+0x2a>
        p->state = RUNNABLE;
    80002338:	0154ac23          	sw	s5,24(s1)
    8000233c:	b7e1                	j	80002304 <wakeup+0x2a>
    }
  }
}
    8000233e:	70e2                	ld	ra,56(sp)
    80002340:	7442                	ld	s0,48(sp)
    80002342:	74a2                	ld	s1,40(sp)
    80002344:	7902                	ld	s2,32(sp)
    80002346:	69e2                	ld	s3,24(sp)
    80002348:	6a42                	ld	s4,16(sp)
    8000234a:	6aa2                	ld	s5,8(sp)
    8000234c:	6121                	addi	sp,sp,64
    8000234e:	8082                	ret

0000000080002350 <reparent>:
{
    80002350:	7179                	addi	sp,sp,-48
    80002352:	f406                	sd	ra,40(sp)
    80002354:	f022                	sd	s0,32(sp)
    80002356:	ec26                	sd	s1,24(sp)
    80002358:	e84a                	sd	s2,16(sp)
    8000235a:	e44e                	sd	s3,8(sp)
    8000235c:	e052                	sd	s4,0(sp)
    8000235e:	1800                	addi	s0,sp,48
    80002360:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002362:	0000f497          	auipc	s1,0xf
    80002366:	36e48493          	addi	s1,s1,878 # 800116d0 <proc>
      pp->parent = initproc;
    8000236a:	00007a17          	auipc	s4,0x7
    8000236e:	cbea0a13          	addi	s4,s4,-834 # 80009028 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002372:	00015997          	auipc	s3,0x15
    80002376:	f5e98993          	addi	s3,s3,-162 # 800172d0 <tickslock>
    8000237a:	a029                	j	80002384 <reparent+0x34>
    8000237c:	17048493          	addi	s1,s1,368
    80002380:	01348d63          	beq	s1,s3,8000239a <reparent+0x4a>
    if(pp->parent == p){
    80002384:	7c9c                	ld	a5,56(s1)
    80002386:	ff279be3          	bne	a5,s2,8000237c <reparent+0x2c>
      pp->parent = initproc;
    8000238a:	000a3503          	ld	a0,0(s4)
    8000238e:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80002390:	00000097          	auipc	ra,0x0
    80002394:	f4a080e7          	jalr	-182(ra) # 800022da <wakeup>
    80002398:	b7d5                	j	8000237c <reparent+0x2c>
}
    8000239a:	70a2                	ld	ra,40(sp)
    8000239c:	7402                	ld	s0,32(sp)
    8000239e:	64e2                	ld	s1,24(sp)
    800023a0:	6942                	ld	s2,16(sp)
    800023a2:	69a2                	ld	s3,8(sp)
    800023a4:	6a02                	ld	s4,0(sp)
    800023a6:	6145                	addi	sp,sp,48
    800023a8:	8082                	ret

00000000800023aa <exit>:
{
    800023aa:	7179                	addi	sp,sp,-48
    800023ac:	f406                	sd	ra,40(sp)
    800023ae:	f022                	sd	s0,32(sp)
    800023b0:	ec26                	sd	s1,24(sp)
    800023b2:	e84a                	sd	s2,16(sp)
    800023b4:	e44e                	sd	s3,8(sp)
    800023b6:	e052                	sd	s4,0(sp)
    800023b8:	1800                	addi	s0,sp,48
    800023ba:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800023bc:	fffff097          	auipc	ra,0xfffff
    800023c0:	6ca080e7          	jalr	1738(ra) # 80001a86 <myproc>
    800023c4:	89aa                	mv	s3,a0
  if(p == initproc)
    800023c6:	00007797          	auipc	a5,0x7
    800023ca:	c627b783          	ld	a5,-926(a5) # 80009028 <initproc>
    800023ce:	0d050493          	addi	s1,a0,208
    800023d2:	15050913          	addi	s2,a0,336
    800023d6:	00a79d63          	bne	a5,a0,800023f0 <exit+0x46>
    panic("init exiting");
    800023da:	00006517          	auipc	a0,0x6
    800023de:	e6650513          	addi	a0,a0,-410 # 80008240 <etext+0x240>
    800023e2:	ffffe097          	auipc	ra,0xffffe
    800023e6:	174080e7          	jalr	372(ra) # 80000556 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    800023ea:	04a1                	addi	s1,s1,8
    800023ec:	01248b63          	beq	s1,s2,80002402 <exit+0x58>
    if(p->ofile[fd]){
    800023f0:	6088                	ld	a0,0(s1)
    800023f2:	dd65                	beqz	a0,800023ea <exit+0x40>
      fileclose(f);
    800023f4:	00002097          	auipc	ra,0x2
    800023f8:	360080e7          	jalr	864(ra) # 80004754 <fileclose>
      p->ofile[fd] = 0;
    800023fc:	0004b023          	sd	zero,0(s1)
    80002400:	b7ed                	j	800023ea <exit+0x40>
  begin_op();
    80002402:	00002097          	auipc	ra,0x2
    80002406:	e70080e7          	jalr	-400(ra) # 80004272 <begin_op>
  iput(p->cwd);
    8000240a:	1509b503          	ld	a0,336(s3)
    8000240e:	00001097          	auipc	ra,0x1
    80002412:	62a080e7          	jalr	1578(ra) # 80003a38 <iput>
  end_op();
    80002416:	00002097          	auipc	ra,0x2
    8000241a:	edc080e7          	jalr	-292(ra) # 800042f2 <end_op>
  p->cwd = 0;
    8000241e:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80002422:	0000f517          	auipc	a0,0xf
    80002426:	e9650513          	addi	a0,a0,-362 # 800112b8 <wait_lock>
    8000242a:	fffff097          	auipc	ra,0xfffff
    8000242e:	82a080e7          	jalr	-2006(ra) # 80000c54 <acquire>
  reparent(p);
    80002432:	854e                	mv	a0,s3
    80002434:	00000097          	auipc	ra,0x0
    80002438:	f1c080e7          	jalr	-228(ra) # 80002350 <reparent>
  wakeup(p->parent);
    8000243c:	0389b503          	ld	a0,56(s3)
    80002440:	00000097          	auipc	ra,0x0
    80002444:	e9a080e7          	jalr	-358(ra) # 800022da <wakeup>
  acquire(&p->lock);
    80002448:	854e                	mv	a0,s3
    8000244a:	fffff097          	auipc	ra,0xfffff
    8000244e:	80a080e7          	jalr	-2038(ra) # 80000c54 <acquire>
  p->xstate = status;
    80002452:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80002456:	4795                	li	a5,5
    80002458:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000245c:	0000f517          	auipc	a0,0xf
    80002460:	e5c50513          	addi	a0,a0,-420 # 800112b8 <wait_lock>
    80002464:	fffff097          	auipc	ra,0xfffff
    80002468:	8a0080e7          	jalr	-1888(ra) # 80000d04 <release>
  sched();
    8000246c:	00000097          	auipc	ra,0x0
    80002470:	bd4080e7          	jalr	-1068(ra) # 80002040 <sched>
  panic("zombie exit");
    80002474:	00006517          	auipc	a0,0x6
    80002478:	ddc50513          	addi	a0,a0,-548 # 80008250 <etext+0x250>
    8000247c:	ffffe097          	auipc	ra,0xffffe
    80002480:	0da080e7          	jalr	218(ra) # 80000556 <panic>

0000000080002484 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80002484:	7179                	addi	sp,sp,-48
    80002486:	f406                	sd	ra,40(sp)
    80002488:	f022                	sd	s0,32(sp)
    8000248a:	ec26                	sd	s1,24(sp)
    8000248c:	e84a                	sd	s2,16(sp)
    8000248e:	e44e                	sd	s3,8(sp)
    80002490:	1800                	addi	s0,sp,48
    80002492:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002494:	0000f497          	auipc	s1,0xf
    80002498:	23c48493          	addi	s1,s1,572 # 800116d0 <proc>
    8000249c:	00015997          	auipc	s3,0x15
    800024a0:	e3498993          	addi	s3,s3,-460 # 800172d0 <tickslock>
    acquire(&p->lock);
    800024a4:	8526                	mv	a0,s1
    800024a6:	ffffe097          	auipc	ra,0xffffe
    800024aa:	7ae080e7          	jalr	1966(ra) # 80000c54 <acquire>
    if(p->pid == pid){
    800024ae:	589c                	lw	a5,48(s1)
    800024b0:	01278d63          	beq	a5,s2,800024ca <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800024b4:	8526                	mv	a0,s1
    800024b6:	fffff097          	auipc	ra,0xfffff
    800024ba:	84e080e7          	jalr	-1970(ra) # 80000d04 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800024be:	17048493          	addi	s1,s1,368
    800024c2:	ff3491e3          	bne	s1,s3,800024a4 <kill+0x20>
  }
  return -1;
    800024c6:	557d                	li	a0,-1
    800024c8:	a829                	j	800024e2 <kill+0x5e>
      p->killed = 1;
    800024ca:	4785                	li	a5,1
    800024cc:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800024ce:	4c98                	lw	a4,24(s1)
    800024d0:	4789                	li	a5,2
    800024d2:	00f70f63          	beq	a4,a5,800024f0 <kill+0x6c>
      release(&p->lock);
    800024d6:	8526                	mv	a0,s1
    800024d8:	fffff097          	auipc	ra,0xfffff
    800024dc:	82c080e7          	jalr	-2004(ra) # 80000d04 <release>
      return 0;
    800024e0:	4501                	li	a0,0
}
    800024e2:	70a2                	ld	ra,40(sp)
    800024e4:	7402                	ld	s0,32(sp)
    800024e6:	64e2                	ld	s1,24(sp)
    800024e8:	6942                	ld	s2,16(sp)
    800024ea:	69a2                	ld	s3,8(sp)
    800024ec:	6145                	addi	sp,sp,48
    800024ee:	8082                	ret
        p->state = RUNNABLE;
    800024f0:	478d                	li	a5,3
    800024f2:	cc9c                	sw	a5,24(s1)
    800024f4:	b7cd                	j	800024d6 <kill+0x52>

00000000800024f6 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800024f6:	7179                	addi	sp,sp,-48
    800024f8:	f406                	sd	ra,40(sp)
    800024fa:	f022                	sd	s0,32(sp)
    800024fc:	ec26                	sd	s1,24(sp)
    800024fe:	e84a                	sd	s2,16(sp)
    80002500:	e44e                	sd	s3,8(sp)
    80002502:	e052                	sd	s4,0(sp)
    80002504:	1800                	addi	s0,sp,48
    80002506:	84aa                	mv	s1,a0
    80002508:	8a2e                	mv	s4,a1
    8000250a:	89b2                	mv	s3,a2
    8000250c:	8936                	mv	s2,a3
  struct proc *p = myproc();
    8000250e:	fffff097          	auipc	ra,0xfffff
    80002512:	578080e7          	jalr	1400(ra) # 80001a86 <myproc>
  if(user_dst){
    80002516:	c08d                	beqz	s1,80002538 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80002518:	86ca                	mv	a3,s2
    8000251a:	864e                	mv	a2,s3
    8000251c:	85d2                	mv	a1,s4
    8000251e:	6928                	ld	a0,80(a0)
    80002520:	fffff097          	auipc	ra,0xfffff
    80002524:	1ea080e7          	jalr	490(ra) # 8000170a <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002528:	70a2                	ld	ra,40(sp)
    8000252a:	7402                	ld	s0,32(sp)
    8000252c:	64e2                	ld	s1,24(sp)
    8000252e:	6942                	ld	s2,16(sp)
    80002530:	69a2                	ld	s3,8(sp)
    80002532:	6a02                	ld	s4,0(sp)
    80002534:	6145                	addi	sp,sp,48
    80002536:	8082                	ret
    memmove((char *)dst, src, len);
    80002538:	0009061b          	sext.w	a2,s2
    8000253c:	85ce                	mv	a1,s3
    8000253e:	8552                	mv	a0,s4
    80002540:	fffff097          	auipc	ra,0xfffff
    80002544:	86c080e7          	jalr	-1940(ra) # 80000dac <memmove>
    return 0;
    80002548:	8526                	mv	a0,s1
    8000254a:	bff9                	j	80002528 <either_copyout+0x32>

000000008000254c <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000254c:	7179                	addi	sp,sp,-48
    8000254e:	f406                	sd	ra,40(sp)
    80002550:	f022                	sd	s0,32(sp)
    80002552:	ec26                	sd	s1,24(sp)
    80002554:	e84a                	sd	s2,16(sp)
    80002556:	e44e                	sd	s3,8(sp)
    80002558:	e052                	sd	s4,0(sp)
    8000255a:	1800                	addi	s0,sp,48
    8000255c:	8a2a                	mv	s4,a0
    8000255e:	84ae                	mv	s1,a1
    80002560:	89b2                	mv	s3,a2
    80002562:	8936                	mv	s2,a3
  struct proc *p = myproc();
    80002564:	fffff097          	auipc	ra,0xfffff
    80002568:	522080e7          	jalr	1314(ra) # 80001a86 <myproc>
  if(user_src){
    8000256c:	c08d                	beqz	s1,8000258e <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    8000256e:	86ca                	mv	a3,s2
    80002570:	864e                	mv	a2,s3
    80002572:	85d2                	mv	a1,s4
    80002574:	6928                	ld	a0,80(a0)
    80002576:	fffff097          	auipc	ra,0xfffff
    8000257a:	220080e7          	jalr	544(ra) # 80001796 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000257e:	70a2                	ld	ra,40(sp)
    80002580:	7402                	ld	s0,32(sp)
    80002582:	64e2                	ld	s1,24(sp)
    80002584:	6942                	ld	s2,16(sp)
    80002586:	69a2                	ld	s3,8(sp)
    80002588:	6a02                	ld	s4,0(sp)
    8000258a:	6145                	addi	sp,sp,48
    8000258c:	8082                	ret
    memmove(dst, (char*)src, len);
    8000258e:	0009061b          	sext.w	a2,s2
    80002592:	85ce                	mv	a1,s3
    80002594:	8552                	mv	a0,s4
    80002596:	fffff097          	auipc	ra,0xfffff
    8000259a:	816080e7          	jalr	-2026(ra) # 80000dac <memmove>
    return 0;
    8000259e:	8526                	mv	a0,s1
    800025a0:	bff9                	j	8000257e <either_copyin+0x32>

00000000800025a2 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800025a2:	715d                	addi	sp,sp,-80
    800025a4:	e486                	sd	ra,72(sp)
    800025a6:	e0a2                	sd	s0,64(sp)
    800025a8:	fc26                	sd	s1,56(sp)
    800025aa:	f84a                	sd	s2,48(sp)
    800025ac:	f44e                	sd	s3,40(sp)
    800025ae:	f052                	sd	s4,32(sp)
    800025b0:	ec56                	sd	s5,24(sp)
    800025b2:	e85a                	sd	s6,16(sp)
    800025b4:	e45e                	sd	s7,8(sp)
    800025b6:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800025b8:	00006517          	auipc	a0,0x6
    800025bc:	a5850513          	addi	a0,a0,-1448 # 80008010 <etext+0x10>
    800025c0:	ffffe097          	auipc	ra,0xffffe
    800025c4:	fe0080e7          	jalr	-32(ra) # 800005a0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800025c8:	0000f497          	auipc	s1,0xf
    800025cc:	26048493          	addi	s1,s1,608 # 80011828 <proc+0x158>
    800025d0:	00015917          	auipc	s2,0x15
    800025d4:	e5890913          	addi	s2,s2,-424 # 80017428 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800025d8:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800025da:	00006997          	auipc	s3,0x6
    800025de:	c8698993          	addi	s3,s3,-890 # 80008260 <etext+0x260>
    printf("%d %s %s", p->pid, state, p->name);
    800025e2:	00006a97          	auipc	s5,0x6
    800025e6:	c86a8a93          	addi	s5,s5,-890 # 80008268 <etext+0x268>
    printf("\n");
    800025ea:	00006a17          	auipc	s4,0x6
    800025ee:	a26a0a13          	addi	s4,s4,-1498 # 80008010 <etext+0x10>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800025f2:	00006b97          	auipc	s7,0x6
    800025f6:	11eb8b93          	addi	s7,s7,286 # 80008710 <states.0>
    800025fa:	a00d                	j	8000261c <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800025fc:	ed86a583          	lw	a1,-296(a3)
    80002600:	8556                	mv	a0,s5
    80002602:	ffffe097          	auipc	ra,0xffffe
    80002606:	f9e080e7          	jalr	-98(ra) # 800005a0 <printf>
    printf("\n");
    8000260a:	8552                	mv	a0,s4
    8000260c:	ffffe097          	auipc	ra,0xffffe
    80002610:	f94080e7          	jalr	-108(ra) # 800005a0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002614:	17048493          	addi	s1,s1,368
    80002618:	03248263          	beq	s1,s2,8000263c <procdump+0x9a>
    if(p->state == UNUSED)
    8000261c:	86a6                	mv	a3,s1
    8000261e:	ec04a783          	lw	a5,-320(s1)
    80002622:	dbed                	beqz	a5,80002614 <procdump+0x72>
      state = "???";
    80002624:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002626:	fcfb6be3          	bltu	s6,a5,800025fc <procdump+0x5a>
    8000262a:	02079713          	slli	a4,a5,0x20
    8000262e:	01d75793          	srli	a5,a4,0x1d
    80002632:	97de                	add	a5,a5,s7
    80002634:	6390                	ld	a2,0(a5)
    80002636:	f279                	bnez	a2,800025fc <procdump+0x5a>
      state = "???";
    80002638:	864e                	mv	a2,s3
    8000263a:	b7c9                	j	800025fc <procdump+0x5a>
  }
}
    8000263c:	60a6                	ld	ra,72(sp)
    8000263e:	6406                	ld	s0,64(sp)
    80002640:	74e2                	ld	s1,56(sp)
    80002642:	7942                	ld	s2,48(sp)
    80002644:	79a2                	ld	s3,40(sp)
    80002646:	7a02                	ld	s4,32(sp)
    80002648:	6ae2                	ld	s5,24(sp)
    8000264a:	6b42                	ld	s6,16(sp)
    8000264c:	6ba2                	ld	s7,8(sp)
    8000264e:	6161                	addi	sp,sp,80
    80002650:	8082                	ret

0000000080002652 <wait2>:

int wait2(uint64 addr, struct rusage *rusage)
{
    80002652:	711d                	addi	sp,sp,-96
    80002654:	ec86                	sd	ra,88(sp)
    80002656:	e8a2                	sd	s0,80(sp)
    80002658:	e4a6                	sd	s1,72(sp)
    8000265a:	e0ca                	sd	s2,64(sp)
    8000265c:	fc4e                	sd	s3,56(sp)
    8000265e:	f852                	sd	s4,48(sp)
    80002660:	f456                	sd	s5,40(sp)
    80002662:	f05a                	sd	s6,32(sp)
    80002664:	ec5e                	sd	s7,24(sp)
    80002666:	e862                	sd	s8,16(sp)
    80002668:	1080                	addi	s0,sp,96
    8000266a:	8baa                	mv	s7,a0
    8000266c:	8c2e                	mv	s8,a1
  struct proc *np;
  int havekids, pid;
  struct proc *p = myproc();
    8000266e:	fffff097          	auipc	ra,0xfffff
    80002672:	418080e7          	jalr	1048(ra) # 80001a86 <myproc>
    80002676:	892a                	mv	s2,a0
  
  struct rusage ru;

  acquire(&wait_lock);
    80002678:	0000f517          	auipc	a0,0xf
    8000267c:	c4050513          	addi	a0,a0,-960 # 800112b8 <wait_lock>
    80002680:	ffffe097          	auipc	ra,0xffffe
    80002684:	5d4080e7          	jalr	1492(ra) # 80000c54 <acquire>
      if(np->parent == p){
        // make sure the child isn't still in exit() or swtch().
        acquire(&np->lock);

        havekids = 1;
        if(np->state == ZOMBIE){
    80002688:	4a15                	li	s4,5
        havekids = 1;
    8000268a:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    8000268c:	00015997          	auipc	s3,0x15
    80002690:	c4498993          	addi	s3,s3,-956 # 800172d0 <tickslock>
      release(&wait_lock);
      return -1;
    }
    
    // Wait for a child to exit.
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002694:	0000fb17          	auipc	s6,0xf
    80002698:	c24b0b13          	addi	s6,s6,-988 # 800112b8 <wait_lock>
    8000269c:	a201                	j	8000279c <wait2+0x14a>
          pid = np->pid;
    8000269e:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800026a2:	060b9363          	bnez	s7,80002708 <wait2+0xb6>
          ru.cputime = np->cputime;
    800026a6:	1684b783          	ld	a5,360(s1)
    800026aa:	faf43423          	sd	a5,-88(s0)
          if(rusage != 0 && copyout(p->pagetable, (uint64)rusage,(char *)&ru,
    800026ae:	000c0e63          	beqz	s8,800026ca <wait2+0x78>
    800026b2:	46a1                	li	a3,8
    800026b4:	fa840613          	addi	a2,s0,-88
    800026b8:	85e2                	mv	a1,s8
    800026ba:	05093503          	ld	a0,80(s2)
    800026be:	fffff097          	auipc	ra,0xfffff
    800026c2:	04c080e7          	jalr	76(ra) # 8000170a <copyout>
    800026c6:	06054c63          	bltz	a0,8000273e <wait2+0xec>
          freeproc(np);
    800026ca:	8526                	mv	a0,s1
    800026cc:	fffff097          	auipc	ra,0xfffff
    800026d0:	56e080e7          	jalr	1390(ra) # 80001c3a <freeproc>
          release(&np->lock);
    800026d4:	8526                	mv	a0,s1
    800026d6:	ffffe097          	auipc	ra,0xffffe
    800026da:	62e080e7          	jalr	1582(ra) # 80000d04 <release>
          release(&wait_lock);
    800026de:	0000f517          	auipc	a0,0xf
    800026e2:	bda50513          	addi	a0,a0,-1062 # 800112b8 <wait_lock>
    800026e6:	ffffe097          	auipc	ra,0xffffe
    800026ea:	61e080e7          	jalr	1566(ra) # 80000d04 <release>
  }
    800026ee:	854e                	mv	a0,s3
    800026f0:	60e6                	ld	ra,88(sp)
    800026f2:	6446                	ld	s0,80(sp)
    800026f4:	64a6                	ld	s1,72(sp)
    800026f6:	6906                	ld	s2,64(sp)
    800026f8:	79e2                	ld	s3,56(sp)
    800026fa:	7a42                	ld	s4,48(sp)
    800026fc:	7aa2                	ld	s5,40(sp)
    800026fe:	7b02                	ld	s6,32(sp)
    80002700:	6be2                	ld	s7,24(sp)
    80002702:	6c42                	ld	s8,16(sp)
    80002704:	6125                	addi	sp,sp,96
    80002706:	8082                	ret
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80002708:	4691                	li	a3,4
    8000270a:	02c48613          	addi	a2,s1,44
    8000270e:	85de                	mv	a1,s7
    80002710:	05093503          	ld	a0,80(s2)
    80002714:	fffff097          	auipc	ra,0xfffff
    80002718:	ff6080e7          	jalr	-10(ra) # 8000170a <copyout>
    8000271c:	f80555e3          	bgez	a0,800026a6 <wait2+0x54>
            release(&np->lock);
    80002720:	8526                	mv	a0,s1
    80002722:	ffffe097          	auipc	ra,0xffffe
    80002726:	5e2080e7          	jalr	1506(ra) # 80000d04 <release>
            release(&wait_lock);
    8000272a:	0000f517          	auipc	a0,0xf
    8000272e:	b8e50513          	addi	a0,a0,-1138 # 800112b8 <wait_lock>
    80002732:	ffffe097          	auipc	ra,0xffffe
    80002736:	5d2080e7          	jalr	1490(ra) # 80000d04 <release>
            return -1;
    8000273a:	59fd                	li	s3,-1
    8000273c:	bf4d                	j	800026ee <wait2+0x9c>
            release(&np->lock);
    8000273e:	8526                	mv	a0,s1
    80002740:	ffffe097          	auipc	ra,0xffffe
    80002744:	5c4080e7          	jalr	1476(ra) # 80000d04 <release>
            release(&wait_lock);
    80002748:	0000f517          	auipc	a0,0xf
    8000274c:	b7050513          	addi	a0,a0,-1168 # 800112b8 <wait_lock>
    80002750:	ffffe097          	auipc	ra,0xffffe
    80002754:	5b4080e7          	jalr	1460(ra) # 80000d04 <release>
            return -1;
    80002758:	59fd                	li	s3,-1
    8000275a:	bf51                	j	800026ee <wait2+0x9c>
    for(np = proc; np < &proc[NPROC]; np++){
    8000275c:	17048493          	addi	s1,s1,368
    80002760:	03348463          	beq	s1,s3,80002788 <wait2+0x136>
      if(np->parent == p){
    80002764:	7c9c                	ld	a5,56(s1)
    80002766:	ff279be3          	bne	a5,s2,8000275c <wait2+0x10a>
        acquire(&np->lock);
    8000276a:	8526                	mv	a0,s1
    8000276c:	ffffe097          	auipc	ra,0xffffe
    80002770:	4e8080e7          	jalr	1256(ra) # 80000c54 <acquire>
        if(np->state == ZOMBIE){
    80002774:	4c9c                	lw	a5,24(s1)
    80002776:	f34784e3          	beq	a5,s4,8000269e <wait2+0x4c>
        release(&np->lock);
    8000277a:	8526                	mv	a0,s1
    8000277c:	ffffe097          	auipc	ra,0xffffe
    80002780:	588080e7          	jalr	1416(ra) # 80000d04 <release>
        havekids = 1;
    80002784:	8756                	mv	a4,s5
    80002786:	bfd9                	j	8000275c <wait2+0x10a>
    if(!havekids || p->killed){
    80002788:	c305                	beqz	a4,800027a8 <wait2+0x156>
    8000278a:	02892783          	lw	a5,40(s2)
    8000278e:	ef89                	bnez	a5,800027a8 <wait2+0x156>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002790:	85da                	mv	a1,s6
    80002792:	854a                	mv	a0,s2
    80002794:	00000097          	auipc	ra,0x0
    80002798:	9c0080e7          	jalr	-1600(ra) # 80002154 <sleep>
    havekids = 0;
    8000279c:	4701                	li	a4,0
    for(np = proc; np < &proc[NPROC]; np++){
    8000279e:	0000f497          	auipc	s1,0xf
    800027a2:	f3248493          	addi	s1,s1,-206 # 800116d0 <proc>
    800027a6:	bf7d                	j	80002764 <wait2+0x112>
      release(&wait_lock);
    800027a8:	0000f517          	auipc	a0,0xf
    800027ac:	b1050513          	addi	a0,a0,-1264 # 800112b8 <wait_lock>
    800027b0:	ffffe097          	auipc	ra,0xffffe
    800027b4:	554080e7          	jalr	1364(ra) # 80000d04 <release>
      return -1;
    800027b8:	59fd                	li	s3,-1
    800027ba:	bf15                	j	800026ee <wait2+0x9c>

00000000800027bc <swtch>:
    800027bc:	00153023          	sd	ra,0(a0)
    800027c0:	00253423          	sd	sp,8(a0)
    800027c4:	e900                	sd	s0,16(a0)
    800027c6:	ed04                	sd	s1,24(a0)
    800027c8:	03253023          	sd	s2,32(a0)
    800027cc:	03353423          	sd	s3,40(a0)
    800027d0:	03453823          	sd	s4,48(a0)
    800027d4:	03553c23          	sd	s5,56(a0)
    800027d8:	05653023          	sd	s6,64(a0)
    800027dc:	05753423          	sd	s7,72(a0)
    800027e0:	05853823          	sd	s8,80(a0)
    800027e4:	05953c23          	sd	s9,88(a0)
    800027e8:	07a53023          	sd	s10,96(a0)
    800027ec:	07b53423          	sd	s11,104(a0)
    800027f0:	0005b083          	ld	ra,0(a1)
    800027f4:	0085b103          	ld	sp,8(a1)
    800027f8:	6980                	ld	s0,16(a1)
    800027fa:	6d84                	ld	s1,24(a1)
    800027fc:	0205b903          	ld	s2,32(a1)
    80002800:	0285b983          	ld	s3,40(a1)
    80002804:	0305ba03          	ld	s4,48(a1)
    80002808:	0385ba83          	ld	s5,56(a1)
    8000280c:	0405bb03          	ld	s6,64(a1)
    80002810:	0485bb83          	ld	s7,72(a1)
    80002814:	0505bc03          	ld	s8,80(a1)
    80002818:	0585bc83          	ld	s9,88(a1)
    8000281c:	0605bd03          	ld	s10,96(a1)
    80002820:	0685bd83          	ld	s11,104(a1)
    80002824:	8082                	ret

0000000080002826 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002826:	1141                	addi	sp,sp,-16
    80002828:	e406                	sd	ra,8(sp)
    8000282a:	e022                	sd	s0,0(sp)
    8000282c:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    8000282e:	00006597          	auipc	a1,0x6
    80002832:	a7258593          	addi	a1,a1,-1422 # 800082a0 <etext+0x2a0>
    80002836:	00015517          	auipc	a0,0x15
    8000283a:	a9a50513          	addi	a0,a0,-1382 # 800172d0 <tickslock>
    8000283e:	ffffe097          	auipc	ra,0xffffe
    80002842:	37c080e7          	jalr	892(ra) # 80000bba <initlock>
}
    80002846:	60a2                	ld	ra,8(sp)
    80002848:	6402                	ld	s0,0(sp)
    8000284a:	0141                	addi	sp,sp,16
    8000284c:	8082                	ret

000000008000284e <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    8000284e:	1141                	addi	sp,sp,-16
    80002850:	e406                	sd	ra,8(sp)
    80002852:	e022                	sd	s0,0(sp)
    80002854:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002856:	00003797          	auipc	a5,0x3
    8000285a:	62a78793          	addi	a5,a5,1578 # 80005e80 <kernelvec>
    8000285e:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002862:	60a2                	ld	ra,8(sp)
    80002864:	6402                	ld	s0,0(sp)
    80002866:	0141                	addi	sp,sp,16
    80002868:	8082                	ret

000000008000286a <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    8000286a:	1141                	addi	sp,sp,-16
    8000286c:	e406                	sd	ra,8(sp)
    8000286e:	e022                	sd	s0,0(sp)
    80002870:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002872:	fffff097          	auipc	ra,0xfffff
    80002876:	214080e7          	jalr	532(ra) # 80001a86 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000287a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000287e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002880:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80002884:	00004697          	auipc	a3,0x4
    80002888:	77c68693          	addi	a3,a3,1916 # 80007000 <_trampoline>
    8000288c:	00004717          	auipc	a4,0x4
    80002890:	77470713          	addi	a4,a4,1908 # 80007000 <_trampoline>
    80002894:	8f15                	sub	a4,a4,a3
    80002896:	040007b7          	lui	a5,0x4000
    8000289a:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    8000289c:	07b2                	slli	a5,a5,0xc
    8000289e:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    800028a0:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800028a4:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800028a6:	18002673          	csrr	a2,satp
    800028aa:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800028ac:	6d30                	ld	a2,88(a0)
    800028ae:	6138                	ld	a4,64(a0)
    800028b0:	6585                	lui	a1,0x1
    800028b2:	972e                	add	a4,a4,a1
    800028b4:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800028b6:	6d38                	ld	a4,88(a0)
    800028b8:	00000617          	auipc	a2,0x0
    800028bc:	14460613          	addi	a2,a2,324 # 800029fc <usertrap>
    800028c0:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    800028c2:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800028c4:	8612                	mv	a2,tp
    800028c6:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800028c8:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800028cc:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800028d0:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800028d4:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800028d8:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800028da:	6f18                	ld	a4,24(a4)
    800028dc:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    800028e0:	692c                	ld	a1,80(a0)
    800028e2:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    800028e4:	00004717          	auipc	a4,0x4
    800028e8:	7ac70713          	addi	a4,a4,1964 # 80007090 <userret>
    800028ec:	8f15                	sub	a4,a4,a3
    800028ee:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    800028f0:	577d                	li	a4,-1
    800028f2:	177e                	slli	a4,a4,0x3f
    800028f4:	8dd9                	or	a1,a1,a4
    800028f6:	02000537          	lui	a0,0x2000
    800028fa:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800028fc:	0536                	slli	a0,a0,0xd
    800028fe:	9782                	jalr	a5
}
    80002900:	60a2                	ld	ra,8(sp)
    80002902:	6402                	ld	s0,0(sp)
    80002904:	0141                	addi	sp,sp,16
    80002906:	8082                	ret

0000000080002908 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002908:	1141                	addi	sp,sp,-16
    8000290a:	e406                	sd	ra,8(sp)
    8000290c:	e022                	sd	s0,0(sp)
    8000290e:	0800                	addi	s0,sp,16
  acquire(&tickslock);
    80002910:	00015517          	auipc	a0,0x15
    80002914:	9c050513          	addi	a0,a0,-1600 # 800172d0 <tickslock>
    80002918:	ffffe097          	auipc	ra,0xffffe
    8000291c:	33c080e7          	jalr	828(ra) # 80000c54 <acquire>
  ticks++;
    80002920:	00006717          	auipc	a4,0x6
    80002924:	71070713          	addi	a4,a4,1808 # 80009030 <ticks>
    80002928:	431c                	lw	a5,0(a4)
    8000292a:	2785                	addiw	a5,a5,1
    8000292c:	c31c                	sw	a5,0(a4)
  wakeup(&ticks);
    8000292e:	853a                	mv	a0,a4
    80002930:	00000097          	auipc	ra,0x0
    80002934:	9aa080e7          	jalr	-1622(ra) # 800022da <wakeup>
  release(&tickslock);
    80002938:	00015517          	auipc	a0,0x15
    8000293c:	99850513          	addi	a0,a0,-1640 # 800172d0 <tickslock>
    80002940:	ffffe097          	auipc	ra,0xffffe
    80002944:	3c4080e7          	jalr	964(ra) # 80000d04 <release>
}
    80002948:	60a2                	ld	ra,8(sp)
    8000294a:	6402                	ld	s0,0(sp)
    8000294c:	0141                	addi	sp,sp,16
    8000294e:	8082                	ret

0000000080002950 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002950:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002954:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80002956:	0a07d263          	bgez	a5,800029fa <devintr+0xaa>
{
    8000295a:	1101                	addi	sp,sp,-32
    8000295c:	ec06                	sd	ra,24(sp)
    8000295e:	e822                	sd	s0,16(sp)
    80002960:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80002962:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80002966:	46a5                	li	a3,9
    80002968:	00d70c63          	beq	a4,a3,80002980 <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    8000296c:	577d                	li	a4,-1
    8000296e:	177e                	slli	a4,a4,0x3f
    80002970:	0705                	addi	a4,a4,1
    return 0;
    80002972:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80002974:	06e78263          	beq	a5,a4,800029d8 <devintr+0x88>
  }
}
    80002978:	60e2                	ld	ra,24(sp)
    8000297a:	6442                	ld	s0,16(sp)
    8000297c:	6105                	addi	sp,sp,32
    8000297e:	8082                	ret
    80002980:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80002982:	00003097          	auipc	ra,0x3
    80002986:	60a080e7          	jalr	1546(ra) # 80005f8c <plic_claim>
    8000298a:	872a                	mv	a4,a0
    8000298c:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    8000298e:	47a9                	li	a5,10
    80002990:	00f50963          	beq	a0,a5,800029a2 <devintr+0x52>
    } else if(irq == VIRTIO0_IRQ){
    80002994:	4785                	li	a5,1
    80002996:	00f50b63          	beq	a0,a5,800029ac <devintr+0x5c>
    return 1;
    8000299a:	4505                	li	a0,1
    } else if(irq){
    8000299c:	ef09                	bnez	a4,800029b6 <devintr+0x66>
    8000299e:	64a2                	ld	s1,8(sp)
    800029a0:	bfe1                	j	80002978 <devintr+0x28>
      uartintr();
    800029a2:	ffffe097          	auipc	ra,0xffffe
    800029a6:	056080e7          	jalr	86(ra) # 800009f8 <uartintr>
    if(irq)
    800029aa:	a839                	j	800029c8 <devintr+0x78>
      virtio_disk_intr();
    800029ac:	00004097          	auipc	ra,0x4
    800029b0:	a9a080e7          	jalr	-1382(ra) # 80006446 <virtio_disk_intr>
    if(irq)
    800029b4:	a811                	j	800029c8 <devintr+0x78>
      printf("unexpected interrupt irq=%d\n", irq);
    800029b6:	85ba                	mv	a1,a4
    800029b8:	00006517          	auipc	a0,0x6
    800029bc:	8f050513          	addi	a0,a0,-1808 # 800082a8 <etext+0x2a8>
    800029c0:	ffffe097          	auipc	ra,0xffffe
    800029c4:	be0080e7          	jalr	-1056(ra) # 800005a0 <printf>
      plic_complete(irq);
    800029c8:	8526                	mv	a0,s1
    800029ca:	00003097          	auipc	ra,0x3
    800029ce:	5e6080e7          	jalr	1510(ra) # 80005fb0 <plic_complete>
    return 1;
    800029d2:	4505                	li	a0,1
    800029d4:	64a2                	ld	s1,8(sp)
    800029d6:	b74d                	j	80002978 <devintr+0x28>
    if(cpuid() == 0){
    800029d8:	fffff097          	auipc	ra,0xfffff
    800029dc:	07a080e7          	jalr	122(ra) # 80001a52 <cpuid>
    800029e0:	c901                	beqz	a0,800029f0 <devintr+0xa0>
  asm volatile("csrr %0, sip" : "=r" (x) );
    800029e2:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    800029e6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    800029e8:	14479073          	csrw	sip,a5
    return 2;
    800029ec:	4509                	li	a0,2
    800029ee:	b769                	j	80002978 <devintr+0x28>
      clockintr();
    800029f0:	00000097          	auipc	ra,0x0
    800029f4:	f18080e7          	jalr	-232(ra) # 80002908 <clockintr>
    800029f8:	b7ed                	j	800029e2 <devintr+0x92>
}
    800029fa:	8082                	ret

00000000800029fc <usertrap>:
{
    800029fc:	1101                	addi	sp,sp,-32
    800029fe:	ec06                	sd	ra,24(sp)
    80002a00:	e822                	sd	s0,16(sp)
    80002a02:	e426                	sd	s1,8(sp)
    80002a04:	e04a                	sd	s2,0(sp)
    80002a06:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a08:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002a0c:	1007f793          	andi	a5,a5,256
    80002a10:	e3ad                	bnez	a5,80002a72 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002a12:	00003797          	auipc	a5,0x3
    80002a16:	46e78793          	addi	a5,a5,1134 # 80005e80 <kernelvec>
    80002a1a:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002a1e:	fffff097          	auipc	ra,0xfffff
    80002a22:	068080e7          	jalr	104(ra) # 80001a86 <myproc>
    80002a26:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002a28:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002a2a:	14102773          	csrr	a4,sepc
    80002a2e:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002a30:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002a34:	47a1                	li	a5,8
    80002a36:	04f71c63          	bne	a4,a5,80002a8e <usertrap+0x92>
    if(p->killed)
    80002a3a:	551c                	lw	a5,40(a0)
    80002a3c:	e3b9                	bnez	a5,80002a82 <usertrap+0x86>
    p->trapframe->epc += 4;
    80002a3e:	6cb8                	ld	a4,88(s1)
    80002a40:	6f1c                	ld	a5,24(a4)
    80002a42:	0791                	addi	a5,a5,4
    80002a44:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a46:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002a4a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002a4e:	10079073          	csrw	sstatus,a5
    syscall();
    80002a52:	00000097          	auipc	ra,0x0
    80002a56:	2ec080e7          	jalr	748(ra) # 80002d3e <syscall>
  if(p->killed)
    80002a5a:	549c                	lw	a5,40(s1)
    80002a5c:	efc9                	bnez	a5,80002af6 <usertrap+0xfa>
  usertrapret();
    80002a5e:	00000097          	auipc	ra,0x0
    80002a62:	e0c080e7          	jalr	-500(ra) # 8000286a <usertrapret>
}
    80002a66:	60e2                	ld	ra,24(sp)
    80002a68:	6442                	ld	s0,16(sp)
    80002a6a:	64a2                	ld	s1,8(sp)
    80002a6c:	6902                	ld	s2,0(sp)
    80002a6e:	6105                	addi	sp,sp,32
    80002a70:	8082                	ret
    panic("usertrap: not from user mode");
    80002a72:	00006517          	auipc	a0,0x6
    80002a76:	85650513          	addi	a0,a0,-1962 # 800082c8 <etext+0x2c8>
    80002a7a:	ffffe097          	auipc	ra,0xffffe
    80002a7e:	adc080e7          	jalr	-1316(ra) # 80000556 <panic>
      exit(-1);
    80002a82:	557d                	li	a0,-1
    80002a84:	00000097          	auipc	ra,0x0
    80002a88:	926080e7          	jalr	-1754(ra) # 800023aa <exit>
    80002a8c:	bf4d                	j	80002a3e <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80002a8e:	00000097          	auipc	ra,0x0
    80002a92:	ec2080e7          	jalr	-318(ra) # 80002950 <devintr>
    80002a96:	892a                	mv	s2,a0
    80002a98:	c501                	beqz	a0,80002aa0 <usertrap+0xa4>
  if(p->killed)
    80002a9a:	549c                	lw	a5,40(s1)
    80002a9c:	c3a1                	beqz	a5,80002adc <usertrap+0xe0>
    80002a9e:	a815                	j	80002ad2 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002aa0:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002aa4:	5890                	lw	a2,48(s1)
    80002aa6:	00006517          	auipc	a0,0x6
    80002aaa:	84250513          	addi	a0,a0,-1982 # 800082e8 <etext+0x2e8>
    80002aae:	ffffe097          	auipc	ra,0xffffe
    80002ab2:	af2080e7          	jalr	-1294(ra) # 800005a0 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002ab6:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002aba:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002abe:	00006517          	auipc	a0,0x6
    80002ac2:	85a50513          	addi	a0,a0,-1958 # 80008318 <etext+0x318>
    80002ac6:	ffffe097          	auipc	ra,0xffffe
    80002aca:	ada080e7          	jalr	-1318(ra) # 800005a0 <printf>
    p->killed = 1;
    80002ace:	4785                	li	a5,1
    80002ad0:	d49c                	sw	a5,40(s1)
    exit(-1);
    80002ad2:	557d                	li	a0,-1
    80002ad4:	00000097          	auipc	ra,0x0
    80002ad8:	8d6080e7          	jalr	-1834(ra) # 800023aa <exit>
  if(which_dev == 2){
    80002adc:	4789                	li	a5,2
    80002ade:	f8f910e3          	bne	s2,a5,80002a5e <usertrap+0x62>
    p->cputime++; // Increment CPU time on timer interrupt
    80002ae2:	1684b783          	ld	a5,360(s1)
    80002ae6:	0785                	addi	a5,a5,1
    80002ae8:	16f4b423          	sd	a5,360(s1)
    yield();
    80002aec:	fffff097          	auipc	ra,0xfffff
    80002af0:	62c080e7          	jalr	1580(ra) # 80002118 <yield>
    80002af4:	b7ad                	j	80002a5e <usertrap+0x62>
  int which_dev = 0;
    80002af6:	4901                	li	s2,0
    80002af8:	bfe9                	j	80002ad2 <usertrap+0xd6>

0000000080002afa <kerneltrap>:
{
    80002afa:	7179                	addi	sp,sp,-48
    80002afc:	f406                	sd	ra,40(sp)
    80002afe:	f022                	sd	s0,32(sp)
    80002b00:	ec26                	sd	s1,24(sp)
    80002b02:	e84a                	sd	s2,16(sp)
    80002b04:	e44e                	sd	s3,8(sp)
    80002b06:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002b08:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002b0c:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002b10:	142027f3          	csrr	a5,scause
    80002b14:	89be                	mv	s3,a5
  if((sstatus & SSTATUS_SPP) == 0)
    80002b16:	1004f793          	andi	a5,s1,256
    80002b1a:	cb85                	beqz	a5,80002b4a <kerneltrap+0x50>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002b1c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002b20:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002b22:	ef85                	bnez	a5,80002b5a <kerneltrap+0x60>
  if((which_dev = devintr()) == 0){
    80002b24:	00000097          	auipc	ra,0x0
    80002b28:	e2c080e7          	jalr	-468(ra) # 80002950 <devintr>
    80002b2c:	cd1d                	beqz	a0,80002b6a <kerneltrap+0x70>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002b2e:	4789                	li	a5,2
    80002b30:	06f50a63          	beq	a0,a5,80002ba4 <kerneltrap+0xaa>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002b34:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002b38:	10049073          	csrw	sstatus,s1
}
    80002b3c:	70a2                	ld	ra,40(sp)
    80002b3e:	7402                	ld	s0,32(sp)
    80002b40:	64e2                	ld	s1,24(sp)
    80002b42:	6942                	ld	s2,16(sp)
    80002b44:	69a2                	ld	s3,8(sp)
    80002b46:	6145                	addi	sp,sp,48
    80002b48:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002b4a:	00005517          	auipc	a0,0x5
    80002b4e:	7ee50513          	addi	a0,a0,2030 # 80008338 <etext+0x338>
    80002b52:	ffffe097          	auipc	ra,0xffffe
    80002b56:	a04080e7          	jalr	-1532(ra) # 80000556 <panic>
    panic("kerneltrap: interrupts enabled");
    80002b5a:	00006517          	auipc	a0,0x6
    80002b5e:	80650513          	addi	a0,a0,-2042 # 80008360 <etext+0x360>
    80002b62:	ffffe097          	auipc	ra,0xffffe
    80002b66:	9f4080e7          	jalr	-1548(ra) # 80000556 <panic>
    printf("scause %p\n", scause);
    80002b6a:	85ce                	mv	a1,s3
    80002b6c:	00006517          	auipc	a0,0x6
    80002b70:	81450513          	addi	a0,a0,-2028 # 80008380 <etext+0x380>
    80002b74:	ffffe097          	auipc	ra,0xffffe
    80002b78:	a2c080e7          	jalr	-1492(ra) # 800005a0 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002b7c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002b80:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002b84:	00006517          	auipc	a0,0x6
    80002b88:	80c50513          	addi	a0,a0,-2036 # 80008390 <etext+0x390>
    80002b8c:	ffffe097          	auipc	ra,0xffffe
    80002b90:	a14080e7          	jalr	-1516(ra) # 800005a0 <printf>
    panic("kerneltrap");
    80002b94:	00006517          	auipc	a0,0x6
    80002b98:	81450513          	addi	a0,a0,-2028 # 800083a8 <etext+0x3a8>
    80002b9c:	ffffe097          	auipc	ra,0xffffe
    80002ba0:	9ba080e7          	jalr	-1606(ra) # 80000556 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002ba4:	fffff097          	auipc	ra,0xfffff
    80002ba8:	ee2080e7          	jalr	-286(ra) # 80001a86 <myproc>
    80002bac:	d541                	beqz	a0,80002b34 <kerneltrap+0x3a>
    80002bae:	fffff097          	auipc	ra,0xfffff
    80002bb2:	ed8080e7          	jalr	-296(ra) # 80001a86 <myproc>
    80002bb6:	4d18                	lw	a4,24(a0)
    80002bb8:	4791                	li	a5,4
    80002bba:	f6f71de3          	bne	a4,a5,80002b34 <kerneltrap+0x3a>
    yield();
    80002bbe:	fffff097          	auipc	ra,0xfffff
    80002bc2:	55a080e7          	jalr	1370(ra) # 80002118 <yield>
    80002bc6:	b7bd                	j	80002b34 <kerneltrap+0x3a>

0000000080002bc8 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002bc8:	1101                	addi	sp,sp,-32
    80002bca:	ec06                	sd	ra,24(sp)
    80002bcc:	e822                	sd	s0,16(sp)
    80002bce:	e426                	sd	s1,8(sp)
    80002bd0:	1000                	addi	s0,sp,32
    80002bd2:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002bd4:	fffff097          	auipc	ra,0xfffff
    80002bd8:	eb2080e7          	jalr	-334(ra) # 80001a86 <myproc>
  switch (n) {
    80002bdc:	4795                	li	a5,5
    80002bde:	0497e163          	bltu	a5,s1,80002c20 <argraw+0x58>
    80002be2:	048a                	slli	s1,s1,0x2
    80002be4:	00006717          	auipc	a4,0x6
    80002be8:	b5c70713          	addi	a4,a4,-1188 # 80008740 <states.0+0x30>
    80002bec:	94ba                	add	s1,s1,a4
    80002bee:	409c                	lw	a5,0(s1)
    80002bf0:	97ba                	add	a5,a5,a4
    80002bf2:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002bf4:	6d3c                	ld	a5,88(a0)
    80002bf6:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002bf8:	60e2                	ld	ra,24(sp)
    80002bfa:	6442                	ld	s0,16(sp)
    80002bfc:	64a2                	ld	s1,8(sp)
    80002bfe:	6105                	addi	sp,sp,32
    80002c00:	8082                	ret
    return p->trapframe->a1;
    80002c02:	6d3c                	ld	a5,88(a0)
    80002c04:	7fa8                	ld	a0,120(a5)
    80002c06:	bfcd                	j	80002bf8 <argraw+0x30>
    return p->trapframe->a2;
    80002c08:	6d3c                	ld	a5,88(a0)
    80002c0a:	63c8                	ld	a0,128(a5)
    80002c0c:	b7f5                	j	80002bf8 <argraw+0x30>
    return p->trapframe->a3;
    80002c0e:	6d3c                	ld	a5,88(a0)
    80002c10:	67c8                	ld	a0,136(a5)
    80002c12:	b7dd                	j	80002bf8 <argraw+0x30>
    return p->trapframe->a4;
    80002c14:	6d3c                	ld	a5,88(a0)
    80002c16:	6bc8                	ld	a0,144(a5)
    80002c18:	b7c5                	j	80002bf8 <argraw+0x30>
    return p->trapframe->a5;
    80002c1a:	6d3c                	ld	a5,88(a0)
    80002c1c:	6fc8                	ld	a0,152(a5)
    80002c1e:	bfe9                	j	80002bf8 <argraw+0x30>
  panic("argraw");
    80002c20:	00005517          	auipc	a0,0x5
    80002c24:	79850513          	addi	a0,a0,1944 # 800083b8 <etext+0x3b8>
    80002c28:	ffffe097          	auipc	ra,0xffffe
    80002c2c:	92e080e7          	jalr	-1746(ra) # 80000556 <panic>

0000000080002c30 <fetchaddr>:
{
    80002c30:	1101                	addi	sp,sp,-32
    80002c32:	ec06                	sd	ra,24(sp)
    80002c34:	e822                	sd	s0,16(sp)
    80002c36:	e426                	sd	s1,8(sp)
    80002c38:	e04a                	sd	s2,0(sp)
    80002c3a:	1000                	addi	s0,sp,32
    80002c3c:	84aa                	mv	s1,a0
    80002c3e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002c40:	fffff097          	auipc	ra,0xfffff
    80002c44:	e46080e7          	jalr	-442(ra) # 80001a86 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002c48:	653c                	ld	a5,72(a0)
    80002c4a:	02f4f863          	bgeu	s1,a5,80002c7a <fetchaddr+0x4a>
    80002c4e:	00848713          	addi	a4,s1,8
    80002c52:	02e7e663          	bltu	a5,a4,80002c7e <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002c56:	46a1                	li	a3,8
    80002c58:	8626                	mv	a2,s1
    80002c5a:	85ca                	mv	a1,s2
    80002c5c:	6928                	ld	a0,80(a0)
    80002c5e:	fffff097          	auipc	ra,0xfffff
    80002c62:	b38080e7          	jalr	-1224(ra) # 80001796 <copyin>
    80002c66:	00a03533          	snez	a0,a0
    80002c6a:	40a0053b          	negw	a0,a0
}
    80002c6e:	60e2                	ld	ra,24(sp)
    80002c70:	6442                	ld	s0,16(sp)
    80002c72:	64a2                	ld	s1,8(sp)
    80002c74:	6902                	ld	s2,0(sp)
    80002c76:	6105                	addi	sp,sp,32
    80002c78:	8082                	ret
    return -1;
    80002c7a:	557d                	li	a0,-1
    80002c7c:	bfcd                	j	80002c6e <fetchaddr+0x3e>
    80002c7e:	557d                	li	a0,-1
    80002c80:	b7fd                	j	80002c6e <fetchaddr+0x3e>

0000000080002c82 <fetchstr>:
{
    80002c82:	7179                	addi	sp,sp,-48
    80002c84:	f406                	sd	ra,40(sp)
    80002c86:	f022                	sd	s0,32(sp)
    80002c88:	ec26                	sd	s1,24(sp)
    80002c8a:	e84a                	sd	s2,16(sp)
    80002c8c:	e44e                	sd	s3,8(sp)
    80002c8e:	1800                	addi	s0,sp,48
    80002c90:	89aa                	mv	s3,a0
    80002c92:	84ae                	mv	s1,a1
    80002c94:	8932                	mv	s2,a2
  struct proc *p = myproc();
    80002c96:	fffff097          	auipc	ra,0xfffff
    80002c9a:	df0080e7          	jalr	-528(ra) # 80001a86 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002c9e:	86ca                	mv	a3,s2
    80002ca0:	864e                	mv	a2,s3
    80002ca2:	85a6                	mv	a1,s1
    80002ca4:	6928                	ld	a0,80(a0)
    80002ca6:	fffff097          	auipc	ra,0xfffff
    80002caa:	b7e080e7          	jalr	-1154(ra) # 80001824 <copyinstr>
  if(err < 0)
    80002cae:	00054763          	bltz	a0,80002cbc <fetchstr+0x3a>
  return strlen(buf);
    80002cb2:	8526                	mv	a0,s1
    80002cb4:	ffffe097          	auipc	ra,0xffffe
    80002cb8:	226080e7          	jalr	550(ra) # 80000eda <strlen>
}
    80002cbc:	70a2                	ld	ra,40(sp)
    80002cbe:	7402                	ld	s0,32(sp)
    80002cc0:	64e2                	ld	s1,24(sp)
    80002cc2:	6942                	ld	s2,16(sp)
    80002cc4:	69a2                	ld	s3,8(sp)
    80002cc6:	6145                	addi	sp,sp,48
    80002cc8:	8082                	ret

0000000080002cca <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002cca:	1101                	addi	sp,sp,-32
    80002ccc:	ec06                	sd	ra,24(sp)
    80002cce:	e822                	sd	s0,16(sp)
    80002cd0:	e426                	sd	s1,8(sp)
    80002cd2:	1000                	addi	s0,sp,32
    80002cd4:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002cd6:	00000097          	auipc	ra,0x0
    80002cda:	ef2080e7          	jalr	-270(ra) # 80002bc8 <argraw>
    80002cde:	c088                	sw	a0,0(s1)
  return 0;
}
    80002ce0:	4501                	li	a0,0
    80002ce2:	60e2                	ld	ra,24(sp)
    80002ce4:	6442                	ld	s0,16(sp)
    80002ce6:	64a2                	ld	s1,8(sp)
    80002ce8:	6105                	addi	sp,sp,32
    80002cea:	8082                	ret

0000000080002cec <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002cec:	1101                	addi	sp,sp,-32
    80002cee:	ec06                	sd	ra,24(sp)
    80002cf0:	e822                	sd	s0,16(sp)
    80002cf2:	e426                	sd	s1,8(sp)
    80002cf4:	1000                	addi	s0,sp,32
    80002cf6:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002cf8:	00000097          	auipc	ra,0x0
    80002cfc:	ed0080e7          	jalr	-304(ra) # 80002bc8 <argraw>
    80002d00:	e088                	sd	a0,0(s1)
  return 0;
}
    80002d02:	4501                	li	a0,0
    80002d04:	60e2                	ld	ra,24(sp)
    80002d06:	6442                	ld	s0,16(sp)
    80002d08:	64a2                	ld	s1,8(sp)
    80002d0a:	6105                	addi	sp,sp,32
    80002d0c:	8082                	ret

0000000080002d0e <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002d0e:	1101                	addi	sp,sp,-32
    80002d10:	ec06                	sd	ra,24(sp)
    80002d12:	e822                	sd	s0,16(sp)
    80002d14:	e426                	sd	s1,8(sp)
    80002d16:	e04a                	sd	s2,0(sp)
    80002d18:	1000                	addi	s0,sp,32
    80002d1a:	892e                	mv	s2,a1
    80002d1c:	84b2                	mv	s1,a2
  *ip = argraw(n);
    80002d1e:	00000097          	auipc	ra,0x0
    80002d22:	eaa080e7          	jalr	-342(ra) # 80002bc8 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002d26:	8626                	mv	a2,s1
    80002d28:	85ca                	mv	a1,s2
    80002d2a:	00000097          	auipc	ra,0x0
    80002d2e:	f58080e7          	jalr	-168(ra) # 80002c82 <fetchstr>
}
    80002d32:	60e2                	ld	ra,24(sp)
    80002d34:	6442                	ld	s0,16(sp)
    80002d36:	64a2                	ld	s1,8(sp)
    80002d38:	6902                	ld	s2,0(sp)
    80002d3a:	6105                	addi	sp,sp,32
    80002d3c:	8082                	ret

0000000080002d3e <syscall>:
[SYS_cputime] sys_cputime, // Added the new cputime syscall here
};

void
syscall(void)
{
    80002d3e:	1101                	addi	sp,sp,-32
    80002d40:	ec06                	sd	ra,24(sp)
    80002d42:	e822                	sd	s0,16(sp)
    80002d44:	e426                	sd	s1,8(sp)
    80002d46:	e04a                	sd	s2,0(sp)
    80002d48:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002d4a:	fffff097          	auipc	ra,0xfffff
    80002d4e:	d3c080e7          	jalr	-708(ra) # 80001a86 <myproc>
    80002d52:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002d54:	05853903          	ld	s2,88(a0)
    80002d58:	0a893783          	ld	a5,168(s2)
    80002d5c:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002d60:	37fd                	addiw	a5,a5,-1
    80002d62:	4759                	li	a4,22
    80002d64:	00f76f63          	bltu	a4,a5,80002d82 <syscall+0x44>
    80002d68:	00369713          	slli	a4,a3,0x3
    80002d6c:	00006797          	auipc	a5,0x6
    80002d70:	9ec78793          	addi	a5,a5,-1556 # 80008758 <syscalls>
    80002d74:	97ba                	add	a5,a5,a4
    80002d76:	639c                	ld	a5,0(a5)
    80002d78:	c789                	beqz	a5,80002d82 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002d7a:	9782                	jalr	a5
    80002d7c:	06a93823          	sd	a0,112(s2)
    80002d80:	a839                	j	80002d9e <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002d82:	15848613          	addi	a2,s1,344
    80002d86:	588c                	lw	a1,48(s1)
    80002d88:	00005517          	auipc	a0,0x5
    80002d8c:	63850513          	addi	a0,a0,1592 # 800083c0 <etext+0x3c0>
    80002d90:	ffffe097          	auipc	ra,0xffffe
    80002d94:	810080e7          	jalr	-2032(ra) # 800005a0 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002d98:	6cbc                	ld	a5,88(s1)
    80002d9a:	577d                	li	a4,-1
    80002d9c:	fbb8                	sd	a4,112(a5)
  }
}
    80002d9e:	60e2                	ld	ra,24(sp)
    80002da0:	6442                	ld	s0,16(sp)
    80002da2:	64a2                	ld	s1,8(sp)
    80002da4:	6902                	ld	s2,0(sp)
    80002da6:	6105                	addi	sp,sp,32
    80002da8:	8082                	ret

0000000080002daa <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002daa:	1101                	addi	sp,sp,-32
    80002dac:	ec06                	sd	ra,24(sp)
    80002dae:	e822                	sd	s0,16(sp)
    80002db0:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002db2:	fec40593          	addi	a1,s0,-20
    80002db6:	4501                	li	a0,0
    80002db8:	00000097          	auipc	ra,0x0
    80002dbc:	f12080e7          	jalr	-238(ra) # 80002cca <argint>
    return -1;
    80002dc0:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002dc2:	00054963          	bltz	a0,80002dd4 <sys_exit+0x2a>
  exit(n);
    80002dc6:	fec42503          	lw	a0,-20(s0)
    80002dca:	fffff097          	auipc	ra,0xfffff
    80002dce:	5e0080e7          	jalr	1504(ra) # 800023aa <exit>
  return 0;  // not reached
    80002dd2:	4781                	li	a5,0
}
    80002dd4:	853e                	mv	a0,a5
    80002dd6:	60e2                	ld	ra,24(sp)
    80002dd8:	6442                	ld	s0,16(sp)
    80002dda:	6105                	addi	sp,sp,32
    80002ddc:	8082                	ret

0000000080002dde <sys_getpid>:

uint64
sys_getpid(void)
{
    80002dde:	1141                	addi	sp,sp,-16
    80002de0:	e406                	sd	ra,8(sp)
    80002de2:	e022                	sd	s0,0(sp)
    80002de4:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002de6:	fffff097          	auipc	ra,0xfffff
    80002dea:	ca0080e7          	jalr	-864(ra) # 80001a86 <myproc>
}
    80002dee:	5908                	lw	a0,48(a0)
    80002df0:	60a2                	ld	ra,8(sp)
    80002df2:	6402                	ld	s0,0(sp)
    80002df4:	0141                	addi	sp,sp,16
    80002df6:	8082                	ret

0000000080002df8 <sys_fork>:

uint64
sys_fork(void)
{
    80002df8:	1141                	addi	sp,sp,-16
    80002dfa:	e406                	sd	ra,8(sp)
    80002dfc:	e022                	sd	s0,0(sp)
    80002dfe:	0800                	addi	s0,sp,16
  return fork();
    80002e00:	fffff097          	auipc	ra,0xfffff
    80002e04:	05e080e7          	jalr	94(ra) # 80001e5e <fork>
}
    80002e08:	60a2                	ld	ra,8(sp)
    80002e0a:	6402                	ld	s0,0(sp)
    80002e0c:	0141                	addi	sp,sp,16
    80002e0e:	8082                	ret

0000000080002e10 <sys_wait>:

uint64
sys_wait(void)
{
    80002e10:	1101                	addi	sp,sp,-32
    80002e12:	ec06                	sd	ra,24(sp)
    80002e14:	e822                	sd	s0,16(sp)
    80002e16:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002e18:	fe840593          	addi	a1,s0,-24
    80002e1c:	4501                	li	a0,0
    80002e1e:	00000097          	auipc	ra,0x0
    80002e22:	ece080e7          	jalr	-306(ra) # 80002cec <argaddr>
    80002e26:	87aa                	mv	a5,a0
    return -1;
    80002e28:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002e2a:	0007c863          	bltz	a5,80002e3a <sys_wait+0x2a>
  return wait(p);
    80002e2e:	fe843503          	ld	a0,-24(s0)
    80002e32:	fffff097          	auipc	ra,0xfffff
    80002e36:	386080e7          	jalr	902(ra) # 800021b8 <wait>
}
    80002e3a:	60e2                	ld	ra,24(sp)
    80002e3c:	6442                	ld	s0,16(sp)
    80002e3e:	6105                	addi	sp,sp,32
    80002e40:	8082                	ret

0000000080002e42 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002e42:	7179                	addi	sp,sp,-48
    80002e44:	f406                	sd	ra,40(sp)
    80002e46:	f022                	sd	s0,32(sp)
    80002e48:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002e4a:	fdc40593          	addi	a1,s0,-36
    80002e4e:	4501                	li	a0,0
    80002e50:	00000097          	auipc	ra,0x0
    80002e54:	e7a080e7          	jalr	-390(ra) # 80002cca <argint>
    return -1;
    80002e58:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002e5a:	02054363          	bltz	a0,80002e80 <sys_sbrk+0x3e>
    80002e5e:	ec26                	sd	s1,24(sp)
  addr = myproc()->sz;
    80002e60:	fffff097          	auipc	ra,0xfffff
    80002e64:	c26080e7          	jalr	-986(ra) # 80001a86 <myproc>
    80002e68:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002e6a:	fdc42503          	lw	a0,-36(s0)
    80002e6e:	fffff097          	auipc	ra,0xfffff
    80002e72:	f78080e7          	jalr	-136(ra) # 80001de6 <growproc>
    80002e76:	00054a63          	bltz	a0,80002e8a <sys_sbrk+0x48>
    return -1;
  return addr;
    80002e7a:	0004879b          	sext.w	a5,s1
    80002e7e:	64e2                	ld	s1,24(sp)
}
    80002e80:	853e                	mv	a0,a5
    80002e82:	70a2                	ld	ra,40(sp)
    80002e84:	7402                	ld	s0,32(sp)
    80002e86:	6145                	addi	sp,sp,48
    80002e88:	8082                	ret
    return -1;
    80002e8a:	57fd                	li	a5,-1
    80002e8c:	64e2                	ld	s1,24(sp)
    80002e8e:	bfcd                	j	80002e80 <sys_sbrk+0x3e>

0000000080002e90 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002e90:	7139                	addi	sp,sp,-64
    80002e92:	fc06                	sd	ra,56(sp)
    80002e94:	f822                	sd	s0,48(sp)
    80002e96:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002e98:	fcc40593          	addi	a1,s0,-52
    80002e9c:	4501                	li	a0,0
    80002e9e:	00000097          	auipc	ra,0x0
    80002ea2:	e2c080e7          	jalr	-468(ra) # 80002cca <argint>
    return -1;
    80002ea6:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002ea8:	06054b63          	bltz	a0,80002f1e <sys_sleep+0x8e>
  acquire(&tickslock);
    80002eac:	00014517          	auipc	a0,0x14
    80002eb0:	42450513          	addi	a0,a0,1060 # 800172d0 <tickslock>
    80002eb4:	ffffe097          	auipc	ra,0xffffe
    80002eb8:	da0080e7          	jalr	-608(ra) # 80000c54 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    80002ebc:	fcc42783          	lw	a5,-52(s0)
    80002ec0:	c7b1                	beqz	a5,80002f0c <sys_sleep+0x7c>
    80002ec2:	f426                	sd	s1,40(sp)
    80002ec4:	f04a                	sd	s2,32(sp)
    80002ec6:	ec4e                	sd	s3,24(sp)
  ticks0 = ticks;
    80002ec8:	00006997          	auipc	s3,0x6
    80002ecc:	1689a983          	lw	s3,360(s3) # 80009030 <ticks>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002ed0:	00014917          	auipc	s2,0x14
    80002ed4:	40090913          	addi	s2,s2,1024 # 800172d0 <tickslock>
    80002ed8:	00006497          	auipc	s1,0x6
    80002edc:	15848493          	addi	s1,s1,344 # 80009030 <ticks>
    if(myproc()->killed){
    80002ee0:	fffff097          	auipc	ra,0xfffff
    80002ee4:	ba6080e7          	jalr	-1114(ra) # 80001a86 <myproc>
    80002ee8:	551c                	lw	a5,40(a0)
    80002eea:	ef9d                	bnez	a5,80002f28 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002eec:	85ca                	mv	a1,s2
    80002eee:	8526                	mv	a0,s1
    80002ef0:	fffff097          	auipc	ra,0xfffff
    80002ef4:	264080e7          	jalr	612(ra) # 80002154 <sleep>
  while(ticks - ticks0 < n){
    80002ef8:	409c                	lw	a5,0(s1)
    80002efa:	413787bb          	subw	a5,a5,s3
    80002efe:	fcc42703          	lw	a4,-52(s0)
    80002f02:	fce7efe3          	bltu	a5,a4,80002ee0 <sys_sleep+0x50>
    80002f06:	74a2                	ld	s1,40(sp)
    80002f08:	7902                	ld	s2,32(sp)
    80002f0a:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002f0c:	00014517          	auipc	a0,0x14
    80002f10:	3c450513          	addi	a0,a0,964 # 800172d0 <tickslock>
    80002f14:	ffffe097          	auipc	ra,0xffffe
    80002f18:	df0080e7          	jalr	-528(ra) # 80000d04 <release>
  return 0;
    80002f1c:	4781                	li	a5,0
}
    80002f1e:	853e                	mv	a0,a5
    80002f20:	70e2                	ld	ra,56(sp)
    80002f22:	7442                	ld	s0,48(sp)
    80002f24:	6121                	addi	sp,sp,64
    80002f26:	8082                	ret
      release(&tickslock);
    80002f28:	00014517          	auipc	a0,0x14
    80002f2c:	3a850513          	addi	a0,a0,936 # 800172d0 <tickslock>
    80002f30:	ffffe097          	auipc	ra,0xffffe
    80002f34:	dd4080e7          	jalr	-556(ra) # 80000d04 <release>
      return -1;
    80002f38:	57fd                	li	a5,-1
    80002f3a:	74a2                	ld	s1,40(sp)
    80002f3c:	7902                	ld	s2,32(sp)
    80002f3e:	69e2                	ld	s3,24(sp)
    80002f40:	bff9                	j	80002f1e <sys_sleep+0x8e>

0000000080002f42 <sys_kill>:

uint64
sys_kill(void)
{
    80002f42:	1101                	addi	sp,sp,-32
    80002f44:	ec06                	sd	ra,24(sp)
    80002f46:	e822                	sd	s0,16(sp)
    80002f48:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002f4a:	fec40593          	addi	a1,s0,-20
    80002f4e:	4501                	li	a0,0
    80002f50:	00000097          	auipc	ra,0x0
    80002f54:	d7a080e7          	jalr	-646(ra) # 80002cca <argint>
    80002f58:	87aa                	mv	a5,a0
    return -1;
    80002f5a:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002f5c:	0007c863          	bltz	a5,80002f6c <sys_kill+0x2a>
  return kill(pid);
    80002f60:	fec42503          	lw	a0,-20(s0)
    80002f64:	fffff097          	auipc	ra,0xfffff
    80002f68:	520080e7          	jalr	1312(ra) # 80002484 <kill>
}
    80002f6c:	60e2                	ld	ra,24(sp)
    80002f6e:	6442                	ld	s0,16(sp)
    80002f70:	6105                	addi	sp,sp,32
    80002f72:	8082                	ret

0000000080002f74 <sys_uptime>:

uint64
sys_uptime(void)
{
    80002f74:	1101                	addi	sp,sp,-32
    80002f76:	ec06                	sd	ra,24(sp)
    80002f78:	e822                	sd	s0,16(sp)
    80002f7a:	e426                	sd	s1,8(sp)
    80002f7c:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002f7e:	00014517          	auipc	a0,0x14
    80002f82:	35250513          	addi	a0,a0,850 # 800172d0 <tickslock>
    80002f86:	ffffe097          	auipc	ra,0xffffe
    80002f8a:	cce080e7          	jalr	-818(ra) # 80000c54 <acquire>
  xticks = ticks;
    80002f8e:	00006797          	auipc	a5,0x6
    80002f92:	0a27a783          	lw	a5,162(a5) # 80009030 <ticks>
    80002f96:	84be                	mv	s1,a5
  release(&tickslock);
    80002f98:	00014517          	auipc	a0,0x14
    80002f9c:	33850513          	addi	a0,a0,824 # 800172d0 <tickslock>
    80002fa0:	ffffe097          	auipc	ra,0xffffe
    80002fa4:	d64080e7          	jalr	-668(ra) # 80000d04 <release>
  return xticks;
}
    80002fa8:	02049513          	slli	a0,s1,0x20
    80002fac:	9101                	srli	a0,a0,0x20
    80002fae:	60e2                	ld	ra,24(sp)
    80002fb0:	6442                	ld	s0,16(sp)
    80002fb2:	64a2                	ld	s1,8(sp)
    80002fb4:	6105                	addi	sp,sp,32
    80002fb6:	8082                	ret

0000000080002fb8 <sys_cputime>:

uint64
sys_cputime(void)
{
    80002fb8:	1141                	addi	sp,sp,-16
    80002fba:	e406                	sd	ra,8(sp)
    80002fbc:	e022                	sd	s0,0(sp)
    80002fbe:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002fc0:	fffff097          	auipc	ra,0xfffff
    80002fc4:	ac6080e7          	jalr	-1338(ra) # 80001a86 <myproc>
  return p->cputime;
}
    80002fc8:	16853503          	ld	a0,360(a0)
    80002fcc:	60a2                	ld	ra,8(sp)
    80002fce:	6402                	ld	s0,0(sp)
    80002fd0:	0141                	addi	sp,sp,16
    80002fd2:	8082                	ret

0000000080002fd4 <sys_wait2>:

uint64
sys_wait2(void)
{
    80002fd4:	1101                	addi	sp,sp,-32
    80002fd6:	ec06                	sd	ra,24(sp)
    80002fd8:	e822                	sd	s0,16(sp)
    80002fda:	1000                	addi	s0,sp,32
  uint64 addr;
  uint64 rusage_addr;

  if(argaddr(0, &addr) < 0) // Get the first argument (addr)
    80002fdc:	fe840593          	addi	a1,s0,-24
    80002fe0:	4501                	li	a0,0
    80002fe2:	00000097          	auipc	ra,0x0
    80002fe6:	d0a080e7          	jalr	-758(ra) # 80002cec <argaddr>
    return -1;
    80002fea:	57fd                	li	a5,-1
  if(argaddr(0, &addr) < 0) // Get the first argument (addr)
    80002fec:	02054563          	bltz	a0,80003016 <sys_wait2+0x42>
    
  if(argaddr(1, &rusage_addr) < 0) // Get the second argument (rusage_addr)
    80002ff0:	fe040593          	addi	a1,s0,-32
    80002ff4:	4505                	li	a0,1
    80002ff6:	00000097          	auipc	ra,0x0
    80002ffa:	cf6080e7          	jalr	-778(ra) # 80002cec <argaddr>
    return -1;
    80002ffe:	57fd                	li	a5,-1
  if(argaddr(1, &rusage_addr) < 0) // Get the second argument (rusage_addr)
    80003000:	00054b63          	bltz	a0,80003016 <sys_wait2+0x42>

  return wait2(addr, (struct rusage *)rusage_addr); // Call wait2 with the provided arguments converts rusage_addr to a pointer to struct rusage
    80003004:	fe043583          	ld	a1,-32(s0)
    80003008:	fe843503          	ld	a0,-24(s0)
    8000300c:	fffff097          	auipc	ra,0xfffff
    80003010:	646080e7          	jalr	1606(ra) # 80002652 <wait2>
    80003014:	87aa                	mv	a5,a0
    80003016:	853e                	mv	a0,a5
    80003018:	60e2                	ld	ra,24(sp)
    8000301a:	6442                	ld	s0,16(sp)
    8000301c:	6105                	addi	sp,sp,32
    8000301e:	8082                	ret

0000000080003020 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80003020:	7179                	addi	sp,sp,-48
    80003022:	f406                	sd	ra,40(sp)
    80003024:	f022                	sd	s0,32(sp)
    80003026:	ec26                	sd	s1,24(sp)
    80003028:	e84a                	sd	s2,16(sp)
    8000302a:	e44e                	sd	s3,8(sp)
    8000302c:	e052                	sd	s4,0(sp)
    8000302e:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80003030:	00005597          	auipc	a1,0x5
    80003034:	3b058593          	addi	a1,a1,944 # 800083e0 <etext+0x3e0>
    80003038:	00014517          	auipc	a0,0x14
    8000303c:	2b050513          	addi	a0,a0,688 # 800172e8 <bcache>
    80003040:	ffffe097          	auipc	ra,0xffffe
    80003044:	b7a080e7          	jalr	-1158(ra) # 80000bba <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80003048:	0001c797          	auipc	a5,0x1c
    8000304c:	2a078793          	addi	a5,a5,672 # 8001f2e8 <bcache+0x8000>
    80003050:	0001c717          	auipc	a4,0x1c
    80003054:	50070713          	addi	a4,a4,1280 # 8001f550 <bcache+0x8268>
    80003058:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000305c:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003060:	00014497          	auipc	s1,0x14
    80003064:	2a048493          	addi	s1,s1,672 # 80017300 <bcache+0x18>
    b->next = bcache.head.next;
    80003068:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000306a:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000306c:	00005a17          	auipc	s4,0x5
    80003070:	37ca0a13          	addi	s4,s4,892 # 800083e8 <etext+0x3e8>
    b->next = bcache.head.next;
    80003074:	2b893783          	ld	a5,696(s2)
    80003078:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000307a:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000307e:	85d2                	mv	a1,s4
    80003080:	01048513          	addi	a0,s1,16
    80003084:	00001097          	auipc	ra,0x1
    80003088:	4c2080e7          	jalr	1218(ra) # 80004546 <initsleeplock>
    bcache.head.next->prev = b;
    8000308c:	2b893783          	ld	a5,696(s2)
    80003090:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80003092:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003096:	45848493          	addi	s1,s1,1112
    8000309a:	fd349de3          	bne	s1,s3,80003074 <binit+0x54>
  }
}
    8000309e:	70a2                	ld	ra,40(sp)
    800030a0:	7402                	ld	s0,32(sp)
    800030a2:	64e2                	ld	s1,24(sp)
    800030a4:	6942                	ld	s2,16(sp)
    800030a6:	69a2                	ld	s3,8(sp)
    800030a8:	6a02                	ld	s4,0(sp)
    800030aa:	6145                	addi	sp,sp,48
    800030ac:	8082                	ret

00000000800030ae <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800030ae:	7179                	addi	sp,sp,-48
    800030b0:	f406                	sd	ra,40(sp)
    800030b2:	f022                	sd	s0,32(sp)
    800030b4:	ec26                	sd	s1,24(sp)
    800030b6:	e84a                	sd	s2,16(sp)
    800030b8:	e44e                	sd	s3,8(sp)
    800030ba:	1800                	addi	s0,sp,48
    800030bc:	892a                	mv	s2,a0
    800030be:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800030c0:	00014517          	auipc	a0,0x14
    800030c4:	22850513          	addi	a0,a0,552 # 800172e8 <bcache>
    800030c8:	ffffe097          	auipc	ra,0xffffe
    800030cc:	b8c080e7          	jalr	-1140(ra) # 80000c54 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800030d0:	0001c497          	auipc	s1,0x1c
    800030d4:	4d04b483          	ld	s1,1232(s1) # 8001f5a0 <bcache+0x82b8>
    800030d8:	0001c797          	auipc	a5,0x1c
    800030dc:	47878793          	addi	a5,a5,1144 # 8001f550 <bcache+0x8268>
    800030e0:	02f48f63          	beq	s1,a5,8000311e <bread+0x70>
    800030e4:	873e                	mv	a4,a5
    800030e6:	a021                	j	800030ee <bread+0x40>
    800030e8:	68a4                	ld	s1,80(s1)
    800030ea:	02e48a63          	beq	s1,a4,8000311e <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800030ee:	449c                	lw	a5,8(s1)
    800030f0:	ff279ce3          	bne	a5,s2,800030e8 <bread+0x3a>
    800030f4:	44dc                	lw	a5,12(s1)
    800030f6:	ff3799e3          	bne	a5,s3,800030e8 <bread+0x3a>
      b->refcnt++;
    800030fa:	40bc                	lw	a5,64(s1)
    800030fc:	2785                	addiw	a5,a5,1
    800030fe:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003100:	00014517          	auipc	a0,0x14
    80003104:	1e850513          	addi	a0,a0,488 # 800172e8 <bcache>
    80003108:	ffffe097          	auipc	ra,0xffffe
    8000310c:	bfc080e7          	jalr	-1028(ra) # 80000d04 <release>
      acquiresleep(&b->lock);
    80003110:	01048513          	addi	a0,s1,16
    80003114:	00001097          	auipc	ra,0x1
    80003118:	46c080e7          	jalr	1132(ra) # 80004580 <acquiresleep>
      return b;
    8000311c:	a8b9                	j	8000317a <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000311e:	0001c497          	auipc	s1,0x1c
    80003122:	47a4b483          	ld	s1,1146(s1) # 8001f598 <bcache+0x82b0>
    80003126:	0001c797          	auipc	a5,0x1c
    8000312a:	42a78793          	addi	a5,a5,1066 # 8001f550 <bcache+0x8268>
    8000312e:	00f48863          	beq	s1,a5,8000313e <bread+0x90>
    80003132:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003134:	40bc                	lw	a5,64(s1)
    80003136:	cf81                	beqz	a5,8000314e <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003138:	64a4                	ld	s1,72(s1)
    8000313a:	fee49de3          	bne	s1,a4,80003134 <bread+0x86>
  panic("bget: no buffers");
    8000313e:	00005517          	auipc	a0,0x5
    80003142:	2b250513          	addi	a0,a0,690 # 800083f0 <etext+0x3f0>
    80003146:	ffffd097          	auipc	ra,0xffffd
    8000314a:	410080e7          	jalr	1040(ra) # 80000556 <panic>
      b->dev = dev;
    8000314e:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003152:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003156:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000315a:	4785                	li	a5,1
    8000315c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000315e:	00014517          	auipc	a0,0x14
    80003162:	18a50513          	addi	a0,a0,394 # 800172e8 <bcache>
    80003166:	ffffe097          	auipc	ra,0xffffe
    8000316a:	b9e080e7          	jalr	-1122(ra) # 80000d04 <release>
      acquiresleep(&b->lock);
    8000316e:	01048513          	addi	a0,s1,16
    80003172:	00001097          	auipc	ra,0x1
    80003176:	40e080e7          	jalr	1038(ra) # 80004580 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000317a:	409c                	lw	a5,0(s1)
    8000317c:	cb89                	beqz	a5,8000318e <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000317e:	8526                	mv	a0,s1
    80003180:	70a2                	ld	ra,40(sp)
    80003182:	7402                	ld	s0,32(sp)
    80003184:	64e2                	ld	s1,24(sp)
    80003186:	6942                	ld	s2,16(sp)
    80003188:	69a2                	ld	s3,8(sp)
    8000318a:	6145                	addi	sp,sp,48
    8000318c:	8082                	ret
    virtio_disk_rw(b, 0);
    8000318e:	4581                	li	a1,0
    80003190:	8526                	mv	a0,s1
    80003192:	00003097          	auipc	ra,0x3
    80003196:	02c080e7          	jalr	44(ra) # 800061be <virtio_disk_rw>
    b->valid = 1;
    8000319a:	4785                	li	a5,1
    8000319c:	c09c                	sw	a5,0(s1)
  return b;
    8000319e:	b7c5                	j	8000317e <bread+0xd0>

00000000800031a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800031a0:	1101                	addi	sp,sp,-32
    800031a2:	ec06                	sd	ra,24(sp)
    800031a4:	e822                	sd	s0,16(sp)
    800031a6:	e426                	sd	s1,8(sp)
    800031a8:	1000                	addi	s0,sp,32
    800031aa:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800031ac:	0541                	addi	a0,a0,16
    800031ae:	00001097          	auipc	ra,0x1
    800031b2:	46c080e7          	jalr	1132(ra) # 8000461a <holdingsleep>
    800031b6:	cd01                	beqz	a0,800031ce <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800031b8:	4585                	li	a1,1
    800031ba:	8526                	mv	a0,s1
    800031bc:	00003097          	auipc	ra,0x3
    800031c0:	002080e7          	jalr	2(ra) # 800061be <virtio_disk_rw>
}
    800031c4:	60e2                	ld	ra,24(sp)
    800031c6:	6442                	ld	s0,16(sp)
    800031c8:	64a2                	ld	s1,8(sp)
    800031ca:	6105                	addi	sp,sp,32
    800031cc:	8082                	ret
    panic("bwrite");
    800031ce:	00005517          	auipc	a0,0x5
    800031d2:	23a50513          	addi	a0,a0,570 # 80008408 <etext+0x408>
    800031d6:	ffffd097          	auipc	ra,0xffffd
    800031da:	380080e7          	jalr	896(ra) # 80000556 <panic>

00000000800031de <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800031de:	1101                	addi	sp,sp,-32
    800031e0:	ec06                	sd	ra,24(sp)
    800031e2:	e822                	sd	s0,16(sp)
    800031e4:	e426                	sd	s1,8(sp)
    800031e6:	e04a                	sd	s2,0(sp)
    800031e8:	1000                	addi	s0,sp,32
    800031ea:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800031ec:	01050913          	addi	s2,a0,16
    800031f0:	854a                	mv	a0,s2
    800031f2:	00001097          	auipc	ra,0x1
    800031f6:	428080e7          	jalr	1064(ra) # 8000461a <holdingsleep>
    800031fa:	c535                	beqz	a0,80003266 <brelse+0x88>
    panic("brelse");

  releasesleep(&b->lock);
    800031fc:	854a                	mv	a0,s2
    800031fe:	00001097          	auipc	ra,0x1
    80003202:	3d8080e7          	jalr	984(ra) # 800045d6 <releasesleep>

  acquire(&bcache.lock);
    80003206:	00014517          	auipc	a0,0x14
    8000320a:	0e250513          	addi	a0,a0,226 # 800172e8 <bcache>
    8000320e:	ffffe097          	auipc	ra,0xffffe
    80003212:	a46080e7          	jalr	-1466(ra) # 80000c54 <acquire>
  b->refcnt--;
    80003216:	40bc                	lw	a5,64(s1)
    80003218:	37fd                	addiw	a5,a5,-1
    8000321a:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000321c:	e79d                	bnez	a5,8000324a <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000321e:	68b8                	ld	a4,80(s1)
    80003220:	64bc                	ld	a5,72(s1)
    80003222:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80003224:	68b8                	ld	a4,80(s1)
    80003226:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003228:	0001c797          	auipc	a5,0x1c
    8000322c:	0c078793          	addi	a5,a5,192 # 8001f2e8 <bcache+0x8000>
    80003230:	2b87b703          	ld	a4,696(a5)
    80003234:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003236:	0001c717          	auipc	a4,0x1c
    8000323a:	31a70713          	addi	a4,a4,794 # 8001f550 <bcache+0x8268>
    8000323e:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003240:	2b87b703          	ld	a4,696(a5)
    80003244:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003246:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000324a:	00014517          	auipc	a0,0x14
    8000324e:	09e50513          	addi	a0,a0,158 # 800172e8 <bcache>
    80003252:	ffffe097          	auipc	ra,0xffffe
    80003256:	ab2080e7          	jalr	-1358(ra) # 80000d04 <release>
}
    8000325a:	60e2                	ld	ra,24(sp)
    8000325c:	6442                	ld	s0,16(sp)
    8000325e:	64a2                	ld	s1,8(sp)
    80003260:	6902                	ld	s2,0(sp)
    80003262:	6105                	addi	sp,sp,32
    80003264:	8082                	ret
    panic("brelse");
    80003266:	00005517          	auipc	a0,0x5
    8000326a:	1aa50513          	addi	a0,a0,426 # 80008410 <etext+0x410>
    8000326e:	ffffd097          	auipc	ra,0xffffd
    80003272:	2e8080e7          	jalr	744(ra) # 80000556 <panic>

0000000080003276 <bpin>:

void
bpin(struct buf *b) {
    80003276:	1101                	addi	sp,sp,-32
    80003278:	ec06                	sd	ra,24(sp)
    8000327a:	e822                	sd	s0,16(sp)
    8000327c:	e426                	sd	s1,8(sp)
    8000327e:	1000                	addi	s0,sp,32
    80003280:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003282:	00014517          	auipc	a0,0x14
    80003286:	06650513          	addi	a0,a0,102 # 800172e8 <bcache>
    8000328a:	ffffe097          	auipc	ra,0xffffe
    8000328e:	9ca080e7          	jalr	-1590(ra) # 80000c54 <acquire>
  b->refcnt++;
    80003292:	40bc                	lw	a5,64(s1)
    80003294:	2785                	addiw	a5,a5,1
    80003296:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003298:	00014517          	auipc	a0,0x14
    8000329c:	05050513          	addi	a0,a0,80 # 800172e8 <bcache>
    800032a0:	ffffe097          	auipc	ra,0xffffe
    800032a4:	a64080e7          	jalr	-1436(ra) # 80000d04 <release>
}
    800032a8:	60e2                	ld	ra,24(sp)
    800032aa:	6442                	ld	s0,16(sp)
    800032ac:	64a2                	ld	s1,8(sp)
    800032ae:	6105                	addi	sp,sp,32
    800032b0:	8082                	ret

00000000800032b2 <bunpin>:

void
bunpin(struct buf *b) {
    800032b2:	1101                	addi	sp,sp,-32
    800032b4:	ec06                	sd	ra,24(sp)
    800032b6:	e822                	sd	s0,16(sp)
    800032b8:	e426                	sd	s1,8(sp)
    800032ba:	1000                	addi	s0,sp,32
    800032bc:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800032be:	00014517          	auipc	a0,0x14
    800032c2:	02a50513          	addi	a0,a0,42 # 800172e8 <bcache>
    800032c6:	ffffe097          	auipc	ra,0xffffe
    800032ca:	98e080e7          	jalr	-1650(ra) # 80000c54 <acquire>
  b->refcnt--;
    800032ce:	40bc                	lw	a5,64(s1)
    800032d0:	37fd                	addiw	a5,a5,-1
    800032d2:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800032d4:	00014517          	auipc	a0,0x14
    800032d8:	01450513          	addi	a0,a0,20 # 800172e8 <bcache>
    800032dc:	ffffe097          	auipc	ra,0xffffe
    800032e0:	a28080e7          	jalr	-1496(ra) # 80000d04 <release>
}
    800032e4:	60e2                	ld	ra,24(sp)
    800032e6:	6442                	ld	s0,16(sp)
    800032e8:	64a2                	ld	s1,8(sp)
    800032ea:	6105                	addi	sp,sp,32
    800032ec:	8082                	ret

00000000800032ee <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800032ee:	1101                	addi	sp,sp,-32
    800032f0:	ec06                	sd	ra,24(sp)
    800032f2:	e822                	sd	s0,16(sp)
    800032f4:	e426                	sd	s1,8(sp)
    800032f6:	e04a                	sd	s2,0(sp)
    800032f8:	1000                	addi	s0,sp,32
    800032fa:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800032fc:	00d5d79b          	srliw	a5,a1,0xd
    80003300:	0001c597          	auipc	a1,0x1c
    80003304:	6c45a583          	lw	a1,1732(a1) # 8001f9c4 <sb+0x1c>
    80003308:	9dbd                	addw	a1,a1,a5
    8000330a:	00000097          	auipc	ra,0x0
    8000330e:	da4080e7          	jalr	-604(ra) # 800030ae <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003312:	0074f713          	andi	a4,s1,7
    80003316:	4785                	li	a5,1
    80003318:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    8000331c:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    8000331e:	90d9                	srli	s1,s1,0x36
    80003320:	00950733          	add	a4,a0,s1
    80003324:	05874703          	lbu	a4,88(a4)
    80003328:	00e7f6b3          	and	a3,a5,a4
    8000332c:	c69d                	beqz	a3,8000335a <bfree+0x6c>
    8000332e:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003330:	94aa                	add	s1,s1,a0
    80003332:	fff7c793          	not	a5,a5
    80003336:	8f7d                	and	a4,a4,a5
    80003338:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000333c:	00001097          	auipc	ra,0x1
    80003340:	124080e7          	jalr	292(ra) # 80004460 <log_write>
  brelse(bp);
    80003344:	854a                	mv	a0,s2
    80003346:	00000097          	auipc	ra,0x0
    8000334a:	e98080e7          	jalr	-360(ra) # 800031de <brelse>
}
    8000334e:	60e2                	ld	ra,24(sp)
    80003350:	6442                	ld	s0,16(sp)
    80003352:	64a2                	ld	s1,8(sp)
    80003354:	6902                	ld	s2,0(sp)
    80003356:	6105                	addi	sp,sp,32
    80003358:	8082                	ret
    panic("freeing free block");
    8000335a:	00005517          	auipc	a0,0x5
    8000335e:	0be50513          	addi	a0,a0,190 # 80008418 <etext+0x418>
    80003362:	ffffd097          	auipc	ra,0xffffd
    80003366:	1f4080e7          	jalr	500(ra) # 80000556 <panic>

000000008000336a <balloc>:
{
    8000336a:	715d                	addi	sp,sp,-80
    8000336c:	e486                	sd	ra,72(sp)
    8000336e:	e0a2                	sd	s0,64(sp)
    80003370:	fc26                	sd	s1,56(sp)
    80003372:	f84a                	sd	s2,48(sp)
    80003374:	f44e                	sd	s3,40(sp)
    80003376:	f052                	sd	s4,32(sp)
    80003378:	ec56                	sd	s5,24(sp)
    8000337a:	e85a                	sd	s6,16(sp)
    8000337c:	e45e                	sd	s7,8(sp)
    8000337e:	e062                	sd	s8,0(sp)
    80003380:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    80003382:	0001c797          	auipc	a5,0x1c
    80003386:	62a7a783          	lw	a5,1578(a5) # 8001f9ac <sb+0x4>
    8000338a:	cfb5                	beqz	a5,80003406 <balloc+0x9c>
    8000338c:	8baa                	mv	s7,a0
    8000338e:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003390:	0001cb17          	auipc	s6,0x1c
    80003394:	618b0b13          	addi	s6,s6,1560 # 8001f9a8 <sb>
      m = 1 << (bi % 8);
    80003398:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000339a:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000339c:	6c09                	lui	s8,0x2
    8000339e:	a821                	j	800033b6 <balloc+0x4c>
    brelse(bp);
    800033a0:	854a                	mv	a0,s2
    800033a2:	00000097          	auipc	ra,0x0
    800033a6:	e3c080e7          	jalr	-452(ra) # 800031de <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800033aa:	015c0abb          	addw	s5,s8,s5
    800033ae:	004b2783          	lw	a5,4(s6)
    800033b2:	04fafa63          	bgeu	s5,a5,80003406 <balloc+0x9c>
    bp = bread(dev, BBLOCK(b, sb));
    800033b6:	40dad59b          	sraiw	a1,s5,0xd
    800033ba:	01cb2783          	lw	a5,28(s6)
    800033be:	9dbd                	addw	a1,a1,a5
    800033c0:	855e                	mv	a0,s7
    800033c2:	00000097          	auipc	ra,0x0
    800033c6:	cec080e7          	jalr	-788(ra) # 800030ae <bread>
    800033ca:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800033cc:	004b2503          	lw	a0,4(s6)
    800033d0:	84d6                	mv	s1,s5
    800033d2:	4701                	li	a4,0
    800033d4:	fca4f6e3          	bgeu	s1,a0,800033a0 <balloc+0x36>
      m = 1 << (bi % 8);
    800033d8:	00777693          	andi	a3,a4,7
    800033dc:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800033e0:	41f7579b          	sraiw	a5,a4,0x1f
    800033e4:	01d7d79b          	srliw	a5,a5,0x1d
    800033e8:	9fb9                	addw	a5,a5,a4
    800033ea:	4037d79b          	sraiw	a5,a5,0x3
    800033ee:	00f90633          	add	a2,s2,a5
    800033f2:	05864603          	lbu	a2,88(a2)
    800033f6:	00c6f5b3          	and	a1,a3,a2
    800033fa:	cd91                	beqz	a1,80003416 <balloc+0xac>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800033fc:	2705                	addiw	a4,a4,1
    800033fe:	2485                	addiw	s1,s1,1
    80003400:	fd471ae3          	bne	a4,s4,800033d4 <balloc+0x6a>
    80003404:	bf71                	j	800033a0 <balloc+0x36>
  panic("balloc: out of blocks");
    80003406:	00005517          	auipc	a0,0x5
    8000340a:	02a50513          	addi	a0,a0,42 # 80008430 <etext+0x430>
    8000340e:	ffffd097          	auipc	ra,0xffffd
    80003412:	148080e7          	jalr	328(ra) # 80000556 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003416:	97ca                	add	a5,a5,s2
    80003418:	8e55                	or	a2,a2,a3
    8000341a:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000341e:	854a                	mv	a0,s2
    80003420:	00001097          	auipc	ra,0x1
    80003424:	040080e7          	jalr	64(ra) # 80004460 <log_write>
        brelse(bp);
    80003428:	854a                	mv	a0,s2
    8000342a:	00000097          	auipc	ra,0x0
    8000342e:	db4080e7          	jalr	-588(ra) # 800031de <brelse>
  bp = bread(dev, bno);
    80003432:	85a6                	mv	a1,s1
    80003434:	855e                	mv	a0,s7
    80003436:	00000097          	auipc	ra,0x0
    8000343a:	c78080e7          	jalr	-904(ra) # 800030ae <bread>
    8000343e:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003440:	40000613          	li	a2,1024
    80003444:	4581                	li	a1,0
    80003446:	05850513          	addi	a0,a0,88
    8000344a:	ffffe097          	auipc	ra,0xffffe
    8000344e:	902080e7          	jalr	-1790(ra) # 80000d4c <memset>
  log_write(bp);
    80003452:	854a                	mv	a0,s2
    80003454:	00001097          	auipc	ra,0x1
    80003458:	00c080e7          	jalr	12(ra) # 80004460 <log_write>
  brelse(bp);
    8000345c:	854a                	mv	a0,s2
    8000345e:	00000097          	auipc	ra,0x0
    80003462:	d80080e7          	jalr	-640(ra) # 800031de <brelse>
}
    80003466:	8526                	mv	a0,s1
    80003468:	60a6                	ld	ra,72(sp)
    8000346a:	6406                	ld	s0,64(sp)
    8000346c:	74e2                	ld	s1,56(sp)
    8000346e:	7942                	ld	s2,48(sp)
    80003470:	79a2                	ld	s3,40(sp)
    80003472:	7a02                	ld	s4,32(sp)
    80003474:	6ae2                	ld	s5,24(sp)
    80003476:	6b42                	ld	s6,16(sp)
    80003478:	6ba2                	ld	s7,8(sp)
    8000347a:	6c02                	ld	s8,0(sp)
    8000347c:	6161                	addi	sp,sp,80
    8000347e:	8082                	ret

0000000080003480 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80003480:	7179                	addi	sp,sp,-48
    80003482:	f406                	sd	ra,40(sp)
    80003484:	f022                	sd	s0,32(sp)
    80003486:	ec26                	sd	s1,24(sp)
    80003488:	e84a                	sd	s2,16(sp)
    8000348a:	e44e                	sd	s3,8(sp)
    8000348c:	1800                	addi	s0,sp,48
    8000348e:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003490:	47ad                	li	a5,11
    80003492:	04b7fd63          	bgeu	a5,a1,800034ec <bmap+0x6c>
    80003496:	e052                	sd	s4,0(sp)
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80003498:	ff45849b          	addiw	s1,a1,-12

  if(bn < NINDIRECT){
    8000349c:	0ff00793          	li	a5,255
    800034a0:	0897ef63          	bltu	a5,s1,8000353e <bmap+0xbe>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800034a4:	08052583          	lw	a1,128(a0)
    800034a8:	c5a5                	beqz	a1,80003510 <bmap+0x90>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800034aa:	00092503          	lw	a0,0(s2)
    800034ae:	00000097          	auipc	ra,0x0
    800034b2:	c00080e7          	jalr	-1024(ra) # 800030ae <bread>
    800034b6:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800034b8:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800034bc:	02049713          	slli	a4,s1,0x20
    800034c0:	01e75593          	srli	a1,a4,0x1e
    800034c4:	00b784b3          	add	s1,a5,a1
    800034c8:	0004a983          	lw	s3,0(s1)
    800034cc:	04098b63          	beqz	s3,80003522 <bmap+0xa2>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800034d0:	8552                	mv	a0,s4
    800034d2:	00000097          	auipc	ra,0x0
    800034d6:	d0c080e7          	jalr	-756(ra) # 800031de <brelse>
    return addr;
    800034da:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800034dc:	854e                	mv	a0,s3
    800034de:	70a2                	ld	ra,40(sp)
    800034e0:	7402                	ld	s0,32(sp)
    800034e2:	64e2                	ld	s1,24(sp)
    800034e4:	6942                	ld	s2,16(sp)
    800034e6:	69a2                	ld	s3,8(sp)
    800034e8:	6145                	addi	sp,sp,48
    800034ea:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    800034ec:	02059793          	slli	a5,a1,0x20
    800034f0:	01e7d593          	srli	a1,a5,0x1e
    800034f4:	00b504b3          	add	s1,a0,a1
    800034f8:	0504a983          	lw	s3,80(s1)
    800034fc:	fe0990e3          	bnez	s3,800034dc <bmap+0x5c>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80003500:	4108                	lw	a0,0(a0)
    80003502:	00000097          	auipc	ra,0x0
    80003506:	e68080e7          	jalr	-408(ra) # 8000336a <balloc>
    8000350a:	89aa                	mv	s3,a0
    8000350c:	c8a8                	sw	a0,80(s1)
    8000350e:	b7f9                	j	800034dc <bmap+0x5c>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80003510:	4108                	lw	a0,0(a0)
    80003512:	00000097          	auipc	ra,0x0
    80003516:	e58080e7          	jalr	-424(ra) # 8000336a <balloc>
    8000351a:	85aa                	mv	a1,a0
    8000351c:	08a92023          	sw	a0,128(s2)
    80003520:	b769                	j	800034aa <bmap+0x2a>
      a[bn] = addr = balloc(ip->dev);
    80003522:	00092503          	lw	a0,0(s2)
    80003526:	00000097          	auipc	ra,0x0
    8000352a:	e44080e7          	jalr	-444(ra) # 8000336a <balloc>
    8000352e:	89aa                	mv	s3,a0
    80003530:	c088                	sw	a0,0(s1)
      log_write(bp);
    80003532:	8552                	mv	a0,s4
    80003534:	00001097          	auipc	ra,0x1
    80003538:	f2c080e7          	jalr	-212(ra) # 80004460 <log_write>
    8000353c:	bf51                	j	800034d0 <bmap+0x50>
  panic("bmap: out of range");
    8000353e:	00005517          	auipc	a0,0x5
    80003542:	f0a50513          	addi	a0,a0,-246 # 80008448 <etext+0x448>
    80003546:	ffffd097          	auipc	ra,0xffffd
    8000354a:	010080e7          	jalr	16(ra) # 80000556 <panic>

000000008000354e <iget>:
{
    8000354e:	7179                	addi	sp,sp,-48
    80003550:	f406                	sd	ra,40(sp)
    80003552:	f022                	sd	s0,32(sp)
    80003554:	ec26                	sd	s1,24(sp)
    80003556:	e84a                	sd	s2,16(sp)
    80003558:	e44e                	sd	s3,8(sp)
    8000355a:	e052                	sd	s4,0(sp)
    8000355c:	1800                	addi	s0,sp,48
    8000355e:	892a                	mv	s2,a0
    80003560:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003562:	0001c517          	auipc	a0,0x1c
    80003566:	46650513          	addi	a0,a0,1126 # 8001f9c8 <itable>
    8000356a:	ffffd097          	auipc	ra,0xffffd
    8000356e:	6ea080e7          	jalr	1770(ra) # 80000c54 <acquire>
  empty = 0;
    80003572:	4981                	li	s3,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003574:	0001c497          	auipc	s1,0x1c
    80003578:	46c48493          	addi	s1,s1,1132 # 8001f9e0 <itable+0x18>
    8000357c:	0001e697          	auipc	a3,0x1e
    80003580:	ef468693          	addi	a3,a3,-268 # 80021470 <log>
    80003584:	a809                	j	80003596 <iget+0x48>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003586:	e781                	bnez	a5,8000358e <iget+0x40>
    80003588:	00099363          	bnez	s3,8000358e <iget+0x40>
      empty = ip;
    8000358c:	89a6                	mv	s3,s1
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000358e:	08848493          	addi	s1,s1,136
    80003592:	02d48763          	beq	s1,a3,800035c0 <iget+0x72>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003596:	449c                	lw	a5,8(s1)
    80003598:	fef057e3          	blez	a5,80003586 <iget+0x38>
    8000359c:	4098                	lw	a4,0(s1)
    8000359e:	ff2718e3          	bne	a4,s2,8000358e <iget+0x40>
    800035a2:	40d8                	lw	a4,4(s1)
    800035a4:	ff4715e3          	bne	a4,s4,8000358e <iget+0x40>
      ip->ref++;
    800035a8:	2785                	addiw	a5,a5,1
    800035aa:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800035ac:	0001c517          	auipc	a0,0x1c
    800035b0:	41c50513          	addi	a0,a0,1052 # 8001f9c8 <itable>
    800035b4:	ffffd097          	auipc	ra,0xffffd
    800035b8:	750080e7          	jalr	1872(ra) # 80000d04 <release>
      return ip;
    800035bc:	89a6                	mv	s3,s1
    800035be:	a025                	j	800035e6 <iget+0x98>
  if(empty == 0)
    800035c0:	02098c63          	beqz	s3,800035f8 <iget+0xaa>
  ip->dev = dev;
    800035c4:	0129a023          	sw	s2,0(s3)
  ip->inum = inum;
    800035c8:	0149a223          	sw	s4,4(s3)
  ip->ref = 1;
    800035cc:	4785                	li	a5,1
    800035ce:	00f9a423          	sw	a5,8(s3)
  ip->valid = 0;
    800035d2:	0409a023          	sw	zero,64(s3)
  release(&itable.lock);
    800035d6:	0001c517          	auipc	a0,0x1c
    800035da:	3f250513          	addi	a0,a0,1010 # 8001f9c8 <itable>
    800035de:	ffffd097          	auipc	ra,0xffffd
    800035e2:	726080e7          	jalr	1830(ra) # 80000d04 <release>
}
    800035e6:	854e                	mv	a0,s3
    800035e8:	70a2                	ld	ra,40(sp)
    800035ea:	7402                	ld	s0,32(sp)
    800035ec:	64e2                	ld	s1,24(sp)
    800035ee:	6942                	ld	s2,16(sp)
    800035f0:	69a2                	ld	s3,8(sp)
    800035f2:	6a02                	ld	s4,0(sp)
    800035f4:	6145                	addi	sp,sp,48
    800035f6:	8082                	ret
    panic("iget: no inodes");
    800035f8:	00005517          	auipc	a0,0x5
    800035fc:	e6850513          	addi	a0,a0,-408 # 80008460 <etext+0x460>
    80003600:	ffffd097          	auipc	ra,0xffffd
    80003604:	f56080e7          	jalr	-170(ra) # 80000556 <panic>

0000000080003608 <fsinit>:
fsinit(int dev) {
    80003608:	1101                	addi	sp,sp,-32
    8000360a:	ec06                	sd	ra,24(sp)
    8000360c:	e822                	sd	s0,16(sp)
    8000360e:	e426                	sd	s1,8(sp)
    80003610:	e04a                	sd	s2,0(sp)
    80003612:	1000                	addi	s0,sp,32
    80003614:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003616:	4585                	li	a1,1
    80003618:	00000097          	auipc	ra,0x0
    8000361c:	a96080e7          	jalr	-1386(ra) # 800030ae <bread>
    80003620:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003622:	02000613          	li	a2,32
    80003626:	05850593          	addi	a1,a0,88
    8000362a:	0001c517          	auipc	a0,0x1c
    8000362e:	37e50513          	addi	a0,a0,894 # 8001f9a8 <sb>
    80003632:	ffffd097          	auipc	ra,0xffffd
    80003636:	77a080e7          	jalr	1914(ra) # 80000dac <memmove>
  brelse(bp);
    8000363a:	8526                	mv	a0,s1
    8000363c:	00000097          	auipc	ra,0x0
    80003640:	ba2080e7          	jalr	-1118(ra) # 800031de <brelse>
  if(sb.magic != FSMAGIC)
    80003644:	0001c717          	auipc	a4,0x1c
    80003648:	36472703          	lw	a4,868(a4) # 8001f9a8 <sb>
    8000364c:	102037b7          	lui	a5,0x10203
    80003650:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003654:	02f71163          	bne	a4,a5,80003676 <fsinit+0x6e>
  initlog(dev, &sb);
    80003658:	0001c597          	auipc	a1,0x1c
    8000365c:	35058593          	addi	a1,a1,848 # 8001f9a8 <sb>
    80003660:	854a                	mv	a0,s2
    80003662:	00001097          	auipc	ra,0x1
    80003666:	b78080e7          	jalr	-1160(ra) # 800041da <initlog>
}
    8000366a:	60e2                	ld	ra,24(sp)
    8000366c:	6442                	ld	s0,16(sp)
    8000366e:	64a2                	ld	s1,8(sp)
    80003670:	6902                	ld	s2,0(sp)
    80003672:	6105                	addi	sp,sp,32
    80003674:	8082                	ret
    panic("invalid file system");
    80003676:	00005517          	auipc	a0,0x5
    8000367a:	dfa50513          	addi	a0,a0,-518 # 80008470 <etext+0x470>
    8000367e:	ffffd097          	auipc	ra,0xffffd
    80003682:	ed8080e7          	jalr	-296(ra) # 80000556 <panic>

0000000080003686 <iinit>:
{
    80003686:	7179                	addi	sp,sp,-48
    80003688:	f406                	sd	ra,40(sp)
    8000368a:	f022                	sd	s0,32(sp)
    8000368c:	ec26                	sd	s1,24(sp)
    8000368e:	e84a                	sd	s2,16(sp)
    80003690:	e44e                	sd	s3,8(sp)
    80003692:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003694:	00005597          	auipc	a1,0x5
    80003698:	df458593          	addi	a1,a1,-524 # 80008488 <etext+0x488>
    8000369c:	0001c517          	auipc	a0,0x1c
    800036a0:	32c50513          	addi	a0,a0,812 # 8001f9c8 <itable>
    800036a4:	ffffd097          	auipc	ra,0xffffd
    800036a8:	516080e7          	jalr	1302(ra) # 80000bba <initlock>
  for(i = 0; i < NINODE; i++) {
    800036ac:	0001c497          	auipc	s1,0x1c
    800036b0:	34448493          	addi	s1,s1,836 # 8001f9f0 <itable+0x28>
    800036b4:	0001e997          	auipc	s3,0x1e
    800036b8:	dcc98993          	addi	s3,s3,-564 # 80021480 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800036bc:	00005917          	auipc	s2,0x5
    800036c0:	dd490913          	addi	s2,s2,-556 # 80008490 <etext+0x490>
    800036c4:	85ca                	mv	a1,s2
    800036c6:	8526                	mv	a0,s1
    800036c8:	00001097          	auipc	ra,0x1
    800036cc:	e7e080e7          	jalr	-386(ra) # 80004546 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800036d0:	08848493          	addi	s1,s1,136
    800036d4:	ff3498e3          	bne	s1,s3,800036c4 <iinit+0x3e>
}
    800036d8:	70a2                	ld	ra,40(sp)
    800036da:	7402                	ld	s0,32(sp)
    800036dc:	64e2                	ld	s1,24(sp)
    800036de:	6942                	ld	s2,16(sp)
    800036e0:	69a2                	ld	s3,8(sp)
    800036e2:	6145                	addi	sp,sp,48
    800036e4:	8082                	ret

00000000800036e6 <ialloc>:
{
    800036e6:	7139                	addi	sp,sp,-64
    800036e8:	fc06                	sd	ra,56(sp)
    800036ea:	f822                	sd	s0,48(sp)
    800036ec:	f426                	sd	s1,40(sp)
    800036ee:	f04a                	sd	s2,32(sp)
    800036f0:	ec4e                	sd	s3,24(sp)
    800036f2:	e852                	sd	s4,16(sp)
    800036f4:	e456                	sd	s5,8(sp)
    800036f6:	e05a                	sd	s6,0(sp)
    800036f8:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800036fa:	0001c717          	auipc	a4,0x1c
    800036fe:	2ba72703          	lw	a4,698(a4) # 8001f9b4 <sb+0xc>
    80003702:	4785                	li	a5,1
    80003704:	04e7f863          	bgeu	a5,a4,80003754 <ialloc+0x6e>
    80003708:	8aaa                	mv	s5,a0
    8000370a:	8b2e                	mv	s6,a1
    8000370c:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    8000370e:	0001ca17          	auipc	s4,0x1c
    80003712:	29aa0a13          	addi	s4,s4,666 # 8001f9a8 <sb>
    80003716:	00495593          	srli	a1,s2,0x4
    8000371a:	018a2783          	lw	a5,24(s4)
    8000371e:	9dbd                	addw	a1,a1,a5
    80003720:	8556                	mv	a0,s5
    80003722:	00000097          	auipc	ra,0x0
    80003726:	98c080e7          	jalr	-1652(ra) # 800030ae <bread>
    8000372a:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    8000372c:	05850993          	addi	s3,a0,88
    80003730:	00f97793          	andi	a5,s2,15
    80003734:	079a                	slli	a5,a5,0x6
    80003736:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003738:	00099783          	lh	a5,0(s3)
    8000373c:	c785                	beqz	a5,80003764 <ialloc+0x7e>
    brelse(bp);
    8000373e:	00000097          	auipc	ra,0x0
    80003742:	aa0080e7          	jalr	-1376(ra) # 800031de <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003746:	0905                	addi	s2,s2,1
    80003748:	00ca2703          	lw	a4,12(s4)
    8000374c:	0009079b          	sext.w	a5,s2
    80003750:	fce7e3e3          	bltu	a5,a4,80003716 <ialloc+0x30>
  panic("ialloc: no inodes");
    80003754:	00005517          	auipc	a0,0x5
    80003758:	d4450513          	addi	a0,a0,-700 # 80008498 <etext+0x498>
    8000375c:	ffffd097          	auipc	ra,0xffffd
    80003760:	dfa080e7          	jalr	-518(ra) # 80000556 <panic>
      memset(dip, 0, sizeof(*dip));
    80003764:	04000613          	li	a2,64
    80003768:	4581                	li	a1,0
    8000376a:	854e                	mv	a0,s3
    8000376c:	ffffd097          	auipc	ra,0xffffd
    80003770:	5e0080e7          	jalr	1504(ra) # 80000d4c <memset>
      dip->type = type;
    80003774:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003778:	8526                	mv	a0,s1
    8000377a:	00001097          	auipc	ra,0x1
    8000377e:	ce6080e7          	jalr	-794(ra) # 80004460 <log_write>
      brelse(bp);
    80003782:	8526                	mv	a0,s1
    80003784:	00000097          	auipc	ra,0x0
    80003788:	a5a080e7          	jalr	-1446(ra) # 800031de <brelse>
      return iget(dev, inum);
    8000378c:	0009059b          	sext.w	a1,s2
    80003790:	8556                	mv	a0,s5
    80003792:	00000097          	auipc	ra,0x0
    80003796:	dbc080e7          	jalr	-580(ra) # 8000354e <iget>
}
    8000379a:	70e2                	ld	ra,56(sp)
    8000379c:	7442                	ld	s0,48(sp)
    8000379e:	74a2                	ld	s1,40(sp)
    800037a0:	7902                	ld	s2,32(sp)
    800037a2:	69e2                	ld	s3,24(sp)
    800037a4:	6a42                	ld	s4,16(sp)
    800037a6:	6aa2                	ld	s5,8(sp)
    800037a8:	6b02                	ld	s6,0(sp)
    800037aa:	6121                	addi	sp,sp,64
    800037ac:	8082                	ret

00000000800037ae <iupdate>:
{
    800037ae:	1101                	addi	sp,sp,-32
    800037b0:	ec06                	sd	ra,24(sp)
    800037b2:	e822                	sd	s0,16(sp)
    800037b4:	e426                	sd	s1,8(sp)
    800037b6:	e04a                	sd	s2,0(sp)
    800037b8:	1000                	addi	s0,sp,32
    800037ba:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800037bc:	415c                	lw	a5,4(a0)
    800037be:	0047d79b          	srliw	a5,a5,0x4
    800037c2:	0001c597          	auipc	a1,0x1c
    800037c6:	1fe5a583          	lw	a1,510(a1) # 8001f9c0 <sb+0x18>
    800037ca:	9dbd                	addw	a1,a1,a5
    800037cc:	4108                	lw	a0,0(a0)
    800037ce:	00000097          	auipc	ra,0x0
    800037d2:	8e0080e7          	jalr	-1824(ra) # 800030ae <bread>
    800037d6:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800037d8:	05850793          	addi	a5,a0,88
    800037dc:	40d8                	lw	a4,4(s1)
    800037de:	8b3d                	andi	a4,a4,15
    800037e0:	071a                	slli	a4,a4,0x6
    800037e2:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800037e4:	04449703          	lh	a4,68(s1)
    800037e8:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800037ec:	04649703          	lh	a4,70(s1)
    800037f0:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800037f4:	04849703          	lh	a4,72(s1)
    800037f8:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800037fc:	04a49703          	lh	a4,74(s1)
    80003800:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003804:	44f8                	lw	a4,76(s1)
    80003806:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003808:	03400613          	li	a2,52
    8000380c:	05048593          	addi	a1,s1,80
    80003810:	00c78513          	addi	a0,a5,12
    80003814:	ffffd097          	auipc	ra,0xffffd
    80003818:	598080e7          	jalr	1432(ra) # 80000dac <memmove>
  log_write(bp);
    8000381c:	854a                	mv	a0,s2
    8000381e:	00001097          	auipc	ra,0x1
    80003822:	c42080e7          	jalr	-958(ra) # 80004460 <log_write>
  brelse(bp);
    80003826:	854a                	mv	a0,s2
    80003828:	00000097          	auipc	ra,0x0
    8000382c:	9b6080e7          	jalr	-1610(ra) # 800031de <brelse>
}
    80003830:	60e2                	ld	ra,24(sp)
    80003832:	6442                	ld	s0,16(sp)
    80003834:	64a2                	ld	s1,8(sp)
    80003836:	6902                	ld	s2,0(sp)
    80003838:	6105                	addi	sp,sp,32
    8000383a:	8082                	ret

000000008000383c <idup>:
{
    8000383c:	1101                	addi	sp,sp,-32
    8000383e:	ec06                	sd	ra,24(sp)
    80003840:	e822                	sd	s0,16(sp)
    80003842:	e426                	sd	s1,8(sp)
    80003844:	1000                	addi	s0,sp,32
    80003846:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003848:	0001c517          	auipc	a0,0x1c
    8000384c:	18050513          	addi	a0,a0,384 # 8001f9c8 <itable>
    80003850:	ffffd097          	auipc	ra,0xffffd
    80003854:	404080e7          	jalr	1028(ra) # 80000c54 <acquire>
  ip->ref++;
    80003858:	449c                	lw	a5,8(s1)
    8000385a:	2785                	addiw	a5,a5,1
    8000385c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000385e:	0001c517          	auipc	a0,0x1c
    80003862:	16a50513          	addi	a0,a0,362 # 8001f9c8 <itable>
    80003866:	ffffd097          	auipc	ra,0xffffd
    8000386a:	49e080e7          	jalr	1182(ra) # 80000d04 <release>
}
    8000386e:	8526                	mv	a0,s1
    80003870:	60e2                	ld	ra,24(sp)
    80003872:	6442                	ld	s0,16(sp)
    80003874:	64a2                	ld	s1,8(sp)
    80003876:	6105                	addi	sp,sp,32
    80003878:	8082                	ret

000000008000387a <ilock>:
{
    8000387a:	1101                	addi	sp,sp,-32
    8000387c:	ec06                	sd	ra,24(sp)
    8000387e:	e822                	sd	s0,16(sp)
    80003880:	e426                	sd	s1,8(sp)
    80003882:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003884:	c10d                	beqz	a0,800038a6 <ilock+0x2c>
    80003886:	84aa                	mv	s1,a0
    80003888:	451c                	lw	a5,8(a0)
    8000388a:	00f05e63          	blez	a5,800038a6 <ilock+0x2c>
  acquiresleep(&ip->lock);
    8000388e:	0541                	addi	a0,a0,16
    80003890:	00001097          	auipc	ra,0x1
    80003894:	cf0080e7          	jalr	-784(ra) # 80004580 <acquiresleep>
  if(ip->valid == 0){
    80003898:	40bc                	lw	a5,64(s1)
    8000389a:	cf99                	beqz	a5,800038b8 <ilock+0x3e>
}
    8000389c:	60e2                	ld	ra,24(sp)
    8000389e:	6442                	ld	s0,16(sp)
    800038a0:	64a2                	ld	s1,8(sp)
    800038a2:	6105                	addi	sp,sp,32
    800038a4:	8082                	ret
    800038a6:	e04a                	sd	s2,0(sp)
    panic("ilock");
    800038a8:	00005517          	auipc	a0,0x5
    800038ac:	c0850513          	addi	a0,a0,-1016 # 800084b0 <etext+0x4b0>
    800038b0:	ffffd097          	auipc	ra,0xffffd
    800038b4:	ca6080e7          	jalr	-858(ra) # 80000556 <panic>
    800038b8:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800038ba:	40dc                	lw	a5,4(s1)
    800038bc:	0047d79b          	srliw	a5,a5,0x4
    800038c0:	0001c597          	auipc	a1,0x1c
    800038c4:	1005a583          	lw	a1,256(a1) # 8001f9c0 <sb+0x18>
    800038c8:	9dbd                	addw	a1,a1,a5
    800038ca:	4088                	lw	a0,0(s1)
    800038cc:	fffff097          	auipc	ra,0xfffff
    800038d0:	7e2080e7          	jalr	2018(ra) # 800030ae <bread>
    800038d4:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800038d6:	05850593          	addi	a1,a0,88
    800038da:	40dc                	lw	a5,4(s1)
    800038dc:	8bbd                	andi	a5,a5,15
    800038de:	079a                	slli	a5,a5,0x6
    800038e0:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800038e2:	00059783          	lh	a5,0(a1)
    800038e6:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800038ea:	00259783          	lh	a5,2(a1)
    800038ee:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800038f2:	00459783          	lh	a5,4(a1)
    800038f6:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800038fa:	00659783          	lh	a5,6(a1)
    800038fe:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003902:	459c                	lw	a5,8(a1)
    80003904:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003906:	03400613          	li	a2,52
    8000390a:	05b1                	addi	a1,a1,12
    8000390c:	05048513          	addi	a0,s1,80
    80003910:	ffffd097          	auipc	ra,0xffffd
    80003914:	49c080e7          	jalr	1180(ra) # 80000dac <memmove>
    brelse(bp);
    80003918:	854a                	mv	a0,s2
    8000391a:	00000097          	auipc	ra,0x0
    8000391e:	8c4080e7          	jalr	-1852(ra) # 800031de <brelse>
    ip->valid = 1;
    80003922:	4785                	li	a5,1
    80003924:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003926:	04449783          	lh	a5,68(s1)
    8000392a:	c399                	beqz	a5,80003930 <ilock+0xb6>
    8000392c:	6902                	ld	s2,0(sp)
    8000392e:	b7bd                	j	8000389c <ilock+0x22>
      panic("ilock: no type");
    80003930:	00005517          	auipc	a0,0x5
    80003934:	b8850513          	addi	a0,a0,-1144 # 800084b8 <etext+0x4b8>
    80003938:	ffffd097          	auipc	ra,0xffffd
    8000393c:	c1e080e7          	jalr	-994(ra) # 80000556 <panic>

0000000080003940 <iunlock>:
{
    80003940:	1101                	addi	sp,sp,-32
    80003942:	ec06                	sd	ra,24(sp)
    80003944:	e822                	sd	s0,16(sp)
    80003946:	e426                	sd	s1,8(sp)
    80003948:	e04a                	sd	s2,0(sp)
    8000394a:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    8000394c:	c905                	beqz	a0,8000397c <iunlock+0x3c>
    8000394e:	84aa                	mv	s1,a0
    80003950:	01050913          	addi	s2,a0,16
    80003954:	854a                	mv	a0,s2
    80003956:	00001097          	auipc	ra,0x1
    8000395a:	cc4080e7          	jalr	-828(ra) # 8000461a <holdingsleep>
    8000395e:	cd19                	beqz	a0,8000397c <iunlock+0x3c>
    80003960:	449c                	lw	a5,8(s1)
    80003962:	00f05d63          	blez	a5,8000397c <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003966:	854a                	mv	a0,s2
    80003968:	00001097          	auipc	ra,0x1
    8000396c:	c6e080e7          	jalr	-914(ra) # 800045d6 <releasesleep>
}
    80003970:	60e2                	ld	ra,24(sp)
    80003972:	6442                	ld	s0,16(sp)
    80003974:	64a2                	ld	s1,8(sp)
    80003976:	6902                	ld	s2,0(sp)
    80003978:	6105                	addi	sp,sp,32
    8000397a:	8082                	ret
    panic("iunlock");
    8000397c:	00005517          	auipc	a0,0x5
    80003980:	b4c50513          	addi	a0,a0,-1204 # 800084c8 <etext+0x4c8>
    80003984:	ffffd097          	auipc	ra,0xffffd
    80003988:	bd2080e7          	jalr	-1070(ra) # 80000556 <panic>

000000008000398c <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    8000398c:	7179                	addi	sp,sp,-48
    8000398e:	f406                	sd	ra,40(sp)
    80003990:	f022                	sd	s0,32(sp)
    80003992:	ec26                	sd	s1,24(sp)
    80003994:	e84a                	sd	s2,16(sp)
    80003996:	e44e                	sd	s3,8(sp)
    80003998:	1800                	addi	s0,sp,48
    8000399a:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    8000399c:	05050493          	addi	s1,a0,80
    800039a0:	08050913          	addi	s2,a0,128
    800039a4:	a021                	j	800039ac <itrunc+0x20>
    800039a6:	0491                	addi	s1,s1,4
    800039a8:	01248d63          	beq	s1,s2,800039c2 <itrunc+0x36>
    if(ip->addrs[i]){
    800039ac:	408c                	lw	a1,0(s1)
    800039ae:	dde5                	beqz	a1,800039a6 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    800039b0:	0009a503          	lw	a0,0(s3)
    800039b4:	00000097          	auipc	ra,0x0
    800039b8:	93a080e7          	jalr	-1734(ra) # 800032ee <bfree>
      ip->addrs[i] = 0;
    800039bc:	0004a023          	sw	zero,0(s1)
    800039c0:	b7dd                	j	800039a6 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    800039c2:	0809a583          	lw	a1,128(s3)
    800039c6:	ed99                	bnez	a1,800039e4 <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800039c8:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800039cc:	854e                	mv	a0,s3
    800039ce:	00000097          	auipc	ra,0x0
    800039d2:	de0080e7          	jalr	-544(ra) # 800037ae <iupdate>
}
    800039d6:	70a2                	ld	ra,40(sp)
    800039d8:	7402                	ld	s0,32(sp)
    800039da:	64e2                	ld	s1,24(sp)
    800039dc:	6942                	ld	s2,16(sp)
    800039de:	69a2                	ld	s3,8(sp)
    800039e0:	6145                	addi	sp,sp,48
    800039e2:	8082                	ret
    800039e4:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800039e6:	0009a503          	lw	a0,0(s3)
    800039ea:	fffff097          	auipc	ra,0xfffff
    800039ee:	6c4080e7          	jalr	1732(ra) # 800030ae <bread>
    800039f2:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800039f4:	05850493          	addi	s1,a0,88
    800039f8:	45850913          	addi	s2,a0,1112
    800039fc:	a021                	j	80003a04 <itrunc+0x78>
    800039fe:	0491                	addi	s1,s1,4
    80003a00:	01248b63          	beq	s1,s2,80003a16 <itrunc+0x8a>
      if(a[j])
    80003a04:	408c                	lw	a1,0(s1)
    80003a06:	dde5                	beqz	a1,800039fe <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80003a08:	0009a503          	lw	a0,0(s3)
    80003a0c:	00000097          	auipc	ra,0x0
    80003a10:	8e2080e7          	jalr	-1822(ra) # 800032ee <bfree>
    80003a14:	b7ed                	j	800039fe <itrunc+0x72>
    brelse(bp);
    80003a16:	8552                	mv	a0,s4
    80003a18:	fffff097          	auipc	ra,0xfffff
    80003a1c:	7c6080e7          	jalr	1990(ra) # 800031de <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003a20:	0809a583          	lw	a1,128(s3)
    80003a24:	0009a503          	lw	a0,0(s3)
    80003a28:	00000097          	auipc	ra,0x0
    80003a2c:	8c6080e7          	jalr	-1850(ra) # 800032ee <bfree>
    ip->addrs[NDIRECT] = 0;
    80003a30:	0809a023          	sw	zero,128(s3)
    80003a34:	6a02                	ld	s4,0(sp)
    80003a36:	bf49                	j	800039c8 <itrunc+0x3c>

0000000080003a38 <iput>:
{
    80003a38:	1101                	addi	sp,sp,-32
    80003a3a:	ec06                	sd	ra,24(sp)
    80003a3c:	e822                	sd	s0,16(sp)
    80003a3e:	e426                	sd	s1,8(sp)
    80003a40:	1000                	addi	s0,sp,32
    80003a42:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003a44:	0001c517          	auipc	a0,0x1c
    80003a48:	f8450513          	addi	a0,a0,-124 # 8001f9c8 <itable>
    80003a4c:	ffffd097          	auipc	ra,0xffffd
    80003a50:	208080e7          	jalr	520(ra) # 80000c54 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003a54:	4498                	lw	a4,8(s1)
    80003a56:	4785                	li	a5,1
    80003a58:	02f70263          	beq	a4,a5,80003a7c <iput+0x44>
  ip->ref--;
    80003a5c:	449c                	lw	a5,8(s1)
    80003a5e:	37fd                	addiw	a5,a5,-1
    80003a60:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003a62:	0001c517          	auipc	a0,0x1c
    80003a66:	f6650513          	addi	a0,a0,-154 # 8001f9c8 <itable>
    80003a6a:	ffffd097          	auipc	ra,0xffffd
    80003a6e:	29a080e7          	jalr	666(ra) # 80000d04 <release>
}
    80003a72:	60e2                	ld	ra,24(sp)
    80003a74:	6442                	ld	s0,16(sp)
    80003a76:	64a2                	ld	s1,8(sp)
    80003a78:	6105                	addi	sp,sp,32
    80003a7a:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003a7c:	40bc                	lw	a5,64(s1)
    80003a7e:	dff9                	beqz	a5,80003a5c <iput+0x24>
    80003a80:	04a49783          	lh	a5,74(s1)
    80003a84:	ffe1                	bnez	a5,80003a5c <iput+0x24>
    80003a86:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80003a88:	01048793          	addi	a5,s1,16
    80003a8c:	893e                	mv	s2,a5
    80003a8e:	853e                	mv	a0,a5
    80003a90:	00001097          	auipc	ra,0x1
    80003a94:	af0080e7          	jalr	-1296(ra) # 80004580 <acquiresleep>
    release(&itable.lock);
    80003a98:	0001c517          	auipc	a0,0x1c
    80003a9c:	f3050513          	addi	a0,a0,-208 # 8001f9c8 <itable>
    80003aa0:	ffffd097          	auipc	ra,0xffffd
    80003aa4:	264080e7          	jalr	612(ra) # 80000d04 <release>
    itrunc(ip);
    80003aa8:	8526                	mv	a0,s1
    80003aaa:	00000097          	auipc	ra,0x0
    80003aae:	ee2080e7          	jalr	-286(ra) # 8000398c <itrunc>
    ip->type = 0;
    80003ab2:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003ab6:	8526                	mv	a0,s1
    80003ab8:	00000097          	auipc	ra,0x0
    80003abc:	cf6080e7          	jalr	-778(ra) # 800037ae <iupdate>
    ip->valid = 0;
    80003ac0:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003ac4:	854a                	mv	a0,s2
    80003ac6:	00001097          	auipc	ra,0x1
    80003aca:	b10080e7          	jalr	-1264(ra) # 800045d6 <releasesleep>
    acquire(&itable.lock);
    80003ace:	0001c517          	auipc	a0,0x1c
    80003ad2:	efa50513          	addi	a0,a0,-262 # 8001f9c8 <itable>
    80003ad6:	ffffd097          	auipc	ra,0xffffd
    80003ada:	17e080e7          	jalr	382(ra) # 80000c54 <acquire>
    80003ade:	6902                	ld	s2,0(sp)
    80003ae0:	bfb5                	j	80003a5c <iput+0x24>

0000000080003ae2 <iunlockput>:
{
    80003ae2:	1101                	addi	sp,sp,-32
    80003ae4:	ec06                	sd	ra,24(sp)
    80003ae6:	e822                	sd	s0,16(sp)
    80003ae8:	e426                	sd	s1,8(sp)
    80003aea:	1000                	addi	s0,sp,32
    80003aec:	84aa                	mv	s1,a0
  iunlock(ip);
    80003aee:	00000097          	auipc	ra,0x0
    80003af2:	e52080e7          	jalr	-430(ra) # 80003940 <iunlock>
  iput(ip);
    80003af6:	8526                	mv	a0,s1
    80003af8:	00000097          	auipc	ra,0x0
    80003afc:	f40080e7          	jalr	-192(ra) # 80003a38 <iput>
}
    80003b00:	60e2                	ld	ra,24(sp)
    80003b02:	6442                	ld	s0,16(sp)
    80003b04:	64a2                	ld	s1,8(sp)
    80003b06:	6105                	addi	sp,sp,32
    80003b08:	8082                	ret

0000000080003b0a <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003b0a:	1141                	addi	sp,sp,-16
    80003b0c:	e406                	sd	ra,8(sp)
    80003b0e:	e022                	sd	s0,0(sp)
    80003b10:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003b12:	411c                	lw	a5,0(a0)
    80003b14:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003b16:	415c                	lw	a5,4(a0)
    80003b18:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003b1a:	04451783          	lh	a5,68(a0)
    80003b1e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003b22:	04a51783          	lh	a5,74(a0)
    80003b26:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003b2a:	04c56783          	lwu	a5,76(a0)
    80003b2e:	e99c                	sd	a5,16(a1)
}
    80003b30:	60a2                	ld	ra,8(sp)
    80003b32:	6402                	ld	s0,0(sp)
    80003b34:	0141                	addi	sp,sp,16
    80003b36:	8082                	ret

0000000080003b38 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003b38:	457c                	lw	a5,76(a0)
    80003b3a:	0ed7ea63          	bltu	a5,a3,80003c2e <readi+0xf6>
{
    80003b3e:	7159                	addi	sp,sp,-112
    80003b40:	f486                	sd	ra,104(sp)
    80003b42:	f0a2                	sd	s0,96(sp)
    80003b44:	eca6                	sd	s1,88(sp)
    80003b46:	fc56                	sd	s5,56(sp)
    80003b48:	f85a                	sd	s6,48(sp)
    80003b4a:	f45e                	sd	s7,40(sp)
    80003b4c:	ec66                	sd	s9,24(sp)
    80003b4e:	1880                	addi	s0,sp,112
    80003b50:	8baa                	mv	s7,a0
    80003b52:	8cae                	mv	s9,a1
    80003b54:	8ab2                	mv	s5,a2
    80003b56:	84b6                	mv	s1,a3
    80003b58:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003b5a:	9f35                	addw	a4,a4,a3
    return 0;
    80003b5c:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003b5e:	0ad76763          	bltu	a4,a3,80003c0c <readi+0xd4>
    80003b62:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80003b64:	00e7f463          	bgeu	a5,a4,80003b6c <readi+0x34>
    n = ip->size - off;
    80003b68:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003b6c:	0a0b0f63          	beqz	s6,80003c2a <readi+0xf2>
    80003b70:	e8ca                	sd	s2,80(sp)
    80003b72:	e0d2                	sd	s4,64(sp)
    80003b74:	f062                	sd	s8,32(sp)
    80003b76:	e86a                	sd	s10,16(sp)
    80003b78:	e46e                	sd	s11,8(sp)
    80003b7a:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003b7c:	40000d93          	li	s11,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003b80:	5d7d                	li	s10,-1
    80003b82:	a82d                	j	80003bbc <readi+0x84>
    80003b84:	020a1c13          	slli	s8,s4,0x20
    80003b88:	020c5c13          	srli	s8,s8,0x20
    80003b8c:	05890613          	addi	a2,s2,88
    80003b90:	86e2                	mv	a3,s8
    80003b92:	963e                	add	a2,a2,a5
    80003b94:	85d6                	mv	a1,s5
    80003b96:	8566                	mv	a0,s9
    80003b98:	fffff097          	auipc	ra,0xfffff
    80003b9c:	95e080e7          	jalr	-1698(ra) # 800024f6 <either_copyout>
    80003ba0:	05a50963          	beq	a0,s10,80003bf2 <readi+0xba>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003ba4:	854a                	mv	a0,s2
    80003ba6:	fffff097          	auipc	ra,0xfffff
    80003baa:	638080e7          	jalr	1592(ra) # 800031de <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003bae:	013a09bb          	addw	s3,s4,s3
    80003bb2:	009a04bb          	addw	s1,s4,s1
    80003bb6:	9ae2                	add	s5,s5,s8
    80003bb8:	0769f363          	bgeu	s3,s6,80003c1e <readi+0xe6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003bbc:	000ba903          	lw	s2,0(s7)
    80003bc0:	00a4d59b          	srliw	a1,s1,0xa
    80003bc4:	855e                	mv	a0,s7
    80003bc6:	00000097          	auipc	ra,0x0
    80003bca:	8ba080e7          	jalr	-1862(ra) # 80003480 <bmap>
    80003bce:	85aa                	mv	a1,a0
    80003bd0:	854a                	mv	a0,s2
    80003bd2:	fffff097          	auipc	ra,0xfffff
    80003bd6:	4dc080e7          	jalr	1244(ra) # 800030ae <bread>
    80003bda:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003bdc:	3ff4f793          	andi	a5,s1,1023
    80003be0:	40fd873b          	subw	a4,s11,a5
    80003be4:	413b06bb          	subw	a3,s6,s3
    80003be8:	8a3a                	mv	s4,a4
    80003bea:	f8e6fde3          	bgeu	a3,a4,80003b84 <readi+0x4c>
    80003bee:	8a36                	mv	s4,a3
    80003bf0:	bf51                	j	80003b84 <readi+0x4c>
      brelse(bp);
    80003bf2:	854a                	mv	a0,s2
    80003bf4:	fffff097          	auipc	ra,0xfffff
    80003bf8:	5ea080e7          	jalr	1514(ra) # 800031de <brelse>
      tot = -1;
    80003bfc:	59fd                	li	s3,-1
      break;
    80003bfe:	6946                	ld	s2,80(sp)
    80003c00:	6a06                	ld	s4,64(sp)
    80003c02:	7c02                	ld	s8,32(sp)
    80003c04:	6d42                	ld	s10,16(sp)
    80003c06:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80003c08:	854e                	mv	a0,s3
    80003c0a:	69a6                	ld	s3,72(sp)
}
    80003c0c:	70a6                	ld	ra,104(sp)
    80003c0e:	7406                	ld	s0,96(sp)
    80003c10:	64e6                	ld	s1,88(sp)
    80003c12:	7ae2                	ld	s5,56(sp)
    80003c14:	7b42                	ld	s6,48(sp)
    80003c16:	7ba2                	ld	s7,40(sp)
    80003c18:	6ce2                	ld	s9,24(sp)
    80003c1a:	6165                	addi	sp,sp,112
    80003c1c:	8082                	ret
    80003c1e:	6946                	ld	s2,80(sp)
    80003c20:	6a06                	ld	s4,64(sp)
    80003c22:	7c02                	ld	s8,32(sp)
    80003c24:	6d42                	ld	s10,16(sp)
    80003c26:	6da2                	ld	s11,8(sp)
    80003c28:	b7c5                	j	80003c08 <readi+0xd0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003c2a:	89da                	mv	s3,s6
    80003c2c:	bff1                	j	80003c08 <readi+0xd0>
    return 0;
    80003c2e:	4501                	li	a0,0
}
    80003c30:	8082                	ret

0000000080003c32 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003c32:	457c                	lw	a5,76(a0)
    80003c34:	10d7e963          	bltu	a5,a3,80003d46 <writei+0x114>
{
    80003c38:	7159                	addi	sp,sp,-112
    80003c3a:	f486                	sd	ra,104(sp)
    80003c3c:	f0a2                	sd	s0,96(sp)
    80003c3e:	e8ca                	sd	s2,80(sp)
    80003c40:	fc56                	sd	s5,56(sp)
    80003c42:	f45e                	sd	s7,40(sp)
    80003c44:	f062                	sd	s8,32(sp)
    80003c46:	ec66                	sd	s9,24(sp)
    80003c48:	1880                	addi	s0,sp,112
    80003c4a:	8baa                	mv	s7,a0
    80003c4c:	8cae                	mv	s9,a1
    80003c4e:	8ab2                	mv	s5,a2
    80003c50:	8936                	mv	s2,a3
    80003c52:	8c3a                	mv	s8,a4
  if(off > ip->size || off + n < off)
    80003c54:	00e687bb          	addw	a5,a3,a4
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003c58:	00043737          	lui	a4,0x43
    80003c5c:	0ef76763          	bltu	a4,a5,80003d4a <writei+0x118>
    80003c60:	0ed7e563          	bltu	a5,a3,80003d4a <writei+0x118>
    80003c64:	e0d2                	sd	s4,64(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003c66:	0c0c0863          	beqz	s8,80003d36 <writei+0x104>
    80003c6a:	eca6                	sd	s1,88(sp)
    80003c6c:	e4ce                	sd	s3,72(sp)
    80003c6e:	f85a                	sd	s6,48(sp)
    80003c70:	e86a                	sd	s10,16(sp)
    80003c72:	e46e                	sd	s11,8(sp)
    80003c74:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003c76:	40000d93          	li	s11,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003c7a:	5d7d                	li	s10,-1
    80003c7c:	a091                	j	80003cc0 <writei+0x8e>
    80003c7e:	02099b13          	slli	s6,s3,0x20
    80003c82:	020b5b13          	srli	s6,s6,0x20
    80003c86:	05848513          	addi	a0,s1,88
    80003c8a:	86da                	mv	a3,s6
    80003c8c:	8656                	mv	a2,s5
    80003c8e:	85e6                	mv	a1,s9
    80003c90:	953e                	add	a0,a0,a5
    80003c92:	fffff097          	auipc	ra,0xfffff
    80003c96:	8ba080e7          	jalr	-1862(ra) # 8000254c <either_copyin>
    80003c9a:	05a50e63          	beq	a0,s10,80003cf6 <writei+0xc4>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003c9e:	8526                	mv	a0,s1
    80003ca0:	00000097          	auipc	ra,0x0
    80003ca4:	7c0080e7          	jalr	1984(ra) # 80004460 <log_write>
    brelse(bp);
    80003ca8:	8526                	mv	a0,s1
    80003caa:	fffff097          	auipc	ra,0xfffff
    80003cae:	534080e7          	jalr	1332(ra) # 800031de <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003cb2:	01498a3b          	addw	s4,s3,s4
    80003cb6:	0129893b          	addw	s2,s3,s2
    80003cba:	9ada                	add	s5,s5,s6
    80003cbc:	058a7263          	bgeu	s4,s8,80003d00 <writei+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003cc0:	000ba483          	lw	s1,0(s7)
    80003cc4:	00a9559b          	srliw	a1,s2,0xa
    80003cc8:	855e                	mv	a0,s7
    80003cca:	fffff097          	auipc	ra,0xfffff
    80003cce:	7b6080e7          	jalr	1974(ra) # 80003480 <bmap>
    80003cd2:	85aa                	mv	a1,a0
    80003cd4:	8526                	mv	a0,s1
    80003cd6:	fffff097          	auipc	ra,0xfffff
    80003cda:	3d8080e7          	jalr	984(ra) # 800030ae <bread>
    80003cde:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003ce0:	3ff97793          	andi	a5,s2,1023
    80003ce4:	40fd873b          	subw	a4,s11,a5
    80003ce8:	414c06bb          	subw	a3,s8,s4
    80003cec:	89ba                	mv	s3,a4
    80003cee:	f8e6f8e3          	bgeu	a3,a4,80003c7e <writei+0x4c>
    80003cf2:	89b6                	mv	s3,a3
    80003cf4:	b769                	j	80003c7e <writei+0x4c>
      brelse(bp);
    80003cf6:	8526                	mv	a0,s1
    80003cf8:	fffff097          	auipc	ra,0xfffff
    80003cfc:	4e6080e7          	jalr	1254(ra) # 800031de <brelse>
  }

  if(off > ip->size)
    80003d00:	04cba783          	lw	a5,76(s7)
    80003d04:	0327fb63          	bgeu	a5,s2,80003d3a <writei+0x108>
    ip->size = off;
    80003d08:	052ba623          	sw	s2,76(s7)
    80003d0c:	64e6                	ld	s1,88(sp)
    80003d0e:	69a6                	ld	s3,72(sp)
    80003d10:	7b42                	ld	s6,48(sp)
    80003d12:	6d42                	ld	s10,16(sp)
    80003d14:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003d16:	855e                	mv	a0,s7
    80003d18:	00000097          	auipc	ra,0x0
    80003d1c:	a96080e7          	jalr	-1386(ra) # 800037ae <iupdate>

  return tot;
    80003d20:	8552                	mv	a0,s4
    80003d22:	6a06                	ld	s4,64(sp)
}
    80003d24:	70a6                	ld	ra,104(sp)
    80003d26:	7406                	ld	s0,96(sp)
    80003d28:	6946                	ld	s2,80(sp)
    80003d2a:	7ae2                	ld	s5,56(sp)
    80003d2c:	7ba2                	ld	s7,40(sp)
    80003d2e:	7c02                	ld	s8,32(sp)
    80003d30:	6ce2                	ld	s9,24(sp)
    80003d32:	6165                	addi	sp,sp,112
    80003d34:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003d36:	8a62                	mv	s4,s8
    80003d38:	bff9                	j	80003d16 <writei+0xe4>
    80003d3a:	64e6                	ld	s1,88(sp)
    80003d3c:	69a6                	ld	s3,72(sp)
    80003d3e:	7b42                	ld	s6,48(sp)
    80003d40:	6d42                	ld	s10,16(sp)
    80003d42:	6da2                	ld	s11,8(sp)
    80003d44:	bfc9                	j	80003d16 <writei+0xe4>
    return -1;
    80003d46:	557d                	li	a0,-1
}
    80003d48:	8082                	ret
    return -1;
    80003d4a:	557d                	li	a0,-1
    80003d4c:	bfe1                	j	80003d24 <writei+0xf2>

0000000080003d4e <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003d4e:	1141                	addi	sp,sp,-16
    80003d50:	e406                	sd	ra,8(sp)
    80003d52:	e022                	sd	s0,0(sp)
    80003d54:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003d56:	4639                	li	a2,14
    80003d58:	ffffd097          	auipc	ra,0xffffd
    80003d5c:	0cc080e7          	jalr	204(ra) # 80000e24 <strncmp>
}
    80003d60:	60a2                	ld	ra,8(sp)
    80003d62:	6402                	ld	s0,0(sp)
    80003d64:	0141                	addi	sp,sp,16
    80003d66:	8082                	ret

0000000080003d68 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003d68:	711d                	addi	sp,sp,-96
    80003d6a:	ec86                	sd	ra,88(sp)
    80003d6c:	e8a2                	sd	s0,80(sp)
    80003d6e:	e4a6                	sd	s1,72(sp)
    80003d70:	e0ca                	sd	s2,64(sp)
    80003d72:	fc4e                	sd	s3,56(sp)
    80003d74:	f852                	sd	s4,48(sp)
    80003d76:	f456                	sd	s5,40(sp)
    80003d78:	f05a                	sd	s6,32(sp)
    80003d7a:	ec5e                	sd	s7,24(sp)
    80003d7c:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003d7e:	04451703          	lh	a4,68(a0)
    80003d82:	4785                	li	a5,1
    80003d84:	00f71f63          	bne	a4,a5,80003da2 <dirlookup+0x3a>
    80003d88:	892a                	mv	s2,a0
    80003d8a:	8aae                	mv	s5,a1
    80003d8c:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003d8e:	457c                	lw	a5,76(a0)
    80003d90:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003d92:	fa040a13          	addi	s4,s0,-96
    80003d96:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    80003d98:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003d9c:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003d9e:	e79d                	bnez	a5,80003dcc <dirlookup+0x64>
    80003da0:	a88d                	j	80003e12 <dirlookup+0xaa>
    panic("dirlookup not DIR");
    80003da2:	00004517          	auipc	a0,0x4
    80003da6:	72e50513          	addi	a0,a0,1838 # 800084d0 <etext+0x4d0>
    80003daa:	ffffc097          	auipc	ra,0xffffc
    80003dae:	7ac080e7          	jalr	1964(ra) # 80000556 <panic>
      panic("dirlookup read");
    80003db2:	00004517          	auipc	a0,0x4
    80003db6:	73650513          	addi	a0,a0,1846 # 800084e8 <etext+0x4e8>
    80003dba:	ffffc097          	auipc	ra,0xffffc
    80003dbe:	79c080e7          	jalr	1948(ra) # 80000556 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003dc2:	24c1                	addiw	s1,s1,16
    80003dc4:	04c92783          	lw	a5,76(s2)
    80003dc8:	04f4f463          	bgeu	s1,a5,80003e10 <dirlookup+0xa8>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003dcc:	874e                	mv	a4,s3
    80003dce:	86a6                	mv	a3,s1
    80003dd0:	8652                	mv	a2,s4
    80003dd2:	4581                	li	a1,0
    80003dd4:	854a                	mv	a0,s2
    80003dd6:	00000097          	auipc	ra,0x0
    80003dda:	d62080e7          	jalr	-670(ra) # 80003b38 <readi>
    80003dde:	fd351ae3          	bne	a0,s3,80003db2 <dirlookup+0x4a>
    if(de.inum == 0)
    80003de2:	fa045783          	lhu	a5,-96(s0)
    80003de6:	dff1                	beqz	a5,80003dc2 <dirlookup+0x5a>
    if(namecmp(name, de.name) == 0){
    80003de8:	85da                	mv	a1,s6
    80003dea:	8556                	mv	a0,s5
    80003dec:	00000097          	auipc	ra,0x0
    80003df0:	f62080e7          	jalr	-158(ra) # 80003d4e <namecmp>
    80003df4:	f579                	bnez	a0,80003dc2 <dirlookup+0x5a>
      if(poff)
    80003df6:	000b8463          	beqz	s7,80003dfe <dirlookup+0x96>
        *poff = off;
    80003dfa:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80003dfe:	fa045583          	lhu	a1,-96(s0)
    80003e02:	00092503          	lw	a0,0(s2)
    80003e06:	fffff097          	auipc	ra,0xfffff
    80003e0a:	748080e7          	jalr	1864(ra) # 8000354e <iget>
    80003e0e:	a011                	j	80003e12 <dirlookup+0xaa>
  return 0;
    80003e10:	4501                	li	a0,0
}
    80003e12:	60e6                	ld	ra,88(sp)
    80003e14:	6446                	ld	s0,80(sp)
    80003e16:	64a6                	ld	s1,72(sp)
    80003e18:	6906                	ld	s2,64(sp)
    80003e1a:	79e2                	ld	s3,56(sp)
    80003e1c:	7a42                	ld	s4,48(sp)
    80003e1e:	7aa2                	ld	s5,40(sp)
    80003e20:	7b02                	ld	s6,32(sp)
    80003e22:	6be2                	ld	s7,24(sp)
    80003e24:	6125                	addi	sp,sp,96
    80003e26:	8082                	ret

0000000080003e28 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003e28:	711d                	addi	sp,sp,-96
    80003e2a:	ec86                	sd	ra,88(sp)
    80003e2c:	e8a2                	sd	s0,80(sp)
    80003e2e:	e4a6                	sd	s1,72(sp)
    80003e30:	e0ca                	sd	s2,64(sp)
    80003e32:	fc4e                	sd	s3,56(sp)
    80003e34:	f852                	sd	s4,48(sp)
    80003e36:	f456                	sd	s5,40(sp)
    80003e38:	f05a                	sd	s6,32(sp)
    80003e3a:	ec5e                	sd	s7,24(sp)
    80003e3c:	e862                	sd	s8,16(sp)
    80003e3e:	e466                	sd	s9,8(sp)
    80003e40:	e06a                	sd	s10,0(sp)
    80003e42:	1080                	addi	s0,sp,96
    80003e44:	84aa                	mv	s1,a0
    80003e46:	8b2e                	mv	s6,a1
    80003e48:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003e4a:	00054703          	lbu	a4,0(a0)
    80003e4e:	02f00793          	li	a5,47
    80003e52:	02f70363          	beq	a4,a5,80003e78 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003e56:	ffffe097          	auipc	ra,0xffffe
    80003e5a:	c30080e7          	jalr	-976(ra) # 80001a86 <myproc>
    80003e5e:	15053503          	ld	a0,336(a0)
    80003e62:	00000097          	auipc	ra,0x0
    80003e66:	9da080e7          	jalr	-1574(ra) # 8000383c <idup>
    80003e6a:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003e6c:	02f00993          	li	s3,47
  if(len >= DIRSIZ)
    80003e70:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80003e72:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003e74:	4b85                	li	s7,1
    80003e76:	a87d                	j	80003f34 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    80003e78:	4585                	li	a1,1
    80003e7a:	852e                	mv	a0,a1
    80003e7c:	fffff097          	auipc	ra,0xfffff
    80003e80:	6d2080e7          	jalr	1746(ra) # 8000354e <iget>
    80003e84:	8a2a                	mv	s4,a0
    80003e86:	b7dd                	j	80003e6c <namex+0x44>
      iunlockput(ip);
    80003e88:	8552                	mv	a0,s4
    80003e8a:	00000097          	auipc	ra,0x0
    80003e8e:	c58080e7          	jalr	-936(ra) # 80003ae2 <iunlockput>
      return 0;
    80003e92:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003e94:	8552                	mv	a0,s4
    80003e96:	60e6                	ld	ra,88(sp)
    80003e98:	6446                	ld	s0,80(sp)
    80003e9a:	64a6                	ld	s1,72(sp)
    80003e9c:	6906                	ld	s2,64(sp)
    80003e9e:	79e2                	ld	s3,56(sp)
    80003ea0:	7a42                	ld	s4,48(sp)
    80003ea2:	7aa2                	ld	s5,40(sp)
    80003ea4:	7b02                	ld	s6,32(sp)
    80003ea6:	6be2                	ld	s7,24(sp)
    80003ea8:	6c42                	ld	s8,16(sp)
    80003eaa:	6ca2                	ld	s9,8(sp)
    80003eac:	6d02                	ld	s10,0(sp)
    80003eae:	6125                	addi	sp,sp,96
    80003eb0:	8082                	ret
      iunlock(ip);
    80003eb2:	8552                	mv	a0,s4
    80003eb4:	00000097          	auipc	ra,0x0
    80003eb8:	a8c080e7          	jalr	-1396(ra) # 80003940 <iunlock>
      return ip;
    80003ebc:	bfe1                	j	80003e94 <namex+0x6c>
      iunlockput(ip);
    80003ebe:	8552                	mv	a0,s4
    80003ec0:	00000097          	auipc	ra,0x0
    80003ec4:	c22080e7          	jalr	-990(ra) # 80003ae2 <iunlockput>
      return 0;
    80003ec8:	8a4a                	mv	s4,s2
    80003eca:	b7e9                	j	80003e94 <namex+0x6c>
  len = path - s;
    80003ecc:	40990633          	sub	a2,s2,s1
    80003ed0:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80003ed4:	09ac5c63          	bge	s8,s10,80003f6c <namex+0x144>
    memmove(name, s, DIRSIZ);
    80003ed8:	8666                	mv	a2,s9
    80003eda:	85a6                	mv	a1,s1
    80003edc:	8556                	mv	a0,s5
    80003ede:	ffffd097          	auipc	ra,0xffffd
    80003ee2:	ece080e7          	jalr	-306(ra) # 80000dac <memmove>
    80003ee6:	84ca                	mv	s1,s2
  while(*path == '/')
    80003ee8:	0004c783          	lbu	a5,0(s1)
    80003eec:	01379763          	bne	a5,s3,80003efa <namex+0xd2>
    path++;
    80003ef0:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003ef2:	0004c783          	lbu	a5,0(s1)
    80003ef6:	ff378de3          	beq	a5,s3,80003ef0 <namex+0xc8>
    ilock(ip);
    80003efa:	8552                	mv	a0,s4
    80003efc:	00000097          	auipc	ra,0x0
    80003f00:	97e080e7          	jalr	-1666(ra) # 8000387a <ilock>
    if(ip->type != T_DIR){
    80003f04:	044a1783          	lh	a5,68(s4)
    80003f08:	f97790e3          	bne	a5,s7,80003e88 <namex+0x60>
    if(nameiparent && *path == '\0'){
    80003f0c:	000b0563          	beqz	s6,80003f16 <namex+0xee>
    80003f10:	0004c783          	lbu	a5,0(s1)
    80003f14:	dfd9                	beqz	a5,80003eb2 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003f16:	4601                	li	a2,0
    80003f18:	85d6                	mv	a1,s5
    80003f1a:	8552                	mv	a0,s4
    80003f1c:	00000097          	auipc	ra,0x0
    80003f20:	e4c080e7          	jalr	-436(ra) # 80003d68 <dirlookup>
    80003f24:	892a                	mv	s2,a0
    80003f26:	dd41                	beqz	a0,80003ebe <namex+0x96>
    iunlockput(ip);
    80003f28:	8552                	mv	a0,s4
    80003f2a:	00000097          	auipc	ra,0x0
    80003f2e:	bb8080e7          	jalr	-1096(ra) # 80003ae2 <iunlockput>
    ip = next;
    80003f32:	8a4a                	mv	s4,s2
  while(*path == '/')
    80003f34:	0004c783          	lbu	a5,0(s1)
    80003f38:	01379763          	bne	a5,s3,80003f46 <namex+0x11e>
    path++;
    80003f3c:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003f3e:	0004c783          	lbu	a5,0(s1)
    80003f42:	ff378de3          	beq	a5,s3,80003f3c <namex+0x114>
  if(*path == 0)
    80003f46:	cf9d                	beqz	a5,80003f84 <namex+0x15c>
  while(*path != '/' && *path != 0)
    80003f48:	0004c783          	lbu	a5,0(s1)
    80003f4c:	fd178713          	addi	a4,a5,-47
    80003f50:	cb19                	beqz	a4,80003f66 <namex+0x13e>
    80003f52:	cb91                	beqz	a5,80003f66 <namex+0x13e>
    80003f54:	8926                	mv	s2,s1
    path++;
    80003f56:	0905                	addi	s2,s2,1
  while(*path != '/' && *path != 0)
    80003f58:	00094783          	lbu	a5,0(s2)
    80003f5c:	fd178713          	addi	a4,a5,-47
    80003f60:	d735                	beqz	a4,80003ecc <namex+0xa4>
    80003f62:	fbf5                	bnez	a5,80003f56 <namex+0x12e>
    80003f64:	b7a5                	j	80003ecc <namex+0xa4>
    80003f66:	8926                	mv	s2,s1
  len = path - s;
    80003f68:	4d01                	li	s10,0
    80003f6a:	4601                	li	a2,0
    memmove(name, s, len);
    80003f6c:	2601                	sext.w	a2,a2
    80003f6e:	85a6                	mv	a1,s1
    80003f70:	8556                	mv	a0,s5
    80003f72:	ffffd097          	auipc	ra,0xffffd
    80003f76:	e3a080e7          	jalr	-454(ra) # 80000dac <memmove>
    name[len] = 0;
    80003f7a:	9d56                	add	s10,s10,s5
    80003f7c:	000d0023          	sb	zero,0(s10)
    80003f80:	84ca                	mv	s1,s2
    80003f82:	b79d                	j	80003ee8 <namex+0xc0>
  if(nameiparent){
    80003f84:	f00b08e3          	beqz	s6,80003e94 <namex+0x6c>
    iput(ip);
    80003f88:	8552                	mv	a0,s4
    80003f8a:	00000097          	auipc	ra,0x0
    80003f8e:	aae080e7          	jalr	-1362(ra) # 80003a38 <iput>
    return 0;
    80003f92:	4a01                	li	s4,0
    80003f94:	b701                	j	80003e94 <namex+0x6c>

0000000080003f96 <dirlink>:
{
    80003f96:	715d                	addi	sp,sp,-80
    80003f98:	e486                	sd	ra,72(sp)
    80003f9a:	e0a2                	sd	s0,64(sp)
    80003f9c:	f84a                	sd	s2,48(sp)
    80003f9e:	ec56                	sd	s5,24(sp)
    80003fa0:	e85a                	sd	s6,16(sp)
    80003fa2:	0880                	addi	s0,sp,80
    80003fa4:	892a                	mv	s2,a0
    80003fa6:	8aae                	mv	s5,a1
    80003fa8:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003faa:	4601                	li	a2,0
    80003fac:	00000097          	auipc	ra,0x0
    80003fb0:	dbc080e7          	jalr	-580(ra) # 80003d68 <dirlookup>
    80003fb4:	e129                	bnez	a0,80003ff6 <dirlink+0x60>
    80003fb6:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003fb8:	04c92483          	lw	s1,76(s2)
    80003fbc:	cca9                	beqz	s1,80004016 <dirlink+0x80>
    80003fbe:	f44e                	sd	s3,40(sp)
    80003fc0:	f052                	sd	s4,32(sp)
    80003fc2:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003fc4:	fb040a13          	addi	s4,s0,-80
    80003fc8:	49c1                	li	s3,16
    80003fca:	874e                	mv	a4,s3
    80003fcc:	86a6                	mv	a3,s1
    80003fce:	8652                	mv	a2,s4
    80003fd0:	4581                	li	a1,0
    80003fd2:	854a                	mv	a0,s2
    80003fd4:	00000097          	auipc	ra,0x0
    80003fd8:	b64080e7          	jalr	-1180(ra) # 80003b38 <readi>
    80003fdc:	03351363          	bne	a0,s3,80004002 <dirlink+0x6c>
    if(de.inum == 0)
    80003fe0:	fb045783          	lhu	a5,-80(s0)
    80003fe4:	c79d                	beqz	a5,80004012 <dirlink+0x7c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003fe6:	24c1                	addiw	s1,s1,16
    80003fe8:	04c92783          	lw	a5,76(s2)
    80003fec:	fcf4efe3          	bltu	s1,a5,80003fca <dirlink+0x34>
    80003ff0:	79a2                	ld	s3,40(sp)
    80003ff2:	7a02                	ld	s4,32(sp)
    80003ff4:	a00d                	j	80004016 <dirlink+0x80>
    iput(ip);
    80003ff6:	00000097          	auipc	ra,0x0
    80003ffa:	a42080e7          	jalr	-1470(ra) # 80003a38 <iput>
    return -1;
    80003ffe:	557d                	li	a0,-1
    80004000:	a0a9                	j	8000404a <dirlink+0xb4>
      panic("dirlink read");
    80004002:	00004517          	auipc	a0,0x4
    80004006:	4f650513          	addi	a0,a0,1270 # 800084f8 <etext+0x4f8>
    8000400a:	ffffc097          	auipc	ra,0xffffc
    8000400e:	54c080e7          	jalr	1356(ra) # 80000556 <panic>
    80004012:	79a2                	ld	s3,40(sp)
    80004014:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80004016:	4639                	li	a2,14
    80004018:	85d6                	mv	a1,s5
    8000401a:	fb240513          	addi	a0,s0,-78
    8000401e:	ffffd097          	auipc	ra,0xffffd
    80004022:	e40080e7          	jalr	-448(ra) # 80000e5e <strncpy>
  de.inum = inum;
    80004026:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000402a:	4741                	li	a4,16
    8000402c:	86a6                	mv	a3,s1
    8000402e:	fb040613          	addi	a2,s0,-80
    80004032:	4581                	li	a1,0
    80004034:	854a                	mv	a0,s2
    80004036:	00000097          	auipc	ra,0x0
    8000403a:	bfc080e7          	jalr	-1028(ra) # 80003c32 <writei>
    8000403e:	872a                	mv	a4,a0
    80004040:	47c1                	li	a5,16
  return 0;
    80004042:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004044:	00f71a63          	bne	a4,a5,80004058 <dirlink+0xc2>
    80004048:	74e2                	ld	s1,56(sp)
}
    8000404a:	60a6                	ld	ra,72(sp)
    8000404c:	6406                	ld	s0,64(sp)
    8000404e:	7942                	ld	s2,48(sp)
    80004050:	6ae2                	ld	s5,24(sp)
    80004052:	6b42                	ld	s6,16(sp)
    80004054:	6161                	addi	sp,sp,80
    80004056:	8082                	ret
    80004058:	f44e                	sd	s3,40(sp)
    8000405a:	f052                	sd	s4,32(sp)
    panic("dirlink");
    8000405c:	00004517          	auipc	a0,0x4
    80004060:	5ac50513          	addi	a0,a0,1452 # 80008608 <etext+0x608>
    80004064:	ffffc097          	auipc	ra,0xffffc
    80004068:	4f2080e7          	jalr	1266(ra) # 80000556 <panic>

000000008000406c <namei>:

struct inode*
namei(char *path)
{
    8000406c:	1101                	addi	sp,sp,-32
    8000406e:	ec06                	sd	ra,24(sp)
    80004070:	e822                	sd	s0,16(sp)
    80004072:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80004074:	fe040613          	addi	a2,s0,-32
    80004078:	4581                	li	a1,0
    8000407a:	00000097          	auipc	ra,0x0
    8000407e:	dae080e7          	jalr	-594(ra) # 80003e28 <namex>
}
    80004082:	60e2                	ld	ra,24(sp)
    80004084:	6442                	ld	s0,16(sp)
    80004086:	6105                	addi	sp,sp,32
    80004088:	8082                	ret

000000008000408a <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000408a:	1141                	addi	sp,sp,-16
    8000408c:	e406                	sd	ra,8(sp)
    8000408e:	e022                	sd	s0,0(sp)
    80004090:	0800                	addi	s0,sp,16
    80004092:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80004094:	4585                	li	a1,1
    80004096:	00000097          	auipc	ra,0x0
    8000409a:	d92080e7          	jalr	-622(ra) # 80003e28 <namex>
}
    8000409e:	60a2                	ld	ra,8(sp)
    800040a0:	6402                	ld	s0,0(sp)
    800040a2:	0141                	addi	sp,sp,16
    800040a4:	8082                	ret

00000000800040a6 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800040a6:	1101                	addi	sp,sp,-32
    800040a8:	ec06                	sd	ra,24(sp)
    800040aa:	e822                	sd	s0,16(sp)
    800040ac:	e426                	sd	s1,8(sp)
    800040ae:	e04a                	sd	s2,0(sp)
    800040b0:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800040b2:	0001d917          	auipc	s2,0x1d
    800040b6:	3be90913          	addi	s2,s2,958 # 80021470 <log>
    800040ba:	01892583          	lw	a1,24(s2)
    800040be:	02892503          	lw	a0,40(s2)
    800040c2:	fffff097          	auipc	ra,0xfffff
    800040c6:	fec080e7          	jalr	-20(ra) # 800030ae <bread>
    800040ca:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800040cc:	02c92603          	lw	a2,44(s2)
    800040d0:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800040d2:	00c05f63          	blez	a2,800040f0 <write_head+0x4a>
    800040d6:	0001d717          	auipc	a4,0x1d
    800040da:	3ca70713          	addi	a4,a4,970 # 800214a0 <log+0x30>
    800040de:	87aa                	mv	a5,a0
    800040e0:	060a                	slli	a2,a2,0x2
    800040e2:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    800040e4:	4314                	lw	a3,0(a4)
    800040e6:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    800040e8:	0711                	addi	a4,a4,4
    800040ea:	0791                	addi	a5,a5,4
    800040ec:	fec79ce3          	bne	a5,a2,800040e4 <write_head+0x3e>
  }
  bwrite(buf);
    800040f0:	8526                	mv	a0,s1
    800040f2:	fffff097          	auipc	ra,0xfffff
    800040f6:	0ae080e7          	jalr	174(ra) # 800031a0 <bwrite>
  brelse(buf);
    800040fa:	8526                	mv	a0,s1
    800040fc:	fffff097          	auipc	ra,0xfffff
    80004100:	0e2080e7          	jalr	226(ra) # 800031de <brelse>
}
    80004104:	60e2                	ld	ra,24(sp)
    80004106:	6442                	ld	s0,16(sp)
    80004108:	64a2                	ld	s1,8(sp)
    8000410a:	6902                	ld	s2,0(sp)
    8000410c:	6105                	addi	sp,sp,32
    8000410e:	8082                	ret

0000000080004110 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80004110:	0001d797          	auipc	a5,0x1d
    80004114:	38c7a783          	lw	a5,908(a5) # 8002149c <log+0x2c>
    80004118:	0cf05063          	blez	a5,800041d8 <install_trans+0xc8>
{
    8000411c:	715d                	addi	sp,sp,-80
    8000411e:	e486                	sd	ra,72(sp)
    80004120:	e0a2                	sd	s0,64(sp)
    80004122:	fc26                	sd	s1,56(sp)
    80004124:	f84a                	sd	s2,48(sp)
    80004126:	f44e                	sd	s3,40(sp)
    80004128:	f052                	sd	s4,32(sp)
    8000412a:	ec56                	sd	s5,24(sp)
    8000412c:	e85a                	sd	s6,16(sp)
    8000412e:	e45e                	sd	s7,8(sp)
    80004130:	0880                	addi	s0,sp,80
    80004132:	8b2a                	mv	s6,a0
    80004134:	0001da97          	auipc	s5,0x1d
    80004138:	36ca8a93          	addi	s5,s5,876 # 800214a0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000413c:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000413e:	0001d997          	auipc	s3,0x1d
    80004142:	33298993          	addi	s3,s3,818 # 80021470 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004146:	40000b93          	li	s7,1024
    8000414a:	a00d                	j	8000416c <install_trans+0x5c>
    brelse(lbuf);
    8000414c:	854a                	mv	a0,s2
    8000414e:	fffff097          	auipc	ra,0xfffff
    80004152:	090080e7          	jalr	144(ra) # 800031de <brelse>
    brelse(dbuf);
    80004156:	8526                	mv	a0,s1
    80004158:	fffff097          	auipc	ra,0xfffff
    8000415c:	086080e7          	jalr	134(ra) # 800031de <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004160:	2a05                	addiw	s4,s4,1
    80004162:	0a91                	addi	s5,s5,4
    80004164:	02c9a783          	lw	a5,44(s3)
    80004168:	04fa5d63          	bge	s4,a5,800041c2 <install_trans+0xb2>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000416c:	0189a583          	lw	a1,24(s3)
    80004170:	014585bb          	addw	a1,a1,s4
    80004174:	2585                	addiw	a1,a1,1
    80004176:	0289a503          	lw	a0,40(s3)
    8000417a:	fffff097          	auipc	ra,0xfffff
    8000417e:	f34080e7          	jalr	-204(ra) # 800030ae <bread>
    80004182:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80004184:	000aa583          	lw	a1,0(s5)
    80004188:	0289a503          	lw	a0,40(s3)
    8000418c:	fffff097          	auipc	ra,0xfffff
    80004190:	f22080e7          	jalr	-222(ra) # 800030ae <bread>
    80004194:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004196:	865e                	mv	a2,s7
    80004198:	05890593          	addi	a1,s2,88
    8000419c:	05850513          	addi	a0,a0,88
    800041a0:	ffffd097          	auipc	ra,0xffffd
    800041a4:	c0c080e7          	jalr	-1012(ra) # 80000dac <memmove>
    bwrite(dbuf);  // write dst to disk
    800041a8:	8526                	mv	a0,s1
    800041aa:	fffff097          	auipc	ra,0xfffff
    800041ae:	ff6080e7          	jalr	-10(ra) # 800031a0 <bwrite>
    if(recovering == 0)
    800041b2:	f80b1de3          	bnez	s6,8000414c <install_trans+0x3c>
      bunpin(dbuf);
    800041b6:	8526                	mv	a0,s1
    800041b8:	fffff097          	auipc	ra,0xfffff
    800041bc:	0fa080e7          	jalr	250(ra) # 800032b2 <bunpin>
    800041c0:	b771                	j	8000414c <install_trans+0x3c>
}
    800041c2:	60a6                	ld	ra,72(sp)
    800041c4:	6406                	ld	s0,64(sp)
    800041c6:	74e2                	ld	s1,56(sp)
    800041c8:	7942                	ld	s2,48(sp)
    800041ca:	79a2                	ld	s3,40(sp)
    800041cc:	7a02                	ld	s4,32(sp)
    800041ce:	6ae2                	ld	s5,24(sp)
    800041d0:	6b42                	ld	s6,16(sp)
    800041d2:	6ba2                	ld	s7,8(sp)
    800041d4:	6161                	addi	sp,sp,80
    800041d6:	8082                	ret
    800041d8:	8082                	ret

00000000800041da <initlog>:
{
    800041da:	7179                	addi	sp,sp,-48
    800041dc:	f406                	sd	ra,40(sp)
    800041de:	f022                	sd	s0,32(sp)
    800041e0:	ec26                	sd	s1,24(sp)
    800041e2:	e84a                	sd	s2,16(sp)
    800041e4:	e44e                	sd	s3,8(sp)
    800041e6:	1800                	addi	s0,sp,48
    800041e8:	892a                	mv	s2,a0
    800041ea:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800041ec:	0001d497          	auipc	s1,0x1d
    800041f0:	28448493          	addi	s1,s1,644 # 80021470 <log>
    800041f4:	00004597          	auipc	a1,0x4
    800041f8:	31458593          	addi	a1,a1,788 # 80008508 <etext+0x508>
    800041fc:	8526                	mv	a0,s1
    800041fe:	ffffd097          	auipc	ra,0xffffd
    80004202:	9bc080e7          	jalr	-1604(ra) # 80000bba <initlock>
  log.start = sb->logstart;
    80004206:	0149a583          	lw	a1,20(s3)
    8000420a:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000420c:	0109a783          	lw	a5,16(s3)
    80004210:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80004212:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80004216:	854a                	mv	a0,s2
    80004218:	fffff097          	auipc	ra,0xfffff
    8000421c:	e96080e7          	jalr	-362(ra) # 800030ae <bread>
  log.lh.n = lh->n;
    80004220:	4d30                	lw	a2,88(a0)
    80004222:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80004224:	00c05f63          	blez	a2,80004242 <initlog+0x68>
    80004228:	87aa                	mv	a5,a0
    8000422a:	0001d717          	auipc	a4,0x1d
    8000422e:	27670713          	addi	a4,a4,630 # 800214a0 <log+0x30>
    80004232:	060a                	slli	a2,a2,0x2
    80004234:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80004236:	4ff4                	lw	a3,92(a5)
    80004238:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000423a:	0791                	addi	a5,a5,4
    8000423c:	0711                	addi	a4,a4,4
    8000423e:	fec79ce3          	bne	a5,a2,80004236 <initlog+0x5c>
  brelse(buf);
    80004242:	fffff097          	auipc	ra,0xfffff
    80004246:	f9c080e7          	jalr	-100(ra) # 800031de <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000424a:	4505                	li	a0,1
    8000424c:	00000097          	auipc	ra,0x0
    80004250:	ec4080e7          	jalr	-316(ra) # 80004110 <install_trans>
  log.lh.n = 0;
    80004254:	0001d797          	auipc	a5,0x1d
    80004258:	2407a423          	sw	zero,584(a5) # 8002149c <log+0x2c>
  write_head(); // clear the log
    8000425c:	00000097          	auipc	ra,0x0
    80004260:	e4a080e7          	jalr	-438(ra) # 800040a6 <write_head>
}
    80004264:	70a2                	ld	ra,40(sp)
    80004266:	7402                	ld	s0,32(sp)
    80004268:	64e2                	ld	s1,24(sp)
    8000426a:	6942                	ld	s2,16(sp)
    8000426c:	69a2                	ld	s3,8(sp)
    8000426e:	6145                	addi	sp,sp,48
    80004270:	8082                	ret

0000000080004272 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004272:	1101                	addi	sp,sp,-32
    80004274:	ec06                	sd	ra,24(sp)
    80004276:	e822                	sd	s0,16(sp)
    80004278:	e426                	sd	s1,8(sp)
    8000427a:	e04a                	sd	s2,0(sp)
    8000427c:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000427e:	0001d517          	auipc	a0,0x1d
    80004282:	1f250513          	addi	a0,a0,498 # 80021470 <log>
    80004286:	ffffd097          	auipc	ra,0xffffd
    8000428a:	9ce080e7          	jalr	-1586(ra) # 80000c54 <acquire>
  while(1){
    if(log.committing){
    8000428e:	0001d497          	auipc	s1,0x1d
    80004292:	1e248493          	addi	s1,s1,482 # 80021470 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004296:	4979                	li	s2,30
    80004298:	a039                	j	800042a6 <begin_op+0x34>
      sleep(&log, &log.lock);
    8000429a:	85a6                	mv	a1,s1
    8000429c:	8526                	mv	a0,s1
    8000429e:	ffffe097          	auipc	ra,0xffffe
    800042a2:	eb6080e7          	jalr	-330(ra) # 80002154 <sleep>
    if(log.committing){
    800042a6:	50dc                	lw	a5,36(s1)
    800042a8:	fbed                	bnez	a5,8000429a <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800042aa:	5098                	lw	a4,32(s1)
    800042ac:	2705                	addiw	a4,a4,1
    800042ae:	0027179b          	slliw	a5,a4,0x2
    800042b2:	9fb9                	addw	a5,a5,a4
    800042b4:	0017979b          	slliw	a5,a5,0x1
    800042b8:	54d4                	lw	a3,44(s1)
    800042ba:	9fb5                	addw	a5,a5,a3
    800042bc:	00f95963          	bge	s2,a5,800042ce <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800042c0:	85a6                	mv	a1,s1
    800042c2:	8526                	mv	a0,s1
    800042c4:	ffffe097          	auipc	ra,0xffffe
    800042c8:	e90080e7          	jalr	-368(ra) # 80002154 <sleep>
    800042cc:	bfe9                	j	800042a6 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800042ce:	0001d797          	auipc	a5,0x1d
    800042d2:	1ce7a123          	sw	a4,450(a5) # 80021490 <log+0x20>
      release(&log.lock);
    800042d6:	0001d517          	auipc	a0,0x1d
    800042da:	19a50513          	addi	a0,a0,410 # 80021470 <log>
    800042de:	ffffd097          	auipc	ra,0xffffd
    800042e2:	a26080e7          	jalr	-1498(ra) # 80000d04 <release>
      break;
    }
  }
}
    800042e6:	60e2                	ld	ra,24(sp)
    800042e8:	6442                	ld	s0,16(sp)
    800042ea:	64a2                	ld	s1,8(sp)
    800042ec:	6902                	ld	s2,0(sp)
    800042ee:	6105                	addi	sp,sp,32
    800042f0:	8082                	ret

00000000800042f2 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800042f2:	7139                	addi	sp,sp,-64
    800042f4:	fc06                	sd	ra,56(sp)
    800042f6:	f822                	sd	s0,48(sp)
    800042f8:	f426                	sd	s1,40(sp)
    800042fa:	f04a                	sd	s2,32(sp)
    800042fc:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800042fe:	0001d497          	auipc	s1,0x1d
    80004302:	17248493          	addi	s1,s1,370 # 80021470 <log>
    80004306:	8526                	mv	a0,s1
    80004308:	ffffd097          	auipc	ra,0xffffd
    8000430c:	94c080e7          	jalr	-1716(ra) # 80000c54 <acquire>
  log.outstanding -= 1;
    80004310:	509c                	lw	a5,32(s1)
    80004312:	37fd                	addiw	a5,a5,-1
    80004314:	893e                	mv	s2,a5
    80004316:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80004318:	50dc                	lw	a5,36(s1)
    8000431a:	efb1                	bnez	a5,80004376 <end_op+0x84>
    panic("log.committing");
  if(log.outstanding == 0){
    8000431c:	06091863          	bnez	s2,8000438c <end_op+0x9a>
    do_commit = 1;
    log.committing = 1;
    80004320:	0001d497          	auipc	s1,0x1d
    80004324:	15048493          	addi	s1,s1,336 # 80021470 <log>
    80004328:	4785                	li	a5,1
    8000432a:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000432c:	8526                	mv	a0,s1
    8000432e:	ffffd097          	auipc	ra,0xffffd
    80004332:	9d6080e7          	jalr	-1578(ra) # 80000d04 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004336:	54dc                	lw	a5,44(s1)
    80004338:	08f04063          	bgtz	a5,800043b8 <end_op+0xc6>
    acquire(&log.lock);
    8000433c:	0001d517          	auipc	a0,0x1d
    80004340:	13450513          	addi	a0,a0,308 # 80021470 <log>
    80004344:	ffffd097          	auipc	ra,0xffffd
    80004348:	910080e7          	jalr	-1776(ra) # 80000c54 <acquire>
    log.committing = 0;
    8000434c:	0001d797          	auipc	a5,0x1d
    80004350:	1407a423          	sw	zero,328(a5) # 80021494 <log+0x24>
    wakeup(&log);
    80004354:	0001d517          	auipc	a0,0x1d
    80004358:	11c50513          	addi	a0,a0,284 # 80021470 <log>
    8000435c:	ffffe097          	auipc	ra,0xffffe
    80004360:	f7e080e7          	jalr	-130(ra) # 800022da <wakeup>
    release(&log.lock);
    80004364:	0001d517          	auipc	a0,0x1d
    80004368:	10c50513          	addi	a0,a0,268 # 80021470 <log>
    8000436c:	ffffd097          	auipc	ra,0xffffd
    80004370:	998080e7          	jalr	-1640(ra) # 80000d04 <release>
}
    80004374:	a825                	j	800043ac <end_op+0xba>
    80004376:	ec4e                	sd	s3,24(sp)
    80004378:	e852                	sd	s4,16(sp)
    8000437a:	e456                	sd	s5,8(sp)
    panic("log.committing");
    8000437c:	00004517          	auipc	a0,0x4
    80004380:	19450513          	addi	a0,a0,404 # 80008510 <etext+0x510>
    80004384:	ffffc097          	auipc	ra,0xffffc
    80004388:	1d2080e7          	jalr	466(ra) # 80000556 <panic>
    wakeup(&log);
    8000438c:	0001d517          	auipc	a0,0x1d
    80004390:	0e450513          	addi	a0,a0,228 # 80021470 <log>
    80004394:	ffffe097          	auipc	ra,0xffffe
    80004398:	f46080e7          	jalr	-186(ra) # 800022da <wakeup>
  release(&log.lock);
    8000439c:	0001d517          	auipc	a0,0x1d
    800043a0:	0d450513          	addi	a0,a0,212 # 80021470 <log>
    800043a4:	ffffd097          	auipc	ra,0xffffd
    800043a8:	960080e7          	jalr	-1696(ra) # 80000d04 <release>
}
    800043ac:	70e2                	ld	ra,56(sp)
    800043ae:	7442                	ld	s0,48(sp)
    800043b0:	74a2                	ld	s1,40(sp)
    800043b2:	7902                	ld	s2,32(sp)
    800043b4:	6121                	addi	sp,sp,64
    800043b6:	8082                	ret
    800043b8:	ec4e                	sd	s3,24(sp)
    800043ba:	e852                	sd	s4,16(sp)
    800043bc:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800043be:	0001da97          	auipc	s5,0x1d
    800043c2:	0e2a8a93          	addi	s5,s5,226 # 800214a0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800043c6:	0001da17          	auipc	s4,0x1d
    800043ca:	0aaa0a13          	addi	s4,s4,170 # 80021470 <log>
    800043ce:	018a2583          	lw	a1,24(s4)
    800043d2:	012585bb          	addw	a1,a1,s2
    800043d6:	2585                	addiw	a1,a1,1
    800043d8:	028a2503          	lw	a0,40(s4)
    800043dc:	fffff097          	auipc	ra,0xfffff
    800043e0:	cd2080e7          	jalr	-814(ra) # 800030ae <bread>
    800043e4:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800043e6:	000aa583          	lw	a1,0(s5)
    800043ea:	028a2503          	lw	a0,40(s4)
    800043ee:	fffff097          	auipc	ra,0xfffff
    800043f2:	cc0080e7          	jalr	-832(ra) # 800030ae <bread>
    800043f6:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800043f8:	40000613          	li	a2,1024
    800043fc:	05850593          	addi	a1,a0,88
    80004400:	05848513          	addi	a0,s1,88
    80004404:	ffffd097          	auipc	ra,0xffffd
    80004408:	9a8080e7          	jalr	-1624(ra) # 80000dac <memmove>
    bwrite(to);  // write the log
    8000440c:	8526                	mv	a0,s1
    8000440e:	fffff097          	auipc	ra,0xfffff
    80004412:	d92080e7          	jalr	-622(ra) # 800031a0 <bwrite>
    brelse(from);
    80004416:	854e                	mv	a0,s3
    80004418:	fffff097          	auipc	ra,0xfffff
    8000441c:	dc6080e7          	jalr	-570(ra) # 800031de <brelse>
    brelse(to);
    80004420:	8526                	mv	a0,s1
    80004422:	fffff097          	auipc	ra,0xfffff
    80004426:	dbc080e7          	jalr	-580(ra) # 800031de <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000442a:	2905                	addiw	s2,s2,1
    8000442c:	0a91                	addi	s5,s5,4
    8000442e:	02ca2783          	lw	a5,44(s4)
    80004432:	f8f94ee3          	blt	s2,a5,800043ce <end_op+0xdc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004436:	00000097          	auipc	ra,0x0
    8000443a:	c70080e7          	jalr	-912(ra) # 800040a6 <write_head>
    install_trans(0); // Now install writes to home locations
    8000443e:	4501                	li	a0,0
    80004440:	00000097          	auipc	ra,0x0
    80004444:	cd0080e7          	jalr	-816(ra) # 80004110 <install_trans>
    log.lh.n = 0;
    80004448:	0001d797          	auipc	a5,0x1d
    8000444c:	0407aa23          	sw	zero,84(a5) # 8002149c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004450:	00000097          	auipc	ra,0x0
    80004454:	c56080e7          	jalr	-938(ra) # 800040a6 <write_head>
    80004458:	69e2                	ld	s3,24(sp)
    8000445a:	6a42                	ld	s4,16(sp)
    8000445c:	6aa2                	ld	s5,8(sp)
    8000445e:	bdf9                	j	8000433c <end_op+0x4a>

0000000080004460 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004460:	1101                	addi	sp,sp,-32
    80004462:	ec06                	sd	ra,24(sp)
    80004464:	e822                	sd	s0,16(sp)
    80004466:	e426                	sd	s1,8(sp)
    80004468:	1000                	addi	s0,sp,32
    8000446a:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000446c:	0001d517          	auipc	a0,0x1d
    80004470:	00450513          	addi	a0,a0,4 # 80021470 <log>
    80004474:	ffffc097          	auipc	ra,0xffffc
    80004478:	7e0080e7          	jalr	2016(ra) # 80000c54 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000447c:	0001d617          	auipc	a2,0x1d
    80004480:	02062603          	lw	a2,32(a2) # 8002149c <log+0x2c>
    80004484:	47f5                	li	a5,29
    80004486:	06c7c663          	blt	a5,a2,800044f2 <log_write+0x92>
    8000448a:	0001d797          	auipc	a5,0x1d
    8000448e:	0027a783          	lw	a5,2(a5) # 8002148c <log+0x1c>
    80004492:	37fd                	addiw	a5,a5,-1
    80004494:	04f65f63          	bge	a2,a5,800044f2 <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004498:	0001d797          	auipc	a5,0x1d
    8000449c:	ff87a783          	lw	a5,-8(a5) # 80021490 <log+0x20>
    800044a0:	06f05163          	blez	a5,80004502 <log_write+0xa2>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800044a4:	4781                	li	a5,0
    800044a6:	06c05663          	blez	a2,80004512 <log_write+0xb2>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800044aa:	44cc                	lw	a1,12(s1)
    800044ac:	0001d717          	auipc	a4,0x1d
    800044b0:	ff470713          	addi	a4,a4,-12 # 800214a0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800044b4:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800044b6:	4314                	lw	a3,0(a4)
    800044b8:	04b68d63          	beq	a3,a1,80004512 <log_write+0xb2>
  for (i = 0; i < log.lh.n; i++) {
    800044bc:	2785                	addiw	a5,a5,1
    800044be:	0711                	addi	a4,a4,4
    800044c0:	fef61be3          	bne	a2,a5,800044b6 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800044c4:	060a                	slli	a2,a2,0x2
    800044c6:	02060613          	addi	a2,a2,32
    800044ca:	0001d797          	auipc	a5,0x1d
    800044ce:	fa678793          	addi	a5,a5,-90 # 80021470 <log>
    800044d2:	97b2                	add	a5,a5,a2
    800044d4:	44d8                	lw	a4,12(s1)
    800044d6:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800044d8:	8526                	mv	a0,s1
    800044da:	fffff097          	auipc	ra,0xfffff
    800044de:	d9c080e7          	jalr	-612(ra) # 80003276 <bpin>
    log.lh.n++;
    800044e2:	0001d717          	auipc	a4,0x1d
    800044e6:	f8e70713          	addi	a4,a4,-114 # 80021470 <log>
    800044ea:	575c                	lw	a5,44(a4)
    800044ec:	2785                	addiw	a5,a5,1
    800044ee:	d75c                	sw	a5,44(a4)
    800044f0:	a835                	j	8000452c <log_write+0xcc>
    panic("too big a transaction");
    800044f2:	00004517          	auipc	a0,0x4
    800044f6:	02e50513          	addi	a0,a0,46 # 80008520 <etext+0x520>
    800044fa:	ffffc097          	auipc	ra,0xffffc
    800044fe:	05c080e7          	jalr	92(ra) # 80000556 <panic>
    panic("log_write outside of trans");
    80004502:	00004517          	auipc	a0,0x4
    80004506:	03650513          	addi	a0,a0,54 # 80008538 <etext+0x538>
    8000450a:	ffffc097          	auipc	ra,0xffffc
    8000450e:	04c080e7          	jalr	76(ra) # 80000556 <panic>
  log.lh.block[i] = b->blockno;
    80004512:	00279693          	slli	a3,a5,0x2
    80004516:	02068693          	addi	a3,a3,32
    8000451a:	0001d717          	auipc	a4,0x1d
    8000451e:	f5670713          	addi	a4,a4,-170 # 80021470 <log>
    80004522:	9736                	add	a4,a4,a3
    80004524:	44d4                	lw	a3,12(s1)
    80004526:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004528:	faf608e3          	beq	a2,a5,800044d8 <log_write+0x78>
  }
  release(&log.lock);
    8000452c:	0001d517          	auipc	a0,0x1d
    80004530:	f4450513          	addi	a0,a0,-188 # 80021470 <log>
    80004534:	ffffc097          	auipc	ra,0xffffc
    80004538:	7d0080e7          	jalr	2000(ra) # 80000d04 <release>
}
    8000453c:	60e2                	ld	ra,24(sp)
    8000453e:	6442                	ld	s0,16(sp)
    80004540:	64a2                	ld	s1,8(sp)
    80004542:	6105                	addi	sp,sp,32
    80004544:	8082                	ret

0000000080004546 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004546:	1101                	addi	sp,sp,-32
    80004548:	ec06                	sd	ra,24(sp)
    8000454a:	e822                	sd	s0,16(sp)
    8000454c:	e426                	sd	s1,8(sp)
    8000454e:	e04a                	sd	s2,0(sp)
    80004550:	1000                	addi	s0,sp,32
    80004552:	84aa                	mv	s1,a0
    80004554:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004556:	00004597          	auipc	a1,0x4
    8000455a:	00258593          	addi	a1,a1,2 # 80008558 <etext+0x558>
    8000455e:	0521                	addi	a0,a0,8
    80004560:	ffffc097          	auipc	ra,0xffffc
    80004564:	65a080e7          	jalr	1626(ra) # 80000bba <initlock>
  lk->name = name;
    80004568:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000456c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004570:	0204a423          	sw	zero,40(s1)
}
    80004574:	60e2                	ld	ra,24(sp)
    80004576:	6442                	ld	s0,16(sp)
    80004578:	64a2                	ld	s1,8(sp)
    8000457a:	6902                	ld	s2,0(sp)
    8000457c:	6105                	addi	sp,sp,32
    8000457e:	8082                	ret

0000000080004580 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004580:	1101                	addi	sp,sp,-32
    80004582:	ec06                	sd	ra,24(sp)
    80004584:	e822                	sd	s0,16(sp)
    80004586:	e426                	sd	s1,8(sp)
    80004588:	e04a                	sd	s2,0(sp)
    8000458a:	1000                	addi	s0,sp,32
    8000458c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000458e:	00850913          	addi	s2,a0,8
    80004592:	854a                	mv	a0,s2
    80004594:	ffffc097          	auipc	ra,0xffffc
    80004598:	6c0080e7          	jalr	1728(ra) # 80000c54 <acquire>
  while (lk->locked) {
    8000459c:	409c                	lw	a5,0(s1)
    8000459e:	cb89                	beqz	a5,800045b0 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800045a0:	85ca                	mv	a1,s2
    800045a2:	8526                	mv	a0,s1
    800045a4:	ffffe097          	auipc	ra,0xffffe
    800045a8:	bb0080e7          	jalr	-1104(ra) # 80002154 <sleep>
  while (lk->locked) {
    800045ac:	409c                	lw	a5,0(s1)
    800045ae:	fbed                	bnez	a5,800045a0 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800045b0:	4785                	li	a5,1
    800045b2:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800045b4:	ffffd097          	auipc	ra,0xffffd
    800045b8:	4d2080e7          	jalr	1234(ra) # 80001a86 <myproc>
    800045bc:	591c                	lw	a5,48(a0)
    800045be:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800045c0:	854a                	mv	a0,s2
    800045c2:	ffffc097          	auipc	ra,0xffffc
    800045c6:	742080e7          	jalr	1858(ra) # 80000d04 <release>
}
    800045ca:	60e2                	ld	ra,24(sp)
    800045cc:	6442                	ld	s0,16(sp)
    800045ce:	64a2                	ld	s1,8(sp)
    800045d0:	6902                	ld	s2,0(sp)
    800045d2:	6105                	addi	sp,sp,32
    800045d4:	8082                	ret

00000000800045d6 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800045d6:	1101                	addi	sp,sp,-32
    800045d8:	ec06                	sd	ra,24(sp)
    800045da:	e822                	sd	s0,16(sp)
    800045dc:	e426                	sd	s1,8(sp)
    800045de:	e04a                	sd	s2,0(sp)
    800045e0:	1000                	addi	s0,sp,32
    800045e2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800045e4:	00850913          	addi	s2,a0,8
    800045e8:	854a                	mv	a0,s2
    800045ea:	ffffc097          	auipc	ra,0xffffc
    800045ee:	66a080e7          	jalr	1642(ra) # 80000c54 <acquire>
  lk->locked = 0;
    800045f2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800045f6:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800045fa:	8526                	mv	a0,s1
    800045fc:	ffffe097          	auipc	ra,0xffffe
    80004600:	cde080e7          	jalr	-802(ra) # 800022da <wakeup>
  release(&lk->lk);
    80004604:	854a                	mv	a0,s2
    80004606:	ffffc097          	auipc	ra,0xffffc
    8000460a:	6fe080e7          	jalr	1790(ra) # 80000d04 <release>
}
    8000460e:	60e2                	ld	ra,24(sp)
    80004610:	6442                	ld	s0,16(sp)
    80004612:	64a2                	ld	s1,8(sp)
    80004614:	6902                	ld	s2,0(sp)
    80004616:	6105                	addi	sp,sp,32
    80004618:	8082                	ret

000000008000461a <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000461a:	7179                	addi	sp,sp,-48
    8000461c:	f406                	sd	ra,40(sp)
    8000461e:	f022                	sd	s0,32(sp)
    80004620:	ec26                	sd	s1,24(sp)
    80004622:	e84a                	sd	s2,16(sp)
    80004624:	1800                	addi	s0,sp,48
    80004626:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004628:	00850913          	addi	s2,a0,8
    8000462c:	854a                	mv	a0,s2
    8000462e:	ffffc097          	auipc	ra,0xffffc
    80004632:	626080e7          	jalr	1574(ra) # 80000c54 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004636:	409c                	lw	a5,0(s1)
    80004638:	ef91                	bnez	a5,80004654 <holdingsleep+0x3a>
    8000463a:	4481                	li	s1,0
  release(&lk->lk);
    8000463c:	854a                	mv	a0,s2
    8000463e:	ffffc097          	auipc	ra,0xffffc
    80004642:	6c6080e7          	jalr	1734(ra) # 80000d04 <release>
  return r;
}
    80004646:	8526                	mv	a0,s1
    80004648:	70a2                	ld	ra,40(sp)
    8000464a:	7402                	ld	s0,32(sp)
    8000464c:	64e2                	ld	s1,24(sp)
    8000464e:	6942                	ld	s2,16(sp)
    80004650:	6145                	addi	sp,sp,48
    80004652:	8082                	ret
    80004654:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80004656:	0284a983          	lw	s3,40(s1)
    8000465a:	ffffd097          	auipc	ra,0xffffd
    8000465e:	42c080e7          	jalr	1068(ra) # 80001a86 <myproc>
    80004662:	5904                	lw	s1,48(a0)
    80004664:	413484b3          	sub	s1,s1,s3
    80004668:	0014b493          	seqz	s1,s1
    8000466c:	69a2                	ld	s3,8(sp)
    8000466e:	b7f9                	j	8000463c <holdingsleep+0x22>

0000000080004670 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004670:	1141                	addi	sp,sp,-16
    80004672:	e406                	sd	ra,8(sp)
    80004674:	e022                	sd	s0,0(sp)
    80004676:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004678:	00004597          	auipc	a1,0x4
    8000467c:	ef058593          	addi	a1,a1,-272 # 80008568 <etext+0x568>
    80004680:	0001d517          	auipc	a0,0x1d
    80004684:	f3850513          	addi	a0,a0,-200 # 800215b8 <ftable>
    80004688:	ffffc097          	auipc	ra,0xffffc
    8000468c:	532080e7          	jalr	1330(ra) # 80000bba <initlock>
}
    80004690:	60a2                	ld	ra,8(sp)
    80004692:	6402                	ld	s0,0(sp)
    80004694:	0141                	addi	sp,sp,16
    80004696:	8082                	ret

0000000080004698 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004698:	1101                	addi	sp,sp,-32
    8000469a:	ec06                	sd	ra,24(sp)
    8000469c:	e822                	sd	s0,16(sp)
    8000469e:	e426                	sd	s1,8(sp)
    800046a0:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800046a2:	0001d517          	auipc	a0,0x1d
    800046a6:	f1650513          	addi	a0,a0,-234 # 800215b8 <ftable>
    800046aa:	ffffc097          	auipc	ra,0xffffc
    800046ae:	5aa080e7          	jalr	1450(ra) # 80000c54 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800046b2:	0001d497          	auipc	s1,0x1d
    800046b6:	f1e48493          	addi	s1,s1,-226 # 800215d0 <ftable+0x18>
    800046ba:	0001e717          	auipc	a4,0x1e
    800046be:	eb670713          	addi	a4,a4,-330 # 80022570 <ftable+0xfb8>
    if(f->ref == 0){
    800046c2:	40dc                	lw	a5,4(s1)
    800046c4:	cf99                	beqz	a5,800046e2 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800046c6:	02848493          	addi	s1,s1,40
    800046ca:	fee49ce3          	bne	s1,a4,800046c2 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800046ce:	0001d517          	auipc	a0,0x1d
    800046d2:	eea50513          	addi	a0,a0,-278 # 800215b8 <ftable>
    800046d6:	ffffc097          	auipc	ra,0xffffc
    800046da:	62e080e7          	jalr	1582(ra) # 80000d04 <release>
  return 0;
    800046de:	4481                	li	s1,0
    800046e0:	a819                	j	800046f6 <filealloc+0x5e>
      f->ref = 1;
    800046e2:	4785                	li	a5,1
    800046e4:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800046e6:	0001d517          	auipc	a0,0x1d
    800046ea:	ed250513          	addi	a0,a0,-302 # 800215b8 <ftable>
    800046ee:	ffffc097          	auipc	ra,0xffffc
    800046f2:	616080e7          	jalr	1558(ra) # 80000d04 <release>
}
    800046f6:	8526                	mv	a0,s1
    800046f8:	60e2                	ld	ra,24(sp)
    800046fa:	6442                	ld	s0,16(sp)
    800046fc:	64a2                	ld	s1,8(sp)
    800046fe:	6105                	addi	sp,sp,32
    80004700:	8082                	ret

0000000080004702 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004702:	1101                	addi	sp,sp,-32
    80004704:	ec06                	sd	ra,24(sp)
    80004706:	e822                	sd	s0,16(sp)
    80004708:	e426                	sd	s1,8(sp)
    8000470a:	1000                	addi	s0,sp,32
    8000470c:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000470e:	0001d517          	auipc	a0,0x1d
    80004712:	eaa50513          	addi	a0,a0,-342 # 800215b8 <ftable>
    80004716:	ffffc097          	auipc	ra,0xffffc
    8000471a:	53e080e7          	jalr	1342(ra) # 80000c54 <acquire>
  if(f->ref < 1)
    8000471e:	40dc                	lw	a5,4(s1)
    80004720:	02f05263          	blez	a5,80004744 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004724:	2785                	addiw	a5,a5,1
    80004726:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004728:	0001d517          	auipc	a0,0x1d
    8000472c:	e9050513          	addi	a0,a0,-368 # 800215b8 <ftable>
    80004730:	ffffc097          	auipc	ra,0xffffc
    80004734:	5d4080e7          	jalr	1492(ra) # 80000d04 <release>
  return f;
}
    80004738:	8526                	mv	a0,s1
    8000473a:	60e2                	ld	ra,24(sp)
    8000473c:	6442                	ld	s0,16(sp)
    8000473e:	64a2                	ld	s1,8(sp)
    80004740:	6105                	addi	sp,sp,32
    80004742:	8082                	ret
    panic("filedup");
    80004744:	00004517          	auipc	a0,0x4
    80004748:	e2c50513          	addi	a0,a0,-468 # 80008570 <etext+0x570>
    8000474c:	ffffc097          	auipc	ra,0xffffc
    80004750:	e0a080e7          	jalr	-502(ra) # 80000556 <panic>

0000000080004754 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004754:	7139                	addi	sp,sp,-64
    80004756:	fc06                	sd	ra,56(sp)
    80004758:	f822                	sd	s0,48(sp)
    8000475a:	f426                	sd	s1,40(sp)
    8000475c:	0080                	addi	s0,sp,64
    8000475e:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004760:	0001d517          	auipc	a0,0x1d
    80004764:	e5850513          	addi	a0,a0,-424 # 800215b8 <ftable>
    80004768:	ffffc097          	auipc	ra,0xffffc
    8000476c:	4ec080e7          	jalr	1260(ra) # 80000c54 <acquire>
  if(f->ref < 1)
    80004770:	40dc                	lw	a5,4(s1)
    80004772:	04f05c63          	blez	a5,800047ca <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80004776:	37fd                	addiw	a5,a5,-1
    80004778:	c0dc                	sw	a5,4(s1)
    8000477a:	06f04463          	bgtz	a5,800047e2 <fileclose+0x8e>
    8000477e:	f04a                	sd	s2,32(sp)
    80004780:	ec4e                	sd	s3,24(sp)
    80004782:	e852                	sd	s4,16(sp)
    80004784:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004786:	0004a903          	lw	s2,0(s1)
    8000478a:	0094c783          	lbu	a5,9(s1)
    8000478e:	89be                	mv	s3,a5
    80004790:	689c                	ld	a5,16(s1)
    80004792:	8a3e                	mv	s4,a5
    80004794:	6c9c                	ld	a5,24(s1)
    80004796:	8abe                	mv	s5,a5
  f->ref = 0;
    80004798:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000479c:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800047a0:	0001d517          	auipc	a0,0x1d
    800047a4:	e1850513          	addi	a0,a0,-488 # 800215b8 <ftable>
    800047a8:	ffffc097          	auipc	ra,0xffffc
    800047ac:	55c080e7          	jalr	1372(ra) # 80000d04 <release>

  if(ff.type == FD_PIPE){
    800047b0:	4785                	li	a5,1
    800047b2:	04f90563          	beq	s2,a5,800047fc <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800047b6:	ffe9079b          	addiw	a5,s2,-2
    800047ba:	4705                	li	a4,1
    800047bc:	04f77b63          	bgeu	a4,a5,80004812 <fileclose+0xbe>
    800047c0:	7902                	ld	s2,32(sp)
    800047c2:	69e2                	ld	s3,24(sp)
    800047c4:	6a42                	ld	s4,16(sp)
    800047c6:	6aa2                	ld	s5,8(sp)
    800047c8:	a02d                	j	800047f2 <fileclose+0x9e>
    800047ca:	f04a                	sd	s2,32(sp)
    800047cc:	ec4e                	sd	s3,24(sp)
    800047ce:	e852                	sd	s4,16(sp)
    800047d0:	e456                	sd	s5,8(sp)
    panic("fileclose");
    800047d2:	00004517          	auipc	a0,0x4
    800047d6:	da650513          	addi	a0,a0,-602 # 80008578 <etext+0x578>
    800047da:	ffffc097          	auipc	ra,0xffffc
    800047de:	d7c080e7          	jalr	-644(ra) # 80000556 <panic>
    release(&ftable.lock);
    800047e2:	0001d517          	auipc	a0,0x1d
    800047e6:	dd650513          	addi	a0,a0,-554 # 800215b8 <ftable>
    800047ea:	ffffc097          	auipc	ra,0xffffc
    800047ee:	51a080e7          	jalr	1306(ra) # 80000d04 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    800047f2:	70e2                	ld	ra,56(sp)
    800047f4:	7442                	ld	s0,48(sp)
    800047f6:	74a2                	ld	s1,40(sp)
    800047f8:	6121                	addi	sp,sp,64
    800047fa:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800047fc:	85ce                	mv	a1,s3
    800047fe:	8552                	mv	a0,s4
    80004800:	00000097          	auipc	ra,0x0
    80004804:	3b4080e7          	jalr	948(ra) # 80004bb4 <pipeclose>
    80004808:	7902                	ld	s2,32(sp)
    8000480a:	69e2                	ld	s3,24(sp)
    8000480c:	6a42                	ld	s4,16(sp)
    8000480e:	6aa2                	ld	s5,8(sp)
    80004810:	b7cd                	j	800047f2 <fileclose+0x9e>
    begin_op();
    80004812:	00000097          	auipc	ra,0x0
    80004816:	a60080e7          	jalr	-1440(ra) # 80004272 <begin_op>
    iput(ff.ip);
    8000481a:	8556                	mv	a0,s5
    8000481c:	fffff097          	auipc	ra,0xfffff
    80004820:	21c080e7          	jalr	540(ra) # 80003a38 <iput>
    end_op();
    80004824:	00000097          	auipc	ra,0x0
    80004828:	ace080e7          	jalr	-1330(ra) # 800042f2 <end_op>
    8000482c:	7902                	ld	s2,32(sp)
    8000482e:	69e2                	ld	s3,24(sp)
    80004830:	6a42                	ld	s4,16(sp)
    80004832:	6aa2                	ld	s5,8(sp)
    80004834:	bf7d                	j	800047f2 <fileclose+0x9e>

0000000080004836 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004836:	715d                	addi	sp,sp,-80
    80004838:	e486                	sd	ra,72(sp)
    8000483a:	e0a2                	sd	s0,64(sp)
    8000483c:	fc26                	sd	s1,56(sp)
    8000483e:	f052                	sd	s4,32(sp)
    80004840:	0880                	addi	s0,sp,80
    80004842:	84aa                	mv	s1,a0
    80004844:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    80004846:	ffffd097          	auipc	ra,0xffffd
    8000484a:	240080e7          	jalr	576(ra) # 80001a86 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    8000484e:	409c                	lw	a5,0(s1)
    80004850:	37f9                	addiw	a5,a5,-2
    80004852:	4705                	li	a4,1
    80004854:	04f76a63          	bltu	a4,a5,800048a8 <filestat+0x72>
    80004858:	f84a                	sd	s2,48(sp)
    8000485a:	f44e                	sd	s3,40(sp)
    8000485c:	89aa                	mv	s3,a0
    ilock(f->ip);
    8000485e:	6c88                	ld	a0,24(s1)
    80004860:	fffff097          	auipc	ra,0xfffff
    80004864:	01a080e7          	jalr	26(ra) # 8000387a <ilock>
    stati(f->ip, &st);
    80004868:	fb840913          	addi	s2,s0,-72
    8000486c:	85ca                	mv	a1,s2
    8000486e:	6c88                	ld	a0,24(s1)
    80004870:	fffff097          	auipc	ra,0xfffff
    80004874:	29a080e7          	jalr	666(ra) # 80003b0a <stati>
    iunlock(f->ip);
    80004878:	6c88                	ld	a0,24(s1)
    8000487a:	fffff097          	auipc	ra,0xfffff
    8000487e:	0c6080e7          	jalr	198(ra) # 80003940 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004882:	46e1                	li	a3,24
    80004884:	864a                	mv	a2,s2
    80004886:	85d2                	mv	a1,s4
    80004888:	0509b503          	ld	a0,80(s3)
    8000488c:	ffffd097          	auipc	ra,0xffffd
    80004890:	e7e080e7          	jalr	-386(ra) # 8000170a <copyout>
    80004894:	41f5551b          	sraiw	a0,a0,0x1f
    80004898:	7942                	ld	s2,48(sp)
    8000489a:	79a2                	ld	s3,40(sp)
      return -1;
    return 0;
  }
  return -1;
}
    8000489c:	60a6                	ld	ra,72(sp)
    8000489e:	6406                	ld	s0,64(sp)
    800048a0:	74e2                	ld	s1,56(sp)
    800048a2:	7a02                	ld	s4,32(sp)
    800048a4:	6161                	addi	sp,sp,80
    800048a6:	8082                	ret
  return -1;
    800048a8:	557d                	li	a0,-1
    800048aa:	bfcd                	j	8000489c <filestat+0x66>

00000000800048ac <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800048ac:	7179                	addi	sp,sp,-48
    800048ae:	f406                	sd	ra,40(sp)
    800048b0:	f022                	sd	s0,32(sp)
    800048b2:	e84a                	sd	s2,16(sp)
    800048b4:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800048b6:	00854783          	lbu	a5,8(a0)
    800048ba:	cbc5                	beqz	a5,8000496a <fileread+0xbe>
    800048bc:	ec26                	sd	s1,24(sp)
    800048be:	e44e                	sd	s3,8(sp)
    800048c0:	84aa                	mv	s1,a0
    800048c2:	892e                	mv	s2,a1
    800048c4:	89b2                	mv	s3,a2
    return -1;

  if(f->type == FD_PIPE){
    800048c6:	411c                	lw	a5,0(a0)
    800048c8:	4705                	li	a4,1
    800048ca:	04e78963          	beq	a5,a4,8000491c <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800048ce:	470d                	li	a4,3
    800048d0:	04e78f63          	beq	a5,a4,8000492e <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800048d4:	4709                	li	a4,2
    800048d6:	08e79263          	bne	a5,a4,8000495a <fileread+0xae>
    ilock(f->ip);
    800048da:	6d08                	ld	a0,24(a0)
    800048dc:	fffff097          	auipc	ra,0xfffff
    800048e0:	f9e080e7          	jalr	-98(ra) # 8000387a <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800048e4:	874e                	mv	a4,s3
    800048e6:	5094                	lw	a3,32(s1)
    800048e8:	864a                	mv	a2,s2
    800048ea:	4585                	li	a1,1
    800048ec:	6c88                	ld	a0,24(s1)
    800048ee:	fffff097          	auipc	ra,0xfffff
    800048f2:	24a080e7          	jalr	586(ra) # 80003b38 <readi>
    800048f6:	892a                	mv	s2,a0
    800048f8:	00a05563          	blez	a0,80004902 <fileread+0x56>
      f->off += r;
    800048fc:	509c                	lw	a5,32(s1)
    800048fe:	9fa9                	addw	a5,a5,a0
    80004900:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004902:	6c88                	ld	a0,24(s1)
    80004904:	fffff097          	auipc	ra,0xfffff
    80004908:	03c080e7          	jalr	60(ra) # 80003940 <iunlock>
    8000490c:	64e2                	ld	s1,24(sp)
    8000490e:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80004910:	854a                	mv	a0,s2
    80004912:	70a2                	ld	ra,40(sp)
    80004914:	7402                	ld	s0,32(sp)
    80004916:	6942                	ld	s2,16(sp)
    80004918:	6145                	addi	sp,sp,48
    8000491a:	8082                	ret
    r = piperead(f->pipe, addr, n);
    8000491c:	6908                	ld	a0,16(a0)
    8000491e:	00000097          	auipc	ra,0x0
    80004922:	422080e7          	jalr	1058(ra) # 80004d40 <piperead>
    80004926:	892a                	mv	s2,a0
    80004928:	64e2                	ld	s1,24(sp)
    8000492a:	69a2                	ld	s3,8(sp)
    8000492c:	b7d5                	j	80004910 <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000492e:	02451783          	lh	a5,36(a0)
    80004932:	03079693          	slli	a3,a5,0x30
    80004936:	92c1                	srli	a3,a3,0x30
    80004938:	4725                	li	a4,9
    8000493a:	02d76b63          	bltu	a4,a3,80004970 <fileread+0xc4>
    8000493e:	0792                	slli	a5,a5,0x4
    80004940:	0001d717          	auipc	a4,0x1d
    80004944:	bd870713          	addi	a4,a4,-1064 # 80021518 <devsw>
    80004948:	97ba                	add	a5,a5,a4
    8000494a:	639c                	ld	a5,0(a5)
    8000494c:	c79d                	beqz	a5,8000497a <fileread+0xce>
    r = devsw[f->major].read(1, addr, n);
    8000494e:	4505                	li	a0,1
    80004950:	9782                	jalr	a5
    80004952:	892a                	mv	s2,a0
    80004954:	64e2                	ld	s1,24(sp)
    80004956:	69a2                	ld	s3,8(sp)
    80004958:	bf65                	j	80004910 <fileread+0x64>
    panic("fileread");
    8000495a:	00004517          	auipc	a0,0x4
    8000495e:	c2e50513          	addi	a0,a0,-978 # 80008588 <etext+0x588>
    80004962:	ffffc097          	auipc	ra,0xffffc
    80004966:	bf4080e7          	jalr	-1036(ra) # 80000556 <panic>
    return -1;
    8000496a:	57fd                	li	a5,-1
    8000496c:	893e                	mv	s2,a5
    8000496e:	b74d                	j	80004910 <fileread+0x64>
      return -1;
    80004970:	57fd                	li	a5,-1
    80004972:	893e                	mv	s2,a5
    80004974:	64e2                	ld	s1,24(sp)
    80004976:	69a2                	ld	s3,8(sp)
    80004978:	bf61                	j	80004910 <fileread+0x64>
    8000497a:	57fd                	li	a5,-1
    8000497c:	893e                	mv	s2,a5
    8000497e:	64e2                	ld	s1,24(sp)
    80004980:	69a2                	ld	s3,8(sp)
    80004982:	b779                	j	80004910 <fileread+0x64>

0000000080004984 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004984:	00954783          	lbu	a5,9(a0)
    80004988:	12078d63          	beqz	a5,80004ac2 <filewrite+0x13e>
{
    8000498c:	711d                	addi	sp,sp,-96
    8000498e:	ec86                	sd	ra,88(sp)
    80004990:	e8a2                	sd	s0,80(sp)
    80004992:	e0ca                	sd	s2,64(sp)
    80004994:	f456                	sd	s5,40(sp)
    80004996:	f05a                	sd	s6,32(sp)
    80004998:	1080                	addi	s0,sp,96
    8000499a:	892a                	mv	s2,a0
    8000499c:	8b2e                	mv	s6,a1
    8000499e:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    800049a0:	411c                	lw	a5,0(a0)
    800049a2:	4705                	li	a4,1
    800049a4:	02e78a63          	beq	a5,a4,800049d8 <filewrite+0x54>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800049a8:	470d                	li	a4,3
    800049aa:	02e78d63          	beq	a5,a4,800049e4 <filewrite+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800049ae:	4709                	li	a4,2
    800049b0:	0ee79b63          	bne	a5,a4,80004aa6 <filewrite+0x122>
    800049b4:	f852                	sd	s4,48(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800049b6:	0cc05663          	blez	a2,80004a82 <filewrite+0xfe>
    800049ba:	e4a6                	sd	s1,72(sp)
    800049bc:	fc4e                	sd	s3,56(sp)
    800049be:	ec5e                	sd	s7,24(sp)
    800049c0:	e862                	sd	s8,16(sp)
    800049c2:	e466                	sd	s9,8(sp)
    int i = 0;
    800049c4:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    800049c6:	6b85                	lui	s7,0x1
    800049c8:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800049cc:	6785                	lui	a5,0x1
    800049ce:	c007879b          	addiw	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    800049d2:	8cbe                	mv	s9,a5
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800049d4:	4c05                	li	s8,1
    800049d6:	a849                	j	80004a68 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    800049d8:	6908                	ld	a0,16(a0)
    800049da:	00000097          	auipc	ra,0x0
    800049de:	250080e7          	jalr	592(ra) # 80004c2a <pipewrite>
    800049e2:	a85d                	j	80004a98 <filewrite+0x114>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800049e4:	02451783          	lh	a5,36(a0)
    800049e8:	03079693          	slli	a3,a5,0x30
    800049ec:	92c1                	srli	a3,a3,0x30
    800049ee:	4725                	li	a4,9
    800049f0:	0cd76b63          	bltu	a4,a3,80004ac6 <filewrite+0x142>
    800049f4:	0792                	slli	a5,a5,0x4
    800049f6:	0001d717          	auipc	a4,0x1d
    800049fa:	b2270713          	addi	a4,a4,-1246 # 80021518 <devsw>
    800049fe:	97ba                	add	a5,a5,a4
    80004a00:	679c                	ld	a5,8(a5)
    80004a02:	c7e1                	beqz	a5,80004aca <filewrite+0x146>
    ret = devsw[f->major].write(1, addr, n);
    80004a04:	4505                	li	a0,1
    80004a06:	9782                	jalr	a5
    80004a08:	a841                	j	80004a98 <filewrite+0x114>
      if(n1 > max)
    80004a0a:	2981                	sext.w	s3,s3
      begin_op();
    80004a0c:	00000097          	auipc	ra,0x0
    80004a10:	866080e7          	jalr	-1946(ra) # 80004272 <begin_op>
      ilock(f->ip);
    80004a14:	01893503          	ld	a0,24(s2)
    80004a18:	fffff097          	auipc	ra,0xfffff
    80004a1c:	e62080e7          	jalr	-414(ra) # 8000387a <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004a20:	874e                	mv	a4,s3
    80004a22:	02092683          	lw	a3,32(s2)
    80004a26:	016a0633          	add	a2,s4,s6
    80004a2a:	85e2                	mv	a1,s8
    80004a2c:	01893503          	ld	a0,24(s2)
    80004a30:	fffff097          	auipc	ra,0xfffff
    80004a34:	202080e7          	jalr	514(ra) # 80003c32 <writei>
    80004a38:	84aa                	mv	s1,a0
    80004a3a:	00a05763          	blez	a0,80004a48 <filewrite+0xc4>
        f->off += r;
    80004a3e:	02092783          	lw	a5,32(s2)
    80004a42:	9fa9                	addw	a5,a5,a0
    80004a44:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004a48:	01893503          	ld	a0,24(s2)
    80004a4c:	fffff097          	auipc	ra,0xfffff
    80004a50:	ef4080e7          	jalr	-268(ra) # 80003940 <iunlock>
      end_op();
    80004a54:	00000097          	auipc	ra,0x0
    80004a58:	89e080e7          	jalr	-1890(ra) # 800042f2 <end_op>

      if(r != n1){
    80004a5c:	02999563          	bne	s3,s1,80004a86 <filewrite+0x102>
        // error from writei
        break;
      }
      i += r;
    80004a60:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    80004a64:	015a5963          	bge	s4,s5,80004a76 <filewrite+0xf2>
      int n1 = n - i;
    80004a68:	414a87bb          	subw	a5,s5,s4
    80004a6c:	89be                	mv	s3,a5
      if(n1 > max)
    80004a6e:	f8fbdee3          	bge	s7,a5,80004a0a <filewrite+0x86>
    80004a72:	89e6                	mv	s3,s9
    80004a74:	bf59                	j	80004a0a <filewrite+0x86>
    80004a76:	64a6                	ld	s1,72(sp)
    80004a78:	79e2                	ld	s3,56(sp)
    80004a7a:	6be2                	ld	s7,24(sp)
    80004a7c:	6c42                	ld	s8,16(sp)
    80004a7e:	6ca2                	ld	s9,8(sp)
    80004a80:	a801                	j	80004a90 <filewrite+0x10c>
    int i = 0;
    80004a82:	4a01                	li	s4,0
    80004a84:	a031                	j	80004a90 <filewrite+0x10c>
    80004a86:	64a6                	ld	s1,72(sp)
    80004a88:	79e2                	ld	s3,56(sp)
    80004a8a:	6be2                	ld	s7,24(sp)
    80004a8c:	6c42                	ld	s8,16(sp)
    80004a8e:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    80004a90:	034a9f63          	bne	s5,s4,80004ace <filewrite+0x14a>
    80004a94:	8556                	mv	a0,s5
    80004a96:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004a98:	60e6                	ld	ra,88(sp)
    80004a9a:	6446                	ld	s0,80(sp)
    80004a9c:	6906                	ld	s2,64(sp)
    80004a9e:	7aa2                	ld	s5,40(sp)
    80004aa0:	7b02                	ld	s6,32(sp)
    80004aa2:	6125                	addi	sp,sp,96
    80004aa4:	8082                	ret
    80004aa6:	e4a6                	sd	s1,72(sp)
    80004aa8:	fc4e                	sd	s3,56(sp)
    80004aaa:	f852                	sd	s4,48(sp)
    80004aac:	ec5e                	sd	s7,24(sp)
    80004aae:	e862                	sd	s8,16(sp)
    80004ab0:	e466                	sd	s9,8(sp)
    panic("filewrite");
    80004ab2:	00004517          	auipc	a0,0x4
    80004ab6:	ae650513          	addi	a0,a0,-1306 # 80008598 <etext+0x598>
    80004aba:	ffffc097          	auipc	ra,0xffffc
    80004abe:	a9c080e7          	jalr	-1380(ra) # 80000556 <panic>
    return -1;
    80004ac2:	557d                	li	a0,-1
}
    80004ac4:	8082                	ret
      return -1;
    80004ac6:	557d                	li	a0,-1
    80004ac8:	bfc1                	j	80004a98 <filewrite+0x114>
    80004aca:	557d                	li	a0,-1
    80004acc:	b7f1                	j	80004a98 <filewrite+0x114>
    ret = (i == n ? n : -1);
    80004ace:	557d                	li	a0,-1
    80004ad0:	7a42                	ld	s4,48(sp)
    80004ad2:	b7d9                	j	80004a98 <filewrite+0x114>

0000000080004ad4 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004ad4:	7179                	addi	sp,sp,-48
    80004ad6:	f406                	sd	ra,40(sp)
    80004ad8:	f022                	sd	s0,32(sp)
    80004ada:	ec26                	sd	s1,24(sp)
    80004adc:	e052                	sd	s4,0(sp)
    80004ade:	1800                	addi	s0,sp,48
    80004ae0:	84aa                	mv	s1,a0
    80004ae2:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004ae4:	0005b023          	sd	zero,0(a1)
    80004ae8:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004aec:	00000097          	auipc	ra,0x0
    80004af0:	bac080e7          	jalr	-1108(ra) # 80004698 <filealloc>
    80004af4:	e088                	sd	a0,0(s1)
    80004af6:	cd49                	beqz	a0,80004b90 <pipealloc+0xbc>
    80004af8:	00000097          	auipc	ra,0x0
    80004afc:	ba0080e7          	jalr	-1120(ra) # 80004698 <filealloc>
    80004b00:	00aa3023          	sd	a0,0(s4)
    80004b04:	c141                	beqz	a0,80004b84 <pipealloc+0xb0>
    80004b06:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004b08:	ffffc097          	auipc	ra,0xffffc
    80004b0c:	048080e7          	jalr	72(ra) # 80000b50 <kalloc>
    80004b10:	892a                	mv	s2,a0
    80004b12:	c13d                	beqz	a0,80004b78 <pipealloc+0xa4>
    80004b14:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80004b16:	4985                	li	s3,1
    80004b18:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004b1c:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004b20:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004b24:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004b28:	00004597          	auipc	a1,0x4
    80004b2c:	a8058593          	addi	a1,a1,-1408 # 800085a8 <etext+0x5a8>
    80004b30:	ffffc097          	auipc	ra,0xffffc
    80004b34:	08a080e7          	jalr	138(ra) # 80000bba <initlock>
  (*f0)->type = FD_PIPE;
    80004b38:	609c                	ld	a5,0(s1)
    80004b3a:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004b3e:	609c                	ld	a5,0(s1)
    80004b40:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004b44:	609c                	ld	a5,0(s1)
    80004b46:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004b4a:	609c                	ld	a5,0(s1)
    80004b4c:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004b50:	000a3783          	ld	a5,0(s4)
    80004b54:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004b58:	000a3783          	ld	a5,0(s4)
    80004b5c:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004b60:	000a3783          	ld	a5,0(s4)
    80004b64:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004b68:	000a3783          	ld	a5,0(s4)
    80004b6c:	0127b823          	sd	s2,16(a5)
  return 0;
    80004b70:	4501                	li	a0,0
    80004b72:	6942                	ld	s2,16(sp)
    80004b74:	69a2                	ld	s3,8(sp)
    80004b76:	a03d                	j	80004ba4 <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004b78:	6088                	ld	a0,0(s1)
    80004b7a:	c119                	beqz	a0,80004b80 <pipealloc+0xac>
    80004b7c:	6942                	ld	s2,16(sp)
    80004b7e:	a029                	j	80004b88 <pipealloc+0xb4>
    80004b80:	6942                	ld	s2,16(sp)
    80004b82:	a039                	j	80004b90 <pipealloc+0xbc>
    80004b84:	6088                	ld	a0,0(s1)
    80004b86:	c50d                	beqz	a0,80004bb0 <pipealloc+0xdc>
    fileclose(*f0);
    80004b88:	00000097          	auipc	ra,0x0
    80004b8c:	bcc080e7          	jalr	-1076(ra) # 80004754 <fileclose>
  if(*f1)
    80004b90:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004b94:	557d                	li	a0,-1
  if(*f1)
    80004b96:	c799                	beqz	a5,80004ba4 <pipealloc+0xd0>
    fileclose(*f1);
    80004b98:	853e                	mv	a0,a5
    80004b9a:	00000097          	auipc	ra,0x0
    80004b9e:	bba080e7          	jalr	-1094(ra) # 80004754 <fileclose>
  return -1;
    80004ba2:	557d                	li	a0,-1
}
    80004ba4:	70a2                	ld	ra,40(sp)
    80004ba6:	7402                	ld	s0,32(sp)
    80004ba8:	64e2                	ld	s1,24(sp)
    80004baa:	6a02                	ld	s4,0(sp)
    80004bac:	6145                	addi	sp,sp,48
    80004bae:	8082                	ret
  return -1;
    80004bb0:	557d                	li	a0,-1
    80004bb2:	bfcd                	j	80004ba4 <pipealloc+0xd0>

0000000080004bb4 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004bb4:	1101                	addi	sp,sp,-32
    80004bb6:	ec06                	sd	ra,24(sp)
    80004bb8:	e822                	sd	s0,16(sp)
    80004bba:	e426                	sd	s1,8(sp)
    80004bbc:	e04a                	sd	s2,0(sp)
    80004bbe:	1000                	addi	s0,sp,32
    80004bc0:	84aa                	mv	s1,a0
    80004bc2:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004bc4:	ffffc097          	auipc	ra,0xffffc
    80004bc8:	090080e7          	jalr	144(ra) # 80000c54 <acquire>
  if(writable){
    80004bcc:	02090b63          	beqz	s2,80004c02 <pipeclose+0x4e>
    pi->writeopen = 0;
    80004bd0:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004bd4:	21848513          	addi	a0,s1,536
    80004bd8:	ffffd097          	auipc	ra,0xffffd
    80004bdc:	702080e7          	jalr	1794(ra) # 800022da <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004be0:	2204a783          	lw	a5,544(s1)
    80004be4:	e781                	bnez	a5,80004bec <pipeclose+0x38>
    80004be6:	2244a783          	lw	a5,548(s1)
    80004bea:	c78d                	beqz	a5,80004c14 <pipeclose+0x60>
    release(&pi->lock);
    kfree((char*)pi);
  } else
    release(&pi->lock);
    80004bec:	8526                	mv	a0,s1
    80004bee:	ffffc097          	auipc	ra,0xffffc
    80004bf2:	116080e7          	jalr	278(ra) # 80000d04 <release>
}
    80004bf6:	60e2                	ld	ra,24(sp)
    80004bf8:	6442                	ld	s0,16(sp)
    80004bfa:	64a2                	ld	s1,8(sp)
    80004bfc:	6902                	ld	s2,0(sp)
    80004bfe:	6105                	addi	sp,sp,32
    80004c00:	8082                	ret
    pi->readopen = 0;
    80004c02:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004c06:	21c48513          	addi	a0,s1,540
    80004c0a:	ffffd097          	auipc	ra,0xffffd
    80004c0e:	6d0080e7          	jalr	1744(ra) # 800022da <wakeup>
    80004c12:	b7f9                	j	80004be0 <pipeclose+0x2c>
    release(&pi->lock);
    80004c14:	8526                	mv	a0,s1
    80004c16:	ffffc097          	auipc	ra,0xffffc
    80004c1a:	0ee080e7          	jalr	238(ra) # 80000d04 <release>
    kfree((char*)pi);
    80004c1e:	8526                	mv	a0,s1
    80004c20:	ffffc097          	auipc	ra,0xffffc
    80004c24:	e2c080e7          	jalr	-468(ra) # 80000a4c <kfree>
    80004c28:	b7f9                	j	80004bf6 <pipeclose+0x42>

0000000080004c2a <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004c2a:	7159                	addi	sp,sp,-112
    80004c2c:	f486                	sd	ra,104(sp)
    80004c2e:	f0a2                	sd	s0,96(sp)
    80004c30:	eca6                	sd	s1,88(sp)
    80004c32:	e8ca                	sd	s2,80(sp)
    80004c34:	e4ce                	sd	s3,72(sp)
    80004c36:	e0d2                	sd	s4,64(sp)
    80004c38:	fc56                	sd	s5,56(sp)
    80004c3a:	1880                	addi	s0,sp,112
    80004c3c:	84aa                	mv	s1,a0
    80004c3e:	8aae                	mv	s5,a1
    80004c40:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004c42:	ffffd097          	auipc	ra,0xffffd
    80004c46:	e44080e7          	jalr	-444(ra) # 80001a86 <myproc>
    80004c4a:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004c4c:	8526                	mv	a0,s1
    80004c4e:	ffffc097          	auipc	ra,0xffffc
    80004c52:	006080e7          	jalr	6(ra) # 80000c54 <acquire>
  while(i < n){
    80004c56:	0d405d63          	blez	s4,80004d30 <pipewrite+0x106>
    80004c5a:	f85a                	sd	s6,48(sp)
    80004c5c:	f45e                	sd	s7,40(sp)
    80004c5e:	f062                	sd	s8,32(sp)
    80004c60:	ec66                	sd	s9,24(sp)
    80004c62:	e86a                	sd	s10,16(sp)
  int i = 0;
    80004c64:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004c66:	f9f40c13          	addi	s8,s0,-97
    80004c6a:	4b85                	li	s7,1
    80004c6c:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004c6e:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004c72:	21c48c93          	addi	s9,s1,540
    80004c76:	a099                	j	80004cbc <pipewrite+0x92>
      release(&pi->lock);
    80004c78:	8526                	mv	a0,s1
    80004c7a:	ffffc097          	auipc	ra,0xffffc
    80004c7e:	08a080e7          	jalr	138(ra) # 80000d04 <release>
      return -1;
    80004c82:	597d                	li	s2,-1
    80004c84:	7b42                	ld	s6,48(sp)
    80004c86:	7ba2                	ld	s7,40(sp)
    80004c88:	7c02                	ld	s8,32(sp)
    80004c8a:	6ce2                	ld	s9,24(sp)
    80004c8c:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004c8e:	854a                	mv	a0,s2
    80004c90:	70a6                	ld	ra,104(sp)
    80004c92:	7406                	ld	s0,96(sp)
    80004c94:	64e6                	ld	s1,88(sp)
    80004c96:	6946                	ld	s2,80(sp)
    80004c98:	69a6                	ld	s3,72(sp)
    80004c9a:	6a06                	ld	s4,64(sp)
    80004c9c:	7ae2                	ld	s5,56(sp)
    80004c9e:	6165                	addi	sp,sp,112
    80004ca0:	8082                	ret
      wakeup(&pi->nread);
    80004ca2:	856a                	mv	a0,s10
    80004ca4:	ffffd097          	auipc	ra,0xffffd
    80004ca8:	636080e7          	jalr	1590(ra) # 800022da <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004cac:	85a6                	mv	a1,s1
    80004cae:	8566                	mv	a0,s9
    80004cb0:	ffffd097          	auipc	ra,0xffffd
    80004cb4:	4a4080e7          	jalr	1188(ra) # 80002154 <sleep>
  while(i < n){
    80004cb8:	05495b63          	bge	s2,s4,80004d0e <pipewrite+0xe4>
    if(pi->readopen == 0 || pr->killed){
    80004cbc:	2204a783          	lw	a5,544(s1)
    80004cc0:	dfc5                	beqz	a5,80004c78 <pipewrite+0x4e>
    80004cc2:	0289a783          	lw	a5,40(s3)
    80004cc6:	fbcd                	bnez	a5,80004c78 <pipewrite+0x4e>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004cc8:	2184a783          	lw	a5,536(s1)
    80004ccc:	21c4a703          	lw	a4,540(s1)
    80004cd0:	2007879b          	addiw	a5,a5,512
    80004cd4:	fcf707e3          	beq	a4,a5,80004ca2 <pipewrite+0x78>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004cd8:	86de                	mv	a3,s7
    80004cda:	01590633          	add	a2,s2,s5
    80004cde:	85e2                	mv	a1,s8
    80004ce0:	0509b503          	ld	a0,80(s3)
    80004ce4:	ffffd097          	auipc	ra,0xffffd
    80004ce8:	ab2080e7          	jalr	-1358(ra) # 80001796 <copyin>
    80004cec:	05650463          	beq	a0,s6,80004d34 <pipewrite+0x10a>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004cf0:	21c4a783          	lw	a5,540(s1)
    80004cf4:	0017871b          	addiw	a4,a5,1
    80004cf8:	20e4ae23          	sw	a4,540(s1)
    80004cfc:	1ff7f793          	andi	a5,a5,511
    80004d00:	97a6                	add	a5,a5,s1
    80004d02:	f9f44703          	lbu	a4,-97(s0)
    80004d06:	00e78c23          	sb	a4,24(a5)
      i++;
    80004d0a:	2905                	addiw	s2,s2,1
    80004d0c:	b775                	j	80004cb8 <pipewrite+0x8e>
    80004d0e:	7b42                	ld	s6,48(sp)
    80004d10:	7ba2                	ld	s7,40(sp)
    80004d12:	7c02                	ld	s8,32(sp)
    80004d14:	6ce2                	ld	s9,24(sp)
    80004d16:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    80004d18:	21848513          	addi	a0,s1,536
    80004d1c:	ffffd097          	auipc	ra,0xffffd
    80004d20:	5be080e7          	jalr	1470(ra) # 800022da <wakeup>
  release(&pi->lock);
    80004d24:	8526                	mv	a0,s1
    80004d26:	ffffc097          	auipc	ra,0xffffc
    80004d2a:	fde080e7          	jalr	-34(ra) # 80000d04 <release>
  return i;
    80004d2e:	b785                	j	80004c8e <pipewrite+0x64>
  int i = 0;
    80004d30:	4901                	li	s2,0
    80004d32:	b7dd                	j	80004d18 <pipewrite+0xee>
    80004d34:	7b42                	ld	s6,48(sp)
    80004d36:	7ba2                	ld	s7,40(sp)
    80004d38:	7c02                	ld	s8,32(sp)
    80004d3a:	6ce2                	ld	s9,24(sp)
    80004d3c:	6d42                	ld	s10,16(sp)
    80004d3e:	bfe9                	j	80004d18 <pipewrite+0xee>

0000000080004d40 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004d40:	711d                	addi	sp,sp,-96
    80004d42:	ec86                	sd	ra,88(sp)
    80004d44:	e8a2                	sd	s0,80(sp)
    80004d46:	e4a6                	sd	s1,72(sp)
    80004d48:	e0ca                	sd	s2,64(sp)
    80004d4a:	fc4e                	sd	s3,56(sp)
    80004d4c:	f852                	sd	s4,48(sp)
    80004d4e:	f456                	sd	s5,40(sp)
    80004d50:	1080                	addi	s0,sp,96
    80004d52:	84aa                	mv	s1,a0
    80004d54:	892e                	mv	s2,a1
    80004d56:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004d58:	ffffd097          	auipc	ra,0xffffd
    80004d5c:	d2e080e7          	jalr	-722(ra) # 80001a86 <myproc>
    80004d60:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004d62:	8526                	mv	a0,s1
    80004d64:	ffffc097          	auipc	ra,0xffffc
    80004d68:	ef0080e7          	jalr	-272(ra) # 80000c54 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004d6c:	2184a703          	lw	a4,536(s1)
    80004d70:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004d74:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004d78:	02f71863          	bne	a4,a5,80004da8 <piperead+0x68>
    80004d7c:	2244a783          	lw	a5,548(s1)
    80004d80:	cf9d                	beqz	a5,80004dbe <piperead+0x7e>
    if(pr->killed){
    80004d82:	028a2783          	lw	a5,40(s4)
    80004d86:	e78d                	bnez	a5,80004db0 <piperead+0x70>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004d88:	85a6                	mv	a1,s1
    80004d8a:	854e                	mv	a0,s3
    80004d8c:	ffffd097          	auipc	ra,0xffffd
    80004d90:	3c8080e7          	jalr	968(ra) # 80002154 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004d94:	2184a703          	lw	a4,536(s1)
    80004d98:	21c4a783          	lw	a5,540(s1)
    80004d9c:	fef700e3          	beq	a4,a5,80004d7c <piperead+0x3c>
    80004da0:	f05a                	sd	s6,32(sp)
    80004da2:	ec5e                	sd	s7,24(sp)
    80004da4:	e862                	sd	s8,16(sp)
    80004da6:	a839                	j	80004dc4 <piperead+0x84>
    80004da8:	f05a                	sd	s6,32(sp)
    80004daa:	ec5e                	sd	s7,24(sp)
    80004dac:	e862                	sd	s8,16(sp)
    80004dae:	a819                	j	80004dc4 <piperead+0x84>
      release(&pi->lock);
    80004db0:	8526                	mv	a0,s1
    80004db2:	ffffc097          	auipc	ra,0xffffc
    80004db6:	f52080e7          	jalr	-174(ra) # 80000d04 <release>
      return -1;
    80004dba:	59fd                	li	s3,-1
    80004dbc:	a88d                	j	80004e2e <piperead+0xee>
    80004dbe:	f05a                	sd	s6,32(sp)
    80004dc0:	ec5e                	sd	s7,24(sp)
    80004dc2:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004dc4:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004dc6:	faf40c13          	addi	s8,s0,-81
    80004dca:	4b85                	li	s7,1
    80004dcc:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004dce:	05505263          	blez	s5,80004e12 <piperead+0xd2>
    if(pi->nread == pi->nwrite)
    80004dd2:	2184a783          	lw	a5,536(s1)
    80004dd6:	21c4a703          	lw	a4,540(s1)
    80004dda:	02f70c63          	beq	a4,a5,80004e12 <piperead+0xd2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004dde:	0017871b          	addiw	a4,a5,1
    80004de2:	20e4ac23          	sw	a4,536(s1)
    80004de6:	1ff7f793          	andi	a5,a5,511
    80004dea:	97a6                	add	a5,a5,s1
    80004dec:	0187c783          	lbu	a5,24(a5)
    80004df0:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004df4:	86de                	mv	a3,s7
    80004df6:	8662                	mv	a2,s8
    80004df8:	85ca                	mv	a1,s2
    80004dfa:	050a3503          	ld	a0,80(s4)
    80004dfe:	ffffd097          	auipc	ra,0xffffd
    80004e02:	90c080e7          	jalr	-1780(ra) # 8000170a <copyout>
    80004e06:	01650663          	beq	a0,s6,80004e12 <piperead+0xd2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004e0a:	2985                	addiw	s3,s3,1
    80004e0c:	0905                	addi	s2,s2,1
    80004e0e:	fd3a92e3          	bne	s5,s3,80004dd2 <piperead+0x92>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004e12:	21c48513          	addi	a0,s1,540
    80004e16:	ffffd097          	auipc	ra,0xffffd
    80004e1a:	4c4080e7          	jalr	1220(ra) # 800022da <wakeup>
  release(&pi->lock);
    80004e1e:	8526                	mv	a0,s1
    80004e20:	ffffc097          	auipc	ra,0xffffc
    80004e24:	ee4080e7          	jalr	-284(ra) # 80000d04 <release>
    80004e28:	7b02                	ld	s6,32(sp)
    80004e2a:	6be2                	ld	s7,24(sp)
    80004e2c:	6c42                	ld	s8,16(sp)
  return i;
}
    80004e2e:	854e                	mv	a0,s3
    80004e30:	60e6                	ld	ra,88(sp)
    80004e32:	6446                	ld	s0,80(sp)
    80004e34:	64a6                	ld	s1,72(sp)
    80004e36:	6906                	ld	s2,64(sp)
    80004e38:	79e2                	ld	s3,56(sp)
    80004e3a:	7a42                	ld	s4,48(sp)
    80004e3c:	7aa2                	ld	s5,40(sp)
    80004e3e:	6125                	addi	sp,sp,96
    80004e40:	8082                	ret

0000000080004e42 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004e42:	de010113          	addi	sp,sp,-544
    80004e46:	20113c23          	sd	ra,536(sp)
    80004e4a:	20813823          	sd	s0,528(sp)
    80004e4e:	20913423          	sd	s1,520(sp)
    80004e52:	21213023          	sd	s2,512(sp)
    80004e56:	1400                	addi	s0,sp,544
    80004e58:	892a                	mv	s2,a0
    80004e5a:	dea43823          	sd	a0,-528(s0)
    80004e5e:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004e62:	ffffd097          	auipc	ra,0xffffd
    80004e66:	c24080e7          	jalr	-988(ra) # 80001a86 <myproc>
    80004e6a:	84aa                	mv	s1,a0

  begin_op();
    80004e6c:	fffff097          	auipc	ra,0xfffff
    80004e70:	406080e7          	jalr	1030(ra) # 80004272 <begin_op>

  if((ip = namei(path)) == 0){
    80004e74:	854a                	mv	a0,s2
    80004e76:	fffff097          	auipc	ra,0xfffff
    80004e7a:	1f6080e7          	jalr	502(ra) # 8000406c <namei>
    80004e7e:	c525                	beqz	a0,80004ee6 <exec+0xa4>
    80004e80:	fbd2                	sd	s4,496(sp)
    80004e82:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004e84:	fffff097          	auipc	ra,0xfffff
    80004e88:	9f6080e7          	jalr	-1546(ra) # 8000387a <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004e8c:	04000713          	li	a4,64
    80004e90:	4681                	li	a3,0
    80004e92:	e5040613          	addi	a2,s0,-432
    80004e96:	4581                	li	a1,0
    80004e98:	8552                	mv	a0,s4
    80004e9a:	fffff097          	auipc	ra,0xfffff
    80004e9e:	c9e080e7          	jalr	-866(ra) # 80003b38 <readi>
    80004ea2:	04000793          	li	a5,64
    80004ea6:	00f51a63          	bne	a0,a5,80004eba <exec+0x78>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004eaa:	e5042703          	lw	a4,-432(s0)
    80004eae:	464c47b7          	lui	a5,0x464c4
    80004eb2:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004eb6:	02f70e63          	beq	a4,a5,80004ef2 <exec+0xb0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004eba:	8552                	mv	a0,s4
    80004ebc:	fffff097          	auipc	ra,0xfffff
    80004ec0:	c26080e7          	jalr	-986(ra) # 80003ae2 <iunlockput>
    end_op();
    80004ec4:	fffff097          	auipc	ra,0xfffff
    80004ec8:	42e080e7          	jalr	1070(ra) # 800042f2 <end_op>
  }
  return -1;
    80004ecc:	557d                	li	a0,-1
    80004ece:	7a5e                	ld	s4,496(sp)
}
    80004ed0:	21813083          	ld	ra,536(sp)
    80004ed4:	21013403          	ld	s0,528(sp)
    80004ed8:	20813483          	ld	s1,520(sp)
    80004edc:	20013903          	ld	s2,512(sp)
    80004ee0:	22010113          	addi	sp,sp,544
    80004ee4:	8082                	ret
    end_op();
    80004ee6:	fffff097          	auipc	ra,0xfffff
    80004eea:	40c080e7          	jalr	1036(ra) # 800042f2 <end_op>
    return -1;
    80004eee:	557d                	li	a0,-1
    80004ef0:	b7c5                	j	80004ed0 <exec+0x8e>
    80004ef2:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80004ef4:	8526                	mv	a0,s1
    80004ef6:	ffffd097          	auipc	ra,0xffffd
    80004efa:	c56080e7          	jalr	-938(ra) # 80001b4c <proc_pagetable>
    80004efe:	8b2a                	mv	s6,a0
    80004f00:	2a050a63          	beqz	a0,800051b4 <exec+0x372>
    80004f04:	ffce                	sd	s3,504(sp)
    80004f06:	f7d6                	sd	s5,488(sp)
    80004f08:	efde                	sd	s7,472(sp)
    80004f0a:	ebe2                	sd	s8,464(sp)
    80004f0c:	e7e6                	sd	s9,456(sp)
    80004f0e:	e3ea                	sd	s10,448(sp)
    80004f10:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004f12:	e8845783          	lhu	a5,-376(s0)
    80004f16:	cfed                	beqz	a5,80005010 <exec+0x1ce>
    80004f18:	e7042683          	lw	a3,-400(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004f1c:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004f1e:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004f20:	03800d93          	li	s11,56
    if((ph.vaddr % PGSIZE) != 0)
    80004f24:	6c85                	lui	s9,0x1
    80004f26:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004f2a:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004f2e:	6a85                	lui	s5,0x1
    80004f30:	a0b5                	j	80004f9c <exec+0x15a>
      panic("loadseg: address should exist");
    80004f32:	00003517          	auipc	a0,0x3
    80004f36:	67e50513          	addi	a0,a0,1662 # 800085b0 <etext+0x5b0>
    80004f3a:	ffffb097          	auipc	ra,0xffffb
    80004f3e:	61c080e7          	jalr	1564(ra) # 80000556 <panic>
    if(sz - i < PGSIZE)
    80004f42:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004f44:	874a                	mv	a4,s2
    80004f46:	009c06bb          	addw	a3,s8,s1
    80004f4a:	4581                	li	a1,0
    80004f4c:	8552                	mv	a0,s4
    80004f4e:	fffff097          	auipc	ra,0xfffff
    80004f52:	bea080e7          	jalr	-1046(ra) # 80003b38 <readi>
    80004f56:	26a91363          	bne	s2,a0,800051bc <exec+0x37a>
  for(i = 0; i < sz; i += PGSIZE){
    80004f5a:	009a84bb          	addw	s1,s5,s1
    80004f5e:	0334f463          	bgeu	s1,s3,80004f86 <exec+0x144>
    pa = walkaddr(pagetable, va + i);
    80004f62:	02049593          	slli	a1,s1,0x20
    80004f66:	9181                	srli	a1,a1,0x20
    80004f68:	95de                	add	a1,a1,s7
    80004f6a:	855a                	mv	a0,s6
    80004f6c:	ffffc097          	auipc	ra,0xffffc
    80004f70:	17e080e7          	jalr	382(ra) # 800010ea <walkaddr>
    80004f74:	862a                	mv	a2,a0
    if(pa == 0)
    80004f76:	dd55                	beqz	a0,80004f32 <exec+0xf0>
    if(sz - i < PGSIZE)
    80004f78:	409987bb          	subw	a5,s3,s1
    80004f7c:	893e                	mv	s2,a5
    80004f7e:	fcfcf2e3          	bgeu	s9,a5,80004f42 <exec+0x100>
    80004f82:	8956                	mv	s2,s5
    80004f84:	bf7d                	j	80004f42 <exec+0x100>
    sz = sz1;
    80004f86:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004f8a:	2d05                	addiw	s10,s10,1
    80004f8c:	e0843783          	ld	a5,-504(s0)
    80004f90:	0387869b          	addiw	a3,a5,56
    80004f94:	e8845783          	lhu	a5,-376(s0)
    80004f98:	06fd5d63          	bge	s10,a5,80005012 <exec+0x1d0>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004f9c:	e0d43423          	sd	a3,-504(s0)
    80004fa0:	876e                	mv	a4,s11
    80004fa2:	e1840613          	addi	a2,s0,-488
    80004fa6:	4581                	li	a1,0
    80004fa8:	8552                	mv	a0,s4
    80004faa:	fffff097          	auipc	ra,0xfffff
    80004fae:	b8e080e7          	jalr	-1138(ra) # 80003b38 <readi>
    80004fb2:	21b51363          	bne	a0,s11,800051b8 <exec+0x376>
    if(ph.type != ELF_PROG_LOAD)
    80004fb6:	e1842783          	lw	a5,-488(s0)
    80004fba:	4705                	li	a4,1
    80004fbc:	fce797e3          	bne	a5,a4,80004f8a <exec+0x148>
    if(ph.memsz < ph.filesz)
    80004fc0:	e4043603          	ld	a2,-448(s0)
    80004fc4:	e3843783          	ld	a5,-456(s0)
    80004fc8:	20f66a63          	bltu	a2,a5,800051dc <exec+0x39a>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004fcc:	e2843783          	ld	a5,-472(s0)
    80004fd0:	963e                	add	a2,a2,a5
    80004fd2:	20f66863          	bltu	a2,a5,800051e2 <exec+0x3a0>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004fd6:	85a6                	mv	a1,s1
    80004fd8:	855a                	mv	a0,s6
    80004fda:	ffffc097          	auipc	ra,0xffffc
    80004fde:	4ce080e7          	jalr	1230(ra) # 800014a8 <uvmalloc>
    80004fe2:	dea43c23          	sd	a0,-520(s0)
    80004fe6:	20050163          	beqz	a0,800051e8 <exec+0x3a6>
    if((ph.vaddr % PGSIZE) != 0)
    80004fea:	e2843b83          	ld	s7,-472(s0)
    80004fee:	de843783          	ld	a5,-536(s0)
    80004ff2:	00fbf7b3          	and	a5,s7,a5
    80004ff6:	1c079363          	bnez	a5,800051bc <exec+0x37a>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004ffa:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004ffe:	00098663          	beqz	s3,8000500a <exec+0x1c8>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005002:	e2042c03          	lw	s8,-480(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005006:	4481                	li	s1,0
    80005008:	bfa9                	j	80004f62 <exec+0x120>
    sz = sz1;
    8000500a:	df843483          	ld	s1,-520(s0)
    8000500e:	bfb5                	j	80004f8a <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005010:	4481                	li	s1,0
  iunlockput(ip);
    80005012:	8552                	mv	a0,s4
    80005014:	fffff097          	auipc	ra,0xfffff
    80005018:	ace080e7          	jalr	-1330(ra) # 80003ae2 <iunlockput>
  end_op();
    8000501c:	fffff097          	auipc	ra,0xfffff
    80005020:	2d6080e7          	jalr	726(ra) # 800042f2 <end_op>
  p = myproc();
    80005024:	ffffd097          	auipc	ra,0xffffd
    80005028:	a62080e7          	jalr	-1438(ra) # 80001a86 <myproc>
    8000502c:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    8000502e:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80005032:	6985                	lui	s3,0x1
    80005034:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80005036:	99a6                	add	s3,s3,s1
    80005038:	77fd                	lui	a5,0xfffff
    8000503a:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000503e:	6609                	lui	a2,0x2
    80005040:	964e                	add	a2,a2,s3
    80005042:	85ce                	mv	a1,s3
    80005044:	855a                	mv	a0,s6
    80005046:	ffffc097          	auipc	ra,0xffffc
    8000504a:	462080e7          	jalr	1122(ra) # 800014a8 <uvmalloc>
    8000504e:	8a2a                	mv	s4,a0
    80005050:	e115                	bnez	a0,80005074 <exec+0x232>
    proc_freepagetable(pagetable, sz);
    80005052:	85ce                	mv	a1,s3
    80005054:	855a                	mv	a0,s6
    80005056:	ffffd097          	auipc	ra,0xffffd
    8000505a:	b92080e7          	jalr	-1134(ra) # 80001be8 <proc_freepagetable>
  return -1;
    8000505e:	557d                	li	a0,-1
    80005060:	79fe                	ld	s3,504(sp)
    80005062:	7a5e                	ld	s4,496(sp)
    80005064:	7abe                	ld	s5,488(sp)
    80005066:	7b1e                	ld	s6,480(sp)
    80005068:	6bfe                	ld	s7,472(sp)
    8000506a:	6c5e                	ld	s8,464(sp)
    8000506c:	6cbe                	ld	s9,456(sp)
    8000506e:	6d1e                	ld	s10,448(sp)
    80005070:	7dfa                	ld	s11,440(sp)
    80005072:	bdb9                	j	80004ed0 <exec+0x8e>
  uvmclear(pagetable, sz-2*PGSIZE);
    80005074:	75f9                	lui	a1,0xffffe
    80005076:	95aa                	add	a1,a1,a0
    80005078:	855a                	mv	a0,s6
    8000507a:	ffffc097          	auipc	ra,0xffffc
    8000507e:	65e080e7          	jalr	1630(ra) # 800016d8 <uvmclear>
  stackbase = sp - PGSIZE;
    80005082:	800a0b93          	addi	s7,s4,-2048
    80005086:	800b8b93          	addi	s7,s7,-2048
  for(argc = 0; argv[argc]; argc++) {
    8000508a:	e0043783          	ld	a5,-512(s0)
    8000508e:	6388                	ld	a0,0(a5)
  sp = sz;
    80005090:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    80005092:	4481                	li	s1,0
    ustack[argc] = sp;
    80005094:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    80005098:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    8000509c:	c135                	beqz	a0,80005100 <exec+0x2be>
    sp -= strlen(argv[argc]) + 1;
    8000509e:	ffffc097          	auipc	ra,0xffffc
    800050a2:	e3c080e7          	jalr	-452(ra) # 80000eda <strlen>
    800050a6:	0015079b          	addiw	a5,a0,1
    800050aa:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800050ae:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800050b2:	13796e63          	bltu	s2,s7,800051ee <exec+0x3ac>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800050b6:	e0043d83          	ld	s11,-512(s0)
    800050ba:	000db983          	ld	s3,0(s11)
    800050be:	854e                	mv	a0,s3
    800050c0:	ffffc097          	auipc	ra,0xffffc
    800050c4:	e1a080e7          	jalr	-486(ra) # 80000eda <strlen>
    800050c8:	0015069b          	addiw	a3,a0,1
    800050cc:	864e                	mv	a2,s3
    800050ce:	85ca                	mv	a1,s2
    800050d0:	855a                	mv	a0,s6
    800050d2:	ffffc097          	auipc	ra,0xffffc
    800050d6:	638080e7          	jalr	1592(ra) # 8000170a <copyout>
    800050da:	10054c63          	bltz	a0,800051f2 <exec+0x3b0>
    ustack[argc] = sp;
    800050de:	00349793          	slli	a5,s1,0x3
    800050e2:	97e6                	add	a5,a5,s9
    800050e4:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffd9000>
  for(argc = 0; argv[argc]; argc++) {
    800050e8:	0485                	addi	s1,s1,1
    800050ea:	008d8793          	addi	a5,s11,8
    800050ee:	e0f43023          	sd	a5,-512(s0)
    800050f2:	008db503          	ld	a0,8(s11)
    800050f6:	c509                	beqz	a0,80005100 <exec+0x2be>
    if(argc >= MAXARG)
    800050f8:	fb8493e3          	bne	s1,s8,8000509e <exec+0x25c>
  sz = sz1;
    800050fc:	89d2                	mv	s3,s4
    800050fe:	bf91                	j	80005052 <exec+0x210>
  ustack[argc] = 0;
    80005100:	00349793          	slli	a5,s1,0x3
    80005104:	f9078793          	addi	a5,a5,-112
    80005108:	97a2                	add	a5,a5,s0
    8000510a:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    8000510e:	00349693          	slli	a3,s1,0x3
    80005112:	06a1                	addi	a3,a3,8
    80005114:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80005118:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    8000511c:	89d2                	mv	s3,s4
  if(sp < stackbase)
    8000511e:	f3796ae3          	bltu	s2,s7,80005052 <exec+0x210>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80005122:	e9040613          	addi	a2,s0,-368
    80005126:	85ca                	mv	a1,s2
    80005128:	855a                	mv	a0,s6
    8000512a:	ffffc097          	auipc	ra,0xffffc
    8000512e:	5e0080e7          	jalr	1504(ra) # 8000170a <copyout>
    80005132:	f20540e3          	bltz	a0,80005052 <exec+0x210>
  p->trapframe->a1 = sp;
    80005136:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    8000513a:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000513e:	df043783          	ld	a5,-528(s0)
    80005142:	0007c703          	lbu	a4,0(a5)
    80005146:	cf11                	beqz	a4,80005162 <exec+0x320>
    80005148:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000514a:	02f00693          	li	a3,47
    8000514e:	a029                	j	80005158 <exec+0x316>
  for(last=s=path; *s; s++)
    80005150:	0785                	addi	a5,a5,1
    80005152:	fff7c703          	lbu	a4,-1(a5)
    80005156:	c711                	beqz	a4,80005162 <exec+0x320>
    if(*s == '/')
    80005158:	fed71ce3          	bne	a4,a3,80005150 <exec+0x30e>
      last = s+1;
    8000515c:	def43823          	sd	a5,-528(s0)
    80005160:	bfc5                	j	80005150 <exec+0x30e>
  safestrcpy(p->name, last, sizeof(p->name));
    80005162:	4641                	li	a2,16
    80005164:	df043583          	ld	a1,-528(s0)
    80005168:	158a8513          	addi	a0,s5,344
    8000516c:	ffffc097          	auipc	ra,0xffffc
    80005170:	d38080e7          	jalr	-712(ra) # 80000ea4 <safestrcpy>
  oldpagetable = p->pagetable;
    80005174:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80005178:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    8000517c:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80005180:	058ab783          	ld	a5,88(s5)
    80005184:	e6843703          	ld	a4,-408(s0)
    80005188:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000518a:	058ab783          	ld	a5,88(s5)
    8000518e:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80005192:	85ea                	mv	a1,s10
    80005194:	ffffd097          	auipc	ra,0xffffd
    80005198:	a54080e7          	jalr	-1452(ra) # 80001be8 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000519c:	0004851b          	sext.w	a0,s1
    800051a0:	79fe                	ld	s3,504(sp)
    800051a2:	7a5e                	ld	s4,496(sp)
    800051a4:	7abe                	ld	s5,488(sp)
    800051a6:	7b1e                	ld	s6,480(sp)
    800051a8:	6bfe                	ld	s7,472(sp)
    800051aa:	6c5e                	ld	s8,464(sp)
    800051ac:	6cbe                	ld	s9,456(sp)
    800051ae:	6d1e                	ld	s10,448(sp)
    800051b0:	7dfa                	ld	s11,440(sp)
    800051b2:	bb39                	j	80004ed0 <exec+0x8e>
    800051b4:	7b1e                	ld	s6,480(sp)
    800051b6:	b311                	j	80004eba <exec+0x78>
    800051b8:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    800051bc:	df843583          	ld	a1,-520(s0)
    800051c0:	855a                	mv	a0,s6
    800051c2:	ffffd097          	auipc	ra,0xffffd
    800051c6:	a26080e7          	jalr	-1498(ra) # 80001be8 <proc_freepagetable>
  if(ip){
    800051ca:	79fe                	ld	s3,504(sp)
    800051cc:	7abe                	ld	s5,488(sp)
    800051ce:	7b1e                	ld	s6,480(sp)
    800051d0:	6bfe                	ld	s7,472(sp)
    800051d2:	6c5e                	ld	s8,464(sp)
    800051d4:	6cbe                	ld	s9,456(sp)
    800051d6:	6d1e                	ld	s10,448(sp)
    800051d8:	7dfa                	ld	s11,440(sp)
    800051da:	b1c5                	j	80004eba <exec+0x78>
    800051dc:	de943c23          	sd	s1,-520(s0)
    800051e0:	bff1                	j	800051bc <exec+0x37a>
    800051e2:	de943c23          	sd	s1,-520(s0)
    800051e6:	bfd9                	j	800051bc <exec+0x37a>
    800051e8:	de943c23          	sd	s1,-520(s0)
    800051ec:	bfc1                	j	800051bc <exec+0x37a>
  sz = sz1;
    800051ee:	89d2                	mv	s3,s4
    800051f0:	b58d                	j	80005052 <exec+0x210>
    800051f2:	89d2                	mv	s3,s4
    800051f4:	bdb9                	j	80005052 <exec+0x210>

00000000800051f6 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800051f6:	7179                	addi	sp,sp,-48
    800051f8:	f406                	sd	ra,40(sp)
    800051fa:	f022                	sd	s0,32(sp)
    800051fc:	ec26                	sd	s1,24(sp)
    800051fe:	e84a                	sd	s2,16(sp)
    80005200:	1800                	addi	s0,sp,48
    80005202:	892e                	mv	s2,a1
    80005204:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80005206:	fdc40593          	addi	a1,s0,-36
    8000520a:	ffffe097          	auipc	ra,0xffffe
    8000520e:	ac0080e7          	jalr	-1344(ra) # 80002cca <argint>
    80005212:	04054163          	bltz	a0,80005254 <argfd+0x5e>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80005216:	fdc42703          	lw	a4,-36(s0)
    8000521a:	47bd                	li	a5,15
    8000521c:	02e7ee63          	bltu	a5,a4,80005258 <argfd+0x62>
    80005220:	ffffd097          	auipc	ra,0xffffd
    80005224:	866080e7          	jalr	-1946(ra) # 80001a86 <myproc>
    80005228:	fdc42703          	lw	a4,-36(s0)
    8000522c:	00371793          	slli	a5,a4,0x3
    80005230:	0d078793          	addi	a5,a5,208
    80005234:	953e                	add	a0,a0,a5
    80005236:	611c                	ld	a5,0(a0)
    80005238:	c395                	beqz	a5,8000525c <argfd+0x66>
    return -1;
  if(pfd)
    8000523a:	00090463          	beqz	s2,80005242 <argfd+0x4c>
    *pfd = fd;
    8000523e:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80005242:	4501                	li	a0,0
  if(pf)
    80005244:	c091                	beqz	s1,80005248 <argfd+0x52>
    *pf = f;
    80005246:	e09c                	sd	a5,0(s1)
}
    80005248:	70a2                	ld	ra,40(sp)
    8000524a:	7402                	ld	s0,32(sp)
    8000524c:	64e2                	ld	s1,24(sp)
    8000524e:	6942                	ld	s2,16(sp)
    80005250:	6145                	addi	sp,sp,48
    80005252:	8082                	ret
    return -1;
    80005254:	557d                	li	a0,-1
    80005256:	bfcd                	j	80005248 <argfd+0x52>
    return -1;
    80005258:	557d                	li	a0,-1
    8000525a:	b7fd                	j	80005248 <argfd+0x52>
    8000525c:	557d                	li	a0,-1
    8000525e:	b7ed                	j	80005248 <argfd+0x52>

0000000080005260 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80005260:	1101                	addi	sp,sp,-32
    80005262:	ec06                	sd	ra,24(sp)
    80005264:	e822                	sd	s0,16(sp)
    80005266:	e426                	sd	s1,8(sp)
    80005268:	1000                	addi	s0,sp,32
    8000526a:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000526c:	ffffd097          	auipc	ra,0xffffd
    80005270:	81a080e7          	jalr	-2022(ra) # 80001a86 <myproc>
    80005274:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80005276:	0d050793          	addi	a5,a0,208
    8000527a:	4501                	li	a0,0
    8000527c:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000527e:	6398                	ld	a4,0(a5)
    80005280:	cb19                	beqz	a4,80005296 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80005282:	2505                	addiw	a0,a0,1
    80005284:	07a1                	addi	a5,a5,8
    80005286:	fed51ce3          	bne	a0,a3,8000527e <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000528a:	557d                	li	a0,-1
}
    8000528c:	60e2                	ld	ra,24(sp)
    8000528e:	6442                	ld	s0,16(sp)
    80005290:	64a2                	ld	s1,8(sp)
    80005292:	6105                	addi	sp,sp,32
    80005294:	8082                	ret
      p->ofile[fd] = f;
    80005296:	00351793          	slli	a5,a0,0x3
    8000529a:	0d078793          	addi	a5,a5,208
    8000529e:	963e                	add	a2,a2,a5
    800052a0:	e204                	sd	s1,0(a2)
      return fd;
    800052a2:	b7ed                	j	8000528c <fdalloc+0x2c>

00000000800052a4 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800052a4:	715d                	addi	sp,sp,-80
    800052a6:	e486                	sd	ra,72(sp)
    800052a8:	e0a2                	sd	s0,64(sp)
    800052aa:	fc26                	sd	s1,56(sp)
    800052ac:	f84a                	sd	s2,48(sp)
    800052ae:	f44e                	sd	s3,40(sp)
    800052b0:	f052                	sd	s4,32(sp)
    800052b2:	ec56                	sd	s5,24(sp)
    800052b4:	0880                	addi	s0,sp,80
    800052b6:	89ae                	mv	s3,a1
    800052b8:	8a32                	mv	s4,a2
    800052ba:	8ab6                	mv	s5,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800052bc:	fb040593          	addi	a1,s0,-80
    800052c0:	fffff097          	auipc	ra,0xfffff
    800052c4:	dca080e7          	jalr	-566(ra) # 8000408a <nameiparent>
    800052c8:	892a                	mv	s2,a0
    800052ca:	12050d63          	beqz	a0,80005404 <create+0x160>
    return 0;

  ilock(dp);
    800052ce:	ffffe097          	auipc	ra,0xffffe
    800052d2:	5ac080e7          	jalr	1452(ra) # 8000387a <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800052d6:	4601                	li	a2,0
    800052d8:	fb040593          	addi	a1,s0,-80
    800052dc:	854a                	mv	a0,s2
    800052de:	fffff097          	auipc	ra,0xfffff
    800052e2:	a8a080e7          	jalr	-1398(ra) # 80003d68 <dirlookup>
    800052e6:	84aa                	mv	s1,a0
    800052e8:	c539                	beqz	a0,80005336 <create+0x92>
    iunlockput(dp);
    800052ea:	854a                	mv	a0,s2
    800052ec:	ffffe097          	auipc	ra,0xffffe
    800052f0:	7f6080e7          	jalr	2038(ra) # 80003ae2 <iunlockput>
    ilock(ip);
    800052f4:	8526                	mv	a0,s1
    800052f6:	ffffe097          	auipc	ra,0xffffe
    800052fa:	584080e7          	jalr	1412(ra) # 8000387a <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800052fe:	4789                	li	a5,2
    80005300:	02f99463          	bne	s3,a5,80005328 <create+0x84>
    80005304:	0444d783          	lhu	a5,68(s1)
    80005308:	37f9                	addiw	a5,a5,-2
    8000530a:	17c2                	slli	a5,a5,0x30
    8000530c:	93c1                	srli	a5,a5,0x30
    8000530e:	4705                	li	a4,1
    80005310:	00f76c63          	bltu	a4,a5,80005328 <create+0x84>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80005314:	8526                	mv	a0,s1
    80005316:	60a6                	ld	ra,72(sp)
    80005318:	6406                	ld	s0,64(sp)
    8000531a:	74e2                	ld	s1,56(sp)
    8000531c:	7942                	ld	s2,48(sp)
    8000531e:	79a2                	ld	s3,40(sp)
    80005320:	7a02                	ld	s4,32(sp)
    80005322:	6ae2                	ld	s5,24(sp)
    80005324:	6161                	addi	sp,sp,80
    80005326:	8082                	ret
    iunlockput(ip);
    80005328:	8526                	mv	a0,s1
    8000532a:	ffffe097          	auipc	ra,0xffffe
    8000532e:	7b8080e7          	jalr	1976(ra) # 80003ae2 <iunlockput>
    return 0;
    80005332:	4481                	li	s1,0
    80005334:	b7c5                	j	80005314 <create+0x70>
  if((ip = ialloc(dp->dev, type)) == 0)
    80005336:	85ce                	mv	a1,s3
    80005338:	00092503          	lw	a0,0(s2)
    8000533c:	ffffe097          	auipc	ra,0xffffe
    80005340:	3aa080e7          	jalr	938(ra) # 800036e6 <ialloc>
    80005344:	84aa                	mv	s1,a0
    80005346:	c521                	beqz	a0,8000538e <create+0xea>
  ilock(ip);
    80005348:	ffffe097          	auipc	ra,0xffffe
    8000534c:	532080e7          	jalr	1330(ra) # 8000387a <ilock>
  ip->major = major;
    80005350:	05449323          	sh	s4,70(s1)
  ip->minor = minor;
    80005354:	05549423          	sh	s5,72(s1)
  ip->nlink = 1;
    80005358:	4785                	li	a5,1
    8000535a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000535e:	8526                	mv	a0,s1
    80005360:	ffffe097          	auipc	ra,0xffffe
    80005364:	44e080e7          	jalr	1102(ra) # 800037ae <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80005368:	4705                	li	a4,1
    8000536a:	02e98a63          	beq	s3,a4,8000539e <create+0xfa>
  if(dirlink(dp, name, ip->inum) < 0)
    8000536e:	40d0                	lw	a2,4(s1)
    80005370:	fb040593          	addi	a1,s0,-80
    80005374:	854a                	mv	a0,s2
    80005376:	fffff097          	auipc	ra,0xfffff
    8000537a:	c20080e7          	jalr	-992(ra) # 80003f96 <dirlink>
    8000537e:	06054b63          	bltz	a0,800053f4 <create+0x150>
  iunlockput(dp);
    80005382:	854a                	mv	a0,s2
    80005384:	ffffe097          	auipc	ra,0xffffe
    80005388:	75e080e7          	jalr	1886(ra) # 80003ae2 <iunlockput>
  return ip;
    8000538c:	b761                	j	80005314 <create+0x70>
    panic("create: ialloc");
    8000538e:	00003517          	auipc	a0,0x3
    80005392:	24250513          	addi	a0,a0,578 # 800085d0 <etext+0x5d0>
    80005396:	ffffb097          	auipc	ra,0xffffb
    8000539a:	1c0080e7          	jalr	448(ra) # 80000556 <panic>
    dp->nlink++;  // for ".."
    8000539e:	04a95783          	lhu	a5,74(s2)
    800053a2:	2785                	addiw	a5,a5,1
    800053a4:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800053a8:	854a                	mv	a0,s2
    800053aa:	ffffe097          	auipc	ra,0xffffe
    800053ae:	404080e7          	jalr	1028(ra) # 800037ae <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800053b2:	40d0                	lw	a2,4(s1)
    800053b4:	00003597          	auipc	a1,0x3
    800053b8:	22c58593          	addi	a1,a1,556 # 800085e0 <etext+0x5e0>
    800053bc:	8526                	mv	a0,s1
    800053be:	fffff097          	auipc	ra,0xfffff
    800053c2:	bd8080e7          	jalr	-1064(ra) # 80003f96 <dirlink>
    800053c6:	00054f63          	bltz	a0,800053e4 <create+0x140>
    800053ca:	00492603          	lw	a2,4(s2)
    800053ce:	00003597          	auipc	a1,0x3
    800053d2:	21a58593          	addi	a1,a1,538 # 800085e8 <etext+0x5e8>
    800053d6:	8526                	mv	a0,s1
    800053d8:	fffff097          	auipc	ra,0xfffff
    800053dc:	bbe080e7          	jalr	-1090(ra) # 80003f96 <dirlink>
    800053e0:	f80557e3          	bgez	a0,8000536e <create+0xca>
      panic("create dots");
    800053e4:	00003517          	auipc	a0,0x3
    800053e8:	20c50513          	addi	a0,a0,524 # 800085f0 <etext+0x5f0>
    800053ec:	ffffb097          	auipc	ra,0xffffb
    800053f0:	16a080e7          	jalr	362(ra) # 80000556 <panic>
    panic("create: dirlink");
    800053f4:	00003517          	auipc	a0,0x3
    800053f8:	20c50513          	addi	a0,a0,524 # 80008600 <etext+0x600>
    800053fc:	ffffb097          	auipc	ra,0xffffb
    80005400:	15a080e7          	jalr	346(ra) # 80000556 <panic>
    return 0;
    80005404:	84aa                	mv	s1,a0
    80005406:	b739                	j	80005314 <create+0x70>

0000000080005408 <sys_dup>:
{
    80005408:	7179                	addi	sp,sp,-48
    8000540a:	f406                	sd	ra,40(sp)
    8000540c:	f022                	sd	s0,32(sp)
    8000540e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005410:	fd840613          	addi	a2,s0,-40
    80005414:	4581                	li	a1,0
    80005416:	4501                	li	a0,0
    80005418:	00000097          	auipc	ra,0x0
    8000541c:	dde080e7          	jalr	-546(ra) # 800051f6 <argfd>
    return -1;
    80005420:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80005422:	02054763          	bltz	a0,80005450 <sys_dup+0x48>
    80005426:	ec26                	sd	s1,24(sp)
    80005428:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    8000542a:	fd843483          	ld	s1,-40(s0)
    8000542e:	8526                	mv	a0,s1
    80005430:	00000097          	auipc	ra,0x0
    80005434:	e30080e7          	jalr	-464(ra) # 80005260 <fdalloc>
    80005438:	892a                	mv	s2,a0
    return -1;
    8000543a:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000543c:	00054f63          	bltz	a0,8000545a <sys_dup+0x52>
  filedup(f);
    80005440:	8526                	mv	a0,s1
    80005442:	fffff097          	auipc	ra,0xfffff
    80005446:	2c0080e7          	jalr	704(ra) # 80004702 <filedup>
  return fd;
    8000544a:	87ca                	mv	a5,s2
    8000544c:	64e2                	ld	s1,24(sp)
    8000544e:	6942                	ld	s2,16(sp)
}
    80005450:	853e                	mv	a0,a5
    80005452:	70a2                	ld	ra,40(sp)
    80005454:	7402                	ld	s0,32(sp)
    80005456:	6145                	addi	sp,sp,48
    80005458:	8082                	ret
    8000545a:	64e2                	ld	s1,24(sp)
    8000545c:	6942                	ld	s2,16(sp)
    8000545e:	bfcd                	j	80005450 <sys_dup+0x48>

0000000080005460 <sys_read>:
{
    80005460:	7179                	addi	sp,sp,-48
    80005462:	f406                	sd	ra,40(sp)
    80005464:	f022                	sd	s0,32(sp)
    80005466:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005468:	fe840613          	addi	a2,s0,-24
    8000546c:	4581                	li	a1,0
    8000546e:	4501                	li	a0,0
    80005470:	00000097          	auipc	ra,0x0
    80005474:	d86080e7          	jalr	-634(ra) # 800051f6 <argfd>
    return -1;
    80005478:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000547a:	04054163          	bltz	a0,800054bc <sys_read+0x5c>
    8000547e:	fe440593          	addi	a1,s0,-28
    80005482:	4509                	li	a0,2
    80005484:	ffffe097          	auipc	ra,0xffffe
    80005488:	846080e7          	jalr	-1978(ra) # 80002cca <argint>
    return -1;
    8000548c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000548e:	02054763          	bltz	a0,800054bc <sys_read+0x5c>
    80005492:	fd840593          	addi	a1,s0,-40
    80005496:	4505                	li	a0,1
    80005498:	ffffe097          	auipc	ra,0xffffe
    8000549c:	854080e7          	jalr	-1964(ra) # 80002cec <argaddr>
    return -1;
    800054a0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800054a2:	00054d63          	bltz	a0,800054bc <sys_read+0x5c>
  return fileread(f, p, n);
    800054a6:	fe442603          	lw	a2,-28(s0)
    800054aa:	fd843583          	ld	a1,-40(s0)
    800054ae:	fe843503          	ld	a0,-24(s0)
    800054b2:	fffff097          	auipc	ra,0xfffff
    800054b6:	3fa080e7          	jalr	1018(ra) # 800048ac <fileread>
    800054ba:	87aa                	mv	a5,a0
}
    800054bc:	853e                	mv	a0,a5
    800054be:	70a2                	ld	ra,40(sp)
    800054c0:	7402                	ld	s0,32(sp)
    800054c2:	6145                	addi	sp,sp,48
    800054c4:	8082                	ret

00000000800054c6 <sys_write>:
{
    800054c6:	7179                	addi	sp,sp,-48
    800054c8:	f406                	sd	ra,40(sp)
    800054ca:	f022                	sd	s0,32(sp)
    800054cc:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800054ce:	fe840613          	addi	a2,s0,-24
    800054d2:	4581                	li	a1,0
    800054d4:	4501                	li	a0,0
    800054d6:	00000097          	auipc	ra,0x0
    800054da:	d20080e7          	jalr	-736(ra) # 800051f6 <argfd>
    return -1;
    800054de:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800054e0:	04054163          	bltz	a0,80005522 <sys_write+0x5c>
    800054e4:	fe440593          	addi	a1,s0,-28
    800054e8:	4509                	li	a0,2
    800054ea:	ffffd097          	auipc	ra,0xffffd
    800054ee:	7e0080e7          	jalr	2016(ra) # 80002cca <argint>
    return -1;
    800054f2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800054f4:	02054763          	bltz	a0,80005522 <sys_write+0x5c>
    800054f8:	fd840593          	addi	a1,s0,-40
    800054fc:	4505                	li	a0,1
    800054fe:	ffffd097          	auipc	ra,0xffffd
    80005502:	7ee080e7          	jalr	2030(ra) # 80002cec <argaddr>
    return -1;
    80005506:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005508:	00054d63          	bltz	a0,80005522 <sys_write+0x5c>
  return filewrite(f, p, n);
    8000550c:	fe442603          	lw	a2,-28(s0)
    80005510:	fd843583          	ld	a1,-40(s0)
    80005514:	fe843503          	ld	a0,-24(s0)
    80005518:	fffff097          	auipc	ra,0xfffff
    8000551c:	46c080e7          	jalr	1132(ra) # 80004984 <filewrite>
    80005520:	87aa                	mv	a5,a0
}
    80005522:	853e                	mv	a0,a5
    80005524:	70a2                	ld	ra,40(sp)
    80005526:	7402                	ld	s0,32(sp)
    80005528:	6145                	addi	sp,sp,48
    8000552a:	8082                	ret

000000008000552c <sys_close>:
{
    8000552c:	1101                	addi	sp,sp,-32
    8000552e:	ec06                	sd	ra,24(sp)
    80005530:	e822                	sd	s0,16(sp)
    80005532:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005534:	fe040613          	addi	a2,s0,-32
    80005538:	fec40593          	addi	a1,s0,-20
    8000553c:	4501                	li	a0,0
    8000553e:	00000097          	auipc	ra,0x0
    80005542:	cb8080e7          	jalr	-840(ra) # 800051f6 <argfd>
    return -1;
    80005546:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005548:	02054563          	bltz	a0,80005572 <sys_close+0x46>
  myproc()->ofile[fd] = 0;
    8000554c:	ffffc097          	auipc	ra,0xffffc
    80005550:	53a080e7          	jalr	1338(ra) # 80001a86 <myproc>
    80005554:	fec42783          	lw	a5,-20(s0)
    80005558:	078e                	slli	a5,a5,0x3
    8000555a:	0d078793          	addi	a5,a5,208
    8000555e:	953e                	add	a0,a0,a5
    80005560:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80005564:	fe043503          	ld	a0,-32(s0)
    80005568:	fffff097          	auipc	ra,0xfffff
    8000556c:	1ec080e7          	jalr	492(ra) # 80004754 <fileclose>
  return 0;
    80005570:	4781                	li	a5,0
}
    80005572:	853e                	mv	a0,a5
    80005574:	60e2                	ld	ra,24(sp)
    80005576:	6442                	ld	s0,16(sp)
    80005578:	6105                	addi	sp,sp,32
    8000557a:	8082                	ret

000000008000557c <sys_fstat>:
{
    8000557c:	1101                	addi	sp,sp,-32
    8000557e:	ec06                	sd	ra,24(sp)
    80005580:	e822                	sd	s0,16(sp)
    80005582:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005584:	fe840613          	addi	a2,s0,-24
    80005588:	4581                	li	a1,0
    8000558a:	4501                	li	a0,0
    8000558c:	00000097          	auipc	ra,0x0
    80005590:	c6a080e7          	jalr	-918(ra) # 800051f6 <argfd>
    return -1;
    80005594:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005596:	02054563          	bltz	a0,800055c0 <sys_fstat+0x44>
    8000559a:	fe040593          	addi	a1,s0,-32
    8000559e:	4505                	li	a0,1
    800055a0:	ffffd097          	auipc	ra,0xffffd
    800055a4:	74c080e7          	jalr	1868(ra) # 80002cec <argaddr>
    return -1;
    800055a8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800055aa:	00054b63          	bltz	a0,800055c0 <sys_fstat+0x44>
  return filestat(f, st);
    800055ae:	fe043583          	ld	a1,-32(s0)
    800055b2:	fe843503          	ld	a0,-24(s0)
    800055b6:	fffff097          	auipc	ra,0xfffff
    800055ba:	280080e7          	jalr	640(ra) # 80004836 <filestat>
    800055be:	87aa                	mv	a5,a0
}
    800055c0:	853e                	mv	a0,a5
    800055c2:	60e2                	ld	ra,24(sp)
    800055c4:	6442                	ld	s0,16(sp)
    800055c6:	6105                	addi	sp,sp,32
    800055c8:	8082                	ret

00000000800055ca <sys_link>:
{
    800055ca:	7169                	addi	sp,sp,-304
    800055cc:	f606                	sd	ra,296(sp)
    800055ce:	f222                	sd	s0,288(sp)
    800055d0:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800055d2:	08000613          	li	a2,128
    800055d6:	ed040593          	addi	a1,s0,-304
    800055da:	4501                	li	a0,0
    800055dc:	ffffd097          	auipc	ra,0xffffd
    800055e0:	732080e7          	jalr	1842(ra) # 80002d0e <argstr>
    return -1;
    800055e4:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800055e6:	12054663          	bltz	a0,80005712 <sys_link+0x148>
    800055ea:	08000613          	li	a2,128
    800055ee:	f5040593          	addi	a1,s0,-176
    800055f2:	4505                	li	a0,1
    800055f4:	ffffd097          	auipc	ra,0xffffd
    800055f8:	71a080e7          	jalr	1818(ra) # 80002d0e <argstr>
    return -1;
    800055fc:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800055fe:	10054a63          	bltz	a0,80005712 <sys_link+0x148>
    80005602:	ee26                	sd	s1,280(sp)
  begin_op();
    80005604:	fffff097          	auipc	ra,0xfffff
    80005608:	c6e080e7          	jalr	-914(ra) # 80004272 <begin_op>
  if((ip = namei(old)) == 0){
    8000560c:	ed040513          	addi	a0,s0,-304
    80005610:	fffff097          	auipc	ra,0xfffff
    80005614:	a5c080e7          	jalr	-1444(ra) # 8000406c <namei>
    80005618:	84aa                	mv	s1,a0
    8000561a:	c949                	beqz	a0,800056ac <sys_link+0xe2>
  ilock(ip);
    8000561c:	ffffe097          	auipc	ra,0xffffe
    80005620:	25e080e7          	jalr	606(ra) # 8000387a <ilock>
  if(ip->type == T_DIR){
    80005624:	04449703          	lh	a4,68(s1)
    80005628:	4785                	li	a5,1
    8000562a:	08f70863          	beq	a4,a5,800056ba <sys_link+0xf0>
    8000562e:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80005630:	04a4d783          	lhu	a5,74(s1)
    80005634:	2785                	addiw	a5,a5,1
    80005636:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000563a:	8526                	mv	a0,s1
    8000563c:	ffffe097          	auipc	ra,0xffffe
    80005640:	172080e7          	jalr	370(ra) # 800037ae <iupdate>
  iunlock(ip);
    80005644:	8526                	mv	a0,s1
    80005646:	ffffe097          	auipc	ra,0xffffe
    8000564a:	2fa080e7          	jalr	762(ra) # 80003940 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000564e:	fd040593          	addi	a1,s0,-48
    80005652:	f5040513          	addi	a0,s0,-176
    80005656:	fffff097          	auipc	ra,0xfffff
    8000565a:	a34080e7          	jalr	-1484(ra) # 8000408a <nameiparent>
    8000565e:	892a                	mv	s2,a0
    80005660:	cd35                	beqz	a0,800056dc <sys_link+0x112>
  ilock(dp);
    80005662:	ffffe097          	auipc	ra,0xffffe
    80005666:	218080e7          	jalr	536(ra) # 8000387a <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000566a:	854a                	mv	a0,s2
    8000566c:	00092703          	lw	a4,0(s2)
    80005670:	409c                	lw	a5,0(s1)
    80005672:	06f71063          	bne	a4,a5,800056d2 <sys_link+0x108>
    80005676:	40d0                	lw	a2,4(s1)
    80005678:	fd040593          	addi	a1,s0,-48
    8000567c:	fffff097          	auipc	ra,0xfffff
    80005680:	91a080e7          	jalr	-1766(ra) # 80003f96 <dirlink>
    80005684:	04054763          	bltz	a0,800056d2 <sys_link+0x108>
  iunlockput(dp);
    80005688:	854a                	mv	a0,s2
    8000568a:	ffffe097          	auipc	ra,0xffffe
    8000568e:	458080e7          	jalr	1112(ra) # 80003ae2 <iunlockput>
  iput(ip);
    80005692:	8526                	mv	a0,s1
    80005694:	ffffe097          	auipc	ra,0xffffe
    80005698:	3a4080e7          	jalr	932(ra) # 80003a38 <iput>
  end_op();
    8000569c:	fffff097          	auipc	ra,0xfffff
    800056a0:	c56080e7          	jalr	-938(ra) # 800042f2 <end_op>
  return 0;
    800056a4:	4781                	li	a5,0
    800056a6:	64f2                	ld	s1,280(sp)
    800056a8:	6952                	ld	s2,272(sp)
    800056aa:	a0a5                	j	80005712 <sys_link+0x148>
    end_op();
    800056ac:	fffff097          	auipc	ra,0xfffff
    800056b0:	c46080e7          	jalr	-954(ra) # 800042f2 <end_op>
    return -1;
    800056b4:	57fd                	li	a5,-1
    800056b6:	64f2                	ld	s1,280(sp)
    800056b8:	a8a9                	j	80005712 <sys_link+0x148>
    iunlockput(ip);
    800056ba:	8526                	mv	a0,s1
    800056bc:	ffffe097          	auipc	ra,0xffffe
    800056c0:	426080e7          	jalr	1062(ra) # 80003ae2 <iunlockput>
    end_op();
    800056c4:	fffff097          	auipc	ra,0xfffff
    800056c8:	c2e080e7          	jalr	-978(ra) # 800042f2 <end_op>
    return -1;
    800056cc:	57fd                	li	a5,-1
    800056ce:	64f2                	ld	s1,280(sp)
    800056d0:	a089                	j	80005712 <sys_link+0x148>
    iunlockput(dp);
    800056d2:	854a                	mv	a0,s2
    800056d4:	ffffe097          	auipc	ra,0xffffe
    800056d8:	40e080e7          	jalr	1038(ra) # 80003ae2 <iunlockput>
  ilock(ip);
    800056dc:	8526                	mv	a0,s1
    800056de:	ffffe097          	auipc	ra,0xffffe
    800056e2:	19c080e7          	jalr	412(ra) # 8000387a <ilock>
  ip->nlink--;
    800056e6:	04a4d783          	lhu	a5,74(s1)
    800056ea:	37fd                	addiw	a5,a5,-1
    800056ec:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800056f0:	8526                	mv	a0,s1
    800056f2:	ffffe097          	auipc	ra,0xffffe
    800056f6:	0bc080e7          	jalr	188(ra) # 800037ae <iupdate>
  iunlockput(ip);
    800056fa:	8526                	mv	a0,s1
    800056fc:	ffffe097          	auipc	ra,0xffffe
    80005700:	3e6080e7          	jalr	998(ra) # 80003ae2 <iunlockput>
  end_op();
    80005704:	fffff097          	auipc	ra,0xfffff
    80005708:	bee080e7          	jalr	-1042(ra) # 800042f2 <end_op>
  return -1;
    8000570c:	57fd                	li	a5,-1
    8000570e:	64f2                	ld	s1,280(sp)
    80005710:	6952                	ld	s2,272(sp)
}
    80005712:	853e                	mv	a0,a5
    80005714:	70b2                	ld	ra,296(sp)
    80005716:	7412                	ld	s0,288(sp)
    80005718:	6155                	addi	sp,sp,304
    8000571a:	8082                	ret

000000008000571c <sys_unlink>:
{
    8000571c:	7151                	addi	sp,sp,-240
    8000571e:	f586                	sd	ra,232(sp)
    80005720:	f1a2                	sd	s0,224(sp)
    80005722:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005724:	08000613          	li	a2,128
    80005728:	f3040593          	addi	a1,s0,-208
    8000572c:	4501                	li	a0,0
    8000572e:	ffffd097          	auipc	ra,0xffffd
    80005732:	5e0080e7          	jalr	1504(ra) # 80002d0e <argstr>
    80005736:	1a054763          	bltz	a0,800058e4 <sys_unlink+0x1c8>
    8000573a:	eda6                	sd	s1,216(sp)
  begin_op();
    8000573c:	fffff097          	auipc	ra,0xfffff
    80005740:	b36080e7          	jalr	-1226(ra) # 80004272 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005744:	fb040593          	addi	a1,s0,-80
    80005748:	f3040513          	addi	a0,s0,-208
    8000574c:	fffff097          	auipc	ra,0xfffff
    80005750:	93e080e7          	jalr	-1730(ra) # 8000408a <nameiparent>
    80005754:	84aa                	mv	s1,a0
    80005756:	c165                	beqz	a0,80005836 <sys_unlink+0x11a>
  ilock(dp);
    80005758:	ffffe097          	auipc	ra,0xffffe
    8000575c:	122080e7          	jalr	290(ra) # 8000387a <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005760:	00003597          	auipc	a1,0x3
    80005764:	e8058593          	addi	a1,a1,-384 # 800085e0 <etext+0x5e0>
    80005768:	fb040513          	addi	a0,s0,-80
    8000576c:	ffffe097          	auipc	ra,0xffffe
    80005770:	5e2080e7          	jalr	1506(ra) # 80003d4e <namecmp>
    80005774:	14050963          	beqz	a0,800058c6 <sys_unlink+0x1aa>
    80005778:	00003597          	auipc	a1,0x3
    8000577c:	e7058593          	addi	a1,a1,-400 # 800085e8 <etext+0x5e8>
    80005780:	fb040513          	addi	a0,s0,-80
    80005784:	ffffe097          	auipc	ra,0xffffe
    80005788:	5ca080e7          	jalr	1482(ra) # 80003d4e <namecmp>
    8000578c:	12050d63          	beqz	a0,800058c6 <sys_unlink+0x1aa>
    80005790:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005792:	f2c40613          	addi	a2,s0,-212
    80005796:	fb040593          	addi	a1,s0,-80
    8000579a:	8526                	mv	a0,s1
    8000579c:	ffffe097          	auipc	ra,0xffffe
    800057a0:	5cc080e7          	jalr	1484(ra) # 80003d68 <dirlookup>
    800057a4:	892a                	mv	s2,a0
    800057a6:	10050f63          	beqz	a0,800058c4 <sys_unlink+0x1a8>
    800057aa:	e5ce                	sd	s3,200(sp)
  ilock(ip);
    800057ac:	ffffe097          	auipc	ra,0xffffe
    800057b0:	0ce080e7          	jalr	206(ra) # 8000387a <ilock>
  if(ip->nlink < 1)
    800057b4:	04a91783          	lh	a5,74(s2)
    800057b8:	08f05663          	blez	a5,80005844 <sys_unlink+0x128>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800057bc:	04491703          	lh	a4,68(s2)
    800057c0:	4785                	li	a5,1
    800057c2:	08f70963          	beq	a4,a5,80005854 <sys_unlink+0x138>
  memset(&de, 0, sizeof(de));
    800057c6:	fc040993          	addi	s3,s0,-64
    800057ca:	4641                	li	a2,16
    800057cc:	4581                	li	a1,0
    800057ce:	854e                	mv	a0,s3
    800057d0:	ffffb097          	auipc	ra,0xffffb
    800057d4:	57c080e7          	jalr	1404(ra) # 80000d4c <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800057d8:	4741                	li	a4,16
    800057da:	f2c42683          	lw	a3,-212(s0)
    800057de:	864e                	mv	a2,s3
    800057e0:	4581                	li	a1,0
    800057e2:	8526                	mv	a0,s1
    800057e4:	ffffe097          	auipc	ra,0xffffe
    800057e8:	44e080e7          	jalr	1102(ra) # 80003c32 <writei>
    800057ec:	47c1                	li	a5,16
    800057ee:	0af51863          	bne	a0,a5,8000589e <sys_unlink+0x182>
  if(ip->type == T_DIR){
    800057f2:	04491703          	lh	a4,68(s2)
    800057f6:	4785                	li	a5,1
    800057f8:	0af70b63          	beq	a4,a5,800058ae <sys_unlink+0x192>
  iunlockput(dp);
    800057fc:	8526                	mv	a0,s1
    800057fe:	ffffe097          	auipc	ra,0xffffe
    80005802:	2e4080e7          	jalr	740(ra) # 80003ae2 <iunlockput>
  ip->nlink--;
    80005806:	04a95783          	lhu	a5,74(s2)
    8000580a:	37fd                	addiw	a5,a5,-1
    8000580c:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005810:	854a                	mv	a0,s2
    80005812:	ffffe097          	auipc	ra,0xffffe
    80005816:	f9c080e7          	jalr	-100(ra) # 800037ae <iupdate>
  iunlockput(ip);
    8000581a:	854a                	mv	a0,s2
    8000581c:	ffffe097          	auipc	ra,0xffffe
    80005820:	2c6080e7          	jalr	710(ra) # 80003ae2 <iunlockput>
  end_op();
    80005824:	fffff097          	auipc	ra,0xfffff
    80005828:	ace080e7          	jalr	-1330(ra) # 800042f2 <end_op>
  return 0;
    8000582c:	4501                	li	a0,0
    8000582e:	64ee                	ld	s1,216(sp)
    80005830:	694e                	ld	s2,208(sp)
    80005832:	69ae                	ld	s3,200(sp)
    80005834:	a065                	j	800058dc <sys_unlink+0x1c0>
    end_op();
    80005836:	fffff097          	auipc	ra,0xfffff
    8000583a:	abc080e7          	jalr	-1348(ra) # 800042f2 <end_op>
    return -1;
    8000583e:	557d                	li	a0,-1
    80005840:	64ee                	ld	s1,216(sp)
    80005842:	a869                	j	800058dc <sys_unlink+0x1c0>
    panic("unlink: nlink < 1");
    80005844:	00003517          	auipc	a0,0x3
    80005848:	dcc50513          	addi	a0,a0,-564 # 80008610 <etext+0x610>
    8000584c:	ffffb097          	auipc	ra,0xffffb
    80005850:	d0a080e7          	jalr	-758(ra) # 80000556 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005854:	04c92703          	lw	a4,76(s2)
    80005858:	02000793          	li	a5,32
    8000585c:	f6e7f5e3          	bgeu	a5,a4,800057c6 <sys_unlink+0xaa>
    80005860:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005862:	4741                	li	a4,16
    80005864:	86ce                	mv	a3,s3
    80005866:	f1840613          	addi	a2,s0,-232
    8000586a:	4581                	li	a1,0
    8000586c:	854a                	mv	a0,s2
    8000586e:	ffffe097          	auipc	ra,0xffffe
    80005872:	2ca080e7          	jalr	714(ra) # 80003b38 <readi>
    80005876:	47c1                	li	a5,16
    80005878:	00f51b63          	bne	a0,a5,8000588e <sys_unlink+0x172>
    if(de.inum != 0)
    8000587c:	f1845783          	lhu	a5,-232(s0)
    80005880:	e7a5                	bnez	a5,800058e8 <sys_unlink+0x1cc>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005882:	29c1                	addiw	s3,s3,16
    80005884:	04c92783          	lw	a5,76(s2)
    80005888:	fcf9ede3          	bltu	s3,a5,80005862 <sys_unlink+0x146>
    8000588c:	bf2d                	j	800057c6 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    8000588e:	00003517          	auipc	a0,0x3
    80005892:	d9a50513          	addi	a0,a0,-614 # 80008628 <etext+0x628>
    80005896:	ffffb097          	auipc	ra,0xffffb
    8000589a:	cc0080e7          	jalr	-832(ra) # 80000556 <panic>
    panic("unlink: writei");
    8000589e:	00003517          	auipc	a0,0x3
    800058a2:	da250513          	addi	a0,a0,-606 # 80008640 <etext+0x640>
    800058a6:	ffffb097          	auipc	ra,0xffffb
    800058aa:	cb0080e7          	jalr	-848(ra) # 80000556 <panic>
    dp->nlink--;
    800058ae:	04a4d783          	lhu	a5,74(s1)
    800058b2:	37fd                	addiw	a5,a5,-1
    800058b4:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800058b8:	8526                	mv	a0,s1
    800058ba:	ffffe097          	auipc	ra,0xffffe
    800058be:	ef4080e7          	jalr	-268(ra) # 800037ae <iupdate>
    800058c2:	bf2d                	j	800057fc <sys_unlink+0xe0>
    800058c4:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    800058c6:	8526                	mv	a0,s1
    800058c8:	ffffe097          	auipc	ra,0xffffe
    800058cc:	21a080e7          	jalr	538(ra) # 80003ae2 <iunlockput>
  end_op();
    800058d0:	fffff097          	auipc	ra,0xfffff
    800058d4:	a22080e7          	jalr	-1502(ra) # 800042f2 <end_op>
  return -1;
    800058d8:	557d                	li	a0,-1
    800058da:	64ee                	ld	s1,216(sp)
}
    800058dc:	70ae                	ld	ra,232(sp)
    800058de:	740e                	ld	s0,224(sp)
    800058e0:	616d                	addi	sp,sp,240
    800058e2:	8082                	ret
    return -1;
    800058e4:	557d                	li	a0,-1
    800058e6:	bfdd                	j	800058dc <sys_unlink+0x1c0>
    iunlockput(ip);
    800058e8:	854a                	mv	a0,s2
    800058ea:	ffffe097          	auipc	ra,0xffffe
    800058ee:	1f8080e7          	jalr	504(ra) # 80003ae2 <iunlockput>
    goto bad;
    800058f2:	694e                	ld	s2,208(sp)
    800058f4:	69ae                	ld	s3,200(sp)
    800058f6:	bfc1                	j	800058c6 <sys_unlink+0x1aa>

00000000800058f8 <sys_open>:

uint64
sys_open(void)
{
    800058f8:	7131                	addi	sp,sp,-192
    800058fa:	fd06                	sd	ra,184(sp)
    800058fc:	f922                	sd	s0,176(sp)
    800058fe:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005900:	08000613          	li	a2,128
    80005904:	f5040593          	addi	a1,s0,-176
    80005908:	4501                	li	a0,0
    8000590a:	ffffd097          	auipc	ra,0xffffd
    8000590e:	404080e7          	jalr	1028(ra) # 80002d0e <argstr>
    return -1;
    80005912:	57fd                	li	a5,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005914:	0c054963          	bltz	a0,800059e6 <sys_open+0xee>
    80005918:	f4c40593          	addi	a1,s0,-180
    8000591c:	4505                	li	a0,1
    8000591e:	ffffd097          	auipc	ra,0xffffd
    80005922:	3ac080e7          	jalr	940(ra) # 80002cca <argint>
    return -1;
    80005926:	57fd                	li	a5,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005928:	0a054f63          	bltz	a0,800059e6 <sys_open+0xee>
    8000592c:	f526                	sd	s1,168(sp)

  begin_op();
    8000592e:	fffff097          	auipc	ra,0xfffff
    80005932:	944080e7          	jalr	-1724(ra) # 80004272 <begin_op>

  if(omode & O_CREATE){
    80005936:	f4c42783          	lw	a5,-180(s0)
    8000593a:	2007f793          	andi	a5,a5,512
    8000593e:	c3e1                	beqz	a5,800059fe <sys_open+0x106>
    ip = create(path, T_FILE, 0, 0);
    80005940:	4681                	li	a3,0
    80005942:	4601                	li	a2,0
    80005944:	4589                	li	a1,2
    80005946:	f5040513          	addi	a0,s0,-176
    8000594a:	00000097          	auipc	ra,0x0
    8000594e:	95a080e7          	jalr	-1702(ra) # 800052a4 <create>
    80005952:	84aa                	mv	s1,a0
    if(ip == 0){
    80005954:	cd51                	beqz	a0,800059f0 <sys_open+0xf8>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005956:	04449703          	lh	a4,68(s1)
    8000595a:	478d                	li	a5,3
    8000595c:	00f71763          	bne	a4,a5,8000596a <sys_open+0x72>
    80005960:	0464d703          	lhu	a4,70(s1)
    80005964:	47a5                	li	a5,9
    80005966:	0ee7e363          	bltu	a5,a4,80005a4c <sys_open+0x154>
    8000596a:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    8000596c:	fffff097          	auipc	ra,0xfffff
    80005970:	d2c080e7          	jalr	-724(ra) # 80004698 <filealloc>
    80005974:	892a                	mv	s2,a0
    80005976:	cd6d                	beqz	a0,80005a70 <sys_open+0x178>
    80005978:	ed4e                	sd	s3,152(sp)
    8000597a:	00000097          	auipc	ra,0x0
    8000597e:	8e6080e7          	jalr	-1818(ra) # 80005260 <fdalloc>
    80005982:	89aa                	mv	s3,a0
    80005984:	0e054063          	bltz	a0,80005a64 <sys_open+0x16c>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005988:	04449703          	lh	a4,68(s1)
    8000598c:	478d                	li	a5,3
    8000598e:	0ef70e63          	beq	a4,a5,80005a8a <sys_open+0x192>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005992:	4789                	li	a5,2
    80005994:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80005998:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    8000599c:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    800059a0:	f4c42783          	lw	a5,-180(s0)
    800059a4:	0017f713          	andi	a4,a5,1
    800059a8:	00174713          	xori	a4,a4,1
    800059ac:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800059b0:	0037f713          	andi	a4,a5,3
    800059b4:	00e03733          	snez	a4,a4
    800059b8:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800059bc:	4007f793          	andi	a5,a5,1024
    800059c0:	c791                	beqz	a5,800059cc <sys_open+0xd4>
    800059c2:	04449703          	lh	a4,68(s1)
    800059c6:	4789                	li	a5,2
    800059c8:	0cf70863          	beq	a4,a5,80005a98 <sys_open+0x1a0>
    itrunc(ip);
  }

  iunlock(ip);
    800059cc:	8526                	mv	a0,s1
    800059ce:	ffffe097          	auipc	ra,0xffffe
    800059d2:	f72080e7          	jalr	-142(ra) # 80003940 <iunlock>
  end_op();
    800059d6:	fffff097          	auipc	ra,0xfffff
    800059da:	91c080e7          	jalr	-1764(ra) # 800042f2 <end_op>

  return fd;
    800059de:	87ce                	mv	a5,s3
    800059e0:	74aa                	ld	s1,168(sp)
    800059e2:	790a                	ld	s2,160(sp)
    800059e4:	69ea                	ld	s3,152(sp)
}
    800059e6:	853e                	mv	a0,a5
    800059e8:	70ea                	ld	ra,184(sp)
    800059ea:	744a                	ld	s0,176(sp)
    800059ec:	6129                	addi	sp,sp,192
    800059ee:	8082                	ret
      end_op();
    800059f0:	fffff097          	auipc	ra,0xfffff
    800059f4:	902080e7          	jalr	-1790(ra) # 800042f2 <end_op>
      return -1;
    800059f8:	57fd                	li	a5,-1
    800059fa:	74aa                	ld	s1,168(sp)
    800059fc:	b7ed                	j	800059e6 <sys_open+0xee>
    if((ip = namei(path)) == 0){
    800059fe:	f5040513          	addi	a0,s0,-176
    80005a02:	ffffe097          	auipc	ra,0xffffe
    80005a06:	66a080e7          	jalr	1642(ra) # 8000406c <namei>
    80005a0a:	84aa                	mv	s1,a0
    80005a0c:	c90d                	beqz	a0,80005a3e <sys_open+0x146>
    ilock(ip);
    80005a0e:	ffffe097          	auipc	ra,0xffffe
    80005a12:	e6c080e7          	jalr	-404(ra) # 8000387a <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005a16:	04449703          	lh	a4,68(s1)
    80005a1a:	4785                	li	a5,1
    80005a1c:	f2f71de3          	bne	a4,a5,80005956 <sys_open+0x5e>
    80005a20:	f4c42783          	lw	a5,-180(s0)
    80005a24:	d3b9                	beqz	a5,8000596a <sys_open+0x72>
      iunlockput(ip);
    80005a26:	8526                	mv	a0,s1
    80005a28:	ffffe097          	auipc	ra,0xffffe
    80005a2c:	0ba080e7          	jalr	186(ra) # 80003ae2 <iunlockput>
      end_op();
    80005a30:	fffff097          	auipc	ra,0xfffff
    80005a34:	8c2080e7          	jalr	-1854(ra) # 800042f2 <end_op>
      return -1;
    80005a38:	57fd                	li	a5,-1
    80005a3a:	74aa                	ld	s1,168(sp)
    80005a3c:	b76d                	j	800059e6 <sys_open+0xee>
      end_op();
    80005a3e:	fffff097          	auipc	ra,0xfffff
    80005a42:	8b4080e7          	jalr	-1868(ra) # 800042f2 <end_op>
      return -1;
    80005a46:	57fd                	li	a5,-1
    80005a48:	74aa                	ld	s1,168(sp)
    80005a4a:	bf71                	j	800059e6 <sys_open+0xee>
    iunlockput(ip);
    80005a4c:	8526                	mv	a0,s1
    80005a4e:	ffffe097          	auipc	ra,0xffffe
    80005a52:	094080e7          	jalr	148(ra) # 80003ae2 <iunlockput>
    end_op();
    80005a56:	fffff097          	auipc	ra,0xfffff
    80005a5a:	89c080e7          	jalr	-1892(ra) # 800042f2 <end_op>
    return -1;
    80005a5e:	57fd                	li	a5,-1
    80005a60:	74aa                	ld	s1,168(sp)
    80005a62:	b751                	j	800059e6 <sys_open+0xee>
      fileclose(f);
    80005a64:	854a                	mv	a0,s2
    80005a66:	fffff097          	auipc	ra,0xfffff
    80005a6a:	cee080e7          	jalr	-786(ra) # 80004754 <fileclose>
    80005a6e:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80005a70:	8526                	mv	a0,s1
    80005a72:	ffffe097          	auipc	ra,0xffffe
    80005a76:	070080e7          	jalr	112(ra) # 80003ae2 <iunlockput>
    end_op();
    80005a7a:	fffff097          	auipc	ra,0xfffff
    80005a7e:	878080e7          	jalr	-1928(ra) # 800042f2 <end_op>
    return -1;
    80005a82:	57fd                	li	a5,-1
    80005a84:	74aa                	ld	s1,168(sp)
    80005a86:	790a                	ld	s2,160(sp)
    80005a88:	bfb9                	j	800059e6 <sys_open+0xee>
    f->type = FD_DEVICE;
    80005a8a:	00e92023          	sw	a4,0(s2)
    f->major = ip->major;
    80005a8e:	04649783          	lh	a5,70(s1)
    80005a92:	02f91223          	sh	a5,36(s2)
    80005a96:	b719                	j	8000599c <sys_open+0xa4>
    itrunc(ip);
    80005a98:	8526                	mv	a0,s1
    80005a9a:	ffffe097          	auipc	ra,0xffffe
    80005a9e:	ef2080e7          	jalr	-270(ra) # 8000398c <itrunc>
    80005aa2:	b72d                	j	800059cc <sys_open+0xd4>

0000000080005aa4 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005aa4:	7175                	addi	sp,sp,-144
    80005aa6:	e506                	sd	ra,136(sp)
    80005aa8:	e122                	sd	s0,128(sp)
    80005aaa:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005aac:	ffffe097          	auipc	ra,0xffffe
    80005ab0:	7c6080e7          	jalr	1990(ra) # 80004272 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005ab4:	08000613          	li	a2,128
    80005ab8:	f7040593          	addi	a1,s0,-144
    80005abc:	4501                	li	a0,0
    80005abe:	ffffd097          	auipc	ra,0xffffd
    80005ac2:	250080e7          	jalr	592(ra) # 80002d0e <argstr>
    80005ac6:	02054963          	bltz	a0,80005af8 <sys_mkdir+0x54>
    80005aca:	4681                	li	a3,0
    80005acc:	4601                	li	a2,0
    80005ace:	4585                	li	a1,1
    80005ad0:	f7040513          	addi	a0,s0,-144
    80005ad4:	fffff097          	auipc	ra,0xfffff
    80005ad8:	7d0080e7          	jalr	2000(ra) # 800052a4 <create>
    80005adc:	cd11                	beqz	a0,80005af8 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005ade:	ffffe097          	auipc	ra,0xffffe
    80005ae2:	004080e7          	jalr	4(ra) # 80003ae2 <iunlockput>
  end_op();
    80005ae6:	fffff097          	auipc	ra,0xfffff
    80005aea:	80c080e7          	jalr	-2036(ra) # 800042f2 <end_op>
  return 0;
    80005aee:	4501                	li	a0,0
}
    80005af0:	60aa                	ld	ra,136(sp)
    80005af2:	640a                	ld	s0,128(sp)
    80005af4:	6149                	addi	sp,sp,144
    80005af6:	8082                	ret
    end_op();
    80005af8:	ffffe097          	auipc	ra,0xffffe
    80005afc:	7fa080e7          	jalr	2042(ra) # 800042f2 <end_op>
    return -1;
    80005b00:	557d                	li	a0,-1
    80005b02:	b7fd                	j	80005af0 <sys_mkdir+0x4c>

0000000080005b04 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005b04:	7135                	addi	sp,sp,-160
    80005b06:	ed06                	sd	ra,152(sp)
    80005b08:	e922                	sd	s0,144(sp)
    80005b0a:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005b0c:	ffffe097          	auipc	ra,0xffffe
    80005b10:	766080e7          	jalr	1894(ra) # 80004272 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005b14:	08000613          	li	a2,128
    80005b18:	f7040593          	addi	a1,s0,-144
    80005b1c:	4501                	li	a0,0
    80005b1e:	ffffd097          	auipc	ra,0xffffd
    80005b22:	1f0080e7          	jalr	496(ra) # 80002d0e <argstr>
    80005b26:	04054a63          	bltz	a0,80005b7a <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80005b2a:	f6c40593          	addi	a1,s0,-148
    80005b2e:	4505                	li	a0,1
    80005b30:	ffffd097          	auipc	ra,0xffffd
    80005b34:	19a080e7          	jalr	410(ra) # 80002cca <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005b38:	04054163          	bltz	a0,80005b7a <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80005b3c:	f6840593          	addi	a1,s0,-152
    80005b40:	4509                	li	a0,2
    80005b42:	ffffd097          	auipc	ra,0xffffd
    80005b46:	188080e7          	jalr	392(ra) # 80002cca <argint>
     argint(1, &major) < 0 ||
    80005b4a:	02054863          	bltz	a0,80005b7a <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005b4e:	f6841683          	lh	a3,-152(s0)
    80005b52:	f6c41603          	lh	a2,-148(s0)
    80005b56:	458d                	li	a1,3
    80005b58:	f7040513          	addi	a0,s0,-144
    80005b5c:	fffff097          	auipc	ra,0xfffff
    80005b60:	748080e7          	jalr	1864(ra) # 800052a4 <create>
     argint(2, &minor) < 0 ||
    80005b64:	c919                	beqz	a0,80005b7a <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005b66:	ffffe097          	auipc	ra,0xffffe
    80005b6a:	f7c080e7          	jalr	-132(ra) # 80003ae2 <iunlockput>
  end_op();
    80005b6e:	ffffe097          	auipc	ra,0xffffe
    80005b72:	784080e7          	jalr	1924(ra) # 800042f2 <end_op>
  return 0;
    80005b76:	4501                	li	a0,0
    80005b78:	a031                	j	80005b84 <sys_mknod+0x80>
    end_op();
    80005b7a:	ffffe097          	auipc	ra,0xffffe
    80005b7e:	778080e7          	jalr	1912(ra) # 800042f2 <end_op>
    return -1;
    80005b82:	557d                	li	a0,-1
}
    80005b84:	60ea                	ld	ra,152(sp)
    80005b86:	644a                	ld	s0,144(sp)
    80005b88:	610d                	addi	sp,sp,160
    80005b8a:	8082                	ret

0000000080005b8c <sys_chdir>:

uint64
sys_chdir(void)
{
    80005b8c:	7135                	addi	sp,sp,-160
    80005b8e:	ed06                	sd	ra,152(sp)
    80005b90:	e922                	sd	s0,144(sp)
    80005b92:	e14a                	sd	s2,128(sp)
    80005b94:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005b96:	ffffc097          	auipc	ra,0xffffc
    80005b9a:	ef0080e7          	jalr	-272(ra) # 80001a86 <myproc>
    80005b9e:	892a                	mv	s2,a0
  
  begin_op();
    80005ba0:	ffffe097          	auipc	ra,0xffffe
    80005ba4:	6d2080e7          	jalr	1746(ra) # 80004272 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005ba8:	08000613          	li	a2,128
    80005bac:	f6040593          	addi	a1,s0,-160
    80005bb0:	4501                	li	a0,0
    80005bb2:	ffffd097          	auipc	ra,0xffffd
    80005bb6:	15c080e7          	jalr	348(ra) # 80002d0e <argstr>
    80005bba:	04054d63          	bltz	a0,80005c14 <sys_chdir+0x88>
    80005bbe:	e526                	sd	s1,136(sp)
    80005bc0:	f6040513          	addi	a0,s0,-160
    80005bc4:	ffffe097          	auipc	ra,0xffffe
    80005bc8:	4a8080e7          	jalr	1192(ra) # 8000406c <namei>
    80005bcc:	84aa                	mv	s1,a0
    80005bce:	c131                	beqz	a0,80005c12 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005bd0:	ffffe097          	auipc	ra,0xffffe
    80005bd4:	caa080e7          	jalr	-854(ra) # 8000387a <ilock>
  if(ip->type != T_DIR){
    80005bd8:	04449703          	lh	a4,68(s1)
    80005bdc:	4785                	li	a5,1
    80005bde:	04f71163          	bne	a4,a5,80005c20 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005be2:	8526                	mv	a0,s1
    80005be4:	ffffe097          	auipc	ra,0xffffe
    80005be8:	d5c080e7          	jalr	-676(ra) # 80003940 <iunlock>
  iput(p->cwd);
    80005bec:	15093503          	ld	a0,336(s2)
    80005bf0:	ffffe097          	auipc	ra,0xffffe
    80005bf4:	e48080e7          	jalr	-440(ra) # 80003a38 <iput>
  end_op();
    80005bf8:	ffffe097          	auipc	ra,0xffffe
    80005bfc:	6fa080e7          	jalr	1786(ra) # 800042f2 <end_op>
  p->cwd = ip;
    80005c00:	14993823          	sd	s1,336(s2)
  return 0;
    80005c04:	4501                	li	a0,0
    80005c06:	64aa                	ld	s1,136(sp)
}
    80005c08:	60ea                	ld	ra,152(sp)
    80005c0a:	644a                	ld	s0,144(sp)
    80005c0c:	690a                	ld	s2,128(sp)
    80005c0e:	610d                	addi	sp,sp,160
    80005c10:	8082                	ret
    80005c12:	64aa                	ld	s1,136(sp)
    end_op();
    80005c14:	ffffe097          	auipc	ra,0xffffe
    80005c18:	6de080e7          	jalr	1758(ra) # 800042f2 <end_op>
    return -1;
    80005c1c:	557d                	li	a0,-1
    80005c1e:	b7ed                	j	80005c08 <sys_chdir+0x7c>
    iunlockput(ip);
    80005c20:	8526                	mv	a0,s1
    80005c22:	ffffe097          	auipc	ra,0xffffe
    80005c26:	ec0080e7          	jalr	-320(ra) # 80003ae2 <iunlockput>
    end_op();
    80005c2a:	ffffe097          	auipc	ra,0xffffe
    80005c2e:	6c8080e7          	jalr	1736(ra) # 800042f2 <end_op>
    return -1;
    80005c32:	557d                	li	a0,-1
    80005c34:	64aa                	ld	s1,136(sp)
    80005c36:	bfc9                	j	80005c08 <sys_chdir+0x7c>

0000000080005c38 <sys_exec>:

uint64
sys_exec(void)
{
    80005c38:	7145                	addi	sp,sp,-464
    80005c3a:	e786                	sd	ra,456(sp)
    80005c3c:	e3a2                	sd	s0,448(sp)
    80005c3e:	fb4a                	sd	s2,432(sp)
    80005c40:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005c42:	08000613          	li	a2,128
    80005c46:	f4040593          	addi	a1,s0,-192
    80005c4a:	4501                	li	a0,0
    80005c4c:	ffffd097          	auipc	ra,0xffffd
    80005c50:	0c2080e7          	jalr	194(ra) # 80002d0e <argstr>
    return -1;
    80005c54:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005c56:	10054463          	bltz	a0,80005d5e <sys_exec+0x126>
    80005c5a:	e3840593          	addi	a1,s0,-456
    80005c5e:	4505                	li	a0,1
    80005c60:	ffffd097          	auipc	ra,0xffffd
    80005c64:	08c080e7          	jalr	140(ra) # 80002cec <argaddr>
    80005c68:	0e054b63          	bltz	a0,80005d5e <sys_exec+0x126>
    80005c6c:	ff26                	sd	s1,440(sp)
    80005c6e:	f74e                	sd	s3,424(sp)
    80005c70:	f352                	sd	s4,416(sp)
    80005c72:	ef56                	sd	s5,408(sp)
    80005c74:	eb5a                	sd	s6,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80005c76:	10000613          	li	a2,256
    80005c7a:	4581                	li	a1,0
    80005c7c:	e4040513          	addi	a0,s0,-448
    80005c80:	ffffb097          	auipc	ra,0xffffb
    80005c84:	0cc080e7          	jalr	204(ra) # 80000d4c <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005c88:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005c8c:	89a6                	mv	s3,s1
    80005c8e:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005c90:	e3040a13          	addi	s4,s0,-464
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005c94:	6a85                	lui	s5,0x1
    if(i >= NELEM(argv)){
    80005c96:	02000b13          	li	s6,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005c9a:	00391513          	slli	a0,s2,0x3
    80005c9e:	85d2                	mv	a1,s4
    80005ca0:	e3843783          	ld	a5,-456(s0)
    80005ca4:	953e                	add	a0,a0,a5
    80005ca6:	ffffd097          	auipc	ra,0xffffd
    80005caa:	f8a080e7          	jalr	-118(ra) # 80002c30 <fetchaddr>
    80005cae:	02054a63          	bltz	a0,80005ce2 <sys_exec+0xaa>
    if(uarg == 0){
    80005cb2:	e3043783          	ld	a5,-464(s0)
    80005cb6:	cba1                	beqz	a5,80005d06 <sys_exec+0xce>
    argv[i] = kalloc();
    80005cb8:	ffffb097          	auipc	ra,0xffffb
    80005cbc:	e98080e7          	jalr	-360(ra) # 80000b50 <kalloc>
    80005cc0:	85aa                	mv	a1,a0
    80005cc2:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005cc6:	cd11                	beqz	a0,80005ce2 <sys_exec+0xaa>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005cc8:	8656                	mv	a2,s5
    80005cca:	e3043503          	ld	a0,-464(s0)
    80005cce:	ffffd097          	auipc	ra,0xffffd
    80005cd2:	fb4080e7          	jalr	-76(ra) # 80002c82 <fetchstr>
    80005cd6:	00054663          	bltz	a0,80005ce2 <sys_exec+0xaa>
    if(i >= NELEM(argv)){
    80005cda:	0905                	addi	s2,s2,1
    80005cdc:	09a1                	addi	s3,s3,8
    80005cde:	fb691ee3          	bne	s2,s6,80005c9a <sys_exec+0x62>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005ce2:	f4040913          	addi	s2,s0,-192
    80005ce6:	6088                	ld	a0,0(s1)
    80005ce8:	c52d                	beqz	a0,80005d52 <sys_exec+0x11a>
    kfree(argv[i]);
    80005cea:	ffffb097          	auipc	ra,0xffffb
    80005cee:	d62080e7          	jalr	-670(ra) # 80000a4c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005cf2:	04a1                	addi	s1,s1,8
    80005cf4:	ff2499e3          	bne	s1,s2,80005ce6 <sys_exec+0xae>
  return -1;
    80005cf8:	597d                	li	s2,-1
    80005cfa:	74fa                	ld	s1,440(sp)
    80005cfc:	79ba                	ld	s3,424(sp)
    80005cfe:	7a1a                	ld	s4,416(sp)
    80005d00:	6afa                	ld	s5,408(sp)
    80005d02:	6b5a                	ld	s6,400(sp)
    80005d04:	a8a9                	j	80005d5e <sys_exec+0x126>
      argv[i] = 0;
    80005d06:	0009079b          	sext.w	a5,s2
    80005d0a:	e4040593          	addi	a1,s0,-448
    80005d0e:	078e                	slli	a5,a5,0x3
    80005d10:	97ae                	add	a5,a5,a1
    80005d12:	0007b023          	sd	zero,0(a5)
  int ret = exec(path, argv);
    80005d16:	f4040513          	addi	a0,s0,-192
    80005d1a:	fffff097          	auipc	ra,0xfffff
    80005d1e:	128080e7          	jalr	296(ra) # 80004e42 <exec>
    80005d22:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005d24:	f4040993          	addi	s3,s0,-192
    80005d28:	6088                	ld	a0,0(s1)
    80005d2a:	cd11                	beqz	a0,80005d46 <sys_exec+0x10e>
    kfree(argv[i]);
    80005d2c:	ffffb097          	auipc	ra,0xffffb
    80005d30:	d20080e7          	jalr	-736(ra) # 80000a4c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005d34:	04a1                	addi	s1,s1,8
    80005d36:	ff3499e3          	bne	s1,s3,80005d28 <sys_exec+0xf0>
    80005d3a:	74fa                	ld	s1,440(sp)
    80005d3c:	79ba                	ld	s3,424(sp)
    80005d3e:	7a1a                	ld	s4,416(sp)
    80005d40:	6afa                	ld	s5,408(sp)
    80005d42:	6b5a                	ld	s6,400(sp)
    80005d44:	a829                	j	80005d5e <sys_exec+0x126>
  return ret;
    80005d46:	74fa                	ld	s1,440(sp)
    80005d48:	79ba                	ld	s3,424(sp)
    80005d4a:	7a1a                	ld	s4,416(sp)
    80005d4c:	6afa                	ld	s5,408(sp)
    80005d4e:	6b5a                	ld	s6,400(sp)
    80005d50:	a039                	j	80005d5e <sys_exec+0x126>
  return -1;
    80005d52:	597d                	li	s2,-1
    80005d54:	74fa                	ld	s1,440(sp)
    80005d56:	79ba                	ld	s3,424(sp)
    80005d58:	7a1a                	ld	s4,416(sp)
    80005d5a:	6afa                	ld	s5,408(sp)
    80005d5c:	6b5a                	ld	s6,400(sp)
}
    80005d5e:	854a                	mv	a0,s2
    80005d60:	60be                	ld	ra,456(sp)
    80005d62:	641e                	ld	s0,448(sp)
    80005d64:	795a                	ld	s2,432(sp)
    80005d66:	6179                	addi	sp,sp,464
    80005d68:	8082                	ret

0000000080005d6a <sys_pipe>:

uint64
sys_pipe(void)
{
    80005d6a:	7139                	addi	sp,sp,-64
    80005d6c:	fc06                	sd	ra,56(sp)
    80005d6e:	f822                	sd	s0,48(sp)
    80005d70:	f426                	sd	s1,40(sp)
    80005d72:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005d74:	ffffc097          	auipc	ra,0xffffc
    80005d78:	d12080e7          	jalr	-750(ra) # 80001a86 <myproc>
    80005d7c:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005d7e:	fd840593          	addi	a1,s0,-40
    80005d82:	4501                	li	a0,0
    80005d84:	ffffd097          	auipc	ra,0xffffd
    80005d88:	f68080e7          	jalr	-152(ra) # 80002cec <argaddr>
    return -1;
    80005d8c:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005d8e:	0e054363          	bltz	a0,80005e74 <sys_pipe+0x10a>
  if(pipealloc(&rf, &wf) < 0)
    80005d92:	fc840593          	addi	a1,s0,-56
    80005d96:	fd040513          	addi	a0,s0,-48
    80005d9a:	fffff097          	auipc	ra,0xfffff
    80005d9e:	d3a080e7          	jalr	-710(ra) # 80004ad4 <pipealloc>
    return -1;
    80005da2:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005da4:	0c054863          	bltz	a0,80005e74 <sys_pipe+0x10a>
  fd0 = -1;
    80005da8:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005dac:	fd043503          	ld	a0,-48(s0)
    80005db0:	fffff097          	auipc	ra,0xfffff
    80005db4:	4b0080e7          	jalr	1200(ra) # 80005260 <fdalloc>
    80005db8:	fca42223          	sw	a0,-60(s0)
    80005dbc:	08054f63          	bltz	a0,80005e5a <sys_pipe+0xf0>
    80005dc0:	fc843503          	ld	a0,-56(s0)
    80005dc4:	fffff097          	auipc	ra,0xfffff
    80005dc8:	49c080e7          	jalr	1180(ra) # 80005260 <fdalloc>
    80005dcc:	fca42023          	sw	a0,-64(s0)
    80005dd0:	06054b63          	bltz	a0,80005e46 <sys_pipe+0xdc>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005dd4:	4691                	li	a3,4
    80005dd6:	fc440613          	addi	a2,s0,-60
    80005dda:	fd843583          	ld	a1,-40(s0)
    80005dde:	68a8                	ld	a0,80(s1)
    80005de0:	ffffc097          	auipc	ra,0xffffc
    80005de4:	92a080e7          	jalr	-1750(ra) # 8000170a <copyout>
    80005de8:	02054063          	bltz	a0,80005e08 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005dec:	4691                	li	a3,4
    80005dee:	fc040613          	addi	a2,s0,-64
    80005df2:	fd843583          	ld	a1,-40(s0)
    80005df6:	95b6                	add	a1,a1,a3
    80005df8:	68a8                	ld	a0,80(s1)
    80005dfa:	ffffc097          	auipc	ra,0xffffc
    80005dfe:	910080e7          	jalr	-1776(ra) # 8000170a <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005e02:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005e04:	06055863          	bgez	a0,80005e74 <sys_pipe+0x10a>
    p->ofile[fd0] = 0;
    80005e08:	fc442783          	lw	a5,-60(s0)
    80005e0c:	078e                	slli	a5,a5,0x3
    80005e0e:	0d078793          	addi	a5,a5,208
    80005e12:	97a6                	add	a5,a5,s1
    80005e14:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005e18:	fc042783          	lw	a5,-64(s0)
    80005e1c:	078e                	slli	a5,a5,0x3
    80005e1e:	0d078793          	addi	a5,a5,208
    80005e22:	00f48533          	add	a0,s1,a5
    80005e26:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005e2a:	fd043503          	ld	a0,-48(s0)
    80005e2e:	fffff097          	auipc	ra,0xfffff
    80005e32:	926080e7          	jalr	-1754(ra) # 80004754 <fileclose>
    fileclose(wf);
    80005e36:	fc843503          	ld	a0,-56(s0)
    80005e3a:	fffff097          	auipc	ra,0xfffff
    80005e3e:	91a080e7          	jalr	-1766(ra) # 80004754 <fileclose>
    return -1;
    80005e42:	57fd                	li	a5,-1
    80005e44:	a805                	j	80005e74 <sys_pipe+0x10a>
    if(fd0 >= 0)
    80005e46:	fc442783          	lw	a5,-60(s0)
    80005e4a:	0007c863          	bltz	a5,80005e5a <sys_pipe+0xf0>
      p->ofile[fd0] = 0;
    80005e4e:	078e                	slli	a5,a5,0x3
    80005e50:	0d078793          	addi	a5,a5,208
    80005e54:	97a6                	add	a5,a5,s1
    80005e56:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005e5a:	fd043503          	ld	a0,-48(s0)
    80005e5e:	fffff097          	auipc	ra,0xfffff
    80005e62:	8f6080e7          	jalr	-1802(ra) # 80004754 <fileclose>
    fileclose(wf);
    80005e66:	fc843503          	ld	a0,-56(s0)
    80005e6a:	fffff097          	auipc	ra,0xfffff
    80005e6e:	8ea080e7          	jalr	-1814(ra) # 80004754 <fileclose>
    return -1;
    80005e72:	57fd                	li	a5,-1
}
    80005e74:	853e                	mv	a0,a5
    80005e76:	70e2                	ld	ra,56(sp)
    80005e78:	7442                	ld	s0,48(sp)
    80005e7a:	74a2                	ld	s1,40(sp)
    80005e7c:	6121                	addi	sp,sp,64
    80005e7e:	8082                	ret

0000000080005e80 <kernelvec>:
    80005e80:	7111                	addi	sp,sp,-256
    80005e82:	e006                	sd	ra,0(sp)
    80005e84:	e40a                	sd	sp,8(sp)
    80005e86:	e80e                	sd	gp,16(sp)
    80005e88:	ec12                	sd	tp,24(sp)
    80005e8a:	f016                	sd	t0,32(sp)
    80005e8c:	f41a                	sd	t1,40(sp)
    80005e8e:	f81e                	sd	t2,48(sp)
    80005e90:	fc22                	sd	s0,56(sp)
    80005e92:	e0a6                	sd	s1,64(sp)
    80005e94:	e4aa                	sd	a0,72(sp)
    80005e96:	e8ae                	sd	a1,80(sp)
    80005e98:	ecb2                	sd	a2,88(sp)
    80005e9a:	f0b6                	sd	a3,96(sp)
    80005e9c:	f4ba                	sd	a4,104(sp)
    80005e9e:	f8be                	sd	a5,112(sp)
    80005ea0:	fcc2                	sd	a6,120(sp)
    80005ea2:	e146                	sd	a7,128(sp)
    80005ea4:	e54a                	sd	s2,136(sp)
    80005ea6:	e94e                	sd	s3,144(sp)
    80005ea8:	ed52                	sd	s4,152(sp)
    80005eaa:	f156                	sd	s5,160(sp)
    80005eac:	f55a                	sd	s6,168(sp)
    80005eae:	f95e                	sd	s7,176(sp)
    80005eb0:	fd62                	sd	s8,184(sp)
    80005eb2:	e1e6                	sd	s9,192(sp)
    80005eb4:	e5ea                	sd	s10,200(sp)
    80005eb6:	e9ee                	sd	s11,208(sp)
    80005eb8:	edf2                	sd	t3,216(sp)
    80005eba:	f1f6                	sd	t4,224(sp)
    80005ebc:	f5fa                	sd	t5,232(sp)
    80005ebe:	f9fe                	sd	t6,240(sp)
    80005ec0:	c3bfc0ef          	jal	80002afa <kerneltrap>
    80005ec4:	6082                	ld	ra,0(sp)
    80005ec6:	6122                	ld	sp,8(sp)
    80005ec8:	61c2                	ld	gp,16(sp)
    80005eca:	7282                	ld	t0,32(sp)
    80005ecc:	7322                	ld	t1,40(sp)
    80005ece:	73c2                	ld	t2,48(sp)
    80005ed0:	7462                	ld	s0,56(sp)
    80005ed2:	6486                	ld	s1,64(sp)
    80005ed4:	6526                	ld	a0,72(sp)
    80005ed6:	65c6                	ld	a1,80(sp)
    80005ed8:	6666                	ld	a2,88(sp)
    80005eda:	7686                	ld	a3,96(sp)
    80005edc:	7726                	ld	a4,104(sp)
    80005ede:	77c6                	ld	a5,112(sp)
    80005ee0:	7866                	ld	a6,120(sp)
    80005ee2:	688a                	ld	a7,128(sp)
    80005ee4:	692a                	ld	s2,136(sp)
    80005ee6:	69ca                	ld	s3,144(sp)
    80005ee8:	6a6a                	ld	s4,152(sp)
    80005eea:	7a8a                	ld	s5,160(sp)
    80005eec:	7b2a                	ld	s6,168(sp)
    80005eee:	7bca                	ld	s7,176(sp)
    80005ef0:	7c6a                	ld	s8,184(sp)
    80005ef2:	6c8e                	ld	s9,192(sp)
    80005ef4:	6d2e                	ld	s10,200(sp)
    80005ef6:	6dce                	ld	s11,208(sp)
    80005ef8:	6e6e                	ld	t3,216(sp)
    80005efa:	7e8e                	ld	t4,224(sp)
    80005efc:	7f2e                	ld	t5,232(sp)
    80005efe:	7fce                	ld	t6,240(sp)
    80005f00:	6111                	addi	sp,sp,256
    80005f02:	10200073          	sret
    80005f06:	00000013          	nop
    80005f0a:	00000013          	nop
    80005f0e:	0001                	nop

0000000080005f10 <timervec>:
    80005f10:	34051573          	csrrw	a0,mscratch,a0
    80005f14:	e10c                	sd	a1,0(a0)
    80005f16:	e510                	sd	a2,8(a0)
    80005f18:	e914                	sd	a3,16(a0)
    80005f1a:	6d0c                	ld	a1,24(a0)
    80005f1c:	7110                	ld	a2,32(a0)
    80005f1e:	6194                	ld	a3,0(a1)
    80005f20:	96b2                	add	a3,a3,a2
    80005f22:	e194                	sd	a3,0(a1)
    80005f24:	4589                	li	a1,2
    80005f26:	14459073          	csrw	sip,a1
    80005f2a:	6914                	ld	a3,16(a0)
    80005f2c:	6510                	ld	a2,8(a0)
    80005f2e:	610c                	ld	a1,0(a0)
    80005f30:	34051573          	csrrw	a0,mscratch,a0
    80005f34:	30200073          	mret
    80005f38:	0001                	nop

0000000080005f3a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005f3a:	1141                	addi	sp,sp,-16
    80005f3c:	e406                	sd	ra,8(sp)
    80005f3e:	e022                	sd	s0,0(sp)
    80005f40:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005f42:	0c000737          	lui	a4,0xc000
    80005f46:	4785                	li	a5,1
    80005f48:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005f4a:	c35c                	sw	a5,4(a4)
}
    80005f4c:	60a2                	ld	ra,8(sp)
    80005f4e:	6402                	ld	s0,0(sp)
    80005f50:	0141                	addi	sp,sp,16
    80005f52:	8082                	ret

0000000080005f54 <plicinithart>:

void
plicinithart(void)
{
    80005f54:	1141                	addi	sp,sp,-16
    80005f56:	e406                	sd	ra,8(sp)
    80005f58:	e022                	sd	s0,0(sp)
    80005f5a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005f5c:	ffffc097          	auipc	ra,0xffffc
    80005f60:	af6080e7          	jalr	-1290(ra) # 80001a52 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005f64:	0085171b          	slliw	a4,a0,0x8
    80005f68:	0c0027b7          	lui	a5,0xc002
    80005f6c:	97ba                	add	a5,a5,a4
    80005f6e:	40200713          	li	a4,1026
    80005f72:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005f76:	00d5151b          	slliw	a0,a0,0xd
    80005f7a:	0c2017b7          	lui	a5,0xc201
    80005f7e:	97aa                	add	a5,a5,a0
    80005f80:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005f84:	60a2                	ld	ra,8(sp)
    80005f86:	6402                	ld	s0,0(sp)
    80005f88:	0141                	addi	sp,sp,16
    80005f8a:	8082                	ret

0000000080005f8c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005f8c:	1141                	addi	sp,sp,-16
    80005f8e:	e406                	sd	ra,8(sp)
    80005f90:	e022                	sd	s0,0(sp)
    80005f92:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005f94:	ffffc097          	auipc	ra,0xffffc
    80005f98:	abe080e7          	jalr	-1346(ra) # 80001a52 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005f9c:	00d5151b          	slliw	a0,a0,0xd
    80005fa0:	0c2017b7          	lui	a5,0xc201
    80005fa4:	97aa                	add	a5,a5,a0
  return irq;
}
    80005fa6:	43c8                	lw	a0,4(a5)
    80005fa8:	60a2                	ld	ra,8(sp)
    80005faa:	6402                	ld	s0,0(sp)
    80005fac:	0141                	addi	sp,sp,16
    80005fae:	8082                	ret

0000000080005fb0 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005fb0:	1101                	addi	sp,sp,-32
    80005fb2:	ec06                	sd	ra,24(sp)
    80005fb4:	e822                	sd	s0,16(sp)
    80005fb6:	e426                	sd	s1,8(sp)
    80005fb8:	1000                	addi	s0,sp,32
    80005fba:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005fbc:	ffffc097          	auipc	ra,0xffffc
    80005fc0:	a96080e7          	jalr	-1386(ra) # 80001a52 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005fc4:	00d5179b          	slliw	a5,a0,0xd
    80005fc8:	0c201737          	lui	a4,0xc201
    80005fcc:	97ba                	add	a5,a5,a4
    80005fce:	c3c4                	sw	s1,4(a5)
}
    80005fd0:	60e2                	ld	ra,24(sp)
    80005fd2:	6442                	ld	s0,16(sp)
    80005fd4:	64a2                	ld	s1,8(sp)
    80005fd6:	6105                	addi	sp,sp,32
    80005fd8:	8082                	ret

0000000080005fda <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005fda:	1141                	addi	sp,sp,-16
    80005fdc:	e406                	sd	ra,8(sp)
    80005fde:	e022                	sd	s0,0(sp)
    80005fe0:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005fe2:	479d                	li	a5,7
    80005fe4:	06a7c863          	blt	a5,a0,80006054 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    80005fe8:	0001d717          	auipc	a4,0x1d
    80005fec:	01870713          	addi	a4,a4,24 # 80023000 <disk>
    80005ff0:	972a                	add	a4,a4,a0
    80005ff2:	6789                	lui	a5,0x2
    80005ff4:	97ba                	add	a5,a5,a4
    80005ff6:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005ffa:	e7ad                	bnez	a5,80006064 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005ffc:	00451793          	slli	a5,a0,0x4
    80006000:	0001f717          	auipc	a4,0x1f
    80006004:	00070713          	mv	a4,a4
    80006008:	6314                	ld	a3,0(a4)
    8000600a:	96be                	add	a3,a3,a5
    8000600c:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80006010:	6314                	ld	a3,0(a4)
    80006012:	96be                	add	a3,a3,a5
    80006014:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80006018:	6314                	ld	a3,0(a4)
    8000601a:	96be                	add	a3,a3,a5
    8000601c:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    80006020:	6318                	ld	a4,0(a4)
    80006022:	97ba                	add	a5,a5,a4
    80006024:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80006028:	0001d717          	auipc	a4,0x1d
    8000602c:	fd870713          	addi	a4,a4,-40 # 80023000 <disk>
    80006030:	972a                	add	a4,a4,a0
    80006032:	6789                	lui	a5,0x2
    80006034:	97ba                	add	a5,a5,a4
    80006036:	4705                	li	a4,1
    80006038:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000603c:	0001f517          	auipc	a0,0x1f
    80006040:	fdc50513          	addi	a0,a0,-36 # 80025018 <disk+0x2018>
    80006044:	ffffc097          	auipc	ra,0xffffc
    80006048:	296080e7          	jalr	662(ra) # 800022da <wakeup>
}
    8000604c:	60a2                	ld	ra,8(sp)
    8000604e:	6402                	ld	s0,0(sp)
    80006050:	0141                	addi	sp,sp,16
    80006052:	8082                	ret
    panic("free_desc 1");
    80006054:	00002517          	auipc	a0,0x2
    80006058:	5fc50513          	addi	a0,a0,1532 # 80008650 <etext+0x650>
    8000605c:	ffffa097          	auipc	ra,0xffffa
    80006060:	4fa080e7          	jalr	1274(ra) # 80000556 <panic>
    panic("free_desc 2");
    80006064:	00002517          	auipc	a0,0x2
    80006068:	5fc50513          	addi	a0,a0,1532 # 80008660 <etext+0x660>
    8000606c:	ffffa097          	auipc	ra,0xffffa
    80006070:	4ea080e7          	jalr	1258(ra) # 80000556 <panic>

0000000080006074 <virtio_disk_init>:
{
    80006074:	1141                	addi	sp,sp,-16
    80006076:	e406                	sd	ra,8(sp)
    80006078:	e022                	sd	s0,0(sp)
    8000607a:	0800                	addi	s0,sp,16
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000607c:	00002597          	auipc	a1,0x2
    80006080:	5f458593          	addi	a1,a1,1524 # 80008670 <etext+0x670>
    80006084:	0001f517          	auipc	a0,0x1f
    80006088:	0a450513          	addi	a0,a0,164 # 80025128 <disk+0x2128>
    8000608c:	ffffb097          	auipc	ra,0xffffb
    80006090:	b2e080e7          	jalr	-1234(ra) # 80000bba <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006094:	100017b7          	lui	a5,0x10001
    80006098:	4398                	lw	a4,0(a5)
    8000609a:	2701                	sext.w	a4,a4
    8000609c:	747277b7          	lui	a5,0x74727
    800060a0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800060a4:	0ef71563          	bne	a4,a5,8000618e <virtio_disk_init+0x11a>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800060a8:	100017b7          	lui	a5,0x10001
    800060ac:	43dc                	lw	a5,4(a5)
    800060ae:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800060b0:	4705                	li	a4,1
    800060b2:	0ce79e63          	bne	a5,a4,8000618e <virtio_disk_init+0x11a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800060b6:	100017b7          	lui	a5,0x10001
    800060ba:	479c                	lw	a5,8(a5)
    800060bc:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800060be:	4709                	li	a4,2
    800060c0:	0ce79763          	bne	a5,a4,8000618e <virtio_disk_init+0x11a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800060c4:	100017b7          	lui	a5,0x10001
    800060c8:	47d8                	lw	a4,12(a5)
    800060ca:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800060cc:	554d47b7          	lui	a5,0x554d4
    800060d0:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800060d4:	0af71d63          	bne	a4,a5,8000618e <virtio_disk_init+0x11a>
  *R(VIRTIO_MMIO_STATUS) = status;
    800060d8:	100017b7          	lui	a5,0x10001
    800060dc:	4705                	li	a4,1
    800060de:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800060e0:	470d                	li	a4,3
    800060e2:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800060e4:	10001737          	lui	a4,0x10001
    800060e8:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800060ea:	c7ffe6b7          	lui	a3,0xc7ffe
    800060ee:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fd875f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800060f2:	8f75                	and	a4,a4,a3
    800060f4:	100016b7          	lui	a3,0x10001
    800060f8:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    800060fa:	472d                	li	a4,11
    800060fc:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800060fe:	473d                	li	a4,15
    80006100:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80006102:	6705                	lui	a4,0x1
    80006104:	d698                	sw	a4,40(a3)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80006106:	0206a823          	sw	zero,48(a3) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000610a:	5adc                	lw	a5,52(a3)
    8000610c:	2781                	sext.w	a5,a5
  if(max == 0)
    8000610e:	cbc1                	beqz	a5,8000619e <virtio_disk_init+0x12a>
  if(max < NUM)
    80006110:	471d                	li	a4,7
    80006112:	08f77e63          	bgeu	a4,a5,800061ae <virtio_disk_init+0x13a>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006116:	100017b7          	lui	a5,0x10001
    8000611a:	4721                	li	a4,8
    8000611c:	df98                	sw	a4,56(a5)
  memset(disk.pages, 0, sizeof(disk.pages));
    8000611e:	6609                	lui	a2,0x2
    80006120:	4581                	li	a1,0
    80006122:	0001d517          	auipc	a0,0x1d
    80006126:	ede50513          	addi	a0,a0,-290 # 80023000 <disk>
    8000612a:	ffffb097          	auipc	ra,0xffffb
    8000612e:	c22080e7          	jalr	-990(ra) # 80000d4c <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80006132:	0001d717          	auipc	a4,0x1d
    80006136:	ece70713          	addi	a4,a4,-306 # 80023000 <disk>
    8000613a:	00c75793          	srli	a5,a4,0xc
    8000613e:	2781                	sext.w	a5,a5
    80006140:	100016b7          	lui	a3,0x10001
    80006144:	c2bc                	sw	a5,64(a3)
  disk.desc = (struct virtq_desc *) disk.pages;
    80006146:	0001f797          	auipc	a5,0x1f
    8000614a:	eba78793          	addi	a5,a5,-326 # 80025000 <disk+0x2000>
    8000614e:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80006150:	0001d717          	auipc	a4,0x1d
    80006154:	f3070713          	addi	a4,a4,-208 # 80023080 <disk+0x80>
    80006158:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    8000615a:	0001e717          	auipc	a4,0x1e
    8000615e:	ea670713          	addi	a4,a4,-346 # 80024000 <disk+0x1000>
    80006162:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80006164:	4705                	li	a4,1
    80006166:	00e78c23          	sb	a4,24(a5)
    8000616a:	00e78ca3          	sb	a4,25(a5)
    8000616e:	00e78d23          	sb	a4,26(a5)
    80006172:	00e78da3          	sb	a4,27(a5)
    80006176:	00e78e23          	sb	a4,28(a5)
    8000617a:	00e78ea3          	sb	a4,29(a5)
    8000617e:	00e78f23          	sb	a4,30(a5)
    80006182:	00e78fa3          	sb	a4,31(a5)
}
    80006186:	60a2                	ld	ra,8(sp)
    80006188:	6402                	ld	s0,0(sp)
    8000618a:	0141                	addi	sp,sp,16
    8000618c:	8082                	ret
    panic("could not find virtio disk");
    8000618e:	00002517          	auipc	a0,0x2
    80006192:	4f250513          	addi	a0,a0,1266 # 80008680 <etext+0x680>
    80006196:	ffffa097          	auipc	ra,0xffffa
    8000619a:	3c0080e7          	jalr	960(ra) # 80000556 <panic>
    panic("virtio disk has no queue 0");
    8000619e:	00002517          	auipc	a0,0x2
    800061a2:	50250513          	addi	a0,a0,1282 # 800086a0 <etext+0x6a0>
    800061a6:	ffffa097          	auipc	ra,0xffffa
    800061aa:	3b0080e7          	jalr	944(ra) # 80000556 <panic>
    panic("virtio disk max queue too short");
    800061ae:	00002517          	auipc	a0,0x2
    800061b2:	51250513          	addi	a0,a0,1298 # 800086c0 <etext+0x6c0>
    800061b6:	ffffa097          	auipc	ra,0xffffa
    800061ba:	3a0080e7          	jalr	928(ra) # 80000556 <panic>

00000000800061be <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800061be:	711d                	addi	sp,sp,-96
    800061c0:	ec86                	sd	ra,88(sp)
    800061c2:	e8a2                	sd	s0,80(sp)
    800061c4:	e4a6                	sd	s1,72(sp)
    800061c6:	e0ca                	sd	s2,64(sp)
    800061c8:	fc4e                	sd	s3,56(sp)
    800061ca:	f852                	sd	s4,48(sp)
    800061cc:	f456                	sd	s5,40(sp)
    800061ce:	f05a                	sd	s6,32(sp)
    800061d0:	ec5e                	sd	s7,24(sp)
    800061d2:	e862                	sd	s8,16(sp)
    800061d4:	1080                	addi	s0,sp,96
    800061d6:	89aa                	mv	s3,a0
    800061d8:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800061da:	00c52b83          	lw	s7,12(a0)
    800061de:	001b9b9b          	slliw	s7,s7,0x1
    800061e2:	1b82                	slli	s7,s7,0x20
    800061e4:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    800061e8:	0001f517          	auipc	a0,0x1f
    800061ec:	f4050513          	addi	a0,a0,-192 # 80025128 <disk+0x2128>
    800061f0:	ffffb097          	auipc	ra,0xffffb
    800061f4:	a64080e7          	jalr	-1436(ra) # 80000c54 <acquire>
  for(int i = 0; i < NUM; i++){
    800061f8:	44a1                	li	s1,8
      disk.free[i] = 0;
    800061fa:	0001db17          	auipc	s6,0x1d
    800061fe:	e06b0b13          	addi	s6,s6,-506 # 80023000 <disk>
    80006202:	6a89                	lui	s5,0x2
  for(int i = 0; i < 3; i++){
    80006204:	4a0d                	li	s4,3
    80006206:	a88d                	j	80006278 <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    80006208:	00fb0733          	add	a4,s6,a5
    8000620c:	9756                	add	a4,a4,s5
    8000620e:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80006212:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80006214:	0207c563          	bltz	a5,8000623e <virtio_disk_rw+0x80>
  for(int i = 0; i < 3; i++){
    80006218:	2905                	addiw	s2,s2,1
    8000621a:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    8000621c:	1b490063          	beq	s2,s4,800063bc <virtio_disk_rw+0x1fe>
    idx[i] = alloc_desc();
    80006220:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80006222:	0001f717          	auipc	a4,0x1f
    80006226:	df670713          	addi	a4,a4,-522 # 80025018 <disk+0x2018>
    8000622a:	4781                	li	a5,0
    if(disk.free[i]){
    8000622c:	00074683          	lbu	a3,0(a4)
    80006230:	fee1                	bnez	a3,80006208 <virtio_disk_rw+0x4a>
  for(int i = 0; i < NUM; i++){
    80006232:	2785                	addiw	a5,a5,1
    80006234:	0705                	addi	a4,a4,1
    80006236:	fe979be3          	bne	a5,s1,8000622c <virtio_disk_rw+0x6e>
    idx[i] = alloc_desc();
    8000623a:	57fd                	li	a5,-1
    8000623c:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    8000623e:	03205163          	blez	s2,80006260 <virtio_disk_rw+0xa2>
        free_desc(idx[j]);
    80006242:	fa042503          	lw	a0,-96(s0)
    80006246:	00000097          	auipc	ra,0x0
    8000624a:	d94080e7          	jalr	-620(ra) # 80005fda <free_desc>
      for(int j = 0; j < i; j++)
    8000624e:	4785                	li	a5,1
    80006250:	0127d863          	bge	a5,s2,80006260 <virtio_disk_rw+0xa2>
        free_desc(idx[j]);
    80006254:	fa442503          	lw	a0,-92(s0)
    80006258:	00000097          	auipc	ra,0x0
    8000625c:	d82080e7          	jalr	-638(ra) # 80005fda <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006260:	0001f597          	auipc	a1,0x1f
    80006264:	ec858593          	addi	a1,a1,-312 # 80025128 <disk+0x2128>
    80006268:	0001f517          	auipc	a0,0x1f
    8000626c:	db050513          	addi	a0,a0,-592 # 80025018 <disk+0x2018>
    80006270:	ffffc097          	auipc	ra,0xffffc
    80006274:	ee4080e7          	jalr	-284(ra) # 80002154 <sleep>
  for(int i = 0; i < 3; i++){
    80006278:	fa040613          	addi	a2,s0,-96
    8000627c:	4901                	li	s2,0
    8000627e:	b74d                	j	80006220 <virtio_disk_rw+0x62>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80006280:	0001f717          	auipc	a4,0x1f
    80006284:	d8073703          	ld	a4,-640(a4) # 80025000 <disk+0x2000>
    80006288:	973e                	add	a4,a4,a5
    8000628a:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000628e:	0001d897          	auipc	a7,0x1d
    80006292:	d7288893          	addi	a7,a7,-654 # 80023000 <disk>
    80006296:	0001f717          	auipc	a4,0x1f
    8000629a:	d6a70713          	addi	a4,a4,-662 # 80025000 <disk+0x2000>
    8000629e:	6314                	ld	a3,0(a4)
    800062a0:	96be                	add	a3,a3,a5
    800062a2:	00c6d583          	lhu	a1,12(a3) # 1000100c <_entry-0x6fffeff4>
    800062a6:	0015e593          	ori	a1,a1,1
    800062aa:	00b69623          	sh	a1,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800062ae:	fa842683          	lw	a3,-88(s0)
    800062b2:	630c                	ld	a1,0(a4)
    800062b4:	97ae                	add	a5,a5,a1
    800062b6:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800062ba:	20050593          	addi	a1,a0,512
    800062be:	0592                	slli	a1,a1,0x4
    800062c0:	95c6                	add	a1,a1,a7
    800062c2:	57fd                	li	a5,-1
    800062c4:	02f58823          	sb	a5,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800062c8:	00469793          	slli	a5,a3,0x4
    800062cc:	00073803          	ld	a6,0(a4)
    800062d0:	983e                	add	a6,a6,a5
    800062d2:	6689                	lui	a3,0x2
    800062d4:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    800062d8:	96b2                	add	a3,a3,a2
    800062da:	96c6                	add	a3,a3,a7
    800062dc:	00d83023          	sd	a3,0(a6)
  disk.desc[idx[2]].len = 1;
    800062e0:	6314                	ld	a3,0(a4)
    800062e2:	96be                	add	a3,a3,a5
    800062e4:	4605                	li	a2,1
    800062e6:	c690                	sw	a2,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800062e8:	6314                	ld	a3,0(a4)
    800062ea:	96be                	add	a3,a3,a5
    800062ec:	4809                	li	a6,2
    800062ee:	01069623          	sh	a6,12(a3)
  disk.desc[idx[2]].next = 0;
    800062f2:	6314                	ld	a3,0(a4)
    800062f4:	97b6                	add	a5,a5,a3
    800062f6:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800062fa:	00c9a223          	sw	a2,4(s3)
  disk.info[idx[0]].b = b;
    800062fe:	0335b423          	sd	s3,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80006302:	6714                	ld	a3,8(a4)
    80006304:	0026d783          	lhu	a5,2(a3)
    80006308:	8b9d                	andi	a5,a5,7
    8000630a:	0786                	slli	a5,a5,0x1
    8000630c:	96be                	add	a3,a3,a5
    8000630e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80006312:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80006316:	6718                	ld	a4,8(a4)
    80006318:	00275783          	lhu	a5,2(a4)
    8000631c:	2785                	addiw	a5,a5,1
    8000631e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80006322:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80006326:	100017b7          	lui	a5,0x10001
    8000632a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000632e:	0049a783          	lw	a5,4(s3)
    80006332:	02c79163          	bne	a5,a2,80006354 <virtio_disk_rw+0x196>
    sleep(b, &disk.vdisk_lock);
    80006336:	0001f917          	auipc	s2,0x1f
    8000633a:	df290913          	addi	s2,s2,-526 # 80025128 <disk+0x2128>
  while(b->disk == 1) {
    8000633e:	84be                	mv	s1,a5
    sleep(b, &disk.vdisk_lock);
    80006340:	85ca                	mv	a1,s2
    80006342:	854e                	mv	a0,s3
    80006344:	ffffc097          	auipc	ra,0xffffc
    80006348:	e10080e7          	jalr	-496(ra) # 80002154 <sleep>
  while(b->disk == 1) {
    8000634c:	0049a783          	lw	a5,4(s3)
    80006350:	fe9788e3          	beq	a5,s1,80006340 <virtio_disk_rw+0x182>
  }

  disk.info[idx[0]].b = 0;
    80006354:	fa042903          	lw	s2,-96(s0)
    80006358:	20090713          	addi	a4,s2,512
    8000635c:	0712                	slli	a4,a4,0x4
    8000635e:	0001d797          	auipc	a5,0x1d
    80006362:	ca278793          	addi	a5,a5,-862 # 80023000 <disk>
    80006366:	97ba                	add	a5,a5,a4
    80006368:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    8000636c:	0001f997          	auipc	s3,0x1f
    80006370:	c9498993          	addi	s3,s3,-876 # 80025000 <disk+0x2000>
    80006374:	00491713          	slli	a4,s2,0x4
    80006378:	0009b783          	ld	a5,0(s3)
    8000637c:	97ba                	add	a5,a5,a4
    8000637e:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006382:	854a                	mv	a0,s2
    80006384:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80006388:	00000097          	auipc	ra,0x0
    8000638c:	c52080e7          	jalr	-942(ra) # 80005fda <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80006390:	8885                	andi	s1,s1,1
    80006392:	f0ed                	bnez	s1,80006374 <virtio_disk_rw+0x1b6>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80006394:	0001f517          	auipc	a0,0x1f
    80006398:	d9450513          	addi	a0,a0,-620 # 80025128 <disk+0x2128>
    8000639c:	ffffb097          	auipc	ra,0xffffb
    800063a0:	968080e7          	jalr	-1688(ra) # 80000d04 <release>
}
    800063a4:	60e6                	ld	ra,88(sp)
    800063a6:	6446                	ld	s0,80(sp)
    800063a8:	64a6                	ld	s1,72(sp)
    800063aa:	6906                	ld	s2,64(sp)
    800063ac:	79e2                	ld	s3,56(sp)
    800063ae:	7a42                	ld	s4,48(sp)
    800063b0:	7aa2                	ld	s5,40(sp)
    800063b2:	7b02                	ld	s6,32(sp)
    800063b4:	6be2                	ld	s7,24(sp)
    800063b6:	6c42                	ld	s8,16(sp)
    800063b8:	6125                	addi	sp,sp,96
    800063ba:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800063bc:	fa042503          	lw	a0,-96(s0)
    800063c0:	00451613          	slli	a2,a0,0x4
  if(write)
    800063c4:	0001d597          	auipc	a1,0x1d
    800063c8:	c3c58593          	addi	a1,a1,-964 # 80023000 <disk>
    800063cc:	20050793          	addi	a5,a0,512
    800063d0:	0792                	slli	a5,a5,0x4
    800063d2:	97ae                	add	a5,a5,a1
    800063d4:	01803733          	snez	a4,s8
    800063d8:	0ae7a423          	sw	a4,168(a5)
  buf0->reserved = 0;
    800063dc:	0a07a623          	sw	zero,172(a5)
  buf0->sector = sector;
    800063e0:	0b77b823          	sd	s7,176(a5)
  disk.desc[idx[0]].addr = (uint64) buf0;
    800063e4:	0001f717          	auipc	a4,0x1f
    800063e8:	c1c70713          	addi	a4,a4,-996 # 80025000 <disk+0x2000>
    800063ec:	6314                	ld	a3,0(a4)
    800063ee:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800063f0:	6789                	lui	a5,0x2
    800063f2:	0a878793          	addi	a5,a5,168 # 20a8 <_entry-0x7fffdf58>
    800063f6:	97b2                	add	a5,a5,a2
    800063f8:	97ae                	add	a5,a5,a1
  disk.desc[idx[0]].addr = (uint64) buf0;
    800063fa:	e29c                	sd	a5,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800063fc:	631c                	ld	a5,0(a4)
    800063fe:	97b2                	add	a5,a5,a2
    80006400:	46c1                	li	a3,16
    80006402:	c794                	sw	a3,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006404:	631c                	ld	a5,0(a4)
    80006406:	97b2                	add	a5,a5,a2
    80006408:	4685                	li	a3,1
    8000640a:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[0]].next = idx[1];
    8000640e:	fa442783          	lw	a5,-92(s0)
    80006412:	6314                	ld	a3,0(a4)
    80006414:	96b2                	add	a3,a3,a2
    80006416:	00f69723          	sh	a5,14(a3)
  disk.desc[idx[1]].addr = (uint64) b->data;
    8000641a:	0792                	slli	a5,a5,0x4
    8000641c:	6314                	ld	a3,0(a4)
    8000641e:	96be                	add	a3,a3,a5
    80006420:	05898593          	addi	a1,s3,88
    80006424:	e28c                	sd	a1,0(a3)
  disk.desc[idx[1]].len = BSIZE;
    80006426:	6318                	ld	a4,0(a4)
    80006428:	973e                	add	a4,a4,a5
    8000642a:	40000693          	li	a3,1024
    8000642e:	c714                	sw	a3,8(a4)
  if(write)
    80006430:	e40c18e3          	bnez	s8,80006280 <virtio_disk_rw+0xc2>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80006434:	0001f717          	auipc	a4,0x1f
    80006438:	bcc73703          	ld	a4,-1076(a4) # 80025000 <disk+0x2000>
    8000643c:	973e                	add	a4,a4,a5
    8000643e:	4689                	li	a3,2
    80006440:	00d71623          	sh	a3,12(a4)
    80006444:	b5a9                	j	8000628e <virtio_disk_rw+0xd0>

0000000080006446 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006446:	1101                	addi	sp,sp,-32
    80006448:	ec06                	sd	ra,24(sp)
    8000644a:	e822                	sd	s0,16(sp)
    8000644c:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000644e:	0001f517          	auipc	a0,0x1f
    80006452:	cda50513          	addi	a0,a0,-806 # 80025128 <disk+0x2128>
    80006456:	ffffa097          	auipc	ra,0xffffa
    8000645a:	7fe080e7          	jalr	2046(ra) # 80000c54 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    8000645e:	100017b7          	lui	a5,0x10001
    80006462:	53bc                	lw	a5,96(a5)
    80006464:	8b8d                	andi	a5,a5,3
    80006466:	10001737          	lui	a4,0x10001
    8000646a:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000646c:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80006470:	0001f797          	auipc	a5,0x1f
    80006474:	b9078793          	addi	a5,a5,-1136 # 80025000 <disk+0x2000>
    80006478:	6b94                	ld	a3,16(a5)
    8000647a:	0207d703          	lhu	a4,32(a5)
    8000647e:	0026d783          	lhu	a5,2(a3)
    80006482:	06f70563          	beq	a4,a5,800064ec <virtio_disk_intr+0xa6>
    80006486:	e426                	sd	s1,8(sp)
    80006488:	e04a                	sd	s2,0(sp)
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000648a:	0001d917          	auipc	s2,0x1d
    8000648e:	b7690913          	addi	s2,s2,-1162 # 80023000 <disk>
    80006492:	0001f497          	auipc	s1,0x1f
    80006496:	b6e48493          	addi	s1,s1,-1170 # 80025000 <disk+0x2000>
    __sync_synchronize();
    8000649a:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000649e:	6898                	ld	a4,16(s1)
    800064a0:	0204d783          	lhu	a5,32(s1)
    800064a4:	8b9d                	andi	a5,a5,7
    800064a6:	078e                	slli	a5,a5,0x3
    800064a8:	97ba                	add	a5,a5,a4
    800064aa:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800064ac:	20078713          	addi	a4,a5,512
    800064b0:	0712                	slli	a4,a4,0x4
    800064b2:	974a                	add	a4,a4,s2
    800064b4:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    800064b8:	e731                	bnez	a4,80006504 <virtio_disk_intr+0xbe>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800064ba:	20078793          	addi	a5,a5,512
    800064be:	0792                	slli	a5,a5,0x4
    800064c0:	97ca                	add	a5,a5,s2
    800064c2:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800064c4:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800064c8:	ffffc097          	auipc	ra,0xffffc
    800064cc:	e12080e7          	jalr	-494(ra) # 800022da <wakeup>

    disk.used_idx += 1;
    800064d0:	0204d783          	lhu	a5,32(s1)
    800064d4:	2785                	addiw	a5,a5,1
    800064d6:	17c2                	slli	a5,a5,0x30
    800064d8:	93c1                	srli	a5,a5,0x30
    800064da:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800064de:	6898                	ld	a4,16(s1)
    800064e0:	00275703          	lhu	a4,2(a4)
    800064e4:	faf71be3          	bne	a4,a5,8000649a <virtio_disk_intr+0x54>
    800064e8:	64a2                	ld	s1,8(sp)
    800064ea:	6902                	ld	s2,0(sp)
  }

  release(&disk.vdisk_lock);
    800064ec:	0001f517          	auipc	a0,0x1f
    800064f0:	c3c50513          	addi	a0,a0,-964 # 80025128 <disk+0x2128>
    800064f4:	ffffb097          	auipc	ra,0xffffb
    800064f8:	810080e7          	jalr	-2032(ra) # 80000d04 <release>
}
    800064fc:	60e2                	ld	ra,24(sp)
    800064fe:	6442                	ld	s0,16(sp)
    80006500:	6105                	addi	sp,sp,32
    80006502:	8082                	ret
      panic("virtio_disk_intr status");
    80006504:	00002517          	auipc	a0,0x2
    80006508:	1dc50513          	addi	a0,a0,476 # 800086e0 <etext+0x6e0>
    8000650c:	ffffa097          	auipc	ra,0xffffa
    80006510:	04a080e7          	jalr	74(ra) # 80000556 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
