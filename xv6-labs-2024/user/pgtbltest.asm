
user/_pgtbltest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <err>:

char *testname = "???";

void
err(char *why)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
   c:	84aa                	mv	s1,a0
  printf("pgtbltest: %s failed: %s, pid=%d\n", testname, why, getpid());
   e:	00001917          	auipc	s2,0x1
  12:	ff293903          	ld	s2,-14(s2) # 1000 <testname>
  16:	47a000ef          	jal	ra,490 <getpid>
  1a:	86aa                	mv	a3,a0
  1c:	8626                	mv	a2,s1
  1e:	85ca                	mv	a1,s2
  20:	00001517          	auipc	a0,0x1
  24:	9a050513          	addi	a0,a0,-1632 # 9c0 <malloc+0xe4>
  28:	7fa000ef          	jal	ra,822 <printf>
  exit(1);
  2c:	4505                	li	a0,1
  2e:	3e2000ef          	jal	ra,410 <exit>

0000000000000032 <ugetpid_test>:
}

void
ugetpid_test()
{
  32:	7179                	addi	sp,sp,-48
  34:	f406                	sd	ra,40(sp)
  36:	f022                	sd	s0,32(sp)
  38:	ec26                	sd	s1,24(sp)
  3a:	1800                	addi	s0,sp,48
  int i;

  printf("ugetpid_test starting\n");
  3c:	00001517          	auipc	a0,0x1
  40:	9ac50513          	addi	a0,a0,-1620 # 9e8 <malloc+0x10c>
  44:	7de000ef          	jal	ra,822 <printf>
  testname = "ugetpid_test";
  48:	00001797          	auipc	a5,0x1
  4c:	9b878793          	addi	a5,a5,-1608 # a00 <malloc+0x124>
  50:	00001717          	auipc	a4,0x1
  54:	faf73823          	sd	a5,-80(a4) # 1000 <testname>
  58:	04000493          	li	s1,64

  for (i = 0; i < 64; i++) {
    int ret = fork();
  5c:	3ac000ef          	jal	ra,408 <fork>
  60:	fca42e23          	sw	a0,-36(s0)
    if (ret != 0) {
  64:	c905                	beqz	a0,94 <ugetpid_test+0x62>
      wait(&ret);
  66:	fdc40513          	addi	a0,s0,-36
  6a:	3ae000ef          	jal	ra,418 <wait>
      if (ret != 0)
  6e:	fdc42783          	lw	a5,-36(s0)
  72:	ef91                	bnez	a5,8e <ugetpid_test+0x5c>
  for (i = 0; i < 64; i++) {
  74:	34fd                	addiw	s1,s1,-1
  76:	f0fd                	bnez	s1,5c <ugetpid_test+0x2a>
    }
    if (getpid() != ugetpid())
      err("missmatched PID");
    exit(0);
  }
  printf("ugetpid_test: OK\n");
  78:	00001517          	auipc	a0,0x1
  7c:	9a850513          	addi	a0,a0,-1624 # a20 <malloc+0x144>
  80:	7a2000ef          	jal	ra,822 <printf>
}
  84:	70a2                	ld	ra,40(sp)
  86:	7402                	ld	s0,32(sp)
  88:	64e2                	ld	s1,24(sp)
  8a:	6145                	addi	sp,sp,48
  8c:	8082                	ret
        exit(1);
  8e:	4505                	li	a0,1
  90:	380000ef          	jal	ra,410 <exit>
    if (getpid() != ugetpid())
  94:	3fc000ef          	jal	ra,490 <getpid>
static inline int
ugetpid(void)
{
  // Sử dụng trực tiếp địa chỉ ảo cố định của USYSCALL ở User Space
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
  98:	040007b7          	lui	a5,0x4000
  9c:	17f5                	addi	a5,a5,-3
  9e:	07b2                	slli	a5,a5,0xc
  a0:	439c                	lw	a5,0(a5)
  a2:	00a78863          	beq	a5,a0,b2 <ugetpid_test+0x80>
      err("missmatched PID");
  a6:	00001517          	auipc	a0,0x1
  aa:	96a50513          	addi	a0,a0,-1686 # a10 <malloc+0x134>
  ae:	f53ff0ef          	jal	ra,0 <err>
    exit(0);
  b2:	4501                	li	a0,0
  b4:	35c000ef          	jal	ra,410 <exit>

00000000000000b8 <pgaccess_test>:

void
pgaccess_test()
{
  b8:	7179                	addi	sp,sp,-48
  ba:	f406                	sd	ra,40(sp)
  bc:	f022                	sd	s0,32(sp)
  be:	ec26                	sd	s1,24(sp)
  c0:	1800                	addi	s0,sp,48
  char *buf;
  unsigned int abits;
  printf("pgaccess_test starting\n");
  c2:	00001517          	auipc	a0,0x1
  c6:	97650513          	addi	a0,a0,-1674 # a38 <malloc+0x15c>
  ca:	758000ef          	jal	ra,822 <printf>
  testname = "pgaccess_test";
  ce:	00001797          	auipc	a5,0x1
  d2:	98278793          	addi	a5,a5,-1662 # a50 <malloc+0x174>
  d6:	00001717          	auipc	a4,0x1
  da:	f2f73523          	sd	a5,-214(a4) # 1000 <testname>
  buf = malloc(32 * PGSIZE);
  de:	00020537          	lui	a0,0x20
  e2:	7fa000ef          	jal	ra,8dc <malloc>
  e6:	84aa                	mv	s1,a0
  if (pgaccess(buf, 32, &abits) < 0)
  e8:	fdc40613          	addi	a2,s0,-36
  ec:	02000593          	li	a1,32
  f0:	3c0000ef          	jal	ra,4b0 <pgaccess>
  f4:	06054563          	bltz	a0,15e <pgaccess_test+0xa6>
    err("pgaccess failed");
  buf[PGSIZE * 1] += 1;
  f8:	6785                	lui	a5,0x1
  fa:	97a6                	add	a5,a5,s1
  fc:	0007c703          	lbu	a4,0(a5) # 1000 <testname>
 100:	2705                	addiw	a4,a4,1
 102:	00e78023          	sb	a4,0(a5)
  buf[PGSIZE * 2] += 1;
 106:	6789                	lui	a5,0x2
 108:	97a6                	add	a5,a5,s1
 10a:	0007c703          	lbu	a4,0(a5) # 2000 <base+0xfe0>
 10e:	2705                	addiw	a4,a4,1
 110:	00e78023          	sb	a4,0(a5)
  buf[PGSIZE * 30] += 1;
 114:	67f9                	lui	a5,0x1e
 116:	97a6                	add	a5,a5,s1
 118:	0007c703          	lbu	a4,0(a5) # 1e000 <base+0x1cfe0>
 11c:	2705                	addiw	a4,a4,1
 11e:	00e78023          	sb	a4,0(a5)
  if (pgaccess(buf, 32, &abits) < 0)
 122:	fdc40613          	addi	a2,s0,-36
 126:	02000593          	li	a1,32
 12a:	8526                	mv	a0,s1
 12c:	384000ef          	jal	ra,4b0 <pgaccess>
 130:	02054d63          	bltz	a0,16a <pgaccess_test+0xb2>
    err("pgaccess failed");
  if (abits != ((1 << 1) | (1 << 2) | (1 << 30)))
 134:	fdc42703          	lw	a4,-36(s0)
 138:	400007b7          	lui	a5,0x40000
 13c:	0799                	addi	a5,a5,6
 13e:	02f71c63          	bne	a4,a5,176 <pgaccess_test+0xbe>
    err("incorrect access bits set");
  free(buf);
 142:	8526                	mv	a0,s1
 144:	710000ef          	jal	ra,854 <free>
  printf("pgaccess_test: OK\n");
 148:	00001517          	auipc	a0,0x1
 14c:	94850513          	addi	a0,a0,-1720 # a90 <malloc+0x1b4>
 150:	6d2000ef          	jal	ra,822 <printf>
 154:	70a2                	ld	ra,40(sp)
 156:	7402                	ld	s0,32(sp)
 158:	64e2                	ld	s1,24(sp)
 15a:	6145                	addi	sp,sp,48
 15c:	8082                	ret
    err("pgaccess failed");
 15e:	00001517          	auipc	a0,0x1
 162:	90250513          	addi	a0,a0,-1790 # a60 <malloc+0x184>
 166:	e9bff0ef          	jal	ra,0 <err>
    err("pgaccess failed");
 16a:	00001517          	auipc	a0,0x1
 16e:	8f650513          	addi	a0,a0,-1802 # a60 <malloc+0x184>
 172:	e8fff0ef          	jal	ra,0 <err>
    err("incorrect access bits set");
 176:	00001517          	auipc	a0,0x1
 17a:	8fa50513          	addi	a0,a0,-1798 # a70 <malloc+0x194>
 17e:	e83ff0ef          	jal	ra,0 <err>

0000000000000182 <main>:
{
 182:	1141                	addi	sp,sp,-16
 184:	e406                	sd	ra,8(sp)
 186:	e022                	sd	s0,0(sp)
 188:	0800                	addi	s0,sp,16
  ugetpid_test();
 18a:	ea9ff0ef          	jal	ra,32 <ugetpid_test>
  pgaccess_test();
 18e:	f2bff0ef          	jal	ra,b8 <pgaccess_test>
  printf("pgtbltest: all tests succeeded\n");
 192:	00001517          	auipc	a0,0x1
 196:	91650513          	addi	a0,a0,-1770 # aa8 <malloc+0x1cc>
 19a:	688000ef          	jal	ra,822 <printf>
  exit(0);
 19e:	4501                	li	a0,0
 1a0:	270000ef          	jal	ra,410 <exit>

00000000000001a4 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 1a4:	1141                	addi	sp,sp,-16
 1a6:	e406                	sd	ra,8(sp)
 1a8:	e022                	sd	s0,0(sp)
 1aa:	0800                	addi	s0,sp,16
  extern int main();
  main();
 1ac:	fd7ff0ef          	jal	ra,182 <main>
  exit(0);
 1b0:	4501                	li	a0,0
 1b2:	25e000ef          	jal	ra,410 <exit>

00000000000001b6 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1b6:	1141                	addi	sp,sp,-16
 1b8:	e422                	sd	s0,8(sp)
 1ba:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1bc:	87aa                	mv	a5,a0
 1be:	0585                	addi	a1,a1,1
 1c0:	0785                	addi	a5,a5,1
 1c2:	fff5c703          	lbu	a4,-1(a1)
 1c6:	fee78fa3          	sb	a4,-1(a5) # 3fffffff <base+0x3fffefdf>
 1ca:	fb75                	bnez	a4,1be <strcpy+0x8>
    ;
  return os;
}
 1cc:	6422                	ld	s0,8(sp)
 1ce:	0141                	addi	sp,sp,16
 1d0:	8082                	ret

00000000000001d2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1d2:	1141                	addi	sp,sp,-16
 1d4:	e422                	sd	s0,8(sp)
 1d6:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1d8:	00054783          	lbu	a5,0(a0)
 1dc:	cb91                	beqz	a5,1f0 <strcmp+0x1e>
 1de:	0005c703          	lbu	a4,0(a1)
 1e2:	00f71763          	bne	a4,a5,1f0 <strcmp+0x1e>
    p++, q++;
 1e6:	0505                	addi	a0,a0,1
 1e8:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1ea:	00054783          	lbu	a5,0(a0)
 1ee:	fbe5                	bnez	a5,1de <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1f0:	0005c503          	lbu	a0,0(a1)
}
 1f4:	40a7853b          	subw	a0,a5,a0
 1f8:	6422                	ld	s0,8(sp)
 1fa:	0141                	addi	sp,sp,16
 1fc:	8082                	ret

00000000000001fe <strlen>:

uint
strlen(const char *s)
{
 1fe:	1141                	addi	sp,sp,-16
 200:	e422                	sd	s0,8(sp)
 202:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 204:	00054783          	lbu	a5,0(a0)
 208:	cf91                	beqz	a5,224 <strlen+0x26>
 20a:	0505                	addi	a0,a0,1
 20c:	87aa                	mv	a5,a0
 20e:	4685                	li	a3,1
 210:	9e89                	subw	a3,a3,a0
 212:	00f6853b          	addw	a0,a3,a5
 216:	0785                	addi	a5,a5,1
 218:	fff7c703          	lbu	a4,-1(a5)
 21c:	fb7d                	bnez	a4,212 <strlen+0x14>
    ;
  return n;
}
 21e:	6422                	ld	s0,8(sp)
 220:	0141                	addi	sp,sp,16
 222:	8082                	ret
  for(n = 0; s[n]; n++)
 224:	4501                	li	a0,0
 226:	bfe5                	j	21e <strlen+0x20>

0000000000000228 <memset>:

void*
memset(void *dst, int c, uint n)
{
 228:	1141                	addi	sp,sp,-16
 22a:	e422                	sd	s0,8(sp)
 22c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 22e:	ca19                	beqz	a2,244 <memset+0x1c>
 230:	87aa                	mv	a5,a0
 232:	1602                	slli	a2,a2,0x20
 234:	9201                	srli	a2,a2,0x20
 236:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 23a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 23e:	0785                	addi	a5,a5,1
 240:	fee79de3          	bne	a5,a4,23a <memset+0x12>
  }
  return dst;
}
 244:	6422                	ld	s0,8(sp)
 246:	0141                	addi	sp,sp,16
 248:	8082                	ret

000000000000024a <strchr>:

char*
strchr(const char *s, char c)
{
 24a:	1141                	addi	sp,sp,-16
 24c:	e422                	sd	s0,8(sp)
 24e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 250:	00054783          	lbu	a5,0(a0)
 254:	cb99                	beqz	a5,26a <strchr+0x20>
    if(*s == c)
 256:	00f58763          	beq	a1,a5,264 <strchr+0x1a>
  for(; *s; s++)
 25a:	0505                	addi	a0,a0,1
 25c:	00054783          	lbu	a5,0(a0)
 260:	fbfd                	bnez	a5,256 <strchr+0xc>
      return (char*)s;
  return 0;
 262:	4501                	li	a0,0
}
 264:	6422                	ld	s0,8(sp)
 266:	0141                	addi	sp,sp,16
 268:	8082                	ret
  return 0;
 26a:	4501                	li	a0,0
 26c:	bfe5                	j	264 <strchr+0x1a>

000000000000026e <gets>:

char*
gets(char *buf, int max)
{
 26e:	711d                	addi	sp,sp,-96
 270:	ec86                	sd	ra,88(sp)
 272:	e8a2                	sd	s0,80(sp)
 274:	e4a6                	sd	s1,72(sp)
 276:	e0ca                	sd	s2,64(sp)
 278:	fc4e                	sd	s3,56(sp)
 27a:	f852                	sd	s4,48(sp)
 27c:	f456                	sd	s5,40(sp)
 27e:	f05a                	sd	s6,32(sp)
 280:	ec5e                	sd	s7,24(sp)
 282:	1080                	addi	s0,sp,96
 284:	8baa                	mv	s7,a0
 286:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 288:	892a                	mv	s2,a0
 28a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 28c:	4aa9                	li	s5,10
 28e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 290:	89a6                	mv	s3,s1
 292:	2485                	addiw	s1,s1,1
 294:	0344d663          	bge	s1,s4,2c0 <gets+0x52>
    cc = read(0, &c, 1);
 298:	4605                	li	a2,1
 29a:	faf40593          	addi	a1,s0,-81
 29e:	4501                	li	a0,0
 2a0:	188000ef          	jal	ra,428 <read>
    if(cc < 1)
 2a4:	00a05e63          	blez	a0,2c0 <gets+0x52>
    buf[i++] = c;
 2a8:	faf44783          	lbu	a5,-81(s0)
 2ac:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2b0:	01578763          	beq	a5,s5,2be <gets+0x50>
 2b4:	0905                	addi	s2,s2,1
 2b6:	fd679de3          	bne	a5,s6,290 <gets+0x22>
  for(i=0; i+1 < max; ){
 2ba:	89a6                	mv	s3,s1
 2bc:	a011                	j	2c0 <gets+0x52>
 2be:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2c0:	99de                	add	s3,s3,s7
 2c2:	00098023          	sb	zero,0(s3)
  return buf;
}
 2c6:	855e                	mv	a0,s7
 2c8:	60e6                	ld	ra,88(sp)
 2ca:	6446                	ld	s0,80(sp)
 2cc:	64a6                	ld	s1,72(sp)
 2ce:	6906                	ld	s2,64(sp)
 2d0:	79e2                	ld	s3,56(sp)
 2d2:	7a42                	ld	s4,48(sp)
 2d4:	7aa2                	ld	s5,40(sp)
 2d6:	7b02                	ld	s6,32(sp)
 2d8:	6be2                	ld	s7,24(sp)
 2da:	6125                	addi	sp,sp,96
 2dc:	8082                	ret

00000000000002de <stat>:

int
stat(const char *n, struct stat *st)
{
 2de:	1101                	addi	sp,sp,-32
 2e0:	ec06                	sd	ra,24(sp)
 2e2:	e822                	sd	s0,16(sp)
 2e4:	e426                	sd	s1,8(sp)
 2e6:	e04a                	sd	s2,0(sp)
 2e8:	1000                	addi	s0,sp,32
 2ea:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2ec:	4581                	li	a1,0
 2ee:	162000ef          	jal	ra,450 <open>
  if(fd < 0)
 2f2:	02054163          	bltz	a0,314 <stat+0x36>
 2f6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2f8:	85ca                	mv	a1,s2
 2fa:	16e000ef          	jal	ra,468 <fstat>
 2fe:	892a                	mv	s2,a0
  close(fd);
 300:	8526                	mv	a0,s1
 302:	136000ef          	jal	ra,438 <close>
  return r;
}
 306:	854a                	mv	a0,s2
 308:	60e2                	ld	ra,24(sp)
 30a:	6442                	ld	s0,16(sp)
 30c:	64a2                	ld	s1,8(sp)
 30e:	6902                	ld	s2,0(sp)
 310:	6105                	addi	sp,sp,32
 312:	8082                	ret
    return -1;
 314:	597d                	li	s2,-1
 316:	bfc5                	j	306 <stat+0x28>

0000000000000318 <atoi>:

int
atoi(const char *s)
{
 318:	1141                	addi	sp,sp,-16
 31a:	e422                	sd	s0,8(sp)
 31c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 31e:	00054603          	lbu	a2,0(a0)
 322:	fd06079b          	addiw	a5,a2,-48
 326:	0ff7f793          	andi	a5,a5,255
 32a:	4725                	li	a4,9
 32c:	02f76963          	bltu	a4,a5,35e <atoi+0x46>
 330:	86aa                	mv	a3,a0
  n = 0;
 332:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 334:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 336:	0685                	addi	a3,a3,1
 338:	0025179b          	slliw	a5,a0,0x2
 33c:	9fa9                	addw	a5,a5,a0
 33e:	0017979b          	slliw	a5,a5,0x1
 342:	9fb1                	addw	a5,a5,a2
 344:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 348:	0006c603          	lbu	a2,0(a3)
 34c:	fd06071b          	addiw	a4,a2,-48
 350:	0ff77713          	andi	a4,a4,255
 354:	fee5f1e3          	bgeu	a1,a4,336 <atoi+0x1e>
  return n;
}
 358:	6422                	ld	s0,8(sp)
 35a:	0141                	addi	sp,sp,16
 35c:	8082                	ret
  n = 0;
 35e:	4501                	li	a0,0
 360:	bfe5                	j	358 <atoi+0x40>

0000000000000362 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 362:	1141                	addi	sp,sp,-16
 364:	e422                	sd	s0,8(sp)
 366:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 368:	02b57463          	bgeu	a0,a1,390 <memmove+0x2e>
    while(n-- > 0)
 36c:	00c05f63          	blez	a2,38a <memmove+0x28>
 370:	1602                	slli	a2,a2,0x20
 372:	9201                	srli	a2,a2,0x20
 374:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 378:	872a                	mv	a4,a0
      *dst++ = *src++;
 37a:	0585                	addi	a1,a1,1
 37c:	0705                	addi	a4,a4,1
 37e:	fff5c683          	lbu	a3,-1(a1)
 382:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 386:	fee79ae3          	bne	a5,a4,37a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 38a:	6422                	ld	s0,8(sp)
 38c:	0141                	addi	sp,sp,16
 38e:	8082                	ret
    dst += n;
 390:	00c50733          	add	a4,a0,a2
    src += n;
 394:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 396:	fec05ae3          	blez	a2,38a <memmove+0x28>
 39a:	fff6079b          	addiw	a5,a2,-1
 39e:	1782                	slli	a5,a5,0x20
 3a0:	9381                	srli	a5,a5,0x20
 3a2:	fff7c793          	not	a5,a5
 3a6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3a8:	15fd                	addi	a1,a1,-1
 3aa:	177d                	addi	a4,a4,-1
 3ac:	0005c683          	lbu	a3,0(a1)
 3b0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3b4:	fee79ae3          	bne	a5,a4,3a8 <memmove+0x46>
 3b8:	bfc9                	j	38a <memmove+0x28>

00000000000003ba <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3ba:	1141                	addi	sp,sp,-16
 3bc:	e422                	sd	s0,8(sp)
 3be:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3c0:	ca05                	beqz	a2,3f0 <memcmp+0x36>
 3c2:	fff6069b          	addiw	a3,a2,-1
 3c6:	1682                	slli	a3,a3,0x20
 3c8:	9281                	srli	a3,a3,0x20
 3ca:	0685                	addi	a3,a3,1
 3cc:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3ce:	00054783          	lbu	a5,0(a0)
 3d2:	0005c703          	lbu	a4,0(a1)
 3d6:	00e79863          	bne	a5,a4,3e6 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3da:	0505                	addi	a0,a0,1
    p2++;
 3dc:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3de:	fed518e3          	bne	a0,a3,3ce <memcmp+0x14>
  }
  return 0;
 3e2:	4501                	li	a0,0
 3e4:	a019                	j	3ea <memcmp+0x30>
      return *p1 - *p2;
 3e6:	40e7853b          	subw	a0,a5,a4
}
 3ea:	6422                	ld	s0,8(sp)
 3ec:	0141                	addi	sp,sp,16
 3ee:	8082                	ret
  return 0;
 3f0:	4501                	li	a0,0
 3f2:	bfe5                	j	3ea <memcmp+0x30>

