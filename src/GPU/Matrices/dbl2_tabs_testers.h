// The file dbl2_tabs_testers.h specifies test functions on the
// tiled accelerated back substitution in double double precision.

#ifndef __dbl2_tabs_testers_h__
#define __dbl2_tabs_testers_h__

double dbl2_Difference_Sum
 ( int n, double *xhi, double *xlo, double *yhi, double *ylo );
/*
 * DESCRIPTION :
 *   Returns the sum of the absolute value of the differences
 *   between the entries of the n-dimensional vectors x and y. */

double dbl2_Column_Sum ( int dim, int col, double **Ahi, double **Alo );
/*
 * DESCRIPTION :
 *   Returns the sum of the absolute values of all dim elements
 *   of the matrix A in the column with index col. */

double dbl2_Max_Column_Sum ( int dim, double **Ahi, double **Alo );
/*
 * DESCRIPTION :
 *   Returns the maximum column sum of the elements
 *   in the matrix A of dimension dim. */

double dbl2_condition
 ( int dim, double **Ahi, double **Alo, double **invAhi, double **invAlo );
/*
 * DESCRIPTION :
 *   Returns the condition number of A using the 1-norm
 *   on the matrix of dimension dim and its inverse invA. */

double dbl2_Matrix_Difference_Sum
 ( int n, double **Ahi, double **Alo, double **Bhi, double **Blo );
/*
 * DESCRIPTION :
 *   Returns the sum of the absolute value of the differences
 *   between two n-by-n matrices A and B. */

void test_real2_upper_inverse ( void );
/*
 * DESCRIPTION :
 *   Generates a random real upper triangular matrix
 *   to test the computation of its inverse. */

#endif
