// The file dbl_matrices_testers.cpp defines the function with prototypes
// in dbl_matrices_testers.h.

#include <iostream>
#include <iomanip>
#include <cstdlib>
#include "random_numbers.h"
#include "random_series.h"
#include "random_matrices.h"
#include "dbl_matrices_host.h"
#include "dbl_matrices_testers.h"

using namespace std;

void test_real_inner_product ( void )
{
   cout << "Give the dimension : ";
   int dim; cin >> dim;

   cout << "Give a degree larger than one : ";
   int deg; cin >> deg;

   double *x = new double[dim];
   double **px = new double*[dim];
   double **mx = new double*[dim];

   for(int i=0; i<dim; i++)
   {
      px[i] = new double[deg+1];
      mx[i] = new double[deg+1];
   }
   random_dbl_series_vectors(dim,deg,x,px,mx);

   cout << scientific << setprecision(16);

   for(int k=0; k<dim; k++)
   {
      cout << "a random x : " << x[k] << endl;
      cout << "series for exp(+x) :" << endl; 
      for(int i=0; i<=deg; i++) cout << px[k][i] << endl;
      cout << "series for exp(-x) :" << endl; 
      for(int i=0; i<=deg; i++) cout << mx[k][i] << endl;
   }

   double *ip = new double[deg+1];

   real_inner_product(dim,deg,px,mx,ip);

   cout << "the inner product :" << endl;
   for(int i=0; i<=deg; i++) cout << ip[i] << endl;
}

void test_cmplx_inner_product ( void )
{
   cout << "Give the dimension : ";
   int dim; cin >> dim;

   cout << "Give a degree larger than one : ";
   int deg; cin >> deg;

   double *xre = new double[dim];
   double *xim = new double[dim];
   double **pxre = new double*[dim];
   double **pxim = new double*[dim];
   double **mxre = new double*[dim];
   double **mxim = new double*[dim];

   for(int i=0; i<dim; i++)
   {
      pxre[i] = new double[deg+1];
      pxim[i] = new double[deg+1];
      mxre[i] = new double[deg+1];
      mxim[i] = new double[deg+1];
   }
   random_cmplx_series_vectors
      (dim,deg,xre,xim,pxre,pxim,mxre,mxim);

   cout << scientific << setprecision(16);

   for(int k=0; k<dim; k++)
   {
      cout << "a random x : "
           << xre[k] << "  " << xim[k] << endl;
      cout << "series for exp(+x) :" << endl; 
      for(int i=0; i<=deg; i++)
         cout << pxre[k][i] << "  " << pxim[k][i] << endl;
      cout << "series for exp(-x) :" << endl; 
      for(int i=0; i<=deg; i++)
         cout << mxre[k][i] << "  " << mxim[k][i] << endl;
   }

   double *ipre = new double[deg+1];
   double *ipim = new double[deg+1];

   cmplx_inner_product(dim,deg,pxre,pxim,mxre,mxim,ipre,ipim);

   cout << "the inner product :" << endl;
   for(int i=0; i<=deg; i++)
      cout << ipre[i] << "  " << ipim[i] << endl;
}

