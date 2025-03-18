.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================
read_matrix:
    addi sp, sp, -24
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw ra, 20(sp)
    # Prologue
	mv s0, a0 # pointer to string representing the filename
    mv s1, a1 # pointer to an integer, we will set it to the number of rows
    mv s2, a2 # pointer to an integer, we will set it to the number of columns
    
    #================================================================
    # Opens file with name a1 with permissions a2.
    addi sp, sp, -12
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    
    mv a1, s0 # filepath
    li a2, 0 # r model
    jal ra, fopen
    mv s3, a0 # file descriptor
    
    lw a2, 8(sp)
    lw a1, 4(sp)
    lw a0, 0(sp)
    addi sp, sp, 12
    #================================================================
    # Reads rows
    # Reads a3 bytes of the file into the buffer a2
    addi sp, sp, -16
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    
    mv a1, s3 # file descriptor
    mv a2, s1 # pointer to the buffer you want to write the read bytes to.
    li a3, 4 # Number of bytes to be read.
    jal ra, fread
    
    lw a3, 12(sp)
    lw a2, 8(sp)
    lw a1, 4(sp)
    lw a0, 0(sp)
    addi sp, sp, 16
    #================================================================
    # Reads columns
    # Reads a3 bytes of the file into the buffer a2
    addi sp, sp, -16
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    
    mv a1, s3 # file descriptor
    mv a2, s2 # pointer to the buffer you want to write the read bytes to.
    li a3, 4 # Number of bytes to be read.
    jal ra, fread
    
    lw a3, 12(sp)
    lw a2, 8(sp)
    lw a1, 4(sp)
    lw a0, 0(sp)
    addi sp, sp, 16
    #================================================================
    # Reads Matrix
    # Reads a3 bytes of the file into the buffer a2
    addi sp, sp, -16
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    
    mv a1, s3 # file descriptor
    #===============================
    # Malloc
    addi sp, sp, -8
    sw a0, 0(sp)
    sw a1, 4(sp)
    
    lw t0, 0(s1)
    lw t1, 0(s2)
    mul t3, t1, t0
    slli t3, t3, 2
    mv a0, t3
    jal ra, malloc
    mv s4, a0 # pointer to the allocated heap memory
    
    lw a1, 4(sp)
    lw a0, 0(sp)
    addi sp, sp, 8
    #===============================
    lw t0, 0(s1)
    lw t1, 0(s2)
    mul t3, t1, t0
    slli t3, t3, 2
    mv a2, s4
    mv a3, t3
    jal ra, fread
    
    lw a3, 12(sp)
    lw a2, 8(sp)
    lw a1, 4(sp)
    lw a0, 0(sp)
    addi sp, sp, 16
    #================================================================

    mv a0, s4
    # Epilogue
    lw ra, 20(sp)
    lw s4, 16(sp)
    lw s3, 12(sp)
    lw s2, 8(sp)
    lw s1, 4(sp)
    lw s0, 0(sp)
    addi sp, sp, 24
    
    ret
