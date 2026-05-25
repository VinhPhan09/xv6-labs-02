#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  int normal_pid = getpid();  // Gọi qua ecall (chậm)
  int fast_pid = ugetpid();   // Đọc trực tiếp từ USYSCALL (nhanh)

  printf("Normal getpid(): %d\n", normal_pid);
  printf("Fast ugetpid():   %d\n", fast_pid);

  if(normal_pid == fast_pid){
    printf("ugetpidtest: OK\n");
  } else {
    printf("ugetpidtest: FAILED (Mismatch!)\n");
  }

  exit(0);
}