.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:
    addi sp, sp, -20
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)

    # Prologue
    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a4
    
    # === Convert strides to byte offsets ===
    slli s3, s3, 2   # s3 = s3 * 4 (stride in bytes)
    slli s4, s4, 2   # s4 = s4 * 4 (stride in bytes)

    # === Dot product computation ===
    mv t0, zero      # t0 = 0 (accumulator)
    mv t1, zero      # t1 = 0 (loop counter)

loop_start:
    bge t1, s2, loop_end

loop_continue:
    lw t2, 0(s0)     # Load v0[i]
    lw t3, 0(s1)     # Load v1[i]
    mul t4, t2, t3   # t4 = v0[i] * v1[i]
    add t0, t0, t4   # Accumulate sum

    addi t1, t1, 1   # i++
    add s0, s0, s3   # Move to next element in v0
    add s1, s1, s4   # Move to next element in v1
    j loop_start

loop_end:
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    addi sp, sp, 20
    mv a0, t0    # Return dot product
    ret
