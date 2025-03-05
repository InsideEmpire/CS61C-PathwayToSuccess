/************************************************************************
**
** NAME:        gameoflife.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Justin Yokota - Starter Code
**				YOUR NAME HERE
**
**
** DATE:        2020-08-23
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "imageloader.h"

//Determines what color the cell at the given row/col should be. This function allocates space for a new Color.
//Note that you will need to read the eight neighbors of the cell in question. The grid "wraps", so we treat the top row as adjacent to the bottom row
//and the left column as adjacent to the right column.
Color *evaluateOneCell(Image *image, int row, int col, uint32_t rule)
{
	int rows = image->rows;
    int cols = image->cols;
    int alive_neighbors = 0;

    int neighbors[8][2] = {
        {(row - 1 + rows) % rows, (col - 1 + cols) % cols},
        {(row - 1 + rows) % rows, col},
        {(row - 1 + rows) % rows, (col + 1) % cols},
        {row, (col - 1 + cols) % cols},
        {row, (col + 1) % cols},
        {(row + 1) % rows, (col - 1 + cols) % cols},
        {(row + 1) % rows, col},
        {(row + 1) % rows, (col + 1) % cols}
    };

    for (int i = 0; i < 8; i++) {
        int neighbor_row = neighbors[i][0];
        int neighbor_col = neighbors[i][1];
        if (image->image[neighbor_row][neighbor_col].R == 255) {
            alive_neighbors++;
        }
    }

    int current_state = (image->image[row][col].R == 255) ? 1 : 0;

    int new_state = (rule >> (current_state * 9 + alive_neighbors)) & 1;

    Color *new_color = (Color *)malloc(sizeof(Color));
    if (new_state == 1) {
        new_color->R = 255;
        new_color->G = 255;
        new_color->B = 255;
    } else {
        new_color->R = 0;
        new_color->G = 0;
        new_color->B = 0;
    }

    return new_color;
}

//The main body of Life; given an image and a rule, computes one iteration of the Game of Life.
//You should be able to copy most of this from steganography.c
Image *life(Image *image, uint32_t rule)
{
	Image *new_image = (Image *)malloc(sizeof(Image));
    new_image->rows = image->rows;
    new_image->cols = image->cols;
    new_image->image = (Color **)malloc(new_image->rows * sizeof(Color *));
    for (int i = 0; i < new_image->rows; i++) {
        new_image->image[i] = (Color *)malloc(new_image->cols * sizeof(Color));
    }

    for (int i = 0; i < image->rows; i++) {
        for (int j = 0; j < image->cols; j++) {
            Color *new_color = evaluateOneCell(image, i, j, rule);
            new_image->image[i][j] = *new_color;
            free(new_color);
        }
    }

    return new_image;
}

/*
Loads a .ppm from a file, computes the next iteration of the game of life, then prints to stdout the new image.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a .ppm.
argv[2] should contain a hexadecimal number (such as 0x1808). Note that this will be a string.
You may find the function strtol useful for this conversion.
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!

You may find it useful to copy the code from steganography.c, to start.
*/
int main(int argc, char **argv)
{
	if (argc <= 2) {
		printf("usage: ./gameOfLife filename rule\nfilename is an ASCII PPM file (type P3) with maximum value 255.\nrule is a hex number beginning with 0x; Life is 0x1808.\n");
		return -1;
	}
	char *file_name = argv[1];
    char *rule_str = argv[2];

    char *endptr;
    uint32_t rule = strtol(rule_str, &endptr, 16);
    if (*endptr != '\0' || rule < 0x00000 || rule > 0x3FFFF) {
        printf("Invalid rule. Rule should be a hex number between 0x00000 and 0x3FFFF.\n");
        return -1;
    }

	Image *image = readData(file_name);

    Image *new_image = life(image, rule);

    writeData(new_image);
    freeImage(image);
    freeImage(new_image);

    return 0;
}
