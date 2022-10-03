    .globl my_exit
my_exit:
    movl    %edi, %ebp
    movl    $0xe7, %eax
    syscall
