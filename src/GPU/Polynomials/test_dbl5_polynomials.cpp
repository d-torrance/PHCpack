/* Tests polynomial evaluation and differentiation
 * in penta double precision. */

#include <iostream>
#include <iomanip>
#include <cstdlib>
#include <ctime>
#include <cmath>
// #include <vector_types.h>
#include "random_polynomials.h"
#include "random5_monomials.h"
#include "random5_polynomials.h"
#include "convolution_jobs.h"
#include "addition_jobs.h"
#include "write_job_counts.h"
// #include "dbl5_polynomials_host.h"
// #include "dbl5_polynomials_kernels.h"

using namespace std;

double test_dbl5_real_polynomial
 ( int dim, int nbr, int nva, int pwr, int deg, int verbose );
/*
 * DESCRIPTION :
 *   Tests the evaluation and differentiation for random real data.
 *   Returns the sum of all errors.
 * 
 * ON ENTRY :
 *   dim      dimension, total number of variables;
 *   nbr      number of terms in the polynomial;
 *   nva      number of variables per monomial (for products and cyclic);
 *   pwr      highest power of each variable;
 *   deg      truncation degree of the series;
 *   verbose  if zero, then no output is written. */

int main_dbl5_test_polynomial
 ( int seed, int dim, int nbr, int nva, int pwr, int deg, int vrblvl );
/*
 * DESCRIPTION :
 *   Runs tests on a random polynomial in triple double precision.
 *   Returns 0 if all tests passed,
 *   otherwise, returns the number of failed tests.
 *
 * ON ENTRY :
 *   seed     seed for the random number generator;
 *   dim      dimension, total number of variables;
 *   nbr      number of terms in the polynomial;
 *   nva      number of variables in each monomial (for products, cyclic);
 *   pwr      highest power of each variable;
 *   deg      truncation degree of the series;
 *   vrblvl   is the verbose level, if 0 then no output. */

int main ( void )
{
   cout << "Give the seed (0 for time) : ";
   int seed; cin >> seed;

   cout << "Give the dimension : ";
   int dim;  cin >> dim;

   cout << "Give the variables per monomial (0 for random polynomial) : ";
   int nva; cin >> nva;

   int nbr; // number of monomials, not counting the constant

   if(nva > 0)
   {
      cout << "Enter 0 for products, other number of cyclic : ";
      cin >> nbr;

      if(nbr == 0)
         nbr = products_count(dim,nva);
      else
         nbr = dim;

      cout << "-> number of monomials : " << nbr << endl;
   }
   else
   {
      cout << "Give the number of terms : ";
      cin >> nbr;
   }
   // cout << "Give the largest power of each variable : "; cin >> pwr;
   const int pwr=1;

   cout << "Give the degree of the series : ";
   int deg; cin >> deg;

   cout << "Give the verbose level : ";
   int vrb; cin >> vrb;

   int fail = main_dbl5_test_polynomial(seed,dim,nbr,nva,pwr,deg,vrb);

   if(fail == 0)
      cout << "All tests passed." << endl;
   else
      cout << "Number of failed tests : " << fail << endl;

   return 0;
}

int main_dbl5_test_polynomial
 ( int seed, int dim, int nbr, int nva, int pwr, int deg, int vrblvl )
{
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
   if(vrblvl > 0) cout << "  Seed used : " << seedused << endl;

   double realsum = test_dbl5_real_polynomial(dim,nbr,nva,pwr,deg,vrblvl-1);

   const double tol = 1.0e-76;

   int fail = int(realsum > tol);

   if(vrblvl > 0)
   {
      cout << scientific << setprecision(2);
      cout << "Sum of all errors in penta double precision :" << endl;
      cout << "  on real data : " << realsum;
      if(realsum < tol)
         cout << "  pass." << endl;
      else
         cout << "  fail!" << endl;

      cout << "  Seed used : " <<  seedused << endl;
   }
   return fail;
}

