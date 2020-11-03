/* The file dbl_monomials_host.cpp defines functions specified
 * in dbl_monomials_host.h. */

#include <cstdlib>
#include "dbl_convolutions_host.h"
#include "dbl_monomials_host.h"

void CPU_dbl_speel
 ( int nvr, int deg, int *idx, double **input,
   double **forward, double **backward, double **cross )
{
   int ix1 = idx[0];
   int ix2 = idx[1];

   CPU_dbl_product(deg,input[ix1],input[ix2],forward[0]);
   for(int i=2; i<nvr; i++)
   {
      ix2 = idx[i];
      CPU_dbl_product(deg,forward[i-2],input[ix2],forward[i-1]);
   }
   if(nvr > 2)
   {
      ix1 = idx[nvr-1];
      ix2 = idx[nvr-2];
      CPU_dbl_product(deg,input[ix1],input[ix2],backward[0]);
      for(int i=1; i<nvr-2; i++)
      {
         ix2 = idx[nvr-2-i];
         CPU_dbl_product(deg,backward[i-1],input[ix2],backward[i]);
      }
      if(nvr == 3)
      {
         ix1 = idx[0];
         ix2 = idx[2];
         CPU_dbl_product(deg,input[ix1],input[ix2],cross[0]);
      }
      else
      {
         ix1 = idx[0];
         ix2 = nvr-3;
         CPU_dbl_product(deg,input[ix1],backward[ix2],cross[0]);
         for(int i=1; i<nvr-3; i++)
         {
            ix2 = nvr-3-i;
            CPU_dbl_product(deg,forward[i-1],backward[ix2],cross[i]);
         }
         ix2 = idx[nvr-1];
         CPU_dbl_product(deg,forward[nvr-4],input[ix2],cross[nvr-3]);
      }
   }
}

void CPU_dbl_evaldiff
 ( int dim, int nvr, int deg, int *idx, double **input, double **output )
{
   double **forward = new double*[nvr-1];
   double **backward = new double*[nvr-2];
   double **cross = new double*[nvr-2];

   for(int i=0; i<nvr-2; i++)
   {
      forward[i] = new double[deg+1];
      backward[i] = new double[deg+1];
      cross[i] = new double[deg+1];
   }
   forward[nvr-2] = new double[deg+1];

   CPU_dbl_speel(nvr,deg,idx,input,forward,backward,cross);

   for(int i=0; i<=deg; i++) output[dim][i] = forward[nvr-2][i];  

   if(nvr > 2)
   {
      int ix = idx[nvr-1];
      for(int i=0; i<=deg; i++) output[ix][i] = forward[nvr-3][i];  

      ix = idx[0];
      for(int i=0; i<=deg; i++) output[ix][i] = backward[nvr-3][i];  

      for(int k=1; k<nvr-1; k++)
      {
         ix = idx[k];
         for(int i=0; i<=deg; i++) output[ix][i] = cross[k-1][i];  
      }
   }
   for(int i=0; i<nvr-2; i++)
   {
      free(forward[i]);
      free(backward[i]);
      free(cross[i]);
   }
   free(forward[nvr-2]);

   free(forward); free(backward); free(cross);
}
