// Collects the convolution jobs to evaluate and differentiate
// one polynomial in several variables.

#include <iostream>
#include <cstdlib>
#include <ctime>
#include "random_polynomials.h"

using namespace std;

void write_monomial_convolutions ( int nvr, int *idx, int monidx, int *cnt );
/*
 * DESCRIPTION :
 *   Writes the convolution jobs to evaluate and differentiate one monomial.
 *
 * ON ENTRY :
 *   nvr     number of variables in the monomial;
 *   idx     array of nvr indices to the participating variables;
 *   monidx  index of the monomial;
 *   cnt     current number of convolution jobs.
 *
 * ON RETURN :
 *   cnt     updated number of convolution jobs. */

void write_polynomial_convolutions ( int nbr, int *nvr, int **idx );
/*
 * DESCRIPTION :
 *   Writes the convolution jobs to evaluate and differentiate a polynomial.
 *
 * ON ENTRY :
 *   nbr     number of monomials in the polynomial;
 *   nvr     array of nbr counts on the number of variables in monomials;
 *   idx     array of nbr indices to the participating variables. */

int main ( void )
{
   cout << "Give the seed (0 for time) : ";
   int seed; cin >> seed;

   cout << "Give the dimension : ";
   int dim;  cin >> dim;

   cout << "Give the number of terms : ";
   int nbr; cin >> nbr;

   int seedused;

   if(seed != 0)
   {
      srand(seed);
      seedused = seed;
   }
   else
   {
      const int timevalue = time(NULL); // for a random seed
      srand(timevalue);
      seedused = timevalue;
   }
   const int deg=0;
   const int pwr=1;

   double *cst = new double[deg+1]; // constant coefficient series
   double **cff = new double*[nbr]; // coefficient series of terms
   for(int i=0; i<nbr; i++) cff[i] = new double[deg+1];
   int *nvr = new int[nbr]; // number of variables in each monomial

   make_supports(dim,nbr,nvr); // define supports of polynomial

   int **idx = new int*[nbr];  // indices of variables in monomials
   for(int i=0; i<nbr; i++) idx[i] = new int[nvr[i]];
   int **exp = new int*[nbr];  // exponents of the variables
   for(int i=0; i<nbr; i++) exp[i] = new int[nvr[i]];

   bool fail = make_real_polynomial(dim,nbr,pwr,deg,nvr,idx,exp,cst,cff);

   for(int i=0; i<nbr; i++)
   {
      cout << "Indices of monomial " << i << " :";
      for(int j=0; j<nvr[i]; j++) cout << " " << idx[i][j]; cout << endl;
   }
   write_polynomial_convolutions(nbr,nvr,idx);

   return 0;
}

void write_monomial_convolutions ( int nvr, int *idx, int monidx, int *cnt )
{
   int ix1 = idx[0];
   int ix2;

   *cnt = *cnt + 1; cout << *cnt << " : ";
   cout << "monomial " << monidx << " : ";               // f[0] = cff*x[0]
   cout << "cff * input[" << ix1 << "] to f[0]" << endl;

   for(int i=1; i<nvr; i++)
   {                                                  // f[i] = f[i-1]*x[i]
      ix2 = idx[i];
      *cnt = *cnt + 1; cout << *cnt << " : ";
      cout << "monomial " << monidx << " : ";
      cout << "f[" << i-1 << "] * "
           << "input[" << ix2 << "] to f[" << i << "]" << endl;
   }
   if(nvr > 2)
   {
      ix1 = idx[nvr-1]; ix2 = idx[nvr-2];           // b[0] = x[n-1]*x[n-2]
      *cnt = *cnt + 1; cout << *cnt << " : ";
      cout << "monomial " << monidx << " : ";
      cout << "input[" << ix1 << "] * "
           << "input[" << ix2 << "] to b[0]" << endl;

      for(int i=1; i<nvr-2; i++)
      {                                           // b[i] = b[i-1]*x[n-2-i]
         ix2 = idx[nvr-2-i];
         *cnt = *cnt + 1; cout << *cnt << " : ";
         cout << "monomial " << monidx << " : ";
         cout << "b[" << i-1 << "] * "
              << "input[" << ix2 << "] to b[" << i << "]" << endl;
      }
      *cnt = *cnt + 1; cout << *cnt << " : ";
      cout << "monomial " << monidx << " : ";        // b[n-3] = cff*b[n-3]
      cout << "b[" << nvr-3 << "] * cff to "
           << "b[" << nvr-2 << "]" << endl;
      // host code uses cross[0] as work space,
      // kernels write to backward[nvr-2]

      if(nvr == 3)
      {                                                 // c[0] = f[0]*x[2]
         ix2 = idx[2];
         *cnt = *cnt + 1; cout << *cnt << " : ";
         cout << "monomial " << monidx << " : ";
         cout << "f[0] * input[" << ix2 << "] to c[0]" << endl;
      }
      else
      {
         for(int i=0; i<nvr-3; i++)
         {                                          // c[i] = f[i]*b[n-4-i]
            ix2 = nvr-4-i;
            *cnt = *cnt + 1; cout << *cnt << " : ";
            cout << "monomial " << monidx << " : ";
            cout << "f[" << i << "] * b[" << ix2
                 << "] to c[" << i << "]" << endl;
         }
         ix2 = idx[nvr-1];                        // c[n-3] = f[n-3]*x[n-1]
         *cnt = *cnt + 1; cout << *cnt << " : ";
         cout << "monomial " << monidx << " : ";
         cout << "f[" << nvr-3 << "] * input[" << ix2
              << "] to c[" << nvr-3 << "]" << endl;
      }
   }
}

void write_polynomial_convolutions ( int nbr, int *nvr, int **idx )
{
   int ix1,ix2;
   int cnt=0;

   for(int i=0; i<nbr; i++)
   {
      if(nvr[i] == 1)
      {
         ix1 = idx[i][0];

         cnt = cnt + 1; cout << cnt << " : ";
         cout << "monomial " << i << " : ";
         cout << "input[" << ix1 << "] * cff to f[0]" << endl;
      }
      else if(nvr[i] == 2)
      {
         ix1 = idx[i][0]; ix2 = idx[i][1];

         cnt = cnt + 1; cout << cnt << " : ";
         cout << "monomial " << i << " : ";
         cout << "input[" << ix1 << "] * "
              << "input[" << ix2 << "] to f[0]" << endl;

         cnt = cnt + 1; cout << cnt << " : ";
         cout << "monomial " << i << " : ";
         cout << "f[0] * cff to f[0]" << endl;

         cnt = cnt + 1; cout << cnt << " : ";
         cout << "monomial " << i << " : ";
         cout << "cff * " << "input[" << ix1 << "] to b[0]" << endl;

         cnt = cnt + 1; cout << cnt << " : ";
         cout << "monomial " << i << " : ";
         cout << "cff * " << "input[" << ix2 << "] to c[0]" << endl;
      }
      else if(nvr[i] > 2)
      {
         write_monomial_convolutions(nvr[i],idx[i],i,&cnt);
      }
   }
}
