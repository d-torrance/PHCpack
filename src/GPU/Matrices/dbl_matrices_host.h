/* The file dbl_matrices_host specifies functions on vectors and matrices
 * of series truncated to the same degree in double precision. */

#ifndef __dbl_matrices_host_h__
#define __dbl_matrices_host_h__

void real_inner_product
 ( int dim, int deg, double **x, double **y, double *z );
/*
 * DESCRIPTION :
 *   Computes the product of two real vectors x and y of power series
 *   and assigns the result to z.
 *
 * ON ENTRY :
 *   dim      dimension of the vectors x and y;
 *   deg      truncation degree of the series;
 *   x        dim series truncated to degree deg;
 *   y        dim series truncated to degree deg;
 *   z        space for deg+1 doubles.
 *
 * ON RETURN :
 *   z        the sum of all x[k]*y[k] for k from 0 to dim-1,
 *            as a power series truncated to the degree deg. */

void cmplx_inner_product
 ( int dim, int deg,
   double **xre, double **xim, double **yre, double **yim,
   double *zre, double *zim );
/*
 * DESCRIPTION :
 *   Computes the product of two complex vectors x and y of power series
 *   and assigns the result to z.
 *
 * ON ENTRY :
 *   dim      dimension of the vectors x and y;
 *   deg      truncation degree of the series;
 *   xre      real parts of dim series truncated to degree deg;
 *   xim      imaginary parts of dim series truncated to degree deg;
 *   yre      real parts of dim series truncated to degree deg;
 *   yim      imaginary parts of dim series truncated to degree deg;
 *   zre      space for deg+1 doubles;
 *   zim      space for deg+1 doubles.
 *
 * ON RETURN :
 *   zre      real parts of the sum of all x[k]*y[k] for k from 0 to dim-1,
 *            as a power series truncated to the degree deg;
 *   zim      imaginary parts of the sum of all x[k]*y[k] for k from 0
 *            to dim-1, as a power series truncated to the degree deg. */

void real_matrix_vector_product
 ( int rows, int cols, int deg, double ***A, double **x, double **y );
/*
 * DESCRIPTION :
 *   Computes the product y of the matrix A with x on real data.
 *
 * ON ENTRY :
 *   rows     the number of rows in the matrix A
 *            and the dimension of y;
 *   cols     the number of columns in the matrix A
 *            and the dimension of x;
 *   deg      truncation degree of the series;
 *   A        matrix of dimensions rows and cols,
 *            of power series truncated at the degree deg;
 *   x        vector of dimension cols
 *            of power series truncated at the degree deg;
 *   y        space allocated for a vector of dimension rows 
 *            of power series truncated at the degree deg.
 *
 * ON RETURN :
 *   y        product of A with x. */

void cmplx_matrix_vector_product
 ( int rows, int cols, int deg, double ***Are, double ***Aim,
   double **xre, double **xim, double **yre, double **yim );
/*
 * DESCRIPTION :
 *   Computes the product y of the matrix A with x on complex data.
 *
 * ON ENTRY :
 *   rows     the number of rows in the matrix A
 *            and the dimension of y;
 *   cols     the number of columns in the matrix A
 *            and the dimension of x;
 *   deg      truncation degree of the series;
 *   Are      real parts of a matrix of dimensions rows and cols,
 *            of power series truncated at the degree deg;
 *   Aim      imaginary parts of a matrix of dimensions rows and cols,
 *            of power series truncated at the degree deg;
 *   xre      real parts of a vector of dimension cols
 *            of power series truncated at the degree deg;
 *   xim      imaginary parts of a vector of dimension cols
 *            of power series truncated at the degree deg;
 *   yre      space allocated for a vector of dimension rows for
 *            the real parts of series truncated at the degree deg;
 *   yim      space allocated for a vector of dimension rows for
 *            the imaginary parts of series truncated at the degree deg.
 *
 * ON RETURN :
 *   yre      real parts of the product of A with x;
 *   yim      imaginary parts of the product of A with x. */

