
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00019117          	auipc	sp,0x19
    80000004:	d4010113          	addi	sp,sp,-704 # 80018d40 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	4cb040ef          	jal	ra,80004ce0 <start>

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
    80000034:	e1078793          	addi	a5,a5,-496 # 80020e40 <end>
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
    80000050:	8c490913          	addi	s2,s2,-1852 # 80007910 <kmem>
    80000054:	854a                	mv	a0,s2
    80000056:	694050ef          	jal	ra,800056ea <acquire>
  r->next = kmem.freelist;
    8000005a:	01893783          	ld	a5,24(s2)
    8000005e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000060:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000064:	854a                	mv	a0,s2
    80000066:	71c050ef          	jal	ra,80005782 <release>
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
    8000007e:	358050ef          	jal	ra,800053d6 <panic>

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
    800000dc:	83850513          	addi	a0,a0,-1992 # 80007910 <kmem>
    800000e0:	58a050ef          	jal	ra,8000566a <initlock>
  freerange(end, (void*)PHYSTOP);
    800000e4:	45c5                	li	a1,17
    800000e6:	05ee                	slli	a1,a1,0x1b
    800000e8:	00021517          	auipc	a0,0x21
    800000ec:	d5850513          	addi	a0,a0,-680 # 80020e40 <end>
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
    8000010a:	80a48493          	addi	s1,s1,-2038 # 80007910 <kmem>
    8000010e:	8526                	mv	a0,s1
    80000110:	5da050ef          	jal	ra,800056ea <acquire>
  r = kmem.freelist;
    80000114:	6c84                	ld	s1,24(s1)
  if(r)
    80000116:	c485                	beqz	s1,8000013e <kalloc+0x42>
    kmem.freelist = r->next;
    80000118:	609c                	ld	a5,0(s1)
    8000011a:	00007517          	auipc	a0,0x7
    8000011e:	7f650513          	addi	a0,a0,2038 # 80007910 <kmem>
    80000122:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000124:	65e050ef          	jal	ra,80005782 <release>

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
    8000013e:	00007517          	auipc	a0,0x7
    80000142:	7d250513          	addi	a0,a0,2002 # 80007910 <kmem>
    80000146:	63c050ef          	jal	ra,80005782 <release>
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
    800002f6:	231000ef          	jal	ra,80000d26 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    800002fa:	00007717          	auipc	a4,0x7
    800002fe:	5e670713          	addi	a4,a4,1510 # 800078e0 <started>
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
    8000030e:	219000ef          	jal	ra,80000d26 <cpuid>
    80000312:	85aa                	mv	a1,a0
    80000314:	00007517          	auipc	a0,0x7
    80000318:	d2450513          	addi	a0,a0,-732 # 80007038 <etext+0x38>
    8000031c:	607040ef          	jal	ra,80005122 <printf>
    kvminithart();    // turn on paging
    80000320:	080000ef          	jal	ra,800003a0 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000324:	5ac010ef          	jal	ra,800018d0 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000328:	40c040ef          	jal	ra,80004734 <plicinithart>
  }

  scheduler();        
    8000032c:	6eb000ef          	jal	ra,80001216 <scheduler>
    consoleinit();
    80000330:	51b040ef          	jal	ra,8000504a <consoleinit>
    printfinit();
    80000334:	0dc050ef          	jal	ra,80005410 <printfinit>
    printf("\n");
    80000338:	00007517          	auipc	a0,0x7
    8000033c:	d1050513          	addi	a0,a0,-752 # 80007048 <etext+0x48>
    80000340:	5e3040ef          	jal	ra,80005122 <printf>
    printf("xv6 kernel is booting\n");
    80000344:	00007517          	auipc	a0,0x7
    80000348:	cdc50513          	addi	a0,a0,-804 # 80007020 <etext+0x20>
    8000034c:	5d7040ef          	jal	ra,80005122 <printf>
    printf("\n");
    80000350:	00007517          	auipc	a0,0x7
    80000354:	cf850513          	addi	a0,a0,-776 # 80007048 <etext+0x48>
    80000358:	5cb040ef          	jal	ra,80005122 <printf>
    kinit();         // physical page allocator
    8000035c:	d6dff0ef          	jal	ra,800000c8 <kinit>
    kvminit();       // create kernel page table
    80000360:	2ca000ef          	jal	ra,8000062a <kvminit>
    kvminithart();   // turn on paging
    80000364:	03c000ef          	jal	ra,800003a0 <kvminithart>
    procinit();      // process table
    80000368:	117000ef          	jal	ra,80000c7e <procinit>
    trapinit();      // trap vectors
    8000036c:	540010ef          	jal	ra,800018ac <trapinit>
    trapinithart();  // install kernel trap vector
    80000370:	560010ef          	jal	ra,800018d0 <trapinithart>
    plicinit();      // set up interrupt controller
    80000374:	3aa040ef          	jal	ra,8000471e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000378:	3bc040ef          	jal	ra,80004734 <plicinithart>
    binit();         // buffer cache
    8000037c:	43d010ef          	jal	ra,80001fb8 <binit>
    iinit();         // inode table
    80000380:	21c020ef          	jal	ra,8000259c <iinit>
    fileinit();      // file table
    80000384:	7b7020ef          	jal	ra,8000333a <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000388:	49c040ef          	jal	ra,80004824 <virtio_disk_init>
    userinit();      // first user process
    8000038c:	4b7000ef          	jal	ra,80001042 <userinit>
    __sync_synchronize();
    80000390:	0ff0000f          	fence
    started = 1;
    80000394:	4785                	li	a5,1
    80000396:	00007717          	auipc	a4,0x7
    8000039a:	54f72523          	sw	a5,1354(a4) # 800078e0 <started>
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
    800003ae:	53e7b783          	ld	a5,1342(a5) # 800078e8 <kernel_pagetable>
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
    800003f6:	7e1040ef          	jal	ra,800053d6 <panic>
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
    8000050c:	6cb040ef          	jal	ra,800053d6 <panic>
    panic("mappages: size not aligned");
    80000510:	00007517          	auipc	a0,0x7
    80000514:	b6850513          	addi	a0,a0,-1176 # 80007078 <etext+0x78>
    80000518:	6bf040ef          	jal	ra,800053d6 <panic>
    panic("mappages: size");
    8000051c:	00007517          	auipc	a0,0x7
    80000520:	b7c50513          	addi	a0,a0,-1156 # 80007098 <etext+0x98>
    80000524:	6b3040ef          	jal	ra,800053d6 <panic>
      panic("mappages: remap");
    80000528:	00007517          	auipc	a0,0x7
    8000052c:	b8050513          	addi	a0,a0,-1152 # 800070a8 <etext+0xa8>
    80000530:	6a7040ef          	jal	ra,800053d6 <panic>
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
    80000574:	663040ef          	jal	ra,800053d6 <panic>

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
    80000618:	5dc000ef          	jal	ra,80000bf4 <proc_mapstacks>
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
    8000063a:	2aa7b923          	sd	a0,690(a5) # 800078e8 <kernel_pagetable>
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
    80000694:	543040ef          	jal	ra,800053d6 <panic>
      panic("uvmunmap: walk");
    80000698:	00007517          	auipc	a0,0x7
    8000069c:	a4050513          	addi	a0,a0,-1472 # 800070d8 <etext+0xd8>
    800006a0:	537040ef          	jal	ra,800053d6 <panic>
      panic("uvmunmap: not mapped");
    800006a4:	00007517          	auipc	a0,0x7
    800006a8:	a4450513          	addi	a0,a0,-1468 # 800070e8 <etext+0xe8>
    800006ac:	52b040ef          	jal	ra,800053d6 <panic>
      panic("uvmunmap: not a leaf");
    800006b0:	00007517          	auipc	a0,0x7
    800006b4:	a5050513          	addi	a0,a0,-1456 # 80007100 <etext+0x100>
    800006b8:	51f040ef          	jal	ra,800053d6 <panic>
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
    80000772:	465040ef          	jal	ra,800053d6 <panic>

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
    80000898:	33f040ef          	jal	ra,800053d6 <panic>
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
    8000092a:	2ad040ef          	jal	ra,800053d6 <panic>
      panic("uvmcopy: page not present");
    8000092e:	00007517          	auipc	a0,0x7
    80000932:	83a50513          	addi	a0,a0,-1990 # 80007168 <etext+0x168>
    80000936:	2a1040ef          	jal	ra,800053d6 <panic>
      continue;
    if((pte = walk(old, i, 0)) == 0)
      panic("uvmcopy: pte should exist");
    8000093a:	00007517          	auipc	a0,0x7
    8000093e:	80e50513          	addi	a0,a0,-2034 # 80007148 <etext+0x148>
    80000942:	295040ef          	jal	ra,800053d6 <panic>
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
    80000a02:	1d5040ef          	jal	ra,800053d6 <panic>

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

0000000080000bf4 <proc_mapstacks>:
  // Allocate a page for each process's kernel stack.
  // Map it high in memory, followed by an invalid
  // guard page.
  void
  proc_mapstacks(pagetable_t kpgtbl)
  {
    80000bf4:	7139                	addi	sp,sp,-64
    80000bf6:	fc06                	sd	ra,56(sp)
    80000bf8:	f822                	sd	s0,48(sp)
    80000bfa:	f426                	sd	s1,40(sp)
    80000bfc:	f04a                	sd	s2,32(sp)
    80000bfe:	ec4e                	sd	s3,24(sp)
    80000c00:	e852                	sd	s4,16(sp)
    80000c02:	e456                	sd	s5,8(sp)
    80000c04:	e05a                	sd	s6,0(sp)
    80000c06:	0080                	addi	s0,sp,64
    80000c08:	89aa                	mv	s3,a0
    struct proc *p;
    
    for(p = proc; p < &proc[NPROC]; p++) {
    80000c0a:	00007497          	auipc	s1,0x7
    80000c0e:	15648493          	addi	s1,s1,342 # 80007d60 <proc>
      char *pa = kalloc();
      if(pa == 0)
        panic("kalloc");
      uint64 va = KSTACK((int) (p - proc));
    80000c12:	8b26                	mv	s6,s1
    80000c14:	00006a97          	auipc	s5,0x6
    80000c18:	3eca8a93          	addi	s5,s5,1004 # 80007000 <etext>
    80000c1c:	04000937          	lui	s2,0x4000
    80000c20:	197d                	addi	s2,s2,-1
    80000c22:	0932                	slli	s2,s2,0xc
    for(p = proc; p < &proc[NPROC]; p++) {
    80000c24:	0000da17          	auipc	s4,0xd
    80000c28:	d3ca0a13          	addi	s4,s4,-708 # 8000d960 <tickslock>
      char *pa = kalloc();
    80000c2c:	cd0ff0ef          	jal	ra,800000fc <kalloc>
    80000c30:	862a                	mv	a2,a0
      if(pa == 0)
    80000c32:	c121                	beqz	a0,80000c72 <proc_mapstacks+0x7e>
      uint64 va = KSTACK((int) (p - proc));
    80000c34:	416485b3          	sub	a1,s1,s6
    80000c38:	8591                	srai	a1,a1,0x4
    80000c3a:	000ab783          	ld	a5,0(s5)
    80000c3e:	02f585b3          	mul	a1,a1,a5
    80000c42:	2585                	addiw	a1,a1,1
    80000c44:	00d5959b          	slliw	a1,a1,0xd
      kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000c48:	4719                	li	a4,6
    80000c4a:	6685                	lui	a3,0x1
    80000c4c:	40b905b3          	sub	a1,s2,a1
    80000c50:	854e                	mv	a0,s3
    80000c52:	8ffff0ef          	jal	ra,80000550 <kvmmap>
    for(p = proc; p < &proc[NPROC]; p++) {
    80000c56:	17048493          	addi	s1,s1,368
    80000c5a:	fd4499e3          	bne	s1,s4,80000c2c <proc_mapstacks+0x38>
    }
  }
    80000c5e:	70e2                	ld	ra,56(sp)
    80000c60:	7442                	ld	s0,48(sp)
    80000c62:	74a2                	ld	s1,40(sp)
    80000c64:	7902                	ld	s2,32(sp)
    80000c66:	69e2                	ld	s3,24(sp)
    80000c68:	6a42                	ld	s4,16(sp)
    80000c6a:	6aa2                	ld	s5,8(sp)
    80000c6c:	6b02                	ld	s6,0(sp)
    80000c6e:	6121                	addi	sp,sp,64
    80000c70:	8082                	ret
        panic("kalloc");
    80000c72:	00006517          	auipc	a0,0x6
    80000c76:	52650513          	addi	a0,a0,1318 # 80007198 <etext+0x198>
    80000c7a:	75c040ef          	jal	ra,800053d6 <panic>

0000000080000c7e <procinit>:

  // initialize the proc table.
  void
  procinit(void)
  {
    80000c7e:	7139                	addi	sp,sp,-64
    80000c80:	fc06                	sd	ra,56(sp)
    80000c82:	f822                	sd	s0,48(sp)
    80000c84:	f426                	sd	s1,40(sp)
    80000c86:	f04a                	sd	s2,32(sp)
    80000c88:	ec4e                	sd	s3,24(sp)
    80000c8a:	e852                	sd	s4,16(sp)
    80000c8c:	e456                	sd	s5,8(sp)
    80000c8e:	e05a                	sd	s6,0(sp)
    80000c90:	0080                	addi	s0,sp,64
    struct proc *p;
    
    initlock(&pid_lock, "nextpid");
    80000c92:	00006597          	auipc	a1,0x6
    80000c96:	50e58593          	addi	a1,a1,1294 # 800071a0 <etext+0x1a0>
    80000c9a:	00007517          	auipc	a0,0x7
    80000c9e:	c9650513          	addi	a0,a0,-874 # 80007930 <pid_lock>
    80000ca2:	1c9040ef          	jal	ra,8000566a <initlock>
    initlock(&wait_lock, "wait_lock");
    80000ca6:	00006597          	auipc	a1,0x6
    80000caa:	50258593          	addi	a1,a1,1282 # 800071a8 <etext+0x1a8>
    80000cae:	00007517          	auipc	a0,0x7
    80000cb2:	c9a50513          	addi	a0,a0,-870 # 80007948 <wait_lock>
    80000cb6:	1b5040ef          	jal	ra,8000566a <initlock>
    for(p = proc; p < &proc[NPROC]; p++) {
    80000cba:	00007497          	auipc	s1,0x7
    80000cbe:	0a648493          	addi	s1,s1,166 # 80007d60 <proc>
        initlock(&p->lock, "proc");
    80000cc2:	00006b17          	auipc	s6,0x6
    80000cc6:	4f6b0b13          	addi	s6,s6,1270 # 800071b8 <etext+0x1b8>
        p->state = UNUSED;
        p->kstack = KSTACK((int) (p - proc));
    80000cca:	8aa6                	mv	s5,s1
    80000ccc:	00006a17          	auipc	s4,0x6
    80000cd0:	334a0a13          	addi	s4,s4,820 # 80007000 <etext>
    80000cd4:	04000937          	lui	s2,0x4000
    80000cd8:	197d                	addi	s2,s2,-1
    80000cda:	0932                	slli	s2,s2,0xc
    for(p = proc; p < &proc[NPROC]; p++) {
    80000cdc:	0000d997          	auipc	s3,0xd
    80000ce0:	c8498993          	addi	s3,s3,-892 # 8000d960 <tickslock>
        initlock(&p->lock, "proc");
    80000ce4:	85da                	mv	a1,s6
    80000ce6:	8526                	mv	a0,s1
    80000ce8:	183040ef          	jal	ra,8000566a <initlock>
        p->state = UNUSED;
    80000cec:	0004ac23          	sw	zero,24(s1)
        p->kstack = KSTACK((int) (p - proc));
    80000cf0:	415487b3          	sub	a5,s1,s5
    80000cf4:	8791                	srai	a5,a5,0x4
    80000cf6:	000a3703          	ld	a4,0(s4)
    80000cfa:	02e787b3          	mul	a5,a5,a4
    80000cfe:	2785                	addiw	a5,a5,1
    80000d00:	00d7979b          	slliw	a5,a5,0xd
    80000d04:	40f907b3          	sub	a5,s2,a5
    80000d08:	e0fc                	sd	a5,192(s1)
    for(p = proc; p < &proc[NPROC]; p++) {
    80000d0a:	17048493          	addi	s1,s1,368
    80000d0e:	fd349be3          	bne	s1,s3,80000ce4 <procinit+0x66>
    }
  }
    80000d12:	70e2                	ld	ra,56(sp)
    80000d14:	7442                	ld	s0,48(sp)
    80000d16:	74a2                	ld	s1,40(sp)
    80000d18:	7902                	ld	s2,32(sp)
    80000d1a:	69e2                	ld	s3,24(sp)
    80000d1c:	6a42                	ld	s4,16(sp)
    80000d1e:	6aa2                	ld	s5,8(sp)
    80000d20:	6b02                	ld	s6,0(sp)
    80000d22:	6121                	addi	sp,sp,64
    80000d24:	8082                	ret

0000000080000d26 <cpuid>:
  // Must be called with interrupts disabled,
  // to prevent race with process being moved
  // to a different CPU.
  int
  cpuid()
  {
    80000d26:	1141                	addi	sp,sp,-16
    80000d28:	e422                	sd	s0,8(sp)
    80000d2a:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000d2c:	8512                	mv	a0,tp
    int id = r_tp();
    return id;
  }
    80000d2e:	2501                	sext.w	a0,a0
    80000d30:	6422                	ld	s0,8(sp)
    80000d32:	0141                	addi	sp,sp,16
    80000d34:	8082                	ret

0000000080000d36 <mycpu>:

  // Return this CPU's cpu struct.
  // Interrupts must be disabled.
  struct cpu*
  mycpu(void)
  {
    80000d36:	1141                	addi	sp,sp,-16
    80000d38:	e422                	sd	s0,8(sp)
    80000d3a:	0800                	addi	s0,sp,16
    80000d3c:	8792                	mv	a5,tp
    int id = cpuid();
    struct cpu *c = &cpus[id];
    80000d3e:	2781                	sext.w	a5,a5
    80000d40:	079e                	slli	a5,a5,0x7
    return c;
  }
    80000d42:	00007517          	auipc	a0,0x7
    80000d46:	c1e50513          	addi	a0,a0,-994 # 80007960 <cpus>
    80000d4a:	953e                	add	a0,a0,a5
    80000d4c:	6422                	ld	s0,8(sp)
    80000d4e:	0141                	addi	sp,sp,16
    80000d50:	8082                	ret

0000000080000d52 <myproc>:

  // Return the current struct proc *, or zero if none.
  struct proc*
  myproc(void)
  {
    80000d52:	1101                	addi	sp,sp,-32
    80000d54:	ec06                	sd	ra,24(sp)
    80000d56:	e822                	sd	s0,16(sp)
    80000d58:	e426                	sd	s1,8(sp)
    80000d5a:	1000                	addi	s0,sp,32
    push_off();
    80000d5c:	14f040ef          	jal	ra,800056aa <push_off>
    80000d60:	8792                	mv	a5,tp
    struct cpu *c = mycpu();
    struct proc *p = c->proc;
    80000d62:	2781                	sext.w	a5,a5
    80000d64:	079e                	slli	a5,a5,0x7
    80000d66:	00007717          	auipc	a4,0x7
    80000d6a:	bca70713          	addi	a4,a4,-1078 # 80007930 <pid_lock>
    80000d6e:	97ba                	add	a5,a5,a4
    80000d70:	7b84                	ld	s1,48(a5)
    pop_off();
    80000d72:	1bd040ef          	jal	ra,8000572e <pop_off>
    return p;
  }
    80000d76:	8526                	mv	a0,s1
    80000d78:	60e2                	ld	ra,24(sp)
    80000d7a:	6442                	ld	s0,16(sp)
    80000d7c:	64a2                	ld	s1,8(sp)
    80000d7e:	6105                	addi	sp,sp,32
    80000d80:	8082                	ret

0000000080000d82 <forkret>:

  // A fork child's very first scheduling by scheduler()
  // will swtch to forkret.
  void
  forkret(void)
  {
    80000d82:	1141                	addi	sp,sp,-16
    80000d84:	e406                	sd	ra,8(sp)
    80000d86:	e022                	sd	s0,0(sp)
    80000d88:	0800                	addi	s0,sp,16
    static int first = 1;

    // Still holding p->lock from scheduler.
    release(&myproc()->lock);
    80000d8a:	fc9ff0ef          	jal	ra,80000d52 <myproc>
    80000d8e:	1f5040ef          	jal	ra,80005782 <release>

    if (first) {
    80000d92:	00007797          	auipc	a5,0x7
    80000d96:	afe7a783          	lw	a5,-1282(a5) # 80007890 <first.1>
    80000d9a:	e799                	bnez	a5,80000da8 <forkret+0x26>
      first = 0;
      // ensure other cores see first=0.
      __sync_synchronize();
    }

    usertrapret();
    80000d9c:	34d000ef          	jal	ra,800018e8 <usertrapret>
  }
    80000da0:	60a2                	ld	ra,8(sp)
    80000da2:	6402                	ld	s0,0(sp)
    80000da4:	0141                	addi	sp,sp,16
    80000da6:	8082                	ret
      fsinit(ROOTDEV);
    80000da8:	4505                	li	a0,1
    80000daa:	786010ef          	jal	ra,80002530 <fsinit>
      first = 0;
    80000dae:	00007797          	auipc	a5,0x7
    80000db2:	ae07a123          	sw	zero,-1310(a5) # 80007890 <first.1>
      __sync_synchronize();
    80000db6:	0ff0000f          	fence
    80000dba:	b7cd                	j	80000d9c <forkret+0x1a>

0000000080000dbc <allocpid>:
  {
    80000dbc:	1101                	addi	sp,sp,-32
    80000dbe:	ec06                	sd	ra,24(sp)
    80000dc0:	e822                	sd	s0,16(sp)
    80000dc2:	e426                	sd	s1,8(sp)
    80000dc4:	e04a                	sd	s2,0(sp)
    80000dc6:	1000                	addi	s0,sp,32
    acquire(&pid_lock);
    80000dc8:	00007917          	auipc	s2,0x7
    80000dcc:	b6890913          	addi	s2,s2,-1176 # 80007930 <pid_lock>
    80000dd0:	854a                	mv	a0,s2
    80000dd2:	119040ef          	jal	ra,800056ea <acquire>
    pid = nextpid;
    80000dd6:	00007797          	auipc	a5,0x7
    80000dda:	abe78793          	addi	a5,a5,-1346 # 80007894 <nextpid>
    80000dde:	4384                	lw	s1,0(a5)
    nextpid = nextpid + 1;
    80000de0:	0014871b          	addiw	a4,s1,1
    80000de4:	c398                	sw	a4,0(a5)
    release(&pid_lock);
    80000de6:	854a                	mv	a0,s2
    80000de8:	19b040ef          	jal	ra,80005782 <release>
  }
    80000dec:	8526                	mv	a0,s1
    80000dee:	60e2                	ld	ra,24(sp)
    80000df0:	6442                	ld	s0,16(sp)
    80000df2:	64a2                	ld	s1,8(sp)
    80000df4:	6902                	ld	s2,0(sp)
    80000df6:	6105                	addi	sp,sp,32
    80000df8:	8082                	ret

0000000080000dfa <proc_pagetable>:
  {
    80000dfa:	1101                	addi	sp,sp,-32
    80000dfc:	ec06                	sd	ra,24(sp)
    80000dfe:	e822                	sd	s0,16(sp)
    80000e00:	e426                	sd	s1,8(sp)
    80000e02:	e04a                	sd	s2,0(sp)
    80000e04:	1000                	addi	s0,sp,32
    80000e06:	892a                	mv	s2,a0
    pagetable = uvmcreate();
    80000e08:	8ebff0ef          	jal	ra,800006f2 <uvmcreate>
    80000e0c:	84aa                	mv	s1,a0
    if(pagetable == 0)
    80000e0e:	c929                	beqz	a0,80000e60 <proc_pagetable+0x66>
    if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000e10:	4729                	li	a4,10
    80000e12:	00005697          	auipc	a3,0x5
    80000e16:	1ee68693          	addi	a3,a3,494 # 80006000 <_trampoline>
    80000e1a:	6605                	lui	a2,0x1
    80000e1c:	040005b7          	lui	a1,0x4000
    80000e20:	15fd                	addi	a1,a1,-1
    80000e22:	05b2                	slli	a1,a1,0xc
    80000e24:	e7cff0ef          	jal	ra,800004a0 <mappages>
    80000e28:	04054363          	bltz	a0,80000e6e <proc_pagetable+0x74>
    if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000e2c:	4719                	li	a4,6
    80000e2e:	04093683          	ld	a3,64(s2)
    80000e32:	6605                	lui	a2,0x1
    80000e34:	020005b7          	lui	a1,0x2000
    80000e38:	15fd                	addi	a1,a1,-1
    80000e3a:	05b6                	slli	a1,a1,0xd
    80000e3c:	8526                	mv	a0,s1
    80000e3e:	e62ff0ef          	jal	ra,800004a0 <mappages>
    80000e42:	02054c63          	bltz	a0,80000e7a <proc_pagetable+0x80>
    if(mappages(pagetable, USYSCALL, PGSIZE,
    80000e46:	4749                	li	a4,18
    80000e48:	04893683          	ld	a3,72(s2)
    80000e4c:	6605                	lui	a2,0x1
    80000e4e:	040005b7          	lui	a1,0x4000
    80000e52:	15f5                	addi	a1,a1,-3
    80000e54:	05b2                	slli	a1,a1,0xc
    80000e56:	8526                	mv	a0,s1
    80000e58:	e48ff0ef          	jal	ra,800004a0 <mappages>
    80000e5c:	02054e63          	bltz	a0,80000e98 <proc_pagetable+0x9e>
  }
    80000e60:	8526                	mv	a0,s1
    80000e62:	60e2                	ld	ra,24(sp)
    80000e64:	6442                	ld	s0,16(sp)
    80000e66:	64a2                	ld	s1,8(sp)
    80000e68:	6902                	ld	s2,0(sp)
    80000e6a:	6105                	addi	sp,sp,32
    80000e6c:	8082                	ret
      uvmfree(pagetable, 0);
    80000e6e:	4581                	li	a1,0
    80000e70:	8526                	mv	a0,s1
    80000e72:	a41ff0ef          	jal	ra,800008b2 <uvmfree>
      return 0;
    80000e76:	4481                	li	s1,0
    80000e78:	b7e5                	j	80000e60 <proc_pagetable+0x66>
      uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000e7a:	4681                	li	a3,0
    80000e7c:	4605                	li	a2,1
    80000e7e:	040005b7          	lui	a1,0x4000
    80000e82:	15fd                	addi	a1,a1,-1
    80000e84:	05b2                	slli	a1,a1,0xc
    80000e86:	8526                	mv	a0,s1
    80000e88:	fbeff0ef          	jal	ra,80000646 <uvmunmap>
      uvmfree(pagetable, 0);
    80000e8c:	4581                	li	a1,0
    80000e8e:	8526                	mv	a0,s1
    80000e90:	a23ff0ef          	jal	ra,800008b2 <uvmfree>
      return 0;
    80000e94:	4481                	li	s1,0
    80000e96:	b7e9                	j	80000e60 <proc_pagetable+0x66>
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000e98:	4681                	li	a3,0
    80000e9a:	4605                	li	a2,1
    80000e9c:	020005b7          	lui	a1,0x2000
    80000ea0:	15fd                	addi	a1,a1,-1
    80000ea2:	05b6                	slli	a1,a1,0xd
    80000ea4:	8526                	mv	a0,s1
    80000ea6:	fa0ff0ef          	jal	ra,80000646 <uvmunmap>
    uvmfree(pagetable, 0);
    80000eaa:	4581                	li	a1,0
    80000eac:	8526                	mv	a0,s1
    80000eae:	a05ff0ef          	jal	ra,800008b2 <uvmfree>
    return 0;
    80000eb2:	4481                	li	s1,0
    80000eb4:	b775                	j	80000e60 <proc_pagetable+0x66>

0000000080000eb6 <proc_freepagetable>:
  {
    80000eb6:	7179                	addi	sp,sp,-48
    80000eb8:	f406                	sd	ra,40(sp)
    80000eba:	f022                	sd	s0,32(sp)
    80000ebc:	ec26                	sd	s1,24(sp)
    80000ebe:	e84a                	sd	s2,16(sp)
    80000ec0:	e44e                	sd	s3,8(sp)
    80000ec2:	1800                	addi	s0,sp,48
    80000ec4:	84aa                	mv	s1,a0
    80000ec6:	89ae                	mv	s3,a1
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000ec8:	4681                	li	a3,0
    80000eca:	4605                	li	a2,1
    80000ecc:	04000937          	lui	s2,0x4000
    80000ed0:	fff90593          	addi	a1,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000ed4:	05b2                	slli	a1,a1,0xc
    80000ed6:	f70ff0ef          	jal	ra,80000646 <uvmunmap>
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000eda:	4681                	li	a3,0
    80000edc:	4605                	li	a2,1
    80000ede:	020005b7          	lui	a1,0x2000
    80000ee2:	15fd                	addi	a1,a1,-1
    80000ee4:	05b6                	slli	a1,a1,0xd
    80000ee6:	8526                	mv	a0,s1
    80000ee8:	f5eff0ef          	jal	ra,80000646 <uvmunmap>
    pte_t *pte = walk(pagetable, USYSCALL, 0);
    80000eec:	4601                	li	a2,0
    80000eee:	1975                	addi	s2,s2,-3
    80000ef0:	00c91593          	slli	a1,s2,0xc
    80000ef4:	8526                	mv	a0,s1
    80000ef6:	cd2ff0ef          	jal	ra,800003c8 <walk>
    if(pte && (*pte & PTE_V)){
    80000efa:	c501                	beqz	a0,80000f02 <proc_freepagetable+0x4c>
    80000efc:	611c                	ld	a5,0(a0)
    80000efe:	8b85                	andi	a5,a5,1
    80000f00:	ef81                	bnez	a5,80000f18 <proc_freepagetable+0x62>
    uvmfree(pagetable, sz);
    80000f02:	85ce                	mv	a1,s3
    80000f04:	8526                	mv	a0,s1
    80000f06:	9adff0ef          	jal	ra,800008b2 <uvmfree>
  }
    80000f0a:	70a2                	ld	ra,40(sp)
    80000f0c:	7402                	ld	s0,32(sp)
    80000f0e:	64e2                	ld	s1,24(sp)
    80000f10:	6942                	ld	s2,16(sp)
    80000f12:	69a2                	ld	s3,8(sp)
    80000f14:	6145                	addi	sp,sp,48
    80000f16:	8082                	ret
    uvmunmap(pagetable, USYSCALL, 1, 0);
    80000f18:	4681                	li	a3,0
    80000f1a:	4605                	li	a2,1
    80000f1c:	00c91593          	slli	a1,s2,0xc
    80000f20:	8526                	mv	a0,s1
    80000f22:	f24ff0ef          	jal	ra,80000646 <uvmunmap>
    80000f26:	bff1                	j	80000f02 <proc_freepagetable+0x4c>

0000000080000f28 <freeproc>:
  {
    80000f28:	1101                	addi	sp,sp,-32
    80000f2a:	ec06                	sd	ra,24(sp)
    80000f2c:	e822                	sd	s0,16(sp)
    80000f2e:	e426                	sd	s1,8(sp)
    80000f30:	1000                	addi	s0,sp,32
    80000f32:	84aa                	mv	s1,a0
   if(p->trapframe)
    80000f34:	6128                	ld	a0,64(a0)
    80000f36:	c119                	beqz	a0,80000f3c <freeproc+0x14>
    kfree((void*)p->trapframe);
    80000f38:	8e4ff0ef          	jal	ra,8000001c <kfree>
  p->trapframe = 0;
    80000f3c:	0404b023          	sd	zero,64(s1)
  if(p->usyscall)
    80000f40:	64a8                	ld	a0,72(s1)
    80000f42:	c119                	beqz	a0,80000f48 <freeproc+0x20>
    kfree((void*)p->usyscall);
    80000f44:	8d8ff0ef          	jal	ra,8000001c <kfree>
  p->usyscall = 0;
    80000f48:	0404b423          	sd	zero,72(s1)
  if(p->pagetable){
    80000f4c:	68e8                	ld	a0,208(s1)
    80000f4e:	c501                	beqz	a0,80000f56 <freeproc+0x2e>
    proc_freepagetable(p->pagetable, p->sz);
    80000f50:	64ec                	ld	a1,200(s1)
    80000f52:	f65ff0ef          	jal	ra,80000eb6 <proc_freepagetable>
    p->pagetable = 0;
    80000f56:	0c04b823          	sd	zero,208(s1)
    p->sz = 0;
    80000f5a:	0c04b423          	sd	zero,200(s1)
    p->pid = 0;
    80000f5e:	0204a823          	sw	zero,48(s1)
    p->parent = 0;
    80000f62:	0204bc23          	sd	zero,56(s1)
    p->name[0] = 0;
    80000f66:	16048023          	sb	zero,352(s1)
    p->chan = 0;
    80000f6a:	0204b023          	sd	zero,32(s1)
    p->killed = 0;
    80000f6e:	0204a423          	sw	zero,40(s1)
    p->xstate = 0;
    80000f72:	0204a623          	sw	zero,44(s1)
    p->state = UNUSED;
    80000f76:	0004ac23          	sw	zero,24(s1)
  }
    80000f7a:	60e2                	ld	ra,24(sp)
    80000f7c:	6442                	ld	s0,16(sp)
    80000f7e:	64a2                	ld	s1,8(sp)
    80000f80:	6105                	addi	sp,sp,32
    80000f82:	8082                	ret

0000000080000f84 <allocproc>:
  {
    80000f84:	1101                	addi	sp,sp,-32
    80000f86:	ec06                	sd	ra,24(sp)
    80000f88:	e822                	sd	s0,16(sp)
    80000f8a:	e426                	sd	s1,8(sp)
    80000f8c:	e04a                	sd	s2,0(sp)
    80000f8e:	1000                	addi	s0,sp,32
    for(p = proc; p < &proc[NPROC]; p++) {
    80000f90:	00007497          	auipc	s1,0x7
    80000f94:	dd048493          	addi	s1,s1,-560 # 80007d60 <proc>
    80000f98:	0000d917          	auipc	s2,0xd
    80000f9c:	9c890913          	addi	s2,s2,-1592 # 8000d960 <tickslock>
      acquire(&p->lock);
    80000fa0:	8526                	mv	a0,s1
    80000fa2:	748040ef          	jal	ra,800056ea <acquire>
      if(p->state == UNUSED) {
    80000fa6:	4c9c                	lw	a5,24(s1)
    80000fa8:	cb91                	beqz	a5,80000fbc <allocproc+0x38>
        release(&p->lock);
    80000faa:	8526                	mv	a0,s1
    80000fac:	7d6040ef          	jal	ra,80005782 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80000fb0:	17048493          	addi	s1,s1,368
    80000fb4:	ff2496e3          	bne	s1,s2,80000fa0 <allocproc+0x1c>
    return 0;
    80000fb8:	4481                	li	s1,0
    80000fba:	a881                	j	8000100a <allocproc+0x86>
  p->pid = allocpid();
    80000fbc:	e01ff0ef          	jal	ra,80000dbc <allocpid>
    80000fc0:	d888                	sw	a0,48(s1)
  p->state = USED;
    80000fc2:	4785                	li	a5,1
    80000fc4:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80000fc6:	936ff0ef          	jal	ra,800000fc <kalloc>
    80000fca:	892a                	mv	s2,a0
    80000fcc:	e0a8                	sd	a0,64(s1)
    80000fce:	c529                	beqz	a0,80001018 <allocproc+0x94>
  p->usyscall = (struct usyscall *) kalloc();
    80000fd0:	92cff0ef          	jal	ra,800000fc <kalloc>
    80000fd4:	892a                	mv	s2,a0
    80000fd6:	e4a8                	sd	a0,72(s1)
  if(p->usyscall == 0){
    80000fd8:	c921                	beqz	a0,80001028 <allocproc+0xa4>
  p->usyscall->pid = p->pid; // Cập nhật pid trong usyscall ngay khi cấp phát
    80000fda:	589c                	lw	a5,48(s1)
    80000fdc:	c11c                	sw	a5,0(a0)
    p->pagetable = proc_pagetable(p);
    80000fde:	8526                	mv	a0,s1
    80000fe0:	e1bff0ef          	jal	ra,80000dfa <proc_pagetable>
    80000fe4:	892a                	mv	s2,a0
    80000fe6:	e8e8                	sd	a0,208(s1)
    if(p->pagetable == 0){
    80000fe8:	c529                	beqz	a0,80001032 <allocproc+0xae>
    memset(&p->context, 0, sizeof(p->context));
    80000fea:	07000613          	li	a2,112
    80000fee:	4581                	li	a1,0
    80000ff0:	05048513          	addi	a0,s1,80
    80000ff4:	958ff0ef          	jal	ra,8000014c <memset>
    p->context.ra = (uint64)forkret;
    80000ff8:	00000797          	auipc	a5,0x0
    80000ffc:	d8a78793          	addi	a5,a5,-630 # 80000d82 <forkret>
    80001000:	e8bc                	sd	a5,80(s1)
    p->context.sp = p->kstack + PGSIZE;
    80001002:	60fc                	ld	a5,192(s1)
    80001004:	6705                	lui	a4,0x1
    80001006:	97ba                	add	a5,a5,a4
    80001008:	ecbc                	sd	a5,88(s1)
  }
    8000100a:	8526                	mv	a0,s1
    8000100c:	60e2                	ld	ra,24(sp)
    8000100e:	6442                	ld	s0,16(sp)
    80001010:	64a2                	ld	s1,8(sp)
    80001012:	6902                	ld	s2,0(sp)
    80001014:	6105                	addi	sp,sp,32
    80001016:	8082                	ret
    freeproc(p);
    80001018:	8526                	mv	a0,s1
    8000101a:	f0fff0ef          	jal	ra,80000f28 <freeproc>
    release(&p->lock);
    8000101e:	8526                	mv	a0,s1
    80001020:	762040ef          	jal	ra,80005782 <release>
    return 0;
    80001024:	84ca                	mv	s1,s2
    80001026:	b7d5                	j	8000100a <allocproc+0x86>
    freeproc(p);
    80001028:	8526                	mv	a0,s1
    8000102a:	effff0ef          	jal	ra,80000f28 <freeproc>
    return 0;
    8000102e:	84ca                	mv	s1,s2
    80001030:	bfe9                	j	8000100a <allocproc+0x86>
      freeproc(p);
    80001032:	8526                	mv	a0,s1
    80001034:	ef5ff0ef          	jal	ra,80000f28 <freeproc>
      release(&p->lock);
    80001038:	8526                	mv	a0,s1
    8000103a:	748040ef          	jal	ra,80005782 <release>
      return 0;
    8000103e:	84ca                	mv	s1,s2
    80001040:	b7e9                	j	8000100a <allocproc+0x86>

0000000080001042 <userinit>:
  {
    80001042:	1101                	addi	sp,sp,-32
    80001044:	ec06                	sd	ra,24(sp)
    80001046:	e822                	sd	s0,16(sp)
    80001048:	e426                	sd	s1,8(sp)
    8000104a:	1000                	addi	s0,sp,32
    p = allocproc();
    8000104c:	f39ff0ef          	jal	ra,80000f84 <allocproc>
    80001050:	84aa                	mv	s1,a0
    initproc = p;
    80001052:	00007797          	auipc	a5,0x7
    80001056:	88a7bf23          	sd	a0,-1890(a5) # 800078f0 <initproc>
    uvmfirst(p->pagetable, initcode, sizeof(initcode));
    8000105a:	03400613          	li	a2,52
    8000105e:	00007597          	auipc	a1,0x7
    80001062:	84258593          	addi	a1,a1,-1982 # 800078a0 <initcode>
    80001066:	6968                	ld	a0,208(a0)
    80001068:	eb0ff0ef          	jal	ra,80000718 <uvmfirst>
    p->sz = PGSIZE;
    8000106c:	6785                	lui	a5,0x1
    8000106e:	e4fc                	sd	a5,200(s1)
    p->trapframe->epc = 0;      // user program counter
    80001070:	60b8                	ld	a4,64(s1)
    80001072:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
    p->trapframe->sp = PGSIZE;  // user stack pointer
    80001076:	60b8                	ld	a4,64(s1)
    80001078:	fb1c                	sd	a5,48(a4)
    safestrcpy(p->name, "initcode", sizeof(p->name));
    8000107a:	4641                	li	a2,16
    8000107c:	00006597          	auipc	a1,0x6
    80001080:	14458593          	addi	a1,a1,324 # 800071c0 <etext+0x1c0>
    80001084:	16048513          	addi	a0,s1,352
    80001088:	a0aff0ef          	jal	ra,80000292 <safestrcpy>
    p->cwd = namei("/");
    8000108c:	00006517          	auipc	a0,0x6
    80001090:	14450513          	addi	a0,a0,324 # 800071d0 <etext+0x1d0>
    80001094:	57b010ef          	jal	ra,80002e0e <namei>
    80001098:	14a4bc23          	sd	a0,344(s1)
    p->state = RUNNABLE;
    8000109c:	478d                	li	a5,3
    8000109e:	cc9c                	sw	a5,24(s1)
    release(&p->lock);
    800010a0:	8526                	mv	a0,s1
    800010a2:	6e0040ef          	jal	ra,80005782 <release>
  }
    800010a6:	60e2                	ld	ra,24(sp)
    800010a8:	6442                	ld	s0,16(sp)
    800010aa:	64a2                	ld	s1,8(sp)
    800010ac:	6105                	addi	sp,sp,32
    800010ae:	8082                	ret

00000000800010b0 <growproc>:
  {
    800010b0:	1101                	addi	sp,sp,-32
    800010b2:	ec06                	sd	ra,24(sp)
    800010b4:	e822                	sd	s0,16(sp)
    800010b6:	e426                	sd	s1,8(sp)
    800010b8:	e04a                	sd	s2,0(sp)
    800010ba:	1000                	addi	s0,sp,32
    800010bc:	892a                	mv	s2,a0
    struct proc *p = myproc();
    800010be:	c95ff0ef          	jal	ra,80000d52 <myproc>
    800010c2:	84aa                	mv	s1,a0
    sz = p->sz;
    800010c4:	656c                	ld	a1,200(a0)
    if(n > 0){
    800010c6:	01204c63          	bgtz	s2,800010de <growproc+0x2e>
    } else if(n < 0){
    800010ca:	02094463          	bltz	s2,800010f2 <growproc+0x42>
    p->sz = sz;
    800010ce:	e4ec                	sd	a1,200(s1)
    return 0;
    800010d0:	4501                	li	a0,0
  }
    800010d2:	60e2                	ld	ra,24(sp)
    800010d4:	6442                	ld	s0,16(sp)
    800010d6:	64a2                	ld	s1,8(sp)
    800010d8:	6902                	ld	s2,0(sp)
    800010da:	6105                	addi	sp,sp,32
    800010dc:	8082                	ret
      if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800010de:	4691                	li	a3,4
    800010e0:	00b90633          	add	a2,s2,a1
    800010e4:	6968                	ld	a0,208(a0)
    800010e6:	ed4ff0ef          	jal	ra,800007ba <uvmalloc>
    800010ea:	85aa                	mv	a1,a0
    800010ec:	f16d                	bnez	a0,800010ce <growproc+0x1e>
        return -1;
    800010ee:	557d                	li	a0,-1
    800010f0:	b7cd                	j	800010d2 <growproc+0x22>
      sz = uvmdealloc(p->pagetable, sz, sz + n);
    800010f2:	00b90633          	add	a2,s2,a1
    800010f6:	6968                	ld	a0,208(a0)
    800010f8:	e7eff0ef          	jal	ra,80000776 <uvmdealloc>
    800010fc:	85aa                	mv	a1,a0
    800010fe:	bfc1                	j	800010ce <growproc+0x1e>

0000000080001100 <fork>:
  {
    80001100:	7139                	addi	sp,sp,-64
    80001102:	fc06                	sd	ra,56(sp)
    80001104:	f822                	sd	s0,48(sp)
    80001106:	f426                	sd	s1,40(sp)
    80001108:	f04a                	sd	s2,32(sp)
    8000110a:	ec4e                	sd	s3,24(sp)
    8000110c:	e852                	sd	s4,16(sp)
    8000110e:	e456                	sd	s5,8(sp)
    80001110:	0080                	addi	s0,sp,64
    struct proc *p = myproc();
    80001112:	c41ff0ef          	jal	ra,80000d52 <myproc>
    80001116:	8aaa                	mv	s5,a0
    if((np = allocproc()) == 0){
    80001118:	e6dff0ef          	jal	ra,80000f84 <allocproc>
    8000111c:	0e050b63          	beqz	a0,80001212 <fork+0x112>
    80001120:	89aa                	mv	s3,a0
    if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001122:	0c8ab603          	ld	a2,200(s5)
    80001126:	696c                	ld	a1,208(a0)
    80001128:	0d0ab503          	ld	a0,208(s5)
    8000112c:	fc2ff0ef          	jal	ra,800008ee <uvmcopy>
    80001130:	04054d63          	bltz	a0,8000118a <fork+0x8a>
    np->sz = p->sz;
    80001134:	0c8ab783          	ld	a5,200(s5)
    80001138:	0cf9b423          	sd	a5,200(s3)
    *(np->trapframe) = *(p->trapframe);
    8000113c:	040ab683          	ld	a3,64(s5)
    80001140:	87b6                	mv	a5,a3
    80001142:	0409b703          	ld	a4,64(s3)
    80001146:	12068693          	addi	a3,a3,288
    8000114a:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000114e:	6788                	ld	a0,8(a5)
    80001150:	6b8c                	ld	a1,16(a5)
    80001152:	6f90                	ld	a2,24(a5)
    80001154:	01073023          	sd	a6,0(a4)
    80001158:	e708                	sd	a0,8(a4)
    8000115a:	eb0c                	sd	a1,16(a4)
    8000115c:	ef10                	sd	a2,24(a4)
    8000115e:	02078793          	addi	a5,a5,32
    80001162:	02070713          	addi	a4,a4,32
    80001166:	fed792e3          	bne	a5,a3,8000114a <fork+0x4a>
    np->usyscall->pid = np->pid; // Cập nhật pid trong usyscall của tiến trình con
    8000116a:	0489b783          	ld	a5,72(s3)
    8000116e:	0309a703          	lw	a4,48(s3)
    80001172:	c398                	sw	a4,0(a5)
    np->trapframe->a0 = 0;
    80001174:	0409b783          	ld	a5,64(s3)
    80001178:	0607b823          	sd	zero,112(a5)
    for(i = 0; i < NOFILE; i++)
    8000117c:	0d8a8493          	addi	s1,s5,216
    80001180:	0d898913          	addi	s2,s3,216
    80001184:	158a8a13          	addi	s4,s5,344
    80001188:	a829                	j	800011a2 <fork+0xa2>
      freeproc(np);
    8000118a:	854e                	mv	a0,s3
    8000118c:	d9dff0ef          	jal	ra,80000f28 <freeproc>
      release(&np->lock);
    80001190:	854e                	mv	a0,s3
    80001192:	5f0040ef          	jal	ra,80005782 <release>
      return -1;
    80001196:	597d                	li	s2,-1
    80001198:	a09d                	j	800011fe <fork+0xfe>
    for(i = 0; i < NOFILE; i++)
    8000119a:	04a1                	addi	s1,s1,8
    8000119c:	0921                	addi	s2,s2,8
    8000119e:	01448963          	beq	s1,s4,800011b0 <fork+0xb0>
      if(p->ofile[i])
    800011a2:	6088                	ld	a0,0(s1)
    800011a4:	d97d                	beqz	a0,8000119a <fork+0x9a>
        np->ofile[i] = filedup(p->ofile[i]);
    800011a6:	216020ef          	jal	ra,800033bc <filedup>
    800011aa:	00a93023          	sd	a0,0(s2)
    800011ae:	b7f5                	j	8000119a <fork+0x9a>
    np->cwd = idup(p->cwd);
    800011b0:	158ab503          	ld	a0,344(s5)
    800011b4:	572010ef          	jal	ra,80002726 <idup>
    800011b8:	14a9bc23          	sd	a0,344(s3)
    safestrcpy(np->name, p->name, sizeof(p->name));
    800011bc:	4641                	li	a2,16
    800011be:	160a8593          	addi	a1,s5,352
    800011c2:	16098513          	addi	a0,s3,352
    800011c6:	8ccff0ef          	jal	ra,80000292 <safestrcpy>
    pid = np->pid;
    800011ca:	0309a903          	lw	s2,48(s3)
    release(&np->lock);
    800011ce:	854e                	mv	a0,s3
    800011d0:	5b2040ef          	jal	ra,80005782 <release>
    acquire(&wait_lock);
    800011d4:	00006497          	auipc	s1,0x6
    800011d8:	77448493          	addi	s1,s1,1908 # 80007948 <wait_lock>
    800011dc:	8526                	mv	a0,s1
    800011de:	50c040ef          	jal	ra,800056ea <acquire>
    np->parent = p;
    800011e2:	0359bc23          	sd	s5,56(s3)
    release(&wait_lock);
    800011e6:	8526                	mv	a0,s1
    800011e8:	59a040ef          	jal	ra,80005782 <release>
    acquire(&np->lock);
    800011ec:	854e                	mv	a0,s3
    800011ee:	4fc040ef          	jal	ra,800056ea <acquire>
    np->state = RUNNABLE;
    800011f2:	478d                	li	a5,3
    800011f4:	00f9ac23          	sw	a5,24(s3)
    release(&np->lock);
    800011f8:	854e                	mv	a0,s3
    800011fa:	588040ef          	jal	ra,80005782 <release>
  }
    800011fe:	854a                	mv	a0,s2
    80001200:	70e2                	ld	ra,56(sp)
    80001202:	7442                	ld	s0,48(sp)
    80001204:	74a2                	ld	s1,40(sp)
    80001206:	7902                	ld	s2,32(sp)
    80001208:	69e2                	ld	s3,24(sp)
    8000120a:	6a42                	ld	s4,16(sp)
    8000120c:	6aa2                	ld	s5,8(sp)
    8000120e:	6121                	addi	sp,sp,64
    80001210:	8082                	ret
      return -1;
    80001212:	597d                	li	s2,-1
    80001214:	b7ed                	j	800011fe <fork+0xfe>

0000000080001216 <scheduler>:
  {
    80001216:	715d                	addi	sp,sp,-80
    80001218:	e486                	sd	ra,72(sp)
    8000121a:	e0a2                	sd	s0,64(sp)
    8000121c:	fc26                	sd	s1,56(sp)
    8000121e:	f84a                	sd	s2,48(sp)
    80001220:	f44e                	sd	s3,40(sp)
    80001222:	f052                	sd	s4,32(sp)
    80001224:	ec56                	sd	s5,24(sp)
    80001226:	e85a                	sd	s6,16(sp)
    80001228:	e45e                	sd	s7,8(sp)
    8000122a:	e062                	sd	s8,0(sp)
    8000122c:	0880                	addi	s0,sp,80
    8000122e:	8792                	mv	a5,tp
    int id = r_tp();
    80001230:	2781                	sext.w	a5,a5
    c->proc = 0;
    80001232:	00779b13          	slli	s6,a5,0x7
    80001236:	00006717          	auipc	a4,0x6
    8000123a:	6fa70713          	addi	a4,a4,1786 # 80007930 <pid_lock>
    8000123e:	975a                	add	a4,a4,s6
    80001240:	02073823          	sd	zero,48(a4)
          swtch(&c->context, &p->context);
    80001244:	00006717          	auipc	a4,0x6
    80001248:	72470713          	addi	a4,a4,1828 # 80007968 <cpus+0x8>
    8000124c:	9b3a                	add	s6,s6,a4
          p->state = RUNNING;
    8000124e:	4c11                	li	s8,4
          c->proc = p;
    80001250:	079e                	slli	a5,a5,0x7
    80001252:	00006a17          	auipc	s4,0x6
    80001256:	6dea0a13          	addi	s4,s4,1758 # 80007930 <pid_lock>
    8000125a:	9a3e                	add	s4,s4,a5
          found = 1;
    8000125c:	4b85                	li	s7,1
      for(p = proc; p < &proc[NPROC]; p++) {
    8000125e:	0000c997          	auipc	s3,0xc
    80001262:	70298993          	addi	s3,s3,1794 # 8000d960 <tickslock>
    80001266:	a0a9                	j	800012b0 <scheduler+0x9a>
        release(&p->lock);
    80001268:	8526                	mv	a0,s1
    8000126a:	518040ef          	jal	ra,80005782 <release>
      for(p = proc; p < &proc[NPROC]; p++) {
    8000126e:	17048493          	addi	s1,s1,368
    80001272:	03348563          	beq	s1,s3,8000129c <scheduler+0x86>
        acquire(&p->lock);
    80001276:	8526                	mv	a0,s1
    80001278:	472040ef          	jal	ra,800056ea <acquire>
        if(p->state == RUNNABLE) {
    8000127c:	4c9c                	lw	a5,24(s1)
    8000127e:	ff2795e3          	bne	a5,s2,80001268 <scheduler+0x52>
          p->state = RUNNING;
    80001282:	0184ac23          	sw	s8,24(s1)
          c->proc = p;
    80001286:	029a3823          	sd	s1,48(s4)
          swtch(&c->context, &p->context);
    8000128a:	05048593          	addi	a1,s1,80
    8000128e:	855a                	mv	a0,s6
    80001290:	5b2000ef          	jal	ra,80001842 <swtch>
          c->proc = 0;
    80001294:	020a3823          	sd	zero,48(s4)
          found = 1;
    80001298:	8ade                	mv	s5,s7
    8000129a:	b7f9                	j	80001268 <scheduler+0x52>
      if(found == 0) {
    8000129c:	000a9a63          	bnez	s5,800012b0 <scheduler+0x9a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800012a0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800012a4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800012a8:	10079073          	csrw	sstatus,a5
        asm volatile("wfi");
    800012ac:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800012b0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800012b4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800012b8:	10079073          	csrw	sstatus,a5
      int found = 0;
    800012bc:	4a81                	li	s5,0
      for(p = proc; p < &proc[NPROC]; p++) {
    800012be:	00007497          	auipc	s1,0x7
    800012c2:	aa248493          	addi	s1,s1,-1374 # 80007d60 <proc>
        if(p->state == RUNNABLE) {
    800012c6:	490d                	li	s2,3
    800012c8:	b77d                	j	80001276 <scheduler+0x60>

00000000800012ca <sched>:
  {
    800012ca:	7179                	addi	sp,sp,-48
    800012cc:	f406                	sd	ra,40(sp)
    800012ce:	f022                	sd	s0,32(sp)
    800012d0:	ec26                	sd	s1,24(sp)
    800012d2:	e84a                	sd	s2,16(sp)
    800012d4:	e44e                	sd	s3,8(sp)
    800012d6:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    800012d8:	a7bff0ef          	jal	ra,80000d52 <myproc>
    800012dc:	84aa                	mv	s1,a0
    if(!holding(&p->lock))
    800012de:	3a2040ef          	jal	ra,80005680 <holding>
    800012e2:	c92d                	beqz	a0,80001354 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    800012e4:	8792                	mv	a5,tp
    if(mycpu()->noff != 1)
    800012e6:	2781                	sext.w	a5,a5
    800012e8:	079e                	slli	a5,a5,0x7
    800012ea:	00006717          	auipc	a4,0x6
    800012ee:	64670713          	addi	a4,a4,1606 # 80007930 <pid_lock>
    800012f2:	97ba                	add	a5,a5,a4
    800012f4:	0a87a703          	lw	a4,168(a5)
    800012f8:	4785                	li	a5,1
    800012fa:	06f71363          	bne	a4,a5,80001360 <sched+0x96>
    if(p->state == RUNNING)
    800012fe:	4c98                	lw	a4,24(s1)
    80001300:	4791                	li	a5,4
    80001302:	06f70563          	beq	a4,a5,8000136c <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001306:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000130a:	8b89                	andi	a5,a5,2
    if(intr_get())
    8000130c:	e7b5                	bnez	a5,80001378 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000130e:	8792                	mv	a5,tp
    intena = mycpu()->intena;
    80001310:	00006917          	auipc	s2,0x6
    80001314:	62090913          	addi	s2,s2,1568 # 80007930 <pid_lock>
    80001318:	2781                	sext.w	a5,a5
    8000131a:	079e                	slli	a5,a5,0x7
    8000131c:	97ca                	add	a5,a5,s2
    8000131e:	0ac7a983          	lw	s3,172(a5)
    80001322:	8792                	mv	a5,tp
    swtch(&p->context, &mycpu()->context);
    80001324:	2781                	sext.w	a5,a5
    80001326:	079e                	slli	a5,a5,0x7
    80001328:	00006597          	auipc	a1,0x6
    8000132c:	64058593          	addi	a1,a1,1600 # 80007968 <cpus+0x8>
    80001330:	95be                	add	a1,a1,a5
    80001332:	05048513          	addi	a0,s1,80
    80001336:	50c000ef          	jal	ra,80001842 <swtch>
    8000133a:	8792                	mv	a5,tp
    mycpu()->intena = intena;
    8000133c:	2781                	sext.w	a5,a5
    8000133e:	079e                	slli	a5,a5,0x7
    80001340:	97ca                	add	a5,a5,s2
    80001342:	0b37a623          	sw	s3,172(a5)
  }
    80001346:	70a2                	ld	ra,40(sp)
    80001348:	7402                	ld	s0,32(sp)
    8000134a:	64e2                	ld	s1,24(sp)
    8000134c:	6942                	ld	s2,16(sp)
    8000134e:	69a2                	ld	s3,8(sp)
    80001350:	6145                	addi	sp,sp,48
    80001352:	8082                	ret
      panic("sched p->lock");
    80001354:	00006517          	auipc	a0,0x6
    80001358:	e8450513          	addi	a0,a0,-380 # 800071d8 <etext+0x1d8>
    8000135c:	07a040ef          	jal	ra,800053d6 <panic>
      panic("sched locks");
    80001360:	00006517          	auipc	a0,0x6
    80001364:	e8850513          	addi	a0,a0,-376 # 800071e8 <etext+0x1e8>
    80001368:	06e040ef          	jal	ra,800053d6 <panic>
      panic("sched running");
    8000136c:	00006517          	auipc	a0,0x6
    80001370:	e8c50513          	addi	a0,a0,-372 # 800071f8 <etext+0x1f8>
    80001374:	062040ef          	jal	ra,800053d6 <panic>
      panic("sched interruptible");
    80001378:	00006517          	auipc	a0,0x6
    8000137c:	e9050513          	addi	a0,a0,-368 # 80007208 <etext+0x208>
    80001380:	056040ef          	jal	ra,800053d6 <panic>

0000000080001384 <yield>:
  {
    80001384:	1101                	addi	sp,sp,-32
    80001386:	ec06                	sd	ra,24(sp)
    80001388:	e822                	sd	s0,16(sp)
    8000138a:	e426                	sd	s1,8(sp)
    8000138c:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    8000138e:	9c5ff0ef          	jal	ra,80000d52 <myproc>
    80001392:	84aa                	mv	s1,a0
    acquire(&p->lock);
    80001394:	356040ef          	jal	ra,800056ea <acquire>
    p->state = RUNNABLE;
    80001398:	478d                	li	a5,3
    8000139a:	cc9c                	sw	a5,24(s1)
    sched();
    8000139c:	f2fff0ef          	jal	ra,800012ca <sched>
    release(&p->lock);
    800013a0:	8526                	mv	a0,s1
    800013a2:	3e0040ef          	jal	ra,80005782 <release>
  }
    800013a6:	60e2                	ld	ra,24(sp)
    800013a8:	6442                	ld	s0,16(sp)
    800013aa:	64a2                	ld	s1,8(sp)
    800013ac:	6105                	addi	sp,sp,32
    800013ae:	8082                	ret

00000000800013b0 <sleep>:

  // Atomically release lock and sleep on chan.
  // Reacquires lock when awakened.
  void
  sleep(void *chan, struct spinlock *lk)
  {
    800013b0:	7179                	addi	sp,sp,-48
    800013b2:	f406                	sd	ra,40(sp)
    800013b4:	f022                	sd	s0,32(sp)
    800013b6:	ec26                	sd	s1,24(sp)
    800013b8:	e84a                	sd	s2,16(sp)
    800013ba:	e44e                	sd	s3,8(sp)
    800013bc:	1800                	addi	s0,sp,48
    800013be:	89aa                	mv	s3,a0
    800013c0:	892e                	mv	s2,a1
    struct proc *p = myproc();
    800013c2:	991ff0ef          	jal	ra,80000d52 <myproc>
    800013c6:	84aa                	mv	s1,a0
    // Once we hold p->lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup locks p->lock),
    // so it's okay to release lk.

    acquire(&p->lock);  //DOC: sleeplock1
    800013c8:	322040ef          	jal	ra,800056ea <acquire>
    release(lk);
    800013cc:	854a                	mv	a0,s2
    800013ce:	3b4040ef          	jal	ra,80005782 <release>

    // Go to sleep.
    p->chan = chan;
    800013d2:	0334b023          	sd	s3,32(s1)
    p->state = SLEEPING;
    800013d6:	4789                	li	a5,2
    800013d8:	cc9c                	sw	a5,24(s1)

    sched();
    800013da:	ef1ff0ef          	jal	ra,800012ca <sched>

    // Tidy up.
    p->chan = 0;
    800013de:	0204b023          	sd	zero,32(s1)

    // Reacquire original lock.
    release(&p->lock);
    800013e2:	8526                	mv	a0,s1
    800013e4:	39e040ef          	jal	ra,80005782 <release>
    acquire(lk);
    800013e8:	854a                	mv	a0,s2
    800013ea:	300040ef          	jal	ra,800056ea <acquire>
  }
    800013ee:	70a2                	ld	ra,40(sp)
    800013f0:	7402                	ld	s0,32(sp)
    800013f2:	64e2                	ld	s1,24(sp)
    800013f4:	6942                	ld	s2,16(sp)
    800013f6:	69a2                	ld	s3,8(sp)
    800013f8:	6145                	addi	sp,sp,48
    800013fa:	8082                	ret

00000000800013fc <wakeup>:

  // Wake up all processes sleeping on chan.
  // Must be called without any p->lock.
  void
  wakeup(void *chan)
  {
    800013fc:	7139                	addi	sp,sp,-64
    800013fe:	fc06                	sd	ra,56(sp)
    80001400:	f822                	sd	s0,48(sp)
    80001402:	f426                	sd	s1,40(sp)
    80001404:	f04a                	sd	s2,32(sp)
    80001406:	ec4e                	sd	s3,24(sp)
    80001408:	e852                	sd	s4,16(sp)
    8000140a:	e456                	sd	s5,8(sp)
    8000140c:	0080                	addi	s0,sp,64
    8000140e:	8a2a                	mv	s4,a0
    struct proc *p;

    for(p = proc; p < &proc[NPROC]; p++) {
    80001410:	00007497          	auipc	s1,0x7
    80001414:	95048493          	addi	s1,s1,-1712 # 80007d60 <proc>
      if(p != myproc()){
        acquire(&p->lock);
        if(p->state == SLEEPING && p->chan == chan) {
    80001418:	4989                	li	s3,2
          p->state = RUNNABLE;
    8000141a:	4a8d                	li	s5,3
    for(p = proc; p < &proc[NPROC]; p++) {
    8000141c:	0000c917          	auipc	s2,0xc
    80001420:	54490913          	addi	s2,s2,1348 # 8000d960 <tickslock>
    80001424:	a801                	j	80001434 <wakeup+0x38>
        }
        release(&p->lock);
    80001426:	8526                	mv	a0,s1
    80001428:	35a040ef          	jal	ra,80005782 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000142c:	17048493          	addi	s1,s1,368
    80001430:	03248263          	beq	s1,s2,80001454 <wakeup+0x58>
      if(p != myproc()){
    80001434:	91fff0ef          	jal	ra,80000d52 <myproc>
    80001438:	fea48ae3          	beq	s1,a0,8000142c <wakeup+0x30>
        acquire(&p->lock);
    8000143c:	8526                	mv	a0,s1
    8000143e:	2ac040ef          	jal	ra,800056ea <acquire>
        if(p->state == SLEEPING && p->chan == chan) {
    80001442:	4c9c                	lw	a5,24(s1)
    80001444:	ff3791e3          	bne	a5,s3,80001426 <wakeup+0x2a>
    80001448:	709c                	ld	a5,32(s1)
    8000144a:	fd479ee3          	bne	a5,s4,80001426 <wakeup+0x2a>
          p->state = RUNNABLE;
    8000144e:	0154ac23          	sw	s5,24(s1)
    80001452:	bfd1                	j	80001426 <wakeup+0x2a>
      }
    }
  }
    80001454:	70e2                	ld	ra,56(sp)
    80001456:	7442                	ld	s0,48(sp)
    80001458:	74a2                	ld	s1,40(sp)
    8000145a:	7902                	ld	s2,32(sp)
    8000145c:	69e2                	ld	s3,24(sp)
    8000145e:	6a42                	ld	s4,16(sp)
    80001460:	6aa2                	ld	s5,8(sp)
    80001462:	6121                	addi	sp,sp,64
    80001464:	8082                	ret

0000000080001466 <reparent>:
  {
    80001466:	7179                	addi	sp,sp,-48
    80001468:	f406                	sd	ra,40(sp)
    8000146a:	f022                	sd	s0,32(sp)
    8000146c:	ec26                	sd	s1,24(sp)
    8000146e:	e84a                	sd	s2,16(sp)
    80001470:	e44e                	sd	s3,8(sp)
    80001472:	e052                	sd	s4,0(sp)
    80001474:	1800                	addi	s0,sp,48
    80001476:	892a                	mv	s2,a0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001478:	00007497          	auipc	s1,0x7
    8000147c:	8e848493          	addi	s1,s1,-1816 # 80007d60 <proc>
        pp->parent = initproc;
    80001480:	00006a17          	auipc	s4,0x6
    80001484:	470a0a13          	addi	s4,s4,1136 # 800078f0 <initproc>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001488:	0000c997          	auipc	s3,0xc
    8000148c:	4d898993          	addi	s3,s3,1240 # 8000d960 <tickslock>
    80001490:	a029                	j	8000149a <reparent+0x34>
    80001492:	17048493          	addi	s1,s1,368
    80001496:	01348b63          	beq	s1,s3,800014ac <reparent+0x46>
      if(pp->parent == p){
    8000149a:	7c9c                	ld	a5,56(s1)
    8000149c:	ff279be3          	bne	a5,s2,80001492 <reparent+0x2c>
        pp->parent = initproc;
    800014a0:	000a3503          	ld	a0,0(s4)
    800014a4:	fc88                	sd	a0,56(s1)
        wakeup(initproc);
    800014a6:	f57ff0ef          	jal	ra,800013fc <wakeup>
    800014aa:	b7e5                	j	80001492 <reparent+0x2c>
  }
    800014ac:	70a2                	ld	ra,40(sp)
    800014ae:	7402                	ld	s0,32(sp)
    800014b0:	64e2                	ld	s1,24(sp)
    800014b2:	6942                	ld	s2,16(sp)
    800014b4:	69a2                	ld	s3,8(sp)
    800014b6:	6a02                	ld	s4,0(sp)
    800014b8:	6145                	addi	sp,sp,48
    800014ba:	8082                	ret

00000000800014bc <exit>:
  {
    800014bc:	7179                	addi	sp,sp,-48
    800014be:	f406                	sd	ra,40(sp)
    800014c0:	f022                	sd	s0,32(sp)
    800014c2:	ec26                	sd	s1,24(sp)
    800014c4:	e84a                	sd	s2,16(sp)
    800014c6:	e44e                	sd	s3,8(sp)
    800014c8:	e052                	sd	s4,0(sp)
    800014ca:	1800                	addi	s0,sp,48
    800014cc:	8a2a                	mv	s4,a0
    struct proc *p = myproc();
    800014ce:	885ff0ef          	jal	ra,80000d52 <myproc>
    800014d2:	89aa                	mv	s3,a0
    if(p == initproc)
    800014d4:	00006797          	auipc	a5,0x6
    800014d8:	41c7b783          	ld	a5,1052(a5) # 800078f0 <initproc>
    800014dc:	0d850493          	addi	s1,a0,216
    800014e0:	15850913          	addi	s2,a0,344
    800014e4:	00a79f63          	bne	a5,a0,80001502 <exit+0x46>
      panic("init exiting");
    800014e8:	00006517          	auipc	a0,0x6
    800014ec:	d3850513          	addi	a0,a0,-712 # 80007220 <etext+0x220>
    800014f0:	6e7030ef          	jal	ra,800053d6 <panic>
        fileclose(f);
    800014f4:	70f010ef          	jal	ra,80003402 <fileclose>
        p->ofile[fd] = 0;
    800014f8:	0004b023          	sd	zero,0(s1)
    for(int fd = 0; fd < NOFILE; fd++){
    800014fc:	04a1                	addi	s1,s1,8
    800014fe:	01248563          	beq	s1,s2,80001508 <exit+0x4c>
      if(p->ofile[fd]){
    80001502:	6088                	ld	a0,0(s1)
    80001504:	f965                	bnez	a0,800014f4 <exit+0x38>
    80001506:	bfdd                	j	800014fc <exit+0x40>
    begin_op();
    80001508:	2df010ef          	jal	ra,80002fe6 <begin_op>
    iput(p->cwd);
    8000150c:	1589b503          	ld	a0,344(s3)
    80001510:	3ca010ef          	jal	ra,800028da <iput>
    end_op();
    80001514:	343010ef          	jal	ra,80003056 <end_op>
    p->cwd = 0;
    80001518:	1409bc23          	sd	zero,344(s3)
    acquire(&wait_lock);
    8000151c:	00006497          	auipc	s1,0x6
    80001520:	42c48493          	addi	s1,s1,1068 # 80007948 <wait_lock>
    80001524:	8526                	mv	a0,s1
    80001526:	1c4040ef          	jal	ra,800056ea <acquire>
    reparent(p);
    8000152a:	854e                	mv	a0,s3
    8000152c:	f3bff0ef          	jal	ra,80001466 <reparent>
    wakeup(p->parent);
    80001530:	0389b503          	ld	a0,56(s3)
    80001534:	ec9ff0ef          	jal	ra,800013fc <wakeup>
    acquire(&p->lock);
    80001538:	854e                	mv	a0,s3
    8000153a:	1b0040ef          	jal	ra,800056ea <acquire>
    p->xstate = status;
    8000153e:	0349a623          	sw	s4,44(s3)
    p->state = ZOMBIE;
    80001542:	4795                	li	a5,5
    80001544:	00f9ac23          	sw	a5,24(s3)
    release(&wait_lock);
    80001548:	8526                	mv	a0,s1
    8000154a:	238040ef          	jal	ra,80005782 <release>
    sched();
    8000154e:	d7dff0ef          	jal	ra,800012ca <sched>
    panic("zombie exit");
    80001552:	00006517          	auipc	a0,0x6
    80001556:	cde50513          	addi	a0,a0,-802 # 80007230 <etext+0x230>
    8000155a:	67d030ef          	jal	ra,800053d6 <panic>

000000008000155e <kill>:
  // Kill the process with the given pid.
  // The victim won't exit until it tries to return
  // to user space (see usertrap() in trap.c).
  int
  kill(int pid)
  {
    8000155e:	7179                	addi	sp,sp,-48
    80001560:	f406                	sd	ra,40(sp)
    80001562:	f022                	sd	s0,32(sp)
    80001564:	ec26                	sd	s1,24(sp)
    80001566:	e84a                	sd	s2,16(sp)
    80001568:	e44e                	sd	s3,8(sp)
    8000156a:	1800                	addi	s0,sp,48
    8000156c:	892a                	mv	s2,a0
    struct proc *p;

    for(p = proc; p < &proc[NPROC]; p++){
    8000156e:	00006497          	auipc	s1,0x6
    80001572:	7f248493          	addi	s1,s1,2034 # 80007d60 <proc>
    80001576:	0000c997          	auipc	s3,0xc
    8000157a:	3ea98993          	addi	s3,s3,1002 # 8000d960 <tickslock>
      acquire(&p->lock);
    8000157e:	8526                	mv	a0,s1
    80001580:	16a040ef          	jal	ra,800056ea <acquire>
      if(p->pid == pid){
    80001584:	589c                	lw	a5,48(s1)
    80001586:	01278b63          	beq	a5,s2,8000159c <kill+0x3e>
          p->state = RUNNABLE;
        }
        release(&p->lock);
        return 0;
      }
      release(&p->lock);
    8000158a:	8526                	mv	a0,s1
    8000158c:	1f6040ef          	jal	ra,80005782 <release>
    for(p = proc; p < &proc[NPROC]; p++){
    80001590:	17048493          	addi	s1,s1,368
    80001594:	ff3495e3          	bne	s1,s3,8000157e <kill+0x20>
    }
    return -1;
    80001598:	557d                	li	a0,-1
    8000159a:	a819                	j	800015b0 <kill+0x52>
        p->killed = 1;
    8000159c:	4785                	li	a5,1
    8000159e:	d49c                	sw	a5,40(s1)
        if(p->state == SLEEPING){
    800015a0:	4c98                	lw	a4,24(s1)
    800015a2:	4789                	li	a5,2
    800015a4:	00f70d63          	beq	a4,a5,800015be <kill+0x60>
        release(&p->lock);
    800015a8:	8526                	mv	a0,s1
    800015aa:	1d8040ef          	jal	ra,80005782 <release>
        return 0;
    800015ae:	4501                	li	a0,0
  }
    800015b0:	70a2                	ld	ra,40(sp)
    800015b2:	7402                	ld	s0,32(sp)
    800015b4:	64e2                	ld	s1,24(sp)
    800015b6:	6942                	ld	s2,16(sp)
    800015b8:	69a2                	ld	s3,8(sp)
    800015ba:	6145                	addi	sp,sp,48
    800015bc:	8082                	ret
          p->state = RUNNABLE;
    800015be:	478d                	li	a5,3
    800015c0:	cc9c                	sw	a5,24(s1)
    800015c2:	b7dd                	j	800015a8 <kill+0x4a>

00000000800015c4 <setkilled>:

  void
  setkilled(struct proc *p)
  {
    800015c4:	1101                	addi	sp,sp,-32
    800015c6:	ec06                	sd	ra,24(sp)
    800015c8:	e822                	sd	s0,16(sp)
    800015ca:	e426                	sd	s1,8(sp)
    800015cc:	1000                	addi	s0,sp,32
    800015ce:	84aa                	mv	s1,a0
    acquire(&p->lock);
    800015d0:	11a040ef          	jal	ra,800056ea <acquire>
    p->killed = 1;
    800015d4:	4785                	li	a5,1
    800015d6:	d49c                	sw	a5,40(s1)
    release(&p->lock);
    800015d8:	8526                	mv	a0,s1
    800015da:	1a8040ef          	jal	ra,80005782 <release>
  }
    800015de:	60e2                	ld	ra,24(sp)
    800015e0:	6442                	ld	s0,16(sp)
    800015e2:	64a2                	ld	s1,8(sp)
    800015e4:	6105                	addi	sp,sp,32
    800015e6:	8082                	ret

00000000800015e8 <killed>:

  int
  killed(struct proc *p)
  {
    800015e8:	1101                	addi	sp,sp,-32
    800015ea:	ec06                	sd	ra,24(sp)
    800015ec:	e822                	sd	s0,16(sp)
    800015ee:	e426                	sd	s1,8(sp)
    800015f0:	e04a                	sd	s2,0(sp)
    800015f2:	1000                	addi	s0,sp,32
    800015f4:	84aa                	mv	s1,a0
    int k;
    
    acquire(&p->lock);
    800015f6:	0f4040ef          	jal	ra,800056ea <acquire>
    k = p->killed;
    800015fa:	0284a903          	lw	s2,40(s1)
    release(&p->lock);
    800015fe:	8526                	mv	a0,s1
    80001600:	182040ef          	jal	ra,80005782 <release>
    return k;
  }
    80001604:	854a                	mv	a0,s2
    80001606:	60e2                	ld	ra,24(sp)
    80001608:	6442                	ld	s0,16(sp)
    8000160a:	64a2                	ld	s1,8(sp)
    8000160c:	6902                	ld	s2,0(sp)
    8000160e:	6105                	addi	sp,sp,32
    80001610:	8082                	ret

0000000080001612 <wait>:
  {
    80001612:	715d                	addi	sp,sp,-80
    80001614:	e486                	sd	ra,72(sp)
    80001616:	e0a2                	sd	s0,64(sp)
    80001618:	fc26                	sd	s1,56(sp)
    8000161a:	f84a                	sd	s2,48(sp)
    8000161c:	f44e                	sd	s3,40(sp)
    8000161e:	f052                	sd	s4,32(sp)
    80001620:	ec56                	sd	s5,24(sp)
    80001622:	e85a                	sd	s6,16(sp)
    80001624:	e45e                	sd	s7,8(sp)
    80001626:	e062                	sd	s8,0(sp)
    80001628:	0880                	addi	s0,sp,80
    8000162a:	8b2a                	mv	s6,a0
    struct proc *p = myproc();
    8000162c:	f26ff0ef          	jal	ra,80000d52 <myproc>
    80001630:	892a                	mv	s2,a0
    acquire(&wait_lock);
    80001632:	00006517          	auipc	a0,0x6
    80001636:	31650513          	addi	a0,a0,790 # 80007948 <wait_lock>
    8000163a:	0b0040ef          	jal	ra,800056ea <acquire>
      havekids = 0;
    8000163e:	4b81                	li	s7,0
          if(pp->state == ZOMBIE){
    80001640:	4a15                	li	s4,5
          havekids = 1;
    80001642:	4a85                	li	s5,1
      for(pp = proc; pp < &proc[NPROC]; pp++){
    80001644:	0000c997          	auipc	s3,0xc
    80001648:	31c98993          	addi	s3,s3,796 # 8000d960 <tickslock>
      sleep(p, &wait_lock);  //DOC: wait-sleep
    8000164c:	00006c17          	auipc	s8,0x6
    80001650:	2fcc0c13          	addi	s8,s8,764 # 80007948 <wait_lock>
      havekids = 0;
    80001654:	875e                	mv	a4,s7
      for(pp = proc; pp < &proc[NPROC]; pp++){
    80001656:	00006497          	auipc	s1,0x6
    8000165a:	70a48493          	addi	s1,s1,1802 # 80007d60 <proc>
    8000165e:	a899                	j	800016b4 <wait+0xa2>
            pid = pp->pid;
    80001660:	0304a983          	lw	s3,48(s1)
            if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001664:	000b0c63          	beqz	s6,8000167c <wait+0x6a>
    80001668:	4691                	li	a3,4
    8000166a:	02c48613          	addi	a2,s1,44
    8000166e:	85da                	mv	a1,s6
    80001670:	0d093503          	ld	a0,208(s2)
    80001674:	b92ff0ef          	jal	ra,80000a06 <copyout>
    80001678:	00054f63          	bltz	a0,80001696 <wait+0x84>
            freeproc(pp);
    8000167c:	8526                	mv	a0,s1
    8000167e:	8abff0ef          	jal	ra,80000f28 <freeproc>
            release(&pp->lock);
    80001682:	8526                	mv	a0,s1
    80001684:	0fe040ef          	jal	ra,80005782 <release>
            release(&wait_lock);
    80001688:	00006517          	auipc	a0,0x6
    8000168c:	2c050513          	addi	a0,a0,704 # 80007948 <wait_lock>
    80001690:	0f2040ef          	jal	ra,80005782 <release>
            return pid;
    80001694:	a891                	j	800016e8 <wait+0xd6>
              release(&pp->lock);
    80001696:	8526                	mv	a0,s1
    80001698:	0ea040ef          	jal	ra,80005782 <release>
              release(&wait_lock);
    8000169c:	00006517          	auipc	a0,0x6
    800016a0:	2ac50513          	addi	a0,a0,684 # 80007948 <wait_lock>
    800016a4:	0de040ef          	jal	ra,80005782 <release>
              return -1;
    800016a8:	59fd                	li	s3,-1
    800016aa:	a83d                	j	800016e8 <wait+0xd6>
      for(pp = proc; pp < &proc[NPROC]; pp++){
    800016ac:	17048493          	addi	s1,s1,368
    800016b0:	03348063          	beq	s1,s3,800016d0 <wait+0xbe>
        if(pp->parent == p){
    800016b4:	7c9c                	ld	a5,56(s1)
    800016b6:	ff279be3          	bne	a5,s2,800016ac <wait+0x9a>
          acquire(&pp->lock);
    800016ba:	8526                	mv	a0,s1
    800016bc:	02e040ef          	jal	ra,800056ea <acquire>
          if(pp->state == ZOMBIE){
    800016c0:	4c9c                	lw	a5,24(s1)
    800016c2:	f9478fe3          	beq	a5,s4,80001660 <wait+0x4e>
          release(&pp->lock);
    800016c6:	8526                	mv	a0,s1
    800016c8:	0ba040ef          	jal	ra,80005782 <release>
          havekids = 1;
    800016cc:	8756                	mv	a4,s5
    800016ce:	bff9                	j	800016ac <wait+0x9a>
      if(!havekids || killed(p)){
    800016d0:	c709                	beqz	a4,800016da <wait+0xc8>
    800016d2:	854a                	mv	a0,s2
    800016d4:	f15ff0ef          	jal	ra,800015e8 <killed>
    800016d8:	c50d                	beqz	a0,80001702 <wait+0xf0>
        release(&wait_lock);
    800016da:	00006517          	auipc	a0,0x6
    800016de:	26e50513          	addi	a0,a0,622 # 80007948 <wait_lock>
    800016e2:	0a0040ef          	jal	ra,80005782 <release>
        return -1;
    800016e6:	59fd                	li	s3,-1
  }
    800016e8:	854e                	mv	a0,s3
    800016ea:	60a6                	ld	ra,72(sp)
    800016ec:	6406                	ld	s0,64(sp)
    800016ee:	74e2                	ld	s1,56(sp)
    800016f0:	7942                	ld	s2,48(sp)
    800016f2:	79a2                	ld	s3,40(sp)
    800016f4:	7a02                	ld	s4,32(sp)
    800016f6:	6ae2                	ld	s5,24(sp)
    800016f8:	6b42                	ld	s6,16(sp)
    800016fa:	6ba2                	ld	s7,8(sp)
    800016fc:	6c02                	ld	s8,0(sp)
    800016fe:	6161                	addi	sp,sp,80
    80001700:	8082                	ret
      sleep(p, &wait_lock);  //DOC: wait-sleep
    80001702:	85e2                	mv	a1,s8
    80001704:	854a                	mv	a0,s2
    80001706:	cabff0ef          	jal	ra,800013b0 <sleep>
      havekids = 0;
    8000170a:	b7a9                	j	80001654 <wait+0x42>

000000008000170c <either_copyout>:
  // Copy to either a user address, or kernel address,
  // depending on usr_dst.
  // Returns 0 on success, -1 on error.
  int
  either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
  {
    8000170c:	7179                	addi	sp,sp,-48
    8000170e:	f406                	sd	ra,40(sp)
    80001710:	f022                	sd	s0,32(sp)
    80001712:	ec26                	sd	s1,24(sp)
    80001714:	e84a                	sd	s2,16(sp)
    80001716:	e44e                	sd	s3,8(sp)
    80001718:	e052                	sd	s4,0(sp)
    8000171a:	1800                	addi	s0,sp,48
    8000171c:	84aa                	mv	s1,a0
    8000171e:	892e                	mv	s2,a1
    80001720:	89b2                	mv	s3,a2
    80001722:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    80001724:	e2eff0ef          	jal	ra,80000d52 <myproc>
    if(user_dst){
    80001728:	cc99                	beqz	s1,80001746 <either_copyout+0x3a>
      return copyout(p->pagetable, dst, src, len);
    8000172a:	86d2                	mv	a3,s4
    8000172c:	864e                	mv	a2,s3
    8000172e:	85ca                	mv	a1,s2
    80001730:	6968                	ld	a0,208(a0)
    80001732:	ad4ff0ef          	jal	ra,80000a06 <copyout>
    } else {
      memmove((char *)dst, src, len);
      return 0;
    }
  }
    80001736:	70a2                	ld	ra,40(sp)
    80001738:	7402                	ld	s0,32(sp)
    8000173a:	64e2                	ld	s1,24(sp)
    8000173c:	6942                	ld	s2,16(sp)
    8000173e:	69a2                	ld	s3,8(sp)
    80001740:	6a02                	ld	s4,0(sp)
    80001742:	6145                	addi	sp,sp,48
    80001744:	8082                	ret
      memmove((char *)dst, src, len);
    80001746:	000a061b          	sext.w	a2,s4
    8000174a:	85ce                	mv	a1,s3
    8000174c:	854a                	mv	a0,s2
    8000174e:	a5bfe0ef          	jal	ra,800001a8 <memmove>
      return 0;
    80001752:	8526                	mv	a0,s1
    80001754:	b7cd                	j	80001736 <either_copyout+0x2a>

0000000080001756 <either_copyin>:
  // Copy from either a user address, or kernel address,
  // depending on usr_src.
  // Returns 0 on success, -1 on error.
  int
  either_copyin(void *dst, int user_src, uint64 src, uint64 len)
  {
    80001756:	7179                	addi	sp,sp,-48
    80001758:	f406                	sd	ra,40(sp)
    8000175a:	f022                	sd	s0,32(sp)
    8000175c:	ec26                	sd	s1,24(sp)
    8000175e:	e84a                	sd	s2,16(sp)
    80001760:	e44e                	sd	s3,8(sp)
    80001762:	e052                	sd	s4,0(sp)
    80001764:	1800                	addi	s0,sp,48
    80001766:	892a                	mv	s2,a0
    80001768:	84ae                	mv	s1,a1
    8000176a:	89b2                	mv	s3,a2
    8000176c:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    8000176e:	de4ff0ef          	jal	ra,80000d52 <myproc>
    if(user_src){
    80001772:	cc99                	beqz	s1,80001790 <either_copyin+0x3a>
      return copyin(p->pagetable, dst, src, len);
    80001774:	86d2                	mv	a3,s4
    80001776:	864e                	mv	a2,s3
    80001778:	85ca                	mv	a1,s2
    8000177a:	6968                	ld	a0,208(a0)
    8000177c:	b42ff0ef          	jal	ra,80000abe <copyin>
    } else {
      memmove(dst, (char*)src, len);
      return 0;
    }
  }
    80001780:	70a2                	ld	ra,40(sp)
    80001782:	7402                	ld	s0,32(sp)
    80001784:	64e2                	ld	s1,24(sp)
    80001786:	6942                	ld	s2,16(sp)
    80001788:	69a2                	ld	s3,8(sp)
    8000178a:	6a02                	ld	s4,0(sp)
    8000178c:	6145                	addi	sp,sp,48
    8000178e:	8082                	ret
      memmove(dst, (char*)src, len);
    80001790:	000a061b          	sext.w	a2,s4
    80001794:	85ce                	mv	a1,s3
    80001796:	854a                	mv	a0,s2
    80001798:	a11fe0ef          	jal	ra,800001a8 <memmove>
      return 0;
    8000179c:	8526                	mv	a0,s1
    8000179e:	b7cd                	j	80001780 <either_copyin+0x2a>

00000000800017a0 <procdump>:
  // Print a process listing to console.  For debugging.
  // Runs when user types ^P on console.
  // No lock to avoid wedging a stuck machine further.
  void
  procdump(void)
  {
    800017a0:	715d                	addi	sp,sp,-80
    800017a2:	e486                	sd	ra,72(sp)
    800017a4:	e0a2                	sd	s0,64(sp)
    800017a6:	fc26                	sd	s1,56(sp)
    800017a8:	f84a                	sd	s2,48(sp)
    800017aa:	f44e                	sd	s3,40(sp)
    800017ac:	f052                	sd	s4,32(sp)
    800017ae:	ec56                	sd	s5,24(sp)
    800017b0:	e85a                	sd	s6,16(sp)
    800017b2:	e45e                	sd	s7,8(sp)
    800017b4:	0880                	addi	s0,sp,80
    [ZOMBIE]    "zombie"
    };
    struct proc *p;
    char *state;

    printf("\n");
    800017b6:	00006517          	auipc	a0,0x6
    800017ba:	89250513          	addi	a0,a0,-1902 # 80007048 <etext+0x48>
    800017be:	165030ef          	jal	ra,80005122 <printf>
    for(p = proc; p < &proc[NPROC]; p++){
    800017c2:	00006497          	auipc	s1,0x6
    800017c6:	6fe48493          	addi	s1,s1,1790 # 80007ec0 <proc+0x160>
    800017ca:	0000c917          	auipc	s2,0xc
    800017ce:	2f690913          	addi	s2,s2,758 # 8000dac0 <bcache+0x148>
      if(p->state == UNUSED)
        continue;
      if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017d2:	4b15                	li	s6,5
        state = states[p->state];
      else
        state = "???";
    800017d4:	00006997          	auipc	s3,0x6
    800017d8:	a6c98993          	addi	s3,s3,-1428 # 80007240 <etext+0x240>
      printf("%d %s %s", p->pid, state, p->name);
    800017dc:	00006a97          	auipc	s5,0x6
    800017e0:	a6ca8a93          	addi	s5,s5,-1428 # 80007248 <etext+0x248>
      printf("\n");
    800017e4:	00006a17          	auipc	s4,0x6
    800017e8:	864a0a13          	addi	s4,s4,-1948 # 80007048 <etext+0x48>
      if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017ec:	00006b97          	auipc	s7,0x6
    800017f0:	a9cb8b93          	addi	s7,s7,-1380 # 80007288 <states.0>
    800017f4:	a829                	j	8000180e <procdump+0x6e>
      printf("%d %s %s", p->pid, state, p->name);
    800017f6:	ed06a583          	lw	a1,-304(a3)
    800017fa:	8556                	mv	a0,s5
    800017fc:	127030ef          	jal	ra,80005122 <printf>
      printf("\n");
    80001800:	8552                	mv	a0,s4
    80001802:	121030ef          	jal	ra,80005122 <printf>
    for(p = proc; p < &proc[NPROC]; p++){
    80001806:	17048493          	addi	s1,s1,368
    8000180a:	03248163          	beq	s1,s2,8000182c <procdump+0x8c>
      if(p->state == UNUSED)
    8000180e:	86a6                	mv	a3,s1
    80001810:	eb84a783          	lw	a5,-328(s1)
    80001814:	dbed                	beqz	a5,80001806 <procdump+0x66>
        state = "???";
    80001816:	864e                	mv	a2,s3
      if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001818:	fcfb6fe3          	bltu	s6,a5,800017f6 <procdump+0x56>
    8000181c:	1782                	slli	a5,a5,0x20
    8000181e:	9381                	srli	a5,a5,0x20
    80001820:	078e                	slli	a5,a5,0x3
    80001822:	97de                	add	a5,a5,s7
    80001824:	6390                	ld	a2,0(a5)
    80001826:	fa61                	bnez	a2,800017f6 <procdump+0x56>
        state = "???";
    80001828:	864e                	mv	a2,s3
    8000182a:	b7f1                	j	800017f6 <procdump+0x56>
    }
  }
    8000182c:	60a6                	ld	ra,72(sp)
    8000182e:	6406                	ld	s0,64(sp)
    80001830:	74e2                	ld	s1,56(sp)
    80001832:	7942                	ld	s2,48(sp)
    80001834:	79a2                	ld	s3,40(sp)
    80001836:	7a02                	ld	s4,32(sp)
    80001838:	6ae2                	ld	s5,24(sp)
    8000183a:	6b42                	ld	s6,16(sp)
    8000183c:	6ba2                	ld	s7,8(sp)
    8000183e:	6161                	addi	sp,sp,80
    80001840:	8082                	ret

0000000080001842 <swtch>:
    80001842:	00153023          	sd	ra,0(a0)
    80001846:	00253423          	sd	sp,8(a0)
    8000184a:	e900                	sd	s0,16(a0)
    8000184c:	ed04                	sd	s1,24(a0)
    8000184e:	03253023          	sd	s2,32(a0)
    80001852:	03353423          	sd	s3,40(a0)
    80001856:	03453823          	sd	s4,48(a0)
    8000185a:	03553c23          	sd	s5,56(a0)
    8000185e:	05653023          	sd	s6,64(a0)
    80001862:	05753423          	sd	s7,72(a0)
    80001866:	05853823          	sd	s8,80(a0)
    8000186a:	05953c23          	sd	s9,88(a0)
    8000186e:	07a53023          	sd	s10,96(a0)
    80001872:	07b53423          	sd	s11,104(a0)
    80001876:	0005b083          	ld	ra,0(a1)
    8000187a:	0085b103          	ld	sp,8(a1)
    8000187e:	6980                	ld	s0,16(a1)
    80001880:	6d84                	ld	s1,24(a1)
    80001882:	0205b903          	ld	s2,32(a1)
    80001886:	0285b983          	ld	s3,40(a1)
    8000188a:	0305ba03          	ld	s4,48(a1)
    8000188e:	0385ba83          	ld	s5,56(a1)
    80001892:	0405bb03          	ld	s6,64(a1)
    80001896:	0485bb83          	ld	s7,72(a1)
    8000189a:	0505bc03          	ld	s8,80(a1)
    8000189e:	0585bc83          	ld	s9,88(a1)
    800018a2:	0605bd03          	ld	s10,96(a1)
    800018a6:	0685bd83          	ld	s11,104(a1)
    800018aa:	8082                	ret

00000000800018ac <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800018ac:	1141                	addi	sp,sp,-16
    800018ae:	e406                	sd	ra,8(sp)
    800018b0:	e022                	sd	s0,0(sp)
    800018b2:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800018b4:	00006597          	auipc	a1,0x6
    800018b8:	a0458593          	addi	a1,a1,-1532 # 800072b8 <states.0+0x30>
    800018bc:	0000c517          	auipc	a0,0xc
    800018c0:	0a450513          	addi	a0,a0,164 # 8000d960 <tickslock>
    800018c4:	5a7030ef          	jal	ra,8000566a <initlock>
}
    800018c8:	60a2                	ld	ra,8(sp)
    800018ca:	6402                	ld	s0,0(sp)
    800018cc:	0141                	addi	sp,sp,16
    800018ce:	8082                	ret

00000000800018d0 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800018d0:	1141                	addi	sp,sp,-16
    800018d2:	e422                	sd	s0,8(sp)
    800018d4:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800018d6:	00003797          	auipc	a5,0x3
    800018da:	dea78793          	addi	a5,a5,-534 # 800046c0 <kernelvec>
    800018de:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800018e2:	6422                	ld	s0,8(sp)
    800018e4:	0141                	addi	sp,sp,16
    800018e6:	8082                	ret

00000000800018e8 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    800018e8:	1141                	addi	sp,sp,-16
    800018ea:	e406                	sd	ra,8(sp)
    800018ec:	e022                	sd	s0,0(sp)
    800018ee:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800018f0:	c62ff0ef          	jal	ra,80000d52 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800018f4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800018f8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800018fa:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    800018fe:	00004617          	auipc	a2,0x4
    80001902:	70260613          	addi	a2,a2,1794 # 80006000 <_trampoline>
    80001906:	00004697          	auipc	a3,0x4
    8000190a:	6fa68693          	addi	a3,a3,1786 # 80006000 <_trampoline>
    8000190e:	8e91                	sub	a3,a3,a2
    80001910:	040007b7          	lui	a5,0x4000
    80001914:	17fd                	addi	a5,a5,-1
    80001916:	07b2                	slli	a5,a5,0xc
    80001918:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000191a:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    8000191e:	6138                	ld	a4,64(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001920:	180026f3          	csrr	a3,satp
    80001924:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001926:	6138                	ld	a4,64(a0)
    80001928:	6174                	ld	a3,192(a0)
    8000192a:	6585                	lui	a1,0x1
    8000192c:	96ae                	add	a3,a3,a1
    8000192e:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001930:	6138                	ld	a4,64(a0)
    80001932:	00000697          	auipc	a3,0x0
    80001936:	10c68693          	addi	a3,a3,268 # 80001a3e <usertrap>
    8000193a:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    8000193c:	6138                	ld	a4,64(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    8000193e:	8692                	mv	a3,tp
    80001940:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001942:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001946:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    8000194a:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000194e:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001952:	6138                	ld	a4,64(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001954:	6f18                	ld	a4,24(a4)
    80001956:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    8000195a:	6968                	ld	a0,208(a0)
    8000195c:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    8000195e:	00004717          	auipc	a4,0x4
    80001962:	73e70713          	addi	a4,a4,1854 # 8000609c <userret>
    80001966:	8f11                	sub	a4,a4,a2
    80001968:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    8000196a:	577d                	li	a4,-1
    8000196c:	177e                	slli	a4,a4,0x3f
    8000196e:	8d59                	or	a0,a0,a4
    80001970:	9782                	jalr	a5
}
    80001972:	60a2                	ld	ra,8(sp)
    80001974:	6402                	ld	s0,0(sp)
    80001976:	0141                	addi	sp,sp,16
    80001978:	8082                	ret

000000008000197a <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    8000197a:	1101                	addi	sp,sp,-32
    8000197c:	ec06                	sd	ra,24(sp)
    8000197e:	e822                	sd	s0,16(sp)
    80001980:	e426                	sd	s1,8(sp)
    80001982:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    80001984:	ba2ff0ef          	jal	ra,80000d26 <cpuid>
    80001988:	cd19                	beqz	a0,800019a6 <clockintr+0x2c>
  asm volatile("csrr %0, time" : "=r" (x) );
    8000198a:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    8000198e:	000f4737          	lui	a4,0xf4
    80001992:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80001996:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80001998:	14d79073          	csrw	0x14d,a5
}
    8000199c:	60e2                	ld	ra,24(sp)
    8000199e:	6442                	ld	s0,16(sp)
    800019a0:	64a2                	ld	s1,8(sp)
    800019a2:	6105                	addi	sp,sp,32
    800019a4:	8082                	ret
    acquire(&tickslock);
    800019a6:	0000c497          	auipc	s1,0xc
    800019aa:	fba48493          	addi	s1,s1,-70 # 8000d960 <tickslock>
    800019ae:	8526                	mv	a0,s1
    800019b0:	53b030ef          	jal	ra,800056ea <acquire>
    ticks++;
    800019b4:	00006517          	auipc	a0,0x6
    800019b8:	f4450513          	addi	a0,a0,-188 # 800078f8 <ticks>
    800019bc:	411c                	lw	a5,0(a0)
    800019be:	2785                	addiw	a5,a5,1
    800019c0:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    800019c2:	a3bff0ef          	jal	ra,800013fc <wakeup>
    release(&tickslock);
    800019c6:	8526                	mv	a0,s1
    800019c8:	5bb030ef          	jal	ra,80005782 <release>
    800019cc:	bf7d                	j	8000198a <clockintr+0x10>

00000000800019ce <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800019ce:	1101                	addi	sp,sp,-32
    800019d0:	ec06                	sd	ra,24(sp)
    800019d2:	e822                	sd	s0,16(sp)
    800019d4:	e426                	sd	s1,8(sp)
    800019d6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800019d8:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    800019dc:	57fd                	li	a5,-1
    800019de:	17fe                	slli	a5,a5,0x3f
    800019e0:	07a5                	addi	a5,a5,9
    800019e2:	00f70d63          	beq	a4,a5,800019fc <devintr+0x2e>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    800019e6:	57fd                	li	a5,-1
    800019e8:	17fe                	slli	a5,a5,0x3f
    800019ea:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    800019ec:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    800019ee:	04f70463          	beq	a4,a5,80001a36 <devintr+0x68>
  }
}
    800019f2:	60e2                	ld	ra,24(sp)
    800019f4:	6442                	ld	s0,16(sp)
    800019f6:	64a2                	ld	s1,8(sp)
    800019f8:	6105                	addi	sp,sp,32
    800019fa:	8082                	ret
    int irq = plic_claim();
    800019fc:	56d020ef          	jal	ra,80004768 <plic_claim>
    80001a00:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001a02:	47a9                	li	a5,10
    80001a04:	02f50363          	beq	a0,a5,80001a2a <devintr+0x5c>
    } else if(irq == VIRTIO0_IRQ){
    80001a08:	4785                	li	a5,1
    80001a0a:	02f50363          	beq	a0,a5,80001a30 <devintr+0x62>
    return 1;
    80001a0e:	4505                	li	a0,1
    } else if(irq){
    80001a10:	d0ed                	beqz	s1,800019f2 <devintr+0x24>
      printf("unexpected interrupt irq=%d\n", irq);
    80001a12:	85a6                	mv	a1,s1
    80001a14:	00006517          	auipc	a0,0x6
    80001a18:	8ac50513          	addi	a0,a0,-1876 # 800072c0 <states.0+0x38>
    80001a1c:	706030ef          	jal	ra,80005122 <printf>
      plic_complete(irq);
    80001a20:	8526                	mv	a0,s1
    80001a22:	567020ef          	jal	ra,80004788 <plic_complete>
    return 1;
    80001a26:	4505                	li	a0,1
    80001a28:	b7e9                	j	800019f2 <devintr+0x24>
      uartintr();
    80001a2a:	405030ef          	jal	ra,8000562e <uartintr>
    80001a2e:	bfcd                	j	80001a20 <devintr+0x52>
      virtio_disk_intr();
    80001a30:	1c8030ef          	jal	ra,80004bf8 <virtio_disk_intr>
    80001a34:	b7f5                	j	80001a20 <devintr+0x52>
    clockintr();
    80001a36:	f45ff0ef          	jal	ra,8000197a <clockintr>
    return 2;
    80001a3a:	4509                	li	a0,2
    80001a3c:	bf5d                	j	800019f2 <devintr+0x24>

0000000080001a3e <usertrap>:
{
    80001a3e:	1101                	addi	sp,sp,-32
    80001a40:	ec06                	sd	ra,24(sp)
    80001a42:	e822                	sd	s0,16(sp)
    80001a44:	e426                	sd	s1,8(sp)
    80001a46:	e04a                	sd	s2,0(sp)
    80001a48:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a4a:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001a4e:	1007f793          	andi	a5,a5,256
    80001a52:	ef85                	bnez	a5,80001a8a <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001a54:	00003797          	auipc	a5,0x3
    80001a58:	c6c78793          	addi	a5,a5,-916 # 800046c0 <kernelvec>
    80001a5c:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001a60:	af2ff0ef          	jal	ra,80000d52 <myproc>
    80001a64:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001a66:	613c                	ld	a5,64(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a68:	14102773          	csrr	a4,sepc
    80001a6c:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001a6e:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001a72:	47a1                	li	a5,8
    80001a74:	02f70163          	beq	a4,a5,80001a96 <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    80001a78:	f57ff0ef          	jal	ra,800019ce <devintr>
    80001a7c:	892a                	mv	s2,a0
    80001a7e:	c135                	beqz	a0,80001ae2 <usertrap+0xa4>
  if(killed(p))
    80001a80:	8526                	mv	a0,s1
    80001a82:	b67ff0ef          	jal	ra,800015e8 <killed>
    80001a86:	cd1d                	beqz	a0,80001ac4 <usertrap+0x86>
    80001a88:	a81d                	j	80001abe <usertrap+0x80>
    panic("usertrap: not from user mode");
    80001a8a:	00006517          	auipc	a0,0x6
    80001a8e:	85650513          	addi	a0,a0,-1962 # 800072e0 <states.0+0x58>
    80001a92:	145030ef          	jal	ra,800053d6 <panic>
    if(killed(p))
    80001a96:	b53ff0ef          	jal	ra,800015e8 <killed>
    80001a9a:	e121                	bnez	a0,80001ada <usertrap+0x9c>
    p->trapframe->epc += 4;
    80001a9c:	60b8                	ld	a4,64(s1)
    80001a9e:	6f1c                	ld	a5,24(a4)
    80001aa0:	0791                	addi	a5,a5,4
    80001aa2:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001aa4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001aa8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001aac:	10079073          	csrw	sstatus,a5
    syscall();
    80001ab0:	248000ef          	jal	ra,80001cf8 <syscall>
  if(killed(p))
    80001ab4:	8526                	mv	a0,s1
    80001ab6:	b33ff0ef          	jal	ra,800015e8 <killed>
    80001aba:	c901                	beqz	a0,80001aca <usertrap+0x8c>
    80001abc:	4901                	li	s2,0
    exit(-1);
    80001abe:	557d                	li	a0,-1
    80001ac0:	9fdff0ef          	jal	ra,800014bc <exit>
  if(which_dev == 2)
    80001ac4:	4789                	li	a5,2
    80001ac6:	04f90563          	beq	s2,a5,80001b10 <usertrap+0xd2>
  usertrapret();
    80001aca:	e1fff0ef          	jal	ra,800018e8 <usertrapret>
}
    80001ace:	60e2                	ld	ra,24(sp)
    80001ad0:	6442                	ld	s0,16(sp)
    80001ad2:	64a2                	ld	s1,8(sp)
    80001ad4:	6902                	ld	s2,0(sp)
    80001ad6:	6105                	addi	sp,sp,32
    80001ad8:	8082                	ret
      exit(-1);
    80001ada:	557d                	li	a0,-1
    80001adc:	9e1ff0ef          	jal	ra,800014bc <exit>
    80001ae0:	bf75                	j	80001a9c <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ae2:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001ae6:	5890                	lw	a2,48(s1)
    80001ae8:	00006517          	auipc	a0,0x6
    80001aec:	81850513          	addi	a0,a0,-2024 # 80007300 <states.0+0x78>
    80001af0:	632030ef          	jal	ra,80005122 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001af4:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001af8:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001afc:	00006517          	auipc	a0,0x6
    80001b00:	83450513          	addi	a0,a0,-1996 # 80007330 <states.0+0xa8>
    80001b04:	61e030ef          	jal	ra,80005122 <printf>
    setkilled(p);
    80001b08:	8526                	mv	a0,s1
    80001b0a:	abbff0ef          	jal	ra,800015c4 <setkilled>
    80001b0e:	b75d                	j	80001ab4 <usertrap+0x76>
    yield();
    80001b10:	875ff0ef          	jal	ra,80001384 <yield>
    80001b14:	bf5d                	j	80001aca <usertrap+0x8c>

0000000080001b16 <kerneltrap>:
{
    80001b16:	7179                	addi	sp,sp,-48
    80001b18:	f406                	sd	ra,40(sp)
    80001b1a:	f022                	sd	s0,32(sp)
    80001b1c:	ec26                	sd	s1,24(sp)
    80001b1e:	e84a                	sd	s2,16(sp)
    80001b20:	e44e                	sd	s3,8(sp)
    80001b22:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b24:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b28:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b2c:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001b30:	1004f793          	andi	a5,s1,256
    80001b34:	c795                	beqz	a5,80001b60 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b36:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001b3a:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001b3c:	eb85                	bnez	a5,80001b6c <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80001b3e:	e91ff0ef          	jal	ra,800019ce <devintr>
    80001b42:	c91d                	beqz	a0,80001b78 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80001b44:	4789                	li	a5,2
    80001b46:	04f50a63          	beq	a0,a5,80001b9a <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b4a:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b4e:	10049073          	csrw	sstatus,s1
}
    80001b52:	70a2                	ld	ra,40(sp)
    80001b54:	7402                	ld	s0,32(sp)
    80001b56:	64e2                	ld	s1,24(sp)
    80001b58:	6942                	ld	s2,16(sp)
    80001b5a:	69a2                	ld	s3,8(sp)
    80001b5c:	6145                	addi	sp,sp,48
    80001b5e:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001b60:	00005517          	auipc	a0,0x5
    80001b64:	7f850513          	addi	a0,a0,2040 # 80007358 <states.0+0xd0>
    80001b68:	06f030ef          	jal	ra,800053d6 <panic>
    panic("kerneltrap: interrupts enabled");
    80001b6c:	00006517          	auipc	a0,0x6
    80001b70:	81450513          	addi	a0,a0,-2028 # 80007380 <states.0+0xf8>
    80001b74:	063030ef          	jal	ra,800053d6 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b78:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001b7c:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001b80:	85ce                	mv	a1,s3
    80001b82:	00006517          	auipc	a0,0x6
    80001b86:	81e50513          	addi	a0,a0,-2018 # 800073a0 <states.0+0x118>
    80001b8a:	598030ef          	jal	ra,80005122 <printf>
    panic("kerneltrap");
    80001b8e:	00006517          	auipc	a0,0x6
    80001b92:	83a50513          	addi	a0,a0,-1990 # 800073c8 <states.0+0x140>
    80001b96:	041030ef          	jal	ra,800053d6 <panic>
  if(which_dev == 2 && myproc() != 0)
    80001b9a:	9b8ff0ef          	jal	ra,80000d52 <myproc>
    80001b9e:	d555                	beqz	a0,80001b4a <kerneltrap+0x34>
    yield();
    80001ba0:	fe4ff0ef          	jal	ra,80001384 <yield>
    80001ba4:	b75d                	j	80001b4a <kerneltrap+0x34>

0000000080001ba6 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001ba6:	1101                	addi	sp,sp,-32
    80001ba8:	ec06                	sd	ra,24(sp)
    80001baa:	e822                	sd	s0,16(sp)
    80001bac:	e426                	sd	s1,8(sp)
    80001bae:	1000                	addi	s0,sp,32
    80001bb0:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001bb2:	9a0ff0ef          	jal	ra,80000d52 <myproc>
  switch (n) {
    80001bb6:	4795                	li	a5,5
    80001bb8:	0497e163          	bltu	a5,s1,80001bfa <argraw+0x54>
    80001bbc:	048a                	slli	s1,s1,0x2
    80001bbe:	00006717          	auipc	a4,0x6
    80001bc2:	84270713          	addi	a4,a4,-1982 # 80007400 <states.0+0x178>
    80001bc6:	94ba                	add	s1,s1,a4
    80001bc8:	409c                	lw	a5,0(s1)
    80001bca:	97ba                	add	a5,a5,a4
    80001bcc:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001bce:	613c                	ld	a5,64(a0)
    80001bd0:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001bd2:	60e2                	ld	ra,24(sp)
    80001bd4:	6442                	ld	s0,16(sp)
    80001bd6:	64a2                	ld	s1,8(sp)
    80001bd8:	6105                	addi	sp,sp,32
    80001bda:	8082                	ret
    return p->trapframe->a1;
    80001bdc:	613c                	ld	a5,64(a0)
    80001bde:	7fa8                	ld	a0,120(a5)
    80001be0:	bfcd                	j	80001bd2 <argraw+0x2c>
    return p->trapframe->a2;
    80001be2:	613c                	ld	a5,64(a0)
    80001be4:	63c8                	ld	a0,128(a5)
    80001be6:	b7f5                	j	80001bd2 <argraw+0x2c>
    return p->trapframe->a3;
    80001be8:	613c                	ld	a5,64(a0)
    80001bea:	67c8                	ld	a0,136(a5)
    80001bec:	b7dd                	j	80001bd2 <argraw+0x2c>
    return p->trapframe->a4;
    80001bee:	613c                	ld	a5,64(a0)
    80001bf0:	6bc8                	ld	a0,144(a5)
    80001bf2:	b7c5                	j	80001bd2 <argraw+0x2c>
    return p->trapframe->a5;
    80001bf4:	613c                	ld	a5,64(a0)
    80001bf6:	6fc8                	ld	a0,152(a5)
    80001bf8:	bfe9                	j	80001bd2 <argraw+0x2c>
  panic("argraw");
    80001bfa:	00005517          	auipc	a0,0x5
    80001bfe:	7de50513          	addi	a0,a0,2014 # 800073d8 <states.0+0x150>
    80001c02:	7d4030ef          	jal	ra,800053d6 <panic>

0000000080001c06 <fetchaddr>:
{
    80001c06:	1101                	addi	sp,sp,-32
    80001c08:	ec06                	sd	ra,24(sp)
    80001c0a:	e822                	sd	s0,16(sp)
    80001c0c:	e426                	sd	s1,8(sp)
    80001c0e:	e04a                	sd	s2,0(sp)
    80001c10:	1000                	addi	s0,sp,32
    80001c12:	84aa                	mv	s1,a0
    80001c14:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001c16:	93cff0ef          	jal	ra,80000d52 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001c1a:	657c                	ld	a5,200(a0)
    80001c1c:	02f4f663          	bgeu	s1,a5,80001c48 <fetchaddr+0x42>
    80001c20:	00848713          	addi	a4,s1,8
    80001c24:	02e7e463          	bltu	a5,a4,80001c4c <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001c28:	46a1                	li	a3,8
    80001c2a:	8626                	mv	a2,s1
    80001c2c:	85ca                	mv	a1,s2
    80001c2e:	6968                	ld	a0,208(a0)
    80001c30:	e8ffe0ef          	jal	ra,80000abe <copyin>
    80001c34:	00a03533          	snez	a0,a0
    80001c38:	40a00533          	neg	a0,a0
}
    80001c3c:	60e2                	ld	ra,24(sp)
    80001c3e:	6442                	ld	s0,16(sp)
    80001c40:	64a2                	ld	s1,8(sp)
    80001c42:	6902                	ld	s2,0(sp)
    80001c44:	6105                	addi	sp,sp,32
    80001c46:	8082                	ret
    return -1;
    80001c48:	557d                	li	a0,-1
    80001c4a:	bfcd                	j	80001c3c <fetchaddr+0x36>
    80001c4c:	557d                	li	a0,-1
    80001c4e:	b7fd                	j	80001c3c <fetchaddr+0x36>

0000000080001c50 <fetchstr>:
{
    80001c50:	7179                	addi	sp,sp,-48
    80001c52:	f406                	sd	ra,40(sp)
    80001c54:	f022                	sd	s0,32(sp)
    80001c56:	ec26                	sd	s1,24(sp)
    80001c58:	e84a                	sd	s2,16(sp)
    80001c5a:	e44e                	sd	s3,8(sp)
    80001c5c:	1800                	addi	s0,sp,48
    80001c5e:	892a                	mv	s2,a0
    80001c60:	84ae                	mv	s1,a1
    80001c62:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001c64:	8eeff0ef          	jal	ra,80000d52 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001c68:	86ce                	mv	a3,s3
    80001c6a:	864a                	mv	a2,s2
    80001c6c:	85a6                	mv	a1,s1
    80001c6e:	6968                	ld	a0,208(a0)
    80001c70:	ed5fe0ef          	jal	ra,80000b44 <copyinstr>
    80001c74:	00054c63          	bltz	a0,80001c8c <fetchstr+0x3c>
  return strlen(buf);
    80001c78:	8526                	mv	a0,s1
    80001c7a:	e4afe0ef          	jal	ra,800002c4 <strlen>
}
    80001c7e:	70a2                	ld	ra,40(sp)
    80001c80:	7402                	ld	s0,32(sp)
    80001c82:	64e2                	ld	s1,24(sp)
    80001c84:	6942                	ld	s2,16(sp)
    80001c86:	69a2                	ld	s3,8(sp)
    80001c88:	6145                	addi	sp,sp,48
    80001c8a:	8082                	ret
    return -1;
    80001c8c:	557d                	li	a0,-1
    80001c8e:	bfc5                	j	80001c7e <fetchstr+0x2e>

0000000080001c90 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001c90:	1101                	addi	sp,sp,-32
    80001c92:	ec06                	sd	ra,24(sp)
    80001c94:	e822                	sd	s0,16(sp)
    80001c96:	e426                	sd	s1,8(sp)
    80001c98:	1000                	addi	s0,sp,32
    80001c9a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001c9c:	f0bff0ef          	jal	ra,80001ba6 <argraw>
    80001ca0:	c088                	sw	a0,0(s1)
}
    80001ca2:	60e2                	ld	ra,24(sp)
    80001ca4:	6442                	ld	s0,16(sp)
    80001ca6:	64a2                	ld	s1,8(sp)
    80001ca8:	6105                	addi	sp,sp,32
    80001caa:	8082                	ret

0000000080001cac <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001cac:	1101                	addi	sp,sp,-32
    80001cae:	ec06                	sd	ra,24(sp)
    80001cb0:	e822                	sd	s0,16(sp)
    80001cb2:	e426                	sd	s1,8(sp)
    80001cb4:	1000                	addi	s0,sp,32
    80001cb6:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001cb8:	eefff0ef          	jal	ra,80001ba6 <argraw>
    80001cbc:	e088                	sd	a0,0(s1)
}
    80001cbe:	60e2                	ld	ra,24(sp)
    80001cc0:	6442                	ld	s0,16(sp)
    80001cc2:	64a2                	ld	s1,8(sp)
    80001cc4:	6105                	addi	sp,sp,32
    80001cc6:	8082                	ret

0000000080001cc8 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001cc8:	7179                	addi	sp,sp,-48
    80001cca:	f406                	sd	ra,40(sp)
    80001ccc:	f022                	sd	s0,32(sp)
    80001cce:	ec26                	sd	s1,24(sp)
    80001cd0:	e84a                	sd	s2,16(sp)
    80001cd2:	1800                	addi	s0,sp,48
    80001cd4:	84ae                	mv	s1,a1
    80001cd6:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80001cd8:	fd840593          	addi	a1,s0,-40
    80001cdc:	fd1ff0ef          	jal	ra,80001cac <argaddr>
  return fetchstr(addr, buf, max);
    80001ce0:	864a                	mv	a2,s2
    80001ce2:	85a6                	mv	a1,s1
    80001ce4:	fd843503          	ld	a0,-40(s0)
    80001ce8:	f69ff0ef          	jal	ra,80001c50 <fetchstr>
}
    80001cec:	70a2                	ld	ra,40(sp)
    80001cee:	7402                	ld	s0,32(sp)
    80001cf0:	64e2                	ld	s1,24(sp)
    80001cf2:	6942                	ld	s2,16(sp)
    80001cf4:	6145                	addi	sp,sp,48
    80001cf6:	8082                	ret

0000000080001cf8 <syscall>:
[SYS_pgaccess] sys_pgaccess,
};

void
syscall(void)
{
    80001cf8:	1101                	addi	sp,sp,-32
    80001cfa:	ec06                	sd	ra,24(sp)
    80001cfc:	e822                	sd	s0,16(sp)
    80001cfe:	e426                	sd	s1,8(sp)
    80001d00:	e04a                	sd	s2,0(sp)
    80001d02:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001d04:	84eff0ef          	jal	ra,80000d52 <myproc>
    80001d08:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001d0a:	04053903          	ld	s2,64(a0)
    80001d0e:	0a893783          	ld	a5,168(s2)
    80001d12:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001d16:	37fd                	addiw	a5,a5,-1
    80001d18:	4755                	li	a4,21
    80001d1a:	00f76f63          	bltu	a4,a5,80001d38 <syscall+0x40>
    80001d1e:	00369713          	slli	a4,a3,0x3
    80001d22:	00005797          	auipc	a5,0x5
    80001d26:	6f678793          	addi	a5,a5,1782 # 80007418 <syscalls>
    80001d2a:	97ba                	add	a5,a5,a4
    80001d2c:	639c                	ld	a5,0(a5)
    80001d2e:	c789                	beqz	a5,80001d38 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80001d30:	9782                	jalr	a5
    80001d32:	06a93823          	sd	a0,112(s2)
    80001d36:	a829                	j	80001d50 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001d38:	16048613          	addi	a2,s1,352
    80001d3c:	588c                	lw	a1,48(s1)
    80001d3e:	00005517          	auipc	a0,0x5
    80001d42:	6a250513          	addi	a0,a0,1698 # 800073e0 <states.0+0x158>
    80001d46:	3dc030ef          	jal	ra,80005122 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001d4a:	60bc                	ld	a5,64(s1)
    80001d4c:	577d                	li	a4,-1
    80001d4e:	fbb8                	sd	a4,112(a5)
  }
}
    80001d50:	60e2                	ld	ra,24(sp)
    80001d52:	6442                	ld	s0,16(sp)
    80001d54:	64a2                	ld	s1,8(sp)
    80001d56:	6902                	ld	s2,0(sp)
    80001d58:	6105                	addi	sp,sp,32
    80001d5a:	8082                	ret

0000000080001d5c <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80001d5c:	1101                	addi	sp,sp,-32
    80001d5e:	ec06                	sd	ra,24(sp)
    80001d60:	e822                	sd	s0,16(sp)
    80001d62:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80001d64:	fec40593          	addi	a1,s0,-20
    80001d68:	4501                	li	a0,0
    80001d6a:	f27ff0ef          	jal	ra,80001c90 <argint>
  exit(n);
    80001d6e:	fec42503          	lw	a0,-20(s0)
    80001d72:	f4aff0ef          	jal	ra,800014bc <exit>
  return 0;  // not reached
}
    80001d76:	4501                	li	a0,0
    80001d78:	60e2                	ld	ra,24(sp)
    80001d7a:	6442                	ld	s0,16(sp)
    80001d7c:	6105                	addi	sp,sp,32
    80001d7e:	8082                	ret

0000000080001d80 <sys_getpid>:

uint64
sys_getpid(void)
{
    80001d80:	1141                	addi	sp,sp,-16
    80001d82:	e406                	sd	ra,8(sp)
    80001d84:	e022                	sd	s0,0(sp)
    80001d86:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80001d88:	fcbfe0ef          	jal	ra,80000d52 <myproc>
}
    80001d8c:	5908                	lw	a0,48(a0)
    80001d8e:	60a2                	ld	ra,8(sp)
    80001d90:	6402                	ld	s0,0(sp)
    80001d92:	0141                	addi	sp,sp,16
    80001d94:	8082                	ret

0000000080001d96 <sys_fork>:

uint64
sys_fork(void)
{
    80001d96:	1141                	addi	sp,sp,-16
    80001d98:	e406                	sd	ra,8(sp)
    80001d9a:	e022                	sd	s0,0(sp)
    80001d9c:	0800                	addi	s0,sp,16
  return fork();
    80001d9e:	b62ff0ef          	jal	ra,80001100 <fork>
}
    80001da2:	60a2                	ld	ra,8(sp)
    80001da4:	6402                	ld	s0,0(sp)
    80001da6:	0141                	addi	sp,sp,16
    80001da8:	8082                	ret

0000000080001daa <sys_wait>:

uint64
sys_wait(void)
{
    80001daa:	1101                	addi	sp,sp,-32
    80001dac:	ec06                	sd	ra,24(sp)
    80001dae:	e822                	sd	s0,16(sp)
    80001db0:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80001db2:	fe840593          	addi	a1,s0,-24
    80001db6:	4501                	li	a0,0
    80001db8:	ef5ff0ef          	jal	ra,80001cac <argaddr>
  return wait(p);
    80001dbc:	fe843503          	ld	a0,-24(s0)
    80001dc0:	853ff0ef          	jal	ra,80001612 <wait>
}
    80001dc4:	60e2                	ld	ra,24(sp)
    80001dc6:	6442                	ld	s0,16(sp)
    80001dc8:	6105                	addi	sp,sp,32
    80001dca:	8082                	ret

0000000080001dcc <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80001dcc:	7179                	addi	sp,sp,-48
    80001dce:	f406                	sd	ra,40(sp)
    80001dd0:	f022                	sd	s0,32(sp)
    80001dd2:	ec26                	sd	s1,24(sp)
    80001dd4:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80001dd6:	fdc40593          	addi	a1,s0,-36
    80001dda:	4501                	li	a0,0
    80001ddc:	eb5ff0ef          	jal	ra,80001c90 <argint>
  addr = myproc()->sz;
    80001de0:	f73fe0ef          	jal	ra,80000d52 <myproc>
    80001de4:	6564                	ld	s1,200(a0)
  if(growproc(n) < 0)
    80001de6:	fdc42503          	lw	a0,-36(s0)
    80001dea:	ac6ff0ef          	jal	ra,800010b0 <growproc>
    80001dee:	00054863          	bltz	a0,80001dfe <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80001df2:	8526                	mv	a0,s1
    80001df4:	70a2                	ld	ra,40(sp)
    80001df6:	7402                	ld	s0,32(sp)
    80001df8:	64e2                	ld	s1,24(sp)
    80001dfa:	6145                	addi	sp,sp,48
    80001dfc:	8082                	ret
    return -1;
    80001dfe:	54fd                	li	s1,-1
    80001e00:	bfcd                	j	80001df2 <sys_sbrk+0x26>

0000000080001e02 <sys_sleep>:

uint64
sys_sleep(void)
{
    80001e02:	7139                	addi	sp,sp,-64
    80001e04:	fc06                	sd	ra,56(sp)
    80001e06:	f822                	sd	s0,48(sp)
    80001e08:	f426                	sd	s1,40(sp)
    80001e0a:	f04a                	sd	s2,32(sp)
    80001e0c:	ec4e                	sd	s3,24(sp)
    80001e0e:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80001e10:	fcc40593          	addi	a1,s0,-52
    80001e14:	4501                	li	a0,0
    80001e16:	e7bff0ef          	jal	ra,80001c90 <argint>
  if(n < 0)
    80001e1a:	fcc42783          	lw	a5,-52(s0)
    80001e1e:	0607c563          	bltz	a5,80001e88 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80001e22:	0000c517          	auipc	a0,0xc
    80001e26:	b3e50513          	addi	a0,a0,-1218 # 8000d960 <tickslock>
    80001e2a:	0c1030ef          	jal	ra,800056ea <acquire>
  ticks0 = ticks;
    80001e2e:	00006917          	auipc	s2,0x6
    80001e32:	aca92903          	lw	s2,-1334(s2) # 800078f8 <ticks>
  while(ticks - ticks0 < n){
    80001e36:	fcc42783          	lw	a5,-52(s0)
    80001e3a:	cb8d                	beqz	a5,80001e6c <sys_sleep+0x6a>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80001e3c:	0000c997          	auipc	s3,0xc
    80001e40:	b2498993          	addi	s3,s3,-1244 # 8000d960 <tickslock>
    80001e44:	00006497          	auipc	s1,0x6
    80001e48:	ab448493          	addi	s1,s1,-1356 # 800078f8 <ticks>
    if(killed(myproc())){
    80001e4c:	f07fe0ef          	jal	ra,80000d52 <myproc>
    80001e50:	f98ff0ef          	jal	ra,800015e8 <killed>
    80001e54:	ed0d                	bnez	a0,80001e8e <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80001e56:	85ce                	mv	a1,s3
    80001e58:	8526                	mv	a0,s1
    80001e5a:	d56ff0ef          	jal	ra,800013b0 <sleep>
  while(ticks - ticks0 < n){
    80001e5e:	409c                	lw	a5,0(s1)
    80001e60:	412787bb          	subw	a5,a5,s2
    80001e64:	fcc42703          	lw	a4,-52(s0)
    80001e68:	fee7e2e3          	bltu	a5,a4,80001e4c <sys_sleep+0x4a>
  }
  release(&tickslock);
    80001e6c:	0000c517          	auipc	a0,0xc
    80001e70:	af450513          	addi	a0,a0,-1292 # 8000d960 <tickslock>
    80001e74:	10f030ef          	jal	ra,80005782 <release>
  return 0;
    80001e78:	4501                	li	a0,0
}
    80001e7a:	70e2                	ld	ra,56(sp)
    80001e7c:	7442                	ld	s0,48(sp)
    80001e7e:	74a2                	ld	s1,40(sp)
    80001e80:	7902                	ld	s2,32(sp)
    80001e82:	69e2                	ld	s3,24(sp)
    80001e84:	6121                	addi	sp,sp,64
    80001e86:	8082                	ret
    n = 0;
    80001e88:	fc042623          	sw	zero,-52(s0)
    80001e8c:	bf59                	j	80001e22 <sys_sleep+0x20>
      release(&tickslock);
    80001e8e:	0000c517          	auipc	a0,0xc
    80001e92:	ad250513          	addi	a0,a0,-1326 # 8000d960 <tickslock>
    80001e96:	0ed030ef          	jal	ra,80005782 <release>
      return -1;
    80001e9a:	557d                	li	a0,-1
    80001e9c:	bff9                	j	80001e7a <sys_sleep+0x78>

0000000080001e9e <sys_kill>:

uint64
sys_kill(void)
{
    80001e9e:	1101                	addi	sp,sp,-32
    80001ea0:	ec06                	sd	ra,24(sp)
    80001ea2:	e822                	sd	s0,16(sp)
    80001ea4:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80001ea6:	fec40593          	addi	a1,s0,-20
    80001eaa:	4501                	li	a0,0
    80001eac:	de5ff0ef          	jal	ra,80001c90 <argint>
  return kill(pid);
    80001eb0:	fec42503          	lw	a0,-20(s0)
    80001eb4:	eaaff0ef          	jal	ra,8000155e <kill>
}
    80001eb8:	60e2                	ld	ra,24(sp)
    80001eba:	6442                	ld	s0,16(sp)
    80001ebc:	6105                	addi	sp,sp,32
    80001ebe:	8082                	ret

0000000080001ec0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80001ec0:	1101                	addi	sp,sp,-32
    80001ec2:	ec06                	sd	ra,24(sp)
    80001ec4:	e822                	sd	s0,16(sp)
    80001ec6:	e426                	sd	s1,8(sp)
    80001ec8:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80001eca:	0000c517          	auipc	a0,0xc
    80001ece:	a9650513          	addi	a0,a0,-1386 # 8000d960 <tickslock>
    80001ed2:	019030ef          	jal	ra,800056ea <acquire>
  xticks = ticks;
    80001ed6:	00006497          	auipc	s1,0x6
    80001eda:	a224a483          	lw	s1,-1502(s1) # 800078f8 <ticks>
  release(&tickslock);
    80001ede:	0000c517          	auipc	a0,0xc
    80001ee2:	a8250513          	addi	a0,a0,-1406 # 8000d960 <tickslock>
    80001ee6:	09d030ef          	jal	ra,80005782 <release>
  return xticks;
}
    80001eea:	02049513          	slli	a0,s1,0x20
    80001eee:	9101                	srli	a0,a0,0x20
    80001ef0:	60e2                	ld	ra,24(sp)
    80001ef2:	6442                	ld	s0,16(sp)
    80001ef4:	64a2                	ld	s1,8(sp)
    80001ef6:	6105                	addi	sp,sp,32
    80001ef8:	8082                	ret

0000000080001efa <sys_pgaccess>:
uint64
sys_pgaccess(void)
{
    80001efa:	711d                	addi	sp,sp,-96
    80001efc:	ec86                	sd	ra,88(sp)
    80001efe:	e8a2                	sd	s0,80(sp)
    80001f00:	e4a6                	sd	s1,72(sp)
    80001f02:	e0ca                	sd	s2,64(sp)
    80001f04:	fc4e                	sd	s3,56(sp)
    80001f06:	f852                	sd	s4,48(sp)
    80001f08:	f456                	sd	s5,40(sp)
    80001f0a:	1080                	addi	s0,sp,96
    uint64 va;
    int npages;
    uint64 addr;

    struct proc *p = myproc();
    80001f0c:	e47fe0ef          	jal	ra,80000d52 <myproc>
    80001f10:	89aa                	mv	s3,a0

    // ✅ lấy argument (KHÔNG check <0)
    argaddr(0, &va);
    80001f12:	fb840593          	addi	a1,s0,-72
    80001f16:	4501                	li	a0,0
    80001f18:	d95ff0ef          	jal	ra,80001cac <argaddr>
    argint(1, &npages);
    80001f1c:	fb440593          	addi	a1,s0,-76
    80001f20:	4505                	li	a0,1
    80001f22:	d6fff0ef          	jal	ra,80001c90 <argint>
    argaddr(2, &addr);
    80001f26:	fa840593          	addi	a1,s0,-88
    80001f2a:	4509                	li	a0,2
    80001f2c:	d81ff0ef          	jal	ra,80001cac <argaddr>

    unsigned int mask = 0;
    80001f30:	fa042223          	sw	zero,-92(s0)

    for(int i = 0; i < npages; i++){
    80001f34:	fb442783          	lw	a5,-76(s0)
    80001f38:	04f05d63          	blez	a5,80001f92 <sys_pgaccess+0x98>
    80001f3c:	4481                	li	s1,0
        pte_t *pte = walk(p->pagetable, va + i * PGSIZE, 0);

        if(pte && (*pte & PTE_V) && (*pte & PTE_A)){
    80001f3e:	04100a13          	li	s4,65
            mask |= (1 << i);
    80001f42:	4a85                	li	s5,1
    80001f44:	a801                	j	80001f54 <sys_pgaccess+0x5a>
    for(int i = 0; i < npages; i++){
    80001f46:	0485                	addi	s1,s1,1
    80001f48:	fb442703          	lw	a4,-76(s0)
    80001f4c:	0004879b          	sext.w	a5,s1
    80001f50:	04e7d163          	bge	a5,a4,80001f92 <sys_pgaccess+0x98>
    80001f54:	0004891b          	sext.w	s2,s1
        pte_t *pte = walk(p->pagetable, va + i * PGSIZE, 0);
    80001f58:	00c49793          	slli	a5,s1,0xc
    80001f5c:	4601                	li	a2,0
    80001f5e:	fb843583          	ld	a1,-72(s0)
    80001f62:	95be                	add	a1,a1,a5
    80001f64:	0d09b503          	ld	a0,208(s3)
    80001f68:	c60fe0ef          	jal	ra,800003c8 <walk>
        if(pte && (*pte & PTE_V) && (*pte & PTE_A)){
    80001f6c:	dd69                	beqz	a0,80001f46 <sys_pgaccess+0x4c>
    80001f6e:	611c                	ld	a5,0(a0)
    80001f70:	0417f793          	andi	a5,a5,65
    80001f74:	fd4799e3          	bne	a5,s4,80001f46 <sys_pgaccess+0x4c>
            mask |= (1 << i);
    80001f78:	012a993b          	sllw	s2,s5,s2
    80001f7c:	fa442783          	lw	a5,-92(s0)
    80001f80:	00f96933          	or	s2,s2,a5
    80001f84:	fb242223          	sw	s2,-92(s0)
            *pte &= ~PTE_A;   // reset bit accessed
    80001f88:	611c                	ld	a5,0(a0)
    80001f8a:	fbf7f793          	andi	a5,a5,-65
    80001f8e:	e11c                	sd	a5,0(a0)
    80001f90:	bf5d                	j	80001f46 <sys_pgaccess+0x4c>
        }
    }

    if(copyout(p->pagetable, addr, (char*)&mask, sizeof(mask)) < 0)
    80001f92:	4691                	li	a3,4
    80001f94:	fa440613          	addi	a2,s0,-92
    80001f98:	fa843583          	ld	a1,-88(s0)
    80001f9c:	0d09b503          	ld	a0,208(s3)
    80001fa0:	a67fe0ef          	jal	ra,80000a06 <copyout>
        return -1;

    return 0;
}
    80001fa4:	957d                	srai	a0,a0,0x3f
    80001fa6:	60e6                	ld	ra,88(sp)
    80001fa8:	6446                	ld	s0,80(sp)
    80001faa:	64a6                	ld	s1,72(sp)
    80001fac:	6906                	ld	s2,64(sp)
    80001fae:	79e2                	ld	s3,56(sp)
    80001fb0:	7a42                	ld	s4,48(sp)
    80001fb2:	7aa2                	ld	s5,40(sp)
    80001fb4:	6125                	addi	sp,sp,96
    80001fb6:	8082                	ret

0000000080001fb8 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80001fb8:	7179                	addi	sp,sp,-48
    80001fba:	f406                	sd	ra,40(sp)
    80001fbc:	f022                	sd	s0,32(sp)
    80001fbe:	ec26                	sd	s1,24(sp)
    80001fc0:	e84a                	sd	s2,16(sp)
    80001fc2:	e44e                	sd	s3,8(sp)
    80001fc4:	e052                	sd	s4,0(sp)
    80001fc6:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80001fc8:	00005597          	auipc	a1,0x5
    80001fcc:	50858593          	addi	a1,a1,1288 # 800074d0 <syscalls+0xb8>
    80001fd0:	0000c517          	auipc	a0,0xc
    80001fd4:	9a850513          	addi	a0,a0,-1624 # 8000d978 <bcache>
    80001fd8:	692030ef          	jal	ra,8000566a <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80001fdc:	00014797          	auipc	a5,0x14
    80001fe0:	99c78793          	addi	a5,a5,-1636 # 80015978 <bcache+0x8000>
    80001fe4:	00014717          	auipc	a4,0x14
    80001fe8:	bfc70713          	addi	a4,a4,-1028 # 80015be0 <bcache+0x8268>
    80001fec:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80001ff0:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001ff4:	0000c497          	auipc	s1,0xc
    80001ff8:	99c48493          	addi	s1,s1,-1636 # 8000d990 <bcache+0x18>
    b->next = bcache.head.next;
    80001ffc:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80001ffe:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002000:	00005a17          	auipc	s4,0x5
    80002004:	4d8a0a13          	addi	s4,s4,1240 # 800074d8 <syscalls+0xc0>
    b->next = bcache.head.next;
    80002008:	2b893783          	ld	a5,696(s2)
    8000200c:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000200e:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002012:	85d2                	mv	a1,s4
    80002014:	01048513          	addi	a0,s1,16
    80002018:	224010ef          	jal	ra,8000323c <initsleeplock>
    bcache.head.next->prev = b;
    8000201c:	2b893783          	ld	a5,696(s2)
    80002020:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002022:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002026:	45848493          	addi	s1,s1,1112
    8000202a:	fd349fe3          	bne	s1,s3,80002008 <binit+0x50>
  }
}
    8000202e:	70a2                	ld	ra,40(sp)
    80002030:	7402                	ld	s0,32(sp)
    80002032:	64e2                	ld	s1,24(sp)
    80002034:	6942                	ld	s2,16(sp)
    80002036:	69a2                	ld	s3,8(sp)
    80002038:	6a02                	ld	s4,0(sp)
    8000203a:	6145                	addi	sp,sp,48
    8000203c:	8082                	ret

000000008000203e <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000203e:	7179                	addi	sp,sp,-48
    80002040:	f406                	sd	ra,40(sp)
    80002042:	f022                	sd	s0,32(sp)
    80002044:	ec26                	sd	s1,24(sp)
    80002046:	e84a                	sd	s2,16(sp)
    80002048:	e44e                	sd	s3,8(sp)
    8000204a:	1800                	addi	s0,sp,48
    8000204c:	892a                	mv	s2,a0
    8000204e:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002050:	0000c517          	auipc	a0,0xc
    80002054:	92850513          	addi	a0,a0,-1752 # 8000d978 <bcache>
    80002058:	692030ef          	jal	ra,800056ea <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000205c:	00014497          	auipc	s1,0x14
    80002060:	bd44b483          	ld	s1,-1068(s1) # 80015c30 <bcache+0x82b8>
    80002064:	00014797          	auipc	a5,0x14
    80002068:	b7c78793          	addi	a5,a5,-1156 # 80015be0 <bcache+0x8268>
    8000206c:	02f48b63          	beq	s1,a5,800020a2 <bread+0x64>
    80002070:	873e                	mv	a4,a5
    80002072:	a021                	j	8000207a <bread+0x3c>
    80002074:	68a4                	ld	s1,80(s1)
    80002076:	02e48663          	beq	s1,a4,800020a2 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    8000207a:	449c                	lw	a5,8(s1)
    8000207c:	ff279ce3          	bne	a5,s2,80002074 <bread+0x36>
    80002080:	44dc                	lw	a5,12(s1)
    80002082:	ff3799e3          	bne	a5,s3,80002074 <bread+0x36>
      b->refcnt++;
    80002086:	40bc                	lw	a5,64(s1)
    80002088:	2785                	addiw	a5,a5,1
    8000208a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000208c:	0000c517          	auipc	a0,0xc
    80002090:	8ec50513          	addi	a0,a0,-1812 # 8000d978 <bcache>
    80002094:	6ee030ef          	jal	ra,80005782 <release>
      acquiresleep(&b->lock);
    80002098:	01048513          	addi	a0,s1,16
    8000209c:	1d6010ef          	jal	ra,80003272 <acquiresleep>
      return b;
    800020a0:	a889                	j	800020f2 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800020a2:	00014497          	auipc	s1,0x14
    800020a6:	b864b483          	ld	s1,-1146(s1) # 80015c28 <bcache+0x82b0>
    800020aa:	00014797          	auipc	a5,0x14
    800020ae:	b3678793          	addi	a5,a5,-1226 # 80015be0 <bcache+0x8268>
    800020b2:	00f48863          	beq	s1,a5,800020c2 <bread+0x84>
    800020b6:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800020b8:	40bc                	lw	a5,64(s1)
    800020ba:	cb91                	beqz	a5,800020ce <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800020bc:	64a4                	ld	s1,72(s1)
    800020be:	fee49de3          	bne	s1,a4,800020b8 <bread+0x7a>
  panic("bget: no buffers");
    800020c2:	00005517          	auipc	a0,0x5
    800020c6:	41e50513          	addi	a0,a0,1054 # 800074e0 <syscalls+0xc8>
    800020ca:	30c030ef          	jal	ra,800053d6 <panic>
      b->dev = dev;
    800020ce:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800020d2:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800020d6:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800020da:	4785                	li	a5,1
    800020dc:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800020de:	0000c517          	auipc	a0,0xc
    800020e2:	89a50513          	addi	a0,a0,-1894 # 8000d978 <bcache>
    800020e6:	69c030ef          	jal	ra,80005782 <release>
      acquiresleep(&b->lock);
    800020ea:	01048513          	addi	a0,s1,16
    800020ee:	184010ef          	jal	ra,80003272 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800020f2:	409c                	lw	a5,0(s1)
    800020f4:	cb89                	beqz	a5,80002106 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800020f6:	8526                	mv	a0,s1
    800020f8:	70a2                	ld	ra,40(sp)
    800020fa:	7402                	ld	s0,32(sp)
    800020fc:	64e2                	ld	s1,24(sp)
    800020fe:	6942                	ld	s2,16(sp)
    80002100:	69a2                	ld	s3,8(sp)
    80002102:	6145                	addi	sp,sp,48
    80002104:	8082                	ret
    virtio_disk_rw(b, 0);
    80002106:	4581                	li	a1,0
    80002108:	8526                	mv	a0,s1
    8000210a:	0d3020ef          	jal	ra,800049dc <virtio_disk_rw>
    b->valid = 1;
    8000210e:	4785                	li	a5,1
    80002110:	c09c                	sw	a5,0(s1)
  return b;
    80002112:	b7d5                	j	800020f6 <bread+0xb8>

0000000080002114 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002114:	1101                	addi	sp,sp,-32
    80002116:	ec06                	sd	ra,24(sp)
    80002118:	e822                	sd	s0,16(sp)
    8000211a:	e426                	sd	s1,8(sp)
    8000211c:	1000                	addi	s0,sp,32
    8000211e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002120:	0541                	addi	a0,a0,16
    80002122:	1ce010ef          	jal	ra,800032f0 <holdingsleep>
    80002126:	c911                	beqz	a0,8000213a <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002128:	4585                	li	a1,1
    8000212a:	8526                	mv	a0,s1
    8000212c:	0b1020ef          	jal	ra,800049dc <virtio_disk_rw>
}
    80002130:	60e2                	ld	ra,24(sp)
    80002132:	6442                	ld	s0,16(sp)
    80002134:	64a2                	ld	s1,8(sp)
    80002136:	6105                	addi	sp,sp,32
    80002138:	8082                	ret
    panic("bwrite");
    8000213a:	00005517          	auipc	a0,0x5
    8000213e:	3be50513          	addi	a0,a0,958 # 800074f8 <syscalls+0xe0>
    80002142:	294030ef          	jal	ra,800053d6 <panic>

0000000080002146 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002146:	1101                	addi	sp,sp,-32
    80002148:	ec06                	sd	ra,24(sp)
    8000214a:	e822                	sd	s0,16(sp)
    8000214c:	e426                	sd	s1,8(sp)
    8000214e:	e04a                	sd	s2,0(sp)
    80002150:	1000                	addi	s0,sp,32
    80002152:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002154:	01050913          	addi	s2,a0,16
    80002158:	854a                	mv	a0,s2
    8000215a:	196010ef          	jal	ra,800032f0 <holdingsleep>
    8000215e:	c13d                	beqz	a0,800021c4 <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
    80002160:	854a                	mv	a0,s2
    80002162:	156010ef          	jal	ra,800032b8 <releasesleep>

  acquire(&bcache.lock);
    80002166:	0000c517          	auipc	a0,0xc
    8000216a:	81250513          	addi	a0,a0,-2030 # 8000d978 <bcache>
    8000216e:	57c030ef          	jal	ra,800056ea <acquire>
  b->refcnt--;
    80002172:	40bc                	lw	a5,64(s1)
    80002174:	37fd                	addiw	a5,a5,-1
    80002176:	0007871b          	sext.w	a4,a5
    8000217a:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000217c:	eb05                	bnez	a4,800021ac <brelse+0x66>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000217e:	68bc                	ld	a5,80(s1)
    80002180:	64b8                	ld	a4,72(s1)
    80002182:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002184:	64bc                	ld	a5,72(s1)
    80002186:	68b8                	ld	a4,80(s1)
    80002188:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000218a:	00013797          	auipc	a5,0x13
    8000218e:	7ee78793          	addi	a5,a5,2030 # 80015978 <bcache+0x8000>
    80002192:	2b87b703          	ld	a4,696(a5)
    80002196:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002198:	00014717          	auipc	a4,0x14
    8000219c:	a4870713          	addi	a4,a4,-1464 # 80015be0 <bcache+0x8268>
    800021a0:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800021a2:	2b87b703          	ld	a4,696(a5)
    800021a6:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800021a8:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800021ac:	0000b517          	auipc	a0,0xb
    800021b0:	7cc50513          	addi	a0,a0,1996 # 8000d978 <bcache>
    800021b4:	5ce030ef          	jal	ra,80005782 <release>
}
    800021b8:	60e2                	ld	ra,24(sp)
    800021ba:	6442                	ld	s0,16(sp)
    800021bc:	64a2                	ld	s1,8(sp)
    800021be:	6902                	ld	s2,0(sp)
    800021c0:	6105                	addi	sp,sp,32
    800021c2:	8082                	ret
    panic("brelse");
    800021c4:	00005517          	auipc	a0,0x5
    800021c8:	33c50513          	addi	a0,a0,828 # 80007500 <syscalls+0xe8>
    800021cc:	20a030ef          	jal	ra,800053d6 <panic>

00000000800021d0 <bpin>:

void
bpin(struct buf *b) {
    800021d0:	1101                	addi	sp,sp,-32
    800021d2:	ec06                	sd	ra,24(sp)
    800021d4:	e822                	sd	s0,16(sp)
    800021d6:	e426                	sd	s1,8(sp)
    800021d8:	1000                	addi	s0,sp,32
    800021da:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800021dc:	0000b517          	auipc	a0,0xb
    800021e0:	79c50513          	addi	a0,a0,1948 # 8000d978 <bcache>
    800021e4:	506030ef          	jal	ra,800056ea <acquire>
  b->refcnt++;
    800021e8:	40bc                	lw	a5,64(s1)
    800021ea:	2785                	addiw	a5,a5,1
    800021ec:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800021ee:	0000b517          	auipc	a0,0xb
    800021f2:	78a50513          	addi	a0,a0,1930 # 8000d978 <bcache>
    800021f6:	58c030ef          	jal	ra,80005782 <release>
}
    800021fa:	60e2                	ld	ra,24(sp)
    800021fc:	6442                	ld	s0,16(sp)
    800021fe:	64a2                	ld	s1,8(sp)
    80002200:	6105                	addi	sp,sp,32
    80002202:	8082                	ret

0000000080002204 <bunpin>:

void
bunpin(struct buf *b) {
    80002204:	1101                	addi	sp,sp,-32
    80002206:	ec06                	sd	ra,24(sp)
    80002208:	e822                	sd	s0,16(sp)
    8000220a:	e426                	sd	s1,8(sp)
    8000220c:	1000                	addi	s0,sp,32
    8000220e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002210:	0000b517          	auipc	a0,0xb
    80002214:	76850513          	addi	a0,a0,1896 # 8000d978 <bcache>
    80002218:	4d2030ef          	jal	ra,800056ea <acquire>
  b->refcnt--;
    8000221c:	40bc                	lw	a5,64(s1)
    8000221e:	37fd                	addiw	a5,a5,-1
    80002220:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002222:	0000b517          	auipc	a0,0xb
    80002226:	75650513          	addi	a0,a0,1878 # 8000d978 <bcache>
    8000222a:	558030ef          	jal	ra,80005782 <release>
}
    8000222e:	60e2                	ld	ra,24(sp)
    80002230:	6442                	ld	s0,16(sp)
    80002232:	64a2                	ld	s1,8(sp)
    80002234:	6105                	addi	sp,sp,32
    80002236:	8082                	ret

0000000080002238 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002238:	1101                	addi	sp,sp,-32
    8000223a:	ec06                	sd	ra,24(sp)
    8000223c:	e822                	sd	s0,16(sp)
    8000223e:	e426                	sd	s1,8(sp)
    80002240:	e04a                	sd	s2,0(sp)
    80002242:	1000                	addi	s0,sp,32
    80002244:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002246:	00d5d59b          	srliw	a1,a1,0xd
    8000224a:	00014797          	auipc	a5,0x14
    8000224e:	e0a7a783          	lw	a5,-502(a5) # 80016054 <sb+0x1c>
    80002252:	9dbd                	addw	a1,a1,a5
    80002254:	debff0ef          	jal	ra,8000203e <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002258:	0074f713          	andi	a4,s1,7
    8000225c:	4785                	li	a5,1
    8000225e:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002262:	14ce                	slli	s1,s1,0x33
    80002264:	90d9                	srli	s1,s1,0x36
    80002266:	00950733          	add	a4,a0,s1
    8000226a:	05874703          	lbu	a4,88(a4)
    8000226e:	00e7f6b3          	and	a3,a5,a4
    80002272:	c29d                	beqz	a3,80002298 <bfree+0x60>
    80002274:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002276:	94aa                	add	s1,s1,a0
    80002278:	fff7c793          	not	a5,a5
    8000227c:	8ff9                	and	a5,a5,a4
    8000227e:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002282:	6e9000ef          	jal	ra,8000316a <log_write>
  brelse(bp);
    80002286:	854a                	mv	a0,s2
    80002288:	ebfff0ef          	jal	ra,80002146 <brelse>
}
    8000228c:	60e2                	ld	ra,24(sp)
    8000228e:	6442                	ld	s0,16(sp)
    80002290:	64a2                	ld	s1,8(sp)
    80002292:	6902                	ld	s2,0(sp)
    80002294:	6105                	addi	sp,sp,32
    80002296:	8082                	ret
    panic("freeing free block");
    80002298:	00005517          	auipc	a0,0x5
    8000229c:	27050513          	addi	a0,a0,624 # 80007508 <syscalls+0xf0>
    800022a0:	136030ef          	jal	ra,800053d6 <panic>

00000000800022a4 <balloc>:
{
    800022a4:	711d                	addi	sp,sp,-96
    800022a6:	ec86                	sd	ra,88(sp)
    800022a8:	e8a2                	sd	s0,80(sp)
    800022aa:	e4a6                	sd	s1,72(sp)
    800022ac:	e0ca                	sd	s2,64(sp)
    800022ae:	fc4e                	sd	s3,56(sp)
    800022b0:	f852                	sd	s4,48(sp)
    800022b2:	f456                	sd	s5,40(sp)
    800022b4:	f05a                	sd	s6,32(sp)
    800022b6:	ec5e                	sd	s7,24(sp)
    800022b8:	e862                	sd	s8,16(sp)
    800022ba:	e466                	sd	s9,8(sp)
    800022bc:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800022be:	00014797          	auipc	a5,0x14
    800022c2:	d7e7a783          	lw	a5,-642(a5) # 8001603c <sb+0x4>
    800022c6:	0e078163          	beqz	a5,800023a8 <balloc+0x104>
    800022ca:	8baa                	mv	s7,a0
    800022cc:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800022ce:	00014b17          	auipc	s6,0x14
    800022d2:	d6ab0b13          	addi	s6,s6,-662 # 80016038 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800022d6:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800022d8:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800022da:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800022dc:	6c89                	lui	s9,0x2
    800022de:	a0b5                	j	8000234a <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    800022e0:	974a                	add	a4,a4,s2
    800022e2:	8fd5                	or	a5,a5,a3
    800022e4:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800022e8:	854a                	mv	a0,s2
    800022ea:	681000ef          	jal	ra,8000316a <log_write>
        brelse(bp);
    800022ee:	854a                	mv	a0,s2
    800022f0:	e57ff0ef          	jal	ra,80002146 <brelse>
  bp = bread(dev, bno);
    800022f4:	85a6                	mv	a1,s1
    800022f6:	855e                	mv	a0,s7
    800022f8:	d47ff0ef          	jal	ra,8000203e <bread>
    800022fc:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800022fe:	40000613          	li	a2,1024
    80002302:	4581                	li	a1,0
    80002304:	05850513          	addi	a0,a0,88
    80002308:	e45fd0ef          	jal	ra,8000014c <memset>
  log_write(bp);
    8000230c:	854a                	mv	a0,s2
    8000230e:	65d000ef          	jal	ra,8000316a <log_write>
  brelse(bp);
    80002312:	854a                	mv	a0,s2
    80002314:	e33ff0ef          	jal	ra,80002146 <brelse>
}
    80002318:	8526                	mv	a0,s1
    8000231a:	60e6                	ld	ra,88(sp)
    8000231c:	6446                	ld	s0,80(sp)
    8000231e:	64a6                	ld	s1,72(sp)
    80002320:	6906                	ld	s2,64(sp)
    80002322:	79e2                	ld	s3,56(sp)
    80002324:	7a42                	ld	s4,48(sp)
    80002326:	7aa2                	ld	s5,40(sp)
    80002328:	7b02                	ld	s6,32(sp)
    8000232a:	6be2                	ld	s7,24(sp)
    8000232c:	6c42                	ld	s8,16(sp)
    8000232e:	6ca2                	ld	s9,8(sp)
    80002330:	6125                	addi	sp,sp,96
    80002332:	8082                	ret
    brelse(bp);
    80002334:	854a                	mv	a0,s2
    80002336:	e11ff0ef          	jal	ra,80002146 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000233a:	015c87bb          	addw	a5,s9,s5
    8000233e:	00078a9b          	sext.w	s5,a5
    80002342:	004b2703          	lw	a4,4(s6)
    80002346:	06eaf163          	bgeu	s5,a4,800023a8 <balloc+0x104>
    bp = bread(dev, BBLOCK(b, sb));
    8000234a:	41fad79b          	sraiw	a5,s5,0x1f
    8000234e:	0137d79b          	srliw	a5,a5,0x13
    80002352:	015787bb          	addw	a5,a5,s5
    80002356:	40d7d79b          	sraiw	a5,a5,0xd
    8000235a:	01cb2583          	lw	a1,28(s6)
    8000235e:	9dbd                	addw	a1,a1,a5
    80002360:	855e                	mv	a0,s7
    80002362:	cddff0ef          	jal	ra,8000203e <bread>
    80002366:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002368:	004b2503          	lw	a0,4(s6)
    8000236c:	000a849b          	sext.w	s1,s5
    80002370:	8662                	mv	a2,s8
    80002372:	fca4f1e3          	bgeu	s1,a0,80002334 <balloc+0x90>
      m = 1 << (bi % 8);
    80002376:	41f6579b          	sraiw	a5,a2,0x1f
    8000237a:	01d7d69b          	srliw	a3,a5,0x1d
    8000237e:	00c6873b          	addw	a4,a3,a2
    80002382:	00777793          	andi	a5,a4,7
    80002386:	9f95                	subw	a5,a5,a3
    80002388:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000238c:	4037571b          	sraiw	a4,a4,0x3
    80002390:	00e906b3          	add	a3,s2,a4
    80002394:	0586c683          	lbu	a3,88(a3)
    80002398:	00d7f5b3          	and	a1,a5,a3
    8000239c:	d1b1                	beqz	a1,800022e0 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000239e:	2605                	addiw	a2,a2,1
    800023a0:	2485                	addiw	s1,s1,1
    800023a2:	fd4618e3          	bne	a2,s4,80002372 <balloc+0xce>
    800023a6:	b779                	j	80002334 <balloc+0x90>
  printf("balloc: out of blocks\n");
    800023a8:	00005517          	auipc	a0,0x5
    800023ac:	17850513          	addi	a0,a0,376 # 80007520 <syscalls+0x108>
    800023b0:	573020ef          	jal	ra,80005122 <printf>
  return 0;
    800023b4:	4481                	li	s1,0
    800023b6:	b78d                	j	80002318 <balloc+0x74>

00000000800023b8 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800023b8:	7179                	addi	sp,sp,-48
    800023ba:	f406                	sd	ra,40(sp)
    800023bc:	f022                	sd	s0,32(sp)
    800023be:	ec26                	sd	s1,24(sp)
    800023c0:	e84a                	sd	s2,16(sp)
    800023c2:	e44e                	sd	s3,8(sp)
    800023c4:	e052                	sd	s4,0(sp)
    800023c6:	1800                	addi	s0,sp,48
    800023c8:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800023ca:	47ad                	li	a5,11
    800023cc:	02b7e563          	bltu	a5,a1,800023f6 <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    800023d0:	02059493          	slli	s1,a1,0x20
    800023d4:	9081                	srli	s1,s1,0x20
    800023d6:	048a                	slli	s1,s1,0x2
    800023d8:	94aa                	add	s1,s1,a0
    800023da:	0504a903          	lw	s2,80(s1)
    800023de:	06091663          	bnez	s2,8000244a <bmap+0x92>
      addr = balloc(ip->dev);
    800023e2:	4108                	lw	a0,0(a0)
    800023e4:	ec1ff0ef          	jal	ra,800022a4 <balloc>
    800023e8:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800023ec:	04090f63          	beqz	s2,8000244a <bmap+0x92>
        return 0;
      ip->addrs[bn] = addr;
    800023f0:	0524a823          	sw	s2,80(s1)
    800023f4:	a899                	j	8000244a <bmap+0x92>
    }
    return addr;
  }
  bn -= NDIRECT;
    800023f6:	ff45849b          	addiw	s1,a1,-12
    800023fa:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800023fe:	0ff00793          	li	a5,255
    80002402:	06e7eb63          	bltu	a5,a4,80002478 <bmap+0xc0>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002406:	08052903          	lw	s2,128(a0)
    8000240a:	00091b63          	bnez	s2,80002420 <bmap+0x68>
      addr = balloc(ip->dev);
    8000240e:	4108                	lw	a0,0(a0)
    80002410:	e95ff0ef          	jal	ra,800022a4 <balloc>
    80002414:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002418:	02090963          	beqz	s2,8000244a <bmap+0x92>
        return 0;
      ip->addrs[NDIRECT] = addr;
    8000241c:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80002420:	85ca                	mv	a1,s2
    80002422:	0009a503          	lw	a0,0(s3)
    80002426:	c19ff0ef          	jal	ra,8000203e <bread>
    8000242a:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000242c:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002430:	02049593          	slli	a1,s1,0x20
    80002434:	9181                	srli	a1,a1,0x20
    80002436:	058a                	slli	a1,a1,0x2
    80002438:	00b784b3          	add	s1,a5,a1
    8000243c:	0004a903          	lw	s2,0(s1)
    80002440:	00090e63          	beqz	s2,8000245c <bmap+0xa4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002444:	8552                	mv	a0,s4
    80002446:	d01ff0ef          	jal	ra,80002146 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000244a:	854a                	mv	a0,s2
    8000244c:	70a2                	ld	ra,40(sp)
    8000244e:	7402                	ld	s0,32(sp)
    80002450:	64e2                	ld	s1,24(sp)
    80002452:	6942                	ld	s2,16(sp)
    80002454:	69a2                	ld	s3,8(sp)
    80002456:	6a02                	ld	s4,0(sp)
    80002458:	6145                	addi	sp,sp,48
    8000245a:	8082                	ret
      addr = balloc(ip->dev);
    8000245c:	0009a503          	lw	a0,0(s3)
    80002460:	e45ff0ef          	jal	ra,800022a4 <balloc>
    80002464:	0005091b          	sext.w	s2,a0
      if(addr){
    80002468:	fc090ee3          	beqz	s2,80002444 <bmap+0x8c>
        a[bn] = addr;
    8000246c:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002470:	8552                	mv	a0,s4
    80002472:	4f9000ef          	jal	ra,8000316a <log_write>
    80002476:	b7f9                	j	80002444 <bmap+0x8c>
  panic("bmap: out of range");
    80002478:	00005517          	auipc	a0,0x5
    8000247c:	0c050513          	addi	a0,a0,192 # 80007538 <syscalls+0x120>
    80002480:	757020ef          	jal	ra,800053d6 <panic>

0000000080002484 <iget>:
{
    80002484:	7179                	addi	sp,sp,-48
    80002486:	f406                	sd	ra,40(sp)
    80002488:	f022                	sd	s0,32(sp)
    8000248a:	ec26                	sd	s1,24(sp)
    8000248c:	e84a                	sd	s2,16(sp)
    8000248e:	e44e                	sd	s3,8(sp)
    80002490:	e052                	sd	s4,0(sp)
    80002492:	1800                	addi	s0,sp,48
    80002494:	89aa                	mv	s3,a0
    80002496:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002498:	00014517          	auipc	a0,0x14
    8000249c:	bc050513          	addi	a0,a0,-1088 # 80016058 <itable>
    800024a0:	24a030ef          	jal	ra,800056ea <acquire>
  empty = 0;
    800024a4:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800024a6:	00014497          	auipc	s1,0x14
    800024aa:	bca48493          	addi	s1,s1,-1078 # 80016070 <itable+0x18>
    800024ae:	00015697          	auipc	a3,0x15
    800024b2:	65268693          	addi	a3,a3,1618 # 80017b00 <log>
    800024b6:	a039                	j	800024c4 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800024b8:	02090963          	beqz	s2,800024ea <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800024bc:	08848493          	addi	s1,s1,136
    800024c0:	02d48863          	beq	s1,a3,800024f0 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800024c4:	449c                	lw	a5,8(s1)
    800024c6:	fef059e3          	blez	a5,800024b8 <iget+0x34>
    800024ca:	4098                	lw	a4,0(s1)
    800024cc:	ff3716e3          	bne	a4,s3,800024b8 <iget+0x34>
    800024d0:	40d8                	lw	a4,4(s1)
    800024d2:	ff4713e3          	bne	a4,s4,800024b8 <iget+0x34>
      ip->ref++;
    800024d6:	2785                	addiw	a5,a5,1
    800024d8:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800024da:	00014517          	auipc	a0,0x14
    800024de:	b7e50513          	addi	a0,a0,-1154 # 80016058 <itable>
    800024e2:	2a0030ef          	jal	ra,80005782 <release>
      return ip;
    800024e6:	8926                	mv	s2,s1
    800024e8:	a02d                	j	80002512 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800024ea:	fbe9                	bnez	a5,800024bc <iget+0x38>
    800024ec:	8926                	mv	s2,s1
    800024ee:	b7f9                	j	800024bc <iget+0x38>
  if(empty == 0)
    800024f0:	02090a63          	beqz	s2,80002524 <iget+0xa0>
  ip->dev = dev;
    800024f4:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800024f8:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800024fc:	4785                	li	a5,1
    800024fe:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002502:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002506:	00014517          	auipc	a0,0x14
    8000250a:	b5250513          	addi	a0,a0,-1198 # 80016058 <itable>
    8000250e:	274030ef          	jal	ra,80005782 <release>
}
    80002512:	854a                	mv	a0,s2
    80002514:	70a2                	ld	ra,40(sp)
    80002516:	7402                	ld	s0,32(sp)
    80002518:	64e2                	ld	s1,24(sp)
    8000251a:	6942                	ld	s2,16(sp)
    8000251c:	69a2                	ld	s3,8(sp)
    8000251e:	6a02                	ld	s4,0(sp)
    80002520:	6145                	addi	sp,sp,48
    80002522:	8082                	ret
    panic("iget: no inodes");
    80002524:	00005517          	auipc	a0,0x5
    80002528:	02c50513          	addi	a0,a0,44 # 80007550 <syscalls+0x138>
    8000252c:	6ab020ef          	jal	ra,800053d6 <panic>

0000000080002530 <fsinit>:
fsinit(int dev) {
    80002530:	7179                	addi	sp,sp,-48
    80002532:	f406                	sd	ra,40(sp)
    80002534:	f022                	sd	s0,32(sp)
    80002536:	ec26                	sd	s1,24(sp)
    80002538:	e84a                	sd	s2,16(sp)
    8000253a:	e44e                	sd	s3,8(sp)
    8000253c:	1800                	addi	s0,sp,48
    8000253e:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002540:	4585                	li	a1,1
    80002542:	afdff0ef          	jal	ra,8000203e <bread>
    80002546:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002548:	00014997          	auipc	s3,0x14
    8000254c:	af098993          	addi	s3,s3,-1296 # 80016038 <sb>
    80002550:	02000613          	li	a2,32
    80002554:	05850593          	addi	a1,a0,88
    80002558:	854e                	mv	a0,s3
    8000255a:	c4ffd0ef          	jal	ra,800001a8 <memmove>
  brelse(bp);
    8000255e:	8526                	mv	a0,s1
    80002560:	be7ff0ef          	jal	ra,80002146 <brelse>
  if(sb.magic != FSMAGIC)
    80002564:	0009a703          	lw	a4,0(s3)
    80002568:	102037b7          	lui	a5,0x10203
    8000256c:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002570:	02f71063          	bne	a4,a5,80002590 <fsinit+0x60>
  initlog(dev, &sb);
    80002574:	00014597          	auipc	a1,0x14
    80002578:	ac458593          	addi	a1,a1,-1340 # 80016038 <sb>
    8000257c:	854a                	mv	a0,s2
    8000257e:	1d9000ef          	jal	ra,80002f56 <initlog>
}
    80002582:	70a2                	ld	ra,40(sp)
    80002584:	7402                	ld	s0,32(sp)
    80002586:	64e2                	ld	s1,24(sp)
    80002588:	6942                	ld	s2,16(sp)
    8000258a:	69a2                	ld	s3,8(sp)
    8000258c:	6145                	addi	sp,sp,48
    8000258e:	8082                	ret
    panic("invalid file system");
    80002590:	00005517          	auipc	a0,0x5
    80002594:	fd050513          	addi	a0,a0,-48 # 80007560 <syscalls+0x148>
    80002598:	63f020ef          	jal	ra,800053d6 <panic>

000000008000259c <iinit>:
{
    8000259c:	7179                	addi	sp,sp,-48
    8000259e:	f406                	sd	ra,40(sp)
    800025a0:	f022                	sd	s0,32(sp)
    800025a2:	ec26                	sd	s1,24(sp)
    800025a4:	e84a                	sd	s2,16(sp)
    800025a6:	e44e                	sd	s3,8(sp)
    800025a8:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800025aa:	00005597          	auipc	a1,0x5
    800025ae:	fce58593          	addi	a1,a1,-50 # 80007578 <syscalls+0x160>
    800025b2:	00014517          	auipc	a0,0x14
    800025b6:	aa650513          	addi	a0,a0,-1370 # 80016058 <itable>
    800025ba:	0b0030ef          	jal	ra,8000566a <initlock>
  for(i = 0; i < NINODE; i++) {
    800025be:	00014497          	auipc	s1,0x14
    800025c2:	ac248493          	addi	s1,s1,-1342 # 80016080 <itable+0x28>
    800025c6:	00015997          	auipc	s3,0x15
    800025ca:	54a98993          	addi	s3,s3,1354 # 80017b10 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800025ce:	00005917          	auipc	s2,0x5
    800025d2:	fb290913          	addi	s2,s2,-78 # 80007580 <syscalls+0x168>
    800025d6:	85ca                	mv	a1,s2
    800025d8:	8526                	mv	a0,s1
    800025da:	463000ef          	jal	ra,8000323c <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800025de:	08848493          	addi	s1,s1,136
    800025e2:	ff349ae3          	bne	s1,s3,800025d6 <iinit+0x3a>
}
    800025e6:	70a2                	ld	ra,40(sp)
    800025e8:	7402                	ld	s0,32(sp)
    800025ea:	64e2                	ld	s1,24(sp)
    800025ec:	6942                	ld	s2,16(sp)
    800025ee:	69a2                	ld	s3,8(sp)
    800025f0:	6145                	addi	sp,sp,48
    800025f2:	8082                	ret

00000000800025f4 <ialloc>:
{
    800025f4:	715d                	addi	sp,sp,-80
    800025f6:	e486                	sd	ra,72(sp)
    800025f8:	e0a2                	sd	s0,64(sp)
    800025fa:	fc26                	sd	s1,56(sp)
    800025fc:	f84a                	sd	s2,48(sp)
    800025fe:	f44e                	sd	s3,40(sp)
    80002600:	f052                	sd	s4,32(sp)
    80002602:	ec56                	sd	s5,24(sp)
    80002604:	e85a                	sd	s6,16(sp)
    80002606:	e45e                	sd	s7,8(sp)
    80002608:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    8000260a:	00014717          	auipc	a4,0x14
    8000260e:	a3a72703          	lw	a4,-1478(a4) # 80016044 <sb+0xc>
    80002612:	4785                	li	a5,1
    80002614:	04e7f663          	bgeu	a5,a4,80002660 <ialloc+0x6c>
    80002618:	8aaa                	mv	s5,a0
    8000261a:	8bae                	mv	s7,a1
    8000261c:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000261e:	00014a17          	auipc	s4,0x14
    80002622:	a1aa0a13          	addi	s4,s4,-1510 # 80016038 <sb>
    80002626:	00048b1b          	sext.w	s6,s1
    8000262a:	0044d793          	srli	a5,s1,0x4
    8000262e:	018a2583          	lw	a1,24(s4)
    80002632:	9dbd                	addw	a1,a1,a5
    80002634:	8556                	mv	a0,s5
    80002636:	a09ff0ef          	jal	ra,8000203e <bread>
    8000263a:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    8000263c:	05850993          	addi	s3,a0,88
    80002640:	00f4f793          	andi	a5,s1,15
    80002644:	079a                	slli	a5,a5,0x6
    80002646:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002648:	00099783          	lh	a5,0(s3)
    8000264c:	cf85                	beqz	a5,80002684 <ialloc+0x90>
    brelse(bp);
    8000264e:	af9ff0ef          	jal	ra,80002146 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002652:	0485                	addi	s1,s1,1
    80002654:	00ca2703          	lw	a4,12(s4)
    80002658:	0004879b          	sext.w	a5,s1
    8000265c:	fce7e5e3          	bltu	a5,a4,80002626 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002660:	00005517          	auipc	a0,0x5
    80002664:	f2850513          	addi	a0,a0,-216 # 80007588 <syscalls+0x170>
    80002668:	2bb020ef          	jal	ra,80005122 <printf>
  return 0;
    8000266c:	4501                	li	a0,0
}
    8000266e:	60a6                	ld	ra,72(sp)
    80002670:	6406                	ld	s0,64(sp)
    80002672:	74e2                	ld	s1,56(sp)
    80002674:	7942                	ld	s2,48(sp)
    80002676:	79a2                	ld	s3,40(sp)
    80002678:	7a02                	ld	s4,32(sp)
    8000267a:	6ae2                	ld	s5,24(sp)
    8000267c:	6b42                	ld	s6,16(sp)
    8000267e:	6ba2                	ld	s7,8(sp)
    80002680:	6161                	addi	sp,sp,80
    80002682:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002684:	04000613          	li	a2,64
    80002688:	4581                	li	a1,0
    8000268a:	854e                	mv	a0,s3
    8000268c:	ac1fd0ef          	jal	ra,8000014c <memset>
      dip->type = type;
    80002690:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002694:	854a                	mv	a0,s2
    80002696:	2d5000ef          	jal	ra,8000316a <log_write>
      brelse(bp);
    8000269a:	854a                	mv	a0,s2
    8000269c:	aabff0ef          	jal	ra,80002146 <brelse>
      return iget(dev, inum);
    800026a0:	85da                	mv	a1,s6
    800026a2:	8556                	mv	a0,s5
    800026a4:	de1ff0ef          	jal	ra,80002484 <iget>
    800026a8:	b7d9                	j	8000266e <ialloc+0x7a>

00000000800026aa <iupdate>:
{
    800026aa:	1101                	addi	sp,sp,-32
    800026ac:	ec06                	sd	ra,24(sp)
    800026ae:	e822                	sd	s0,16(sp)
    800026b0:	e426                	sd	s1,8(sp)
    800026b2:	e04a                	sd	s2,0(sp)
    800026b4:	1000                	addi	s0,sp,32
    800026b6:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800026b8:	415c                	lw	a5,4(a0)
    800026ba:	0047d79b          	srliw	a5,a5,0x4
    800026be:	00014597          	auipc	a1,0x14
    800026c2:	9925a583          	lw	a1,-1646(a1) # 80016050 <sb+0x18>
    800026c6:	9dbd                	addw	a1,a1,a5
    800026c8:	4108                	lw	a0,0(a0)
    800026ca:	975ff0ef          	jal	ra,8000203e <bread>
    800026ce:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800026d0:	05850793          	addi	a5,a0,88
    800026d4:	40c8                	lw	a0,4(s1)
    800026d6:	893d                	andi	a0,a0,15
    800026d8:	051a                	slli	a0,a0,0x6
    800026da:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    800026dc:	04449703          	lh	a4,68(s1)
    800026e0:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    800026e4:	04649703          	lh	a4,70(s1)
    800026e8:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    800026ec:	04849703          	lh	a4,72(s1)
    800026f0:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    800026f4:	04a49703          	lh	a4,74(s1)
    800026f8:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    800026fc:	44f8                	lw	a4,76(s1)
    800026fe:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002700:	03400613          	li	a2,52
    80002704:	05048593          	addi	a1,s1,80
    80002708:	0531                	addi	a0,a0,12
    8000270a:	a9ffd0ef          	jal	ra,800001a8 <memmove>
  log_write(bp);
    8000270e:	854a                	mv	a0,s2
    80002710:	25b000ef          	jal	ra,8000316a <log_write>
  brelse(bp);
    80002714:	854a                	mv	a0,s2
    80002716:	a31ff0ef          	jal	ra,80002146 <brelse>
}
    8000271a:	60e2                	ld	ra,24(sp)
    8000271c:	6442                	ld	s0,16(sp)
    8000271e:	64a2                	ld	s1,8(sp)
    80002720:	6902                	ld	s2,0(sp)
    80002722:	6105                	addi	sp,sp,32
    80002724:	8082                	ret

0000000080002726 <idup>:
{
    80002726:	1101                	addi	sp,sp,-32
    80002728:	ec06                	sd	ra,24(sp)
    8000272a:	e822                	sd	s0,16(sp)
    8000272c:	e426                	sd	s1,8(sp)
    8000272e:	1000                	addi	s0,sp,32
    80002730:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002732:	00014517          	auipc	a0,0x14
    80002736:	92650513          	addi	a0,a0,-1754 # 80016058 <itable>
    8000273a:	7b1020ef          	jal	ra,800056ea <acquire>
  ip->ref++;
    8000273e:	449c                	lw	a5,8(s1)
    80002740:	2785                	addiw	a5,a5,1
    80002742:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002744:	00014517          	auipc	a0,0x14
    80002748:	91450513          	addi	a0,a0,-1772 # 80016058 <itable>
    8000274c:	036030ef          	jal	ra,80005782 <release>
}
    80002750:	8526                	mv	a0,s1
    80002752:	60e2                	ld	ra,24(sp)
    80002754:	6442                	ld	s0,16(sp)
    80002756:	64a2                	ld	s1,8(sp)
    80002758:	6105                	addi	sp,sp,32
    8000275a:	8082                	ret

000000008000275c <ilock>:
{
    8000275c:	1101                	addi	sp,sp,-32
    8000275e:	ec06                	sd	ra,24(sp)
    80002760:	e822                	sd	s0,16(sp)
    80002762:	e426                	sd	s1,8(sp)
    80002764:	e04a                	sd	s2,0(sp)
    80002766:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002768:	c105                	beqz	a0,80002788 <ilock+0x2c>
    8000276a:	84aa                	mv	s1,a0
    8000276c:	451c                	lw	a5,8(a0)
    8000276e:	00f05d63          	blez	a5,80002788 <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002772:	0541                	addi	a0,a0,16
    80002774:	2ff000ef          	jal	ra,80003272 <acquiresleep>
  if(ip->valid == 0){
    80002778:	40bc                	lw	a5,64(s1)
    8000277a:	cf89                	beqz	a5,80002794 <ilock+0x38>
}
    8000277c:	60e2                	ld	ra,24(sp)
    8000277e:	6442                	ld	s0,16(sp)
    80002780:	64a2                	ld	s1,8(sp)
    80002782:	6902                	ld	s2,0(sp)
    80002784:	6105                	addi	sp,sp,32
    80002786:	8082                	ret
    panic("ilock");
    80002788:	00005517          	auipc	a0,0x5
    8000278c:	e1850513          	addi	a0,a0,-488 # 800075a0 <syscalls+0x188>
    80002790:	447020ef          	jal	ra,800053d6 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002794:	40dc                	lw	a5,4(s1)
    80002796:	0047d79b          	srliw	a5,a5,0x4
    8000279a:	00014597          	auipc	a1,0x14
    8000279e:	8b65a583          	lw	a1,-1866(a1) # 80016050 <sb+0x18>
    800027a2:	9dbd                	addw	a1,a1,a5
    800027a4:	4088                	lw	a0,0(s1)
    800027a6:	899ff0ef          	jal	ra,8000203e <bread>
    800027aa:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800027ac:	05850593          	addi	a1,a0,88
    800027b0:	40dc                	lw	a5,4(s1)
    800027b2:	8bbd                	andi	a5,a5,15
    800027b4:	079a                	slli	a5,a5,0x6
    800027b6:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800027b8:	00059783          	lh	a5,0(a1)
    800027bc:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800027c0:	00259783          	lh	a5,2(a1)
    800027c4:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800027c8:	00459783          	lh	a5,4(a1)
    800027cc:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800027d0:	00659783          	lh	a5,6(a1)
    800027d4:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800027d8:	459c                	lw	a5,8(a1)
    800027da:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800027dc:	03400613          	li	a2,52
    800027e0:	05b1                	addi	a1,a1,12
    800027e2:	05048513          	addi	a0,s1,80
    800027e6:	9c3fd0ef          	jal	ra,800001a8 <memmove>
    brelse(bp);
    800027ea:	854a                	mv	a0,s2
    800027ec:	95bff0ef          	jal	ra,80002146 <brelse>
    ip->valid = 1;
    800027f0:	4785                	li	a5,1
    800027f2:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800027f4:	04449783          	lh	a5,68(s1)
    800027f8:	f3d1                	bnez	a5,8000277c <ilock+0x20>
      panic("ilock: no type");
    800027fa:	00005517          	auipc	a0,0x5
    800027fe:	dae50513          	addi	a0,a0,-594 # 800075a8 <syscalls+0x190>
    80002802:	3d5020ef          	jal	ra,800053d6 <panic>

0000000080002806 <iunlock>:
{
    80002806:	1101                	addi	sp,sp,-32
    80002808:	ec06                	sd	ra,24(sp)
    8000280a:	e822                	sd	s0,16(sp)
    8000280c:	e426                	sd	s1,8(sp)
    8000280e:	e04a                	sd	s2,0(sp)
    80002810:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002812:	c505                	beqz	a0,8000283a <iunlock+0x34>
    80002814:	84aa                	mv	s1,a0
    80002816:	01050913          	addi	s2,a0,16
    8000281a:	854a                	mv	a0,s2
    8000281c:	2d5000ef          	jal	ra,800032f0 <holdingsleep>
    80002820:	cd09                	beqz	a0,8000283a <iunlock+0x34>
    80002822:	449c                	lw	a5,8(s1)
    80002824:	00f05b63          	blez	a5,8000283a <iunlock+0x34>
  releasesleep(&ip->lock);
    80002828:	854a                	mv	a0,s2
    8000282a:	28f000ef          	jal	ra,800032b8 <releasesleep>
}
    8000282e:	60e2                	ld	ra,24(sp)
    80002830:	6442                	ld	s0,16(sp)
    80002832:	64a2                	ld	s1,8(sp)
    80002834:	6902                	ld	s2,0(sp)
    80002836:	6105                	addi	sp,sp,32
    80002838:	8082                	ret
    panic("iunlock");
    8000283a:	00005517          	auipc	a0,0x5
    8000283e:	d7e50513          	addi	a0,a0,-642 # 800075b8 <syscalls+0x1a0>
    80002842:	395020ef          	jal	ra,800053d6 <panic>

0000000080002846 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002846:	7179                	addi	sp,sp,-48
    80002848:	f406                	sd	ra,40(sp)
    8000284a:	f022                	sd	s0,32(sp)
    8000284c:	ec26                	sd	s1,24(sp)
    8000284e:	e84a                	sd	s2,16(sp)
    80002850:	e44e                	sd	s3,8(sp)
    80002852:	e052                	sd	s4,0(sp)
    80002854:	1800                	addi	s0,sp,48
    80002856:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002858:	05050493          	addi	s1,a0,80
    8000285c:	08050913          	addi	s2,a0,128
    80002860:	a021                	j	80002868 <itrunc+0x22>
    80002862:	0491                	addi	s1,s1,4
    80002864:	01248b63          	beq	s1,s2,8000287a <itrunc+0x34>
    if(ip->addrs[i]){
    80002868:	408c                	lw	a1,0(s1)
    8000286a:	dde5                	beqz	a1,80002862 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    8000286c:	0009a503          	lw	a0,0(s3)
    80002870:	9c9ff0ef          	jal	ra,80002238 <bfree>
      ip->addrs[i] = 0;
    80002874:	0004a023          	sw	zero,0(s1)
    80002878:	b7ed                	j	80002862 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    8000287a:	0809a583          	lw	a1,128(s3)
    8000287e:	ed91                	bnez	a1,8000289a <itrunc+0x54>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002880:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002884:	854e                	mv	a0,s3
    80002886:	e25ff0ef          	jal	ra,800026aa <iupdate>
}
    8000288a:	70a2                	ld	ra,40(sp)
    8000288c:	7402                	ld	s0,32(sp)
    8000288e:	64e2                	ld	s1,24(sp)
    80002890:	6942                	ld	s2,16(sp)
    80002892:	69a2                	ld	s3,8(sp)
    80002894:	6a02                	ld	s4,0(sp)
    80002896:	6145                	addi	sp,sp,48
    80002898:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    8000289a:	0009a503          	lw	a0,0(s3)
    8000289e:	fa0ff0ef          	jal	ra,8000203e <bread>
    800028a2:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800028a4:	05850493          	addi	s1,a0,88
    800028a8:	45850913          	addi	s2,a0,1112
    800028ac:	a021                	j	800028b4 <itrunc+0x6e>
    800028ae:	0491                	addi	s1,s1,4
    800028b0:	01248963          	beq	s1,s2,800028c2 <itrunc+0x7c>
      if(a[j])
    800028b4:	408c                	lw	a1,0(s1)
    800028b6:	dde5                	beqz	a1,800028ae <itrunc+0x68>
        bfree(ip->dev, a[j]);
    800028b8:	0009a503          	lw	a0,0(s3)
    800028bc:	97dff0ef          	jal	ra,80002238 <bfree>
    800028c0:	b7fd                	j	800028ae <itrunc+0x68>
    brelse(bp);
    800028c2:	8552                	mv	a0,s4
    800028c4:	883ff0ef          	jal	ra,80002146 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800028c8:	0809a583          	lw	a1,128(s3)
    800028cc:	0009a503          	lw	a0,0(s3)
    800028d0:	969ff0ef          	jal	ra,80002238 <bfree>
    ip->addrs[NDIRECT] = 0;
    800028d4:	0809a023          	sw	zero,128(s3)
    800028d8:	b765                	j	80002880 <itrunc+0x3a>

00000000800028da <iput>:
{
    800028da:	1101                	addi	sp,sp,-32
    800028dc:	ec06                	sd	ra,24(sp)
    800028de:	e822                	sd	s0,16(sp)
    800028e0:	e426                	sd	s1,8(sp)
    800028e2:	e04a                	sd	s2,0(sp)
    800028e4:	1000                	addi	s0,sp,32
    800028e6:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800028e8:	00013517          	auipc	a0,0x13
    800028ec:	77050513          	addi	a0,a0,1904 # 80016058 <itable>
    800028f0:	5fb020ef          	jal	ra,800056ea <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800028f4:	4498                	lw	a4,8(s1)
    800028f6:	4785                	li	a5,1
    800028f8:	02f70163          	beq	a4,a5,8000291a <iput+0x40>
  ip->ref--;
    800028fc:	449c                	lw	a5,8(s1)
    800028fe:	37fd                	addiw	a5,a5,-1
    80002900:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002902:	00013517          	auipc	a0,0x13
    80002906:	75650513          	addi	a0,a0,1878 # 80016058 <itable>
    8000290a:	679020ef          	jal	ra,80005782 <release>
}
    8000290e:	60e2                	ld	ra,24(sp)
    80002910:	6442                	ld	s0,16(sp)
    80002912:	64a2                	ld	s1,8(sp)
    80002914:	6902                	ld	s2,0(sp)
    80002916:	6105                	addi	sp,sp,32
    80002918:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000291a:	40bc                	lw	a5,64(s1)
    8000291c:	d3e5                	beqz	a5,800028fc <iput+0x22>
    8000291e:	04a49783          	lh	a5,74(s1)
    80002922:	ffe9                	bnez	a5,800028fc <iput+0x22>
    acquiresleep(&ip->lock);
    80002924:	01048913          	addi	s2,s1,16
    80002928:	854a                	mv	a0,s2
    8000292a:	149000ef          	jal	ra,80003272 <acquiresleep>
    release(&itable.lock);
    8000292e:	00013517          	auipc	a0,0x13
    80002932:	72a50513          	addi	a0,a0,1834 # 80016058 <itable>
    80002936:	64d020ef          	jal	ra,80005782 <release>
    itrunc(ip);
    8000293a:	8526                	mv	a0,s1
    8000293c:	f0bff0ef          	jal	ra,80002846 <itrunc>
    ip->type = 0;
    80002940:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002944:	8526                	mv	a0,s1
    80002946:	d65ff0ef          	jal	ra,800026aa <iupdate>
    ip->valid = 0;
    8000294a:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    8000294e:	854a                	mv	a0,s2
    80002950:	169000ef          	jal	ra,800032b8 <releasesleep>
    acquire(&itable.lock);
    80002954:	00013517          	auipc	a0,0x13
    80002958:	70450513          	addi	a0,a0,1796 # 80016058 <itable>
    8000295c:	58f020ef          	jal	ra,800056ea <acquire>
    80002960:	bf71                	j	800028fc <iput+0x22>

0000000080002962 <iunlockput>:
{
    80002962:	1101                	addi	sp,sp,-32
    80002964:	ec06                	sd	ra,24(sp)
    80002966:	e822                	sd	s0,16(sp)
    80002968:	e426                	sd	s1,8(sp)
    8000296a:	1000                	addi	s0,sp,32
    8000296c:	84aa                	mv	s1,a0
  iunlock(ip);
    8000296e:	e99ff0ef          	jal	ra,80002806 <iunlock>
  iput(ip);
    80002972:	8526                	mv	a0,s1
    80002974:	f67ff0ef          	jal	ra,800028da <iput>
}
    80002978:	60e2                	ld	ra,24(sp)
    8000297a:	6442                	ld	s0,16(sp)
    8000297c:	64a2                	ld	s1,8(sp)
    8000297e:	6105                	addi	sp,sp,32
    80002980:	8082                	ret

0000000080002982 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002982:	1141                	addi	sp,sp,-16
    80002984:	e422                	sd	s0,8(sp)
    80002986:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002988:	411c                	lw	a5,0(a0)
    8000298a:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    8000298c:	415c                	lw	a5,4(a0)
    8000298e:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002990:	04451783          	lh	a5,68(a0)
    80002994:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002998:	04a51783          	lh	a5,74(a0)
    8000299c:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800029a0:	04c56783          	lwu	a5,76(a0)
    800029a4:	e99c                	sd	a5,16(a1)
}
    800029a6:	6422                	ld	s0,8(sp)
    800029a8:	0141                	addi	sp,sp,16
    800029aa:	8082                	ret

00000000800029ac <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800029ac:	457c                	lw	a5,76(a0)
    800029ae:	0cd7ef63          	bltu	a5,a3,80002a8c <readi+0xe0>
{
    800029b2:	7159                	addi	sp,sp,-112
    800029b4:	f486                	sd	ra,104(sp)
    800029b6:	f0a2                	sd	s0,96(sp)
    800029b8:	eca6                	sd	s1,88(sp)
    800029ba:	e8ca                	sd	s2,80(sp)
    800029bc:	e4ce                	sd	s3,72(sp)
    800029be:	e0d2                	sd	s4,64(sp)
    800029c0:	fc56                	sd	s5,56(sp)
    800029c2:	f85a                	sd	s6,48(sp)
    800029c4:	f45e                	sd	s7,40(sp)
    800029c6:	f062                	sd	s8,32(sp)
    800029c8:	ec66                	sd	s9,24(sp)
    800029ca:	e86a                	sd	s10,16(sp)
    800029cc:	e46e                	sd	s11,8(sp)
    800029ce:	1880                	addi	s0,sp,112
    800029d0:	8b2a                	mv	s6,a0
    800029d2:	8bae                	mv	s7,a1
    800029d4:	8a32                	mv	s4,a2
    800029d6:	84b6                	mv	s1,a3
    800029d8:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    800029da:	9f35                	addw	a4,a4,a3
    return 0;
    800029dc:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800029de:	08d76663          	bltu	a4,a3,80002a6a <readi+0xbe>
  if(off + n > ip->size)
    800029e2:	00e7f463          	bgeu	a5,a4,800029ea <readi+0x3e>
    n = ip->size - off;
    800029e6:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800029ea:	080a8f63          	beqz	s5,80002a88 <readi+0xdc>
    800029ee:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800029f0:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800029f4:	5c7d                	li	s8,-1
    800029f6:	a80d                	j	80002a28 <readi+0x7c>
    800029f8:	020d1d93          	slli	s11,s10,0x20
    800029fc:	020ddd93          	srli	s11,s11,0x20
    80002a00:	05890793          	addi	a5,s2,88
    80002a04:	86ee                	mv	a3,s11
    80002a06:	963e                	add	a2,a2,a5
    80002a08:	85d2                	mv	a1,s4
    80002a0a:	855e                	mv	a0,s7
    80002a0c:	d01fe0ef          	jal	ra,8000170c <either_copyout>
    80002a10:	05850763          	beq	a0,s8,80002a5e <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002a14:	854a                	mv	a0,s2
    80002a16:	f30ff0ef          	jal	ra,80002146 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002a1a:	013d09bb          	addw	s3,s10,s3
    80002a1e:	009d04bb          	addw	s1,s10,s1
    80002a22:	9a6e                	add	s4,s4,s11
    80002a24:	0559f163          	bgeu	s3,s5,80002a66 <readi+0xba>
    uint addr = bmap(ip, off/BSIZE);
    80002a28:	00a4d59b          	srliw	a1,s1,0xa
    80002a2c:	855a                	mv	a0,s6
    80002a2e:	98bff0ef          	jal	ra,800023b8 <bmap>
    80002a32:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002a36:	c985                	beqz	a1,80002a66 <readi+0xba>
    bp = bread(ip->dev, addr);
    80002a38:	000b2503          	lw	a0,0(s6)
    80002a3c:	e02ff0ef          	jal	ra,8000203e <bread>
    80002a40:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002a42:	3ff4f613          	andi	a2,s1,1023
    80002a46:	40cc87bb          	subw	a5,s9,a2
    80002a4a:	413a873b          	subw	a4,s5,s3
    80002a4e:	8d3e                	mv	s10,a5
    80002a50:	2781                	sext.w	a5,a5
    80002a52:	0007069b          	sext.w	a3,a4
    80002a56:	faf6f1e3          	bgeu	a3,a5,800029f8 <readi+0x4c>
    80002a5a:	8d3a                	mv	s10,a4
    80002a5c:	bf71                	j	800029f8 <readi+0x4c>
      brelse(bp);
    80002a5e:	854a                	mv	a0,s2
    80002a60:	ee6ff0ef          	jal	ra,80002146 <brelse>
      tot = -1;
    80002a64:	59fd                	li	s3,-1
  }
  return tot;
    80002a66:	0009851b          	sext.w	a0,s3
}
    80002a6a:	70a6                	ld	ra,104(sp)
    80002a6c:	7406                	ld	s0,96(sp)
    80002a6e:	64e6                	ld	s1,88(sp)
    80002a70:	6946                	ld	s2,80(sp)
    80002a72:	69a6                	ld	s3,72(sp)
    80002a74:	6a06                	ld	s4,64(sp)
    80002a76:	7ae2                	ld	s5,56(sp)
    80002a78:	7b42                	ld	s6,48(sp)
    80002a7a:	7ba2                	ld	s7,40(sp)
    80002a7c:	7c02                	ld	s8,32(sp)
    80002a7e:	6ce2                	ld	s9,24(sp)
    80002a80:	6d42                	ld	s10,16(sp)
    80002a82:	6da2                	ld	s11,8(sp)
    80002a84:	6165                	addi	sp,sp,112
    80002a86:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002a88:	89d6                	mv	s3,s5
    80002a8a:	bff1                	j	80002a66 <readi+0xba>
    return 0;
    80002a8c:	4501                	li	a0,0
}
    80002a8e:	8082                	ret

0000000080002a90 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002a90:	457c                	lw	a5,76(a0)
    80002a92:	0ed7ea63          	bltu	a5,a3,80002b86 <writei+0xf6>
{
    80002a96:	7159                	addi	sp,sp,-112
    80002a98:	f486                	sd	ra,104(sp)
    80002a9a:	f0a2                	sd	s0,96(sp)
    80002a9c:	eca6                	sd	s1,88(sp)
    80002a9e:	e8ca                	sd	s2,80(sp)
    80002aa0:	e4ce                	sd	s3,72(sp)
    80002aa2:	e0d2                	sd	s4,64(sp)
    80002aa4:	fc56                	sd	s5,56(sp)
    80002aa6:	f85a                	sd	s6,48(sp)
    80002aa8:	f45e                	sd	s7,40(sp)
    80002aaa:	f062                	sd	s8,32(sp)
    80002aac:	ec66                	sd	s9,24(sp)
    80002aae:	e86a                	sd	s10,16(sp)
    80002ab0:	e46e                	sd	s11,8(sp)
    80002ab2:	1880                	addi	s0,sp,112
    80002ab4:	8aaa                	mv	s5,a0
    80002ab6:	8bae                	mv	s7,a1
    80002ab8:	8a32                	mv	s4,a2
    80002aba:	8936                	mv	s2,a3
    80002abc:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002abe:	00e687bb          	addw	a5,a3,a4
    80002ac2:	0cd7e463          	bltu	a5,a3,80002b8a <writei+0xfa>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002ac6:	00043737          	lui	a4,0x43
    80002aca:	0cf76263          	bltu	a4,a5,80002b8e <writei+0xfe>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002ace:	0a0b0a63          	beqz	s6,80002b82 <writei+0xf2>
    80002ad2:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ad4:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002ad8:	5c7d                	li	s8,-1
    80002ada:	a825                	j	80002b12 <writei+0x82>
    80002adc:	020d1d93          	slli	s11,s10,0x20
    80002ae0:	020ddd93          	srli	s11,s11,0x20
    80002ae4:	05848793          	addi	a5,s1,88
    80002ae8:	86ee                	mv	a3,s11
    80002aea:	8652                	mv	a2,s4
    80002aec:	85de                	mv	a1,s7
    80002aee:	953e                	add	a0,a0,a5
    80002af0:	c67fe0ef          	jal	ra,80001756 <either_copyin>
    80002af4:	05850a63          	beq	a0,s8,80002b48 <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002af8:	8526                	mv	a0,s1
    80002afa:	670000ef          	jal	ra,8000316a <log_write>
    brelse(bp);
    80002afe:	8526                	mv	a0,s1
    80002b00:	e46ff0ef          	jal	ra,80002146 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002b04:	013d09bb          	addw	s3,s10,s3
    80002b08:	012d093b          	addw	s2,s10,s2
    80002b0c:	9a6e                	add	s4,s4,s11
    80002b0e:	0569f063          	bgeu	s3,s6,80002b4e <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002b12:	00a9559b          	srliw	a1,s2,0xa
    80002b16:	8556                	mv	a0,s5
    80002b18:	8a1ff0ef          	jal	ra,800023b8 <bmap>
    80002b1c:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002b20:	c59d                	beqz	a1,80002b4e <writei+0xbe>
    bp = bread(ip->dev, addr);
    80002b22:	000aa503          	lw	a0,0(s5)
    80002b26:	d18ff0ef          	jal	ra,8000203e <bread>
    80002b2a:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002b2c:	3ff97513          	andi	a0,s2,1023
    80002b30:	40ac87bb          	subw	a5,s9,a0
    80002b34:	413b073b          	subw	a4,s6,s3
    80002b38:	8d3e                	mv	s10,a5
    80002b3a:	2781                	sext.w	a5,a5
    80002b3c:	0007069b          	sext.w	a3,a4
    80002b40:	f8f6fee3          	bgeu	a3,a5,80002adc <writei+0x4c>
    80002b44:	8d3a                	mv	s10,a4
    80002b46:	bf59                	j	80002adc <writei+0x4c>
      brelse(bp);
    80002b48:	8526                	mv	a0,s1
    80002b4a:	dfcff0ef          	jal	ra,80002146 <brelse>
  }

  if(off > ip->size)
    80002b4e:	04caa783          	lw	a5,76(s5)
    80002b52:	0127f463          	bgeu	a5,s2,80002b5a <writei+0xca>
    ip->size = off;
    80002b56:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002b5a:	8556                	mv	a0,s5
    80002b5c:	b4fff0ef          	jal	ra,800026aa <iupdate>

  return tot;
    80002b60:	0009851b          	sext.w	a0,s3
}
    80002b64:	70a6                	ld	ra,104(sp)
    80002b66:	7406                	ld	s0,96(sp)
    80002b68:	64e6                	ld	s1,88(sp)
    80002b6a:	6946                	ld	s2,80(sp)
    80002b6c:	69a6                	ld	s3,72(sp)
    80002b6e:	6a06                	ld	s4,64(sp)
    80002b70:	7ae2                	ld	s5,56(sp)
    80002b72:	7b42                	ld	s6,48(sp)
    80002b74:	7ba2                	ld	s7,40(sp)
    80002b76:	7c02                	ld	s8,32(sp)
    80002b78:	6ce2                	ld	s9,24(sp)
    80002b7a:	6d42                	ld	s10,16(sp)
    80002b7c:	6da2                	ld	s11,8(sp)
    80002b7e:	6165                	addi	sp,sp,112
    80002b80:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002b82:	89da                	mv	s3,s6
    80002b84:	bfd9                	j	80002b5a <writei+0xca>
    return -1;
    80002b86:	557d                	li	a0,-1
}
    80002b88:	8082                	ret
    return -1;
    80002b8a:	557d                	li	a0,-1
    80002b8c:	bfe1                	j	80002b64 <writei+0xd4>
    return -1;
    80002b8e:	557d                	li	a0,-1
    80002b90:	bfd1                	j	80002b64 <writei+0xd4>

0000000080002b92 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002b92:	1141                	addi	sp,sp,-16
    80002b94:	e406                	sd	ra,8(sp)
    80002b96:	e022                	sd	s0,0(sp)
    80002b98:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002b9a:	4639                	li	a2,14
    80002b9c:	e7cfd0ef          	jal	ra,80000218 <strncmp>
}
    80002ba0:	60a2                	ld	ra,8(sp)
    80002ba2:	6402                	ld	s0,0(sp)
    80002ba4:	0141                	addi	sp,sp,16
    80002ba6:	8082                	ret

0000000080002ba8 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002ba8:	7139                	addi	sp,sp,-64
    80002baa:	fc06                	sd	ra,56(sp)
    80002bac:	f822                	sd	s0,48(sp)
    80002bae:	f426                	sd	s1,40(sp)
    80002bb0:	f04a                	sd	s2,32(sp)
    80002bb2:	ec4e                	sd	s3,24(sp)
    80002bb4:	e852                	sd	s4,16(sp)
    80002bb6:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002bb8:	04451703          	lh	a4,68(a0)
    80002bbc:	4785                	li	a5,1
    80002bbe:	00f71a63          	bne	a4,a5,80002bd2 <dirlookup+0x2a>
    80002bc2:	892a                	mv	s2,a0
    80002bc4:	89ae                	mv	s3,a1
    80002bc6:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002bc8:	457c                	lw	a5,76(a0)
    80002bca:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002bcc:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002bce:	e39d                	bnez	a5,80002bf4 <dirlookup+0x4c>
    80002bd0:	a095                	j	80002c34 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80002bd2:	00005517          	auipc	a0,0x5
    80002bd6:	9ee50513          	addi	a0,a0,-1554 # 800075c0 <syscalls+0x1a8>
    80002bda:	7fc020ef          	jal	ra,800053d6 <panic>
      panic("dirlookup read");
    80002bde:	00005517          	auipc	a0,0x5
    80002be2:	9fa50513          	addi	a0,a0,-1542 # 800075d8 <syscalls+0x1c0>
    80002be6:	7f0020ef          	jal	ra,800053d6 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002bea:	24c1                	addiw	s1,s1,16
    80002bec:	04c92783          	lw	a5,76(s2)
    80002bf0:	04f4f163          	bgeu	s1,a5,80002c32 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002bf4:	4741                	li	a4,16
    80002bf6:	86a6                	mv	a3,s1
    80002bf8:	fc040613          	addi	a2,s0,-64
    80002bfc:	4581                	li	a1,0
    80002bfe:	854a                	mv	a0,s2
    80002c00:	dadff0ef          	jal	ra,800029ac <readi>
    80002c04:	47c1                	li	a5,16
    80002c06:	fcf51ce3          	bne	a0,a5,80002bde <dirlookup+0x36>
    if(de.inum == 0)
    80002c0a:	fc045783          	lhu	a5,-64(s0)
    80002c0e:	dff1                	beqz	a5,80002bea <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80002c10:	fc240593          	addi	a1,s0,-62
    80002c14:	854e                	mv	a0,s3
    80002c16:	f7dff0ef          	jal	ra,80002b92 <namecmp>
    80002c1a:	f961                	bnez	a0,80002bea <dirlookup+0x42>
      if(poff)
    80002c1c:	000a0463          	beqz	s4,80002c24 <dirlookup+0x7c>
        *poff = off;
    80002c20:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80002c24:	fc045583          	lhu	a1,-64(s0)
    80002c28:	00092503          	lw	a0,0(s2)
    80002c2c:	859ff0ef          	jal	ra,80002484 <iget>
    80002c30:	a011                	j	80002c34 <dirlookup+0x8c>
  return 0;
    80002c32:	4501                	li	a0,0
}
    80002c34:	70e2                	ld	ra,56(sp)
    80002c36:	7442                	ld	s0,48(sp)
    80002c38:	74a2                	ld	s1,40(sp)
    80002c3a:	7902                	ld	s2,32(sp)
    80002c3c:	69e2                	ld	s3,24(sp)
    80002c3e:	6a42                	ld	s4,16(sp)
    80002c40:	6121                	addi	sp,sp,64
    80002c42:	8082                	ret

0000000080002c44 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002c44:	711d                	addi	sp,sp,-96
    80002c46:	ec86                	sd	ra,88(sp)
    80002c48:	e8a2                	sd	s0,80(sp)
    80002c4a:	e4a6                	sd	s1,72(sp)
    80002c4c:	e0ca                	sd	s2,64(sp)
    80002c4e:	fc4e                	sd	s3,56(sp)
    80002c50:	f852                	sd	s4,48(sp)
    80002c52:	f456                	sd	s5,40(sp)
    80002c54:	f05a                	sd	s6,32(sp)
    80002c56:	ec5e                	sd	s7,24(sp)
    80002c58:	e862                	sd	s8,16(sp)
    80002c5a:	e466                	sd	s9,8(sp)
    80002c5c:	1080                	addi	s0,sp,96
    80002c5e:	84aa                	mv	s1,a0
    80002c60:	8aae                	mv	s5,a1
    80002c62:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002c64:	00054703          	lbu	a4,0(a0)
    80002c68:	02f00793          	li	a5,47
    80002c6c:	00f70f63          	beq	a4,a5,80002c8a <namex+0x46>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002c70:	8e2fe0ef          	jal	ra,80000d52 <myproc>
    80002c74:	15853503          	ld	a0,344(a0)
    80002c78:	aafff0ef          	jal	ra,80002726 <idup>
    80002c7c:	89aa                	mv	s3,a0
  while(*path == '/')
    80002c7e:	02f00913          	li	s2,47
  len = path - s;
    80002c82:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    80002c84:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002c86:	4b85                	li	s7,1
    80002c88:	a861                	j	80002d20 <namex+0xdc>
    ip = iget(ROOTDEV, ROOTINO);
    80002c8a:	4585                	li	a1,1
    80002c8c:	4505                	li	a0,1
    80002c8e:	ff6ff0ef          	jal	ra,80002484 <iget>
    80002c92:	89aa                	mv	s3,a0
    80002c94:	b7ed                	j	80002c7e <namex+0x3a>
      iunlockput(ip);
    80002c96:	854e                	mv	a0,s3
    80002c98:	ccbff0ef          	jal	ra,80002962 <iunlockput>
      return 0;
    80002c9c:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002c9e:	854e                	mv	a0,s3
    80002ca0:	60e6                	ld	ra,88(sp)
    80002ca2:	6446                	ld	s0,80(sp)
    80002ca4:	64a6                	ld	s1,72(sp)
    80002ca6:	6906                	ld	s2,64(sp)
    80002ca8:	79e2                	ld	s3,56(sp)
    80002caa:	7a42                	ld	s4,48(sp)
    80002cac:	7aa2                	ld	s5,40(sp)
    80002cae:	7b02                	ld	s6,32(sp)
    80002cb0:	6be2                	ld	s7,24(sp)
    80002cb2:	6c42                	ld	s8,16(sp)
    80002cb4:	6ca2                	ld	s9,8(sp)
    80002cb6:	6125                	addi	sp,sp,96
    80002cb8:	8082                	ret
      iunlock(ip);
    80002cba:	854e                	mv	a0,s3
    80002cbc:	b4bff0ef          	jal	ra,80002806 <iunlock>
      return ip;
    80002cc0:	bff9                	j	80002c9e <namex+0x5a>
      iunlockput(ip);
    80002cc2:	854e                	mv	a0,s3
    80002cc4:	c9fff0ef          	jal	ra,80002962 <iunlockput>
      return 0;
    80002cc8:	89e6                	mv	s3,s9
    80002cca:	bfd1                	j	80002c9e <namex+0x5a>
  len = path - s;
    80002ccc:	40b48633          	sub	a2,s1,a1
    80002cd0:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80002cd4:	079c5c63          	bge	s8,s9,80002d4c <namex+0x108>
    memmove(name, s, DIRSIZ);
    80002cd8:	4639                	li	a2,14
    80002cda:	8552                	mv	a0,s4
    80002cdc:	cccfd0ef          	jal	ra,800001a8 <memmove>
  while(*path == '/')
    80002ce0:	0004c783          	lbu	a5,0(s1)
    80002ce4:	01279763          	bne	a5,s2,80002cf2 <namex+0xae>
    path++;
    80002ce8:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002cea:	0004c783          	lbu	a5,0(s1)
    80002cee:	ff278de3          	beq	a5,s2,80002ce8 <namex+0xa4>
    ilock(ip);
    80002cf2:	854e                	mv	a0,s3
    80002cf4:	a69ff0ef          	jal	ra,8000275c <ilock>
    if(ip->type != T_DIR){
    80002cf8:	04499783          	lh	a5,68(s3)
    80002cfc:	f9779de3          	bne	a5,s7,80002c96 <namex+0x52>
    if(nameiparent && *path == '\0'){
    80002d00:	000a8563          	beqz	s5,80002d0a <namex+0xc6>
    80002d04:	0004c783          	lbu	a5,0(s1)
    80002d08:	dbcd                	beqz	a5,80002cba <namex+0x76>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002d0a:	865a                	mv	a2,s6
    80002d0c:	85d2                	mv	a1,s4
    80002d0e:	854e                	mv	a0,s3
    80002d10:	e99ff0ef          	jal	ra,80002ba8 <dirlookup>
    80002d14:	8caa                	mv	s9,a0
    80002d16:	d555                	beqz	a0,80002cc2 <namex+0x7e>
    iunlockput(ip);
    80002d18:	854e                	mv	a0,s3
    80002d1a:	c49ff0ef          	jal	ra,80002962 <iunlockput>
    ip = next;
    80002d1e:	89e6                	mv	s3,s9
  while(*path == '/')
    80002d20:	0004c783          	lbu	a5,0(s1)
    80002d24:	05279363          	bne	a5,s2,80002d6a <namex+0x126>
    path++;
    80002d28:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002d2a:	0004c783          	lbu	a5,0(s1)
    80002d2e:	ff278de3          	beq	a5,s2,80002d28 <namex+0xe4>
  if(*path == 0)
    80002d32:	c78d                	beqz	a5,80002d5c <namex+0x118>
    path++;
    80002d34:	85a6                	mv	a1,s1
  len = path - s;
    80002d36:	8cda                	mv	s9,s6
    80002d38:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    80002d3a:	01278963          	beq	a5,s2,80002d4c <namex+0x108>
    80002d3e:	d7d9                	beqz	a5,80002ccc <namex+0x88>
    path++;
    80002d40:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80002d42:	0004c783          	lbu	a5,0(s1)
    80002d46:	ff279ce3          	bne	a5,s2,80002d3e <namex+0xfa>
    80002d4a:	b749                	j	80002ccc <namex+0x88>
    memmove(name, s, len);
    80002d4c:	2601                	sext.w	a2,a2
    80002d4e:	8552                	mv	a0,s4
    80002d50:	c58fd0ef          	jal	ra,800001a8 <memmove>
    name[len] = 0;
    80002d54:	9cd2                	add	s9,s9,s4
    80002d56:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80002d5a:	b759                	j	80002ce0 <namex+0x9c>
  if(nameiparent){
    80002d5c:	f40a81e3          	beqz	s5,80002c9e <namex+0x5a>
    iput(ip);
    80002d60:	854e                	mv	a0,s3
    80002d62:	b79ff0ef          	jal	ra,800028da <iput>
    return 0;
    80002d66:	4981                	li	s3,0
    80002d68:	bf1d                	j	80002c9e <namex+0x5a>
  if(*path == 0)
    80002d6a:	dbed                	beqz	a5,80002d5c <namex+0x118>
  while(*path != '/' && *path != 0)
    80002d6c:	0004c783          	lbu	a5,0(s1)
    80002d70:	85a6                	mv	a1,s1
    80002d72:	b7f1                	j	80002d3e <namex+0xfa>

0000000080002d74 <dirlink>:
{
    80002d74:	7139                	addi	sp,sp,-64
    80002d76:	fc06                	sd	ra,56(sp)
    80002d78:	f822                	sd	s0,48(sp)
    80002d7a:	f426                	sd	s1,40(sp)
    80002d7c:	f04a                	sd	s2,32(sp)
    80002d7e:	ec4e                	sd	s3,24(sp)
    80002d80:	e852                	sd	s4,16(sp)
    80002d82:	0080                	addi	s0,sp,64
    80002d84:	892a                	mv	s2,a0
    80002d86:	8a2e                	mv	s4,a1
    80002d88:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002d8a:	4601                	li	a2,0
    80002d8c:	e1dff0ef          	jal	ra,80002ba8 <dirlookup>
    80002d90:	e52d                	bnez	a0,80002dfa <dirlink+0x86>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002d92:	04c92483          	lw	s1,76(s2)
    80002d96:	c48d                	beqz	s1,80002dc0 <dirlink+0x4c>
    80002d98:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002d9a:	4741                	li	a4,16
    80002d9c:	86a6                	mv	a3,s1
    80002d9e:	fc040613          	addi	a2,s0,-64
    80002da2:	4581                	li	a1,0
    80002da4:	854a                	mv	a0,s2
    80002da6:	c07ff0ef          	jal	ra,800029ac <readi>
    80002daa:	47c1                	li	a5,16
    80002dac:	04f51b63          	bne	a0,a5,80002e02 <dirlink+0x8e>
    if(de.inum == 0)
    80002db0:	fc045783          	lhu	a5,-64(s0)
    80002db4:	c791                	beqz	a5,80002dc0 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002db6:	24c1                	addiw	s1,s1,16
    80002db8:	04c92783          	lw	a5,76(s2)
    80002dbc:	fcf4efe3          	bltu	s1,a5,80002d9a <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80002dc0:	4639                	li	a2,14
    80002dc2:	85d2                	mv	a1,s4
    80002dc4:	fc240513          	addi	a0,s0,-62
    80002dc8:	c8cfd0ef          	jal	ra,80000254 <strncpy>
  de.inum = inum;
    80002dcc:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002dd0:	4741                	li	a4,16
    80002dd2:	86a6                	mv	a3,s1
    80002dd4:	fc040613          	addi	a2,s0,-64
    80002dd8:	4581                	li	a1,0
    80002dda:	854a                	mv	a0,s2
    80002ddc:	cb5ff0ef          	jal	ra,80002a90 <writei>
    80002de0:	1541                	addi	a0,a0,-16
    80002de2:	00a03533          	snez	a0,a0
    80002de6:	40a00533          	neg	a0,a0
}
    80002dea:	70e2                	ld	ra,56(sp)
    80002dec:	7442                	ld	s0,48(sp)
    80002dee:	74a2                	ld	s1,40(sp)
    80002df0:	7902                	ld	s2,32(sp)
    80002df2:	69e2                	ld	s3,24(sp)
    80002df4:	6a42                	ld	s4,16(sp)
    80002df6:	6121                	addi	sp,sp,64
    80002df8:	8082                	ret
    iput(ip);
    80002dfa:	ae1ff0ef          	jal	ra,800028da <iput>
    return -1;
    80002dfe:	557d                	li	a0,-1
    80002e00:	b7ed                	j	80002dea <dirlink+0x76>
      panic("dirlink read");
    80002e02:	00004517          	auipc	a0,0x4
    80002e06:	7e650513          	addi	a0,a0,2022 # 800075e8 <syscalls+0x1d0>
    80002e0a:	5cc020ef          	jal	ra,800053d6 <panic>

0000000080002e0e <namei>:

struct inode*
namei(char *path)
{
    80002e0e:	1101                	addi	sp,sp,-32
    80002e10:	ec06                	sd	ra,24(sp)
    80002e12:	e822                	sd	s0,16(sp)
    80002e14:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80002e16:	fe040613          	addi	a2,s0,-32
    80002e1a:	4581                	li	a1,0
    80002e1c:	e29ff0ef          	jal	ra,80002c44 <namex>
}
    80002e20:	60e2                	ld	ra,24(sp)
    80002e22:	6442                	ld	s0,16(sp)
    80002e24:	6105                	addi	sp,sp,32
    80002e26:	8082                	ret

0000000080002e28 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80002e28:	1141                	addi	sp,sp,-16
    80002e2a:	e406                	sd	ra,8(sp)
    80002e2c:	e022                	sd	s0,0(sp)
    80002e2e:	0800                	addi	s0,sp,16
    80002e30:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80002e32:	4585                	li	a1,1
    80002e34:	e11ff0ef          	jal	ra,80002c44 <namex>
}
    80002e38:	60a2                	ld	ra,8(sp)
    80002e3a:	6402                	ld	s0,0(sp)
    80002e3c:	0141                	addi	sp,sp,16
    80002e3e:	8082                	ret

0000000080002e40 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80002e40:	1101                	addi	sp,sp,-32
    80002e42:	ec06                	sd	ra,24(sp)
    80002e44:	e822                	sd	s0,16(sp)
    80002e46:	e426                	sd	s1,8(sp)
    80002e48:	e04a                	sd	s2,0(sp)
    80002e4a:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80002e4c:	00015917          	auipc	s2,0x15
    80002e50:	cb490913          	addi	s2,s2,-844 # 80017b00 <log>
    80002e54:	01892583          	lw	a1,24(s2)
    80002e58:	02892503          	lw	a0,40(s2)
    80002e5c:	9e2ff0ef          	jal	ra,8000203e <bread>
    80002e60:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80002e62:	02c92683          	lw	a3,44(s2)
    80002e66:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80002e68:	02d05763          	blez	a3,80002e96 <write_head+0x56>
    80002e6c:	00015797          	auipc	a5,0x15
    80002e70:	cc478793          	addi	a5,a5,-828 # 80017b30 <log+0x30>
    80002e74:	05c50713          	addi	a4,a0,92
    80002e78:	36fd                	addiw	a3,a3,-1
    80002e7a:	1682                	slli	a3,a3,0x20
    80002e7c:	9281                	srli	a3,a3,0x20
    80002e7e:	068a                	slli	a3,a3,0x2
    80002e80:	00015617          	auipc	a2,0x15
    80002e84:	cb460613          	addi	a2,a2,-844 # 80017b34 <log+0x34>
    80002e88:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80002e8a:	4390                	lw	a2,0(a5)
    80002e8c:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80002e8e:	0791                	addi	a5,a5,4
    80002e90:	0711                	addi	a4,a4,4
    80002e92:	fed79ce3          	bne	a5,a3,80002e8a <write_head+0x4a>
  }
  bwrite(buf);
    80002e96:	8526                	mv	a0,s1
    80002e98:	a7cff0ef          	jal	ra,80002114 <bwrite>
  brelse(buf);
    80002e9c:	8526                	mv	a0,s1
    80002e9e:	aa8ff0ef          	jal	ra,80002146 <brelse>
}
    80002ea2:	60e2                	ld	ra,24(sp)
    80002ea4:	6442                	ld	s0,16(sp)
    80002ea6:	64a2                	ld	s1,8(sp)
    80002ea8:	6902                	ld	s2,0(sp)
    80002eaa:	6105                	addi	sp,sp,32
    80002eac:	8082                	ret

0000000080002eae <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80002eae:	00015797          	auipc	a5,0x15
    80002eb2:	c7e7a783          	lw	a5,-898(a5) # 80017b2c <log+0x2c>
    80002eb6:	08f05f63          	blez	a5,80002f54 <install_trans+0xa6>
{
    80002eba:	7139                	addi	sp,sp,-64
    80002ebc:	fc06                	sd	ra,56(sp)
    80002ebe:	f822                	sd	s0,48(sp)
    80002ec0:	f426                	sd	s1,40(sp)
    80002ec2:	f04a                	sd	s2,32(sp)
    80002ec4:	ec4e                	sd	s3,24(sp)
    80002ec6:	e852                	sd	s4,16(sp)
    80002ec8:	e456                	sd	s5,8(sp)
    80002eca:	e05a                	sd	s6,0(sp)
    80002ecc:	0080                	addi	s0,sp,64
    80002ece:	8b2a                	mv	s6,a0
    80002ed0:	00015a97          	auipc	s5,0x15
    80002ed4:	c60a8a93          	addi	s5,s5,-928 # 80017b30 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002ed8:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002eda:	00015997          	auipc	s3,0x15
    80002ede:	c2698993          	addi	s3,s3,-986 # 80017b00 <log>
    80002ee2:	a829                	j	80002efc <install_trans+0x4e>
    brelse(lbuf);
    80002ee4:	854a                	mv	a0,s2
    80002ee6:	a60ff0ef          	jal	ra,80002146 <brelse>
    brelse(dbuf);
    80002eea:	8526                	mv	a0,s1
    80002eec:	a5aff0ef          	jal	ra,80002146 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002ef0:	2a05                	addiw	s4,s4,1
    80002ef2:	0a91                	addi	s5,s5,4
    80002ef4:	02c9a783          	lw	a5,44(s3)
    80002ef8:	04fa5463          	bge	s4,a5,80002f40 <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002efc:	0189a583          	lw	a1,24(s3)
    80002f00:	014585bb          	addw	a1,a1,s4
    80002f04:	2585                	addiw	a1,a1,1
    80002f06:	0289a503          	lw	a0,40(s3)
    80002f0a:	934ff0ef          	jal	ra,8000203e <bread>
    80002f0e:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80002f10:	000aa583          	lw	a1,0(s5)
    80002f14:	0289a503          	lw	a0,40(s3)
    80002f18:	926ff0ef          	jal	ra,8000203e <bread>
    80002f1c:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80002f1e:	40000613          	li	a2,1024
    80002f22:	05890593          	addi	a1,s2,88
    80002f26:	05850513          	addi	a0,a0,88
    80002f2a:	a7efd0ef          	jal	ra,800001a8 <memmove>
    bwrite(dbuf);  // write dst to disk
    80002f2e:	8526                	mv	a0,s1
    80002f30:	9e4ff0ef          	jal	ra,80002114 <bwrite>
    if(recovering == 0)
    80002f34:	fa0b18e3          	bnez	s6,80002ee4 <install_trans+0x36>
      bunpin(dbuf);
    80002f38:	8526                	mv	a0,s1
    80002f3a:	acaff0ef          	jal	ra,80002204 <bunpin>
    80002f3e:	b75d                	j	80002ee4 <install_trans+0x36>
}
    80002f40:	70e2                	ld	ra,56(sp)
    80002f42:	7442                	ld	s0,48(sp)
    80002f44:	74a2                	ld	s1,40(sp)
    80002f46:	7902                	ld	s2,32(sp)
    80002f48:	69e2                	ld	s3,24(sp)
    80002f4a:	6a42                	ld	s4,16(sp)
    80002f4c:	6aa2                	ld	s5,8(sp)
    80002f4e:	6b02                	ld	s6,0(sp)
    80002f50:	6121                	addi	sp,sp,64
    80002f52:	8082                	ret
    80002f54:	8082                	ret

0000000080002f56 <initlog>:
{
    80002f56:	7179                	addi	sp,sp,-48
    80002f58:	f406                	sd	ra,40(sp)
    80002f5a:	f022                	sd	s0,32(sp)
    80002f5c:	ec26                	sd	s1,24(sp)
    80002f5e:	e84a                	sd	s2,16(sp)
    80002f60:	e44e                	sd	s3,8(sp)
    80002f62:	1800                	addi	s0,sp,48
    80002f64:	892a                	mv	s2,a0
    80002f66:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80002f68:	00015497          	auipc	s1,0x15
    80002f6c:	b9848493          	addi	s1,s1,-1128 # 80017b00 <log>
    80002f70:	00004597          	auipc	a1,0x4
    80002f74:	68858593          	addi	a1,a1,1672 # 800075f8 <syscalls+0x1e0>
    80002f78:	8526                	mv	a0,s1
    80002f7a:	6f0020ef          	jal	ra,8000566a <initlock>
  log.start = sb->logstart;
    80002f7e:	0149a583          	lw	a1,20(s3)
    80002f82:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80002f84:	0109a783          	lw	a5,16(s3)
    80002f88:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80002f8a:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80002f8e:	854a                	mv	a0,s2
    80002f90:	8aeff0ef          	jal	ra,8000203e <bread>
  log.lh.n = lh->n;
    80002f94:	4d34                	lw	a3,88(a0)
    80002f96:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80002f98:	02d05563          	blez	a3,80002fc2 <initlog+0x6c>
    80002f9c:	05c50793          	addi	a5,a0,92
    80002fa0:	00015717          	auipc	a4,0x15
    80002fa4:	b9070713          	addi	a4,a4,-1136 # 80017b30 <log+0x30>
    80002fa8:	36fd                	addiw	a3,a3,-1
    80002faa:	1682                	slli	a3,a3,0x20
    80002fac:	9281                	srli	a3,a3,0x20
    80002fae:	068a                	slli	a3,a3,0x2
    80002fb0:	06050613          	addi	a2,a0,96
    80002fb4:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80002fb6:	4390                	lw	a2,0(a5)
    80002fb8:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80002fba:	0791                	addi	a5,a5,4
    80002fbc:	0711                	addi	a4,a4,4
    80002fbe:	fed79ce3          	bne	a5,a3,80002fb6 <initlog+0x60>
  brelse(buf);
    80002fc2:	984ff0ef          	jal	ra,80002146 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80002fc6:	4505                	li	a0,1
    80002fc8:	ee7ff0ef          	jal	ra,80002eae <install_trans>
  log.lh.n = 0;
    80002fcc:	00015797          	auipc	a5,0x15
    80002fd0:	b607a023          	sw	zero,-1184(a5) # 80017b2c <log+0x2c>
  write_head(); // clear the log
    80002fd4:	e6dff0ef          	jal	ra,80002e40 <write_head>
}
    80002fd8:	70a2                	ld	ra,40(sp)
    80002fda:	7402                	ld	s0,32(sp)
    80002fdc:	64e2                	ld	s1,24(sp)
    80002fde:	6942                	ld	s2,16(sp)
    80002fe0:	69a2                	ld	s3,8(sp)
    80002fe2:	6145                	addi	sp,sp,48
    80002fe4:	8082                	ret

0000000080002fe6 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80002fe6:	1101                	addi	sp,sp,-32
    80002fe8:	ec06                	sd	ra,24(sp)
    80002fea:	e822                	sd	s0,16(sp)
    80002fec:	e426                	sd	s1,8(sp)
    80002fee:	e04a                	sd	s2,0(sp)
    80002ff0:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80002ff2:	00015517          	auipc	a0,0x15
    80002ff6:	b0e50513          	addi	a0,a0,-1266 # 80017b00 <log>
    80002ffa:	6f0020ef          	jal	ra,800056ea <acquire>
  while(1){
    if(log.committing){
    80002ffe:	00015497          	auipc	s1,0x15
    80003002:	b0248493          	addi	s1,s1,-1278 # 80017b00 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003006:	4979                	li	s2,30
    80003008:	a029                	j	80003012 <begin_op+0x2c>
      sleep(&log, &log.lock);
    8000300a:	85a6                	mv	a1,s1
    8000300c:	8526                	mv	a0,s1
    8000300e:	ba2fe0ef          	jal	ra,800013b0 <sleep>
    if(log.committing){
    80003012:	50dc                	lw	a5,36(s1)
    80003014:	fbfd                	bnez	a5,8000300a <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003016:	509c                	lw	a5,32(s1)
    80003018:	0017871b          	addiw	a4,a5,1
    8000301c:	0007069b          	sext.w	a3,a4
    80003020:	0027179b          	slliw	a5,a4,0x2
    80003024:	9fb9                	addw	a5,a5,a4
    80003026:	0017979b          	slliw	a5,a5,0x1
    8000302a:	54d8                	lw	a4,44(s1)
    8000302c:	9fb9                	addw	a5,a5,a4
    8000302e:	00f95763          	bge	s2,a5,8000303c <begin_op+0x56>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003032:	85a6                	mv	a1,s1
    80003034:	8526                	mv	a0,s1
    80003036:	b7afe0ef          	jal	ra,800013b0 <sleep>
    8000303a:	bfe1                	j	80003012 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    8000303c:	00015517          	auipc	a0,0x15
    80003040:	ac450513          	addi	a0,a0,-1340 # 80017b00 <log>
    80003044:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003046:	73c020ef          	jal	ra,80005782 <release>
      break;
    }
  }
}
    8000304a:	60e2                	ld	ra,24(sp)
    8000304c:	6442                	ld	s0,16(sp)
    8000304e:	64a2                	ld	s1,8(sp)
    80003050:	6902                	ld	s2,0(sp)
    80003052:	6105                	addi	sp,sp,32
    80003054:	8082                	ret

0000000080003056 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003056:	7139                	addi	sp,sp,-64
    80003058:	fc06                	sd	ra,56(sp)
    8000305a:	f822                	sd	s0,48(sp)
    8000305c:	f426                	sd	s1,40(sp)
    8000305e:	f04a                	sd	s2,32(sp)
    80003060:	ec4e                	sd	s3,24(sp)
    80003062:	e852                	sd	s4,16(sp)
    80003064:	e456                	sd	s5,8(sp)
    80003066:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003068:	00015497          	auipc	s1,0x15
    8000306c:	a9848493          	addi	s1,s1,-1384 # 80017b00 <log>
    80003070:	8526                	mv	a0,s1
    80003072:	678020ef          	jal	ra,800056ea <acquire>
  log.outstanding -= 1;
    80003076:	509c                	lw	a5,32(s1)
    80003078:	37fd                	addiw	a5,a5,-1
    8000307a:	0007891b          	sext.w	s2,a5
    8000307e:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003080:	50dc                	lw	a5,36(s1)
    80003082:	ef9d                	bnez	a5,800030c0 <end_op+0x6a>
    panic("log.committing");
  if(log.outstanding == 0){
    80003084:	04091463          	bnez	s2,800030cc <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003088:	00015497          	auipc	s1,0x15
    8000308c:	a7848493          	addi	s1,s1,-1416 # 80017b00 <log>
    80003090:	4785                	li	a5,1
    80003092:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003094:	8526                	mv	a0,s1
    80003096:	6ec020ef          	jal	ra,80005782 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000309a:	54dc                	lw	a5,44(s1)
    8000309c:	04f04b63          	bgtz	a5,800030f2 <end_op+0x9c>
    acquire(&log.lock);
    800030a0:	00015497          	auipc	s1,0x15
    800030a4:	a6048493          	addi	s1,s1,-1440 # 80017b00 <log>
    800030a8:	8526                	mv	a0,s1
    800030aa:	640020ef          	jal	ra,800056ea <acquire>
    log.committing = 0;
    800030ae:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800030b2:	8526                	mv	a0,s1
    800030b4:	b48fe0ef          	jal	ra,800013fc <wakeup>
    release(&log.lock);
    800030b8:	8526                	mv	a0,s1
    800030ba:	6c8020ef          	jal	ra,80005782 <release>
}
    800030be:	a00d                	j	800030e0 <end_op+0x8a>
    panic("log.committing");
    800030c0:	00004517          	auipc	a0,0x4
    800030c4:	54050513          	addi	a0,a0,1344 # 80007600 <syscalls+0x1e8>
    800030c8:	30e020ef          	jal	ra,800053d6 <panic>
    wakeup(&log);
    800030cc:	00015497          	auipc	s1,0x15
    800030d0:	a3448493          	addi	s1,s1,-1484 # 80017b00 <log>
    800030d4:	8526                	mv	a0,s1
    800030d6:	b26fe0ef          	jal	ra,800013fc <wakeup>
  release(&log.lock);
    800030da:	8526                	mv	a0,s1
    800030dc:	6a6020ef          	jal	ra,80005782 <release>
}
    800030e0:	70e2                	ld	ra,56(sp)
    800030e2:	7442                	ld	s0,48(sp)
    800030e4:	74a2                	ld	s1,40(sp)
    800030e6:	7902                	ld	s2,32(sp)
    800030e8:	69e2                	ld	s3,24(sp)
    800030ea:	6a42                	ld	s4,16(sp)
    800030ec:	6aa2                	ld	s5,8(sp)
    800030ee:	6121                	addi	sp,sp,64
    800030f0:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800030f2:	00015a97          	auipc	s5,0x15
    800030f6:	a3ea8a93          	addi	s5,s5,-1474 # 80017b30 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800030fa:	00015a17          	auipc	s4,0x15
    800030fe:	a06a0a13          	addi	s4,s4,-1530 # 80017b00 <log>
    80003102:	018a2583          	lw	a1,24(s4)
    80003106:	012585bb          	addw	a1,a1,s2
    8000310a:	2585                	addiw	a1,a1,1
    8000310c:	028a2503          	lw	a0,40(s4)
    80003110:	f2ffe0ef          	jal	ra,8000203e <bread>
    80003114:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003116:	000aa583          	lw	a1,0(s5)
    8000311a:	028a2503          	lw	a0,40(s4)
    8000311e:	f21fe0ef          	jal	ra,8000203e <bread>
    80003122:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003124:	40000613          	li	a2,1024
    80003128:	05850593          	addi	a1,a0,88
    8000312c:	05848513          	addi	a0,s1,88
    80003130:	878fd0ef          	jal	ra,800001a8 <memmove>
    bwrite(to);  // write the log
    80003134:	8526                	mv	a0,s1
    80003136:	fdffe0ef          	jal	ra,80002114 <bwrite>
    brelse(from);
    8000313a:	854e                	mv	a0,s3
    8000313c:	80aff0ef          	jal	ra,80002146 <brelse>
    brelse(to);
    80003140:	8526                	mv	a0,s1
    80003142:	804ff0ef          	jal	ra,80002146 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003146:	2905                	addiw	s2,s2,1
    80003148:	0a91                	addi	s5,s5,4
    8000314a:	02ca2783          	lw	a5,44(s4)
    8000314e:	faf94ae3          	blt	s2,a5,80003102 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003152:	cefff0ef          	jal	ra,80002e40 <write_head>
    install_trans(0); // Now install writes to home locations
    80003156:	4501                	li	a0,0
    80003158:	d57ff0ef          	jal	ra,80002eae <install_trans>
    log.lh.n = 0;
    8000315c:	00015797          	auipc	a5,0x15
    80003160:	9c07a823          	sw	zero,-1584(a5) # 80017b2c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003164:	cddff0ef          	jal	ra,80002e40 <write_head>
    80003168:	bf25                	j	800030a0 <end_op+0x4a>

000000008000316a <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000316a:	1101                	addi	sp,sp,-32
    8000316c:	ec06                	sd	ra,24(sp)
    8000316e:	e822                	sd	s0,16(sp)
    80003170:	e426                	sd	s1,8(sp)
    80003172:	e04a                	sd	s2,0(sp)
    80003174:	1000                	addi	s0,sp,32
    80003176:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003178:	00015917          	auipc	s2,0x15
    8000317c:	98890913          	addi	s2,s2,-1656 # 80017b00 <log>
    80003180:	854a                	mv	a0,s2
    80003182:	568020ef          	jal	ra,800056ea <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003186:	02c92603          	lw	a2,44(s2)
    8000318a:	47f5                	li	a5,29
    8000318c:	06c7c363          	blt	a5,a2,800031f2 <log_write+0x88>
    80003190:	00015797          	auipc	a5,0x15
    80003194:	98c7a783          	lw	a5,-1652(a5) # 80017b1c <log+0x1c>
    80003198:	37fd                	addiw	a5,a5,-1
    8000319a:	04f65c63          	bge	a2,a5,800031f2 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000319e:	00015797          	auipc	a5,0x15
    800031a2:	9827a783          	lw	a5,-1662(a5) # 80017b20 <log+0x20>
    800031a6:	04f05c63          	blez	a5,800031fe <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800031aa:	4781                	li	a5,0
    800031ac:	04c05f63          	blez	a2,8000320a <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800031b0:	44cc                	lw	a1,12(s1)
    800031b2:	00015717          	auipc	a4,0x15
    800031b6:	97e70713          	addi	a4,a4,-1666 # 80017b30 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800031ba:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800031bc:	4314                	lw	a3,0(a4)
    800031be:	04b68663          	beq	a3,a1,8000320a <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    800031c2:	2785                	addiw	a5,a5,1
    800031c4:	0711                	addi	a4,a4,4
    800031c6:	fef61be3          	bne	a2,a5,800031bc <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    800031ca:	0621                	addi	a2,a2,8
    800031cc:	060a                	slli	a2,a2,0x2
    800031ce:	00015797          	auipc	a5,0x15
    800031d2:	93278793          	addi	a5,a5,-1742 # 80017b00 <log>
    800031d6:	963e                	add	a2,a2,a5
    800031d8:	44dc                	lw	a5,12(s1)
    800031da:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800031dc:	8526                	mv	a0,s1
    800031de:	ff3fe0ef          	jal	ra,800021d0 <bpin>
    log.lh.n++;
    800031e2:	00015717          	auipc	a4,0x15
    800031e6:	91e70713          	addi	a4,a4,-1762 # 80017b00 <log>
    800031ea:	575c                	lw	a5,44(a4)
    800031ec:	2785                	addiw	a5,a5,1
    800031ee:	d75c                	sw	a5,44(a4)
    800031f0:	a815                	j	80003224 <log_write+0xba>
    panic("too big a transaction");
    800031f2:	00004517          	auipc	a0,0x4
    800031f6:	41e50513          	addi	a0,a0,1054 # 80007610 <syscalls+0x1f8>
    800031fa:	1dc020ef          	jal	ra,800053d6 <panic>
    panic("log_write outside of trans");
    800031fe:	00004517          	auipc	a0,0x4
    80003202:	42a50513          	addi	a0,a0,1066 # 80007628 <syscalls+0x210>
    80003206:	1d0020ef          	jal	ra,800053d6 <panic>
  log.lh.block[i] = b->blockno;
    8000320a:	00878713          	addi	a4,a5,8
    8000320e:	00271693          	slli	a3,a4,0x2
    80003212:	00015717          	auipc	a4,0x15
    80003216:	8ee70713          	addi	a4,a4,-1810 # 80017b00 <log>
    8000321a:	9736                	add	a4,a4,a3
    8000321c:	44d4                	lw	a3,12(s1)
    8000321e:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003220:	faf60ee3          	beq	a2,a5,800031dc <log_write+0x72>
  }
  release(&log.lock);
    80003224:	00015517          	auipc	a0,0x15
    80003228:	8dc50513          	addi	a0,a0,-1828 # 80017b00 <log>
    8000322c:	556020ef          	jal	ra,80005782 <release>
}
    80003230:	60e2                	ld	ra,24(sp)
    80003232:	6442                	ld	s0,16(sp)
    80003234:	64a2                	ld	s1,8(sp)
    80003236:	6902                	ld	s2,0(sp)
    80003238:	6105                	addi	sp,sp,32
    8000323a:	8082                	ret

000000008000323c <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000323c:	1101                	addi	sp,sp,-32
    8000323e:	ec06                	sd	ra,24(sp)
    80003240:	e822                	sd	s0,16(sp)
    80003242:	e426                	sd	s1,8(sp)
    80003244:	e04a                	sd	s2,0(sp)
    80003246:	1000                	addi	s0,sp,32
    80003248:	84aa                	mv	s1,a0
    8000324a:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000324c:	00004597          	auipc	a1,0x4
    80003250:	3fc58593          	addi	a1,a1,1020 # 80007648 <syscalls+0x230>
    80003254:	0521                	addi	a0,a0,8
    80003256:	414020ef          	jal	ra,8000566a <initlock>
  lk->name = name;
    8000325a:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000325e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003262:	0204a423          	sw	zero,40(s1)
}
    80003266:	60e2                	ld	ra,24(sp)
    80003268:	6442                	ld	s0,16(sp)
    8000326a:	64a2                	ld	s1,8(sp)
    8000326c:	6902                	ld	s2,0(sp)
    8000326e:	6105                	addi	sp,sp,32
    80003270:	8082                	ret

0000000080003272 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003272:	1101                	addi	sp,sp,-32
    80003274:	ec06                	sd	ra,24(sp)
    80003276:	e822                	sd	s0,16(sp)
    80003278:	e426                	sd	s1,8(sp)
    8000327a:	e04a                	sd	s2,0(sp)
    8000327c:	1000                	addi	s0,sp,32
    8000327e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003280:	00850913          	addi	s2,a0,8
    80003284:	854a                	mv	a0,s2
    80003286:	464020ef          	jal	ra,800056ea <acquire>
  while (lk->locked) {
    8000328a:	409c                	lw	a5,0(s1)
    8000328c:	c799                	beqz	a5,8000329a <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    8000328e:	85ca                	mv	a1,s2
    80003290:	8526                	mv	a0,s1
    80003292:	91efe0ef          	jal	ra,800013b0 <sleep>
  while (lk->locked) {
    80003296:	409c                	lw	a5,0(s1)
    80003298:	fbfd                	bnez	a5,8000328e <acquiresleep+0x1c>
  }
  lk->locked = 1;
    8000329a:	4785                	li	a5,1
    8000329c:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000329e:	ab5fd0ef          	jal	ra,80000d52 <myproc>
    800032a2:	591c                	lw	a5,48(a0)
    800032a4:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800032a6:	854a                	mv	a0,s2
    800032a8:	4da020ef          	jal	ra,80005782 <release>
}
    800032ac:	60e2                	ld	ra,24(sp)
    800032ae:	6442                	ld	s0,16(sp)
    800032b0:	64a2                	ld	s1,8(sp)
    800032b2:	6902                	ld	s2,0(sp)
    800032b4:	6105                	addi	sp,sp,32
    800032b6:	8082                	ret

00000000800032b8 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800032b8:	1101                	addi	sp,sp,-32
    800032ba:	ec06                	sd	ra,24(sp)
    800032bc:	e822                	sd	s0,16(sp)
    800032be:	e426                	sd	s1,8(sp)
    800032c0:	e04a                	sd	s2,0(sp)
    800032c2:	1000                	addi	s0,sp,32
    800032c4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800032c6:	00850913          	addi	s2,a0,8
    800032ca:	854a                	mv	a0,s2
    800032cc:	41e020ef          	jal	ra,800056ea <acquire>
  lk->locked = 0;
    800032d0:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800032d4:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800032d8:	8526                	mv	a0,s1
    800032da:	922fe0ef          	jal	ra,800013fc <wakeup>
  release(&lk->lk);
    800032de:	854a                	mv	a0,s2
    800032e0:	4a2020ef          	jal	ra,80005782 <release>
}
    800032e4:	60e2                	ld	ra,24(sp)
    800032e6:	6442                	ld	s0,16(sp)
    800032e8:	64a2                	ld	s1,8(sp)
    800032ea:	6902                	ld	s2,0(sp)
    800032ec:	6105                	addi	sp,sp,32
    800032ee:	8082                	ret

00000000800032f0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800032f0:	7179                	addi	sp,sp,-48
    800032f2:	f406                	sd	ra,40(sp)
    800032f4:	f022                	sd	s0,32(sp)
    800032f6:	ec26                	sd	s1,24(sp)
    800032f8:	e84a                	sd	s2,16(sp)
    800032fa:	e44e                	sd	s3,8(sp)
    800032fc:	1800                	addi	s0,sp,48
    800032fe:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003300:	00850913          	addi	s2,a0,8
    80003304:	854a                	mv	a0,s2
    80003306:	3e4020ef          	jal	ra,800056ea <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000330a:	409c                	lw	a5,0(s1)
    8000330c:	ef89                	bnez	a5,80003326 <holdingsleep+0x36>
    8000330e:	4481                	li	s1,0
  release(&lk->lk);
    80003310:	854a                	mv	a0,s2
    80003312:	470020ef          	jal	ra,80005782 <release>
  return r;
}
    80003316:	8526                	mv	a0,s1
    80003318:	70a2                	ld	ra,40(sp)
    8000331a:	7402                	ld	s0,32(sp)
    8000331c:	64e2                	ld	s1,24(sp)
    8000331e:	6942                	ld	s2,16(sp)
    80003320:	69a2                	ld	s3,8(sp)
    80003322:	6145                	addi	sp,sp,48
    80003324:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003326:	0284a983          	lw	s3,40(s1)
    8000332a:	a29fd0ef          	jal	ra,80000d52 <myproc>
    8000332e:	5904                	lw	s1,48(a0)
    80003330:	413484b3          	sub	s1,s1,s3
    80003334:	0014b493          	seqz	s1,s1
    80003338:	bfe1                	j	80003310 <holdingsleep+0x20>

000000008000333a <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000333a:	1141                	addi	sp,sp,-16
    8000333c:	e406                	sd	ra,8(sp)
    8000333e:	e022                	sd	s0,0(sp)
    80003340:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003342:	00004597          	auipc	a1,0x4
    80003346:	31658593          	addi	a1,a1,790 # 80007658 <syscalls+0x240>
    8000334a:	00015517          	auipc	a0,0x15
    8000334e:	8fe50513          	addi	a0,a0,-1794 # 80017c48 <ftable>
    80003352:	318020ef          	jal	ra,8000566a <initlock>
}
    80003356:	60a2                	ld	ra,8(sp)
    80003358:	6402                	ld	s0,0(sp)
    8000335a:	0141                	addi	sp,sp,16
    8000335c:	8082                	ret

000000008000335e <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000335e:	1101                	addi	sp,sp,-32
    80003360:	ec06                	sd	ra,24(sp)
    80003362:	e822                	sd	s0,16(sp)
    80003364:	e426                	sd	s1,8(sp)
    80003366:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003368:	00015517          	auipc	a0,0x15
    8000336c:	8e050513          	addi	a0,a0,-1824 # 80017c48 <ftable>
    80003370:	37a020ef          	jal	ra,800056ea <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003374:	00015497          	auipc	s1,0x15
    80003378:	8ec48493          	addi	s1,s1,-1812 # 80017c60 <ftable+0x18>
    8000337c:	00016717          	auipc	a4,0x16
    80003380:	88470713          	addi	a4,a4,-1916 # 80018c00 <disk>
    if(f->ref == 0){
    80003384:	40dc                	lw	a5,4(s1)
    80003386:	cf89                	beqz	a5,800033a0 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003388:	02848493          	addi	s1,s1,40
    8000338c:	fee49ce3          	bne	s1,a4,80003384 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003390:	00015517          	auipc	a0,0x15
    80003394:	8b850513          	addi	a0,a0,-1864 # 80017c48 <ftable>
    80003398:	3ea020ef          	jal	ra,80005782 <release>
  return 0;
    8000339c:	4481                	li	s1,0
    8000339e:	a809                	j	800033b0 <filealloc+0x52>
      f->ref = 1;
    800033a0:	4785                	li	a5,1
    800033a2:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800033a4:	00015517          	auipc	a0,0x15
    800033a8:	8a450513          	addi	a0,a0,-1884 # 80017c48 <ftable>
    800033ac:	3d6020ef          	jal	ra,80005782 <release>
}
    800033b0:	8526                	mv	a0,s1
    800033b2:	60e2                	ld	ra,24(sp)
    800033b4:	6442                	ld	s0,16(sp)
    800033b6:	64a2                	ld	s1,8(sp)
    800033b8:	6105                	addi	sp,sp,32
    800033ba:	8082                	ret

00000000800033bc <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800033bc:	1101                	addi	sp,sp,-32
    800033be:	ec06                	sd	ra,24(sp)
    800033c0:	e822                	sd	s0,16(sp)
    800033c2:	e426                	sd	s1,8(sp)
    800033c4:	1000                	addi	s0,sp,32
    800033c6:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800033c8:	00015517          	auipc	a0,0x15
    800033cc:	88050513          	addi	a0,a0,-1920 # 80017c48 <ftable>
    800033d0:	31a020ef          	jal	ra,800056ea <acquire>
  if(f->ref < 1)
    800033d4:	40dc                	lw	a5,4(s1)
    800033d6:	02f05063          	blez	a5,800033f6 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    800033da:	2785                	addiw	a5,a5,1
    800033dc:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800033de:	00015517          	auipc	a0,0x15
    800033e2:	86a50513          	addi	a0,a0,-1942 # 80017c48 <ftable>
    800033e6:	39c020ef          	jal	ra,80005782 <release>
  return f;
}
    800033ea:	8526                	mv	a0,s1
    800033ec:	60e2                	ld	ra,24(sp)
    800033ee:	6442                	ld	s0,16(sp)
    800033f0:	64a2                	ld	s1,8(sp)
    800033f2:	6105                	addi	sp,sp,32
    800033f4:	8082                	ret
    panic("filedup");
    800033f6:	00004517          	auipc	a0,0x4
    800033fa:	26a50513          	addi	a0,a0,618 # 80007660 <syscalls+0x248>
    800033fe:	7d9010ef          	jal	ra,800053d6 <panic>

0000000080003402 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003402:	7139                	addi	sp,sp,-64
    80003404:	fc06                	sd	ra,56(sp)
    80003406:	f822                	sd	s0,48(sp)
    80003408:	f426                	sd	s1,40(sp)
    8000340a:	f04a                	sd	s2,32(sp)
    8000340c:	ec4e                	sd	s3,24(sp)
    8000340e:	e852                	sd	s4,16(sp)
    80003410:	e456                	sd	s5,8(sp)
    80003412:	0080                	addi	s0,sp,64
    80003414:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003416:	00015517          	auipc	a0,0x15
    8000341a:	83250513          	addi	a0,a0,-1998 # 80017c48 <ftable>
    8000341e:	2cc020ef          	jal	ra,800056ea <acquire>
  if(f->ref < 1)
    80003422:	40dc                	lw	a5,4(s1)
    80003424:	04f05963          	blez	a5,80003476 <fileclose+0x74>
    panic("fileclose");
  if(--f->ref > 0){
    80003428:	37fd                	addiw	a5,a5,-1
    8000342a:	0007871b          	sext.w	a4,a5
    8000342e:	c0dc                	sw	a5,4(s1)
    80003430:	04e04963          	bgtz	a4,80003482 <fileclose+0x80>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003434:	0004a903          	lw	s2,0(s1)
    80003438:	0094ca83          	lbu	s5,9(s1)
    8000343c:	0104ba03          	ld	s4,16(s1)
    80003440:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003444:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003448:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    8000344c:	00014517          	auipc	a0,0x14
    80003450:	7fc50513          	addi	a0,a0,2044 # 80017c48 <ftable>
    80003454:	32e020ef          	jal	ra,80005782 <release>

  if(ff.type == FD_PIPE){
    80003458:	4785                	li	a5,1
    8000345a:	04f90363          	beq	s2,a5,800034a0 <fileclose+0x9e>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    8000345e:	3979                	addiw	s2,s2,-2
    80003460:	4785                	li	a5,1
    80003462:	0327e663          	bltu	a5,s2,8000348e <fileclose+0x8c>
    begin_op();
    80003466:	b81ff0ef          	jal	ra,80002fe6 <begin_op>
    iput(ff.ip);
    8000346a:	854e                	mv	a0,s3
    8000346c:	c6eff0ef          	jal	ra,800028da <iput>
    end_op();
    80003470:	be7ff0ef          	jal	ra,80003056 <end_op>
    80003474:	a829                	j	8000348e <fileclose+0x8c>
    panic("fileclose");
    80003476:	00004517          	auipc	a0,0x4
    8000347a:	1f250513          	addi	a0,a0,498 # 80007668 <syscalls+0x250>
    8000347e:	759010ef          	jal	ra,800053d6 <panic>
    release(&ftable.lock);
    80003482:	00014517          	auipc	a0,0x14
    80003486:	7c650513          	addi	a0,a0,1990 # 80017c48 <ftable>
    8000348a:	2f8020ef          	jal	ra,80005782 <release>
  }
}
    8000348e:	70e2                	ld	ra,56(sp)
    80003490:	7442                	ld	s0,48(sp)
    80003492:	74a2                	ld	s1,40(sp)
    80003494:	7902                	ld	s2,32(sp)
    80003496:	69e2                	ld	s3,24(sp)
    80003498:	6a42                	ld	s4,16(sp)
    8000349a:	6aa2                	ld	s5,8(sp)
    8000349c:	6121                	addi	sp,sp,64
    8000349e:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800034a0:	85d6                	mv	a1,s5
    800034a2:	8552                	mv	a0,s4
    800034a4:	2ec000ef          	jal	ra,80003790 <pipeclose>
    800034a8:	b7dd                	j	8000348e <fileclose+0x8c>

00000000800034aa <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800034aa:	715d                	addi	sp,sp,-80
    800034ac:	e486                	sd	ra,72(sp)
    800034ae:	e0a2                	sd	s0,64(sp)
    800034b0:	fc26                	sd	s1,56(sp)
    800034b2:	f84a                	sd	s2,48(sp)
    800034b4:	f44e                	sd	s3,40(sp)
    800034b6:	0880                	addi	s0,sp,80
    800034b8:	84aa                	mv	s1,a0
    800034ba:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800034bc:	897fd0ef          	jal	ra,80000d52 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800034c0:	409c                	lw	a5,0(s1)
    800034c2:	37f9                	addiw	a5,a5,-2
    800034c4:	4705                	li	a4,1
    800034c6:	02f76f63          	bltu	a4,a5,80003504 <filestat+0x5a>
    800034ca:	892a                	mv	s2,a0
    ilock(f->ip);
    800034cc:	6c88                	ld	a0,24(s1)
    800034ce:	a8eff0ef          	jal	ra,8000275c <ilock>
    stati(f->ip, &st);
    800034d2:	fb840593          	addi	a1,s0,-72
    800034d6:	6c88                	ld	a0,24(s1)
    800034d8:	caaff0ef          	jal	ra,80002982 <stati>
    iunlock(f->ip);
    800034dc:	6c88                	ld	a0,24(s1)
    800034de:	b28ff0ef          	jal	ra,80002806 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800034e2:	46e1                	li	a3,24
    800034e4:	fb840613          	addi	a2,s0,-72
    800034e8:	85ce                	mv	a1,s3
    800034ea:	0d093503          	ld	a0,208(s2)
    800034ee:	d18fd0ef          	jal	ra,80000a06 <copyout>
    800034f2:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    800034f6:	60a6                	ld	ra,72(sp)
    800034f8:	6406                	ld	s0,64(sp)
    800034fa:	74e2                	ld	s1,56(sp)
    800034fc:	7942                	ld	s2,48(sp)
    800034fe:	79a2                	ld	s3,40(sp)
    80003500:	6161                	addi	sp,sp,80
    80003502:	8082                	ret
  return -1;
    80003504:	557d                	li	a0,-1
    80003506:	bfc5                	j	800034f6 <filestat+0x4c>

0000000080003508 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003508:	7179                	addi	sp,sp,-48
    8000350a:	f406                	sd	ra,40(sp)
    8000350c:	f022                	sd	s0,32(sp)
    8000350e:	ec26                	sd	s1,24(sp)
    80003510:	e84a                	sd	s2,16(sp)
    80003512:	e44e                	sd	s3,8(sp)
    80003514:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003516:	00854783          	lbu	a5,8(a0)
    8000351a:	cbc1                	beqz	a5,800035aa <fileread+0xa2>
    8000351c:	84aa                	mv	s1,a0
    8000351e:	89ae                	mv	s3,a1
    80003520:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003522:	411c                	lw	a5,0(a0)
    80003524:	4705                	li	a4,1
    80003526:	04e78363          	beq	a5,a4,8000356c <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000352a:	470d                	li	a4,3
    8000352c:	04e78563          	beq	a5,a4,80003576 <fileread+0x6e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003530:	4709                	li	a4,2
    80003532:	06e79663          	bne	a5,a4,8000359e <fileread+0x96>
    ilock(f->ip);
    80003536:	6d08                	ld	a0,24(a0)
    80003538:	a24ff0ef          	jal	ra,8000275c <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    8000353c:	874a                	mv	a4,s2
    8000353e:	5094                	lw	a3,32(s1)
    80003540:	864e                	mv	a2,s3
    80003542:	4585                	li	a1,1
    80003544:	6c88                	ld	a0,24(s1)
    80003546:	c66ff0ef          	jal	ra,800029ac <readi>
    8000354a:	892a                	mv	s2,a0
    8000354c:	00a05563          	blez	a0,80003556 <fileread+0x4e>
      f->off += r;
    80003550:	509c                	lw	a5,32(s1)
    80003552:	9fa9                	addw	a5,a5,a0
    80003554:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003556:	6c88                	ld	a0,24(s1)
    80003558:	aaeff0ef          	jal	ra,80002806 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    8000355c:	854a                	mv	a0,s2
    8000355e:	70a2                	ld	ra,40(sp)
    80003560:	7402                	ld	s0,32(sp)
    80003562:	64e2                	ld	s1,24(sp)
    80003564:	6942                	ld	s2,16(sp)
    80003566:	69a2                	ld	s3,8(sp)
    80003568:	6145                	addi	sp,sp,48
    8000356a:	8082                	ret
    r = piperead(f->pipe, addr, n);
    8000356c:	6908                	ld	a0,16(a0)
    8000356e:	34e000ef          	jal	ra,800038bc <piperead>
    80003572:	892a                	mv	s2,a0
    80003574:	b7e5                	j	8000355c <fileread+0x54>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003576:	02451783          	lh	a5,36(a0)
    8000357a:	03079693          	slli	a3,a5,0x30
    8000357e:	92c1                	srli	a3,a3,0x30
    80003580:	4725                	li	a4,9
    80003582:	02d76663          	bltu	a4,a3,800035ae <fileread+0xa6>
    80003586:	0792                	slli	a5,a5,0x4
    80003588:	00014717          	auipc	a4,0x14
    8000358c:	62070713          	addi	a4,a4,1568 # 80017ba8 <devsw>
    80003590:	97ba                	add	a5,a5,a4
    80003592:	639c                	ld	a5,0(a5)
    80003594:	cf99                	beqz	a5,800035b2 <fileread+0xaa>
    r = devsw[f->major].read(1, addr, n);
    80003596:	4505                	li	a0,1
    80003598:	9782                	jalr	a5
    8000359a:	892a                	mv	s2,a0
    8000359c:	b7c1                	j	8000355c <fileread+0x54>
    panic("fileread");
    8000359e:	00004517          	auipc	a0,0x4
    800035a2:	0da50513          	addi	a0,a0,218 # 80007678 <syscalls+0x260>
    800035a6:	631010ef          	jal	ra,800053d6 <panic>
    return -1;
    800035aa:	597d                	li	s2,-1
    800035ac:	bf45                	j	8000355c <fileread+0x54>
      return -1;
    800035ae:	597d                	li	s2,-1
    800035b0:	b775                	j	8000355c <fileread+0x54>
    800035b2:	597d                	li	s2,-1
    800035b4:	b765                	j	8000355c <fileread+0x54>

00000000800035b6 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    800035b6:	715d                	addi	sp,sp,-80
    800035b8:	e486                	sd	ra,72(sp)
    800035ba:	e0a2                	sd	s0,64(sp)
    800035bc:	fc26                	sd	s1,56(sp)
    800035be:	f84a                	sd	s2,48(sp)
    800035c0:	f44e                	sd	s3,40(sp)
    800035c2:	f052                	sd	s4,32(sp)
    800035c4:	ec56                	sd	s5,24(sp)
    800035c6:	e85a                	sd	s6,16(sp)
    800035c8:	e45e                	sd	s7,8(sp)
    800035ca:	e062                	sd	s8,0(sp)
    800035cc:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    800035ce:	00954783          	lbu	a5,9(a0)
    800035d2:	0e078863          	beqz	a5,800036c2 <filewrite+0x10c>
    800035d6:	892a                	mv	s2,a0
    800035d8:	8aae                	mv	s5,a1
    800035da:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800035dc:	411c                	lw	a5,0(a0)
    800035de:	4705                	li	a4,1
    800035e0:	02e78263          	beq	a5,a4,80003604 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800035e4:	470d                	li	a4,3
    800035e6:	02e78463          	beq	a5,a4,8000360e <filewrite+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800035ea:	4709                	li	a4,2
    800035ec:	0ce79563          	bne	a5,a4,800036b6 <filewrite+0x100>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800035f0:	0ac05163          	blez	a2,80003692 <filewrite+0xdc>
    int i = 0;
    800035f4:	4981                	li	s3,0
    800035f6:	6b05                	lui	s6,0x1
    800035f8:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    800035fc:	6b85                	lui	s7,0x1
    800035fe:	c00b8b9b          	addiw	s7,s7,-1024
    80003602:	a041                	j	80003682 <filewrite+0xcc>
    ret = pipewrite(f->pipe, addr, n);
    80003604:	6908                	ld	a0,16(a0)
    80003606:	1e2000ef          	jal	ra,800037e8 <pipewrite>
    8000360a:	8a2a                	mv	s4,a0
    8000360c:	a071                	j	80003698 <filewrite+0xe2>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    8000360e:	02451783          	lh	a5,36(a0)
    80003612:	03079693          	slli	a3,a5,0x30
    80003616:	92c1                	srli	a3,a3,0x30
    80003618:	4725                	li	a4,9
    8000361a:	0ad76663          	bltu	a4,a3,800036c6 <filewrite+0x110>
    8000361e:	0792                	slli	a5,a5,0x4
    80003620:	00014717          	auipc	a4,0x14
    80003624:	58870713          	addi	a4,a4,1416 # 80017ba8 <devsw>
    80003628:	97ba                	add	a5,a5,a4
    8000362a:	679c                	ld	a5,8(a5)
    8000362c:	cfd9                	beqz	a5,800036ca <filewrite+0x114>
    ret = devsw[f->major].write(1, addr, n);
    8000362e:	4505                	li	a0,1
    80003630:	9782                	jalr	a5
    80003632:	8a2a                	mv	s4,a0
    80003634:	a095                	j	80003698 <filewrite+0xe2>
    80003636:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    8000363a:	9adff0ef          	jal	ra,80002fe6 <begin_op>
      ilock(f->ip);
    8000363e:	01893503          	ld	a0,24(s2)
    80003642:	91aff0ef          	jal	ra,8000275c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003646:	8762                	mv	a4,s8
    80003648:	02092683          	lw	a3,32(s2)
    8000364c:	01598633          	add	a2,s3,s5
    80003650:	4585                	li	a1,1
    80003652:	01893503          	ld	a0,24(s2)
    80003656:	c3aff0ef          	jal	ra,80002a90 <writei>
    8000365a:	84aa                	mv	s1,a0
    8000365c:	00a05763          	blez	a0,8000366a <filewrite+0xb4>
        f->off += r;
    80003660:	02092783          	lw	a5,32(s2)
    80003664:	9fa9                	addw	a5,a5,a0
    80003666:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000366a:	01893503          	ld	a0,24(s2)
    8000366e:	998ff0ef          	jal	ra,80002806 <iunlock>
      end_op();
    80003672:	9e5ff0ef          	jal	ra,80003056 <end_op>

      if(r != n1){
    80003676:	009c1f63          	bne	s8,s1,80003694 <filewrite+0xde>
        // error from writei
        break;
      }
      i += r;
    8000367a:	013489bb          	addw	s3,s1,s3
    while(i < n){
    8000367e:	0149db63          	bge	s3,s4,80003694 <filewrite+0xde>
      int n1 = n - i;
    80003682:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003686:	84be                	mv	s1,a5
    80003688:	2781                	sext.w	a5,a5
    8000368a:	fafb56e3          	bge	s6,a5,80003636 <filewrite+0x80>
    8000368e:	84de                	mv	s1,s7
    80003690:	b75d                	j	80003636 <filewrite+0x80>
    int i = 0;
    80003692:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003694:	013a1f63          	bne	s4,s3,800036b2 <filewrite+0xfc>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003698:	8552                	mv	a0,s4
    8000369a:	60a6                	ld	ra,72(sp)
    8000369c:	6406                	ld	s0,64(sp)
    8000369e:	74e2                	ld	s1,56(sp)
    800036a0:	7942                	ld	s2,48(sp)
    800036a2:	79a2                	ld	s3,40(sp)
    800036a4:	7a02                	ld	s4,32(sp)
    800036a6:	6ae2                	ld	s5,24(sp)
    800036a8:	6b42                	ld	s6,16(sp)
    800036aa:	6ba2                	ld	s7,8(sp)
    800036ac:	6c02                	ld	s8,0(sp)
    800036ae:	6161                	addi	sp,sp,80
    800036b0:	8082                	ret
    ret = (i == n ? n : -1);
    800036b2:	5a7d                	li	s4,-1
    800036b4:	b7d5                	j	80003698 <filewrite+0xe2>
    panic("filewrite");
    800036b6:	00004517          	auipc	a0,0x4
    800036ba:	fd250513          	addi	a0,a0,-46 # 80007688 <syscalls+0x270>
    800036be:	519010ef          	jal	ra,800053d6 <panic>
    return -1;
    800036c2:	5a7d                	li	s4,-1
    800036c4:	bfd1                	j	80003698 <filewrite+0xe2>
      return -1;
    800036c6:	5a7d                	li	s4,-1
    800036c8:	bfc1                	j	80003698 <filewrite+0xe2>
    800036ca:	5a7d                	li	s4,-1
    800036cc:	b7f1                	j	80003698 <filewrite+0xe2>

00000000800036ce <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800036ce:	7179                	addi	sp,sp,-48
    800036d0:	f406                	sd	ra,40(sp)
    800036d2:	f022                	sd	s0,32(sp)
    800036d4:	ec26                	sd	s1,24(sp)
    800036d6:	e84a                	sd	s2,16(sp)
    800036d8:	e44e                	sd	s3,8(sp)
    800036da:	e052                	sd	s4,0(sp)
    800036dc:	1800                	addi	s0,sp,48
    800036de:	84aa                	mv	s1,a0
    800036e0:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800036e2:	0005b023          	sd	zero,0(a1)
    800036e6:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800036ea:	c75ff0ef          	jal	ra,8000335e <filealloc>
    800036ee:	e088                	sd	a0,0(s1)
    800036f0:	cd35                	beqz	a0,8000376c <pipealloc+0x9e>
    800036f2:	c6dff0ef          	jal	ra,8000335e <filealloc>
    800036f6:	00aa3023          	sd	a0,0(s4)
    800036fa:	c52d                	beqz	a0,80003764 <pipealloc+0x96>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800036fc:	a01fc0ef          	jal	ra,800000fc <kalloc>
    80003700:	892a                	mv	s2,a0
    80003702:	cd31                	beqz	a0,8000375e <pipealloc+0x90>
    goto bad;
  pi->readopen = 1;
    80003704:	4985                	li	s3,1
    80003706:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    8000370a:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    8000370e:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003712:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003716:	00004597          	auipc	a1,0x4
    8000371a:	f8258593          	addi	a1,a1,-126 # 80007698 <syscalls+0x280>
    8000371e:	74d010ef          	jal	ra,8000566a <initlock>
  (*f0)->type = FD_PIPE;
    80003722:	609c                	ld	a5,0(s1)
    80003724:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003728:	609c                	ld	a5,0(s1)
    8000372a:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000372e:	609c                	ld	a5,0(s1)
    80003730:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003734:	609c                	ld	a5,0(s1)
    80003736:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    8000373a:	000a3783          	ld	a5,0(s4)
    8000373e:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003742:	000a3783          	ld	a5,0(s4)
    80003746:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000374a:	000a3783          	ld	a5,0(s4)
    8000374e:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003752:	000a3783          	ld	a5,0(s4)
    80003756:	0127b823          	sd	s2,16(a5)
  return 0;
    8000375a:	4501                	li	a0,0
    8000375c:	a005                	j	8000377c <pipealloc+0xae>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    8000375e:	6088                	ld	a0,0(s1)
    80003760:	e501                	bnez	a0,80003768 <pipealloc+0x9a>
    80003762:	a029                	j	8000376c <pipealloc+0x9e>
    80003764:	6088                	ld	a0,0(s1)
    80003766:	c11d                	beqz	a0,8000378c <pipealloc+0xbe>
    fileclose(*f0);
    80003768:	c9bff0ef          	jal	ra,80003402 <fileclose>
  if(*f1)
    8000376c:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003770:	557d                	li	a0,-1
  if(*f1)
    80003772:	c789                	beqz	a5,8000377c <pipealloc+0xae>
    fileclose(*f1);
    80003774:	853e                	mv	a0,a5
    80003776:	c8dff0ef          	jal	ra,80003402 <fileclose>
  return -1;
    8000377a:	557d                	li	a0,-1
}
    8000377c:	70a2                	ld	ra,40(sp)
    8000377e:	7402                	ld	s0,32(sp)
    80003780:	64e2                	ld	s1,24(sp)
    80003782:	6942                	ld	s2,16(sp)
    80003784:	69a2                	ld	s3,8(sp)
    80003786:	6a02                	ld	s4,0(sp)
    80003788:	6145                	addi	sp,sp,48
    8000378a:	8082                	ret
  return -1;
    8000378c:	557d                	li	a0,-1
    8000378e:	b7fd                	j	8000377c <pipealloc+0xae>

0000000080003790 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003790:	1101                	addi	sp,sp,-32
    80003792:	ec06                	sd	ra,24(sp)
    80003794:	e822                	sd	s0,16(sp)
    80003796:	e426                	sd	s1,8(sp)
    80003798:	e04a                	sd	s2,0(sp)
    8000379a:	1000                	addi	s0,sp,32
    8000379c:	84aa                	mv	s1,a0
    8000379e:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800037a0:	74b010ef          	jal	ra,800056ea <acquire>
  if(writable){
    800037a4:	02090763          	beqz	s2,800037d2 <pipeclose+0x42>
    pi->writeopen = 0;
    800037a8:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800037ac:	21848513          	addi	a0,s1,536
    800037b0:	c4dfd0ef          	jal	ra,800013fc <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800037b4:	2204b783          	ld	a5,544(s1)
    800037b8:	e785                	bnez	a5,800037e0 <pipeclose+0x50>
    release(&pi->lock);
    800037ba:	8526                	mv	a0,s1
    800037bc:	7c7010ef          	jal	ra,80005782 <release>
    kfree((char*)pi);
    800037c0:	8526                	mv	a0,s1
    800037c2:	85bfc0ef          	jal	ra,8000001c <kfree>
  } else
    release(&pi->lock);
}
    800037c6:	60e2                	ld	ra,24(sp)
    800037c8:	6442                	ld	s0,16(sp)
    800037ca:	64a2                	ld	s1,8(sp)
    800037cc:	6902                	ld	s2,0(sp)
    800037ce:	6105                	addi	sp,sp,32
    800037d0:	8082                	ret
    pi->readopen = 0;
    800037d2:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800037d6:	21c48513          	addi	a0,s1,540
    800037da:	c23fd0ef          	jal	ra,800013fc <wakeup>
    800037de:	bfd9                	j	800037b4 <pipeclose+0x24>
    release(&pi->lock);
    800037e0:	8526                	mv	a0,s1
    800037e2:	7a1010ef          	jal	ra,80005782 <release>
}
    800037e6:	b7c5                	j	800037c6 <pipeclose+0x36>

00000000800037e8 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800037e8:	711d                	addi	sp,sp,-96
    800037ea:	ec86                	sd	ra,88(sp)
    800037ec:	e8a2                	sd	s0,80(sp)
    800037ee:	e4a6                	sd	s1,72(sp)
    800037f0:	e0ca                	sd	s2,64(sp)
    800037f2:	fc4e                	sd	s3,56(sp)
    800037f4:	f852                	sd	s4,48(sp)
    800037f6:	f456                	sd	s5,40(sp)
    800037f8:	f05a                	sd	s6,32(sp)
    800037fa:	ec5e                	sd	s7,24(sp)
    800037fc:	e862                	sd	s8,16(sp)
    800037fe:	1080                	addi	s0,sp,96
    80003800:	84aa                	mv	s1,a0
    80003802:	8aae                	mv	s5,a1
    80003804:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003806:	d4cfd0ef          	jal	ra,80000d52 <myproc>
    8000380a:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000380c:	8526                	mv	a0,s1
    8000380e:	6dd010ef          	jal	ra,800056ea <acquire>
  while(i < n){
    80003812:	09405c63          	blez	s4,800038aa <pipewrite+0xc2>
  int i = 0;
    80003816:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003818:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000381a:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000381e:	21c48b93          	addi	s7,s1,540
    80003822:	a81d                	j	80003858 <pipewrite+0x70>
      release(&pi->lock);
    80003824:	8526                	mv	a0,s1
    80003826:	75d010ef          	jal	ra,80005782 <release>
      return -1;
    8000382a:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000382c:	854a                	mv	a0,s2
    8000382e:	60e6                	ld	ra,88(sp)
    80003830:	6446                	ld	s0,80(sp)
    80003832:	64a6                	ld	s1,72(sp)
    80003834:	6906                	ld	s2,64(sp)
    80003836:	79e2                	ld	s3,56(sp)
    80003838:	7a42                	ld	s4,48(sp)
    8000383a:	7aa2                	ld	s5,40(sp)
    8000383c:	7b02                	ld	s6,32(sp)
    8000383e:	6be2                	ld	s7,24(sp)
    80003840:	6c42                	ld	s8,16(sp)
    80003842:	6125                	addi	sp,sp,96
    80003844:	8082                	ret
      wakeup(&pi->nread);
    80003846:	8562                	mv	a0,s8
    80003848:	bb5fd0ef          	jal	ra,800013fc <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000384c:	85a6                	mv	a1,s1
    8000384e:	855e                	mv	a0,s7
    80003850:	b61fd0ef          	jal	ra,800013b0 <sleep>
  while(i < n){
    80003854:	05495c63          	bge	s2,s4,800038ac <pipewrite+0xc4>
    if(pi->readopen == 0 || killed(pr)){
    80003858:	2204a783          	lw	a5,544(s1)
    8000385c:	d7e1                	beqz	a5,80003824 <pipewrite+0x3c>
    8000385e:	854e                	mv	a0,s3
    80003860:	d89fd0ef          	jal	ra,800015e8 <killed>
    80003864:	f161                	bnez	a0,80003824 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003866:	2184a783          	lw	a5,536(s1)
    8000386a:	21c4a703          	lw	a4,540(s1)
    8000386e:	2007879b          	addiw	a5,a5,512
    80003872:	fcf70ae3          	beq	a4,a5,80003846 <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003876:	4685                	li	a3,1
    80003878:	01590633          	add	a2,s2,s5
    8000387c:	faf40593          	addi	a1,s0,-81
    80003880:	0d09b503          	ld	a0,208(s3)
    80003884:	a3afd0ef          	jal	ra,80000abe <copyin>
    80003888:	03650263          	beq	a0,s6,800038ac <pipewrite+0xc4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000388c:	21c4a783          	lw	a5,540(s1)
    80003890:	0017871b          	addiw	a4,a5,1
    80003894:	20e4ae23          	sw	a4,540(s1)
    80003898:	1ff7f793          	andi	a5,a5,511
    8000389c:	97a6                	add	a5,a5,s1
    8000389e:	faf44703          	lbu	a4,-81(s0)
    800038a2:	00e78c23          	sb	a4,24(a5)
      i++;
    800038a6:	2905                	addiw	s2,s2,1
    800038a8:	b775                	j	80003854 <pipewrite+0x6c>
  int i = 0;
    800038aa:	4901                	li	s2,0
  wakeup(&pi->nread);
    800038ac:	21848513          	addi	a0,s1,536
    800038b0:	b4dfd0ef          	jal	ra,800013fc <wakeup>
  release(&pi->lock);
    800038b4:	8526                	mv	a0,s1
    800038b6:	6cd010ef          	jal	ra,80005782 <release>
  return i;
    800038ba:	bf8d                	j	8000382c <pipewrite+0x44>

00000000800038bc <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800038bc:	715d                	addi	sp,sp,-80
    800038be:	e486                	sd	ra,72(sp)
    800038c0:	e0a2                	sd	s0,64(sp)
    800038c2:	fc26                	sd	s1,56(sp)
    800038c4:	f84a                	sd	s2,48(sp)
    800038c6:	f44e                	sd	s3,40(sp)
    800038c8:	f052                	sd	s4,32(sp)
    800038ca:	ec56                	sd	s5,24(sp)
    800038cc:	e85a                	sd	s6,16(sp)
    800038ce:	0880                	addi	s0,sp,80
    800038d0:	84aa                	mv	s1,a0
    800038d2:	892e                	mv	s2,a1
    800038d4:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800038d6:	c7cfd0ef          	jal	ra,80000d52 <myproc>
    800038da:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800038dc:	8526                	mv	a0,s1
    800038de:	60d010ef          	jal	ra,800056ea <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800038e2:	2184a703          	lw	a4,536(s1)
    800038e6:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800038ea:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800038ee:	02f71363          	bne	a4,a5,80003914 <piperead+0x58>
    800038f2:	2244a783          	lw	a5,548(s1)
    800038f6:	cf99                	beqz	a5,80003914 <piperead+0x58>
    if(killed(pr)){
    800038f8:	8552                	mv	a0,s4
    800038fa:	ceffd0ef          	jal	ra,800015e8 <killed>
    800038fe:	e141                	bnez	a0,8000397e <piperead+0xc2>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003900:	85a6                	mv	a1,s1
    80003902:	854e                	mv	a0,s3
    80003904:	aadfd0ef          	jal	ra,800013b0 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003908:	2184a703          	lw	a4,536(s1)
    8000390c:	21c4a783          	lw	a5,540(s1)
    80003910:	fef701e3          	beq	a4,a5,800038f2 <piperead+0x36>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003914:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003916:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003918:	05505163          	blez	s5,8000395a <piperead+0x9e>
    if(pi->nread == pi->nwrite)
    8000391c:	2184a783          	lw	a5,536(s1)
    80003920:	21c4a703          	lw	a4,540(s1)
    80003924:	02f70b63          	beq	a4,a5,8000395a <piperead+0x9e>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003928:	0017871b          	addiw	a4,a5,1
    8000392c:	20e4ac23          	sw	a4,536(s1)
    80003930:	1ff7f793          	andi	a5,a5,511
    80003934:	97a6                	add	a5,a5,s1
    80003936:	0187c783          	lbu	a5,24(a5)
    8000393a:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000393e:	4685                	li	a3,1
    80003940:	fbf40613          	addi	a2,s0,-65
    80003944:	85ca                	mv	a1,s2
    80003946:	0d0a3503          	ld	a0,208(s4)
    8000394a:	8bcfd0ef          	jal	ra,80000a06 <copyout>
    8000394e:	01650663          	beq	a0,s6,8000395a <piperead+0x9e>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003952:	2985                	addiw	s3,s3,1
    80003954:	0905                	addi	s2,s2,1
    80003956:	fd3a93e3          	bne	s5,s3,8000391c <piperead+0x60>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000395a:	21c48513          	addi	a0,s1,540
    8000395e:	a9ffd0ef          	jal	ra,800013fc <wakeup>
  release(&pi->lock);
    80003962:	8526                	mv	a0,s1
    80003964:	61f010ef          	jal	ra,80005782 <release>
  return i;
}
    80003968:	854e                	mv	a0,s3
    8000396a:	60a6                	ld	ra,72(sp)
    8000396c:	6406                	ld	s0,64(sp)
    8000396e:	74e2                	ld	s1,56(sp)
    80003970:	7942                	ld	s2,48(sp)
    80003972:	79a2                	ld	s3,40(sp)
    80003974:	7a02                	ld	s4,32(sp)
    80003976:	6ae2                	ld	s5,24(sp)
    80003978:	6b42                	ld	s6,16(sp)
    8000397a:	6161                	addi	sp,sp,80
    8000397c:	8082                	ret
      release(&pi->lock);
    8000397e:	8526                	mv	a0,s1
    80003980:	603010ef          	jal	ra,80005782 <release>
      return -1;
    80003984:	59fd                	li	s3,-1
    80003986:	b7cd                	j	80003968 <piperead+0xac>

0000000080003988 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80003988:	1141                	addi	sp,sp,-16
    8000398a:	e422                	sd	s0,8(sp)
    8000398c:	0800                	addi	s0,sp,16
    8000398e:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003990:	8905                	andi	a0,a0,1
    80003992:	c111                	beqz	a0,80003996 <flags2perm+0xe>
      perm = PTE_X;
    80003994:	4521                	li	a0,8
    if(flags & 0x2)
    80003996:	8b89                	andi	a5,a5,2
    80003998:	c399                	beqz	a5,8000399e <flags2perm+0x16>
      perm |= PTE_W;
    8000399a:	00456513          	ori	a0,a0,4
    return perm;
}
    8000399e:	6422                	ld	s0,8(sp)
    800039a0:	0141                	addi	sp,sp,16
    800039a2:	8082                	ret

00000000800039a4 <exec>:

int
exec(char *path, char **argv)
{
    800039a4:	de010113          	addi	sp,sp,-544
    800039a8:	20113c23          	sd	ra,536(sp)
    800039ac:	20813823          	sd	s0,528(sp)
    800039b0:	20913423          	sd	s1,520(sp)
    800039b4:	21213023          	sd	s2,512(sp)
    800039b8:	ffce                	sd	s3,504(sp)
    800039ba:	fbd2                	sd	s4,496(sp)
    800039bc:	f7d6                	sd	s5,488(sp)
    800039be:	f3da                	sd	s6,480(sp)
    800039c0:	efde                	sd	s7,472(sp)
    800039c2:	ebe2                	sd	s8,464(sp)
    800039c4:	e7e6                	sd	s9,456(sp)
    800039c6:	e3ea                	sd	s10,448(sp)
    800039c8:	ff6e                	sd	s11,440(sp)
    800039ca:	1400                	addi	s0,sp,544
    800039cc:	892a                	mv	s2,a0
    800039ce:	dea43423          	sd	a0,-536(s0)
    800039d2:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800039d6:	b7cfd0ef          	jal	ra,80000d52 <myproc>
    800039da:	84aa                	mv	s1,a0

  begin_op();
    800039dc:	e0aff0ef          	jal	ra,80002fe6 <begin_op>

  if((ip = namei(path)) == 0){
    800039e0:	854a                	mv	a0,s2
    800039e2:	c2cff0ef          	jal	ra,80002e0e <namei>
    800039e6:	c13d                	beqz	a0,80003a4c <exec+0xa8>
    800039e8:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800039ea:	d73fe0ef          	jal	ra,8000275c <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800039ee:	04000713          	li	a4,64
    800039f2:	4681                	li	a3,0
    800039f4:	e5040613          	addi	a2,s0,-432
    800039f8:	4581                	li	a1,0
    800039fa:	8556                	mv	a0,s5
    800039fc:	fb1fe0ef          	jal	ra,800029ac <readi>
    80003a00:	04000793          	li	a5,64
    80003a04:	00f51a63          	bne	a0,a5,80003a18 <exec+0x74>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80003a08:	e5042703          	lw	a4,-432(s0)
    80003a0c:	464c47b7          	lui	a5,0x464c4
    80003a10:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003a14:	04f70063          	beq	a4,a5,80003a54 <exec+0xb0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003a18:	8556                	mv	a0,s5
    80003a1a:	f49fe0ef          	jal	ra,80002962 <iunlockput>
    end_op();
    80003a1e:	e38ff0ef          	jal	ra,80003056 <end_op>
  }
  return -1;
    80003a22:	557d                	li	a0,-1
}
    80003a24:	21813083          	ld	ra,536(sp)
    80003a28:	21013403          	ld	s0,528(sp)
    80003a2c:	20813483          	ld	s1,520(sp)
    80003a30:	20013903          	ld	s2,512(sp)
    80003a34:	79fe                	ld	s3,504(sp)
    80003a36:	7a5e                	ld	s4,496(sp)
    80003a38:	7abe                	ld	s5,488(sp)
    80003a3a:	7b1e                	ld	s6,480(sp)
    80003a3c:	6bfe                	ld	s7,472(sp)
    80003a3e:	6c5e                	ld	s8,464(sp)
    80003a40:	6cbe                	ld	s9,456(sp)
    80003a42:	6d1e                	ld	s10,448(sp)
    80003a44:	7dfa                	ld	s11,440(sp)
    80003a46:	22010113          	addi	sp,sp,544
    80003a4a:	8082                	ret
    end_op();
    80003a4c:	e0aff0ef          	jal	ra,80003056 <end_op>
    return -1;
    80003a50:	557d                	li	a0,-1
    80003a52:	bfc9                	j	80003a24 <exec+0x80>
  if((pagetable = proc_pagetable(p)) == 0)
    80003a54:	8526                	mv	a0,s1
    80003a56:	ba4fd0ef          	jal	ra,80000dfa <proc_pagetable>
    80003a5a:	8b2a                	mv	s6,a0
    80003a5c:	dd55                	beqz	a0,80003a18 <exec+0x74>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003a5e:	e7042783          	lw	a5,-400(s0)
    80003a62:	e8845703          	lhu	a4,-376(s0)
    80003a66:	c325                	beqz	a4,80003ac6 <exec+0x122>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003a68:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003a6a:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    80003a6e:	6a05                	lui	s4,0x1
    80003a70:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80003a74:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    80003a78:	6d85                	lui	s11,0x1
    80003a7a:	7d7d                	lui	s10,0xfffff
    80003a7c:	a411                	j	80003c80 <exec+0x2dc>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80003a7e:	00004517          	auipc	a0,0x4
    80003a82:	c2250513          	addi	a0,a0,-990 # 800076a0 <syscalls+0x288>
    80003a86:	151010ef          	jal	ra,800053d6 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003a8a:	874a                	mv	a4,s2
    80003a8c:	009c86bb          	addw	a3,s9,s1
    80003a90:	4581                	li	a1,0
    80003a92:	8556                	mv	a0,s5
    80003a94:	f19fe0ef          	jal	ra,800029ac <readi>
    80003a98:	2501                	sext.w	a0,a0
    80003a9a:	18a91263          	bne	s2,a0,80003c1e <exec+0x27a>
  for(i = 0; i < sz; i += PGSIZE){
    80003a9e:	009d84bb          	addw	s1,s11,s1
    80003aa2:	013d09bb          	addw	s3,s10,s3
    80003aa6:	1b74fd63          	bgeu	s1,s7,80003c60 <exec+0x2bc>
    pa = walkaddr(pagetable, va + i);
    80003aaa:	02049593          	slli	a1,s1,0x20
    80003aae:	9181                	srli	a1,a1,0x20
    80003ab0:	95e2                	add	a1,a1,s8
    80003ab2:	855a                	mv	a0,s6
    80003ab4:	9affc0ef          	jal	ra,80000462 <walkaddr>
    80003ab8:	862a                	mv	a2,a0
    if(pa == 0)
    80003aba:	d171                	beqz	a0,80003a7e <exec+0xda>
      n = PGSIZE;
    80003abc:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    80003abe:	fd49f6e3          	bgeu	s3,s4,80003a8a <exec+0xe6>
      n = sz - i;
    80003ac2:	894e                	mv	s2,s3
    80003ac4:	b7d9                	j	80003a8a <exec+0xe6>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003ac6:	4901                	li	s2,0
  iunlockput(ip);
    80003ac8:	8556                	mv	a0,s5
    80003aca:	e99fe0ef          	jal	ra,80002962 <iunlockput>
  end_op();
    80003ace:	d88ff0ef          	jal	ra,80003056 <end_op>
  p = myproc();
    80003ad2:	a80fd0ef          	jal	ra,80000d52 <myproc>
    80003ad6:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80003ad8:	0c853d03          	ld	s10,200(a0)
  sz = PGROUNDUP(sz);
    80003adc:	6785                	lui	a5,0x1
    80003ade:	17fd                	addi	a5,a5,-1
    80003ae0:	993e                	add	s2,s2,a5
    80003ae2:	77fd                	lui	a5,0xfffff
    80003ae4:	00f977b3          	and	a5,s2,a5
    80003ae8:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003aec:	4691                	li	a3,4
    80003aee:	660d                	lui	a2,0x3
    80003af0:	963e                	add	a2,a2,a5
    80003af2:	85be                	mv	a1,a5
    80003af4:	855a                	mv	a0,s6
    80003af6:	cc5fc0ef          	jal	ra,800007ba <uvmalloc>
    80003afa:	8c2a                	mv	s8,a0
  ip = 0;
    80003afc:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003afe:	12050063          	beqz	a0,80003c1e <exec+0x27a>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003b02:	75f5                	lui	a1,0xffffd
    80003b04:	95aa                	add	a1,a1,a0
    80003b06:	855a                	mv	a0,s6
    80003b08:	ed5fc0ef          	jal	ra,800009dc <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003b0c:	7af9                	lui	s5,0xffffe
    80003b0e:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80003b10:	df043783          	ld	a5,-528(s0)
    80003b14:	6388                	ld	a0,0(a5)
    80003b16:	c135                	beqz	a0,80003b7a <exec+0x1d6>
    80003b18:	e9040993          	addi	s3,s0,-368
    80003b1c:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80003b20:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80003b22:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80003b24:	fa0fc0ef          	jal	ra,800002c4 <strlen>
    80003b28:	0015079b          	addiw	a5,a0,1
    80003b2c:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003b30:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80003b34:	11596a63          	bltu	s2,s5,80003c48 <exec+0x2a4>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003b38:	df043d83          	ld	s11,-528(s0)
    80003b3c:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80003b40:	8552                	mv	a0,s4
    80003b42:	f82fc0ef          	jal	ra,800002c4 <strlen>
    80003b46:	0015069b          	addiw	a3,a0,1
    80003b4a:	8652                	mv	a2,s4
    80003b4c:	85ca                	mv	a1,s2
    80003b4e:	855a                	mv	a0,s6
    80003b50:	eb7fc0ef          	jal	ra,80000a06 <copyout>
    80003b54:	0e054e63          	bltz	a0,80003c50 <exec+0x2ac>
    ustack[argc] = sp;
    80003b58:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80003b5c:	0485                	addi	s1,s1,1
    80003b5e:	008d8793          	addi	a5,s11,8
    80003b62:	def43823          	sd	a5,-528(s0)
    80003b66:	008db503          	ld	a0,8(s11)
    80003b6a:	c911                	beqz	a0,80003b7e <exec+0x1da>
    if(argc >= MAXARG)
    80003b6c:	09a1                	addi	s3,s3,8
    80003b6e:	fb3c9be3          	bne	s9,s3,80003b24 <exec+0x180>
  sz = sz1;
    80003b72:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80003b76:	4a81                	li	s5,0
    80003b78:	a05d                	j	80003c1e <exec+0x27a>
  sp = sz;
    80003b7a:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80003b7c:	4481                	li	s1,0
  ustack[argc] = 0;
    80003b7e:	00349793          	slli	a5,s1,0x3
    80003b82:	f9040713          	addi	a4,s0,-112
    80003b86:	97ba                	add	a5,a5,a4
    80003b88:	f007b023          	sd	zero,-256(a5) # ffffffffffffef00 <end+0xffffffff7ffde0c0>
  sp -= (argc+1) * sizeof(uint64);
    80003b8c:	00148693          	addi	a3,s1,1
    80003b90:	068e                	slli	a3,a3,0x3
    80003b92:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003b96:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80003b9a:	01597663          	bgeu	s2,s5,80003ba6 <exec+0x202>
  sz = sz1;
    80003b9e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80003ba2:	4a81                	li	s5,0
    80003ba4:	a8ad                	j	80003c1e <exec+0x27a>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003ba6:	e9040613          	addi	a2,s0,-368
    80003baa:	85ca                	mv	a1,s2
    80003bac:	855a                	mv	a0,s6
    80003bae:	e59fc0ef          	jal	ra,80000a06 <copyout>
    80003bb2:	0a054363          	bltz	a0,80003c58 <exec+0x2b4>
  p->trapframe->a1 = sp;
    80003bb6:	040bb783          	ld	a5,64(s7) # 1040 <_entry-0x7fffefc0>
    80003bba:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003bbe:	de843783          	ld	a5,-536(s0)
    80003bc2:	0007c703          	lbu	a4,0(a5)
    80003bc6:	cf11                	beqz	a4,80003be2 <exec+0x23e>
    80003bc8:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003bca:	02f00693          	li	a3,47
    80003bce:	a039                	j	80003bdc <exec+0x238>
      last = s+1;
    80003bd0:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80003bd4:	0785                	addi	a5,a5,1
    80003bd6:	fff7c703          	lbu	a4,-1(a5)
    80003bda:	c701                	beqz	a4,80003be2 <exec+0x23e>
    if(*s == '/')
    80003bdc:	fed71ce3          	bne	a4,a3,80003bd4 <exec+0x230>
    80003be0:	bfc5                	j	80003bd0 <exec+0x22c>
  safestrcpy(p->name, last, sizeof(p->name));
    80003be2:	4641                	li	a2,16
    80003be4:	de843583          	ld	a1,-536(s0)
    80003be8:	160b8513          	addi	a0,s7,352
    80003bec:	ea6fc0ef          	jal	ra,80000292 <safestrcpy>
  oldpagetable = p->pagetable;
    80003bf0:	0d0bb503          	ld	a0,208(s7)
  p->pagetable = pagetable;
    80003bf4:	0d6bb823          	sd	s6,208(s7)
  p->sz = sz;
    80003bf8:	0d8bb423          	sd	s8,200(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80003bfc:	040bb783          	ld	a5,64(s7)
    80003c00:	e6843703          	ld	a4,-408(s0)
    80003c04:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003c06:	040bb783          	ld	a5,64(s7)
    80003c0a:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003c0e:	85ea                	mv	a1,s10
    80003c10:	aa6fd0ef          	jal	ra,80000eb6 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003c14:	0004851b          	sext.w	a0,s1
    80003c18:	b531                	j	80003a24 <exec+0x80>
    80003c1a:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80003c1e:	df843583          	ld	a1,-520(s0)
    80003c22:	855a                	mv	a0,s6
    80003c24:	a92fd0ef          	jal	ra,80000eb6 <proc_freepagetable>
  if(ip){
    80003c28:	de0a98e3          	bnez	s5,80003a18 <exec+0x74>
  return -1;
    80003c2c:	557d                	li	a0,-1
    80003c2e:	bbdd                	j	80003a24 <exec+0x80>
    80003c30:	df243c23          	sd	s2,-520(s0)
    80003c34:	b7ed                	j	80003c1e <exec+0x27a>
    80003c36:	df243c23          	sd	s2,-520(s0)
    80003c3a:	b7d5                	j	80003c1e <exec+0x27a>
    80003c3c:	df243c23          	sd	s2,-520(s0)
    80003c40:	bff9                	j	80003c1e <exec+0x27a>
    80003c42:	df243c23          	sd	s2,-520(s0)
    80003c46:	bfe1                	j	80003c1e <exec+0x27a>
  sz = sz1;
    80003c48:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80003c4c:	4a81                	li	s5,0
    80003c4e:	bfc1                	j	80003c1e <exec+0x27a>
  sz = sz1;
    80003c50:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80003c54:	4a81                	li	s5,0
    80003c56:	b7e1                	j	80003c1e <exec+0x27a>
  sz = sz1;
    80003c58:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80003c5c:	4a81                	li	s5,0
    80003c5e:	b7c1                	j	80003c1e <exec+0x27a>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003c60:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003c64:	e0843783          	ld	a5,-504(s0)
    80003c68:	0017869b          	addiw	a3,a5,1
    80003c6c:	e0d43423          	sd	a3,-504(s0)
    80003c70:	e0043783          	ld	a5,-512(s0)
    80003c74:	0387879b          	addiw	a5,a5,56
    80003c78:	e8845703          	lhu	a4,-376(s0)
    80003c7c:	e4e6d6e3          	bge	a3,a4,80003ac8 <exec+0x124>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003c80:	2781                	sext.w	a5,a5
    80003c82:	e0f43023          	sd	a5,-512(s0)
    80003c86:	03800713          	li	a4,56
    80003c8a:	86be                	mv	a3,a5
    80003c8c:	e1840613          	addi	a2,s0,-488
    80003c90:	4581                	li	a1,0
    80003c92:	8556                	mv	a0,s5
    80003c94:	d19fe0ef          	jal	ra,800029ac <readi>
    80003c98:	03800793          	li	a5,56
    80003c9c:	f6f51fe3          	bne	a0,a5,80003c1a <exec+0x276>
    if(ph.type != ELF_PROG_LOAD)
    80003ca0:	e1842783          	lw	a5,-488(s0)
    80003ca4:	4705                	li	a4,1
    80003ca6:	fae79fe3          	bne	a5,a4,80003c64 <exec+0x2c0>
    if(ph.memsz < ph.filesz)
    80003caa:	e4043483          	ld	s1,-448(s0)
    80003cae:	e3843783          	ld	a5,-456(s0)
    80003cb2:	f6f4efe3          	bltu	s1,a5,80003c30 <exec+0x28c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003cb6:	e2843783          	ld	a5,-472(s0)
    80003cba:	94be                	add	s1,s1,a5
    80003cbc:	f6f4ede3          	bltu	s1,a5,80003c36 <exec+0x292>
    if(ph.vaddr % PGSIZE != 0)
    80003cc0:	de043703          	ld	a4,-544(s0)
    80003cc4:	8ff9                	and	a5,a5,a4
    80003cc6:	fbbd                	bnez	a5,80003c3c <exec+0x298>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003cc8:	e1c42503          	lw	a0,-484(s0)
    80003ccc:	cbdff0ef          	jal	ra,80003988 <flags2perm>
    80003cd0:	86aa                	mv	a3,a0
    80003cd2:	8626                	mv	a2,s1
    80003cd4:	85ca                	mv	a1,s2
    80003cd6:	855a                	mv	a0,s6
    80003cd8:	ae3fc0ef          	jal	ra,800007ba <uvmalloc>
    80003cdc:	dea43c23          	sd	a0,-520(s0)
    80003ce0:	d12d                	beqz	a0,80003c42 <exec+0x29e>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003ce2:	e2843c03          	ld	s8,-472(s0)
    80003ce6:	e2042c83          	lw	s9,-480(s0)
    80003cea:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003cee:	f60b89e3          	beqz	s7,80003c60 <exec+0x2bc>
    80003cf2:	89de                	mv	s3,s7
    80003cf4:	4481                	li	s1,0
    80003cf6:	bb55                	j	80003aaa <exec+0x106>

0000000080003cf8 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003cf8:	7179                	addi	sp,sp,-48
    80003cfa:	f406                	sd	ra,40(sp)
    80003cfc:	f022                	sd	s0,32(sp)
    80003cfe:	ec26                	sd	s1,24(sp)
    80003d00:	e84a                	sd	s2,16(sp)
    80003d02:	1800                	addi	s0,sp,48
    80003d04:	892e                	mv	s2,a1
    80003d06:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003d08:	fdc40593          	addi	a1,s0,-36
    80003d0c:	f85fd0ef          	jal	ra,80001c90 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003d10:	fdc42703          	lw	a4,-36(s0)
    80003d14:	47bd                	li	a5,15
    80003d16:	02e7e963          	bltu	a5,a4,80003d48 <argfd+0x50>
    80003d1a:	838fd0ef          	jal	ra,80000d52 <myproc>
    80003d1e:	fdc42703          	lw	a4,-36(s0)
    80003d22:	01a70793          	addi	a5,a4,26
    80003d26:	078e                	slli	a5,a5,0x3
    80003d28:	953e                	add	a0,a0,a5
    80003d2a:	651c                	ld	a5,8(a0)
    80003d2c:	c385                	beqz	a5,80003d4c <argfd+0x54>
    return -1;
  if(pfd)
    80003d2e:	00090463          	beqz	s2,80003d36 <argfd+0x3e>
    *pfd = fd;
    80003d32:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003d36:	4501                	li	a0,0
  if(pf)
    80003d38:	c091                	beqz	s1,80003d3c <argfd+0x44>
    *pf = f;
    80003d3a:	e09c                	sd	a5,0(s1)
}
    80003d3c:	70a2                	ld	ra,40(sp)
    80003d3e:	7402                	ld	s0,32(sp)
    80003d40:	64e2                	ld	s1,24(sp)
    80003d42:	6942                	ld	s2,16(sp)
    80003d44:	6145                	addi	sp,sp,48
    80003d46:	8082                	ret
    return -1;
    80003d48:	557d                	li	a0,-1
    80003d4a:	bfcd                	j	80003d3c <argfd+0x44>
    80003d4c:	557d                	li	a0,-1
    80003d4e:	b7fd                	j	80003d3c <argfd+0x44>

0000000080003d50 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003d50:	1101                	addi	sp,sp,-32
    80003d52:	ec06                	sd	ra,24(sp)
    80003d54:	e822                	sd	s0,16(sp)
    80003d56:	e426                	sd	s1,8(sp)
    80003d58:	1000                	addi	s0,sp,32
    80003d5a:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003d5c:	ff7fc0ef          	jal	ra,80000d52 <myproc>
    80003d60:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003d62:	0d850793          	addi	a5,a0,216
    80003d66:	4501                	li	a0,0
    80003d68:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80003d6a:	6398                	ld	a4,0(a5)
    80003d6c:	cb19                	beqz	a4,80003d82 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80003d6e:	2505                	addiw	a0,a0,1
    80003d70:	07a1                	addi	a5,a5,8
    80003d72:	fed51ce3          	bne	a0,a3,80003d6a <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80003d76:	557d                	li	a0,-1
}
    80003d78:	60e2                	ld	ra,24(sp)
    80003d7a:	6442                	ld	s0,16(sp)
    80003d7c:	64a2                	ld	s1,8(sp)
    80003d7e:	6105                	addi	sp,sp,32
    80003d80:	8082                	ret
      p->ofile[fd] = f;
    80003d82:	01a50793          	addi	a5,a0,26
    80003d86:	078e                	slli	a5,a5,0x3
    80003d88:	963e                	add	a2,a2,a5
    80003d8a:	e604                	sd	s1,8(a2)
      return fd;
    80003d8c:	b7f5                	j	80003d78 <fdalloc+0x28>

0000000080003d8e <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80003d8e:	715d                	addi	sp,sp,-80
    80003d90:	e486                	sd	ra,72(sp)
    80003d92:	e0a2                	sd	s0,64(sp)
    80003d94:	fc26                	sd	s1,56(sp)
    80003d96:	f84a                	sd	s2,48(sp)
    80003d98:	f44e                	sd	s3,40(sp)
    80003d9a:	f052                	sd	s4,32(sp)
    80003d9c:	ec56                	sd	s5,24(sp)
    80003d9e:	e85a                	sd	s6,16(sp)
    80003da0:	0880                	addi	s0,sp,80
    80003da2:	8b2e                	mv	s6,a1
    80003da4:	89b2                	mv	s3,a2
    80003da6:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80003da8:	fb040593          	addi	a1,s0,-80
    80003dac:	87cff0ef          	jal	ra,80002e28 <nameiparent>
    80003db0:	84aa                	mv	s1,a0
    80003db2:	10050b63          	beqz	a0,80003ec8 <create+0x13a>
    return 0;

  ilock(dp);
    80003db6:	9a7fe0ef          	jal	ra,8000275c <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80003dba:	4601                	li	a2,0
    80003dbc:	fb040593          	addi	a1,s0,-80
    80003dc0:	8526                	mv	a0,s1
    80003dc2:	de7fe0ef          	jal	ra,80002ba8 <dirlookup>
    80003dc6:	8aaa                	mv	s5,a0
    80003dc8:	c521                	beqz	a0,80003e10 <create+0x82>
    iunlockput(dp);
    80003dca:	8526                	mv	a0,s1
    80003dcc:	b97fe0ef          	jal	ra,80002962 <iunlockput>
    ilock(ip);
    80003dd0:	8556                	mv	a0,s5
    80003dd2:	98bfe0ef          	jal	ra,8000275c <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80003dd6:	000b059b          	sext.w	a1,s6
    80003dda:	4789                	li	a5,2
    80003ddc:	02f59563          	bne	a1,a5,80003e06 <create+0x78>
    80003de0:	044ad783          	lhu	a5,68(s5) # ffffffffffffe044 <end+0xffffffff7ffdd204>
    80003de4:	37f9                	addiw	a5,a5,-2
    80003de6:	17c2                	slli	a5,a5,0x30
    80003de8:	93c1                	srli	a5,a5,0x30
    80003dea:	4705                	li	a4,1
    80003dec:	00f76d63          	bltu	a4,a5,80003e06 <create+0x78>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80003df0:	8556                	mv	a0,s5
    80003df2:	60a6                	ld	ra,72(sp)
    80003df4:	6406                	ld	s0,64(sp)
    80003df6:	74e2                	ld	s1,56(sp)
    80003df8:	7942                	ld	s2,48(sp)
    80003dfa:	79a2                	ld	s3,40(sp)
    80003dfc:	7a02                	ld	s4,32(sp)
    80003dfe:	6ae2                	ld	s5,24(sp)
    80003e00:	6b42                	ld	s6,16(sp)
    80003e02:	6161                	addi	sp,sp,80
    80003e04:	8082                	ret
    iunlockput(ip);
    80003e06:	8556                	mv	a0,s5
    80003e08:	b5bfe0ef          	jal	ra,80002962 <iunlockput>
    return 0;
    80003e0c:	4a81                	li	s5,0
    80003e0e:	b7cd                	j	80003df0 <create+0x62>
  if((ip = ialloc(dp->dev, type)) == 0){
    80003e10:	85da                	mv	a1,s6
    80003e12:	4088                	lw	a0,0(s1)
    80003e14:	fe0fe0ef          	jal	ra,800025f4 <ialloc>
    80003e18:	8a2a                	mv	s4,a0
    80003e1a:	cd1d                	beqz	a0,80003e58 <create+0xca>
  ilock(ip);
    80003e1c:	941fe0ef          	jal	ra,8000275c <ilock>
  ip->major = major;
    80003e20:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80003e24:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80003e28:	4905                	li	s2,1
    80003e2a:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80003e2e:	8552                	mv	a0,s4
    80003e30:	87bfe0ef          	jal	ra,800026aa <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80003e34:	000b059b          	sext.w	a1,s6
    80003e38:	03258563          	beq	a1,s2,80003e62 <create+0xd4>
  if(dirlink(dp, name, ip->inum) < 0)
    80003e3c:	004a2603          	lw	a2,4(s4)
    80003e40:	fb040593          	addi	a1,s0,-80
    80003e44:	8526                	mv	a0,s1
    80003e46:	f2ffe0ef          	jal	ra,80002d74 <dirlink>
    80003e4a:	06054363          	bltz	a0,80003eb0 <create+0x122>
  iunlockput(dp);
    80003e4e:	8526                	mv	a0,s1
    80003e50:	b13fe0ef          	jal	ra,80002962 <iunlockput>
  return ip;
    80003e54:	8ad2                	mv	s5,s4
    80003e56:	bf69                	j	80003df0 <create+0x62>
    iunlockput(dp);
    80003e58:	8526                	mv	a0,s1
    80003e5a:	b09fe0ef          	jal	ra,80002962 <iunlockput>
    return 0;
    80003e5e:	8ad2                	mv	s5,s4
    80003e60:	bf41                	j	80003df0 <create+0x62>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80003e62:	004a2603          	lw	a2,4(s4)
    80003e66:	00004597          	auipc	a1,0x4
    80003e6a:	85a58593          	addi	a1,a1,-1958 # 800076c0 <syscalls+0x2a8>
    80003e6e:	8552                	mv	a0,s4
    80003e70:	f05fe0ef          	jal	ra,80002d74 <dirlink>
    80003e74:	02054e63          	bltz	a0,80003eb0 <create+0x122>
    80003e78:	40d0                	lw	a2,4(s1)
    80003e7a:	00004597          	auipc	a1,0x4
    80003e7e:	84e58593          	addi	a1,a1,-1970 # 800076c8 <syscalls+0x2b0>
    80003e82:	8552                	mv	a0,s4
    80003e84:	ef1fe0ef          	jal	ra,80002d74 <dirlink>
    80003e88:	02054463          	bltz	a0,80003eb0 <create+0x122>
  if(dirlink(dp, name, ip->inum) < 0)
    80003e8c:	004a2603          	lw	a2,4(s4)
    80003e90:	fb040593          	addi	a1,s0,-80
    80003e94:	8526                	mv	a0,s1
    80003e96:	edffe0ef          	jal	ra,80002d74 <dirlink>
    80003e9a:	00054b63          	bltz	a0,80003eb0 <create+0x122>
    dp->nlink++;  // for ".."
    80003e9e:	04a4d783          	lhu	a5,74(s1)
    80003ea2:	2785                	addiw	a5,a5,1
    80003ea4:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80003ea8:	8526                	mv	a0,s1
    80003eaa:	801fe0ef          	jal	ra,800026aa <iupdate>
    80003eae:	b745                	j	80003e4e <create+0xc0>
  ip->nlink = 0;
    80003eb0:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80003eb4:	8552                	mv	a0,s4
    80003eb6:	ff4fe0ef          	jal	ra,800026aa <iupdate>
  iunlockput(ip);
    80003eba:	8552                	mv	a0,s4
    80003ebc:	aa7fe0ef          	jal	ra,80002962 <iunlockput>
  iunlockput(dp);
    80003ec0:	8526                	mv	a0,s1
    80003ec2:	aa1fe0ef          	jal	ra,80002962 <iunlockput>
  return 0;
    80003ec6:	b72d                	j	80003df0 <create+0x62>
    return 0;
    80003ec8:	8aaa                	mv	s5,a0
    80003eca:	b71d                	j	80003df0 <create+0x62>

0000000080003ecc <sys_dup>:
{
    80003ecc:	7179                	addi	sp,sp,-48
    80003ece:	f406                	sd	ra,40(sp)
    80003ed0:	f022                	sd	s0,32(sp)
    80003ed2:	ec26                	sd	s1,24(sp)
    80003ed4:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80003ed6:	fd840613          	addi	a2,s0,-40
    80003eda:	4581                	li	a1,0
    80003edc:	4501                	li	a0,0
    80003ede:	e1bff0ef          	jal	ra,80003cf8 <argfd>
    return -1;
    80003ee2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80003ee4:	00054f63          	bltz	a0,80003f02 <sys_dup+0x36>
  if((fd=fdalloc(f)) < 0)
    80003ee8:	fd843503          	ld	a0,-40(s0)
    80003eec:	e65ff0ef          	jal	ra,80003d50 <fdalloc>
    80003ef0:	84aa                	mv	s1,a0
    return -1;
    80003ef2:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80003ef4:	00054763          	bltz	a0,80003f02 <sys_dup+0x36>
  filedup(f);
    80003ef8:	fd843503          	ld	a0,-40(s0)
    80003efc:	cc0ff0ef          	jal	ra,800033bc <filedup>
  return fd;
    80003f00:	87a6                	mv	a5,s1
}
    80003f02:	853e                	mv	a0,a5
    80003f04:	70a2                	ld	ra,40(sp)
    80003f06:	7402                	ld	s0,32(sp)
    80003f08:	64e2                	ld	s1,24(sp)
    80003f0a:	6145                	addi	sp,sp,48
    80003f0c:	8082                	ret

0000000080003f0e <sys_read>:
{
    80003f0e:	7179                	addi	sp,sp,-48
    80003f10:	f406                	sd	ra,40(sp)
    80003f12:	f022                	sd	s0,32(sp)
    80003f14:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80003f16:	fd840593          	addi	a1,s0,-40
    80003f1a:	4505                	li	a0,1
    80003f1c:	d91fd0ef          	jal	ra,80001cac <argaddr>
  argint(2, &n);
    80003f20:	fe440593          	addi	a1,s0,-28
    80003f24:	4509                	li	a0,2
    80003f26:	d6bfd0ef          	jal	ra,80001c90 <argint>
  if(argfd(0, 0, &f) < 0)
    80003f2a:	fe840613          	addi	a2,s0,-24
    80003f2e:	4581                	li	a1,0
    80003f30:	4501                	li	a0,0
    80003f32:	dc7ff0ef          	jal	ra,80003cf8 <argfd>
    80003f36:	87aa                	mv	a5,a0
    return -1;
    80003f38:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80003f3a:	0007ca63          	bltz	a5,80003f4e <sys_read+0x40>
  return fileread(f, p, n);
    80003f3e:	fe442603          	lw	a2,-28(s0)
    80003f42:	fd843583          	ld	a1,-40(s0)
    80003f46:	fe843503          	ld	a0,-24(s0)
    80003f4a:	dbeff0ef          	jal	ra,80003508 <fileread>
}
    80003f4e:	70a2                	ld	ra,40(sp)
    80003f50:	7402                	ld	s0,32(sp)
    80003f52:	6145                	addi	sp,sp,48
    80003f54:	8082                	ret

0000000080003f56 <sys_write>:
{
    80003f56:	7179                	addi	sp,sp,-48
    80003f58:	f406                	sd	ra,40(sp)
    80003f5a:	f022                	sd	s0,32(sp)
    80003f5c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80003f5e:	fd840593          	addi	a1,s0,-40
    80003f62:	4505                	li	a0,1
    80003f64:	d49fd0ef          	jal	ra,80001cac <argaddr>
  argint(2, &n);
    80003f68:	fe440593          	addi	a1,s0,-28
    80003f6c:	4509                	li	a0,2
    80003f6e:	d23fd0ef          	jal	ra,80001c90 <argint>
  if(argfd(0, 0, &f) < 0)
    80003f72:	fe840613          	addi	a2,s0,-24
    80003f76:	4581                	li	a1,0
    80003f78:	4501                	li	a0,0
    80003f7a:	d7fff0ef          	jal	ra,80003cf8 <argfd>
    80003f7e:	87aa                	mv	a5,a0
    return -1;
    80003f80:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80003f82:	0007ca63          	bltz	a5,80003f96 <sys_write+0x40>
  return filewrite(f, p, n);
    80003f86:	fe442603          	lw	a2,-28(s0)
    80003f8a:	fd843583          	ld	a1,-40(s0)
    80003f8e:	fe843503          	ld	a0,-24(s0)
    80003f92:	e24ff0ef          	jal	ra,800035b6 <filewrite>
}
    80003f96:	70a2                	ld	ra,40(sp)
    80003f98:	7402                	ld	s0,32(sp)
    80003f9a:	6145                	addi	sp,sp,48
    80003f9c:	8082                	ret

0000000080003f9e <sys_close>:
{
    80003f9e:	1101                	addi	sp,sp,-32
    80003fa0:	ec06                	sd	ra,24(sp)
    80003fa2:	e822                	sd	s0,16(sp)
    80003fa4:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80003fa6:	fe040613          	addi	a2,s0,-32
    80003faa:	fec40593          	addi	a1,s0,-20
    80003fae:	4501                	li	a0,0
    80003fb0:	d49ff0ef          	jal	ra,80003cf8 <argfd>
    return -1;
    80003fb4:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80003fb6:	02054063          	bltz	a0,80003fd6 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80003fba:	d99fc0ef          	jal	ra,80000d52 <myproc>
    80003fbe:	fec42783          	lw	a5,-20(s0)
    80003fc2:	07e9                	addi	a5,a5,26
    80003fc4:	078e                	slli	a5,a5,0x3
    80003fc6:	97aa                	add	a5,a5,a0
    80003fc8:	0007b423          	sd	zero,8(a5)
  fileclose(f);
    80003fcc:	fe043503          	ld	a0,-32(s0)
    80003fd0:	c32ff0ef          	jal	ra,80003402 <fileclose>
  return 0;
    80003fd4:	4781                	li	a5,0
}
    80003fd6:	853e                	mv	a0,a5
    80003fd8:	60e2                	ld	ra,24(sp)
    80003fda:	6442                	ld	s0,16(sp)
    80003fdc:	6105                	addi	sp,sp,32
    80003fde:	8082                	ret

0000000080003fe0 <sys_fstat>:
{
    80003fe0:	1101                	addi	sp,sp,-32
    80003fe2:	ec06                	sd	ra,24(sp)
    80003fe4:	e822                	sd	s0,16(sp)
    80003fe6:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80003fe8:	fe040593          	addi	a1,s0,-32
    80003fec:	4505                	li	a0,1
    80003fee:	cbffd0ef          	jal	ra,80001cac <argaddr>
  if(argfd(0, 0, &f) < 0)
    80003ff2:	fe840613          	addi	a2,s0,-24
    80003ff6:	4581                	li	a1,0
    80003ff8:	4501                	li	a0,0
    80003ffa:	cffff0ef          	jal	ra,80003cf8 <argfd>
    80003ffe:	87aa                	mv	a5,a0
    return -1;
    80004000:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004002:	0007c863          	bltz	a5,80004012 <sys_fstat+0x32>
  return filestat(f, st);
    80004006:	fe043583          	ld	a1,-32(s0)
    8000400a:	fe843503          	ld	a0,-24(s0)
    8000400e:	c9cff0ef          	jal	ra,800034aa <filestat>
}
    80004012:	60e2                	ld	ra,24(sp)
    80004014:	6442                	ld	s0,16(sp)
    80004016:	6105                	addi	sp,sp,32
    80004018:	8082                	ret

000000008000401a <sys_link>:
{
    8000401a:	7169                	addi	sp,sp,-304
    8000401c:	f606                	sd	ra,296(sp)
    8000401e:	f222                	sd	s0,288(sp)
    80004020:	ee26                	sd	s1,280(sp)
    80004022:	ea4a                	sd	s2,272(sp)
    80004024:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004026:	08000613          	li	a2,128
    8000402a:	ed040593          	addi	a1,s0,-304
    8000402e:	4501                	li	a0,0
    80004030:	c99fd0ef          	jal	ra,80001cc8 <argstr>
    return -1;
    80004034:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004036:	0c054663          	bltz	a0,80004102 <sys_link+0xe8>
    8000403a:	08000613          	li	a2,128
    8000403e:	f5040593          	addi	a1,s0,-176
    80004042:	4505                	li	a0,1
    80004044:	c85fd0ef          	jal	ra,80001cc8 <argstr>
    return -1;
    80004048:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000404a:	0a054c63          	bltz	a0,80004102 <sys_link+0xe8>
  begin_op();
    8000404e:	f99fe0ef          	jal	ra,80002fe6 <begin_op>
  if((ip = namei(old)) == 0){
    80004052:	ed040513          	addi	a0,s0,-304
    80004056:	db9fe0ef          	jal	ra,80002e0e <namei>
    8000405a:	84aa                	mv	s1,a0
    8000405c:	c525                	beqz	a0,800040c4 <sys_link+0xaa>
  ilock(ip);
    8000405e:	efefe0ef          	jal	ra,8000275c <ilock>
  if(ip->type == T_DIR){
    80004062:	04449703          	lh	a4,68(s1)
    80004066:	4785                	li	a5,1
    80004068:	06f70263          	beq	a4,a5,800040cc <sys_link+0xb2>
  ip->nlink++;
    8000406c:	04a4d783          	lhu	a5,74(s1)
    80004070:	2785                	addiw	a5,a5,1
    80004072:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004076:	8526                	mv	a0,s1
    80004078:	e32fe0ef          	jal	ra,800026aa <iupdate>
  iunlock(ip);
    8000407c:	8526                	mv	a0,s1
    8000407e:	f88fe0ef          	jal	ra,80002806 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004082:	fd040593          	addi	a1,s0,-48
    80004086:	f5040513          	addi	a0,s0,-176
    8000408a:	d9ffe0ef          	jal	ra,80002e28 <nameiparent>
    8000408e:	892a                	mv	s2,a0
    80004090:	c921                	beqz	a0,800040e0 <sys_link+0xc6>
  ilock(dp);
    80004092:	ecafe0ef          	jal	ra,8000275c <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004096:	00092703          	lw	a4,0(s2)
    8000409a:	409c                	lw	a5,0(s1)
    8000409c:	02f71f63          	bne	a4,a5,800040da <sys_link+0xc0>
    800040a0:	40d0                	lw	a2,4(s1)
    800040a2:	fd040593          	addi	a1,s0,-48
    800040a6:	854a                	mv	a0,s2
    800040a8:	ccdfe0ef          	jal	ra,80002d74 <dirlink>
    800040ac:	02054763          	bltz	a0,800040da <sys_link+0xc0>
  iunlockput(dp);
    800040b0:	854a                	mv	a0,s2
    800040b2:	8b1fe0ef          	jal	ra,80002962 <iunlockput>
  iput(ip);
    800040b6:	8526                	mv	a0,s1
    800040b8:	823fe0ef          	jal	ra,800028da <iput>
  end_op();
    800040bc:	f9bfe0ef          	jal	ra,80003056 <end_op>
  return 0;
    800040c0:	4781                	li	a5,0
    800040c2:	a081                	j	80004102 <sys_link+0xe8>
    end_op();
    800040c4:	f93fe0ef          	jal	ra,80003056 <end_op>
    return -1;
    800040c8:	57fd                	li	a5,-1
    800040ca:	a825                	j	80004102 <sys_link+0xe8>
    iunlockput(ip);
    800040cc:	8526                	mv	a0,s1
    800040ce:	895fe0ef          	jal	ra,80002962 <iunlockput>
    end_op();
    800040d2:	f85fe0ef          	jal	ra,80003056 <end_op>
    return -1;
    800040d6:	57fd                	li	a5,-1
    800040d8:	a02d                	j	80004102 <sys_link+0xe8>
    iunlockput(dp);
    800040da:	854a                	mv	a0,s2
    800040dc:	887fe0ef          	jal	ra,80002962 <iunlockput>
  ilock(ip);
    800040e0:	8526                	mv	a0,s1
    800040e2:	e7afe0ef          	jal	ra,8000275c <ilock>
  ip->nlink--;
    800040e6:	04a4d783          	lhu	a5,74(s1)
    800040ea:	37fd                	addiw	a5,a5,-1
    800040ec:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800040f0:	8526                	mv	a0,s1
    800040f2:	db8fe0ef          	jal	ra,800026aa <iupdate>
  iunlockput(ip);
    800040f6:	8526                	mv	a0,s1
    800040f8:	86bfe0ef          	jal	ra,80002962 <iunlockput>
  end_op();
    800040fc:	f5bfe0ef          	jal	ra,80003056 <end_op>
  return -1;
    80004100:	57fd                	li	a5,-1
}
    80004102:	853e                	mv	a0,a5
    80004104:	70b2                	ld	ra,296(sp)
    80004106:	7412                	ld	s0,288(sp)
    80004108:	64f2                	ld	s1,280(sp)
    8000410a:	6952                	ld	s2,272(sp)
    8000410c:	6155                	addi	sp,sp,304
    8000410e:	8082                	ret

0000000080004110 <sys_unlink>:
{
    80004110:	7151                	addi	sp,sp,-240
    80004112:	f586                	sd	ra,232(sp)
    80004114:	f1a2                	sd	s0,224(sp)
    80004116:	eda6                	sd	s1,216(sp)
    80004118:	e9ca                	sd	s2,208(sp)
    8000411a:	e5ce                	sd	s3,200(sp)
    8000411c:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000411e:	08000613          	li	a2,128
    80004122:	f3040593          	addi	a1,s0,-208
    80004126:	4501                	li	a0,0
    80004128:	ba1fd0ef          	jal	ra,80001cc8 <argstr>
    8000412c:	12054b63          	bltz	a0,80004262 <sys_unlink+0x152>
  begin_op();
    80004130:	eb7fe0ef          	jal	ra,80002fe6 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004134:	fb040593          	addi	a1,s0,-80
    80004138:	f3040513          	addi	a0,s0,-208
    8000413c:	cedfe0ef          	jal	ra,80002e28 <nameiparent>
    80004140:	84aa                	mv	s1,a0
    80004142:	c54d                	beqz	a0,800041ec <sys_unlink+0xdc>
  ilock(dp);
    80004144:	e18fe0ef          	jal	ra,8000275c <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004148:	00003597          	auipc	a1,0x3
    8000414c:	57858593          	addi	a1,a1,1400 # 800076c0 <syscalls+0x2a8>
    80004150:	fb040513          	addi	a0,s0,-80
    80004154:	a3ffe0ef          	jal	ra,80002b92 <namecmp>
    80004158:	10050a63          	beqz	a0,8000426c <sys_unlink+0x15c>
    8000415c:	00003597          	auipc	a1,0x3
    80004160:	56c58593          	addi	a1,a1,1388 # 800076c8 <syscalls+0x2b0>
    80004164:	fb040513          	addi	a0,s0,-80
    80004168:	a2bfe0ef          	jal	ra,80002b92 <namecmp>
    8000416c:	10050063          	beqz	a0,8000426c <sys_unlink+0x15c>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004170:	f2c40613          	addi	a2,s0,-212
    80004174:	fb040593          	addi	a1,s0,-80
    80004178:	8526                	mv	a0,s1
    8000417a:	a2ffe0ef          	jal	ra,80002ba8 <dirlookup>
    8000417e:	892a                	mv	s2,a0
    80004180:	0e050663          	beqz	a0,8000426c <sys_unlink+0x15c>
  ilock(ip);
    80004184:	dd8fe0ef          	jal	ra,8000275c <ilock>
  if(ip->nlink < 1)
    80004188:	04a91783          	lh	a5,74(s2)
    8000418c:	06f05463          	blez	a5,800041f4 <sys_unlink+0xe4>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004190:	04491703          	lh	a4,68(s2)
    80004194:	4785                	li	a5,1
    80004196:	06f70563          	beq	a4,a5,80004200 <sys_unlink+0xf0>
  memset(&de, 0, sizeof(de));
    8000419a:	4641                	li	a2,16
    8000419c:	4581                	li	a1,0
    8000419e:	fc040513          	addi	a0,s0,-64
    800041a2:	fabfb0ef          	jal	ra,8000014c <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800041a6:	4741                	li	a4,16
    800041a8:	f2c42683          	lw	a3,-212(s0)
    800041ac:	fc040613          	addi	a2,s0,-64
    800041b0:	4581                	li	a1,0
    800041b2:	8526                	mv	a0,s1
    800041b4:	8ddfe0ef          	jal	ra,80002a90 <writei>
    800041b8:	47c1                	li	a5,16
    800041ba:	08f51563          	bne	a0,a5,80004244 <sys_unlink+0x134>
  if(ip->type == T_DIR){
    800041be:	04491703          	lh	a4,68(s2)
    800041c2:	4785                	li	a5,1
    800041c4:	08f70663          	beq	a4,a5,80004250 <sys_unlink+0x140>
  iunlockput(dp);
    800041c8:	8526                	mv	a0,s1
    800041ca:	f98fe0ef          	jal	ra,80002962 <iunlockput>
  ip->nlink--;
    800041ce:	04a95783          	lhu	a5,74(s2)
    800041d2:	37fd                	addiw	a5,a5,-1
    800041d4:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800041d8:	854a                	mv	a0,s2
    800041da:	cd0fe0ef          	jal	ra,800026aa <iupdate>
  iunlockput(ip);
    800041de:	854a                	mv	a0,s2
    800041e0:	f82fe0ef          	jal	ra,80002962 <iunlockput>
  end_op();
    800041e4:	e73fe0ef          	jal	ra,80003056 <end_op>
  return 0;
    800041e8:	4501                	li	a0,0
    800041ea:	a079                	j	80004278 <sys_unlink+0x168>
    end_op();
    800041ec:	e6bfe0ef          	jal	ra,80003056 <end_op>
    return -1;
    800041f0:	557d                	li	a0,-1
    800041f2:	a059                	j	80004278 <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    800041f4:	00003517          	auipc	a0,0x3
    800041f8:	4dc50513          	addi	a0,a0,1244 # 800076d0 <syscalls+0x2b8>
    800041fc:	1da010ef          	jal	ra,800053d6 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004200:	04c92703          	lw	a4,76(s2)
    80004204:	02000793          	li	a5,32
    80004208:	f8e7f9e3          	bgeu	a5,a4,8000419a <sys_unlink+0x8a>
    8000420c:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004210:	4741                	li	a4,16
    80004212:	86ce                	mv	a3,s3
    80004214:	f1840613          	addi	a2,s0,-232
    80004218:	4581                	li	a1,0
    8000421a:	854a                	mv	a0,s2
    8000421c:	f90fe0ef          	jal	ra,800029ac <readi>
    80004220:	47c1                	li	a5,16
    80004222:	00f51b63          	bne	a0,a5,80004238 <sys_unlink+0x128>
    if(de.inum != 0)
    80004226:	f1845783          	lhu	a5,-232(s0)
    8000422a:	ef95                	bnez	a5,80004266 <sys_unlink+0x156>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000422c:	29c1                	addiw	s3,s3,16
    8000422e:	04c92783          	lw	a5,76(s2)
    80004232:	fcf9efe3          	bltu	s3,a5,80004210 <sys_unlink+0x100>
    80004236:	b795                	j	8000419a <sys_unlink+0x8a>
      panic("isdirempty: readi");
    80004238:	00003517          	auipc	a0,0x3
    8000423c:	4b050513          	addi	a0,a0,1200 # 800076e8 <syscalls+0x2d0>
    80004240:	196010ef          	jal	ra,800053d6 <panic>
    panic("unlink: writei");
    80004244:	00003517          	auipc	a0,0x3
    80004248:	4bc50513          	addi	a0,a0,1212 # 80007700 <syscalls+0x2e8>
    8000424c:	18a010ef          	jal	ra,800053d6 <panic>
    dp->nlink--;
    80004250:	04a4d783          	lhu	a5,74(s1)
    80004254:	37fd                	addiw	a5,a5,-1
    80004256:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000425a:	8526                	mv	a0,s1
    8000425c:	c4efe0ef          	jal	ra,800026aa <iupdate>
    80004260:	b7a5                	j	800041c8 <sys_unlink+0xb8>
    return -1;
    80004262:	557d                	li	a0,-1
    80004264:	a811                	j	80004278 <sys_unlink+0x168>
    iunlockput(ip);
    80004266:	854a                	mv	a0,s2
    80004268:	efafe0ef          	jal	ra,80002962 <iunlockput>
  iunlockput(dp);
    8000426c:	8526                	mv	a0,s1
    8000426e:	ef4fe0ef          	jal	ra,80002962 <iunlockput>
  end_op();
    80004272:	de5fe0ef          	jal	ra,80003056 <end_op>
  return -1;
    80004276:	557d                	li	a0,-1
}
    80004278:	70ae                	ld	ra,232(sp)
    8000427a:	740e                	ld	s0,224(sp)
    8000427c:	64ee                	ld	s1,216(sp)
    8000427e:	694e                	ld	s2,208(sp)
    80004280:	69ae                	ld	s3,200(sp)
    80004282:	616d                	addi	sp,sp,240
    80004284:	8082                	ret

0000000080004286 <sys_open>:

uint64
sys_open(void)
{
    80004286:	7131                	addi	sp,sp,-192
    80004288:	fd06                	sd	ra,184(sp)
    8000428a:	f922                	sd	s0,176(sp)
    8000428c:	f526                	sd	s1,168(sp)
    8000428e:	f14a                	sd	s2,160(sp)
    80004290:	ed4e                	sd	s3,152(sp)
    80004292:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004294:	f4c40593          	addi	a1,s0,-180
    80004298:	4505                	li	a0,1
    8000429a:	9f7fd0ef          	jal	ra,80001c90 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000429e:	08000613          	li	a2,128
    800042a2:	f5040593          	addi	a1,s0,-176
    800042a6:	4501                	li	a0,0
    800042a8:	a21fd0ef          	jal	ra,80001cc8 <argstr>
    800042ac:	87aa                	mv	a5,a0
    return -1;
    800042ae:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    800042b0:	0807cd63          	bltz	a5,8000434a <sys_open+0xc4>

  begin_op();
    800042b4:	d33fe0ef          	jal	ra,80002fe6 <begin_op>

  if(omode & O_CREATE){
    800042b8:	f4c42783          	lw	a5,-180(s0)
    800042bc:	2007f793          	andi	a5,a5,512
    800042c0:	c3c5                	beqz	a5,80004360 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    800042c2:	4681                	li	a3,0
    800042c4:	4601                	li	a2,0
    800042c6:	4589                	li	a1,2
    800042c8:	f5040513          	addi	a0,s0,-176
    800042cc:	ac3ff0ef          	jal	ra,80003d8e <create>
    800042d0:	84aa                	mv	s1,a0
    if(ip == 0){
    800042d2:	c159                	beqz	a0,80004358 <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800042d4:	04449703          	lh	a4,68(s1)
    800042d8:	478d                	li	a5,3
    800042da:	00f71763          	bne	a4,a5,800042e8 <sys_open+0x62>
    800042de:	0464d703          	lhu	a4,70(s1)
    800042e2:	47a5                	li	a5,9
    800042e4:	0ae7e963          	bltu	a5,a4,80004396 <sys_open+0x110>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800042e8:	876ff0ef          	jal	ra,8000335e <filealloc>
    800042ec:	89aa                	mv	s3,a0
    800042ee:	0c050963          	beqz	a0,800043c0 <sys_open+0x13a>
    800042f2:	a5fff0ef          	jal	ra,80003d50 <fdalloc>
    800042f6:	892a                	mv	s2,a0
    800042f8:	0c054163          	bltz	a0,800043ba <sys_open+0x134>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800042fc:	04449703          	lh	a4,68(s1)
    80004300:	478d                	li	a5,3
    80004302:	0af70163          	beq	a4,a5,800043a4 <sys_open+0x11e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004306:	4789                	li	a5,2
    80004308:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    8000430c:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004310:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004314:	f4c42783          	lw	a5,-180(s0)
    80004318:	0017c713          	xori	a4,a5,1
    8000431c:	8b05                	andi	a4,a4,1
    8000431e:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004322:	0037f713          	andi	a4,a5,3
    80004326:	00e03733          	snez	a4,a4
    8000432a:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    8000432e:	4007f793          	andi	a5,a5,1024
    80004332:	c791                	beqz	a5,8000433e <sys_open+0xb8>
    80004334:	04449703          	lh	a4,68(s1)
    80004338:	4789                	li	a5,2
    8000433a:	06f70c63          	beq	a4,a5,800043b2 <sys_open+0x12c>
    itrunc(ip);
  }

  iunlock(ip);
    8000433e:	8526                	mv	a0,s1
    80004340:	cc6fe0ef          	jal	ra,80002806 <iunlock>
  end_op();
    80004344:	d13fe0ef          	jal	ra,80003056 <end_op>

  return fd;
    80004348:	854a                	mv	a0,s2
}
    8000434a:	70ea                	ld	ra,184(sp)
    8000434c:	744a                	ld	s0,176(sp)
    8000434e:	74aa                	ld	s1,168(sp)
    80004350:	790a                	ld	s2,160(sp)
    80004352:	69ea                	ld	s3,152(sp)
    80004354:	6129                	addi	sp,sp,192
    80004356:	8082                	ret
      end_op();
    80004358:	cfffe0ef          	jal	ra,80003056 <end_op>
      return -1;
    8000435c:	557d                	li	a0,-1
    8000435e:	b7f5                	j	8000434a <sys_open+0xc4>
    if((ip = namei(path)) == 0){
    80004360:	f5040513          	addi	a0,s0,-176
    80004364:	aabfe0ef          	jal	ra,80002e0e <namei>
    80004368:	84aa                	mv	s1,a0
    8000436a:	c115                	beqz	a0,8000438e <sys_open+0x108>
    ilock(ip);
    8000436c:	bf0fe0ef          	jal	ra,8000275c <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004370:	04449703          	lh	a4,68(s1)
    80004374:	4785                	li	a5,1
    80004376:	f4f71fe3          	bne	a4,a5,800042d4 <sys_open+0x4e>
    8000437a:	f4c42783          	lw	a5,-180(s0)
    8000437e:	d7ad                	beqz	a5,800042e8 <sys_open+0x62>
      iunlockput(ip);
    80004380:	8526                	mv	a0,s1
    80004382:	de0fe0ef          	jal	ra,80002962 <iunlockput>
      end_op();
    80004386:	cd1fe0ef          	jal	ra,80003056 <end_op>
      return -1;
    8000438a:	557d                	li	a0,-1
    8000438c:	bf7d                	j	8000434a <sys_open+0xc4>
      end_op();
    8000438e:	cc9fe0ef          	jal	ra,80003056 <end_op>
      return -1;
    80004392:	557d                	li	a0,-1
    80004394:	bf5d                	j	8000434a <sys_open+0xc4>
    iunlockput(ip);
    80004396:	8526                	mv	a0,s1
    80004398:	dcafe0ef          	jal	ra,80002962 <iunlockput>
    end_op();
    8000439c:	cbbfe0ef          	jal	ra,80003056 <end_op>
    return -1;
    800043a0:	557d                	li	a0,-1
    800043a2:	b765                	j	8000434a <sys_open+0xc4>
    f->type = FD_DEVICE;
    800043a4:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    800043a8:	04649783          	lh	a5,70(s1)
    800043ac:	02f99223          	sh	a5,36(s3)
    800043b0:	b785                	j	80004310 <sys_open+0x8a>
    itrunc(ip);
    800043b2:	8526                	mv	a0,s1
    800043b4:	c92fe0ef          	jal	ra,80002846 <itrunc>
    800043b8:	b759                	j	8000433e <sys_open+0xb8>
      fileclose(f);
    800043ba:	854e                	mv	a0,s3
    800043bc:	846ff0ef          	jal	ra,80003402 <fileclose>
    iunlockput(ip);
    800043c0:	8526                	mv	a0,s1
    800043c2:	da0fe0ef          	jal	ra,80002962 <iunlockput>
    end_op();
    800043c6:	c91fe0ef          	jal	ra,80003056 <end_op>
    return -1;
    800043ca:	557d                	li	a0,-1
    800043cc:	bfbd                	j	8000434a <sys_open+0xc4>

00000000800043ce <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800043ce:	7175                	addi	sp,sp,-144
    800043d0:	e506                	sd	ra,136(sp)
    800043d2:	e122                	sd	s0,128(sp)
    800043d4:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800043d6:	c11fe0ef          	jal	ra,80002fe6 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    800043da:	08000613          	li	a2,128
    800043de:	f7040593          	addi	a1,s0,-144
    800043e2:	4501                	li	a0,0
    800043e4:	8e5fd0ef          	jal	ra,80001cc8 <argstr>
    800043e8:	02054363          	bltz	a0,8000440e <sys_mkdir+0x40>
    800043ec:	4681                	li	a3,0
    800043ee:	4601                	li	a2,0
    800043f0:	4585                	li	a1,1
    800043f2:	f7040513          	addi	a0,s0,-144
    800043f6:	999ff0ef          	jal	ra,80003d8e <create>
    800043fa:	c911                	beqz	a0,8000440e <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800043fc:	d66fe0ef          	jal	ra,80002962 <iunlockput>
  end_op();
    80004400:	c57fe0ef          	jal	ra,80003056 <end_op>
  return 0;
    80004404:	4501                	li	a0,0
}
    80004406:	60aa                	ld	ra,136(sp)
    80004408:	640a                	ld	s0,128(sp)
    8000440a:	6149                	addi	sp,sp,144
    8000440c:	8082                	ret
    end_op();
    8000440e:	c49fe0ef          	jal	ra,80003056 <end_op>
    return -1;
    80004412:	557d                	li	a0,-1
    80004414:	bfcd                	j	80004406 <sys_mkdir+0x38>

0000000080004416 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004416:	7135                	addi	sp,sp,-160
    80004418:	ed06                	sd	ra,152(sp)
    8000441a:	e922                	sd	s0,144(sp)
    8000441c:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    8000441e:	bc9fe0ef          	jal	ra,80002fe6 <begin_op>
  argint(1, &major);
    80004422:	f6c40593          	addi	a1,s0,-148
    80004426:	4505                	li	a0,1
    80004428:	869fd0ef          	jal	ra,80001c90 <argint>
  argint(2, &minor);
    8000442c:	f6840593          	addi	a1,s0,-152
    80004430:	4509                	li	a0,2
    80004432:	85ffd0ef          	jal	ra,80001c90 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004436:	08000613          	li	a2,128
    8000443a:	f7040593          	addi	a1,s0,-144
    8000443e:	4501                	li	a0,0
    80004440:	889fd0ef          	jal	ra,80001cc8 <argstr>
    80004444:	02054563          	bltz	a0,8000446e <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004448:	f6841683          	lh	a3,-152(s0)
    8000444c:	f6c41603          	lh	a2,-148(s0)
    80004450:	458d                	li	a1,3
    80004452:	f7040513          	addi	a0,s0,-144
    80004456:	939ff0ef          	jal	ra,80003d8e <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000445a:	c911                	beqz	a0,8000446e <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000445c:	d06fe0ef          	jal	ra,80002962 <iunlockput>
  end_op();
    80004460:	bf7fe0ef          	jal	ra,80003056 <end_op>
  return 0;
    80004464:	4501                	li	a0,0
}
    80004466:	60ea                	ld	ra,152(sp)
    80004468:	644a                	ld	s0,144(sp)
    8000446a:	610d                	addi	sp,sp,160
    8000446c:	8082                	ret
    end_op();
    8000446e:	be9fe0ef          	jal	ra,80003056 <end_op>
    return -1;
    80004472:	557d                	li	a0,-1
    80004474:	bfcd                	j	80004466 <sys_mknod+0x50>

0000000080004476 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004476:	7135                	addi	sp,sp,-160
    80004478:	ed06                	sd	ra,152(sp)
    8000447a:	e922                	sd	s0,144(sp)
    8000447c:	e526                	sd	s1,136(sp)
    8000447e:	e14a                	sd	s2,128(sp)
    80004480:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004482:	8d1fc0ef          	jal	ra,80000d52 <myproc>
    80004486:	892a                	mv	s2,a0
  
  begin_op();
    80004488:	b5ffe0ef          	jal	ra,80002fe6 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    8000448c:	08000613          	li	a2,128
    80004490:	f6040593          	addi	a1,s0,-160
    80004494:	4501                	li	a0,0
    80004496:	833fd0ef          	jal	ra,80001cc8 <argstr>
    8000449a:	04054163          	bltz	a0,800044dc <sys_chdir+0x66>
    8000449e:	f6040513          	addi	a0,s0,-160
    800044a2:	96dfe0ef          	jal	ra,80002e0e <namei>
    800044a6:	84aa                	mv	s1,a0
    800044a8:	c915                	beqz	a0,800044dc <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    800044aa:	ab2fe0ef          	jal	ra,8000275c <ilock>
  if(ip->type != T_DIR){
    800044ae:	04449703          	lh	a4,68(s1)
    800044b2:	4785                	li	a5,1
    800044b4:	02f71863          	bne	a4,a5,800044e4 <sys_chdir+0x6e>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800044b8:	8526                	mv	a0,s1
    800044ba:	b4cfe0ef          	jal	ra,80002806 <iunlock>
  iput(p->cwd);
    800044be:	15893503          	ld	a0,344(s2)
    800044c2:	c18fe0ef          	jal	ra,800028da <iput>
  end_op();
    800044c6:	b91fe0ef          	jal	ra,80003056 <end_op>
  p->cwd = ip;
    800044ca:	14993c23          	sd	s1,344(s2)
  return 0;
    800044ce:	4501                	li	a0,0
}
    800044d0:	60ea                	ld	ra,152(sp)
    800044d2:	644a                	ld	s0,144(sp)
    800044d4:	64aa                	ld	s1,136(sp)
    800044d6:	690a                	ld	s2,128(sp)
    800044d8:	610d                	addi	sp,sp,160
    800044da:	8082                	ret
    end_op();
    800044dc:	b7bfe0ef          	jal	ra,80003056 <end_op>
    return -1;
    800044e0:	557d                	li	a0,-1
    800044e2:	b7fd                	j	800044d0 <sys_chdir+0x5a>
    iunlockput(ip);
    800044e4:	8526                	mv	a0,s1
    800044e6:	c7cfe0ef          	jal	ra,80002962 <iunlockput>
    end_op();
    800044ea:	b6dfe0ef          	jal	ra,80003056 <end_op>
    return -1;
    800044ee:	557d                	li	a0,-1
    800044f0:	b7c5                	j	800044d0 <sys_chdir+0x5a>

00000000800044f2 <sys_exec>:

uint64
sys_exec(void)
{
    800044f2:	7145                	addi	sp,sp,-464
    800044f4:	e786                	sd	ra,456(sp)
    800044f6:	e3a2                	sd	s0,448(sp)
    800044f8:	ff26                	sd	s1,440(sp)
    800044fa:	fb4a                	sd	s2,432(sp)
    800044fc:	f74e                	sd	s3,424(sp)
    800044fe:	f352                	sd	s4,416(sp)
    80004500:	ef56                	sd	s5,408(sp)
    80004502:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004504:	e3840593          	addi	a1,s0,-456
    80004508:	4505                	li	a0,1
    8000450a:	fa2fd0ef          	jal	ra,80001cac <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    8000450e:	08000613          	li	a2,128
    80004512:	f4040593          	addi	a1,s0,-192
    80004516:	4501                	li	a0,0
    80004518:	fb0fd0ef          	jal	ra,80001cc8 <argstr>
    8000451c:	87aa                	mv	a5,a0
    return -1;
    8000451e:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004520:	0a07c463          	bltz	a5,800045c8 <sys_exec+0xd6>
  }
  memset(argv, 0, sizeof(argv));
    80004524:	10000613          	li	a2,256
    80004528:	4581                	li	a1,0
    8000452a:	e4040513          	addi	a0,s0,-448
    8000452e:	c1ffb0ef          	jal	ra,8000014c <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004532:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004536:	89a6                	mv	s3,s1
    80004538:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    8000453a:	02000a13          	li	s4,32
    8000453e:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004542:	00391793          	slli	a5,s2,0x3
    80004546:	e3040593          	addi	a1,s0,-464
    8000454a:	e3843503          	ld	a0,-456(s0)
    8000454e:	953e                	add	a0,a0,a5
    80004550:	eb6fd0ef          	jal	ra,80001c06 <fetchaddr>
    80004554:	02054663          	bltz	a0,80004580 <sys_exec+0x8e>
      goto bad;
    }
    if(uarg == 0){
    80004558:	e3043783          	ld	a5,-464(s0)
    8000455c:	cf8d                	beqz	a5,80004596 <sys_exec+0xa4>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    8000455e:	b9ffb0ef          	jal	ra,800000fc <kalloc>
    80004562:	85aa                	mv	a1,a0
    80004564:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004568:	cd01                	beqz	a0,80004580 <sys_exec+0x8e>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000456a:	6605                	lui	a2,0x1
    8000456c:	e3043503          	ld	a0,-464(s0)
    80004570:	ee0fd0ef          	jal	ra,80001c50 <fetchstr>
    80004574:	00054663          	bltz	a0,80004580 <sys_exec+0x8e>
    if(i >= NELEM(argv)){
    80004578:	0905                	addi	s2,s2,1
    8000457a:	09a1                	addi	s3,s3,8
    8000457c:	fd4911e3          	bne	s2,s4,8000453e <sys_exec+0x4c>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004580:	10048913          	addi	s2,s1,256
    80004584:	6088                	ld	a0,0(s1)
    80004586:	c121                	beqz	a0,800045c6 <sys_exec+0xd4>
    kfree(argv[i]);
    80004588:	a95fb0ef          	jal	ra,8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000458c:	04a1                	addi	s1,s1,8
    8000458e:	ff249be3          	bne	s1,s2,80004584 <sys_exec+0x92>
  return -1;
    80004592:	557d                	li	a0,-1
    80004594:	a815                	j	800045c8 <sys_exec+0xd6>
      argv[i] = 0;
    80004596:	0a8e                	slli	s5,s5,0x3
    80004598:	fc040793          	addi	a5,s0,-64
    8000459c:	9abe                	add	s5,s5,a5
    8000459e:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    800045a2:	e4040593          	addi	a1,s0,-448
    800045a6:	f4040513          	addi	a0,s0,-192
    800045aa:	bfaff0ef          	jal	ra,800039a4 <exec>
    800045ae:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800045b0:	10048993          	addi	s3,s1,256
    800045b4:	6088                	ld	a0,0(s1)
    800045b6:	c511                	beqz	a0,800045c2 <sys_exec+0xd0>
    kfree(argv[i]);
    800045b8:	a65fb0ef          	jal	ra,8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800045bc:	04a1                	addi	s1,s1,8
    800045be:	ff349be3          	bne	s1,s3,800045b4 <sys_exec+0xc2>
  return ret;
    800045c2:	854a                	mv	a0,s2
    800045c4:	a011                	j	800045c8 <sys_exec+0xd6>
  return -1;
    800045c6:	557d                	li	a0,-1
}
    800045c8:	60be                	ld	ra,456(sp)
    800045ca:	641e                	ld	s0,448(sp)
    800045cc:	74fa                	ld	s1,440(sp)
    800045ce:	795a                	ld	s2,432(sp)
    800045d0:	79ba                	ld	s3,424(sp)
    800045d2:	7a1a                	ld	s4,416(sp)
    800045d4:	6afa                	ld	s5,408(sp)
    800045d6:	6179                	addi	sp,sp,464
    800045d8:	8082                	ret

00000000800045da <sys_pipe>:

uint64
sys_pipe(void)
{
    800045da:	7139                	addi	sp,sp,-64
    800045dc:	fc06                	sd	ra,56(sp)
    800045de:	f822                	sd	s0,48(sp)
    800045e0:	f426                	sd	s1,40(sp)
    800045e2:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800045e4:	f6efc0ef          	jal	ra,80000d52 <myproc>
    800045e8:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800045ea:	fd840593          	addi	a1,s0,-40
    800045ee:	4501                	li	a0,0
    800045f0:	ebcfd0ef          	jal	ra,80001cac <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800045f4:	fc840593          	addi	a1,s0,-56
    800045f8:	fd040513          	addi	a0,s0,-48
    800045fc:	8d2ff0ef          	jal	ra,800036ce <pipealloc>
    return -1;
    80004600:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004602:	0a054463          	bltz	a0,800046aa <sys_pipe+0xd0>
  fd0 = -1;
    80004606:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000460a:	fd043503          	ld	a0,-48(s0)
    8000460e:	f42ff0ef          	jal	ra,80003d50 <fdalloc>
    80004612:	fca42223          	sw	a0,-60(s0)
    80004616:	08054163          	bltz	a0,80004698 <sys_pipe+0xbe>
    8000461a:	fc843503          	ld	a0,-56(s0)
    8000461e:	f32ff0ef          	jal	ra,80003d50 <fdalloc>
    80004622:	fca42023          	sw	a0,-64(s0)
    80004626:	06054063          	bltz	a0,80004686 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000462a:	4691                	li	a3,4
    8000462c:	fc440613          	addi	a2,s0,-60
    80004630:	fd843583          	ld	a1,-40(s0)
    80004634:	68e8                	ld	a0,208(s1)
    80004636:	bd0fc0ef          	jal	ra,80000a06 <copyout>
    8000463a:	00054e63          	bltz	a0,80004656 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000463e:	4691                	li	a3,4
    80004640:	fc040613          	addi	a2,s0,-64
    80004644:	fd843583          	ld	a1,-40(s0)
    80004648:	0591                	addi	a1,a1,4
    8000464a:	68e8                	ld	a0,208(s1)
    8000464c:	bbafc0ef          	jal	ra,80000a06 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004650:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004652:	04055c63          	bgez	a0,800046aa <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    80004656:	fc442783          	lw	a5,-60(s0)
    8000465a:	07e9                	addi	a5,a5,26
    8000465c:	078e                	slli	a5,a5,0x3
    8000465e:	97a6                	add	a5,a5,s1
    80004660:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80004664:	fc042503          	lw	a0,-64(s0)
    80004668:	0569                	addi	a0,a0,26
    8000466a:	050e                	slli	a0,a0,0x3
    8000466c:	94aa                	add	s1,s1,a0
    8000466e:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    80004672:	fd043503          	ld	a0,-48(s0)
    80004676:	d8dfe0ef          	jal	ra,80003402 <fileclose>
    fileclose(wf);
    8000467a:	fc843503          	ld	a0,-56(s0)
    8000467e:	d85fe0ef          	jal	ra,80003402 <fileclose>
    return -1;
    80004682:	57fd                	li	a5,-1
    80004684:	a01d                	j	800046aa <sys_pipe+0xd0>
    if(fd0 >= 0)
    80004686:	fc442783          	lw	a5,-60(s0)
    8000468a:	0007c763          	bltz	a5,80004698 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    8000468e:	07e9                	addi	a5,a5,26
    80004690:	078e                	slli	a5,a5,0x3
    80004692:	94be                	add	s1,s1,a5
    80004694:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    80004698:	fd043503          	ld	a0,-48(s0)
    8000469c:	d67fe0ef          	jal	ra,80003402 <fileclose>
    fileclose(wf);
    800046a0:	fc843503          	ld	a0,-56(s0)
    800046a4:	d5ffe0ef          	jal	ra,80003402 <fileclose>
    return -1;
    800046a8:	57fd                	li	a5,-1
}
    800046aa:	853e                	mv	a0,a5
    800046ac:	70e2                	ld	ra,56(sp)
    800046ae:	7442                	ld	s0,48(sp)
    800046b0:	74a2                	ld	s1,40(sp)
    800046b2:	6121                	addi	sp,sp,64
    800046b4:	8082                	ret
	...

00000000800046c0 <kernelvec>:
    800046c0:	7111                	addi	sp,sp,-256
    800046c2:	e006                	sd	ra,0(sp)
    800046c4:	e40a                	sd	sp,8(sp)
    800046c6:	e80e                	sd	gp,16(sp)
    800046c8:	ec12                	sd	tp,24(sp)
    800046ca:	f016                	sd	t0,32(sp)
    800046cc:	f41a                	sd	t1,40(sp)
    800046ce:	f81e                	sd	t2,48(sp)
    800046d0:	e4aa                	sd	a0,72(sp)
    800046d2:	e8ae                	sd	a1,80(sp)
    800046d4:	ecb2                	sd	a2,88(sp)
    800046d6:	f0b6                	sd	a3,96(sp)
    800046d8:	f4ba                	sd	a4,104(sp)
    800046da:	f8be                	sd	a5,112(sp)
    800046dc:	fcc2                	sd	a6,120(sp)
    800046de:	e146                	sd	a7,128(sp)
    800046e0:	edf2                	sd	t3,216(sp)
    800046e2:	f1f6                	sd	t4,224(sp)
    800046e4:	f5fa                	sd	t5,232(sp)
    800046e6:	f9fe                	sd	t6,240(sp)
    800046e8:	c2efd0ef          	jal	ra,80001b16 <kerneltrap>
    800046ec:	6082                	ld	ra,0(sp)
    800046ee:	6122                	ld	sp,8(sp)
    800046f0:	61c2                	ld	gp,16(sp)
    800046f2:	7282                	ld	t0,32(sp)
    800046f4:	7322                	ld	t1,40(sp)
    800046f6:	73c2                	ld	t2,48(sp)
    800046f8:	6526                	ld	a0,72(sp)
    800046fa:	65c6                	ld	a1,80(sp)
    800046fc:	6666                	ld	a2,88(sp)
    800046fe:	7686                	ld	a3,96(sp)
    80004700:	7726                	ld	a4,104(sp)
    80004702:	77c6                	ld	a5,112(sp)
    80004704:	7866                	ld	a6,120(sp)
    80004706:	688a                	ld	a7,128(sp)
    80004708:	6e6e                	ld	t3,216(sp)
    8000470a:	7e8e                	ld	t4,224(sp)
    8000470c:	7f2e                	ld	t5,232(sp)
    8000470e:	7fce                	ld	t6,240(sp)
    80004710:	6111                	addi	sp,sp,256
    80004712:	10200073          	sret
	...

000000008000471e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000471e:	1141                	addi	sp,sp,-16
    80004720:	e422                	sd	s0,8(sp)
    80004722:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80004724:	0c0007b7          	lui	a5,0xc000
    80004728:	4705                	li	a4,1
    8000472a:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000472c:	c3d8                	sw	a4,4(a5)
}
    8000472e:	6422                	ld	s0,8(sp)
    80004730:	0141                	addi	sp,sp,16
    80004732:	8082                	ret

0000000080004734 <plicinithart>:

void
plicinithart(void)
{
    80004734:	1141                	addi	sp,sp,-16
    80004736:	e406                	sd	ra,8(sp)
    80004738:	e022                	sd	s0,0(sp)
    8000473a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000473c:	deafc0ef          	jal	ra,80000d26 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80004740:	0085171b          	slliw	a4,a0,0x8
    80004744:	0c0027b7          	lui	a5,0xc002
    80004748:	97ba                	add	a5,a5,a4
    8000474a:	40200713          	li	a4,1026
    8000474e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80004752:	00d5151b          	slliw	a0,a0,0xd
    80004756:	0c2017b7          	lui	a5,0xc201
    8000475a:	953e                	add	a0,a0,a5
    8000475c:	00052023          	sw	zero,0(a0)
}
    80004760:	60a2                	ld	ra,8(sp)
    80004762:	6402                	ld	s0,0(sp)
    80004764:	0141                	addi	sp,sp,16
    80004766:	8082                	ret

0000000080004768 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80004768:	1141                	addi	sp,sp,-16
    8000476a:	e406                	sd	ra,8(sp)
    8000476c:	e022                	sd	s0,0(sp)
    8000476e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004770:	db6fc0ef          	jal	ra,80000d26 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80004774:	00d5179b          	slliw	a5,a0,0xd
    80004778:	0c201537          	lui	a0,0xc201
    8000477c:	953e                	add	a0,a0,a5
  return irq;
}
    8000477e:	4148                	lw	a0,4(a0)
    80004780:	60a2                	ld	ra,8(sp)
    80004782:	6402                	ld	s0,0(sp)
    80004784:	0141                	addi	sp,sp,16
    80004786:	8082                	ret

0000000080004788 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80004788:	1101                	addi	sp,sp,-32
    8000478a:	ec06                	sd	ra,24(sp)
    8000478c:	e822                	sd	s0,16(sp)
    8000478e:	e426                	sd	s1,8(sp)
    80004790:	1000                	addi	s0,sp,32
    80004792:	84aa                	mv	s1,a0
  int hart = cpuid();
    80004794:	d92fc0ef          	jal	ra,80000d26 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80004798:	00d5151b          	slliw	a0,a0,0xd
    8000479c:	0c2017b7          	lui	a5,0xc201
    800047a0:	97aa                	add	a5,a5,a0
    800047a2:	c3c4                	sw	s1,4(a5)
}
    800047a4:	60e2                	ld	ra,24(sp)
    800047a6:	6442                	ld	s0,16(sp)
    800047a8:	64a2                	ld	s1,8(sp)
    800047aa:	6105                	addi	sp,sp,32
    800047ac:	8082                	ret

00000000800047ae <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800047ae:	1141                	addi	sp,sp,-16
    800047b0:	e406                	sd	ra,8(sp)
    800047b2:	e022                	sd	s0,0(sp)
    800047b4:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800047b6:	479d                	li	a5,7
    800047b8:	04a7ca63          	blt	a5,a0,8000480c <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    800047bc:	00014797          	auipc	a5,0x14
    800047c0:	44478793          	addi	a5,a5,1092 # 80018c00 <disk>
    800047c4:	97aa                	add	a5,a5,a0
    800047c6:	0187c783          	lbu	a5,24(a5)
    800047ca:	e7b9                	bnez	a5,80004818 <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800047cc:	00451613          	slli	a2,a0,0x4
    800047d0:	00014797          	auipc	a5,0x14
    800047d4:	43078793          	addi	a5,a5,1072 # 80018c00 <disk>
    800047d8:	6394                	ld	a3,0(a5)
    800047da:	96b2                	add	a3,a3,a2
    800047dc:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800047e0:	6398                	ld	a4,0(a5)
    800047e2:	9732                	add	a4,a4,a2
    800047e4:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800047e8:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800047ec:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800047f0:	953e                	add	a0,a0,a5
    800047f2:	4785                	li	a5,1
    800047f4:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    800047f8:	00014517          	auipc	a0,0x14
    800047fc:	42050513          	addi	a0,a0,1056 # 80018c18 <disk+0x18>
    80004800:	bfdfc0ef          	jal	ra,800013fc <wakeup>
}
    80004804:	60a2                	ld	ra,8(sp)
    80004806:	6402                	ld	s0,0(sp)
    80004808:	0141                	addi	sp,sp,16
    8000480a:	8082                	ret
    panic("free_desc 1");
    8000480c:	00003517          	auipc	a0,0x3
    80004810:	f0450513          	addi	a0,a0,-252 # 80007710 <syscalls+0x2f8>
    80004814:	3c3000ef          	jal	ra,800053d6 <panic>
    panic("free_desc 2");
    80004818:	00003517          	auipc	a0,0x3
    8000481c:	f0850513          	addi	a0,a0,-248 # 80007720 <syscalls+0x308>
    80004820:	3b7000ef          	jal	ra,800053d6 <panic>

0000000080004824 <virtio_disk_init>:
{
    80004824:	1101                	addi	sp,sp,-32
    80004826:	ec06                	sd	ra,24(sp)
    80004828:	e822                	sd	s0,16(sp)
    8000482a:	e426                	sd	s1,8(sp)
    8000482c:	e04a                	sd	s2,0(sp)
    8000482e:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80004830:	00003597          	auipc	a1,0x3
    80004834:	f0058593          	addi	a1,a1,-256 # 80007730 <syscalls+0x318>
    80004838:	00014517          	auipc	a0,0x14
    8000483c:	4f050513          	addi	a0,a0,1264 # 80018d28 <disk+0x128>
    80004840:	62b000ef          	jal	ra,8000566a <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004844:	100017b7          	lui	a5,0x10001
    80004848:	4398                	lw	a4,0(a5)
    8000484a:	2701                	sext.w	a4,a4
    8000484c:	747277b7          	lui	a5,0x74727
    80004850:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80004854:	14f71063          	bne	a4,a5,80004994 <virtio_disk_init+0x170>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004858:	100017b7          	lui	a5,0x10001
    8000485c:	43dc                	lw	a5,4(a5)
    8000485e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004860:	4709                	li	a4,2
    80004862:	12e79963          	bne	a5,a4,80004994 <virtio_disk_init+0x170>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004866:	100017b7          	lui	a5,0x10001
    8000486a:	479c                	lw	a5,8(a5)
    8000486c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000486e:	12e79363          	bne	a5,a4,80004994 <virtio_disk_init+0x170>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80004872:	100017b7          	lui	a5,0x10001
    80004876:	47d8                	lw	a4,12(a5)
    80004878:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000487a:	554d47b7          	lui	a5,0x554d4
    8000487e:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80004882:	10f71963          	bne	a4,a5,80004994 <virtio_disk_init+0x170>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004886:	100017b7          	lui	a5,0x10001
    8000488a:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000488e:	4705                	li	a4,1
    80004890:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004892:	470d                	li	a4,3
    80004894:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80004896:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80004898:	c7ffe737          	lui	a4,0xc7ffe
    8000489c:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdd91f>
    800048a0:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800048a2:	2701                	sext.w	a4,a4
    800048a4:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800048a6:	472d                	li	a4,11
    800048a8:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    800048aa:	5bbc                	lw	a5,112(a5)
    800048ac:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800048b0:	8ba1                	andi	a5,a5,8
    800048b2:	0e078763          	beqz	a5,800049a0 <virtio_disk_init+0x17c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800048b6:	100017b7          	lui	a5,0x10001
    800048ba:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800048be:	43fc                	lw	a5,68(a5)
    800048c0:	2781                	sext.w	a5,a5
    800048c2:	0e079563          	bnez	a5,800049ac <virtio_disk_init+0x188>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800048c6:	100017b7          	lui	a5,0x10001
    800048ca:	5bdc                	lw	a5,52(a5)
    800048cc:	2781                	sext.w	a5,a5
  if(max == 0)
    800048ce:	0e078563          	beqz	a5,800049b8 <virtio_disk_init+0x194>
  if(max < NUM)
    800048d2:	471d                	li	a4,7
    800048d4:	0ef77863          	bgeu	a4,a5,800049c4 <virtio_disk_init+0x1a0>
  disk.desc = kalloc();
    800048d8:	825fb0ef          	jal	ra,800000fc <kalloc>
    800048dc:	00014497          	auipc	s1,0x14
    800048e0:	32448493          	addi	s1,s1,804 # 80018c00 <disk>
    800048e4:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800048e6:	817fb0ef          	jal	ra,800000fc <kalloc>
    800048ea:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800048ec:	811fb0ef          	jal	ra,800000fc <kalloc>
    800048f0:	87aa                	mv	a5,a0
    800048f2:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800048f4:	6088                	ld	a0,0(s1)
    800048f6:	cd69                	beqz	a0,800049d0 <virtio_disk_init+0x1ac>
    800048f8:	00014717          	auipc	a4,0x14
    800048fc:	31073703          	ld	a4,784(a4) # 80018c08 <disk+0x8>
    80004900:	cb61                	beqz	a4,800049d0 <virtio_disk_init+0x1ac>
    80004902:	c7f9                	beqz	a5,800049d0 <virtio_disk_init+0x1ac>
  memset(disk.desc, 0, PGSIZE);
    80004904:	6605                	lui	a2,0x1
    80004906:	4581                	li	a1,0
    80004908:	845fb0ef          	jal	ra,8000014c <memset>
  memset(disk.avail, 0, PGSIZE);
    8000490c:	00014497          	auipc	s1,0x14
    80004910:	2f448493          	addi	s1,s1,756 # 80018c00 <disk>
    80004914:	6605                	lui	a2,0x1
    80004916:	4581                	li	a1,0
    80004918:	6488                	ld	a0,8(s1)
    8000491a:	833fb0ef          	jal	ra,8000014c <memset>
  memset(disk.used, 0, PGSIZE);
    8000491e:	6605                	lui	a2,0x1
    80004920:	4581                	li	a1,0
    80004922:	6888                	ld	a0,16(s1)
    80004924:	829fb0ef          	jal	ra,8000014c <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80004928:	100017b7          	lui	a5,0x10001
    8000492c:	4721                	li	a4,8
    8000492e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80004930:	4098                	lw	a4,0(s1)
    80004932:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80004936:	40d8                	lw	a4,4(s1)
    80004938:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000493c:	6498                	ld	a4,8(s1)
    8000493e:	0007069b          	sext.w	a3,a4
    80004942:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80004946:	9701                	srai	a4,a4,0x20
    80004948:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000494c:	6898                	ld	a4,16(s1)
    8000494e:	0007069b          	sext.w	a3,a4
    80004952:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80004956:	9701                	srai	a4,a4,0x20
    80004958:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000495c:	4705                	li	a4,1
    8000495e:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    80004960:	00e48c23          	sb	a4,24(s1)
    80004964:	00e48ca3          	sb	a4,25(s1)
    80004968:	00e48d23          	sb	a4,26(s1)
    8000496c:	00e48da3          	sb	a4,27(s1)
    80004970:	00e48e23          	sb	a4,28(s1)
    80004974:	00e48ea3          	sb	a4,29(s1)
    80004978:	00e48f23          	sb	a4,30(s1)
    8000497c:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004980:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004984:	0727a823          	sw	s2,112(a5)
}
    80004988:	60e2                	ld	ra,24(sp)
    8000498a:	6442                	ld	s0,16(sp)
    8000498c:	64a2                	ld	s1,8(sp)
    8000498e:	6902                	ld	s2,0(sp)
    80004990:	6105                	addi	sp,sp,32
    80004992:	8082                	ret
    panic("could not find virtio disk");
    80004994:	00003517          	auipc	a0,0x3
    80004998:	dac50513          	addi	a0,a0,-596 # 80007740 <syscalls+0x328>
    8000499c:	23b000ef          	jal	ra,800053d6 <panic>
    panic("virtio disk FEATURES_OK unset");
    800049a0:	00003517          	auipc	a0,0x3
    800049a4:	dc050513          	addi	a0,a0,-576 # 80007760 <syscalls+0x348>
    800049a8:	22f000ef          	jal	ra,800053d6 <panic>
    panic("virtio disk should not be ready");
    800049ac:	00003517          	auipc	a0,0x3
    800049b0:	dd450513          	addi	a0,a0,-556 # 80007780 <syscalls+0x368>
    800049b4:	223000ef          	jal	ra,800053d6 <panic>
    panic("virtio disk has no queue 0");
    800049b8:	00003517          	auipc	a0,0x3
    800049bc:	de850513          	addi	a0,a0,-536 # 800077a0 <syscalls+0x388>
    800049c0:	217000ef          	jal	ra,800053d6 <panic>
    panic("virtio disk max queue too short");
    800049c4:	00003517          	auipc	a0,0x3
    800049c8:	dfc50513          	addi	a0,a0,-516 # 800077c0 <syscalls+0x3a8>
    800049cc:	20b000ef          	jal	ra,800053d6 <panic>
    panic("virtio disk kalloc");
    800049d0:	00003517          	auipc	a0,0x3
    800049d4:	e1050513          	addi	a0,a0,-496 # 800077e0 <syscalls+0x3c8>
    800049d8:	1ff000ef          	jal	ra,800053d6 <panic>

00000000800049dc <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800049dc:	7119                	addi	sp,sp,-128
    800049de:	fc86                	sd	ra,120(sp)
    800049e0:	f8a2                	sd	s0,112(sp)
    800049e2:	f4a6                	sd	s1,104(sp)
    800049e4:	f0ca                	sd	s2,96(sp)
    800049e6:	ecce                	sd	s3,88(sp)
    800049e8:	e8d2                	sd	s4,80(sp)
    800049ea:	e4d6                	sd	s5,72(sp)
    800049ec:	e0da                	sd	s6,64(sp)
    800049ee:	fc5e                	sd	s7,56(sp)
    800049f0:	f862                	sd	s8,48(sp)
    800049f2:	f466                	sd	s9,40(sp)
    800049f4:	f06a                	sd	s10,32(sp)
    800049f6:	ec6e                	sd	s11,24(sp)
    800049f8:	0100                	addi	s0,sp,128
    800049fa:	8aaa                	mv	s5,a0
    800049fc:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800049fe:	00c52d03          	lw	s10,12(a0)
    80004a02:	001d1d1b          	slliw	s10,s10,0x1
    80004a06:	1d02                	slli	s10,s10,0x20
    80004a08:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    80004a0c:	00014517          	auipc	a0,0x14
    80004a10:	31c50513          	addi	a0,a0,796 # 80018d28 <disk+0x128>
    80004a14:	4d7000ef          	jal	ra,800056ea <acquire>
  for(int i = 0; i < 3; i++){
    80004a18:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80004a1a:	44a1                	li	s1,8
      disk.free[i] = 0;
    80004a1c:	00014b97          	auipc	s7,0x14
    80004a20:	1e4b8b93          	addi	s7,s7,484 # 80018c00 <disk>
  for(int i = 0; i < 3; i++){
    80004a24:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004a26:	00014c97          	auipc	s9,0x14
    80004a2a:	302c8c93          	addi	s9,s9,770 # 80018d28 <disk+0x128>
    80004a2e:	a8a9                	j	80004a88 <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80004a30:	00fb8733          	add	a4,s7,a5
    80004a34:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80004a38:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004a3a:	0207c563          	bltz	a5,80004a64 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80004a3e:	2905                	addiw	s2,s2,1
    80004a40:	0611                	addi	a2,a2,4
    80004a42:	05690863          	beq	s2,s6,80004a92 <virtio_disk_rw+0xb6>
    idx[i] = alloc_desc();
    80004a46:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004a48:	00014717          	auipc	a4,0x14
    80004a4c:	1b870713          	addi	a4,a4,440 # 80018c00 <disk>
    80004a50:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80004a52:	01874683          	lbu	a3,24(a4)
    80004a56:	fee9                	bnez	a3,80004a30 <virtio_disk_rw+0x54>
  for(int i = 0; i < NUM; i++){
    80004a58:	2785                	addiw	a5,a5,1
    80004a5a:	0705                	addi	a4,a4,1
    80004a5c:	fe979be3          	bne	a5,s1,80004a52 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80004a60:	57fd                	li	a5,-1
    80004a62:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80004a64:	01205b63          	blez	s2,80004a7a <virtio_disk_rw+0x9e>
    80004a68:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80004a6a:	000a2503          	lw	a0,0(s4)
    80004a6e:	d41ff0ef          	jal	ra,800047ae <free_desc>
      for(int j = 0; j < i; j++)
    80004a72:	2d85                	addiw	s11,s11,1
    80004a74:	0a11                	addi	s4,s4,4
    80004a76:	ffb91ae3          	bne	s2,s11,80004a6a <virtio_disk_rw+0x8e>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004a7a:	85e6                	mv	a1,s9
    80004a7c:	00014517          	auipc	a0,0x14
    80004a80:	19c50513          	addi	a0,a0,412 # 80018c18 <disk+0x18>
    80004a84:	92dfc0ef          	jal	ra,800013b0 <sleep>
  for(int i = 0; i < 3; i++){
    80004a88:	f8040a13          	addi	s4,s0,-128
{
    80004a8c:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80004a8e:	894e                	mv	s2,s3
    80004a90:	bf5d                	j	80004a46 <virtio_disk_rw+0x6a>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004a92:	f8042583          	lw	a1,-128(s0)
    80004a96:	00a58793          	addi	a5,a1,10
    80004a9a:	0792                	slli	a5,a5,0x4

  if(write)
    80004a9c:	00014617          	auipc	a2,0x14
    80004aa0:	16460613          	addi	a2,a2,356 # 80018c00 <disk>
    80004aa4:	00f60733          	add	a4,a2,a5
    80004aa8:	018036b3          	snez	a3,s8
    80004aac:	c714                	sw	a3,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004aae:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80004ab2:	01a73823          	sd	s10,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004ab6:	f6078693          	addi	a3,a5,-160
    80004aba:	6218                	ld	a4,0(a2)
    80004abc:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004abe:	00878513          	addi	a0,a5,8
    80004ac2:	9532                	add	a0,a0,a2
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004ac4:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004ac6:	6208                	ld	a0,0(a2)
    80004ac8:	96aa                	add	a3,a3,a0
    80004aca:	4741                	li	a4,16
    80004acc:	c698                	sw	a4,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004ace:	4705                	li	a4,1
    80004ad0:	00e69623          	sh	a4,12(a3)
  disk.desc[idx[0]].next = idx[1];
    80004ad4:	f8442703          	lw	a4,-124(s0)
    80004ad8:	00e69723          	sh	a4,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004adc:	0712                	slli	a4,a4,0x4
    80004ade:	953a                	add	a0,a0,a4
    80004ae0:	058a8693          	addi	a3,s5,88
    80004ae4:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    80004ae6:	6208                	ld	a0,0(a2)
    80004ae8:	972a                	add	a4,a4,a0
    80004aea:	40000693          	li	a3,1024
    80004aee:	c714                	sw	a3,8(a4)
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80004af0:	001c3c13          	seqz	s8,s8
    80004af4:	0c06                	slli	s8,s8,0x1
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004af6:	001c6c13          	ori	s8,s8,1
    80004afa:	01871623          	sh	s8,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80004afe:	f8842603          	lw	a2,-120(s0)
    80004b02:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004b06:	00014697          	auipc	a3,0x14
    80004b0a:	0fa68693          	addi	a3,a3,250 # 80018c00 <disk>
    80004b0e:	00258713          	addi	a4,a1,2
    80004b12:	0712                	slli	a4,a4,0x4
    80004b14:	9736                	add	a4,a4,a3
    80004b16:	587d                	li	a6,-1
    80004b18:	01070823          	sb	a6,16(a4)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004b1c:	0612                	slli	a2,a2,0x4
    80004b1e:	9532                	add	a0,a0,a2
    80004b20:	f9078793          	addi	a5,a5,-112
    80004b24:	97b6                	add	a5,a5,a3
    80004b26:	e11c                	sd	a5,0(a0)
  disk.desc[idx[2]].len = 1;
    80004b28:	629c                	ld	a5,0(a3)
    80004b2a:	97b2                	add	a5,a5,a2
    80004b2c:	4605                	li	a2,1
    80004b2e:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004b30:	4509                	li	a0,2
    80004b32:	00a79623          	sh	a0,12(a5)
  disk.desc[idx[2]].next = 0;
    80004b36:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004b3a:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    80004b3e:	01573423          	sd	s5,8(a4)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004b42:	6698                	ld	a4,8(a3)
    80004b44:	00275783          	lhu	a5,2(a4)
    80004b48:	8b9d                	andi	a5,a5,7
    80004b4a:	0786                	slli	a5,a5,0x1
    80004b4c:	97ba                	add	a5,a5,a4
    80004b4e:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80004b52:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004b56:	6698                	ld	a4,8(a3)
    80004b58:	00275783          	lhu	a5,2(a4)
    80004b5c:	2785                	addiw	a5,a5,1
    80004b5e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004b62:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004b66:	100017b7          	lui	a5,0x10001
    80004b6a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004b6e:	004aa783          	lw	a5,4(s5)
    80004b72:	00c79f63          	bne	a5,a2,80004b90 <virtio_disk_rw+0x1b4>
    sleep(b, &disk.vdisk_lock);
    80004b76:	00014917          	auipc	s2,0x14
    80004b7a:	1b290913          	addi	s2,s2,434 # 80018d28 <disk+0x128>
  while(b->disk == 1) {
    80004b7e:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80004b80:	85ca                	mv	a1,s2
    80004b82:	8556                	mv	a0,s5
    80004b84:	82dfc0ef          	jal	ra,800013b0 <sleep>
  while(b->disk == 1) {
    80004b88:	004aa783          	lw	a5,4(s5)
    80004b8c:	fe978ae3          	beq	a5,s1,80004b80 <virtio_disk_rw+0x1a4>
  }

  disk.info[idx[0]].b = 0;
    80004b90:	f8042903          	lw	s2,-128(s0)
    80004b94:	00290793          	addi	a5,s2,2
    80004b98:	00479713          	slli	a4,a5,0x4
    80004b9c:	00014797          	auipc	a5,0x14
    80004ba0:	06478793          	addi	a5,a5,100 # 80018c00 <disk>
    80004ba4:	97ba                	add	a5,a5,a4
    80004ba6:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004baa:	00014997          	auipc	s3,0x14
    80004bae:	05698993          	addi	s3,s3,86 # 80018c00 <disk>
    80004bb2:	00491713          	slli	a4,s2,0x4
    80004bb6:	0009b783          	ld	a5,0(s3)
    80004bba:	97ba                	add	a5,a5,a4
    80004bbc:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004bc0:	854a                	mv	a0,s2
    80004bc2:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004bc6:	be9ff0ef          	jal	ra,800047ae <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004bca:	8885                	andi	s1,s1,1
    80004bcc:	f0fd                	bnez	s1,80004bb2 <virtio_disk_rw+0x1d6>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004bce:	00014517          	auipc	a0,0x14
    80004bd2:	15a50513          	addi	a0,a0,346 # 80018d28 <disk+0x128>
    80004bd6:	3ad000ef          	jal	ra,80005782 <release>
}
    80004bda:	70e6                	ld	ra,120(sp)
    80004bdc:	7446                	ld	s0,112(sp)
    80004bde:	74a6                	ld	s1,104(sp)
    80004be0:	7906                	ld	s2,96(sp)
    80004be2:	69e6                	ld	s3,88(sp)
    80004be4:	6a46                	ld	s4,80(sp)
    80004be6:	6aa6                	ld	s5,72(sp)
    80004be8:	6b06                	ld	s6,64(sp)
    80004bea:	7be2                	ld	s7,56(sp)
    80004bec:	7c42                	ld	s8,48(sp)
    80004bee:	7ca2                	ld	s9,40(sp)
    80004bf0:	7d02                	ld	s10,32(sp)
    80004bf2:	6de2                	ld	s11,24(sp)
    80004bf4:	6109                	addi	sp,sp,128
    80004bf6:	8082                	ret

0000000080004bf8 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80004bf8:	1101                	addi	sp,sp,-32
    80004bfa:	ec06                	sd	ra,24(sp)
    80004bfc:	e822                	sd	s0,16(sp)
    80004bfe:	e426                	sd	s1,8(sp)
    80004c00:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80004c02:	00014497          	auipc	s1,0x14
    80004c06:	ffe48493          	addi	s1,s1,-2 # 80018c00 <disk>
    80004c0a:	00014517          	auipc	a0,0x14
    80004c0e:	11e50513          	addi	a0,a0,286 # 80018d28 <disk+0x128>
    80004c12:	2d9000ef          	jal	ra,800056ea <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80004c16:	10001737          	lui	a4,0x10001
    80004c1a:	533c                	lw	a5,96(a4)
    80004c1c:	8b8d                	andi	a5,a5,3
    80004c1e:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80004c20:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80004c24:	689c                	ld	a5,16(s1)
    80004c26:	0204d703          	lhu	a4,32(s1)
    80004c2a:	0027d783          	lhu	a5,2(a5)
    80004c2e:	04f70663          	beq	a4,a5,80004c7a <virtio_disk_intr+0x82>
    __sync_synchronize();
    80004c32:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80004c36:	6898                	ld	a4,16(s1)
    80004c38:	0204d783          	lhu	a5,32(s1)
    80004c3c:	8b9d                	andi	a5,a5,7
    80004c3e:	078e                	slli	a5,a5,0x3
    80004c40:	97ba                	add	a5,a5,a4
    80004c42:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80004c44:	00278713          	addi	a4,a5,2
    80004c48:	0712                	slli	a4,a4,0x4
    80004c4a:	9726                	add	a4,a4,s1
    80004c4c:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80004c50:	e321                	bnez	a4,80004c90 <virtio_disk_intr+0x98>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80004c52:	0789                	addi	a5,a5,2
    80004c54:	0792                	slli	a5,a5,0x4
    80004c56:	97a6                	add	a5,a5,s1
    80004c58:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80004c5a:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80004c5e:	f9efc0ef          	jal	ra,800013fc <wakeup>

    disk.used_idx += 1;
    80004c62:	0204d783          	lhu	a5,32(s1)
    80004c66:	2785                	addiw	a5,a5,1
    80004c68:	17c2                	slli	a5,a5,0x30
    80004c6a:	93c1                	srli	a5,a5,0x30
    80004c6c:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80004c70:	6898                	ld	a4,16(s1)
    80004c72:	00275703          	lhu	a4,2(a4)
    80004c76:	faf71ee3          	bne	a4,a5,80004c32 <virtio_disk_intr+0x3a>
  }

  release(&disk.vdisk_lock);
    80004c7a:	00014517          	auipc	a0,0x14
    80004c7e:	0ae50513          	addi	a0,a0,174 # 80018d28 <disk+0x128>
    80004c82:	301000ef          	jal	ra,80005782 <release>
}
    80004c86:	60e2                	ld	ra,24(sp)
    80004c88:	6442                	ld	s0,16(sp)
    80004c8a:	64a2                	ld	s1,8(sp)
    80004c8c:	6105                	addi	sp,sp,32
    80004c8e:	8082                	ret
      panic("virtio_disk_intr status");
    80004c90:	00003517          	auipc	a0,0x3
    80004c94:	b6850513          	addi	a0,a0,-1176 # 800077f8 <syscalls+0x3e0>
    80004c98:	73e000ef          	jal	ra,800053d6 <panic>

0000000080004c9c <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    80004c9c:	1141                	addi	sp,sp,-16
    80004c9e:	e422                	sd	s0,8(sp)
    80004ca0:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80004ca2:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80004ca6:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    80004caa:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80004cae:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80004cb2:	577d                	li	a4,-1
    80004cb4:	177e                	slli	a4,a4,0x3f
    80004cb6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80004cb8:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80004cbc:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80004cc0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80004cc4:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80004cc8:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80004ccc:	000f4737          	lui	a4,0xf4
    80004cd0:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80004cd4:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80004cd6:	14d79073          	csrw	0x14d,a5
}
    80004cda:	6422                	ld	s0,8(sp)
    80004cdc:	0141                	addi	sp,sp,16
    80004cde:	8082                	ret

0000000080004ce0 <start>:
{
    80004ce0:	1141                	addi	sp,sp,-16
    80004ce2:	e406                	sd	ra,8(sp)
    80004ce4:	e022                	sd	s0,0(sp)
    80004ce6:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80004ce8:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80004cec:	7779                	lui	a4,0xffffe
    80004cee:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdd9bf>
    80004cf2:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80004cf4:	6705                	lui	a4,0x1
    80004cf6:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80004cfa:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80004cfc:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80004d00:	ffffb797          	auipc	a5,0xffffb
    80004d04:	5ee78793          	addi	a5,a5,1518 # 800002ee <main>
    80004d08:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80004d0c:	4781                	li	a5,0
    80004d0e:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80004d12:	67c1                	lui	a5,0x10
    80004d14:	17fd                	addi	a5,a5,-1
    80004d16:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80004d1a:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80004d1e:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80004d22:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80004d26:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80004d2a:	57fd                	li	a5,-1
    80004d2c:	83a9                	srli	a5,a5,0xa
    80004d2e:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80004d32:	47bd                	li	a5,15
    80004d34:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80004d38:	f65ff0ef          	jal	ra,80004c9c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80004d3c:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80004d40:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80004d42:	823e                	mv	tp,a5
  asm volatile("mret");
    80004d44:	30200073          	mret
}
    80004d48:	60a2                	ld	ra,8(sp)
    80004d4a:	6402                	ld	s0,0(sp)
    80004d4c:	0141                	addi	sp,sp,16
    80004d4e:	8082                	ret

0000000080004d50 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80004d50:	715d                	addi	sp,sp,-80
    80004d52:	e486                	sd	ra,72(sp)
    80004d54:	e0a2                	sd	s0,64(sp)
    80004d56:	fc26                	sd	s1,56(sp)
    80004d58:	f84a                	sd	s2,48(sp)
    80004d5a:	f44e                	sd	s3,40(sp)
    80004d5c:	f052                	sd	s4,32(sp)
    80004d5e:	ec56                	sd	s5,24(sp)
    80004d60:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80004d62:	04c05263          	blez	a2,80004da6 <consolewrite+0x56>
    80004d66:	8a2a                	mv	s4,a0
    80004d68:	84ae                	mv	s1,a1
    80004d6a:	89b2                	mv	s3,a2
    80004d6c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80004d6e:	5afd                	li	s5,-1
    80004d70:	4685                	li	a3,1
    80004d72:	8626                	mv	a2,s1
    80004d74:	85d2                	mv	a1,s4
    80004d76:	fbf40513          	addi	a0,s0,-65
    80004d7a:	9ddfc0ef          	jal	ra,80001756 <either_copyin>
    80004d7e:	01550a63          	beq	a0,s5,80004d92 <consolewrite+0x42>
      break;
    uartputc(c);
    80004d82:	fbf44503          	lbu	a0,-65(s0)
    80004d86:	7da000ef          	jal	ra,80005560 <uartputc>
  for(i = 0; i < n; i++){
    80004d8a:	2905                	addiw	s2,s2,1
    80004d8c:	0485                	addi	s1,s1,1
    80004d8e:	ff2991e3          	bne	s3,s2,80004d70 <consolewrite+0x20>
  }

  return i;
}
    80004d92:	854a                	mv	a0,s2
    80004d94:	60a6                	ld	ra,72(sp)
    80004d96:	6406                	ld	s0,64(sp)
    80004d98:	74e2                	ld	s1,56(sp)
    80004d9a:	7942                	ld	s2,48(sp)
    80004d9c:	79a2                	ld	s3,40(sp)
    80004d9e:	7a02                	ld	s4,32(sp)
    80004da0:	6ae2                	ld	s5,24(sp)
    80004da2:	6161                	addi	sp,sp,80
    80004da4:	8082                	ret
  for(i = 0; i < n; i++){
    80004da6:	4901                	li	s2,0
    80004da8:	b7ed                	j	80004d92 <consolewrite+0x42>

0000000080004daa <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80004daa:	7159                	addi	sp,sp,-112
    80004dac:	f486                	sd	ra,104(sp)
    80004dae:	f0a2                	sd	s0,96(sp)
    80004db0:	eca6                	sd	s1,88(sp)
    80004db2:	e8ca                	sd	s2,80(sp)
    80004db4:	e4ce                	sd	s3,72(sp)
    80004db6:	e0d2                	sd	s4,64(sp)
    80004db8:	fc56                	sd	s5,56(sp)
    80004dba:	f85a                	sd	s6,48(sp)
    80004dbc:	f45e                	sd	s7,40(sp)
    80004dbe:	f062                	sd	s8,32(sp)
    80004dc0:	ec66                	sd	s9,24(sp)
    80004dc2:	e86a                	sd	s10,16(sp)
    80004dc4:	1880                	addi	s0,sp,112
    80004dc6:	8aaa                	mv	s5,a0
    80004dc8:	8a2e                	mv	s4,a1
    80004dca:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80004dcc:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80004dd0:	0001c517          	auipc	a0,0x1c
    80004dd4:	f7050513          	addi	a0,a0,-144 # 80020d40 <cons>
    80004dd8:	113000ef          	jal	ra,800056ea <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80004ddc:	0001c497          	auipc	s1,0x1c
    80004de0:	f6448493          	addi	s1,s1,-156 # 80020d40 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80004de4:	0001c917          	auipc	s2,0x1c
    80004de8:	ff490913          	addi	s2,s2,-12 # 80020dd8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    80004dec:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80004dee:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80004df0:	4ca9                	li	s9,10
  while(n > 0){
    80004df2:	07305363          	blez	s3,80004e58 <consoleread+0xae>
    while(cons.r == cons.w){
    80004df6:	0984a783          	lw	a5,152(s1)
    80004dfa:	09c4a703          	lw	a4,156(s1)
    80004dfe:	02f71163          	bne	a4,a5,80004e20 <consoleread+0x76>
      if(killed(myproc())){
    80004e02:	f51fb0ef          	jal	ra,80000d52 <myproc>
    80004e06:	fe2fc0ef          	jal	ra,800015e8 <killed>
    80004e0a:	e125                	bnez	a0,80004e6a <consoleread+0xc0>
      sleep(&cons.r, &cons.lock);
    80004e0c:	85a6                	mv	a1,s1
    80004e0e:	854a                	mv	a0,s2
    80004e10:	da0fc0ef          	jal	ra,800013b0 <sleep>
    while(cons.r == cons.w){
    80004e14:	0984a783          	lw	a5,152(s1)
    80004e18:	09c4a703          	lw	a4,156(s1)
    80004e1c:	fef703e3          	beq	a4,a5,80004e02 <consoleread+0x58>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80004e20:	0017871b          	addiw	a4,a5,1
    80004e24:	08e4ac23          	sw	a4,152(s1)
    80004e28:	07f7f713          	andi	a4,a5,127
    80004e2c:	9726                	add	a4,a4,s1
    80004e2e:	01874703          	lbu	a4,24(a4)
    80004e32:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80004e36:	057d0f63          	beq	s10,s7,80004e94 <consoleread+0xea>
    cbuf = c;
    80004e3a:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80004e3e:	4685                	li	a3,1
    80004e40:	f9f40613          	addi	a2,s0,-97
    80004e44:	85d2                	mv	a1,s4
    80004e46:	8556                	mv	a0,s5
    80004e48:	8c5fc0ef          	jal	ra,8000170c <either_copyout>
    80004e4c:	01850663          	beq	a0,s8,80004e58 <consoleread+0xae>
    dst++;
    80004e50:	0a05                	addi	s4,s4,1
    --n;
    80004e52:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80004e54:	f99d1fe3          	bne	s10,s9,80004df2 <consoleread+0x48>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80004e58:	0001c517          	auipc	a0,0x1c
    80004e5c:	ee850513          	addi	a0,a0,-280 # 80020d40 <cons>
    80004e60:	123000ef          	jal	ra,80005782 <release>

  return target - n;
    80004e64:	413b053b          	subw	a0,s6,s3
    80004e68:	a801                	j	80004e78 <consoleread+0xce>
        release(&cons.lock);
    80004e6a:	0001c517          	auipc	a0,0x1c
    80004e6e:	ed650513          	addi	a0,a0,-298 # 80020d40 <cons>
    80004e72:	111000ef          	jal	ra,80005782 <release>
        return -1;
    80004e76:	557d                	li	a0,-1
}
    80004e78:	70a6                	ld	ra,104(sp)
    80004e7a:	7406                	ld	s0,96(sp)
    80004e7c:	64e6                	ld	s1,88(sp)
    80004e7e:	6946                	ld	s2,80(sp)
    80004e80:	69a6                	ld	s3,72(sp)
    80004e82:	6a06                	ld	s4,64(sp)
    80004e84:	7ae2                	ld	s5,56(sp)
    80004e86:	7b42                	ld	s6,48(sp)
    80004e88:	7ba2                	ld	s7,40(sp)
    80004e8a:	7c02                	ld	s8,32(sp)
    80004e8c:	6ce2                	ld	s9,24(sp)
    80004e8e:	6d42                	ld	s10,16(sp)
    80004e90:	6165                	addi	sp,sp,112
    80004e92:	8082                	ret
      if(n < target){
    80004e94:	0009871b          	sext.w	a4,s3
    80004e98:	fd6770e3          	bgeu	a4,s6,80004e58 <consoleread+0xae>
        cons.r--;
    80004e9c:	0001c717          	auipc	a4,0x1c
    80004ea0:	f2f72e23          	sw	a5,-196(a4) # 80020dd8 <cons+0x98>
    80004ea4:	bf55                	j	80004e58 <consoleread+0xae>

0000000080004ea6 <consputc>:
{
    80004ea6:	1141                	addi	sp,sp,-16
    80004ea8:	e406                	sd	ra,8(sp)
    80004eaa:	e022                	sd	s0,0(sp)
    80004eac:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80004eae:	10000793          	li	a5,256
    80004eb2:	00f50863          	beq	a0,a5,80004ec2 <consputc+0x1c>
    uartputc_sync(c);
    80004eb6:	5d4000ef          	jal	ra,8000548a <uartputc_sync>
}
    80004eba:	60a2                	ld	ra,8(sp)
    80004ebc:	6402                	ld	s0,0(sp)
    80004ebe:	0141                	addi	sp,sp,16
    80004ec0:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80004ec2:	4521                	li	a0,8
    80004ec4:	5c6000ef          	jal	ra,8000548a <uartputc_sync>
    80004ec8:	02000513          	li	a0,32
    80004ecc:	5be000ef          	jal	ra,8000548a <uartputc_sync>
    80004ed0:	4521                	li	a0,8
    80004ed2:	5b8000ef          	jal	ra,8000548a <uartputc_sync>
    80004ed6:	b7d5                	j	80004eba <consputc+0x14>

0000000080004ed8 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80004ed8:	1101                	addi	sp,sp,-32
    80004eda:	ec06                	sd	ra,24(sp)
    80004edc:	e822                	sd	s0,16(sp)
    80004ede:	e426                	sd	s1,8(sp)
    80004ee0:	e04a                	sd	s2,0(sp)
    80004ee2:	1000                	addi	s0,sp,32
    80004ee4:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80004ee6:	0001c517          	auipc	a0,0x1c
    80004eea:	e5a50513          	addi	a0,a0,-422 # 80020d40 <cons>
    80004eee:	7fc000ef          	jal	ra,800056ea <acquire>

  switch(c){
    80004ef2:	47d5                	li	a5,21
    80004ef4:	0af48063          	beq	s1,a5,80004f94 <consoleintr+0xbc>
    80004ef8:	0297c663          	blt	a5,s1,80004f24 <consoleintr+0x4c>
    80004efc:	47a1                	li	a5,8
    80004efe:	0cf48f63          	beq	s1,a5,80004fdc <consoleintr+0x104>
    80004f02:	47c1                	li	a5,16
    80004f04:	10f49063          	bne	s1,a5,80005004 <consoleintr+0x12c>
  case C('P'):  // Print process list.
    procdump();
    80004f08:	899fc0ef          	jal	ra,800017a0 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80004f0c:	0001c517          	auipc	a0,0x1c
    80004f10:	e3450513          	addi	a0,a0,-460 # 80020d40 <cons>
    80004f14:	06f000ef          	jal	ra,80005782 <release>
}
    80004f18:	60e2                	ld	ra,24(sp)
    80004f1a:	6442                	ld	s0,16(sp)
    80004f1c:	64a2                	ld	s1,8(sp)
    80004f1e:	6902                	ld	s2,0(sp)
    80004f20:	6105                	addi	sp,sp,32
    80004f22:	8082                	ret
  switch(c){
    80004f24:	07f00793          	li	a5,127
    80004f28:	0af48a63          	beq	s1,a5,80004fdc <consoleintr+0x104>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80004f2c:	0001c717          	auipc	a4,0x1c
    80004f30:	e1470713          	addi	a4,a4,-492 # 80020d40 <cons>
    80004f34:	0a072783          	lw	a5,160(a4)
    80004f38:	09872703          	lw	a4,152(a4)
    80004f3c:	9f99                	subw	a5,a5,a4
    80004f3e:	07f00713          	li	a4,127
    80004f42:	fcf765e3          	bltu	a4,a5,80004f0c <consoleintr+0x34>
      c = (c == '\r') ? '\n' : c;
    80004f46:	47b5                	li	a5,13
    80004f48:	0cf48163          	beq	s1,a5,8000500a <consoleintr+0x132>
      consputc(c);
    80004f4c:	8526                	mv	a0,s1
    80004f4e:	f59ff0ef          	jal	ra,80004ea6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80004f52:	0001c797          	auipc	a5,0x1c
    80004f56:	dee78793          	addi	a5,a5,-530 # 80020d40 <cons>
    80004f5a:	0a07a683          	lw	a3,160(a5)
    80004f5e:	0016871b          	addiw	a4,a3,1
    80004f62:	0007061b          	sext.w	a2,a4
    80004f66:	0ae7a023          	sw	a4,160(a5)
    80004f6a:	07f6f693          	andi	a3,a3,127
    80004f6e:	97b6                	add	a5,a5,a3
    80004f70:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80004f74:	47a9                	li	a5,10
    80004f76:	0af48f63          	beq	s1,a5,80005034 <consoleintr+0x15c>
    80004f7a:	4791                	li	a5,4
    80004f7c:	0af48c63          	beq	s1,a5,80005034 <consoleintr+0x15c>
    80004f80:	0001c797          	auipc	a5,0x1c
    80004f84:	e587a783          	lw	a5,-424(a5) # 80020dd8 <cons+0x98>
    80004f88:	9f1d                	subw	a4,a4,a5
    80004f8a:	08000793          	li	a5,128
    80004f8e:	f6f71fe3          	bne	a4,a5,80004f0c <consoleintr+0x34>
    80004f92:	a04d                	j	80005034 <consoleintr+0x15c>
    while(cons.e != cons.w &&
    80004f94:	0001c717          	auipc	a4,0x1c
    80004f98:	dac70713          	addi	a4,a4,-596 # 80020d40 <cons>
    80004f9c:	0a072783          	lw	a5,160(a4)
    80004fa0:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80004fa4:	0001c497          	auipc	s1,0x1c
    80004fa8:	d9c48493          	addi	s1,s1,-612 # 80020d40 <cons>
    while(cons.e != cons.w &&
    80004fac:	4929                	li	s2,10
    80004fae:	f4f70fe3          	beq	a4,a5,80004f0c <consoleintr+0x34>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80004fb2:	37fd                	addiw	a5,a5,-1
    80004fb4:	07f7f713          	andi	a4,a5,127
    80004fb8:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80004fba:	01874703          	lbu	a4,24(a4)
    80004fbe:	f52707e3          	beq	a4,s2,80004f0c <consoleintr+0x34>
      cons.e--;
    80004fc2:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80004fc6:	10000513          	li	a0,256
    80004fca:	eddff0ef          	jal	ra,80004ea6 <consputc>
    while(cons.e != cons.w &&
    80004fce:	0a04a783          	lw	a5,160(s1)
    80004fd2:	09c4a703          	lw	a4,156(s1)
    80004fd6:	fcf71ee3          	bne	a4,a5,80004fb2 <consoleintr+0xda>
    80004fda:	bf0d                	j	80004f0c <consoleintr+0x34>
    if(cons.e != cons.w){
    80004fdc:	0001c717          	auipc	a4,0x1c
    80004fe0:	d6470713          	addi	a4,a4,-668 # 80020d40 <cons>
    80004fe4:	0a072783          	lw	a5,160(a4)
    80004fe8:	09c72703          	lw	a4,156(a4)
    80004fec:	f2f700e3          	beq	a4,a5,80004f0c <consoleintr+0x34>
      cons.e--;
    80004ff0:	37fd                	addiw	a5,a5,-1
    80004ff2:	0001c717          	auipc	a4,0x1c
    80004ff6:	def72723          	sw	a5,-530(a4) # 80020de0 <cons+0xa0>
      consputc(BACKSPACE);
    80004ffa:	10000513          	li	a0,256
    80004ffe:	ea9ff0ef          	jal	ra,80004ea6 <consputc>
    80005002:	b729                	j	80004f0c <consoleintr+0x34>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005004:	f00484e3          	beqz	s1,80004f0c <consoleintr+0x34>
    80005008:	b715                	j	80004f2c <consoleintr+0x54>
      consputc(c);
    8000500a:	4529                	li	a0,10
    8000500c:	e9bff0ef          	jal	ra,80004ea6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005010:	0001c797          	auipc	a5,0x1c
    80005014:	d3078793          	addi	a5,a5,-720 # 80020d40 <cons>
    80005018:	0a07a703          	lw	a4,160(a5)
    8000501c:	0017069b          	addiw	a3,a4,1
    80005020:	0006861b          	sext.w	a2,a3
    80005024:	0ad7a023          	sw	a3,160(a5)
    80005028:	07f77713          	andi	a4,a4,127
    8000502c:	97ba                	add	a5,a5,a4
    8000502e:	4729                	li	a4,10
    80005030:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005034:	0001c797          	auipc	a5,0x1c
    80005038:	dac7a423          	sw	a2,-600(a5) # 80020ddc <cons+0x9c>
        wakeup(&cons.r);
    8000503c:	0001c517          	auipc	a0,0x1c
    80005040:	d9c50513          	addi	a0,a0,-612 # 80020dd8 <cons+0x98>
    80005044:	bb8fc0ef          	jal	ra,800013fc <wakeup>
    80005048:	b5d1                	j	80004f0c <consoleintr+0x34>

000000008000504a <consoleinit>:

void
consoleinit(void)
{
    8000504a:	1141                	addi	sp,sp,-16
    8000504c:	e406                	sd	ra,8(sp)
    8000504e:	e022                	sd	s0,0(sp)
    80005050:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005052:	00002597          	auipc	a1,0x2
    80005056:	7be58593          	addi	a1,a1,1982 # 80007810 <syscalls+0x3f8>
    8000505a:	0001c517          	auipc	a0,0x1c
    8000505e:	ce650513          	addi	a0,a0,-794 # 80020d40 <cons>
    80005062:	608000ef          	jal	ra,8000566a <initlock>

  uartinit();
    80005066:	3d8000ef          	jal	ra,8000543e <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000506a:	00013797          	auipc	a5,0x13
    8000506e:	b3e78793          	addi	a5,a5,-1218 # 80017ba8 <devsw>
    80005072:	00000717          	auipc	a4,0x0
    80005076:	d3870713          	addi	a4,a4,-712 # 80004daa <consoleread>
    8000507a:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000507c:	00000717          	auipc	a4,0x0
    80005080:	cd470713          	addi	a4,a4,-812 # 80004d50 <consolewrite>
    80005084:	ef98                	sd	a4,24(a5)
}
    80005086:	60a2                	ld	ra,8(sp)
    80005088:	6402                	ld	s0,0(sp)
    8000508a:	0141                	addi	sp,sp,16
    8000508c:	8082                	ret

000000008000508e <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    8000508e:	7179                	addi	sp,sp,-48
    80005090:	f406                	sd	ra,40(sp)
    80005092:	f022                	sd	s0,32(sp)
    80005094:	ec26                	sd	s1,24(sp)
    80005096:	e84a                	sd	s2,16(sp)
    80005098:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    8000509a:	c219                	beqz	a2,800050a0 <printint+0x12>
    8000509c:	06054f63          	bltz	a0,8000511a <printint+0x8c>
    x = -xx;
  else
    x = xx;
    800050a0:	4881                	li	a7,0
    800050a2:	fd040693          	addi	a3,s0,-48

  i = 0;
    800050a6:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    800050a8:	00002617          	auipc	a2,0x2
    800050ac:	79060613          	addi	a2,a2,1936 # 80007838 <digits>
    800050b0:	883e                	mv	a6,a5
    800050b2:	2785                	addiw	a5,a5,1
    800050b4:	02b57733          	remu	a4,a0,a1
    800050b8:	9732                	add	a4,a4,a2
    800050ba:	00074703          	lbu	a4,0(a4)
    800050be:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    800050c2:	872a                	mv	a4,a0
    800050c4:	02b55533          	divu	a0,a0,a1
    800050c8:	0685                	addi	a3,a3,1
    800050ca:	feb773e3          	bgeu	a4,a1,800050b0 <printint+0x22>

  if(sign)
    800050ce:	00088b63          	beqz	a7,800050e4 <printint+0x56>
    buf[i++] = '-';
    800050d2:	fe040713          	addi	a4,s0,-32
    800050d6:	97ba                	add	a5,a5,a4
    800050d8:	02d00713          	li	a4,45
    800050dc:	fee78823          	sb	a4,-16(a5)
    800050e0:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    800050e4:	02f05563          	blez	a5,8000510e <printint+0x80>
    800050e8:	fd040713          	addi	a4,s0,-48
    800050ec:	00f704b3          	add	s1,a4,a5
    800050f0:	fff70913          	addi	s2,a4,-1
    800050f4:	993e                	add	s2,s2,a5
    800050f6:	37fd                	addiw	a5,a5,-1
    800050f8:	1782                	slli	a5,a5,0x20
    800050fa:	9381                	srli	a5,a5,0x20
    800050fc:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    80005100:	fff4c503          	lbu	a0,-1(s1)
    80005104:	da3ff0ef          	jal	ra,80004ea6 <consputc>
  while(--i >= 0)
    80005108:	14fd                	addi	s1,s1,-1
    8000510a:	ff249be3          	bne	s1,s2,80005100 <printint+0x72>
}
    8000510e:	70a2                	ld	ra,40(sp)
    80005110:	7402                	ld	s0,32(sp)
    80005112:	64e2                	ld	s1,24(sp)
    80005114:	6942                	ld	s2,16(sp)
    80005116:	6145                	addi	sp,sp,48
    80005118:	8082                	ret
    x = -xx;
    8000511a:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    8000511e:	4885                	li	a7,1
    x = -xx;
    80005120:	b749                	j	800050a2 <printint+0x14>

0000000080005122 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    80005122:	7155                	addi	sp,sp,-208
    80005124:	e506                	sd	ra,136(sp)
    80005126:	e122                	sd	s0,128(sp)
    80005128:	fca6                	sd	s1,120(sp)
    8000512a:	f8ca                	sd	s2,112(sp)
    8000512c:	f4ce                	sd	s3,104(sp)
    8000512e:	f0d2                	sd	s4,96(sp)
    80005130:	ecd6                	sd	s5,88(sp)
    80005132:	e8da                	sd	s6,80(sp)
    80005134:	e4de                	sd	s7,72(sp)
    80005136:	e0e2                	sd	s8,64(sp)
    80005138:	fc66                	sd	s9,56(sp)
    8000513a:	f86a                	sd	s10,48(sp)
    8000513c:	f46e                	sd	s11,40(sp)
    8000513e:	0900                	addi	s0,sp,144
    80005140:	8a2a                	mv	s4,a0
    80005142:	e40c                	sd	a1,8(s0)
    80005144:	e810                	sd	a2,16(s0)
    80005146:	ec14                	sd	a3,24(s0)
    80005148:	f018                	sd	a4,32(s0)
    8000514a:	f41c                	sd	a5,40(s0)
    8000514c:	03043823          	sd	a6,48(s0)
    80005150:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    80005154:	0001c797          	auipc	a5,0x1c
    80005158:	cac7a783          	lw	a5,-852(a5) # 80020e00 <pr+0x18>
    8000515c:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    80005160:	eb9d                	bnez	a5,80005196 <printf+0x74>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80005162:	00840793          	addi	a5,s0,8
    80005166:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000516a:	00054503          	lbu	a0,0(a0)
    8000516e:	24050463          	beqz	a0,800053b6 <printf+0x294>
    80005172:	4981                	li	s3,0
    if(cx != '%'){
    80005174:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    80005178:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    8000517c:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    80005180:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80005184:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80005188:	07000d93          	li	s11,112
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000518c:	00002b97          	auipc	s7,0x2
    80005190:	6acb8b93          	addi	s7,s7,1708 # 80007838 <digits>
    80005194:	a081                	j	800051d4 <printf+0xb2>
    acquire(&pr.lock);
    80005196:	0001c517          	auipc	a0,0x1c
    8000519a:	c5250513          	addi	a0,a0,-942 # 80020de8 <pr>
    8000519e:	54c000ef          	jal	ra,800056ea <acquire>
  va_start(ap, fmt);
    800051a2:	00840793          	addi	a5,s0,8
    800051a6:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800051aa:	000a4503          	lbu	a0,0(s4)
    800051ae:	f171                	bnez	a0,80005172 <printf+0x50>
#endif
  }
  va_end(ap);

  if(locking)
    release(&pr.lock);
    800051b0:	0001c517          	auipc	a0,0x1c
    800051b4:	c3850513          	addi	a0,a0,-968 # 80020de8 <pr>
    800051b8:	5ca000ef          	jal	ra,80005782 <release>
    800051bc:	aaed                	j	800053b6 <printf+0x294>
      consputc(cx);
    800051be:	ce9ff0ef          	jal	ra,80004ea6 <consputc>
      continue;
    800051c2:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800051c4:	0014899b          	addiw	s3,s1,1
    800051c8:	013a07b3          	add	a5,s4,s3
    800051cc:	0007c503          	lbu	a0,0(a5)
    800051d0:	1c050f63          	beqz	a0,800053ae <printf+0x28c>
    if(cx != '%'){
    800051d4:	ff5515e3          	bne	a0,s5,800051be <printf+0x9c>
    i++;
    800051d8:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    800051dc:	009a07b3          	add	a5,s4,s1
    800051e0:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    800051e4:	1c090563          	beqz	s2,800053ae <printf+0x28c>
    800051e8:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    800051ec:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    800051ee:	c789                	beqz	a5,800051f8 <printf+0xd6>
    800051f0:	009a0733          	add	a4,s4,s1
    800051f4:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    800051f8:	03690463          	beq	s2,s6,80005220 <printf+0xfe>
    } else if(c0 == 'l' && c1 == 'd'){
    800051fc:	03890e63          	beq	s2,s8,80005238 <printf+0x116>
    } else if(c0 == 'u'){
    80005200:	0b990d63          	beq	s2,s9,800052ba <printf+0x198>
    } else if(c0 == 'x'){
    80005204:	11a90363          	beq	s2,s10,8000530a <printf+0x1e8>
    } else if(c0 == 'p'){
    80005208:	13b90b63          	beq	s2,s11,8000533e <printf+0x21c>
    } else if(c0 == 's'){
    8000520c:	07300793          	li	a5,115
    80005210:	16f90363          	beq	s2,a5,80005376 <printf+0x254>
    } else if(c0 == '%'){
    80005214:	03591c63          	bne	s2,s5,8000524c <printf+0x12a>
      consputc('%');
    80005218:	8556                	mv	a0,s5
    8000521a:	c8dff0ef          	jal	ra,80004ea6 <consputc>
    8000521e:	b75d                	j	800051c4 <printf+0xa2>
      printint(va_arg(ap, int), 10, 1);
    80005220:	f8843783          	ld	a5,-120(s0)
    80005224:	00878713          	addi	a4,a5,8
    80005228:	f8e43423          	sd	a4,-120(s0)
    8000522c:	4605                	li	a2,1
    8000522e:	45a9                	li	a1,10
    80005230:	4388                	lw	a0,0(a5)
    80005232:	e5dff0ef          	jal	ra,8000508e <printint>
    80005236:	b779                	j	800051c4 <printf+0xa2>
    } else if(c0 == 'l' && c1 == 'd'){
    80005238:	03678163          	beq	a5,s6,8000525a <printf+0x138>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000523c:	03878d63          	beq	a5,s8,80005276 <printf+0x154>
    } else if(c0 == 'l' && c1 == 'u'){
    80005240:	09978963          	beq	a5,s9,800052d2 <printf+0x1b0>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80005244:	03878b63          	beq	a5,s8,8000527a <printf+0x158>
    } else if(c0 == 'l' && c1 == 'x'){
    80005248:	0da78d63          	beq	a5,s10,80005322 <printf+0x200>
      consputc('%');
    8000524c:	8556                	mv	a0,s5
    8000524e:	c59ff0ef          	jal	ra,80004ea6 <consputc>
      consputc(c0);
    80005252:	854a                	mv	a0,s2
    80005254:	c53ff0ef          	jal	ra,80004ea6 <consputc>
    80005258:	b7b5                	j	800051c4 <printf+0xa2>
      printint(va_arg(ap, uint64), 10, 1);
    8000525a:	f8843783          	ld	a5,-120(s0)
    8000525e:	00878713          	addi	a4,a5,8
    80005262:	f8e43423          	sd	a4,-120(s0)
    80005266:	4605                	li	a2,1
    80005268:	45a9                	li	a1,10
    8000526a:	6388                	ld	a0,0(a5)
    8000526c:	e23ff0ef          	jal	ra,8000508e <printint>
      i += 1;
    80005270:	0029849b          	addiw	s1,s3,2
    80005274:	bf81                	j	800051c4 <printf+0xa2>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80005276:	03668463          	beq	a3,s6,8000529e <printf+0x17c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    8000527a:	07968a63          	beq	a3,s9,800052ee <printf+0x1cc>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    8000527e:	fda697e3          	bne	a3,s10,8000524c <printf+0x12a>
      printint(va_arg(ap, uint64), 16, 0);
    80005282:	f8843783          	ld	a5,-120(s0)
    80005286:	00878713          	addi	a4,a5,8
    8000528a:	f8e43423          	sd	a4,-120(s0)
    8000528e:	4601                	li	a2,0
    80005290:	45c1                	li	a1,16
    80005292:	6388                	ld	a0,0(a5)
    80005294:	dfbff0ef          	jal	ra,8000508e <printint>
      i += 2;
    80005298:	0039849b          	addiw	s1,s3,3
    8000529c:	b725                	j	800051c4 <printf+0xa2>
      printint(va_arg(ap, uint64), 10, 1);
    8000529e:	f8843783          	ld	a5,-120(s0)
    800052a2:	00878713          	addi	a4,a5,8
    800052a6:	f8e43423          	sd	a4,-120(s0)
    800052aa:	4605                	li	a2,1
    800052ac:	45a9                	li	a1,10
    800052ae:	6388                	ld	a0,0(a5)
    800052b0:	ddfff0ef          	jal	ra,8000508e <printint>
      i += 2;
    800052b4:	0039849b          	addiw	s1,s3,3
    800052b8:	b731                	j	800051c4 <printf+0xa2>
      printint(va_arg(ap, int), 10, 0);
    800052ba:	f8843783          	ld	a5,-120(s0)
    800052be:	00878713          	addi	a4,a5,8
    800052c2:	f8e43423          	sd	a4,-120(s0)
    800052c6:	4601                	li	a2,0
    800052c8:	45a9                	li	a1,10
    800052ca:	4388                	lw	a0,0(a5)
    800052cc:	dc3ff0ef          	jal	ra,8000508e <printint>
    800052d0:	bdd5                	j	800051c4 <printf+0xa2>
      printint(va_arg(ap, uint64), 10, 0);
    800052d2:	f8843783          	ld	a5,-120(s0)
    800052d6:	00878713          	addi	a4,a5,8
    800052da:	f8e43423          	sd	a4,-120(s0)
    800052de:	4601                	li	a2,0
    800052e0:	45a9                	li	a1,10
    800052e2:	6388                	ld	a0,0(a5)
    800052e4:	dabff0ef          	jal	ra,8000508e <printint>
      i += 1;
    800052e8:	0029849b          	addiw	s1,s3,2
    800052ec:	bde1                	j	800051c4 <printf+0xa2>
      printint(va_arg(ap, uint64), 10, 0);
    800052ee:	f8843783          	ld	a5,-120(s0)
    800052f2:	00878713          	addi	a4,a5,8
    800052f6:	f8e43423          	sd	a4,-120(s0)
    800052fa:	4601                	li	a2,0
    800052fc:	45a9                	li	a1,10
    800052fe:	6388                	ld	a0,0(a5)
    80005300:	d8fff0ef          	jal	ra,8000508e <printint>
      i += 2;
    80005304:	0039849b          	addiw	s1,s3,3
    80005308:	bd75                	j	800051c4 <printf+0xa2>
      printint(va_arg(ap, int), 16, 0);
    8000530a:	f8843783          	ld	a5,-120(s0)
    8000530e:	00878713          	addi	a4,a5,8
    80005312:	f8e43423          	sd	a4,-120(s0)
    80005316:	4601                	li	a2,0
    80005318:	45c1                	li	a1,16
    8000531a:	4388                	lw	a0,0(a5)
    8000531c:	d73ff0ef          	jal	ra,8000508e <printint>
    80005320:	b555                	j	800051c4 <printf+0xa2>
      printint(va_arg(ap, uint64), 16, 0);
    80005322:	f8843783          	ld	a5,-120(s0)
    80005326:	00878713          	addi	a4,a5,8
    8000532a:	f8e43423          	sd	a4,-120(s0)
    8000532e:	4601                	li	a2,0
    80005330:	45c1                	li	a1,16
    80005332:	6388                	ld	a0,0(a5)
    80005334:	d5bff0ef          	jal	ra,8000508e <printint>
      i += 1;
    80005338:	0029849b          	addiw	s1,s3,2
    8000533c:	b561                	j	800051c4 <printf+0xa2>
      printptr(va_arg(ap, uint64));
    8000533e:	f8843783          	ld	a5,-120(s0)
    80005342:	00878713          	addi	a4,a5,8
    80005346:	f8e43423          	sd	a4,-120(s0)
    8000534a:	0007b983          	ld	s3,0(a5)
  consputc('0');
    8000534e:	03000513          	li	a0,48
    80005352:	b55ff0ef          	jal	ra,80004ea6 <consputc>
  consputc('x');
    80005356:	856a                	mv	a0,s10
    80005358:	b4fff0ef          	jal	ra,80004ea6 <consputc>
    8000535c:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000535e:	03c9d793          	srli	a5,s3,0x3c
    80005362:	97de                	add	a5,a5,s7
    80005364:	0007c503          	lbu	a0,0(a5)
    80005368:	b3fff0ef          	jal	ra,80004ea6 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000536c:	0992                	slli	s3,s3,0x4
    8000536e:	397d                	addiw	s2,s2,-1
    80005370:	fe0917e3          	bnez	s2,8000535e <printf+0x23c>
    80005374:	bd81                	j	800051c4 <printf+0xa2>
      if((s = va_arg(ap, char*)) == 0)
    80005376:	f8843783          	ld	a5,-120(s0)
    8000537a:	00878713          	addi	a4,a5,8
    8000537e:	f8e43423          	sd	a4,-120(s0)
    80005382:	0007b903          	ld	s2,0(a5)
    80005386:	00090d63          	beqz	s2,800053a0 <printf+0x27e>
      for(; *s; s++)
    8000538a:	00094503          	lbu	a0,0(s2)
    8000538e:	e2050be3          	beqz	a0,800051c4 <printf+0xa2>
        consputc(*s);
    80005392:	b15ff0ef          	jal	ra,80004ea6 <consputc>
      for(; *s; s++)
    80005396:	0905                	addi	s2,s2,1
    80005398:	00094503          	lbu	a0,0(s2)
    8000539c:	f97d                	bnez	a0,80005392 <printf+0x270>
    8000539e:	b51d                	j	800051c4 <printf+0xa2>
        s = "(null)";
    800053a0:	00002917          	auipc	s2,0x2
    800053a4:	47890913          	addi	s2,s2,1144 # 80007818 <syscalls+0x400>
      for(; *s; s++)
    800053a8:	02800513          	li	a0,40
    800053ac:	b7dd                	j	80005392 <printf+0x270>
  if(locking)
    800053ae:	f7843783          	ld	a5,-136(s0)
    800053b2:	de079fe3          	bnez	a5,800051b0 <printf+0x8e>

  return 0;
}
    800053b6:	4501                	li	a0,0
    800053b8:	60aa                	ld	ra,136(sp)
    800053ba:	640a                	ld	s0,128(sp)
    800053bc:	74e6                	ld	s1,120(sp)
    800053be:	7946                	ld	s2,112(sp)
    800053c0:	79a6                	ld	s3,104(sp)
    800053c2:	7a06                	ld	s4,96(sp)
    800053c4:	6ae6                	ld	s5,88(sp)
    800053c6:	6b46                	ld	s6,80(sp)
    800053c8:	6ba6                	ld	s7,72(sp)
    800053ca:	6c06                	ld	s8,64(sp)
    800053cc:	7ce2                	ld	s9,56(sp)
    800053ce:	7d42                	ld	s10,48(sp)
    800053d0:	7da2                	ld	s11,40(sp)
    800053d2:	6169                	addi	sp,sp,208
    800053d4:	8082                	ret

00000000800053d6 <panic>:

void
panic(char *s)
{
    800053d6:	1101                	addi	sp,sp,-32
    800053d8:	ec06                	sd	ra,24(sp)
    800053da:	e822                	sd	s0,16(sp)
    800053dc:	e426                	sd	s1,8(sp)
    800053de:	1000                	addi	s0,sp,32
    800053e0:	84aa                	mv	s1,a0
  pr.locking = 0;
    800053e2:	0001c797          	auipc	a5,0x1c
    800053e6:	a007af23          	sw	zero,-1506(a5) # 80020e00 <pr+0x18>
  printf("panic: ");
    800053ea:	00002517          	auipc	a0,0x2
    800053ee:	43650513          	addi	a0,a0,1078 # 80007820 <syscalls+0x408>
    800053f2:	d31ff0ef          	jal	ra,80005122 <printf>
  printf("%s\n", s);
    800053f6:	85a6                	mv	a1,s1
    800053f8:	00002517          	auipc	a0,0x2
    800053fc:	43050513          	addi	a0,a0,1072 # 80007828 <syscalls+0x410>
    80005400:	d23ff0ef          	jal	ra,80005122 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005404:	4785                	li	a5,1
    80005406:	00002717          	auipc	a4,0x2
    8000540a:	4ef72b23          	sw	a5,1270(a4) # 800078fc <panicked>
  for(;;)
    8000540e:	a001                	j	8000540e <panic+0x38>

0000000080005410 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005410:	1101                	addi	sp,sp,-32
    80005412:	ec06                	sd	ra,24(sp)
    80005414:	e822                	sd	s0,16(sp)
    80005416:	e426                	sd	s1,8(sp)
    80005418:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    8000541a:	0001c497          	auipc	s1,0x1c
    8000541e:	9ce48493          	addi	s1,s1,-1586 # 80020de8 <pr>
    80005422:	00002597          	auipc	a1,0x2
    80005426:	40e58593          	addi	a1,a1,1038 # 80007830 <syscalls+0x418>
    8000542a:	8526                	mv	a0,s1
    8000542c:	23e000ef          	jal	ra,8000566a <initlock>
  pr.locking = 1;
    80005430:	4785                	li	a5,1
    80005432:	cc9c                	sw	a5,24(s1)
}
    80005434:	60e2                	ld	ra,24(sp)
    80005436:	6442                	ld	s0,16(sp)
    80005438:	64a2                	ld	s1,8(sp)
    8000543a:	6105                	addi	sp,sp,32
    8000543c:	8082                	ret

000000008000543e <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000543e:	1141                	addi	sp,sp,-16
    80005440:	e406                	sd	ra,8(sp)
    80005442:	e022                	sd	s0,0(sp)
    80005444:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005446:	100007b7          	lui	a5,0x10000
    8000544a:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000544e:	f8000713          	li	a4,-128
    80005452:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005456:	470d                	li	a4,3
    80005458:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000545c:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005460:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005464:	469d                	li	a3,7
    80005466:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000546a:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000546e:	00002597          	auipc	a1,0x2
    80005472:	3e258593          	addi	a1,a1,994 # 80007850 <digits+0x18>
    80005476:	0001c517          	auipc	a0,0x1c
    8000547a:	99250513          	addi	a0,a0,-1646 # 80020e08 <uart_tx_lock>
    8000547e:	1ec000ef          	jal	ra,8000566a <initlock>
}
    80005482:	60a2                	ld	ra,8(sp)
    80005484:	6402                	ld	s0,0(sp)
    80005486:	0141                	addi	sp,sp,16
    80005488:	8082                	ret

000000008000548a <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000548a:	1101                	addi	sp,sp,-32
    8000548c:	ec06                	sd	ra,24(sp)
    8000548e:	e822                	sd	s0,16(sp)
    80005490:	e426                	sd	s1,8(sp)
    80005492:	1000                	addi	s0,sp,32
    80005494:	84aa                	mv	s1,a0
  push_off();
    80005496:	214000ef          	jal	ra,800056aa <push_off>

  if(panicked){
    8000549a:	00002797          	auipc	a5,0x2
    8000549e:	4627a783          	lw	a5,1122(a5) # 800078fc <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800054a2:	10000737          	lui	a4,0x10000
  if(panicked){
    800054a6:	c391                	beqz	a5,800054aa <uartputc_sync+0x20>
    for(;;)
    800054a8:	a001                	j	800054a8 <uartputc_sync+0x1e>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800054aa:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800054ae:	0207f793          	andi	a5,a5,32
    800054b2:	dfe5                	beqz	a5,800054aa <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    800054b4:	0ff4f513          	andi	a0,s1,255
    800054b8:	100007b7          	lui	a5,0x10000
    800054bc:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800054c0:	26e000ef          	jal	ra,8000572e <pop_off>
}
    800054c4:	60e2                	ld	ra,24(sp)
    800054c6:	6442                	ld	s0,16(sp)
    800054c8:	64a2                	ld	s1,8(sp)
    800054ca:	6105                	addi	sp,sp,32
    800054cc:	8082                	ret

00000000800054ce <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800054ce:	00002797          	auipc	a5,0x2
    800054d2:	4327b783          	ld	a5,1074(a5) # 80007900 <uart_tx_r>
    800054d6:	00002717          	auipc	a4,0x2
    800054da:	43273703          	ld	a4,1074(a4) # 80007908 <uart_tx_w>
    800054de:	06f70c63          	beq	a4,a5,80005556 <uartstart+0x88>
{
    800054e2:	7139                	addi	sp,sp,-64
    800054e4:	fc06                	sd	ra,56(sp)
    800054e6:	f822                	sd	s0,48(sp)
    800054e8:	f426                	sd	s1,40(sp)
    800054ea:	f04a                	sd	s2,32(sp)
    800054ec:	ec4e                	sd	s3,24(sp)
    800054ee:	e852                	sd	s4,16(sp)
    800054f0:	e456                	sd	s5,8(sp)
    800054f2:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800054f4:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800054f8:	0001ca17          	auipc	s4,0x1c
    800054fc:	910a0a13          	addi	s4,s4,-1776 # 80020e08 <uart_tx_lock>
    uart_tx_r += 1;
    80005500:	00002497          	auipc	s1,0x2
    80005504:	40048493          	addi	s1,s1,1024 # 80007900 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005508:	00002997          	auipc	s3,0x2
    8000550c:	40098993          	addi	s3,s3,1024 # 80007908 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005510:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005514:	02077713          	andi	a4,a4,32
    80005518:	c715                	beqz	a4,80005544 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000551a:	01f7f713          	andi	a4,a5,31
    8000551e:	9752                	add	a4,a4,s4
    80005520:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80005524:	0785                	addi	a5,a5,1
    80005526:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005528:	8526                	mv	a0,s1
    8000552a:	ed3fb0ef          	jal	ra,800013fc <wakeup>
    
    WriteReg(THR, c);
    8000552e:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80005532:	609c                	ld	a5,0(s1)
    80005534:	0009b703          	ld	a4,0(s3)
    80005538:	fcf71ce3          	bne	a4,a5,80005510 <uartstart+0x42>
      ReadReg(ISR);
    8000553c:	100007b7          	lui	a5,0x10000
    80005540:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
  }
}
    80005544:	70e2                	ld	ra,56(sp)
    80005546:	7442                	ld	s0,48(sp)
    80005548:	74a2                	ld	s1,40(sp)
    8000554a:	7902                	ld	s2,32(sp)
    8000554c:	69e2                	ld	s3,24(sp)
    8000554e:	6a42                	ld	s4,16(sp)
    80005550:	6aa2                	ld	s5,8(sp)
    80005552:	6121                	addi	sp,sp,64
    80005554:	8082                	ret
      ReadReg(ISR);
    80005556:	100007b7          	lui	a5,0x10000
    8000555a:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
      return;
    8000555e:	8082                	ret

0000000080005560 <uartputc>:
{
    80005560:	7179                	addi	sp,sp,-48
    80005562:	f406                	sd	ra,40(sp)
    80005564:	f022                	sd	s0,32(sp)
    80005566:	ec26                	sd	s1,24(sp)
    80005568:	e84a                	sd	s2,16(sp)
    8000556a:	e44e                	sd	s3,8(sp)
    8000556c:	e052                	sd	s4,0(sp)
    8000556e:	1800                	addi	s0,sp,48
    80005570:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80005572:	0001c517          	auipc	a0,0x1c
    80005576:	89650513          	addi	a0,a0,-1898 # 80020e08 <uart_tx_lock>
    8000557a:	170000ef          	jal	ra,800056ea <acquire>
  if(panicked){
    8000557e:	00002797          	auipc	a5,0x2
    80005582:	37e7a783          	lw	a5,894(a5) # 800078fc <panicked>
    80005586:	efbd                	bnez	a5,80005604 <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005588:	00002717          	auipc	a4,0x2
    8000558c:	38073703          	ld	a4,896(a4) # 80007908 <uart_tx_w>
    80005590:	00002797          	auipc	a5,0x2
    80005594:	3707b783          	ld	a5,880(a5) # 80007900 <uart_tx_r>
    80005598:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000559c:	0001c997          	auipc	s3,0x1c
    800055a0:	86c98993          	addi	s3,s3,-1940 # 80020e08 <uart_tx_lock>
    800055a4:	00002497          	auipc	s1,0x2
    800055a8:	35c48493          	addi	s1,s1,860 # 80007900 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800055ac:	00002917          	auipc	s2,0x2
    800055b0:	35c90913          	addi	s2,s2,860 # 80007908 <uart_tx_w>
    800055b4:	00e79d63          	bne	a5,a4,800055ce <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    800055b8:	85ce                	mv	a1,s3
    800055ba:	8526                	mv	a0,s1
    800055bc:	df5fb0ef          	jal	ra,800013b0 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800055c0:	00093703          	ld	a4,0(s2)
    800055c4:	609c                	ld	a5,0(s1)
    800055c6:	02078793          	addi	a5,a5,32
    800055ca:	fee787e3          	beq	a5,a4,800055b8 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800055ce:	0001c497          	auipc	s1,0x1c
    800055d2:	83a48493          	addi	s1,s1,-1990 # 80020e08 <uart_tx_lock>
    800055d6:	01f77793          	andi	a5,a4,31
    800055da:	97a6                	add	a5,a5,s1
    800055dc:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800055e0:	0705                	addi	a4,a4,1
    800055e2:	00002797          	auipc	a5,0x2
    800055e6:	32e7b323          	sd	a4,806(a5) # 80007908 <uart_tx_w>
  uartstart();
    800055ea:	ee5ff0ef          	jal	ra,800054ce <uartstart>
  release(&uart_tx_lock);
    800055ee:	8526                	mv	a0,s1
    800055f0:	192000ef          	jal	ra,80005782 <release>
}
    800055f4:	70a2                	ld	ra,40(sp)
    800055f6:	7402                	ld	s0,32(sp)
    800055f8:	64e2                	ld	s1,24(sp)
    800055fa:	6942                	ld	s2,16(sp)
    800055fc:	69a2                	ld	s3,8(sp)
    800055fe:	6a02                	ld	s4,0(sp)
    80005600:	6145                	addi	sp,sp,48
    80005602:	8082                	ret
    for(;;)
    80005604:	a001                	j	80005604 <uartputc+0xa4>

0000000080005606 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80005606:	1141                	addi	sp,sp,-16
    80005608:	e422                	sd	s0,8(sp)
    8000560a:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000560c:	100007b7          	lui	a5,0x10000
    80005610:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80005614:	8b85                	andi	a5,a5,1
    80005616:	cb91                	beqz	a5,8000562a <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80005618:	100007b7          	lui	a5,0x10000
    8000561c:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80005620:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80005624:	6422                	ld	s0,8(sp)
    80005626:	0141                	addi	sp,sp,16
    80005628:	8082                	ret
    return -1;
    8000562a:	557d                	li	a0,-1
    8000562c:	bfe5                	j	80005624 <uartgetc+0x1e>

000000008000562e <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    8000562e:	1101                	addi	sp,sp,-32
    80005630:	ec06                	sd	ra,24(sp)
    80005632:	e822                	sd	s0,16(sp)
    80005634:	e426                	sd	s1,8(sp)
    80005636:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80005638:	54fd                	li	s1,-1
    8000563a:	a019                	j	80005640 <uartintr+0x12>
      break;
    consoleintr(c);
    8000563c:	89dff0ef          	jal	ra,80004ed8 <consoleintr>
    int c = uartgetc();
    80005640:	fc7ff0ef          	jal	ra,80005606 <uartgetc>
    if(c == -1)
    80005644:	fe951ce3          	bne	a0,s1,8000563c <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80005648:	0001b497          	auipc	s1,0x1b
    8000564c:	7c048493          	addi	s1,s1,1984 # 80020e08 <uart_tx_lock>
    80005650:	8526                	mv	a0,s1
    80005652:	098000ef          	jal	ra,800056ea <acquire>
  uartstart();
    80005656:	e79ff0ef          	jal	ra,800054ce <uartstart>
  release(&uart_tx_lock);
    8000565a:	8526                	mv	a0,s1
    8000565c:	126000ef          	jal	ra,80005782 <release>
}
    80005660:	60e2                	ld	ra,24(sp)
    80005662:	6442                	ld	s0,16(sp)
    80005664:	64a2                	ld	s1,8(sp)
    80005666:	6105                	addi	sp,sp,32
    80005668:	8082                	ret

000000008000566a <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000566a:	1141                	addi	sp,sp,-16
    8000566c:	e422                	sd	s0,8(sp)
    8000566e:	0800                	addi	s0,sp,16
  lk->name = name;
    80005670:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80005672:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80005676:	00053823          	sd	zero,16(a0)
}
    8000567a:	6422                	ld	s0,8(sp)
    8000567c:	0141                	addi	sp,sp,16
    8000567e:	8082                	ret

0000000080005680 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80005680:	411c                	lw	a5,0(a0)
    80005682:	e399                	bnez	a5,80005688 <holding+0x8>
    80005684:	4501                	li	a0,0
  return r;
}
    80005686:	8082                	ret
{
    80005688:	1101                	addi	sp,sp,-32
    8000568a:	ec06                	sd	ra,24(sp)
    8000568c:	e822                	sd	s0,16(sp)
    8000568e:	e426                	sd	s1,8(sp)
    80005690:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80005692:	6904                	ld	s1,16(a0)
    80005694:	ea2fb0ef          	jal	ra,80000d36 <mycpu>
    80005698:	40a48533          	sub	a0,s1,a0
    8000569c:	00153513          	seqz	a0,a0
}
    800056a0:	60e2                	ld	ra,24(sp)
    800056a2:	6442                	ld	s0,16(sp)
    800056a4:	64a2                	ld	s1,8(sp)
    800056a6:	6105                	addi	sp,sp,32
    800056a8:	8082                	ret

00000000800056aa <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800056aa:	1101                	addi	sp,sp,-32
    800056ac:	ec06                	sd	ra,24(sp)
    800056ae:	e822                	sd	s0,16(sp)
    800056b0:	e426                	sd	s1,8(sp)
    800056b2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800056b4:	100024f3          	csrr	s1,sstatus
    800056b8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800056bc:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800056be:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800056c2:	e74fb0ef          	jal	ra,80000d36 <mycpu>
    800056c6:	5d3c                	lw	a5,120(a0)
    800056c8:	cb99                	beqz	a5,800056de <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800056ca:	e6cfb0ef          	jal	ra,80000d36 <mycpu>
    800056ce:	5d3c                	lw	a5,120(a0)
    800056d0:	2785                	addiw	a5,a5,1
    800056d2:	dd3c                	sw	a5,120(a0)
}
    800056d4:	60e2                	ld	ra,24(sp)
    800056d6:	6442                	ld	s0,16(sp)
    800056d8:	64a2                	ld	s1,8(sp)
    800056da:	6105                	addi	sp,sp,32
    800056dc:	8082                	ret
    mycpu()->intena = old;
    800056de:	e58fb0ef          	jal	ra,80000d36 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800056e2:	8085                	srli	s1,s1,0x1
    800056e4:	8885                	andi	s1,s1,1
    800056e6:	dd64                	sw	s1,124(a0)
    800056e8:	b7cd                	j	800056ca <push_off+0x20>

00000000800056ea <acquire>:
{
    800056ea:	1101                	addi	sp,sp,-32
    800056ec:	ec06                	sd	ra,24(sp)
    800056ee:	e822                	sd	s0,16(sp)
    800056f0:	e426                	sd	s1,8(sp)
    800056f2:	1000                	addi	s0,sp,32
    800056f4:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800056f6:	fb5ff0ef          	jal	ra,800056aa <push_off>
  if(holding(lk))
    800056fa:	8526                	mv	a0,s1
    800056fc:	f85ff0ef          	jal	ra,80005680 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005700:	4705                	li	a4,1
  if(holding(lk))
    80005702:	e105                	bnez	a0,80005722 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005704:	87ba                	mv	a5,a4
    80005706:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000570a:	2781                	sext.w	a5,a5
    8000570c:	ffe5                	bnez	a5,80005704 <acquire+0x1a>
  __sync_synchronize();
    8000570e:	0ff0000f          	fence
  lk->cpu = mycpu();
    80005712:	e24fb0ef          	jal	ra,80000d36 <mycpu>
    80005716:	e888                	sd	a0,16(s1)
}
    80005718:	60e2                	ld	ra,24(sp)
    8000571a:	6442                	ld	s0,16(sp)
    8000571c:	64a2                	ld	s1,8(sp)
    8000571e:	6105                	addi	sp,sp,32
    80005720:	8082                	ret
    panic("acquire");
    80005722:	00002517          	auipc	a0,0x2
    80005726:	13650513          	addi	a0,a0,310 # 80007858 <digits+0x20>
    8000572a:	cadff0ef          	jal	ra,800053d6 <panic>

000000008000572e <pop_off>:

void
pop_off(void)
{
    8000572e:	1141                	addi	sp,sp,-16
    80005730:	e406                	sd	ra,8(sp)
    80005732:	e022                	sd	s0,0(sp)
    80005734:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80005736:	e00fb0ef          	jal	ra,80000d36 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000573a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000573e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80005740:	e78d                	bnez	a5,8000576a <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80005742:	5d3c                	lw	a5,120(a0)
    80005744:	02f05963          	blez	a5,80005776 <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    80005748:	37fd                	addiw	a5,a5,-1
    8000574a:	0007871b          	sext.w	a4,a5
    8000574e:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80005750:	eb09                	bnez	a4,80005762 <pop_off+0x34>
    80005752:	5d7c                	lw	a5,124(a0)
    80005754:	c799                	beqz	a5,80005762 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005756:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000575a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000575e:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80005762:	60a2                	ld	ra,8(sp)
    80005764:	6402                	ld	s0,0(sp)
    80005766:	0141                	addi	sp,sp,16
    80005768:	8082                	ret
    panic("pop_off - interruptible");
    8000576a:	00002517          	auipc	a0,0x2
    8000576e:	0f650513          	addi	a0,a0,246 # 80007860 <digits+0x28>
    80005772:	c65ff0ef          	jal	ra,800053d6 <panic>
    panic("pop_off");
    80005776:	00002517          	auipc	a0,0x2
    8000577a:	10250513          	addi	a0,a0,258 # 80007878 <digits+0x40>
    8000577e:	c59ff0ef          	jal	ra,800053d6 <panic>

0000000080005782 <release>:
{
    80005782:	1101                	addi	sp,sp,-32
    80005784:	ec06                	sd	ra,24(sp)
    80005786:	e822                	sd	s0,16(sp)
    80005788:	e426                	sd	s1,8(sp)
    8000578a:	1000                	addi	s0,sp,32
    8000578c:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000578e:	ef3ff0ef          	jal	ra,80005680 <holding>
    80005792:	c105                	beqz	a0,800057b2 <release+0x30>
  lk->cpu = 0;
    80005794:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80005798:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000579c:	0f50000f          	fence	iorw,ow
    800057a0:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800057a4:	f8bff0ef          	jal	ra,8000572e <pop_off>
}
    800057a8:	60e2                	ld	ra,24(sp)
    800057aa:	6442                	ld	s0,16(sp)
    800057ac:	64a2                	ld	s1,8(sp)
    800057ae:	6105                	addi	sp,sp,32
    800057b0:	8082                	ret
    panic("release");
    800057b2:	00002517          	auipc	a0,0x2
    800057b6:	0ce50513          	addi	a0,a0,206 # 80007880 <digits+0x48>
    800057ba:	c1dff0ef          	jal	ra,800053d6 <panic>
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