00000000000003f4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3f4:	1141                	addi	sp,sp,-16
 3f6:	e406                	sd	ra,8(sp)
 3f8:	e022                	sd	s0,0(sp)
 3fa:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3fc:	f67ff0ef          	jal	ra,362 <memmove>
}
 400:	60a2                	ld	ra,8(sp)
 402:	6402                	ld	s0,0(sp)
 404:	0141                	addi	sp,sp,16
 406:	8082                	ret

0000000000000408 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 408:	4885                	li	a7,1
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <exit>:
.global exit
exit:
 li a7, SYS_exit
 410:	4889                	li	a7,2
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <wait>:
.global wait
wait:
 li a7, SYS_wait
 418:	488d                	li	a7,3
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 420:	4891                	li	a7,4
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <read>:
.global read
read:
 li a7, SYS_read
 428:	4895                	li	a7,5
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <write>:
.global write
write:
 li a7, SYS_write
 430:	48c1                	li	a7,16
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <close>:
.global close
close:
 li a7, SYS_close
 438:	48d5                	li	a7,21
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <kill>:
.global kill
kill:
 li a7, SYS_kill
 440:	4899                	li	a7,6
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <exec>:
.global exec
exec:
 li a7, SYS_exec
 448:	489d                	li	a7,7
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <open>:
.global open
open:
 li a7, SYS_open
 450:	48bd                	li	a7,15
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 458:	48c5                	li	a7,17
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 460:	48c9                	li	a7,18
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 468:	48a1                	li	a7,8
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <link>:
.global link
link:
 li a7, SYS_link
 470:	48cd                	li	a7,19
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 478:	48d1                	li	a7,20
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 480:	48a5                	li	a7,9
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <dup>:
.global dup
dup:
 li a7, SYS_dup
 488:	48a9                	li	a7,10
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 490:	48ad                	li	a7,11
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 498:	48b1                	li	a7,12
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4a0:	48b5                	li	a7,13
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4a8:	48b9                	li	a7,14
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 4b0:	48d9                	li	a7,22
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4b8:	1101                	addi	sp,sp,-32
 4ba:	ec06                	sd	ra,24(sp)
 4bc:	e822                	sd	s0,16(sp)
 4be:	1000                	addi	s0,sp,32
 4c0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4c4:	4605                	li	a2,1
 4c6:	fef40593          	addi	a1,s0,-17
 4ca:	f67ff0ef          	jal	ra,430 <write>
}
 4ce:	60e2                	ld	ra,24(sp)
 4d0:	6442                	ld	s0,16(sp)
 4d2:	6105                	addi	sp,sp,32
 4d4:	8082                	ret

