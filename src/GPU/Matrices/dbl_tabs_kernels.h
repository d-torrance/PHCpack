/* The file dbl_tabs_kernels.h specifies functions for the
 * tiled accelerated back substitution in double precision. */

#ifndef __dbl_tabs_kernels_h__
#define __dbl_tabs_kernels_h__

#define d_shmemsize 256

__global__ void dbl_small_invert_upper ( int dim, double *U, double *invU );
/*
 * DESCRIPTION :
 *   Computes the inverse of an upper triangular matrix.
 *   The U matrix is stored in columnwise fashion,
 *   as the row-by-row computation of the inverse invU
 *   applies a column-by-column load of U.
 *
 * REQUIRED : dim <= 16.
 *   Because the inverse is stored entirely in shared memory,
 *   the dimension dim is limited to 16 = 2^4, as 16^2 = 256,
 *   the upper limit on the shared memory, d_shmemsize.
 *
 * ON ENTRY :
 *   dim      dimension of the upper triangular matrix U;
 *   U        an upper triangular matrix stored column wise;
 *   invU     space allocated for a matrix of dimension dim.
 *
 * ON RETURN :
 *   invU     the inverse of the matrix U, stored row wise. */

void test_dbl_small_invert_upper ( int dim, double *U, double *invU );
/*
 * DESCRIPTION :
 *   Runs the same code as dbl_small_invert_upper,
 *   but in a serialized manner, one column after the other,
 *   with many print statements to verified the correctness.
 *   The parameters are the same as dbl_small_invert_upper. */

__global__ void dbl_medium_invert_upper ( int dim, double *U, double *invU );
/*
 * DESCRIPTION :
 *   Computes the inverse of an upper triangular matrix.
 *   The U matrix is stored in columnwise fashion,
 *   as the row-by-row computation of the inverse invU
 *   applies a column-by-column load of U.
 *
 * REQUIRED : dim <= 256.
 *   Because the columns of U are loaded entirely into shared memory
 *   and the rows of the inverses are computed first entirely in
 *   shared memory before storing, the dimension dim is limited 
 *   to 256, the upper limit on the shared memory, d_shmemsize.
 *
 * ON ENTRY :
 *   dim      dimension of the upper triangular matrix U;
 *   U        an upper triangular matrix stored column wise;
 *   invU     space allocated for a matrix of dimension dim.
 *
 * ON RETURN :
 *   invU     the inverse of the matrix U, stored row wise. */

__global__ void  dbl_invert_tiles ( int dim, double *U, double *invU );
/*
 * DESCRIPTION :
 *   Replaces the columns of the tiles with the rows of the inverses.
 *   The number of blocks equals the number of tiles in U.
 *   The number of threads per block equals the dimension of each tile.
 *
 * REQUIRED : dim <= 256 = d_shmemsize.
 *
 * ON ENTRY :
 *   dim      the dimension of each tile;
 *   U        columns of all tiles on the diagonal 
 *            of an upper triangular matrix;
 *   invU     space allocated for the inverse of all tiles in U.
 *
 * ON RETURN :
 *   invU     rows of the inverse of the tiles in U. */

void GPU_dbl_upper_inverse ( int dim, double **U, double **invU );
/*
 * DESCRIPTION :
 *   Calls the kernel to invert the upper triangular matrix U.
 *   The matrices are stored in the conventional rowwise fashion.
 *
 * ON ENTRY :
 *   dim      dimension of the upper triangular matrix U;
 *   U        an upper triangular matrix of dimension dim;
 *   invU     space allocated for a matrix of dimension dim.
 *
 * ON RETURN :
 *   invU     the inverse of the matrix U. */

void GPU_dbl_upper_tiled_solver
 ( int dim, int szt, int nbt, double **U, double *b, double *x );
/*
 * DESCRIPTION :
 *   Solves an upper triangular system with a tiled algorithm.
 *
 * ON ENTRY :
 *   dim      dimension of the upper triangular matrix U;
 *   szt      size of each tile;
 *   nbt      number of tiles, dim = szt*nbt;
 *   U        an upper triangular matrix of dimension dim;
 *   b        the right hand side of the linear system;
 *   x        space allocated for dim doubles.
 *
 * ON RETURN :
 *   x        the solution to the system U*x = b. */

#endif
