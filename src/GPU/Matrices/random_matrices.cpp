// The file random_matrices.cpp defines the functions with prototypes
// in random_matrices.h.

#include "random_series.h"
#include "random_matrices.h"

void random_dbl_series_vector ( int dim, int deg, double *x, double **v )
{
   for(int k=0; k<dim; k++)
      random_dbl_exponential(deg,&x[k],v[k]);
}

void random_dbl_series_vectors
 ( int dim, int deg, double *x, double **plux, double **minx )
{
   for(int k=0; k<dim; k++)
      random_dbl_exponentials(deg,&x[k],plux[k],minx[k]);
}

void random_cmplx_series_vectors
 ( int dim, int deg, double *xre, double *xim,
   double **pluxre, double **pluxim, double **minxre, double **minxim )
{
   for(int k=0; k<dim; k++)
      random_cmplx_exponentials
         (deg,&xre[k],&xim[k],pluxre[k],pluxim[k],minxre[k],minxim[k]);
}

void random_dbl_series_matrix
 ( int rows, int cols, int deg, double **x, double ***A )
{
   for(int i=0; i<rows; i++)
      for(int j=0; j<cols; j++)
         random_dbl_exponential(deg,&x[i][j],A[i][j]);
}

void random_dbl_upper_series_matrix
 ( int rows, int cols, int deg, double **x, double ***A )
{
   for(int i=0; i<rows; i++)
   {
      for(int j=0; j<i; j++)
      {
         for(int k=0; k<=deg; k++) A[i][j][k] = 0.0;
      }
      for(int j=i; j<cols; j++)
      {
         random_dbl_exponential(deg,&x[i][j],A[i][j]);
      }
   }
}

void random_cmplx_series_matrix
 ( int rows, int cols, int deg, double **xre, double **xim,
   double ***Are, double ***Aim )
{
   for(int i=0; i<rows; i++)
      for(int j=0; j<cols; j++)
         random_cmplx_exponential
            (deg,&xre[i][j],&xim[i][j],Are[i][j],Aim[i][j]);
}

void random_cmplx_upper_series_matrix
 ( int rows, int cols, int deg, double **xre, double **xim,
   double ***Are, double ***Aim )
{
   for(int i=0; i<rows; i++)
   {
      for(int j=0; j<i; j++)
      {
         for(int k=0; k<=deg; k++)
         {
            Are[i][j][k] = 0.0;
            Aim[i][j][k] = 0.0;
         }
      }
      for(int j=i; j<cols; j++)
      {
         random_cmplx_exponential
            (deg,&xre[i][j],&xim[i][j],Are[i][j],Aim[i][j]);
      }
   }
}
