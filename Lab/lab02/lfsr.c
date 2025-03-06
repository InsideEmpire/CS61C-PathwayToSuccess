#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "lfsr.h"

void lfsr_calculate(uint16_t *reg) {
    *reg = (*reg >> 1) | ((((*reg >> 5) ^ (*reg >> 3) ^ (*reg >> 2) ^ (*reg >> 0)) & 1) << 15);
}

