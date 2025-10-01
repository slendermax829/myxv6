
user/_sh:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getcmd>:
  exit(0);
}

int
getcmd(char *buf, int nbuf)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	e04a                	sd	s2,0(sp)
       a:	1000                	addi	s0,sp,32
       c:	84aa                	mv	s1,a0
       e:	892e                	mv	s2,a1
  fprintf(2, "$ ");
      10:	00001597          	auipc	a1,0x1
      14:	33858593          	addi	a1,a1,824 # 1348 <malloc+0xfc>
      18:	4509                	li	a0,2
      1a:	00001097          	auipc	ra,0x1
      1e:	148080e7          	jalr	328(ra) # 1162 <fprintf>
  memset(buf, 0, nbuf);
      22:	864a                	mv	a2,s2
      24:	4581                	li	a1,0
      26:	8526                	mv	a0,s1
      28:	00001097          	auipc	ra,0x1
      2c:	be0080e7          	jalr	-1056(ra) # c08 <memset>
  gets(buf, nbuf);
      30:	85ca                	mv	a1,s2
      32:	8526                	mv	a0,s1
      34:	00001097          	auipc	ra,0x1
      38:	c22080e7          	jalr	-990(ra) # c56 <gets>
  if(buf[0] == 0) // EOF
      3c:	0004c503          	lbu	a0,0(s1)
      40:	00153513          	seqz	a0,a0
    return -1;
  return 0;
}
      44:	40a0053b          	negw	a0,a0
      48:	60e2                	ld	ra,24(sp)
      4a:	6442                	ld	s0,16(sp)
      4c:	64a2                	ld	s1,8(sp)
      4e:	6902                	ld	s2,0(sp)
      50:	6105                	addi	sp,sp,32
      52:	8082                	ret

0000000000000054 <panic>:
  exit(0);
}

void
panic(char *s)
{
      54:	1141                	addi	sp,sp,-16
      56:	e406                	sd	ra,8(sp)
      58:	e022                	sd	s0,0(sp)
      5a:	0800                	addi	s0,sp,16
      5c:	862a                	mv	a2,a0
  fprintf(2, "%s\n", s);
      5e:	00001597          	auipc	a1,0x1
      62:	2fa58593          	addi	a1,a1,762 # 1358 <malloc+0x10c>
      66:	4509                	li	a0,2
      68:	00001097          	auipc	ra,0x1
      6c:	0fa080e7          	jalr	250(ra) # 1162 <fprintf>
  exit(1);
      70:	4505                	li	a0,1
      72:	00001097          	auipc	ra,0x1
      76:	da8080e7          	jalr	-600(ra) # e1a <exit>

000000000000007a <fork1>:
}

int
fork1(void)
{
      7a:	1141                	addi	sp,sp,-16
      7c:	e406                	sd	ra,8(sp)
      7e:	e022                	sd	s0,0(sp)
      80:	0800                	addi	s0,sp,16
  int pid;

  pid = fork();
      82:	00001097          	auipc	ra,0x1
      86:	d90080e7          	jalr	-624(ra) # e12 <fork>
  if(pid == -1)
      8a:	57fd                	li	a5,-1
      8c:	00f50663          	beq	a0,a5,98 <fork1+0x1e>
    panic("fork");
  return pid;
}
      90:	60a2                	ld	ra,8(sp)
      92:	6402                	ld	s0,0(sp)
      94:	0141                	addi	sp,sp,16
      96:	8082                	ret
    panic("fork");
      98:	00001517          	auipc	a0,0x1
      9c:	2c850513          	addi	a0,a0,712 # 1360 <malloc+0x114>
      a0:	00000097          	auipc	ra,0x0
      a4:	fb4080e7          	jalr	-76(ra) # 54 <panic>

00000000000000a8 <runcmd>:
{
      a8:	7179                	addi	sp,sp,-48
      aa:	f406                	sd	ra,40(sp)
      ac:	f022                	sd	s0,32(sp)
      ae:	1800                	addi	s0,sp,48
  if(cmd == 0)
      b0:	c115                	beqz	a0,d4 <runcmd+0x2c>
      b2:	ec26                	sd	s1,24(sp)
      b4:	84aa                	mv	s1,a0
  switch(cmd->type){
      b6:	4118                	lw	a4,0(a0)
      b8:	4795                	li	a5,5
      ba:	02e7e363          	bltu	a5,a4,e0 <runcmd+0x38>
      be:	00056783          	lwu	a5,0(a0)
      c2:	078a                	slli	a5,a5,0x2
      c4:	00001717          	auipc	a4,0x1
      c8:	39c70713          	addi	a4,a4,924 # 1460 <malloc+0x214>
      cc:	97ba                	add	a5,a5,a4
      ce:	439c                	lw	a5,0(a5)
      d0:	97ba                	add	a5,a5,a4
      d2:	8782                	jr	a5
      d4:	ec26                	sd	s1,24(sp)
    exit(1);
      d6:	4505                	li	a0,1
      d8:	00001097          	auipc	ra,0x1
      dc:	d42080e7          	jalr	-702(ra) # e1a <exit>
    panic("runcmd");
      e0:	00001517          	auipc	a0,0x1
      e4:	28850513          	addi	a0,a0,648 # 1368 <malloc+0x11c>
      e8:	00000097          	auipc	ra,0x0
      ec:	f6c080e7          	jalr	-148(ra) # 54 <panic>
    if(ecmd->argv[0] == 0)
      f0:	6508                	ld	a0,8(a0)
      f2:	c515                	beqz	a0,11e <runcmd+0x76>
    exec(ecmd->argv[0], ecmd->argv);
      f4:	00848593          	addi	a1,s1,8
      f8:	00001097          	auipc	ra,0x1
      fc:	d5a080e7          	jalr	-678(ra) # e52 <exec>
    fprintf(2, "exec %s failed\n", ecmd->argv[0]);
     100:	6490                	ld	a2,8(s1)
     102:	00001597          	auipc	a1,0x1
     106:	26e58593          	addi	a1,a1,622 # 1370 <malloc+0x124>
     10a:	4509                	li	a0,2
     10c:	00001097          	auipc	ra,0x1
     110:	056080e7          	jalr	86(ra) # 1162 <fprintf>
  exit(0);
     114:	4501                	li	a0,0
     116:	00001097          	auipc	ra,0x1
     11a:	d04080e7          	jalr	-764(ra) # e1a <exit>
      exit(1);
     11e:	4505                	li	a0,1
     120:	00001097          	auipc	ra,0x1
     124:	cfa080e7          	jalr	-774(ra) # e1a <exit>
    close(rcmd->fd);
     128:	5148                	lw	a0,36(a0)
     12a:	00001097          	auipc	ra,0x1
     12e:	d18080e7          	jalr	-744(ra) # e42 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     132:	508c                	lw	a1,32(s1)
     134:	6888                	ld	a0,16(s1)
     136:	00001097          	auipc	ra,0x1
     13a:	d24080e7          	jalr	-732(ra) # e5a <open>
     13e:	00054763          	bltz	a0,14c <runcmd+0xa4>
    runcmd(rcmd->cmd);
     142:	6488                	ld	a0,8(s1)
     144:	00000097          	auipc	ra,0x0
     148:	f64080e7          	jalr	-156(ra) # a8 <runcmd>
      fprintf(2, "open %s failed\n", rcmd->file);
     14c:	6890                	ld	a2,16(s1)
     14e:	00001597          	auipc	a1,0x1
     152:	23258593          	addi	a1,a1,562 # 1380 <malloc+0x134>
     156:	4509                	li	a0,2
     158:	00001097          	auipc	ra,0x1
     15c:	00a080e7          	jalr	10(ra) # 1162 <fprintf>
      exit(1);
     160:	4505                	li	a0,1
     162:	00001097          	auipc	ra,0x1
     166:	cb8080e7          	jalr	-840(ra) # e1a <exit>
    if(fork1() == 0)
     16a:	00000097          	auipc	ra,0x0
     16e:	f10080e7          	jalr	-240(ra) # 7a <fork1>
     172:	e511                	bnez	a0,17e <runcmd+0xd6>
      runcmd(lcmd->left);
     174:	6488                	ld	a0,8(s1)
     176:	00000097          	auipc	ra,0x0
     17a:	f32080e7          	jalr	-206(ra) # a8 <runcmd>
    wait(0);
     17e:	4501                	li	a0,0
     180:	00001097          	auipc	ra,0x1
     184:	ca2080e7          	jalr	-862(ra) # e22 <wait>
    runcmd(lcmd->right);
     188:	6888                	ld	a0,16(s1)
     18a:	00000097          	auipc	ra,0x0
     18e:	f1e080e7          	jalr	-226(ra) # a8 <runcmd>
    if(pipe(p) < 0)
     192:	fd840513          	addi	a0,s0,-40
     196:	00001097          	auipc	ra,0x1
     19a:	c94080e7          	jalr	-876(ra) # e2a <pipe>
     19e:	04054363          	bltz	a0,1e4 <runcmd+0x13c>
    if(fork1() == 0){
     1a2:	00000097          	auipc	ra,0x0
     1a6:	ed8080e7          	jalr	-296(ra) # 7a <fork1>
     1aa:	e529                	bnez	a0,1f4 <runcmd+0x14c>
      close(1);
     1ac:	4505                	li	a0,1
     1ae:	00001097          	auipc	ra,0x1
     1b2:	c94080e7          	jalr	-876(ra) # e42 <close>
      dup(p[1]);
     1b6:	fdc42503          	lw	a0,-36(s0)
     1ba:	00001097          	auipc	ra,0x1
     1be:	cd8080e7          	jalr	-808(ra) # e92 <dup>
      close(p[0]);
     1c2:	fd842503          	lw	a0,-40(s0)
     1c6:	00001097          	auipc	ra,0x1
     1ca:	c7c080e7          	jalr	-900(ra) # e42 <close>
      close(p[1]);
     1ce:	fdc42503          	lw	a0,-36(s0)
     1d2:	00001097          	auipc	ra,0x1
     1d6:	c70080e7          	jalr	-912(ra) # e42 <close>
      runcmd(pcmd->left);
     1da:	6488                	ld	a0,8(s1)
     1dc:	00000097          	auipc	ra,0x0
     1e0:	ecc080e7          	jalr	-308(ra) # a8 <runcmd>
      panic("pipe");
     1e4:	00001517          	auipc	a0,0x1
     1e8:	1ac50513          	addi	a0,a0,428 # 1390 <malloc+0x144>
     1ec:	00000097          	auipc	ra,0x0
     1f0:	e68080e7          	jalr	-408(ra) # 54 <panic>
    if(fork1() == 0){
     1f4:	00000097          	auipc	ra,0x0
     1f8:	e86080e7          	jalr	-378(ra) # 7a <fork1>
     1fc:	ed05                	bnez	a0,234 <runcmd+0x18c>
      close(0);
     1fe:	00001097          	auipc	ra,0x1
     202:	c44080e7          	jalr	-956(ra) # e42 <close>
      dup(p[0]);
     206:	fd842503          	lw	a0,-40(s0)
     20a:	00001097          	auipc	ra,0x1
     20e:	c88080e7          	jalr	-888(ra) # e92 <dup>
      close(p[0]);
     212:	fd842503          	lw	a0,-40(s0)
     216:	00001097          	auipc	ra,0x1
     21a:	c2c080e7          	jalr	-980(ra) # e42 <close>
      close(p[1]);
     21e:	fdc42503          	lw	a0,-36(s0)
     222:	00001097          	auipc	ra,0x1
     226:	c20080e7          	jalr	-992(ra) # e42 <close>
      runcmd(pcmd->right);
     22a:	6888                	ld	a0,16(s1)
     22c:	00000097          	auipc	ra,0x0
     230:	e7c080e7          	jalr	-388(ra) # a8 <runcmd>
    close(p[0]);
     234:	fd842503          	lw	a0,-40(s0)
     238:	00001097          	auipc	ra,0x1
     23c:	c0a080e7          	jalr	-1014(ra) # e42 <close>
    close(p[1]);
     240:	fdc42503          	lw	a0,-36(s0)
     244:	00001097          	auipc	ra,0x1
     248:	bfe080e7          	jalr	-1026(ra) # e42 <close>
    wait(0);
     24c:	4501                	li	a0,0
     24e:	00001097          	auipc	ra,0x1
     252:	bd4080e7          	jalr	-1068(ra) # e22 <wait>
    wait(0);
     256:	4501                	li	a0,0
     258:	00001097          	auipc	ra,0x1
     25c:	bca080e7          	jalr	-1078(ra) # e22 <wait>
    break;
     260:	bd55                	j	114 <runcmd+0x6c>
    if(fork1() == 0)
     262:	00000097          	auipc	ra,0x0
     266:	e18080e7          	jalr	-488(ra) # 7a <fork1>
     26a:	ea0515e3          	bnez	a0,114 <runcmd+0x6c>
      runcmd(bcmd->cmd);
     26e:	6488                	ld	a0,8(s1)
     270:	00000097          	auipc	ra,0x0
     274:	e38080e7          	jalr	-456(ra) # a8 <runcmd>

0000000000000278 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     278:	1101                	addi	sp,sp,-32
     27a:	ec06                	sd	ra,24(sp)
     27c:	e822                	sd	s0,16(sp)
     27e:	e426                	sd	s1,8(sp)
     280:	1000                	addi	s0,sp,32
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     282:	0a800513          	li	a0,168
     286:	00001097          	auipc	ra,0x1
     28a:	fc6080e7          	jalr	-58(ra) # 124c <malloc>
     28e:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     290:	0a800613          	li	a2,168
     294:	4581                	li	a1,0
     296:	00001097          	auipc	ra,0x1
     29a:	972080e7          	jalr	-1678(ra) # c08 <memset>
  cmd->type = EXEC;
     29e:	4785                	li	a5,1
     2a0:	c09c                	sw	a5,0(s1)
  return (struct cmd*)cmd;
}
     2a2:	8526                	mv	a0,s1
     2a4:	60e2                	ld	ra,24(sp)
     2a6:	6442                	ld	s0,16(sp)
     2a8:	64a2                	ld	s1,8(sp)
     2aa:	6105                	addi	sp,sp,32
     2ac:	8082                	ret

00000000000002ae <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     2ae:	7139                	addi	sp,sp,-64
     2b0:	fc06                	sd	ra,56(sp)
     2b2:	f822                	sd	s0,48(sp)
     2b4:	f426                	sd	s1,40(sp)
     2b6:	f04a                	sd	s2,32(sp)
     2b8:	ec4e                	sd	s3,24(sp)
     2ba:	e852                	sd	s4,16(sp)
     2bc:	e456                	sd	s5,8(sp)
     2be:	e05a                	sd	s6,0(sp)
     2c0:	0080                	addi	s0,sp,64
     2c2:	892a                	mv	s2,a0
     2c4:	89ae                	mv	s3,a1
     2c6:	8a32                	mv	s4,a2
     2c8:	8ab6                	mv	s5,a3
     2ca:	8b3a                	mv	s6,a4
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2cc:	02800513          	li	a0,40
     2d0:	00001097          	auipc	ra,0x1
     2d4:	f7c080e7          	jalr	-132(ra) # 124c <malloc>
     2d8:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2da:	02800613          	li	a2,40
     2de:	4581                	li	a1,0
     2e0:	00001097          	auipc	ra,0x1
     2e4:	928080e7          	jalr	-1752(ra) # c08 <memset>
  cmd->type = REDIR;
     2e8:	4789                	li	a5,2
     2ea:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     2ec:	0124b423          	sd	s2,8(s1)
  cmd->file = file;
     2f0:	0134b823          	sd	s3,16(s1)
  cmd->efile = efile;
     2f4:	0144bc23          	sd	s4,24(s1)
  cmd->mode = mode;
     2f8:	0354a023          	sw	s5,32(s1)
  cmd->fd = fd;
     2fc:	0364a223          	sw	s6,36(s1)
  return (struct cmd*)cmd;
}
     300:	8526                	mv	a0,s1
     302:	70e2                	ld	ra,56(sp)
     304:	7442                	ld	s0,48(sp)
     306:	74a2                	ld	s1,40(sp)
     308:	7902                	ld	s2,32(sp)
     30a:	69e2                	ld	s3,24(sp)
     30c:	6a42                	ld	s4,16(sp)
     30e:	6aa2                	ld	s5,8(sp)
     310:	6b02                	ld	s6,0(sp)
     312:	6121                	addi	sp,sp,64
     314:	8082                	ret

0000000000000316 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     316:	7179                	addi	sp,sp,-48
     318:	f406                	sd	ra,40(sp)
     31a:	f022                	sd	s0,32(sp)
     31c:	ec26                	sd	s1,24(sp)
     31e:	e84a                	sd	s2,16(sp)
     320:	e44e                	sd	s3,8(sp)
     322:	1800                	addi	s0,sp,48
     324:	892a                	mv	s2,a0
     326:	89ae                	mv	s3,a1
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     328:	4561                	li	a0,24
     32a:	00001097          	auipc	ra,0x1
     32e:	f22080e7          	jalr	-222(ra) # 124c <malloc>
     332:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     334:	4661                	li	a2,24
     336:	4581                	li	a1,0
     338:	00001097          	auipc	ra,0x1
     33c:	8d0080e7          	jalr	-1840(ra) # c08 <memset>
  cmd->type = PIPE;
     340:	478d                	li	a5,3
     342:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     344:	0124b423          	sd	s2,8(s1)
  cmd->right = right;
     348:	0134b823          	sd	s3,16(s1)
  return (struct cmd*)cmd;
}
     34c:	8526                	mv	a0,s1
     34e:	70a2                	ld	ra,40(sp)
     350:	7402                	ld	s0,32(sp)
     352:	64e2                	ld	s1,24(sp)
     354:	6942                	ld	s2,16(sp)
     356:	69a2                	ld	s3,8(sp)
     358:	6145                	addi	sp,sp,48
     35a:	8082                	ret

000000000000035c <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     35c:	7179                	addi	sp,sp,-48
     35e:	f406                	sd	ra,40(sp)
     360:	f022                	sd	s0,32(sp)
     362:	ec26                	sd	s1,24(sp)
     364:	e84a                	sd	s2,16(sp)
     366:	e44e                	sd	s3,8(sp)
     368:	1800                	addi	s0,sp,48
     36a:	892a                	mv	s2,a0
     36c:	89ae                	mv	s3,a1
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     36e:	4561                	li	a0,24
     370:	00001097          	auipc	ra,0x1
     374:	edc080e7          	jalr	-292(ra) # 124c <malloc>
     378:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     37a:	4661                	li	a2,24
     37c:	4581                	li	a1,0
     37e:	00001097          	auipc	ra,0x1
     382:	88a080e7          	jalr	-1910(ra) # c08 <memset>
  cmd->type = LIST;
     386:	4791                	li	a5,4
     388:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     38a:	0124b423          	sd	s2,8(s1)
  cmd->right = right;
     38e:	0134b823          	sd	s3,16(s1)
  return (struct cmd*)cmd;
}
     392:	8526                	mv	a0,s1
     394:	70a2                	ld	ra,40(sp)
     396:	7402                	ld	s0,32(sp)
     398:	64e2                	ld	s1,24(sp)
     39a:	6942                	ld	s2,16(sp)
     39c:	69a2                	ld	s3,8(sp)
     39e:	6145                	addi	sp,sp,48
     3a0:	8082                	ret

