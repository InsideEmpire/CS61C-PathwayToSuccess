.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:
    addi sp, sp, -28
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw ra, 24(sp)
    # Prologue

    # ======================================
    mv s0, a0 # m0
    mv s1, a3 # m1
    mv s3, a6 # d
    mv s4, a1 # height of m0 and width of m1
    mv s5, a2 # width of m0 and height of m0
    # ======================================
    
    li t1, 0 # i = 0 outer m0's ith row
    li t2, 0 # j = 0 inner m1's jth column
outer_loop_start:
    li t2, 0
inner_loop_start:
    addi sp, sp, -28
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    sw a4, 16(sp)
    sw t1, 20(sp)
    sw t2, 24(sp)
    
    # Calculate row index for m0
    slli t6, t1, 2        
    mul t6, t6, s5        # t6 = i * m0_width * 4
    add a0, s0, t6        # a0 = m0(s0) + t6 (m0's row start)

    # Calculate column index for m1
    slli t5, t2, 2        # t5 = j * 4 (column offset for m1)
    add a1, s1, t5        # a1 = m1(s1) + t5 (m1's column start)

    # Set other arguments for dot product
    mv a2, s5             # length (width of m0 and height of m1)
    li a3, 1
    mv a4, s4
    # FUNCTION: Dot product of 2 int vectors
    # Arguments:
    #   a0 (int*) is the pointer to the start of v0
    #   a1 (int*) is the pointer to the start of v1
    #   a2 (int)  is the length of the vectors
    #   a3 (int)  is the stride of v0
    #   a4 (int)  is the stride of v1
    # Returns:
    #   a0 (int)  is the dot product of v0 and v1
    jal ra, dot            # Call dot

    # Restore the stack and store result in d
    sw a0, 0(s3)
    addi s3, s3, 4
    
    # Restore registers
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw a3, 12(sp)
    lw a4, 16(sp)
    lw t1, 20(sp)
    lw t2, 24(sp)
    addi sp, sp, 28
    
inner_loop_end:
    addi t2, t2, 1        # increment column index
    bge t2, s4, outer_loop_end
    j inner_loop_start

outer_loop_end:
    addi t1, t1, 1        # increment row index
    bge t1, s4, done      # check if done
    j outer_loop_start

done:   
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw ra, 24(sp)
    addi sp, sp, 28
    ret
