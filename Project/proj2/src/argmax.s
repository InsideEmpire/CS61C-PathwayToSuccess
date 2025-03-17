.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:
    addi sp, sp, -8
    sw s0, 0(sp)
    sw s1, 4(sp)
    # Prologue
    mv s0, a0
    mv s1, a1
loop_start:
    mv t2, s0 # pointer
    mv t3, zero #pointer index
    lw t0, 0(t2) # largest index
    mv t1, zero # largest element
loop_continue:
    lw t4, 0(t2)
    bge t1, t4, next
    mv t1, t4
    mv t0, t3
next:
    addi t2, t2, 4
    addi t3, t3, 1
    bgt s1, t3, loop_continue
loop_end:
    lw s0, 0(sp)
    lw s1, 4(sp)
    addi sp, sp, 8
    # Epilogue
    mv a0, t0
    ret