00000000000003a2 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     3a2:	1101                	addi	sp,sp,-32
     3a4:	ec06                	sd	ra,24(sp)
     3a6:	e822                	sd	s0,16(sp)
     3a8:	e426                	sd	s1,8(sp)
     3aa:	e04a                	sd	s2,0(sp)
     3ac:	1000                	addi	s0,sp,32
     3ae:	892a                	mv	s2,a0
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3b0:	4541                	li	a0,16
     3b2:	00001097          	auipc	ra,0x1
     3b6:	e9a080e7          	jalr	-358(ra) # 124c <malloc>
     3ba:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     3bc:	4641                	li	a2,16
     3be:	4581                	li	a1,0
     3c0:	00001097          	auipc	ra,0x1
     3c4:	848080e7          	jalr	-1976(ra) # c08 <memset>
  cmd->type = BACK;
     3c8:	4795                	li	a5,5
     3ca:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     3cc:	0124b423          	sd	s2,8(s1)
  return (struct cmd*)cmd;
}
     3d0:	8526                	mv	a0,s1
     3d2:	60e2                	ld	ra,24(sp)
     3d4:	6442                	ld	s0,16(sp)
     3d6:	64a2                	ld	s1,8(sp)
     3d8:	6902                	ld	s2,0(sp)
     3da:	6105                	addi	sp,sp,32
     3dc:	8082                	ret

