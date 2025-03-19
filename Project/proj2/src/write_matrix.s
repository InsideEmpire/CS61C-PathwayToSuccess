.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 93.
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 94.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 95.
# ==============================================================================
write_matrix:
    addi sp, sp, -24
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw ra, 20(sp)
    # Prologue
    mv s0, a0 # pointer to string representing the filename
    mv s1, a1 # pointer to the start of the matrix in memory
    mv s2, a2 # number of rows in the matrix
    mv s3, a3 # number of columns in the matrix
    
    #================================================================
    # int fopen(char *a1, int a2)
    # Opens file with name a1 with permissions a2.
    addi sp, sp, -12
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    
    mv a1, s0 # a1 = filepath
    li a2, 1 # a2 = permissions (0, 1, 2, 3, 4, 5 = r, w, a, r+, w+, a+)
    jal ra, fopen
    mv s4, a0 # file descriptor
    
    lw a2, 8(sp)
    lw a1, 4(sp)
    lw a0, 0(sp)
    addi sp, sp, 12
    #================================================================
    # int fwrite(int a1, void *a2, size_t a3, size_t a4)
    # Writes a3 * a4 bytes from the buffer in a2 to the file descriptor a1.
    addi sp, sp, -20
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    sw a4, 16(sp)
    
    mv a1, s4 # a1 = file descriptor
    addi sp, sp, -4
    sw s2, 0(sp)
    mv a2, sp # a2 = Buffer to read from (number of rows in the matrix)
    addi sp, sp, 4
    li a3, 1 # a3 = Number of items to read from the buffer.
    li a4, 4 # a4 = Size of each item in the buffer.
    jal ra, fwrite
    
    lw a4, 16(sp)
    lw a3, 12(sp)
    lw a2, 8(sp)
    lw a1, 4(sp)
    lw a0, 0(sp)
    addi sp, sp, 20
    #================================================================
    # int fwrite(int a1, void *a2, size_t a3, size_t a4)
    # Writes a3 * a4 bytes from the buffer in a2 to the file descriptor a1.
    addi sp, sp, -20
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    sw a4, 16(sp)
    
    mv a1, s4 # a1 = file descriptor
    addi sp, sp, -4
    sw s3, 0(sp)
    mv a2, sp # a2 = Buffer to read from (number of columns in the matrix)
    addi sp, sp, 4
    li a3, 1 # a3 = Number of items to read from the buffer.
    li a4, 4 # a4 = Size of each item in the buffer.
    jal ra, fwrite
    
    lw a4, 16(sp)
    lw a3, 12(sp)
    lw a2, 8(sp)
    lw a1, 4(sp)
    lw a0, 0(sp)
    addi sp, sp, 20
    #================================================================
    # int fwrite(int a1, void *a2, size_t a3, size_t a4)
    # Writes a3 * a4 bytes from the buffer in a2 to the file descriptor a1.
    addi sp, sp, -20
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    sw a4, 16(sp)
    
    mv a1, s4 # a1 = file descriptor
    mv a2, s1 # a2 = Buffer to read from (pointer to the start of the matrix in memory)
    mul a3, s2, s3 # a3 = Number of items to read from the buffer.
    li a4, 4 # a4 = Size of each item in the buffer.
    jal ra, fwrite
    
    lw a4, 16(sp)
    lw a3, 12(sp)
    lw a2, 8(sp)
    lw a1, 4(sp)
    lw a0, 0(sp)
    addi sp, sp, 20
    #================================================================
    # int fclose(int a1)
    # Closes the file descriptor a1.
    # args:
    #   a1 = file descriptor
    # return:
    #   a0 = 0 on success, and EOF (-1) otherwise.
    addi sp, sp, -8
    sw a0, 0(sp)
    sw a1, 4(sp)
    
    mv a1, s4 # a1 = file descriptor
    jal ra, fclose
    
    lw a1, 4(sp)
    lw a0, 0(sp)
    addi sp, sp, 8
    #================================================================


    # Epilogue
    lw ra, 20(sp)
    lw s4, 16(sp)
    lw s3, 12(sp)
    lw s2, 8(sp)
    lw s1, 4(sp)
    lw s0, 0(sp)
    addi sp, sp, 24
    ret
