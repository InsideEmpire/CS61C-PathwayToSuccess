.globl main

.data
source:
    .word   3
    .word   1
    .word   4
    .word   1
    .word   5
    .word   9
    .word   0
dest:
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0

.text
fun: # a0 is an argument (source[k])
    addi t0, a0, 1 # a0 -> source[k] t0 = source[k] + 1
    sub t1, x0, a0 # t1 = -source[k]
    mul a0, t0, t1 # a0 = -source[k] * (source[k] + 1)
    jr ra # ra = PC(54 line) jump back to main 
    # return a0

main:
    # BEGIN PROLOGUE
    addi sp, sp, -20
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw ra, 16(sp)
    # END PROLOGUE
    addi t0, x0, 0
    addi s0, x0, 0
    la s1, source
    la s2, dest
loop:
    slli s3, t0, 2# s3 = {0, 4, 8, ...} t0 = {0, 1, 2, ...}
    add t1, s1, s3 # t1 = s1(&source) + s3(k)
    lw t2, 0(t1) # t2 = t1
    beq t2, x0, exit # t2 -> source[k] if t2(source[k]) == x0(0) exit
    add a0, x0, t2 # a0 = x0(0) + t2(source[k])
    #
    addi sp, sp, -8
    sw t0, 0(sp)
    sw t2, 4(sp)
    jal fun
    lw t0, 0(sp)
    lw t2, 4(sp)
    addi sp, sp, 8
    #
    add t2, x0, a0 # t2 -> -source[k] * (source[k] + 1)
    add t3, s2, s3 # t3 = s2(&dest) + s3(k)
    sw t2, 0(t3) # dest[k] = -source[k] * (source[k] + 1)
    add s0, s0, t2 # s0(sum) += -source[k] * (source[k] + 1)
    addi t0, t0, 1 # t0 = t0 + 1
    jal x0, loop
exit:
    add a0, x0, s0
    # BEGIN EPILOGUE
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw ra, 16(sp)
    addi sp, sp, 20
    # END EPILOGUE
    jr ra # return a0(sum)