00000000000004d6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4d6:	7139                	addi	sp,sp,-64
 4d8:	fc06                	sd	ra,56(sp)
 4da:	f822                	sd	s0,48(sp)
 4dc:	f426                	sd	s1,40(sp)
 4de:	f04a                	sd	s2,32(sp)
 4e0:	ec4e                	sd	s3,24(sp)
 4e2:	0080                	addi	s0,sp,64
 4e4:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4e6:	c299                	beqz	a3,4ec <printint+0x16>
 4e8:	0805c663          	bltz	a1,574 <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4ec:	2581                	sext.w	a1,a1
  neg = 0;
 4ee:	4881                	li	a7,0
 4f0:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4f4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4f6:	2601                	sext.w	a2,a2
 4f8:	00000517          	auipc	a0,0x0
 4fc:	5e050513          	addi	a0,a0,1504 # ad8 <digits>
 500:	883a                	mv	a6,a4
 502:	2705                	addiw	a4,a4,1
 504:	02c5f7bb          	remuw	a5,a1,a2
 508:	1782                	slli	a5,a5,0x20
 50a:	9381                	srli	a5,a5,0x20
 50c:	97aa                	add	a5,a5,a0
 50e:	0007c783          	lbu	a5,0(a5)
 512:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 516:	0005879b          	sext.w	a5,a1
 51a:	02c5d5bb          	divuw	a1,a1,a2
 51e:	0685                	addi	a3,a3,1
 520:	fec7f0e3          	bgeu	a5,a2,500 <printint+0x2a>
  if(neg)
 524:	00088b63          	beqz	a7,53a <printint+0x64>
    buf[i++] = '-';
 528:	fd040793          	addi	a5,s0,-48
 52c:	973e                	add	a4,a4,a5
 52e:	02d00793          	li	a5,45
 532:	fef70823          	sb	a5,-16(a4)
 536:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 53a:	02e05663          	blez	a4,566 <printint+0x90>
 53e:	fc040793          	addi	a5,s0,-64
 542:	00e78933          	add	s2,a5,a4
 546:	fff78993          	addi	s3,a5,-1
 54a:	99ba                	add	s3,s3,a4
 54c:	377d                	addiw	a4,a4,-1
 54e:	1702                	slli	a4,a4,0x20
 550:	9301                	srli	a4,a4,0x20
 552:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 556:	fff94583          	lbu	a1,-1(s2)
 55a:	8526                	mv	a0,s1
 55c:	f5dff0ef          	jal	ra,4b8 <putc>
  while(--i >= 0)
 560:	197d                	addi	s2,s2,-1
 562:	ff391ae3          	bne	s2,s3,556 <printint+0x80>
}
 566:	70e2                	ld	ra,56(sp)
 568:	7442                	ld	s0,48(sp)
 56a:	74a2                	ld	s1,40(sp)
 56c:	7902                	ld	s2,32(sp)
 56e:	69e2                	ld	s3,24(sp)
 570:	6121                	addi	sp,sp,64
 572:	8082                	ret
    x = -xx;
 574:	40b005bb          	negw	a1,a1
    neg = 1;
 578:	4885                	li	a7,1
    x = -xx;
 57a:	bf9d                	j	4f0 <printint+0x1a>

