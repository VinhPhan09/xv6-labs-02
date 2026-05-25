
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
  write(2, "$ ", 2);
      10:	4609                	li	a2,2
      12:	00001597          	auipc	a1,0x1
      16:	18e58593          	addi	a1,a1,398 # 11a0 <malloc+0xea>
      1a:	4509                	li	a0,2
      1c:	3ef000ef          	jal	ra,c0a <write>
  memset(buf, 0, nbuf);
      20:	864a                	mv	a2,s2
      22:	4581                	li	a1,0
      24:	8526                	mv	a0,s1
      26:	1dd000ef          	jal	ra,a02 <memset>
  gets(buf, nbuf);
      2a:	85ca                	mv	a1,s2
      2c:	8526                	mv	a0,s1
      2e:	21b000ef          	jal	ra,a48 <gets>
  if(buf[0] == 0) // EOF
      32:	0004c503          	lbu	a0,0(s1)
      36:	00153513          	seqz	a0,a0
    return -1;
  return 0;
}
      3a:	40a00533          	neg	a0,a0
      3e:	60e2                	ld	ra,24(sp)
      40:	6442                	ld	s0,16(sp)
      42:	64a2                	ld	s1,8(sp)
      44:	6902                	ld	s2,0(sp)
      46:	6105                	addi	sp,sp,32
      48:	8082                	ret

000000000000004a <panic>:
  exit(0);
}

void
panic(char *s)
{
      4a:	1141                	addi	sp,sp,-16
      4c:	e406                	sd	ra,8(sp)
      4e:	e022                	sd	s0,0(sp)
      50:	0800                	addi	s0,sp,16
      52:	862a                	mv	a2,a0
  fprintf(2, "%s\n", s);
      54:	00001597          	auipc	a1,0x1
      58:	15458593          	addi	a1,a1,340 # 11a8 <malloc+0xf2>
      5c:	4509                	li	a0,2
      5e:	775000ef          	jal	ra,fd2 <fprintf>
  exit(1);
      62:	4505                	li	a0,1
      64:	387000ef          	jal	ra,bea <exit>

0000000000000068 <fork1>:
}

int
fork1(void)
{
      68:	1141                	addi	sp,sp,-16
      6a:	e406                	sd	ra,8(sp)
      6c:	e022                	sd	s0,0(sp)
      6e:	0800                	addi	s0,sp,16
  int pid;

  pid = fork();
      70:	373000ef          	jal	ra,be2 <fork>
  if(pid == -1)
      74:	57fd                	li	a5,-1
      76:	00f50663          	beq	a0,a5,82 <fork1+0x1a>
    panic("fork");
  return pid;
}
      7a:	60a2                	ld	ra,8(sp)
      7c:	6402                	ld	s0,0(sp)
      7e:	0141                	addi	sp,sp,16
      80:	8082                	ret
    panic("fork");
      82:	00001517          	auipc	a0,0x1
      86:	12e50513          	addi	a0,a0,302 # 11b0 <malloc+0xfa>
      8a:	fc1ff0ef          	jal	ra,4a <panic>

