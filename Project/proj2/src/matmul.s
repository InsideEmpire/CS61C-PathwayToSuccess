.globl matmul

.text
matmul:
    addi sp, sp, -36
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw ra, 32(sp)
    # Prologue

    # ======================================
    # Check dimensions
    # ======================================
    # Check if m0 dimensions make sense
    blez a1, m0_invalid_dimensions
    blez a2, m0_invalid_dimensions
    
    # Check if m1 dimensions make sense
    blez a4, m1_invalid_dimensions
    blez a5, m1_invalid_dimensions
    
    # Check if m0's columns match m1's rows
    bne a2, a4, dimension_mismatch
    
    # ======================================
    # Save arguments
    # ======================================
    mv s0, a0    # m0 pointer
    mv s1, a3    # m1 pointer
    mv s2, a6    # d pointer
    mv s3, a1    # height of m0 (rows)
    mv s4, a2    # width of m0 (cols) = height of m1 (rows)
    mv s5, a5    # width of m1 (cols)
    
    # ======================================
    # Matrix multiplication
    # ======================================
    li t0, 0     # i = 0 (row index for m0)
    
outer_loop_start:
    bge t0, s3, done   # if i >= rows of m0, done
    
    li t1, 0     # j = 0 (column index for m1)
    
inner_loop_start:
    bge t1, s5, inner_loop_end  # if j >= cols of m1, next row
    
    # Calculate row pointer for m0: m0 + i * width_m0 * 4
    mul t2, t0, s4    # i * width_m0
    slli t2, t2, 2    # * 4 bytes per int
    add a0, s0, t2    # m0 + offset
    
    # Calculate column pointer for m1: m1 + j * 4
    slli t3, t1, 2    # j * 4 bytes per int
    add a1, s1, t3    # m1 + offset
    
    # Set up arguments for dot
    mv a2, s4         # length = width of m0 = height of m1
    li a3, 1          # stride of m0 = 1 (consecutive elements in row)
    mv a4, s5         # stride of m1 = width of m1 (to move to next element in column)
    
    # Save registers before call
    addi sp, sp, -12
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    
    # Call dot product
    jal ra, dot
    
    # Restore registers
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    addi sp, sp, 12
    
    # Store result in d
    # Calculate position: d + (i * width_m1 + j) * 4
    mul t4, t0, s5    # i * width_m1
    add t4, t4, t1    # + j
    slli t4, t4, 2    # * 4 bytes per int
    add t5, s2, t4    # d + offset
    sw a0, 0(t5)      # store result
    
    addi t1, t1, 1    # j++
    j inner_loop_start
    
inner_loop_end:
    addi t0, t0, 1    # i++
    j outer_loop_start

m0_invalid_dimensions:
    li a1, 72
    j exit_with_error

m1_invalid_dimensions:
    li a1, 73
    j exit_with_error

dimension_mismatch:
    li a1, 74
    j exit_with_error

exit_with_error:
    jal exit2

done:
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw ra, 32(sp)
    addi sp, sp, 36
    ret