void test_real_matrix_vector_product ( void )
{
   cout << "Give the number of rows : ";
   int nbrows; cin >> nbrows;

   cout << "Give the number of columns : ";
   int nbcols; cin >> nbcols;

   cout << "Give a degree larger than one : ";
   int deg; cin >> deg;

   double **rnd = new double*[nbrows];
   double ***mat = new double**[nbrows];
   for(int i=0; i<nbrows; i++)
   {
      rnd[i] = new double[nbcols];
      mat[i] = new double*[nbcols];
      for(int j=0; j<nbcols; j++)
         mat[i][j] = new double[deg+1];
   }
   random_dbl_series_matrix(nbrows,nbcols,deg,rnd,mat);

   cout << scientific << setprecision(16);

   for(int i=0; i<nbrows; i++)
      for(int j=0; j<nbcols; j++)
      {
         cout << "A[" << i << "][" << j << "] is exp("
              << rnd[i][j] << ") :" << endl;
         for(int k=0; k<=deg; k++) cout << mat[i][j][k] << endl;
      }
   
   double **x = new double*[nbcols];
   for(int i=0; i<nbcols; i++) x[i] = new double[deg+1];
   double **y = new double*[nbrows];
   for(int i=0; i<nbrows; i++) y[i] = new double[deg+1];

   for(int i=0; i<nbcols; i++)
      dbl_exponential(deg,-rnd[nbrows-1][i],x[i]);

   real_matrix_vector_product(nbrows,nbcols,deg,mat,x,y);
   for(int i=0; i<nbrows; i++)
   {
      cout << "y[" << i << "] :" << endl;
      for(int k=0; k<=deg; k++) cout << y[i][k] << endl;
   }
}

void test_cmplx_matrix_vector_product ( void )
{
   cout << "Give the number of rows : ";
   int nbrows; cin >> nbrows;

   cout << "Give the number of columns : ";
   int nbcols; cin >> nbcols;

   cout << "Give a degree larger than one : ";
   int deg; cin >> deg;

   double **rndre = new double*[nbrows];
   double **rndim = new double*[nbrows];
   double ***matre = new double**[nbrows];
   double ***matim = new double**[nbrows];
   for(int i=0; i<nbrows; i++)
   {
      rndre[i] = new double[nbcols];
      rndim[i] = new double[nbcols];
      matre[i] = new double*[nbcols];
      matim[i] = new double*[nbcols];
      for(int j=0; j<nbcols; j++)
      {
         matre[i][j] = new double[deg+1];
         matim[i][j] = new double[deg+1];
      }
   }
   random_cmplx_series_matrix(nbrows,nbcols,deg,rndre,rndim,matre,matim);

   cout << scientific << setprecision(16);

   for(int i=0; i<nbrows; i++)
      for(int j=0; j<nbcols; j++)
      {
         cout << "A[" << i << "][" << j << "] is exp("
              << rndre[i][j] << ", "
              << rndim[i][j] << ") :" << endl;
         for(int k=0; k<=deg; k++)
            cout << matre[i][j][k] << "  " << matim[i][j][k] << endl;
      }
   
   double **xre = new double*[nbcols];
   double **xim = new double*[nbcols];
   for(int i=0; i<nbcols; i++)
   {
      xre[i] = new double[deg+1];
      xim[i] = new double[deg+1];
   }
   double **yre = new double*[nbrows];
   double **yim = new double*[nbrows];
   for(int i=0; i<nbrows; i++)
   {
      yre[i] = new double[deg+1];
      yim[i] = new double[deg+1];
   }
   for(int i=0; i<nbcols; i++)
      cmplx_exponential
         (deg,-rndre[nbrows-1][i],-rndim[nbrows-1][i],xre[i],xim[i]);

   cmplx_matrix_vector_product
      (nbrows,nbcols,deg,matre,matim,xre,xim,yre,yim);
   for(int i=0; i<nbrows; i++)
   {
      cout << "y[" << i << "] :" << endl;
      for(int k=0; k<=deg; k++)
         cout << yre[i][k] << "  " << yim[i][k] << endl;
   }
}