000000000000057c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 57c:	7119                	addi	sp,sp,-128
 57e:	fc86                	sd	ra,120(sp)
 580:	f8a2                	sd	s0,112(sp)
 582:	f4a6                	sd	s1,104(sp)
 584:	f0ca                	sd	s2,96(sp)
 586:	ecce                	sd	s3,88(sp)
 588:	e8d2                	sd	s4,80(sp)
 58a:	e4d6                	sd	s5,72(sp)
 58c:	e0da                	sd	s6,64(sp)
 58e:	fc5e                	sd	s7,56(sp)
 590:	f862                	sd	s8,48(sp)
 592:	f466                	sd	s9,40(sp)
 594:	f06a                	sd	s10,32(sp)
 596:	ec6e                	sd	s11,24(sp)
 598:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 59a:	0005c903          	lbu	s2,0(a1)
 59e:	22090e63          	beqz	s2,7da <vprintf+0x25e>
 5a2:	8b2a                	mv	s6,a0
 5a4:	8a2e                	mv	s4,a1
 5a6:	8bb2                	mv	s7,a2
  state = 0;
 5a8:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5aa:	4481                	li	s1,0
 5ac:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5ae:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5b2:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5b6:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 5ba:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5be:	00000c97          	auipc	s9,0x0
 5c2:	51ac8c93          	addi	s9,s9,1306 # ad8 <digits>
 5c6:	a005                	j	5e6 <vprintf+0x6a>
        putc(fd, c0);
 5c8:	85ca                	mv	a1,s2
 5ca:	855a                	mv	a0,s6
 5cc:	eedff0ef          	jal	ra,4b8 <putc>
 5d0:	a019                	j	5d6 <vprintf+0x5a>
    } else if(state == '%'){
 5d2:	03598263          	beq	s3,s5,5f6 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 5d6:	2485                	addiw	s1,s1,1
 5d8:	8726                	mv	a4,s1
 5da:	009a07b3          	add	a5,s4,s1
 5de:	0007c903          	lbu	s2,0(a5)
 5e2:	1e090c63          	beqz	s2,7da <vprintf+0x25e>
    c0 = fmt[i] & 0xff;
 5e6:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5ea:	fe0994e3          	bnez	s3,5d2 <vprintf+0x56>
      if(c0 == '%'){
 5ee:	fd579de3          	bne	a5,s5,5c8 <vprintf+0x4c>
        state = '%';
 5f2:	89be                	mv	s3,a5
 5f4:	b7cd                	j	5d6 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 5f6:	cfa5                	beqz	a5,66e <vprintf+0xf2>
 5f8:	00ea06b3          	add	a3,s4,a4
 5fc:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 600:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 602:	c681                	beqz	a3,60a <vprintf+0x8e>
 604:	9752                	add	a4,a4,s4
 606:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 60a:	03878a63          	beq	a5,s8,63e <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 60e:	05a78463          	beq	a5,s10,656 <vprintf+0xda>
      } else if(c0 == 'u'){
 612:	0db78763          	beq	a5,s11,6e0 <vprintf+0x164>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 616:	07800713          	li	a4,120
 61a:	10e78963          	beq	a5,a4,72c <vprintf+0x1b0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 61e:	07000713          	li	a4,112
 622:	12e78e63          	beq	a5,a4,75e <vprintf+0x1e2>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 626:	07300713          	li	a4,115
 62a:	16e78b63          	beq	a5,a4,7a0 <vprintf+0x224>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 62e:	05579063          	bne	a5,s5,66e <vprintf+0xf2>
        putc(fd, '%');
 632:	85d6                	mv	a1,s5
 634:	855a                	mv	a0,s6
 636:	e83ff0ef          	jal	ra,4b8 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 63a:	4981                	li	s3,0
 63c:	bf69                	j	5d6 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 63e:	008b8913          	addi	s2,s7,8
 642:	4685                	li	a3,1
 644:	4629                	li	a2,10
 646:	000ba583          	lw	a1,0(s7)
 64a:	855a                	mv	a0,s6
 64c:	e8bff0ef          	jal	ra,4d6 <printint>
 650:	8bca                	mv	s7,s2
      state = 0;
 652:	4981                	li	s3,0
 654:	b749                	j	5d6 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 656:	03868663          	beq	a3,s8,682 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 65a:	05a68163          	beq	a3,s10,69c <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'u'){
 65e:	09b68d63          	beq	a3,s11,6f8 <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 662:	03a68f63          	beq	a3,s10,6a0 <vprintf+0x124>
      } else if(c0 == 'l' && c1 == 'x'){
 666:	07800793          	li	a5,120
 66a:	0cf68d63          	beq	a3,a5,744 <vprintf+0x1c8>
        putc(fd, '%');
 66e:	85d6                	mv	a1,s5
 670:	855a                	mv	a0,s6
 672:	e47ff0ef          	jal	ra,4b8 <putc>
        putc(fd, c0);
 676:	85ca                	mv	a1,s2
 678:	855a                	mv	a0,s6
 67a:	e3fff0ef          	jal	ra,4b8 <putc>
      state = 0;
 67e:	4981                	li	s3,0
 680:	bf99                	j	5d6 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 682:	008b8913          	addi	s2,s7,8
 686:	4685                	li	a3,1
 688:	4629                	li	a2,10
 68a:	000ba583          	lw	a1,0(s7)
 68e:	855a                	mv	a0,s6
 690:	e47ff0ef          	jal	ra,4d6 <printint>
        i += 1;
 694:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 696:	8bca                	mv	s7,s2
      state = 0;
 698:	4981                	li	s3,0
        i += 1;
 69a:	bf35                	j	5d6 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 69c:	03860563          	beq	a2,s8,6c6 <vprintf+0x14a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6a0:	07b60963          	beq	a2,s11,712 <vprintf+0x196>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6a4:	07800793          	li	a5,120
 6a8:	fcf613e3          	bne	a2,a5,66e <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ac:	008b8913          	addi	s2,s7,8
 6b0:	4681                	li	a3,0
 6b2:	4641                	li	a2,16
 6b4:	000ba583          	lw	a1,0(s7)
 6b8:	855a                	mv	a0,s6
 6ba:	e1dff0ef          	jal	ra,4d6 <printint>
        i += 2;
 6be:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6c0:	8bca                	mv	s7,s2
      state = 0;
 6c2:	4981                	li	s3,0
        i += 2;
 6c4:	bf09                	j	5d6 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6c6:	008b8913          	addi	s2,s7,8
 6ca:	4685                	li	a3,1
 6cc:	4629                	li	a2,10
 6ce:	000ba583          	lw	a1,0(s7)
 6d2:	855a                	mv	a0,s6
 6d4:	e03ff0ef          	jal	ra,4d6 <printint>
        i += 2;
 6d8:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6da:	8bca                	mv	s7,s2
      state = 0;
 6dc:	4981                	li	s3,0
        i += 2;
 6de:	bde5                	j	5d6 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 0);
 6e0:	008b8913          	addi	s2,s7,8
 6e4:	4681                	li	a3,0
 6e6:	4629                	li	a2,10
 6e8:	000ba583          	lw	a1,0(s7)
 6ec:	855a                	mv	a0,s6
 6ee:	de9ff0ef          	jal	ra,4d6 <printint>
 6f2:	8bca                	mv	s7,s2
      state = 0;
 6f4:	4981                	li	s3,0
 6f6:	b5c5                	j	5d6 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6f8:	008b8913          	addi	s2,s7,8
 6fc:	4681                	li	a3,0
 6fe:	4629                	li	a2,10
 700:	000ba583          	lw	a1,0(s7)
 704:	855a                	mv	a0,s6
 706:	dd1ff0ef          	jal	ra,4d6 <printint>
        i += 1;
 70a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 70c:	8bca                	mv	s7,s2
      state = 0;
 70e:	4981                	li	s3,0
        i += 1;
 710:	b5d9                	j	5d6 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 712:	008b8913          	addi	s2,s7,8
 716:	4681                	li	a3,0
 718:	4629                	li	a2,10
 71a:	000ba583          	lw	a1,0(s7)
 71e:	855a                	mv	a0,s6
 720:	db7ff0ef          	jal	ra,4d6 <printint>
        i += 2;
 724:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 726:	8bca                	mv	s7,s2
      state = 0;
 728:	4981                	li	s3,0
        i += 2;
 72a:	b575                	j	5d6 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 16, 0);
 72c:	008b8913          	addi	s2,s7,8
 730:	4681                	li	a3,0
 732:	4641                	li	a2,16
 734:	000ba583          	lw	a1,0(s7)
 738:	855a                	mv	a0,s6
 73a:	d9dff0ef          	jal	ra,4d6 <printint>
 73e:	8bca                	mv	s7,s2
      state = 0;
 740:	4981                	li	s3,0
 742:	bd51                	j	5d6 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 744:	008b8913          	addi	s2,s7,8
 748:	4681                	li	a3,0
 74a:	4641                	li	a2,16
 74c:	000ba583          	lw	a1,0(s7)
 750:	855a                	mv	a0,s6
 752:	d85ff0ef          	jal	ra,4d6 <printint>
        i += 1;
 756:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 758:	8bca                	mv	s7,s2
      state = 0;
 75a:	4981                	li	s3,0
        i += 1;
 75c:	bdad                	j	5d6 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 75e:	008b8793          	addi	a5,s7,8
 762:	f8f43423          	sd	a5,-120(s0)
 766:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 76a:	03000593          	li	a1,48
 76e:	855a                	mv	a0,s6
 770:	d49ff0ef          	jal	ra,4b8 <putc>
  putc(fd, 'x');
 774:	07800593          	li	a1,120
 778:	855a                	mv	a0,s6
 77a:	d3fff0ef          	jal	ra,4b8 <putc>
 77e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 780:	03c9d793          	srli	a5,s3,0x3c
 784:	97e6                	add	a5,a5,s9
 786:	0007c583          	lbu	a1,0(a5)
 78a:	855a                	mv	a0,s6
 78c:	d2dff0ef          	jal	ra,4b8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 790:	0992                	slli	s3,s3,0x4
 792:	397d                	addiw	s2,s2,-1
 794:	fe0916e3          	bnez	s2,780 <vprintf+0x204>
        printptr(fd, va_arg(ap, uint64));
 798:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 79c:	4981                	li	s3,0
 79e:	bd25                	j	5d6 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 7a0:	008b8993          	addi	s3,s7,8
 7a4:	000bb903          	ld	s2,0(s7)
 7a8:	00090f63          	beqz	s2,7c6 <vprintf+0x24a>
        for(; *s; s++)
 7ac:	00094583          	lbu	a1,0(s2)
 7b0:	c195                	beqz	a1,7d4 <vprintf+0x258>
          putc(fd, *s);
 7b2:	855a                	mv	a0,s6
 7b4:	d05ff0ef          	jal	ra,4b8 <putc>
        for(; *s; s++)
 7b8:	0905                	addi	s2,s2,1
 7ba:	00094583          	lbu	a1,0(s2)
 7be:	f9f5                	bnez	a1,7b2 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 7c0:	8bce                	mv	s7,s3
      state = 0;
 7c2:	4981                	li	s3,0
 7c4:	bd09                	j	5d6 <vprintf+0x5a>
          s = "(null)";
 7c6:	00000917          	auipc	s2,0x0
 7ca:	30a90913          	addi	s2,s2,778 # ad0 <malloc+0x1f4>
        for(; *s; s++)
 7ce:	02800593          	li	a1,40
 7d2:	b7c5                	j	7b2 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 7d4:	8bce                	mv	s7,s3
      state = 0;
 7d6:	4981                	li	s3,0
 7d8:	bbfd                	j	5d6 <vprintf+0x5a>
    }
  }
}
 7da:	70e6                	ld	ra,120(sp)
 7dc:	7446                	ld	s0,112(sp)
 7de:	74a6                	ld	s1,104(sp)
 7e0:	7906                	ld	s2,96(sp)
 7e2:	69e6                	ld	s3,88(sp)
 7e4:	6a46                	ld	s4,80(sp)
 7e6:	6aa6                	ld	s5,72(sp)
 7e8:	6b06                	ld	s6,64(sp)
 7ea:	7be2                	ld	s7,56(sp)
 7ec:	7c42                	ld	s8,48(sp)
 7ee:	7ca2                	ld	s9,40(sp)
 7f0:	7d02                	ld	s10,32(sp)
 7f2:	6de2                	ld	s11,24(sp)
 7f4:	6109                	addi	sp,sp,128
 7f6:	8082                	ret