00000000000003de <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     3de:	7139                	addi	sp,sp,-64
     3e0:	fc06                	sd	ra,56(sp)
     3e2:	f822                	sd	s0,48(sp)
     3e4:	f426                	sd	s1,40(sp)
     3e6:	f04a                	sd	s2,32(sp)
     3e8:	ec4e                	sd	s3,24(sp)
     3ea:	e852                	sd	s4,16(sp)
     3ec:	e456                	sd	s5,8(sp)
     3ee:	e05a                	sd	s6,0(sp)
     3f0:	0080                	addi	s0,sp,64
     3f2:	8a2a                	mv	s4,a0
     3f4:	892e                	mv	s2,a1
     3f6:	8ab2                	mv	s5,a2
     3f8:	8b36                	mv	s6,a3
  char *s;
  int ret;

  s = *ps;
     3fa:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     3fc:	00001997          	auipc	s3,0x1
     400:	10c98993          	addi	s3,s3,268 # 1508 <whitespace>
     404:	00b4fe63          	bgeu	s1,a1,420 <gettoken+0x42>
     408:	0004c583          	lbu	a1,0(s1)
     40c:	854e                	mv	a0,s3
     40e:	00001097          	auipc	ra,0x1
     412:	820080e7          	jalr	-2016(ra) # c2e <strchr>
     416:	c509                	beqz	a0,420 <gettoken+0x42>
    s++;
     418:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     41a:	fe9917e3          	bne	s2,s1,408 <gettoken+0x2a>
     41e:	84ca                	mv	s1,s2
  if(q)
     420:	000a8463          	beqz	s5,428 <gettoken+0x4a>
    *q = s;
     424:	009ab023          	sd	s1,0(s5)
  ret = *s;
     428:	0004c783          	lbu	a5,0(s1)
     42c:	00078a9b          	sext.w	s5,a5
  switch(*s){
     430:	03c00713          	li	a4,60
     434:	06f76663          	bltu	a4,a5,4a0 <gettoken+0xc2>
     438:	03a00713          	li	a4,58
     43c:	00f76e63          	bltu	a4,a5,458 <gettoken+0x7a>
     440:	cf89                	beqz	a5,45a <gettoken+0x7c>
     442:	02600713          	li	a4,38
     446:	00e78963          	beq	a5,a4,458 <gettoken+0x7a>
     44a:	fd87879b          	addiw	a5,a5,-40
     44e:	0ff7f793          	zext.b	a5,a5
     452:	4705                	li	a4,1
     454:	06f76763          	bltu	a4,a5,4c2 <gettoken+0xe4>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     458:	0485                	addi	s1,s1,1
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     45a:	000b0463          	beqz	s6,462 <gettoken+0x84>
    *eq = s;
     45e:	009b3023          	sd	s1,0(s6)

  while(s < es && strchr(whitespace, *s))
     462:	00001997          	auipc	s3,0x1
     466:	0a698993          	addi	s3,s3,166 # 1508 <whitespace>
     46a:	0124fe63          	bgeu	s1,s2,486 <gettoken+0xa8>
     46e:	0004c583          	lbu	a1,0(s1)
     472:	854e                	mv	a0,s3
     474:	00000097          	auipc	ra,0x0
     478:	7ba080e7          	jalr	1978(ra) # c2e <strchr>
     47c:	c509                	beqz	a0,486 <gettoken+0xa8>
    s++;
     47e:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     480:	fe9917e3          	bne	s2,s1,46e <gettoken+0x90>
     484:	84ca                	mv	s1,s2
  *ps = s;
     486:	009a3023          	sd	s1,0(s4)
  return ret;
}
     48a:	8556                	mv	a0,s5
     48c:	70e2                	ld	ra,56(sp)
     48e:	7442                	ld	s0,48(sp)
     490:	74a2                	ld	s1,40(sp)
     492:	7902                	ld	s2,32(sp)
     494:	69e2                	ld	s3,24(sp)
     496:	6a42                	ld	s4,16(sp)
     498:	6aa2                	ld	s5,8(sp)
     49a:	6b02                	ld	s6,0(sp)
     49c:	6121                	addi	sp,sp,64
     49e:	8082                	ret
  switch(*s){
     4a0:	03e00713          	li	a4,62
     4a4:	00e79b63          	bne	a5,a4,4ba <gettoken+0xdc>
    if(*s == '>'){
     4a8:	0014c703          	lbu	a4,1(s1)
     4ac:	03e00793          	li	a5,62
     4b0:	04f70c63          	beq	a4,a5,508 <gettoken+0x12a>
    s++;
     4b4:	0485                	addi	s1,s1,1
  ret = *s;
     4b6:	8abe                	mv	s5,a5
     4b8:	b74d                	j	45a <gettoken+0x7c>
  switch(*s){
     4ba:	07c00713          	li	a4,124
     4be:	f8e78de3          	beq	a5,a4,458 <gettoken+0x7a>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     4c2:	00001997          	auipc	s3,0x1
     4c6:	04698993          	addi	s3,s3,70 # 1508 <whitespace>
     4ca:	00001a97          	auipc	s5,0x1
     4ce:	036a8a93          	addi	s5,s5,54 # 1500 <symbols>
     4d2:	0524f563          	bgeu	s1,s2,51c <gettoken+0x13e>
     4d6:	0004c583          	lbu	a1,0(s1)
     4da:	854e                	mv	a0,s3
     4dc:	00000097          	auipc	ra,0x0
     4e0:	752080e7          	jalr	1874(ra) # c2e <strchr>
     4e4:	e90d                	bnez	a0,516 <gettoken+0x138>
     4e6:	0004c583          	lbu	a1,0(s1)
     4ea:	8556                	mv	a0,s5
     4ec:	00000097          	auipc	ra,0x0
     4f0:	742080e7          	jalr	1858(ra) # c2e <strchr>
     4f4:	ed11                	bnez	a0,510 <gettoken+0x132>
      s++;
     4f6:	0485                	addi	s1,s1,1
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     4f8:	fc991fe3          	bne	s2,s1,4d6 <gettoken+0xf8>
  if(eq)
     4fc:	84ca                	mv	s1,s2
    ret = 'a';
     4fe:	06100a93          	li	s5,97
  if(eq)
     502:	f40b1ee3          	bnez	s6,45e <gettoken+0x80>
     506:	b741                	j	486 <gettoken+0xa8>
      s++;
     508:	0489                	addi	s1,s1,2
      ret = '+';
     50a:	02b00a93          	li	s5,43
     50e:	b7b1                	j	45a <gettoken+0x7c>
    ret = 'a';
     510:	06100a93          	li	s5,97
     514:	b799                	j	45a <gettoken+0x7c>
     516:	06100a93          	li	s5,97
     51a:	b781                	j	45a <gettoken+0x7c>
     51c:	06100a93          	li	s5,97
  if(eq)
     520:	f20b1fe3          	bnez	s6,45e <gettoken+0x80>
     524:	b78d                	j	486 <gettoken+0xa8>

0000000000000526 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     526:	7139                	addi	sp,sp,-64
     528:	fc06                	sd	ra,56(sp)
     52a:	f822                	sd	s0,48(sp)
     52c:	f426                	sd	s1,40(sp)
     52e:	f04a                	sd	s2,32(sp)
     530:	ec4e                	sd	s3,24(sp)
     532:	e852                	sd	s4,16(sp)
     534:	e456                	sd	s5,8(sp)
     536:	0080                	addi	s0,sp,64
     538:	8a2a                	mv	s4,a0
     53a:	892e                	mv	s2,a1
     53c:	8ab2                	mv	s5,a2
  char *s;

  s = *ps;
     53e:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     540:	00001997          	auipc	s3,0x1
     544:	fc898993          	addi	s3,s3,-56 # 1508 <whitespace>
     548:	00b4fe63          	bgeu	s1,a1,564 <peek+0x3e>
     54c:	0004c583          	lbu	a1,0(s1)
     550:	854e                	mv	a0,s3
     552:	00000097          	auipc	ra,0x0
     556:	6dc080e7          	jalr	1756(ra) # c2e <strchr>
     55a:	c509                	beqz	a0,564 <peek+0x3e>
    s++;
     55c:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     55e:	fe9917e3          	bne	s2,s1,54c <peek+0x26>
     562:	84ca                	mv	s1,s2
  *ps = s;
     564:	009a3023          	sd	s1,0(s4)
  return *s && strchr(toks, *s);
     568:	0004c583          	lbu	a1,0(s1)
     56c:	4501                	li	a0,0
     56e:	e991                	bnez	a1,582 <peek+0x5c>
}
     570:	70e2                	ld	ra,56(sp)
     572:	7442                	ld	s0,48(sp)
     574:	74a2                	ld	s1,40(sp)
     576:	7902                	ld	s2,32(sp)
     578:	69e2                	ld	s3,24(sp)
     57a:	6a42                	ld	s4,16(sp)
     57c:	6aa2                	ld	s5,8(sp)
     57e:	6121                	addi	sp,sp,64
     580:	8082                	ret
  return *s && strchr(toks, *s);
     582:	8556                	mv	a0,s5
     584:	00000097          	auipc	ra,0x0
     588:	6aa080e7          	jalr	1706(ra) # c2e <strchr>
     58c:	00a03533          	snez	a0,a0
     590:	b7c5                	j	570 <peek+0x4a>

0000000000000592 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     592:	7159                	addi	sp,sp,-112
     594:	f486                	sd	ra,104(sp)
     596:	f0a2                	sd	s0,96(sp)
     598:	eca6                	sd	s1,88(sp)
     59a:	e8ca                	sd	s2,80(sp)
     59c:	e4ce                	sd	s3,72(sp)
     59e:	e0d2                	sd	s4,64(sp)
     5a0:	fc56                	sd	s5,56(sp)
     5a2:	f85a                	sd	s6,48(sp)
     5a4:	f45e                	sd	s7,40(sp)
     5a6:	f062                	sd	s8,32(sp)
     5a8:	ec66                	sd	s9,24(sp)
     5aa:	1880                	addi	s0,sp,112
     5ac:	8a2a                	mv	s4,a0
     5ae:	89ae                	mv	s3,a1
     5b0:	8932                	mv	s2,a2
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     5b2:	00001b17          	auipc	s6,0x1
     5b6:	e06b0b13          	addi	s6,s6,-506 # 13b8 <malloc+0x16c>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
     5ba:	f9040c93          	addi	s9,s0,-112
     5be:	f9840c13          	addi	s8,s0,-104
     5c2:	06100b93          	li	s7,97
  while(peek(ps, es, "<>")){
     5c6:	a02d                	j	5f0 <parseredirs+0x5e>
      panic("missing file for redirection");
     5c8:	00001517          	auipc	a0,0x1
     5cc:	dd050513          	addi	a0,a0,-560 # 1398 <malloc+0x14c>
     5d0:	00000097          	auipc	ra,0x0
     5d4:	a84080e7          	jalr	-1404(ra) # 54 <panic>
    switch(tok){
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     5d8:	4701                	li	a4,0
     5da:	4681                	li	a3,0
     5dc:	f9043603          	ld	a2,-112(s0)
     5e0:	f9843583          	ld	a1,-104(s0)
     5e4:	8552                	mv	a0,s4
     5e6:	00000097          	auipc	ra,0x0
     5ea:	cc8080e7          	jalr	-824(ra) # 2ae <redircmd>
     5ee:	8a2a                	mv	s4,a0
    switch(tok){
     5f0:	03c00a93          	li	s5,60
  while(peek(ps, es, "<>")){
     5f4:	865a                	mv	a2,s6
     5f6:	85ca                	mv	a1,s2
     5f8:	854e                	mv	a0,s3
     5fa:	00000097          	auipc	ra,0x0
     5fe:	f2c080e7          	jalr	-212(ra) # 526 <peek>
     602:	c935                	beqz	a0,676 <parseredirs+0xe4>
    tok = gettoken(ps, es, 0, 0);
     604:	4681                	li	a3,0
     606:	4601                	li	a2,0
     608:	85ca                	mv	a1,s2
     60a:	854e                	mv	a0,s3
     60c:	00000097          	auipc	ra,0x0
     610:	dd2080e7          	jalr	-558(ra) # 3de <gettoken>
     614:	84aa                	mv	s1,a0
    if(gettoken(ps, es, &q, &eq) != 'a')
     616:	86e6                	mv	a3,s9
     618:	8662                	mv	a2,s8
     61a:	85ca                	mv	a1,s2
     61c:	854e                	mv	a0,s3
     61e:	00000097          	auipc	ra,0x0
     622:	dc0080e7          	jalr	-576(ra) # 3de <gettoken>
     626:	fb7511e3          	bne	a0,s7,5c8 <parseredirs+0x36>
    switch(tok){
     62a:	fb5487e3          	beq	s1,s5,5d8 <parseredirs+0x46>
     62e:	03e00793          	li	a5,62
     632:	02f48463          	beq	s1,a5,65a <parseredirs+0xc8>
     636:	02b00793          	li	a5,43
     63a:	faf49de3          	bne	s1,a5,5f4 <parseredirs+0x62>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     63e:	4705                	li	a4,1
     640:	20100693          	li	a3,513
     644:	f9043603          	ld	a2,-112(s0)
     648:	f9843583          	ld	a1,-104(s0)
     64c:	8552                	mv	a0,s4
     64e:	00000097          	auipc	ra,0x0
     652:	c60080e7          	jalr	-928(ra) # 2ae <redircmd>
     656:	8a2a                	mv	s4,a0
      break;
     658:	bf61                	j	5f0 <parseredirs+0x5e>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
     65a:	4705                	li	a4,1
     65c:	60100693          	li	a3,1537
     660:	f9043603          	ld	a2,-112(s0)
     664:	f9843583          	ld	a1,-104(s0)
     668:	8552                	mv	a0,s4
     66a:	00000097          	auipc	ra,0x0
     66e:	c44080e7          	jalr	-956(ra) # 2ae <redircmd>
     672:	8a2a                	mv	s4,a0
      break;
     674:	bfb5                	j	5f0 <parseredirs+0x5e>
    }
  }
  return cmd;
}
     676:	8552                	mv	a0,s4
     678:	70a6                	ld	ra,104(sp)
     67a:	7406                	ld	s0,96(sp)
     67c:	64e6                	ld	s1,88(sp)
     67e:	6946                	ld	s2,80(sp)
     680:	69a6                	ld	s3,72(sp)
     682:	6a06                	ld	s4,64(sp)
     684:	7ae2                	ld	s5,56(sp)
     686:	7b42                	ld	s6,48(sp)
     688:	7ba2                	ld	s7,40(sp)
     68a:	7c02                	ld	s8,32(sp)
     68c:	6ce2                	ld	s9,24(sp)
     68e:	6165                	addi	sp,sp,112
     690:	8082                	ret

0000000000000692 <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     692:	7119                	addi	sp,sp,-128
     694:	fc86                	sd	ra,120(sp)
     696:	f8a2                	sd	s0,112(sp)
     698:	f4a6                	sd	s1,104(sp)
     69a:	e8d2                	sd	s4,80(sp)
     69c:	e4d6                	sd	s5,72(sp)
     69e:	0100                	addi	s0,sp,128
     6a0:	8a2a                	mv	s4,a0
     6a2:	8aae                	mv	s5,a1
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     6a4:	00001617          	auipc	a2,0x1
     6a8:	d1c60613          	addi	a2,a2,-740 # 13c0 <malloc+0x174>
     6ac:	00000097          	auipc	ra,0x0
     6b0:	e7a080e7          	jalr	-390(ra) # 526 <peek>
     6b4:	e521                	bnez	a0,6fc <parseexec+0x6a>
     6b6:	f0ca                	sd	s2,96(sp)
     6b8:	ecce                	sd	s3,88(sp)
     6ba:	e0da                	sd	s6,64(sp)
     6bc:	fc5e                	sd	s7,56(sp)
     6be:	f862                	sd	s8,48(sp)
     6c0:	f466                	sd	s9,40(sp)
     6c2:	f06a                	sd	s10,32(sp)
     6c4:	ec6e                	sd	s11,24(sp)
     6c6:	892a                	mv	s2,a0
    return parseblock(ps, es);

  ret = execcmd();
     6c8:	00000097          	auipc	ra,0x0
     6cc:	bb0080e7          	jalr	-1104(ra) # 278 <execcmd>
     6d0:	89aa                	mv	s3,a0
     6d2:	8daa                	mv	s11,a0
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     6d4:	8656                	mv	a2,s5
     6d6:	85d2                	mv	a1,s4
     6d8:	00000097          	auipc	ra,0x0
     6dc:	eba080e7          	jalr	-326(ra) # 592 <parseredirs>
     6e0:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     6e2:	09a1                	addi	s3,s3,8
     6e4:	00001b17          	auipc	s6,0x1
     6e8:	cfcb0b13          	addi	s6,s6,-772 # 13e0 <malloc+0x194>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     6ec:	f8040c13          	addi	s8,s0,-128
     6f0:	f8840b93          	addi	s7,s0,-120
      break;
    if(tok != 'a')
     6f4:	06100d13          	li	s10,97
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
     6f8:	4ca9                	li	s9,10
  while(!peek(ps, es, "|)&;")){
     6fa:	a089                	j	73c <parseexec+0xaa>
    return parseblock(ps, es);
     6fc:	85d6                	mv	a1,s5
     6fe:	8552                	mv	a0,s4
     700:	00000097          	auipc	ra,0x0
     704:	1c4080e7          	jalr	452(ra) # 8c4 <parseblock>
     708:	84aa                	mv	s1,a0
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     70a:	8526                	mv	a0,s1
     70c:	70e6                	ld	ra,120(sp)
     70e:	7446                	ld	s0,112(sp)
     710:	74a6                	ld	s1,104(sp)
     712:	6a46                	ld	s4,80(sp)
     714:	6aa6                	ld	s5,72(sp)
     716:	6109                	addi	sp,sp,128
     718:	8082                	ret
      panic("syntax");
     71a:	00001517          	auipc	a0,0x1
     71e:	cae50513          	addi	a0,a0,-850 # 13c8 <malloc+0x17c>
     722:	00000097          	auipc	ra,0x0
     726:	932080e7          	jalr	-1742(ra) # 54 <panic>
    if(argc >= MAXARGS)
     72a:	09a1                	addi	s3,s3,8
    ret = parseredirs(ret, ps, es);
     72c:	8656                	mv	a2,s5
     72e:	85d2                	mv	a1,s4
     730:	8526                	mv	a0,s1
     732:	00000097          	auipc	ra,0x0
     736:	e60080e7          	jalr	-416(ra) # 592 <parseredirs>
     73a:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     73c:	865a                	mv	a2,s6
     73e:	85d6                	mv	a1,s5
     740:	8552                	mv	a0,s4
     742:	00000097          	auipc	ra,0x0
     746:	de4080e7          	jalr	-540(ra) # 526 <peek>
     74a:	ed1d                	bnez	a0,788 <parseexec+0xf6>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     74c:	86e2                	mv	a3,s8
     74e:	865e                	mv	a2,s7
     750:	85d6                	mv	a1,s5
     752:	8552                	mv	a0,s4
     754:	00000097          	auipc	ra,0x0
     758:	c8a080e7          	jalr	-886(ra) # 3de <gettoken>
     75c:	c515                	beqz	a0,788 <parseexec+0xf6>
    if(tok != 'a')
     75e:	fba51ee3          	bne	a0,s10,71a <parseexec+0x88>
    cmd->argv[argc] = q;
     762:	f8843783          	ld	a5,-120(s0)
     766:	00f9b023          	sd	a5,0(s3)
    cmd->eargv[argc] = eq;
     76a:	f8043783          	ld	a5,-128(s0)
     76e:	04f9b823          	sd	a5,80(s3)
    argc++;
     772:	2905                	addiw	s2,s2,1
    if(argc >= MAXARGS)
     774:	fb991be3          	bne	s2,s9,72a <parseexec+0x98>
      panic("too many args");
     778:	00001517          	auipc	a0,0x1
     77c:	c5850513          	addi	a0,a0,-936 # 13d0 <malloc+0x184>
     780:	00000097          	auipc	ra,0x0
     784:	8d4080e7          	jalr	-1836(ra) # 54 <panic>
  cmd->argv[argc] = 0;
     788:	090e                	slli	s2,s2,0x3
     78a:	012d87b3          	add	a5,s11,s2
     78e:	0007b423          	sd	zero,8(a5)
  cmd->eargv[argc] = 0;
     792:	0407bc23          	sd	zero,88(a5)
     796:	7906                	ld	s2,96(sp)
     798:	69e6                	ld	s3,88(sp)
     79a:	6b06                	ld	s6,64(sp)
     79c:	7be2                	ld	s7,56(sp)
     79e:	7c42                	ld	s8,48(sp)
     7a0:	7ca2                	ld	s9,40(sp)
     7a2:	7d02                	ld	s10,32(sp)
     7a4:	6de2                	ld	s11,24(sp)
  return ret;
     7a6:	b795                	j	70a <parseexec+0x78>

00000000000007a8 <parsepipe>:
{
     7a8:	7179                	addi	sp,sp,-48
     7aa:	f406                	sd	ra,40(sp)
     7ac:	f022                	sd	s0,32(sp)
     7ae:	ec26                	sd	s1,24(sp)
     7b0:	e84a                	sd	s2,16(sp)
     7b2:	e44e                	sd	s3,8(sp)
     7b4:	e052                	sd	s4,0(sp)
     7b6:	1800                	addi	s0,sp,48
     7b8:	892a                	mv	s2,a0
     7ba:	8a2a                	mv	s4,a0
     7bc:	84ae                	mv	s1,a1
  cmd = parseexec(ps, es);
     7be:	00000097          	auipc	ra,0x0
     7c2:	ed4080e7          	jalr	-300(ra) # 692 <parseexec>
     7c6:	89aa                	mv	s3,a0
  if(peek(ps, es, "|")){
     7c8:	00001617          	auipc	a2,0x1
     7cc:	c2060613          	addi	a2,a2,-992 # 13e8 <malloc+0x19c>
     7d0:	85a6                	mv	a1,s1
     7d2:	854a                	mv	a0,s2
     7d4:	00000097          	auipc	ra,0x0
     7d8:	d52080e7          	jalr	-686(ra) # 526 <peek>
     7dc:	e911                	bnez	a0,7f0 <parsepipe+0x48>
}
     7de:	854e                	mv	a0,s3
     7e0:	70a2                	ld	ra,40(sp)
     7e2:	7402                	ld	s0,32(sp)
     7e4:	64e2                	ld	s1,24(sp)
     7e6:	6942                	ld	s2,16(sp)
     7e8:	69a2                	ld	s3,8(sp)
     7ea:	6a02                	ld	s4,0(sp)
     7ec:	6145                	addi	sp,sp,48
     7ee:	8082                	ret
    gettoken(ps, es, 0, 0);
     7f0:	4681                	li	a3,0
     7f2:	4601                	li	a2,0
     7f4:	85a6                	mv	a1,s1
     7f6:	8552                	mv	a0,s4
     7f8:	00000097          	auipc	ra,0x0
     7fc:	be6080e7          	jalr	-1050(ra) # 3de <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     800:	85a6                	mv	a1,s1
     802:	8552                	mv	a0,s4
     804:	00000097          	auipc	ra,0x0
     808:	fa4080e7          	jalr	-92(ra) # 7a8 <parsepipe>
     80c:	85aa                	mv	a1,a0
     80e:	854e                	mv	a0,s3
     810:	00000097          	auipc	ra,0x0
     814:	b06080e7          	jalr	-1274(ra) # 316 <pipecmd>
     818:	89aa                	mv	s3,a0
  return cmd;
     81a:	b7d1                	j	7de <parsepipe+0x36>

000000000000081c <parseline>:
{
     81c:	7179                	addi	sp,sp,-48
     81e:	f406                	sd	ra,40(sp)
     820:	f022                	sd	s0,32(sp)
     822:	ec26                	sd	s1,24(sp)
     824:	e84a                	sd	s2,16(sp)
     826:	e44e                	sd	s3,8(sp)
     828:	e052                	sd	s4,0(sp)
     82a:	1800                	addi	s0,sp,48
     82c:	892a                	mv	s2,a0
     82e:	89ae                	mv	s3,a1
  cmd = parsepipe(ps, es);
     830:	00000097          	auipc	ra,0x0
     834:	f78080e7          	jalr	-136(ra) # 7a8 <parsepipe>
     838:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     83a:	00001a17          	auipc	s4,0x1
     83e:	bb6a0a13          	addi	s4,s4,-1098 # 13f0 <malloc+0x1a4>
     842:	a839                	j	860 <parseline+0x44>
    gettoken(ps, es, 0, 0);
     844:	4681                	li	a3,0
     846:	4601                	li	a2,0
     848:	85ce                	mv	a1,s3
     84a:	854a                	mv	a0,s2
     84c:	00000097          	auipc	ra,0x0
     850:	b92080e7          	jalr	-1134(ra) # 3de <gettoken>
    cmd = backcmd(cmd);
     854:	8526                	mv	a0,s1
     856:	00000097          	auipc	ra,0x0
     85a:	b4c080e7          	jalr	-1204(ra) # 3a2 <backcmd>
     85e:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     860:	8652                	mv	a2,s4
     862:	85ce                	mv	a1,s3
     864:	854a                	mv	a0,s2
     866:	00000097          	auipc	ra,0x0
     86a:	cc0080e7          	jalr	-832(ra) # 526 <peek>
     86e:	f979                	bnez	a0,844 <parseline+0x28>
  if(peek(ps, es, ";")){
     870:	00001617          	auipc	a2,0x1
     874:	b8860613          	addi	a2,a2,-1144 # 13f8 <malloc+0x1ac>
     878:	85ce                	mv	a1,s3
     87a:	854a                	mv	a0,s2
     87c:	00000097          	auipc	ra,0x0
     880:	caa080e7          	jalr	-854(ra) # 526 <peek>
     884:	e911                	bnez	a0,898 <parseline+0x7c>
}
     886:	8526                	mv	a0,s1
     888:	70a2                	ld	ra,40(sp)
     88a:	7402                	ld	s0,32(sp)
     88c:	64e2                	ld	s1,24(sp)
     88e:	6942                	ld	s2,16(sp)
     890:	69a2                	ld	s3,8(sp)
     892:	6a02                	ld	s4,0(sp)
     894:	6145                	addi	sp,sp,48
     896:	8082                	ret
    gettoken(ps, es, 0, 0);
     898:	4681                	li	a3,0
     89a:	4601                	li	a2,0
     89c:	85ce                	mv	a1,s3
     89e:	854a                	mv	a0,s2
     8a0:	00000097          	auipc	ra,0x0
     8a4:	b3e080e7          	jalr	-1218(ra) # 3de <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     8a8:	85ce                	mv	a1,s3
     8aa:	854a                	mv	a0,s2
     8ac:	00000097          	auipc	ra,0x0
     8b0:	f70080e7          	jalr	-144(ra) # 81c <parseline>
     8b4:	85aa                	mv	a1,a0
     8b6:	8526                	mv	a0,s1
     8b8:	00000097          	auipc	ra,0x0
     8bc:	aa4080e7          	jalr	-1372(ra) # 35c <listcmd>
     8c0:	84aa                	mv	s1,a0
  return cmd;
     8c2:	b7d1                	j	886 <parseline+0x6a>

00000000000008c4 <parseblock>:
{
     8c4:	7179                	addi	sp,sp,-48
     8c6:	f406                	sd	ra,40(sp)
     8c8:	f022                	sd	s0,32(sp)
     8ca:	ec26                	sd	s1,24(sp)
     8cc:	e84a                	sd	s2,16(sp)
     8ce:	e44e                	sd	s3,8(sp)
     8d0:	1800                	addi	s0,sp,48
     8d2:	84aa                	mv	s1,a0
     8d4:	892e                	mv	s2,a1
  if(!peek(ps, es, "("))
     8d6:	00001617          	auipc	a2,0x1
     8da:	aea60613          	addi	a2,a2,-1302 # 13c0 <malloc+0x174>
     8de:	00000097          	auipc	ra,0x0
     8e2:	c48080e7          	jalr	-952(ra) # 526 <peek>
     8e6:	c12d                	beqz	a0,948 <parseblock+0x84>
  gettoken(ps, es, 0, 0);
     8e8:	4681                	li	a3,0
     8ea:	4601                	li	a2,0
     8ec:	85ca                	mv	a1,s2
     8ee:	8526                	mv	a0,s1
     8f0:	00000097          	auipc	ra,0x0
     8f4:	aee080e7          	jalr	-1298(ra) # 3de <gettoken>
  cmd = parseline(ps, es);
     8f8:	85ca                	mv	a1,s2
     8fa:	8526                	mv	a0,s1
     8fc:	00000097          	auipc	ra,0x0
     900:	f20080e7          	jalr	-224(ra) # 81c <parseline>
     904:	89aa                	mv	s3,a0
  if(!peek(ps, es, ")"))
     906:	00001617          	auipc	a2,0x1
     90a:	b0a60613          	addi	a2,a2,-1270 # 1410 <malloc+0x1c4>
     90e:	85ca                	mv	a1,s2
     910:	8526                	mv	a0,s1
     912:	00000097          	auipc	ra,0x0
     916:	c14080e7          	jalr	-1004(ra) # 526 <peek>
     91a:	cd1d                	beqz	a0,958 <parseblock+0x94>
  gettoken(ps, es, 0, 0);
     91c:	4681                	li	a3,0
     91e:	4601                	li	a2,0
     920:	85ca                	mv	a1,s2
     922:	8526                	mv	a0,s1
     924:	00000097          	auipc	ra,0x0
     928:	aba080e7          	jalr	-1350(ra) # 3de <gettoken>
  cmd = parseredirs(cmd, ps, es);
     92c:	864a                	mv	a2,s2
     92e:	85a6                	mv	a1,s1
     930:	854e                	mv	a0,s3
     932:	00000097          	auipc	ra,0x0
     936:	c60080e7          	jalr	-928(ra) # 592 <parseredirs>
}
     93a:	70a2                	ld	ra,40(sp)
     93c:	7402                	ld	s0,32(sp)
     93e:	64e2                	ld	s1,24(sp)
     940:	6942                	ld	s2,16(sp)
     942:	69a2                	ld	s3,8(sp)
     944:	6145                	addi	sp,sp,48
     946:	8082                	ret
    panic("parseblock");
     948:	00001517          	auipc	a0,0x1
     94c:	ab850513          	addi	a0,a0,-1352 # 1400 <malloc+0x1b4>
     950:	fffff097          	auipc	ra,0xfffff
     954:	704080e7          	jalr	1796(ra) # 54 <panic>
    panic("syntax - missing )");
     958:	00001517          	auipc	a0,0x1
     95c:	ac050513          	addi	a0,a0,-1344 # 1418 <malloc+0x1cc>
     960:	fffff097          	auipc	ra,0xfffff
     964:	6f4080e7          	jalr	1780(ra) # 54 <panic>

0000000000000968 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     968:	1101                	addi	sp,sp,-32
     96a:	ec06                	sd	ra,24(sp)
     96c:	e822                	sd	s0,16(sp)
     96e:	e426                	sd	s1,8(sp)
     970:	1000                	addi	s0,sp,32
     972:	84aa                	mv	s1,a0
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     974:	c521                	beqz	a0,9bc <nulterminate+0x54>
    return 0;

  switch(cmd->type){
     976:	4118                	lw	a4,0(a0)
     978:	4795                	li	a5,5
     97a:	04e7e163          	bltu	a5,a4,9bc <nulterminate+0x54>
     97e:	00056783          	lwu	a5,0(a0)
     982:	078a                	slli	a5,a5,0x2
     984:	00001717          	auipc	a4,0x1
     988:	af470713          	addi	a4,a4,-1292 # 1478 <malloc+0x22c>
     98c:	97ba                	add	a5,a5,a4
     98e:	439c                	lw	a5,0(a5)
     990:	97ba                	add	a5,a5,a4
     992:	8782                	jr	a5
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     994:	651c                	ld	a5,8(a0)
     996:	c39d                	beqz	a5,9bc <nulterminate+0x54>
     998:	01050793          	addi	a5,a0,16
      *ecmd->eargv[i] = 0;
     99c:	67b8                	ld	a4,72(a5)
     99e:	00070023          	sb	zero,0(a4)
    for(i=0; ecmd->argv[i]; i++)
     9a2:	07a1                	addi	a5,a5,8
     9a4:	ff87b703          	ld	a4,-8(a5)
     9a8:	fb75                	bnez	a4,99c <nulterminate+0x34>
     9aa:	a809                	j	9bc <nulterminate+0x54>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
     9ac:	6508                	ld	a0,8(a0)
     9ae:	00000097          	auipc	ra,0x0
     9b2:	fba080e7          	jalr	-70(ra) # 968 <nulterminate>
    *rcmd->efile = 0;
     9b6:	6c9c                	ld	a5,24(s1)
     9b8:	00078023          	sb	zero,0(a5)
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     9bc:	8526                	mv	a0,s1
     9be:	60e2                	ld	ra,24(sp)
     9c0:	6442                	ld	s0,16(sp)
     9c2:	64a2                	ld	s1,8(sp)
     9c4:	6105                	addi	sp,sp,32
     9c6:	8082                	ret
    nulterminate(pcmd->left);
     9c8:	6508                	ld	a0,8(a0)
     9ca:	00000097          	auipc	ra,0x0
     9ce:	f9e080e7          	jalr	-98(ra) # 968 <nulterminate>
    nulterminate(pcmd->right);
     9d2:	6888                	ld	a0,16(s1)
     9d4:	00000097          	auipc	ra,0x0
     9d8:	f94080e7          	jalr	-108(ra) # 968 <nulterminate>
    break;
     9dc:	b7c5                	j	9bc <nulterminate+0x54>
    nulterminate(lcmd->left);
     9de:	6508                	ld	a0,8(a0)
     9e0:	00000097          	auipc	ra,0x0
     9e4:	f88080e7          	jalr	-120(ra) # 968 <nulterminate>
    nulterminate(lcmd->right);
     9e8:	6888                	ld	a0,16(s1)
     9ea:	00000097          	auipc	ra,0x0
     9ee:	f7e080e7          	jalr	-130(ra) # 968 <nulterminate>
    break;
     9f2:	b7e9                	j	9bc <nulterminate+0x54>
    nulterminate(bcmd->cmd);
     9f4:	6508                	ld	a0,8(a0)
     9f6:	00000097          	auipc	ra,0x0
     9fa:	f72080e7          	jalr	-142(ra) # 968 <nulterminate>
    break;
     9fe:	bf7d                	j	9bc <nulterminate+0x54>

0000000000000a00 <parsecmd>:
{
     a00:	7139                	addi	sp,sp,-64
     a02:	fc06                	sd	ra,56(sp)
     a04:	f822                	sd	s0,48(sp)
     a06:	f426                	sd	s1,40(sp)
     a08:	f04a                	sd	s2,32(sp)
     a0a:	ec4e                	sd	s3,24(sp)
     a0c:	0080                	addi	s0,sp,64
     a0e:	fca43423          	sd	a0,-56(s0)
  es = s + strlen(s);
     a12:	84aa                	mv	s1,a0
     a14:	00000097          	auipc	ra,0x0
     a18:	1c8080e7          	jalr	456(ra) # bdc <strlen>
     a1c:	1502                	slli	a0,a0,0x20
     a1e:	9101                	srli	a0,a0,0x20
     a20:	94aa                	add	s1,s1,a0
  cmd = parseline(&s, es);
     a22:	fc840913          	addi	s2,s0,-56
     a26:	85a6                	mv	a1,s1
     a28:	854a                	mv	a0,s2
     a2a:	00000097          	auipc	ra,0x0
     a2e:	df2080e7          	jalr	-526(ra) # 81c <parseline>
     a32:	89aa                	mv	s3,a0
  peek(&s, es, "");
     a34:	00001617          	auipc	a2,0x1
     a38:	91c60613          	addi	a2,a2,-1764 # 1350 <malloc+0x104>
     a3c:	85a6                	mv	a1,s1
     a3e:	854a                	mv	a0,s2
     a40:	00000097          	auipc	ra,0x0
     a44:	ae6080e7          	jalr	-1306(ra) # 526 <peek>
  if(s != es){
     a48:	fc843603          	ld	a2,-56(s0)
     a4c:	00961f63          	bne	a2,s1,a6a <parsecmd+0x6a>
  nulterminate(cmd);
     a50:	854e                	mv	a0,s3
     a52:	00000097          	auipc	ra,0x0
     a56:	f16080e7          	jalr	-234(ra) # 968 <nulterminate>
}
     a5a:	854e                	mv	a0,s3
     a5c:	70e2                	ld	ra,56(sp)
     a5e:	7442                	ld	s0,48(sp)
     a60:	74a2                	ld	s1,40(sp)
     a62:	7902                	ld	s2,32(sp)
     a64:	69e2                	ld	s3,24(sp)
     a66:	6121                	addi	sp,sp,64
     a68:	8082                	ret
    fprintf(2, "leftovers: %s\n", s);
     a6a:	00001597          	auipc	a1,0x1
     a6e:	9c658593          	addi	a1,a1,-1594 # 1430 <malloc+0x1e4>
     a72:	4509                	li	a0,2
     a74:	00000097          	auipc	ra,0x0
     a78:	6ee080e7          	jalr	1774(ra) # 1162 <fprintf>
    panic("syntax");
     a7c:	00001517          	auipc	a0,0x1
     a80:	94c50513          	addi	a0,a0,-1716 # 13c8 <malloc+0x17c>
     a84:	fffff097          	auipc	ra,0xfffff
     a88:	5d0080e7          	jalr	1488(ra) # 54 <panic>

0000000000000a8c <main>:
{
     a8c:	7179                	addi	sp,sp,-48
     a8e:	f406                	sd	ra,40(sp)
     a90:	f022                	sd	s0,32(sp)
     a92:	ec26                	sd	s1,24(sp)
     a94:	e84a                	sd	s2,16(sp)
     a96:	e44e                	sd	s3,8(sp)
     a98:	e052                	sd	s4,0(sp)
     a9a:	1800                	addi	s0,sp,48
  while((fd = open("console", O_RDWR)) >= 0){
     a9c:	4489                	li	s1,2
     a9e:	00001917          	auipc	s2,0x1
     aa2:	9a290913          	addi	s2,s2,-1630 # 1440 <malloc+0x1f4>
     aa6:	85a6                	mv	a1,s1
     aa8:	854a                	mv	a0,s2
     aaa:	00000097          	auipc	ra,0x0
     aae:	3b0080e7          	jalr	944(ra) # e5a <open>
     ab2:	00054863          	bltz	a0,ac2 <main+0x36>
    if(fd >= 3){
     ab6:	fea4d8e3          	bge	s1,a0,aa6 <main+0x1a>
      close(fd);
     aba:	00000097          	auipc	ra,0x0
     abe:	388080e7          	jalr	904(ra) # e42 <close>
  while(getcmd(buf, sizeof(buf)) >= 0){
     ac2:	06400913          	li	s2,100
     ac6:	00001497          	auipc	s1,0x1
     aca:	a5248493          	addi	s1,s1,-1454 # 1518 <buf.0>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     ace:	06300993          	li	s3,99
     ad2:	02000a13          	li	s4,32
     ad6:	a819                	j	aec <main+0x60>
    if(fork1() == 0)
     ad8:	fffff097          	auipc	ra,0xfffff
     adc:	5a2080e7          	jalr	1442(ra) # 7a <fork1>
     ae0:	c549                	beqz	a0,b6a <main+0xde>
    wait(0);
     ae2:	4501                	li	a0,0
     ae4:	00000097          	auipc	ra,0x0
     ae8:	33e080e7          	jalr	830(ra) # e22 <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
     aec:	85ca                	mv	a1,s2
     aee:	8526                	mv	a0,s1
     af0:	fffff097          	auipc	ra,0xfffff
     af4:	510080e7          	jalr	1296(ra) # 0 <getcmd>
     af8:	08054563          	bltz	a0,b82 <main+0xf6>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     afc:	0004c783          	lbu	a5,0(s1)
     b00:	fd379ce3          	bne	a5,s3,ad8 <main+0x4c>
     b04:	0014c783          	lbu	a5,1(s1)
     b08:	fd2798e3          	bne	a5,s2,ad8 <main+0x4c>
     b0c:	0024c783          	lbu	a5,2(s1)
     b10:	fd4794e3          	bne	a5,s4,ad8 <main+0x4c>
      buf[strlen(buf)-1] = 0;  // chop \n
     b14:	00001517          	auipc	a0,0x1
     b18:	a0450513          	addi	a0,a0,-1532 # 1518 <buf.0>
     b1c:	00000097          	auipc	ra,0x0
     b20:	0c0080e7          	jalr	192(ra) # bdc <strlen>
     b24:	fff5079b          	addiw	a5,a0,-1
     b28:	1782                	slli	a5,a5,0x20
     b2a:	9381                	srli	a5,a5,0x20
     b2c:	00001717          	auipc	a4,0x1
     b30:	9ec70713          	addi	a4,a4,-1556 # 1518 <buf.0>
     b34:	97ba                	add	a5,a5,a4
     b36:	00078023          	sb	zero,0(a5)
      if(chdir(buf+3) < 0)
     b3a:	00001517          	auipc	a0,0x1
     b3e:	9e150513          	addi	a0,a0,-1567 # 151b <buf.0+0x3>
     b42:	00000097          	auipc	ra,0x0
     b46:	348080e7          	jalr	840(ra) # e8a <chdir>
     b4a:	fa0551e3          	bgez	a0,aec <main+0x60>
        fprintf(2, "cannot cd %s\n", buf+3);
     b4e:	00001617          	auipc	a2,0x1
     b52:	9cd60613          	addi	a2,a2,-1587 # 151b <buf.0+0x3>
     b56:	00001597          	auipc	a1,0x1
     b5a:	8f258593          	addi	a1,a1,-1806 # 1448 <malloc+0x1fc>
     b5e:	4509                	li	a0,2
     b60:	00000097          	auipc	ra,0x0
     b64:	602080e7          	jalr	1538(ra) # 1162 <fprintf>
     b68:	b751                	j	aec <main+0x60>
      runcmd(parsecmd(buf));
     b6a:	00001517          	auipc	a0,0x1
     b6e:	9ae50513          	addi	a0,a0,-1618 # 1518 <buf.0>
     b72:	00000097          	auipc	ra,0x0
     b76:	e8e080e7          	jalr	-370(ra) # a00 <parsecmd>
     b7a:	fffff097          	auipc	ra,0xfffff
     b7e:	52e080e7          	jalr	1326(ra) # a8 <runcmd>
  exit(0);
     b82:	4501                	li	a0,0
     b84:	00000097          	auipc	ra,0x0
     b88:	296080e7          	jalr	662(ra) # e1a <exit>

0000000000000b8c <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
     b8c:	1141                	addi	sp,sp,-16
     b8e:	e406                	sd	ra,8(sp)
     b90:	e022                	sd	s0,0(sp)
     b92:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     b94:	87aa                	mv	a5,a0
     b96:	0585                	addi	a1,a1,1
     b98:	0785                	addi	a5,a5,1
     b9a:	fff5c703          	lbu	a4,-1(a1)
     b9e:	fee78fa3          	sb	a4,-1(a5)
     ba2:	fb75                	bnez	a4,b96 <strcpy+0xa>
    ;
  return os;
}
     ba4:	60a2                	ld	ra,8(sp)
     ba6:	6402                	ld	s0,0(sp)
     ba8:	0141                	addi	sp,sp,16
     baa:	8082                	ret

0000000000000bac <strcmp>:

int
strcmp(const char *p, const char *q)
{
     bac:	1141                	addi	sp,sp,-16
     bae:	e406                	sd	ra,8(sp)
     bb0:	e022                	sd	s0,0(sp)
     bb2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     bb4:	00054783          	lbu	a5,0(a0)
     bb8:	cb91                	beqz	a5,bcc <strcmp+0x20>
     bba:	0005c703          	lbu	a4,0(a1)
     bbe:	00f71763          	bne	a4,a5,bcc <strcmp+0x20>
    p++, q++;
     bc2:	0505                	addi	a0,a0,1
     bc4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     bc6:	00054783          	lbu	a5,0(a0)
     bca:	fbe5                	bnez	a5,bba <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
     bcc:	0005c503          	lbu	a0,0(a1)
}
     bd0:	40a7853b          	subw	a0,a5,a0
     bd4:	60a2                	ld	ra,8(sp)
     bd6:	6402                	ld	s0,0(sp)
     bd8:	0141                	addi	sp,sp,16
     bda:	8082                	ret

0000000000000bdc <strlen>:

uint
strlen(const char *s)
{
     bdc:	1141                	addi	sp,sp,-16
     bde:	e406                	sd	ra,8(sp)
     be0:	e022                	sd	s0,0(sp)
     be2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     be4:	00054783          	lbu	a5,0(a0)
     be8:	cf91                	beqz	a5,c04 <strlen+0x28>
     bea:	00150793          	addi	a5,a0,1
     bee:	86be                	mv	a3,a5
     bf0:	0785                	addi	a5,a5,1
     bf2:	fff7c703          	lbu	a4,-1(a5)
     bf6:	ff65                	bnez	a4,bee <strlen+0x12>
     bf8:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
     bfc:	60a2                	ld	ra,8(sp)
     bfe:	6402                	ld	s0,0(sp)
     c00:	0141                	addi	sp,sp,16
     c02:	8082                	ret
  for(n = 0; s[n]; n++)
     c04:	4501                	li	a0,0
     c06:	bfdd                	j	bfc <strlen+0x20>

0000000000000c08 <memset>:

void*
memset(void *dst, int c, uint n)
{
     c08:	1141                	addi	sp,sp,-16
     c0a:	e406                	sd	ra,8(sp)
     c0c:	e022                	sd	s0,0(sp)
     c0e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     c10:	ca19                	beqz	a2,c26 <memset+0x1e>
     c12:	87aa                	mv	a5,a0
     c14:	1602                	slli	a2,a2,0x20
     c16:	9201                	srli	a2,a2,0x20
     c18:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     c1c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     c20:	0785                	addi	a5,a5,1
     c22:	fee79de3          	bne	a5,a4,c1c <memset+0x14>
  }
  return dst;
}
     c26:	60a2                	ld	ra,8(sp)
     c28:	6402                	ld	s0,0(sp)
     c2a:	0141                	addi	sp,sp,16
     c2c:	8082                	ret

0000000000000c2e <strchr>:

char*
strchr(const char *s, char c)
{
     c2e:	1141                	addi	sp,sp,-16
     c30:	e406                	sd	ra,8(sp)
     c32:	e022                	sd	s0,0(sp)
     c34:	0800                	addi	s0,sp,16
  for(; *s; s++)
     c36:	00054783          	lbu	a5,0(a0)
     c3a:	cf81                	beqz	a5,c52 <strchr+0x24>
    if(*s == c)
     c3c:	00f58763          	beq	a1,a5,c4a <strchr+0x1c>
  for(; *s; s++)
     c40:	0505                	addi	a0,a0,1
     c42:	00054783          	lbu	a5,0(a0)
     c46:	fbfd                	bnez	a5,c3c <strchr+0xe>
      return (char*)s;
  return 0;
     c48:	4501                	li	a0,0
}
     c4a:	60a2                	ld	ra,8(sp)
     c4c:	6402                	ld	s0,0(sp)
     c4e:	0141                	addi	sp,sp,16
     c50:	8082                	ret
  return 0;
     c52:	4501                	li	a0,0
     c54:	bfdd                	j	c4a <strchr+0x1c>

0000000000000c56 <gets>:

char*
gets(char *buf, int max)
{
     c56:	711d                	addi	sp,sp,-96
     c58:	ec86                	sd	ra,88(sp)
     c5a:	e8a2                	sd	s0,80(sp)
     c5c:	e4a6                	sd	s1,72(sp)
     c5e:	e0ca                	sd	s2,64(sp)
     c60:	fc4e                	sd	s3,56(sp)
     c62:	f852                	sd	s4,48(sp)
     c64:	f456                	sd	s5,40(sp)
     c66:	f05a                	sd	s6,32(sp)
     c68:	ec5e                	sd	s7,24(sp)
     c6a:	e862                	sd	s8,16(sp)
     c6c:	1080                	addi	s0,sp,96
     c6e:	8baa                	mv	s7,a0
     c70:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c72:	892a                	mv	s2,a0
     c74:	4481                	li	s1,0
    cc = read(0, &c, 1);
     c76:	faf40b13          	addi	s6,s0,-81
     c7a:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
     c7c:	8c26                	mv	s8,s1
     c7e:	0014899b          	addiw	s3,s1,1
     c82:	84ce                	mv	s1,s3
     c84:	0349d663          	bge	s3,s4,cb0 <gets+0x5a>
    cc = read(0, &c, 1);
     c88:	8656                	mv	a2,s5
     c8a:	85da                	mv	a1,s6
     c8c:	4501                	li	a0,0
     c8e:	00000097          	auipc	ra,0x0
     c92:	1a4080e7          	jalr	420(ra) # e32 <read>
    if(cc < 1)
     c96:	00a05d63          	blez	a0,cb0 <gets+0x5a>
      break;
    buf[i++] = c;
     c9a:	faf44783          	lbu	a5,-81(s0)
     c9e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     ca2:	0905                	addi	s2,s2,1
     ca4:	ff678713          	addi	a4,a5,-10
     ca8:	c319                	beqz	a4,cae <gets+0x58>
     caa:	17cd                	addi	a5,a5,-13
     cac:	fbe1                	bnez	a5,c7c <gets+0x26>
    buf[i++] = c;
     cae:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
     cb0:	9c5e                	add	s8,s8,s7
     cb2:	000c0023          	sb	zero,0(s8)
  return buf;
}
     cb6:	855e                	mv	a0,s7
     cb8:	60e6                	ld	ra,88(sp)
     cba:	6446                	ld	s0,80(sp)
     cbc:	64a6                	ld	s1,72(sp)
     cbe:	6906                	ld	s2,64(sp)
     cc0:	79e2                	ld	s3,56(sp)
     cc2:	7a42                	ld	s4,48(sp)
     cc4:	7aa2                	ld	s5,40(sp)
     cc6:	7b02                	ld	s6,32(sp)
     cc8:	6be2                	ld	s7,24(sp)
     cca:	6c42                	ld	s8,16(sp)
     ccc:	6125                	addi	sp,sp,96
     cce:	8082                	ret

0000000000000cd0 <stat>:

int
stat(const char *n, struct stat *st)
{
     cd0:	1101                	addi	sp,sp,-32
     cd2:	ec06                	sd	ra,24(sp)
     cd4:	e822                	sd	s0,16(sp)
     cd6:	e04a                	sd	s2,0(sp)
     cd8:	1000                	addi	s0,sp,32
     cda:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     cdc:	4581                	li	a1,0
     cde:	00000097          	auipc	ra,0x0
     ce2:	17c080e7          	jalr	380(ra) # e5a <open>
  if(fd < 0)
     ce6:	02054663          	bltz	a0,d12 <stat+0x42>
     cea:	e426                	sd	s1,8(sp)
     cec:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     cee:	85ca                	mv	a1,s2
     cf0:	00000097          	auipc	ra,0x0
     cf4:	182080e7          	jalr	386(ra) # e72 <fstat>
     cf8:	892a                	mv	s2,a0
  close(fd);
     cfa:	8526                	mv	a0,s1
     cfc:	00000097          	auipc	ra,0x0
     d00:	146080e7          	jalr	326(ra) # e42 <close>
  return r;
     d04:	64a2                	ld	s1,8(sp)
}
     d06:	854a                	mv	a0,s2
     d08:	60e2                	ld	ra,24(sp)
     d0a:	6442                	ld	s0,16(sp)
     d0c:	6902                	ld	s2,0(sp)
     d0e:	6105                	addi	sp,sp,32
     d10:	8082                	ret
    return -1;
     d12:	57fd                	li	a5,-1
     d14:	893e                	mv	s2,a5
     d16:	bfc5                	j	d06 <stat+0x36>

0000000000000d18 <atoi>:

int
atoi(const char *s)
{
     d18:	1141                	addi	sp,sp,-16
     d1a:	e406                	sd	ra,8(sp)
     d1c:	e022                	sd	s0,0(sp)
     d1e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     d20:	00054683          	lbu	a3,0(a0)
     d24:	fd06879b          	addiw	a5,a3,-48
     d28:	0ff7f793          	zext.b	a5,a5
     d2c:	4625                	li	a2,9
     d2e:	02f66963          	bltu	a2,a5,d60 <atoi+0x48>
     d32:	872a                	mv	a4,a0
  n = 0;
     d34:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     d36:	0705                	addi	a4,a4,1
     d38:	0025179b          	slliw	a5,a0,0x2
     d3c:	9fa9                	addw	a5,a5,a0
     d3e:	0017979b          	slliw	a5,a5,0x1
     d42:	9fb5                	addw	a5,a5,a3
     d44:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     d48:	00074683          	lbu	a3,0(a4)
     d4c:	fd06879b          	addiw	a5,a3,-48
     d50:	0ff7f793          	zext.b	a5,a5
     d54:	fef671e3          	bgeu	a2,a5,d36 <atoi+0x1e>
  return n;
}
     d58:	60a2                	ld	ra,8(sp)
     d5a:	6402                	ld	s0,0(sp)
     d5c:	0141                	addi	sp,sp,16
     d5e:	8082                	ret
  n = 0;
     d60:	4501                	li	a0,0
     d62:	bfdd                	j	d58 <atoi+0x40>

0000000000000d64 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     d64:	1141                	addi	sp,sp,-16
     d66:	e406                	sd	ra,8(sp)
     d68:	e022                	sd	s0,0(sp)
     d6a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     d6c:	02b57563          	bgeu	a0,a1,d96 <memmove+0x32>
    while(n-- > 0)
     d70:	00c05f63          	blez	a2,d8e <memmove+0x2a>
     d74:	1602                	slli	a2,a2,0x20
     d76:	9201                	srli	a2,a2,0x20
     d78:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     d7c:	872a                	mv	a4,a0
      *dst++ = *src++;
     d7e:	0585                	addi	a1,a1,1
     d80:	0705                	addi	a4,a4,1
     d82:	fff5c683          	lbu	a3,-1(a1)
     d86:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     d8a:	fee79ae3          	bne	a5,a4,d7e <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     d8e:	60a2                	ld	ra,8(sp)
     d90:	6402                	ld	s0,0(sp)
     d92:	0141                	addi	sp,sp,16
     d94:	8082                	ret
    while(n-- > 0)
     d96:	fec05ce3          	blez	a2,d8e <memmove+0x2a>
    dst += n;
     d9a:	00c50733          	add	a4,a0,a2
    src += n;
     d9e:	95b2                	add	a1,a1,a2
     da0:	fff6079b          	addiw	a5,a2,-1
     da4:	1782                	slli	a5,a5,0x20
     da6:	9381                	srli	a5,a5,0x20
     da8:	fff7c793          	not	a5,a5
     dac:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     dae:	15fd                	addi	a1,a1,-1
     db0:	177d                	addi	a4,a4,-1
     db2:	0005c683          	lbu	a3,0(a1)
     db6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     dba:	fef71ae3          	bne	a4,a5,dae <memmove+0x4a>
     dbe:	bfc1                	j	d8e <memmove+0x2a>

0000000000000dc0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     dc0:	1141                	addi	sp,sp,-16
     dc2:	e406                	sd	ra,8(sp)
     dc4:	e022                	sd	s0,0(sp)
     dc6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     dc8:	c61d                	beqz	a2,df6 <memcmp+0x36>
     dca:	1602                	slli	a2,a2,0x20
     dcc:	9201                	srli	a2,a2,0x20
     dce:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
     dd2:	00054783          	lbu	a5,0(a0)
     dd6:	0005c703          	lbu	a4,0(a1)
     dda:	00e79863          	bne	a5,a4,dea <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
     dde:	0505                	addi	a0,a0,1
    p2++;
     de0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     de2:	fed518e3          	bne	a0,a3,dd2 <memcmp+0x12>
  }
  return 0;
     de6:	4501                	li	a0,0
     de8:	a019                	j	dee <memcmp+0x2e>
      return *p1 - *p2;
     dea:	40e7853b          	subw	a0,a5,a4
}
     dee:	60a2                	ld	ra,8(sp)
     df0:	6402                	ld	s0,0(sp)
     df2:	0141                	addi	sp,sp,16
     df4:	8082                	ret
  return 0;
     df6:	4501                	li	a0,0
     df8:	bfdd                	j	dee <memcmp+0x2e>

0000000000000dfa <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     dfa:	1141                	addi	sp,sp,-16
     dfc:	e406                	sd	ra,8(sp)
     dfe:	e022                	sd	s0,0(sp)
     e00:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     e02:	00000097          	auipc	ra,0x0
     e06:	f62080e7          	jalr	-158(ra) # d64 <memmove>
}
     e0a:	60a2                	ld	ra,8(sp)
     e0c:	6402                	ld	s0,0(sp)
     e0e:	0141                	addi	sp,sp,16
     e10:	8082                	ret

0000000000000e12 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     e12:	4885                	li	a7,1
 ecall
     e14:	00000073          	ecall
 ret
     e18:	8082                	ret

0000000000000e1a <exit>:
.global exit
exit:
 li a7, SYS_exit
     e1a:	4889                	li	a7,2
 ecall
     e1c:	00000073          	ecall
 ret
     e20:	8082                	ret

0000000000000e22 <wait>:
.global wait
wait:
 li a7, SYS_wait
     e22:	488d                	li	a7,3
 ecall
     e24:	00000073          	ecall
 ret
     e28:	8082                	ret

0000000000000e2a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     e2a:	4891                	li	a7,4
 ecall
     e2c:	00000073          	ecall
 ret
     e30:	8082                	ret

0000000000000e32 <read>:
.global read
read:
 li a7, SYS_read
     e32:	4895                	li	a7,5
 ecall
     e34:	00000073          	ecall
 ret
     e38:	8082                	ret

0000000000000e3a <write>:
.global write
write:
 li a7, SYS_write
     e3a:	48c1                	li	a7,16
 ecall
     e3c:	00000073          	ecall
 ret
     e40:	8082                	ret

0000000000000e42 <close>:
.global close
close:
 li a7, SYS_close
     e42:	48d5                	li	a7,21
 ecall
     e44:	00000073          	ecall
 ret
     e48:	8082                	ret

0000000000000e4a <kill>:
.global kill
kill:
 li a7, SYS_kill
     e4a:	4899                	li	a7,6
 ecall
     e4c:	00000073          	ecall
 ret
     e50:	8082                	ret

0000000000000e52 <exec>:
.global exec
exec:
 li a7, SYS_exec
     e52:	489d                	li	a7,7
 ecall
     e54:	00000073          	ecall
 ret
     e58:	8082                	ret

0000000000000e5a <open>:
.global open
open:
 li a7, SYS_open
     e5a:	48bd                	li	a7,15
 ecall
     e5c:	00000073          	ecall
 ret
     e60:	8082                	ret

0000000000000e62 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     e62:	48c5                	li	a7,17
 ecall
     e64:	00000073          	ecall
 ret
     e68:	8082                	ret

0000000000000e6a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     e6a:	48c9                	li	a7,18
 ecall
     e6c:	00000073          	ecall
 ret
     e70:	8082                	ret

0000000000000e72 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     e72:	48a1                	li	a7,8
 ecall
     e74:	00000073          	ecall
 ret
     e78:	8082                	ret

0000000000000e7a <link>:
.global link
link:
 li a7, SYS_link
     e7a:	48cd                	li	a7,19
 ecall
     e7c:	00000073          	ecall
 ret
     e80:	8082                	ret

0000000000000e82 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     e82:	48d1                	li	a7,20
 ecall
     e84:	00000073          	ecall
 ret
     e88:	8082                	ret

0000000000000e8a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     e8a:	48a5                	li	a7,9
 ecall
     e8c:	00000073          	ecall
 ret
     e90:	8082                	ret

0000000000000e92 <dup>:
.global dup
dup:
 li a7, SYS_dup
     e92:	48a9                	li	a7,10
 ecall
     e94:	00000073          	ecall
 ret
     e98:	8082                	ret

0000000000000e9a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     e9a:	48ad                	li	a7,11
 ecall
     e9c:	00000073          	ecall
 ret
     ea0:	8082                	ret

0000000000000ea2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     ea2:	48b1                	li	a7,12
 ecall
     ea4:	00000073          	ecall
 ret
     ea8:	8082                	ret

0000000000000eaa <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     eaa:	48b5                	li	a7,13
 ecall
     eac:	00000073          	ecall
 ret
     eb0:	8082                	ret

0000000000000eb2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     eb2:	48b9                	li	a7,14
 ecall
     eb4:	00000073          	ecall
 ret
     eb8:	8082                	ret

0000000000000eba <cputime>:
.global cputime
cputime:
 li a7, SYS_cputime
     eba:	48d9                	li	a7,22
 ecall
     ebc:	00000073          	ecall
 ret
     ec0:	8082                	ret

0000000000000ec2 <wait2>:
.global wait2
wait2:
 li a7, SYS_wait2
     ec2:	48dd                	li	a7,23
 ecall
     ec4:	00000073          	ecall
 ret
     ec8:	8082                	ret

0000000000000eca <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     eca:	1101                	addi	sp,sp,-32
     ecc:	ec06                	sd	ra,24(sp)
     ece:	e822                	sd	s0,16(sp)
     ed0:	1000                	addi	s0,sp,32
     ed2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     ed6:	4605                	li	a2,1
     ed8:	fef40593          	addi	a1,s0,-17
     edc:	00000097          	auipc	ra,0x0
     ee0:	f5e080e7          	jalr	-162(ra) # e3a <write>
}
     ee4:	60e2                	ld	ra,24(sp)
     ee6:	6442                	ld	s0,16(sp)
     ee8:	6105                	addi	sp,sp,32
     eea:	8082                	ret

0000000000000eec <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     eec:	7139                	addi	sp,sp,-64
     eee:	fc06                	sd	ra,56(sp)
     ef0:	f822                	sd	s0,48(sp)
     ef2:	f04a                	sd	s2,32(sp)
     ef4:	ec4e                	sd	s3,24(sp)
     ef6:	0080                	addi	s0,sp,64
     ef8:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     efa:	cad9                	beqz	a3,f90 <printint+0xa4>
     efc:	01f5d79b          	srliw	a5,a1,0x1f
     f00:	cbc1                	beqz	a5,f90 <printint+0xa4>
    neg = 1;
    x = -xx;
     f02:	40b005bb          	negw	a1,a1
    neg = 1;
     f06:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
     f08:	fc040993          	addi	s3,s0,-64
  neg = 0;
     f0c:	86ce                	mv	a3,s3
  i = 0;
     f0e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     f10:	00000817          	auipc	a6,0x0
     f14:	5d880813          	addi	a6,a6,1496 # 14e8 <digits>
     f18:	88ba                	mv	a7,a4
     f1a:	0017051b          	addiw	a0,a4,1
     f1e:	872a                	mv	a4,a0
     f20:	02c5f7bb          	remuw	a5,a1,a2
     f24:	1782                	slli	a5,a5,0x20
     f26:	9381                	srli	a5,a5,0x20
     f28:	97c2                	add	a5,a5,a6
     f2a:	0007c783          	lbu	a5,0(a5)
     f2e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     f32:	87ae                	mv	a5,a1
     f34:	02c5d5bb          	divuw	a1,a1,a2
     f38:	0685                	addi	a3,a3,1
     f3a:	fcc7ffe3          	bgeu	a5,a2,f18 <printint+0x2c>
  if(neg)
     f3e:	00030c63          	beqz	t1,f56 <printint+0x6a>
    buf[i++] = '-';
     f42:	fd050793          	addi	a5,a0,-48
     f46:	00878533          	add	a0,a5,s0
     f4a:	02d00793          	li	a5,45
     f4e:	fef50823          	sb	a5,-16(a0)
     f52:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
     f56:	02e05763          	blez	a4,f84 <printint+0x98>
     f5a:	f426                	sd	s1,40(sp)
     f5c:	377d                	addiw	a4,a4,-1
     f5e:	00e984b3          	add	s1,s3,a4
     f62:	19fd                	addi	s3,s3,-1
     f64:	99ba                	add	s3,s3,a4
     f66:	1702                	slli	a4,a4,0x20
     f68:	9301                	srli	a4,a4,0x20
     f6a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     f6e:	0004c583          	lbu	a1,0(s1)
     f72:	854a                	mv	a0,s2
     f74:	00000097          	auipc	ra,0x0
     f78:	f56080e7          	jalr	-170(ra) # eca <putc>
  while(--i >= 0)
     f7c:	14fd                	addi	s1,s1,-1
     f7e:	ff3498e3          	bne	s1,s3,f6e <printint+0x82>
     f82:	74a2                	ld	s1,40(sp)
}
     f84:	70e2                	ld	ra,56(sp)
     f86:	7442                	ld	s0,48(sp)
     f88:	7902                	ld	s2,32(sp)
     f8a:	69e2                	ld	s3,24(sp)
     f8c:	6121                	addi	sp,sp,64
     f8e:	8082                	ret
  neg = 0;
     f90:	4301                	li	t1,0
     f92:	bf9d                	j	f08 <printint+0x1c>

0000000000000f94 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     f94:	715d                	addi	sp,sp,-80
     f96:	e486                	sd	ra,72(sp)
     f98:	e0a2                	sd	s0,64(sp)
     f9a:	f84a                	sd	s2,48(sp)
     f9c:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     f9e:	0005c903          	lbu	s2,0(a1)
     fa2:	1a090b63          	beqz	s2,1158 <vprintf+0x1c4>
     fa6:	fc26                	sd	s1,56(sp)
     fa8:	f44e                	sd	s3,40(sp)
     faa:	f052                	sd	s4,32(sp)
     fac:	ec56                	sd	s5,24(sp)
     fae:	e85a                	sd	s6,16(sp)
     fb0:	e45e                	sd	s7,8(sp)
     fb2:	8aaa                	mv	s5,a0
     fb4:	8bb2                	mv	s7,a2
     fb6:	00158493          	addi	s1,a1,1
  state = 0;
     fba:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     fbc:	02500a13          	li	s4,37
     fc0:	4b55                	li	s6,21
     fc2:	a839                	j	fe0 <vprintf+0x4c>
        putc(fd, c);
     fc4:	85ca                	mv	a1,s2
     fc6:	8556                	mv	a0,s5
     fc8:	00000097          	auipc	ra,0x0
     fcc:	f02080e7          	jalr	-254(ra) # eca <putc>
     fd0:	a019                	j	fd6 <vprintf+0x42>
    } else if(state == '%'){
     fd2:	01498d63          	beq	s3,s4,fec <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
     fd6:	0485                	addi	s1,s1,1
     fd8:	fff4c903          	lbu	s2,-1(s1)
     fdc:	16090863          	beqz	s2,114c <vprintf+0x1b8>
    if(state == 0){
     fe0:	fe0999e3          	bnez	s3,fd2 <vprintf+0x3e>
      if(c == '%'){
     fe4:	ff4910e3          	bne	s2,s4,fc4 <vprintf+0x30>
        state = '%';
     fe8:	89d2                	mv	s3,s4
     fea:	b7f5                	j	fd6 <vprintf+0x42>
      if(c == 'd'){
     fec:	13490563          	beq	s2,s4,1116 <vprintf+0x182>
     ff0:	f9d9079b          	addiw	a5,s2,-99
     ff4:	0ff7f793          	zext.b	a5,a5
     ff8:	12fb6863          	bltu	s6,a5,1128 <vprintf+0x194>
     ffc:	f9d9079b          	addiw	a5,s2,-99
    1000:	0ff7f713          	zext.b	a4,a5
    1004:	12eb6263          	bltu	s6,a4,1128 <vprintf+0x194>
    1008:	00271793          	slli	a5,a4,0x2
    100c:	00000717          	auipc	a4,0x0
    1010:	48470713          	addi	a4,a4,1156 # 1490 <malloc+0x244>
    1014:	97ba                	add	a5,a5,a4
    1016:	439c                	lw	a5,0(a5)
    1018:	97ba                	add	a5,a5,a4
    101a:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    101c:	008b8913          	addi	s2,s7,8
    1020:	4685                	li	a3,1
    1022:	4629                	li	a2,10
    1024:	000ba583          	lw	a1,0(s7)
    1028:	8556                	mv	a0,s5
    102a:	00000097          	auipc	ra,0x0
    102e:	ec2080e7          	jalr	-318(ra) # eec <printint>
    1032:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    1034:	4981                	li	s3,0
    1036:	b745                	j	fd6 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1038:	008b8913          	addi	s2,s7,8
    103c:	4681                	li	a3,0
    103e:	4629                	li	a2,10
    1040:	000ba583          	lw	a1,0(s7)
    1044:	8556                	mv	a0,s5
    1046:	00000097          	auipc	ra,0x0
    104a:	ea6080e7          	jalr	-346(ra) # eec <printint>
    104e:	8bca                	mv	s7,s2
      state = 0;
    1050:	4981                	li	s3,0
    1052:	b751                	j	fd6 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
    1054:	008b8913          	addi	s2,s7,8
    1058:	4681                	li	a3,0
    105a:	4641                	li	a2,16
    105c:	000ba583          	lw	a1,0(s7)
    1060:	8556                	mv	a0,s5
    1062:	00000097          	auipc	ra,0x0
    1066:	e8a080e7          	jalr	-374(ra) # eec <printint>
    106a:	8bca                	mv	s7,s2
      state = 0;
    106c:	4981                	li	s3,0
    106e:	b7a5                	j	fd6 <vprintf+0x42>
    1070:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
    1072:	008b8793          	addi	a5,s7,8
    1076:	8c3e                	mv	s8,a5
    1078:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    107c:	03000593          	li	a1,48
    1080:	8556                	mv	a0,s5
    1082:	00000097          	auipc	ra,0x0
    1086:	e48080e7          	jalr	-440(ra) # eca <putc>
  putc(fd, 'x');
    108a:	07800593          	li	a1,120
    108e:	8556                	mv	a0,s5
    1090:	00000097          	auipc	ra,0x0
    1094:	e3a080e7          	jalr	-454(ra) # eca <putc>
    1098:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    109a:	00000b97          	auipc	s7,0x0
    109e:	44eb8b93          	addi	s7,s7,1102 # 14e8 <digits>
    10a2:	03c9d793          	srli	a5,s3,0x3c
    10a6:	97de                	add	a5,a5,s7
    10a8:	0007c583          	lbu	a1,0(a5)
    10ac:	8556                	mv	a0,s5
    10ae:	00000097          	auipc	ra,0x0
    10b2:	e1c080e7          	jalr	-484(ra) # eca <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    10b6:	0992                	slli	s3,s3,0x4
    10b8:	397d                	addiw	s2,s2,-1
    10ba:	fe0914e3          	bnez	s2,10a2 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
    10be:	8be2                	mv	s7,s8
      state = 0;
    10c0:	4981                	li	s3,0
    10c2:	6c02                	ld	s8,0(sp)
    10c4:	bf09                	j	fd6 <vprintf+0x42>
        s = va_arg(ap, char*);
    10c6:	008b8993          	addi	s3,s7,8
    10ca:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    10ce:	02090163          	beqz	s2,10f0 <vprintf+0x15c>
        while(*s != 0){
    10d2:	00094583          	lbu	a1,0(s2)
    10d6:	c9a5                	beqz	a1,1146 <vprintf+0x1b2>
          putc(fd, *s);
    10d8:	8556                	mv	a0,s5
    10da:	00000097          	auipc	ra,0x0
    10de:	df0080e7          	jalr	-528(ra) # eca <putc>
          s++;
    10e2:	0905                	addi	s2,s2,1
        while(*s != 0){
    10e4:	00094583          	lbu	a1,0(s2)
    10e8:	f9e5                	bnez	a1,10d8 <vprintf+0x144>
        s = va_arg(ap, char*);
    10ea:	8bce                	mv	s7,s3
      state = 0;
    10ec:	4981                	li	s3,0
    10ee:	b5e5                	j	fd6 <vprintf+0x42>
          s = "(null)";
    10f0:	00000917          	auipc	s2,0x0
    10f4:	36890913          	addi	s2,s2,872 # 1458 <malloc+0x20c>
        while(*s != 0){
    10f8:	02800593          	li	a1,40
    10fc:	bff1                	j	10d8 <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
    10fe:	008b8913          	addi	s2,s7,8
    1102:	000bc583          	lbu	a1,0(s7)
    1106:	8556                	mv	a0,s5
    1108:	00000097          	auipc	ra,0x0
    110c:	dc2080e7          	jalr	-574(ra) # eca <putc>
    1110:	8bca                	mv	s7,s2
      state = 0;
    1112:	4981                	li	s3,0
    1114:	b5c9                	j	fd6 <vprintf+0x42>
        putc(fd, c);
    1116:	02500593          	li	a1,37
    111a:	8556                	mv	a0,s5
    111c:	00000097          	auipc	ra,0x0
    1120:	dae080e7          	jalr	-594(ra) # eca <putc>
      state = 0;
    1124:	4981                	li	s3,0
    1126:	bd45                	j	fd6 <vprintf+0x42>
        putc(fd, '%');
    1128:	02500593          	li	a1,37
    112c:	8556                	mv	a0,s5
    112e:	00000097          	auipc	ra,0x0
    1132:	d9c080e7          	jalr	-612(ra) # eca <putc>
        putc(fd, c);
    1136:	85ca                	mv	a1,s2
    1138:	8556                	mv	a0,s5
    113a:	00000097          	auipc	ra,0x0
    113e:	d90080e7          	jalr	-624(ra) # eca <putc>
      state = 0;
    1142:	4981                	li	s3,0
    1144:	bd49                	j	fd6 <vprintf+0x42>
        s = va_arg(ap, char*);
    1146:	8bce                	mv	s7,s3
      state = 0;
    1148:	4981                	li	s3,0
    114a:	b571                	j	fd6 <vprintf+0x42>
    114c:	74e2                	ld	s1,56(sp)
    114e:	79a2                	ld	s3,40(sp)
    1150:	7a02                	ld	s4,32(sp)
    1152:	6ae2                	ld	s5,24(sp)
    1154:	6b42                	ld	s6,16(sp)
    1156:	6ba2                	ld	s7,8(sp)
    }
  }
}
    1158:	60a6                	ld	ra,72(sp)
    115a:	6406                	ld	s0,64(sp)
    115c:	7942                	ld	s2,48(sp)
    115e:	6161                	addi	sp,sp,80
    1160:	8082                	ret

0000000000001162 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1162:	715d                	addi	sp,sp,-80
    1164:	ec06                	sd	ra,24(sp)
    1166:	e822                	sd	s0,16(sp)
    1168:	1000                	addi	s0,sp,32
    116a:	e010                	sd	a2,0(s0)
    116c:	e414                	sd	a3,8(s0)
    116e:	e818                	sd	a4,16(s0)
    1170:	ec1c                	sd	a5,24(s0)
    1172:	03043023          	sd	a6,32(s0)
    1176:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    117a:	8622                	mv	a2,s0
    117c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1180:	00000097          	auipc	ra,0x0
    1184:	e14080e7          	jalr	-492(ra) # f94 <vprintf>
}
    1188:	60e2                	ld	ra,24(sp)
    118a:	6442                	ld	s0,16(sp)
    118c:	6161                	addi	sp,sp,80
    118e:	8082                	ret

0000000000001190 <printf>:

void
printf(const char *fmt, ...)
{
    1190:	711d                	addi	sp,sp,-96
    1192:	ec06                	sd	ra,24(sp)
    1194:	e822                	sd	s0,16(sp)
    1196:	1000                	addi	s0,sp,32
    1198:	e40c                	sd	a1,8(s0)
    119a:	e810                	sd	a2,16(s0)
    119c:	ec14                	sd	a3,24(s0)
    119e:	f018                	sd	a4,32(s0)
    11a0:	f41c                	sd	a5,40(s0)
    11a2:	03043823          	sd	a6,48(s0)
    11a6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    11aa:	00840613          	addi	a2,s0,8
    11ae:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    11b2:	85aa                	mv	a1,a0
    11b4:	4505                	li	a0,1
    11b6:	00000097          	auipc	ra,0x0
    11ba:	dde080e7          	jalr	-546(ra) # f94 <vprintf>
}
    11be:	60e2                	ld	ra,24(sp)
    11c0:	6442                	ld	s0,16(sp)
    11c2:	6125                	addi	sp,sp,96
    11c4:	8082                	ret

00000000000011c6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    11c6:	1141                	addi	sp,sp,-16
    11c8:	e406                	sd	ra,8(sp)
    11ca:	e022                	sd	s0,0(sp)
    11cc:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    11ce:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11d2:	00000797          	auipc	a5,0x0
    11d6:	33e7b783          	ld	a5,830(a5) # 1510 <freep>
    11da:	a039                	j	11e8 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    11dc:	6398                	ld	a4,0(a5)
    11de:	00e7e463          	bltu	a5,a4,11e6 <free+0x20>
    11e2:	00e6ea63          	bltu	a3,a4,11f6 <free+0x30>
{
    11e6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11e8:	fed7fae3          	bgeu	a5,a3,11dc <free+0x16>
    11ec:	6398                	ld	a4,0(a5)
    11ee:	00e6e463          	bltu	a3,a4,11f6 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    11f2:	fee7eae3          	bltu	a5,a4,11e6 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
    11f6:	ff852583          	lw	a1,-8(a0)
    11fa:	6390                	ld	a2,0(a5)
    11fc:	02059813          	slli	a6,a1,0x20
    1200:	01c85713          	srli	a4,a6,0x1c
    1204:	9736                	add	a4,a4,a3
    1206:	02e60563          	beq	a2,a4,1230 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    120a:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    120e:	4790                	lw	a2,8(a5)
    1210:	02061593          	slli	a1,a2,0x20
    1214:	01c5d713          	srli	a4,a1,0x1c
    1218:	973e                	add	a4,a4,a5
    121a:	02e68263          	beq	a3,a4,123e <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
    121e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    1220:	00000717          	auipc	a4,0x0
    1224:	2ef73823          	sd	a5,752(a4) # 1510 <freep>
}
    1228:	60a2                	ld	ra,8(sp)
    122a:	6402                	ld	s0,0(sp)
    122c:	0141                	addi	sp,sp,16
    122e:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
    1230:	4618                	lw	a4,8(a2)
    1232:	9f2d                	addw	a4,a4,a1
    1234:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1238:	6398                	ld	a4,0(a5)
    123a:	6310                	ld	a2,0(a4)
    123c:	b7f9                	j	120a <free+0x44>
    p->s.size += bp->s.size;
    123e:	ff852703          	lw	a4,-8(a0)
    1242:	9f31                	addw	a4,a4,a2
    1244:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    1246:	ff053683          	ld	a3,-16(a0)
    124a:	bfd1                	j	121e <free+0x58>

000000000000124c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    124c:	7139                	addi	sp,sp,-64
    124e:	fc06                	sd	ra,56(sp)
    1250:	f822                	sd	s0,48(sp)
    1252:	f04a                	sd	s2,32(sp)
    1254:	ec4e                	sd	s3,24(sp)
    1256:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1258:	02051993          	slli	s3,a0,0x20
    125c:	0209d993          	srli	s3,s3,0x20
    1260:	09bd                	addi	s3,s3,15
    1262:	0049d993          	srli	s3,s3,0x4
    1266:	2985                	addiw	s3,s3,1
    1268:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
    126a:	00000517          	auipc	a0,0x0
    126e:	2a653503          	ld	a0,678(a0) # 1510 <freep>
    1272:	c905                	beqz	a0,12a2 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1274:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1276:	4798                	lw	a4,8(a5)
    1278:	09377a63          	bgeu	a4,s3,130c <malloc+0xc0>
    127c:	f426                	sd	s1,40(sp)
    127e:	e852                	sd	s4,16(sp)
    1280:	e456                	sd	s5,8(sp)
    1282:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    1284:	8a4e                	mv	s4,s3
    1286:	6705                	lui	a4,0x1
    1288:	00e9f363          	bgeu	s3,a4,128e <malloc+0x42>
    128c:	6a05                	lui	s4,0x1
    128e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1292:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1296:	00000497          	auipc	s1,0x0
    129a:	27a48493          	addi	s1,s1,634 # 1510 <freep>
  if(p == (char*)-1)
    129e:	5afd                	li	s5,-1
    12a0:	a089                	j	12e2 <malloc+0x96>
    12a2:	f426                	sd	s1,40(sp)
    12a4:	e852                	sd	s4,16(sp)
    12a6:	e456                	sd	s5,8(sp)
    12a8:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    12aa:	00000797          	auipc	a5,0x0
    12ae:	2d678793          	addi	a5,a5,726 # 1580 <base>
    12b2:	00000717          	auipc	a4,0x0
    12b6:	24f73f23          	sd	a5,606(a4) # 1510 <freep>
    12ba:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    12bc:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    12c0:	b7d1                	j	1284 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    12c2:	6398                	ld	a4,0(a5)
    12c4:	e118                	sd	a4,0(a0)
    12c6:	a8b9                	j	1324 <malloc+0xd8>
  hp->s.size = nu;
    12c8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    12cc:	0541                	addi	a0,a0,16
    12ce:	00000097          	auipc	ra,0x0
    12d2:	ef8080e7          	jalr	-264(ra) # 11c6 <free>
  return freep;
    12d6:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    12d8:	c135                	beqz	a0,133c <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    12da:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    12dc:	4798                	lw	a4,8(a5)
    12de:	03277363          	bgeu	a4,s2,1304 <malloc+0xb8>
    if(p == freep)
    12e2:	6098                	ld	a4,0(s1)
    12e4:	853e                	mv	a0,a5
    12e6:	fef71ae3          	bne	a4,a5,12da <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    12ea:	8552                	mv	a0,s4
    12ec:	00000097          	auipc	ra,0x0
    12f0:	bb6080e7          	jalr	-1098(ra) # ea2 <sbrk>
  if(p == (char*)-1)
    12f4:	fd551ae3          	bne	a0,s5,12c8 <malloc+0x7c>
        return 0;
    12f8:	4501                	li	a0,0
    12fa:	74a2                	ld	s1,40(sp)
    12fc:	6a42                	ld	s4,16(sp)
    12fe:	6aa2                	ld	s5,8(sp)
    1300:	6b02                	ld	s6,0(sp)
    1302:	a03d                	j	1330 <malloc+0xe4>
    1304:	74a2                	ld	s1,40(sp)
    1306:	6a42                	ld	s4,16(sp)
    1308:	6aa2                	ld	s5,8(sp)
    130a:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    130c:	fae90be3          	beq	s2,a4,12c2 <malloc+0x76>
        p->s.size -= nunits;
    1310:	4137073b          	subw	a4,a4,s3
    1314:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1316:	02071693          	slli	a3,a4,0x20
    131a:	01c6d713          	srli	a4,a3,0x1c
    131e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1320:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1324:	00000717          	auipc	a4,0x0
    1328:	1ea73623          	sd	a0,492(a4) # 1510 <freep>
      return (void*)(p + 1);
    132c:	01078513          	addi	a0,a5,16
  }
}
    1330:	70e2                	ld	ra,56(sp)
    1332:	7442                	ld	s0,48(sp)
    1334:	7902                	ld	s2,32(sp)
    1336:	69e2                	ld	s3,24(sp)
    1338:	6121                	addi	sp,sp,64
    133a:	8082                	ret
    133c:	74a2                	ld	s1,40(sp)
    133e:	6a42                	ld	s4,16(sp)
    1340:	6aa2                	ld	s5,8(sp)
    1342:	6b02                	ld	s6,0(sp)
    1344:	b7f5                	j	1330 <malloc+0xe4>
