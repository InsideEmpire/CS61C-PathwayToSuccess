.globl abs

.text
# =================================================================
# FUNCTION: Given an int return its absolute value.
# Arguments:
# 	a0 (int) is input integer
# Returns:
#	a0 (int) the absolute value of the input
# =================================================================
abs:
    # Prologue

    ebreak
    # branch if positive
    bge a0, zero, done
    # invert a if negative
    sub a0, zero, a0

    # Epilogue
done:
    ret