00000000000007f8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7f8:	715d                	addi	sp,sp,-80
 7fa:	ec06                	sd	ra,24(sp)
 7fc:	e822                	sd	s0,16(sp)
 7fe:	1000                	addi	s0,sp,32
 800:	e010                	sd	a2,0(s0)
 802:	e414                	sd	a3,8(s0)
 804:	e818                	sd	a4,16(s0)
 806:	ec1c                	sd	a5,24(s0)
 808:	03043023          	sd	a6,32(s0)
 80c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 810:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 814:	8622                	mv	a2,s0
 816:	d67ff0ef          	jal	ra,57c <vprintf>
}
 81a:	60e2                	ld	ra,24(sp)
 81c:	6442                	ld	s0,16(sp)
 81e:	6161                	addi	sp,sp,80
 820:	8082                	ret

0000000000000822 <printf>:

void
printf(const char *fmt, ...)
{
 822:	711d                	addi	sp,sp,-96
 824:	ec06                	sd	ra,24(sp)
 826:	e822                	sd	s0,16(sp)
 828:	1000                	addi	s0,sp,32
 82a:	e40c                	sd	a1,8(s0)
 82c:	e810                	sd	a2,16(s0)
 82e:	ec14                	sd	a3,24(s0)
 830:	f018                	sd	a4,32(s0)
 832:	f41c                	sd	a5,40(s0)
 834:	03043823          	sd	a6,48(s0)
 838:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 83c:	00840613          	addi	a2,s0,8
 840:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 844:	85aa                	mv	a1,a0
 846:	4505                	li	a0,1
 848:	d35ff0ef          	jal	ra,57c <vprintf>
}
 84c:	60e2                	ld	ra,24(sp)
 84e:	6442                	ld	s0,16(sp)
 850:	6125                	addi	sp,sp,96
 852:	8082                	ret