void real_matrix_matrix_product
 ( int rows, int dim, int cols, int deg, 
   double ***A, double ***B, double ***C );
/*
 * DESCRIPTION :
 *   Computes the product C of the matrix A with B on real data.
 *
 * ON ENTRY :
 *   rows     the number of rows in the matrices A and C;
 *   dim      the number of columns in A and rows in B;
 *   cols     the number of columns in the matrices B and C;
 *   deg      truncation degree of the series;
 *   A        matrix of dimensions rows and dim,
 *            of power series truncated at the degree deg;
 *   B        matrix of dimensions dim and cols,
 *            of power series truncated at the degree deg;
 *   C        space allocated for a rows-by_cols matrix
 *            of power series truncated at the degree deg.
 *
 * ON RETURN :
 *   C        product of A with B. */

void real_lower_solver
 ( int dim, int deg, double ***L, double **b, double **x  );
/*
 * DESCRIPTION :
 *   Solves the lower triangular system L*x = b with forward substitution.
 *
 * ON ENTRY :
 *   dim      number of rows and columns in the matrix L;
 *   deg      truncation degree of the series;
 *   L        lower triangular series matrix;
 *   b        right hand side vector;
 *   x        space for dim power series truncated at degree deg.
 *
 * ON RETURN :
 *   x        the solution to L*x = b. */

void real_upper_solver
 ( int dim, int deg, double ***U, double **b, double **x  );
/*
 * DESCRIPTION :
 *   Solves the upper triangular system U*x = b with back substitution.
 *
 * ON ENTRY :
 *   dim      number of rows and columns in the matrix U;
 *   deg      truncation degree of the series;
 *   U        upper triangular series matrix;
 *   b        right hand side vector;
 *   x        space for dim power series truncated at degree deg.
 *
 * ON RETURN :
 *   x        the solution to U*x = b. */

void cmplx_upper_solver
 ( int dim, int deg, double ***Ure, double ***Uim,
   double **bre, double **bim, double **xre, double **xim );
/*
 * DESCRIPTION :
 *   Solves the upper triangular system U*x = b with back substitution.
 *
 * ON ENTRY :
 *   dim      number of rows and columns in the matrix U;
 *   deg      truncation degree of the series;
 *   Ure      real part of an upper triangular series matrix;
 *   Uim      imaginary part of an upper triangular series matrix;
 *   bre      real part of the right hand side vector;
 *   bim      imaginary part of the right hand side vector;
 *   xre      space for dim power series truncated at degree deg;
 *   xim      space for dim power series truncated at degree deg.
 *
 * ON RETURN :
 *   xre      real part of the solution to U*x = b;
 *   xim      real part of the solution to U*x = b. */

void real_lufac ( int dim, int deg, double ***A, int *pivots );
/*
 * DESCRIPTION :
 *   Does an inplace LU factorization with pivoting on the matrix A,
 *   of power series all truncated to the same degree.
 *
 * ON ENTRY :
 *   dim      number of rows and columns in the matrix A;
 *   deg      truncation degree of the series;
 *   A        matrix of power series;
 *   pivots   space for dim pivots.
 *
 * ON RETURN :
 *   A        the lower triangular part of A contains the multipliers
 *            and the upper triangular part of A the row reduced A;
 *   pivots   are the pivots used. */

void real_lu_solver
 ( int dim, int deg, double ***A, int *pivots, double **b, double **x );
/*
 * DESCRIPTION :
 *   Does an inplace LU factorization with pivoting on the matrix A,
 *   of power series all truncated to the same degree,
 *   to solve the system A*x = b.
 *
 * ON ENTRY :
 *   dim      number of rows and columns in the matrix A;
 *   deg      truncation degree of the series;
 *   A        matrix of power series;
 *   pivots   space for dim pivots;
 *   b        right hand side vector;
 *   x        space for dim power series truncated at degree deg.
 *
 * ON RETURN :
 *   A        the lower triangular part of A contains the multipliers
 *            and the upper triangular part of A the row reduced A;
 *   b        permuted according to the pivots;
 *   x        the solution to A*x = b. */

#endif
