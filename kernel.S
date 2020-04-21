.syntax unified
.cpu cortex-m4
//.fpu softvfp
.thumb

#define a #9
#define b #13
#define c #3

// Global memory locations.
.global vtable_kernel
.global __kernel_reset__

.type vtable_kernel, %object
.type __kernel_reset__, %function

.section .interrupt_vector
vtable_kernel:
    .word __stack_start
    .word __kernel_reset__+1
    .size vtable_kernel, .-vtable_kernel

.section .rodata
    data: .asciz "kernel started!\n"
    final: .asciz "Value in register #0: "

.section .text
__kernel_reset__:
    ldr r0, =data
    bl dbgput_line

    //calculate
    mov r1, a
    mov r2, b
    mov r3, c

    add r0, r1, r2
    mov r0, r0, ASR #1

    mov r4, #1
loop:
    cmp r3, #1
    beq end
    mul r5, r4, r3
    mov r4, r5
    sub r3, r3, #1
    b loop

end:
    add r0, r0, r4
    ldr r6, =final
    bl dbgput
    bl dbgput_num
    b end