0000000000000854 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 854:	1141                	addi	sp,sp,-16
 856:	e422                	sd	s0,8(sp)
 858:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 85a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 85e:	00000797          	auipc	a5,0x0
 862:	7b27b783          	ld	a5,1970(a5) # 1010 <freep>
 866:	a805                	j	896 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 868:	4618                	lw	a4,8(a2)
 86a:	9db9                	addw	a1,a1,a4
 86c:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 870:	6398                	ld	a4,0(a5)
 872:	6318                	ld	a4,0(a4)
 874:	fee53823          	sd	a4,-16(a0)
 878:	a091                	j	8bc <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 87a:	ff852703          	lw	a4,-8(a0)
 87e:	9e39                	addw	a2,a2,a4
 880:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 882:	ff053703          	ld	a4,-16(a0)
 886:	e398                	sd	a4,0(a5)
 888:	a099                	j	8ce <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 88a:	6398                	ld	a4,0(a5)
 88c:	00e7e463          	bltu	a5,a4,894 <free+0x40>
 890:	00e6ea63          	bltu	a3,a4,8a4 <free+0x50>
{
 894:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 896:	fed7fae3          	bgeu	a5,a3,88a <free+0x36>
 89a:	6398                	ld	a4,0(a5)
 89c:	00e6e463          	bltu	a3,a4,8a4 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a0:	fee7eae3          	bltu	a5,a4,894 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 8a4:	ff852583          	lw	a1,-8(a0)
 8a8:	6390                	ld	a2,0(a5)
 8aa:	02059713          	slli	a4,a1,0x20
 8ae:	9301                	srli	a4,a4,0x20
 8b0:	0712                	slli	a4,a4,0x4
 8b2:	9736                	add	a4,a4,a3
 8b4:	fae60ae3          	beq	a2,a4,868 <free+0x14>
    bp->s.ptr = p->s.ptr;
 8b8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8bc:	4790                	lw	a2,8(a5)
 8be:	02061713          	slli	a4,a2,0x20
 8c2:	9301                	srli	a4,a4,0x20
 8c4:	0712                	slli	a4,a4,0x4
 8c6:	973e                	add	a4,a4,a5
 8c8:	fae689e3          	beq	a3,a4,87a <free+0x26>
  } else
    p->s.ptr = bp;
 8cc:	e394                	sd	a3,0(a5)
  freep = p;
 8ce:	00000717          	auipc	a4,0x0
 8d2:	74f73123          	sd	a5,1858(a4) # 1010 <freep>
}
 8d6:	6422                	ld	s0,8(sp)
 8d8:	0141                	addi	sp,sp,16
 8da:	8082                	ret