double test_dbl5_real_polynomial
 ( int dim, int nbr, int nva, int pwr, int deg, int verbose )
{
   if(nbr < 1)
      return 0.0;
   else
   {
      double **inputtb = new double*[dim]; // dim series of degree deg
      for(int i=0; i<dim; i++) inputtb[i] = new double[deg+1];
      double **inputix = new double*[dim];
      for(int i=0; i<dim; i++) inputix[i] = new double[deg+1];
      double **inputmi = new double*[dim];
      for(int i=0; i<dim; i++) inputmi[i] = new double[deg+1];
      double **inputrg = new double*[dim];
      for(int i=0; i<dim; i++) inputrg[i] = new double[deg+1];
      double **inputpk = new double*[dim];
      for(int i=0; i<dim; i++) inputpk[i] = new double[deg+1];
      // The output are dim+1 power series of degree deg
      // for the evaluated and differentiated polynomial.
      double **output1tb_h = new double*[dim+1];
      for(int i=0; i<=dim; i++) output1tb_h[i] = new double[deg+1];
      double **output1ix_h = new double*[dim+1];
      for(int i=0; i<=dim; i++) output1ix_h[i] = new double[deg+1];
      double **output1mi_h = new double*[dim+1];
      for(int i=0; i<=dim; i++) output1mi_h[i] = new double[deg+1];
      double **output1rg_h = new double*[dim+1];
      for(int i=0; i<=dim; i++) output1rg_h[i] = new double[deg+1];
      double **output1pk_h = new double*[dim+1];
      for(int i=0; i<=dim; i++) output1pk_h[i] = new double[deg+1];
      double **output2tb_h = new double*[dim+1];
      for(int i=0; i<=dim; i++) output2tb_h[i] = new double[deg+1];
      double **output2ix_h = new double*[dim+1];
      for(int i=0; i<=dim; i++) output2ix_h[i] = new double[deg+1];
      double **output2mi_h = new double*[dim+1];
      for(int i=0; i<=dim; i++) output2mi_h[i] = new double[deg+1];
      double **output2rg_h = new double*[dim+1];
      for(int i=0; i<=dim; i++) output2rg_h[i] = new double[deg+1];
      double **output2pk_h = new double*[dim+1];
      for(int i=0; i<=dim; i++) output2pk_h[i] = new double[deg+1];
      double **outputtb_d = new double*[dim+1];
      for(int i=0; i<=dim; i++) outputtb_d[i] = new double[deg+1];
      double **outputix_d = new double*[dim+1];
      for(int i=0; i<=dim; i++) outputix_d[i] = new double[deg+1];
      double **outputmi_d = new double*[dim+1];
      for(int i=0; i<=dim; i++) outputmi_d[i] = new double[deg+1];
      double **outputrg_d = new double*[dim+1];
      for(int i=0; i<=dim; i++) outputrg_d[i] = new double[deg+1];
      double **outputpk_d = new double*[dim+1];
      for(int i=0; i<=dim; i++) outputpk_d[i] = new double[deg+1];

      make_real5_input(dim,deg,inputtb,inputix,inputmi,inputrg,inputpk);

      if(verbose > 0)
      {
         cout << scientific << setprecision(16);
         cout << "Random input series :" << endl;
         for(int i=0; i<dim; i++)
         {
            cout << "-> coefficients of series " << i << " :" << endl;
            for(int j=0; j<=deg; j++)
               cout << inputtb[i][j] << "  " << inputix[i][j]
                                     << "  " << inputmi[i][j] << endl
                    << inputrg[i][j] << "  " << inputpk[i][j] << endl;
         }
      }
      double *csttb = new double[deg+1]; // constant coefficient series
      double *cstix = new double[deg+1];
      double *cstmi = new double[deg+1];
      double *cstrg = new double[deg+1];
      double *cstpk = new double[deg+1];
      double **cfftb = new double*[nbr]; // coefficient series of terms
      for(int i=0; i<nbr; i++) cfftb[i] = new double[deg+1];
      double **cffix = new double*[nbr];
      for(int i=0; i<nbr; i++) cffix[i] = new double[deg+1];
      double **cffmi = new double*[nbr];
      for(int i=0; i<nbr; i++) cffmi[i] = new double[deg+1];
      double **cffrg = new double*[nbr];
      for(int i=0; i<nbr; i++) cffrg[i] = new double[deg+1];
      double **cffpk = new double*[nbr];
      for(int i=0; i<nbr; i++) cffpk[i] = new double[deg+1];
      int *nvr = new int[nbr]; // number of variables in each monomial

      if(nva == 0) make_supports(dim,nbr,nvr); // random supports

      int **idx = new int*[nbr];  // indices of variables in monomials

      if(nva == 0)
         for(int i=0; i<nbr; i++) idx[i] = new int[nvr[i]];
      else
      {
         for(int i=0; i<nbr; i++)
         {
            idx[i] = new int[nva];
            nvr[i] = nva;
         }
      }
      int **exp = new int*[nbr];  // exponents of the variables
      if(nva > 0)
      {
         if(nbr == dim)
            make_real5_cyclic
               (dim,nva,deg,idx,csttb,cstix,cstmi,cstrg,cstpk,
                                cfftb,cffix,cffmi,cffrg,cffpk);
         else
            make_real5_products
               (dim,nbr,nva,deg,idx,csttb,cstix,cstmi,cstrg,cstpk,
                                    cfftb,cffix,cffmi,cffrg,cffpk);
      }
      else
      {
         for(int i=0; i<nbr; i++) exp[i] = new int[nvr[i]];

         bool fail = make_real5_polynomial
                        (dim,nbr,pwr,deg,nvr,idx,exp,
                         csttb,cstix,cstmi,cstrg,cstpk,
                         cfftb,cffix,cffmi,cffrg,cffpk);
      }
      if(verbose > 0)
      {
         cout << "Coefficient series of the constant term :" << endl;
         for(int j=0; j<=deg; j++)
            cout << csttb[j] << "  " << cstix[j] << "  " << cstmi[j] << endl
                 << cstrg[j] << "  " << cstpk[j] << endl;

         for(int i=0; i<nbr; i++)
         {
            cout << "Generated random monomial " << i << " :" << endl;
            cout << "   the indices :";
            for(int j=0; j<nvr[i]; j++) cout << " " << idx[i][j];
            cout << endl;
            if(nva == 0)
            {
               cout << " the exponents :";
               for(int j=0; j<nvr[i]; j++) cout << " " << exp[i][j];
               cout << endl;
            }
            cout << " coefficient series :" << endl;
            for(int j=0; j<=deg; j++)
               cout << cfftb[i][j] << "  " << cffix[i][j]
                                   << "  " << cffmi[i][j] << endl
                    << cffrg[i][j] << "  " << cffpk[i][j] << endl;
         }
      }
      bool vrb = (verbose > 0);
      if(nva == 0)
      {
         bool dup = duplicate_supports(dim,nbr,nvr,idx,vrb);
         if(dup)
            cout << "Duplicate supports found." << endl;
         else
            cout << "No duplicate supports found." << endl;
      }
 /*
      ConvolutionJobs cnvjobs(dim);

      cnvjobs.make(nbr,nvr,idx,vrb);

      write_convolution_counts(cnvjobs);

      for(int k=0; k<cnvjobs.get_depth(); k++)
      {
         cout << "jobs at layer " << k << " :" << endl;
         for(int i=0; i<cnvjobs.get_layer_count(k); i++)
            cout << cnvjobs.get_job(k,i) << endl;
      }
      cout << endl;

      AdditionJobs addjobs(dim,nbr);

      addjobs.make(nbr,nvr,idx,true);

      cout << "The differential indices :" << endl;
      for(int i=0; i<dim; i++)
      {
         cout << "variable " << i << " :";
         for(int j=0; j<=addjobs.get_differential_count(i); j++)
            cout << " " << addjobs.get_differential_index(i,j);
         cout << endl;
      }
      write_addition_counts(addjobs);

      for(int k=0; k<addjobs.get_depth(); k++)
      {
         cout << "jobs at layer " << k << " :" << endl;
         for(int i=0; i<addjobs.get_layer_count(k); i++)
            cout << addjobs.get_job(k,i) << endl;
      }
      if(vrb) cout << "Computing without convolution jobs ..." << endl;
      CPU_dbl5_poly_evaldiff
         (dim,nbr,deg,nvr,idx,csttb,cstix,cstrg,cstpk,
          cfftb,cffix,cffrg,cffpk,
          inputtb,inputix,inputrg,inputpk,
          output1tb_h,output1ix_h,output1rg_h,output1pk_h,vrb);
      if(vrb) cout << "Computing with convolution jobs ..." << endl;
      CPU_dbl5_poly_evaldiffjobs
         (dim,nbr,deg,nvr,idx,csttb,cstix,cstrg,cstpk,
          cfftb,cffix,cffrg,cffpk,
          inputtb,inputix,inputrg,inputpk,
          output2tb_h,output2ix_h,output2rg_h,output2pk_h,
          cnvjobs,addjobs,vrb);
      if(vrb) cout << "Computing on the device ..." << endl;
      GPU_dbl5_poly_evaldiff
         (deg+1,dim,nbr,deg,nvr,idx,csttb,cstix,cstrg,cstpk,
          cfftb,cffix,cffrg,cffpk,
          inputtb,inputix,inputrg,inputpk,
          outputtb_d,outputix_d,outputrg_d,outputpk_d,
          cnvjobs,addjobs,vrb);

      double err = 0.0;

      if(verbose > 0) cout << "The value of the polynomial :" << endl;
      for(int i=0; i<=deg; i++)
      {
         if(verbose > 0)
         {
            cout << output1tb_h[dim][i] << "  "
                 << output1ix_h[dim][i] << endl
                 << output1rg_h[dim][i] << "  "
                 << output1pk_h[dim][i] << endl;
            cout << output2tb_h[dim][i] << "  "
                 << output2ix_h[dim][i] << endl
                 << output2rg_h[dim][i] << "  "
                 << output2pk_h[dim][i] << endl;
            cout << outputtb_d[dim][i] << "  "
                 << outputix_d[dim][i] << endl
                 << outputrg_d[dim][i] << "  "
                 << outputpk_d[dim][i] << endl;
         }
         err = err + abs(output1tb_h[dim][i] - output2tb_h[dim][i])
                   + abs(output1ix_h[dim][i] - output2ix_h[dim][i])
                   + abs(output1rg_h[dim][i] - output2rg_h[dim][i])
                   + abs(output1pk_h[dim][i] - output2pk_h[dim][i])
                   + abs(output1tb_h[dim][i] - outputtb_d[dim][i])
                   + abs(output1ix_h[dim][i] - outputix_d[dim][i])
                   + abs(output1rg_h[dim][i] - outputrg_d[dim][i])
                   + abs(output1pk_h[dim][i] - outputpk_d[dim][i]);
      }
      if(verbose > 0) cout << "error : " << err << endl;

      double sumerr = err;

      for(int k=0; k<dim; k++)
      {
         if(verbose > 0) cout << "Derivative " << k << " :" << endl;
         err = 0.0;
         for(int i=0; i<=deg; i++)
         {
            if(verbose > 0)
            {
               cout << output1tb_h[k][i] << "  "
                    << output1ix_h[k][i] << endl
                    << output1rg_h[k][i] << "  "
                    << output1pk_h[k][i] << endl;
               cout << output2tb_h[k][i] << "  "
                    << output2ix_h[k][i] << endl
                    << output2rg_h[k][i] << "  "
                    << output2pk_h[k][i] << endl;
               cout << outputtb_d[k][i] << "  "
                    << outputix_d[k][i] << endl
                    << outputrg_d[k][i] << "  "
                    << outputpk_d[k][i] << endl;
            }
            err = err + abs(output1tb_h[k][i] - output2tb_h[k][i])
                      + abs(output1ix_h[k][i] - output2ix_h[k][i])
                      + abs(output1rg_h[k][i] - output2rg_h[k][i])
                      + abs(output1pk_h[k][i] - output2pk_h[k][i])
                      + abs(output1tb_h[k][i] - outputtb_d[k][i])
                      + abs(output1ix_h[k][i] - outputix_d[k][i])
                      + abs(output1rg_h[k][i] - outputrg_d[k][i])
                      + abs(output1pk_h[k][i] - outputpk_d[k][i]);
         }
         if(verbose > 0) cout << "error : " << err << endl;
         sumerr = sumerr + err;
      }
      cout << "dimension : " << dim << endl;
      if(nva > 0)
      {
         cout << "number of variables per monomial : " << nva << endl;
      }
      cout << "number of monomials : " << nbr << endl;
      write_convolution_counts(cnvjobs);
      write_addition_counts(addjobs);
      write_operation_counts(deg,cnvjobs,addjobs);

      return sumerr;
  */
      return 0.0;
   }
}