void test_real_upper_solver ( void )
{
   cout << "Give the dimension : ";
   int dim; cin >> dim;

   cout << "Give a degree larger than one : ";
   int deg; cin >> deg;

   double **rnd = new double*[dim];
   double ***mat = new double**[dim];
   for(int i=0; i<dim; i++)
   {
      rnd[i] = new double[dim];
      mat[i] = new double*[dim];
      for(int j=0; j<dim; j++)
         mat[i][j] = new double[deg+1];
   }
   random_dbl_upper_series_matrix(dim,dim,deg,rnd,mat);

   cout << scientific << setprecision(16);

   for(int i=0; i<dim; i++)
      for(int j=i; j<dim; j++)
      {
         cout << "A[" << i << "][" << j << "] is exp("
              << rnd[i][j] << ") :" << endl;
         for(int k=0; k<=deg; k++) cout << mat[i][j][k] << endl;
      }

   double **x = new double*[dim];
   for(int i=0; i<dim; i++) x[i] = new double[deg+1];
   double **b = new double*[dim];
   for(int i=0; i<dim; i++) b[i] = new double[deg+1];

   for(int i=0; i<dim; i++)  // x equals one
   {
      x[i][0] = 1.0;
      for(int k=1; k<=deg; k++) x[i][k] = 0.0;
   }
   real_matrix_vector_product(dim,dim,deg,mat,x,b);
   for(int i=0; i<dim; i++)
   {
      cout << "b[" << i << "] :" << endl;
      for(int k=0; k<=deg; k++) cout << b[i][k] << endl;
   }
   real_upper_solver(dim,deg,mat,b,x);

   cout << "The solution of the upper triangular system :" << endl;
   for(int i=0; i<dim; i++)
   {
      cout << "x[" << i << "] :" << endl;
      for(int k=0; k<=deg; k++) cout << x[i][k] << endl;
   }
}

void test_cmplx_upper_solver ( void )
{
   cout << "Give the dimension : ";
   int dim; cin >> dim;

   cout << "Give a degree larger than one : ";
   int deg; cin >> deg;

   double **rndre = new double*[dim];
   double **rndim = new double*[dim];
   double ***matre = new double**[dim];
   double ***matim = new double**[dim];
   for(int i=0; i<dim; i++)
   {
      rndre[i] = new double[dim];
      rndim[i] = new double[dim];
      matre[i] = new double*[dim];
      matim[i] = new double*[dim];
      for(int j=0; j<dim; j++)
      {
         matre[i][j] = new double[deg+1];
         matim[i][j] = new double[deg+1];
      }
   }
   random_cmplx_upper_series_matrix(dim,dim,deg,rndre,rndim,matre,matim);

   cout << scientific << setprecision(16);

   for(int i=0; i<dim; i++)
      for(int j=i; j<dim; j++)
      {
         cout << "A[" << i << "][" << j << "] is exp("
              << rndre[i][j] << "  " 
              << rndim[i][j] << ") :" << endl;
         for(int k=0; k<=deg; k++)
            cout << matre[i][j][k] << "  " << matim[i][j][k] << endl;
      }

   double **xre = new double*[dim];
   double **xim = new double*[dim];
   for(int i=0; i<dim; i++)
   {
      xre[i] = new double[deg+1];
      xim[i] = new double[deg+1];
   }
   double **bre = new double*[dim];
   double **bim = new double*[dim];
   for(int i=0; i<dim; i++)
   {
      bre[i] = new double[deg+1];
      bim[i] = new double[deg+1];
   }
   for(int i=0; i<dim; i++)  // x equals one
   {
      xre[i][0] = 1.0;
      xim[i][0] = 0.0;
      for(int k=1; k<=deg; k++)
      {
         xre[i][k] = 0.0;
         xim[i][k] = 0.0;
      }
   }
   cmplx_matrix_vector_product(dim,dim,deg,matre,matim,xre,xim,bre,bim);
   for(int i=0; i<dim; i++)
   {
      cout << "b[" << i << "] :" << endl;
      for(int k=0; k<=deg; k++)
         cout << bre[i][k] << "  " << bim[i][k] << endl;
   }
   cmplx_upper_solver(dim,deg,matre,matim,bre,bim,xre,xim);

   cout << "The solution of the upper triangular system :" << endl;
   for(int i=0; i<dim; i++)
   {
      cout << "x[" << i << "] :" << endl;
      for(int k=0; k<=deg; k++)
         cout << xre[i][k] << "  " << xim[i][k] << endl;
   }
}