00000000000008dc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8dc:	7139                	addi	sp,sp,-64
 8de:	fc06                	sd	ra,56(sp)
 8e0:	f822                	sd	s0,48(sp)
 8e2:	f426                	sd	s1,40(sp)
 8e4:	f04a                	sd	s2,32(sp)
 8e6:	ec4e                	sd	s3,24(sp)
 8e8:	e852                	sd	s4,16(sp)
 8ea:	e456                	sd	s5,8(sp)
 8ec:	e05a                	sd	s6,0(sp)
 8ee:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8f0:	02051493          	slli	s1,a0,0x20
 8f4:	9081                	srli	s1,s1,0x20
 8f6:	04bd                	addi	s1,s1,15
 8f8:	8091                	srli	s1,s1,0x4
 8fa:	0014899b          	addiw	s3,s1,1
 8fe:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 900:	00000517          	auipc	a0,0x0
 904:	71053503          	ld	a0,1808(a0) # 1010 <freep>
 908:	c515                	beqz	a0,934 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 90a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 90c:	4798                	lw	a4,8(a5)
 90e:	02977f63          	bgeu	a4,s1,94c <malloc+0x70>
 912:	8a4e                	mv	s4,s3
 914:	0009871b          	sext.w	a4,s3
 918:	6685                	lui	a3,0x1
 91a:	00d77363          	bgeu	a4,a3,920 <malloc+0x44>
 91e:	6a05                	lui	s4,0x1
 920:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 924:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 928:	00000917          	auipc	s2,0x0
 92c:	6e890913          	addi	s2,s2,1768 # 1010 <freep>
  if(p == (char*)-1)
 930:	5afd                	li	s5,-1
 932:	a0bd                	j	9a0 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 934:	00000797          	auipc	a5,0x0
 938:	6ec78793          	addi	a5,a5,1772 # 1020 <base>
 93c:	00000717          	auipc	a4,0x0
 940:	6cf73a23          	sd	a5,1748(a4) # 1010 <freep>
 944:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 946:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 94a:	b7e1                	j	912 <malloc+0x36>
      if(p->s.size == nunits)
 94c:	02e48b63          	beq	s1,a4,982 <malloc+0xa6>
        p->s.size -= nunits;
 950:	4137073b          	subw	a4,a4,s3
 954:	c798                	sw	a4,8(a5)
        p += p->s.size;
 956:	1702                	slli	a4,a4,0x20
 958:	9301                	srli	a4,a4,0x20
 95a:	0712                	slli	a4,a4,0x4
 95c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 95e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 962:	00000717          	auipc	a4,0x0
 966:	6aa73723          	sd	a0,1710(a4) # 1010 <freep>
      return (void*)(p + 1);
 96a:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 96e:	70e2                	ld	ra,56(sp)
 970:	7442                	ld	s0,48(sp)
 972:	74a2                	ld	s1,40(sp)
 974:	7902                	ld	s2,32(sp)
 976:	69e2                	ld	s3,24(sp)
 978:	6a42                	ld	s4,16(sp)
 97a:	6aa2                	ld	s5,8(sp)
 97c:	6b02                	ld	s6,0(sp)
 97e:	6121                	addi	sp,sp,64
 980:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 982:	6398                	ld	a4,0(a5)
 984:	e118                	sd	a4,0(a0)
 986:	bff1                	j	962 <malloc+0x86>
  hp->s.size = nu;
 988:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 98c:	0541                	addi	a0,a0,16
 98e:	ec7ff0ef          	jal	ra,854 <free>
  return freep;
 992:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 996:	dd61                	beqz	a0,96e <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 998:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 99a:	4798                	lw	a4,8(a5)
 99c:	fa9778e3          	bgeu	a4,s1,94c <malloc+0x70>
    if(p == freep)
 9a0:	00093703          	ld	a4,0(s2)
 9a4:	853e                	mv	a0,a5
 9a6:	fef719e3          	bne	a4,a5,998 <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 9aa:	8552                	mv	a0,s4
 9ac:	aedff0ef          	jal	ra,498 <sbrk>
  if(p == (char*)-1)
 9b0:	fd551ce3          	bne	a0,s5,988 <malloc+0xac>
        return 0;
 9b4:	4501                	li	a0,0
 9b6:	bf65                	j	96e <malloc+0x92>
