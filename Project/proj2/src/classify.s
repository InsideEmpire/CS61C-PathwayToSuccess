.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 89.
    # - If malloc fails, this function terminats the program with exit code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
    addi sp, sp, -52
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)
    sw s9, 36(sp)
    sw s10, 40(sp)
    sw s11, 44(sp)
    sw ra, 48(sp)
	# =====================================
    # LOAD MATRICES
    # =====================================
    lw s0, 4(a1) #(char*) argv[1] pointer to M0_PATH
    lw s1, 8(a1) #(char*) argv[2] pointer to M1_PATH
    lw s2, 12(a1) #(char*) argv[3] pointer to INPUT_PATH
    lw s3, 16(a1) #(char*) argv[4] pointer to OUTPUT_PATH
    mv s11, a2
    
    # Malloc an int array for storing row and column data
    li a0, 24 # {m0_row, m0_col, m1_row, m1_col, in_row, in_col}
    jal malloc
    beqz a0, malloc_fail
    mv s4, a0 # (int*) array for storing row and column data
    # Load pretrained m0
    mv a0, s0
    addi a1, s4, 0
    addi a2, s4, 4
    jal read_matrix
    mv s5, a0 # (int*) pointer to m0 in memory
    # Load pretrained m1
    mv a0, s1
    addi a1, s4, 8
    addi a2, s4, 12
    jal read_matrix
    mv s6, a0 # (int*) pointer to m1 in memory
    # Load input matrix
    mv a0, s2
    addi a1, s4, 16
    addi a2, s4, 20
    jal read_matrix
    mv s7, a0 # (int*) pointer to input in memory
    # =====================================
    # RUN LAYERS
    # =====================================
    # Malloc for m0 * input
    lw t0, 0(s4)
    lw t1, 20(s4)
    mul a0, t0, t1
    slli a0, a0, 2
    jal malloc
    beqz a0, malloc_fail # TODO
    mv s8, a0 # (int*) pointer to m0 * input
    # 1. LINEAR LAYER:    m0 * input
    mv a0, s5
    lw a1, 0(s4)
    lw a2, 4(s4)
    mv a3, s7
    lw a4, 16(s4)
    lw a5, 20(s4)
    mv a6, s8
    jal matmul
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    mv a0, s8
    lw t0, 0(s4)
    lw t1, 20(s4)
    mul a1, t0, t1
    jal relu
    # Malloc for m0 * input
    lw t0, 8(s4)
    lw t1, 20(s4)
    mul a0, t0, t1
    slli a0, a0, 2
    jal malloc
    beqz a0, malloc_fail
    mv s9, a0 # (int*) pointer to m0 * input
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    mv a0, s6
    lw a1, 8(s4)
    lw a2, 12(s4)
    mv a3, s8
    lw a4, 0(s4)
    lw a5, 20(s4)
    mv a6, s9
    jal matmul
    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    mv a0, s3
    mv a1, s9
    lw a2, 8(s4)
    lw a3, 20(s4)
    jal write_matrix
    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    mv a0, s9
    lw t0, 8(s4)
    lw t1, 20(s4)
    mul a1, t0, t1
    jal argmax
    mv s10, a0
    # Print classification
    mv a1, s10
    jal print_int
    # Print newline afterwards for clarity
    li a1, 10
    jal print_char
done:
    # Free heap
    mv a0, s4
    jal free
    mv a0, s5
    jal free
    mv a0, s6
    jal free
    mv a0, s7
    jal free
    mv a0, s8
    jal free
    mv a0, s9
    jal free
    # Done
    mv a0, s10
    
    lw ra, 48(sp)
    lw s11, 44(sp)
    lw s10, 40(sp)
    lw s9, 36(sp)
    lw s8, 32(sp)
    lw s7, 28(sp)
    lw s6, 24(sp)
    lw s5, 20(sp)
    lw s4, 16(sp)
    lw s3, 12(sp)
    lw s2, 8(sp)
    lw s1, 4(sp)
    lw s0, 0(sp)
    addi sp, sp, 52
    ret
    
malloc_fail:
    li a1, 88
    jal exit2