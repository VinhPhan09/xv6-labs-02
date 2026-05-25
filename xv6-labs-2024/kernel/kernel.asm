
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00019117          	auipc	sp,0x19
    80000004:	d7010113          	addi	sp,sp,-656 # 80018d70 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	5ab040ef          	jal	ra,80004dc0 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	e7a9                	bnez	a5,80000076 <kfree+0x5a>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00021797          	auipc	a5,0x21
    80000034:	e4078793          	addi	a5,a5,-448 # 80020e70 <end>
    80000038:	02f56f63          	bltu	a0,a5,80000076 <kfree+0x5a>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	02f57b63          	bgeu	a0,a5,80000076 <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	104000ef          	jal	ra,8000014c <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    8000004c:	00008917          	auipc	s2,0x8
    80000050:	8f490913          	addi	s2,s2,-1804 # 80007940 <kmem>
    80000054:	854a                	mv	a0,s2
    80000056:	774050ef          	jal	ra,800057ca <acquire>
  r->next = kmem.freelist;
    8000005a:	01893783          	ld	a5,24(s2)
    8000005e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000060:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000064:	854a                	mv	a0,s2
    80000066:	7fc050ef          	jal	ra,80005862 <release>
}
    8000006a:	60e2                	ld	ra,24(sp)
    8000006c:	6442                	ld	s0,16(sp)
    8000006e:	64a2                	ld	s1,8(sp)
    80000070:	6902                	ld	s2,0(sp)
    80000072:	6105                	addi	sp,sp,32
    80000074:	8082                	ret
    panic("kfree");
    80000076:	00007517          	auipc	a0,0x7
    8000007a:	f9a50513          	addi	a0,a0,-102 # 80007010 <etext+0x10>
    8000007e:	438050ef          	jal	ra,800054b6 <panic>

0000000080000082 <freerange>:
{
    80000082:	7179                	addi	sp,sp,-48
    80000084:	f406                	sd	ra,40(sp)
    80000086:	f022                	sd	s0,32(sp)
    80000088:	ec26                	sd	s1,24(sp)
    8000008a:	e84a                	sd	s2,16(sp)
    8000008c:	e44e                	sd	s3,8(sp)
    8000008e:	e052                	sd	s4,0(sp)
    80000090:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000092:	6785                	lui	a5,0x1
    80000094:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80000098:	94aa                	add	s1,s1,a0
    8000009a:	757d                	lui	a0,0xfffff
    8000009c:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000009e:	94be                	add	s1,s1,a5
    800000a0:	0095ec63          	bltu	a1,s1,800000b8 <freerange+0x36>
    800000a4:	892e                	mv	s2,a1
    kfree(p);
    800000a6:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000a8:	6985                	lui	s3,0x1
    kfree(p);
    800000aa:	01448533          	add	a0,s1,s4
    800000ae:	f6fff0ef          	jal	ra,8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b2:	94ce                	add	s1,s1,s3
    800000b4:	fe997be3          	bgeu	s2,s1,800000aa <freerange+0x28>
}
    800000b8:	70a2                	ld	ra,40(sp)
    800000ba:	7402                	ld	s0,32(sp)
    800000bc:	64e2                	ld	s1,24(sp)
    800000be:	6942                	ld	s2,16(sp)
    800000c0:	69a2                	ld	s3,8(sp)
    800000c2:	6a02                	ld	s4,0(sp)
    800000c4:	6145                	addi	sp,sp,48
    800000c6:	8082                	ret

00000000800000c8 <kinit>:
{
    800000c8:	1141                	addi	sp,sp,-16
    800000ca:	e406                	sd	ra,8(sp)
    800000cc:	e022                	sd	s0,0(sp)
    800000ce:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000d0:	00007597          	auipc	a1,0x7
    800000d4:	f4858593          	addi	a1,a1,-184 # 80007018 <etext+0x18>
    800000d8:	00008517          	auipc	a0,0x8
    800000dc:	86850513          	addi	a0,a0,-1944 # 80007940 <kmem>
    800000e0:	66a050ef          	jal	ra,8000574a <initlock>
  freerange(end, (void*)PHYSTOP);
    800000e4:	45c5                	li	a1,17
    800000e6:	05ee                	slli	a1,a1,0x1b
    800000e8:	00021517          	auipc	a0,0x21
    800000ec:	d8850513          	addi	a0,a0,-632 # 80020e70 <end>
    800000f0:	f93ff0ef          	jal	ra,80000082 <freerange>
}
    800000f4:	60a2                	ld	ra,8(sp)
    800000f6:	6402                	ld	s0,0(sp)
    800000f8:	0141                	addi	sp,sp,16
    800000fa:	8082                	ret

00000000800000fc <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    800000fc:	1101                	addi	sp,sp,-32
    800000fe:	ec06                	sd	ra,24(sp)
    80000100:	e822                	sd	s0,16(sp)
    80000102:	e426                	sd	s1,8(sp)
    80000104:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000106:	00008497          	auipc	s1,0x8
    8000010a:	83a48493          	addi	s1,s1,-1990 # 80007940 <kmem>
    8000010e:	8526                	mv	a0,s1
    80000110:	6ba050ef          	jal	ra,800057ca <acquire>
  r = kmem.freelist;
    80000114:	6c84                	ld	s1,24(s1)
  if(r)
    80000116:	c485                	beqz	s1,8000013e <kalloc+0x42>
    kmem.freelist = r->next;
    80000118:	609c                	ld	a5,0(s1)
    8000011a:	00008517          	auipc	a0,0x8
    8000011e:	82650513          	addi	a0,a0,-2010 # 80007940 <kmem>
    80000122:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000124:	73e050ef          	jal	ra,80005862 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000128:	6605                	lui	a2,0x1
    8000012a:	4595                	li	a1,5
    8000012c:	8526                	mv	a0,s1
    8000012e:	01e000ef          	jal	ra,8000014c <memset>
  return (void*)r;
}
    80000132:	8526                	mv	a0,s1
    80000134:	60e2                	ld	ra,24(sp)
    80000136:	6442                	ld	s0,16(sp)
    80000138:	64a2                	ld	s1,8(sp)
    8000013a:	6105                	addi	sp,sp,32
    8000013c:	8082                	ret
  release(&kmem.lock);
    8000013e:	00008517          	auipc	a0,0x8
    80000142:	80250513          	addi	a0,a0,-2046 # 80007940 <kmem>
    80000146:	71c050ef          	jal	ra,80005862 <release>
  if(r)
    8000014a:	b7e5                	j	80000132 <kalloc+0x36>

000000008000014c <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000014c:	1141                	addi	sp,sp,-16
    8000014e:	e422                	sd	s0,8(sp)
    80000150:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000152:	ca19                	beqz	a2,80000168 <memset+0x1c>
    80000154:	87aa                	mv	a5,a0
    80000156:	1602                	slli	a2,a2,0x20
    80000158:	9201                	srli	a2,a2,0x20
    8000015a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000015e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000162:	0785                	addi	a5,a5,1
    80000164:	fee79de3          	bne	a5,a4,8000015e <memset+0x12>
  }
  return dst;
}
    80000168:	6422                	ld	s0,8(sp)
    8000016a:	0141                	addi	sp,sp,16
    8000016c:	8082                	ret

000000008000016e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000016e:	1141                	addi	sp,sp,-16
    80000170:	e422                	sd	s0,8(sp)
    80000172:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000174:	ca05                	beqz	a2,800001a4 <memcmp+0x36>
    80000176:	fff6069b          	addiw	a3,a2,-1
    8000017a:	1682                	slli	a3,a3,0x20
    8000017c:	9281                	srli	a3,a3,0x20
    8000017e:	0685                	addi	a3,a3,1
    80000180:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000182:	00054783          	lbu	a5,0(a0)
    80000186:	0005c703          	lbu	a4,0(a1)
    8000018a:	00e79863          	bne	a5,a4,8000019a <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    8000018e:	0505                	addi	a0,a0,1
    80000190:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000192:	fed518e3          	bne	a0,a3,80000182 <memcmp+0x14>
  }

  return 0;
    80000196:	4501                	li	a0,0
    80000198:	a019                	j	8000019e <memcmp+0x30>
      return *s1 - *s2;
    8000019a:	40e7853b          	subw	a0,a5,a4
}
    8000019e:	6422                	ld	s0,8(sp)
    800001a0:	0141                	addi	sp,sp,16
    800001a2:	8082                	ret
  return 0;
    800001a4:	4501                	li	a0,0
    800001a6:	bfe5                	j	8000019e <memcmp+0x30>

00000000800001a8 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001a8:	1141                	addi	sp,sp,-16
    800001aa:	e422                	sd	s0,8(sp)
    800001ac:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001ae:	c205                	beqz	a2,800001ce <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001b0:	02a5e263          	bltu	a1,a0,800001d4 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001b4:	1602                	slli	a2,a2,0x20
    800001b6:	9201                	srli	a2,a2,0x20
    800001b8:	00c587b3          	add	a5,a1,a2
{
    800001bc:	872a                	mv	a4,a0
      *d++ = *s++;
    800001be:	0585                	addi	a1,a1,1
    800001c0:	0705                	addi	a4,a4,1
    800001c2:	fff5c683          	lbu	a3,-1(a1)
    800001c6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001ca:	fef59ae3          	bne	a1,a5,800001be <memmove+0x16>

  return dst;
}
    800001ce:	6422                	ld	s0,8(sp)
    800001d0:	0141                	addi	sp,sp,16
    800001d2:	8082                	ret
  if(s < d && s + n > d){
    800001d4:	02061693          	slli	a3,a2,0x20
    800001d8:	9281                	srli	a3,a3,0x20
    800001da:	00d58733          	add	a4,a1,a3
    800001de:	fce57be3          	bgeu	a0,a4,800001b4 <memmove+0xc>
    d += n;
    800001e2:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    800001e4:	fff6079b          	addiw	a5,a2,-1
    800001e8:	1782                	slli	a5,a5,0x20
    800001ea:	9381                	srli	a5,a5,0x20
    800001ec:	fff7c793          	not	a5,a5
    800001f0:	97ba                	add	a5,a5,a4
      *--d = *--s;
    800001f2:	177d                	addi	a4,a4,-1
    800001f4:	16fd                	addi	a3,a3,-1
    800001f6:	00074603          	lbu	a2,0(a4)
    800001fa:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    800001fe:	fee79ae3          	bne	a5,a4,800001f2 <memmove+0x4a>
    80000202:	b7f1                	j	800001ce <memmove+0x26>

0000000080000204 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000204:	1141                	addi	sp,sp,-16
    80000206:	e406                	sd	ra,8(sp)
    80000208:	e022                	sd	s0,0(sp)
    8000020a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000020c:	f9dff0ef          	jal	ra,800001a8 <memmove>
}
    80000210:	60a2                	ld	ra,8(sp)
    80000212:	6402                	ld	s0,0(sp)
    80000214:	0141                	addi	sp,sp,16
    80000216:	8082                	ret

0000000080000218 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000218:	1141                	addi	sp,sp,-16
    8000021a:	e422                	sd	s0,8(sp)
    8000021c:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000021e:	ce11                	beqz	a2,8000023a <strncmp+0x22>
    80000220:	00054783          	lbu	a5,0(a0)
    80000224:	cf89                	beqz	a5,8000023e <strncmp+0x26>
    80000226:	0005c703          	lbu	a4,0(a1)
    8000022a:	00f71a63          	bne	a4,a5,8000023e <strncmp+0x26>
    n--, p++, q++;
    8000022e:	367d                	addiw	a2,a2,-1
    80000230:	0505                	addi	a0,a0,1
    80000232:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000234:	f675                	bnez	a2,80000220 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000236:	4501                	li	a0,0
    80000238:	a809                	j	8000024a <strncmp+0x32>
    8000023a:	4501                	li	a0,0
    8000023c:	a039                	j	8000024a <strncmp+0x32>
  if(n == 0)
    8000023e:	ca09                	beqz	a2,80000250 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000240:	00054503          	lbu	a0,0(a0)
    80000244:	0005c783          	lbu	a5,0(a1)
    80000248:	9d1d                	subw	a0,a0,a5
}
    8000024a:	6422                	ld	s0,8(sp)
    8000024c:	0141                	addi	sp,sp,16
    8000024e:	8082                	ret
    return 0;
    80000250:	4501                	li	a0,0
    80000252:	bfe5                	j	8000024a <strncmp+0x32>

0000000080000254 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000254:	1141                	addi	sp,sp,-16
    80000256:	e422                	sd	s0,8(sp)
    80000258:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000025a:	872a                	mv	a4,a0
    8000025c:	8832                	mv	a6,a2
    8000025e:	367d                	addiw	a2,a2,-1
    80000260:	01005963          	blez	a6,80000272 <strncpy+0x1e>
    80000264:	0705                	addi	a4,a4,1
    80000266:	0005c783          	lbu	a5,0(a1)
    8000026a:	fef70fa3          	sb	a5,-1(a4)
    8000026e:	0585                	addi	a1,a1,1
    80000270:	f7f5                	bnez	a5,8000025c <strncpy+0x8>
    ;
  while(n-- > 0)
    80000272:	86ba                	mv	a3,a4
    80000274:	00c05c63          	blez	a2,8000028c <strncpy+0x38>
    *s++ = 0;
    80000278:	0685                	addi	a3,a3,1
    8000027a:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    8000027e:	fff6c793          	not	a5,a3
    80000282:	9fb9                	addw	a5,a5,a4
    80000284:	010787bb          	addw	a5,a5,a6
    80000288:	fef048e3          	bgtz	a5,80000278 <strncpy+0x24>
  return os;
}
    8000028c:	6422                	ld	s0,8(sp)
    8000028e:	0141                	addi	sp,sp,16
    80000290:	8082                	ret

0000000080000292 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000292:	1141                	addi	sp,sp,-16
    80000294:	e422                	sd	s0,8(sp)
    80000296:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000298:	02c05363          	blez	a2,800002be <safestrcpy+0x2c>
    8000029c:	fff6069b          	addiw	a3,a2,-1
    800002a0:	1682                	slli	a3,a3,0x20
    800002a2:	9281                	srli	a3,a3,0x20
    800002a4:	96ae                	add	a3,a3,a1
    800002a6:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002a8:	00d58963          	beq	a1,a3,800002ba <safestrcpy+0x28>
    800002ac:	0585                	addi	a1,a1,1
    800002ae:	0785                	addi	a5,a5,1
    800002b0:	fff5c703          	lbu	a4,-1(a1)
    800002b4:	fee78fa3          	sb	a4,-1(a5)
    800002b8:	fb65                	bnez	a4,800002a8 <safestrcpy+0x16>
    ;
  *s = 0;
    800002ba:	00078023          	sb	zero,0(a5)
  return os;
}
    800002be:	6422                	ld	s0,8(sp)
    800002c0:	0141                	addi	sp,sp,16
    800002c2:	8082                	ret

00000000800002c4 <strlen>:

int
strlen(const char *s)
{
    800002c4:	1141                	addi	sp,sp,-16
    800002c6:	e422                	sd	s0,8(sp)
    800002c8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002ca:	00054783          	lbu	a5,0(a0)
    800002ce:	cf91                	beqz	a5,800002ea <strlen+0x26>
    800002d0:	0505                	addi	a0,a0,1
    800002d2:	87aa                	mv	a5,a0
    800002d4:	4685                	li	a3,1
    800002d6:	9e89                	subw	a3,a3,a0
    800002d8:	00f6853b          	addw	a0,a3,a5
    800002dc:	0785                	addi	a5,a5,1
    800002de:	fff7c703          	lbu	a4,-1(a5)
    800002e2:	fb7d                	bnez	a4,800002d8 <strlen+0x14>
    ;
  return n;
}
    800002e4:	6422                	ld	s0,8(sp)
    800002e6:	0141                	addi	sp,sp,16
    800002e8:	8082                	ret
  for(n = 0; s[n]; n++)
    800002ea:	4501                	li	a0,0
    800002ec:	bfe5                	j	800002e4 <strlen+0x20>

00000000800002ee <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    800002ee:	1141                	addi	sp,sp,-16
    800002f0:	e406                	sd	ra,8(sp)
    800002f2:	e022                	sd	s0,0(sp)
    800002f4:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    800002f6:	2ff000ef          	jal	ra,80000df4 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    800002fa:	00007717          	auipc	a4,0x7
    800002fe:	61670713          	addi	a4,a4,1558 # 80007910 <started>
  if(cpuid() == 0){
    80000302:	c51d                	beqz	a0,80000330 <main+0x42>
    while(started == 0)
    80000304:	431c                	lw	a5,0(a4)
    80000306:	2781                	sext.w	a5,a5
    80000308:	dff5                	beqz	a5,80000304 <main+0x16>
      ;
    __sync_synchronize();
    8000030a:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000030e:	2e7000ef          	jal	ra,80000df4 <cpuid>
    80000312:	85aa                	mv	a1,a0
    80000314:	00007517          	auipc	a0,0x7
    80000318:	d2450513          	addi	a0,a0,-732 # 80007038 <etext+0x38>
    8000031c:	6e7040ef          	jal	ra,80005202 <printf>
    kvminithart();    // turn on paging
    80000320:	080000ef          	jal	ra,800003a0 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000324:	67a010ef          	jal	ra,8000199e <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000328:	4ec040ef          	jal	ra,80004814 <plicinithart>
  }

  scheduler();        
    8000032c:	7b9000ef          	jal	ra,800012e4 <scheduler>
    consoleinit();
    80000330:	5fb040ef          	jal	ra,8000512a <consoleinit>
    printfinit();
    80000334:	1bc050ef          	jal	ra,800054f0 <printfinit>
    printf("\n");
    80000338:	00007517          	auipc	a0,0x7
    8000033c:	d1050513          	addi	a0,a0,-752 # 80007048 <etext+0x48>
    80000340:	6c3040ef          	jal	ra,80005202 <printf>
    printf("xv6 kernel is booting\n");
    80000344:	00007517          	auipc	a0,0x7
    80000348:	cdc50513          	addi	a0,a0,-804 # 80007020 <etext+0x20>
    8000034c:	6b7040ef          	jal	ra,80005202 <printf>
    printf("\n");
    80000350:	00007517          	auipc	a0,0x7
    80000354:	cf850513          	addi	a0,a0,-776 # 80007048 <etext+0x48>
    80000358:	6ab040ef          	jal	ra,80005202 <printf>
    kinit();         // physical page allocator
    8000035c:	d6dff0ef          	jal	ra,800000c8 <kinit>
    kvminit();       // create kernel page table
    80000360:	2ca000ef          	jal	ra,8000062a <kvminit>
    kvminithart();   // turn on paging
    80000364:	03c000ef          	jal	ra,800003a0 <kvminithart>
    procinit();      // process table
    80000368:	1e5000ef          	jal	ra,80000d4c <procinit>
    trapinit();      // trap vectors
    8000036c:	60e010ef          	jal	ra,8000197a <trapinit>
    trapinithart();  // install kernel trap vector
    80000370:	62e010ef          	jal	ra,8000199e <trapinithart>
    plicinit();      // set up interrupt controller
    80000374:	48a040ef          	jal	ra,800047fe <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000378:	49c040ef          	jal	ra,80004814 <plicinithart>
    binit();         // buffer cache
    8000037c:	50b010ef          	jal	ra,80002086 <binit>
    iinit();         // inode table
    80000380:	2ea020ef          	jal	ra,8000266a <iinit>
    fileinit();      // file table
    80000384:	084030ef          	jal	ra,80003408 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000388:	57c040ef          	jal	ra,80004904 <virtio_disk_init>
    userinit();      // first user process
    8000038c:	585000ef          	jal	ra,80001110 <userinit>
    __sync_synchronize();
    80000390:	0ff0000f          	fence
    started = 1;
    80000394:	4785                	li	a5,1
    80000396:	00007717          	auipc	a4,0x7
    8000039a:	56f72d23          	sw	a5,1402(a4) # 80007910 <started>
    8000039e:	b779                	j	8000032c <main+0x3e>

00000000800003a0 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    800003a0:	1141                	addi	sp,sp,-16
    800003a2:	e422                	sd	s0,8(sp)
    800003a4:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800003a6:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800003aa:	00007797          	auipc	a5,0x7
    800003ae:	56e7b783          	ld	a5,1390(a5) # 80007918 <kernel_pagetable>
    800003b2:	83b1                	srli	a5,a5,0xc
    800003b4:	577d                	li	a4,-1
    800003b6:	177e                	slli	a4,a4,0x3f
    800003b8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800003ba:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800003be:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800003c2:	6422                	ld	s0,8(sp)
    800003c4:	0141                	addi	sp,sp,16
    800003c6:	8082                	ret

00000000800003c8 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800003c8:	7139                	addi	sp,sp,-64
    800003ca:	fc06                	sd	ra,56(sp)
    800003cc:	f822                	sd	s0,48(sp)
    800003ce:	f426                	sd	s1,40(sp)
    800003d0:	f04a                	sd	s2,32(sp)
    800003d2:	ec4e                	sd	s3,24(sp)
    800003d4:	e852                	sd	s4,16(sp)
    800003d6:	e456                	sd	s5,8(sp)
    800003d8:	e05a                	sd	s6,0(sp)
    800003da:	0080                	addi	s0,sp,64
    800003dc:	84aa                	mv	s1,a0
    800003de:	89ae                	mv	s3,a1
    800003e0:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800003e2:	57fd                	li	a5,-1
    800003e4:	83e9                	srli	a5,a5,0x1a
    800003e6:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800003e8:	4b31                	li	s6,12
  if(va >= MAXVA)
    800003ea:	02b7fc63          	bgeu	a5,a1,80000422 <walk+0x5a>
    panic("walk");
    800003ee:	00007517          	auipc	a0,0x7
    800003f2:	c6250513          	addi	a0,a0,-926 # 80007050 <etext+0x50>
    800003f6:	0c0050ef          	jal	ra,800054b6 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800003fa:	060a8263          	beqz	s5,8000045e <walk+0x96>
    800003fe:	cffff0ef          	jal	ra,800000fc <kalloc>
    80000402:	84aa                	mv	s1,a0
    80000404:	c139                	beqz	a0,8000044a <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000406:	6605                	lui	a2,0x1
    80000408:	4581                	li	a1,0
    8000040a:	d43ff0ef          	jal	ra,8000014c <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    8000040e:	00c4d793          	srli	a5,s1,0xc
    80000412:	07aa                	slli	a5,a5,0xa
    80000414:	0017e793          	ori	a5,a5,1
    80000418:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    8000041c:	3a5d                	addiw	s4,s4,-9
    8000041e:	036a0063          	beq	s4,s6,8000043e <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    80000422:	0149d933          	srl	s2,s3,s4
    80000426:	1ff97913          	andi	s2,s2,511
    8000042a:	090e                	slli	s2,s2,0x3
    8000042c:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000042e:	00093483          	ld	s1,0(s2)
    80000432:	0014f793          	andi	a5,s1,1
    80000436:	d3f1                	beqz	a5,800003fa <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000438:	80a9                	srli	s1,s1,0xa
    8000043a:	04b2                	slli	s1,s1,0xc
    8000043c:	b7c5                	j	8000041c <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    8000043e:	00c9d513          	srli	a0,s3,0xc
    80000442:	1ff57513          	andi	a0,a0,511
    80000446:	050e                	slli	a0,a0,0x3
    80000448:	9526                	add	a0,a0,s1
}
    8000044a:	70e2                	ld	ra,56(sp)
    8000044c:	7442                	ld	s0,48(sp)
    8000044e:	74a2                	ld	s1,40(sp)
    80000450:	7902                	ld	s2,32(sp)
    80000452:	69e2                	ld	s3,24(sp)
    80000454:	6a42                	ld	s4,16(sp)
    80000456:	6aa2                	ld	s5,8(sp)
    80000458:	6b02                	ld	s6,0(sp)
    8000045a:	6121                	addi	sp,sp,64
    8000045c:	8082                	ret
        return 0;
    8000045e:	4501                	li	a0,0
    80000460:	b7ed                	j	8000044a <walk+0x82>

0000000080000462 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000462:	57fd                	li	a5,-1
    80000464:	83e9                	srli	a5,a5,0x1a
    80000466:	00b7f463          	bgeu	a5,a1,8000046e <walkaddr+0xc>
    return 0;
    8000046a:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000046c:	8082                	ret
{
    8000046e:	1141                	addi	sp,sp,-16
    80000470:	e406                	sd	ra,8(sp)
    80000472:	e022                	sd	s0,0(sp)
    80000474:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000476:	4601                	li	a2,0
    80000478:	f51ff0ef          	jal	ra,800003c8 <walk>
  if(pte == 0)
    8000047c:	c105                	beqz	a0,8000049c <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    8000047e:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000480:	0117f693          	andi	a3,a5,17
    80000484:	4745                	li	a4,17
    return 0;
    80000486:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000488:	00e68663          	beq	a3,a4,80000494 <walkaddr+0x32>
}
    8000048c:	60a2                	ld	ra,8(sp)
    8000048e:	6402                	ld	s0,0(sp)
    80000490:	0141                	addi	sp,sp,16
    80000492:	8082                	ret
  pa = PTE2PA(*pte);
    80000494:	00a7d513          	srli	a0,a5,0xa
    80000498:	0532                	slli	a0,a0,0xc
  return pa;
    8000049a:	bfcd                	j	8000048c <walkaddr+0x2a>
    return 0;
    8000049c:	4501                	li	a0,0
    8000049e:	b7fd                	j	8000048c <walkaddr+0x2a>

00000000800004a0 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800004a0:	715d                	addi	sp,sp,-80
    800004a2:	e486                	sd	ra,72(sp)
    800004a4:	e0a2                	sd	s0,64(sp)
    800004a6:	fc26                	sd	s1,56(sp)
    800004a8:	f84a                	sd	s2,48(sp)
    800004aa:	f44e                	sd	s3,40(sp)
    800004ac:	f052                	sd	s4,32(sp)
    800004ae:	ec56                	sd	s5,24(sp)
    800004b0:	e85a                	sd	s6,16(sp)
    800004b2:	e45e                	sd	s7,8(sp)
    800004b4:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800004b6:	03459793          	slli	a5,a1,0x34
    800004ba:	e7a9                	bnez	a5,80000504 <mappages+0x64>
    800004bc:	8aaa                	mv	s5,a0
    800004be:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    800004c0:	03461793          	slli	a5,a2,0x34
    800004c4:	e7b1                	bnez	a5,80000510 <mappages+0x70>
    panic("mappages: size not aligned");

  if(size == 0)
    800004c6:	ca39                	beqz	a2,8000051c <mappages+0x7c>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    800004c8:	79fd                	lui	s3,0xfffff
    800004ca:	964e                	add	a2,a2,s3
    800004cc:	00b609b3          	add	s3,a2,a1
  a = va;
    800004d0:	892e                	mv	s2,a1
    800004d2:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800004d6:	6b85                	lui	s7,0x1
    800004d8:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800004dc:	4605                	li	a2,1
    800004de:	85ca                	mv	a1,s2
    800004e0:	8556                	mv	a0,s5
    800004e2:	ee7ff0ef          	jal	ra,800003c8 <walk>
    800004e6:	c539                	beqz	a0,80000534 <mappages+0x94>
    if(*pte & PTE_V)
    800004e8:	611c                	ld	a5,0(a0)
    800004ea:	8b85                	andi	a5,a5,1
    800004ec:	ef95                	bnez	a5,80000528 <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800004ee:	80b1                	srli	s1,s1,0xc
    800004f0:	04aa                	slli	s1,s1,0xa
    800004f2:	0164e4b3          	or	s1,s1,s6
    800004f6:	0014e493          	ori	s1,s1,1
    800004fa:	e104                	sd	s1,0(a0)
    if(a == last)
    800004fc:	05390863          	beq	s2,s3,8000054c <mappages+0xac>
    a += PGSIZE;
    80000500:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80000502:	bfd9                	j	800004d8 <mappages+0x38>
    panic("mappages: va not aligned");
    80000504:	00007517          	auipc	a0,0x7
    80000508:	b5450513          	addi	a0,a0,-1196 # 80007058 <etext+0x58>
    8000050c:	7ab040ef          	jal	ra,800054b6 <panic>
    panic("mappages: size not aligned");
    80000510:	00007517          	auipc	a0,0x7
    80000514:	b6850513          	addi	a0,a0,-1176 # 80007078 <etext+0x78>
    80000518:	79f040ef          	jal	ra,800054b6 <panic>
    panic("mappages: size");
    8000051c:	00007517          	auipc	a0,0x7
    80000520:	b7c50513          	addi	a0,a0,-1156 # 80007098 <etext+0x98>
    80000524:	793040ef          	jal	ra,800054b6 <panic>
      panic("mappages: remap");
    80000528:	00007517          	auipc	a0,0x7
    8000052c:	b8050513          	addi	a0,a0,-1152 # 800070a8 <etext+0xa8>
    80000530:	787040ef          	jal	ra,800054b6 <panic>
      return -1;
    80000534:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000536:	60a6                	ld	ra,72(sp)
    80000538:	6406                	ld	s0,64(sp)
    8000053a:	74e2                	ld	s1,56(sp)
    8000053c:	7942                	ld	s2,48(sp)
    8000053e:	79a2                	ld	s3,40(sp)
    80000540:	7a02                	ld	s4,32(sp)
    80000542:	6ae2                	ld	s5,24(sp)
    80000544:	6b42                	ld	s6,16(sp)
    80000546:	6ba2                	ld	s7,8(sp)
    80000548:	6161                	addi	sp,sp,80
    8000054a:	8082                	ret
  return 0;
    8000054c:	4501                	li	a0,0
    8000054e:	b7e5                	j	80000536 <mappages+0x96>

0000000080000550 <kvmmap>:
{
    80000550:	1141                	addi	sp,sp,-16
    80000552:	e406                	sd	ra,8(sp)
    80000554:	e022                	sd	s0,0(sp)
    80000556:	0800                	addi	s0,sp,16
    80000558:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000055a:	86b2                	mv	a3,a2
    8000055c:	863e                	mv	a2,a5
    8000055e:	f43ff0ef          	jal	ra,800004a0 <mappages>
    80000562:	e509                	bnez	a0,8000056c <kvmmap+0x1c>
}
    80000564:	60a2                	ld	ra,8(sp)
    80000566:	6402                	ld	s0,0(sp)
    80000568:	0141                	addi	sp,sp,16
    8000056a:	8082                	ret
    panic("kvmmap");
    8000056c:	00007517          	auipc	a0,0x7
    80000570:	b4c50513          	addi	a0,a0,-1204 # 800070b8 <etext+0xb8>
    80000574:	743040ef          	jal	ra,800054b6 <panic>

0000000080000578 <kvmmake>:
{
    80000578:	1101                	addi	sp,sp,-32
    8000057a:	ec06                	sd	ra,24(sp)
    8000057c:	e822                	sd	s0,16(sp)
    8000057e:	e426                	sd	s1,8(sp)
    80000580:	e04a                	sd	s2,0(sp)
    80000582:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000584:	b79ff0ef          	jal	ra,800000fc <kalloc>
    80000588:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000058a:	6605                	lui	a2,0x1
    8000058c:	4581                	li	a1,0
    8000058e:	bbfff0ef          	jal	ra,8000014c <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000592:	4719                	li	a4,6
    80000594:	6685                	lui	a3,0x1
    80000596:	10000637          	lui	a2,0x10000
    8000059a:	100005b7          	lui	a1,0x10000
    8000059e:	8526                	mv	a0,s1
    800005a0:	fb1ff0ef          	jal	ra,80000550 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800005a4:	4719                	li	a4,6
    800005a6:	6685                	lui	a3,0x1
    800005a8:	10001637          	lui	a2,0x10001
    800005ac:	100015b7          	lui	a1,0x10001
    800005b0:	8526                	mv	a0,s1
    800005b2:	f9fff0ef          	jal	ra,80000550 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    800005b6:	4719                	li	a4,6
    800005b8:	040006b7          	lui	a3,0x4000
    800005bc:	0c000637          	lui	a2,0xc000
    800005c0:	0c0005b7          	lui	a1,0xc000
    800005c4:	8526                	mv	a0,s1
    800005c6:	f8bff0ef          	jal	ra,80000550 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800005ca:	00007917          	auipc	s2,0x7
    800005ce:	a3690913          	addi	s2,s2,-1482 # 80007000 <etext>
    800005d2:	4729                	li	a4,10
    800005d4:	80007697          	auipc	a3,0x80007
    800005d8:	a2c68693          	addi	a3,a3,-1492 # 7000 <_entry-0x7fff9000>
    800005dc:	4605                	li	a2,1
    800005de:	067e                	slli	a2,a2,0x1f
    800005e0:	85b2                	mv	a1,a2
    800005e2:	8526                	mv	a0,s1
    800005e4:	f6dff0ef          	jal	ra,80000550 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800005e8:	4719                	li	a4,6
    800005ea:	46c5                	li	a3,17
    800005ec:	06ee                	slli	a3,a3,0x1b
    800005ee:	412686b3          	sub	a3,a3,s2
    800005f2:	864a                	mv	a2,s2
    800005f4:	85ca                	mv	a1,s2
    800005f6:	8526                	mv	a0,s1
    800005f8:	f59ff0ef          	jal	ra,80000550 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800005fc:	4729                	li	a4,10
    800005fe:	6685                	lui	a3,0x1
    80000600:	00006617          	auipc	a2,0x6
    80000604:	a0060613          	addi	a2,a2,-1536 # 80006000 <_trampoline>
    80000608:	040005b7          	lui	a1,0x4000
    8000060c:	15fd                	addi	a1,a1,-1
    8000060e:	05b2                	slli	a1,a1,0xc
    80000610:	8526                	mv	a0,s1
    80000612:	f3fff0ef          	jal	ra,80000550 <kvmmap>
  proc_mapstacks(kpgtbl);
    80000616:	8526                	mv	a0,s1
    80000618:	6aa000ef          	jal	ra,80000cc2 <proc_mapstacks>
}
    8000061c:	8526                	mv	a0,s1
    8000061e:	60e2                	ld	ra,24(sp)
    80000620:	6442                	ld	s0,16(sp)
    80000622:	64a2                	ld	s1,8(sp)
    80000624:	6902                	ld	s2,0(sp)
    80000626:	6105                	addi	sp,sp,32
    80000628:	8082                	ret

000000008000062a <kvminit>:
{
    8000062a:	1141                	addi	sp,sp,-16
    8000062c:	e406                	sd	ra,8(sp)
    8000062e:	e022                	sd	s0,0(sp)
    80000630:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000632:	f47ff0ef          	jal	ra,80000578 <kvmmake>
    80000636:	00007797          	auipc	a5,0x7
    8000063a:	2ea7b123          	sd	a0,738(a5) # 80007918 <kernel_pagetable>
}
    8000063e:	60a2                	ld	ra,8(sp)
    80000640:	6402                	ld	s0,0(sp)
    80000642:	0141                	addi	sp,sp,16
    80000644:	8082                	ret

0000000080000646 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000646:	715d                	addi	sp,sp,-80
    80000648:	e486                	sd	ra,72(sp)
    8000064a:	e0a2                	sd	s0,64(sp)
    8000064c:	fc26                	sd	s1,56(sp)
    8000064e:	f84a                	sd	s2,48(sp)
    80000650:	f44e                	sd	s3,40(sp)
    80000652:	f052                	sd	s4,32(sp)
    80000654:	ec56                	sd	s5,24(sp)
    80000656:	e85a                	sd	s6,16(sp)
    80000658:	e45e                	sd	s7,8(sp)
    8000065a:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000065c:	03459793          	slli	a5,a1,0x34
    80000660:	e795                	bnez	a5,8000068c <uvmunmap+0x46>
    80000662:	8a2a                	mv	s4,a0
    80000664:	892e                	mv	s2,a1
    80000666:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000668:	0632                	slli	a2,a2,0xc
    8000066a:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000066e:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000670:	6b05                	lui	s6,0x1
    80000672:	0535ea63          	bltu	a1,s3,800006c6 <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000676:	60a6                	ld	ra,72(sp)
    80000678:	6406                	ld	s0,64(sp)
    8000067a:	74e2                	ld	s1,56(sp)
    8000067c:	7942                	ld	s2,48(sp)
    8000067e:	79a2                	ld	s3,40(sp)
    80000680:	7a02                	ld	s4,32(sp)
    80000682:	6ae2                	ld	s5,24(sp)
    80000684:	6b42                	ld	s6,16(sp)
    80000686:	6ba2                	ld	s7,8(sp)
    80000688:	6161                	addi	sp,sp,80
    8000068a:	8082                	ret
    panic("uvmunmap: not aligned");
    8000068c:	00007517          	auipc	a0,0x7
    80000690:	a3450513          	addi	a0,a0,-1484 # 800070c0 <etext+0xc0>
    80000694:	623040ef          	jal	ra,800054b6 <panic>
      panic("uvmunmap: walk");
    80000698:	00007517          	auipc	a0,0x7
    8000069c:	a4050513          	addi	a0,a0,-1472 # 800070d8 <etext+0xd8>
    800006a0:	617040ef          	jal	ra,800054b6 <panic>
      panic("uvmunmap: not mapped");
    800006a4:	00007517          	auipc	a0,0x7
    800006a8:	a4450513          	addi	a0,a0,-1468 # 800070e8 <etext+0xe8>
    800006ac:	60b040ef          	jal	ra,800054b6 <panic>
      panic("uvmunmap: not a leaf");
    800006b0:	00007517          	auipc	a0,0x7
    800006b4:	a5050513          	addi	a0,a0,-1456 # 80007100 <etext+0x100>
    800006b8:	5ff040ef          	jal	ra,800054b6 <panic>
    *pte = 0;
    800006bc:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800006c0:	995a                	add	s2,s2,s6
    800006c2:	fb397ae3          	bgeu	s2,s3,80000676 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800006c6:	4601                	li	a2,0
    800006c8:	85ca                	mv	a1,s2
    800006ca:	8552                	mv	a0,s4
    800006cc:	cfdff0ef          	jal	ra,800003c8 <walk>
    800006d0:	84aa                	mv	s1,a0
    800006d2:	d179                	beqz	a0,80000698 <uvmunmap+0x52>
    if((*pte & PTE_V) == 0)
    800006d4:	6108                	ld	a0,0(a0)
    800006d6:	00157793          	andi	a5,a0,1
    800006da:	d7e9                	beqz	a5,800006a4 <uvmunmap+0x5e>
    if(PTE_FLAGS(*pte) == PTE_V)
    800006dc:	3ff57793          	andi	a5,a0,1023
    800006e0:	fd7788e3          	beq	a5,s7,800006b0 <uvmunmap+0x6a>
    if(do_free){
    800006e4:	fc0a8ce3          	beqz	s5,800006bc <uvmunmap+0x76>
      uint64 pa = PTE2PA(*pte);
    800006e8:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800006ea:	0532                	slli	a0,a0,0xc
    800006ec:	931ff0ef          	jal	ra,8000001c <kfree>
    800006f0:	b7f1                	j	800006bc <uvmunmap+0x76>

00000000800006f2 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800006f2:	1101                	addi	sp,sp,-32
    800006f4:	ec06                	sd	ra,24(sp)
    800006f6:	e822                	sd	s0,16(sp)
    800006f8:	e426                	sd	s1,8(sp)
    800006fa:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800006fc:	a01ff0ef          	jal	ra,800000fc <kalloc>
    80000700:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000702:	c509                	beqz	a0,8000070c <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000704:	6605                	lui	a2,0x1
    80000706:	4581                	li	a1,0
    80000708:	a45ff0ef          	jal	ra,8000014c <memset>
  return pagetable;
}
    8000070c:	8526                	mv	a0,s1
    8000070e:	60e2                	ld	ra,24(sp)
    80000710:	6442                	ld	s0,16(sp)
    80000712:	64a2                	ld	s1,8(sp)
    80000714:	6105                	addi	sp,sp,32
    80000716:	8082                	ret

0000000080000718 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80000718:	7179                	addi	sp,sp,-48
    8000071a:	f406                	sd	ra,40(sp)
    8000071c:	f022                	sd	s0,32(sp)
    8000071e:	ec26                	sd	s1,24(sp)
    80000720:	e84a                	sd	s2,16(sp)
    80000722:	e44e                	sd	s3,8(sp)
    80000724:	e052                	sd	s4,0(sp)
    80000726:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000728:	6785                	lui	a5,0x1
    8000072a:	04f67063          	bgeu	a2,a5,8000076a <uvmfirst+0x52>
    8000072e:	8a2a                	mv	s4,a0
    80000730:	89ae                	mv	s3,a1
    80000732:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000734:	9c9ff0ef          	jal	ra,800000fc <kalloc>
    80000738:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000073a:	6605                	lui	a2,0x1
    8000073c:	4581                	li	a1,0
    8000073e:	a0fff0ef          	jal	ra,8000014c <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000742:	4779                	li	a4,30
    80000744:	86ca                	mv	a3,s2
    80000746:	6605                	lui	a2,0x1
    80000748:	4581                	li	a1,0
    8000074a:	8552                	mv	a0,s4
    8000074c:	d55ff0ef          	jal	ra,800004a0 <mappages>
  memmove(mem, src, sz);
    80000750:	8626                	mv	a2,s1
    80000752:	85ce                	mv	a1,s3
    80000754:	854a                	mv	a0,s2
    80000756:	a53ff0ef          	jal	ra,800001a8 <memmove>
}
    8000075a:	70a2                	ld	ra,40(sp)
    8000075c:	7402                	ld	s0,32(sp)
    8000075e:	64e2                	ld	s1,24(sp)
    80000760:	6942                	ld	s2,16(sp)
    80000762:	69a2                	ld	s3,8(sp)
    80000764:	6a02                	ld	s4,0(sp)
    80000766:	6145                	addi	sp,sp,48
    80000768:	8082                	ret
    panic("uvmfirst: more than a page");
    8000076a:	00007517          	auipc	a0,0x7
    8000076e:	9ae50513          	addi	a0,a0,-1618 # 80007118 <etext+0x118>
    80000772:	545040ef          	jal	ra,800054b6 <panic>

0000000080000776 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000776:	1101                	addi	sp,sp,-32
    80000778:	ec06                	sd	ra,24(sp)
    8000077a:	e822                	sd	s0,16(sp)
    8000077c:	e426                	sd	s1,8(sp)
    8000077e:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000780:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000782:	00b67d63          	bgeu	a2,a1,8000079c <uvmdealloc+0x26>
    80000786:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000788:	6785                	lui	a5,0x1
    8000078a:	17fd                	addi	a5,a5,-1
    8000078c:	00f60733          	add	a4,a2,a5
    80000790:	767d                	lui	a2,0xfffff
    80000792:	8f71                	and	a4,a4,a2
    80000794:	97ae                	add	a5,a5,a1
    80000796:	8ff1                	and	a5,a5,a2
    80000798:	00f76863          	bltu	a4,a5,800007a8 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000079c:	8526                	mv	a0,s1
    8000079e:	60e2                	ld	ra,24(sp)
    800007a0:	6442                	ld	s0,16(sp)
    800007a2:	64a2                	ld	s1,8(sp)
    800007a4:	6105                	addi	sp,sp,32
    800007a6:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800007a8:	8f99                	sub	a5,a5,a4
    800007aa:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800007ac:	4685                	li	a3,1
    800007ae:	0007861b          	sext.w	a2,a5
    800007b2:	85ba                	mv	a1,a4
    800007b4:	e93ff0ef          	jal	ra,80000646 <uvmunmap>
    800007b8:	b7d5                	j	8000079c <uvmdealloc+0x26>

00000000800007ba <uvmalloc>:
  if(newsz < oldsz)
    800007ba:	08b66963          	bltu	a2,a1,8000084c <uvmalloc+0x92>
{
    800007be:	7139                	addi	sp,sp,-64
    800007c0:	fc06                	sd	ra,56(sp)
    800007c2:	f822                	sd	s0,48(sp)
    800007c4:	f426                	sd	s1,40(sp)
    800007c6:	f04a                	sd	s2,32(sp)
    800007c8:	ec4e                	sd	s3,24(sp)
    800007ca:	e852                	sd	s4,16(sp)
    800007cc:	e456                	sd	s5,8(sp)
    800007ce:	e05a                	sd	s6,0(sp)
    800007d0:	0080                	addi	s0,sp,64
    800007d2:	8aaa                	mv	s5,a0
    800007d4:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800007d6:	6985                	lui	s3,0x1
    800007d8:	19fd                	addi	s3,s3,-1
    800007da:	95ce                	add	a1,a1,s3
    800007dc:	79fd                	lui	s3,0xfffff
    800007de:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    800007e2:	06c9f763          	bgeu	s3,a2,80000850 <uvmalloc+0x96>
    800007e6:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800007e8:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800007ec:	911ff0ef          	jal	ra,800000fc <kalloc>
    800007f0:	84aa                	mv	s1,a0
    if(mem == 0){
    800007f2:	c11d                	beqz	a0,80000818 <uvmalloc+0x5e>
    memset(mem, 0, PGSIZE);
    800007f4:	6605                	lui	a2,0x1
    800007f6:	4581                	li	a1,0
    800007f8:	955ff0ef          	jal	ra,8000014c <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800007fc:	875a                	mv	a4,s6
    800007fe:	86a6                	mv	a3,s1
    80000800:	6605                	lui	a2,0x1
    80000802:	85ca                	mv	a1,s2
    80000804:	8556                	mv	a0,s5
    80000806:	c9bff0ef          	jal	ra,800004a0 <mappages>
    8000080a:	e51d                	bnez	a0,80000838 <uvmalloc+0x7e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000080c:	6785                	lui	a5,0x1
    8000080e:	993e                	add	s2,s2,a5
    80000810:	fd496ee3          	bltu	s2,s4,800007ec <uvmalloc+0x32>
  return newsz;
    80000814:	8552                	mv	a0,s4
    80000816:	a039                	j	80000824 <uvmalloc+0x6a>
      uvmdealloc(pagetable, a, oldsz);
    80000818:	864e                	mv	a2,s3
    8000081a:	85ca                	mv	a1,s2
    8000081c:	8556                	mv	a0,s5
    8000081e:	f59ff0ef          	jal	ra,80000776 <uvmdealloc>
      return 0;
    80000822:	4501                	li	a0,0
}
    80000824:	70e2                	ld	ra,56(sp)
    80000826:	7442                	ld	s0,48(sp)
    80000828:	74a2                	ld	s1,40(sp)
    8000082a:	7902                	ld	s2,32(sp)
    8000082c:	69e2                	ld	s3,24(sp)
    8000082e:	6a42                	ld	s4,16(sp)
    80000830:	6aa2                	ld	s5,8(sp)
    80000832:	6b02                	ld	s6,0(sp)
    80000834:	6121                	addi	sp,sp,64
    80000836:	8082                	ret
      kfree(mem);
    80000838:	8526                	mv	a0,s1
    8000083a:	fe2ff0ef          	jal	ra,8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000083e:	864e                	mv	a2,s3
    80000840:	85ca                	mv	a1,s2
    80000842:	8556                	mv	a0,s5
    80000844:	f33ff0ef          	jal	ra,80000776 <uvmdealloc>
      return 0;
    80000848:	4501                	li	a0,0
    8000084a:	bfe9                	j	80000824 <uvmalloc+0x6a>
    return oldsz;
    8000084c:	852e                	mv	a0,a1
}
    8000084e:	8082                	ret
  return newsz;
    80000850:	8532                	mv	a0,a2
    80000852:	bfc9                	j	80000824 <uvmalloc+0x6a>

0000000080000854 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000854:	7179                	addi	sp,sp,-48
    80000856:	f406                	sd	ra,40(sp)
    80000858:	f022                	sd	s0,32(sp)
    8000085a:	ec26                	sd	s1,24(sp)
    8000085c:	e84a                	sd	s2,16(sp)
    8000085e:	e44e                	sd	s3,8(sp)
    80000860:	e052                	sd	s4,0(sp)
    80000862:	1800                	addi	s0,sp,48
    80000864:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000866:	84aa                	mv	s1,a0
    80000868:	6905                	lui	s2,0x1
    8000086a:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000086c:	4985                	li	s3,1
    8000086e:	a811                	j	80000882 <freewalk+0x2e>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000870:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000872:	0532                	slli	a0,a0,0xc
    80000874:	fe1ff0ef          	jal	ra,80000854 <freewalk>
      pagetable[i] = 0;
    80000878:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000087c:	04a1                	addi	s1,s1,8
    8000087e:	01248f63          	beq	s1,s2,8000089c <freewalk+0x48>
    pte_t pte = pagetable[i];
    80000882:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000884:	00f57793          	andi	a5,a0,15
    80000888:	ff3784e3          	beq	a5,s3,80000870 <freewalk+0x1c>
    } else if(pte & PTE_V){
    8000088c:	8905                	andi	a0,a0,1
    8000088e:	d57d                	beqz	a0,8000087c <freewalk+0x28>
      panic("freewalk: leaf");
    80000890:	00007517          	auipc	a0,0x7
    80000894:	8a850513          	addi	a0,a0,-1880 # 80007138 <etext+0x138>
    80000898:	41f040ef          	jal	ra,800054b6 <panic>
    }
  }
  kfree((void*)pagetable);
    8000089c:	8552                	mv	a0,s4
    8000089e:	f7eff0ef          	jal	ra,8000001c <kfree>
}
    800008a2:	70a2                	ld	ra,40(sp)
    800008a4:	7402                	ld	s0,32(sp)
    800008a6:	64e2                	ld	s1,24(sp)
    800008a8:	6942                	ld	s2,16(sp)
    800008aa:	69a2                	ld	s3,8(sp)
    800008ac:	6a02                	ld	s4,0(sp)
    800008ae:	6145                	addi	sp,sp,48
    800008b0:	8082                	ret

00000000800008b2 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800008b2:	1101                	addi	sp,sp,-32
    800008b4:	ec06                	sd	ra,24(sp)
    800008b6:	e822                	sd	s0,16(sp)
    800008b8:	e426                	sd	s1,8(sp)
    800008ba:	1000                	addi	s0,sp,32
    800008bc:	84aa                	mv	s1,a0
  if(sz > USYSCALL) {
    sz = USYSCALL;
  }
  
  uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    800008be:	040007b7          	lui	a5,0x4000
    800008c2:	17f5                	addi	a5,a5,-3
    800008c4:	07b2                	slli	a5,a5,0xc
    800008c6:	00b7f363          	bgeu	a5,a1,800008cc <uvmfree+0x1a>
    800008ca:	85be                	mv	a1,a5
    800008cc:	6605                	lui	a2,0x1
    800008ce:	167d                	addi	a2,a2,-1
    800008d0:	962e                	add	a2,a2,a1
    800008d2:	4685                	li	a3,1
    800008d4:	8231                	srli	a2,a2,0xc
    800008d6:	4581                	li	a1,0
    800008d8:	8526                	mv	a0,s1
    800008da:	d6dff0ef          	jal	ra,80000646 <uvmunmap>
  freewalk(pagetable);
    800008de:	8526                	mv	a0,s1
    800008e0:	f75ff0ef          	jal	ra,80000854 <freewalk>
}
    800008e4:	60e2                	ld	ra,24(sp)
    800008e6:	6442                	ld	s0,16(sp)
    800008e8:	64a2                	ld	s1,8(sp)
    800008ea:	6105                	addi	sp,sp,32
    800008ec:	8082                	ret

00000000800008ee <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800008ee:	0e060563          	beqz	a2,800009d8 <uvmcopy+0xea>
{
    800008f2:	711d                	addi	sp,sp,-96
    800008f4:	ec86                	sd	ra,88(sp)
    800008f6:	e8a2                	sd	s0,80(sp)
    800008f8:	e4a6                	sd	s1,72(sp)
    800008fa:	e0ca                	sd	s2,64(sp)
    800008fc:	fc4e                	sd	s3,56(sp)
    800008fe:	f852                	sd	s4,48(sp)
    80000900:	f456                	sd	s5,40(sp)
    80000902:	f05a                	sd	s6,32(sp)
    80000904:	ec5e                	sd	s7,24(sp)
    80000906:	e862                	sd	s8,16(sp)
    80000908:	e466                	sd	s9,8(sp)
    8000090a:	1080                	addi	s0,sp,96
    8000090c:	8a2a                	mv	s4,a0
    8000090e:	8c2e                	mv	s8,a1
    80000910:	8b32                	mv	s6,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000912:	4481                	li	s1,0
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    if(i == TRAPFRAME || i == USYSCALL)
    80000914:	fc000ab7          	lui	s5,0xfc000
    80000918:	0a8d                	addi	s5,s5,3
    8000091a:	0ab2                	slli	s5,s5,0xc
    8000091c:	7bfd                	lui	s7,0xfffff
    8000091e:	1bfd                	addi	s7,s7,-1
    80000920:	a03d                	j	8000094e <uvmcopy+0x60>
      panic("uvmcopy: pte should exist");
    80000922:	00007517          	auipc	a0,0x7
    80000926:	82650513          	addi	a0,a0,-2010 # 80007148 <etext+0x148>
    8000092a:	38d040ef          	jal	ra,800054b6 <panic>
      panic("uvmcopy: page not present");
    8000092e:	00007517          	auipc	a0,0x7
    80000932:	83a50513          	addi	a0,a0,-1990 # 80007168 <etext+0x168>
    80000936:	381040ef          	jal	ra,800054b6 <panic>
      continue;
    if((pte = walk(old, i, 0)) == 0)
      panic("uvmcopy: pte should exist");
    8000093a:	00007517          	auipc	a0,0x7
    8000093e:	80e50513          	addi	a0,a0,-2034 # 80007148 <etext+0x148>
    80000942:	375040ef          	jal	ra,800054b6 <panic>
  for(i = 0; i < sz; i += PGSIZE){
    80000946:	6785                	lui	a5,0x1
    80000948:	94be                	add	s1,s1,a5
    8000094a:	0964f563          	bgeu	s1,s6,800009d4 <uvmcopy+0xe6>
    if((pte = walk(old, i, 0)) == 0)
    8000094e:	4601                	li	a2,0
    80000950:	85a6                	mv	a1,s1
    80000952:	8552                	mv	a0,s4
    80000954:	a75ff0ef          	jal	ra,800003c8 <walk>
    80000958:	d569                	beqz	a0,80000922 <uvmcopy+0x34>
    if((*pte & PTE_V) == 0)
    8000095a:	00053c83          	ld	s9,0(a0)
    8000095e:	001cf793          	andi	a5,s9,1
    80000962:	d7f1                	beqz	a5,8000092e <uvmcopy+0x40>
    pa = PTE2PA(*pte);
    80000964:	00acd593          	srli	a1,s9,0xa
    80000968:	00c59993          	slli	s3,a1,0xc
    if((mem = kalloc()) == 0)
    8000096c:	f90ff0ef          	jal	ra,800000fc <kalloc>
    80000970:	892a                	mv	s2,a0
    80000972:	cd05                	beqz	a0,800009aa <uvmcopy+0xbc>
    memmove(mem, (char*)pa, PGSIZE);
    80000974:	6605                	lui	a2,0x1
    80000976:	85ce                	mv	a1,s3
    80000978:	831ff0ef          	jal	ra,800001a8 <memmove>
    if(i == TRAPFRAME || i == USYSCALL)
    8000097c:	015487b3          	add	a5,s1,s5
    80000980:	0177f7b3          	and	a5,a5,s7
    80000984:	d3e9                	beqz	a5,80000946 <uvmcopy+0x58>
    if((pte = walk(old, i, 0)) == 0)
    80000986:	4601                	li	a2,0
    80000988:	85a6                	mv	a1,s1
    8000098a:	8552                	mv	a0,s4
    8000098c:	a3dff0ef          	jal	ra,800003c8 <walk>
    80000990:	d54d                	beqz	a0,8000093a <uvmcopy+0x4c>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000992:	3ffcf713          	andi	a4,s9,1023
    80000996:	86ca                	mv	a3,s2
    80000998:	6605                	lui	a2,0x1
    8000099a:	85a6                	mv	a1,s1
    8000099c:	8562                	mv	a0,s8
    8000099e:	b03ff0ef          	jal	ra,800004a0 <mappages>
    800009a2:	d155                	beqz	a0,80000946 <uvmcopy+0x58>
      kfree(mem);
    800009a4:	854a                	mv	a0,s2
    800009a6:	e76ff0ef          	jal	ra,8000001c <kfree>
    
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800009aa:	4685                	li	a3,1
    800009ac:	00c4d613          	srli	a2,s1,0xc
    800009b0:	4581                	li	a1,0
    800009b2:	8562                	mv	a0,s8
    800009b4:	c93ff0ef          	jal	ra,80000646 <uvmunmap>
  return -1;
    800009b8:	557d                	li	a0,-1
}
    800009ba:	60e6                	ld	ra,88(sp)
    800009bc:	6446                	ld	s0,80(sp)
    800009be:	64a6                	ld	s1,72(sp)
    800009c0:	6906                	ld	s2,64(sp)
    800009c2:	79e2                	ld	s3,56(sp)
    800009c4:	7a42                	ld	s4,48(sp)
    800009c6:	7aa2                	ld	s5,40(sp)
    800009c8:	7b02                	ld	s6,32(sp)
    800009ca:	6be2                	ld	s7,24(sp)
    800009cc:	6c42                	ld	s8,16(sp)
    800009ce:	6ca2                	ld	s9,8(sp)
    800009d0:	6125                	addi	sp,sp,96
    800009d2:	8082                	ret
  return 0;
    800009d4:	4501                	li	a0,0
    800009d6:	b7d5                	j	800009ba <uvmcopy+0xcc>
    800009d8:	4501                	li	a0,0
}
    800009da:	8082                	ret

00000000800009dc <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800009dc:	1141                	addi	sp,sp,-16
    800009de:	e406                	sd	ra,8(sp)
    800009e0:	e022                	sd	s0,0(sp)
    800009e2:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800009e4:	4601                	li	a2,0
    800009e6:	9e3ff0ef          	jal	ra,800003c8 <walk>
  if(pte == 0)
    800009ea:	c901                	beqz	a0,800009fa <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800009ec:	611c                	ld	a5,0(a0)
    800009ee:	9bbd                	andi	a5,a5,-17
    800009f0:	e11c                	sd	a5,0(a0)
}
    800009f2:	60a2                	ld	ra,8(sp)
    800009f4:	6402                	ld	s0,0(sp)
    800009f6:	0141                	addi	sp,sp,16
    800009f8:	8082                	ret
    panic("uvmclear");
    800009fa:	00006517          	auipc	a0,0x6
    800009fe:	78e50513          	addi	a0,a0,1934 # 80007188 <etext+0x188>
    80000a02:	2b5040ef          	jal	ra,800054b6 <panic>

0000000080000a06 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80000a06:	c6c9                	beqz	a3,80000a90 <copyout+0x8a>
{
    80000a08:	711d                	addi	sp,sp,-96
    80000a0a:	ec86                	sd	ra,88(sp)
    80000a0c:	e8a2                	sd	s0,80(sp)
    80000a0e:	e4a6                	sd	s1,72(sp)
    80000a10:	e0ca                	sd	s2,64(sp)
    80000a12:	fc4e                	sd	s3,56(sp)
    80000a14:	f852                	sd	s4,48(sp)
    80000a16:	f456                	sd	s5,40(sp)
    80000a18:	f05a                	sd	s6,32(sp)
    80000a1a:	ec5e                	sd	s7,24(sp)
    80000a1c:	e862                	sd	s8,16(sp)
    80000a1e:	e466                	sd	s9,8(sp)
    80000a20:	e06a                	sd	s10,0(sp)
    80000a22:	1080                	addi	s0,sp,96
    80000a24:	8baa                	mv	s7,a0
    80000a26:	8aae                	mv	s5,a1
    80000a28:	8b32                	mv	s6,a2
    80000a2a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000a2c:	74fd                	lui	s1,0xfffff
    80000a2e:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    80000a30:	57fd                	li	a5,-1
    80000a32:	83e9                	srli	a5,a5,0x1a
    80000a34:	0697e063          	bltu	a5,s1,80000a94 <copyout+0x8e>
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000a38:	4cd5                	li	s9,21
    80000a3a:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    80000a3c:	8c3e                	mv	s8,a5
    80000a3e:	a025                	j	80000a66 <copyout+0x60>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    80000a40:	83a9                	srli	a5,a5,0xa
    80000a42:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000a44:	409a8533          	sub	a0,s5,s1
    80000a48:	0009061b          	sext.w	a2,s2
    80000a4c:	85da                	mv	a1,s6
    80000a4e:	953e                	add	a0,a0,a5
    80000a50:	f58ff0ef          	jal	ra,800001a8 <memmove>

    len -= n;
    80000a54:	412989b3          	sub	s3,s3,s2
    src += n;
    80000a58:	9b4a                	add	s6,s6,s2
  while(len > 0){
    80000a5a:	02098963          	beqz	s3,80000a8c <copyout+0x86>
    if(va0 >= MAXVA)
    80000a5e:	034c6d63          	bltu	s8,s4,80000a98 <copyout+0x92>
    va0 = PGROUNDDOWN(dstva);
    80000a62:	84d2                	mv	s1,s4
    dstva = va0 + PGSIZE;
    80000a64:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    80000a66:	4601                	li	a2,0
    80000a68:	85a6                	mv	a1,s1
    80000a6a:	855e                	mv	a0,s7
    80000a6c:	95dff0ef          	jal	ra,800003c8 <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000a70:	c515                	beqz	a0,80000a9c <copyout+0x96>
    80000a72:	611c                	ld	a5,0(a0)
    80000a74:	0157f713          	andi	a4,a5,21
    80000a78:	05971163          	bne	a4,s9,80000aba <copyout+0xb4>
    n = PGSIZE - (dstva - va0);
    80000a7c:	01a48a33          	add	s4,s1,s10
    80000a80:	415a0933          	sub	s2,s4,s5
    if(n > len)
    80000a84:	fb29fee3          	bgeu	s3,s2,80000a40 <copyout+0x3a>
    80000a88:	894e                	mv	s2,s3
    80000a8a:	bf5d                	j	80000a40 <copyout+0x3a>
  }
  return 0;
    80000a8c:	4501                	li	a0,0
    80000a8e:	a801                	j	80000a9e <copyout+0x98>
    80000a90:	4501                	li	a0,0
}
    80000a92:	8082                	ret
      return -1;
    80000a94:	557d                	li	a0,-1
    80000a96:	a021                	j	80000a9e <copyout+0x98>
    80000a98:	557d                	li	a0,-1
    80000a9a:	a011                	j	80000a9e <copyout+0x98>
      return -1;
    80000a9c:	557d                	li	a0,-1
}
    80000a9e:	60e6                	ld	ra,88(sp)
    80000aa0:	6446                	ld	s0,80(sp)
    80000aa2:	64a6                	ld	s1,72(sp)
    80000aa4:	6906                	ld	s2,64(sp)
    80000aa6:	79e2                	ld	s3,56(sp)
    80000aa8:	7a42                	ld	s4,48(sp)
    80000aaa:	7aa2                	ld	s5,40(sp)
    80000aac:	7b02                	ld	s6,32(sp)
    80000aae:	6be2                	ld	s7,24(sp)
    80000ab0:	6c42                	ld	s8,16(sp)
    80000ab2:	6ca2                	ld	s9,8(sp)
    80000ab4:	6d02                	ld	s10,0(sp)
    80000ab6:	6125                	addi	sp,sp,96
    80000ab8:	8082                	ret
      return -1;
    80000aba:	557d                	li	a0,-1
    80000abc:	b7cd                	j	80000a9e <copyout+0x98>

0000000080000abe <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000abe:	c6a5                	beqz	a3,80000b26 <copyin+0x68>
{
    80000ac0:	715d                	addi	sp,sp,-80
    80000ac2:	e486                	sd	ra,72(sp)
    80000ac4:	e0a2                	sd	s0,64(sp)
    80000ac6:	fc26                	sd	s1,56(sp)
    80000ac8:	f84a                	sd	s2,48(sp)
    80000aca:	f44e                	sd	s3,40(sp)
    80000acc:	f052                	sd	s4,32(sp)
    80000ace:	ec56                	sd	s5,24(sp)
    80000ad0:	e85a                	sd	s6,16(sp)
    80000ad2:	e45e                	sd	s7,8(sp)
    80000ad4:	e062                	sd	s8,0(sp)
    80000ad6:	0880                	addi	s0,sp,80
    80000ad8:	8b2a                	mv	s6,a0
    80000ada:	8a2e                	mv	s4,a1
    80000adc:	8c32                	mv	s8,a2
    80000ade:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000ae0:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000ae2:	6a85                	lui	s5,0x1
    80000ae4:	a00d                	j	80000b06 <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000ae6:	018505b3          	add	a1,a0,s8
    80000aea:	0004861b          	sext.w	a2,s1
    80000aee:	412585b3          	sub	a1,a1,s2
    80000af2:	8552                	mv	a0,s4
    80000af4:	eb4ff0ef          	jal	ra,800001a8 <memmove>

    len -= n;
    80000af8:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000afc:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000afe:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b02:	02098063          	beqz	s3,80000b22 <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    80000b06:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b0a:	85ca                	mv	a1,s2
    80000b0c:	855a                	mv	a0,s6
    80000b0e:	955ff0ef          	jal	ra,80000462 <walkaddr>
    if(pa0 == 0)
    80000b12:	cd01                	beqz	a0,80000b2a <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    80000b14:	418904b3          	sub	s1,s2,s8
    80000b18:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b1a:	fc99f6e3          	bgeu	s3,s1,80000ae6 <copyin+0x28>
    80000b1e:	84ce                	mv	s1,s3
    80000b20:	b7d9                	j	80000ae6 <copyin+0x28>
  }
  return 0;
    80000b22:	4501                	li	a0,0
    80000b24:	a021                	j	80000b2c <copyin+0x6e>
    80000b26:	4501                	li	a0,0
}
    80000b28:	8082                	ret
      return -1;
    80000b2a:	557d                	li	a0,-1
}
    80000b2c:	60a6                	ld	ra,72(sp)
    80000b2e:	6406                	ld	s0,64(sp)
    80000b30:	74e2                	ld	s1,56(sp)
    80000b32:	7942                	ld	s2,48(sp)
    80000b34:	79a2                	ld	s3,40(sp)
    80000b36:	7a02                	ld	s4,32(sp)
    80000b38:	6ae2                	ld	s5,24(sp)
    80000b3a:	6b42                	ld	s6,16(sp)
    80000b3c:	6ba2                	ld	s7,8(sp)
    80000b3e:	6c02                	ld	s8,0(sp)
    80000b40:	6161                	addi	sp,sp,80
    80000b42:	8082                	ret

0000000080000b44 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000b44:	c2d5                	beqz	a3,80000be8 <copyinstr+0xa4>
{
    80000b46:	715d                	addi	sp,sp,-80
    80000b48:	e486                	sd	ra,72(sp)
    80000b4a:	e0a2                	sd	s0,64(sp)
    80000b4c:	fc26                	sd	s1,56(sp)
    80000b4e:	f84a                	sd	s2,48(sp)
    80000b50:	f44e                	sd	s3,40(sp)
    80000b52:	f052                	sd	s4,32(sp)
    80000b54:	ec56                	sd	s5,24(sp)
    80000b56:	e85a                	sd	s6,16(sp)
    80000b58:	e45e                	sd	s7,8(sp)
    80000b5a:	0880                	addi	s0,sp,80
    80000b5c:	8a2a                	mv	s4,a0
    80000b5e:	8b2e                	mv	s6,a1
    80000b60:	8bb2                	mv	s7,a2
    80000b62:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000b64:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000b66:	6985                	lui	s3,0x1
    80000b68:	a035                	j	80000b94 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000b6a:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000b6e:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000b70:	0017b793          	seqz	a5,a5
    80000b74:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000b78:	60a6                	ld	ra,72(sp)
    80000b7a:	6406                	ld	s0,64(sp)
    80000b7c:	74e2                	ld	s1,56(sp)
    80000b7e:	7942                	ld	s2,48(sp)
    80000b80:	79a2                	ld	s3,40(sp)
    80000b82:	7a02                	ld	s4,32(sp)
    80000b84:	6ae2                	ld	s5,24(sp)
    80000b86:	6b42                	ld	s6,16(sp)
    80000b88:	6ba2                	ld	s7,8(sp)
    80000b8a:	6161                	addi	sp,sp,80
    80000b8c:	8082                	ret
    srcva = va0 + PGSIZE;
    80000b8e:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000b92:	c4b9                	beqz	s1,80000be0 <copyinstr+0x9c>
    va0 = PGROUNDDOWN(srcva);
    80000b94:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000b98:	85ca                	mv	a1,s2
    80000b9a:	8552                	mv	a0,s4
    80000b9c:	8c7ff0ef          	jal	ra,80000462 <walkaddr>
    if(pa0 == 0)
    80000ba0:	c131                	beqz	a0,80000be4 <copyinstr+0xa0>
    n = PGSIZE - (srcva - va0);
    80000ba2:	41790833          	sub	a6,s2,s7
    80000ba6:	984e                	add	a6,a6,s3
    if(n > max)
    80000ba8:	0104f363          	bgeu	s1,a6,80000bae <copyinstr+0x6a>
    80000bac:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000bae:	955e                	add	a0,a0,s7
    80000bb0:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000bb4:	fc080de3          	beqz	a6,80000b8e <copyinstr+0x4a>
    80000bb8:	985a                	add	a6,a6,s6
    80000bba:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000bbc:	41650633          	sub	a2,a0,s6
    80000bc0:	14fd                	addi	s1,s1,-1
    80000bc2:	9b26                	add	s6,s6,s1
    80000bc4:	00f60733          	add	a4,a2,a5
    80000bc8:	00074703          	lbu	a4,0(a4)
    80000bcc:	df59                	beqz	a4,80000b6a <copyinstr+0x26>
        *dst = *p;
    80000bce:	00e78023          	sb	a4,0(a5)
      --max;
    80000bd2:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000bd6:	0785                	addi	a5,a5,1
    while(n > 0){
    80000bd8:	ff0796e3          	bne	a5,a6,80000bc4 <copyinstr+0x80>
      dst++;
    80000bdc:	8b42                	mv	s6,a6
    80000bde:	bf45                	j	80000b8e <copyinstr+0x4a>
    80000be0:	4781                	li	a5,0
    80000be2:	b779                	j	80000b70 <copyinstr+0x2c>
      return -1;
    80000be4:	557d                	li	a0,-1
    80000be6:	bf49                	j	80000b78 <copyinstr+0x34>
  int got_null = 0;
    80000be8:	4781                	li	a5,0
  if(got_null){
    80000bea:	0017b793          	seqz	a5,a5
    80000bee:	40f00533          	neg	a0,a5
}
    80000bf2:	8082                	ret

0000000080000bf4 <vmprint_rec>:
    printf("page table %p\n", pagetable);
    vmprint_rec(pagetable, 0);
}
void
vmprint_rec(pagetable_t pagetable, int depth)
{
    80000bf4:	711d                	addi	sp,sp,-96
    80000bf6:	ec86                	sd	ra,88(sp)
    80000bf8:	e8a2                	sd	s0,80(sp)
    80000bfa:	e4a6                	sd	s1,72(sp)
    80000bfc:	e0ca                	sd	s2,64(sp)
    80000bfe:	fc4e                	sd	s3,56(sp)
    80000c00:	f852                	sd	s4,48(sp)
    80000c02:	f456                	sd	s5,40(sp)
    80000c04:	f05a                	sd	s6,32(sp)
    80000c06:	ec5e                	sd	s7,24(sp)
    80000c08:	e862                	sd	s8,16(sp)
    80000c0a:	e466                	sd	s9,8(sp)
    80000c0c:	e06a                	sd	s10,0(sp)
    80000c0e:	1080                	addi	s0,sp,96
    80000c10:	8aae                	mv	s5,a1
    for(int i = 0; i < 512; i++){
    80000c12:	8a2a                	mv	s4,a0
    80000c14:	4981                	li	s3,0
                printf(" ..");
            }

            uint64 pa = PTE2PA(pte);

            printf("%d: pte %p pa %p\n", i, (void*)pte, (void*)pa);
    80000c16:	00006c17          	auipc	s8,0x6
    80000c1a:	58ac0c13          	addi	s8,s8,1418 # 800071a0 <etext+0x1a0>

            // nếu KHÔNG phải leaf → đi xuống dưới
            if((pte & (PTE_R|PTE_W|PTE_X)) == 0){
                vmprint_rec((pagetable_t)pa, depth + 1);
    80000c1e:	00158d1b          	addiw	s10,a1,1
            for(int j = 0; j < depth; j++){
    80000c22:	4c81                	li	s9,0
                printf(" ..");
    80000c24:	00006b17          	auipc	s6,0x6
    80000c28:	574b0b13          	addi	s6,s6,1396 # 80007198 <etext+0x198>
    for(int i = 0; i < 512; i++){
    80000c2c:	20000b93          	li	s7,512
    80000c30:	a029                	j	80000c3a <vmprint_rec+0x46>
    80000c32:	2985                	addiw	s3,s3,1
    80000c34:	0a21                	addi	s4,s4,8
    80000c36:	05798263          	beq	s3,s7,80000c7a <vmprint_rec+0x86>
        pte_t pte = pagetable[i];
    80000c3a:	000a3903          	ld	s2,0(s4) # fffffffffffff000 <end+0xffffffff7ffde190>
        if(pte & PTE_V){
    80000c3e:	00197793          	andi	a5,s2,1
    80000c42:	dbe5                	beqz	a5,80000c32 <vmprint_rec+0x3e>
            for(int j = 0; j < depth; j++){
    80000c44:	01505963          	blez	s5,80000c56 <vmprint_rec+0x62>
    80000c48:	84e6                	mv	s1,s9
                printf(" ..");
    80000c4a:	855a                	mv	a0,s6
    80000c4c:	5b6040ef          	jal	ra,80005202 <printf>
            for(int j = 0; j < depth; j++){
    80000c50:	2485                	addiw	s1,s1,1
    80000c52:	fe9a9ce3          	bne	s5,s1,80000c4a <vmprint_rec+0x56>
            uint64 pa = PTE2PA(pte);
    80000c56:	00a95493          	srli	s1,s2,0xa
    80000c5a:	04b2                	slli	s1,s1,0xc
            printf("%d: pte %p pa %p\n", i, (void*)pte, (void*)pa);
    80000c5c:	86a6                	mv	a3,s1
    80000c5e:	864a                	mv	a2,s2
    80000c60:	85ce                	mv	a1,s3
    80000c62:	8562                	mv	a0,s8
    80000c64:	59e040ef          	jal	ra,80005202 <printf>
            if((pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000c68:	00e97913          	andi	s2,s2,14
    80000c6c:	fc0913e3          	bnez	s2,80000c32 <vmprint_rec+0x3e>
                vmprint_rec((pagetable_t)pa, depth + 1);
    80000c70:	85ea                	mv	a1,s10
    80000c72:	8526                	mv	a0,s1
    80000c74:	f81ff0ef          	jal	ra,80000bf4 <vmprint_rec>
    80000c78:	bf6d                	j	80000c32 <vmprint_rec+0x3e>
            }
        }
    }
}
    80000c7a:	60e6                	ld	ra,88(sp)
    80000c7c:	6446                	ld	s0,80(sp)
    80000c7e:	64a6                	ld	s1,72(sp)
    80000c80:	6906                	ld	s2,64(sp)
    80000c82:	79e2                	ld	s3,56(sp)
    80000c84:	7a42                	ld	s4,48(sp)
    80000c86:	7aa2                	ld	s5,40(sp)
    80000c88:	7b02                	ld	s6,32(sp)
    80000c8a:	6be2                	ld	s7,24(sp)
    80000c8c:	6c42                	ld	s8,16(sp)
    80000c8e:	6ca2                	ld	s9,8(sp)
    80000c90:	6d02                	ld	s10,0(sp)
    80000c92:	6125                	addi	sp,sp,96
    80000c94:	8082                	ret

0000000080000c96 <vmprint>:
{
    80000c96:	1101                	addi	sp,sp,-32
    80000c98:	ec06                	sd	ra,24(sp)
    80000c9a:	e822                	sd	s0,16(sp)
    80000c9c:	e426                	sd	s1,8(sp)
    80000c9e:	1000                	addi	s0,sp,32
    80000ca0:	84aa                	mv	s1,a0
    printf("page table %p\n", pagetable);
    80000ca2:	85aa                	mv	a1,a0
    80000ca4:	00006517          	auipc	a0,0x6
    80000ca8:	51450513          	addi	a0,a0,1300 # 800071b8 <etext+0x1b8>
    80000cac:	556040ef          	jal	ra,80005202 <printf>
    vmprint_rec(pagetable, 0);
    80000cb0:	4581                	li	a1,0
    80000cb2:	8526                	mv	a0,s1
    80000cb4:	f41ff0ef          	jal	ra,80000bf4 <vmprint_rec>
}
    80000cb8:	60e2                	ld	ra,24(sp)
    80000cba:	6442                	ld	s0,16(sp)
    80000cbc:	64a2                	ld	s1,8(sp)
    80000cbe:	6105                	addi	sp,sp,32
    80000cc0:	8082                	ret

0000000080000cc2 <proc_mapstacks>:
  // Allocate a page for each process's kernel stack.
  // Map it high in memory, followed by an invalid
  // guard page.
  void
  proc_mapstacks(pagetable_t kpgtbl)
  {
    80000cc2:	7139                	addi	sp,sp,-64
    80000cc4:	fc06                	sd	ra,56(sp)
    80000cc6:	f822                	sd	s0,48(sp)
    80000cc8:	f426                	sd	s1,40(sp)
    80000cca:	f04a                	sd	s2,32(sp)
    80000ccc:	ec4e                	sd	s3,24(sp)
    80000cce:	e852                	sd	s4,16(sp)
    80000cd0:	e456                	sd	s5,8(sp)
    80000cd2:	e05a                	sd	s6,0(sp)
    80000cd4:	0080                	addi	s0,sp,64
    80000cd6:	89aa                	mv	s3,a0
    struct proc *p;
    
    for(p = proc; p < &proc[NPROC]; p++) {
    80000cd8:	00007497          	auipc	s1,0x7
    80000cdc:	0b848493          	addi	s1,s1,184 # 80007d90 <proc>
      char *pa = kalloc();
      if(pa == 0)
        panic("kalloc");
      uint64 va = KSTACK((int) (p - proc));
    80000ce0:	8b26                	mv	s6,s1
    80000ce2:	00006a97          	auipc	s5,0x6
    80000ce6:	31ea8a93          	addi	s5,s5,798 # 80007000 <etext>
    80000cea:	04000937          	lui	s2,0x4000
    80000cee:	197d                	addi	s2,s2,-1
    80000cf0:	0932                	slli	s2,s2,0xc
    for(p = proc; p < &proc[NPROC]; p++) {
    80000cf2:	0000da17          	auipc	s4,0xd
    80000cf6:	c9ea0a13          	addi	s4,s4,-866 # 8000d990 <tickslock>
      char *pa = kalloc();
    80000cfa:	c02ff0ef          	jal	ra,800000fc <kalloc>
    80000cfe:	862a                	mv	a2,a0
      if(pa == 0)
    80000d00:	c121                	beqz	a0,80000d40 <proc_mapstacks+0x7e>
      uint64 va = KSTACK((int) (p - proc));
    80000d02:	416485b3          	sub	a1,s1,s6
    80000d06:	8591                	srai	a1,a1,0x4
    80000d08:	000ab783          	ld	a5,0(s5)
    80000d0c:	02f585b3          	mul	a1,a1,a5
    80000d10:	2585                	addiw	a1,a1,1
    80000d12:	00d5959b          	slliw	a1,a1,0xd
      kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d16:	4719                	li	a4,6
    80000d18:	6685                	lui	a3,0x1
    80000d1a:	40b905b3          	sub	a1,s2,a1
    80000d1e:	854e                	mv	a0,s3
    80000d20:	831ff0ef          	jal	ra,80000550 <kvmmap>
    for(p = proc; p < &proc[NPROC]; p++) {
    80000d24:	17048493          	addi	s1,s1,368
    80000d28:	fd4499e3          	bne	s1,s4,80000cfa <proc_mapstacks+0x38>
    }
  }
    80000d2c:	70e2                	ld	ra,56(sp)
    80000d2e:	7442                	ld	s0,48(sp)
    80000d30:	74a2                	ld	s1,40(sp)
    80000d32:	7902                	ld	s2,32(sp)
    80000d34:	69e2                	ld	s3,24(sp)
    80000d36:	6a42                	ld	s4,16(sp)
    80000d38:	6aa2                	ld	s5,8(sp)
    80000d3a:	6b02                	ld	s6,0(sp)
    80000d3c:	6121                	addi	sp,sp,64
    80000d3e:	8082                	ret
        panic("kalloc");
    80000d40:	00006517          	auipc	a0,0x6
    80000d44:	48850513          	addi	a0,a0,1160 # 800071c8 <etext+0x1c8>
    80000d48:	76e040ef          	jal	ra,800054b6 <panic>

0000000080000d4c <procinit>:

  // initialize the proc table.
  void
  procinit(void)
  {
    80000d4c:	7139                	addi	sp,sp,-64
    80000d4e:	fc06                	sd	ra,56(sp)
    80000d50:	f822                	sd	s0,48(sp)
    80000d52:	f426                	sd	s1,40(sp)
    80000d54:	f04a                	sd	s2,32(sp)
    80000d56:	ec4e                	sd	s3,24(sp)
    80000d58:	e852                	sd	s4,16(sp)
    80000d5a:	e456                	sd	s5,8(sp)
    80000d5c:	e05a                	sd	s6,0(sp)
    80000d5e:	0080                	addi	s0,sp,64
    struct proc *p;
    
    initlock(&pid_lock, "nextpid");
    80000d60:	00006597          	auipc	a1,0x6
    80000d64:	47058593          	addi	a1,a1,1136 # 800071d0 <etext+0x1d0>
    80000d68:	00007517          	auipc	a0,0x7
    80000d6c:	bf850513          	addi	a0,a0,-1032 # 80007960 <pid_lock>
    80000d70:	1db040ef          	jal	ra,8000574a <initlock>
    initlock(&wait_lock, "wait_lock");
    80000d74:	00006597          	auipc	a1,0x6
    80000d78:	46458593          	addi	a1,a1,1124 # 800071d8 <etext+0x1d8>
    80000d7c:	00007517          	auipc	a0,0x7
    80000d80:	bfc50513          	addi	a0,a0,-1028 # 80007978 <wait_lock>
    80000d84:	1c7040ef          	jal	ra,8000574a <initlock>
    for(p = proc; p < &proc[NPROC]; p++) {
    80000d88:	00007497          	auipc	s1,0x7
    80000d8c:	00848493          	addi	s1,s1,8 # 80007d90 <proc>
        initlock(&p->lock, "proc");
    80000d90:	00006b17          	auipc	s6,0x6
    80000d94:	458b0b13          	addi	s6,s6,1112 # 800071e8 <etext+0x1e8>
        p->state = UNUSED;
        p->kstack = KSTACK((int) (p - proc));
    80000d98:	8aa6                	mv	s5,s1
    80000d9a:	00006a17          	auipc	s4,0x6
    80000d9e:	266a0a13          	addi	s4,s4,614 # 80007000 <etext>
    80000da2:	04000937          	lui	s2,0x4000
    80000da6:	197d                	addi	s2,s2,-1
    80000da8:	0932                	slli	s2,s2,0xc
    for(p = proc; p < &proc[NPROC]; p++) {
    80000daa:	0000d997          	auipc	s3,0xd
    80000dae:	be698993          	addi	s3,s3,-1050 # 8000d990 <tickslock>
        initlock(&p->lock, "proc");
    80000db2:	85da                	mv	a1,s6
    80000db4:	8526                	mv	a0,s1
    80000db6:	195040ef          	jal	ra,8000574a <initlock>
        p->state = UNUSED;
    80000dba:	0004ac23          	sw	zero,24(s1)
        p->kstack = KSTACK((int) (p - proc));
    80000dbe:	415487b3          	sub	a5,s1,s5
    80000dc2:	8791                	srai	a5,a5,0x4
    80000dc4:	000a3703          	ld	a4,0(s4)
    80000dc8:	02e787b3          	mul	a5,a5,a4
    80000dcc:	2785                	addiw	a5,a5,1
    80000dce:	00d7979b          	slliw	a5,a5,0xd
    80000dd2:	40f907b3          	sub	a5,s2,a5
    80000dd6:	e0fc                	sd	a5,192(s1)
    for(p = proc; p < &proc[NPROC]; p++) {
    80000dd8:	17048493          	addi	s1,s1,368
    80000ddc:	fd349be3          	bne	s1,s3,80000db2 <procinit+0x66>
    }
  }
    80000de0:	70e2                	ld	ra,56(sp)
    80000de2:	7442                	ld	s0,48(sp)
    80000de4:	74a2                	ld	s1,40(sp)
    80000de6:	7902                	ld	s2,32(sp)
    80000de8:	69e2                	ld	s3,24(sp)
    80000dea:	6a42                	ld	s4,16(sp)
    80000dec:	6aa2                	ld	s5,8(sp)
    80000dee:	6b02                	ld	s6,0(sp)
    80000df0:	6121                	addi	sp,sp,64
    80000df2:	8082                	ret

0000000080000df4 <cpuid>:
  // Must be called with interrupts disabled,
  // to prevent race with process being moved
  // to a different CPU.
  int
  cpuid()
  {
    80000df4:	1141                	addi	sp,sp,-16
    80000df6:	e422                	sd	s0,8(sp)
    80000df8:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000dfa:	8512                	mv	a0,tp
    int id = r_tp();
    return id;
  }
    80000dfc:	2501                	sext.w	a0,a0
    80000dfe:	6422                	ld	s0,8(sp)
    80000e00:	0141                	addi	sp,sp,16
    80000e02:	8082                	ret

0000000080000e04 <mycpu>:

  // Return this CPU's cpu struct.
  // Interrupts must be disabled.
  struct cpu*
  mycpu(void)
  {
    80000e04:	1141                	addi	sp,sp,-16
    80000e06:	e422                	sd	s0,8(sp)
    80000e08:	0800                	addi	s0,sp,16
    80000e0a:	8792                	mv	a5,tp
    int id = cpuid();
    struct cpu *c = &cpus[id];
    80000e0c:	2781                	sext.w	a5,a5
    80000e0e:	079e                	slli	a5,a5,0x7
    return c;
  }
    80000e10:	00007517          	auipc	a0,0x7
    80000e14:	b8050513          	addi	a0,a0,-1152 # 80007990 <cpus>
    80000e18:	953e                	add	a0,a0,a5
    80000e1a:	6422                	ld	s0,8(sp)
    80000e1c:	0141                	addi	sp,sp,16
    80000e1e:	8082                	ret

0000000080000e20 <myproc>:

  // Return the current struct proc *, or zero if none.
  struct proc*
  myproc(void)
  {
    80000e20:	1101                	addi	sp,sp,-32
    80000e22:	ec06                	sd	ra,24(sp)
    80000e24:	e822                	sd	s0,16(sp)
    80000e26:	e426                	sd	s1,8(sp)
    80000e28:	1000                	addi	s0,sp,32
    push_off();
    80000e2a:	161040ef          	jal	ra,8000578a <push_off>
    80000e2e:	8792                	mv	a5,tp
    struct cpu *c = mycpu();
    struct proc *p = c->proc;
    80000e30:	2781                	sext.w	a5,a5
    80000e32:	079e                	slli	a5,a5,0x7
    80000e34:	00007717          	auipc	a4,0x7
    80000e38:	b2c70713          	addi	a4,a4,-1236 # 80007960 <pid_lock>
    80000e3c:	97ba                	add	a5,a5,a4
    80000e3e:	7b84                	ld	s1,48(a5)
    pop_off();
    80000e40:	1cf040ef          	jal	ra,8000580e <pop_off>
    return p;
  }
    80000e44:	8526                	mv	a0,s1
    80000e46:	60e2                	ld	ra,24(sp)
    80000e48:	6442                	ld	s0,16(sp)
    80000e4a:	64a2                	ld	s1,8(sp)
    80000e4c:	6105                	addi	sp,sp,32
    80000e4e:	8082                	ret

0000000080000e50 <forkret>:

  // A fork child's very first scheduling by scheduler()
  // will swtch to forkret.
  void
  forkret(void)
  {
    80000e50:	1141                	addi	sp,sp,-16
    80000e52:	e406                	sd	ra,8(sp)
    80000e54:	e022                	sd	s0,0(sp)
    80000e56:	0800                	addi	s0,sp,16
    static int first = 1;

    // Still holding p->lock from scheduler.
    release(&myproc()->lock);
    80000e58:	fc9ff0ef          	jal	ra,80000e20 <myproc>
    80000e5c:	207040ef          	jal	ra,80005862 <release>

    if (first) {
    80000e60:	00007797          	auipc	a5,0x7
    80000e64:	a607a783          	lw	a5,-1440(a5) # 800078c0 <first.1>
    80000e68:	e799                	bnez	a5,80000e76 <forkret+0x26>
      first = 0;
      // ensure other cores see first=0.
      __sync_synchronize();
    }

    usertrapret();
    80000e6a:	34d000ef          	jal	ra,800019b6 <usertrapret>
  }
    80000e6e:	60a2                	ld	ra,8(sp)
    80000e70:	6402                	ld	s0,0(sp)
    80000e72:	0141                	addi	sp,sp,16
    80000e74:	8082                	ret
      fsinit(ROOTDEV);
    80000e76:	4505                	li	a0,1
    80000e78:	786010ef          	jal	ra,800025fe <fsinit>
      first = 0;
    80000e7c:	00007797          	auipc	a5,0x7
    80000e80:	a407a223          	sw	zero,-1468(a5) # 800078c0 <first.1>
      __sync_synchronize();
    80000e84:	0ff0000f          	fence
    80000e88:	b7cd                	j	80000e6a <forkret+0x1a>

0000000080000e8a <allocpid>:
  {
    80000e8a:	1101                	addi	sp,sp,-32
    80000e8c:	ec06                	sd	ra,24(sp)
    80000e8e:	e822                	sd	s0,16(sp)
    80000e90:	e426                	sd	s1,8(sp)
    80000e92:	e04a                	sd	s2,0(sp)
    80000e94:	1000                	addi	s0,sp,32
    acquire(&pid_lock);
    80000e96:	00007917          	auipc	s2,0x7
    80000e9a:	aca90913          	addi	s2,s2,-1334 # 80007960 <pid_lock>
    80000e9e:	854a                	mv	a0,s2
    80000ea0:	12b040ef          	jal	ra,800057ca <acquire>
    pid = nextpid;
    80000ea4:	00007797          	auipc	a5,0x7
    80000ea8:	a2078793          	addi	a5,a5,-1504 # 800078c4 <nextpid>
    80000eac:	4384                	lw	s1,0(a5)
    nextpid = nextpid + 1;
    80000eae:	0014871b          	addiw	a4,s1,1
    80000eb2:	c398                	sw	a4,0(a5)
    release(&pid_lock);
    80000eb4:	854a                	mv	a0,s2
    80000eb6:	1ad040ef          	jal	ra,80005862 <release>
  }
    80000eba:	8526                	mv	a0,s1
    80000ebc:	60e2                	ld	ra,24(sp)
    80000ebe:	6442                	ld	s0,16(sp)
    80000ec0:	64a2                	ld	s1,8(sp)
    80000ec2:	6902                	ld	s2,0(sp)
    80000ec4:	6105                	addi	sp,sp,32
    80000ec6:	8082                	ret

0000000080000ec8 <proc_pagetable>:
  {
    80000ec8:	1101                	addi	sp,sp,-32
    80000eca:	ec06                	sd	ra,24(sp)
    80000ecc:	e822                	sd	s0,16(sp)
    80000ece:	e426                	sd	s1,8(sp)
    80000ed0:	e04a                	sd	s2,0(sp)
    80000ed2:	1000                	addi	s0,sp,32
    80000ed4:	892a                	mv	s2,a0
    pagetable = uvmcreate();
    80000ed6:	81dff0ef          	jal	ra,800006f2 <uvmcreate>
    80000eda:	84aa                	mv	s1,a0
    if(pagetable == 0)
    80000edc:	c929                	beqz	a0,80000f2e <proc_pagetable+0x66>
    if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000ede:	4729                	li	a4,10
    80000ee0:	00005697          	auipc	a3,0x5
    80000ee4:	12068693          	addi	a3,a3,288 # 80006000 <_trampoline>
    80000ee8:	6605                	lui	a2,0x1
    80000eea:	040005b7          	lui	a1,0x4000
    80000eee:	15fd                	addi	a1,a1,-1
    80000ef0:	05b2                	slli	a1,a1,0xc
    80000ef2:	daeff0ef          	jal	ra,800004a0 <mappages>
    80000ef6:	04054363          	bltz	a0,80000f3c <proc_pagetable+0x74>
    if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000efa:	4719                	li	a4,6
    80000efc:	04093683          	ld	a3,64(s2)
    80000f00:	6605                	lui	a2,0x1
    80000f02:	020005b7          	lui	a1,0x2000
    80000f06:	15fd                	addi	a1,a1,-1
    80000f08:	05b6                	slli	a1,a1,0xd
    80000f0a:	8526                	mv	a0,s1
    80000f0c:	d94ff0ef          	jal	ra,800004a0 <mappages>
    80000f10:	02054c63          	bltz	a0,80000f48 <proc_pagetable+0x80>
    if(mappages(pagetable, USYSCALL, PGSIZE,
    80000f14:	4749                	li	a4,18
    80000f16:	04893683          	ld	a3,72(s2)
    80000f1a:	6605                	lui	a2,0x1
    80000f1c:	040005b7          	lui	a1,0x4000
    80000f20:	15f5                	addi	a1,a1,-3
    80000f22:	05b2                	slli	a1,a1,0xc
    80000f24:	8526                	mv	a0,s1
    80000f26:	d7aff0ef          	jal	ra,800004a0 <mappages>
    80000f2a:	02054e63          	bltz	a0,80000f66 <proc_pagetable+0x9e>
  }
    80000f2e:	8526                	mv	a0,s1
    80000f30:	60e2                	ld	ra,24(sp)
    80000f32:	6442                	ld	s0,16(sp)
    80000f34:	64a2                	ld	s1,8(sp)
    80000f36:	6902                	ld	s2,0(sp)
    80000f38:	6105                	addi	sp,sp,32
    80000f3a:	8082                	ret
      uvmfree(pagetable, 0);
    80000f3c:	4581                	li	a1,0
    80000f3e:	8526                	mv	a0,s1
    80000f40:	973ff0ef          	jal	ra,800008b2 <uvmfree>
      return 0;
    80000f44:	4481                	li	s1,0
    80000f46:	b7e5                	j	80000f2e <proc_pagetable+0x66>
      uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f48:	4681                	li	a3,0
    80000f4a:	4605                	li	a2,1
    80000f4c:	040005b7          	lui	a1,0x4000
    80000f50:	15fd                	addi	a1,a1,-1
    80000f52:	05b2                	slli	a1,a1,0xc
    80000f54:	8526                	mv	a0,s1
    80000f56:	ef0ff0ef          	jal	ra,80000646 <uvmunmap>
      uvmfree(pagetable, 0);
    80000f5a:	4581                	li	a1,0
    80000f5c:	8526                	mv	a0,s1
    80000f5e:	955ff0ef          	jal	ra,800008b2 <uvmfree>
      return 0;
    80000f62:	4481                	li	s1,0
    80000f64:	b7e9                	j	80000f2e <proc_pagetable+0x66>
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000f66:	4681                	li	a3,0
    80000f68:	4605                	li	a2,1
    80000f6a:	020005b7          	lui	a1,0x2000
    80000f6e:	15fd                	addi	a1,a1,-1
    80000f70:	05b6                	slli	a1,a1,0xd
    80000f72:	8526                	mv	a0,s1
    80000f74:	ed2ff0ef          	jal	ra,80000646 <uvmunmap>
    uvmfree(pagetable, 0);
    80000f78:	4581                	li	a1,0
    80000f7a:	8526                	mv	a0,s1
    80000f7c:	937ff0ef          	jal	ra,800008b2 <uvmfree>
    return 0;
    80000f80:	4481                	li	s1,0
    80000f82:	b775                	j	80000f2e <proc_pagetable+0x66>

0000000080000f84 <proc_freepagetable>:
  {
    80000f84:	7179                	addi	sp,sp,-48
    80000f86:	f406                	sd	ra,40(sp)
    80000f88:	f022                	sd	s0,32(sp)
    80000f8a:	ec26                	sd	s1,24(sp)
    80000f8c:	e84a                	sd	s2,16(sp)
    80000f8e:	e44e                	sd	s3,8(sp)
    80000f90:	1800                	addi	s0,sp,48
    80000f92:	84aa                	mv	s1,a0
    80000f94:	89ae                	mv	s3,a1
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f96:	4681                	li	a3,0
    80000f98:	4605                	li	a2,1
    80000f9a:	04000937          	lui	s2,0x4000
    80000f9e:	fff90593          	addi	a1,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000fa2:	05b2                	slli	a1,a1,0xc
    80000fa4:	ea2ff0ef          	jal	ra,80000646 <uvmunmap>
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fa8:	4681                	li	a3,0
    80000faa:	4605                	li	a2,1
    80000fac:	020005b7          	lui	a1,0x2000
    80000fb0:	15fd                	addi	a1,a1,-1
    80000fb2:	05b6                	slli	a1,a1,0xd
    80000fb4:	8526                	mv	a0,s1
    80000fb6:	e90ff0ef          	jal	ra,80000646 <uvmunmap>
    pte_t *pte = walk(pagetable, USYSCALL, 0);
    80000fba:	4601                	li	a2,0
    80000fbc:	1975                	addi	s2,s2,-3
    80000fbe:	00c91593          	slli	a1,s2,0xc
    80000fc2:	8526                	mv	a0,s1
    80000fc4:	c04ff0ef          	jal	ra,800003c8 <walk>
    if(pte && (*pte & PTE_V)){
    80000fc8:	c501                	beqz	a0,80000fd0 <proc_freepagetable+0x4c>
    80000fca:	611c                	ld	a5,0(a0)
    80000fcc:	8b85                	andi	a5,a5,1
    80000fce:	ef81                	bnez	a5,80000fe6 <proc_freepagetable+0x62>
    uvmfree(pagetable, sz);
    80000fd0:	85ce                	mv	a1,s3
    80000fd2:	8526                	mv	a0,s1
    80000fd4:	8dfff0ef          	jal	ra,800008b2 <uvmfree>
  }
    80000fd8:	70a2                	ld	ra,40(sp)
    80000fda:	7402                	ld	s0,32(sp)
    80000fdc:	64e2                	ld	s1,24(sp)
    80000fde:	6942                	ld	s2,16(sp)
    80000fe0:	69a2                	ld	s3,8(sp)
    80000fe2:	6145                	addi	sp,sp,48
    80000fe4:	8082                	ret
    uvmunmap(pagetable, USYSCALL, 1, 0);
    80000fe6:	4681                	li	a3,0
    80000fe8:	4605                	li	a2,1
    80000fea:	00c91593          	slli	a1,s2,0xc
    80000fee:	8526                	mv	a0,s1
    80000ff0:	e56ff0ef          	jal	ra,80000646 <uvmunmap>
    80000ff4:	bff1                	j	80000fd0 <proc_freepagetable+0x4c>

0000000080000ff6 <freeproc>:
  {
    80000ff6:	1101                	addi	sp,sp,-32
    80000ff8:	ec06                	sd	ra,24(sp)
    80000ffa:	e822                	sd	s0,16(sp)
    80000ffc:	e426                	sd	s1,8(sp)
    80000ffe:	1000                	addi	s0,sp,32
    80001000:	84aa                	mv	s1,a0
   if(p->trapframe)
    80001002:	6128                	ld	a0,64(a0)
    80001004:	c119                	beqz	a0,8000100a <freeproc+0x14>
    kfree((void*)p->trapframe);
    80001006:	816ff0ef          	jal	ra,8000001c <kfree>
  p->trapframe = 0;
    8000100a:	0404b023          	sd	zero,64(s1)
  if(p->usyscall)
    8000100e:	64a8                	ld	a0,72(s1)
    80001010:	c119                	beqz	a0,80001016 <freeproc+0x20>
    kfree((void*)p->usyscall);
    80001012:	80aff0ef          	jal	ra,8000001c <kfree>
  p->usyscall = 0;
    80001016:	0404b423          	sd	zero,72(s1)
  if(p->pagetable){
    8000101a:	68e8                	ld	a0,208(s1)
    8000101c:	c501                	beqz	a0,80001024 <freeproc+0x2e>
    proc_freepagetable(p->pagetable, p->sz);
    8000101e:	64ec                	ld	a1,200(s1)
    80001020:	f65ff0ef          	jal	ra,80000f84 <proc_freepagetable>
    p->pagetable = 0;
    80001024:	0c04b823          	sd	zero,208(s1)
    p->sz = 0;
    80001028:	0c04b423          	sd	zero,200(s1)
    p->pid = 0;
    8000102c:	0204a823          	sw	zero,48(s1)
    p->parent = 0;
    80001030:	0204bc23          	sd	zero,56(s1)
    p->name[0] = 0;
    80001034:	16048023          	sb	zero,352(s1)
    p->chan = 0;
    80001038:	0204b023          	sd	zero,32(s1)
    p->killed = 0;
    8000103c:	0204a423          	sw	zero,40(s1)
    p->xstate = 0;
    80001040:	0204a623          	sw	zero,44(s1)
    p->state = UNUSED;
    80001044:	0004ac23          	sw	zero,24(s1)
  }
    80001048:	60e2                	ld	ra,24(sp)
    8000104a:	6442                	ld	s0,16(sp)
    8000104c:	64a2                	ld	s1,8(sp)
    8000104e:	6105                	addi	sp,sp,32
    80001050:	8082                	ret

0000000080001052 <allocproc>:
  {
    80001052:	1101                	addi	sp,sp,-32
    80001054:	ec06                	sd	ra,24(sp)
    80001056:	e822                	sd	s0,16(sp)
    80001058:	e426                	sd	s1,8(sp)
    8000105a:	e04a                	sd	s2,0(sp)
    8000105c:	1000                	addi	s0,sp,32
    for(p = proc; p < &proc[NPROC]; p++) {
    8000105e:	00007497          	auipc	s1,0x7
    80001062:	d3248493          	addi	s1,s1,-718 # 80007d90 <proc>
    80001066:	0000d917          	auipc	s2,0xd
    8000106a:	92a90913          	addi	s2,s2,-1750 # 8000d990 <tickslock>
      acquire(&p->lock);
    8000106e:	8526                	mv	a0,s1
    80001070:	75a040ef          	jal	ra,800057ca <acquire>
      if(p->state == UNUSED) {
    80001074:	4c9c                	lw	a5,24(s1)
    80001076:	cb91                	beqz	a5,8000108a <allocproc+0x38>
        release(&p->lock);
    80001078:	8526                	mv	a0,s1
    8000107a:	7e8040ef          	jal	ra,80005862 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000107e:	17048493          	addi	s1,s1,368
    80001082:	ff2496e3          	bne	s1,s2,8000106e <allocproc+0x1c>
    return 0;
    80001086:	4481                	li	s1,0
    80001088:	a881                	j	800010d8 <allocproc+0x86>
  p->pid = allocpid();
    8000108a:	e01ff0ef          	jal	ra,80000e8a <allocpid>
    8000108e:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001090:	4785                	li	a5,1
    80001092:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001094:	868ff0ef          	jal	ra,800000fc <kalloc>
    80001098:	892a                	mv	s2,a0
    8000109a:	e0a8                	sd	a0,64(s1)
    8000109c:	c529                	beqz	a0,800010e6 <allocproc+0x94>
  p->usyscall = (struct usyscall *) kalloc();
    8000109e:	85eff0ef          	jal	ra,800000fc <kalloc>
    800010a2:	892a                	mv	s2,a0
    800010a4:	e4a8                	sd	a0,72(s1)
  if(p->usyscall == 0){
    800010a6:	c921                	beqz	a0,800010f6 <allocproc+0xa4>
  p->usyscall->pid = p->pid; // Cập nhật pid trong usyscall ngay khi cấp phát
    800010a8:	589c                	lw	a5,48(s1)
    800010aa:	c11c                	sw	a5,0(a0)
    p->pagetable = proc_pagetable(p);
    800010ac:	8526                	mv	a0,s1
    800010ae:	e1bff0ef          	jal	ra,80000ec8 <proc_pagetable>
    800010b2:	892a                	mv	s2,a0
    800010b4:	e8e8                	sd	a0,208(s1)
    if(p->pagetable == 0){
    800010b6:	c529                	beqz	a0,80001100 <allocproc+0xae>
    memset(&p->context, 0, sizeof(p->context));
    800010b8:	07000613          	li	a2,112
    800010bc:	4581                	li	a1,0
    800010be:	05048513          	addi	a0,s1,80
    800010c2:	88aff0ef          	jal	ra,8000014c <memset>
    p->context.ra = (uint64)forkret;
    800010c6:	00000797          	auipc	a5,0x0
    800010ca:	d8a78793          	addi	a5,a5,-630 # 80000e50 <forkret>
    800010ce:	e8bc                	sd	a5,80(s1)
    p->context.sp = p->kstack + PGSIZE;
    800010d0:	60fc                	ld	a5,192(s1)
    800010d2:	6705                	lui	a4,0x1
    800010d4:	97ba                	add	a5,a5,a4
    800010d6:	ecbc                	sd	a5,88(s1)
  }
    800010d8:	8526                	mv	a0,s1
    800010da:	60e2                	ld	ra,24(sp)
    800010dc:	6442                	ld	s0,16(sp)
    800010de:	64a2                	ld	s1,8(sp)
    800010e0:	6902                	ld	s2,0(sp)
    800010e2:	6105                	addi	sp,sp,32
    800010e4:	8082                	ret
    freeproc(p);
    800010e6:	8526                	mv	a0,s1
    800010e8:	f0fff0ef          	jal	ra,80000ff6 <freeproc>
    release(&p->lock);
    800010ec:	8526                	mv	a0,s1
    800010ee:	774040ef          	jal	ra,80005862 <release>
    return 0;
    800010f2:	84ca                	mv	s1,s2
    800010f4:	b7d5                	j	800010d8 <allocproc+0x86>
    freeproc(p);
    800010f6:	8526                	mv	a0,s1
    800010f8:	effff0ef          	jal	ra,80000ff6 <freeproc>
    return 0;
    800010fc:	84ca                	mv	s1,s2
    800010fe:	bfe9                	j	800010d8 <allocproc+0x86>
      freeproc(p);
    80001100:	8526                	mv	a0,s1
    80001102:	ef5ff0ef          	jal	ra,80000ff6 <freeproc>
      release(&p->lock);
    80001106:	8526                	mv	a0,s1
    80001108:	75a040ef          	jal	ra,80005862 <release>
      return 0;
    8000110c:	84ca                	mv	s1,s2
    8000110e:	b7e9                	j	800010d8 <allocproc+0x86>

0000000080001110 <userinit>:
  {
    80001110:	1101                	addi	sp,sp,-32
    80001112:	ec06                	sd	ra,24(sp)
    80001114:	e822                	sd	s0,16(sp)
    80001116:	e426                	sd	s1,8(sp)
    80001118:	1000                	addi	s0,sp,32
    p = allocproc();
    8000111a:	f39ff0ef          	jal	ra,80001052 <allocproc>
    8000111e:	84aa                	mv	s1,a0
    initproc = p;
    80001120:	00007797          	auipc	a5,0x7
    80001124:	80a7b023          	sd	a0,-2048(a5) # 80007920 <initproc>
    uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001128:	03400613          	li	a2,52
    8000112c:	00006597          	auipc	a1,0x6
    80001130:	7a458593          	addi	a1,a1,1956 # 800078d0 <initcode>
    80001134:	6968                	ld	a0,208(a0)
    80001136:	de2ff0ef          	jal	ra,80000718 <uvmfirst>
    p->sz = PGSIZE;
    8000113a:	6785                	lui	a5,0x1
    8000113c:	e4fc                	sd	a5,200(s1)
    p->trapframe->epc = 0;      // user program counter
    8000113e:	60b8                	ld	a4,64(s1)
    80001140:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
    p->trapframe->sp = PGSIZE;  // user stack pointer
    80001144:	60b8                	ld	a4,64(s1)
    80001146:	fb1c                	sd	a5,48(a4)
    safestrcpy(p->name, "initcode", sizeof(p->name));
    80001148:	4641                	li	a2,16
    8000114a:	00006597          	auipc	a1,0x6
    8000114e:	0a658593          	addi	a1,a1,166 # 800071f0 <etext+0x1f0>
    80001152:	16048513          	addi	a0,s1,352
    80001156:	93cff0ef          	jal	ra,80000292 <safestrcpy>
    p->cwd = namei("/");
    8000115a:	00006517          	auipc	a0,0x6
    8000115e:	0a650513          	addi	a0,a0,166 # 80007200 <etext+0x200>
    80001162:	57b010ef          	jal	ra,80002edc <namei>
    80001166:	14a4bc23          	sd	a0,344(s1)
    p->state = RUNNABLE;
    8000116a:	478d                	li	a5,3
    8000116c:	cc9c                	sw	a5,24(s1)
    release(&p->lock);
    8000116e:	8526                	mv	a0,s1
    80001170:	6f2040ef          	jal	ra,80005862 <release>
  }
    80001174:	60e2                	ld	ra,24(sp)
    80001176:	6442                	ld	s0,16(sp)
    80001178:	64a2                	ld	s1,8(sp)
    8000117a:	6105                	addi	sp,sp,32
    8000117c:	8082                	ret

000000008000117e <growproc>:
  {
    8000117e:	1101                	addi	sp,sp,-32
    80001180:	ec06                	sd	ra,24(sp)
    80001182:	e822                	sd	s0,16(sp)
    80001184:	e426                	sd	s1,8(sp)
    80001186:	e04a                	sd	s2,0(sp)
    80001188:	1000                	addi	s0,sp,32
    8000118a:	892a                	mv	s2,a0
    struct proc *p = myproc();
    8000118c:	c95ff0ef          	jal	ra,80000e20 <myproc>
    80001190:	84aa                	mv	s1,a0
    sz = p->sz;
    80001192:	656c                	ld	a1,200(a0)
    if(n > 0){
    80001194:	01204c63          	bgtz	s2,800011ac <growproc+0x2e>
    } else if(n < 0){
    80001198:	02094463          	bltz	s2,800011c0 <growproc+0x42>
    p->sz = sz;
    8000119c:	e4ec                	sd	a1,200(s1)
    return 0;
    8000119e:	4501                	li	a0,0
  }
    800011a0:	60e2                	ld	ra,24(sp)
    800011a2:	6442                	ld	s0,16(sp)
    800011a4:	64a2                	ld	s1,8(sp)
    800011a6:	6902                	ld	s2,0(sp)
    800011a8:	6105                	addi	sp,sp,32
    800011aa:	8082                	ret
      if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800011ac:	4691                	li	a3,4
    800011ae:	00b90633          	add	a2,s2,a1
    800011b2:	6968                	ld	a0,208(a0)
    800011b4:	e06ff0ef          	jal	ra,800007ba <uvmalloc>
    800011b8:	85aa                	mv	a1,a0
    800011ba:	f16d                	bnez	a0,8000119c <growproc+0x1e>
        return -1;
    800011bc:	557d                	li	a0,-1
    800011be:	b7cd                	j	800011a0 <growproc+0x22>
      sz = uvmdealloc(p->pagetable, sz, sz + n);
    800011c0:	00b90633          	add	a2,s2,a1
    800011c4:	6968                	ld	a0,208(a0)
    800011c6:	db0ff0ef          	jal	ra,80000776 <uvmdealloc>
    800011ca:	85aa                	mv	a1,a0
    800011cc:	bfc1                	j	8000119c <growproc+0x1e>

00000000800011ce <fork>:
  {
    800011ce:	7139                	addi	sp,sp,-64
    800011d0:	fc06                	sd	ra,56(sp)
    800011d2:	f822                	sd	s0,48(sp)
    800011d4:	f426                	sd	s1,40(sp)
    800011d6:	f04a                	sd	s2,32(sp)
    800011d8:	ec4e                	sd	s3,24(sp)
    800011da:	e852                	sd	s4,16(sp)
    800011dc:	e456                	sd	s5,8(sp)
    800011de:	0080                	addi	s0,sp,64
    struct proc *p = myproc();
    800011e0:	c41ff0ef          	jal	ra,80000e20 <myproc>
    800011e4:	8aaa                	mv	s5,a0
    if((np = allocproc()) == 0){
    800011e6:	e6dff0ef          	jal	ra,80001052 <allocproc>
    800011ea:	0e050b63          	beqz	a0,800012e0 <fork+0x112>
    800011ee:	89aa                	mv	s3,a0
    if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800011f0:	0c8ab603          	ld	a2,200(s5)
    800011f4:	696c                	ld	a1,208(a0)
    800011f6:	0d0ab503          	ld	a0,208(s5)
    800011fa:	ef4ff0ef          	jal	ra,800008ee <uvmcopy>
    800011fe:	04054d63          	bltz	a0,80001258 <fork+0x8a>
    np->sz = p->sz;
    80001202:	0c8ab783          	ld	a5,200(s5)
    80001206:	0cf9b423          	sd	a5,200(s3)
    *(np->trapframe) = *(p->trapframe);
    8000120a:	040ab683          	ld	a3,64(s5)
    8000120e:	87b6                	mv	a5,a3
    80001210:	0409b703          	ld	a4,64(s3)
    80001214:	12068693          	addi	a3,a3,288
    80001218:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000121c:	6788                	ld	a0,8(a5)
    8000121e:	6b8c                	ld	a1,16(a5)
    80001220:	6f90                	ld	a2,24(a5)
    80001222:	01073023          	sd	a6,0(a4)
    80001226:	e708                	sd	a0,8(a4)
    80001228:	eb0c                	sd	a1,16(a4)
    8000122a:	ef10                	sd	a2,24(a4)
    8000122c:	02078793          	addi	a5,a5,32
    80001230:	02070713          	addi	a4,a4,32
    80001234:	fed792e3          	bne	a5,a3,80001218 <fork+0x4a>
    np->usyscall->pid = np->pid; // Cập nhật pid trong usyscall của tiến trình con
    80001238:	0489b783          	ld	a5,72(s3)
    8000123c:	0309a703          	lw	a4,48(s3)
    80001240:	c398                	sw	a4,0(a5)
    np->trapframe->a0 = 0;
    80001242:	0409b783          	ld	a5,64(s3)
    80001246:	0607b823          	sd	zero,112(a5)
    for(i = 0; i < NOFILE; i++)
    8000124a:	0d8a8493          	addi	s1,s5,216
    8000124e:	0d898913          	addi	s2,s3,216
    80001252:	158a8a13          	addi	s4,s5,344
    80001256:	a829                	j	80001270 <fork+0xa2>
      freeproc(np);
    80001258:	854e                	mv	a0,s3
    8000125a:	d9dff0ef          	jal	ra,80000ff6 <freeproc>
      release(&np->lock);
    8000125e:	854e                	mv	a0,s3
    80001260:	602040ef          	jal	ra,80005862 <release>
      return -1;
    80001264:	597d                	li	s2,-1
    80001266:	a09d                	j	800012cc <fork+0xfe>
    for(i = 0; i < NOFILE; i++)
    80001268:	04a1                	addi	s1,s1,8
    8000126a:	0921                	addi	s2,s2,8
    8000126c:	01448963          	beq	s1,s4,8000127e <fork+0xb0>
      if(p->ofile[i])
    80001270:	6088                	ld	a0,0(s1)
    80001272:	d97d                	beqz	a0,80001268 <fork+0x9a>
        np->ofile[i] = filedup(p->ofile[i]);
    80001274:	216020ef          	jal	ra,8000348a <filedup>
    80001278:	00a93023          	sd	a0,0(s2)
    8000127c:	b7f5                	j	80001268 <fork+0x9a>
    np->cwd = idup(p->cwd);
    8000127e:	158ab503          	ld	a0,344(s5)
    80001282:	572010ef          	jal	ra,800027f4 <idup>
    80001286:	14a9bc23          	sd	a0,344(s3)
    safestrcpy(np->name, p->name, sizeof(p->name));
    8000128a:	4641                	li	a2,16
    8000128c:	160a8593          	addi	a1,s5,352
    80001290:	16098513          	addi	a0,s3,352
    80001294:	ffffe0ef          	jal	ra,80000292 <safestrcpy>
    pid = np->pid;
    80001298:	0309a903          	lw	s2,48(s3)
    release(&np->lock);
    8000129c:	854e                	mv	a0,s3
    8000129e:	5c4040ef          	jal	ra,80005862 <release>
    acquire(&wait_lock);
    800012a2:	00006497          	auipc	s1,0x6
    800012a6:	6d648493          	addi	s1,s1,1750 # 80007978 <wait_lock>
    800012aa:	8526                	mv	a0,s1
    800012ac:	51e040ef          	jal	ra,800057ca <acquire>
    np->parent = p;
    800012b0:	0359bc23          	sd	s5,56(s3)
    release(&wait_lock);
    800012b4:	8526                	mv	a0,s1
    800012b6:	5ac040ef          	jal	ra,80005862 <release>
    acquire(&np->lock);
    800012ba:	854e                	mv	a0,s3
    800012bc:	50e040ef          	jal	ra,800057ca <acquire>
    np->state = RUNNABLE;
    800012c0:	478d                	li	a5,3
    800012c2:	00f9ac23          	sw	a5,24(s3)
    release(&np->lock);
    800012c6:	854e                	mv	a0,s3
    800012c8:	59a040ef          	jal	ra,80005862 <release>
  }
    800012cc:	854a                	mv	a0,s2
    800012ce:	70e2                	ld	ra,56(sp)
    800012d0:	7442                	ld	s0,48(sp)
    800012d2:	74a2                	ld	s1,40(sp)
    800012d4:	7902                	ld	s2,32(sp)
    800012d6:	69e2                	ld	s3,24(sp)
    800012d8:	6a42                	ld	s4,16(sp)
    800012da:	6aa2                	ld	s5,8(sp)
    800012dc:	6121                	addi	sp,sp,64
    800012de:	8082                	ret
      return -1;
    800012e0:	597d                	li	s2,-1
    800012e2:	b7ed                	j	800012cc <fork+0xfe>

00000000800012e4 <scheduler>:
  {
    800012e4:	715d                	addi	sp,sp,-80
    800012e6:	e486                	sd	ra,72(sp)
    800012e8:	e0a2                	sd	s0,64(sp)
    800012ea:	fc26                	sd	s1,56(sp)
    800012ec:	f84a                	sd	s2,48(sp)
    800012ee:	f44e                	sd	s3,40(sp)
    800012f0:	f052                	sd	s4,32(sp)
    800012f2:	ec56                	sd	s5,24(sp)
    800012f4:	e85a                	sd	s6,16(sp)
    800012f6:	e45e                	sd	s7,8(sp)
    800012f8:	e062                	sd	s8,0(sp)
    800012fa:	0880                	addi	s0,sp,80
    800012fc:	8792                	mv	a5,tp
    int id = r_tp();
    800012fe:	2781                	sext.w	a5,a5
    c->proc = 0;
    80001300:	00779b13          	slli	s6,a5,0x7
    80001304:	00006717          	auipc	a4,0x6
    80001308:	65c70713          	addi	a4,a4,1628 # 80007960 <pid_lock>
    8000130c:	975a                	add	a4,a4,s6
    8000130e:	02073823          	sd	zero,48(a4)
          swtch(&c->context, &p->context);
    80001312:	00006717          	auipc	a4,0x6
    80001316:	68670713          	addi	a4,a4,1670 # 80007998 <cpus+0x8>
    8000131a:	9b3a                	add	s6,s6,a4
          p->state = RUNNING;
    8000131c:	4c11                	li	s8,4
          c->proc = p;
    8000131e:	079e                	slli	a5,a5,0x7
    80001320:	00006a17          	auipc	s4,0x6
    80001324:	640a0a13          	addi	s4,s4,1600 # 80007960 <pid_lock>
    80001328:	9a3e                	add	s4,s4,a5
          found = 1;
    8000132a:	4b85                	li	s7,1
      for(p = proc; p < &proc[NPROC]; p++) {
    8000132c:	0000c997          	auipc	s3,0xc
    80001330:	66498993          	addi	s3,s3,1636 # 8000d990 <tickslock>
    80001334:	a0a9                	j	8000137e <scheduler+0x9a>
        release(&p->lock);
    80001336:	8526                	mv	a0,s1
    80001338:	52a040ef          	jal	ra,80005862 <release>
      for(p = proc; p < &proc[NPROC]; p++) {
    8000133c:	17048493          	addi	s1,s1,368
    80001340:	03348563          	beq	s1,s3,8000136a <scheduler+0x86>
        acquire(&p->lock);
    80001344:	8526                	mv	a0,s1
    80001346:	484040ef          	jal	ra,800057ca <acquire>
        if(p->state == RUNNABLE) {
    8000134a:	4c9c                	lw	a5,24(s1)
    8000134c:	ff2795e3          	bne	a5,s2,80001336 <scheduler+0x52>
          p->state = RUNNING;
    80001350:	0184ac23          	sw	s8,24(s1)
          c->proc = p;
    80001354:	029a3823          	sd	s1,48(s4)
          swtch(&c->context, &p->context);
    80001358:	05048593          	addi	a1,s1,80
    8000135c:	855a                	mv	a0,s6
    8000135e:	5b2000ef          	jal	ra,80001910 <swtch>
          c->proc = 0;
    80001362:	020a3823          	sd	zero,48(s4)
          found = 1;
    80001366:	8ade                	mv	s5,s7
    80001368:	b7f9                	j	80001336 <scheduler+0x52>
      if(found == 0) {
    8000136a:	000a9a63          	bnez	s5,8000137e <scheduler+0x9a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000136e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001372:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001376:	10079073          	csrw	sstatus,a5
        asm volatile("wfi");
    8000137a:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000137e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001382:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001386:	10079073          	csrw	sstatus,a5
      int found = 0;
    8000138a:	4a81                	li	s5,0
      for(p = proc; p < &proc[NPROC]; p++) {
    8000138c:	00007497          	auipc	s1,0x7
    80001390:	a0448493          	addi	s1,s1,-1532 # 80007d90 <proc>
        if(p->state == RUNNABLE) {
    80001394:	490d                	li	s2,3
    80001396:	b77d                	j	80001344 <scheduler+0x60>

0000000080001398 <sched>:
  {
    80001398:	7179                	addi	sp,sp,-48
    8000139a:	f406                	sd	ra,40(sp)
    8000139c:	f022                	sd	s0,32(sp)
    8000139e:	ec26                	sd	s1,24(sp)
    800013a0:	e84a                	sd	s2,16(sp)
    800013a2:	e44e                	sd	s3,8(sp)
    800013a4:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    800013a6:	a7bff0ef          	jal	ra,80000e20 <myproc>
    800013aa:	84aa                	mv	s1,a0
    if(!holding(&p->lock))
    800013ac:	3b4040ef          	jal	ra,80005760 <holding>
    800013b0:	c92d                	beqz	a0,80001422 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    800013b2:	8792                	mv	a5,tp
    if(mycpu()->noff != 1)
    800013b4:	2781                	sext.w	a5,a5
    800013b6:	079e                	slli	a5,a5,0x7
    800013b8:	00006717          	auipc	a4,0x6
    800013bc:	5a870713          	addi	a4,a4,1448 # 80007960 <pid_lock>
    800013c0:	97ba                	add	a5,a5,a4
    800013c2:	0a87a703          	lw	a4,168(a5)
    800013c6:	4785                	li	a5,1
    800013c8:	06f71363          	bne	a4,a5,8000142e <sched+0x96>
    if(p->state == RUNNING)
    800013cc:	4c98                	lw	a4,24(s1)
    800013ce:	4791                	li	a5,4
    800013d0:	06f70563          	beq	a4,a5,8000143a <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013d4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800013d8:	8b89                	andi	a5,a5,2
    if(intr_get())
    800013da:	e7b5                	bnez	a5,80001446 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    800013dc:	8792                	mv	a5,tp
    intena = mycpu()->intena;
    800013de:	00006917          	auipc	s2,0x6
    800013e2:	58290913          	addi	s2,s2,1410 # 80007960 <pid_lock>
    800013e6:	2781                	sext.w	a5,a5
    800013e8:	079e                	slli	a5,a5,0x7
    800013ea:	97ca                	add	a5,a5,s2
    800013ec:	0ac7a983          	lw	s3,172(a5)
    800013f0:	8792                	mv	a5,tp
    swtch(&p->context, &mycpu()->context);
    800013f2:	2781                	sext.w	a5,a5
    800013f4:	079e                	slli	a5,a5,0x7
    800013f6:	00006597          	auipc	a1,0x6
    800013fa:	5a258593          	addi	a1,a1,1442 # 80007998 <cpus+0x8>
    800013fe:	95be                	add	a1,a1,a5
    80001400:	05048513          	addi	a0,s1,80
    80001404:	50c000ef          	jal	ra,80001910 <swtch>
    80001408:	8792                	mv	a5,tp
    mycpu()->intena = intena;
    8000140a:	2781                	sext.w	a5,a5
    8000140c:	079e                	slli	a5,a5,0x7
    8000140e:	97ca                	add	a5,a5,s2
    80001410:	0b37a623          	sw	s3,172(a5)
  }
    80001414:	70a2                	ld	ra,40(sp)
    80001416:	7402                	ld	s0,32(sp)
    80001418:	64e2                	ld	s1,24(sp)
    8000141a:	6942                	ld	s2,16(sp)
    8000141c:	69a2                	ld	s3,8(sp)
    8000141e:	6145                	addi	sp,sp,48
    80001420:	8082                	ret
      panic("sched p->lock");
    80001422:	00006517          	auipc	a0,0x6
    80001426:	de650513          	addi	a0,a0,-538 # 80007208 <etext+0x208>
    8000142a:	08c040ef          	jal	ra,800054b6 <panic>
      panic("sched locks");
    8000142e:	00006517          	auipc	a0,0x6
    80001432:	dea50513          	addi	a0,a0,-534 # 80007218 <etext+0x218>
    80001436:	080040ef          	jal	ra,800054b6 <panic>
      panic("sched running");
    8000143a:	00006517          	auipc	a0,0x6
    8000143e:	dee50513          	addi	a0,a0,-530 # 80007228 <etext+0x228>
    80001442:	074040ef          	jal	ra,800054b6 <panic>
      panic("sched interruptible");
    80001446:	00006517          	auipc	a0,0x6
    8000144a:	df250513          	addi	a0,a0,-526 # 80007238 <etext+0x238>
    8000144e:	068040ef          	jal	ra,800054b6 <panic>

0000000080001452 <yield>:
  {
    80001452:	1101                	addi	sp,sp,-32
    80001454:	ec06                	sd	ra,24(sp)
    80001456:	e822                	sd	s0,16(sp)
    80001458:	e426                	sd	s1,8(sp)
    8000145a:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    8000145c:	9c5ff0ef          	jal	ra,80000e20 <myproc>
    80001460:	84aa                	mv	s1,a0
    acquire(&p->lock);
    80001462:	368040ef          	jal	ra,800057ca <acquire>
    p->state = RUNNABLE;
    80001466:	478d                	li	a5,3
    80001468:	cc9c                	sw	a5,24(s1)
    sched();
    8000146a:	f2fff0ef          	jal	ra,80001398 <sched>
    release(&p->lock);
    8000146e:	8526                	mv	a0,s1
    80001470:	3f2040ef          	jal	ra,80005862 <release>
  }
    80001474:	60e2                	ld	ra,24(sp)
    80001476:	6442                	ld	s0,16(sp)
    80001478:	64a2                	ld	s1,8(sp)
    8000147a:	6105                	addi	sp,sp,32
    8000147c:	8082                	ret

000000008000147e <sleep>:

  // Atomically release lock and sleep on chan.
  // Reacquires lock when awakened.
  void
  sleep(void *chan, struct spinlock *lk)
  {
    8000147e:	7179                	addi	sp,sp,-48
    80001480:	f406                	sd	ra,40(sp)
    80001482:	f022                	sd	s0,32(sp)
    80001484:	ec26                	sd	s1,24(sp)
    80001486:	e84a                	sd	s2,16(sp)
    80001488:	e44e                	sd	s3,8(sp)
    8000148a:	1800                	addi	s0,sp,48
    8000148c:	89aa                	mv	s3,a0
    8000148e:	892e                	mv	s2,a1
    struct proc *p = myproc();
    80001490:	991ff0ef          	jal	ra,80000e20 <myproc>
    80001494:	84aa                	mv	s1,a0
    // Once we hold p->lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup locks p->lock),
    // so it's okay to release lk.

    acquire(&p->lock);  //DOC: sleeplock1
    80001496:	334040ef          	jal	ra,800057ca <acquire>
    release(lk);
    8000149a:	854a                	mv	a0,s2
    8000149c:	3c6040ef          	jal	ra,80005862 <release>

    // Go to sleep.
    p->chan = chan;
    800014a0:	0334b023          	sd	s3,32(s1)
    p->state = SLEEPING;
    800014a4:	4789                	li	a5,2
    800014a6:	cc9c                	sw	a5,24(s1)

    sched();
    800014a8:	ef1ff0ef          	jal	ra,80001398 <sched>

    // Tidy up.
    p->chan = 0;
    800014ac:	0204b023          	sd	zero,32(s1)

    // Reacquire original lock.
    release(&p->lock);
    800014b0:	8526                	mv	a0,s1
    800014b2:	3b0040ef          	jal	ra,80005862 <release>
    acquire(lk);
    800014b6:	854a                	mv	a0,s2
    800014b8:	312040ef          	jal	ra,800057ca <acquire>
  }
    800014bc:	70a2                	ld	ra,40(sp)
    800014be:	7402                	ld	s0,32(sp)
    800014c0:	64e2                	ld	s1,24(sp)
    800014c2:	6942                	ld	s2,16(sp)
    800014c4:	69a2                	ld	s3,8(sp)
    800014c6:	6145                	addi	sp,sp,48
    800014c8:	8082                	ret

00000000800014ca <wakeup>:

  // Wake up all processes sleeping on chan.
  // Must be called without any p->lock.
  void
  wakeup(void *chan)
  {
    800014ca:	7139                	addi	sp,sp,-64
    800014cc:	fc06                	sd	ra,56(sp)
    800014ce:	f822                	sd	s0,48(sp)
    800014d0:	f426                	sd	s1,40(sp)
    800014d2:	f04a                	sd	s2,32(sp)
    800014d4:	ec4e                	sd	s3,24(sp)
    800014d6:	e852                	sd	s4,16(sp)
    800014d8:	e456                	sd	s5,8(sp)
    800014da:	0080                	addi	s0,sp,64
    800014dc:	8a2a                	mv	s4,a0
    struct proc *p;

    for(p = proc; p < &proc[NPROC]; p++) {
    800014de:	00007497          	auipc	s1,0x7
    800014e2:	8b248493          	addi	s1,s1,-1870 # 80007d90 <proc>
      if(p != myproc()){
        acquire(&p->lock);
        if(p->state == SLEEPING && p->chan == chan) {
    800014e6:	4989                	li	s3,2
          p->state = RUNNABLE;
    800014e8:	4a8d                	li	s5,3
    for(p = proc; p < &proc[NPROC]; p++) {
    800014ea:	0000c917          	auipc	s2,0xc
    800014ee:	4a690913          	addi	s2,s2,1190 # 8000d990 <tickslock>
    800014f2:	a801                	j	80001502 <wakeup+0x38>
        }
        release(&p->lock);
    800014f4:	8526                	mv	a0,s1
    800014f6:	36c040ef          	jal	ra,80005862 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800014fa:	17048493          	addi	s1,s1,368
    800014fe:	03248263          	beq	s1,s2,80001522 <wakeup+0x58>
      if(p != myproc()){
    80001502:	91fff0ef          	jal	ra,80000e20 <myproc>
    80001506:	fea48ae3          	beq	s1,a0,800014fa <wakeup+0x30>
        acquire(&p->lock);
    8000150a:	8526                	mv	a0,s1
    8000150c:	2be040ef          	jal	ra,800057ca <acquire>
        if(p->state == SLEEPING && p->chan == chan) {
    80001510:	4c9c                	lw	a5,24(s1)
    80001512:	ff3791e3          	bne	a5,s3,800014f4 <wakeup+0x2a>
    80001516:	709c                	ld	a5,32(s1)
    80001518:	fd479ee3          	bne	a5,s4,800014f4 <wakeup+0x2a>
          p->state = RUNNABLE;
    8000151c:	0154ac23          	sw	s5,24(s1)
    80001520:	bfd1                	j	800014f4 <wakeup+0x2a>
      }
    }
  }
    80001522:	70e2                	ld	ra,56(sp)
    80001524:	7442                	ld	s0,48(sp)
    80001526:	74a2                	ld	s1,40(sp)
    80001528:	7902                	ld	s2,32(sp)
    8000152a:	69e2                	ld	s3,24(sp)
    8000152c:	6a42                	ld	s4,16(sp)
    8000152e:	6aa2                	ld	s5,8(sp)
    80001530:	6121                	addi	sp,sp,64
    80001532:	8082                	ret

0000000080001534 <reparent>:
  {
    80001534:	7179                	addi	sp,sp,-48
    80001536:	f406                	sd	ra,40(sp)
    80001538:	f022                	sd	s0,32(sp)
    8000153a:	ec26                	sd	s1,24(sp)
    8000153c:	e84a                	sd	s2,16(sp)
    8000153e:	e44e                	sd	s3,8(sp)
    80001540:	e052                	sd	s4,0(sp)
    80001542:	1800                	addi	s0,sp,48
    80001544:	892a                	mv	s2,a0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001546:	00007497          	auipc	s1,0x7
    8000154a:	84a48493          	addi	s1,s1,-1974 # 80007d90 <proc>
        pp->parent = initproc;
    8000154e:	00006a17          	auipc	s4,0x6
    80001552:	3d2a0a13          	addi	s4,s4,978 # 80007920 <initproc>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001556:	0000c997          	auipc	s3,0xc
    8000155a:	43a98993          	addi	s3,s3,1082 # 8000d990 <tickslock>
    8000155e:	a029                	j	80001568 <reparent+0x34>
    80001560:	17048493          	addi	s1,s1,368
    80001564:	01348b63          	beq	s1,s3,8000157a <reparent+0x46>
      if(pp->parent == p){
    80001568:	7c9c                	ld	a5,56(s1)
    8000156a:	ff279be3          	bne	a5,s2,80001560 <reparent+0x2c>
        pp->parent = initproc;
    8000156e:	000a3503          	ld	a0,0(s4)
    80001572:	fc88                	sd	a0,56(s1)
        wakeup(initproc);
    80001574:	f57ff0ef          	jal	ra,800014ca <wakeup>
    80001578:	b7e5                	j	80001560 <reparent+0x2c>
  }
    8000157a:	70a2                	ld	ra,40(sp)
    8000157c:	7402                	ld	s0,32(sp)
    8000157e:	64e2                	ld	s1,24(sp)
    80001580:	6942                	ld	s2,16(sp)
    80001582:	69a2                	ld	s3,8(sp)
    80001584:	6a02                	ld	s4,0(sp)
    80001586:	6145                	addi	sp,sp,48
    80001588:	8082                	ret

000000008000158a <exit>:
  {
    8000158a:	7179                	addi	sp,sp,-48
    8000158c:	f406                	sd	ra,40(sp)
    8000158e:	f022                	sd	s0,32(sp)
    80001590:	ec26                	sd	s1,24(sp)
    80001592:	e84a                	sd	s2,16(sp)
    80001594:	e44e                	sd	s3,8(sp)
    80001596:	e052                	sd	s4,0(sp)
    80001598:	1800                	addi	s0,sp,48
    8000159a:	8a2a                	mv	s4,a0
    struct proc *p = myproc();
    8000159c:	885ff0ef          	jal	ra,80000e20 <myproc>
    800015a0:	89aa                	mv	s3,a0
    if(p == initproc)
    800015a2:	00006797          	auipc	a5,0x6
    800015a6:	37e7b783          	ld	a5,894(a5) # 80007920 <initproc>
    800015aa:	0d850493          	addi	s1,a0,216
    800015ae:	15850913          	addi	s2,a0,344
    800015b2:	00a79f63          	bne	a5,a0,800015d0 <exit+0x46>
      panic("init exiting");
    800015b6:	00006517          	auipc	a0,0x6
    800015ba:	c9a50513          	addi	a0,a0,-870 # 80007250 <etext+0x250>
    800015be:	6f9030ef          	jal	ra,800054b6 <panic>
        fileclose(f);
    800015c2:	70f010ef          	jal	ra,800034d0 <fileclose>
        p->ofile[fd] = 0;
    800015c6:	0004b023          	sd	zero,0(s1)
    for(int fd = 0; fd < NOFILE; fd++){
    800015ca:	04a1                	addi	s1,s1,8
    800015cc:	01248563          	beq	s1,s2,800015d6 <exit+0x4c>
      if(p->ofile[fd]){
    800015d0:	6088                	ld	a0,0(s1)
    800015d2:	f965                	bnez	a0,800015c2 <exit+0x38>
    800015d4:	bfdd                	j	800015ca <exit+0x40>
    begin_op();
    800015d6:	2df010ef          	jal	ra,800030b4 <begin_op>
    iput(p->cwd);
    800015da:	1589b503          	ld	a0,344(s3)
    800015de:	3ca010ef          	jal	ra,800029a8 <iput>
    end_op();
    800015e2:	343010ef          	jal	ra,80003124 <end_op>
    p->cwd = 0;
    800015e6:	1409bc23          	sd	zero,344(s3)
    acquire(&wait_lock);
    800015ea:	00006497          	auipc	s1,0x6
    800015ee:	38e48493          	addi	s1,s1,910 # 80007978 <wait_lock>
    800015f2:	8526                	mv	a0,s1
    800015f4:	1d6040ef          	jal	ra,800057ca <acquire>
    reparent(p);
    800015f8:	854e                	mv	a0,s3
    800015fa:	f3bff0ef          	jal	ra,80001534 <reparent>
    wakeup(p->parent);
    800015fe:	0389b503          	ld	a0,56(s3)
    80001602:	ec9ff0ef          	jal	ra,800014ca <wakeup>
    acquire(&p->lock);
    80001606:	854e                	mv	a0,s3
    80001608:	1c2040ef          	jal	ra,800057ca <acquire>
    p->xstate = status;
    8000160c:	0349a623          	sw	s4,44(s3)
    p->state = ZOMBIE;
    80001610:	4795                	li	a5,5
    80001612:	00f9ac23          	sw	a5,24(s3)
    release(&wait_lock);
    80001616:	8526                	mv	a0,s1
    80001618:	24a040ef          	jal	ra,80005862 <release>
    sched();
    8000161c:	d7dff0ef          	jal	ra,80001398 <sched>
    panic("zombie exit");
    80001620:	00006517          	auipc	a0,0x6
    80001624:	c4050513          	addi	a0,a0,-960 # 80007260 <etext+0x260>
    80001628:	68f030ef          	jal	ra,800054b6 <panic>

000000008000162c <kill>:
  // Kill the process with the given pid.
  // The victim won't exit until it tries to return
  // to user space (see usertrap() in trap.c).
  int
  kill(int pid)
  {
    8000162c:	7179                	addi	sp,sp,-48
    8000162e:	f406                	sd	ra,40(sp)
    80001630:	f022                	sd	s0,32(sp)
    80001632:	ec26                	sd	s1,24(sp)
    80001634:	e84a                	sd	s2,16(sp)
    80001636:	e44e                	sd	s3,8(sp)
    80001638:	1800                	addi	s0,sp,48
    8000163a:	892a                	mv	s2,a0
    struct proc *p;

    for(p = proc; p < &proc[NPROC]; p++){
    8000163c:	00006497          	auipc	s1,0x6
    80001640:	75448493          	addi	s1,s1,1876 # 80007d90 <proc>
    80001644:	0000c997          	auipc	s3,0xc
    80001648:	34c98993          	addi	s3,s3,844 # 8000d990 <tickslock>
      acquire(&p->lock);
    8000164c:	8526                	mv	a0,s1
    8000164e:	17c040ef          	jal	ra,800057ca <acquire>
      if(p->pid == pid){
    80001652:	589c                	lw	a5,48(s1)
    80001654:	01278b63          	beq	a5,s2,8000166a <kill+0x3e>
          p->state = RUNNABLE;
        }
        release(&p->lock);
        return 0;
      }
      release(&p->lock);
    80001658:	8526                	mv	a0,s1
    8000165a:	208040ef          	jal	ra,80005862 <release>
    for(p = proc; p < &proc[NPROC]; p++){
    8000165e:	17048493          	addi	s1,s1,368
    80001662:	ff3495e3          	bne	s1,s3,8000164c <kill+0x20>
    }
    return -1;
    80001666:	557d                	li	a0,-1
    80001668:	a819                	j	8000167e <kill+0x52>
        p->killed = 1;
    8000166a:	4785                	li	a5,1
    8000166c:	d49c                	sw	a5,40(s1)
        if(p->state == SLEEPING){
    8000166e:	4c98                	lw	a4,24(s1)
    80001670:	4789                	li	a5,2
    80001672:	00f70d63          	beq	a4,a5,8000168c <kill+0x60>
        release(&p->lock);
    80001676:	8526                	mv	a0,s1
    80001678:	1ea040ef          	jal	ra,80005862 <release>
        return 0;
    8000167c:	4501                	li	a0,0
  }
    8000167e:	70a2                	ld	ra,40(sp)
    80001680:	7402                	ld	s0,32(sp)
    80001682:	64e2                	ld	s1,24(sp)
    80001684:	6942                	ld	s2,16(sp)
    80001686:	69a2                	ld	s3,8(sp)
    80001688:	6145                	addi	sp,sp,48
    8000168a:	8082                	ret
          p->state = RUNNABLE;
    8000168c:	478d                	li	a5,3
    8000168e:	cc9c                	sw	a5,24(s1)
    80001690:	b7dd                	j	80001676 <kill+0x4a>

0000000080001692 <setkilled>:

  void
  setkilled(struct proc *p)
  {
    80001692:	1101                	addi	sp,sp,-32
    80001694:	ec06                	sd	ra,24(sp)
    80001696:	e822                	sd	s0,16(sp)
    80001698:	e426                	sd	s1,8(sp)
    8000169a:	1000                	addi	s0,sp,32
    8000169c:	84aa                	mv	s1,a0
    acquire(&p->lock);
    8000169e:	12c040ef          	jal	ra,800057ca <acquire>
    p->killed = 1;
    800016a2:	4785                	li	a5,1
    800016a4:	d49c                	sw	a5,40(s1)
    release(&p->lock);
    800016a6:	8526                	mv	a0,s1
    800016a8:	1ba040ef          	jal	ra,80005862 <release>
  }
    800016ac:	60e2                	ld	ra,24(sp)
    800016ae:	6442                	ld	s0,16(sp)
    800016b0:	64a2                	ld	s1,8(sp)
    800016b2:	6105                	addi	sp,sp,32
    800016b4:	8082                	ret

00000000800016b6 <killed>:

  int
  killed(struct proc *p)
  {
    800016b6:	1101                	addi	sp,sp,-32
    800016b8:	ec06                	sd	ra,24(sp)
    800016ba:	e822                	sd	s0,16(sp)
    800016bc:	e426                	sd	s1,8(sp)
    800016be:	e04a                	sd	s2,0(sp)
    800016c0:	1000                	addi	s0,sp,32
    800016c2:	84aa                	mv	s1,a0
    int k;
    
    acquire(&p->lock);
    800016c4:	106040ef          	jal	ra,800057ca <acquire>
    k = p->killed;
    800016c8:	0284a903          	lw	s2,40(s1)
    release(&p->lock);
    800016cc:	8526                	mv	a0,s1
    800016ce:	194040ef          	jal	ra,80005862 <release>
    return k;
  }
    800016d2:	854a                	mv	a0,s2
    800016d4:	60e2                	ld	ra,24(sp)
    800016d6:	6442                	ld	s0,16(sp)
    800016d8:	64a2                	ld	s1,8(sp)
    800016da:	6902                	ld	s2,0(sp)
    800016dc:	6105                	addi	sp,sp,32
    800016de:	8082                	ret

00000000800016e0 <wait>:
  {
    800016e0:	715d                	addi	sp,sp,-80
    800016e2:	e486                	sd	ra,72(sp)
    800016e4:	e0a2                	sd	s0,64(sp)
    800016e6:	fc26                	sd	s1,56(sp)
    800016e8:	f84a                	sd	s2,48(sp)
    800016ea:	f44e                	sd	s3,40(sp)
    800016ec:	f052                	sd	s4,32(sp)
    800016ee:	ec56                	sd	s5,24(sp)
    800016f0:	e85a                	sd	s6,16(sp)
    800016f2:	e45e                	sd	s7,8(sp)
    800016f4:	e062                	sd	s8,0(sp)
    800016f6:	0880                	addi	s0,sp,80
    800016f8:	8b2a                	mv	s6,a0
    struct proc *p = myproc();
    800016fa:	f26ff0ef          	jal	ra,80000e20 <myproc>
    800016fe:	892a                	mv	s2,a0
    acquire(&wait_lock);
    80001700:	00006517          	auipc	a0,0x6
    80001704:	27850513          	addi	a0,a0,632 # 80007978 <wait_lock>
    80001708:	0c2040ef          	jal	ra,800057ca <acquire>
      havekids = 0;
    8000170c:	4b81                	li	s7,0
          if(pp->state == ZOMBIE){
    8000170e:	4a15                	li	s4,5
          havekids = 1;
    80001710:	4a85                	li	s5,1
      for(pp = proc; pp < &proc[NPROC]; pp++){
    80001712:	0000c997          	auipc	s3,0xc
    80001716:	27e98993          	addi	s3,s3,638 # 8000d990 <tickslock>
      sleep(p, &wait_lock);  //DOC: wait-sleep
    8000171a:	00006c17          	auipc	s8,0x6
    8000171e:	25ec0c13          	addi	s8,s8,606 # 80007978 <wait_lock>
      havekids = 0;
    80001722:	875e                	mv	a4,s7
      for(pp = proc; pp < &proc[NPROC]; pp++){
    80001724:	00006497          	auipc	s1,0x6
    80001728:	66c48493          	addi	s1,s1,1644 # 80007d90 <proc>
    8000172c:	a899                	j	80001782 <wait+0xa2>
            pid = pp->pid;
    8000172e:	0304a983          	lw	s3,48(s1)
            if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001732:	000b0c63          	beqz	s6,8000174a <wait+0x6a>
    80001736:	4691                	li	a3,4
    80001738:	02c48613          	addi	a2,s1,44
    8000173c:	85da                	mv	a1,s6
    8000173e:	0d093503          	ld	a0,208(s2)
    80001742:	ac4ff0ef          	jal	ra,80000a06 <copyout>
    80001746:	00054f63          	bltz	a0,80001764 <wait+0x84>
            freeproc(pp);
    8000174a:	8526                	mv	a0,s1
    8000174c:	8abff0ef          	jal	ra,80000ff6 <freeproc>
            release(&pp->lock);
    80001750:	8526                	mv	a0,s1
    80001752:	110040ef          	jal	ra,80005862 <release>
            release(&wait_lock);
    80001756:	00006517          	auipc	a0,0x6
    8000175a:	22250513          	addi	a0,a0,546 # 80007978 <wait_lock>
    8000175e:	104040ef          	jal	ra,80005862 <release>
            return pid;
    80001762:	a891                	j	800017b6 <wait+0xd6>
              release(&pp->lock);
    80001764:	8526                	mv	a0,s1
    80001766:	0fc040ef          	jal	ra,80005862 <release>
              release(&wait_lock);
    8000176a:	00006517          	auipc	a0,0x6
    8000176e:	20e50513          	addi	a0,a0,526 # 80007978 <wait_lock>
    80001772:	0f0040ef          	jal	ra,80005862 <release>
              return -1;
    80001776:	59fd                	li	s3,-1
    80001778:	a83d                	j	800017b6 <wait+0xd6>
      for(pp = proc; pp < &proc[NPROC]; pp++){
    8000177a:	17048493          	addi	s1,s1,368
    8000177e:	03348063          	beq	s1,s3,8000179e <wait+0xbe>
        if(pp->parent == p){
    80001782:	7c9c                	ld	a5,56(s1)
    80001784:	ff279be3          	bne	a5,s2,8000177a <wait+0x9a>
          acquire(&pp->lock);
    80001788:	8526                	mv	a0,s1
    8000178a:	040040ef          	jal	ra,800057ca <acquire>
          if(pp->state == ZOMBIE){
    8000178e:	4c9c                	lw	a5,24(s1)
    80001790:	f9478fe3          	beq	a5,s4,8000172e <wait+0x4e>
          release(&pp->lock);
    80001794:	8526                	mv	a0,s1
    80001796:	0cc040ef          	jal	ra,80005862 <release>
          havekids = 1;
    8000179a:	8756                	mv	a4,s5
    8000179c:	bff9                	j	8000177a <wait+0x9a>
      if(!havekids || killed(p)){
    8000179e:	c709                	beqz	a4,800017a8 <wait+0xc8>
    800017a0:	854a                	mv	a0,s2
    800017a2:	f15ff0ef          	jal	ra,800016b6 <killed>
    800017a6:	c50d                	beqz	a0,800017d0 <wait+0xf0>
        release(&wait_lock);
    800017a8:	00006517          	auipc	a0,0x6
    800017ac:	1d050513          	addi	a0,a0,464 # 80007978 <wait_lock>
    800017b0:	0b2040ef          	jal	ra,80005862 <release>
        return -1;
    800017b4:	59fd                	li	s3,-1
  }
    800017b6:	854e                	mv	a0,s3
    800017b8:	60a6                	ld	ra,72(sp)
    800017ba:	6406                	ld	s0,64(sp)
    800017bc:	74e2                	ld	s1,56(sp)
    800017be:	7942                	ld	s2,48(sp)
    800017c0:	79a2                	ld	s3,40(sp)
    800017c2:	7a02                	ld	s4,32(sp)
    800017c4:	6ae2                	ld	s5,24(sp)
    800017c6:	6b42                	ld	s6,16(sp)
    800017c8:	6ba2                	ld	s7,8(sp)
    800017ca:	6c02                	ld	s8,0(sp)
    800017cc:	6161                	addi	sp,sp,80
    800017ce:	8082                	ret
      sleep(p, &wait_lock);  //DOC: wait-sleep
    800017d0:	85e2                	mv	a1,s8
    800017d2:	854a                	mv	a0,s2
    800017d4:	cabff0ef          	jal	ra,8000147e <sleep>
      havekids = 0;
    800017d8:	b7a9                	j	80001722 <wait+0x42>

00000000800017da <either_copyout>:
  // Copy to either a user address, or kernel address,
  // depending on usr_dst.
  // Returns 0 on success, -1 on error.
  int
  either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
  {
    800017da:	7179                	addi	sp,sp,-48
    800017dc:	f406                	sd	ra,40(sp)
    800017de:	f022                	sd	s0,32(sp)
    800017e0:	ec26                	sd	s1,24(sp)
    800017e2:	e84a                	sd	s2,16(sp)
    800017e4:	e44e                	sd	s3,8(sp)
    800017e6:	e052                	sd	s4,0(sp)
    800017e8:	1800                	addi	s0,sp,48
    800017ea:	84aa                	mv	s1,a0
    800017ec:	892e                	mv	s2,a1
    800017ee:	89b2                	mv	s3,a2
    800017f0:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    800017f2:	e2eff0ef          	jal	ra,80000e20 <myproc>
    if(user_dst){
    800017f6:	cc99                	beqz	s1,80001814 <either_copyout+0x3a>
      return copyout(p->pagetable, dst, src, len);
    800017f8:	86d2                	mv	a3,s4
    800017fa:	864e                	mv	a2,s3
    800017fc:	85ca                	mv	a1,s2
    800017fe:	6968                	ld	a0,208(a0)
    80001800:	a06ff0ef          	jal	ra,80000a06 <copyout>
    } else {
      memmove((char *)dst, src, len);
      return 0;
    }
  }
    80001804:	70a2                	ld	ra,40(sp)
    80001806:	7402                	ld	s0,32(sp)
    80001808:	64e2                	ld	s1,24(sp)
    8000180a:	6942                	ld	s2,16(sp)
    8000180c:	69a2                	ld	s3,8(sp)
    8000180e:	6a02                	ld	s4,0(sp)
    80001810:	6145                	addi	sp,sp,48
    80001812:	8082                	ret
      memmove((char *)dst, src, len);
    80001814:	000a061b          	sext.w	a2,s4
    80001818:	85ce                	mv	a1,s3
    8000181a:	854a                	mv	a0,s2
    8000181c:	98dfe0ef          	jal	ra,800001a8 <memmove>
      return 0;
    80001820:	8526                	mv	a0,s1
    80001822:	b7cd                	j	80001804 <either_copyout+0x2a>

0000000080001824 <either_copyin>:
  // Copy from either a user address, or kernel address,
  // depending on usr_src.
  // Returns 0 on success, -1 on error.
  int
  either_copyin(void *dst, int user_src, uint64 src, uint64 len)
  {
    80001824:	7179                	addi	sp,sp,-48
    80001826:	f406                	sd	ra,40(sp)
    80001828:	f022                	sd	s0,32(sp)
    8000182a:	ec26                	sd	s1,24(sp)
    8000182c:	e84a                	sd	s2,16(sp)
    8000182e:	e44e                	sd	s3,8(sp)
    80001830:	e052                	sd	s4,0(sp)
    80001832:	1800                	addi	s0,sp,48
    80001834:	892a                	mv	s2,a0
    80001836:	84ae                	mv	s1,a1
    80001838:	89b2                	mv	s3,a2
    8000183a:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    8000183c:	de4ff0ef          	jal	ra,80000e20 <myproc>
    if(user_src){
    80001840:	cc99                	beqz	s1,8000185e <either_copyin+0x3a>
      return copyin(p->pagetable, dst, src, len);
    80001842:	86d2                	mv	a3,s4
    80001844:	864e                	mv	a2,s3
    80001846:	85ca                	mv	a1,s2
    80001848:	6968                	ld	a0,208(a0)
    8000184a:	a74ff0ef          	jal	ra,80000abe <copyin>
    } else {
      memmove(dst, (char*)src, len);
      return 0;
    }
  }
    8000184e:	70a2                	ld	ra,40(sp)
    80001850:	7402                	ld	s0,32(sp)
    80001852:	64e2                	ld	s1,24(sp)
    80001854:	6942                	ld	s2,16(sp)
    80001856:	69a2                	ld	s3,8(sp)
    80001858:	6a02                	ld	s4,0(sp)
    8000185a:	6145                	addi	sp,sp,48
    8000185c:	8082                	ret
      memmove(dst, (char*)src, len);
    8000185e:	000a061b          	sext.w	a2,s4
    80001862:	85ce                	mv	a1,s3
    80001864:	854a                	mv	a0,s2
    80001866:	943fe0ef          	jal	ra,800001a8 <memmove>
      return 0;
    8000186a:	8526                	mv	a0,s1
    8000186c:	b7cd                	j	8000184e <either_copyin+0x2a>

000000008000186e <procdump>:
  // Print a process listing to console.  For debugging.
  // Runs when user types ^P on console.
  // No lock to avoid wedging a stuck machine further.
  void
  procdump(void)
  {
    8000186e:	715d                	addi	sp,sp,-80
    80001870:	e486                	sd	ra,72(sp)
    80001872:	e0a2                	sd	s0,64(sp)
    80001874:	fc26                	sd	s1,56(sp)
    80001876:	f84a                	sd	s2,48(sp)
    80001878:	f44e                	sd	s3,40(sp)
    8000187a:	f052                	sd	s4,32(sp)
    8000187c:	ec56                	sd	s5,24(sp)
    8000187e:	e85a                	sd	s6,16(sp)
    80001880:	e45e                	sd	s7,8(sp)
    80001882:	0880                	addi	s0,sp,80
    [ZOMBIE]    "zombie"
    };
    struct proc *p;
    char *state;

    printf("\n");
    80001884:	00005517          	auipc	a0,0x5
    80001888:	7c450513          	addi	a0,a0,1988 # 80007048 <etext+0x48>
    8000188c:	177030ef          	jal	ra,80005202 <printf>
    for(p = proc; p < &proc[NPROC]; p++){
    80001890:	00006497          	auipc	s1,0x6
    80001894:	66048493          	addi	s1,s1,1632 # 80007ef0 <proc+0x160>
    80001898:	0000c917          	auipc	s2,0xc
    8000189c:	25890913          	addi	s2,s2,600 # 8000daf0 <bcache+0x148>
      if(p->state == UNUSED)
        continue;
      if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800018a0:	4b15                	li	s6,5
        state = states[p->state];
      else
        state = "???";
    800018a2:	00006997          	auipc	s3,0x6
    800018a6:	9ce98993          	addi	s3,s3,-1586 # 80007270 <etext+0x270>
      printf("%d %s %s", p->pid, state, p->name);
    800018aa:	00006a97          	auipc	s5,0x6
    800018ae:	9cea8a93          	addi	s5,s5,-1586 # 80007278 <etext+0x278>
      printf("\n");
    800018b2:	00005a17          	auipc	s4,0x5
    800018b6:	796a0a13          	addi	s4,s4,1942 # 80007048 <etext+0x48>
      if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800018ba:	00006b97          	auipc	s7,0x6
    800018be:	9feb8b93          	addi	s7,s7,-1538 # 800072b8 <states.0>
    800018c2:	a829                	j	800018dc <procdump+0x6e>
      printf("%d %s %s", p->pid, state, p->name);
    800018c4:	ed06a583          	lw	a1,-304(a3)
    800018c8:	8556                	mv	a0,s5
    800018ca:	139030ef          	jal	ra,80005202 <printf>
      printf("\n");
    800018ce:	8552                	mv	a0,s4
    800018d0:	133030ef          	jal	ra,80005202 <printf>
    for(p = proc; p < &proc[NPROC]; p++){
    800018d4:	17048493          	addi	s1,s1,368
    800018d8:	03248163          	beq	s1,s2,800018fa <procdump+0x8c>
      if(p->state == UNUSED)
    800018dc:	86a6                	mv	a3,s1
    800018de:	eb84a783          	lw	a5,-328(s1)
    800018e2:	dbed                	beqz	a5,800018d4 <procdump+0x66>
        state = "???";
    800018e4:	864e                	mv	a2,s3
      if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800018e6:	fcfb6fe3          	bltu	s6,a5,800018c4 <procdump+0x56>
    800018ea:	1782                	slli	a5,a5,0x20
    800018ec:	9381                	srli	a5,a5,0x20
    800018ee:	078e                	slli	a5,a5,0x3
    800018f0:	97de                	add	a5,a5,s7
    800018f2:	6390                	ld	a2,0(a5)
    800018f4:	fa61                	bnez	a2,800018c4 <procdump+0x56>
        state = "???";
    800018f6:	864e                	mv	a2,s3
    800018f8:	b7f1                	j	800018c4 <procdump+0x56>
    }
  }
    800018fa:	60a6                	ld	ra,72(sp)
    800018fc:	6406                	ld	s0,64(sp)
    800018fe:	74e2                	ld	s1,56(sp)
    80001900:	7942                	ld	s2,48(sp)
    80001902:	79a2                	ld	s3,40(sp)
    80001904:	7a02                	ld	s4,32(sp)
    80001906:	6ae2                	ld	s5,24(sp)
    80001908:	6b42                	ld	s6,16(sp)
    8000190a:	6ba2                	ld	s7,8(sp)
    8000190c:	6161                	addi	sp,sp,80
    8000190e:	8082                	ret

0000000080001910 <swtch>:
    80001910:	00153023          	sd	ra,0(a0)
    80001914:	00253423          	sd	sp,8(a0)
    80001918:	e900                	sd	s0,16(a0)
    8000191a:	ed04                	sd	s1,24(a0)
    8000191c:	03253023          	sd	s2,32(a0)
    80001920:	03353423          	sd	s3,40(a0)
    80001924:	03453823          	sd	s4,48(a0)
    80001928:	03553c23          	sd	s5,56(a0)
    8000192c:	05653023          	sd	s6,64(a0)
    80001930:	05753423          	sd	s7,72(a0)
    80001934:	05853823          	sd	s8,80(a0)
    80001938:	05953c23          	sd	s9,88(a0)
    8000193c:	07a53023          	sd	s10,96(a0)
    80001940:	07b53423          	sd	s11,104(a0)
    80001944:	0005b083          	ld	ra,0(a1)
    80001948:	0085b103          	ld	sp,8(a1)
    8000194c:	6980                	ld	s0,16(a1)
    8000194e:	6d84                	ld	s1,24(a1)
    80001950:	0205b903          	ld	s2,32(a1)
    80001954:	0285b983          	ld	s3,40(a1)
    80001958:	0305ba03          	ld	s4,48(a1)
    8000195c:	0385ba83          	ld	s5,56(a1)
    80001960:	0405bb03          	ld	s6,64(a1)
    80001964:	0485bb83          	ld	s7,72(a1)
    80001968:	0505bc03          	ld	s8,80(a1)
    8000196c:	0585bc83          	ld	s9,88(a1)
    80001970:	0605bd03          	ld	s10,96(a1)
    80001974:	0685bd83          	ld	s11,104(a1)
    80001978:	8082                	ret

000000008000197a <trapinit>:

extern int devintr();

void
trapinit(void)
{
    8000197a:	1141                	addi	sp,sp,-16
    8000197c:	e406                	sd	ra,8(sp)
    8000197e:	e022                	sd	s0,0(sp)
    80001980:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001982:	00006597          	auipc	a1,0x6
    80001986:	96658593          	addi	a1,a1,-1690 # 800072e8 <states.0+0x30>
    8000198a:	0000c517          	auipc	a0,0xc
    8000198e:	00650513          	addi	a0,a0,6 # 8000d990 <tickslock>
    80001992:	5b9030ef          	jal	ra,8000574a <initlock>
}
    80001996:	60a2                	ld	ra,8(sp)
    80001998:	6402                	ld	s0,0(sp)
    8000199a:	0141                	addi	sp,sp,16
    8000199c:	8082                	ret

000000008000199e <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    8000199e:	1141                	addi	sp,sp,-16
    800019a0:	e422                	sd	s0,8(sp)
    800019a2:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800019a4:	00003797          	auipc	a5,0x3
    800019a8:	dfc78793          	addi	a5,a5,-516 # 800047a0 <kernelvec>
    800019ac:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800019b0:	6422                	ld	s0,8(sp)
    800019b2:	0141                	addi	sp,sp,16
    800019b4:	8082                	ret

00000000800019b6 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    800019b6:	1141                	addi	sp,sp,-16
    800019b8:	e406                	sd	ra,8(sp)
    800019ba:	e022                	sd	s0,0(sp)
    800019bc:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800019be:	c62ff0ef          	jal	ra,80000e20 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800019c2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800019c6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800019c8:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    800019cc:	00004617          	auipc	a2,0x4
    800019d0:	63460613          	addi	a2,a2,1588 # 80006000 <_trampoline>
    800019d4:	00004697          	auipc	a3,0x4
    800019d8:	62c68693          	addi	a3,a3,1580 # 80006000 <_trampoline>
    800019dc:	8e91                	sub	a3,a3,a2
    800019de:	040007b7          	lui	a5,0x4000
    800019e2:	17fd                	addi	a5,a5,-1
    800019e4:	07b2                	slli	a5,a5,0xc
    800019e6:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    800019e8:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800019ec:	6138                	ld	a4,64(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800019ee:	180026f3          	csrr	a3,satp
    800019f2:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800019f4:	6138                	ld	a4,64(a0)
    800019f6:	6174                	ld	a3,192(a0)
    800019f8:	6585                	lui	a1,0x1
    800019fa:	96ae                	add	a3,a3,a1
    800019fc:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800019fe:	6138                	ld	a4,64(a0)
    80001a00:	00000697          	auipc	a3,0x0
    80001a04:	10c68693          	addi	a3,a3,268 # 80001b0c <usertrap>
    80001a08:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001a0a:	6138                	ld	a4,64(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001a0c:	8692                	mv	a3,tp
    80001a0e:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a10:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001a14:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001a18:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001a1c:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001a20:	6138                	ld	a4,64(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001a22:	6f18                	ld	a4,24(a4)
    80001a24:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001a28:	6968                	ld	a0,208(a0)
    80001a2a:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001a2c:	00004717          	auipc	a4,0x4
    80001a30:	67070713          	addi	a4,a4,1648 # 8000609c <userret>
    80001a34:	8f11                	sub	a4,a4,a2
    80001a36:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001a38:	577d                	li	a4,-1
    80001a3a:	177e                	slli	a4,a4,0x3f
    80001a3c:	8d59                	or	a0,a0,a4
    80001a3e:	9782                	jalr	a5
}
    80001a40:	60a2                	ld	ra,8(sp)
    80001a42:	6402                	ld	s0,0(sp)
    80001a44:	0141                	addi	sp,sp,16
    80001a46:	8082                	ret

0000000080001a48 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001a48:	1101                	addi	sp,sp,-32
    80001a4a:	ec06                	sd	ra,24(sp)
    80001a4c:	e822                	sd	s0,16(sp)
    80001a4e:	e426                	sd	s1,8(sp)
    80001a50:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    80001a52:	ba2ff0ef          	jal	ra,80000df4 <cpuid>
    80001a56:	cd19                	beqz	a0,80001a74 <clockintr+0x2c>
  asm volatile("csrr %0, time" : "=r" (x) );
    80001a58:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80001a5c:	000f4737          	lui	a4,0xf4
    80001a60:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80001a64:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80001a66:	14d79073          	csrw	0x14d,a5
}
    80001a6a:	60e2                	ld	ra,24(sp)
    80001a6c:	6442                	ld	s0,16(sp)
    80001a6e:	64a2                	ld	s1,8(sp)
    80001a70:	6105                	addi	sp,sp,32
    80001a72:	8082                	ret
    acquire(&tickslock);
    80001a74:	0000c497          	auipc	s1,0xc
    80001a78:	f1c48493          	addi	s1,s1,-228 # 8000d990 <tickslock>
    80001a7c:	8526                	mv	a0,s1
    80001a7e:	54d030ef          	jal	ra,800057ca <acquire>
    ticks++;
    80001a82:	00006517          	auipc	a0,0x6
    80001a86:	ea650513          	addi	a0,a0,-346 # 80007928 <ticks>
    80001a8a:	411c                	lw	a5,0(a0)
    80001a8c:	2785                	addiw	a5,a5,1
    80001a8e:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80001a90:	a3bff0ef          	jal	ra,800014ca <wakeup>
    release(&tickslock);
    80001a94:	8526                	mv	a0,s1
    80001a96:	5cd030ef          	jal	ra,80005862 <release>
    80001a9a:	bf7d                	j	80001a58 <clockintr+0x10>

0000000080001a9c <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001a9c:	1101                	addi	sp,sp,-32
    80001a9e:	ec06                	sd	ra,24(sp)
    80001aa0:	e822                	sd	s0,16(sp)
    80001aa2:	e426                	sd	s1,8(sp)
    80001aa4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001aa6:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80001aaa:	57fd                	li	a5,-1
    80001aac:	17fe                	slli	a5,a5,0x3f
    80001aae:	07a5                	addi	a5,a5,9
    80001ab0:	00f70d63          	beq	a4,a5,80001aca <devintr+0x2e>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80001ab4:	57fd                	li	a5,-1
    80001ab6:	17fe                	slli	a5,a5,0x3f
    80001ab8:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80001aba:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80001abc:	04f70463          	beq	a4,a5,80001b04 <devintr+0x68>
  }
}
    80001ac0:	60e2                	ld	ra,24(sp)
    80001ac2:	6442                	ld	s0,16(sp)
    80001ac4:	64a2                	ld	s1,8(sp)
    80001ac6:	6105                	addi	sp,sp,32
    80001ac8:	8082                	ret
    int irq = plic_claim();
    80001aca:	57f020ef          	jal	ra,80004848 <plic_claim>
    80001ace:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001ad0:	47a9                	li	a5,10
    80001ad2:	02f50363          	beq	a0,a5,80001af8 <devintr+0x5c>
    } else if(irq == VIRTIO0_IRQ){
    80001ad6:	4785                	li	a5,1
    80001ad8:	02f50363          	beq	a0,a5,80001afe <devintr+0x62>
    return 1;
    80001adc:	4505                	li	a0,1
    } else if(irq){
    80001ade:	d0ed                	beqz	s1,80001ac0 <devintr+0x24>
      printf("unexpected interrupt irq=%d\n", irq);
    80001ae0:	85a6                	mv	a1,s1
    80001ae2:	00006517          	auipc	a0,0x6
    80001ae6:	80e50513          	addi	a0,a0,-2034 # 800072f0 <states.0+0x38>
    80001aea:	718030ef          	jal	ra,80005202 <printf>
      plic_complete(irq);
    80001aee:	8526                	mv	a0,s1
    80001af0:	579020ef          	jal	ra,80004868 <plic_complete>
    return 1;
    80001af4:	4505                	li	a0,1
    80001af6:	b7e9                	j	80001ac0 <devintr+0x24>
      uartintr();
    80001af8:	417030ef          	jal	ra,8000570e <uartintr>
    80001afc:	bfcd                	j	80001aee <devintr+0x52>
      virtio_disk_intr();
    80001afe:	1da030ef          	jal	ra,80004cd8 <virtio_disk_intr>
    80001b02:	b7f5                	j	80001aee <devintr+0x52>
    clockintr();
    80001b04:	f45ff0ef          	jal	ra,80001a48 <clockintr>
    return 2;
    80001b08:	4509                	li	a0,2
    80001b0a:	bf5d                	j	80001ac0 <devintr+0x24>

0000000080001b0c <usertrap>:
{
    80001b0c:	1101                	addi	sp,sp,-32
    80001b0e:	ec06                	sd	ra,24(sp)
    80001b10:	e822                	sd	s0,16(sp)
    80001b12:	e426                	sd	s1,8(sp)
    80001b14:	e04a                	sd	s2,0(sp)
    80001b16:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b18:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001b1c:	1007f793          	andi	a5,a5,256
    80001b20:	ef85                	bnez	a5,80001b58 <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b22:	00003797          	auipc	a5,0x3
    80001b26:	c7e78793          	addi	a5,a5,-898 # 800047a0 <kernelvec>
    80001b2a:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001b2e:	af2ff0ef          	jal	ra,80000e20 <myproc>
    80001b32:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001b34:	613c                	ld	a5,64(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b36:	14102773          	csrr	a4,sepc
    80001b3a:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b3c:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001b40:	47a1                	li	a5,8
    80001b42:	02f70163          	beq	a4,a5,80001b64 <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    80001b46:	f57ff0ef          	jal	ra,80001a9c <devintr>
    80001b4a:	892a                	mv	s2,a0
    80001b4c:	c135                	beqz	a0,80001bb0 <usertrap+0xa4>
  if(killed(p))
    80001b4e:	8526                	mv	a0,s1
    80001b50:	b67ff0ef          	jal	ra,800016b6 <killed>
    80001b54:	cd1d                	beqz	a0,80001b92 <usertrap+0x86>
    80001b56:	a81d                	j	80001b8c <usertrap+0x80>
    panic("usertrap: not from user mode");
    80001b58:	00005517          	auipc	a0,0x5
    80001b5c:	7b850513          	addi	a0,a0,1976 # 80007310 <states.0+0x58>
    80001b60:	157030ef          	jal	ra,800054b6 <panic>
    if(killed(p))
    80001b64:	b53ff0ef          	jal	ra,800016b6 <killed>
    80001b68:	e121                	bnez	a0,80001ba8 <usertrap+0x9c>
    p->trapframe->epc += 4;
    80001b6a:	60b8                	ld	a4,64(s1)
    80001b6c:	6f1c                	ld	a5,24(a4)
    80001b6e:	0791                	addi	a5,a5,4
    80001b70:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b72:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001b76:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b7a:	10079073          	csrw	sstatus,a5
    syscall();
    80001b7e:	248000ef          	jal	ra,80001dc6 <syscall>
  if(killed(p))
    80001b82:	8526                	mv	a0,s1
    80001b84:	b33ff0ef          	jal	ra,800016b6 <killed>
    80001b88:	c901                	beqz	a0,80001b98 <usertrap+0x8c>
    80001b8a:	4901                	li	s2,0
    exit(-1);
    80001b8c:	557d                	li	a0,-1
    80001b8e:	9fdff0ef          	jal	ra,8000158a <exit>
  if(which_dev == 2)
    80001b92:	4789                	li	a5,2
    80001b94:	04f90563          	beq	s2,a5,80001bde <usertrap+0xd2>
  usertrapret();
    80001b98:	e1fff0ef          	jal	ra,800019b6 <usertrapret>
}
    80001b9c:	60e2                	ld	ra,24(sp)
    80001b9e:	6442                	ld	s0,16(sp)
    80001ba0:	64a2                	ld	s1,8(sp)
    80001ba2:	6902                	ld	s2,0(sp)
    80001ba4:	6105                	addi	sp,sp,32
    80001ba6:	8082                	ret
      exit(-1);
    80001ba8:	557d                	li	a0,-1
    80001baa:	9e1ff0ef          	jal	ra,8000158a <exit>
    80001bae:	bf75                	j	80001b6a <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001bb0:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001bb4:	5890                	lw	a2,48(s1)
    80001bb6:	00005517          	auipc	a0,0x5
    80001bba:	77a50513          	addi	a0,a0,1914 # 80007330 <states.0+0x78>
    80001bbe:	644030ef          	jal	ra,80005202 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001bc2:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001bc6:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001bca:	00005517          	auipc	a0,0x5
    80001bce:	79650513          	addi	a0,a0,1942 # 80007360 <states.0+0xa8>
    80001bd2:	630030ef          	jal	ra,80005202 <printf>
    setkilled(p);
    80001bd6:	8526                	mv	a0,s1
    80001bd8:	abbff0ef          	jal	ra,80001692 <setkilled>
    80001bdc:	b75d                	j	80001b82 <usertrap+0x76>
    yield();
    80001bde:	875ff0ef          	jal	ra,80001452 <yield>
    80001be2:	bf5d                	j	80001b98 <usertrap+0x8c>

0000000080001be4 <kerneltrap>:
{
    80001be4:	7179                	addi	sp,sp,-48
    80001be6:	f406                	sd	ra,40(sp)
    80001be8:	f022                	sd	s0,32(sp)
    80001bea:	ec26                	sd	s1,24(sp)
    80001bec:	e84a                	sd	s2,16(sp)
    80001bee:	e44e                	sd	s3,8(sp)
    80001bf0:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001bf2:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bf6:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001bfa:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001bfe:	1004f793          	andi	a5,s1,256
    80001c02:	c795                	beqz	a5,80001c2e <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c04:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001c08:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001c0a:	eb85                	bnez	a5,80001c3a <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80001c0c:	e91ff0ef          	jal	ra,80001a9c <devintr>
    80001c10:	c91d                	beqz	a0,80001c46 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80001c12:	4789                	li	a5,2
    80001c14:	04f50a63          	beq	a0,a5,80001c68 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001c18:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c1c:	10049073          	csrw	sstatus,s1
}
    80001c20:	70a2                	ld	ra,40(sp)
    80001c22:	7402                	ld	s0,32(sp)
    80001c24:	64e2                	ld	s1,24(sp)
    80001c26:	6942                	ld	s2,16(sp)
    80001c28:	69a2                	ld	s3,8(sp)
    80001c2a:	6145                	addi	sp,sp,48
    80001c2c:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001c2e:	00005517          	auipc	a0,0x5
    80001c32:	75a50513          	addi	a0,a0,1882 # 80007388 <states.0+0xd0>
    80001c36:	081030ef          	jal	ra,800054b6 <panic>
    panic("kerneltrap: interrupts enabled");
    80001c3a:	00005517          	auipc	a0,0x5
    80001c3e:	77650513          	addi	a0,a0,1910 # 800073b0 <states.0+0xf8>
    80001c42:	075030ef          	jal	ra,800054b6 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001c46:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001c4a:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001c4e:	85ce                	mv	a1,s3
    80001c50:	00005517          	auipc	a0,0x5
    80001c54:	78050513          	addi	a0,a0,1920 # 800073d0 <states.0+0x118>
    80001c58:	5aa030ef          	jal	ra,80005202 <printf>
    panic("kerneltrap");
    80001c5c:	00005517          	auipc	a0,0x5
    80001c60:	79c50513          	addi	a0,a0,1948 # 800073f8 <states.0+0x140>
    80001c64:	053030ef          	jal	ra,800054b6 <panic>
  if(which_dev == 2 && myproc() != 0)
    80001c68:	9b8ff0ef          	jal	ra,80000e20 <myproc>
    80001c6c:	d555                	beqz	a0,80001c18 <kerneltrap+0x34>
    yield();
    80001c6e:	fe4ff0ef          	jal	ra,80001452 <yield>
    80001c72:	b75d                	j	80001c18 <kerneltrap+0x34>

0000000080001c74 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001c74:	1101                	addi	sp,sp,-32
    80001c76:	ec06                	sd	ra,24(sp)
    80001c78:	e822                	sd	s0,16(sp)
    80001c7a:	e426                	sd	s1,8(sp)
    80001c7c:	1000                	addi	s0,sp,32
    80001c7e:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001c80:	9a0ff0ef          	jal	ra,80000e20 <myproc>
  switch (n) {
    80001c84:	4795                	li	a5,5
    80001c86:	0497e163          	bltu	a5,s1,80001cc8 <argraw+0x54>
    80001c8a:	048a                	slli	s1,s1,0x2
    80001c8c:	00005717          	auipc	a4,0x5
    80001c90:	7a470713          	addi	a4,a4,1956 # 80007430 <states.0+0x178>
    80001c94:	94ba                	add	s1,s1,a4
    80001c96:	409c                	lw	a5,0(s1)
    80001c98:	97ba                	add	a5,a5,a4
    80001c9a:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001c9c:	613c                	ld	a5,64(a0)
    80001c9e:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001ca0:	60e2                	ld	ra,24(sp)
    80001ca2:	6442                	ld	s0,16(sp)
    80001ca4:	64a2                	ld	s1,8(sp)
    80001ca6:	6105                	addi	sp,sp,32
    80001ca8:	8082                	ret
    return p->trapframe->a1;
    80001caa:	613c                	ld	a5,64(a0)
    80001cac:	7fa8                	ld	a0,120(a5)
    80001cae:	bfcd                	j	80001ca0 <argraw+0x2c>
    return p->trapframe->a2;
    80001cb0:	613c                	ld	a5,64(a0)
    80001cb2:	63c8                	ld	a0,128(a5)
    80001cb4:	b7f5                	j	80001ca0 <argraw+0x2c>
    return p->trapframe->a3;
    80001cb6:	613c                	ld	a5,64(a0)
    80001cb8:	67c8                	ld	a0,136(a5)
    80001cba:	b7dd                	j	80001ca0 <argraw+0x2c>
    return p->trapframe->a4;
    80001cbc:	613c                	ld	a5,64(a0)
    80001cbe:	6bc8                	ld	a0,144(a5)
    80001cc0:	b7c5                	j	80001ca0 <argraw+0x2c>
    return p->trapframe->a5;
    80001cc2:	613c                	ld	a5,64(a0)
    80001cc4:	6fc8                	ld	a0,152(a5)
    80001cc6:	bfe9                	j	80001ca0 <argraw+0x2c>
  panic("argraw");
    80001cc8:	00005517          	auipc	a0,0x5
    80001ccc:	74050513          	addi	a0,a0,1856 # 80007408 <states.0+0x150>
    80001cd0:	7e6030ef          	jal	ra,800054b6 <panic>

0000000080001cd4 <fetchaddr>:
{
    80001cd4:	1101                	addi	sp,sp,-32
    80001cd6:	ec06                	sd	ra,24(sp)
    80001cd8:	e822                	sd	s0,16(sp)
    80001cda:	e426                	sd	s1,8(sp)
    80001cdc:	e04a                	sd	s2,0(sp)
    80001cde:	1000                	addi	s0,sp,32
    80001ce0:	84aa                	mv	s1,a0
    80001ce2:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001ce4:	93cff0ef          	jal	ra,80000e20 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001ce8:	657c                	ld	a5,200(a0)
    80001cea:	02f4f663          	bgeu	s1,a5,80001d16 <fetchaddr+0x42>
    80001cee:	00848713          	addi	a4,s1,8
    80001cf2:	02e7e463          	bltu	a5,a4,80001d1a <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001cf6:	46a1                	li	a3,8
    80001cf8:	8626                	mv	a2,s1
    80001cfa:	85ca                	mv	a1,s2
    80001cfc:	6968                	ld	a0,208(a0)
    80001cfe:	dc1fe0ef          	jal	ra,80000abe <copyin>
    80001d02:	00a03533          	snez	a0,a0
    80001d06:	40a00533          	neg	a0,a0
}
    80001d0a:	60e2                	ld	ra,24(sp)
    80001d0c:	6442                	ld	s0,16(sp)
    80001d0e:	64a2                	ld	s1,8(sp)
    80001d10:	6902                	ld	s2,0(sp)
    80001d12:	6105                	addi	sp,sp,32
    80001d14:	8082                	ret
    return -1;
    80001d16:	557d                	li	a0,-1
    80001d18:	bfcd                	j	80001d0a <fetchaddr+0x36>
    80001d1a:	557d                	li	a0,-1
    80001d1c:	b7fd                	j	80001d0a <fetchaddr+0x36>

0000000080001d1e <fetchstr>:
{
    80001d1e:	7179                	addi	sp,sp,-48
    80001d20:	f406                	sd	ra,40(sp)
    80001d22:	f022                	sd	s0,32(sp)
    80001d24:	ec26                	sd	s1,24(sp)
    80001d26:	e84a                	sd	s2,16(sp)
    80001d28:	e44e                	sd	s3,8(sp)
    80001d2a:	1800                	addi	s0,sp,48
    80001d2c:	892a                	mv	s2,a0
    80001d2e:	84ae                	mv	s1,a1
    80001d30:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001d32:	8eeff0ef          	jal	ra,80000e20 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001d36:	86ce                	mv	a3,s3
    80001d38:	864a                	mv	a2,s2
    80001d3a:	85a6                	mv	a1,s1
    80001d3c:	6968                	ld	a0,208(a0)
    80001d3e:	e07fe0ef          	jal	ra,80000b44 <copyinstr>
    80001d42:	00054c63          	bltz	a0,80001d5a <fetchstr+0x3c>
  return strlen(buf);
    80001d46:	8526                	mv	a0,s1
    80001d48:	d7cfe0ef          	jal	ra,800002c4 <strlen>
}
    80001d4c:	70a2                	ld	ra,40(sp)
    80001d4e:	7402                	ld	s0,32(sp)
    80001d50:	64e2                	ld	s1,24(sp)
    80001d52:	6942                	ld	s2,16(sp)
    80001d54:	69a2                	ld	s3,8(sp)
    80001d56:	6145                	addi	sp,sp,48
    80001d58:	8082                	ret
    return -1;
    80001d5a:	557d                	li	a0,-1
    80001d5c:	bfc5                	j	80001d4c <fetchstr+0x2e>

0000000080001d5e <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001d5e:	1101                	addi	sp,sp,-32
    80001d60:	ec06                	sd	ra,24(sp)
    80001d62:	e822                	sd	s0,16(sp)
    80001d64:	e426                	sd	s1,8(sp)
    80001d66:	1000                	addi	s0,sp,32
    80001d68:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001d6a:	f0bff0ef          	jal	ra,80001c74 <argraw>
    80001d6e:	c088                	sw	a0,0(s1)
}
    80001d70:	60e2                	ld	ra,24(sp)
    80001d72:	6442                	ld	s0,16(sp)
    80001d74:	64a2                	ld	s1,8(sp)
    80001d76:	6105                	addi	sp,sp,32
    80001d78:	8082                	ret

0000000080001d7a <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001d7a:	1101                	addi	sp,sp,-32
    80001d7c:	ec06                	sd	ra,24(sp)
    80001d7e:	e822                	sd	s0,16(sp)
    80001d80:	e426                	sd	s1,8(sp)
    80001d82:	1000                	addi	s0,sp,32
    80001d84:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001d86:	eefff0ef          	jal	ra,80001c74 <argraw>
    80001d8a:	e088                	sd	a0,0(s1)
}
    80001d8c:	60e2                	ld	ra,24(sp)
    80001d8e:	6442                	ld	s0,16(sp)
    80001d90:	64a2                	ld	s1,8(sp)
    80001d92:	6105                	addi	sp,sp,32
    80001d94:	8082                	ret

0000000080001d96 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001d96:	7179                	addi	sp,sp,-48
    80001d98:	f406                	sd	ra,40(sp)
    80001d9a:	f022                	sd	s0,32(sp)
    80001d9c:	ec26                	sd	s1,24(sp)
    80001d9e:	e84a                	sd	s2,16(sp)
    80001da0:	1800                	addi	s0,sp,48
    80001da2:	84ae                	mv	s1,a1
    80001da4:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80001da6:	fd840593          	addi	a1,s0,-40
    80001daa:	fd1ff0ef          	jal	ra,80001d7a <argaddr>
  return fetchstr(addr, buf, max);
    80001dae:	864a                	mv	a2,s2
    80001db0:	85a6                	mv	a1,s1
    80001db2:	fd843503          	ld	a0,-40(s0)
    80001db6:	f69ff0ef          	jal	ra,80001d1e <fetchstr>
}
    80001dba:	70a2                	ld	ra,40(sp)
    80001dbc:	7402                	ld	s0,32(sp)
    80001dbe:	64e2                	ld	s1,24(sp)
    80001dc0:	6942                	ld	s2,16(sp)
    80001dc2:	6145                	addi	sp,sp,48
    80001dc4:	8082                	ret

0000000080001dc6 <syscall>:
[SYS_pgaccess] sys_pgaccess,
};

void
syscall(void)
{
    80001dc6:	1101                	addi	sp,sp,-32
    80001dc8:	ec06                	sd	ra,24(sp)
    80001dca:	e822                	sd	s0,16(sp)
    80001dcc:	e426                	sd	s1,8(sp)
    80001dce:	e04a                	sd	s2,0(sp)
    80001dd0:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001dd2:	84eff0ef          	jal	ra,80000e20 <myproc>
    80001dd6:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001dd8:	04053903          	ld	s2,64(a0)
    80001ddc:	0a893783          	ld	a5,168(s2)
    80001de0:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001de4:	37fd                	addiw	a5,a5,-1
    80001de6:	4755                	li	a4,21
    80001de8:	00f76f63          	bltu	a4,a5,80001e06 <syscall+0x40>
    80001dec:	00369713          	slli	a4,a3,0x3
    80001df0:	00005797          	auipc	a5,0x5
    80001df4:	65878793          	addi	a5,a5,1624 # 80007448 <syscalls>
    80001df8:	97ba                	add	a5,a5,a4
    80001dfa:	639c                	ld	a5,0(a5)
    80001dfc:	c789                	beqz	a5,80001e06 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80001dfe:	9782                	jalr	a5
    80001e00:	06a93823          	sd	a0,112(s2)
    80001e04:	a829                	j	80001e1e <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001e06:	16048613          	addi	a2,s1,352
    80001e0a:	588c                	lw	a1,48(s1)
    80001e0c:	00005517          	auipc	a0,0x5
    80001e10:	60450513          	addi	a0,a0,1540 # 80007410 <states.0+0x158>
    80001e14:	3ee030ef          	jal	ra,80005202 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001e18:	60bc                	ld	a5,64(s1)
    80001e1a:	577d                	li	a4,-1
    80001e1c:	fbb8                	sd	a4,112(a5)
  }
}
    80001e1e:	60e2                	ld	ra,24(sp)
    80001e20:	6442                	ld	s0,16(sp)
    80001e22:	64a2                	ld	s1,8(sp)
    80001e24:	6902                	ld	s2,0(sp)
    80001e26:	6105                	addi	sp,sp,32
    80001e28:	8082                	ret

0000000080001e2a <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80001e2a:	1101                	addi	sp,sp,-32
    80001e2c:	ec06                	sd	ra,24(sp)
    80001e2e:	e822                	sd	s0,16(sp)
    80001e30:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80001e32:	fec40593          	addi	a1,s0,-20
    80001e36:	4501                	li	a0,0
    80001e38:	f27ff0ef          	jal	ra,80001d5e <argint>
  exit(n);
    80001e3c:	fec42503          	lw	a0,-20(s0)
    80001e40:	f4aff0ef          	jal	ra,8000158a <exit>
  return 0;  // not reached
}
    80001e44:	4501                	li	a0,0
    80001e46:	60e2                	ld	ra,24(sp)
    80001e48:	6442                	ld	s0,16(sp)
    80001e4a:	6105                	addi	sp,sp,32
    80001e4c:	8082                	ret

0000000080001e4e <sys_getpid>:

uint64
sys_getpid(void)
{
    80001e4e:	1141                	addi	sp,sp,-16
    80001e50:	e406                	sd	ra,8(sp)
    80001e52:	e022                	sd	s0,0(sp)
    80001e54:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80001e56:	fcbfe0ef          	jal	ra,80000e20 <myproc>
}
    80001e5a:	5908                	lw	a0,48(a0)
    80001e5c:	60a2                	ld	ra,8(sp)
    80001e5e:	6402                	ld	s0,0(sp)
    80001e60:	0141                	addi	sp,sp,16
    80001e62:	8082                	ret

0000000080001e64 <sys_fork>:

uint64
sys_fork(void)
{
    80001e64:	1141                	addi	sp,sp,-16
    80001e66:	e406                	sd	ra,8(sp)
    80001e68:	e022                	sd	s0,0(sp)
    80001e6a:	0800                	addi	s0,sp,16
  return fork();
    80001e6c:	b62ff0ef          	jal	ra,800011ce <fork>
}
    80001e70:	60a2                	ld	ra,8(sp)
    80001e72:	6402                	ld	s0,0(sp)
    80001e74:	0141                	addi	sp,sp,16
    80001e76:	8082                	ret

0000000080001e78 <sys_wait>:

uint64
sys_wait(void)
{
    80001e78:	1101                	addi	sp,sp,-32
    80001e7a:	ec06                	sd	ra,24(sp)
    80001e7c:	e822                	sd	s0,16(sp)
    80001e7e:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80001e80:	fe840593          	addi	a1,s0,-24
    80001e84:	4501                	li	a0,0
    80001e86:	ef5ff0ef          	jal	ra,80001d7a <argaddr>
  return wait(p);
    80001e8a:	fe843503          	ld	a0,-24(s0)
    80001e8e:	853ff0ef          	jal	ra,800016e0 <wait>
}
    80001e92:	60e2                	ld	ra,24(sp)
    80001e94:	6442                	ld	s0,16(sp)
    80001e96:	6105                	addi	sp,sp,32
    80001e98:	8082                	ret

0000000080001e9a <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80001e9a:	7179                	addi	sp,sp,-48
    80001e9c:	f406                	sd	ra,40(sp)
    80001e9e:	f022                	sd	s0,32(sp)
    80001ea0:	ec26                	sd	s1,24(sp)
    80001ea2:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80001ea4:	fdc40593          	addi	a1,s0,-36
    80001ea8:	4501                	li	a0,0
    80001eaa:	eb5ff0ef          	jal	ra,80001d5e <argint>
  addr = myproc()->sz;
    80001eae:	f73fe0ef          	jal	ra,80000e20 <myproc>
    80001eb2:	6564                	ld	s1,200(a0)
  if(growproc(n) < 0)
    80001eb4:	fdc42503          	lw	a0,-36(s0)
    80001eb8:	ac6ff0ef          	jal	ra,8000117e <growproc>
    80001ebc:	00054863          	bltz	a0,80001ecc <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80001ec0:	8526                	mv	a0,s1
    80001ec2:	70a2                	ld	ra,40(sp)
    80001ec4:	7402                	ld	s0,32(sp)
    80001ec6:	64e2                	ld	s1,24(sp)
    80001ec8:	6145                	addi	sp,sp,48
    80001eca:	8082                	ret
    return -1;
    80001ecc:	54fd                	li	s1,-1
    80001ece:	bfcd                	j	80001ec0 <sys_sbrk+0x26>

0000000080001ed0 <sys_sleep>:

uint64
sys_sleep(void)
{
    80001ed0:	7139                	addi	sp,sp,-64
    80001ed2:	fc06                	sd	ra,56(sp)
    80001ed4:	f822                	sd	s0,48(sp)
    80001ed6:	f426                	sd	s1,40(sp)
    80001ed8:	f04a                	sd	s2,32(sp)
    80001eda:	ec4e                	sd	s3,24(sp)
    80001edc:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80001ede:	fcc40593          	addi	a1,s0,-52
    80001ee2:	4501                	li	a0,0
    80001ee4:	e7bff0ef          	jal	ra,80001d5e <argint>
  if(n < 0)
    80001ee8:	fcc42783          	lw	a5,-52(s0)
    80001eec:	0607c563          	bltz	a5,80001f56 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80001ef0:	0000c517          	auipc	a0,0xc
    80001ef4:	aa050513          	addi	a0,a0,-1376 # 8000d990 <tickslock>
    80001ef8:	0d3030ef          	jal	ra,800057ca <acquire>
  ticks0 = ticks;
    80001efc:	00006917          	auipc	s2,0x6
    80001f00:	a2c92903          	lw	s2,-1492(s2) # 80007928 <ticks>
  while(ticks - ticks0 < n){
    80001f04:	fcc42783          	lw	a5,-52(s0)
    80001f08:	cb8d                	beqz	a5,80001f3a <sys_sleep+0x6a>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80001f0a:	0000c997          	auipc	s3,0xc
    80001f0e:	a8698993          	addi	s3,s3,-1402 # 8000d990 <tickslock>
    80001f12:	00006497          	auipc	s1,0x6
    80001f16:	a1648493          	addi	s1,s1,-1514 # 80007928 <ticks>
    if(killed(myproc())){
    80001f1a:	f07fe0ef          	jal	ra,80000e20 <myproc>
    80001f1e:	f98ff0ef          	jal	ra,800016b6 <killed>
    80001f22:	ed0d                	bnez	a0,80001f5c <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80001f24:	85ce                	mv	a1,s3
    80001f26:	8526                	mv	a0,s1
    80001f28:	d56ff0ef          	jal	ra,8000147e <sleep>
  while(ticks - ticks0 < n){
    80001f2c:	409c                	lw	a5,0(s1)
    80001f2e:	412787bb          	subw	a5,a5,s2
    80001f32:	fcc42703          	lw	a4,-52(s0)
    80001f36:	fee7e2e3          	bltu	a5,a4,80001f1a <sys_sleep+0x4a>
  }
  release(&tickslock);
    80001f3a:	0000c517          	auipc	a0,0xc
    80001f3e:	a5650513          	addi	a0,a0,-1450 # 8000d990 <tickslock>
    80001f42:	121030ef          	jal	ra,80005862 <release>
  return 0;
    80001f46:	4501                	li	a0,0
}
    80001f48:	70e2                	ld	ra,56(sp)
    80001f4a:	7442                	ld	s0,48(sp)
    80001f4c:	74a2                	ld	s1,40(sp)
    80001f4e:	7902                	ld	s2,32(sp)
    80001f50:	69e2                	ld	s3,24(sp)
    80001f52:	6121                	addi	sp,sp,64
    80001f54:	8082                	ret
    n = 0;
    80001f56:	fc042623          	sw	zero,-52(s0)
    80001f5a:	bf59                	j	80001ef0 <sys_sleep+0x20>
      release(&tickslock);
    80001f5c:	0000c517          	auipc	a0,0xc
    80001f60:	a3450513          	addi	a0,a0,-1484 # 8000d990 <tickslock>
    80001f64:	0ff030ef          	jal	ra,80005862 <release>
      return -1;
    80001f68:	557d                	li	a0,-1
    80001f6a:	bff9                	j	80001f48 <sys_sleep+0x78>

0000000080001f6c <sys_kill>:

uint64
sys_kill(void)
{
    80001f6c:	1101                	addi	sp,sp,-32
    80001f6e:	ec06                	sd	ra,24(sp)
    80001f70:	e822                	sd	s0,16(sp)
    80001f72:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80001f74:	fec40593          	addi	a1,s0,-20
    80001f78:	4501                	li	a0,0
    80001f7a:	de5ff0ef          	jal	ra,80001d5e <argint>
  return kill(pid);
    80001f7e:	fec42503          	lw	a0,-20(s0)
    80001f82:	eaaff0ef          	jal	ra,8000162c <kill>
}
    80001f86:	60e2                	ld	ra,24(sp)
    80001f88:	6442                	ld	s0,16(sp)
    80001f8a:	6105                	addi	sp,sp,32
    80001f8c:	8082                	ret

0000000080001f8e <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80001f8e:	1101                	addi	sp,sp,-32
    80001f90:	ec06                	sd	ra,24(sp)
    80001f92:	e822                	sd	s0,16(sp)
    80001f94:	e426                	sd	s1,8(sp)
    80001f96:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80001f98:	0000c517          	auipc	a0,0xc
    80001f9c:	9f850513          	addi	a0,a0,-1544 # 8000d990 <tickslock>
    80001fa0:	02b030ef          	jal	ra,800057ca <acquire>
  xticks = ticks;
    80001fa4:	00006497          	auipc	s1,0x6
    80001fa8:	9844a483          	lw	s1,-1660(s1) # 80007928 <ticks>
  release(&tickslock);
    80001fac:	0000c517          	auipc	a0,0xc
    80001fb0:	9e450513          	addi	a0,a0,-1564 # 8000d990 <tickslock>
    80001fb4:	0af030ef          	jal	ra,80005862 <release>
  return xticks;
}
    80001fb8:	02049513          	slli	a0,s1,0x20
    80001fbc:	9101                	srli	a0,a0,0x20
    80001fbe:	60e2                	ld	ra,24(sp)
    80001fc0:	6442                	ld	s0,16(sp)
    80001fc2:	64a2                	ld	s1,8(sp)
    80001fc4:	6105                	addi	sp,sp,32
    80001fc6:	8082                	ret

0000000080001fc8 <sys_pgaccess>:
uint64
sys_pgaccess(void)
{
    80001fc8:	711d                	addi	sp,sp,-96
    80001fca:	ec86                	sd	ra,88(sp)
    80001fcc:	e8a2                	sd	s0,80(sp)
    80001fce:	e4a6                	sd	s1,72(sp)
    80001fd0:	e0ca                	sd	s2,64(sp)
    80001fd2:	fc4e                	sd	s3,56(sp)
    80001fd4:	f852                	sd	s4,48(sp)
    80001fd6:	f456                	sd	s5,40(sp)
    80001fd8:	1080                	addi	s0,sp,96
    uint64 va;
    int npages;
    uint64 addr;

    struct proc *p = myproc();
    80001fda:	e47fe0ef          	jal	ra,80000e20 <myproc>
    80001fde:	89aa                	mv	s3,a0
    argaddr(0, &va);
    80001fe0:	fb840593          	addi	a1,s0,-72
    80001fe4:	4501                	li	a0,0
    80001fe6:	d95ff0ef          	jal	ra,80001d7a <argaddr>
    argint(1, &npages);
    80001fea:	fb440593          	addi	a1,s0,-76
    80001fee:	4505                	li	a0,1
    80001ff0:	d6fff0ef          	jal	ra,80001d5e <argint>
    argaddr(2, &addr);
    80001ff4:	fa840593          	addi	a1,s0,-88
    80001ff8:	4509                	li	a0,2
    80001ffa:	d81ff0ef          	jal	ra,80001d7a <argaddr>

    unsigned int mask = 0;
    80001ffe:	fa042223          	sw	zero,-92(s0)

    for(int i = 0; i < npages; i++){
    80002002:	fb442783          	lw	a5,-76(s0)
    80002006:	04f05d63          	blez	a5,80002060 <sys_pgaccess+0x98>
    8000200a:	4481                	li	s1,0
        pte_t *pte = walk(p->pagetable, va + i * PGSIZE, 0);

        if(pte && (*pte & PTE_V) && (*pte & PTE_A)){
    8000200c:	04100a13          	li	s4,65
            mask |= (1 << i);
    80002010:	4a85                	li	s5,1
    80002012:	a801                	j	80002022 <sys_pgaccess+0x5a>
    for(int i = 0; i < npages; i++){
    80002014:	0485                	addi	s1,s1,1
    80002016:	fb442703          	lw	a4,-76(s0)
    8000201a:	0004879b          	sext.w	a5,s1
    8000201e:	04e7d163          	bge	a5,a4,80002060 <sys_pgaccess+0x98>
    80002022:	0004891b          	sext.w	s2,s1
        pte_t *pte = walk(p->pagetable, va + i * PGSIZE, 0);
    80002026:	00c49793          	slli	a5,s1,0xc
    8000202a:	4601                	li	a2,0
    8000202c:	fb843583          	ld	a1,-72(s0)
    80002030:	95be                	add	a1,a1,a5
    80002032:	0d09b503          	ld	a0,208(s3)
    80002036:	b92fe0ef          	jal	ra,800003c8 <walk>
        if(pte && (*pte & PTE_V) && (*pte & PTE_A)){
    8000203a:	dd69                	beqz	a0,80002014 <sys_pgaccess+0x4c>
    8000203c:	611c                	ld	a5,0(a0)
    8000203e:	0417f793          	andi	a5,a5,65
    80002042:	fd4799e3          	bne	a5,s4,80002014 <sys_pgaccess+0x4c>
            mask |= (1 << i);
    80002046:	012a993b          	sllw	s2,s5,s2
    8000204a:	fa442783          	lw	a5,-92(s0)
    8000204e:	00f96933          	or	s2,s2,a5
    80002052:	fb242223          	sw	s2,-92(s0)
            *pte &= ~PTE_A;   
    80002056:	611c                	ld	a5,0(a0)
    80002058:	fbf7f793          	andi	a5,a5,-65
    8000205c:	e11c                	sd	a5,0(a0)
    8000205e:	bf5d                	j	80002014 <sys_pgaccess+0x4c>
        }
    }

    if(copyout(p->pagetable, addr, (char*)&mask, sizeof(mask)) < 0)
    80002060:	4691                	li	a3,4
    80002062:	fa440613          	addi	a2,s0,-92
    80002066:	fa843583          	ld	a1,-88(s0)
    8000206a:	0d09b503          	ld	a0,208(s3)
    8000206e:	999fe0ef          	jal	ra,80000a06 <copyout>
        return -1;

    return 0;
}
    80002072:	957d                	srai	a0,a0,0x3f
    80002074:	60e6                	ld	ra,88(sp)
    80002076:	6446                	ld	s0,80(sp)
    80002078:	64a6                	ld	s1,72(sp)
    8000207a:	6906                	ld	s2,64(sp)
    8000207c:	79e2                	ld	s3,56(sp)
    8000207e:	7a42                	ld	s4,48(sp)
    80002080:	7aa2                	ld	s5,40(sp)
    80002082:	6125                	addi	sp,sp,96
    80002084:	8082                	ret

0000000080002086 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002086:	7179                	addi	sp,sp,-48
    80002088:	f406                	sd	ra,40(sp)
    8000208a:	f022                	sd	s0,32(sp)
    8000208c:	ec26                	sd	s1,24(sp)
    8000208e:	e84a                	sd	s2,16(sp)
    80002090:	e44e                	sd	s3,8(sp)
    80002092:	e052                	sd	s4,0(sp)
    80002094:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002096:	00005597          	auipc	a1,0x5
    8000209a:	46a58593          	addi	a1,a1,1130 # 80007500 <syscalls+0xb8>
    8000209e:	0000c517          	auipc	a0,0xc
    800020a2:	90a50513          	addi	a0,a0,-1782 # 8000d9a8 <bcache>
    800020a6:	6a4030ef          	jal	ra,8000574a <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800020aa:	00014797          	auipc	a5,0x14
    800020ae:	8fe78793          	addi	a5,a5,-1794 # 800159a8 <bcache+0x8000>
    800020b2:	00014717          	auipc	a4,0x14
    800020b6:	b5e70713          	addi	a4,a4,-1186 # 80015c10 <bcache+0x8268>
    800020ba:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800020be:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800020c2:	0000c497          	auipc	s1,0xc
    800020c6:	8fe48493          	addi	s1,s1,-1794 # 8000d9c0 <bcache+0x18>
    b->next = bcache.head.next;
    800020ca:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800020cc:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800020ce:	00005a17          	auipc	s4,0x5
    800020d2:	43aa0a13          	addi	s4,s4,1082 # 80007508 <syscalls+0xc0>
    b->next = bcache.head.next;
    800020d6:	2b893783          	ld	a5,696(s2)
    800020da:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800020dc:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800020e0:	85d2                	mv	a1,s4
    800020e2:	01048513          	addi	a0,s1,16
    800020e6:	224010ef          	jal	ra,8000330a <initsleeplock>
    bcache.head.next->prev = b;
    800020ea:	2b893783          	ld	a5,696(s2)
    800020ee:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800020f0:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800020f4:	45848493          	addi	s1,s1,1112
    800020f8:	fd349fe3          	bne	s1,s3,800020d6 <binit+0x50>
  }
}
    800020fc:	70a2                	ld	ra,40(sp)
    800020fe:	7402                	ld	s0,32(sp)
    80002100:	64e2                	ld	s1,24(sp)
    80002102:	6942                	ld	s2,16(sp)
    80002104:	69a2                	ld	s3,8(sp)
    80002106:	6a02                	ld	s4,0(sp)
    80002108:	6145                	addi	sp,sp,48
    8000210a:	8082                	ret

000000008000210c <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000210c:	7179                	addi	sp,sp,-48
    8000210e:	f406                	sd	ra,40(sp)
    80002110:	f022                	sd	s0,32(sp)
    80002112:	ec26                	sd	s1,24(sp)
    80002114:	e84a                	sd	s2,16(sp)
    80002116:	e44e                	sd	s3,8(sp)
    80002118:	1800                	addi	s0,sp,48
    8000211a:	892a                	mv	s2,a0
    8000211c:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000211e:	0000c517          	auipc	a0,0xc
    80002122:	88a50513          	addi	a0,a0,-1910 # 8000d9a8 <bcache>
    80002126:	6a4030ef          	jal	ra,800057ca <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000212a:	00014497          	auipc	s1,0x14
    8000212e:	b364b483          	ld	s1,-1226(s1) # 80015c60 <bcache+0x82b8>
    80002132:	00014797          	auipc	a5,0x14
    80002136:	ade78793          	addi	a5,a5,-1314 # 80015c10 <bcache+0x8268>
    8000213a:	02f48b63          	beq	s1,a5,80002170 <bread+0x64>
    8000213e:	873e                	mv	a4,a5
    80002140:	a021                	j	80002148 <bread+0x3c>
    80002142:	68a4                	ld	s1,80(s1)
    80002144:	02e48663          	beq	s1,a4,80002170 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002148:	449c                	lw	a5,8(s1)
    8000214a:	ff279ce3          	bne	a5,s2,80002142 <bread+0x36>
    8000214e:	44dc                	lw	a5,12(s1)
    80002150:	ff3799e3          	bne	a5,s3,80002142 <bread+0x36>
      b->refcnt++;
    80002154:	40bc                	lw	a5,64(s1)
    80002156:	2785                	addiw	a5,a5,1
    80002158:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000215a:	0000c517          	auipc	a0,0xc
    8000215e:	84e50513          	addi	a0,a0,-1970 # 8000d9a8 <bcache>
    80002162:	700030ef          	jal	ra,80005862 <release>
      acquiresleep(&b->lock);
    80002166:	01048513          	addi	a0,s1,16
    8000216a:	1d6010ef          	jal	ra,80003340 <acquiresleep>
      return b;
    8000216e:	a889                	j	800021c0 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002170:	00014497          	auipc	s1,0x14
    80002174:	ae84b483          	ld	s1,-1304(s1) # 80015c58 <bcache+0x82b0>
    80002178:	00014797          	auipc	a5,0x14
    8000217c:	a9878793          	addi	a5,a5,-1384 # 80015c10 <bcache+0x8268>
    80002180:	00f48863          	beq	s1,a5,80002190 <bread+0x84>
    80002184:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002186:	40bc                	lw	a5,64(s1)
    80002188:	cb91                	beqz	a5,8000219c <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000218a:	64a4                	ld	s1,72(s1)
    8000218c:	fee49de3          	bne	s1,a4,80002186 <bread+0x7a>
  panic("bget: no buffers");
    80002190:	00005517          	auipc	a0,0x5
    80002194:	38050513          	addi	a0,a0,896 # 80007510 <syscalls+0xc8>
    80002198:	31e030ef          	jal	ra,800054b6 <panic>
      b->dev = dev;
    8000219c:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800021a0:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800021a4:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800021a8:	4785                	li	a5,1
    800021aa:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800021ac:	0000b517          	auipc	a0,0xb
    800021b0:	7fc50513          	addi	a0,a0,2044 # 8000d9a8 <bcache>
    800021b4:	6ae030ef          	jal	ra,80005862 <release>
      acquiresleep(&b->lock);
    800021b8:	01048513          	addi	a0,s1,16
    800021bc:	184010ef          	jal	ra,80003340 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800021c0:	409c                	lw	a5,0(s1)
    800021c2:	cb89                	beqz	a5,800021d4 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800021c4:	8526                	mv	a0,s1
    800021c6:	70a2                	ld	ra,40(sp)
    800021c8:	7402                	ld	s0,32(sp)
    800021ca:	64e2                	ld	s1,24(sp)
    800021cc:	6942                	ld	s2,16(sp)
    800021ce:	69a2                	ld	s3,8(sp)
    800021d0:	6145                	addi	sp,sp,48
    800021d2:	8082                	ret
    virtio_disk_rw(b, 0);
    800021d4:	4581                	li	a1,0
    800021d6:	8526                	mv	a0,s1
    800021d8:	0e5020ef          	jal	ra,80004abc <virtio_disk_rw>
    b->valid = 1;
    800021dc:	4785                	li	a5,1
    800021de:	c09c                	sw	a5,0(s1)
  return b;
    800021e0:	b7d5                	j	800021c4 <bread+0xb8>

00000000800021e2 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800021e2:	1101                	addi	sp,sp,-32
    800021e4:	ec06                	sd	ra,24(sp)
    800021e6:	e822                	sd	s0,16(sp)
    800021e8:	e426                	sd	s1,8(sp)
    800021ea:	1000                	addi	s0,sp,32
    800021ec:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800021ee:	0541                	addi	a0,a0,16
    800021f0:	1ce010ef          	jal	ra,800033be <holdingsleep>
    800021f4:	c911                	beqz	a0,80002208 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800021f6:	4585                	li	a1,1
    800021f8:	8526                	mv	a0,s1
    800021fa:	0c3020ef          	jal	ra,80004abc <virtio_disk_rw>
}
    800021fe:	60e2                	ld	ra,24(sp)
    80002200:	6442                	ld	s0,16(sp)
    80002202:	64a2                	ld	s1,8(sp)
    80002204:	6105                	addi	sp,sp,32
    80002206:	8082                	ret
    panic("bwrite");
    80002208:	00005517          	auipc	a0,0x5
    8000220c:	32050513          	addi	a0,a0,800 # 80007528 <syscalls+0xe0>
    80002210:	2a6030ef          	jal	ra,800054b6 <panic>

0000000080002214 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002214:	1101                	addi	sp,sp,-32
    80002216:	ec06                	sd	ra,24(sp)
    80002218:	e822                	sd	s0,16(sp)
    8000221a:	e426                	sd	s1,8(sp)
    8000221c:	e04a                	sd	s2,0(sp)
    8000221e:	1000                	addi	s0,sp,32
    80002220:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002222:	01050913          	addi	s2,a0,16
    80002226:	854a                	mv	a0,s2
    80002228:	196010ef          	jal	ra,800033be <holdingsleep>
    8000222c:	c13d                	beqz	a0,80002292 <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
    8000222e:	854a                	mv	a0,s2
    80002230:	156010ef          	jal	ra,80003386 <releasesleep>

  acquire(&bcache.lock);
    80002234:	0000b517          	auipc	a0,0xb
    80002238:	77450513          	addi	a0,a0,1908 # 8000d9a8 <bcache>
    8000223c:	58e030ef          	jal	ra,800057ca <acquire>
  b->refcnt--;
    80002240:	40bc                	lw	a5,64(s1)
    80002242:	37fd                	addiw	a5,a5,-1
    80002244:	0007871b          	sext.w	a4,a5
    80002248:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000224a:	eb05                	bnez	a4,8000227a <brelse+0x66>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000224c:	68bc                	ld	a5,80(s1)
    8000224e:	64b8                	ld	a4,72(s1)
    80002250:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002252:	64bc                	ld	a5,72(s1)
    80002254:	68b8                	ld	a4,80(s1)
    80002256:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002258:	00013797          	auipc	a5,0x13
    8000225c:	75078793          	addi	a5,a5,1872 # 800159a8 <bcache+0x8000>
    80002260:	2b87b703          	ld	a4,696(a5)
    80002264:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002266:	00014717          	auipc	a4,0x14
    8000226a:	9aa70713          	addi	a4,a4,-1622 # 80015c10 <bcache+0x8268>
    8000226e:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002270:	2b87b703          	ld	a4,696(a5)
    80002274:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002276:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000227a:	0000b517          	auipc	a0,0xb
    8000227e:	72e50513          	addi	a0,a0,1838 # 8000d9a8 <bcache>
    80002282:	5e0030ef          	jal	ra,80005862 <release>
}
    80002286:	60e2                	ld	ra,24(sp)
    80002288:	6442                	ld	s0,16(sp)
    8000228a:	64a2                	ld	s1,8(sp)
    8000228c:	6902                	ld	s2,0(sp)
    8000228e:	6105                	addi	sp,sp,32
    80002290:	8082                	ret
    panic("brelse");
    80002292:	00005517          	auipc	a0,0x5
    80002296:	29e50513          	addi	a0,a0,670 # 80007530 <syscalls+0xe8>
    8000229a:	21c030ef          	jal	ra,800054b6 <panic>

000000008000229e <bpin>:

void
bpin(struct buf *b) {
    8000229e:	1101                	addi	sp,sp,-32
    800022a0:	ec06                	sd	ra,24(sp)
    800022a2:	e822                	sd	s0,16(sp)
    800022a4:	e426                	sd	s1,8(sp)
    800022a6:	1000                	addi	s0,sp,32
    800022a8:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800022aa:	0000b517          	auipc	a0,0xb
    800022ae:	6fe50513          	addi	a0,a0,1790 # 8000d9a8 <bcache>
    800022b2:	518030ef          	jal	ra,800057ca <acquire>
  b->refcnt++;
    800022b6:	40bc                	lw	a5,64(s1)
    800022b8:	2785                	addiw	a5,a5,1
    800022ba:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800022bc:	0000b517          	auipc	a0,0xb
    800022c0:	6ec50513          	addi	a0,a0,1772 # 8000d9a8 <bcache>
    800022c4:	59e030ef          	jal	ra,80005862 <release>
}
    800022c8:	60e2                	ld	ra,24(sp)
    800022ca:	6442                	ld	s0,16(sp)
    800022cc:	64a2                	ld	s1,8(sp)
    800022ce:	6105                	addi	sp,sp,32
    800022d0:	8082                	ret

00000000800022d2 <bunpin>:

void
bunpin(struct buf *b) {
    800022d2:	1101                	addi	sp,sp,-32
    800022d4:	ec06                	sd	ra,24(sp)
    800022d6:	e822                	sd	s0,16(sp)
    800022d8:	e426                	sd	s1,8(sp)
    800022da:	1000                	addi	s0,sp,32
    800022dc:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800022de:	0000b517          	auipc	a0,0xb
    800022e2:	6ca50513          	addi	a0,a0,1738 # 8000d9a8 <bcache>
    800022e6:	4e4030ef          	jal	ra,800057ca <acquire>
  b->refcnt--;
    800022ea:	40bc                	lw	a5,64(s1)
    800022ec:	37fd                	addiw	a5,a5,-1
    800022ee:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800022f0:	0000b517          	auipc	a0,0xb
    800022f4:	6b850513          	addi	a0,a0,1720 # 8000d9a8 <bcache>
    800022f8:	56a030ef          	jal	ra,80005862 <release>
}
    800022fc:	60e2                	ld	ra,24(sp)
    800022fe:	6442                	ld	s0,16(sp)
    80002300:	64a2                	ld	s1,8(sp)
    80002302:	6105                	addi	sp,sp,32
    80002304:	8082                	ret

0000000080002306 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002306:	1101                	addi	sp,sp,-32
    80002308:	ec06                	sd	ra,24(sp)
    8000230a:	e822                	sd	s0,16(sp)
    8000230c:	e426                	sd	s1,8(sp)
    8000230e:	e04a                	sd	s2,0(sp)
    80002310:	1000                	addi	s0,sp,32
    80002312:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002314:	00d5d59b          	srliw	a1,a1,0xd
    80002318:	00014797          	auipc	a5,0x14
    8000231c:	d6c7a783          	lw	a5,-660(a5) # 80016084 <sb+0x1c>
    80002320:	9dbd                	addw	a1,a1,a5
    80002322:	debff0ef          	jal	ra,8000210c <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002326:	0074f713          	andi	a4,s1,7
    8000232a:	4785                	li	a5,1
    8000232c:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002330:	14ce                	slli	s1,s1,0x33
    80002332:	90d9                	srli	s1,s1,0x36
    80002334:	00950733          	add	a4,a0,s1
    80002338:	05874703          	lbu	a4,88(a4)
    8000233c:	00e7f6b3          	and	a3,a5,a4
    80002340:	c29d                	beqz	a3,80002366 <bfree+0x60>
    80002342:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002344:	94aa                	add	s1,s1,a0
    80002346:	fff7c793          	not	a5,a5
    8000234a:	8ff9                	and	a5,a5,a4
    8000234c:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002350:	6e9000ef          	jal	ra,80003238 <log_write>
  brelse(bp);
    80002354:	854a                	mv	a0,s2
    80002356:	ebfff0ef          	jal	ra,80002214 <brelse>
}
    8000235a:	60e2                	ld	ra,24(sp)
    8000235c:	6442                	ld	s0,16(sp)
    8000235e:	64a2                	ld	s1,8(sp)
    80002360:	6902                	ld	s2,0(sp)
    80002362:	6105                	addi	sp,sp,32
    80002364:	8082                	ret
    panic("freeing free block");
    80002366:	00005517          	auipc	a0,0x5
    8000236a:	1d250513          	addi	a0,a0,466 # 80007538 <syscalls+0xf0>
    8000236e:	148030ef          	jal	ra,800054b6 <panic>

0000000080002372 <balloc>:
{
    80002372:	711d                	addi	sp,sp,-96
    80002374:	ec86                	sd	ra,88(sp)
    80002376:	e8a2                	sd	s0,80(sp)
    80002378:	e4a6                	sd	s1,72(sp)
    8000237a:	e0ca                	sd	s2,64(sp)
    8000237c:	fc4e                	sd	s3,56(sp)
    8000237e:	f852                	sd	s4,48(sp)
    80002380:	f456                	sd	s5,40(sp)
    80002382:	f05a                	sd	s6,32(sp)
    80002384:	ec5e                	sd	s7,24(sp)
    80002386:	e862                	sd	s8,16(sp)
    80002388:	e466                	sd	s9,8(sp)
    8000238a:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000238c:	00014797          	auipc	a5,0x14
    80002390:	ce07a783          	lw	a5,-800(a5) # 8001606c <sb+0x4>
    80002394:	0e078163          	beqz	a5,80002476 <balloc+0x104>
    80002398:	8baa                	mv	s7,a0
    8000239a:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000239c:	00014b17          	auipc	s6,0x14
    800023a0:	cccb0b13          	addi	s6,s6,-820 # 80016068 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800023a4:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800023a6:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800023a8:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800023aa:	6c89                	lui	s9,0x2
    800023ac:	a0b5                	j	80002418 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    800023ae:	974a                	add	a4,a4,s2
    800023b0:	8fd5                	or	a5,a5,a3
    800023b2:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800023b6:	854a                	mv	a0,s2
    800023b8:	681000ef          	jal	ra,80003238 <log_write>
        brelse(bp);
    800023bc:	854a                	mv	a0,s2
    800023be:	e57ff0ef          	jal	ra,80002214 <brelse>
  bp = bread(dev, bno);
    800023c2:	85a6                	mv	a1,s1
    800023c4:	855e                	mv	a0,s7
    800023c6:	d47ff0ef          	jal	ra,8000210c <bread>
    800023ca:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800023cc:	40000613          	li	a2,1024
    800023d0:	4581                	li	a1,0
    800023d2:	05850513          	addi	a0,a0,88
    800023d6:	d77fd0ef          	jal	ra,8000014c <memset>
  log_write(bp);
    800023da:	854a                	mv	a0,s2
    800023dc:	65d000ef          	jal	ra,80003238 <log_write>
  brelse(bp);
    800023e0:	854a                	mv	a0,s2
    800023e2:	e33ff0ef          	jal	ra,80002214 <brelse>
}
    800023e6:	8526                	mv	a0,s1
    800023e8:	60e6                	ld	ra,88(sp)
    800023ea:	6446                	ld	s0,80(sp)
    800023ec:	64a6                	ld	s1,72(sp)
    800023ee:	6906                	ld	s2,64(sp)
    800023f0:	79e2                	ld	s3,56(sp)
    800023f2:	7a42                	ld	s4,48(sp)
    800023f4:	7aa2                	ld	s5,40(sp)
    800023f6:	7b02                	ld	s6,32(sp)
    800023f8:	6be2                	ld	s7,24(sp)
    800023fa:	6c42                	ld	s8,16(sp)
    800023fc:	6ca2                	ld	s9,8(sp)
    800023fe:	6125                	addi	sp,sp,96
    80002400:	8082                	ret
    brelse(bp);
    80002402:	854a                	mv	a0,s2
    80002404:	e11ff0ef          	jal	ra,80002214 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002408:	015c87bb          	addw	a5,s9,s5
    8000240c:	00078a9b          	sext.w	s5,a5
    80002410:	004b2703          	lw	a4,4(s6)
    80002414:	06eaf163          	bgeu	s5,a4,80002476 <balloc+0x104>
    bp = bread(dev, BBLOCK(b, sb));
    80002418:	41fad79b          	sraiw	a5,s5,0x1f
    8000241c:	0137d79b          	srliw	a5,a5,0x13
    80002420:	015787bb          	addw	a5,a5,s5
    80002424:	40d7d79b          	sraiw	a5,a5,0xd
    80002428:	01cb2583          	lw	a1,28(s6)
    8000242c:	9dbd                	addw	a1,a1,a5
    8000242e:	855e                	mv	a0,s7
    80002430:	cddff0ef          	jal	ra,8000210c <bread>
    80002434:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002436:	004b2503          	lw	a0,4(s6)
    8000243a:	000a849b          	sext.w	s1,s5
    8000243e:	8662                	mv	a2,s8
    80002440:	fca4f1e3          	bgeu	s1,a0,80002402 <balloc+0x90>
      m = 1 << (bi % 8);
    80002444:	41f6579b          	sraiw	a5,a2,0x1f
    80002448:	01d7d69b          	srliw	a3,a5,0x1d
    8000244c:	00c6873b          	addw	a4,a3,a2
    80002450:	00777793          	andi	a5,a4,7
    80002454:	9f95                	subw	a5,a5,a3
    80002456:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000245a:	4037571b          	sraiw	a4,a4,0x3
    8000245e:	00e906b3          	add	a3,s2,a4
    80002462:	0586c683          	lbu	a3,88(a3)
    80002466:	00d7f5b3          	and	a1,a5,a3
    8000246a:	d1b1                	beqz	a1,800023ae <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000246c:	2605                	addiw	a2,a2,1
    8000246e:	2485                	addiw	s1,s1,1
    80002470:	fd4618e3          	bne	a2,s4,80002440 <balloc+0xce>
    80002474:	b779                	j	80002402 <balloc+0x90>
  printf("balloc: out of blocks\n");
    80002476:	00005517          	auipc	a0,0x5
    8000247a:	0da50513          	addi	a0,a0,218 # 80007550 <syscalls+0x108>
    8000247e:	585020ef          	jal	ra,80005202 <printf>
  return 0;
    80002482:	4481                	li	s1,0
    80002484:	b78d                	j	800023e6 <balloc+0x74>

0000000080002486 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002486:	7179                	addi	sp,sp,-48
    80002488:	f406                	sd	ra,40(sp)
    8000248a:	f022                	sd	s0,32(sp)
    8000248c:	ec26                	sd	s1,24(sp)
    8000248e:	e84a                	sd	s2,16(sp)
    80002490:	e44e                	sd	s3,8(sp)
    80002492:	e052                	sd	s4,0(sp)
    80002494:	1800                	addi	s0,sp,48
    80002496:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002498:	47ad                	li	a5,11
    8000249a:	02b7e563          	bltu	a5,a1,800024c4 <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    8000249e:	02059493          	slli	s1,a1,0x20
    800024a2:	9081                	srli	s1,s1,0x20
    800024a4:	048a                	slli	s1,s1,0x2
    800024a6:	94aa                	add	s1,s1,a0
    800024a8:	0504a903          	lw	s2,80(s1)
    800024ac:	06091663          	bnez	s2,80002518 <bmap+0x92>
      addr = balloc(ip->dev);
    800024b0:	4108                	lw	a0,0(a0)
    800024b2:	ec1ff0ef          	jal	ra,80002372 <balloc>
    800024b6:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800024ba:	04090f63          	beqz	s2,80002518 <bmap+0x92>
        return 0;
      ip->addrs[bn] = addr;
    800024be:	0524a823          	sw	s2,80(s1)
    800024c2:	a899                	j	80002518 <bmap+0x92>
    }
    return addr;
  }
  bn -= NDIRECT;
    800024c4:	ff45849b          	addiw	s1,a1,-12
    800024c8:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800024cc:	0ff00793          	li	a5,255
    800024d0:	06e7eb63          	bltu	a5,a4,80002546 <bmap+0xc0>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800024d4:	08052903          	lw	s2,128(a0)
    800024d8:	00091b63          	bnez	s2,800024ee <bmap+0x68>
      addr = balloc(ip->dev);
    800024dc:	4108                	lw	a0,0(a0)
    800024de:	e95ff0ef          	jal	ra,80002372 <balloc>
    800024e2:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800024e6:	02090963          	beqz	s2,80002518 <bmap+0x92>
        return 0;
      ip->addrs[NDIRECT] = addr;
    800024ea:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    800024ee:	85ca                	mv	a1,s2
    800024f0:	0009a503          	lw	a0,0(s3)
    800024f4:	c19ff0ef          	jal	ra,8000210c <bread>
    800024f8:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800024fa:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800024fe:	02049593          	slli	a1,s1,0x20
    80002502:	9181                	srli	a1,a1,0x20
    80002504:	058a                	slli	a1,a1,0x2
    80002506:	00b784b3          	add	s1,a5,a1
    8000250a:	0004a903          	lw	s2,0(s1)
    8000250e:	00090e63          	beqz	s2,8000252a <bmap+0xa4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002512:	8552                	mv	a0,s4
    80002514:	d01ff0ef          	jal	ra,80002214 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002518:	854a                	mv	a0,s2
    8000251a:	70a2                	ld	ra,40(sp)
    8000251c:	7402                	ld	s0,32(sp)
    8000251e:	64e2                	ld	s1,24(sp)
    80002520:	6942                	ld	s2,16(sp)
    80002522:	69a2                	ld	s3,8(sp)
    80002524:	6a02                	ld	s4,0(sp)
    80002526:	6145                	addi	sp,sp,48
    80002528:	8082                	ret
      addr = balloc(ip->dev);
    8000252a:	0009a503          	lw	a0,0(s3)
    8000252e:	e45ff0ef          	jal	ra,80002372 <balloc>
    80002532:	0005091b          	sext.w	s2,a0
      if(addr){
    80002536:	fc090ee3          	beqz	s2,80002512 <bmap+0x8c>
        a[bn] = addr;
    8000253a:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000253e:	8552                	mv	a0,s4
    80002540:	4f9000ef          	jal	ra,80003238 <log_write>
    80002544:	b7f9                	j	80002512 <bmap+0x8c>
  panic("bmap: out of range");
    80002546:	00005517          	auipc	a0,0x5
    8000254a:	02250513          	addi	a0,a0,34 # 80007568 <syscalls+0x120>
    8000254e:	769020ef          	jal	ra,800054b6 <panic>

0000000080002552 <iget>:
{
    80002552:	7179                	addi	sp,sp,-48
    80002554:	f406                	sd	ra,40(sp)
    80002556:	f022                	sd	s0,32(sp)
    80002558:	ec26                	sd	s1,24(sp)
    8000255a:	e84a                	sd	s2,16(sp)
    8000255c:	e44e                	sd	s3,8(sp)
    8000255e:	e052                	sd	s4,0(sp)
    80002560:	1800                	addi	s0,sp,48
    80002562:	89aa                	mv	s3,a0
    80002564:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002566:	00014517          	auipc	a0,0x14
    8000256a:	b2250513          	addi	a0,a0,-1246 # 80016088 <itable>
    8000256e:	25c030ef          	jal	ra,800057ca <acquire>
  empty = 0;
    80002572:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002574:	00014497          	auipc	s1,0x14
    80002578:	b2c48493          	addi	s1,s1,-1236 # 800160a0 <itable+0x18>
    8000257c:	00015697          	auipc	a3,0x15
    80002580:	5b468693          	addi	a3,a3,1460 # 80017b30 <log>
    80002584:	a039                	j	80002592 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002586:	02090963          	beqz	s2,800025b8 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000258a:	08848493          	addi	s1,s1,136
    8000258e:	02d48863          	beq	s1,a3,800025be <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002592:	449c                	lw	a5,8(s1)
    80002594:	fef059e3          	blez	a5,80002586 <iget+0x34>
    80002598:	4098                	lw	a4,0(s1)
    8000259a:	ff3716e3          	bne	a4,s3,80002586 <iget+0x34>
    8000259e:	40d8                	lw	a4,4(s1)
    800025a0:	ff4713e3          	bne	a4,s4,80002586 <iget+0x34>
      ip->ref++;
    800025a4:	2785                	addiw	a5,a5,1
    800025a6:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800025a8:	00014517          	auipc	a0,0x14
    800025ac:	ae050513          	addi	a0,a0,-1312 # 80016088 <itable>
    800025b0:	2b2030ef          	jal	ra,80005862 <release>
      return ip;
    800025b4:	8926                	mv	s2,s1
    800025b6:	a02d                	j	800025e0 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800025b8:	fbe9                	bnez	a5,8000258a <iget+0x38>
    800025ba:	8926                	mv	s2,s1
    800025bc:	b7f9                	j	8000258a <iget+0x38>
  if(empty == 0)
    800025be:	02090a63          	beqz	s2,800025f2 <iget+0xa0>
  ip->dev = dev;
    800025c2:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800025c6:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800025ca:	4785                	li	a5,1
    800025cc:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800025d0:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800025d4:	00014517          	auipc	a0,0x14
    800025d8:	ab450513          	addi	a0,a0,-1356 # 80016088 <itable>
    800025dc:	286030ef          	jal	ra,80005862 <release>
}
    800025e0:	854a                	mv	a0,s2
    800025e2:	70a2                	ld	ra,40(sp)
    800025e4:	7402                	ld	s0,32(sp)
    800025e6:	64e2                	ld	s1,24(sp)
    800025e8:	6942                	ld	s2,16(sp)
    800025ea:	69a2                	ld	s3,8(sp)
    800025ec:	6a02                	ld	s4,0(sp)
    800025ee:	6145                	addi	sp,sp,48
    800025f0:	8082                	ret
    panic("iget: no inodes");
    800025f2:	00005517          	auipc	a0,0x5
    800025f6:	f8e50513          	addi	a0,a0,-114 # 80007580 <syscalls+0x138>
    800025fa:	6bd020ef          	jal	ra,800054b6 <panic>

00000000800025fe <fsinit>:
fsinit(int dev) {
    800025fe:	7179                	addi	sp,sp,-48
    80002600:	f406                	sd	ra,40(sp)
    80002602:	f022                	sd	s0,32(sp)
    80002604:	ec26                	sd	s1,24(sp)
    80002606:	e84a                	sd	s2,16(sp)
    80002608:	e44e                	sd	s3,8(sp)
    8000260a:	1800                	addi	s0,sp,48
    8000260c:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000260e:	4585                	li	a1,1
    80002610:	afdff0ef          	jal	ra,8000210c <bread>
    80002614:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002616:	00014997          	auipc	s3,0x14
    8000261a:	a5298993          	addi	s3,s3,-1454 # 80016068 <sb>
    8000261e:	02000613          	li	a2,32
    80002622:	05850593          	addi	a1,a0,88
    80002626:	854e                	mv	a0,s3
    80002628:	b81fd0ef          	jal	ra,800001a8 <memmove>
  brelse(bp);
    8000262c:	8526                	mv	a0,s1
    8000262e:	be7ff0ef          	jal	ra,80002214 <brelse>
  if(sb.magic != FSMAGIC)
    80002632:	0009a703          	lw	a4,0(s3)
    80002636:	102037b7          	lui	a5,0x10203
    8000263a:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000263e:	02f71063          	bne	a4,a5,8000265e <fsinit+0x60>
  initlog(dev, &sb);
    80002642:	00014597          	auipc	a1,0x14
    80002646:	a2658593          	addi	a1,a1,-1498 # 80016068 <sb>
    8000264a:	854a                	mv	a0,s2
    8000264c:	1d9000ef          	jal	ra,80003024 <initlog>
}
    80002650:	70a2                	ld	ra,40(sp)
    80002652:	7402                	ld	s0,32(sp)
    80002654:	64e2                	ld	s1,24(sp)
    80002656:	6942                	ld	s2,16(sp)
    80002658:	69a2                	ld	s3,8(sp)
    8000265a:	6145                	addi	sp,sp,48
    8000265c:	8082                	ret
    panic("invalid file system");
    8000265e:	00005517          	auipc	a0,0x5
    80002662:	f3250513          	addi	a0,a0,-206 # 80007590 <syscalls+0x148>
    80002666:	651020ef          	jal	ra,800054b6 <panic>

000000008000266a <iinit>:
{
    8000266a:	7179                	addi	sp,sp,-48
    8000266c:	f406                	sd	ra,40(sp)
    8000266e:	f022                	sd	s0,32(sp)
    80002670:	ec26                	sd	s1,24(sp)
    80002672:	e84a                	sd	s2,16(sp)
    80002674:	e44e                	sd	s3,8(sp)
    80002676:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002678:	00005597          	auipc	a1,0x5
    8000267c:	f3058593          	addi	a1,a1,-208 # 800075a8 <syscalls+0x160>
    80002680:	00014517          	auipc	a0,0x14
    80002684:	a0850513          	addi	a0,a0,-1528 # 80016088 <itable>
    80002688:	0c2030ef          	jal	ra,8000574a <initlock>
  for(i = 0; i < NINODE; i++) {
    8000268c:	00014497          	auipc	s1,0x14
    80002690:	a2448493          	addi	s1,s1,-1500 # 800160b0 <itable+0x28>
    80002694:	00015997          	auipc	s3,0x15
    80002698:	4ac98993          	addi	s3,s3,1196 # 80017b40 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    8000269c:	00005917          	auipc	s2,0x5
    800026a0:	f1490913          	addi	s2,s2,-236 # 800075b0 <syscalls+0x168>
    800026a4:	85ca                	mv	a1,s2
    800026a6:	8526                	mv	a0,s1
    800026a8:	463000ef          	jal	ra,8000330a <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800026ac:	08848493          	addi	s1,s1,136
    800026b0:	ff349ae3          	bne	s1,s3,800026a4 <iinit+0x3a>
}
    800026b4:	70a2                	ld	ra,40(sp)
    800026b6:	7402                	ld	s0,32(sp)
    800026b8:	64e2                	ld	s1,24(sp)
    800026ba:	6942                	ld	s2,16(sp)
    800026bc:	69a2                	ld	s3,8(sp)
    800026be:	6145                	addi	sp,sp,48
    800026c0:	8082                	ret

00000000800026c2 <ialloc>:
{
    800026c2:	715d                	addi	sp,sp,-80
    800026c4:	e486                	sd	ra,72(sp)
    800026c6:	e0a2                	sd	s0,64(sp)
    800026c8:	fc26                	sd	s1,56(sp)
    800026ca:	f84a                	sd	s2,48(sp)
    800026cc:	f44e                	sd	s3,40(sp)
    800026ce:	f052                	sd	s4,32(sp)
    800026d0:	ec56                	sd	s5,24(sp)
    800026d2:	e85a                	sd	s6,16(sp)
    800026d4:	e45e                	sd	s7,8(sp)
    800026d6:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    800026d8:	00014717          	auipc	a4,0x14
    800026dc:	99c72703          	lw	a4,-1636(a4) # 80016074 <sb+0xc>
    800026e0:	4785                	li	a5,1
    800026e2:	04e7f663          	bgeu	a5,a4,8000272e <ialloc+0x6c>
    800026e6:	8aaa                	mv	s5,a0
    800026e8:	8bae                	mv	s7,a1
    800026ea:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    800026ec:	00014a17          	auipc	s4,0x14
    800026f0:	97ca0a13          	addi	s4,s4,-1668 # 80016068 <sb>
    800026f4:	00048b1b          	sext.w	s6,s1
    800026f8:	0044d793          	srli	a5,s1,0x4
    800026fc:	018a2583          	lw	a1,24(s4)
    80002700:	9dbd                	addw	a1,a1,a5
    80002702:	8556                	mv	a0,s5
    80002704:	a09ff0ef          	jal	ra,8000210c <bread>
    80002708:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    8000270a:	05850993          	addi	s3,a0,88
    8000270e:	00f4f793          	andi	a5,s1,15
    80002712:	079a                	slli	a5,a5,0x6
    80002714:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002716:	00099783          	lh	a5,0(s3)
    8000271a:	cf85                	beqz	a5,80002752 <ialloc+0x90>
    brelse(bp);
    8000271c:	af9ff0ef          	jal	ra,80002214 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002720:	0485                	addi	s1,s1,1
    80002722:	00ca2703          	lw	a4,12(s4)
    80002726:	0004879b          	sext.w	a5,s1
    8000272a:	fce7e5e3          	bltu	a5,a4,800026f4 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    8000272e:	00005517          	auipc	a0,0x5
    80002732:	e8a50513          	addi	a0,a0,-374 # 800075b8 <syscalls+0x170>
    80002736:	2cd020ef          	jal	ra,80005202 <printf>
  return 0;
    8000273a:	4501                	li	a0,0
}
    8000273c:	60a6                	ld	ra,72(sp)
    8000273e:	6406                	ld	s0,64(sp)
    80002740:	74e2                	ld	s1,56(sp)
    80002742:	7942                	ld	s2,48(sp)
    80002744:	79a2                	ld	s3,40(sp)
    80002746:	7a02                	ld	s4,32(sp)
    80002748:	6ae2                	ld	s5,24(sp)
    8000274a:	6b42                	ld	s6,16(sp)
    8000274c:	6ba2                	ld	s7,8(sp)
    8000274e:	6161                	addi	sp,sp,80
    80002750:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002752:	04000613          	li	a2,64
    80002756:	4581                	li	a1,0
    80002758:	854e                	mv	a0,s3
    8000275a:	9f3fd0ef          	jal	ra,8000014c <memset>
      dip->type = type;
    8000275e:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002762:	854a                	mv	a0,s2
    80002764:	2d5000ef          	jal	ra,80003238 <log_write>
      brelse(bp);
    80002768:	854a                	mv	a0,s2
    8000276a:	aabff0ef          	jal	ra,80002214 <brelse>
      return iget(dev, inum);
    8000276e:	85da                	mv	a1,s6
    80002770:	8556                	mv	a0,s5
    80002772:	de1ff0ef          	jal	ra,80002552 <iget>
    80002776:	b7d9                	j	8000273c <ialloc+0x7a>

0000000080002778 <iupdate>:
{
    80002778:	1101                	addi	sp,sp,-32
    8000277a:	ec06                	sd	ra,24(sp)
    8000277c:	e822                	sd	s0,16(sp)
    8000277e:	e426                	sd	s1,8(sp)
    80002780:	e04a                	sd	s2,0(sp)
    80002782:	1000                	addi	s0,sp,32
    80002784:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002786:	415c                	lw	a5,4(a0)
    80002788:	0047d79b          	srliw	a5,a5,0x4
    8000278c:	00014597          	auipc	a1,0x14
    80002790:	8f45a583          	lw	a1,-1804(a1) # 80016080 <sb+0x18>
    80002794:	9dbd                	addw	a1,a1,a5
    80002796:	4108                	lw	a0,0(a0)
    80002798:	975ff0ef          	jal	ra,8000210c <bread>
    8000279c:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000279e:	05850793          	addi	a5,a0,88
    800027a2:	40c8                	lw	a0,4(s1)
    800027a4:	893d                	andi	a0,a0,15
    800027a6:	051a                	slli	a0,a0,0x6
    800027a8:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    800027aa:	04449703          	lh	a4,68(s1)
    800027ae:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    800027b2:	04649703          	lh	a4,70(s1)
    800027b6:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    800027ba:	04849703          	lh	a4,72(s1)
    800027be:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    800027c2:	04a49703          	lh	a4,74(s1)
    800027c6:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    800027ca:	44f8                	lw	a4,76(s1)
    800027cc:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800027ce:	03400613          	li	a2,52
    800027d2:	05048593          	addi	a1,s1,80
    800027d6:	0531                	addi	a0,a0,12
    800027d8:	9d1fd0ef          	jal	ra,800001a8 <memmove>
  log_write(bp);
    800027dc:	854a                	mv	a0,s2
    800027de:	25b000ef          	jal	ra,80003238 <log_write>
  brelse(bp);
    800027e2:	854a                	mv	a0,s2
    800027e4:	a31ff0ef          	jal	ra,80002214 <brelse>
}
    800027e8:	60e2                	ld	ra,24(sp)
    800027ea:	6442                	ld	s0,16(sp)
    800027ec:	64a2                	ld	s1,8(sp)
    800027ee:	6902                	ld	s2,0(sp)
    800027f0:	6105                	addi	sp,sp,32
    800027f2:	8082                	ret

00000000800027f4 <idup>:
{
    800027f4:	1101                	addi	sp,sp,-32
    800027f6:	ec06                	sd	ra,24(sp)
    800027f8:	e822                	sd	s0,16(sp)
    800027fa:	e426                	sd	s1,8(sp)
    800027fc:	1000                	addi	s0,sp,32
    800027fe:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002800:	00014517          	auipc	a0,0x14
    80002804:	88850513          	addi	a0,a0,-1912 # 80016088 <itable>
    80002808:	7c3020ef          	jal	ra,800057ca <acquire>
  ip->ref++;
    8000280c:	449c                	lw	a5,8(s1)
    8000280e:	2785                	addiw	a5,a5,1
    80002810:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002812:	00014517          	auipc	a0,0x14
    80002816:	87650513          	addi	a0,a0,-1930 # 80016088 <itable>
    8000281a:	048030ef          	jal	ra,80005862 <release>
}
    8000281e:	8526                	mv	a0,s1
    80002820:	60e2                	ld	ra,24(sp)
    80002822:	6442                	ld	s0,16(sp)
    80002824:	64a2                	ld	s1,8(sp)
    80002826:	6105                	addi	sp,sp,32
    80002828:	8082                	ret

000000008000282a <ilock>:
{
    8000282a:	1101                	addi	sp,sp,-32
    8000282c:	ec06                	sd	ra,24(sp)
    8000282e:	e822                	sd	s0,16(sp)
    80002830:	e426                	sd	s1,8(sp)
    80002832:	e04a                	sd	s2,0(sp)
    80002834:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002836:	c105                	beqz	a0,80002856 <ilock+0x2c>
    80002838:	84aa                	mv	s1,a0
    8000283a:	451c                	lw	a5,8(a0)
    8000283c:	00f05d63          	blez	a5,80002856 <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002840:	0541                	addi	a0,a0,16
    80002842:	2ff000ef          	jal	ra,80003340 <acquiresleep>
  if(ip->valid == 0){
    80002846:	40bc                	lw	a5,64(s1)
    80002848:	cf89                	beqz	a5,80002862 <ilock+0x38>
}
    8000284a:	60e2                	ld	ra,24(sp)
    8000284c:	6442                	ld	s0,16(sp)
    8000284e:	64a2                	ld	s1,8(sp)
    80002850:	6902                	ld	s2,0(sp)
    80002852:	6105                	addi	sp,sp,32
    80002854:	8082                	ret
    panic("ilock");
    80002856:	00005517          	auipc	a0,0x5
    8000285a:	d7a50513          	addi	a0,a0,-646 # 800075d0 <syscalls+0x188>
    8000285e:	459020ef          	jal	ra,800054b6 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002862:	40dc                	lw	a5,4(s1)
    80002864:	0047d79b          	srliw	a5,a5,0x4
    80002868:	00014597          	auipc	a1,0x14
    8000286c:	8185a583          	lw	a1,-2024(a1) # 80016080 <sb+0x18>
    80002870:	9dbd                	addw	a1,a1,a5
    80002872:	4088                	lw	a0,0(s1)
    80002874:	899ff0ef          	jal	ra,8000210c <bread>
    80002878:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000287a:	05850593          	addi	a1,a0,88
    8000287e:	40dc                	lw	a5,4(s1)
    80002880:	8bbd                	andi	a5,a5,15
    80002882:	079a                	slli	a5,a5,0x6
    80002884:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002886:	00059783          	lh	a5,0(a1)
    8000288a:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    8000288e:	00259783          	lh	a5,2(a1)
    80002892:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002896:	00459783          	lh	a5,4(a1)
    8000289a:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000289e:	00659783          	lh	a5,6(a1)
    800028a2:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800028a6:	459c                	lw	a5,8(a1)
    800028a8:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800028aa:	03400613          	li	a2,52
    800028ae:	05b1                	addi	a1,a1,12
    800028b0:	05048513          	addi	a0,s1,80
    800028b4:	8f5fd0ef          	jal	ra,800001a8 <memmove>
    brelse(bp);
    800028b8:	854a                	mv	a0,s2
    800028ba:	95bff0ef          	jal	ra,80002214 <brelse>
    ip->valid = 1;
    800028be:	4785                	li	a5,1
    800028c0:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800028c2:	04449783          	lh	a5,68(s1)
    800028c6:	f3d1                	bnez	a5,8000284a <ilock+0x20>
      panic("ilock: no type");
    800028c8:	00005517          	auipc	a0,0x5
    800028cc:	d1050513          	addi	a0,a0,-752 # 800075d8 <syscalls+0x190>
    800028d0:	3e7020ef          	jal	ra,800054b6 <panic>

00000000800028d4 <iunlock>:
{
    800028d4:	1101                	addi	sp,sp,-32
    800028d6:	ec06                	sd	ra,24(sp)
    800028d8:	e822                	sd	s0,16(sp)
    800028da:	e426                	sd	s1,8(sp)
    800028dc:	e04a                	sd	s2,0(sp)
    800028de:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800028e0:	c505                	beqz	a0,80002908 <iunlock+0x34>
    800028e2:	84aa                	mv	s1,a0
    800028e4:	01050913          	addi	s2,a0,16
    800028e8:	854a                	mv	a0,s2
    800028ea:	2d5000ef          	jal	ra,800033be <holdingsleep>
    800028ee:	cd09                	beqz	a0,80002908 <iunlock+0x34>
    800028f0:	449c                	lw	a5,8(s1)
    800028f2:	00f05b63          	blez	a5,80002908 <iunlock+0x34>
  releasesleep(&ip->lock);
    800028f6:	854a                	mv	a0,s2
    800028f8:	28f000ef          	jal	ra,80003386 <releasesleep>
}
    800028fc:	60e2                	ld	ra,24(sp)
    800028fe:	6442                	ld	s0,16(sp)
    80002900:	64a2                	ld	s1,8(sp)
    80002902:	6902                	ld	s2,0(sp)
    80002904:	6105                	addi	sp,sp,32
    80002906:	8082                	ret
    panic("iunlock");
    80002908:	00005517          	auipc	a0,0x5
    8000290c:	ce050513          	addi	a0,a0,-800 # 800075e8 <syscalls+0x1a0>
    80002910:	3a7020ef          	jal	ra,800054b6 <panic>

0000000080002914 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002914:	7179                	addi	sp,sp,-48
    80002916:	f406                	sd	ra,40(sp)
    80002918:	f022                	sd	s0,32(sp)
    8000291a:	ec26                	sd	s1,24(sp)
    8000291c:	e84a                	sd	s2,16(sp)
    8000291e:	e44e                	sd	s3,8(sp)
    80002920:	e052                	sd	s4,0(sp)
    80002922:	1800                	addi	s0,sp,48
    80002924:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002926:	05050493          	addi	s1,a0,80
    8000292a:	08050913          	addi	s2,a0,128
    8000292e:	a021                	j	80002936 <itrunc+0x22>
    80002930:	0491                	addi	s1,s1,4
    80002932:	01248b63          	beq	s1,s2,80002948 <itrunc+0x34>
    if(ip->addrs[i]){
    80002936:	408c                	lw	a1,0(s1)
    80002938:	dde5                	beqz	a1,80002930 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    8000293a:	0009a503          	lw	a0,0(s3)
    8000293e:	9c9ff0ef          	jal	ra,80002306 <bfree>
      ip->addrs[i] = 0;
    80002942:	0004a023          	sw	zero,0(s1)
    80002946:	b7ed                	j	80002930 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002948:	0809a583          	lw	a1,128(s3)
    8000294c:	ed91                	bnez	a1,80002968 <itrunc+0x54>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000294e:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002952:	854e                	mv	a0,s3
    80002954:	e25ff0ef          	jal	ra,80002778 <iupdate>
}
    80002958:	70a2                	ld	ra,40(sp)
    8000295a:	7402                	ld	s0,32(sp)
    8000295c:	64e2                	ld	s1,24(sp)
    8000295e:	6942                	ld	s2,16(sp)
    80002960:	69a2                	ld	s3,8(sp)
    80002962:	6a02                	ld	s4,0(sp)
    80002964:	6145                	addi	sp,sp,48
    80002966:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002968:	0009a503          	lw	a0,0(s3)
    8000296c:	fa0ff0ef          	jal	ra,8000210c <bread>
    80002970:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002972:	05850493          	addi	s1,a0,88
    80002976:	45850913          	addi	s2,a0,1112
    8000297a:	a021                	j	80002982 <itrunc+0x6e>
    8000297c:	0491                	addi	s1,s1,4
    8000297e:	01248963          	beq	s1,s2,80002990 <itrunc+0x7c>
      if(a[j])
    80002982:	408c                	lw	a1,0(s1)
    80002984:	dde5                	beqz	a1,8000297c <itrunc+0x68>
        bfree(ip->dev, a[j]);
    80002986:	0009a503          	lw	a0,0(s3)
    8000298a:	97dff0ef          	jal	ra,80002306 <bfree>
    8000298e:	b7fd                	j	8000297c <itrunc+0x68>
    brelse(bp);
    80002990:	8552                	mv	a0,s4
    80002992:	883ff0ef          	jal	ra,80002214 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002996:	0809a583          	lw	a1,128(s3)
    8000299a:	0009a503          	lw	a0,0(s3)
    8000299e:	969ff0ef          	jal	ra,80002306 <bfree>
    ip->addrs[NDIRECT] = 0;
    800029a2:	0809a023          	sw	zero,128(s3)
    800029a6:	b765                	j	8000294e <itrunc+0x3a>

00000000800029a8 <iput>:
{
    800029a8:	1101                	addi	sp,sp,-32
    800029aa:	ec06                	sd	ra,24(sp)
    800029ac:	e822                	sd	s0,16(sp)
    800029ae:	e426                	sd	s1,8(sp)
    800029b0:	e04a                	sd	s2,0(sp)
    800029b2:	1000                	addi	s0,sp,32
    800029b4:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800029b6:	00013517          	auipc	a0,0x13
    800029ba:	6d250513          	addi	a0,a0,1746 # 80016088 <itable>
    800029be:	60d020ef          	jal	ra,800057ca <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800029c2:	4498                	lw	a4,8(s1)
    800029c4:	4785                	li	a5,1
    800029c6:	02f70163          	beq	a4,a5,800029e8 <iput+0x40>
  ip->ref--;
    800029ca:	449c                	lw	a5,8(s1)
    800029cc:	37fd                	addiw	a5,a5,-1
    800029ce:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800029d0:	00013517          	auipc	a0,0x13
    800029d4:	6b850513          	addi	a0,a0,1720 # 80016088 <itable>
    800029d8:	68b020ef          	jal	ra,80005862 <release>
}
    800029dc:	60e2                	ld	ra,24(sp)
    800029de:	6442                	ld	s0,16(sp)
    800029e0:	64a2                	ld	s1,8(sp)
    800029e2:	6902                	ld	s2,0(sp)
    800029e4:	6105                	addi	sp,sp,32
    800029e6:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800029e8:	40bc                	lw	a5,64(s1)
    800029ea:	d3e5                	beqz	a5,800029ca <iput+0x22>
    800029ec:	04a49783          	lh	a5,74(s1)
    800029f0:	ffe9                	bnez	a5,800029ca <iput+0x22>
    acquiresleep(&ip->lock);
    800029f2:	01048913          	addi	s2,s1,16
    800029f6:	854a                	mv	a0,s2
    800029f8:	149000ef          	jal	ra,80003340 <acquiresleep>
    release(&itable.lock);
    800029fc:	00013517          	auipc	a0,0x13
    80002a00:	68c50513          	addi	a0,a0,1676 # 80016088 <itable>
    80002a04:	65f020ef          	jal	ra,80005862 <release>
    itrunc(ip);
    80002a08:	8526                	mv	a0,s1
    80002a0a:	f0bff0ef          	jal	ra,80002914 <itrunc>
    ip->type = 0;
    80002a0e:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002a12:	8526                	mv	a0,s1
    80002a14:	d65ff0ef          	jal	ra,80002778 <iupdate>
    ip->valid = 0;
    80002a18:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002a1c:	854a                	mv	a0,s2
    80002a1e:	169000ef          	jal	ra,80003386 <releasesleep>
    acquire(&itable.lock);
    80002a22:	00013517          	auipc	a0,0x13
    80002a26:	66650513          	addi	a0,a0,1638 # 80016088 <itable>
    80002a2a:	5a1020ef          	jal	ra,800057ca <acquire>
    80002a2e:	bf71                	j	800029ca <iput+0x22>

0000000080002a30 <iunlockput>:
{
    80002a30:	1101                	addi	sp,sp,-32
    80002a32:	ec06                	sd	ra,24(sp)
    80002a34:	e822                	sd	s0,16(sp)
    80002a36:	e426                	sd	s1,8(sp)
    80002a38:	1000                	addi	s0,sp,32
    80002a3a:	84aa                	mv	s1,a0
  iunlock(ip);
    80002a3c:	e99ff0ef          	jal	ra,800028d4 <iunlock>
  iput(ip);
    80002a40:	8526                	mv	a0,s1
    80002a42:	f67ff0ef          	jal	ra,800029a8 <iput>
}
    80002a46:	60e2                	ld	ra,24(sp)
    80002a48:	6442                	ld	s0,16(sp)
    80002a4a:	64a2                	ld	s1,8(sp)
    80002a4c:	6105                	addi	sp,sp,32
    80002a4e:	8082                	ret

0000000080002a50 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002a50:	1141                	addi	sp,sp,-16
    80002a52:	e422                	sd	s0,8(sp)
    80002a54:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002a56:	411c                	lw	a5,0(a0)
    80002a58:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002a5a:	415c                	lw	a5,4(a0)
    80002a5c:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002a5e:	04451783          	lh	a5,68(a0)
    80002a62:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002a66:	04a51783          	lh	a5,74(a0)
    80002a6a:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002a6e:	04c56783          	lwu	a5,76(a0)
    80002a72:	e99c                	sd	a5,16(a1)
}
    80002a74:	6422                	ld	s0,8(sp)
    80002a76:	0141                	addi	sp,sp,16
    80002a78:	8082                	ret

0000000080002a7a <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002a7a:	457c                	lw	a5,76(a0)
    80002a7c:	0cd7ef63          	bltu	a5,a3,80002b5a <readi+0xe0>
{
    80002a80:	7159                	addi	sp,sp,-112
    80002a82:	f486                	sd	ra,104(sp)
    80002a84:	f0a2                	sd	s0,96(sp)
    80002a86:	eca6                	sd	s1,88(sp)
    80002a88:	e8ca                	sd	s2,80(sp)
    80002a8a:	e4ce                	sd	s3,72(sp)
    80002a8c:	e0d2                	sd	s4,64(sp)
    80002a8e:	fc56                	sd	s5,56(sp)
    80002a90:	f85a                	sd	s6,48(sp)
    80002a92:	f45e                	sd	s7,40(sp)
    80002a94:	f062                	sd	s8,32(sp)
    80002a96:	ec66                	sd	s9,24(sp)
    80002a98:	e86a                	sd	s10,16(sp)
    80002a9a:	e46e                	sd	s11,8(sp)
    80002a9c:	1880                	addi	s0,sp,112
    80002a9e:	8b2a                	mv	s6,a0
    80002aa0:	8bae                	mv	s7,a1
    80002aa2:	8a32                	mv	s4,a2
    80002aa4:	84b6                	mv	s1,a3
    80002aa6:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002aa8:	9f35                	addw	a4,a4,a3
    return 0;
    80002aaa:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002aac:	08d76663          	bltu	a4,a3,80002b38 <readi+0xbe>
  if(off + n > ip->size)
    80002ab0:	00e7f463          	bgeu	a5,a4,80002ab8 <readi+0x3e>
    n = ip->size - off;
    80002ab4:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ab8:	080a8f63          	beqz	s5,80002b56 <readi+0xdc>
    80002abc:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002abe:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002ac2:	5c7d                	li	s8,-1
    80002ac4:	a80d                	j	80002af6 <readi+0x7c>
    80002ac6:	020d1d93          	slli	s11,s10,0x20
    80002aca:	020ddd93          	srli	s11,s11,0x20
    80002ace:	05890793          	addi	a5,s2,88
    80002ad2:	86ee                	mv	a3,s11
    80002ad4:	963e                	add	a2,a2,a5
    80002ad6:	85d2                	mv	a1,s4
    80002ad8:	855e                	mv	a0,s7
    80002ada:	d01fe0ef          	jal	ra,800017da <either_copyout>
    80002ade:	05850763          	beq	a0,s8,80002b2c <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002ae2:	854a                	mv	a0,s2
    80002ae4:	f30ff0ef          	jal	ra,80002214 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ae8:	013d09bb          	addw	s3,s10,s3
    80002aec:	009d04bb          	addw	s1,s10,s1
    80002af0:	9a6e                	add	s4,s4,s11
    80002af2:	0559f163          	bgeu	s3,s5,80002b34 <readi+0xba>
    uint addr = bmap(ip, off/BSIZE);
    80002af6:	00a4d59b          	srliw	a1,s1,0xa
    80002afa:	855a                	mv	a0,s6
    80002afc:	98bff0ef          	jal	ra,80002486 <bmap>
    80002b00:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002b04:	c985                	beqz	a1,80002b34 <readi+0xba>
    bp = bread(ip->dev, addr);
    80002b06:	000b2503          	lw	a0,0(s6)
    80002b0a:	e02ff0ef          	jal	ra,8000210c <bread>
    80002b0e:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002b10:	3ff4f613          	andi	a2,s1,1023
    80002b14:	40cc87bb          	subw	a5,s9,a2
    80002b18:	413a873b          	subw	a4,s5,s3
    80002b1c:	8d3e                	mv	s10,a5
    80002b1e:	2781                	sext.w	a5,a5
    80002b20:	0007069b          	sext.w	a3,a4
    80002b24:	faf6f1e3          	bgeu	a3,a5,80002ac6 <readi+0x4c>
    80002b28:	8d3a                	mv	s10,a4
    80002b2a:	bf71                	j	80002ac6 <readi+0x4c>
      brelse(bp);
    80002b2c:	854a                	mv	a0,s2
    80002b2e:	ee6ff0ef          	jal	ra,80002214 <brelse>
      tot = -1;
    80002b32:	59fd                	li	s3,-1
  }
  return tot;
    80002b34:	0009851b          	sext.w	a0,s3
}
    80002b38:	70a6                	ld	ra,104(sp)
    80002b3a:	7406                	ld	s0,96(sp)
    80002b3c:	64e6                	ld	s1,88(sp)
    80002b3e:	6946                	ld	s2,80(sp)
    80002b40:	69a6                	ld	s3,72(sp)
    80002b42:	6a06                	ld	s4,64(sp)
    80002b44:	7ae2                	ld	s5,56(sp)
    80002b46:	7b42                	ld	s6,48(sp)
    80002b48:	7ba2                	ld	s7,40(sp)
    80002b4a:	7c02                	ld	s8,32(sp)
    80002b4c:	6ce2                	ld	s9,24(sp)
    80002b4e:	6d42                	ld	s10,16(sp)
    80002b50:	6da2                	ld	s11,8(sp)
    80002b52:	6165                	addi	sp,sp,112
    80002b54:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002b56:	89d6                	mv	s3,s5
    80002b58:	bff1                	j	80002b34 <readi+0xba>
    return 0;
    80002b5a:	4501                	li	a0,0
}
    80002b5c:	8082                	ret

0000000080002b5e <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002b5e:	457c                	lw	a5,76(a0)
    80002b60:	0ed7ea63          	bltu	a5,a3,80002c54 <writei+0xf6>
{
    80002b64:	7159                	addi	sp,sp,-112
    80002b66:	f486                	sd	ra,104(sp)
    80002b68:	f0a2                	sd	s0,96(sp)
    80002b6a:	eca6                	sd	s1,88(sp)
    80002b6c:	e8ca                	sd	s2,80(sp)
    80002b6e:	e4ce                	sd	s3,72(sp)
    80002b70:	e0d2                	sd	s4,64(sp)
    80002b72:	fc56                	sd	s5,56(sp)
    80002b74:	f85a                	sd	s6,48(sp)
    80002b76:	f45e                	sd	s7,40(sp)
    80002b78:	f062                	sd	s8,32(sp)
    80002b7a:	ec66                	sd	s9,24(sp)
    80002b7c:	e86a                	sd	s10,16(sp)
    80002b7e:	e46e                	sd	s11,8(sp)
    80002b80:	1880                	addi	s0,sp,112
    80002b82:	8aaa                	mv	s5,a0
    80002b84:	8bae                	mv	s7,a1
    80002b86:	8a32                	mv	s4,a2
    80002b88:	8936                	mv	s2,a3
    80002b8a:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002b8c:	00e687bb          	addw	a5,a3,a4
    80002b90:	0cd7e463          	bltu	a5,a3,80002c58 <writei+0xfa>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002b94:	00043737          	lui	a4,0x43
    80002b98:	0cf76263          	bltu	a4,a5,80002c5c <writei+0xfe>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002b9c:	0a0b0a63          	beqz	s6,80002c50 <writei+0xf2>
    80002ba0:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ba2:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002ba6:	5c7d                	li	s8,-1
    80002ba8:	a825                	j	80002be0 <writei+0x82>
    80002baa:	020d1d93          	slli	s11,s10,0x20
    80002bae:	020ddd93          	srli	s11,s11,0x20
    80002bb2:	05848793          	addi	a5,s1,88
    80002bb6:	86ee                	mv	a3,s11
    80002bb8:	8652                	mv	a2,s4
    80002bba:	85de                	mv	a1,s7
    80002bbc:	953e                	add	a0,a0,a5
    80002bbe:	c67fe0ef          	jal	ra,80001824 <either_copyin>
    80002bc2:	05850a63          	beq	a0,s8,80002c16 <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002bc6:	8526                	mv	a0,s1
    80002bc8:	670000ef          	jal	ra,80003238 <log_write>
    brelse(bp);
    80002bcc:	8526                	mv	a0,s1
    80002bce:	e46ff0ef          	jal	ra,80002214 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002bd2:	013d09bb          	addw	s3,s10,s3
    80002bd6:	012d093b          	addw	s2,s10,s2
    80002bda:	9a6e                	add	s4,s4,s11
    80002bdc:	0569f063          	bgeu	s3,s6,80002c1c <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002be0:	00a9559b          	srliw	a1,s2,0xa
    80002be4:	8556                	mv	a0,s5
    80002be6:	8a1ff0ef          	jal	ra,80002486 <bmap>
    80002bea:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002bee:	c59d                	beqz	a1,80002c1c <writei+0xbe>
    bp = bread(ip->dev, addr);
    80002bf0:	000aa503          	lw	a0,0(s5)
    80002bf4:	d18ff0ef          	jal	ra,8000210c <bread>
    80002bf8:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002bfa:	3ff97513          	andi	a0,s2,1023
    80002bfe:	40ac87bb          	subw	a5,s9,a0
    80002c02:	413b073b          	subw	a4,s6,s3
    80002c06:	8d3e                	mv	s10,a5
    80002c08:	2781                	sext.w	a5,a5
    80002c0a:	0007069b          	sext.w	a3,a4
    80002c0e:	f8f6fee3          	bgeu	a3,a5,80002baa <writei+0x4c>
    80002c12:	8d3a                	mv	s10,a4
    80002c14:	bf59                	j	80002baa <writei+0x4c>
      brelse(bp);
    80002c16:	8526                	mv	a0,s1
    80002c18:	dfcff0ef          	jal	ra,80002214 <brelse>
  }

  if(off > ip->size)
    80002c1c:	04caa783          	lw	a5,76(s5)
    80002c20:	0127f463          	bgeu	a5,s2,80002c28 <writei+0xca>
    ip->size = off;
    80002c24:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002c28:	8556                	mv	a0,s5
    80002c2a:	b4fff0ef          	jal	ra,80002778 <iupdate>

  return tot;
    80002c2e:	0009851b          	sext.w	a0,s3
}
    80002c32:	70a6                	ld	ra,104(sp)
    80002c34:	7406                	ld	s0,96(sp)
    80002c36:	64e6                	ld	s1,88(sp)
    80002c38:	6946                	ld	s2,80(sp)
    80002c3a:	69a6                	ld	s3,72(sp)
    80002c3c:	6a06                	ld	s4,64(sp)
    80002c3e:	7ae2                	ld	s5,56(sp)
    80002c40:	7b42                	ld	s6,48(sp)
    80002c42:	7ba2                	ld	s7,40(sp)
    80002c44:	7c02                	ld	s8,32(sp)
    80002c46:	6ce2                	ld	s9,24(sp)
    80002c48:	6d42                	ld	s10,16(sp)
    80002c4a:	6da2                	ld	s11,8(sp)
    80002c4c:	6165                	addi	sp,sp,112
    80002c4e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002c50:	89da                	mv	s3,s6
    80002c52:	bfd9                	j	80002c28 <writei+0xca>
    return -1;
    80002c54:	557d                	li	a0,-1
}
    80002c56:	8082                	ret
    return -1;
    80002c58:	557d                	li	a0,-1
    80002c5a:	bfe1                	j	80002c32 <writei+0xd4>
    return -1;
    80002c5c:	557d                	li	a0,-1
    80002c5e:	bfd1                	j	80002c32 <writei+0xd4>

0000000080002c60 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002c60:	1141                	addi	sp,sp,-16
    80002c62:	e406                	sd	ra,8(sp)
    80002c64:	e022                	sd	s0,0(sp)
    80002c66:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002c68:	4639                	li	a2,14
    80002c6a:	daefd0ef          	jal	ra,80000218 <strncmp>
}
    80002c6e:	60a2                	ld	ra,8(sp)
    80002c70:	6402                	ld	s0,0(sp)
    80002c72:	0141                	addi	sp,sp,16
    80002c74:	8082                	ret

0000000080002c76 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002c76:	7139                	addi	sp,sp,-64
    80002c78:	fc06                	sd	ra,56(sp)
    80002c7a:	f822                	sd	s0,48(sp)
    80002c7c:	f426                	sd	s1,40(sp)
    80002c7e:	f04a                	sd	s2,32(sp)
    80002c80:	ec4e                	sd	s3,24(sp)
    80002c82:	e852                	sd	s4,16(sp)
    80002c84:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002c86:	04451703          	lh	a4,68(a0)
    80002c8a:	4785                	li	a5,1
    80002c8c:	00f71a63          	bne	a4,a5,80002ca0 <dirlookup+0x2a>
    80002c90:	892a                	mv	s2,a0
    80002c92:	89ae                	mv	s3,a1
    80002c94:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c96:	457c                	lw	a5,76(a0)
    80002c98:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002c9a:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c9c:	e39d                	bnez	a5,80002cc2 <dirlookup+0x4c>
    80002c9e:	a095                	j	80002d02 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80002ca0:	00005517          	auipc	a0,0x5
    80002ca4:	95050513          	addi	a0,a0,-1712 # 800075f0 <syscalls+0x1a8>
    80002ca8:	00f020ef          	jal	ra,800054b6 <panic>
      panic("dirlookup read");
    80002cac:	00005517          	auipc	a0,0x5
    80002cb0:	95c50513          	addi	a0,a0,-1700 # 80007608 <syscalls+0x1c0>
    80002cb4:	003020ef          	jal	ra,800054b6 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002cb8:	24c1                	addiw	s1,s1,16
    80002cba:	04c92783          	lw	a5,76(s2)
    80002cbe:	04f4f163          	bgeu	s1,a5,80002d00 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002cc2:	4741                	li	a4,16
    80002cc4:	86a6                	mv	a3,s1
    80002cc6:	fc040613          	addi	a2,s0,-64
    80002cca:	4581                	li	a1,0
    80002ccc:	854a                	mv	a0,s2
    80002cce:	dadff0ef          	jal	ra,80002a7a <readi>
    80002cd2:	47c1                	li	a5,16
    80002cd4:	fcf51ce3          	bne	a0,a5,80002cac <dirlookup+0x36>
    if(de.inum == 0)
    80002cd8:	fc045783          	lhu	a5,-64(s0)
    80002cdc:	dff1                	beqz	a5,80002cb8 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80002cde:	fc240593          	addi	a1,s0,-62
    80002ce2:	854e                	mv	a0,s3
    80002ce4:	f7dff0ef          	jal	ra,80002c60 <namecmp>
    80002ce8:	f961                	bnez	a0,80002cb8 <dirlookup+0x42>
      if(poff)
    80002cea:	000a0463          	beqz	s4,80002cf2 <dirlookup+0x7c>
        *poff = off;
    80002cee:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80002cf2:	fc045583          	lhu	a1,-64(s0)
    80002cf6:	00092503          	lw	a0,0(s2)
    80002cfa:	859ff0ef          	jal	ra,80002552 <iget>
    80002cfe:	a011                	j	80002d02 <dirlookup+0x8c>
  return 0;
    80002d00:	4501                	li	a0,0
}
    80002d02:	70e2                	ld	ra,56(sp)
    80002d04:	7442                	ld	s0,48(sp)
    80002d06:	74a2                	ld	s1,40(sp)
    80002d08:	7902                	ld	s2,32(sp)
    80002d0a:	69e2                	ld	s3,24(sp)
    80002d0c:	6a42                	ld	s4,16(sp)
    80002d0e:	6121                	addi	sp,sp,64
    80002d10:	8082                	ret

0000000080002d12 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002d12:	711d                	addi	sp,sp,-96
    80002d14:	ec86                	sd	ra,88(sp)
    80002d16:	e8a2                	sd	s0,80(sp)
    80002d18:	e4a6                	sd	s1,72(sp)
    80002d1a:	e0ca                	sd	s2,64(sp)
    80002d1c:	fc4e                	sd	s3,56(sp)
    80002d1e:	f852                	sd	s4,48(sp)
    80002d20:	f456                	sd	s5,40(sp)
    80002d22:	f05a                	sd	s6,32(sp)
    80002d24:	ec5e                	sd	s7,24(sp)
    80002d26:	e862                	sd	s8,16(sp)
    80002d28:	e466                	sd	s9,8(sp)
    80002d2a:	1080                	addi	s0,sp,96
    80002d2c:	84aa                	mv	s1,a0
    80002d2e:	8aae                	mv	s5,a1
    80002d30:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002d32:	00054703          	lbu	a4,0(a0)
    80002d36:	02f00793          	li	a5,47
    80002d3a:	00f70f63          	beq	a4,a5,80002d58 <namex+0x46>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002d3e:	8e2fe0ef          	jal	ra,80000e20 <myproc>
    80002d42:	15853503          	ld	a0,344(a0)
    80002d46:	aafff0ef          	jal	ra,800027f4 <idup>
    80002d4a:	89aa                	mv	s3,a0
  while(*path == '/')
    80002d4c:	02f00913          	li	s2,47
  len = path - s;
    80002d50:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    80002d52:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002d54:	4b85                	li	s7,1
    80002d56:	a861                	j	80002dee <namex+0xdc>
    ip = iget(ROOTDEV, ROOTINO);
    80002d58:	4585                	li	a1,1
    80002d5a:	4505                	li	a0,1
    80002d5c:	ff6ff0ef          	jal	ra,80002552 <iget>
    80002d60:	89aa                	mv	s3,a0
    80002d62:	b7ed                	j	80002d4c <namex+0x3a>
      iunlockput(ip);
    80002d64:	854e                	mv	a0,s3
    80002d66:	ccbff0ef          	jal	ra,80002a30 <iunlockput>
      return 0;
    80002d6a:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002d6c:	854e                	mv	a0,s3
    80002d6e:	60e6                	ld	ra,88(sp)
    80002d70:	6446                	ld	s0,80(sp)
    80002d72:	64a6                	ld	s1,72(sp)
    80002d74:	6906                	ld	s2,64(sp)
    80002d76:	79e2                	ld	s3,56(sp)
    80002d78:	7a42                	ld	s4,48(sp)
    80002d7a:	7aa2                	ld	s5,40(sp)
    80002d7c:	7b02                	ld	s6,32(sp)
    80002d7e:	6be2                	ld	s7,24(sp)
    80002d80:	6c42                	ld	s8,16(sp)
    80002d82:	6ca2                	ld	s9,8(sp)
    80002d84:	6125                	addi	sp,sp,96
    80002d86:	8082                	ret
      iunlock(ip);
    80002d88:	854e                	mv	a0,s3
    80002d8a:	b4bff0ef          	jal	ra,800028d4 <iunlock>
      return ip;
    80002d8e:	bff9                	j	80002d6c <namex+0x5a>
      iunlockput(ip);
    80002d90:	854e                	mv	a0,s3
    80002d92:	c9fff0ef          	jal	ra,80002a30 <iunlockput>
      return 0;
    80002d96:	89e6                	mv	s3,s9
    80002d98:	bfd1                	j	80002d6c <namex+0x5a>
  len = path - s;
    80002d9a:	40b48633          	sub	a2,s1,a1
    80002d9e:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80002da2:	079c5c63          	bge	s8,s9,80002e1a <namex+0x108>
    memmove(name, s, DIRSIZ);
    80002da6:	4639                	li	a2,14
    80002da8:	8552                	mv	a0,s4
    80002daa:	bfefd0ef          	jal	ra,800001a8 <memmove>
  while(*path == '/')
    80002dae:	0004c783          	lbu	a5,0(s1)
    80002db2:	01279763          	bne	a5,s2,80002dc0 <namex+0xae>
    path++;
    80002db6:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002db8:	0004c783          	lbu	a5,0(s1)
    80002dbc:	ff278de3          	beq	a5,s2,80002db6 <namex+0xa4>
    ilock(ip);
    80002dc0:	854e                	mv	a0,s3
    80002dc2:	a69ff0ef          	jal	ra,8000282a <ilock>
    if(ip->type != T_DIR){
    80002dc6:	04499783          	lh	a5,68(s3)
    80002dca:	f9779de3          	bne	a5,s7,80002d64 <namex+0x52>
    if(nameiparent && *path == '\0'){
    80002dce:	000a8563          	beqz	s5,80002dd8 <namex+0xc6>
    80002dd2:	0004c783          	lbu	a5,0(s1)
    80002dd6:	dbcd                	beqz	a5,80002d88 <namex+0x76>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002dd8:	865a                	mv	a2,s6
    80002dda:	85d2                	mv	a1,s4
    80002ddc:	854e                	mv	a0,s3
    80002dde:	e99ff0ef          	jal	ra,80002c76 <dirlookup>
    80002de2:	8caa                	mv	s9,a0
    80002de4:	d555                	beqz	a0,80002d90 <namex+0x7e>
    iunlockput(ip);
    80002de6:	854e                	mv	a0,s3
    80002de8:	c49ff0ef          	jal	ra,80002a30 <iunlockput>
    ip = next;
    80002dec:	89e6                	mv	s3,s9
  while(*path == '/')
    80002dee:	0004c783          	lbu	a5,0(s1)
    80002df2:	05279363          	bne	a5,s2,80002e38 <namex+0x126>
    path++;
    80002df6:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002df8:	0004c783          	lbu	a5,0(s1)
    80002dfc:	ff278de3          	beq	a5,s2,80002df6 <namex+0xe4>
  if(*path == 0)
    80002e00:	c78d                	beqz	a5,80002e2a <namex+0x118>
    path++;
    80002e02:	85a6                	mv	a1,s1
  len = path - s;
    80002e04:	8cda                	mv	s9,s6
    80002e06:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    80002e08:	01278963          	beq	a5,s2,80002e1a <namex+0x108>
    80002e0c:	d7d9                	beqz	a5,80002d9a <namex+0x88>
    path++;
    80002e0e:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80002e10:	0004c783          	lbu	a5,0(s1)
    80002e14:	ff279ce3          	bne	a5,s2,80002e0c <namex+0xfa>
    80002e18:	b749                	j	80002d9a <namex+0x88>
    memmove(name, s, len);
    80002e1a:	2601                	sext.w	a2,a2
    80002e1c:	8552                	mv	a0,s4
    80002e1e:	b8afd0ef          	jal	ra,800001a8 <memmove>
    name[len] = 0;
    80002e22:	9cd2                	add	s9,s9,s4
    80002e24:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80002e28:	b759                	j	80002dae <namex+0x9c>
  if(nameiparent){
    80002e2a:	f40a81e3          	beqz	s5,80002d6c <namex+0x5a>
    iput(ip);
    80002e2e:	854e                	mv	a0,s3
    80002e30:	b79ff0ef          	jal	ra,800029a8 <iput>
    return 0;
    80002e34:	4981                	li	s3,0
    80002e36:	bf1d                	j	80002d6c <namex+0x5a>
  if(*path == 0)
    80002e38:	dbed                	beqz	a5,80002e2a <namex+0x118>
  while(*path != '/' && *path != 0)
    80002e3a:	0004c783          	lbu	a5,0(s1)
    80002e3e:	85a6                	mv	a1,s1
    80002e40:	b7f1                	j	80002e0c <namex+0xfa>

0000000080002e42 <dirlink>:
{
    80002e42:	7139                	addi	sp,sp,-64
    80002e44:	fc06                	sd	ra,56(sp)
    80002e46:	f822                	sd	s0,48(sp)
    80002e48:	f426                	sd	s1,40(sp)
    80002e4a:	f04a                	sd	s2,32(sp)
    80002e4c:	ec4e                	sd	s3,24(sp)
    80002e4e:	e852                	sd	s4,16(sp)
    80002e50:	0080                	addi	s0,sp,64
    80002e52:	892a                	mv	s2,a0
    80002e54:	8a2e                	mv	s4,a1
    80002e56:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002e58:	4601                	li	a2,0
    80002e5a:	e1dff0ef          	jal	ra,80002c76 <dirlookup>
    80002e5e:	e52d                	bnez	a0,80002ec8 <dirlink+0x86>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002e60:	04c92483          	lw	s1,76(s2)
    80002e64:	c48d                	beqz	s1,80002e8e <dirlink+0x4c>
    80002e66:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002e68:	4741                	li	a4,16
    80002e6a:	86a6                	mv	a3,s1
    80002e6c:	fc040613          	addi	a2,s0,-64
    80002e70:	4581                	li	a1,0
    80002e72:	854a                	mv	a0,s2
    80002e74:	c07ff0ef          	jal	ra,80002a7a <readi>
    80002e78:	47c1                	li	a5,16
    80002e7a:	04f51b63          	bne	a0,a5,80002ed0 <dirlink+0x8e>
    if(de.inum == 0)
    80002e7e:	fc045783          	lhu	a5,-64(s0)
    80002e82:	c791                	beqz	a5,80002e8e <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002e84:	24c1                	addiw	s1,s1,16
    80002e86:	04c92783          	lw	a5,76(s2)
    80002e8a:	fcf4efe3          	bltu	s1,a5,80002e68 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80002e8e:	4639                	li	a2,14
    80002e90:	85d2                	mv	a1,s4
    80002e92:	fc240513          	addi	a0,s0,-62
    80002e96:	bbefd0ef          	jal	ra,80000254 <strncpy>
  de.inum = inum;
    80002e9a:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002e9e:	4741                	li	a4,16
    80002ea0:	86a6                	mv	a3,s1
    80002ea2:	fc040613          	addi	a2,s0,-64
    80002ea6:	4581                	li	a1,0
    80002ea8:	854a                	mv	a0,s2
    80002eaa:	cb5ff0ef          	jal	ra,80002b5e <writei>
    80002eae:	1541                	addi	a0,a0,-16
    80002eb0:	00a03533          	snez	a0,a0
    80002eb4:	40a00533          	neg	a0,a0
}
    80002eb8:	70e2                	ld	ra,56(sp)
    80002eba:	7442                	ld	s0,48(sp)
    80002ebc:	74a2                	ld	s1,40(sp)
    80002ebe:	7902                	ld	s2,32(sp)
    80002ec0:	69e2                	ld	s3,24(sp)
    80002ec2:	6a42                	ld	s4,16(sp)
    80002ec4:	6121                	addi	sp,sp,64
    80002ec6:	8082                	ret
    iput(ip);
    80002ec8:	ae1ff0ef          	jal	ra,800029a8 <iput>
    return -1;
    80002ecc:	557d                	li	a0,-1
    80002ece:	b7ed                	j	80002eb8 <dirlink+0x76>
      panic("dirlink read");
    80002ed0:	00004517          	auipc	a0,0x4
    80002ed4:	74850513          	addi	a0,a0,1864 # 80007618 <syscalls+0x1d0>
    80002ed8:	5de020ef          	jal	ra,800054b6 <panic>

0000000080002edc <namei>:

struct inode*
namei(char *path)
{
    80002edc:	1101                	addi	sp,sp,-32
    80002ede:	ec06                	sd	ra,24(sp)
    80002ee0:	e822                	sd	s0,16(sp)
    80002ee2:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80002ee4:	fe040613          	addi	a2,s0,-32
    80002ee8:	4581                	li	a1,0
    80002eea:	e29ff0ef          	jal	ra,80002d12 <namex>
}
    80002eee:	60e2                	ld	ra,24(sp)
    80002ef0:	6442                	ld	s0,16(sp)
    80002ef2:	6105                	addi	sp,sp,32
    80002ef4:	8082                	ret

0000000080002ef6 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80002ef6:	1141                	addi	sp,sp,-16
    80002ef8:	e406                	sd	ra,8(sp)
    80002efa:	e022                	sd	s0,0(sp)
    80002efc:	0800                	addi	s0,sp,16
    80002efe:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80002f00:	4585                	li	a1,1
    80002f02:	e11ff0ef          	jal	ra,80002d12 <namex>
}
    80002f06:	60a2                	ld	ra,8(sp)
    80002f08:	6402                	ld	s0,0(sp)
    80002f0a:	0141                	addi	sp,sp,16
    80002f0c:	8082                	ret

0000000080002f0e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80002f0e:	1101                	addi	sp,sp,-32
    80002f10:	ec06                	sd	ra,24(sp)
    80002f12:	e822                	sd	s0,16(sp)
    80002f14:	e426                	sd	s1,8(sp)
    80002f16:	e04a                	sd	s2,0(sp)
    80002f18:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80002f1a:	00015917          	auipc	s2,0x15
    80002f1e:	c1690913          	addi	s2,s2,-1002 # 80017b30 <log>
    80002f22:	01892583          	lw	a1,24(s2)
    80002f26:	02892503          	lw	a0,40(s2)
    80002f2a:	9e2ff0ef          	jal	ra,8000210c <bread>
    80002f2e:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80002f30:	02c92683          	lw	a3,44(s2)
    80002f34:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80002f36:	02d05763          	blez	a3,80002f64 <write_head+0x56>
    80002f3a:	00015797          	auipc	a5,0x15
    80002f3e:	c2678793          	addi	a5,a5,-986 # 80017b60 <log+0x30>
    80002f42:	05c50713          	addi	a4,a0,92
    80002f46:	36fd                	addiw	a3,a3,-1
    80002f48:	1682                	slli	a3,a3,0x20
    80002f4a:	9281                	srli	a3,a3,0x20
    80002f4c:	068a                	slli	a3,a3,0x2
    80002f4e:	00015617          	auipc	a2,0x15
    80002f52:	c1660613          	addi	a2,a2,-1002 # 80017b64 <log+0x34>
    80002f56:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80002f58:	4390                	lw	a2,0(a5)
    80002f5a:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80002f5c:	0791                	addi	a5,a5,4
    80002f5e:	0711                	addi	a4,a4,4
    80002f60:	fed79ce3          	bne	a5,a3,80002f58 <write_head+0x4a>
  }
  bwrite(buf);
    80002f64:	8526                	mv	a0,s1
    80002f66:	a7cff0ef          	jal	ra,800021e2 <bwrite>
  brelse(buf);
    80002f6a:	8526                	mv	a0,s1
    80002f6c:	aa8ff0ef          	jal	ra,80002214 <brelse>
}
    80002f70:	60e2                	ld	ra,24(sp)
    80002f72:	6442                	ld	s0,16(sp)
    80002f74:	64a2                	ld	s1,8(sp)
    80002f76:	6902                	ld	s2,0(sp)
    80002f78:	6105                	addi	sp,sp,32
    80002f7a:	8082                	ret

0000000080002f7c <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80002f7c:	00015797          	auipc	a5,0x15
    80002f80:	be07a783          	lw	a5,-1056(a5) # 80017b5c <log+0x2c>
    80002f84:	08f05f63          	blez	a5,80003022 <install_trans+0xa6>
{
    80002f88:	7139                	addi	sp,sp,-64
    80002f8a:	fc06                	sd	ra,56(sp)
    80002f8c:	f822                	sd	s0,48(sp)
    80002f8e:	f426                	sd	s1,40(sp)
    80002f90:	f04a                	sd	s2,32(sp)
    80002f92:	ec4e                	sd	s3,24(sp)
    80002f94:	e852                	sd	s4,16(sp)
    80002f96:	e456                	sd	s5,8(sp)
    80002f98:	e05a                	sd	s6,0(sp)
    80002f9a:	0080                	addi	s0,sp,64
    80002f9c:	8b2a                	mv	s6,a0
    80002f9e:	00015a97          	auipc	s5,0x15
    80002fa2:	bc2a8a93          	addi	s5,s5,-1086 # 80017b60 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002fa6:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002fa8:	00015997          	auipc	s3,0x15
    80002fac:	b8898993          	addi	s3,s3,-1144 # 80017b30 <log>
    80002fb0:	a829                	j	80002fca <install_trans+0x4e>
    brelse(lbuf);
    80002fb2:	854a                	mv	a0,s2
    80002fb4:	a60ff0ef          	jal	ra,80002214 <brelse>
    brelse(dbuf);
    80002fb8:	8526                	mv	a0,s1
    80002fba:	a5aff0ef          	jal	ra,80002214 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002fbe:	2a05                	addiw	s4,s4,1
    80002fc0:	0a91                	addi	s5,s5,4
    80002fc2:	02c9a783          	lw	a5,44(s3)
    80002fc6:	04fa5463          	bge	s4,a5,8000300e <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002fca:	0189a583          	lw	a1,24(s3)
    80002fce:	014585bb          	addw	a1,a1,s4
    80002fd2:	2585                	addiw	a1,a1,1
    80002fd4:	0289a503          	lw	a0,40(s3)
    80002fd8:	934ff0ef          	jal	ra,8000210c <bread>
    80002fdc:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80002fde:	000aa583          	lw	a1,0(s5)
    80002fe2:	0289a503          	lw	a0,40(s3)
    80002fe6:	926ff0ef          	jal	ra,8000210c <bread>
    80002fea:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80002fec:	40000613          	li	a2,1024
    80002ff0:	05890593          	addi	a1,s2,88
    80002ff4:	05850513          	addi	a0,a0,88
    80002ff8:	9b0fd0ef          	jal	ra,800001a8 <memmove>
    bwrite(dbuf);  // write dst to disk
    80002ffc:	8526                	mv	a0,s1
    80002ffe:	9e4ff0ef          	jal	ra,800021e2 <bwrite>
    if(recovering == 0)
    80003002:	fa0b18e3          	bnez	s6,80002fb2 <install_trans+0x36>
      bunpin(dbuf);
    80003006:	8526                	mv	a0,s1
    80003008:	acaff0ef          	jal	ra,800022d2 <bunpin>
    8000300c:	b75d                	j	80002fb2 <install_trans+0x36>
}
    8000300e:	70e2                	ld	ra,56(sp)
    80003010:	7442                	ld	s0,48(sp)
    80003012:	74a2                	ld	s1,40(sp)
    80003014:	7902                	ld	s2,32(sp)
    80003016:	69e2                	ld	s3,24(sp)
    80003018:	6a42                	ld	s4,16(sp)
    8000301a:	6aa2                	ld	s5,8(sp)
    8000301c:	6b02                	ld	s6,0(sp)
    8000301e:	6121                	addi	sp,sp,64
    80003020:	8082                	ret
    80003022:	8082                	ret

0000000080003024 <initlog>:
{
    80003024:	7179                	addi	sp,sp,-48
    80003026:	f406                	sd	ra,40(sp)
    80003028:	f022                	sd	s0,32(sp)
    8000302a:	ec26                	sd	s1,24(sp)
    8000302c:	e84a                	sd	s2,16(sp)
    8000302e:	e44e                	sd	s3,8(sp)
    80003030:	1800                	addi	s0,sp,48
    80003032:	892a                	mv	s2,a0
    80003034:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003036:	00015497          	auipc	s1,0x15
    8000303a:	afa48493          	addi	s1,s1,-1286 # 80017b30 <log>
    8000303e:	00004597          	auipc	a1,0x4
    80003042:	5ea58593          	addi	a1,a1,1514 # 80007628 <syscalls+0x1e0>
    80003046:	8526                	mv	a0,s1
    80003048:	702020ef          	jal	ra,8000574a <initlock>
  log.start = sb->logstart;
    8000304c:	0149a583          	lw	a1,20(s3)
    80003050:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003052:	0109a783          	lw	a5,16(s3)
    80003056:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003058:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000305c:	854a                	mv	a0,s2
    8000305e:	8aeff0ef          	jal	ra,8000210c <bread>
  log.lh.n = lh->n;
    80003062:	4d34                	lw	a3,88(a0)
    80003064:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003066:	02d05563          	blez	a3,80003090 <initlog+0x6c>
    8000306a:	05c50793          	addi	a5,a0,92
    8000306e:	00015717          	auipc	a4,0x15
    80003072:	af270713          	addi	a4,a4,-1294 # 80017b60 <log+0x30>
    80003076:	36fd                	addiw	a3,a3,-1
    80003078:	1682                	slli	a3,a3,0x20
    8000307a:	9281                	srli	a3,a3,0x20
    8000307c:	068a                	slli	a3,a3,0x2
    8000307e:	06050613          	addi	a2,a0,96
    80003082:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80003084:	4390                	lw	a2,0(a5)
    80003086:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003088:	0791                	addi	a5,a5,4
    8000308a:	0711                	addi	a4,a4,4
    8000308c:	fed79ce3          	bne	a5,a3,80003084 <initlog+0x60>
  brelse(buf);
    80003090:	984ff0ef          	jal	ra,80002214 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003094:	4505                	li	a0,1
    80003096:	ee7ff0ef          	jal	ra,80002f7c <install_trans>
  log.lh.n = 0;
    8000309a:	00015797          	auipc	a5,0x15
    8000309e:	ac07a123          	sw	zero,-1342(a5) # 80017b5c <log+0x2c>
  write_head(); // clear the log
    800030a2:	e6dff0ef          	jal	ra,80002f0e <write_head>
}
    800030a6:	70a2                	ld	ra,40(sp)
    800030a8:	7402                	ld	s0,32(sp)
    800030aa:	64e2                	ld	s1,24(sp)
    800030ac:	6942                	ld	s2,16(sp)
    800030ae:	69a2                	ld	s3,8(sp)
    800030b0:	6145                	addi	sp,sp,48
    800030b2:	8082                	ret

00000000800030b4 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800030b4:	1101                	addi	sp,sp,-32
    800030b6:	ec06                	sd	ra,24(sp)
    800030b8:	e822                	sd	s0,16(sp)
    800030ba:	e426                	sd	s1,8(sp)
    800030bc:	e04a                	sd	s2,0(sp)
    800030be:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800030c0:	00015517          	auipc	a0,0x15
    800030c4:	a7050513          	addi	a0,a0,-1424 # 80017b30 <log>
    800030c8:	702020ef          	jal	ra,800057ca <acquire>
  while(1){
    if(log.committing){
    800030cc:	00015497          	auipc	s1,0x15
    800030d0:	a6448493          	addi	s1,s1,-1436 # 80017b30 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800030d4:	4979                	li	s2,30
    800030d6:	a029                	j	800030e0 <begin_op+0x2c>
      sleep(&log, &log.lock);
    800030d8:	85a6                	mv	a1,s1
    800030da:	8526                	mv	a0,s1
    800030dc:	ba2fe0ef          	jal	ra,8000147e <sleep>
    if(log.committing){
    800030e0:	50dc                	lw	a5,36(s1)
    800030e2:	fbfd                	bnez	a5,800030d8 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800030e4:	509c                	lw	a5,32(s1)
    800030e6:	0017871b          	addiw	a4,a5,1
    800030ea:	0007069b          	sext.w	a3,a4
    800030ee:	0027179b          	slliw	a5,a4,0x2
    800030f2:	9fb9                	addw	a5,a5,a4
    800030f4:	0017979b          	slliw	a5,a5,0x1
    800030f8:	54d8                	lw	a4,44(s1)
    800030fa:	9fb9                	addw	a5,a5,a4
    800030fc:	00f95763          	bge	s2,a5,8000310a <begin_op+0x56>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003100:	85a6                	mv	a1,s1
    80003102:	8526                	mv	a0,s1
    80003104:	b7afe0ef          	jal	ra,8000147e <sleep>
    80003108:	bfe1                	j	800030e0 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    8000310a:	00015517          	auipc	a0,0x15
    8000310e:	a2650513          	addi	a0,a0,-1498 # 80017b30 <log>
    80003112:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003114:	74e020ef          	jal	ra,80005862 <release>
      break;
    }
  }
}
    80003118:	60e2                	ld	ra,24(sp)
    8000311a:	6442                	ld	s0,16(sp)
    8000311c:	64a2                	ld	s1,8(sp)
    8000311e:	6902                	ld	s2,0(sp)
    80003120:	6105                	addi	sp,sp,32
    80003122:	8082                	ret

0000000080003124 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003124:	7139                	addi	sp,sp,-64
    80003126:	fc06                	sd	ra,56(sp)
    80003128:	f822                	sd	s0,48(sp)
    8000312a:	f426                	sd	s1,40(sp)
    8000312c:	f04a                	sd	s2,32(sp)
    8000312e:	ec4e                	sd	s3,24(sp)
    80003130:	e852                	sd	s4,16(sp)
    80003132:	e456                	sd	s5,8(sp)
    80003134:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003136:	00015497          	auipc	s1,0x15
    8000313a:	9fa48493          	addi	s1,s1,-1542 # 80017b30 <log>
    8000313e:	8526                	mv	a0,s1
    80003140:	68a020ef          	jal	ra,800057ca <acquire>
  log.outstanding -= 1;
    80003144:	509c                	lw	a5,32(s1)
    80003146:	37fd                	addiw	a5,a5,-1
    80003148:	0007891b          	sext.w	s2,a5
    8000314c:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000314e:	50dc                	lw	a5,36(s1)
    80003150:	ef9d                	bnez	a5,8000318e <end_op+0x6a>
    panic("log.committing");
  if(log.outstanding == 0){
    80003152:	04091463          	bnez	s2,8000319a <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003156:	00015497          	auipc	s1,0x15
    8000315a:	9da48493          	addi	s1,s1,-1574 # 80017b30 <log>
    8000315e:	4785                	li	a5,1
    80003160:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003162:	8526                	mv	a0,s1
    80003164:	6fe020ef          	jal	ra,80005862 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003168:	54dc                	lw	a5,44(s1)
    8000316a:	04f04b63          	bgtz	a5,800031c0 <end_op+0x9c>
    acquire(&log.lock);
    8000316e:	00015497          	auipc	s1,0x15
    80003172:	9c248493          	addi	s1,s1,-1598 # 80017b30 <log>
    80003176:	8526                	mv	a0,s1
    80003178:	652020ef          	jal	ra,800057ca <acquire>
    log.committing = 0;
    8000317c:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003180:	8526                	mv	a0,s1
    80003182:	b48fe0ef          	jal	ra,800014ca <wakeup>
    release(&log.lock);
    80003186:	8526                	mv	a0,s1
    80003188:	6da020ef          	jal	ra,80005862 <release>
}
    8000318c:	a00d                	j	800031ae <end_op+0x8a>
    panic("log.committing");
    8000318e:	00004517          	auipc	a0,0x4
    80003192:	4a250513          	addi	a0,a0,1186 # 80007630 <syscalls+0x1e8>
    80003196:	320020ef          	jal	ra,800054b6 <panic>
    wakeup(&log);
    8000319a:	00015497          	auipc	s1,0x15
    8000319e:	99648493          	addi	s1,s1,-1642 # 80017b30 <log>
    800031a2:	8526                	mv	a0,s1
    800031a4:	b26fe0ef          	jal	ra,800014ca <wakeup>
  release(&log.lock);
    800031a8:	8526                	mv	a0,s1
    800031aa:	6b8020ef          	jal	ra,80005862 <release>
}
    800031ae:	70e2                	ld	ra,56(sp)
    800031b0:	7442                	ld	s0,48(sp)
    800031b2:	74a2                	ld	s1,40(sp)
    800031b4:	7902                	ld	s2,32(sp)
    800031b6:	69e2                	ld	s3,24(sp)
    800031b8:	6a42                	ld	s4,16(sp)
    800031ba:	6aa2                	ld	s5,8(sp)
    800031bc:	6121                	addi	sp,sp,64
    800031be:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800031c0:	00015a97          	auipc	s5,0x15
    800031c4:	9a0a8a93          	addi	s5,s5,-1632 # 80017b60 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800031c8:	00015a17          	auipc	s4,0x15
    800031cc:	968a0a13          	addi	s4,s4,-1688 # 80017b30 <log>
    800031d0:	018a2583          	lw	a1,24(s4)
    800031d4:	012585bb          	addw	a1,a1,s2
    800031d8:	2585                	addiw	a1,a1,1
    800031da:	028a2503          	lw	a0,40(s4)
    800031de:	f2ffe0ef          	jal	ra,8000210c <bread>
    800031e2:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800031e4:	000aa583          	lw	a1,0(s5)
    800031e8:	028a2503          	lw	a0,40(s4)
    800031ec:	f21fe0ef          	jal	ra,8000210c <bread>
    800031f0:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800031f2:	40000613          	li	a2,1024
    800031f6:	05850593          	addi	a1,a0,88
    800031fa:	05848513          	addi	a0,s1,88
    800031fe:	fabfc0ef          	jal	ra,800001a8 <memmove>
    bwrite(to);  // write the log
    80003202:	8526                	mv	a0,s1
    80003204:	fdffe0ef          	jal	ra,800021e2 <bwrite>
    brelse(from);
    80003208:	854e                	mv	a0,s3
    8000320a:	80aff0ef          	jal	ra,80002214 <brelse>
    brelse(to);
    8000320e:	8526                	mv	a0,s1
    80003210:	804ff0ef          	jal	ra,80002214 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003214:	2905                	addiw	s2,s2,1
    80003216:	0a91                	addi	s5,s5,4
    80003218:	02ca2783          	lw	a5,44(s4)
    8000321c:	faf94ae3          	blt	s2,a5,800031d0 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003220:	cefff0ef          	jal	ra,80002f0e <write_head>
    install_trans(0); // Now install writes to home locations
    80003224:	4501                	li	a0,0
    80003226:	d57ff0ef          	jal	ra,80002f7c <install_trans>
    log.lh.n = 0;
    8000322a:	00015797          	auipc	a5,0x15
    8000322e:	9207a923          	sw	zero,-1742(a5) # 80017b5c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003232:	cddff0ef          	jal	ra,80002f0e <write_head>
    80003236:	bf25                	j	8000316e <end_op+0x4a>

0000000080003238 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003238:	1101                	addi	sp,sp,-32
    8000323a:	ec06                	sd	ra,24(sp)
    8000323c:	e822                	sd	s0,16(sp)
    8000323e:	e426                	sd	s1,8(sp)
    80003240:	e04a                	sd	s2,0(sp)
    80003242:	1000                	addi	s0,sp,32
    80003244:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003246:	00015917          	auipc	s2,0x15
    8000324a:	8ea90913          	addi	s2,s2,-1814 # 80017b30 <log>
    8000324e:	854a                	mv	a0,s2
    80003250:	57a020ef          	jal	ra,800057ca <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003254:	02c92603          	lw	a2,44(s2)
    80003258:	47f5                	li	a5,29
    8000325a:	06c7c363          	blt	a5,a2,800032c0 <log_write+0x88>
    8000325e:	00015797          	auipc	a5,0x15
    80003262:	8ee7a783          	lw	a5,-1810(a5) # 80017b4c <log+0x1c>
    80003266:	37fd                	addiw	a5,a5,-1
    80003268:	04f65c63          	bge	a2,a5,800032c0 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000326c:	00015797          	auipc	a5,0x15
    80003270:	8e47a783          	lw	a5,-1820(a5) # 80017b50 <log+0x20>
    80003274:	04f05c63          	blez	a5,800032cc <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003278:	4781                	li	a5,0
    8000327a:	04c05f63          	blez	a2,800032d8 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000327e:	44cc                	lw	a1,12(s1)
    80003280:	00015717          	auipc	a4,0x15
    80003284:	8e070713          	addi	a4,a4,-1824 # 80017b60 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003288:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000328a:	4314                	lw	a3,0(a4)
    8000328c:	04b68663          	beq	a3,a1,800032d8 <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    80003290:	2785                	addiw	a5,a5,1
    80003292:	0711                	addi	a4,a4,4
    80003294:	fef61be3          	bne	a2,a5,8000328a <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003298:	0621                	addi	a2,a2,8
    8000329a:	060a                	slli	a2,a2,0x2
    8000329c:	00015797          	auipc	a5,0x15
    800032a0:	89478793          	addi	a5,a5,-1900 # 80017b30 <log>
    800032a4:	963e                	add	a2,a2,a5
    800032a6:	44dc                	lw	a5,12(s1)
    800032a8:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800032aa:	8526                	mv	a0,s1
    800032ac:	ff3fe0ef          	jal	ra,8000229e <bpin>
    log.lh.n++;
    800032b0:	00015717          	auipc	a4,0x15
    800032b4:	88070713          	addi	a4,a4,-1920 # 80017b30 <log>
    800032b8:	575c                	lw	a5,44(a4)
    800032ba:	2785                	addiw	a5,a5,1
    800032bc:	d75c                	sw	a5,44(a4)
    800032be:	a815                	j	800032f2 <log_write+0xba>
    panic("too big a transaction");
    800032c0:	00004517          	auipc	a0,0x4
    800032c4:	38050513          	addi	a0,a0,896 # 80007640 <syscalls+0x1f8>
    800032c8:	1ee020ef          	jal	ra,800054b6 <panic>
    panic("log_write outside of trans");
    800032cc:	00004517          	auipc	a0,0x4
    800032d0:	38c50513          	addi	a0,a0,908 # 80007658 <syscalls+0x210>
    800032d4:	1e2020ef          	jal	ra,800054b6 <panic>
  log.lh.block[i] = b->blockno;
    800032d8:	00878713          	addi	a4,a5,8
    800032dc:	00271693          	slli	a3,a4,0x2
    800032e0:	00015717          	auipc	a4,0x15
    800032e4:	85070713          	addi	a4,a4,-1968 # 80017b30 <log>
    800032e8:	9736                	add	a4,a4,a3
    800032ea:	44d4                	lw	a3,12(s1)
    800032ec:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800032ee:	faf60ee3          	beq	a2,a5,800032aa <log_write+0x72>
  }
  release(&log.lock);
    800032f2:	00015517          	auipc	a0,0x15
    800032f6:	83e50513          	addi	a0,a0,-1986 # 80017b30 <log>
    800032fa:	568020ef          	jal	ra,80005862 <release>
}
    800032fe:	60e2                	ld	ra,24(sp)
    80003300:	6442                	ld	s0,16(sp)
    80003302:	64a2                	ld	s1,8(sp)
    80003304:	6902                	ld	s2,0(sp)
    80003306:	6105                	addi	sp,sp,32
    80003308:	8082                	ret

000000008000330a <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000330a:	1101                	addi	sp,sp,-32
    8000330c:	ec06                	sd	ra,24(sp)
    8000330e:	e822                	sd	s0,16(sp)
    80003310:	e426                	sd	s1,8(sp)
    80003312:	e04a                	sd	s2,0(sp)
    80003314:	1000                	addi	s0,sp,32
    80003316:	84aa                	mv	s1,a0
    80003318:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000331a:	00004597          	auipc	a1,0x4
    8000331e:	35e58593          	addi	a1,a1,862 # 80007678 <syscalls+0x230>
    80003322:	0521                	addi	a0,a0,8
    80003324:	426020ef          	jal	ra,8000574a <initlock>
  lk->name = name;
    80003328:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000332c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003330:	0204a423          	sw	zero,40(s1)
}
    80003334:	60e2                	ld	ra,24(sp)
    80003336:	6442                	ld	s0,16(sp)
    80003338:	64a2                	ld	s1,8(sp)
    8000333a:	6902                	ld	s2,0(sp)
    8000333c:	6105                	addi	sp,sp,32
    8000333e:	8082                	ret

0000000080003340 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003340:	1101                	addi	sp,sp,-32
    80003342:	ec06                	sd	ra,24(sp)
    80003344:	e822                	sd	s0,16(sp)
    80003346:	e426                	sd	s1,8(sp)
    80003348:	e04a                	sd	s2,0(sp)
    8000334a:	1000                	addi	s0,sp,32
    8000334c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000334e:	00850913          	addi	s2,a0,8
    80003352:	854a                	mv	a0,s2
    80003354:	476020ef          	jal	ra,800057ca <acquire>
  while (lk->locked) {
    80003358:	409c                	lw	a5,0(s1)
    8000335a:	c799                	beqz	a5,80003368 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    8000335c:	85ca                	mv	a1,s2
    8000335e:	8526                	mv	a0,s1
    80003360:	91efe0ef          	jal	ra,8000147e <sleep>
  while (lk->locked) {
    80003364:	409c                	lw	a5,0(s1)
    80003366:	fbfd                	bnez	a5,8000335c <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003368:	4785                	li	a5,1
    8000336a:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000336c:	ab5fd0ef          	jal	ra,80000e20 <myproc>
    80003370:	591c                	lw	a5,48(a0)
    80003372:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003374:	854a                	mv	a0,s2
    80003376:	4ec020ef          	jal	ra,80005862 <release>
}
    8000337a:	60e2                	ld	ra,24(sp)
    8000337c:	6442                	ld	s0,16(sp)
    8000337e:	64a2                	ld	s1,8(sp)
    80003380:	6902                	ld	s2,0(sp)
    80003382:	6105                	addi	sp,sp,32
    80003384:	8082                	ret

0000000080003386 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003386:	1101                	addi	sp,sp,-32
    80003388:	ec06                	sd	ra,24(sp)
    8000338a:	e822                	sd	s0,16(sp)
    8000338c:	e426                	sd	s1,8(sp)
    8000338e:	e04a                	sd	s2,0(sp)
    80003390:	1000                	addi	s0,sp,32
    80003392:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003394:	00850913          	addi	s2,a0,8
    80003398:	854a                	mv	a0,s2
    8000339a:	430020ef          	jal	ra,800057ca <acquire>
  lk->locked = 0;
    8000339e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800033a2:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800033a6:	8526                	mv	a0,s1
    800033a8:	922fe0ef          	jal	ra,800014ca <wakeup>
  release(&lk->lk);
    800033ac:	854a                	mv	a0,s2
    800033ae:	4b4020ef          	jal	ra,80005862 <release>
}
    800033b2:	60e2                	ld	ra,24(sp)
    800033b4:	6442                	ld	s0,16(sp)
    800033b6:	64a2                	ld	s1,8(sp)
    800033b8:	6902                	ld	s2,0(sp)
    800033ba:	6105                	addi	sp,sp,32
    800033bc:	8082                	ret

00000000800033be <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800033be:	7179                	addi	sp,sp,-48
    800033c0:	f406                	sd	ra,40(sp)
    800033c2:	f022                	sd	s0,32(sp)
    800033c4:	ec26                	sd	s1,24(sp)
    800033c6:	e84a                	sd	s2,16(sp)
    800033c8:	e44e                	sd	s3,8(sp)
    800033ca:	1800                	addi	s0,sp,48
    800033cc:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800033ce:	00850913          	addi	s2,a0,8
    800033d2:	854a                	mv	a0,s2
    800033d4:	3f6020ef          	jal	ra,800057ca <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800033d8:	409c                	lw	a5,0(s1)
    800033da:	ef89                	bnez	a5,800033f4 <holdingsleep+0x36>
    800033dc:	4481                	li	s1,0
  release(&lk->lk);
    800033de:	854a                	mv	a0,s2
    800033e0:	482020ef          	jal	ra,80005862 <release>
  return r;
}
    800033e4:	8526                	mv	a0,s1
    800033e6:	70a2                	ld	ra,40(sp)
    800033e8:	7402                	ld	s0,32(sp)
    800033ea:	64e2                	ld	s1,24(sp)
    800033ec:	6942                	ld	s2,16(sp)
    800033ee:	69a2                	ld	s3,8(sp)
    800033f0:	6145                	addi	sp,sp,48
    800033f2:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800033f4:	0284a983          	lw	s3,40(s1)
    800033f8:	a29fd0ef          	jal	ra,80000e20 <myproc>
    800033fc:	5904                	lw	s1,48(a0)
    800033fe:	413484b3          	sub	s1,s1,s3
    80003402:	0014b493          	seqz	s1,s1
    80003406:	bfe1                	j	800033de <holdingsleep+0x20>

0000000080003408 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003408:	1141                	addi	sp,sp,-16
    8000340a:	e406                	sd	ra,8(sp)
    8000340c:	e022                	sd	s0,0(sp)
    8000340e:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003410:	00004597          	auipc	a1,0x4
    80003414:	27858593          	addi	a1,a1,632 # 80007688 <syscalls+0x240>
    80003418:	00015517          	auipc	a0,0x15
    8000341c:	86050513          	addi	a0,a0,-1952 # 80017c78 <ftable>
    80003420:	32a020ef          	jal	ra,8000574a <initlock>
}
    80003424:	60a2                	ld	ra,8(sp)
    80003426:	6402                	ld	s0,0(sp)
    80003428:	0141                	addi	sp,sp,16
    8000342a:	8082                	ret

000000008000342c <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000342c:	1101                	addi	sp,sp,-32
    8000342e:	ec06                	sd	ra,24(sp)
    80003430:	e822                	sd	s0,16(sp)
    80003432:	e426                	sd	s1,8(sp)
    80003434:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003436:	00015517          	auipc	a0,0x15
    8000343a:	84250513          	addi	a0,a0,-1982 # 80017c78 <ftable>
    8000343e:	38c020ef          	jal	ra,800057ca <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003442:	00015497          	auipc	s1,0x15
    80003446:	84e48493          	addi	s1,s1,-1970 # 80017c90 <ftable+0x18>
    8000344a:	00015717          	auipc	a4,0x15
    8000344e:	7e670713          	addi	a4,a4,2022 # 80018c30 <disk>
    if(f->ref == 0){
    80003452:	40dc                	lw	a5,4(s1)
    80003454:	cf89                	beqz	a5,8000346e <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003456:	02848493          	addi	s1,s1,40
    8000345a:	fee49ce3          	bne	s1,a4,80003452 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000345e:	00015517          	auipc	a0,0x15
    80003462:	81a50513          	addi	a0,a0,-2022 # 80017c78 <ftable>
    80003466:	3fc020ef          	jal	ra,80005862 <release>
  return 0;
    8000346a:	4481                	li	s1,0
    8000346c:	a809                	j	8000347e <filealloc+0x52>
      f->ref = 1;
    8000346e:	4785                	li	a5,1
    80003470:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003472:	00015517          	auipc	a0,0x15
    80003476:	80650513          	addi	a0,a0,-2042 # 80017c78 <ftable>
    8000347a:	3e8020ef          	jal	ra,80005862 <release>
}
    8000347e:	8526                	mv	a0,s1
    80003480:	60e2                	ld	ra,24(sp)
    80003482:	6442                	ld	s0,16(sp)
    80003484:	64a2                	ld	s1,8(sp)
    80003486:	6105                	addi	sp,sp,32
    80003488:	8082                	ret

000000008000348a <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000348a:	1101                	addi	sp,sp,-32
    8000348c:	ec06                	sd	ra,24(sp)
    8000348e:	e822                	sd	s0,16(sp)
    80003490:	e426                	sd	s1,8(sp)
    80003492:	1000                	addi	s0,sp,32
    80003494:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003496:	00014517          	auipc	a0,0x14
    8000349a:	7e250513          	addi	a0,a0,2018 # 80017c78 <ftable>
    8000349e:	32c020ef          	jal	ra,800057ca <acquire>
  if(f->ref < 1)
    800034a2:	40dc                	lw	a5,4(s1)
    800034a4:	02f05063          	blez	a5,800034c4 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    800034a8:	2785                	addiw	a5,a5,1
    800034aa:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800034ac:	00014517          	auipc	a0,0x14
    800034b0:	7cc50513          	addi	a0,a0,1996 # 80017c78 <ftable>
    800034b4:	3ae020ef          	jal	ra,80005862 <release>
  return f;
}
    800034b8:	8526                	mv	a0,s1
    800034ba:	60e2                	ld	ra,24(sp)
    800034bc:	6442                	ld	s0,16(sp)
    800034be:	64a2                	ld	s1,8(sp)
    800034c0:	6105                	addi	sp,sp,32
    800034c2:	8082                	ret
    panic("filedup");
    800034c4:	00004517          	auipc	a0,0x4
    800034c8:	1cc50513          	addi	a0,a0,460 # 80007690 <syscalls+0x248>
    800034cc:	7eb010ef          	jal	ra,800054b6 <panic>

00000000800034d0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800034d0:	7139                	addi	sp,sp,-64
    800034d2:	fc06                	sd	ra,56(sp)
    800034d4:	f822                	sd	s0,48(sp)
    800034d6:	f426                	sd	s1,40(sp)
    800034d8:	f04a                	sd	s2,32(sp)
    800034da:	ec4e                	sd	s3,24(sp)
    800034dc:	e852                	sd	s4,16(sp)
    800034de:	e456                	sd	s5,8(sp)
    800034e0:	0080                	addi	s0,sp,64
    800034e2:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800034e4:	00014517          	auipc	a0,0x14
    800034e8:	79450513          	addi	a0,a0,1940 # 80017c78 <ftable>
    800034ec:	2de020ef          	jal	ra,800057ca <acquire>
  if(f->ref < 1)
    800034f0:	40dc                	lw	a5,4(s1)
    800034f2:	04f05963          	blez	a5,80003544 <fileclose+0x74>
    panic("fileclose");
  if(--f->ref > 0){
    800034f6:	37fd                	addiw	a5,a5,-1
    800034f8:	0007871b          	sext.w	a4,a5
    800034fc:	c0dc                	sw	a5,4(s1)
    800034fe:	04e04963          	bgtz	a4,80003550 <fileclose+0x80>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003502:	0004a903          	lw	s2,0(s1)
    80003506:	0094ca83          	lbu	s5,9(s1)
    8000350a:	0104ba03          	ld	s4,16(s1)
    8000350e:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003512:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003516:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    8000351a:	00014517          	auipc	a0,0x14
    8000351e:	75e50513          	addi	a0,a0,1886 # 80017c78 <ftable>
    80003522:	340020ef          	jal	ra,80005862 <release>

  if(ff.type == FD_PIPE){
    80003526:	4785                	li	a5,1
    80003528:	04f90363          	beq	s2,a5,8000356e <fileclose+0x9e>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    8000352c:	3979                	addiw	s2,s2,-2
    8000352e:	4785                	li	a5,1
    80003530:	0327e663          	bltu	a5,s2,8000355c <fileclose+0x8c>
    begin_op();
    80003534:	b81ff0ef          	jal	ra,800030b4 <begin_op>
    iput(ff.ip);
    80003538:	854e                	mv	a0,s3
    8000353a:	c6eff0ef          	jal	ra,800029a8 <iput>
    end_op();
    8000353e:	be7ff0ef          	jal	ra,80003124 <end_op>
    80003542:	a829                	j	8000355c <fileclose+0x8c>
    panic("fileclose");
    80003544:	00004517          	auipc	a0,0x4
    80003548:	15450513          	addi	a0,a0,340 # 80007698 <syscalls+0x250>
    8000354c:	76b010ef          	jal	ra,800054b6 <panic>
    release(&ftable.lock);
    80003550:	00014517          	auipc	a0,0x14
    80003554:	72850513          	addi	a0,a0,1832 # 80017c78 <ftable>
    80003558:	30a020ef          	jal	ra,80005862 <release>
  }
}
    8000355c:	70e2                	ld	ra,56(sp)
    8000355e:	7442                	ld	s0,48(sp)
    80003560:	74a2                	ld	s1,40(sp)
    80003562:	7902                	ld	s2,32(sp)
    80003564:	69e2                	ld	s3,24(sp)
    80003566:	6a42                	ld	s4,16(sp)
    80003568:	6aa2                	ld	s5,8(sp)
    8000356a:	6121                	addi	sp,sp,64
    8000356c:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    8000356e:	85d6                	mv	a1,s5
    80003570:	8552                	mv	a0,s4
    80003572:	2ec000ef          	jal	ra,8000385e <pipeclose>
    80003576:	b7dd                	j	8000355c <fileclose+0x8c>

0000000080003578 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003578:	715d                	addi	sp,sp,-80
    8000357a:	e486                	sd	ra,72(sp)
    8000357c:	e0a2                	sd	s0,64(sp)
    8000357e:	fc26                	sd	s1,56(sp)
    80003580:	f84a                	sd	s2,48(sp)
    80003582:	f44e                	sd	s3,40(sp)
    80003584:	0880                	addi	s0,sp,80
    80003586:	84aa                	mv	s1,a0
    80003588:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    8000358a:	897fd0ef          	jal	ra,80000e20 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    8000358e:	409c                	lw	a5,0(s1)
    80003590:	37f9                	addiw	a5,a5,-2
    80003592:	4705                	li	a4,1
    80003594:	02f76f63          	bltu	a4,a5,800035d2 <filestat+0x5a>
    80003598:	892a                	mv	s2,a0
    ilock(f->ip);
    8000359a:	6c88                	ld	a0,24(s1)
    8000359c:	a8eff0ef          	jal	ra,8000282a <ilock>
    stati(f->ip, &st);
    800035a0:	fb840593          	addi	a1,s0,-72
    800035a4:	6c88                	ld	a0,24(s1)
    800035a6:	caaff0ef          	jal	ra,80002a50 <stati>
    iunlock(f->ip);
    800035aa:	6c88                	ld	a0,24(s1)
    800035ac:	b28ff0ef          	jal	ra,800028d4 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800035b0:	46e1                	li	a3,24
    800035b2:	fb840613          	addi	a2,s0,-72
    800035b6:	85ce                	mv	a1,s3
    800035b8:	0d093503          	ld	a0,208(s2)
    800035bc:	c4afd0ef          	jal	ra,80000a06 <copyout>
    800035c0:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    800035c4:	60a6                	ld	ra,72(sp)
    800035c6:	6406                	ld	s0,64(sp)
    800035c8:	74e2                	ld	s1,56(sp)
    800035ca:	7942                	ld	s2,48(sp)
    800035cc:	79a2                	ld	s3,40(sp)
    800035ce:	6161                	addi	sp,sp,80
    800035d0:	8082                	ret
  return -1;
    800035d2:	557d                	li	a0,-1
    800035d4:	bfc5                	j	800035c4 <filestat+0x4c>

00000000800035d6 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800035d6:	7179                	addi	sp,sp,-48
    800035d8:	f406                	sd	ra,40(sp)
    800035da:	f022                	sd	s0,32(sp)
    800035dc:	ec26                	sd	s1,24(sp)
    800035de:	e84a                	sd	s2,16(sp)
    800035e0:	e44e                	sd	s3,8(sp)
    800035e2:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800035e4:	00854783          	lbu	a5,8(a0)
    800035e8:	cbc1                	beqz	a5,80003678 <fileread+0xa2>
    800035ea:	84aa                	mv	s1,a0
    800035ec:	89ae                	mv	s3,a1
    800035ee:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800035f0:	411c                	lw	a5,0(a0)
    800035f2:	4705                	li	a4,1
    800035f4:	04e78363          	beq	a5,a4,8000363a <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800035f8:	470d                	li	a4,3
    800035fa:	04e78563          	beq	a5,a4,80003644 <fileread+0x6e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800035fe:	4709                	li	a4,2
    80003600:	06e79663          	bne	a5,a4,8000366c <fileread+0x96>
    ilock(f->ip);
    80003604:	6d08                	ld	a0,24(a0)
    80003606:	a24ff0ef          	jal	ra,8000282a <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    8000360a:	874a                	mv	a4,s2
    8000360c:	5094                	lw	a3,32(s1)
    8000360e:	864e                	mv	a2,s3
    80003610:	4585                	li	a1,1
    80003612:	6c88                	ld	a0,24(s1)
    80003614:	c66ff0ef          	jal	ra,80002a7a <readi>
    80003618:	892a                	mv	s2,a0
    8000361a:	00a05563          	blez	a0,80003624 <fileread+0x4e>
      f->off += r;
    8000361e:	509c                	lw	a5,32(s1)
    80003620:	9fa9                	addw	a5,a5,a0
    80003622:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003624:	6c88                	ld	a0,24(s1)
    80003626:	aaeff0ef          	jal	ra,800028d4 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    8000362a:	854a                	mv	a0,s2
    8000362c:	70a2                	ld	ra,40(sp)
    8000362e:	7402                	ld	s0,32(sp)
    80003630:	64e2                	ld	s1,24(sp)
    80003632:	6942                	ld	s2,16(sp)
    80003634:	69a2                	ld	s3,8(sp)
    80003636:	6145                	addi	sp,sp,48
    80003638:	8082                	ret
    r = piperead(f->pipe, addr, n);
    8000363a:	6908                	ld	a0,16(a0)
    8000363c:	34e000ef          	jal	ra,8000398a <piperead>
    80003640:	892a                	mv	s2,a0
    80003642:	b7e5                	j	8000362a <fileread+0x54>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003644:	02451783          	lh	a5,36(a0)
    80003648:	03079693          	slli	a3,a5,0x30
    8000364c:	92c1                	srli	a3,a3,0x30
    8000364e:	4725                	li	a4,9
    80003650:	02d76663          	bltu	a4,a3,8000367c <fileread+0xa6>
    80003654:	0792                	slli	a5,a5,0x4
    80003656:	00014717          	auipc	a4,0x14
    8000365a:	58270713          	addi	a4,a4,1410 # 80017bd8 <devsw>
    8000365e:	97ba                	add	a5,a5,a4
    80003660:	639c                	ld	a5,0(a5)
    80003662:	cf99                	beqz	a5,80003680 <fileread+0xaa>
    r = devsw[f->major].read(1, addr, n);
    80003664:	4505                	li	a0,1
    80003666:	9782                	jalr	a5
    80003668:	892a                	mv	s2,a0
    8000366a:	b7c1                	j	8000362a <fileread+0x54>
    panic("fileread");
    8000366c:	00004517          	auipc	a0,0x4
    80003670:	03c50513          	addi	a0,a0,60 # 800076a8 <syscalls+0x260>
    80003674:	643010ef          	jal	ra,800054b6 <panic>
    return -1;
    80003678:	597d                	li	s2,-1
    8000367a:	bf45                	j	8000362a <fileread+0x54>
      return -1;
    8000367c:	597d                	li	s2,-1
    8000367e:	b775                	j	8000362a <fileread+0x54>
    80003680:	597d                	li	s2,-1
    80003682:	b765                	j	8000362a <fileread+0x54>

0000000080003684 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003684:	715d                	addi	sp,sp,-80
    80003686:	e486                	sd	ra,72(sp)
    80003688:	e0a2                	sd	s0,64(sp)
    8000368a:	fc26                	sd	s1,56(sp)
    8000368c:	f84a                	sd	s2,48(sp)
    8000368e:	f44e                	sd	s3,40(sp)
    80003690:	f052                	sd	s4,32(sp)
    80003692:	ec56                	sd	s5,24(sp)
    80003694:	e85a                	sd	s6,16(sp)
    80003696:	e45e                	sd	s7,8(sp)
    80003698:	e062                	sd	s8,0(sp)
    8000369a:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    8000369c:	00954783          	lbu	a5,9(a0)
    800036a0:	0e078863          	beqz	a5,80003790 <filewrite+0x10c>
    800036a4:	892a                	mv	s2,a0
    800036a6:	8aae                	mv	s5,a1
    800036a8:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800036aa:	411c                	lw	a5,0(a0)
    800036ac:	4705                	li	a4,1
    800036ae:	02e78263          	beq	a5,a4,800036d2 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800036b2:	470d                	li	a4,3
    800036b4:	02e78463          	beq	a5,a4,800036dc <filewrite+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800036b8:	4709                	li	a4,2
    800036ba:	0ce79563          	bne	a5,a4,80003784 <filewrite+0x100>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800036be:	0ac05163          	blez	a2,80003760 <filewrite+0xdc>
    int i = 0;
    800036c2:	4981                	li	s3,0
    800036c4:	6b05                	lui	s6,0x1
    800036c6:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    800036ca:	6b85                	lui	s7,0x1
    800036cc:	c00b8b9b          	addiw	s7,s7,-1024
    800036d0:	a041                	j	80003750 <filewrite+0xcc>
    ret = pipewrite(f->pipe, addr, n);
    800036d2:	6908                	ld	a0,16(a0)
    800036d4:	1e2000ef          	jal	ra,800038b6 <pipewrite>
    800036d8:	8a2a                	mv	s4,a0
    800036da:	a071                	j	80003766 <filewrite+0xe2>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800036dc:	02451783          	lh	a5,36(a0)
    800036e0:	03079693          	slli	a3,a5,0x30
    800036e4:	92c1                	srli	a3,a3,0x30
    800036e6:	4725                	li	a4,9
    800036e8:	0ad76663          	bltu	a4,a3,80003794 <filewrite+0x110>
    800036ec:	0792                	slli	a5,a5,0x4
    800036ee:	00014717          	auipc	a4,0x14
    800036f2:	4ea70713          	addi	a4,a4,1258 # 80017bd8 <devsw>
    800036f6:	97ba                	add	a5,a5,a4
    800036f8:	679c                	ld	a5,8(a5)
    800036fa:	cfd9                	beqz	a5,80003798 <filewrite+0x114>
    ret = devsw[f->major].write(1, addr, n);
    800036fc:	4505                	li	a0,1
    800036fe:	9782                	jalr	a5
    80003700:	8a2a                	mv	s4,a0
    80003702:	a095                	j	80003766 <filewrite+0xe2>
    80003704:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003708:	9adff0ef          	jal	ra,800030b4 <begin_op>
      ilock(f->ip);
    8000370c:	01893503          	ld	a0,24(s2)
    80003710:	91aff0ef          	jal	ra,8000282a <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003714:	8762                	mv	a4,s8
    80003716:	02092683          	lw	a3,32(s2)
    8000371a:	01598633          	add	a2,s3,s5
    8000371e:	4585                	li	a1,1
    80003720:	01893503          	ld	a0,24(s2)
    80003724:	c3aff0ef          	jal	ra,80002b5e <writei>
    80003728:	84aa                	mv	s1,a0
    8000372a:	00a05763          	blez	a0,80003738 <filewrite+0xb4>
        f->off += r;
    8000372e:	02092783          	lw	a5,32(s2)
    80003732:	9fa9                	addw	a5,a5,a0
    80003734:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003738:	01893503          	ld	a0,24(s2)
    8000373c:	998ff0ef          	jal	ra,800028d4 <iunlock>
      end_op();
    80003740:	9e5ff0ef          	jal	ra,80003124 <end_op>

      if(r != n1){
    80003744:	009c1f63          	bne	s8,s1,80003762 <filewrite+0xde>
        // error from writei
        break;
      }
      i += r;
    80003748:	013489bb          	addw	s3,s1,s3
    while(i < n){
    8000374c:	0149db63          	bge	s3,s4,80003762 <filewrite+0xde>
      int n1 = n - i;
    80003750:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003754:	84be                	mv	s1,a5
    80003756:	2781                	sext.w	a5,a5
    80003758:	fafb56e3          	bge	s6,a5,80003704 <filewrite+0x80>
    8000375c:	84de                	mv	s1,s7
    8000375e:	b75d                	j	80003704 <filewrite+0x80>
    int i = 0;
    80003760:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003762:	013a1f63          	bne	s4,s3,80003780 <filewrite+0xfc>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003766:	8552                	mv	a0,s4
    80003768:	60a6                	ld	ra,72(sp)
    8000376a:	6406                	ld	s0,64(sp)
    8000376c:	74e2                	ld	s1,56(sp)
    8000376e:	7942                	ld	s2,48(sp)
    80003770:	79a2                	ld	s3,40(sp)
    80003772:	7a02                	ld	s4,32(sp)
    80003774:	6ae2                	ld	s5,24(sp)
    80003776:	6b42                	ld	s6,16(sp)
    80003778:	6ba2                	ld	s7,8(sp)
    8000377a:	6c02                	ld	s8,0(sp)
    8000377c:	6161                	addi	sp,sp,80
    8000377e:	8082                	ret
    ret = (i == n ? n : -1);
    80003780:	5a7d                	li	s4,-1
    80003782:	b7d5                	j	80003766 <filewrite+0xe2>
    panic("filewrite");
    80003784:	00004517          	auipc	a0,0x4
    80003788:	f3450513          	addi	a0,a0,-204 # 800076b8 <syscalls+0x270>
    8000378c:	52b010ef          	jal	ra,800054b6 <panic>
    return -1;
    80003790:	5a7d                	li	s4,-1
    80003792:	bfd1                	j	80003766 <filewrite+0xe2>
      return -1;
    80003794:	5a7d                	li	s4,-1
    80003796:	bfc1                	j	80003766 <filewrite+0xe2>
    80003798:	5a7d                	li	s4,-1
    8000379a:	b7f1                	j	80003766 <filewrite+0xe2>

000000008000379c <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    8000379c:	7179                	addi	sp,sp,-48
    8000379e:	f406                	sd	ra,40(sp)
    800037a0:	f022                	sd	s0,32(sp)
    800037a2:	ec26                	sd	s1,24(sp)
    800037a4:	e84a                	sd	s2,16(sp)
    800037a6:	e44e                	sd	s3,8(sp)
    800037a8:	e052                	sd	s4,0(sp)
    800037aa:	1800                	addi	s0,sp,48
    800037ac:	84aa                	mv	s1,a0
    800037ae:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800037b0:	0005b023          	sd	zero,0(a1)
    800037b4:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800037b8:	c75ff0ef          	jal	ra,8000342c <filealloc>
    800037bc:	e088                	sd	a0,0(s1)
    800037be:	cd35                	beqz	a0,8000383a <pipealloc+0x9e>
    800037c0:	c6dff0ef          	jal	ra,8000342c <filealloc>
    800037c4:	00aa3023          	sd	a0,0(s4)
    800037c8:	c52d                	beqz	a0,80003832 <pipealloc+0x96>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800037ca:	933fc0ef          	jal	ra,800000fc <kalloc>
    800037ce:	892a                	mv	s2,a0
    800037d0:	cd31                	beqz	a0,8000382c <pipealloc+0x90>
    goto bad;
  pi->readopen = 1;
    800037d2:	4985                	li	s3,1
    800037d4:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800037d8:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800037dc:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800037e0:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800037e4:	00004597          	auipc	a1,0x4
    800037e8:	ee458593          	addi	a1,a1,-284 # 800076c8 <syscalls+0x280>
    800037ec:	75f010ef          	jal	ra,8000574a <initlock>
  (*f0)->type = FD_PIPE;
    800037f0:	609c                	ld	a5,0(s1)
    800037f2:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800037f6:	609c                	ld	a5,0(s1)
    800037f8:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800037fc:	609c                	ld	a5,0(s1)
    800037fe:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003802:	609c                	ld	a5,0(s1)
    80003804:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003808:	000a3783          	ld	a5,0(s4)
    8000380c:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003810:	000a3783          	ld	a5,0(s4)
    80003814:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003818:	000a3783          	ld	a5,0(s4)
    8000381c:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003820:	000a3783          	ld	a5,0(s4)
    80003824:	0127b823          	sd	s2,16(a5)
  return 0;
    80003828:	4501                	li	a0,0
    8000382a:	a005                	j	8000384a <pipealloc+0xae>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    8000382c:	6088                	ld	a0,0(s1)
    8000382e:	e501                	bnez	a0,80003836 <pipealloc+0x9a>
    80003830:	a029                	j	8000383a <pipealloc+0x9e>
    80003832:	6088                	ld	a0,0(s1)
    80003834:	c11d                	beqz	a0,8000385a <pipealloc+0xbe>
    fileclose(*f0);
    80003836:	c9bff0ef          	jal	ra,800034d0 <fileclose>
  if(*f1)
    8000383a:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    8000383e:	557d                	li	a0,-1
  if(*f1)
    80003840:	c789                	beqz	a5,8000384a <pipealloc+0xae>
    fileclose(*f1);
    80003842:	853e                	mv	a0,a5
    80003844:	c8dff0ef          	jal	ra,800034d0 <fileclose>
  return -1;
    80003848:	557d                	li	a0,-1
}
    8000384a:	70a2                	ld	ra,40(sp)
    8000384c:	7402                	ld	s0,32(sp)
    8000384e:	64e2                	ld	s1,24(sp)
    80003850:	6942                	ld	s2,16(sp)
    80003852:	69a2                	ld	s3,8(sp)
    80003854:	6a02                	ld	s4,0(sp)
    80003856:	6145                	addi	sp,sp,48
    80003858:	8082                	ret
  return -1;
    8000385a:	557d                	li	a0,-1
    8000385c:	b7fd                	j	8000384a <pipealloc+0xae>

000000008000385e <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    8000385e:	1101                	addi	sp,sp,-32
    80003860:	ec06                	sd	ra,24(sp)
    80003862:	e822                	sd	s0,16(sp)
    80003864:	e426                	sd	s1,8(sp)
    80003866:	e04a                	sd	s2,0(sp)
    80003868:	1000                	addi	s0,sp,32
    8000386a:	84aa                	mv	s1,a0
    8000386c:	892e                	mv	s2,a1
  acquire(&pi->lock);
    8000386e:	75d010ef          	jal	ra,800057ca <acquire>
  if(writable){
    80003872:	02090763          	beqz	s2,800038a0 <pipeclose+0x42>
    pi->writeopen = 0;
    80003876:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    8000387a:	21848513          	addi	a0,s1,536
    8000387e:	c4dfd0ef          	jal	ra,800014ca <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003882:	2204b783          	ld	a5,544(s1)
    80003886:	e785                	bnez	a5,800038ae <pipeclose+0x50>
    release(&pi->lock);
    80003888:	8526                	mv	a0,s1
    8000388a:	7d9010ef          	jal	ra,80005862 <release>
    kfree((char*)pi);
    8000388e:	8526                	mv	a0,s1
    80003890:	f8cfc0ef          	jal	ra,8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003894:	60e2                	ld	ra,24(sp)
    80003896:	6442                	ld	s0,16(sp)
    80003898:	64a2                	ld	s1,8(sp)
    8000389a:	6902                	ld	s2,0(sp)
    8000389c:	6105                	addi	sp,sp,32
    8000389e:	8082                	ret
    pi->readopen = 0;
    800038a0:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800038a4:	21c48513          	addi	a0,s1,540
    800038a8:	c23fd0ef          	jal	ra,800014ca <wakeup>
    800038ac:	bfd9                	j	80003882 <pipeclose+0x24>
    release(&pi->lock);
    800038ae:	8526                	mv	a0,s1
    800038b0:	7b3010ef          	jal	ra,80005862 <release>
}
    800038b4:	b7c5                	j	80003894 <pipeclose+0x36>

00000000800038b6 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800038b6:	711d                	addi	sp,sp,-96
    800038b8:	ec86                	sd	ra,88(sp)
    800038ba:	e8a2                	sd	s0,80(sp)
    800038bc:	e4a6                	sd	s1,72(sp)
    800038be:	e0ca                	sd	s2,64(sp)
    800038c0:	fc4e                	sd	s3,56(sp)
    800038c2:	f852                	sd	s4,48(sp)
    800038c4:	f456                	sd	s5,40(sp)
    800038c6:	f05a                	sd	s6,32(sp)
    800038c8:	ec5e                	sd	s7,24(sp)
    800038ca:	e862                	sd	s8,16(sp)
    800038cc:	1080                	addi	s0,sp,96
    800038ce:	84aa                	mv	s1,a0
    800038d0:	8aae                	mv	s5,a1
    800038d2:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800038d4:	d4cfd0ef          	jal	ra,80000e20 <myproc>
    800038d8:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800038da:	8526                	mv	a0,s1
    800038dc:	6ef010ef          	jal	ra,800057ca <acquire>
  while(i < n){
    800038e0:	09405c63          	blez	s4,80003978 <pipewrite+0xc2>
  int i = 0;
    800038e4:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800038e6:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800038e8:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800038ec:	21c48b93          	addi	s7,s1,540
    800038f0:	a81d                	j	80003926 <pipewrite+0x70>
      release(&pi->lock);
    800038f2:	8526                	mv	a0,s1
    800038f4:	76f010ef          	jal	ra,80005862 <release>
      return -1;
    800038f8:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800038fa:	854a                	mv	a0,s2
    800038fc:	60e6                	ld	ra,88(sp)
    800038fe:	6446                	ld	s0,80(sp)
    80003900:	64a6                	ld	s1,72(sp)
    80003902:	6906                	ld	s2,64(sp)
    80003904:	79e2                	ld	s3,56(sp)
    80003906:	7a42                	ld	s4,48(sp)
    80003908:	7aa2                	ld	s5,40(sp)
    8000390a:	7b02                	ld	s6,32(sp)
    8000390c:	6be2                	ld	s7,24(sp)
    8000390e:	6c42                	ld	s8,16(sp)
    80003910:	6125                	addi	sp,sp,96
    80003912:	8082                	ret
      wakeup(&pi->nread);
    80003914:	8562                	mv	a0,s8
    80003916:	bb5fd0ef          	jal	ra,800014ca <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000391a:	85a6                	mv	a1,s1
    8000391c:	855e                	mv	a0,s7
    8000391e:	b61fd0ef          	jal	ra,8000147e <sleep>
  while(i < n){
    80003922:	05495c63          	bge	s2,s4,8000397a <pipewrite+0xc4>
    if(pi->readopen == 0 || killed(pr)){
    80003926:	2204a783          	lw	a5,544(s1)
    8000392a:	d7e1                	beqz	a5,800038f2 <pipewrite+0x3c>
    8000392c:	854e                	mv	a0,s3
    8000392e:	d89fd0ef          	jal	ra,800016b6 <killed>
    80003932:	f161                	bnez	a0,800038f2 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003934:	2184a783          	lw	a5,536(s1)
    80003938:	21c4a703          	lw	a4,540(s1)
    8000393c:	2007879b          	addiw	a5,a5,512
    80003940:	fcf70ae3          	beq	a4,a5,80003914 <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003944:	4685                	li	a3,1
    80003946:	01590633          	add	a2,s2,s5
    8000394a:	faf40593          	addi	a1,s0,-81
    8000394e:	0d09b503          	ld	a0,208(s3)
    80003952:	96cfd0ef          	jal	ra,80000abe <copyin>
    80003956:	03650263          	beq	a0,s6,8000397a <pipewrite+0xc4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000395a:	21c4a783          	lw	a5,540(s1)
    8000395e:	0017871b          	addiw	a4,a5,1
    80003962:	20e4ae23          	sw	a4,540(s1)
    80003966:	1ff7f793          	andi	a5,a5,511
    8000396a:	97a6                	add	a5,a5,s1
    8000396c:	faf44703          	lbu	a4,-81(s0)
    80003970:	00e78c23          	sb	a4,24(a5)
      i++;
    80003974:	2905                	addiw	s2,s2,1
    80003976:	b775                	j	80003922 <pipewrite+0x6c>
  int i = 0;
    80003978:	4901                	li	s2,0
  wakeup(&pi->nread);
    8000397a:	21848513          	addi	a0,s1,536
    8000397e:	b4dfd0ef          	jal	ra,800014ca <wakeup>
  release(&pi->lock);
    80003982:	8526                	mv	a0,s1
    80003984:	6df010ef          	jal	ra,80005862 <release>
  return i;
    80003988:	bf8d                	j	800038fa <pipewrite+0x44>

000000008000398a <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000398a:	715d                	addi	sp,sp,-80
    8000398c:	e486                	sd	ra,72(sp)
    8000398e:	e0a2                	sd	s0,64(sp)
    80003990:	fc26                	sd	s1,56(sp)
    80003992:	f84a                	sd	s2,48(sp)
    80003994:	f44e                	sd	s3,40(sp)
    80003996:	f052                	sd	s4,32(sp)
    80003998:	ec56                	sd	s5,24(sp)
    8000399a:	e85a                	sd	s6,16(sp)
    8000399c:	0880                	addi	s0,sp,80
    8000399e:	84aa                	mv	s1,a0
    800039a0:	892e                	mv	s2,a1
    800039a2:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800039a4:	c7cfd0ef          	jal	ra,80000e20 <myproc>
    800039a8:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800039aa:	8526                	mv	a0,s1
    800039ac:	61f010ef          	jal	ra,800057ca <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800039b0:	2184a703          	lw	a4,536(s1)
    800039b4:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800039b8:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800039bc:	02f71363          	bne	a4,a5,800039e2 <piperead+0x58>
    800039c0:	2244a783          	lw	a5,548(s1)
    800039c4:	cf99                	beqz	a5,800039e2 <piperead+0x58>
    if(killed(pr)){
    800039c6:	8552                	mv	a0,s4
    800039c8:	ceffd0ef          	jal	ra,800016b6 <killed>
    800039cc:	e141                	bnez	a0,80003a4c <piperead+0xc2>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800039ce:	85a6                	mv	a1,s1
    800039d0:	854e                	mv	a0,s3
    800039d2:	aadfd0ef          	jal	ra,8000147e <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800039d6:	2184a703          	lw	a4,536(s1)
    800039da:	21c4a783          	lw	a5,540(s1)
    800039de:	fef701e3          	beq	a4,a5,800039c0 <piperead+0x36>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800039e2:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800039e4:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800039e6:	05505163          	blez	s5,80003a28 <piperead+0x9e>
    if(pi->nread == pi->nwrite)
    800039ea:	2184a783          	lw	a5,536(s1)
    800039ee:	21c4a703          	lw	a4,540(s1)
    800039f2:	02f70b63          	beq	a4,a5,80003a28 <piperead+0x9e>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800039f6:	0017871b          	addiw	a4,a5,1
    800039fa:	20e4ac23          	sw	a4,536(s1)
    800039fe:	1ff7f793          	andi	a5,a5,511
    80003a02:	97a6                	add	a5,a5,s1
    80003a04:	0187c783          	lbu	a5,24(a5)
    80003a08:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003a0c:	4685                	li	a3,1
    80003a0e:	fbf40613          	addi	a2,s0,-65
    80003a12:	85ca                	mv	a1,s2
    80003a14:	0d0a3503          	ld	a0,208(s4)
    80003a18:	feffc0ef          	jal	ra,80000a06 <copyout>
    80003a1c:	01650663          	beq	a0,s6,80003a28 <piperead+0x9e>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003a20:	2985                	addiw	s3,s3,1
    80003a22:	0905                	addi	s2,s2,1
    80003a24:	fd3a93e3          	bne	s5,s3,800039ea <piperead+0x60>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003a28:	21c48513          	addi	a0,s1,540
    80003a2c:	a9ffd0ef          	jal	ra,800014ca <wakeup>
  release(&pi->lock);
    80003a30:	8526                	mv	a0,s1
    80003a32:	631010ef          	jal	ra,80005862 <release>
  return i;
}
    80003a36:	854e                	mv	a0,s3
    80003a38:	60a6                	ld	ra,72(sp)
    80003a3a:	6406                	ld	s0,64(sp)
    80003a3c:	74e2                	ld	s1,56(sp)
    80003a3e:	7942                	ld	s2,48(sp)
    80003a40:	79a2                	ld	s3,40(sp)
    80003a42:	7a02                	ld	s4,32(sp)
    80003a44:	6ae2                	ld	s5,24(sp)
    80003a46:	6b42                	ld	s6,16(sp)
    80003a48:	6161                	addi	sp,sp,80
    80003a4a:	8082                	ret
      release(&pi->lock);
    80003a4c:	8526                	mv	a0,s1
    80003a4e:	615010ef          	jal	ra,80005862 <release>
      return -1;
    80003a52:	59fd                	li	s3,-1
    80003a54:	b7cd                	j	80003a36 <piperead+0xac>

0000000080003a56 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80003a56:	1141                	addi	sp,sp,-16
    80003a58:	e422                	sd	s0,8(sp)
    80003a5a:	0800                	addi	s0,sp,16
    80003a5c:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003a5e:	8905                	andi	a0,a0,1
    80003a60:	c111                	beqz	a0,80003a64 <flags2perm+0xe>
      perm = PTE_X;
    80003a62:	4521                	li	a0,8
    if(flags & 0x2)
    80003a64:	8b89                	andi	a5,a5,2
    80003a66:	c399                	beqz	a5,80003a6c <flags2perm+0x16>
      perm |= PTE_W;
    80003a68:	00456513          	ori	a0,a0,4
    return perm;
}
    80003a6c:	6422                	ld	s0,8(sp)
    80003a6e:	0141                	addi	sp,sp,16
    80003a70:	8082                	ret

0000000080003a72 <exec>:

int
exec(char *path, char **argv)
{
    80003a72:	de010113          	addi	sp,sp,-544
    80003a76:	20113c23          	sd	ra,536(sp)
    80003a7a:	20813823          	sd	s0,528(sp)
    80003a7e:	20913423          	sd	s1,520(sp)
    80003a82:	21213023          	sd	s2,512(sp)
    80003a86:	ffce                	sd	s3,504(sp)
    80003a88:	fbd2                	sd	s4,496(sp)
    80003a8a:	f7d6                	sd	s5,488(sp)
    80003a8c:	f3da                	sd	s6,480(sp)
    80003a8e:	efde                	sd	s7,472(sp)
    80003a90:	ebe2                	sd	s8,464(sp)
    80003a92:	e7e6                	sd	s9,456(sp)
    80003a94:	e3ea                	sd	s10,448(sp)
    80003a96:	ff6e                	sd	s11,440(sp)
    80003a98:	1400                	addi	s0,sp,544
    80003a9a:	892a                	mv	s2,a0
    80003a9c:	dea43423          	sd	a0,-536(s0)
    80003aa0:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003aa4:	b7cfd0ef          	jal	ra,80000e20 <myproc>
    80003aa8:	84aa                	mv	s1,a0

  begin_op();
    80003aaa:	e0aff0ef          	jal	ra,800030b4 <begin_op>

  if((ip = namei(path)) == 0){
    80003aae:	854a                	mv	a0,s2
    80003ab0:	c2cff0ef          	jal	ra,80002edc <namei>
    80003ab4:	c13d                	beqz	a0,80003b1a <exec+0xa8>
    80003ab6:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003ab8:	d73fe0ef          	jal	ra,8000282a <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003abc:	04000713          	li	a4,64
    80003ac0:	4681                	li	a3,0
    80003ac2:	e5040613          	addi	a2,s0,-432
    80003ac6:	4581                	li	a1,0
    80003ac8:	8556                	mv	a0,s5
    80003aca:	fb1fe0ef          	jal	ra,80002a7a <readi>
    80003ace:	04000793          	li	a5,64
    80003ad2:	00f51a63          	bne	a0,a5,80003ae6 <exec+0x74>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80003ad6:	e5042703          	lw	a4,-432(s0)
    80003ada:	464c47b7          	lui	a5,0x464c4
    80003ade:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003ae2:	04f70063          	beq	a4,a5,80003b22 <exec+0xb0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003ae6:	8556                	mv	a0,s5
    80003ae8:	f49fe0ef          	jal	ra,80002a30 <iunlockput>
    end_op();
    80003aec:	e38ff0ef          	jal	ra,80003124 <end_op>
  }
  return -1;
    80003af0:	557d                	li	a0,-1
}
    80003af2:	21813083          	ld	ra,536(sp)
    80003af6:	21013403          	ld	s0,528(sp)
    80003afa:	20813483          	ld	s1,520(sp)
    80003afe:	20013903          	ld	s2,512(sp)
    80003b02:	79fe                	ld	s3,504(sp)
    80003b04:	7a5e                	ld	s4,496(sp)
    80003b06:	7abe                	ld	s5,488(sp)
    80003b08:	7b1e                	ld	s6,480(sp)
    80003b0a:	6bfe                	ld	s7,472(sp)
    80003b0c:	6c5e                	ld	s8,464(sp)
    80003b0e:	6cbe                	ld	s9,456(sp)
    80003b10:	6d1e                	ld	s10,448(sp)
    80003b12:	7dfa                	ld	s11,440(sp)
    80003b14:	22010113          	addi	sp,sp,544
    80003b18:	8082                	ret
    end_op();
    80003b1a:	e0aff0ef          	jal	ra,80003124 <end_op>
    return -1;
    80003b1e:	557d                	li	a0,-1
    80003b20:	bfc9                	j	80003af2 <exec+0x80>
  if((pagetable = proc_pagetable(p)) == 0)
    80003b22:	8526                	mv	a0,s1
    80003b24:	ba4fd0ef          	jal	ra,80000ec8 <proc_pagetable>
    80003b28:	8b2a                	mv	s6,a0
    80003b2a:	dd55                	beqz	a0,80003ae6 <exec+0x74>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003b2c:	e7042783          	lw	a5,-400(s0)
    80003b30:	e8845703          	lhu	a4,-376(s0)
    80003b34:	c325                	beqz	a4,80003b94 <exec+0x122>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003b36:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003b38:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    80003b3c:	6a05                	lui	s4,0x1
    80003b3e:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80003b42:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    80003b46:	6d85                	lui	s11,0x1
    80003b48:	7d7d                	lui	s10,0xfffff
    80003b4a:	ac21                	j	80003d62 <exec+0x2f0>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80003b4c:	00004517          	auipc	a0,0x4
    80003b50:	b8450513          	addi	a0,a0,-1148 # 800076d0 <syscalls+0x288>
    80003b54:	163010ef          	jal	ra,800054b6 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003b58:	874a                	mv	a4,s2
    80003b5a:	009c86bb          	addw	a3,s9,s1
    80003b5e:	4581                	li	a1,0
    80003b60:	8556                	mv	a0,s5
    80003b62:	f19fe0ef          	jal	ra,80002a7a <readi>
    80003b66:	2501                	sext.w	a0,a0
    80003b68:	18a91c63          	bne	s2,a0,80003d00 <exec+0x28e>
  for(i = 0; i < sz; i += PGSIZE){
    80003b6c:	009d84bb          	addw	s1,s11,s1
    80003b70:	013d09bb          	addw	s3,s10,s3
    80003b74:	1d74f763          	bgeu	s1,s7,80003d42 <exec+0x2d0>
    pa = walkaddr(pagetable, va + i);
    80003b78:	02049593          	slli	a1,s1,0x20
    80003b7c:	9181                	srli	a1,a1,0x20
    80003b7e:	95e2                	add	a1,a1,s8
    80003b80:	855a                	mv	a0,s6
    80003b82:	8e1fc0ef          	jal	ra,80000462 <walkaddr>
    80003b86:	862a                	mv	a2,a0
    if(pa == 0)
    80003b88:	d171                	beqz	a0,80003b4c <exec+0xda>
      n = PGSIZE;
    80003b8a:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    80003b8c:	fd49f6e3          	bgeu	s3,s4,80003b58 <exec+0xe6>
      n = sz - i;
    80003b90:	894e                	mv	s2,s3
    80003b92:	b7d9                	j	80003b58 <exec+0xe6>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003b94:	4901                	li	s2,0
  iunlockput(ip);
    80003b96:	8556                	mv	a0,s5
    80003b98:	e99fe0ef          	jal	ra,80002a30 <iunlockput>
  end_op();
    80003b9c:	d88ff0ef          	jal	ra,80003124 <end_op>
  p = myproc();
    80003ba0:	a80fd0ef          	jal	ra,80000e20 <myproc>
    80003ba4:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80003ba6:	0c853d03          	ld	s10,200(a0)
  sz = PGROUNDUP(sz);
    80003baa:	6785                	lui	a5,0x1
    80003bac:	17fd                	addi	a5,a5,-1
    80003bae:	993e                	add	s2,s2,a5
    80003bb0:	77fd                	lui	a5,0xfffff
    80003bb2:	00f977b3          	and	a5,s2,a5
    80003bb6:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003bba:	4691                	li	a3,4
    80003bbc:	660d                	lui	a2,0x3
    80003bbe:	963e                	add	a2,a2,a5
    80003bc0:	85be                	mv	a1,a5
    80003bc2:	855a                	mv	a0,s6
    80003bc4:	bf7fc0ef          	jal	ra,800007ba <uvmalloc>
    80003bc8:	8c2a                	mv	s8,a0
  ip = 0;
    80003bca:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003bcc:	12050a63          	beqz	a0,80003d00 <exec+0x28e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003bd0:	75f5                	lui	a1,0xffffd
    80003bd2:	95aa                	add	a1,a1,a0
    80003bd4:	855a                	mv	a0,s6
    80003bd6:	e07fc0ef          	jal	ra,800009dc <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003bda:	7af9                	lui	s5,0xffffe
    80003bdc:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80003bde:	df043783          	ld	a5,-528(s0)
    80003be2:	6388                	ld	a0,0(a5)
    80003be4:	c135                	beqz	a0,80003c48 <exec+0x1d6>
    80003be6:	e9040993          	addi	s3,s0,-368
    80003bea:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80003bee:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80003bf0:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80003bf2:	ed2fc0ef          	jal	ra,800002c4 <strlen>
    80003bf6:	0015079b          	addiw	a5,a0,1
    80003bfa:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003bfe:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80003c02:	13596463          	bltu	s2,s5,80003d2a <exec+0x2b8>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003c06:	df043d83          	ld	s11,-528(s0)
    80003c0a:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80003c0e:	8552                	mv	a0,s4
    80003c10:	eb4fc0ef          	jal	ra,800002c4 <strlen>
    80003c14:	0015069b          	addiw	a3,a0,1
    80003c18:	8652                	mv	a2,s4
    80003c1a:	85ca                	mv	a1,s2
    80003c1c:	855a                	mv	a0,s6
    80003c1e:	de9fc0ef          	jal	ra,80000a06 <copyout>
    80003c22:	10054863          	bltz	a0,80003d32 <exec+0x2c0>
    ustack[argc] = sp;
    80003c26:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80003c2a:	0485                	addi	s1,s1,1
    80003c2c:	008d8793          	addi	a5,s11,8
    80003c30:	def43823          	sd	a5,-528(s0)
    80003c34:	008db503          	ld	a0,8(s11)
    80003c38:	c911                	beqz	a0,80003c4c <exec+0x1da>
    if(argc >= MAXARG)
    80003c3a:	09a1                	addi	s3,s3,8
    80003c3c:	fb3c9be3          	bne	s9,s3,80003bf2 <exec+0x180>
  sz = sz1;
    80003c40:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80003c44:	4a81                	li	s5,0
    80003c46:	a86d                	j	80003d00 <exec+0x28e>
  sp = sz;
    80003c48:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80003c4a:	4481                	li	s1,0
  ustack[argc] = 0;
    80003c4c:	00349793          	slli	a5,s1,0x3
    80003c50:	f9040713          	addi	a4,s0,-112
    80003c54:	97ba                	add	a5,a5,a4
    80003c56:	f007b023          	sd	zero,-256(a5) # ffffffffffffef00 <end+0xffffffff7ffde090>
  sp -= (argc+1) * sizeof(uint64);
    80003c5a:	00148693          	addi	a3,s1,1
    80003c5e:	068e                	slli	a3,a3,0x3
    80003c60:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003c64:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80003c68:	01597663          	bgeu	s2,s5,80003c74 <exec+0x202>
  sz = sz1;
    80003c6c:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80003c70:	4a81                	li	s5,0
    80003c72:	a079                	j	80003d00 <exec+0x28e>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003c74:	e9040613          	addi	a2,s0,-368
    80003c78:	85ca                	mv	a1,s2
    80003c7a:	855a                	mv	a0,s6
    80003c7c:	d8bfc0ef          	jal	ra,80000a06 <copyout>
    80003c80:	0a054d63          	bltz	a0,80003d3a <exec+0x2c8>
  p->trapframe->a1 = sp;
    80003c84:	040bb783          	ld	a5,64(s7) # 1040 <_entry-0x7fffefc0>
    80003c88:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003c8c:	de843783          	ld	a5,-536(s0)
    80003c90:	0007c703          	lbu	a4,0(a5)
    80003c94:	cf11                	beqz	a4,80003cb0 <exec+0x23e>
    80003c96:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003c98:	02f00693          	li	a3,47
    80003c9c:	a039                	j	80003caa <exec+0x238>
      last = s+1;
    80003c9e:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80003ca2:	0785                	addi	a5,a5,1
    80003ca4:	fff7c703          	lbu	a4,-1(a5)
    80003ca8:	c701                	beqz	a4,80003cb0 <exec+0x23e>
    if(*s == '/')
    80003caa:	fed71ce3          	bne	a4,a3,80003ca2 <exec+0x230>
    80003cae:	bfc5                	j	80003c9e <exec+0x22c>
  safestrcpy(p->name, last, sizeof(p->name));
    80003cb0:	4641                	li	a2,16
    80003cb2:	de843583          	ld	a1,-536(s0)
    80003cb6:	160b8513          	addi	a0,s7,352
    80003cba:	dd8fc0ef          	jal	ra,80000292 <safestrcpy>
  oldpagetable = p->pagetable;
    80003cbe:	0d0bb503          	ld	a0,208(s7)
  p->pagetable = pagetable;
    80003cc2:	0d6bb823          	sd	s6,208(s7)
  p->sz = sz;
    80003cc6:	0d8bb423          	sd	s8,200(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80003cca:	040bb783          	ld	a5,64(s7)
    80003cce:	e6843703          	ld	a4,-408(s0)
    80003cd2:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003cd4:	040bb783          	ld	a5,64(s7)
    80003cd8:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003cdc:	85ea                	mv	a1,s10
    80003cde:	aa6fd0ef          	jal	ra,80000f84 <proc_freepagetable>
  if(p->pid == 1){
    80003ce2:	030ba703          	lw	a4,48(s7)
    80003ce6:	4785                	li	a5,1
    80003ce8:	00f70563          	beq	a4,a5,80003cf2 <exec+0x280>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003cec:	0004851b          	sext.w	a0,s1
    80003cf0:	b509                	j	80003af2 <exec+0x80>
    vmprint(p->pagetable);
    80003cf2:	0d0bb503          	ld	a0,208(s7)
    80003cf6:	fa1fc0ef          	jal	ra,80000c96 <vmprint>
    80003cfa:	bfcd                	j	80003cec <exec+0x27a>
    80003cfc:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80003d00:	df843583          	ld	a1,-520(s0)
    80003d04:	855a                	mv	a0,s6
    80003d06:	a7efd0ef          	jal	ra,80000f84 <proc_freepagetable>
  if(ip){
    80003d0a:	dc0a9ee3          	bnez	s5,80003ae6 <exec+0x74>
  return -1;
    80003d0e:	557d                	li	a0,-1
    80003d10:	b3cd                	j	80003af2 <exec+0x80>
    80003d12:	df243c23          	sd	s2,-520(s0)
    80003d16:	b7ed                	j	80003d00 <exec+0x28e>
    80003d18:	df243c23          	sd	s2,-520(s0)
    80003d1c:	b7d5                	j	80003d00 <exec+0x28e>
    80003d1e:	df243c23          	sd	s2,-520(s0)
    80003d22:	bff9                	j	80003d00 <exec+0x28e>
    80003d24:	df243c23          	sd	s2,-520(s0)
    80003d28:	bfe1                	j	80003d00 <exec+0x28e>
  sz = sz1;
    80003d2a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80003d2e:	4a81                	li	s5,0
    80003d30:	bfc1                	j	80003d00 <exec+0x28e>
  sz = sz1;
    80003d32:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80003d36:	4a81                	li	s5,0
    80003d38:	b7e1                	j	80003d00 <exec+0x28e>
  sz = sz1;
    80003d3a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80003d3e:	4a81                	li	s5,0
    80003d40:	b7c1                	j	80003d00 <exec+0x28e>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003d42:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003d46:	e0843783          	ld	a5,-504(s0)
    80003d4a:	0017869b          	addiw	a3,a5,1
    80003d4e:	e0d43423          	sd	a3,-504(s0)
    80003d52:	e0043783          	ld	a5,-512(s0)
    80003d56:	0387879b          	addiw	a5,a5,56
    80003d5a:	e8845703          	lhu	a4,-376(s0)
    80003d5e:	e2e6dce3          	bge	a3,a4,80003b96 <exec+0x124>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003d62:	2781                	sext.w	a5,a5
    80003d64:	e0f43023          	sd	a5,-512(s0)
    80003d68:	03800713          	li	a4,56
    80003d6c:	86be                	mv	a3,a5
    80003d6e:	e1840613          	addi	a2,s0,-488
    80003d72:	4581                	li	a1,0
    80003d74:	8556                	mv	a0,s5
    80003d76:	d05fe0ef          	jal	ra,80002a7a <readi>
    80003d7a:	03800793          	li	a5,56
    80003d7e:	f6f51fe3          	bne	a0,a5,80003cfc <exec+0x28a>
    if(ph.type != ELF_PROG_LOAD)
    80003d82:	e1842783          	lw	a5,-488(s0)
    80003d86:	4705                	li	a4,1
    80003d88:	fae79fe3          	bne	a5,a4,80003d46 <exec+0x2d4>
    if(ph.memsz < ph.filesz)
    80003d8c:	e4043483          	ld	s1,-448(s0)
    80003d90:	e3843783          	ld	a5,-456(s0)
    80003d94:	f6f4efe3          	bltu	s1,a5,80003d12 <exec+0x2a0>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003d98:	e2843783          	ld	a5,-472(s0)
    80003d9c:	94be                	add	s1,s1,a5
    80003d9e:	f6f4ede3          	bltu	s1,a5,80003d18 <exec+0x2a6>
    if(ph.vaddr % PGSIZE != 0)
    80003da2:	de043703          	ld	a4,-544(s0)
    80003da6:	8ff9                	and	a5,a5,a4
    80003da8:	fbbd                	bnez	a5,80003d1e <exec+0x2ac>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003daa:	e1c42503          	lw	a0,-484(s0)
    80003dae:	ca9ff0ef          	jal	ra,80003a56 <flags2perm>
    80003db2:	86aa                	mv	a3,a0
    80003db4:	8626                	mv	a2,s1
    80003db6:	85ca                	mv	a1,s2
    80003db8:	855a                	mv	a0,s6
    80003dba:	a01fc0ef          	jal	ra,800007ba <uvmalloc>
    80003dbe:	dea43c23          	sd	a0,-520(s0)
    80003dc2:	d12d                	beqz	a0,80003d24 <exec+0x2b2>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003dc4:	e2843c03          	ld	s8,-472(s0)
    80003dc8:	e2042c83          	lw	s9,-480(s0)
    80003dcc:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003dd0:	f60b89e3          	beqz	s7,80003d42 <exec+0x2d0>
    80003dd4:	89de                	mv	s3,s7
    80003dd6:	4481                	li	s1,0
    80003dd8:	b345                	j	80003b78 <exec+0x106>

0000000080003dda <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003dda:	7179                	addi	sp,sp,-48
    80003ddc:	f406                	sd	ra,40(sp)
    80003dde:	f022                	sd	s0,32(sp)
    80003de0:	ec26                	sd	s1,24(sp)
    80003de2:	e84a                	sd	s2,16(sp)
    80003de4:	1800                	addi	s0,sp,48
    80003de6:	892e                	mv	s2,a1
    80003de8:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003dea:	fdc40593          	addi	a1,s0,-36
    80003dee:	f71fd0ef          	jal	ra,80001d5e <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003df2:	fdc42703          	lw	a4,-36(s0)
    80003df6:	47bd                	li	a5,15
    80003df8:	02e7e963          	bltu	a5,a4,80003e2a <argfd+0x50>
    80003dfc:	824fd0ef          	jal	ra,80000e20 <myproc>
    80003e00:	fdc42703          	lw	a4,-36(s0)
    80003e04:	01a70793          	addi	a5,a4,26
    80003e08:	078e                	slli	a5,a5,0x3
    80003e0a:	953e                	add	a0,a0,a5
    80003e0c:	651c                	ld	a5,8(a0)
    80003e0e:	c385                	beqz	a5,80003e2e <argfd+0x54>
    return -1;
  if(pfd)
    80003e10:	00090463          	beqz	s2,80003e18 <argfd+0x3e>
    *pfd = fd;
    80003e14:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003e18:	4501                	li	a0,0
  if(pf)
    80003e1a:	c091                	beqz	s1,80003e1e <argfd+0x44>
    *pf = f;
    80003e1c:	e09c                	sd	a5,0(s1)
}
    80003e1e:	70a2                	ld	ra,40(sp)
    80003e20:	7402                	ld	s0,32(sp)
    80003e22:	64e2                	ld	s1,24(sp)
    80003e24:	6942                	ld	s2,16(sp)
    80003e26:	6145                	addi	sp,sp,48
    80003e28:	8082                	ret
    return -1;
    80003e2a:	557d                	li	a0,-1
    80003e2c:	bfcd                	j	80003e1e <argfd+0x44>
    80003e2e:	557d                	li	a0,-1
    80003e30:	b7fd                	j	80003e1e <argfd+0x44>

0000000080003e32 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003e32:	1101                	addi	sp,sp,-32
    80003e34:	ec06                	sd	ra,24(sp)
    80003e36:	e822                	sd	s0,16(sp)
    80003e38:	e426                	sd	s1,8(sp)
    80003e3a:	1000                	addi	s0,sp,32
    80003e3c:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003e3e:	fe3fc0ef          	jal	ra,80000e20 <myproc>
    80003e42:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003e44:	0d850793          	addi	a5,a0,216
    80003e48:	4501                	li	a0,0
    80003e4a:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80003e4c:	6398                	ld	a4,0(a5)
    80003e4e:	cb19                	beqz	a4,80003e64 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80003e50:	2505                	addiw	a0,a0,1
    80003e52:	07a1                	addi	a5,a5,8
    80003e54:	fed51ce3          	bne	a0,a3,80003e4c <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80003e58:	557d                	li	a0,-1
}
    80003e5a:	60e2                	ld	ra,24(sp)
    80003e5c:	6442                	ld	s0,16(sp)
    80003e5e:	64a2                	ld	s1,8(sp)
    80003e60:	6105                	addi	sp,sp,32
    80003e62:	8082                	ret
      p->ofile[fd] = f;
    80003e64:	01a50793          	addi	a5,a0,26
    80003e68:	078e                	slli	a5,a5,0x3
    80003e6a:	963e                	add	a2,a2,a5
    80003e6c:	e604                	sd	s1,8(a2)
      return fd;
    80003e6e:	b7f5                	j	80003e5a <fdalloc+0x28>

0000000080003e70 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80003e70:	715d                	addi	sp,sp,-80
    80003e72:	e486                	sd	ra,72(sp)
    80003e74:	e0a2                	sd	s0,64(sp)
    80003e76:	fc26                	sd	s1,56(sp)
    80003e78:	f84a                	sd	s2,48(sp)
    80003e7a:	f44e                	sd	s3,40(sp)
    80003e7c:	f052                	sd	s4,32(sp)
    80003e7e:	ec56                	sd	s5,24(sp)
    80003e80:	e85a                	sd	s6,16(sp)
    80003e82:	0880                	addi	s0,sp,80
    80003e84:	8b2e                	mv	s6,a1
    80003e86:	89b2                	mv	s3,a2
    80003e88:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80003e8a:	fb040593          	addi	a1,s0,-80
    80003e8e:	868ff0ef          	jal	ra,80002ef6 <nameiparent>
    80003e92:	84aa                	mv	s1,a0
    80003e94:	10050b63          	beqz	a0,80003faa <create+0x13a>
    return 0;

  ilock(dp);
    80003e98:	993fe0ef          	jal	ra,8000282a <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80003e9c:	4601                	li	a2,0
    80003e9e:	fb040593          	addi	a1,s0,-80
    80003ea2:	8526                	mv	a0,s1
    80003ea4:	dd3fe0ef          	jal	ra,80002c76 <dirlookup>
    80003ea8:	8aaa                	mv	s5,a0
    80003eaa:	c521                	beqz	a0,80003ef2 <create+0x82>
    iunlockput(dp);
    80003eac:	8526                	mv	a0,s1
    80003eae:	b83fe0ef          	jal	ra,80002a30 <iunlockput>
    ilock(ip);
    80003eb2:	8556                	mv	a0,s5
    80003eb4:	977fe0ef          	jal	ra,8000282a <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80003eb8:	000b059b          	sext.w	a1,s6
    80003ebc:	4789                	li	a5,2
    80003ebe:	02f59563          	bne	a1,a5,80003ee8 <create+0x78>
    80003ec2:	044ad783          	lhu	a5,68(s5) # ffffffffffffe044 <end+0xffffffff7ffdd1d4>
    80003ec6:	37f9                	addiw	a5,a5,-2
    80003ec8:	17c2                	slli	a5,a5,0x30
    80003eca:	93c1                	srli	a5,a5,0x30
    80003ecc:	4705                	li	a4,1
    80003ece:	00f76d63          	bltu	a4,a5,80003ee8 <create+0x78>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80003ed2:	8556                	mv	a0,s5
    80003ed4:	60a6                	ld	ra,72(sp)
    80003ed6:	6406                	ld	s0,64(sp)
    80003ed8:	74e2                	ld	s1,56(sp)
    80003eda:	7942                	ld	s2,48(sp)
    80003edc:	79a2                	ld	s3,40(sp)
    80003ede:	7a02                	ld	s4,32(sp)
    80003ee0:	6ae2                	ld	s5,24(sp)
    80003ee2:	6b42                	ld	s6,16(sp)
    80003ee4:	6161                	addi	sp,sp,80
    80003ee6:	8082                	ret
    iunlockput(ip);
    80003ee8:	8556                	mv	a0,s5
    80003eea:	b47fe0ef          	jal	ra,80002a30 <iunlockput>
    return 0;
    80003eee:	4a81                	li	s5,0
    80003ef0:	b7cd                	j	80003ed2 <create+0x62>
  if((ip = ialloc(dp->dev, type)) == 0){
    80003ef2:	85da                	mv	a1,s6
    80003ef4:	4088                	lw	a0,0(s1)
    80003ef6:	fccfe0ef          	jal	ra,800026c2 <ialloc>
    80003efa:	8a2a                	mv	s4,a0
    80003efc:	cd1d                	beqz	a0,80003f3a <create+0xca>
  ilock(ip);
    80003efe:	92dfe0ef          	jal	ra,8000282a <ilock>
  ip->major = major;
    80003f02:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80003f06:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80003f0a:	4905                	li	s2,1
    80003f0c:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80003f10:	8552                	mv	a0,s4
    80003f12:	867fe0ef          	jal	ra,80002778 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80003f16:	000b059b          	sext.w	a1,s6
    80003f1a:	03258563          	beq	a1,s2,80003f44 <create+0xd4>
  if(dirlink(dp, name, ip->inum) < 0)
    80003f1e:	004a2603          	lw	a2,4(s4)
    80003f22:	fb040593          	addi	a1,s0,-80
    80003f26:	8526                	mv	a0,s1
    80003f28:	f1bfe0ef          	jal	ra,80002e42 <dirlink>
    80003f2c:	06054363          	bltz	a0,80003f92 <create+0x122>
  iunlockput(dp);
    80003f30:	8526                	mv	a0,s1
    80003f32:	afffe0ef          	jal	ra,80002a30 <iunlockput>
  return ip;
    80003f36:	8ad2                	mv	s5,s4
    80003f38:	bf69                	j	80003ed2 <create+0x62>
    iunlockput(dp);
    80003f3a:	8526                	mv	a0,s1
    80003f3c:	af5fe0ef          	jal	ra,80002a30 <iunlockput>
    return 0;
    80003f40:	8ad2                	mv	s5,s4
    80003f42:	bf41                	j	80003ed2 <create+0x62>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80003f44:	004a2603          	lw	a2,4(s4)
    80003f48:	00003597          	auipc	a1,0x3
    80003f4c:	7a858593          	addi	a1,a1,1960 # 800076f0 <syscalls+0x2a8>
    80003f50:	8552                	mv	a0,s4
    80003f52:	ef1fe0ef          	jal	ra,80002e42 <dirlink>
    80003f56:	02054e63          	bltz	a0,80003f92 <create+0x122>
    80003f5a:	40d0                	lw	a2,4(s1)
    80003f5c:	00003597          	auipc	a1,0x3
    80003f60:	79c58593          	addi	a1,a1,1948 # 800076f8 <syscalls+0x2b0>
    80003f64:	8552                	mv	a0,s4
    80003f66:	eddfe0ef          	jal	ra,80002e42 <dirlink>
    80003f6a:	02054463          	bltz	a0,80003f92 <create+0x122>
  if(dirlink(dp, name, ip->inum) < 0)
    80003f6e:	004a2603          	lw	a2,4(s4)
    80003f72:	fb040593          	addi	a1,s0,-80
    80003f76:	8526                	mv	a0,s1
    80003f78:	ecbfe0ef          	jal	ra,80002e42 <dirlink>
    80003f7c:	00054b63          	bltz	a0,80003f92 <create+0x122>
    dp->nlink++;  // for ".."
    80003f80:	04a4d783          	lhu	a5,74(s1)
    80003f84:	2785                	addiw	a5,a5,1
    80003f86:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80003f8a:	8526                	mv	a0,s1
    80003f8c:	fecfe0ef          	jal	ra,80002778 <iupdate>
    80003f90:	b745                	j	80003f30 <create+0xc0>
  ip->nlink = 0;
    80003f92:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80003f96:	8552                	mv	a0,s4
    80003f98:	fe0fe0ef          	jal	ra,80002778 <iupdate>
  iunlockput(ip);
    80003f9c:	8552                	mv	a0,s4
    80003f9e:	a93fe0ef          	jal	ra,80002a30 <iunlockput>
  iunlockput(dp);
    80003fa2:	8526                	mv	a0,s1
    80003fa4:	a8dfe0ef          	jal	ra,80002a30 <iunlockput>
  return 0;
    80003fa8:	b72d                	j	80003ed2 <create+0x62>
    return 0;
    80003faa:	8aaa                	mv	s5,a0
    80003fac:	b71d                	j	80003ed2 <create+0x62>

0000000080003fae <sys_dup>:
{
    80003fae:	7179                	addi	sp,sp,-48
    80003fb0:	f406                	sd	ra,40(sp)
    80003fb2:	f022                	sd	s0,32(sp)
    80003fb4:	ec26                	sd	s1,24(sp)
    80003fb6:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80003fb8:	fd840613          	addi	a2,s0,-40
    80003fbc:	4581                	li	a1,0
    80003fbe:	4501                	li	a0,0
    80003fc0:	e1bff0ef          	jal	ra,80003dda <argfd>
    return -1;
    80003fc4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80003fc6:	00054f63          	bltz	a0,80003fe4 <sys_dup+0x36>
  if((fd=fdalloc(f)) < 0)
    80003fca:	fd843503          	ld	a0,-40(s0)
    80003fce:	e65ff0ef          	jal	ra,80003e32 <fdalloc>
    80003fd2:	84aa                	mv	s1,a0
    return -1;
    80003fd4:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80003fd6:	00054763          	bltz	a0,80003fe4 <sys_dup+0x36>
  filedup(f);
    80003fda:	fd843503          	ld	a0,-40(s0)
    80003fde:	cacff0ef          	jal	ra,8000348a <filedup>
  return fd;
    80003fe2:	87a6                	mv	a5,s1
}
    80003fe4:	853e                	mv	a0,a5
    80003fe6:	70a2                	ld	ra,40(sp)
    80003fe8:	7402                	ld	s0,32(sp)
    80003fea:	64e2                	ld	s1,24(sp)
    80003fec:	6145                	addi	sp,sp,48
    80003fee:	8082                	ret

0000000080003ff0 <sys_read>:
{
    80003ff0:	7179                	addi	sp,sp,-48
    80003ff2:	f406                	sd	ra,40(sp)
    80003ff4:	f022                	sd	s0,32(sp)
    80003ff6:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80003ff8:	fd840593          	addi	a1,s0,-40
    80003ffc:	4505                	li	a0,1
    80003ffe:	d7dfd0ef          	jal	ra,80001d7a <argaddr>
  argint(2, &n);
    80004002:	fe440593          	addi	a1,s0,-28
    80004006:	4509                	li	a0,2
    80004008:	d57fd0ef          	jal	ra,80001d5e <argint>
  if(argfd(0, 0, &f) < 0)
    8000400c:	fe840613          	addi	a2,s0,-24
    80004010:	4581                	li	a1,0
    80004012:	4501                	li	a0,0
    80004014:	dc7ff0ef          	jal	ra,80003dda <argfd>
    80004018:	87aa                	mv	a5,a0
    return -1;
    8000401a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000401c:	0007ca63          	bltz	a5,80004030 <sys_read+0x40>
  return fileread(f, p, n);
    80004020:	fe442603          	lw	a2,-28(s0)
    80004024:	fd843583          	ld	a1,-40(s0)
    80004028:	fe843503          	ld	a0,-24(s0)
    8000402c:	daaff0ef          	jal	ra,800035d6 <fileread>
}
    80004030:	70a2                	ld	ra,40(sp)
    80004032:	7402                	ld	s0,32(sp)
    80004034:	6145                	addi	sp,sp,48
    80004036:	8082                	ret

0000000080004038 <sys_write>:
{
    80004038:	7179                	addi	sp,sp,-48
    8000403a:	f406                	sd	ra,40(sp)
    8000403c:	f022                	sd	s0,32(sp)
    8000403e:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004040:	fd840593          	addi	a1,s0,-40
    80004044:	4505                	li	a0,1
    80004046:	d35fd0ef          	jal	ra,80001d7a <argaddr>
  argint(2, &n);
    8000404a:	fe440593          	addi	a1,s0,-28
    8000404e:	4509                	li	a0,2
    80004050:	d0ffd0ef          	jal	ra,80001d5e <argint>
  if(argfd(0, 0, &f) < 0)
    80004054:	fe840613          	addi	a2,s0,-24
    80004058:	4581                	li	a1,0
    8000405a:	4501                	li	a0,0
    8000405c:	d7fff0ef          	jal	ra,80003dda <argfd>
    80004060:	87aa                	mv	a5,a0
    return -1;
    80004062:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004064:	0007ca63          	bltz	a5,80004078 <sys_write+0x40>
  return filewrite(f, p, n);
    80004068:	fe442603          	lw	a2,-28(s0)
    8000406c:	fd843583          	ld	a1,-40(s0)
    80004070:	fe843503          	ld	a0,-24(s0)
    80004074:	e10ff0ef          	jal	ra,80003684 <filewrite>
}
    80004078:	70a2                	ld	ra,40(sp)
    8000407a:	7402                	ld	s0,32(sp)
    8000407c:	6145                	addi	sp,sp,48
    8000407e:	8082                	ret

0000000080004080 <sys_close>:
{
    80004080:	1101                	addi	sp,sp,-32
    80004082:	ec06                	sd	ra,24(sp)
    80004084:	e822                	sd	s0,16(sp)
    80004086:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004088:	fe040613          	addi	a2,s0,-32
    8000408c:	fec40593          	addi	a1,s0,-20
    80004090:	4501                	li	a0,0
    80004092:	d49ff0ef          	jal	ra,80003dda <argfd>
    return -1;
    80004096:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004098:	02054063          	bltz	a0,800040b8 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    8000409c:	d85fc0ef          	jal	ra,80000e20 <myproc>
    800040a0:	fec42783          	lw	a5,-20(s0)
    800040a4:	07e9                	addi	a5,a5,26
    800040a6:	078e                	slli	a5,a5,0x3
    800040a8:	97aa                	add	a5,a5,a0
    800040aa:	0007b423          	sd	zero,8(a5)
  fileclose(f);
    800040ae:	fe043503          	ld	a0,-32(s0)
    800040b2:	c1eff0ef          	jal	ra,800034d0 <fileclose>
  return 0;
    800040b6:	4781                	li	a5,0
}
    800040b8:	853e                	mv	a0,a5
    800040ba:	60e2                	ld	ra,24(sp)
    800040bc:	6442                	ld	s0,16(sp)
    800040be:	6105                	addi	sp,sp,32
    800040c0:	8082                	ret

00000000800040c2 <sys_fstat>:
{
    800040c2:	1101                	addi	sp,sp,-32
    800040c4:	ec06                	sd	ra,24(sp)
    800040c6:	e822                	sd	s0,16(sp)
    800040c8:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800040ca:	fe040593          	addi	a1,s0,-32
    800040ce:	4505                	li	a0,1
    800040d0:	cabfd0ef          	jal	ra,80001d7a <argaddr>
  if(argfd(0, 0, &f) < 0)
    800040d4:	fe840613          	addi	a2,s0,-24
    800040d8:	4581                	li	a1,0
    800040da:	4501                	li	a0,0
    800040dc:	cffff0ef          	jal	ra,80003dda <argfd>
    800040e0:	87aa                	mv	a5,a0
    return -1;
    800040e2:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800040e4:	0007c863          	bltz	a5,800040f4 <sys_fstat+0x32>
  return filestat(f, st);
    800040e8:	fe043583          	ld	a1,-32(s0)
    800040ec:	fe843503          	ld	a0,-24(s0)
    800040f0:	c88ff0ef          	jal	ra,80003578 <filestat>
}
    800040f4:	60e2                	ld	ra,24(sp)
    800040f6:	6442                	ld	s0,16(sp)
    800040f8:	6105                	addi	sp,sp,32
    800040fa:	8082                	ret

00000000800040fc <sys_link>:
{
    800040fc:	7169                	addi	sp,sp,-304
    800040fe:	f606                	sd	ra,296(sp)
    80004100:	f222                	sd	s0,288(sp)
    80004102:	ee26                	sd	s1,280(sp)
    80004104:	ea4a                	sd	s2,272(sp)
    80004106:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004108:	08000613          	li	a2,128
    8000410c:	ed040593          	addi	a1,s0,-304
    80004110:	4501                	li	a0,0
    80004112:	c85fd0ef          	jal	ra,80001d96 <argstr>
    return -1;
    80004116:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004118:	0c054663          	bltz	a0,800041e4 <sys_link+0xe8>
    8000411c:	08000613          	li	a2,128
    80004120:	f5040593          	addi	a1,s0,-176
    80004124:	4505                	li	a0,1
    80004126:	c71fd0ef          	jal	ra,80001d96 <argstr>
    return -1;
    8000412a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000412c:	0a054c63          	bltz	a0,800041e4 <sys_link+0xe8>
  begin_op();
    80004130:	f85fe0ef          	jal	ra,800030b4 <begin_op>
  if((ip = namei(old)) == 0){
    80004134:	ed040513          	addi	a0,s0,-304
    80004138:	da5fe0ef          	jal	ra,80002edc <namei>
    8000413c:	84aa                	mv	s1,a0
    8000413e:	c525                	beqz	a0,800041a6 <sys_link+0xaa>
  ilock(ip);
    80004140:	eeafe0ef          	jal	ra,8000282a <ilock>
  if(ip->type == T_DIR){
    80004144:	04449703          	lh	a4,68(s1)
    80004148:	4785                	li	a5,1
    8000414a:	06f70263          	beq	a4,a5,800041ae <sys_link+0xb2>
  ip->nlink++;
    8000414e:	04a4d783          	lhu	a5,74(s1)
    80004152:	2785                	addiw	a5,a5,1
    80004154:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004158:	8526                	mv	a0,s1
    8000415a:	e1efe0ef          	jal	ra,80002778 <iupdate>
  iunlock(ip);
    8000415e:	8526                	mv	a0,s1
    80004160:	f74fe0ef          	jal	ra,800028d4 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004164:	fd040593          	addi	a1,s0,-48
    80004168:	f5040513          	addi	a0,s0,-176
    8000416c:	d8bfe0ef          	jal	ra,80002ef6 <nameiparent>
    80004170:	892a                	mv	s2,a0
    80004172:	c921                	beqz	a0,800041c2 <sys_link+0xc6>
  ilock(dp);
    80004174:	eb6fe0ef          	jal	ra,8000282a <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004178:	00092703          	lw	a4,0(s2)
    8000417c:	409c                	lw	a5,0(s1)
    8000417e:	02f71f63          	bne	a4,a5,800041bc <sys_link+0xc0>
    80004182:	40d0                	lw	a2,4(s1)
    80004184:	fd040593          	addi	a1,s0,-48
    80004188:	854a                	mv	a0,s2
    8000418a:	cb9fe0ef          	jal	ra,80002e42 <dirlink>
    8000418e:	02054763          	bltz	a0,800041bc <sys_link+0xc0>
  iunlockput(dp);
    80004192:	854a                	mv	a0,s2
    80004194:	89dfe0ef          	jal	ra,80002a30 <iunlockput>
  iput(ip);
    80004198:	8526                	mv	a0,s1
    8000419a:	80ffe0ef          	jal	ra,800029a8 <iput>
  end_op();
    8000419e:	f87fe0ef          	jal	ra,80003124 <end_op>
  return 0;
    800041a2:	4781                	li	a5,0
    800041a4:	a081                	j	800041e4 <sys_link+0xe8>
    end_op();
    800041a6:	f7ffe0ef          	jal	ra,80003124 <end_op>
    return -1;
    800041aa:	57fd                	li	a5,-1
    800041ac:	a825                	j	800041e4 <sys_link+0xe8>
    iunlockput(ip);
    800041ae:	8526                	mv	a0,s1
    800041b0:	881fe0ef          	jal	ra,80002a30 <iunlockput>
    end_op();
    800041b4:	f71fe0ef          	jal	ra,80003124 <end_op>
    return -1;
    800041b8:	57fd                	li	a5,-1
    800041ba:	a02d                	j	800041e4 <sys_link+0xe8>
    iunlockput(dp);
    800041bc:	854a                	mv	a0,s2
    800041be:	873fe0ef          	jal	ra,80002a30 <iunlockput>
  ilock(ip);
    800041c2:	8526                	mv	a0,s1
    800041c4:	e66fe0ef          	jal	ra,8000282a <ilock>
  ip->nlink--;
    800041c8:	04a4d783          	lhu	a5,74(s1)
    800041cc:	37fd                	addiw	a5,a5,-1
    800041ce:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800041d2:	8526                	mv	a0,s1
    800041d4:	da4fe0ef          	jal	ra,80002778 <iupdate>
  iunlockput(ip);
    800041d8:	8526                	mv	a0,s1
    800041da:	857fe0ef          	jal	ra,80002a30 <iunlockput>
  end_op();
    800041de:	f47fe0ef          	jal	ra,80003124 <end_op>
  return -1;
    800041e2:	57fd                	li	a5,-1
}
    800041e4:	853e                	mv	a0,a5
    800041e6:	70b2                	ld	ra,296(sp)
    800041e8:	7412                	ld	s0,288(sp)
    800041ea:	64f2                	ld	s1,280(sp)
    800041ec:	6952                	ld	s2,272(sp)
    800041ee:	6155                	addi	sp,sp,304
    800041f0:	8082                	ret

00000000800041f2 <sys_unlink>:
{
    800041f2:	7151                	addi	sp,sp,-240
    800041f4:	f586                	sd	ra,232(sp)
    800041f6:	f1a2                	sd	s0,224(sp)
    800041f8:	eda6                	sd	s1,216(sp)
    800041fa:	e9ca                	sd	s2,208(sp)
    800041fc:	e5ce                	sd	s3,200(sp)
    800041fe:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004200:	08000613          	li	a2,128
    80004204:	f3040593          	addi	a1,s0,-208
    80004208:	4501                	li	a0,0
    8000420a:	b8dfd0ef          	jal	ra,80001d96 <argstr>
    8000420e:	12054b63          	bltz	a0,80004344 <sys_unlink+0x152>
  begin_op();
    80004212:	ea3fe0ef          	jal	ra,800030b4 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004216:	fb040593          	addi	a1,s0,-80
    8000421a:	f3040513          	addi	a0,s0,-208
    8000421e:	cd9fe0ef          	jal	ra,80002ef6 <nameiparent>
    80004222:	84aa                	mv	s1,a0
    80004224:	c54d                	beqz	a0,800042ce <sys_unlink+0xdc>
  ilock(dp);
    80004226:	e04fe0ef          	jal	ra,8000282a <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000422a:	00003597          	auipc	a1,0x3
    8000422e:	4c658593          	addi	a1,a1,1222 # 800076f0 <syscalls+0x2a8>
    80004232:	fb040513          	addi	a0,s0,-80
    80004236:	a2bfe0ef          	jal	ra,80002c60 <namecmp>
    8000423a:	10050a63          	beqz	a0,8000434e <sys_unlink+0x15c>
    8000423e:	00003597          	auipc	a1,0x3
    80004242:	4ba58593          	addi	a1,a1,1210 # 800076f8 <syscalls+0x2b0>
    80004246:	fb040513          	addi	a0,s0,-80
    8000424a:	a17fe0ef          	jal	ra,80002c60 <namecmp>
    8000424e:	10050063          	beqz	a0,8000434e <sys_unlink+0x15c>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004252:	f2c40613          	addi	a2,s0,-212
    80004256:	fb040593          	addi	a1,s0,-80
    8000425a:	8526                	mv	a0,s1
    8000425c:	a1bfe0ef          	jal	ra,80002c76 <dirlookup>
    80004260:	892a                	mv	s2,a0
    80004262:	0e050663          	beqz	a0,8000434e <sys_unlink+0x15c>
  ilock(ip);
    80004266:	dc4fe0ef          	jal	ra,8000282a <ilock>
  if(ip->nlink < 1)
    8000426a:	04a91783          	lh	a5,74(s2)
    8000426e:	06f05463          	blez	a5,800042d6 <sys_unlink+0xe4>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004272:	04491703          	lh	a4,68(s2)
    80004276:	4785                	li	a5,1
    80004278:	06f70563          	beq	a4,a5,800042e2 <sys_unlink+0xf0>
  memset(&de, 0, sizeof(de));
    8000427c:	4641                	li	a2,16
    8000427e:	4581                	li	a1,0
    80004280:	fc040513          	addi	a0,s0,-64
    80004284:	ec9fb0ef          	jal	ra,8000014c <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004288:	4741                	li	a4,16
    8000428a:	f2c42683          	lw	a3,-212(s0)
    8000428e:	fc040613          	addi	a2,s0,-64
    80004292:	4581                	li	a1,0
    80004294:	8526                	mv	a0,s1
    80004296:	8c9fe0ef          	jal	ra,80002b5e <writei>
    8000429a:	47c1                	li	a5,16
    8000429c:	08f51563          	bne	a0,a5,80004326 <sys_unlink+0x134>
  if(ip->type == T_DIR){
    800042a0:	04491703          	lh	a4,68(s2)
    800042a4:	4785                	li	a5,1
    800042a6:	08f70663          	beq	a4,a5,80004332 <sys_unlink+0x140>
  iunlockput(dp);
    800042aa:	8526                	mv	a0,s1
    800042ac:	f84fe0ef          	jal	ra,80002a30 <iunlockput>
  ip->nlink--;
    800042b0:	04a95783          	lhu	a5,74(s2)
    800042b4:	37fd                	addiw	a5,a5,-1
    800042b6:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800042ba:	854a                	mv	a0,s2
    800042bc:	cbcfe0ef          	jal	ra,80002778 <iupdate>
  iunlockput(ip);
    800042c0:	854a                	mv	a0,s2
    800042c2:	f6efe0ef          	jal	ra,80002a30 <iunlockput>
  end_op();
    800042c6:	e5ffe0ef          	jal	ra,80003124 <end_op>
  return 0;
    800042ca:	4501                	li	a0,0
    800042cc:	a079                	j	8000435a <sys_unlink+0x168>
    end_op();
    800042ce:	e57fe0ef          	jal	ra,80003124 <end_op>
    return -1;
    800042d2:	557d                	li	a0,-1
    800042d4:	a059                	j	8000435a <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    800042d6:	00003517          	auipc	a0,0x3
    800042da:	42a50513          	addi	a0,a0,1066 # 80007700 <syscalls+0x2b8>
    800042de:	1d8010ef          	jal	ra,800054b6 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800042e2:	04c92703          	lw	a4,76(s2)
    800042e6:	02000793          	li	a5,32
    800042ea:	f8e7f9e3          	bgeu	a5,a4,8000427c <sys_unlink+0x8a>
    800042ee:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800042f2:	4741                	li	a4,16
    800042f4:	86ce                	mv	a3,s3
    800042f6:	f1840613          	addi	a2,s0,-232
    800042fa:	4581                	li	a1,0
    800042fc:	854a                	mv	a0,s2
    800042fe:	f7cfe0ef          	jal	ra,80002a7a <readi>
    80004302:	47c1                	li	a5,16
    80004304:	00f51b63          	bne	a0,a5,8000431a <sys_unlink+0x128>
    if(de.inum != 0)
    80004308:	f1845783          	lhu	a5,-232(s0)
    8000430c:	ef95                	bnez	a5,80004348 <sys_unlink+0x156>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000430e:	29c1                	addiw	s3,s3,16
    80004310:	04c92783          	lw	a5,76(s2)
    80004314:	fcf9efe3          	bltu	s3,a5,800042f2 <sys_unlink+0x100>
    80004318:	b795                	j	8000427c <sys_unlink+0x8a>
      panic("isdirempty: readi");
    8000431a:	00003517          	auipc	a0,0x3
    8000431e:	3fe50513          	addi	a0,a0,1022 # 80007718 <syscalls+0x2d0>
    80004322:	194010ef          	jal	ra,800054b6 <panic>
    panic("unlink: writei");
    80004326:	00003517          	auipc	a0,0x3
    8000432a:	40a50513          	addi	a0,a0,1034 # 80007730 <syscalls+0x2e8>
    8000432e:	188010ef          	jal	ra,800054b6 <panic>
    dp->nlink--;
    80004332:	04a4d783          	lhu	a5,74(s1)
    80004336:	37fd                	addiw	a5,a5,-1
    80004338:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000433c:	8526                	mv	a0,s1
    8000433e:	c3afe0ef          	jal	ra,80002778 <iupdate>
    80004342:	b7a5                	j	800042aa <sys_unlink+0xb8>
    return -1;
    80004344:	557d                	li	a0,-1
    80004346:	a811                	j	8000435a <sys_unlink+0x168>
    iunlockput(ip);
    80004348:	854a                	mv	a0,s2
    8000434a:	ee6fe0ef          	jal	ra,80002a30 <iunlockput>
  iunlockput(dp);
    8000434e:	8526                	mv	a0,s1
    80004350:	ee0fe0ef          	jal	ra,80002a30 <iunlockput>
  end_op();
    80004354:	dd1fe0ef          	jal	ra,80003124 <end_op>
  return -1;
    80004358:	557d                	li	a0,-1
}
    8000435a:	70ae                	ld	ra,232(sp)
    8000435c:	740e                	ld	s0,224(sp)
    8000435e:	64ee                	ld	s1,216(sp)
    80004360:	694e                	ld	s2,208(sp)
    80004362:	69ae                	ld	s3,200(sp)
    80004364:	616d                	addi	sp,sp,240
    80004366:	8082                	ret

0000000080004368 <sys_open>:

uint64
sys_open(void)
{
    80004368:	7131                	addi	sp,sp,-192
    8000436a:	fd06                	sd	ra,184(sp)
    8000436c:	f922                	sd	s0,176(sp)
    8000436e:	f526                	sd	s1,168(sp)
    80004370:	f14a                	sd	s2,160(sp)
    80004372:	ed4e                	sd	s3,152(sp)
    80004374:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004376:	f4c40593          	addi	a1,s0,-180
    8000437a:	4505                	li	a0,1
    8000437c:	9e3fd0ef          	jal	ra,80001d5e <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004380:	08000613          	li	a2,128
    80004384:	f5040593          	addi	a1,s0,-176
    80004388:	4501                	li	a0,0
    8000438a:	a0dfd0ef          	jal	ra,80001d96 <argstr>
    8000438e:	87aa                	mv	a5,a0
    return -1;
    80004390:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004392:	0807cd63          	bltz	a5,8000442c <sys_open+0xc4>

  begin_op();
    80004396:	d1ffe0ef          	jal	ra,800030b4 <begin_op>

  if(omode & O_CREATE){
    8000439a:	f4c42783          	lw	a5,-180(s0)
    8000439e:	2007f793          	andi	a5,a5,512
    800043a2:	c3c5                	beqz	a5,80004442 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    800043a4:	4681                	li	a3,0
    800043a6:	4601                	li	a2,0
    800043a8:	4589                	li	a1,2
    800043aa:	f5040513          	addi	a0,s0,-176
    800043ae:	ac3ff0ef          	jal	ra,80003e70 <create>
    800043b2:	84aa                	mv	s1,a0
    if(ip == 0){
    800043b4:	c159                	beqz	a0,8000443a <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800043b6:	04449703          	lh	a4,68(s1)
    800043ba:	478d                	li	a5,3
    800043bc:	00f71763          	bne	a4,a5,800043ca <sys_open+0x62>
    800043c0:	0464d703          	lhu	a4,70(s1)
    800043c4:	47a5                	li	a5,9
    800043c6:	0ae7e963          	bltu	a5,a4,80004478 <sys_open+0x110>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800043ca:	862ff0ef          	jal	ra,8000342c <filealloc>
    800043ce:	89aa                	mv	s3,a0
    800043d0:	0c050963          	beqz	a0,800044a2 <sys_open+0x13a>
    800043d4:	a5fff0ef          	jal	ra,80003e32 <fdalloc>
    800043d8:	892a                	mv	s2,a0
    800043da:	0c054163          	bltz	a0,8000449c <sys_open+0x134>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800043de:	04449703          	lh	a4,68(s1)
    800043e2:	478d                	li	a5,3
    800043e4:	0af70163          	beq	a4,a5,80004486 <sys_open+0x11e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800043e8:	4789                	li	a5,2
    800043ea:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    800043ee:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    800043f2:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    800043f6:	f4c42783          	lw	a5,-180(s0)
    800043fa:	0017c713          	xori	a4,a5,1
    800043fe:	8b05                	andi	a4,a4,1
    80004400:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004404:	0037f713          	andi	a4,a5,3
    80004408:	00e03733          	snez	a4,a4
    8000440c:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004410:	4007f793          	andi	a5,a5,1024
    80004414:	c791                	beqz	a5,80004420 <sys_open+0xb8>
    80004416:	04449703          	lh	a4,68(s1)
    8000441a:	4789                	li	a5,2
    8000441c:	06f70c63          	beq	a4,a5,80004494 <sys_open+0x12c>
    itrunc(ip);
  }

  iunlock(ip);
    80004420:	8526                	mv	a0,s1
    80004422:	cb2fe0ef          	jal	ra,800028d4 <iunlock>
  end_op();
    80004426:	cfffe0ef          	jal	ra,80003124 <end_op>

  return fd;
    8000442a:	854a                	mv	a0,s2
}
    8000442c:	70ea                	ld	ra,184(sp)
    8000442e:	744a                	ld	s0,176(sp)
    80004430:	74aa                	ld	s1,168(sp)
    80004432:	790a                	ld	s2,160(sp)
    80004434:	69ea                	ld	s3,152(sp)
    80004436:	6129                	addi	sp,sp,192
    80004438:	8082                	ret
      end_op();
    8000443a:	cebfe0ef          	jal	ra,80003124 <end_op>
      return -1;
    8000443e:	557d                	li	a0,-1
    80004440:	b7f5                	j	8000442c <sys_open+0xc4>
    if((ip = namei(path)) == 0){
    80004442:	f5040513          	addi	a0,s0,-176
    80004446:	a97fe0ef          	jal	ra,80002edc <namei>
    8000444a:	84aa                	mv	s1,a0
    8000444c:	c115                	beqz	a0,80004470 <sys_open+0x108>
    ilock(ip);
    8000444e:	bdcfe0ef          	jal	ra,8000282a <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004452:	04449703          	lh	a4,68(s1)
    80004456:	4785                	li	a5,1
    80004458:	f4f71fe3          	bne	a4,a5,800043b6 <sys_open+0x4e>
    8000445c:	f4c42783          	lw	a5,-180(s0)
    80004460:	d7ad                	beqz	a5,800043ca <sys_open+0x62>
      iunlockput(ip);
    80004462:	8526                	mv	a0,s1
    80004464:	dccfe0ef          	jal	ra,80002a30 <iunlockput>
      end_op();
    80004468:	cbdfe0ef          	jal	ra,80003124 <end_op>
      return -1;
    8000446c:	557d                	li	a0,-1
    8000446e:	bf7d                	j	8000442c <sys_open+0xc4>
      end_op();
    80004470:	cb5fe0ef          	jal	ra,80003124 <end_op>
      return -1;
    80004474:	557d                	li	a0,-1
    80004476:	bf5d                	j	8000442c <sys_open+0xc4>
    iunlockput(ip);
    80004478:	8526                	mv	a0,s1
    8000447a:	db6fe0ef          	jal	ra,80002a30 <iunlockput>
    end_op();
    8000447e:	ca7fe0ef          	jal	ra,80003124 <end_op>
    return -1;
    80004482:	557d                	li	a0,-1
    80004484:	b765                	j	8000442c <sys_open+0xc4>
    f->type = FD_DEVICE;
    80004486:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    8000448a:	04649783          	lh	a5,70(s1)
    8000448e:	02f99223          	sh	a5,36(s3)
    80004492:	b785                	j	800043f2 <sys_open+0x8a>
    itrunc(ip);
    80004494:	8526                	mv	a0,s1
    80004496:	c7efe0ef          	jal	ra,80002914 <itrunc>
    8000449a:	b759                	j	80004420 <sys_open+0xb8>
      fileclose(f);
    8000449c:	854e                	mv	a0,s3
    8000449e:	832ff0ef          	jal	ra,800034d0 <fileclose>
    iunlockput(ip);
    800044a2:	8526                	mv	a0,s1
    800044a4:	d8cfe0ef          	jal	ra,80002a30 <iunlockput>
    end_op();
    800044a8:	c7dfe0ef          	jal	ra,80003124 <end_op>
    return -1;
    800044ac:	557d                	li	a0,-1
    800044ae:	bfbd                	j	8000442c <sys_open+0xc4>

00000000800044b0 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800044b0:	7175                	addi	sp,sp,-144
    800044b2:	e506                	sd	ra,136(sp)
    800044b4:	e122                	sd	s0,128(sp)
    800044b6:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800044b8:	bfdfe0ef          	jal	ra,800030b4 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    800044bc:	08000613          	li	a2,128
    800044c0:	f7040593          	addi	a1,s0,-144
    800044c4:	4501                	li	a0,0
    800044c6:	8d1fd0ef          	jal	ra,80001d96 <argstr>
    800044ca:	02054363          	bltz	a0,800044f0 <sys_mkdir+0x40>
    800044ce:	4681                	li	a3,0
    800044d0:	4601                	li	a2,0
    800044d2:	4585                	li	a1,1
    800044d4:	f7040513          	addi	a0,s0,-144
    800044d8:	999ff0ef          	jal	ra,80003e70 <create>
    800044dc:	c911                	beqz	a0,800044f0 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800044de:	d52fe0ef          	jal	ra,80002a30 <iunlockput>
  end_op();
    800044e2:	c43fe0ef          	jal	ra,80003124 <end_op>
  return 0;
    800044e6:	4501                	li	a0,0
}
    800044e8:	60aa                	ld	ra,136(sp)
    800044ea:	640a                	ld	s0,128(sp)
    800044ec:	6149                	addi	sp,sp,144
    800044ee:	8082                	ret
    end_op();
    800044f0:	c35fe0ef          	jal	ra,80003124 <end_op>
    return -1;
    800044f4:	557d                	li	a0,-1
    800044f6:	bfcd                	j	800044e8 <sys_mkdir+0x38>

00000000800044f8 <sys_mknod>:

uint64
sys_mknod(void)
{
    800044f8:	7135                	addi	sp,sp,-160
    800044fa:	ed06                	sd	ra,152(sp)
    800044fc:	e922                	sd	s0,144(sp)
    800044fe:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004500:	bb5fe0ef          	jal	ra,800030b4 <begin_op>
  argint(1, &major);
    80004504:	f6c40593          	addi	a1,s0,-148
    80004508:	4505                	li	a0,1
    8000450a:	855fd0ef          	jal	ra,80001d5e <argint>
  argint(2, &minor);
    8000450e:	f6840593          	addi	a1,s0,-152
    80004512:	4509                	li	a0,2
    80004514:	84bfd0ef          	jal	ra,80001d5e <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004518:	08000613          	li	a2,128
    8000451c:	f7040593          	addi	a1,s0,-144
    80004520:	4501                	li	a0,0
    80004522:	875fd0ef          	jal	ra,80001d96 <argstr>
    80004526:	02054563          	bltz	a0,80004550 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    8000452a:	f6841683          	lh	a3,-152(s0)
    8000452e:	f6c41603          	lh	a2,-148(s0)
    80004532:	458d                	li	a1,3
    80004534:	f7040513          	addi	a0,s0,-144
    80004538:	939ff0ef          	jal	ra,80003e70 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000453c:	c911                	beqz	a0,80004550 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000453e:	cf2fe0ef          	jal	ra,80002a30 <iunlockput>
  end_op();
    80004542:	be3fe0ef          	jal	ra,80003124 <end_op>
  return 0;
    80004546:	4501                	li	a0,0
}
    80004548:	60ea                	ld	ra,152(sp)
    8000454a:	644a                	ld	s0,144(sp)
    8000454c:	610d                	addi	sp,sp,160
    8000454e:	8082                	ret
    end_op();
    80004550:	bd5fe0ef          	jal	ra,80003124 <end_op>
    return -1;
    80004554:	557d                	li	a0,-1
    80004556:	bfcd                	j	80004548 <sys_mknod+0x50>

0000000080004558 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004558:	7135                	addi	sp,sp,-160
    8000455a:	ed06                	sd	ra,152(sp)
    8000455c:	e922                	sd	s0,144(sp)
    8000455e:	e526                	sd	s1,136(sp)
    80004560:	e14a                	sd	s2,128(sp)
    80004562:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004564:	8bdfc0ef          	jal	ra,80000e20 <myproc>
    80004568:	892a                	mv	s2,a0
  
  begin_op();
    8000456a:	b4bfe0ef          	jal	ra,800030b4 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    8000456e:	08000613          	li	a2,128
    80004572:	f6040593          	addi	a1,s0,-160
    80004576:	4501                	li	a0,0
    80004578:	81ffd0ef          	jal	ra,80001d96 <argstr>
    8000457c:	04054163          	bltz	a0,800045be <sys_chdir+0x66>
    80004580:	f6040513          	addi	a0,s0,-160
    80004584:	959fe0ef          	jal	ra,80002edc <namei>
    80004588:	84aa                	mv	s1,a0
    8000458a:	c915                	beqz	a0,800045be <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    8000458c:	a9efe0ef          	jal	ra,8000282a <ilock>
  if(ip->type != T_DIR){
    80004590:	04449703          	lh	a4,68(s1)
    80004594:	4785                	li	a5,1
    80004596:	02f71863          	bne	a4,a5,800045c6 <sys_chdir+0x6e>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000459a:	8526                	mv	a0,s1
    8000459c:	b38fe0ef          	jal	ra,800028d4 <iunlock>
  iput(p->cwd);
    800045a0:	15893503          	ld	a0,344(s2)
    800045a4:	c04fe0ef          	jal	ra,800029a8 <iput>
  end_op();
    800045a8:	b7dfe0ef          	jal	ra,80003124 <end_op>
  p->cwd = ip;
    800045ac:	14993c23          	sd	s1,344(s2)
  return 0;
    800045b0:	4501                	li	a0,0
}
    800045b2:	60ea                	ld	ra,152(sp)
    800045b4:	644a                	ld	s0,144(sp)
    800045b6:	64aa                	ld	s1,136(sp)
    800045b8:	690a                	ld	s2,128(sp)
    800045ba:	610d                	addi	sp,sp,160
    800045bc:	8082                	ret
    end_op();
    800045be:	b67fe0ef          	jal	ra,80003124 <end_op>
    return -1;
    800045c2:	557d                	li	a0,-1
    800045c4:	b7fd                	j	800045b2 <sys_chdir+0x5a>
    iunlockput(ip);
    800045c6:	8526                	mv	a0,s1
    800045c8:	c68fe0ef          	jal	ra,80002a30 <iunlockput>
    end_op();
    800045cc:	b59fe0ef          	jal	ra,80003124 <end_op>
    return -1;
    800045d0:	557d                	li	a0,-1
    800045d2:	b7c5                	j	800045b2 <sys_chdir+0x5a>

00000000800045d4 <sys_exec>:

uint64
sys_exec(void)
{
    800045d4:	7145                	addi	sp,sp,-464
    800045d6:	e786                	sd	ra,456(sp)
    800045d8:	e3a2                	sd	s0,448(sp)
    800045da:	ff26                	sd	s1,440(sp)
    800045dc:	fb4a                	sd	s2,432(sp)
    800045de:	f74e                	sd	s3,424(sp)
    800045e0:	f352                	sd	s4,416(sp)
    800045e2:	ef56                	sd	s5,408(sp)
    800045e4:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800045e6:	e3840593          	addi	a1,s0,-456
    800045ea:	4505                	li	a0,1
    800045ec:	f8efd0ef          	jal	ra,80001d7a <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800045f0:	08000613          	li	a2,128
    800045f4:	f4040593          	addi	a1,s0,-192
    800045f8:	4501                	li	a0,0
    800045fa:	f9cfd0ef          	jal	ra,80001d96 <argstr>
    800045fe:	87aa                	mv	a5,a0
    return -1;
    80004600:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004602:	0a07c463          	bltz	a5,800046aa <sys_exec+0xd6>
  }
  memset(argv, 0, sizeof(argv));
    80004606:	10000613          	li	a2,256
    8000460a:	4581                	li	a1,0
    8000460c:	e4040513          	addi	a0,s0,-448
    80004610:	b3dfb0ef          	jal	ra,8000014c <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004614:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004618:	89a6                	mv	s3,s1
    8000461a:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    8000461c:	02000a13          	li	s4,32
    80004620:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004624:	00391793          	slli	a5,s2,0x3
    80004628:	e3040593          	addi	a1,s0,-464
    8000462c:	e3843503          	ld	a0,-456(s0)
    80004630:	953e                	add	a0,a0,a5
    80004632:	ea2fd0ef          	jal	ra,80001cd4 <fetchaddr>
    80004636:	02054663          	bltz	a0,80004662 <sys_exec+0x8e>
      goto bad;
    }
    if(uarg == 0){
    8000463a:	e3043783          	ld	a5,-464(s0)
    8000463e:	cf8d                	beqz	a5,80004678 <sys_exec+0xa4>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004640:	abdfb0ef          	jal	ra,800000fc <kalloc>
    80004644:	85aa                	mv	a1,a0
    80004646:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000464a:	cd01                	beqz	a0,80004662 <sys_exec+0x8e>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000464c:	6605                	lui	a2,0x1
    8000464e:	e3043503          	ld	a0,-464(s0)
    80004652:	eccfd0ef          	jal	ra,80001d1e <fetchstr>
    80004656:	00054663          	bltz	a0,80004662 <sys_exec+0x8e>
    if(i >= NELEM(argv)){
    8000465a:	0905                	addi	s2,s2,1
    8000465c:	09a1                	addi	s3,s3,8
    8000465e:	fd4911e3          	bne	s2,s4,80004620 <sys_exec+0x4c>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004662:	10048913          	addi	s2,s1,256
    80004666:	6088                	ld	a0,0(s1)
    80004668:	c121                	beqz	a0,800046a8 <sys_exec+0xd4>
    kfree(argv[i]);
    8000466a:	9b3fb0ef          	jal	ra,8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000466e:	04a1                	addi	s1,s1,8
    80004670:	ff249be3          	bne	s1,s2,80004666 <sys_exec+0x92>
  return -1;
    80004674:	557d                	li	a0,-1
    80004676:	a815                	j	800046aa <sys_exec+0xd6>
      argv[i] = 0;
    80004678:	0a8e                	slli	s5,s5,0x3
    8000467a:	fc040793          	addi	a5,s0,-64
    8000467e:	9abe                	add	s5,s5,a5
    80004680:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004684:	e4040593          	addi	a1,s0,-448
    80004688:	f4040513          	addi	a0,s0,-192
    8000468c:	be6ff0ef          	jal	ra,80003a72 <exec>
    80004690:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004692:	10048993          	addi	s3,s1,256
    80004696:	6088                	ld	a0,0(s1)
    80004698:	c511                	beqz	a0,800046a4 <sys_exec+0xd0>
    kfree(argv[i]);
    8000469a:	983fb0ef          	jal	ra,8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000469e:	04a1                	addi	s1,s1,8
    800046a0:	ff349be3          	bne	s1,s3,80004696 <sys_exec+0xc2>
  return ret;
    800046a4:	854a                	mv	a0,s2
    800046a6:	a011                	j	800046aa <sys_exec+0xd6>
  return -1;
    800046a8:	557d                	li	a0,-1
}
    800046aa:	60be                	ld	ra,456(sp)
    800046ac:	641e                	ld	s0,448(sp)
    800046ae:	74fa                	ld	s1,440(sp)
    800046b0:	795a                	ld	s2,432(sp)
    800046b2:	79ba                	ld	s3,424(sp)
    800046b4:	7a1a                	ld	s4,416(sp)
    800046b6:	6afa                	ld	s5,408(sp)
    800046b8:	6179                	addi	sp,sp,464
    800046ba:	8082                	ret

00000000800046bc <sys_pipe>:

uint64
sys_pipe(void)
{
    800046bc:	7139                	addi	sp,sp,-64
    800046be:	fc06                	sd	ra,56(sp)
    800046c0:	f822                	sd	s0,48(sp)
    800046c2:	f426                	sd	s1,40(sp)
    800046c4:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800046c6:	f5afc0ef          	jal	ra,80000e20 <myproc>
    800046ca:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800046cc:	fd840593          	addi	a1,s0,-40
    800046d0:	4501                	li	a0,0
    800046d2:	ea8fd0ef          	jal	ra,80001d7a <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800046d6:	fc840593          	addi	a1,s0,-56
    800046da:	fd040513          	addi	a0,s0,-48
    800046de:	8beff0ef          	jal	ra,8000379c <pipealloc>
    return -1;
    800046e2:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800046e4:	0a054463          	bltz	a0,8000478c <sys_pipe+0xd0>
  fd0 = -1;
    800046e8:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800046ec:	fd043503          	ld	a0,-48(s0)
    800046f0:	f42ff0ef          	jal	ra,80003e32 <fdalloc>
    800046f4:	fca42223          	sw	a0,-60(s0)
    800046f8:	08054163          	bltz	a0,8000477a <sys_pipe+0xbe>
    800046fc:	fc843503          	ld	a0,-56(s0)
    80004700:	f32ff0ef          	jal	ra,80003e32 <fdalloc>
    80004704:	fca42023          	sw	a0,-64(s0)
    80004708:	06054063          	bltz	a0,80004768 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000470c:	4691                	li	a3,4
    8000470e:	fc440613          	addi	a2,s0,-60
    80004712:	fd843583          	ld	a1,-40(s0)
    80004716:	68e8                	ld	a0,208(s1)
    80004718:	aeefc0ef          	jal	ra,80000a06 <copyout>
    8000471c:	00054e63          	bltz	a0,80004738 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004720:	4691                	li	a3,4
    80004722:	fc040613          	addi	a2,s0,-64
    80004726:	fd843583          	ld	a1,-40(s0)
    8000472a:	0591                	addi	a1,a1,4
    8000472c:	68e8                	ld	a0,208(s1)
    8000472e:	ad8fc0ef          	jal	ra,80000a06 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004732:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004734:	04055c63          	bgez	a0,8000478c <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    80004738:	fc442783          	lw	a5,-60(s0)
    8000473c:	07e9                	addi	a5,a5,26
    8000473e:	078e                	slli	a5,a5,0x3
    80004740:	97a6                	add	a5,a5,s1
    80004742:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80004746:	fc042503          	lw	a0,-64(s0)
    8000474a:	0569                	addi	a0,a0,26
    8000474c:	050e                	slli	a0,a0,0x3
    8000474e:	94aa                	add	s1,s1,a0
    80004750:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    80004754:	fd043503          	ld	a0,-48(s0)
    80004758:	d79fe0ef          	jal	ra,800034d0 <fileclose>
    fileclose(wf);
    8000475c:	fc843503          	ld	a0,-56(s0)
    80004760:	d71fe0ef          	jal	ra,800034d0 <fileclose>
    return -1;
    80004764:	57fd                	li	a5,-1
    80004766:	a01d                	j	8000478c <sys_pipe+0xd0>
    if(fd0 >= 0)
    80004768:	fc442783          	lw	a5,-60(s0)
    8000476c:	0007c763          	bltz	a5,8000477a <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80004770:	07e9                	addi	a5,a5,26
    80004772:	078e                	slli	a5,a5,0x3
    80004774:	94be                	add	s1,s1,a5
    80004776:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    8000477a:	fd043503          	ld	a0,-48(s0)
    8000477e:	d53fe0ef          	jal	ra,800034d0 <fileclose>
    fileclose(wf);
    80004782:	fc843503          	ld	a0,-56(s0)
    80004786:	d4bfe0ef          	jal	ra,800034d0 <fileclose>
    return -1;
    8000478a:	57fd                	li	a5,-1
}
    8000478c:	853e                	mv	a0,a5
    8000478e:	70e2                	ld	ra,56(sp)
    80004790:	7442                	ld	s0,48(sp)
    80004792:	74a2                	ld	s1,40(sp)
    80004794:	6121                	addi	sp,sp,64
    80004796:	8082                	ret
	...

00000000800047a0 <kernelvec>:
    800047a0:	7111                	addi	sp,sp,-256
    800047a2:	e006                	sd	ra,0(sp)
    800047a4:	e40a                	sd	sp,8(sp)
    800047a6:	e80e                	sd	gp,16(sp)
    800047a8:	ec12                	sd	tp,24(sp)
    800047aa:	f016                	sd	t0,32(sp)
    800047ac:	f41a                	sd	t1,40(sp)
    800047ae:	f81e                	sd	t2,48(sp)
    800047b0:	e4aa                	sd	a0,72(sp)
    800047b2:	e8ae                	sd	a1,80(sp)
    800047b4:	ecb2                	sd	a2,88(sp)
    800047b6:	f0b6                	sd	a3,96(sp)
    800047b8:	f4ba                	sd	a4,104(sp)
    800047ba:	f8be                	sd	a5,112(sp)
    800047bc:	fcc2                	sd	a6,120(sp)
    800047be:	e146                	sd	a7,128(sp)
    800047c0:	edf2                	sd	t3,216(sp)
    800047c2:	f1f6                	sd	t4,224(sp)
    800047c4:	f5fa                	sd	t5,232(sp)
    800047c6:	f9fe                	sd	t6,240(sp)
    800047c8:	c1cfd0ef          	jal	ra,80001be4 <kerneltrap>
    800047cc:	6082                	ld	ra,0(sp)
    800047ce:	6122                	ld	sp,8(sp)
    800047d0:	61c2                	ld	gp,16(sp)
    800047d2:	7282                	ld	t0,32(sp)
    800047d4:	7322                	ld	t1,40(sp)
    800047d6:	73c2                	ld	t2,48(sp)
    800047d8:	6526                	ld	a0,72(sp)
    800047da:	65c6                	ld	a1,80(sp)
    800047dc:	6666                	ld	a2,88(sp)
    800047de:	7686                	ld	a3,96(sp)
    800047e0:	7726                	ld	a4,104(sp)
    800047e2:	77c6                	ld	a5,112(sp)
    800047e4:	7866                	ld	a6,120(sp)
    800047e6:	688a                	ld	a7,128(sp)
    800047e8:	6e6e                	ld	t3,216(sp)
    800047ea:	7e8e                	ld	t4,224(sp)
    800047ec:	7f2e                	ld	t5,232(sp)
    800047ee:	7fce                	ld	t6,240(sp)
    800047f0:	6111                	addi	sp,sp,256
    800047f2:	10200073          	sret
	...

00000000800047fe <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800047fe:	1141                	addi	sp,sp,-16
    80004800:	e422                	sd	s0,8(sp)
    80004802:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80004804:	0c0007b7          	lui	a5,0xc000
    80004808:	4705                	li	a4,1
    8000480a:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000480c:	c3d8                	sw	a4,4(a5)
}
    8000480e:	6422                	ld	s0,8(sp)
    80004810:	0141                	addi	sp,sp,16
    80004812:	8082                	ret

0000000080004814 <plicinithart>:

void
plicinithart(void)
{
    80004814:	1141                	addi	sp,sp,-16
    80004816:	e406                	sd	ra,8(sp)
    80004818:	e022                	sd	s0,0(sp)
    8000481a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000481c:	dd8fc0ef          	jal	ra,80000df4 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80004820:	0085171b          	slliw	a4,a0,0x8
    80004824:	0c0027b7          	lui	a5,0xc002
    80004828:	97ba                	add	a5,a5,a4
    8000482a:	40200713          	li	a4,1026
    8000482e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80004832:	00d5151b          	slliw	a0,a0,0xd
    80004836:	0c2017b7          	lui	a5,0xc201
    8000483a:	953e                	add	a0,a0,a5
    8000483c:	00052023          	sw	zero,0(a0)
}
    80004840:	60a2                	ld	ra,8(sp)
    80004842:	6402                	ld	s0,0(sp)
    80004844:	0141                	addi	sp,sp,16
    80004846:	8082                	ret

0000000080004848 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80004848:	1141                	addi	sp,sp,-16
    8000484a:	e406                	sd	ra,8(sp)
    8000484c:	e022                	sd	s0,0(sp)
    8000484e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004850:	da4fc0ef          	jal	ra,80000df4 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80004854:	00d5179b          	slliw	a5,a0,0xd
    80004858:	0c201537          	lui	a0,0xc201
    8000485c:	953e                	add	a0,a0,a5
  return irq;
}
    8000485e:	4148                	lw	a0,4(a0)
    80004860:	60a2                	ld	ra,8(sp)
    80004862:	6402                	ld	s0,0(sp)
    80004864:	0141                	addi	sp,sp,16
    80004866:	8082                	ret

0000000080004868 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80004868:	1101                	addi	sp,sp,-32
    8000486a:	ec06                	sd	ra,24(sp)
    8000486c:	e822                	sd	s0,16(sp)
    8000486e:	e426                	sd	s1,8(sp)
    80004870:	1000                	addi	s0,sp,32
    80004872:	84aa                	mv	s1,a0
  int hart = cpuid();
    80004874:	d80fc0ef          	jal	ra,80000df4 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80004878:	00d5151b          	slliw	a0,a0,0xd
    8000487c:	0c2017b7          	lui	a5,0xc201
    80004880:	97aa                	add	a5,a5,a0
    80004882:	c3c4                	sw	s1,4(a5)
}
    80004884:	60e2                	ld	ra,24(sp)
    80004886:	6442                	ld	s0,16(sp)
    80004888:	64a2                	ld	s1,8(sp)
    8000488a:	6105                	addi	sp,sp,32
    8000488c:	8082                	ret

000000008000488e <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000488e:	1141                	addi	sp,sp,-16
    80004890:	e406                	sd	ra,8(sp)
    80004892:	e022                	sd	s0,0(sp)
    80004894:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80004896:	479d                	li	a5,7
    80004898:	04a7ca63          	blt	a5,a0,800048ec <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    8000489c:	00014797          	auipc	a5,0x14
    800048a0:	39478793          	addi	a5,a5,916 # 80018c30 <disk>
    800048a4:	97aa                	add	a5,a5,a0
    800048a6:	0187c783          	lbu	a5,24(a5)
    800048aa:	e7b9                	bnez	a5,800048f8 <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800048ac:	00451613          	slli	a2,a0,0x4
    800048b0:	00014797          	auipc	a5,0x14
    800048b4:	38078793          	addi	a5,a5,896 # 80018c30 <disk>
    800048b8:	6394                	ld	a3,0(a5)
    800048ba:	96b2                	add	a3,a3,a2
    800048bc:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800048c0:	6398                	ld	a4,0(a5)
    800048c2:	9732                	add	a4,a4,a2
    800048c4:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800048c8:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800048cc:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800048d0:	953e                	add	a0,a0,a5
    800048d2:	4785                	li	a5,1
    800048d4:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    800048d8:	00014517          	auipc	a0,0x14
    800048dc:	37050513          	addi	a0,a0,880 # 80018c48 <disk+0x18>
    800048e0:	bebfc0ef          	jal	ra,800014ca <wakeup>
}
    800048e4:	60a2                	ld	ra,8(sp)
    800048e6:	6402                	ld	s0,0(sp)
    800048e8:	0141                	addi	sp,sp,16
    800048ea:	8082                	ret
    panic("free_desc 1");
    800048ec:	00003517          	auipc	a0,0x3
    800048f0:	e5450513          	addi	a0,a0,-428 # 80007740 <syscalls+0x2f8>
    800048f4:	3c3000ef          	jal	ra,800054b6 <panic>
    panic("free_desc 2");
    800048f8:	00003517          	auipc	a0,0x3
    800048fc:	e5850513          	addi	a0,a0,-424 # 80007750 <syscalls+0x308>
    80004900:	3b7000ef          	jal	ra,800054b6 <panic>

0000000080004904 <virtio_disk_init>:
{
    80004904:	1101                	addi	sp,sp,-32
    80004906:	ec06                	sd	ra,24(sp)
    80004908:	e822                	sd	s0,16(sp)
    8000490a:	e426                	sd	s1,8(sp)
    8000490c:	e04a                	sd	s2,0(sp)
    8000490e:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80004910:	00003597          	auipc	a1,0x3
    80004914:	e5058593          	addi	a1,a1,-432 # 80007760 <syscalls+0x318>
    80004918:	00014517          	auipc	a0,0x14
    8000491c:	44050513          	addi	a0,a0,1088 # 80018d58 <disk+0x128>
    80004920:	62b000ef          	jal	ra,8000574a <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004924:	100017b7          	lui	a5,0x10001
    80004928:	4398                	lw	a4,0(a5)
    8000492a:	2701                	sext.w	a4,a4
    8000492c:	747277b7          	lui	a5,0x74727
    80004930:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80004934:	14f71063          	bne	a4,a5,80004a74 <virtio_disk_init+0x170>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004938:	100017b7          	lui	a5,0x10001
    8000493c:	43dc                	lw	a5,4(a5)
    8000493e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004940:	4709                	li	a4,2
    80004942:	12e79963          	bne	a5,a4,80004a74 <virtio_disk_init+0x170>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004946:	100017b7          	lui	a5,0x10001
    8000494a:	479c                	lw	a5,8(a5)
    8000494c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000494e:	12e79363          	bne	a5,a4,80004a74 <virtio_disk_init+0x170>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80004952:	100017b7          	lui	a5,0x10001
    80004956:	47d8                	lw	a4,12(a5)
    80004958:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000495a:	554d47b7          	lui	a5,0x554d4
    8000495e:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80004962:	10f71963          	bne	a4,a5,80004a74 <virtio_disk_init+0x170>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004966:	100017b7          	lui	a5,0x10001
    8000496a:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000496e:	4705                	li	a4,1
    80004970:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004972:	470d                	li	a4,3
    80004974:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80004976:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80004978:	c7ffe737          	lui	a4,0xc7ffe
    8000497c:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdd8ef>
    80004980:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80004982:	2701                	sext.w	a4,a4
    80004984:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004986:	472d                	li	a4,11
    80004988:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    8000498a:	5bbc                	lw	a5,112(a5)
    8000498c:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80004990:	8ba1                	andi	a5,a5,8
    80004992:	0e078763          	beqz	a5,80004a80 <virtio_disk_init+0x17c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80004996:	100017b7          	lui	a5,0x10001
    8000499a:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    8000499e:	43fc                	lw	a5,68(a5)
    800049a0:	2781                	sext.w	a5,a5
    800049a2:	0e079563          	bnez	a5,80004a8c <virtio_disk_init+0x188>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800049a6:	100017b7          	lui	a5,0x10001
    800049aa:	5bdc                	lw	a5,52(a5)
    800049ac:	2781                	sext.w	a5,a5
  if(max == 0)
    800049ae:	0e078563          	beqz	a5,80004a98 <virtio_disk_init+0x194>
  if(max < NUM)
    800049b2:	471d                	li	a4,7
    800049b4:	0ef77863          	bgeu	a4,a5,80004aa4 <virtio_disk_init+0x1a0>
  disk.desc = kalloc();
    800049b8:	f44fb0ef          	jal	ra,800000fc <kalloc>
    800049bc:	00014497          	auipc	s1,0x14
    800049c0:	27448493          	addi	s1,s1,628 # 80018c30 <disk>
    800049c4:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800049c6:	f36fb0ef          	jal	ra,800000fc <kalloc>
    800049ca:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800049cc:	f30fb0ef          	jal	ra,800000fc <kalloc>
    800049d0:	87aa                	mv	a5,a0
    800049d2:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800049d4:	6088                	ld	a0,0(s1)
    800049d6:	cd69                	beqz	a0,80004ab0 <virtio_disk_init+0x1ac>
    800049d8:	00014717          	auipc	a4,0x14
    800049dc:	26073703          	ld	a4,608(a4) # 80018c38 <disk+0x8>
    800049e0:	cb61                	beqz	a4,80004ab0 <virtio_disk_init+0x1ac>
    800049e2:	c7f9                	beqz	a5,80004ab0 <virtio_disk_init+0x1ac>
  memset(disk.desc, 0, PGSIZE);
    800049e4:	6605                	lui	a2,0x1
    800049e6:	4581                	li	a1,0
    800049e8:	f64fb0ef          	jal	ra,8000014c <memset>
  memset(disk.avail, 0, PGSIZE);
    800049ec:	00014497          	auipc	s1,0x14
    800049f0:	24448493          	addi	s1,s1,580 # 80018c30 <disk>
    800049f4:	6605                	lui	a2,0x1
    800049f6:	4581                	li	a1,0
    800049f8:	6488                	ld	a0,8(s1)
    800049fa:	f52fb0ef          	jal	ra,8000014c <memset>
  memset(disk.used, 0, PGSIZE);
    800049fe:	6605                	lui	a2,0x1
    80004a00:	4581                	li	a1,0
    80004a02:	6888                	ld	a0,16(s1)
    80004a04:	f48fb0ef          	jal	ra,8000014c <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80004a08:	100017b7          	lui	a5,0x10001
    80004a0c:	4721                	li	a4,8
    80004a0e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80004a10:	4098                	lw	a4,0(s1)
    80004a12:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80004a16:	40d8                	lw	a4,4(s1)
    80004a18:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80004a1c:	6498                	ld	a4,8(s1)
    80004a1e:	0007069b          	sext.w	a3,a4
    80004a22:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80004a26:	9701                	srai	a4,a4,0x20
    80004a28:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80004a2c:	6898                	ld	a4,16(s1)
    80004a2e:	0007069b          	sext.w	a3,a4
    80004a32:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80004a36:	9701                	srai	a4,a4,0x20
    80004a38:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80004a3c:	4705                	li	a4,1
    80004a3e:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    80004a40:	00e48c23          	sb	a4,24(s1)
    80004a44:	00e48ca3          	sb	a4,25(s1)
    80004a48:	00e48d23          	sb	a4,26(s1)
    80004a4c:	00e48da3          	sb	a4,27(s1)
    80004a50:	00e48e23          	sb	a4,28(s1)
    80004a54:	00e48ea3          	sb	a4,29(s1)
    80004a58:	00e48f23          	sb	a4,30(s1)
    80004a5c:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004a60:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a64:	0727a823          	sw	s2,112(a5)
}
    80004a68:	60e2                	ld	ra,24(sp)
    80004a6a:	6442                	ld	s0,16(sp)
    80004a6c:	64a2                	ld	s1,8(sp)
    80004a6e:	6902                	ld	s2,0(sp)
    80004a70:	6105                	addi	sp,sp,32
    80004a72:	8082                	ret
    panic("could not find virtio disk");
    80004a74:	00003517          	auipc	a0,0x3
    80004a78:	cfc50513          	addi	a0,a0,-772 # 80007770 <syscalls+0x328>
    80004a7c:	23b000ef          	jal	ra,800054b6 <panic>
    panic("virtio disk FEATURES_OK unset");
    80004a80:	00003517          	auipc	a0,0x3
    80004a84:	d1050513          	addi	a0,a0,-752 # 80007790 <syscalls+0x348>
    80004a88:	22f000ef          	jal	ra,800054b6 <panic>
    panic("virtio disk should not be ready");
    80004a8c:	00003517          	auipc	a0,0x3
    80004a90:	d2450513          	addi	a0,a0,-732 # 800077b0 <syscalls+0x368>
    80004a94:	223000ef          	jal	ra,800054b6 <panic>
    panic("virtio disk has no queue 0");
    80004a98:	00003517          	auipc	a0,0x3
    80004a9c:	d3850513          	addi	a0,a0,-712 # 800077d0 <syscalls+0x388>
    80004aa0:	217000ef          	jal	ra,800054b6 <panic>
    panic("virtio disk max queue too short");
    80004aa4:	00003517          	auipc	a0,0x3
    80004aa8:	d4c50513          	addi	a0,a0,-692 # 800077f0 <syscalls+0x3a8>
    80004aac:	20b000ef          	jal	ra,800054b6 <panic>
    panic("virtio disk kalloc");
    80004ab0:	00003517          	auipc	a0,0x3
    80004ab4:	d6050513          	addi	a0,a0,-672 # 80007810 <syscalls+0x3c8>
    80004ab8:	1ff000ef          	jal	ra,800054b6 <panic>

0000000080004abc <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80004abc:	7119                	addi	sp,sp,-128
    80004abe:	fc86                	sd	ra,120(sp)
    80004ac0:	f8a2                	sd	s0,112(sp)
    80004ac2:	f4a6                	sd	s1,104(sp)
    80004ac4:	f0ca                	sd	s2,96(sp)
    80004ac6:	ecce                	sd	s3,88(sp)
    80004ac8:	e8d2                	sd	s4,80(sp)
    80004aca:	e4d6                	sd	s5,72(sp)
    80004acc:	e0da                	sd	s6,64(sp)
    80004ace:	fc5e                	sd	s7,56(sp)
    80004ad0:	f862                	sd	s8,48(sp)
    80004ad2:	f466                	sd	s9,40(sp)
    80004ad4:	f06a                	sd	s10,32(sp)
    80004ad6:	ec6e                	sd	s11,24(sp)
    80004ad8:	0100                	addi	s0,sp,128
    80004ada:	8aaa                	mv	s5,a0
    80004adc:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80004ade:	00c52d03          	lw	s10,12(a0)
    80004ae2:	001d1d1b          	slliw	s10,s10,0x1
    80004ae6:	1d02                	slli	s10,s10,0x20
    80004ae8:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    80004aec:	00014517          	auipc	a0,0x14
    80004af0:	26c50513          	addi	a0,a0,620 # 80018d58 <disk+0x128>
    80004af4:	4d7000ef          	jal	ra,800057ca <acquire>
  for(int i = 0; i < 3; i++){
    80004af8:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80004afa:	44a1                	li	s1,8
      disk.free[i] = 0;
    80004afc:	00014b97          	auipc	s7,0x14
    80004b00:	134b8b93          	addi	s7,s7,308 # 80018c30 <disk>
  for(int i = 0; i < 3; i++){
    80004b04:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004b06:	00014c97          	auipc	s9,0x14
    80004b0a:	252c8c93          	addi	s9,s9,594 # 80018d58 <disk+0x128>
    80004b0e:	a8a9                	j	80004b68 <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80004b10:	00fb8733          	add	a4,s7,a5
    80004b14:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80004b18:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004b1a:	0207c563          	bltz	a5,80004b44 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80004b1e:	2905                	addiw	s2,s2,1
    80004b20:	0611                	addi	a2,a2,4
    80004b22:	05690863          	beq	s2,s6,80004b72 <virtio_disk_rw+0xb6>
    idx[i] = alloc_desc();
    80004b26:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004b28:	00014717          	auipc	a4,0x14
    80004b2c:	10870713          	addi	a4,a4,264 # 80018c30 <disk>
    80004b30:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80004b32:	01874683          	lbu	a3,24(a4)
    80004b36:	fee9                	bnez	a3,80004b10 <virtio_disk_rw+0x54>
  for(int i = 0; i < NUM; i++){
    80004b38:	2785                	addiw	a5,a5,1
    80004b3a:	0705                	addi	a4,a4,1
    80004b3c:	fe979be3          	bne	a5,s1,80004b32 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80004b40:	57fd                	li	a5,-1
    80004b42:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80004b44:	01205b63          	blez	s2,80004b5a <virtio_disk_rw+0x9e>
    80004b48:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80004b4a:	000a2503          	lw	a0,0(s4)
    80004b4e:	d41ff0ef          	jal	ra,8000488e <free_desc>
      for(int j = 0; j < i; j++)
    80004b52:	2d85                	addiw	s11,s11,1
    80004b54:	0a11                	addi	s4,s4,4
    80004b56:	ffb91ae3          	bne	s2,s11,80004b4a <virtio_disk_rw+0x8e>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004b5a:	85e6                	mv	a1,s9
    80004b5c:	00014517          	auipc	a0,0x14
    80004b60:	0ec50513          	addi	a0,a0,236 # 80018c48 <disk+0x18>
    80004b64:	91bfc0ef          	jal	ra,8000147e <sleep>
  for(int i = 0; i < 3; i++){
    80004b68:	f8040a13          	addi	s4,s0,-128
{
    80004b6c:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80004b6e:	894e                	mv	s2,s3
    80004b70:	bf5d                	j	80004b26 <virtio_disk_rw+0x6a>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004b72:	f8042583          	lw	a1,-128(s0)
    80004b76:	00a58793          	addi	a5,a1,10
    80004b7a:	0792                	slli	a5,a5,0x4

  if(write)
    80004b7c:	00014617          	auipc	a2,0x14
    80004b80:	0b460613          	addi	a2,a2,180 # 80018c30 <disk>
    80004b84:	00f60733          	add	a4,a2,a5
    80004b88:	018036b3          	snez	a3,s8
    80004b8c:	c714                	sw	a3,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004b8e:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80004b92:	01a73823          	sd	s10,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004b96:	f6078693          	addi	a3,a5,-160
    80004b9a:	6218                	ld	a4,0(a2)
    80004b9c:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004b9e:	00878513          	addi	a0,a5,8
    80004ba2:	9532                	add	a0,a0,a2
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004ba4:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004ba6:	6208                	ld	a0,0(a2)
    80004ba8:	96aa                	add	a3,a3,a0
    80004baa:	4741                	li	a4,16
    80004bac:	c698                	sw	a4,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004bae:	4705                	li	a4,1
    80004bb0:	00e69623          	sh	a4,12(a3)
  disk.desc[idx[0]].next = idx[1];
    80004bb4:	f8442703          	lw	a4,-124(s0)
    80004bb8:	00e69723          	sh	a4,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004bbc:	0712                	slli	a4,a4,0x4
    80004bbe:	953a                	add	a0,a0,a4
    80004bc0:	058a8693          	addi	a3,s5,88
    80004bc4:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    80004bc6:	6208                	ld	a0,0(a2)
    80004bc8:	972a                	add	a4,a4,a0
    80004bca:	40000693          	li	a3,1024
    80004bce:	c714                	sw	a3,8(a4)
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80004bd0:	001c3c13          	seqz	s8,s8
    80004bd4:	0c06                	slli	s8,s8,0x1
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004bd6:	001c6c13          	ori	s8,s8,1
    80004bda:	01871623          	sh	s8,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80004bde:	f8842603          	lw	a2,-120(s0)
    80004be2:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004be6:	00014697          	auipc	a3,0x14
    80004bea:	04a68693          	addi	a3,a3,74 # 80018c30 <disk>
    80004bee:	00258713          	addi	a4,a1,2
    80004bf2:	0712                	slli	a4,a4,0x4
    80004bf4:	9736                	add	a4,a4,a3
    80004bf6:	587d                	li	a6,-1
    80004bf8:	01070823          	sb	a6,16(a4)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004bfc:	0612                	slli	a2,a2,0x4
    80004bfe:	9532                	add	a0,a0,a2
    80004c00:	f9078793          	addi	a5,a5,-112
    80004c04:	97b6                	add	a5,a5,a3
    80004c06:	e11c                	sd	a5,0(a0)
  disk.desc[idx[2]].len = 1;
    80004c08:	629c                	ld	a5,0(a3)
    80004c0a:	97b2                	add	a5,a5,a2
    80004c0c:	4605                	li	a2,1
    80004c0e:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004c10:	4509                	li	a0,2
    80004c12:	00a79623          	sh	a0,12(a5)
  disk.desc[idx[2]].next = 0;
    80004c16:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004c1a:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    80004c1e:	01573423          	sd	s5,8(a4)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004c22:	6698                	ld	a4,8(a3)
    80004c24:	00275783          	lhu	a5,2(a4)
    80004c28:	8b9d                	andi	a5,a5,7
    80004c2a:	0786                	slli	a5,a5,0x1
    80004c2c:	97ba                	add	a5,a5,a4
    80004c2e:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80004c32:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004c36:	6698                	ld	a4,8(a3)
    80004c38:	00275783          	lhu	a5,2(a4)
    80004c3c:	2785                	addiw	a5,a5,1
    80004c3e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004c42:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004c46:	100017b7          	lui	a5,0x10001
    80004c4a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004c4e:	004aa783          	lw	a5,4(s5)
    80004c52:	00c79f63          	bne	a5,a2,80004c70 <virtio_disk_rw+0x1b4>
    sleep(b, &disk.vdisk_lock);
    80004c56:	00014917          	auipc	s2,0x14
    80004c5a:	10290913          	addi	s2,s2,258 # 80018d58 <disk+0x128>
  while(b->disk == 1) {
    80004c5e:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80004c60:	85ca                	mv	a1,s2
    80004c62:	8556                	mv	a0,s5
    80004c64:	81bfc0ef          	jal	ra,8000147e <sleep>
  while(b->disk == 1) {
    80004c68:	004aa783          	lw	a5,4(s5)
    80004c6c:	fe978ae3          	beq	a5,s1,80004c60 <virtio_disk_rw+0x1a4>
  }

  disk.info[idx[0]].b = 0;
    80004c70:	f8042903          	lw	s2,-128(s0)
    80004c74:	00290793          	addi	a5,s2,2
    80004c78:	00479713          	slli	a4,a5,0x4
    80004c7c:	00014797          	auipc	a5,0x14
    80004c80:	fb478793          	addi	a5,a5,-76 # 80018c30 <disk>
    80004c84:	97ba                	add	a5,a5,a4
    80004c86:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004c8a:	00014997          	auipc	s3,0x14
    80004c8e:	fa698993          	addi	s3,s3,-90 # 80018c30 <disk>
    80004c92:	00491713          	slli	a4,s2,0x4
    80004c96:	0009b783          	ld	a5,0(s3)
    80004c9a:	97ba                	add	a5,a5,a4
    80004c9c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004ca0:	854a                	mv	a0,s2
    80004ca2:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004ca6:	be9ff0ef          	jal	ra,8000488e <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004caa:	8885                	andi	s1,s1,1
    80004cac:	f0fd                	bnez	s1,80004c92 <virtio_disk_rw+0x1d6>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004cae:	00014517          	auipc	a0,0x14
    80004cb2:	0aa50513          	addi	a0,a0,170 # 80018d58 <disk+0x128>
    80004cb6:	3ad000ef          	jal	ra,80005862 <release>
}
    80004cba:	70e6                	ld	ra,120(sp)
    80004cbc:	7446                	ld	s0,112(sp)
    80004cbe:	74a6                	ld	s1,104(sp)
    80004cc0:	7906                	ld	s2,96(sp)
    80004cc2:	69e6                	ld	s3,88(sp)
    80004cc4:	6a46                	ld	s4,80(sp)
    80004cc6:	6aa6                	ld	s5,72(sp)
    80004cc8:	6b06                	ld	s6,64(sp)
    80004cca:	7be2                	ld	s7,56(sp)
    80004ccc:	7c42                	ld	s8,48(sp)
    80004cce:	7ca2                	ld	s9,40(sp)
    80004cd0:	7d02                	ld	s10,32(sp)
    80004cd2:	6de2                	ld	s11,24(sp)
    80004cd4:	6109                	addi	sp,sp,128
    80004cd6:	8082                	ret

0000000080004cd8 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80004cd8:	1101                	addi	sp,sp,-32
    80004cda:	ec06                	sd	ra,24(sp)
    80004cdc:	e822                	sd	s0,16(sp)
    80004cde:	e426                	sd	s1,8(sp)
    80004ce0:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80004ce2:	00014497          	auipc	s1,0x14
    80004ce6:	f4e48493          	addi	s1,s1,-178 # 80018c30 <disk>
    80004cea:	00014517          	auipc	a0,0x14
    80004cee:	06e50513          	addi	a0,a0,110 # 80018d58 <disk+0x128>
    80004cf2:	2d9000ef          	jal	ra,800057ca <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80004cf6:	10001737          	lui	a4,0x10001
    80004cfa:	533c                	lw	a5,96(a4)
    80004cfc:	8b8d                	andi	a5,a5,3
    80004cfe:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80004d00:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80004d04:	689c                	ld	a5,16(s1)
    80004d06:	0204d703          	lhu	a4,32(s1)
    80004d0a:	0027d783          	lhu	a5,2(a5)
    80004d0e:	04f70663          	beq	a4,a5,80004d5a <virtio_disk_intr+0x82>
    __sync_synchronize();
    80004d12:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80004d16:	6898                	ld	a4,16(s1)
    80004d18:	0204d783          	lhu	a5,32(s1)
    80004d1c:	8b9d                	andi	a5,a5,7
    80004d1e:	078e                	slli	a5,a5,0x3
    80004d20:	97ba                	add	a5,a5,a4
    80004d22:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80004d24:	00278713          	addi	a4,a5,2
    80004d28:	0712                	slli	a4,a4,0x4
    80004d2a:	9726                	add	a4,a4,s1
    80004d2c:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80004d30:	e321                	bnez	a4,80004d70 <virtio_disk_intr+0x98>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80004d32:	0789                	addi	a5,a5,2
    80004d34:	0792                	slli	a5,a5,0x4
    80004d36:	97a6                	add	a5,a5,s1
    80004d38:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80004d3a:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80004d3e:	f8cfc0ef          	jal	ra,800014ca <wakeup>

    disk.used_idx += 1;
    80004d42:	0204d783          	lhu	a5,32(s1)
    80004d46:	2785                	addiw	a5,a5,1
    80004d48:	17c2                	slli	a5,a5,0x30
    80004d4a:	93c1                	srli	a5,a5,0x30
    80004d4c:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80004d50:	6898                	ld	a4,16(s1)
    80004d52:	00275703          	lhu	a4,2(a4)
    80004d56:	faf71ee3          	bne	a4,a5,80004d12 <virtio_disk_intr+0x3a>
  }

  release(&disk.vdisk_lock);
    80004d5a:	00014517          	auipc	a0,0x14
    80004d5e:	ffe50513          	addi	a0,a0,-2 # 80018d58 <disk+0x128>
    80004d62:	301000ef          	jal	ra,80005862 <release>
}
    80004d66:	60e2                	ld	ra,24(sp)
    80004d68:	6442                	ld	s0,16(sp)
    80004d6a:	64a2                	ld	s1,8(sp)
    80004d6c:	6105                	addi	sp,sp,32
    80004d6e:	8082                	ret
      panic("virtio_disk_intr status");
    80004d70:	00003517          	auipc	a0,0x3
    80004d74:	ab850513          	addi	a0,a0,-1352 # 80007828 <syscalls+0x3e0>
    80004d78:	73e000ef          	jal	ra,800054b6 <panic>

0000000080004d7c <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    80004d7c:	1141                	addi	sp,sp,-16
    80004d7e:	e422                	sd	s0,8(sp)
    80004d80:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80004d82:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80004d86:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    80004d8a:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80004d8e:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80004d92:	577d                	li	a4,-1
    80004d94:	177e                	slli	a4,a4,0x3f
    80004d96:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80004d98:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80004d9c:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80004da0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80004da4:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80004da8:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80004dac:	000f4737          	lui	a4,0xf4
    80004db0:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80004db4:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80004db6:	14d79073          	csrw	0x14d,a5
}
    80004dba:	6422                	ld	s0,8(sp)
    80004dbc:	0141                	addi	sp,sp,16
    80004dbe:	8082                	ret

0000000080004dc0 <start>:
{
    80004dc0:	1141                	addi	sp,sp,-16
    80004dc2:	e406                	sd	ra,8(sp)
    80004dc4:	e022                	sd	s0,0(sp)
    80004dc6:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80004dc8:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80004dcc:	7779                	lui	a4,0xffffe
    80004dce:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdd98f>
    80004dd2:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80004dd4:	6705                	lui	a4,0x1
    80004dd6:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80004dda:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80004ddc:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80004de0:	ffffb797          	auipc	a5,0xffffb
    80004de4:	50e78793          	addi	a5,a5,1294 # 800002ee <main>
    80004de8:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80004dec:	4781                	li	a5,0
    80004dee:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80004df2:	67c1                	lui	a5,0x10
    80004df4:	17fd                	addi	a5,a5,-1
    80004df6:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80004dfa:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80004dfe:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80004e02:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80004e06:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80004e0a:	57fd                	li	a5,-1
    80004e0c:	83a9                	srli	a5,a5,0xa
    80004e0e:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80004e12:	47bd                	li	a5,15
    80004e14:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80004e18:	f65ff0ef          	jal	ra,80004d7c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80004e1c:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80004e20:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80004e22:	823e                	mv	tp,a5
  asm volatile("mret");
    80004e24:	30200073          	mret
}
    80004e28:	60a2                	ld	ra,8(sp)
    80004e2a:	6402                	ld	s0,0(sp)
    80004e2c:	0141                	addi	sp,sp,16
    80004e2e:	8082                	ret

0000000080004e30 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80004e30:	715d                	addi	sp,sp,-80
    80004e32:	e486                	sd	ra,72(sp)
    80004e34:	e0a2                	sd	s0,64(sp)
    80004e36:	fc26                	sd	s1,56(sp)
    80004e38:	f84a                	sd	s2,48(sp)
    80004e3a:	f44e                	sd	s3,40(sp)
    80004e3c:	f052                	sd	s4,32(sp)
    80004e3e:	ec56                	sd	s5,24(sp)
    80004e40:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80004e42:	04c05263          	blez	a2,80004e86 <consolewrite+0x56>
    80004e46:	8a2a                	mv	s4,a0
    80004e48:	84ae                	mv	s1,a1
    80004e4a:	89b2                	mv	s3,a2
    80004e4c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80004e4e:	5afd                	li	s5,-1
    80004e50:	4685                	li	a3,1
    80004e52:	8626                	mv	a2,s1
    80004e54:	85d2                	mv	a1,s4
    80004e56:	fbf40513          	addi	a0,s0,-65
    80004e5a:	9cbfc0ef          	jal	ra,80001824 <either_copyin>
    80004e5e:	01550a63          	beq	a0,s5,80004e72 <consolewrite+0x42>
      break;
    uartputc(c);
    80004e62:	fbf44503          	lbu	a0,-65(s0)
    80004e66:	7da000ef          	jal	ra,80005640 <uartputc>
  for(i = 0; i < n; i++){
    80004e6a:	2905                	addiw	s2,s2,1
    80004e6c:	0485                	addi	s1,s1,1
    80004e6e:	ff2991e3          	bne	s3,s2,80004e50 <consolewrite+0x20>
  }

  return i;
}
    80004e72:	854a                	mv	a0,s2
    80004e74:	60a6                	ld	ra,72(sp)
    80004e76:	6406                	ld	s0,64(sp)
    80004e78:	74e2                	ld	s1,56(sp)
    80004e7a:	7942                	ld	s2,48(sp)
    80004e7c:	79a2                	ld	s3,40(sp)
    80004e7e:	7a02                	ld	s4,32(sp)
    80004e80:	6ae2                	ld	s5,24(sp)
    80004e82:	6161                	addi	sp,sp,80
    80004e84:	8082                	ret
  for(i = 0; i < n; i++){
    80004e86:	4901                	li	s2,0
    80004e88:	b7ed                	j	80004e72 <consolewrite+0x42>

0000000080004e8a <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80004e8a:	7159                	addi	sp,sp,-112
    80004e8c:	f486                	sd	ra,104(sp)
    80004e8e:	f0a2                	sd	s0,96(sp)
    80004e90:	eca6                	sd	s1,88(sp)
    80004e92:	e8ca                	sd	s2,80(sp)
    80004e94:	e4ce                	sd	s3,72(sp)
    80004e96:	e0d2                	sd	s4,64(sp)
    80004e98:	fc56                	sd	s5,56(sp)
    80004e9a:	f85a                	sd	s6,48(sp)
    80004e9c:	f45e                	sd	s7,40(sp)
    80004e9e:	f062                	sd	s8,32(sp)
    80004ea0:	ec66                	sd	s9,24(sp)
    80004ea2:	e86a                	sd	s10,16(sp)
    80004ea4:	1880                	addi	s0,sp,112
    80004ea6:	8aaa                	mv	s5,a0
    80004ea8:	8a2e                	mv	s4,a1
    80004eaa:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80004eac:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80004eb0:	0001c517          	auipc	a0,0x1c
    80004eb4:	ec050513          	addi	a0,a0,-320 # 80020d70 <cons>
    80004eb8:	113000ef          	jal	ra,800057ca <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80004ebc:	0001c497          	auipc	s1,0x1c
    80004ec0:	eb448493          	addi	s1,s1,-332 # 80020d70 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80004ec4:	0001c917          	auipc	s2,0x1c
    80004ec8:	f4490913          	addi	s2,s2,-188 # 80020e08 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    80004ecc:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80004ece:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80004ed0:	4ca9                	li	s9,10
  while(n > 0){
    80004ed2:	07305363          	blez	s3,80004f38 <consoleread+0xae>
    while(cons.r == cons.w){
    80004ed6:	0984a783          	lw	a5,152(s1)
    80004eda:	09c4a703          	lw	a4,156(s1)
    80004ede:	02f71163          	bne	a4,a5,80004f00 <consoleread+0x76>
      if(killed(myproc())){
    80004ee2:	f3ffb0ef          	jal	ra,80000e20 <myproc>
    80004ee6:	fd0fc0ef          	jal	ra,800016b6 <killed>
    80004eea:	e125                	bnez	a0,80004f4a <consoleread+0xc0>
      sleep(&cons.r, &cons.lock);
    80004eec:	85a6                	mv	a1,s1
    80004eee:	854a                	mv	a0,s2
    80004ef0:	d8efc0ef          	jal	ra,8000147e <sleep>
    while(cons.r == cons.w){
    80004ef4:	0984a783          	lw	a5,152(s1)
    80004ef8:	09c4a703          	lw	a4,156(s1)
    80004efc:	fef703e3          	beq	a4,a5,80004ee2 <consoleread+0x58>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80004f00:	0017871b          	addiw	a4,a5,1
    80004f04:	08e4ac23          	sw	a4,152(s1)
    80004f08:	07f7f713          	andi	a4,a5,127
    80004f0c:	9726                	add	a4,a4,s1
    80004f0e:	01874703          	lbu	a4,24(a4)
    80004f12:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80004f16:	057d0f63          	beq	s10,s7,80004f74 <consoleread+0xea>
    cbuf = c;
    80004f1a:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80004f1e:	4685                	li	a3,1
    80004f20:	f9f40613          	addi	a2,s0,-97
    80004f24:	85d2                	mv	a1,s4
    80004f26:	8556                	mv	a0,s5
    80004f28:	8b3fc0ef          	jal	ra,800017da <either_copyout>
    80004f2c:	01850663          	beq	a0,s8,80004f38 <consoleread+0xae>
    dst++;
    80004f30:	0a05                	addi	s4,s4,1
    --n;
    80004f32:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80004f34:	f99d1fe3          	bne	s10,s9,80004ed2 <consoleread+0x48>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80004f38:	0001c517          	auipc	a0,0x1c
    80004f3c:	e3850513          	addi	a0,a0,-456 # 80020d70 <cons>
    80004f40:	123000ef          	jal	ra,80005862 <release>

  return target - n;
    80004f44:	413b053b          	subw	a0,s6,s3
    80004f48:	a801                	j	80004f58 <consoleread+0xce>
        release(&cons.lock);
    80004f4a:	0001c517          	auipc	a0,0x1c
    80004f4e:	e2650513          	addi	a0,a0,-474 # 80020d70 <cons>
    80004f52:	111000ef          	jal	ra,80005862 <release>
        return -1;
    80004f56:	557d                	li	a0,-1
}
    80004f58:	70a6                	ld	ra,104(sp)
    80004f5a:	7406                	ld	s0,96(sp)
    80004f5c:	64e6                	ld	s1,88(sp)
    80004f5e:	6946                	ld	s2,80(sp)
    80004f60:	69a6                	ld	s3,72(sp)
    80004f62:	6a06                	ld	s4,64(sp)
    80004f64:	7ae2                	ld	s5,56(sp)
    80004f66:	7b42                	ld	s6,48(sp)
    80004f68:	7ba2                	ld	s7,40(sp)
    80004f6a:	7c02                	ld	s8,32(sp)
    80004f6c:	6ce2                	ld	s9,24(sp)
    80004f6e:	6d42                	ld	s10,16(sp)
    80004f70:	6165                	addi	sp,sp,112
    80004f72:	8082                	ret
      if(n < target){
    80004f74:	0009871b          	sext.w	a4,s3
    80004f78:	fd6770e3          	bgeu	a4,s6,80004f38 <consoleread+0xae>
        cons.r--;
    80004f7c:	0001c717          	auipc	a4,0x1c
    80004f80:	e8f72623          	sw	a5,-372(a4) # 80020e08 <cons+0x98>
    80004f84:	bf55                	j	80004f38 <consoleread+0xae>

0000000080004f86 <consputc>:
{
    80004f86:	1141                	addi	sp,sp,-16
    80004f88:	e406                	sd	ra,8(sp)
    80004f8a:	e022                	sd	s0,0(sp)
    80004f8c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80004f8e:	10000793          	li	a5,256
    80004f92:	00f50863          	beq	a0,a5,80004fa2 <consputc+0x1c>
    uartputc_sync(c);
    80004f96:	5d4000ef          	jal	ra,8000556a <uartputc_sync>
}
    80004f9a:	60a2                	ld	ra,8(sp)
    80004f9c:	6402                	ld	s0,0(sp)
    80004f9e:	0141                	addi	sp,sp,16
    80004fa0:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80004fa2:	4521                	li	a0,8
    80004fa4:	5c6000ef          	jal	ra,8000556a <uartputc_sync>
    80004fa8:	02000513          	li	a0,32
    80004fac:	5be000ef          	jal	ra,8000556a <uartputc_sync>
    80004fb0:	4521                	li	a0,8
    80004fb2:	5b8000ef          	jal	ra,8000556a <uartputc_sync>
    80004fb6:	b7d5                	j	80004f9a <consputc+0x14>

0000000080004fb8 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80004fb8:	1101                	addi	sp,sp,-32
    80004fba:	ec06                	sd	ra,24(sp)
    80004fbc:	e822                	sd	s0,16(sp)
    80004fbe:	e426                	sd	s1,8(sp)
    80004fc0:	e04a                	sd	s2,0(sp)
    80004fc2:	1000                	addi	s0,sp,32
    80004fc4:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80004fc6:	0001c517          	auipc	a0,0x1c
    80004fca:	daa50513          	addi	a0,a0,-598 # 80020d70 <cons>
    80004fce:	7fc000ef          	jal	ra,800057ca <acquire>

  switch(c){
    80004fd2:	47d5                	li	a5,21
    80004fd4:	0af48063          	beq	s1,a5,80005074 <consoleintr+0xbc>
    80004fd8:	0297c663          	blt	a5,s1,80005004 <consoleintr+0x4c>
    80004fdc:	47a1                	li	a5,8
    80004fde:	0cf48f63          	beq	s1,a5,800050bc <consoleintr+0x104>
    80004fe2:	47c1                	li	a5,16
    80004fe4:	10f49063          	bne	s1,a5,800050e4 <consoleintr+0x12c>
  case C('P'):  // Print process list.
    procdump();
    80004fe8:	887fc0ef          	jal	ra,8000186e <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80004fec:	0001c517          	auipc	a0,0x1c
    80004ff0:	d8450513          	addi	a0,a0,-636 # 80020d70 <cons>
    80004ff4:	06f000ef          	jal	ra,80005862 <release>
}
    80004ff8:	60e2                	ld	ra,24(sp)
    80004ffa:	6442                	ld	s0,16(sp)
    80004ffc:	64a2                	ld	s1,8(sp)
    80004ffe:	6902                	ld	s2,0(sp)
    80005000:	6105                	addi	sp,sp,32
    80005002:	8082                	ret
  switch(c){
    80005004:	07f00793          	li	a5,127
    80005008:	0af48a63          	beq	s1,a5,800050bc <consoleintr+0x104>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    8000500c:	0001c717          	auipc	a4,0x1c
    80005010:	d6470713          	addi	a4,a4,-668 # 80020d70 <cons>
    80005014:	0a072783          	lw	a5,160(a4)
    80005018:	09872703          	lw	a4,152(a4)
    8000501c:	9f99                	subw	a5,a5,a4
    8000501e:	07f00713          	li	a4,127
    80005022:	fcf765e3          	bltu	a4,a5,80004fec <consoleintr+0x34>
      c = (c == '\r') ? '\n' : c;
    80005026:	47b5                	li	a5,13
    80005028:	0cf48163          	beq	s1,a5,800050ea <consoleintr+0x132>
      consputc(c);
    8000502c:	8526                	mv	a0,s1
    8000502e:	f59ff0ef          	jal	ra,80004f86 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005032:	0001c797          	auipc	a5,0x1c
    80005036:	d3e78793          	addi	a5,a5,-706 # 80020d70 <cons>
    8000503a:	0a07a683          	lw	a3,160(a5)
    8000503e:	0016871b          	addiw	a4,a3,1
    80005042:	0007061b          	sext.w	a2,a4
    80005046:	0ae7a023          	sw	a4,160(a5)
    8000504a:	07f6f693          	andi	a3,a3,127
    8000504e:	97b6                	add	a5,a5,a3
    80005050:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005054:	47a9                	li	a5,10
    80005056:	0af48f63          	beq	s1,a5,80005114 <consoleintr+0x15c>
    8000505a:	4791                	li	a5,4
    8000505c:	0af48c63          	beq	s1,a5,80005114 <consoleintr+0x15c>
    80005060:	0001c797          	auipc	a5,0x1c
    80005064:	da87a783          	lw	a5,-600(a5) # 80020e08 <cons+0x98>
    80005068:	9f1d                	subw	a4,a4,a5
    8000506a:	08000793          	li	a5,128
    8000506e:	f6f71fe3          	bne	a4,a5,80004fec <consoleintr+0x34>
    80005072:	a04d                	j	80005114 <consoleintr+0x15c>
    while(cons.e != cons.w &&
    80005074:	0001c717          	auipc	a4,0x1c
    80005078:	cfc70713          	addi	a4,a4,-772 # 80020d70 <cons>
    8000507c:	0a072783          	lw	a5,160(a4)
    80005080:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005084:	0001c497          	auipc	s1,0x1c
    80005088:	cec48493          	addi	s1,s1,-788 # 80020d70 <cons>
    while(cons.e != cons.w &&
    8000508c:	4929                	li	s2,10
    8000508e:	f4f70fe3          	beq	a4,a5,80004fec <consoleintr+0x34>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005092:	37fd                	addiw	a5,a5,-1
    80005094:	07f7f713          	andi	a4,a5,127
    80005098:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    8000509a:	01874703          	lbu	a4,24(a4)
    8000509e:	f52707e3          	beq	a4,s2,80004fec <consoleintr+0x34>
      cons.e--;
    800050a2:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800050a6:	10000513          	li	a0,256
    800050aa:	eddff0ef          	jal	ra,80004f86 <consputc>
    while(cons.e != cons.w &&
    800050ae:	0a04a783          	lw	a5,160(s1)
    800050b2:	09c4a703          	lw	a4,156(s1)
    800050b6:	fcf71ee3          	bne	a4,a5,80005092 <consoleintr+0xda>
    800050ba:	bf0d                	j	80004fec <consoleintr+0x34>
    if(cons.e != cons.w){
    800050bc:	0001c717          	auipc	a4,0x1c
    800050c0:	cb470713          	addi	a4,a4,-844 # 80020d70 <cons>
    800050c4:	0a072783          	lw	a5,160(a4)
    800050c8:	09c72703          	lw	a4,156(a4)
    800050cc:	f2f700e3          	beq	a4,a5,80004fec <consoleintr+0x34>
      cons.e--;
    800050d0:	37fd                	addiw	a5,a5,-1
    800050d2:	0001c717          	auipc	a4,0x1c
    800050d6:	d2f72f23          	sw	a5,-706(a4) # 80020e10 <cons+0xa0>
      consputc(BACKSPACE);
    800050da:	10000513          	li	a0,256
    800050de:	ea9ff0ef          	jal	ra,80004f86 <consputc>
    800050e2:	b729                	j	80004fec <consoleintr+0x34>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800050e4:	f00484e3          	beqz	s1,80004fec <consoleintr+0x34>
    800050e8:	b715                	j	8000500c <consoleintr+0x54>
      consputc(c);
    800050ea:	4529                	li	a0,10
    800050ec:	e9bff0ef          	jal	ra,80004f86 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800050f0:	0001c797          	auipc	a5,0x1c
    800050f4:	c8078793          	addi	a5,a5,-896 # 80020d70 <cons>
    800050f8:	0a07a703          	lw	a4,160(a5)
    800050fc:	0017069b          	addiw	a3,a4,1
    80005100:	0006861b          	sext.w	a2,a3
    80005104:	0ad7a023          	sw	a3,160(a5)
    80005108:	07f77713          	andi	a4,a4,127
    8000510c:	97ba                	add	a5,a5,a4
    8000510e:	4729                	li	a4,10
    80005110:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005114:	0001c797          	auipc	a5,0x1c
    80005118:	cec7ac23          	sw	a2,-776(a5) # 80020e0c <cons+0x9c>
        wakeup(&cons.r);
    8000511c:	0001c517          	auipc	a0,0x1c
    80005120:	cec50513          	addi	a0,a0,-788 # 80020e08 <cons+0x98>
    80005124:	ba6fc0ef          	jal	ra,800014ca <wakeup>
    80005128:	b5d1                	j	80004fec <consoleintr+0x34>

000000008000512a <consoleinit>:

void
consoleinit(void)
{
    8000512a:	1141                	addi	sp,sp,-16
    8000512c:	e406                	sd	ra,8(sp)
    8000512e:	e022                	sd	s0,0(sp)
    80005130:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005132:	00002597          	auipc	a1,0x2
    80005136:	70e58593          	addi	a1,a1,1806 # 80007840 <syscalls+0x3f8>
    8000513a:	0001c517          	auipc	a0,0x1c
    8000513e:	c3650513          	addi	a0,a0,-970 # 80020d70 <cons>
    80005142:	608000ef          	jal	ra,8000574a <initlock>

  uartinit();
    80005146:	3d8000ef          	jal	ra,8000551e <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000514a:	00013797          	auipc	a5,0x13
    8000514e:	a8e78793          	addi	a5,a5,-1394 # 80017bd8 <devsw>
    80005152:	00000717          	auipc	a4,0x0
    80005156:	d3870713          	addi	a4,a4,-712 # 80004e8a <consoleread>
    8000515a:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000515c:	00000717          	auipc	a4,0x0
    80005160:	cd470713          	addi	a4,a4,-812 # 80004e30 <consolewrite>
    80005164:	ef98                	sd	a4,24(a5)
}
    80005166:	60a2                	ld	ra,8(sp)
    80005168:	6402                	ld	s0,0(sp)
    8000516a:	0141                	addi	sp,sp,16
    8000516c:	8082                	ret

000000008000516e <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    8000516e:	7179                	addi	sp,sp,-48
    80005170:	f406                	sd	ra,40(sp)
    80005172:	f022                	sd	s0,32(sp)
    80005174:	ec26                	sd	s1,24(sp)
    80005176:	e84a                	sd	s2,16(sp)
    80005178:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    8000517a:	c219                	beqz	a2,80005180 <printint+0x12>
    8000517c:	06054f63          	bltz	a0,800051fa <printint+0x8c>
    x = -xx;
  else
    x = xx;
    80005180:	4881                	li	a7,0
    80005182:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005186:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80005188:	00002617          	auipc	a2,0x2
    8000518c:	6e060613          	addi	a2,a2,1760 # 80007868 <digits>
    80005190:	883e                	mv	a6,a5
    80005192:	2785                	addiw	a5,a5,1
    80005194:	02b57733          	remu	a4,a0,a1
    80005198:	9732                	add	a4,a4,a2
    8000519a:	00074703          	lbu	a4,0(a4)
    8000519e:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    800051a2:	872a                	mv	a4,a0
    800051a4:	02b55533          	divu	a0,a0,a1
    800051a8:	0685                	addi	a3,a3,1
    800051aa:	feb773e3          	bgeu	a4,a1,80005190 <printint+0x22>

  if(sign)
    800051ae:	00088b63          	beqz	a7,800051c4 <printint+0x56>
    buf[i++] = '-';
    800051b2:	fe040713          	addi	a4,s0,-32
    800051b6:	97ba                	add	a5,a5,a4
    800051b8:	02d00713          	li	a4,45
    800051bc:	fee78823          	sb	a4,-16(a5)
    800051c0:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    800051c4:	02f05563          	blez	a5,800051ee <printint+0x80>
    800051c8:	fd040713          	addi	a4,s0,-48
    800051cc:	00f704b3          	add	s1,a4,a5
    800051d0:	fff70913          	addi	s2,a4,-1
    800051d4:	993e                	add	s2,s2,a5
    800051d6:	37fd                	addiw	a5,a5,-1
    800051d8:	1782                	slli	a5,a5,0x20
    800051da:	9381                	srli	a5,a5,0x20
    800051dc:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    800051e0:	fff4c503          	lbu	a0,-1(s1)
    800051e4:	da3ff0ef          	jal	ra,80004f86 <consputc>
  while(--i >= 0)
    800051e8:	14fd                	addi	s1,s1,-1
    800051ea:	ff249be3          	bne	s1,s2,800051e0 <printint+0x72>
}
    800051ee:	70a2                	ld	ra,40(sp)
    800051f0:	7402                	ld	s0,32(sp)
    800051f2:	64e2                	ld	s1,24(sp)
    800051f4:	6942                	ld	s2,16(sp)
    800051f6:	6145                	addi	sp,sp,48
    800051f8:	8082                	ret
    x = -xx;
    800051fa:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    800051fe:	4885                	li	a7,1
    x = -xx;
    80005200:	b749                	j	80005182 <printint+0x14>

0000000080005202 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    80005202:	7155                	addi	sp,sp,-208
    80005204:	e506                	sd	ra,136(sp)
    80005206:	e122                	sd	s0,128(sp)
    80005208:	fca6                	sd	s1,120(sp)
    8000520a:	f8ca                	sd	s2,112(sp)
    8000520c:	f4ce                	sd	s3,104(sp)
    8000520e:	f0d2                	sd	s4,96(sp)
    80005210:	ecd6                	sd	s5,88(sp)
    80005212:	e8da                	sd	s6,80(sp)
    80005214:	e4de                	sd	s7,72(sp)
    80005216:	e0e2                	sd	s8,64(sp)
    80005218:	fc66                	sd	s9,56(sp)
    8000521a:	f86a                	sd	s10,48(sp)
    8000521c:	f46e                	sd	s11,40(sp)
    8000521e:	0900                	addi	s0,sp,144
    80005220:	8a2a                	mv	s4,a0
    80005222:	e40c                	sd	a1,8(s0)
    80005224:	e810                	sd	a2,16(s0)
    80005226:	ec14                	sd	a3,24(s0)
    80005228:	f018                	sd	a4,32(s0)
    8000522a:	f41c                	sd	a5,40(s0)
    8000522c:	03043823          	sd	a6,48(s0)
    80005230:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    80005234:	0001c797          	auipc	a5,0x1c
    80005238:	bfc7a783          	lw	a5,-1028(a5) # 80020e30 <pr+0x18>
    8000523c:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    80005240:	eb9d                	bnez	a5,80005276 <printf+0x74>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80005242:	00840793          	addi	a5,s0,8
    80005246:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000524a:	00054503          	lbu	a0,0(a0)
    8000524e:	24050463          	beqz	a0,80005496 <printf+0x294>
    80005252:	4981                	li	s3,0
    if(cx != '%'){
    80005254:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    80005258:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    8000525c:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    80005260:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80005264:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80005268:	07000d93          	li	s11,112
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000526c:	00002b97          	auipc	s7,0x2
    80005270:	5fcb8b93          	addi	s7,s7,1532 # 80007868 <digits>
    80005274:	a081                	j	800052b4 <printf+0xb2>
    acquire(&pr.lock);
    80005276:	0001c517          	auipc	a0,0x1c
    8000527a:	ba250513          	addi	a0,a0,-1118 # 80020e18 <pr>
    8000527e:	54c000ef          	jal	ra,800057ca <acquire>
  va_start(ap, fmt);
    80005282:	00840793          	addi	a5,s0,8
    80005286:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000528a:	000a4503          	lbu	a0,0(s4)
    8000528e:	f171                	bnez	a0,80005252 <printf+0x50>
#endif
  }
  va_end(ap);

  if(locking)
    release(&pr.lock);
    80005290:	0001c517          	auipc	a0,0x1c
    80005294:	b8850513          	addi	a0,a0,-1144 # 80020e18 <pr>
    80005298:	5ca000ef          	jal	ra,80005862 <release>
    8000529c:	aaed                	j	80005496 <printf+0x294>
      consputc(cx);
    8000529e:	ce9ff0ef          	jal	ra,80004f86 <consputc>
      continue;
    800052a2:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800052a4:	0014899b          	addiw	s3,s1,1
    800052a8:	013a07b3          	add	a5,s4,s3
    800052ac:	0007c503          	lbu	a0,0(a5)
    800052b0:	1c050f63          	beqz	a0,8000548e <printf+0x28c>
    if(cx != '%'){
    800052b4:	ff5515e3          	bne	a0,s5,8000529e <printf+0x9c>
    i++;
    800052b8:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    800052bc:	009a07b3          	add	a5,s4,s1
    800052c0:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    800052c4:	1c090563          	beqz	s2,8000548e <printf+0x28c>
    800052c8:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    800052cc:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    800052ce:	c789                	beqz	a5,800052d8 <printf+0xd6>
    800052d0:	009a0733          	add	a4,s4,s1
    800052d4:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    800052d8:	03690463          	beq	s2,s6,80005300 <printf+0xfe>
    } else if(c0 == 'l' && c1 == 'd'){
    800052dc:	03890e63          	beq	s2,s8,80005318 <printf+0x116>
    } else if(c0 == 'u'){
    800052e0:	0b990d63          	beq	s2,s9,8000539a <printf+0x198>
    } else if(c0 == 'x'){
    800052e4:	11a90363          	beq	s2,s10,800053ea <printf+0x1e8>
    } else if(c0 == 'p'){
    800052e8:	13b90b63          	beq	s2,s11,8000541e <printf+0x21c>
    } else if(c0 == 's'){
    800052ec:	07300793          	li	a5,115
    800052f0:	16f90363          	beq	s2,a5,80005456 <printf+0x254>
    } else if(c0 == '%'){
    800052f4:	03591c63          	bne	s2,s5,8000532c <printf+0x12a>
      consputc('%');
    800052f8:	8556                	mv	a0,s5
    800052fa:	c8dff0ef          	jal	ra,80004f86 <consputc>
    800052fe:	b75d                	j	800052a4 <printf+0xa2>
      printint(va_arg(ap, int), 10, 1);
    80005300:	f8843783          	ld	a5,-120(s0)
    80005304:	00878713          	addi	a4,a5,8
    80005308:	f8e43423          	sd	a4,-120(s0)
    8000530c:	4605                	li	a2,1
    8000530e:	45a9                	li	a1,10
    80005310:	4388                	lw	a0,0(a5)
    80005312:	e5dff0ef          	jal	ra,8000516e <printint>
    80005316:	b779                	j	800052a4 <printf+0xa2>
    } else if(c0 == 'l' && c1 == 'd'){
    80005318:	03678163          	beq	a5,s6,8000533a <printf+0x138>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000531c:	03878d63          	beq	a5,s8,80005356 <printf+0x154>
    } else if(c0 == 'l' && c1 == 'u'){
    80005320:	09978963          	beq	a5,s9,800053b2 <printf+0x1b0>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80005324:	03878b63          	beq	a5,s8,8000535a <printf+0x158>
    } else if(c0 == 'l' && c1 == 'x'){
    80005328:	0da78d63          	beq	a5,s10,80005402 <printf+0x200>
      consputc('%');
    8000532c:	8556                	mv	a0,s5
    8000532e:	c59ff0ef          	jal	ra,80004f86 <consputc>
      consputc(c0);
    80005332:	854a                	mv	a0,s2
    80005334:	c53ff0ef          	jal	ra,80004f86 <consputc>
    80005338:	b7b5                	j	800052a4 <printf+0xa2>
      printint(va_arg(ap, uint64), 10, 1);
    8000533a:	f8843783          	ld	a5,-120(s0)
    8000533e:	00878713          	addi	a4,a5,8
    80005342:	f8e43423          	sd	a4,-120(s0)
    80005346:	4605                	li	a2,1
    80005348:	45a9                	li	a1,10
    8000534a:	6388                	ld	a0,0(a5)
    8000534c:	e23ff0ef          	jal	ra,8000516e <printint>
      i += 1;
    80005350:	0029849b          	addiw	s1,s3,2
    80005354:	bf81                	j	800052a4 <printf+0xa2>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80005356:	03668463          	beq	a3,s6,8000537e <printf+0x17c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    8000535a:	07968a63          	beq	a3,s9,800053ce <printf+0x1cc>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    8000535e:	fda697e3          	bne	a3,s10,8000532c <printf+0x12a>
      printint(va_arg(ap, uint64), 16, 0);
    80005362:	f8843783          	ld	a5,-120(s0)
    80005366:	00878713          	addi	a4,a5,8
    8000536a:	f8e43423          	sd	a4,-120(s0)
    8000536e:	4601                	li	a2,0
    80005370:	45c1                	li	a1,16
    80005372:	6388                	ld	a0,0(a5)
    80005374:	dfbff0ef          	jal	ra,8000516e <printint>
      i += 2;
    80005378:	0039849b          	addiw	s1,s3,3
    8000537c:	b725                	j	800052a4 <printf+0xa2>
      printint(va_arg(ap, uint64), 10, 1);
    8000537e:	f8843783          	ld	a5,-120(s0)
    80005382:	00878713          	addi	a4,a5,8
    80005386:	f8e43423          	sd	a4,-120(s0)
    8000538a:	4605                	li	a2,1
    8000538c:	45a9                	li	a1,10
    8000538e:	6388                	ld	a0,0(a5)
    80005390:	ddfff0ef          	jal	ra,8000516e <printint>
      i += 2;
    80005394:	0039849b          	addiw	s1,s3,3
    80005398:	b731                	j	800052a4 <printf+0xa2>
      printint(va_arg(ap, int), 10, 0);
    8000539a:	f8843783          	ld	a5,-120(s0)
    8000539e:	00878713          	addi	a4,a5,8
    800053a2:	f8e43423          	sd	a4,-120(s0)
    800053a6:	4601                	li	a2,0
    800053a8:	45a9                	li	a1,10
    800053aa:	4388                	lw	a0,0(a5)
    800053ac:	dc3ff0ef          	jal	ra,8000516e <printint>
    800053b0:	bdd5                	j	800052a4 <printf+0xa2>
      printint(va_arg(ap, uint64), 10, 0);
    800053b2:	f8843783          	ld	a5,-120(s0)
    800053b6:	00878713          	addi	a4,a5,8
    800053ba:	f8e43423          	sd	a4,-120(s0)
    800053be:	4601                	li	a2,0
    800053c0:	45a9                	li	a1,10
    800053c2:	6388                	ld	a0,0(a5)
    800053c4:	dabff0ef          	jal	ra,8000516e <printint>
      i += 1;
    800053c8:	0029849b          	addiw	s1,s3,2
    800053cc:	bde1                	j	800052a4 <printf+0xa2>
      printint(va_arg(ap, uint64), 10, 0);
    800053ce:	f8843783          	ld	a5,-120(s0)
    800053d2:	00878713          	addi	a4,a5,8
    800053d6:	f8e43423          	sd	a4,-120(s0)
    800053da:	4601                	li	a2,0
    800053dc:	45a9                	li	a1,10
    800053de:	6388                	ld	a0,0(a5)
    800053e0:	d8fff0ef          	jal	ra,8000516e <printint>
      i += 2;
    800053e4:	0039849b          	addiw	s1,s3,3
    800053e8:	bd75                	j	800052a4 <printf+0xa2>
      printint(va_arg(ap, int), 16, 0);
    800053ea:	f8843783          	ld	a5,-120(s0)
    800053ee:	00878713          	addi	a4,a5,8
    800053f2:	f8e43423          	sd	a4,-120(s0)
    800053f6:	4601                	li	a2,0
    800053f8:	45c1                	li	a1,16
    800053fa:	4388                	lw	a0,0(a5)
    800053fc:	d73ff0ef          	jal	ra,8000516e <printint>
    80005400:	b555                	j	800052a4 <printf+0xa2>
      printint(va_arg(ap, uint64), 16, 0);
    80005402:	f8843783          	ld	a5,-120(s0)
    80005406:	00878713          	addi	a4,a5,8
    8000540a:	f8e43423          	sd	a4,-120(s0)
    8000540e:	4601                	li	a2,0
    80005410:	45c1                	li	a1,16
    80005412:	6388                	ld	a0,0(a5)
    80005414:	d5bff0ef          	jal	ra,8000516e <printint>
      i += 1;
    80005418:	0029849b          	addiw	s1,s3,2
    8000541c:	b561                	j	800052a4 <printf+0xa2>
      printptr(va_arg(ap, uint64));
    8000541e:	f8843783          	ld	a5,-120(s0)
    80005422:	00878713          	addi	a4,a5,8
    80005426:	f8e43423          	sd	a4,-120(s0)
    8000542a:	0007b983          	ld	s3,0(a5)
  consputc('0');
    8000542e:	03000513          	li	a0,48
    80005432:	b55ff0ef          	jal	ra,80004f86 <consputc>
  consputc('x');
    80005436:	856a                	mv	a0,s10
    80005438:	b4fff0ef          	jal	ra,80004f86 <consputc>
    8000543c:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000543e:	03c9d793          	srli	a5,s3,0x3c
    80005442:	97de                	add	a5,a5,s7
    80005444:	0007c503          	lbu	a0,0(a5)
    80005448:	b3fff0ef          	jal	ra,80004f86 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000544c:	0992                	slli	s3,s3,0x4
    8000544e:	397d                	addiw	s2,s2,-1
    80005450:	fe0917e3          	bnez	s2,8000543e <printf+0x23c>
    80005454:	bd81                	j	800052a4 <printf+0xa2>
      if((s = va_arg(ap, char*)) == 0)
    80005456:	f8843783          	ld	a5,-120(s0)
    8000545a:	00878713          	addi	a4,a5,8
    8000545e:	f8e43423          	sd	a4,-120(s0)
    80005462:	0007b903          	ld	s2,0(a5)
    80005466:	00090d63          	beqz	s2,80005480 <printf+0x27e>
      for(; *s; s++)
    8000546a:	00094503          	lbu	a0,0(s2)
    8000546e:	e2050be3          	beqz	a0,800052a4 <printf+0xa2>
        consputc(*s);
    80005472:	b15ff0ef          	jal	ra,80004f86 <consputc>
      for(; *s; s++)
    80005476:	0905                	addi	s2,s2,1
    80005478:	00094503          	lbu	a0,0(s2)
    8000547c:	f97d                	bnez	a0,80005472 <printf+0x270>
    8000547e:	b51d                	j	800052a4 <printf+0xa2>
        s = "(null)";
    80005480:	00002917          	auipc	s2,0x2
    80005484:	3c890913          	addi	s2,s2,968 # 80007848 <syscalls+0x400>
      for(; *s; s++)
    80005488:	02800513          	li	a0,40
    8000548c:	b7dd                	j	80005472 <printf+0x270>
  if(locking)
    8000548e:	f7843783          	ld	a5,-136(s0)
    80005492:	de079fe3          	bnez	a5,80005290 <printf+0x8e>

  return 0;
}
    80005496:	4501                	li	a0,0
    80005498:	60aa                	ld	ra,136(sp)
    8000549a:	640a                	ld	s0,128(sp)
    8000549c:	74e6                	ld	s1,120(sp)
    8000549e:	7946                	ld	s2,112(sp)
    800054a0:	79a6                	ld	s3,104(sp)
    800054a2:	7a06                	ld	s4,96(sp)
    800054a4:	6ae6                	ld	s5,88(sp)
    800054a6:	6b46                	ld	s6,80(sp)
    800054a8:	6ba6                	ld	s7,72(sp)
    800054aa:	6c06                	ld	s8,64(sp)
    800054ac:	7ce2                	ld	s9,56(sp)
    800054ae:	7d42                	ld	s10,48(sp)
    800054b0:	7da2                	ld	s11,40(sp)
    800054b2:	6169                	addi	sp,sp,208
    800054b4:	8082                	ret

00000000800054b6 <panic>:

void
panic(char *s)
{
    800054b6:	1101                	addi	sp,sp,-32
    800054b8:	ec06                	sd	ra,24(sp)
    800054ba:	e822                	sd	s0,16(sp)
    800054bc:	e426                	sd	s1,8(sp)
    800054be:	1000                	addi	s0,sp,32
    800054c0:	84aa                	mv	s1,a0
  pr.locking = 0;
    800054c2:	0001c797          	auipc	a5,0x1c
    800054c6:	9607a723          	sw	zero,-1682(a5) # 80020e30 <pr+0x18>
  printf("panic: ");
    800054ca:	00002517          	auipc	a0,0x2
    800054ce:	38650513          	addi	a0,a0,902 # 80007850 <syscalls+0x408>
    800054d2:	d31ff0ef          	jal	ra,80005202 <printf>
  printf("%s\n", s);
    800054d6:	85a6                	mv	a1,s1
    800054d8:	00002517          	auipc	a0,0x2
    800054dc:	38050513          	addi	a0,a0,896 # 80007858 <syscalls+0x410>
    800054e0:	d23ff0ef          	jal	ra,80005202 <printf>
  panicked = 1; // freeze uart output from other CPUs
    800054e4:	4785                	li	a5,1
    800054e6:	00002717          	auipc	a4,0x2
    800054ea:	44f72323          	sw	a5,1094(a4) # 8000792c <panicked>
  for(;;)
    800054ee:	a001                	j	800054ee <panic+0x38>

00000000800054f0 <printfinit>:
    ;
}

void
printfinit(void)
{
    800054f0:	1101                	addi	sp,sp,-32
    800054f2:	ec06                	sd	ra,24(sp)
    800054f4:	e822                	sd	s0,16(sp)
    800054f6:	e426                	sd	s1,8(sp)
    800054f8:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800054fa:	0001c497          	auipc	s1,0x1c
    800054fe:	91e48493          	addi	s1,s1,-1762 # 80020e18 <pr>
    80005502:	00002597          	auipc	a1,0x2
    80005506:	35e58593          	addi	a1,a1,862 # 80007860 <syscalls+0x418>
    8000550a:	8526                	mv	a0,s1
    8000550c:	23e000ef          	jal	ra,8000574a <initlock>
  pr.locking = 1;
    80005510:	4785                	li	a5,1
    80005512:	cc9c                	sw	a5,24(s1)
}
    80005514:	60e2                	ld	ra,24(sp)
    80005516:	6442                	ld	s0,16(sp)
    80005518:	64a2                	ld	s1,8(sp)
    8000551a:	6105                	addi	sp,sp,32
    8000551c:	8082                	ret

000000008000551e <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000551e:	1141                	addi	sp,sp,-16
    80005520:	e406                	sd	ra,8(sp)
    80005522:	e022                	sd	s0,0(sp)
    80005524:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005526:	100007b7          	lui	a5,0x10000
    8000552a:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000552e:	f8000713          	li	a4,-128
    80005532:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005536:	470d                	li	a4,3
    80005538:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000553c:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005540:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005544:	469d                	li	a3,7
    80005546:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000554a:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000554e:	00002597          	auipc	a1,0x2
    80005552:	33258593          	addi	a1,a1,818 # 80007880 <digits+0x18>
    80005556:	0001c517          	auipc	a0,0x1c
    8000555a:	8e250513          	addi	a0,a0,-1822 # 80020e38 <uart_tx_lock>
    8000555e:	1ec000ef          	jal	ra,8000574a <initlock>
}
    80005562:	60a2                	ld	ra,8(sp)
    80005564:	6402                	ld	s0,0(sp)
    80005566:	0141                	addi	sp,sp,16
    80005568:	8082                	ret

000000008000556a <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000556a:	1101                	addi	sp,sp,-32
    8000556c:	ec06                	sd	ra,24(sp)
    8000556e:	e822                	sd	s0,16(sp)
    80005570:	e426                	sd	s1,8(sp)
    80005572:	1000                	addi	s0,sp,32
    80005574:	84aa                	mv	s1,a0
  push_off();
    80005576:	214000ef          	jal	ra,8000578a <push_off>

  if(panicked){
    8000557a:	00002797          	auipc	a5,0x2
    8000557e:	3b27a783          	lw	a5,946(a5) # 8000792c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005582:	10000737          	lui	a4,0x10000
  if(panicked){
    80005586:	c391                	beqz	a5,8000558a <uartputc_sync+0x20>
    for(;;)
    80005588:	a001                	j	80005588 <uartputc_sync+0x1e>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000558a:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000558e:	0207f793          	andi	a5,a5,32
    80005592:	dfe5                	beqz	a5,8000558a <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    80005594:	0ff4f513          	andi	a0,s1,255
    80005598:	100007b7          	lui	a5,0x10000
    8000559c:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800055a0:	26e000ef          	jal	ra,8000580e <pop_off>
}
    800055a4:	60e2                	ld	ra,24(sp)
    800055a6:	6442                	ld	s0,16(sp)
    800055a8:	64a2                	ld	s1,8(sp)
    800055aa:	6105                	addi	sp,sp,32
    800055ac:	8082                	ret

00000000800055ae <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800055ae:	00002797          	auipc	a5,0x2
    800055b2:	3827b783          	ld	a5,898(a5) # 80007930 <uart_tx_r>
    800055b6:	00002717          	auipc	a4,0x2
    800055ba:	38273703          	ld	a4,898(a4) # 80007938 <uart_tx_w>
    800055be:	06f70c63          	beq	a4,a5,80005636 <uartstart+0x88>
{
    800055c2:	7139                	addi	sp,sp,-64
    800055c4:	fc06                	sd	ra,56(sp)
    800055c6:	f822                	sd	s0,48(sp)
    800055c8:	f426                	sd	s1,40(sp)
    800055ca:	f04a                	sd	s2,32(sp)
    800055cc:	ec4e                	sd	s3,24(sp)
    800055ce:	e852                	sd	s4,16(sp)
    800055d0:	e456                	sd	s5,8(sp)
    800055d2:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800055d4:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800055d8:	0001ca17          	auipc	s4,0x1c
    800055dc:	860a0a13          	addi	s4,s4,-1952 # 80020e38 <uart_tx_lock>
    uart_tx_r += 1;
    800055e0:	00002497          	auipc	s1,0x2
    800055e4:	35048493          	addi	s1,s1,848 # 80007930 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    800055e8:	00002997          	auipc	s3,0x2
    800055ec:	35098993          	addi	s3,s3,848 # 80007938 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800055f0:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    800055f4:	02077713          	andi	a4,a4,32
    800055f8:	c715                	beqz	a4,80005624 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800055fa:	01f7f713          	andi	a4,a5,31
    800055fe:	9752                	add	a4,a4,s4
    80005600:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80005604:	0785                	addi	a5,a5,1
    80005606:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005608:	8526                	mv	a0,s1
    8000560a:	ec1fb0ef          	jal	ra,800014ca <wakeup>
    
    WriteReg(THR, c);
    8000560e:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80005612:	609c                	ld	a5,0(s1)
    80005614:	0009b703          	ld	a4,0(s3)
    80005618:	fcf71ce3          	bne	a4,a5,800055f0 <uartstart+0x42>
      ReadReg(ISR);
    8000561c:	100007b7          	lui	a5,0x10000
    80005620:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
  }
}
    80005624:	70e2                	ld	ra,56(sp)
    80005626:	7442                	ld	s0,48(sp)
    80005628:	74a2                	ld	s1,40(sp)
    8000562a:	7902                	ld	s2,32(sp)
    8000562c:	69e2                	ld	s3,24(sp)
    8000562e:	6a42                	ld	s4,16(sp)
    80005630:	6aa2                	ld	s5,8(sp)
    80005632:	6121                	addi	sp,sp,64
    80005634:	8082                	ret
      ReadReg(ISR);
    80005636:	100007b7          	lui	a5,0x10000
    8000563a:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
      return;
    8000563e:	8082                	ret

0000000080005640 <uartputc>:
{
    80005640:	7179                	addi	sp,sp,-48
    80005642:	f406                	sd	ra,40(sp)
    80005644:	f022                	sd	s0,32(sp)
    80005646:	ec26                	sd	s1,24(sp)
    80005648:	e84a                	sd	s2,16(sp)
    8000564a:	e44e                	sd	s3,8(sp)
    8000564c:	e052                	sd	s4,0(sp)
    8000564e:	1800                	addi	s0,sp,48
    80005650:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80005652:	0001b517          	auipc	a0,0x1b
    80005656:	7e650513          	addi	a0,a0,2022 # 80020e38 <uart_tx_lock>
    8000565a:	170000ef          	jal	ra,800057ca <acquire>
  if(panicked){
    8000565e:	00002797          	auipc	a5,0x2
    80005662:	2ce7a783          	lw	a5,718(a5) # 8000792c <panicked>
    80005666:	efbd                	bnez	a5,800056e4 <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005668:	00002717          	auipc	a4,0x2
    8000566c:	2d073703          	ld	a4,720(a4) # 80007938 <uart_tx_w>
    80005670:	00002797          	auipc	a5,0x2
    80005674:	2c07b783          	ld	a5,704(a5) # 80007930 <uart_tx_r>
    80005678:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000567c:	0001b997          	auipc	s3,0x1b
    80005680:	7bc98993          	addi	s3,s3,1980 # 80020e38 <uart_tx_lock>
    80005684:	00002497          	auipc	s1,0x2
    80005688:	2ac48493          	addi	s1,s1,684 # 80007930 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000568c:	00002917          	auipc	s2,0x2
    80005690:	2ac90913          	addi	s2,s2,684 # 80007938 <uart_tx_w>
    80005694:	00e79d63          	bne	a5,a4,800056ae <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    80005698:	85ce                	mv	a1,s3
    8000569a:	8526                	mv	a0,s1
    8000569c:	de3fb0ef          	jal	ra,8000147e <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800056a0:	00093703          	ld	a4,0(s2)
    800056a4:	609c                	ld	a5,0(s1)
    800056a6:	02078793          	addi	a5,a5,32
    800056aa:	fee787e3          	beq	a5,a4,80005698 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800056ae:	0001b497          	auipc	s1,0x1b
    800056b2:	78a48493          	addi	s1,s1,1930 # 80020e38 <uart_tx_lock>
    800056b6:	01f77793          	andi	a5,a4,31
    800056ba:	97a6                	add	a5,a5,s1
    800056bc:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800056c0:	0705                	addi	a4,a4,1
    800056c2:	00002797          	auipc	a5,0x2
    800056c6:	26e7bb23          	sd	a4,630(a5) # 80007938 <uart_tx_w>
  uartstart();
    800056ca:	ee5ff0ef          	jal	ra,800055ae <uartstart>
  release(&uart_tx_lock);
    800056ce:	8526                	mv	a0,s1
    800056d0:	192000ef          	jal	ra,80005862 <release>
}
    800056d4:	70a2                	ld	ra,40(sp)
    800056d6:	7402                	ld	s0,32(sp)
    800056d8:	64e2                	ld	s1,24(sp)
    800056da:	6942                	ld	s2,16(sp)
    800056dc:	69a2                	ld	s3,8(sp)
    800056de:	6a02                	ld	s4,0(sp)
    800056e0:	6145                	addi	sp,sp,48
    800056e2:	8082                	ret
    for(;;)
    800056e4:	a001                	j	800056e4 <uartputc+0xa4>

00000000800056e6 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800056e6:	1141                	addi	sp,sp,-16
    800056e8:	e422                	sd	s0,8(sp)
    800056ea:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800056ec:	100007b7          	lui	a5,0x10000
    800056f0:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800056f4:	8b85                	andi	a5,a5,1
    800056f6:	cb91                	beqz	a5,8000570a <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800056f8:	100007b7          	lui	a5,0x10000
    800056fc:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80005700:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80005704:	6422                	ld	s0,8(sp)
    80005706:	0141                	addi	sp,sp,16
    80005708:	8082                	ret
    return -1;
    8000570a:	557d                	li	a0,-1
    8000570c:	bfe5                	j	80005704 <uartgetc+0x1e>

000000008000570e <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    8000570e:	1101                	addi	sp,sp,-32
    80005710:	ec06                	sd	ra,24(sp)
    80005712:	e822                	sd	s0,16(sp)
    80005714:	e426                	sd	s1,8(sp)
    80005716:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80005718:	54fd                	li	s1,-1
    8000571a:	a019                	j	80005720 <uartintr+0x12>
      break;
    consoleintr(c);
    8000571c:	89dff0ef          	jal	ra,80004fb8 <consoleintr>
    int c = uartgetc();
    80005720:	fc7ff0ef          	jal	ra,800056e6 <uartgetc>
    if(c == -1)
    80005724:	fe951ce3          	bne	a0,s1,8000571c <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80005728:	0001b497          	auipc	s1,0x1b
    8000572c:	71048493          	addi	s1,s1,1808 # 80020e38 <uart_tx_lock>
    80005730:	8526                	mv	a0,s1
    80005732:	098000ef          	jal	ra,800057ca <acquire>
  uartstart();
    80005736:	e79ff0ef          	jal	ra,800055ae <uartstart>
  release(&uart_tx_lock);
    8000573a:	8526                	mv	a0,s1
    8000573c:	126000ef          	jal	ra,80005862 <release>
}
    80005740:	60e2                	ld	ra,24(sp)
    80005742:	6442                	ld	s0,16(sp)
    80005744:	64a2                	ld	s1,8(sp)
    80005746:	6105                	addi	sp,sp,32
    80005748:	8082                	ret

000000008000574a <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000574a:	1141                	addi	sp,sp,-16
    8000574c:	e422                	sd	s0,8(sp)
    8000574e:	0800                	addi	s0,sp,16
  lk->name = name;
    80005750:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80005752:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80005756:	00053823          	sd	zero,16(a0)
}
    8000575a:	6422                	ld	s0,8(sp)
    8000575c:	0141                	addi	sp,sp,16
    8000575e:	8082                	ret

0000000080005760 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80005760:	411c                	lw	a5,0(a0)
    80005762:	e399                	bnez	a5,80005768 <holding+0x8>
    80005764:	4501                	li	a0,0
  return r;
}
    80005766:	8082                	ret
{
    80005768:	1101                	addi	sp,sp,-32
    8000576a:	ec06                	sd	ra,24(sp)
    8000576c:	e822                	sd	s0,16(sp)
    8000576e:	e426                	sd	s1,8(sp)
    80005770:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80005772:	6904                	ld	s1,16(a0)
    80005774:	e90fb0ef          	jal	ra,80000e04 <mycpu>
    80005778:	40a48533          	sub	a0,s1,a0
    8000577c:	00153513          	seqz	a0,a0
}
    80005780:	60e2                	ld	ra,24(sp)
    80005782:	6442                	ld	s0,16(sp)
    80005784:	64a2                	ld	s1,8(sp)
    80005786:	6105                	addi	sp,sp,32
    80005788:	8082                	ret

000000008000578a <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000578a:	1101                	addi	sp,sp,-32
    8000578c:	ec06                	sd	ra,24(sp)
    8000578e:	e822                	sd	s0,16(sp)
    80005790:	e426                	sd	s1,8(sp)
    80005792:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005794:	100024f3          	csrr	s1,sstatus
    80005798:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000579c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000579e:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800057a2:	e62fb0ef          	jal	ra,80000e04 <mycpu>
    800057a6:	5d3c                	lw	a5,120(a0)
    800057a8:	cb99                	beqz	a5,800057be <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800057aa:	e5afb0ef          	jal	ra,80000e04 <mycpu>
    800057ae:	5d3c                	lw	a5,120(a0)
    800057b0:	2785                	addiw	a5,a5,1
    800057b2:	dd3c                	sw	a5,120(a0)
}
    800057b4:	60e2                	ld	ra,24(sp)
    800057b6:	6442                	ld	s0,16(sp)
    800057b8:	64a2                	ld	s1,8(sp)
    800057ba:	6105                	addi	sp,sp,32
    800057bc:	8082                	ret
    mycpu()->intena = old;
    800057be:	e46fb0ef          	jal	ra,80000e04 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800057c2:	8085                	srli	s1,s1,0x1
    800057c4:	8885                	andi	s1,s1,1
    800057c6:	dd64                	sw	s1,124(a0)
    800057c8:	b7cd                	j	800057aa <push_off+0x20>

00000000800057ca <acquire>:
{
    800057ca:	1101                	addi	sp,sp,-32
    800057cc:	ec06                	sd	ra,24(sp)
    800057ce:	e822                	sd	s0,16(sp)
    800057d0:	e426                	sd	s1,8(sp)
    800057d2:	1000                	addi	s0,sp,32
    800057d4:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800057d6:	fb5ff0ef          	jal	ra,8000578a <push_off>
  if(holding(lk))
    800057da:	8526                	mv	a0,s1
    800057dc:	f85ff0ef          	jal	ra,80005760 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800057e0:	4705                	li	a4,1
  if(holding(lk))
    800057e2:	e105                	bnez	a0,80005802 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800057e4:	87ba                	mv	a5,a4
    800057e6:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800057ea:	2781                	sext.w	a5,a5
    800057ec:	ffe5                	bnez	a5,800057e4 <acquire+0x1a>
  __sync_synchronize();
    800057ee:	0ff0000f          	fence
  lk->cpu = mycpu();
    800057f2:	e12fb0ef          	jal	ra,80000e04 <mycpu>
    800057f6:	e888                	sd	a0,16(s1)
}
    800057f8:	60e2                	ld	ra,24(sp)
    800057fa:	6442                	ld	s0,16(sp)
    800057fc:	64a2                	ld	s1,8(sp)
    800057fe:	6105                	addi	sp,sp,32
    80005800:	8082                	ret
    panic("acquire");
    80005802:	00002517          	auipc	a0,0x2
    80005806:	08650513          	addi	a0,a0,134 # 80007888 <digits+0x20>
    8000580a:	cadff0ef          	jal	ra,800054b6 <panic>

000000008000580e <pop_off>:

void
pop_off(void)
{
    8000580e:	1141                	addi	sp,sp,-16
    80005810:	e406                	sd	ra,8(sp)
    80005812:	e022                	sd	s0,0(sp)
    80005814:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80005816:	deefb0ef          	jal	ra,80000e04 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000581a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000581e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80005820:	e78d                	bnez	a5,8000584a <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80005822:	5d3c                	lw	a5,120(a0)
    80005824:	02f05963          	blez	a5,80005856 <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    80005828:	37fd                	addiw	a5,a5,-1
    8000582a:	0007871b          	sext.w	a4,a5
    8000582e:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80005830:	eb09                	bnez	a4,80005842 <pop_off+0x34>
    80005832:	5d7c                	lw	a5,124(a0)
    80005834:	c799                	beqz	a5,80005842 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005836:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000583a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000583e:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80005842:	60a2                	ld	ra,8(sp)
    80005844:	6402                	ld	s0,0(sp)
    80005846:	0141                	addi	sp,sp,16
    80005848:	8082                	ret
    panic("pop_off - interruptible");
    8000584a:	00002517          	auipc	a0,0x2
    8000584e:	04650513          	addi	a0,a0,70 # 80007890 <digits+0x28>
    80005852:	c65ff0ef          	jal	ra,800054b6 <panic>
    panic("pop_off");
    80005856:	00002517          	auipc	a0,0x2
    8000585a:	05250513          	addi	a0,a0,82 # 800078a8 <digits+0x40>
    8000585e:	c59ff0ef          	jal	ra,800054b6 <panic>

0000000080005862 <release>:
{
    80005862:	1101                	addi	sp,sp,-32
    80005864:	ec06                	sd	ra,24(sp)
    80005866:	e822                	sd	s0,16(sp)
    80005868:	e426                	sd	s1,8(sp)
    8000586a:	1000                	addi	s0,sp,32
    8000586c:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000586e:	ef3ff0ef          	jal	ra,80005760 <holding>
    80005872:	c105                	beqz	a0,80005892 <release+0x30>
  lk->cpu = 0;
    80005874:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80005878:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000587c:	0f50000f          	fence	iorw,ow
    80005880:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80005884:	f8bff0ef          	jal	ra,8000580e <pop_off>
}
    80005888:	60e2                	ld	ra,24(sp)
    8000588a:	6442                	ld	s0,16(sp)
    8000588c:	64a2                	ld	s1,8(sp)
    8000588e:	6105                	addi	sp,sp,32
    80005890:	8082                	ret
    panic("release");
    80005892:	00002517          	auipc	a0,0x2
    80005896:	01e50513          	addi	a0,a0,30 # 800078b0 <digits+0x48>
    8000589a:	c1dff0ef          	jal	ra,800054b6 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	8282                	jr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