void test_real_lufac ( void )
{
   cout << "Give the dimension : ";
   int dim; cin >> dim;

   cout << "Give a degree larger than one : ";
   int deg; cin >> deg;

   double **rnd = new double*[dim];
   double ***A = new double**[dim];
   double ***Acopy = new double**[dim];  // need copy for lufac is inplace
   for(int i=0; i<dim; i++)
   {
      rnd[i] = new double[dim];
      A[i] = new double*[dim];
      Acopy[i] = new double*[dim];
      for(int j=0; j<dim; j++)
      {
         A[i][j] = new double[deg+1];
         Acopy[i][j] = new double[deg+1];
      }
   }
   random_dbl_series_matrix(dim,dim,deg,rnd,A);

   for(int i=0; i<dim; i++)
      for(int j=0; j<dim; j++)
      {
         A[i][j][0] = random_double();
         for(int k=0; k<=deg; k++)
            Acopy[i][j][k] = A[i][j][k];
      }

   cout << scientific << setprecision(16);

   for(int i=0; i<dim; i++)
      for(int j=0; j<dim; j++)
      {
         cout << "A[" << i << "][" << j << "] is exp("
              << rnd[i][j] << ") :" << endl;
         for(int k=0; k<=deg; k++) cout << A[i][j][k] << endl;
      }

   int *pivots = new int[dim];

   real_lufac(dim,deg,A,pivots);
   cout << "done with LU factorization ... " << endl;

   double ***L = new double**[dim]; // lower triangular part of A
   double ***U = new double**[dim]; // upper triangular part of A
   double ***B = new double**[dim]; // the product of L with U
   for(int i=0; i<dim; i++)
   {
      L[i] = new double*[dim];
      U[i] = new double*[dim];
      B[i] = new double*[dim];

      for(int j=0; j<dim; j++)
      {
         L[i][j] = new double[deg+1];
         U[i][j] = new double[deg+1];
         B[i][j] = new double[deg+1];
         if(i < j)
         {
            for(int k=0; k<=deg; k++)
            {
               L[i][j][k] = 0.0;
               U[i][j][k] = A[i][j][k];
            }
         }
         else if(i == j)
         {
            L[i][j][0] = 1.0;
            U[i][j][0] = A[i][j][0];
            for(int k=1; k<=deg; k++)
            {
               L[i][j][k] = 0.0;
               U[i][j][k] = A[i][j][k];
            }
         }
         else
         {
            for(int k=0; k<=deg; k++)
            {
               L[i][j][k] = A[i][j][k];
               U[i][j][k] = 0.0;
            }
         }
      }
   }
   for(int i=0; i<dim; i++)
      for(int j=0; j<dim; j++)
      {
         cout << "L[" << i << "][" << j << "] :" << endl;
         for(int k=0; k<=deg; k++) cout << L[i][j][k] << endl;
      }
   for(int i=0; i<dim; i++)
      for(int j=0; j<dim; j++)
      {
         cout << "U[" << i << "][" << j << "] :" << endl;
         for(int k=0; k<=deg; k++) cout << U[i][j][k] << endl;
      }
   cout << "The pivots :";
   for(int i=0; i<dim; i++) cout << " " << pivots[i];
   cout << endl;

   cout << "doing the matrix-matrix product ... " << endl;
   real_matrix_matrix_product(dim,dim,dim,deg,L,U,B);

   for(int i=0; i<dim; i++)
      for(int j=0; j<dim; j++)
      {
         cout << "A[pivots[" << i << "]][" << j << "] versus ";
         cout << "B[" << i << "][" << j << "] :" << endl;
         for(int k=0; k<=deg; k++)
         {
            cout << Acopy[pivots[i]][j][k] << endl;
            cout << B[i][j][k] << endl;
         }
      }
}
