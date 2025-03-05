/************************************************************************
**
** NAME:        steganography.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**				Justin Yokota - Starter Code
**				YOUR NAME HERE
**
** DATE:        2020-08-23
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "imageloader.h"

//Determines what color the cell at the given row/col should be. This should not affect Image, and should allocate space for a new Color.
Color *evaluateOnePixel(Image *image, int row, int col)
{
	Color *color = (Color*) malloc(sizeof(Color));
	if ((image->image[row][col].B & 1) == 1) 
	{
		color->R = 255;
		color->G = 255;
		color->B = 255;
	}
	else
	{
		color->R = 0;
		color->G = 0;
		color->B = 0;
	}
	return color;
}

//Given an image, creates a new image extracting the LSB of the B channel.
Image *steganography(Image *image)
{
	Image *new_image = (Image*) malloc(sizeof(Image));
	new_image->rows = image->rows;
	new_image->cols = image->cols;
	new_image->image = (Color**) malloc(new_image->rows * sizeof(Color*));
	for (int i = 0; i < new_image->rows; i++)
	{
		new_image->image[i] = (Color*) malloc(new_image->cols * sizeof(Color)); 
	}
	for (uint32_t i = 0; i < image->rows; i++)
    {
        for (uint32_t j = 0; j < image->cols; j++)
        {
			Color *color_i_j = evaluateOnePixel(image, i, j);
			new_image->image[i][j] = *color_i_j;
			free(color_i_j);
        }
    }
	return new_image;
}

/*
Loads a file of ppm P3 format from a file, and prints to stdout (e.g. with printf) a new image, 
where each pixel is black if the LSB of the B channel is 0, 
and white if the LSB of the B channel is 1.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a file of ppm P3 format (not necessarily with .ppm file extension).
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!
*/
int main(int argc, char **argv)
{
	if (argc <= 1) {
		return -1;
	}
	char *file_name = argv[1];
	Image *image = readData(file_name);
	Image *new_image = steganography(image);
	writeData(new_image);
	freeImage(image);
	freeImage(new_image);
	return 0;
}