000000000000008e <runcmd>:
{
      8e:	7179                	addi	sp,sp,-48
      90:	f406                	sd	ra,40(sp)
      92:	f022                	sd	s0,32(sp)
      94:	ec26                	sd	s1,24(sp)
      96:	1800                	addi	s0,sp,48
  if(cmd == 0)
      98:	c10d                	beqz	a0,ba <runcmd+0x2c>
      9a:	84aa                	mv	s1,a0
  switch(cmd->type){
      9c:	4118                	lw	a4,0(a0)
      9e:	4795                	li	a5,5
      a0:	02e7e063          	bltu	a5,a4,c0 <runcmd+0x32>
      a4:	00056783          	lwu	a5,0(a0)
      a8:	078a                	slli	a5,a5,0x2
      aa:	00001717          	auipc	a4,0x1
      ae:	20670713          	addi	a4,a4,518 # 12b0 <malloc+0x1fa>
      b2:	97ba                	add	a5,a5,a4
      b4:	439c                	lw	a5,0(a5)
      b6:	97ba                	add	a5,a5,a4
      b8:	8782                	jr	a5
    exit(1);
      ba:	4505                	li	a0,1
      bc:	32f000ef          	jal	ra,bea <exit>
    panic("runcmd");
      c0:	00001517          	auipc	a0,0x1
      c4:	0f850513          	addi	a0,a0,248 # 11b8 <malloc+0x102>
      c8:	f83ff0ef          	jal	ra,4a <panic>
    if(ecmd->argv[0] == 0)
      cc:	6508                	ld	a0,8(a0)
      ce:	c105                	beqz	a0,ee <runcmd+0x60>
    exec(ecmd->argv[0], ecmd->argv);
      d0:	00848593          	addi	a1,s1,8
      d4:	34f000ef          	jal	ra,c22 <exec>
    fprintf(2, "exec %s failed\n", ecmd->argv[0]);
      d8:	6490                	ld	a2,8(s1)
      da:	00001597          	auipc	a1,0x1
      de:	0e658593          	addi	a1,a1,230 # 11c0 <malloc+0x10a>
      e2:	4509                	li	a0,2
      e4:	6ef000ef          	jal	ra,fd2 <fprintf>
  exit(0);
      e8:	4501                	li	a0,0
      ea:	301000ef          	jal	ra,bea <exit>
      exit(1);
      ee:	4505                	li	a0,1
      f0:	2fb000ef          	jal	ra,bea <exit>
    close(rcmd->fd);
      f4:	5148                	lw	a0,36(a0)
      f6:	31d000ef          	jal	ra,c12 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
      fa:	508c                	lw	a1,32(s1)
      fc:	6888                	ld	a0,16(s1)
      fe:	32d000ef          	jal	ra,c2a <open>
     102:	00054563          	bltz	a0,10c <runcmd+0x7e>
    runcmd(rcmd->cmd);
     106:	6488                	ld	a0,8(s1)
     108:	f87ff0ef          	jal	ra,8e <runcmd>
      fprintf(2, "open %s failed\n", rcmd->file);
     10c:	6890                	ld	a2,16(s1)
     10e:	00001597          	auipc	a1,0x1
     112:	0c258593          	addi	a1,a1,194 # 11d0 <malloc+0x11a>
     116:	4509                	li	a0,2
     118:	6bb000ef          	jal	ra,fd2 <fprintf>
      exit(1);
     11c:	4505                	li	a0,1
     11e:	2cd000ef          	jal	ra,bea <exit>
    if(fork1() == 0)
     122:	f47ff0ef          	jal	ra,68 <fork1>
     126:	e501                	bnez	a0,12e <runcmd+0xa0>
      runcmd(lcmd->left);
     128:	6488                	ld	a0,8(s1)
     12a:	f65ff0ef          	jal	ra,8e <runcmd>
    wait(0);
     12e:	4501                	li	a0,0
     130:	2c3000ef          	jal	ra,bf2 <wait>
    runcmd(lcmd->right);
     134:	6888                	ld	a0,16(s1)
     136:	f59ff0ef          	jal	ra,8e <runcmd>
    if(pipe(p) < 0)
     13a:	fd840513          	addi	a0,s0,-40
     13e:	2bd000ef          	jal	ra,bfa <pipe>
     142:	02054763          	bltz	a0,170 <runcmd+0xe2>
    if(fork1() == 0){
     146:	f23ff0ef          	jal	ra,68 <fork1>
     14a:	e90d                	bnez	a0,17c <runcmd+0xee>
      close(1);
     14c:	4505                	li	a0,1
     14e:	2c5000ef          	jal	ra,c12 <close>
      dup(p[1]);
     152:	fdc42503          	lw	a0,-36(s0)
     156:	30d000ef          	jal	ra,c62 <dup>
      close(p[0]);
     15a:	fd842503          	lw	a0,-40(s0)
     15e:	2b5000ef          	jal	ra,c12 <close>
      close(p[1]);
     162:	fdc42503          	lw	a0,-36(s0)
     166:	2ad000ef          	jal	ra,c12 <close>
      runcmd(pcmd->left);
     16a:	6488                	ld	a0,8(s1)
     16c:	f23ff0ef          	jal	ra,8e <runcmd>
      panic("pipe");
     170:	00001517          	auipc	a0,0x1
     174:	07050513          	addi	a0,a0,112 # 11e0 <malloc+0x12a>
     178:	ed3ff0ef          	jal	ra,4a <panic>
    if(fork1() == 0){
     17c:	eedff0ef          	jal	ra,68 <fork1>
     180:	e115                	bnez	a0,1a4 <runcmd+0x116>
      close(0);
     182:	291000ef          	jal	ra,c12 <close>
      dup(p[0]);
     186:	fd842503          	lw	a0,-40(s0)
     18a:	2d9000ef          	jal	ra,c62 <dup>
      close(p[0]);
     18e:	fd842503          	lw	a0,-40(s0)
     192:	281000ef          	jal	ra,c12 <close>
      close(p[1]);
     196:	fdc42503          	lw	a0,-36(s0)
     19a:	279000ef          	jal	ra,c12 <close>
      runcmd(pcmd->right);
     19e:	6888                	ld	a0,16(s1)
     1a0:	eefff0ef          	jal	ra,8e <runcmd>
    close(p[0]);
     1a4:	fd842503          	lw	a0,-40(s0)
     1a8:	26b000ef          	jal	ra,c12 <close>
    close(p[1]);
     1ac:	fdc42503          	lw	a0,-36(s0)
     1b0:	263000ef          	jal	ra,c12 <close>
    wait(0);
     1b4:	4501                	li	a0,0
     1b6:	23d000ef          	jal	ra,bf2 <wait>
    wait(0);
     1ba:	4501                	li	a0,0
     1bc:	237000ef          	jal	ra,bf2 <wait>
    break;
     1c0:	b725                	j	e8 <runcmd+0x5a>
    if(fork1() == 0)
     1c2:	ea7ff0ef          	jal	ra,68 <fork1>
     1c6:	f20511e3          	bnez	a0,e8 <runcmd+0x5a>
      runcmd(bcmd->cmd);
     1ca:	6488                	ld	a0,8(s1)
     1cc:	ec3ff0ef          	jal	ra,8e <runcmd>

00000000000001d0 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     1d0:	1101                	addi	sp,sp,-32
     1d2:	ec06                	sd	ra,24(sp)
     1d4:	e822                	sd	s0,16(sp)
     1d6:	e426                	sd	s1,8(sp)
     1d8:	1000                	addi	s0,sp,32
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     1da:	0a800513          	li	a0,168
     1de:	6d9000ef          	jal	ra,10b6 <malloc>
     1e2:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     1e4:	0a800613          	li	a2,168
     1e8:	4581                	li	a1,0
     1ea:	019000ef          	jal	ra,a02 <memset>
  cmd->type = EXEC;
     1ee:	4785                	li	a5,1
     1f0:	c09c                	sw	a5,0(s1)
  return (struct cmd*)cmd;
}
     1f2:	8526                	mv	a0,s1
     1f4:	60e2                	ld	ra,24(sp)
     1f6:	6442                	ld	s0,16(sp)
     1f8:	64a2                	ld	s1,8(sp)
     1fa:	6105                	addi	sp,sp,32
     1fc:	8082                	ret

00000000000001fe <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     1fe:	7139                	addi	sp,sp,-64
     200:	fc06                	sd	ra,56(sp)
     202:	f822                	sd	s0,48(sp)
     204:	f426                	sd	s1,40(sp)
     206:	f04a                	sd	s2,32(sp)
     208:	ec4e                	sd	s3,24(sp)
     20a:	e852                	sd	s4,16(sp)
     20c:	e456                	sd	s5,8(sp)
     20e:	e05a                	sd	s6,0(sp)
     210:	0080                	addi	s0,sp,64
     212:	8b2a                	mv	s6,a0
     214:	8aae                	mv	s5,a1
     216:	8a32                	mv	s4,a2
     218:	89b6                	mv	s3,a3
     21a:	893a                	mv	s2,a4
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     21c:	02800513          	li	a0,40
     220:	697000ef          	jal	ra,10b6 <malloc>
     224:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     226:	02800613          	li	a2,40
     22a:	4581                	li	a1,0
     22c:	7d6000ef          	jal	ra,a02 <memset>
  cmd->type = REDIR;
     230:	4789                	li	a5,2
     232:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     234:	0164b423          	sd	s6,8(s1)
  cmd->file = file;
     238:	0154b823          	sd	s5,16(s1)
  cmd->efile = efile;
     23c:	0144bc23          	sd	s4,24(s1)
  cmd->mode = mode;
     240:	0334a023          	sw	s3,32(s1)
  cmd->fd = fd;
     244:	0324a223          	sw	s2,36(s1)
  return (struct cmd*)cmd;
}
     248:	8526                	mv	a0,s1
     24a:	70e2                	ld	ra,56(sp)
     24c:	7442                	ld	s0,48(sp)
     24e:	74a2                	ld	s1,40(sp)
     250:	7902                	ld	s2,32(sp)
     252:	69e2                	ld	s3,24(sp)
     254:	6a42                	ld	s4,16(sp)
     256:	6aa2                	ld	s5,8(sp)
     258:	6b02                	ld	s6,0(sp)
     25a:	6121                	addi	sp,sp,64
     25c:	8082                	ret

000000000000025e <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     25e:	7179                	addi	sp,sp,-48
     260:	f406                	sd	ra,40(sp)
     262:	f022                	sd	s0,32(sp)
     264:	ec26                	sd	s1,24(sp)
     266:	e84a                	sd	s2,16(sp)
     268:	e44e                	sd	s3,8(sp)
     26a:	1800                	addi	s0,sp,48
     26c:	89aa                	mv	s3,a0
     26e:	892e                	mv	s2,a1
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     270:	4561                	li	a0,24
     272:	645000ef          	jal	ra,10b6 <malloc>
     276:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     278:	4661                	li	a2,24
     27a:	4581                	li	a1,0
     27c:	786000ef          	jal	ra,a02 <memset>
  cmd->type = PIPE;
     280:	478d                	li	a5,3
     282:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     284:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     288:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     28c:	8526                	mv	a0,s1
     28e:	70a2                	ld	ra,40(sp)
     290:	7402                	ld	s0,32(sp)
     292:	64e2                	ld	s1,24(sp)
     294:	6942                	ld	s2,16(sp)
     296:	69a2                	ld	s3,8(sp)
     298:	6145                	addi	sp,sp,48
     29a:	8082                	ret

000000000000029c <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     29c:	7179                	addi	sp,sp,-48
     29e:	f406                	sd	ra,40(sp)
     2a0:	f022                	sd	s0,32(sp)
     2a2:	ec26                	sd	s1,24(sp)
     2a4:	e84a                	sd	s2,16(sp)
     2a6:	e44e                	sd	s3,8(sp)
     2a8:	1800                	addi	s0,sp,48
     2aa:	89aa                	mv	s3,a0
     2ac:	892e                	mv	s2,a1
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2ae:	4561                	li	a0,24
     2b0:	607000ef          	jal	ra,10b6 <malloc>
     2b4:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2b6:	4661                	li	a2,24
     2b8:	4581                	li	a1,0
     2ba:	748000ef          	jal	ra,a02 <memset>
  cmd->type = LIST;
     2be:	4791                	li	a5,4
     2c0:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     2c2:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     2c6:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     2ca:	8526                	mv	a0,s1
     2cc:	70a2                	ld	ra,40(sp)
     2ce:	7402                	ld	s0,32(sp)
     2d0:	64e2                	ld	s1,24(sp)
     2d2:	6942                	ld	s2,16(sp)
     2d4:	69a2                	ld	s3,8(sp)
     2d6:	6145                	addi	sp,sp,48
     2d8:	8082                	ret

00000000000002da <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     2da:	1101                	addi	sp,sp,-32
     2dc:	ec06                	sd	ra,24(sp)
     2de:	e822                	sd	s0,16(sp)
     2e0:	e426                	sd	s1,8(sp)
     2e2:	e04a                	sd	s2,0(sp)
     2e4:	1000                	addi	s0,sp,32
     2e6:	892a                	mv	s2,a0
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2e8:	4541                	li	a0,16
     2ea:	5cd000ef          	jal	ra,10b6 <malloc>
     2ee:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2f0:	4641                	li	a2,16
     2f2:	4581                	li	a1,0
     2f4:	70e000ef          	jal	ra,a02 <memset>
  cmd->type = BACK;
     2f8:	4795                	li	a5,5
     2fa:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     2fc:	0124b423          	sd	s2,8(s1)
  return (struct cmd*)cmd;
}
     300:	8526                	mv	a0,s1
     302:	60e2                	ld	ra,24(sp)
     304:	6442                	ld	s0,16(sp)
     306:	64a2                	ld	s1,8(sp)
     308:	6902                	ld	s2,0(sp)
     30a:	6105                	addi	sp,sp,32
     30c:	8082                	ret

000000000000030e <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     30e:	7139                	addi	sp,sp,-64
     310:	fc06                	sd	ra,56(sp)
     312:	f822                	sd	s0,48(sp)
     314:	f426                	sd	s1,40(sp)
     316:	f04a                	sd	s2,32(sp)
     318:	ec4e                	sd	s3,24(sp)
     31a:	e852                	sd	s4,16(sp)
     31c:	e456                	sd	s5,8(sp)
     31e:	e05a                	sd	s6,0(sp)
     320:	0080                	addi	s0,sp,64
     322:	8a2a                	mv	s4,a0
     324:	892e                	mv	s2,a1
     326:	8ab2                	mv	s5,a2
     328:	8b36                	mv	s6,a3
  char *s;
  int ret;

  s = *ps;
     32a:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     32c:	00002997          	auipc	s3,0x2
     330:	cdc98993          	addi	s3,s3,-804 # 2008 <whitespace>
     334:	00b4fb63          	bgeu	s1,a1,34a <gettoken+0x3c>
     338:	0004c583          	lbu	a1,0(s1)
     33c:	854e                	mv	a0,s3
     33e:	6e6000ef          	jal	ra,a24 <strchr>
     342:	c501                	beqz	a0,34a <gettoken+0x3c>
    s++;
     344:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     346:	fe9919e3          	bne	s2,s1,338 <gettoken+0x2a>
  if(q)
     34a:	000a8463          	beqz	s5,352 <gettoken+0x44>
    *q = s;
     34e:	009ab023          	sd	s1,0(s5)
  ret = *s;
     352:	0004c783          	lbu	a5,0(s1)
     356:	00078a9b          	sext.w	s5,a5
  switch(*s){
     35a:	03c00713          	li	a4,60
     35e:	06f76363          	bltu	a4,a5,3c4 <gettoken+0xb6>
     362:	03a00713          	li	a4,58
     366:	00f76e63          	bltu	a4,a5,382 <gettoken+0x74>
     36a:	cf89                	beqz	a5,384 <gettoken+0x76>
     36c:	02600713          	li	a4,38
     370:	00e78963          	beq	a5,a4,382 <gettoken+0x74>
     374:	fd87879b          	addiw	a5,a5,-40
     378:	0ff7f793          	andi	a5,a5,255
     37c:	4705                	li	a4,1
     37e:	06f76a63          	bltu	a4,a5,3f2 <gettoken+0xe4>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     382:	0485                	addi	s1,s1,1
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     384:	000b0463          	beqz	s6,38c <gettoken+0x7e>
    *eq = s;
     388:	009b3023          	sd	s1,0(s6)

  while(s < es && strchr(whitespace, *s))
     38c:	00002997          	auipc	s3,0x2
     390:	c7c98993          	addi	s3,s3,-900 # 2008 <whitespace>
     394:	0124fb63          	bgeu	s1,s2,3aa <gettoken+0x9c>
     398:	0004c583          	lbu	a1,0(s1)
     39c:	854e                	mv	a0,s3
     39e:	686000ef          	jal	ra,a24 <strchr>
     3a2:	c501                	beqz	a0,3aa <gettoken+0x9c>
    s++;
     3a4:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     3a6:	fe9919e3          	bne	s2,s1,398 <gettoken+0x8a>
  *ps = s;
     3aa:	009a3023          	sd	s1,0(s4)
  return ret;
}
     3ae:	8556                	mv	a0,s5
     3b0:	70e2                	ld	ra,56(sp)
     3b2:	7442                	ld	s0,48(sp)
     3b4:	74a2                	ld	s1,40(sp)
     3b6:	7902                	ld	s2,32(sp)
     3b8:	69e2                	ld	s3,24(sp)
     3ba:	6a42                	ld	s4,16(sp)
     3bc:	6aa2                	ld	s5,8(sp)
     3be:	6b02                	ld	s6,0(sp)
     3c0:	6121                	addi	sp,sp,64
     3c2:	8082                	ret
  switch(*s){
     3c4:	03e00713          	li	a4,62
     3c8:	02e79163          	bne	a5,a4,3ea <gettoken+0xdc>
    s++;
     3cc:	00148693          	addi	a3,s1,1
    if(*s == '>'){
     3d0:	0014c703          	lbu	a4,1(s1)
     3d4:	03e00793          	li	a5,62
      s++;
     3d8:	0489                	addi	s1,s1,2
      ret = '+';
     3da:	02b00a93          	li	s5,43
    if(*s == '>'){
     3de:	faf703e3          	beq	a4,a5,384 <gettoken+0x76>
    s++;
     3e2:	84b6                	mv	s1,a3
  ret = *s;
     3e4:	03e00a93          	li	s5,62
     3e8:	bf71                	j	384 <gettoken+0x76>
  switch(*s){
     3ea:	07c00713          	li	a4,124
     3ee:	f8e78ae3          	beq	a5,a4,382 <gettoken+0x74>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     3f2:	00002997          	auipc	s3,0x2
     3f6:	c1698993          	addi	s3,s3,-1002 # 2008 <whitespace>
     3fa:	00002a97          	auipc	s5,0x2
     3fe:	c06a8a93          	addi	s5,s5,-1018 # 2000 <symbols>
     402:	0324f163          	bgeu	s1,s2,424 <gettoken+0x116>
     406:	0004c583          	lbu	a1,0(s1)
     40a:	854e                	mv	a0,s3
     40c:	618000ef          	jal	ra,a24 <strchr>
     410:	e115                	bnez	a0,434 <gettoken+0x126>
     412:	0004c583          	lbu	a1,0(s1)
     416:	8556                	mv	a0,s5
     418:	60c000ef          	jal	ra,a24 <strchr>
     41c:	e909                	bnez	a0,42e <gettoken+0x120>
      s++;
     41e:	0485                	addi	s1,s1,1
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     420:	fe9913e3          	bne	s2,s1,406 <gettoken+0xf8>
  if(eq)
     424:	06100a93          	li	s5,97
     428:	f60b10e3          	bnez	s6,388 <gettoken+0x7a>
     42c:	bfbd                	j	3aa <gettoken+0x9c>
    ret = 'a';
     42e:	06100a93          	li	s5,97
     432:	bf89                	j	384 <gettoken+0x76>
     434:	06100a93          	li	s5,97
     438:	b7b1                	j	384 <gettoken+0x76>

000000000000043a <peek>:

int
peek(char **ps, char *es, char *toks)
{
     43a:	7139                	addi	sp,sp,-64
     43c:	fc06                	sd	ra,56(sp)
     43e:	f822                	sd	s0,48(sp)
     440:	f426                	sd	s1,40(sp)
     442:	f04a                	sd	s2,32(sp)
     444:	ec4e                	sd	s3,24(sp)
     446:	e852                	sd	s4,16(sp)
     448:	e456                	sd	s5,8(sp)
     44a:	0080                	addi	s0,sp,64
     44c:	8a2a                	mv	s4,a0
     44e:	892e                	mv	s2,a1
     450:	8ab2                	mv	s5,a2
  char *s;

  s = *ps;
     452:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     454:	00002997          	auipc	s3,0x2
     458:	bb498993          	addi	s3,s3,-1100 # 2008 <whitespace>
     45c:	00b4fb63          	bgeu	s1,a1,472 <peek+0x38>
     460:	0004c583          	lbu	a1,0(s1)
     464:	854e                	mv	a0,s3
     466:	5be000ef          	jal	ra,a24 <strchr>
     46a:	c501                	beqz	a0,472 <peek+0x38>
    s++;
     46c:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     46e:	fe9919e3          	bne	s2,s1,460 <peek+0x26>
  *ps = s;
     472:	009a3023          	sd	s1,0(s4)
  return *s && strchr(toks, *s);
     476:	0004c583          	lbu	a1,0(s1)
     47a:	4501                	li	a0,0
     47c:	e991                	bnez	a1,490 <peek+0x56>
}
     47e:	70e2                	ld	ra,56(sp)
     480:	7442                	ld	s0,48(sp)
     482:	74a2                	ld	s1,40(sp)
     484:	7902                	ld	s2,32(sp)
     486:	69e2                	ld	s3,24(sp)
     488:	6a42                	ld	s4,16(sp)
     48a:	6aa2                	ld	s5,8(sp)
     48c:	6121                	addi	sp,sp,64
     48e:	8082                	ret
  return *s && strchr(toks, *s);
     490:	8556                	mv	a0,s5
     492:	592000ef          	jal	ra,a24 <strchr>
     496:	00a03533          	snez	a0,a0
     49a:	b7d5                	j	47e <peek+0x44>

000000000000049c <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     49c:	7159                	addi	sp,sp,-112
     49e:	f486                	sd	ra,104(sp)
     4a0:	f0a2                	sd	s0,96(sp)
     4a2:	eca6                	sd	s1,88(sp)
     4a4:	e8ca                	sd	s2,80(sp)
     4a6:	e4ce                	sd	s3,72(sp)
     4a8:	e0d2                	sd	s4,64(sp)
     4aa:	fc56                	sd	s5,56(sp)
     4ac:	f85a                	sd	s6,48(sp)
     4ae:	f45e                	sd	s7,40(sp)
     4b0:	f062                	sd	s8,32(sp)
     4b2:	ec66                	sd	s9,24(sp)
     4b4:	1880                	addi	s0,sp,112
     4b6:	8a2a                	mv	s4,a0
     4b8:	89ae                	mv	s3,a1
     4ba:	8932                	mv	s2,a2
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     4bc:	00001b97          	auipc	s7,0x1
     4c0:	d4cb8b93          	addi	s7,s7,-692 # 1208 <malloc+0x152>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
     4c4:	06100c13          	li	s8,97
      panic("missing file for redirection");
    switch(tok){
     4c8:	03c00c93          	li	s9,60
  while(peek(ps, es, "<>")){
     4cc:	a00d                	j	4ee <parseredirs+0x52>
      panic("missing file for redirection");
     4ce:	00001517          	auipc	a0,0x1
     4d2:	d1a50513          	addi	a0,a0,-742 # 11e8 <malloc+0x132>
     4d6:	b75ff0ef          	jal	ra,4a <panic>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     4da:	4701                	li	a4,0
     4dc:	4681                	li	a3,0
     4de:	f9043603          	ld	a2,-112(s0)
     4e2:	f9843583          	ld	a1,-104(s0)
     4e6:	8552                	mv	a0,s4
     4e8:	d17ff0ef          	jal	ra,1fe <redircmd>
     4ec:	8a2a                	mv	s4,a0
    switch(tok){
     4ee:	03e00b13          	li	s6,62
     4f2:	02b00a93          	li	s5,43
  while(peek(ps, es, "<>")){
     4f6:	865e                	mv	a2,s7
     4f8:	85ca                	mv	a1,s2
     4fa:	854e                	mv	a0,s3
     4fc:	f3fff0ef          	jal	ra,43a <peek>
     500:	c125                	beqz	a0,560 <parseredirs+0xc4>
    tok = gettoken(ps, es, 0, 0);
     502:	4681                	li	a3,0
     504:	4601                	li	a2,0
     506:	85ca                	mv	a1,s2
     508:	854e                	mv	a0,s3
     50a:	e05ff0ef          	jal	ra,30e <gettoken>
     50e:	84aa                	mv	s1,a0
    if(gettoken(ps, es, &q, &eq) != 'a')
     510:	f9040693          	addi	a3,s0,-112
     514:	f9840613          	addi	a2,s0,-104
     518:	85ca                	mv	a1,s2
     51a:	854e                	mv	a0,s3
     51c:	df3ff0ef          	jal	ra,30e <gettoken>
     520:	fb8517e3          	bne	a0,s8,4ce <parseredirs+0x32>
    switch(tok){
     524:	fb948be3          	beq	s1,s9,4da <parseredirs+0x3e>
     528:	03648063          	beq	s1,s6,548 <parseredirs+0xac>
     52c:	fd5495e3          	bne	s1,s5,4f6 <parseredirs+0x5a>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     530:	4705                	li	a4,1
     532:	20100693          	li	a3,513
     536:	f9043603          	ld	a2,-112(s0)
     53a:	f9843583          	ld	a1,-104(s0)
     53e:	8552                	mv	a0,s4
     540:	cbfff0ef          	jal	ra,1fe <redircmd>
     544:	8a2a                	mv	s4,a0
      break;
     546:	b765                	j	4ee <parseredirs+0x52>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
     548:	4705                	li	a4,1
     54a:	60100693          	li	a3,1537
     54e:	f9043603          	ld	a2,-112(s0)
     552:	f9843583          	ld	a1,-104(s0)
     556:	8552                	mv	a0,s4
     558:	ca7ff0ef          	jal	ra,1fe <redircmd>
     55c:	8a2a                	mv	s4,a0
      break;
     55e:	bf41                	j	4ee <parseredirs+0x52>
    }
  }
  return cmd;
}
     560:	8552                	mv	a0,s4
     562:	70a6                	ld	ra,104(sp)
     564:	7406                	ld	s0,96(sp)
     566:	64e6                	ld	s1,88(sp)
     568:	6946                	ld	s2,80(sp)
     56a:	69a6                	ld	s3,72(sp)
     56c:	6a06                	ld	s4,64(sp)
     56e:	7ae2                	ld	s5,56(sp)
     570:	7b42                	ld	s6,48(sp)
     572:	7ba2                	ld	s7,40(sp)
     574:	7c02                	ld	s8,32(sp)
     576:	6ce2                	ld	s9,24(sp)
     578:	6165                	addi	sp,sp,112
     57a:	8082                	ret

000000000000057c <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     57c:	7159                	addi	sp,sp,-112
     57e:	f486                	sd	ra,104(sp)
     580:	f0a2                	sd	s0,96(sp)
     582:	eca6                	sd	s1,88(sp)
     584:	e8ca                	sd	s2,80(sp)
     586:	e4ce                	sd	s3,72(sp)
     588:	e0d2                	sd	s4,64(sp)
     58a:	fc56                	sd	s5,56(sp)
     58c:	f85a                	sd	s6,48(sp)
     58e:	f45e                	sd	s7,40(sp)
     590:	f062                	sd	s8,32(sp)
     592:	ec66                	sd	s9,24(sp)
     594:	1880                	addi	s0,sp,112
     596:	8a2a                	mv	s4,a0
     598:	8aae                	mv	s5,a1
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     59a:	00001617          	auipc	a2,0x1
     59e:	c7660613          	addi	a2,a2,-906 # 1210 <malloc+0x15a>
     5a2:	e99ff0ef          	jal	ra,43a <peek>
     5a6:	e505                	bnez	a0,5ce <parseexec+0x52>
     5a8:	89aa                	mv	s3,a0
    return parseblock(ps, es);

  ret = execcmd();
     5aa:	c27ff0ef          	jal	ra,1d0 <execcmd>
     5ae:	8c2a                	mv	s8,a0
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     5b0:	8656                	mv	a2,s5
     5b2:	85d2                	mv	a1,s4
     5b4:	ee9ff0ef          	jal	ra,49c <parseredirs>
     5b8:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     5ba:	008c0913          	addi	s2,s8,8
     5be:	00001b17          	auipc	s6,0x1
     5c2:	c72b0b13          	addi	s6,s6,-910 # 1230 <malloc+0x17a>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
    if(tok != 'a')
     5c6:	06100c93          	li	s9,97
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
     5ca:	4ba9                	li	s7,10
  while(!peek(ps, es, "|)&;")){
     5cc:	a081                	j	60c <parseexec+0x90>
    return parseblock(ps, es);
     5ce:	85d6                	mv	a1,s5
     5d0:	8552                	mv	a0,s4
     5d2:	170000ef          	jal	ra,742 <parseblock>
     5d6:	84aa                	mv	s1,a0
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     5d8:	8526                	mv	a0,s1
     5da:	70a6                	ld	ra,104(sp)
     5dc:	7406                	ld	s0,96(sp)
     5de:	64e6                	ld	s1,88(sp)
     5e0:	6946                	ld	s2,80(sp)
     5e2:	69a6                	ld	s3,72(sp)
     5e4:	6a06                	ld	s4,64(sp)
     5e6:	7ae2                	ld	s5,56(sp)
     5e8:	7b42                	ld	s6,48(sp)
     5ea:	7ba2                	ld	s7,40(sp)
     5ec:	7c02                	ld	s8,32(sp)
     5ee:	6ce2                	ld	s9,24(sp)
     5f0:	6165                	addi	sp,sp,112
     5f2:	8082                	ret
      panic("syntax");
     5f4:	00001517          	auipc	a0,0x1
     5f8:	c2450513          	addi	a0,a0,-988 # 1218 <malloc+0x162>
     5fc:	a4fff0ef          	jal	ra,4a <panic>
    ret = parseredirs(ret, ps, es);
     600:	8656                	mv	a2,s5
     602:	85d2                	mv	a1,s4
     604:	8526                	mv	a0,s1
     606:	e97ff0ef          	jal	ra,49c <parseredirs>
     60a:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     60c:	865a                	mv	a2,s6
     60e:	85d6                	mv	a1,s5
     610:	8552                	mv	a0,s4
     612:	e29ff0ef          	jal	ra,43a <peek>
     616:	ed15                	bnez	a0,652 <parseexec+0xd6>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     618:	f9040693          	addi	a3,s0,-112
     61c:	f9840613          	addi	a2,s0,-104
     620:	85d6                	mv	a1,s5
     622:	8552                	mv	a0,s4
     624:	cebff0ef          	jal	ra,30e <gettoken>
     628:	c50d                	beqz	a0,652 <parseexec+0xd6>
    if(tok != 'a')
     62a:	fd9515e3          	bne	a0,s9,5f4 <parseexec+0x78>
    cmd->argv[argc] = q;
     62e:	f9843783          	ld	a5,-104(s0)
     632:	00f93023          	sd	a5,0(s2)
    cmd->eargv[argc] = eq;
     636:	f9043783          	ld	a5,-112(s0)
     63a:	04f93823          	sd	a5,80(s2)
    argc++;
     63e:	2985                	addiw	s3,s3,1
    if(argc >= MAXARGS)
     640:	0921                	addi	s2,s2,8
     642:	fb799fe3          	bne	s3,s7,600 <parseexec+0x84>
      panic("too many args");
     646:	00001517          	auipc	a0,0x1
     64a:	bda50513          	addi	a0,a0,-1062 # 1220 <malloc+0x16a>
     64e:	9fdff0ef          	jal	ra,4a <panic>
  cmd->argv[argc] = 0;
     652:	098e                	slli	s3,s3,0x3
     654:	99e2                	add	s3,s3,s8
     656:	0009b423          	sd	zero,8(s3)
  cmd->eargv[argc] = 0;
     65a:	0409bc23          	sd	zero,88(s3)
  return ret;
     65e:	bfad                	j	5d8 <parseexec+0x5c>

0000000000000660 <parsepipe>:
{
     660:	7179                	addi	sp,sp,-48
     662:	f406                	sd	ra,40(sp)
     664:	f022                	sd	s0,32(sp)
     666:	ec26                	sd	s1,24(sp)
     668:	e84a                	sd	s2,16(sp)
     66a:	e44e                	sd	s3,8(sp)
     66c:	1800                	addi	s0,sp,48
     66e:	892a                	mv	s2,a0
     670:	89ae                	mv	s3,a1
  cmd = parseexec(ps, es);
     672:	f0bff0ef          	jal	ra,57c <parseexec>
     676:	84aa                	mv	s1,a0
  if(peek(ps, es, "|")){
     678:	00001617          	auipc	a2,0x1
     67c:	bc060613          	addi	a2,a2,-1088 # 1238 <malloc+0x182>
     680:	85ce                	mv	a1,s3
     682:	854a                	mv	a0,s2
     684:	db7ff0ef          	jal	ra,43a <peek>
     688:	e909                	bnez	a0,69a <parsepipe+0x3a>
}
     68a:	8526                	mv	a0,s1
     68c:	70a2                	ld	ra,40(sp)
     68e:	7402                	ld	s0,32(sp)
     690:	64e2                	ld	s1,24(sp)
     692:	6942                	ld	s2,16(sp)
     694:	69a2                	ld	s3,8(sp)
     696:	6145                	addi	sp,sp,48
     698:	8082                	ret
    gettoken(ps, es, 0, 0);
     69a:	4681                	li	a3,0
     69c:	4601                	li	a2,0
     69e:	85ce                	mv	a1,s3
     6a0:	854a                	mv	a0,s2
     6a2:	c6dff0ef          	jal	ra,30e <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     6a6:	85ce                	mv	a1,s3
     6a8:	854a                	mv	a0,s2
     6aa:	fb7ff0ef          	jal	ra,660 <parsepipe>
     6ae:	85aa                	mv	a1,a0
     6b0:	8526                	mv	a0,s1
     6b2:	badff0ef          	jal	ra,25e <pipecmd>
     6b6:	84aa                	mv	s1,a0
  return cmd;
     6b8:	bfc9                	j	68a <parsepipe+0x2a>

00000000000006ba <parseline>:
{
     6ba:	7179                	addi	sp,sp,-48
     6bc:	f406                	sd	ra,40(sp)
     6be:	f022                	sd	s0,32(sp)
     6c0:	ec26                	sd	s1,24(sp)
     6c2:	e84a                	sd	s2,16(sp)
     6c4:	e44e                	sd	s3,8(sp)
     6c6:	e052                	sd	s4,0(sp)
     6c8:	1800                	addi	s0,sp,48
     6ca:	892a                	mv	s2,a0
     6cc:	89ae                	mv	s3,a1
  cmd = parsepipe(ps, es);
     6ce:	f93ff0ef          	jal	ra,660 <parsepipe>
     6d2:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     6d4:	00001a17          	auipc	s4,0x1
     6d8:	b6ca0a13          	addi	s4,s4,-1172 # 1240 <malloc+0x18a>
     6dc:	a819                	j	6f2 <parseline+0x38>
    gettoken(ps, es, 0, 0);
     6de:	4681                	li	a3,0
     6e0:	4601                	li	a2,0
     6e2:	85ce                	mv	a1,s3
     6e4:	854a                	mv	a0,s2
     6e6:	c29ff0ef          	jal	ra,30e <gettoken>
    cmd = backcmd(cmd);
     6ea:	8526                	mv	a0,s1
     6ec:	befff0ef          	jal	ra,2da <backcmd>
     6f0:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     6f2:	8652                	mv	a2,s4
     6f4:	85ce                	mv	a1,s3
     6f6:	854a                	mv	a0,s2
     6f8:	d43ff0ef          	jal	ra,43a <peek>
     6fc:	f16d                	bnez	a0,6de <parseline+0x24>
  if(peek(ps, es, ";")){
     6fe:	00001617          	auipc	a2,0x1
     702:	b4a60613          	addi	a2,a2,-1206 # 1248 <malloc+0x192>
     706:	85ce                	mv	a1,s3
     708:	854a                	mv	a0,s2
     70a:	d31ff0ef          	jal	ra,43a <peek>
     70e:	e911                	bnez	a0,722 <parseline+0x68>
}
     710:	8526                	mv	a0,s1
     712:	70a2                	ld	ra,40(sp)
     714:	7402                	ld	s0,32(sp)
     716:	64e2                	ld	s1,24(sp)
     718:	6942                	ld	s2,16(sp)
     71a:	69a2                	ld	s3,8(sp)
     71c:	6a02                	ld	s4,0(sp)
     71e:	6145                	addi	sp,sp,48
     720:	8082                	ret
    gettoken(ps, es, 0, 0);
     722:	4681                	li	a3,0
     724:	4601                	li	a2,0
     726:	85ce                	mv	a1,s3
     728:	854a                	mv	a0,s2
     72a:	be5ff0ef          	jal	ra,30e <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     72e:	85ce                	mv	a1,s3
     730:	854a                	mv	a0,s2
     732:	f89ff0ef          	jal	ra,6ba <parseline>
     736:	85aa                	mv	a1,a0
     738:	8526                	mv	a0,s1
     73a:	b63ff0ef          	jal	ra,29c <listcmd>
     73e:	84aa                	mv	s1,a0
  return cmd;
     740:	bfc1                	j	710 <parseline+0x56>

0000000000000742 <parseblock>:
{
     742:	7179                	addi	sp,sp,-48
     744:	f406                	sd	ra,40(sp)
     746:	f022                	sd	s0,32(sp)
     748:	ec26                	sd	s1,24(sp)
     74a:	e84a                	sd	s2,16(sp)
     74c:	e44e                	sd	s3,8(sp)
     74e:	1800                	addi	s0,sp,48
     750:	84aa                	mv	s1,a0
     752:	892e                	mv	s2,a1
  if(!peek(ps, es, "("))
     754:	00001617          	auipc	a2,0x1
     758:	abc60613          	addi	a2,a2,-1348 # 1210 <malloc+0x15a>
     75c:	cdfff0ef          	jal	ra,43a <peek>
     760:	c539                	beqz	a0,7ae <parseblock+0x6c>
  gettoken(ps, es, 0, 0);
     762:	4681                	li	a3,0
     764:	4601                	li	a2,0
     766:	85ca                	mv	a1,s2
     768:	8526                	mv	a0,s1
     76a:	ba5ff0ef          	jal	ra,30e <gettoken>
  cmd = parseline(ps, es);
     76e:	85ca                	mv	a1,s2
     770:	8526                	mv	a0,s1
     772:	f49ff0ef          	jal	ra,6ba <parseline>
     776:	89aa                	mv	s3,a0
  if(!peek(ps, es, ")"))
     778:	00001617          	auipc	a2,0x1
     77c:	ae860613          	addi	a2,a2,-1304 # 1260 <malloc+0x1aa>
     780:	85ca                	mv	a1,s2
     782:	8526                	mv	a0,s1
     784:	cb7ff0ef          	jal	ra,43a <peek>
     788:	c90d                	beqz	a0,7ba <parseblock+0x78>
  gettoken(ps, es, 0, 0);
     78a:	4681                	li	a3,0
     78c:	4601                	li	a2,0
     78e:	85ca                	mv	a1,s2
     790:	8526                	mv	a0,s1
     792:	b7dff0ef          	jal	ra,30e <gettoken>
  cmd = parseredirs(cmd, ps, es);
     796:	864a                	mv	a2,s2
     798:	85a6                	mv	a1,s1
     79a:	854e                	mv	a0,s3
     79c:	d01ff0ef          	jal	ra,49c <parseredirs>
}
     7a0:	70a2                	ld	ra,40(sp)
     7a2:	7402                	ld	s0,32(sp)
     7a4:	64e2                	ld	s1,24(sp)
     7a6:	6942                	ld	s2,16(sp)
     7a8:	69a2                	ld	s3,8(sp)
     7aa:	6145                	addi	sp,sp,48
     7ac:	8082                	ret
    panic("parseblock");
     7ae:	00001517          	auipc	a0,0x1
     7b2:	aa250513          	addi	a0,a0,-1374 # 1250 <malloc+0x19a>
     7b6:	895ff0ef          	jal	ra,4a <panic>
    panic("syntax - missing )");
     7ba:	00001517          	auipc	a0,0x1
     7be:	aae50513          	addi	a0,a0,-1362 # 1268 <malloc+0x1b2>
     7c2:	889ff0ef          	jal	ra,4a <panic>

00000000000007c6 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     7c6:	1101                	addi	sp,sp,-32
     7c8:	ec06                	sd	ra,24(sp)
     7ca:	e822                	sd	s0,16(sp)
     7cc:	e426                	sd	s1,8(sp)
     7ce:	1000                	addi	s0,sp,32
     7d0:	84aa                	mv	s1,a0
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     7d2:	c131                	beqz	a0,816 <nulterminate+0x50>
    return 0;

  switch(cmd->type){
     7d4:	4118                	lw	a4,0(a0)
     7d6:	4795                	li	a5,5
     7d8:	02e7ef63          	bltu	a5,a4,816 <nulterminate+0x50>
     7dc:	00056783          	lwu	a5,0(a0)
     7e0:	078a                	slli	a5,a5,0x2
     7e2:	00001717          	auipc	a4,0x1
     7e6:	ae670713          	addi	a4,a4,-1306 # 12c8 <malloc+0x212>
     7ea:	97ba                	add	a5,a5,a4
     7ec:	439c                	lw	a5,0(a5)
     7ee:	97ba                	add	a5,a5,a4
     7f0:	8782                	jr	a5
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     7f2:	651c                	ld	a5,8(a0)
     7f4:	c38d                	beqz	a5,816 <nulterminate+0x50>
     7f6:	01050793          	addi	a5,a0,16
      *ecmd->eargv[i] = 0;
     7fa:	67b8                	ld	a4,72(a5)
     7fc:	00070023          	sb	zero,0(a4)
    for(i=0; ecmd->argv[i]; i++)
     800:	07a1                	addi	a5,a5,8
     802:	ff87b703          	ld	a4,-8(a5)
     806:	fb75                	bnez	a4,7fa <nulterminate+0x34>
     808:	a039                	j	816 <nulterminate+0x50>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
     80a:	6508                	ld	a0,8(a0)
     80c:	fbbff0ef          	jal	ra,7c6 <nulterminate>
    *rcmd->efile = 0;
     810:	6c9c                	ld	a5,24(s1)
     812:	00078023          	sb	zero,0(a5)
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     816:	8526                	mv	a0,s1
     818:	60e2                	ld	ra,24(sp)
     81a:	6442                	ld	s0,16(sp)
     81c:	64a2                	ld	s1,8(sp)
     81e:	6105                	addi	sp,sp,32
     820:	8082                	ret
    nulterminate(pcmd->left);
     822:	6508                	ld	a0,8(a0)
     824:	fa3ff0ef          	jal	ra,7c6 <nulterminate>
    nulterminate(pcmd->right);
     828:	6888                	ld	a0,16(s1)
     82a:	f9dff0ef          	jal	ra,7c6 <nulterminate>
    break;
     82e:	b7e5                	j	816 <nulterminate+0x50>
    nulterminate(lcmd->left);
     830:	6508                	ld	a0,8(a0)
     832:	f95ff0ef          	jal	ra,7c6 <nulterminate>
    nulterminate(lcmd->right);
     836:	6888                	ld	a0,16(s1)
     838:	f8fff0ef          	jal	ra,7c6 <nulterminate>
    break;
     83c:	bfe9                	j	816 <nulterminate+0x50>
    nulterminate(bcmd->cmd);
     83e:	6508                	ld	a0,8(a0)
     840:	f87ff0ef          	jal	ra,7c6 <nulterminate>
    break;
     844:	bfc9                	j	816 <nulterminate+0x50>

0000000000000846 <parsecmd>:
{
     846:	7179                	addi	sp,sp,-48
     848:	f406                	sd	ra,40(sp)
     84a:	f022                	sd	s0,32(sp)
     84c:	ec26                	sd	s1,24(sp)
     84e:	e84a                	sd	s2,16(sp)
     850:	1800                	addi	s0,sp,48
     852:	fca43c23          	sd	a0,-40(s0)
  es = s + strlen(s);
     856:	84aa                	mv	s1,a0
     858:	180000ef          	jal	ra,9d8 <strlen>
     85c:	1502                	slli	a0,a0,0x20
     85e:	9101                	srli	a0,a0,0x20
     860:	94aa                	add	s1,s1,a0
  cmd = parseline(&s, es);
     862:	85a6                	mv	a1,s1
     864:	fd840513          	addi	a0,s0,-40
     868:	e53ff0ef          	jal	ra,6ba <parseline>
     86c:	892a                	mv	s2,a0
  peek(&s, es, "");
     86e:	00001617          	auipc	a2,0x1
     872:	a1260613          	addi	a2,a2,-1518 # 1280 <malloc+0x1ca>
     876:	85a6                	mv	a1,s1
     878:	fd840513          	addi	a0,s0,-40
     87c:	bbfff0ef          	jal	ra,43a <peek>
  if(s != es){
     880:	fd843603          	ld	a2,-40(s0)
     884:	00961c63          	bne	a2,s1,89c <parsecmd+0x56>
  nulterminate(cmd);
     888:	854a                	mv	a0,s2
     88a:	f3dff0ef          	jal	ra,7c6 <nulterminate>
}
     88e:	854a                	mv	a0,s2
     890:	70a2                	ld	ra,40(sp)
     892:	7402                	ld	s0,32(sp)
     894:	64e2                	ld	s1,24(sp)
     896:	6942                	ld	s2,16(sp)
     898:	6145                	addi	sp,sp,48
     89a:	8082                	ret
    fprintf(2, "leftovers: %s\n", s);
     89c:	00001597          	auipc	a1,0x1
     8a0:	9ec58593          	addi	a1,a1,-1556 # 1288 <malloc+0x1d2>
     8a4:	4509                	li	a0,2
     8a6:	72c000ef          	jal	ra,fd2 <fprintf>
    panic("syntax");
     8aa:	00001517          	auipc	a0,0x1
     8ae:	96e50513          	addi	a0,a0,-1682 # 1218 <malloc+0x162>
     8b2:	f98ff0ef          	jal	ra,4a <panic>

00000000000008b6 <main>:
{
     8b6:	7139                	addi	sp,sp,-64
     8b8:	fc06                	sd	ra,56(sp)
     8ba:	f822                	sd	s0,48(sp)
     8bc:	f426                	sd	s1,40(sp)
     8be:	f04a                	sd	s2,32(sp)
     8c0:	ec4e                	sd	s3,24(sp)
     8c2:	e852                	sd	s4,16(sp)
     8c4:	e456                	sd	s5,8(sp)
     8c6:	0080                	addi	s0,sp,64
  while((fd = open("console", O_RDWR)) >= 0){
     8c8:	00001497          	auipc	s1,0x1
     8cc:	9d048493          	addi	s1,s1,-1584 # 1298 <malloc+0x1e2>
     8d0:	4589                	li	a1,2
     8d2:	8526                	mv	a0,s1
     8d4:	356000ef          	jal	ra,c2a <open>
     8d8:	00054763          	bltz	a0,8e6 <main+0x30>
    if(fd >= 3){
     8dc:	4789                	li	a5,2
     8de:	fea7d9e3          	bge	a5,a0,8d0 <main+0x1a>
      close(fd);
     8e2:	330000ef          	jal	ra,c12 <close>
  while(getcmd(buf, sizeof(buf)) >= 0){
     8e6:	00001497          	auipc	s1,0x1
     8ea:	73a48493          	addi	s1,s1,1850 # 2020 <buf.0>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     8ee:	06300913          	li	s2,99
     8f2:	02000993          	li	s3,32
      if(chdir(buf+3) < 0)
     8f6:	00001a17          	auipc	s4,0x1
     8fa:	72da0a13          	addi	s4,s4,1837 # 2023 <buf.0+0x3>
        fprintf(2, "cannot cd %s\n", buf+3);
     8fe:	00001a97          	auipc	s5,0x1
     902:	9a2a8a93          	addi	s5,s5,-1630 # 12a0 <malloc+0x1ea>
     906:	a039                	j	914 <main+0x5e>
    if(fork1() == 0)
     908:	f60ff0ef          	jal	ra,68 <fork1>
     90c:	cd31                	beqz	a0,968 <main+0xb2>
    wait(0);
     90e:	4501                	li	a0,0
     910:	2e2000ef          	jal	ra,bf2 <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
     914:	06400593          	li	a1,100
     918:	8526                	mv	a0,s1
     91a:	ee6ff0ef          	jal	ra,0 <getcmd>
     91e:	04054d63          	bltz	a0,978 <main+0xc2>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     922:	0004c783          	lbu	a5,0(s1)
     926:	ff2791e3          	bne	a5,s2,908 <main+0x52>
     92a:	0014c703          	lbu	a4,1(s1)
     92e:	06400793          	li	a5,100
     932:	fcf71be3          	bne	a4,a5,908 <main+0x52>
     936:	0024c783          	lbu	a5,2(s1)
     93a:	fd3797e3          	bne	a5,s3,908 <main+0x52>
      buf[strlen(buf)-1] = 0;  // chop \n
     93e:	8526                	mv	a0,s1
     940:	098000ef          	jal	ra,9d8 <strlen>
     944:	fff5079b          	addiw	a5,a0,-1
     948:	1782                	slli	a5,a5,0x20
     94a:	9381                	srli	a5,a5,0x20
     94c:	97a6                	add	a5,a5,s1
     94e:	00078023          	sb	zero,0(a5)
      if(chdir(buf+3) < 0)
     952:	8552                	mv	a0,s4
     954:	306000ef          	jal	ra,c5a <chdir>
     958:	fa055ee3          	bgez	a0,914 <main+0x5e>
        fprintf(2, "cannot cd %s\n", buf+3);
     95c:	8652                	mv	a2,s4
     95e:	85d6                	mv	a1,s5
     960:	4509                	li	a0,2
     962:	670000ef          	jal	ra,fd2 <fprintf>
     966:	b77d                	j	914 <main+0x5e>
      runcmd(parsecmd(buf));
     968:	00001517          	auipc	a0,0x1
     96c:	6b850513          	addi	a0,a0,1720 # 2020 <buf.0>
     970:	ed7ff0ef          	jal	ra,846 <parsecmd>
     974:	f1aff0ef          	jal	ra,8e <runcmd>
  exit(0);
     978:	4501                	li	a0,0
     97a:	270000ef          	jal	ra,bea <exit>

000000000000097e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
     97e:	1141                	addi	sp,sp,-16
     980:	e406                	sd	ra,8(sp)
     982:	e022                	sd	s0,0(sp)
     984:	0800                	addi	s0,sp,16
  extern int main();
  main();
     986:	f31ff0ef          	jal	ra,8b6 <main>
  exit(0);
     98a:	4501                	li	a0,0
     98c:	25e000ef          	jal	ra,bea <exit>

0000000000000990 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     990:	1141                	addi	sp,sp,-16
     992:	e422                	sd	s0,8(sp)
     994:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     996:	87aa                	mv	a5,a0
     998:	0585                	addi	a1,a1,1
     99a:	0785                	addi	a5,a5,1
     99c:	fff5c703          	lbu	a4,-1(a1)
     9a0:	fee78fa3          	sb	a4,-1(a5)
     9a4:	fb75                	bnez	a4,998 <strcpy+0x8>
    ;
  return os;
}
     9a6:	6422                	ld	s0,8(sp)
     9a8:	0141                	addi	sp,sp,16
     9aa:	8082                	ret

00000000000009ac <strcmp>:

int
strcmp(const char *p, const char *q)
{
     9ac:	1141                	addi	sp,sp,-16
     9ae:	e422                	sd	s0,8(sp)
     9b0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     9b2:	00054783          	lbu	a5,0(a0)
     9b6:	cb91                	beqz	a5,9ca <strcmp+0x1e>
     9b8:	0005c703          	lbu	a4,0(a1)
     9bc:	00f71763          	bne	a4,a5,9ca <strcmp+0x1e>
    p++, q++;
     9c0:	0505                	addi	a0,a0,1
     9c2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     9c4:	00054783          	lbu	a5,0(a0)
     9c8:	fbe5                	bnez	a5,9b8 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     9ca:	0005c503          	lbu	a0,0(a1)
}
     9ce:	40a7853b          	subw	a0,a5,a0
     9d2:	6422                	ld	s0,8(sp)
     9d4:	0141                	addi	sp,sp,16
     9d6:	8082                	ret

00000000000009d8 <strlen>:

uint
strlen(const char *s)
{
     9d8:	1141                	addi	sp,sp,-16
     9da:	e422                	sd	s0,8(sp)
     9dc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     9de:	00054783          	lbu	a5,0(a0)
     9e2:	cf91                	beqz	a5,9fe <strlen+0x26>
     9e4:	0505                	addi	a0,a0,1
     9e6:	87aa                	mv	a5,a0
     9e8:	4685                	li	a3,1
     9ea:	9e89                	subw	a3,a3,a0
     9ec:	00f6853b          	addw	a0,a3,a5
     9f0:	0785                	addi	a5,a5,1
     9f2:	fff7c703          	lbu	a4,-1(a5)
     9f6:	fb7d                	bnez	a4,9ec <strlen+0x14>
    ;
  return n;
}
     9f8:	6422                	ld	s0,8(sp)
     9fa:	0141                	addi	sp,sp,16
     9fc:	8082                	ret
  for(n = 0; s[n]; n++)
     9fe:	4501                	li	a0,0
     a00:	bfe5                	j	9f8 <strlen+0x20>

0000000000000a02 <memset>:

void*
memset(void *dst, int c, uint n)
{
     a02:	1141                	addi	sp,sp,-16
     a04:	e422                	sd	s0,8(sp)
     a06:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     a08:	ca19                	beqz	a2,a1e <memset+0x1c>
     a0a:	87aa                	mv	a5,a0
     a0c:	1602                	slli	a2,a2,0x20
     a0e:	9201                	srli	a2,a2,0x20
     a10:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     a14:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     a18:	0785                	addi	a5,a5,1
     a1a:	fee79de3          	bne	a5,a4,a14 <memset+0x12>
  }
  return dst;
}
     a1e:	6422                	ld	s0,8(sp)
     a20:	0141                	addi	sp,sp,16
     a22:	8082                	ret

0000000000000a24 <strchr>:

char*
strchr(const char *s, char c)
{
     a24:	1141                	addi	sp,sp,-16
     a26:	e422                	sd	s0,8(sp)
     a28:	0800                	addi	s0,sp,16
  for(; *s; s++)
     a2a:	00054783          	lbu	a5,0(a0)
     a2e:	cb99                	beqz	a5,a44 <strchr+0x20>
    if(*s == c)
     a30:	00f58763          	beq	a1,a5,a3e <strchr+0x1a>
  for(; *s; s++)
     a34:	0505                	addi	a0,a0,1
     a36:	00054783          	lbu	a5,0(a0)
     a3a:	fbfd                	bnez	a5,a30 <strchr+0xc>
      return (char*)s;
  return 0;
     a3c:	4501                	li	a0,0
}
     a3e:	6422                	ld	s0,8(sp)
     a40:	0141                	addi	sp,sp,16
     a42:	8082                	ret
  return 0;
     a44:	4501                	li	a0,0
     a46:	bfe5                	j	a3e <strchr+0x1a>

0000000000000a48 <gets>:

char*
gets(char *buf, int max)
{
     a48:	711d                	addi	sp,sp,-96
     a4a:	ec86                	sd	ra,88(sp)
     a4c:	e8a2                	sd	s0,80(sp)
     a4e:	e4a6                	sd	s1,72(sp)
     a50:	e0ca                	sd	s2,64(sp)
     a52:	fc4e                	sd	s3,56(sp)
     a54:	f852                	sd	s4,48(sp)
     a56:	f456                	sd	s5,40(sp)
     a58:	f05a                	sd	s6,32(sp)
     a5a:	ec5e                	sd	s7,24(sp)
     a5c:	1080                	addi	s0,sp,96
     a5e:	8baa                	mv	s7,a0
     a60:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     a62:	892a                	mv	s2,a0
     a64:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     a66:	4aa9                	li	s5,10
     a68:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     a6a:	89a6                	mv	s3,s1
     a6c:	2485                	addiw	s1,s1,1
     a6e:	0344d663          	bge	s1,s4,a9a <gets+0x52>
    cc = read(0, &c, 1);
     a72:	4605                	li	a2,1
     a74:	faf40593          	addi	a1,s0,-81
     a78:	4501                	li	a0,0
     a7a:	188000ef          	jal	ra,c02 <read>
    if(cc < 1)
     a7e:	00a05e63          	blez	a0,a9a <gets+0x52>
    buf[i++] = c;
     a82:	faf44783          	lbu	a5,-81(s0)
     a86:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     a8a:	01578763          	beq	a5,s5,a98 <gets+0x50>
     a8e:	0905                	addi	s2,s2,1
     a90:	fd679de3          	bne	a5,s6,a6a <gets+0x22>
  for(i=0; i+1 < max; ){
     a94:	89a6                	mv	s3,s1
     a96:	a011                	j	a9a <gets+0x52>
     a98:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     a9a:	99de                	add	s3,s3,s7
     a9c:	00098023          	sb	zero,0(s3)
  return buf;
}
     aa0:	855e                	mv	a0,s7
     aa2:	60e6                	ld	ra,88(sp)
     aa4:	6446                	ld	s0,80(sp)
     aa6:	64a6                	ld	s1,72(sp)
     aa8:	6906                	ld	s2,64(sp)
     aaa:	79e2                	ld	s3,56(sp)
     aac:	7a42                	ld	s4,48(sp)
     aae:	7aa2                	ld	s5,40(sp)
     ab0:	7b02                	ld	s6,32(sp)
     ab2:	6be2                	ld	s7,24(sp)
     ab4:	6125                	addi	sp,sp,96
     ab6:	8082                	ret

0000000000000ab8 <stat>:

int
stat(const char *n, struct stat *st)
{
     ab8:	1101                	addi	sp,sp,-32
     aba:	ec06                	sd	ra,24(sp)
     abc:	e822                	sd	s0,16(sp)
     abe:	e426                	sd	s1,8(sp)
     ac0:	e04a                	sd	s2,0(sp)
     ac2:	1000                	addi	s0,sp,32
     ac4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     ac6:	4581                	li	a1,0
     ac8:	162000ef          	jal	ra,c2a <open>
  if(fd < 0)
     acc:	02054163          	bltz	a0,aee <stat+0x36>
     ad0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     ad2:	85ca                	mv	a1,s2
     ad4:	16e000ef          	jal	ra,c42 <fstat>
     ad8:	892a                	mv	s2,a0
  close(fd);
     ada:	8526                	mv	a0,s1
     adc:	136000ef          	jal	ra,c12 <close>
  return r;
}
     ae0:	854a                	mv	a0,s2
     ae2:	60e2                	ld	ra,24(sp)
     ae4:	6442                	ld	s0,16(sp)
     ae6:	64a2                	ld	s1,8(sp)
     ae8:	6902                	ld	s2,0(sp)
     aea:	6105                	addi	sp,sp,32
     aec:	8082                	ret
    return -1;
     aee:	597d                	li	s2,-1
     af0:	bfc5                	j	ae0 <stat+0x28>

0000000000000af2 <atoi>:

int
atoi(const char *s)
{
     af2:	1141                	addi	sp,sp,-16
     af4:	e422                	sd	s0,8(sp)
     af6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     af8:	00054603          	lbu	a2,0(a0)
     afc:	fd06079b          	addiw	a5,a2,-48
     b00:	0ff7f793          	andi	a5,a5,255
     b04:	4725                	li	a4,9
     b06:	02f76963          	bltu	a4,a5,b38 <atoi+0x46>
     b0a:	86aa                	mv	a3,a0
  n = 0;
     b0c:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
     b0e:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
     b10:	0685                	addi	a3,a3,1
     b12:	0025179b          	slliw	a5,a0,0x2
     b16:	9fa9                	addw	a5,a5,a0
     b18:	0017979b          	slliw	a5,a5,0x1
     b1c:	9fb1                	addw	a5,a5,a2
     b1e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     b22:	0006c603          	lbu	a2,0(a3)
     b26:	fd06071b          	addiw	a4,a2,-48
     b2a:	0ff77713          	andi	a4,a4,255
     b2e:	fee5f1e3          	bgeu	a1,a4,b10 <atoi+0x1e>
  return n;
}
     b32:	6422                	ld	s0,8(sp)
     b34:	0141                	addi	sp,sp,16
     b36:	8082                	ret
  n = 0;
     b38:	4501                	li	a0,0
     b3a:	bfe5                	j	b32 <atoi+0x40>

0000000000000b3c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     b3c:	1141                	addi	sp,sp,-16
     b3e:	e422                	sd	s0,8(sp)
     b40:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     b42:	02b57463          	bgeu	a0,a1,b6a <memmove+0x2e>
    while(n-- > 0)
     b46:	00c05f63          	blez	a2,b64 <memmove+0x28>
     b4a:	1602                	slli	a2,a2,0x20
     b4c:	9201                	srli	a2,a2,0x20
     b4e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     b52:	872a                	mv	a4,a0
      *dst++ = *src++;
     b54:	0585                	addi	a1,a1,1
     b56:	0705                	addi	a4,a4,1
     b58:	fff5c683          	lbu	a3,-1(a1)
     b5c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     b60:	fee79ae3          	bne	a5,a4,b54 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     b64:	6422                	ld	s0,8(sp)
     b66:	0141                	addi	sp,sp,16
     b68:	8082                	ret
    dst += n;
     b6a:	00c50733          	add	a4,a0,a2
    src += n;
     b6e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     b70:	fec05ae3          	blez	a2,b64 <memmove+0x28>
     b74:	fff6079b          	addiw	a5,a2,-1
     b78:	1782                	slli	a5,a5,0x20
     b7a:	9381                	srli	a5,a5,0x20
     b7c:	fff7c793          	not	a5,a5
     b80:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     b82:	15fd                	addi	a1,a1,-1
     b84:	177d                	addi	a4,a4,-1
     b86:	0005c683          	lbu	a3,0(a1)
     b8a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     b8e:	fee79ae3          	bne	a5,a4,b82 <memmove+0x46>
     b92:	bfc9                	j	b64 <memmove+0x28>

0000000000000b94 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     b94:	1141                	addi	sp,sp,-16
     b96:	e422                	sd	s0,8(sp)
     b98:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     b9a:	ca05                	beqz	a2,bca <memcmp+0x36>
     b9c:	fff6069b          	addiw	a3,a2,-1
     ba0:	1682                	slli	a3,a3,0x20
     ba2:	9281                	srli	a3,a3,0x20
     ba4:	0685                	addi	a3,a3,1
     ba6:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     ba8:	00054783          	lbu	a5,0(a0)
     bac:	0005c703          	lbu	a4,0(a1)
     bb0:	00e79863          	bne	a5,a4,bc0 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     bb4:	0505                	addi	a0,a0,1
    p2++;
     bb6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     bb8:	fed518e3          	bne	a0,a3,ba8 <memcmp+0x14>
  }
  return 0;
     bbc:	4501                	li	a0,0
     bbe:	a019                	j	bc4 <memcmp+0x30>
      return *p1 - *p2;
     bc0:	40e7853b          	subw	a0,a5,a4
}
     bc4:	6422                	ld	s0,8(sp)
     bc6:	0141                	addi	sp,sp,16
     bc8:	8082                	ret
  return 0;
     bca:	4501                	li	a0,0
     bcc:	bfe5                	j	bc4 <memcmp+0x30>

0000000000000bce <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     bce:	1141                	addi	sp,sp,-16
     bd0:	e406                	sd	ra,8(sp)
     bd2:	e022                	sd	s0,0(sp)
     bd4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     bd6:	f67ff0ef          	jal	ra,b3c <memmove>
}
     bda:	60a2                	ld	ra,8(sp)
     bdc:	6402                	ld	s0,0(sp)
     bde:	0141                	addi	sp,sp,16
     be0:	8082                	ret

0000000000000be2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     be2:	4885                	li	a7,1
 ecall
     be4:	00000073          	ecall
 ret
     be8:	8082                	ret

0000000000000bea <exit>:
.global exit
exit:
 li a7, SYS_exit
     bea:	4889                	li	a7,2
 ecall
     bec:	00000073          	ecall
 ret
     bf0:	8082                	ret

0000000000000bf2 <wait>:
.global wait
wait:
 li a7, SYS_wait
     bf2:	488d                	li	a7,3
 ecall
     bf4:	00000073          	ecall
 ret
     bf8:	8082                	ret

0000000000000bfa <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     bfa:	4891                	li	a7,4
 ecall
     bfc:	00000073          	ecall
 ret
     c00:	8082                	ret

0000000000000c02 <read>:
.global read
read:
 li a7, SYS_read
     c02:	4895                	li	a7,5
 ecall
     c04:	00000073          	ecall
 ret
     c08:	8082                	ret

0000000000000c0a <write>:
.global write
write:
 li a7, SYS_write
     c0a:	48c1                	li	a7,16
 ecall
     c0c:	00000073          	ecall
 ret
     c10:	8082                	ret

0000000000000c12 <close>:
.global close
close:
 li a7, SYS_close
     c12:	48d5                	li	a7,21
 ecall
     c14:	00000073          	ecall
 ret
     c18:	8082                	ret

0000000000000c1a <kill>:
.global kill
kill:
 li a7, SYS_kill
     c1a:	4899                	li	a7,6
 ecall
     c1c:	00000073          	ecall
 ret
     c20:	8082                	ret

0000000000000c22 <exec>:
.global exec
exec:
 li a7, SYS_exec
     c22:	489d                	li	a7,7
 ecall
     c24:	00000073          	ecall
 ret
     c28:	8082                	ret

0000000000000c2a <open>:
.global open
open:
 li a7, SYS_open
     c2a:	48bd                	li	a7,15
 ecall
     c2c:	00000073          	ecall
 ret
     c30:	8082                	ret

0000000000000c32 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     c32:	48c5                	li	a7,17
 ecall
     c34:	00000073          	ecall
 ret
     c38:	8082                	ret

0000000000000c3a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     c3a:	48c9                	li	a7,18
 ecall
     c3c:	00000073          	ecall
 ret
     c40:	8082                	ret

0000000000000c42 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     c42:	48a1                	li	a7,8
 ecall
     c44:	00000073          	ecall
 ret
     c48:	8082                	ret

0000000000000c4a <link>:
.global link
link:
 li a7, SYS_link
     c4a:	48cd                	li	a7,19
 ecall
     c4c:	00000073          	ecall
 ret
     c50:	8082                	ret

0000000000000c52 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     c52:	48d1                	li	a7,20
 ecall
     c54:	00000073          	ecall
 ret
     c58:	8082                	ret

0000000000000c5a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     c5a:	48a5                	li	a7,9
 ecall
     c5c:	00000073          	ecall
 ret
     c60:	8082                	ret

0000000000000c62 <dup>:
.global dup
dup:
 li a7, SYS_dup
     c62:	48a9                	li	a7,10
 ecall
     c64:	00000073          	ecall
 ret
     c68:	8082                	ret

0000000000000c6a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     c6a:	48ad                	li	a7,11
 ecall
     c6c:	00000073          	ecall
 ret
     c70:	8082                	ret

0000000000000c72 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     c72:	48b1                	li	a7,12
 ecall
     c74:	00000073          	ecall
 ret
     c78:	8082                	ret

0000000000000c7a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     c7a:	48b5                	li	a7,13
 ecall
     c7c:	00000073          	ecall
 ret
     c80:	8082                	ret

0000000000000c82 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     c82:	48b9                	li	a7,14
 ecall
     c84:	00000073          	ecall
 ret
     c88:	8082                	ret

0000000000000c8a <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
     c8a:	48d9                	li	a7,22
 ecall
     c8c:	00000073          	ecall
 ret
     c90:	8082                	ret

0000000000000c92 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     c92:	1101                	addi	sp,sp,-32
     c94:	ec06                	sd	ra,24(sp)
     c96:	e822                	sd	s0,16(sp)
     c98:	1000                	addi	s0,sp,32
     c9a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     c9e:	4605                	li	a2,1
     ca0:	fef40593          	addi	a1,s0,-17
     ca4:	f67ff0ef          	jal	ra,c0a <write>
}
     ca8:	60e2                	ld	ra,24(sp)
     caa:	6442                	ld	s0,16(sp)
     cac:	6105                	addi	sp,sp,32
     cae:	8082                	ret

0000000000000cb0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     cb0:	7139                	addi	sp,sp,-64
     cb2:	fc06                	sd	ra,56(sp)
     cb4:	f822                	sd	s0,48(sp)
     cb6:	f426                	sd	s1,40(sp)
     cb8:	f04a                	sd	s2,32(sp)
     cba:	ec4e                	sd	s3,24(sp)
     cbc:	0080                	addi	s0,sp,64
     cbe:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     cc0:	c299                	beqz	a3,cc6 <printint+0x16>
     cc2:	0805c663          	bltz	a1,d4e <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     cc6:	2581                	sext.w	a1,a1
  neg = 0;
     cc8:	4881                	li	a7,0
     cca:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     cce:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     cd0:	2601                	sext.w	a2,a2
     cd2:	00000517          	auipc	a0,0x0
     cd6:	61650513          	addi	a0,a0,1558 # 12e8 <digits>
     cda:	883a                	mv	a6,a4
     cdc:	2705                	addiw	a4,a4,1
     cde:	02c5f7bb          	remuw	a5,a1,a2
     ce2:	1782                	slli	a5,a5,0x20
     ce4:	9381                	srli	a5,a5,0x20
     ce6:	97aa                	add	a5,a5,a0
     ce8:	0007c783          	lbu	a5,0(a5)
     cec:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     cf0:	0005879b          	sext.w	a5,a1
     cf4:	02c5d5bb          	divuw	a1,a1,a2
     cf8:	0685                	addi	a3,a3,1
     cfa:	fec7f0e3          	bgeu	a5,a2,cda <printint+0x2a>
  if(neg)
     cfe:	00088b63          	beqz	a7,d14 <printint+0x64>
    buf[i++] = '-';
     d02:	fd040793          	addi	a5,s0,-48
     d06:	973e                	add	a4,a4,a5
     d08:	02d00793          	li	a5,45
     d0c:	fef70823          	sb	a5,-16(a4)
     d10:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     d14:	02e05663          	blez	a4,d40 <printint+0x90>
     d18:	fc040793          	addi	a5,s0,-64
     d1c:	00e78933          	add	s2,a5,a4
     d20:	fff78993          	addi	s3,a5,-1
     d24:	99ba                	add	s3,s3,a4
     d26:	377d                	addiw	a4,a4,-1
     d28:	1702                	slli	a4,a4,0x20
     d2a:	9301                	srli	a4,a4,0x20
     d2c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     d30:	fff94583          	lbu	a1,-1(s2)
     d34:	8526                	mv	a0,s1
     d36:	f5dff0ef          	jal	ra,c92 <putc>
  while(--i >= 0)
     d3a:	197d                	addi	s2,s2,-1
     d3c:	ff391ae3          	bne	s2,s3,d30 <printint+0x80>
}
     d40:	70e2                	ld	ra,56(sp)
     d42:	7442                	ld	s0,48(sp)
     d44:	74a2                	ld	s1,40(sp)
     d46:	7902                	ld	s2,32(sp)
     d48:	69e2                	ld	s3,24(sp)
     d4a:	6121                	addi	sp,sp,64
     d4c:	8082                	ret
    x = -xx;
     d4e:	40b005bb          	negw	a1,a1
    neg = 1;
     d52:	4885                	li	a7,1
    x = -xx;
     d54:	bf9d                	j	cca <printint+0x1a>

0000000000000d56 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     d56:	7119                	addi	sp,sp,-128
     d58:	fc86                	sd	ra,120(sp)
     d5a:	f8a2                	sd	s0,112(sp)
     d5c:	f4a6                	sd	s1,104(sp)
     d5e:	f0ca                	sd	s2,96(sp)
     d60:	ecce                	sd	s3,88(sp)
     d62:	e8d2                	sd	s4,80(sp)
     d64:	e4d6                	sd	s5,72(sp)
     d66:	e0da                	sd	s6,64(sp)
     d68:	fc5e                	sd	s7,56(sp)
     d6a:	f862                	sd	s8,48(sp)
     d6c:	f466                	sd	s9,40(sp)
     d6e:	f06a                	sd	s10,32(sp)
     d70:	ec6e                	sd	s11,24(sp)
     d72:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     d74:	0005c903          	lbu	s2,0(a1)
     d78:	22090e63          	beqz	s2,fb4 <vprintf+0x25e>
     d7c:	8b2a                	mv	s6,a0
     d7e:	8a2e                	mv	s4,a1
     d80:	8bb2                	mv	s7,a2
  state = 0;
     d82:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
     d84:	4481                	li	s1,0
     d86:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     d88:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     d8c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     d90:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
     d94:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     d98:	00000c97          	auipc	s9,0x0
     d9c:	550c8c93          	addi	s9,s9,1360 # 12e8 <digits>
     da0:	a005                	j	dc0 <vprintf+0x6a>
        putc(fd, c0);
     da2:	85ca                	mv	a1,s2
     da4:	855a                	mv	a0,s6
     da6:	eedff0ef          	jal	ra,c92 <putc>
     daa:	a019                	j	db0 <vprintf+0x5a>
    } else if(state == '%'){
     dac:	03598263          	beq	s3,s5,dd0 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
     db0:	2485                	addiw	s1,s1,1
     db2:	8726                	mv	a4,s1
     db4:	009a07b3          	add	a5,s4,s1
     db8:	0007c903          	lbu	s2,0(a5)
     dbc:	1e090c63          	beqz	s2,fb4 <vprintf+0x25e>
    c0 = fmt[i] & 0xff;
     dc0:	0009079b          	sext.w	a5,s2
    if(state == 0){
     dc4:	fe0994e3          	bnez	s3,dac <vprintf+0x56>
      if(c0 == '%'){
     dc8:	fd579de3          	bne	a5,s5,da2 <vprintf+0x4c>
        state = '%';
     dcc:	89be                	mv	s3,a5
     dce:	b7cd                	j	db0 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
     dd0:	cfa5                	beqz	a5,e48 <vprintf+0xf2>
     dd2:	00ea06b3          	add	a3,s4,a4
     dd6:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
     dda:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
     ddc:	c681                	beqz	a3,de4 <vprintf+0x8e>
     dde:	9752                	add	a4,a4,s4
     de0:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
     de4:	03878a63          	beq	a5,s8,e18 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
     de8:	05a78463          	beq	a5,s10,e30 <vprintf+0xda>
      } else if(c0 == 'u'){
     dec:	0db78763          	beq	a5,s11,eba <vprintf+0x164>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
     df0:	07800713          	li	a4,120
     df4:	10e78963          	beq	a5,a4,f06 <vprintf+0x1b0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
     df8:	07000713          	li	a4,112
     dfc:	12e78e63          	beq	a5,a4,f38 <vprintf+0x1e2>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
     e00:	07300713          	li	a4,115
     e04:	16e78b63          	beq	a5,a4,f7a <vprintf+0x224>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
     e08:	05579063          	bne	a5,s5,e48 <vprintf+0xf2>
        putc(fd, '%');
     e0c:	85d6                	mv	a1,s5
     e0e:	855a                	mv	a0,s6
     e10:	e83ff0ef          	jal	ra,c92 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
     e14:	4981                	li	s3,0
     e16:	bf69                	j	db0 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
     e18:	008b8913          	addi	s2,s7,8
     e1c:	4685                	li	a3,1
     e1e:	4629                	li	a2,10
     e20:	000ba583          	lw	a1,0(s7)
     e24:	855a                	mv	a0,s6
     e26:	e8bff0ef          	jal	ra,cb0 <printint>
     e2a:	8bca                	mv	s7,s2
      state = 0;
     e2c:	4981                	li	s3,0
     e2e:	b749                	j	db0 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
     e30:	03868663          	beq	a3,s8,e5c <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     e34:	05a68163          	beq	a3,s10,e76 <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'u'){
     e38:	09b68d63          	beq	a3,s11,ed2 <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
     e3c:	03a68f63          	beq	a3,s10,e7a <vprintf+0x124>
      } else if(c0 == 'l' && c1 == 'x'){
     e40:	07800793          	li	a5,120
     e44:	0cf68d63          	beq	a3,a5,f1e <vprintf+0x1c8>
        putc(fd, '%');
     e48:	85d6                	mv	a1,s5
     e4a:	855a                	mv	a0,s6
     e4c:	e47ff0ef          	jal	ra,c92 <putc>
        putc(fd, c0);
     e50:	85ca                	mv	a1,s2
     e52:	855a                	mv	a0,s6
     e54:	e3fff0ef          	jal	ra,c92 <putc>
      state = 0;
     e58:	4981                	li	s3,0
     e5a:	bf99                	j	db0 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     e5c:	008b8913          	addi	s2,s7,8
     e60:	4685                	li	a3,1
     e62:	4629                	li	a2,10
     e64:	000ba583          	lw	a1,0(s7)
     e68:	855a                	mv	a0,s6
     e6a:	e47ff0ef          	jal	ra,cb0 <printint>
        i += 1;
     e6e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
     e70:	8bca                	mv	s7,s2
      state = 0;
     e72:	4981                	li	s3,0
        i += 1;
     e74:	bf35                	j	db0 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     e76:	03860563          	beq	a2,s8,ea0 <vprintf+0x14a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
     e7a:	07b60963          	beq	a2,s11,eec <vprintf+0x196>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
     e7e:	07800793          	li	a5,120
     e82:	fcf613e3          	bne	a2,a5,e48 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
     e86:	008b8913          	addi	s2,s7,8
     e8a:	4681                	li	a3,0
     e8c:	4641                	li	a2,16
     e8e:	000ba583          	lw	a1,0(s7)
     e92:	855a                	mv	a0,s6
     e94:	e1dff0ef          	jal	ra,cb0 <printint>
        i += 2;
     e98:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
     e9a:	8bca                	mv	s7,s2
      state = 0;
     e9c:	4981                	li	s3,0
        i += 2;
     e9e:	bf09                	j	db0 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     ea0:	008b8913          	addi	s2,s7,8
     ea4:	4685                	li	a3,1
     ea6:	4629                	li	a2,10
     ea8:	000ba583          	lw	a1,0(s7)
     eac:	855a                	mv	a0,s6
     eae:	e03ff0ef          	jal	ra,cb0 <printint>
        i += 2;
     eb2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
     eb4:	8bca                	mv	s7,s2
      state = 0;
     eb6:	4981                	li	s3,0
        i += 2;
     eb8:	bde5                	j	db0 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 0);
     eba:	008b8913          	addi	s2,s7,8
     ebe:	4681                	li	a3,0
     ec0:	4629                	li	a2,10
     ec2:	000ba583          	lw	a1,0(s7)
     ec6:	855a                	mv	a0,s6
     ec8:	de9ff0ef          	jal	ra,cb0 <printint>
     ecc:	8bca                	mv	s7,s2
      state = 0;
     ece:	4981                	li	s3,0
     ed0:	b5c5                	j	db0 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     ed2:	008b8913          	addi	s2,s7,8
     ed6:	4681                	li	a3,0
     ed8:	4629                	li	a2,10
     eda:	000ba583          	lw	a1,0(s7)
     ede:	855a                	mv	a0,s6
     ee0:	dd1ff0ef          	jal	ra,cb0 <printint>
        i += 1;
     ee4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
     ee6:	8bca                	mv	s7,s2
      state = 0;
     ee8:	4981                	li	s3,0
        i += 1;
     eea:	b5d9                	j	db0 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     eec:	008b8913          	addi	s2,s7,8
     ef0:	4681                	li	a3,0
     ef2:	4629                	li	a2,10
     ef4:	000ba583          	lw	a1,0(s7)
     ef8:	855a                	mv	a0,s6
     efa:	db7ff0ef          	jal	ra,cb0 <printint>
        i += 2;
     efe:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
     f00:	8bca                	mv	s7,s2
      state = 0;
     f02:	4981                	li	s3,0
        i += 2;
     f04:	b575                	j	db0 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 16, 0);
     f06:	008b8913          	addi	s2,s7,8
     f0a:	4681                	li	a3,0
     f0c:	4641                	li	a2,16
     f0e:	000ba583          	lw	a1,0(s7)
     f12:	855a                	mv	a0,s6
     f14:	d9dff0ef          	jal	ra,cb0 <printint>
     f18:	8bca                	mv	s7,s2
      state = 0;
     f1a:	4981                	li	s3,0
     f1c:	bd51                	j	db0 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
     f1e:	008b8913          	addi	s2,s7,8
     f22:	4681                	li	a3,0
     f24:	4641                	li	a2,16
     f26:	000ba583          	lw	a1,0(s7)
     f2a:	855a                	mv	a0,s6
     f2c:	d85ff0ef          	jal	ra,cb0 <printint>
        i += 1;
     f30:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
     f32:	8bca                	mv	s7,s2
      state = 0;
     f34:	4981                	li	s3,0
        i += 1;
     f36:	bdad                	j	db0 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
     f38:	008b8793          	addi	a5,s7,8
     f3c:	f8f43423          	sd	a5,-120(s0)
     f40:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     f44:	03000593          	li	a1,48
     f48:	855a                	mv	a0,s6
     f4a:	d49ff0ef          	jal	ra,c92 <putc>
  putc(fd, 'x');
     f4e:	07800593          	li	a1,120
     f52:	855a                	mv	a0,s6
     f54:	d3fff0ef          	jal	ra,c92 <putc>
     f58:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     f5a:	03c9d793          	srli	a5,s3,0x3c
     f5e:	97e6                	add	a5,a5,s9
     f60:	0007c583          	lbu	a1,0(a5)
     f64:	855a                	mv	a0,s6
     f66:	d2dff0ef          	jal	ra,c92 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     f6a:	0992                	slli	s3,s3,0x4
     f6c:	397d                	addiw	s2,s2,-1
     f6e:	fe0916e3          	bnez	s2,f5a <vprintf+0x204>
        printptr(fd, va_arg(ap, uint64));
     f72:	f8843b83          	ld	s7,-120(s0)
      state = 0;
     f76:	4981                	li	s3,0
     f78:	bd25                	j	db0 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
     f7a:	008b8993          	addi	s3,s7,8
     f7e:	000bb903          	ld	s2,0(s7)
     f82:	00090f63          	beqz	s2,fa0 <vprintf+0x24a>
        for(; *s; s++)
     f86:	00094583          	lbu	a1,0(s2)
     f8a:	c195                	beqz	a1,fae <vprintf+0x258>
          putc(fd, *s);
     f8c:	855a                	mv	a0,s6
     f8e:	d05ff0ef          	jal	ra,c92 <putc>
        for(; *s; s++)
     f92:	0905                	addi	s2,s2,1
     f94:	00094583          	lbu	a1,0(s2)
     f98:	f9f5                	bnez	a1,f8c <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
     f9a:	8bce                	mv	s7,s3
      state = 0;
     f9c:	4981                	li	s3,0
     f9e:	bd09                	j	db0 <vprintf+0x5a>
          s = "(null)";
     fa0:	00000917          	auipc	s2,0x0
     fa4:	34090913          	addi	s2,s2,832 # 12e0 <malloc+0x22a>
        for(; *s; s++)
     fa8:	02800593          	li	a1,40
     fac:	b7c5                	j	f8c <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
     fae:	8bce                	mv	s7,s3
      state = 0;
     fb0:	4981                	li	s3,0
     fb2:	bbfd                	j	db0 <vprintf+0x5a>
    }
  }
}
     fb4:	70e6                	ld	ra,120(sp)
     fb6:	7446                	ld	s0,112(sp)
     fb8:	74a6                	ld	s1,104(sp)
     fba:	7906                	ld	s2,96(sp)
     fbc:	69e6                	ld	s3,88(sp)
     fbe:	6a46                	ld	s4,80(sp)
     fc0:	6aa6                	ld	s5,72(sp)
     fc2:	6b06                	ld	s6,64(sp)
     fc4:	7be2                	ld	s7,56(sp)
     fc6:	7c42                	ld	s8,48(sp)
     fc8:	7ca2                	ld	s9,40(sp)
     fca:	7d02                	ld	s10,32(sp)
     fcc:	6de2                	ld	s11,24(sp)
     fce:	6109                	addi	sp,sp,128
     fd0:	8082                	ret

0000000000000fd2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     fd2:	715d                	addi	sp,sp,-80
     fd4:	ec06                	sd	ra,24(sp)
     fd6:	e822                	sd	s0,16(sp)
     fd8:	1000                	addi	s0,sp,32
     fda:	e010                	sd	a2,0(s0)
     fdc:	e414                	sd	a3,8(s0)
     fde:	e818                	sd	a4,16(s0)
     fe0:	ec1c                	sd	a5,24(s0)
     fe2:	03043023          	sd	a6,32(s0)
     fe6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     fea:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     fee:	8622                	mv	a2,s0
     ff0:	d67ff0ef          	jal	ra,d56 <vprintf>
}
     ff4:	60e2                	ld	ra,24(sp)
     ff6:	6442                	ld	s0,16(sp)
     ff8:	6161                	addi	sp,sp,80
     ffa:	8082                	ret

0000000000000ffc <printf>:

void
printf(const char *fmt, ...)
{
     ffc:	711d                	addi	sp,sp,-96
     ffe:	ec06                	sd	ra,24(sp)
    1000:	e822                	sd	s0,16(sp)
    1002:	1000                	addi	s0,sp,32
    1004:	e40c                	sd	a1,8(s0)
    1006:	e810                	sd	a2,16(s0)
    1008:	ec14                	sd	a3,24(s0)
    100a:	f018                	sd	a4,32(s0)
    100c:	f41c                	sd	a5,40(s0)
    100e:	03043823          	sd	a6,48(s0)
    1012:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1016:	00840613          	addi	a2,s0,8
    101a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    101e:	85aa                	mv	a1,a0
    1020:	4505                	li	a0,1
    1022:	d35ff0ef          	jal	ra,d56 <vprintf>
}
    1026:	60e2                	ld	ra,24(sp)
    1028:	6442                	ld	s0,16(sp)
    102a:	6125                	addi	sp,sp,96
    102c:	8082                	ret

000000000000102e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    102e:	1141                	addi	sp,sp,-16
    1030:	e422                	sd	s0,8(sp)
    1032:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1034:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1038:	00001797          	auipc	a5,0x1
    103c:	fd87b783          	ld	a5,-40(a5) # 2010 <freep>
    1040:	a805                	j	1070 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    1042:	4618                	lw	a4,8(a2)
    1044:	9db9                	addw	a1,a1,a4
    1046:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    104a:	6398                	ld	a4,0(a5)
    104c:	6318                	ld	a4,0(a4)
    104e:	fee53823          	sd	a4,-16(a0)
    1052:	a091                	j	1096 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    1054:	ff852703          	lw	a4,-8(a0)
    1058:	9e39                	addw	a2,a2,a4
    105a:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    105c:	ff053703          	ld	a4,-16(a0)
    1060:	e398                	sd	a4,0(a5)
    1062:	a099                	j	10a8 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1064:	6398                	ld	a4,0(a5)
    1066:	00e7e463          	bltu	a5,a4,106e <free+0x40>
    106a:	00e6ea63          	bltu	a3,a4,107e <free+0x50>
{
    106e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1070:	fed7fae3          	bgeu	a5,a3,1064 <free+0x36>
    1074:	6398                	ld	a4,0(a5)
    1076:	00e6e463          	bltu	a3,a4,107e <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    107a:	fee7eae3          	bltu	a5,a4,106e <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    107e:	ff852583          	lw	a1,-8(a0)
    1082:	6390                	ld	a2,0(a5)
    1084:	02059713          	slli	a4,a1,0x20
    1088:	9301                	srli	a4,a4,0x20
    108a:	0712                	slli	a4,a4,0x4
    108c:	9736                	add	a4,a4,a3
    108e:	fae60ae3          	beq	a2,a4,1042 <free+0x14>
    bp->s.ptr = p->s.ptr;
    1092:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1096:	4790                	lw	a2,8(a5)
    1098:	02061713          	slli	a4,a2,0x20
    109c:	9301                	srli	a4,a4,0x20
    109e:	0712                	slli	a4,a4,0x4
    10a0:	973e                	add	a4,a4,a5
    10a2:	fae689e3          	beq	a3,a4,1054 <free+0x26>
  } else
    p->s.ptr = bp;
    10a6:	e394                	sd	a3,0(a5)
  freep = p;
    10a8:	00001717          	auipc	a4,0x1
    10ac:	f6f73423          	sd	a5,-152(a4) # 2010 <freep>
}
    10b0:	6422                	ld	s0,8(sp)
    10b2:	0141                	addi	sp,sp,16
    10b4:	8082                	ret

00000000000010b6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    10b6:	7139                	addi	sp,sp,-64
    10b8:	fc06                	sd	ra,56(sp)
    10ba:	f822                	sd	s0,48(sp)
    10bc:	f426                	sd	s1,40(sp)
    10be:	f04a                	sd	s2,32(sp)
    10c0:	ec4e                	sd	s3,24(sp)
    10c2:	e852                	sd	s4,16(sp)
    10c4:	e456                	sd	s5,8(sp)
    10c6:	e05a                	sd	s6,0(sp)
    10c8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    10ca:	02051493          	slli	s1,a0,0x20
    10ce:	9081                	srli	s1,s1,0x20
    10d0:	04bd                	addi	s1,s1,15
    10d2:	8091                	srli	s1,s1,0x4
    10d4:	0014899b          	addiw	s3,s1,1
    10d8:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    10da:	00001517          	auipc	a0,0x1
    10de:	f3653503          	ld	a0,-202(a0) # 2010 <freep>
    10e2:	c515                	beqz	a0,110e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    10e4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    10e6:	4798                	lw	a4,8(a5)
    10e8:	02977f63          	bgeu	a4,s1,1126 <malloc+0x70>
    10ec:	8a4e                	mv	s4,s3
    10ee:	0009871b          	sext.w	a4,s3
    10f2:	6685                	lui	a3,0x1
    10f4:	00d77363          	bgeu	a4,a3,10fa <malloc+0x44>
    10f8:	6a05                	lui	s4,0x1
    10fa:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    10fe:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1102:	00001917          	auipc	s2,0x1
    1106:	f0e90913          	addi	s2,s2,-242 # 2010 <freep>
  if(p == (char*)-1)
    110a:	5afd                	li	s5,-1
    110c:	a0bd                	j	117a <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
    110e:	00001797          	auipc	a5,0x1
    1112:	f7a78793          	addi	a5,a5,-134 # 2088 <base>
    1116:	00001717          	auipc	a4,0x1
    111a:	eef73d23          	sd	a5,-262(a4) # 2010 <freep>
    111e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    1120:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1124:	b7e1                	j	10ec <malloc+0x36>
      if(p->s.size == nunits)
    1126:	02e48b63          	beq	s1,a4,115c <malloc+0xa6>
        p->s.size -= nunits;
    112a:	4137073b          	subw	a4,a4,s3
    112e:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1130:	1702                	slli	a4,a4,0x20
    1132:	9301                	srli	a4,a4,0x20
    1134:	0712                	slli	a4,a4,0x4
    1136:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1138:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    113c:	00001717          	auipc	a4,0x1
    1140:	eca73a23          	sd	a0,-300(a4) # 2010 <freep>
      return (void*)(p + 1);
    1144:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    1148:	70e2                	ld	ra,56(sp)
    114a:	7442                	ld	s0,48(sp)
    114c:	74a2                	ld	s1,40(sp)
    114e:	7902                	ld	s2,32(sp)
    1150:	69e2                	ld	s3,24(sp)
    1152:	6a42                	ld	s4,16(sp)
    1154:	6aa2                	ld	s5,8(sp)
    1156:	6b02                	ld	s6,0(sp)
    1158:	6121                	addi	sp,sp,64
    115a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    115c:	6398                	ld	a4,0(a5)
    115e:	e118                	sd	a4,0(a0)
    1160:	bff1                	j	113c <malloc+0x86>
  hp->s.size = nu;
    1162:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    1166:	0541                	addi	a0,a0,16
    1168:	ec7ff0ef          	jal	ra,102e <free>
  return freep;
    116c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    1170:	dd61                	beqz	a0,1148 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1172:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1174:	4798                	lw	a4,8(a5)
    1176:	fa9778e3          	bgeu	a4,s1,1126 <malloc+0x70>
    if(p == freep)
    117a:	00093703          	ld	a4,0(s2)
    117e:	853e                	mv	a0,a5
    1180:	fef719e3          	bne	a4,a5,1172 <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
    1184:	8552                	mv	a0,s4
    1186:	aedff0ef          	jal	ra,c72 <sbrk>
  if(p == (char*)-1)
    118a:	fd551ce3          	bne	a0,s5,1162 <malloc+0xac>
        return 0;
    118e:	4501                	li	a0,0
    1190:	bf65                	j	1148 <malloc+0x92>
