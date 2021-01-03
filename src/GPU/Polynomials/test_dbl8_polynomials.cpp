/* Tests polynomial evaluation and differentiation
 * in octo double precision. */

#include <iostream>
#include <iomanip>
#include <cstdlib>
#include <ctime>
#include <cmath>
#include <vector_types.h>
#include "random_polynomials.h"
#include "random8_monomials.h"
#include "random8_polynomials.h"
#include "convolution_jobs.h"
#include "addition_jobs.h"
#include "write_job_counts.h"
#include "dbl8_polynomials_host.h"
#include "dbl8_polynomials_kernels.h"

using namespace std;

double test_dbl8_real_polynomial
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

int main_dbl8_test_polynomial
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

   int fail = main_dbl8_test_polynomial(seed,dim,nbr,nva,pwr,deg,vrb);

   if(fail == 0)
      cout << "All tests passed." << endl;
   else
      cout << "Number of failed tests : " << fail << endl;

   return 0;
}

int main_dbl8_test_polynomial
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

   double realsum = test_dbl8_real_polynomial(dim,nbr,nva,pwr,deg,vrblvl-1);

   const double tol = 1.0e-120;

   int fail = int(realsum > tol);

   if(vrblvl > 0)
   {
      cout << scientific << setprecision(2);
      cout << "Sum of all errors in octo double precision :" << endl;
      cout << "  on real data : " << realsum;
      if(realsum < tol)
         cout << "  pass." << endl;
      else
         cout << "  fail!" << endl;

      cout << "  Seed used : " <<  seedused << endl;
   }
   return fail;
}

double test_dbl8_real_polynomial
 ( int dim, int nbr, int nva, int pwr, int deg, int verbose )
{
   if(nbr < 1)
      return 0.0;
   else
   {
      double **inputhihihi = new double*[dim]; // dim series of degree deg
      for(int i=0; i<dim; i++) inputhihihi[i] = new double[deg+1];
      double **inputhilohi = new double*[dim];
      for(int i=0; i<dim; i++) inputhilohi[i] = new double[deg+1];
      double **inputhihilo = new double*[dim];
      for(int i=0; i<dim; i++) inputhihilo[i] = new double[deg+1];
      double **inputhilolo = new double*[dim];
      for(int i=0; i<dim; i++) inputhilolo[i] = new double[deg+1];
      double **inputlohihi = new double*[dim];
      for(int i=0; i<dim; i++) inputlohihi[i] = new double[deg+1];
      double **inputlolohi = new double*[dim];
      for(int i=0; i<dim; i++) inputlolohi[i] = new double[deg+1];
      double **inputlohilo = new double*[dim];
      for(int i=0; i<dim; i++) inputlohilo[i] = new double[deg+1];
      double **inputlololo = new double*[dim];
      for(int i=0; i<dim; i++) inputlololo[i] = new double[deg+1];
      // The output are dim+1 power series of degree deg
      // for the evaluated and differentiated polynomial.
      double **output1hihihi_h = new double*[dim+1];
      for(int i=0; i<=dim; i++) output1hihihi_h[i] = new double[deg+1];
      double **output1hilohi_h = new double*[dim+1];
      for(int i=0; i<=dim; i++) output1hilohi_h[i] = new double[deg+1];
      double **output1hihilo_h = new double*[dim+1];
      for(int i=0; i<=dim; i++) output1hihilo_h[i] = new double[deg+1];
      double **output1hilolo_h = new double*[dim+1];
      for(int i=0; i<=dim; i++) output1hilolo_h[i] = new double[deg+1];
      double **output1lohihi_h = new double*[dim+1];
      for(int i=0; i<=dim; i++) output1lohihi_h[i] = new double[deg+1];
      double **output1lolohi_h = new double*[dim+1];
      for(int i=0; i<=dim; i++) output1lolohi_h[i] = new double[deg+1];
      double **output1lohilo_h = new double*[dim+1];
      for(int i=0; i<=dim; i++) output1lohilo_h[i] = new double[deg+1];
      double **output1lololo_h = new double*[dim+1];
      for(int i=0; i<=dim; i++) output1lololo_h[i] = new double[deg+1];
      double **output2hihihi_h = new double*[dim+1];
      for(int i=0; i<=dim; i++) output2hihihi_h[i] = new double[deg+1];
      double **output2hilohi_h = new double*[dim+1];
      for(int i=0; i<=dim; i++) output2hilohi_h[i] = new double[deg+1];
      double **output2hihilo_h = new double*[dim+1];
      for(int i=0; i<=dim; i++) output2hihilo_h[i] = new double[deg+1];
      double **output2hilolo_h = new double*[dim+1];
      for(int i=0; i<=dim; i++) output2hilolo_h[i] = new double[deg+1];
      double **output2lohihi_h = new double*[dim+1];
      for(int i=0; i<=dim; i++) output2lohihi_h[i] = new double[deg+1];
      double **output2lolohi_h = new double*[dim+1];
      for(int i=0; i<=dim; i++) output2lolohi_h[i] = new double[deg+1];
      double **output2lohilo_h = new double*[dim+1];
      for(int i=0; i<=dim; i++) output2lohilo_h[i] = new double[deg+1];
      double **output2lololo_h = new double*[dim+1];
      for(int i=0; i<=dim; i++) output2lololo_h[i] = new double[deg+1];
      double **outputhihihi_d = new double*[dim+1];
      for(int i=0; i<=dim; i++) outputhihihi_d[i] = new double[deg+1];
      double **outputhilohi_d = new double*[dim+1];
      for(int i=0; i<=dim; i++) outputhilohi_d[i] = new double[deg+1];
      double **outputhihilo_d = new double*[dim+1];
      for(int i=0; i<=dim; i++) outputhihilo_d[i] = new double[deg+1];
      double **outputhilolo_d = new double*[dim+1];
      for(int i=0; i<=dim; i++) outputhilolo_d[i] = new double[deg+1];
      double **outputlohihi_d = new double*[dim+1];
      for(int i=0; i<=dim; i++) outputlohihi_d[i] = new double[deg+1];
      double **outputlolohi_d = new double*[dim+1];
      for(int i=0; i<=dim; i++) outputlolohi_d[i] = new double[deg+1];
      double **outputlohilo_d = new double*[dim+1];
      for(int i=0; i<=dim; i++) outputlohilo_d[i] = new double[deg+1];
      double **outputlololo_d = new double*[dim+1];
      for(int i=0; i<=dim; i++) outputlololo_d[i] = new double[deg+1];

      make_real8_input(dim,deg,
         inputhihihi,inputhilohi,inputhihilo,inputhilolo,
         inputlohihi,inputlolohi,inputlohilo,inputlololo);

      if(verbose > 0)
      {
         cout << scientific << setprecision(16);
         cout << "Random input series :" << endl;
         for(int i=0; i<dim; i++)
         {
            cout << "-> coefficients of series " << i << " :" << endl;
            for(int j=0; j<=deg; j++)
            {
               cout << inputhihihi[i][j] << "  " << inputlohihi[i][j] << endl;
               cout << inputhilohi[i][j] << "  " << inputlolohi[i][j] << endl;
               cout << inputhihilo[i][j] << "  " << inputlohilo[i][j] << endl;
               cout << inputhilolo[i][j] << "  " << inputlololo[i][j] << endl;
            }
         }
      }
      double *csthihihi = new double[deg+1]; // constant coefficient series
      double *csthilohi = new double[deg+1];
      double *csthihilo = new double[deg+1];
      double *csthilolo = new double[deg+1];
      double *cstlohihi = new double[deg+1]; 
      double *cstlolohi = new double[deg+1];
      double *cstlohilo = new double[deg+1];
      double *cstlololo = new double[deg+1];
      double **cffhihihi = new double*[nbr]; // coefficient series of terms
      for(int i=0; i<nbr; i++) cffhihihi[i] = new double[deg+1];
      double **cffhilohi = new double*[nbr];
      for(int i=0; i<nbr; i++) cffhilohi[i] = new double[deg+1];
      double **cffhihilo = new double*[nbr];
      for(int i=0; i<nbr; i++) cffhihilo[i] = new double[deg+1];
      double **cffhilolo = new double*[nbr];
      for(int i=0; i<nbr; i++) cffhilolo[i] = new double[deg+1];
      double **cfflohihi = new double*[nbr];
      for(int i=0; i<nbr; i++) cfflohihi[i] = new double[deg+1];
      double **cfflolohi = new double*[nbr];
      for(int i=0; i<nbr; i++) cfflolohi[i] = new double[deg+1];
      double **cfflohilo = new double*[nbr];
      for(int i=0; i<nbr; i++) cfflohilo[i] = new double[deg+1];
      double **cfflololo = new double*[nbr];
      for(int i=0; i<nbr; i++) cfflololo[i] = new double[deg+1];
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
            make_real8_cyclic
               (dim,nva,deg,idx,
                csthihihi,csthilohi,csthihilo,csthilolo,
                cstlohihi,cstlolohi,cstlohilo,cstlololo,
                cffhihihi,cffhilohi,cffhihilo,cffhilolo,
                cfflohihi,cfflolohi,cfflohilo,cfflololo);
         else
            make_real8_products
               (dim,nbr,nva,deg,idx,
                csthihihi,csthilohi,csthihilo,csthilolo,
                cstlohihi,cstlolohi,cstlohilo,cstlololo,
                cffhihihi,cffhilohi,cffhihilo,cffhilolo,
                cfflohihi,cfflolohi,cfflohilo,cfflololo);
      }
      else
      {
         for(int i=0; i<nbr; i++) exp[i] = new int[nvr[i]];

         bool fail = make_real8_polynomial
                        (dim,nbr,pwr,deg,nvr,idx,exp,
                         csthihihi,csthilohi,csthihilo,csthilolo,
                         cstlohihi,cstlolohi,cstlohilo,cstlololo,
                         cffhihihi,cffhilohi,cffhihilo,cffhilolo,
                         cfflohihi,cfflolohi,cfflohilo,cfflololo);
      }
      if(verbose > 0)
      {
         cout << "Coefficient series of the constant term :" << endl;
         for(int j=0; j<=deg; j++)
         {
            cout << csthihihi[j] << " " << cstlohihi[j] << endl;
            cout << csthilohi[j] << " " << cstlolohi[j] << endl;
            cout << csthihilo[j] << " " << cstlohilo[j] << endl;
            cout << csthilolo[j] << " " << cstlololo[j] << endl;
         }

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
            {
               cout << cffhihihi[i][j] << " " << cfflohihi[i][j] << endl;
               cout << cffhilohi[i][j] << " " << cfflolohi[i][j] << endl;
               cout << cffhihilo[i][j] << " " << cfflohilo[i][j] << endl;
               cout << cffhilolo[i][j] << " " << cfflololo[i][j] << endl;
            }
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
      CPU_dbl8_poly_evaldiff
         (dim,nbr,deg,nvr,idx,
          csthihihi,csthilohi,csthihilo,csthilolo,
          cstlohihi,cstlolohi,cstlohilo,cstlololo,
          cffhihihi,cffhilohi,cffhihilo,cffhilolo,
          cfflohihi,cfflolohi,cfflohilo,cfflololo,
          inputhihihi,inputhilohi,inputhihilo,inputhilolo,
          inputlohihi,inputlolohi,inputlohilo,inputlololo,
          output1hihihi_h,output1hilohi_h,output1hihilo_h,output1hilolo_h,
          output1lohihi_h,output1lolohi_h,output1lohilo_h,output1lololo_h,
          vrb);
      if(vrb) cout << "Computing with convolution jobs ..." << endl;
      CPU_dbl8_poly_evaldiffjobs
         (dim,nbr,deg,nvr,idx,
          csthihihi,csthilohi,csthihilo,csthilolo,
          cstlohihi,cstlolohi,cstlohilo,cstlololo,
          cffhihihi,cffhilohi,cffhihilo,cffhilolo,
          cfflohihi,cfflolohi,cfflohilo,cfflololo,
          inputhihihi,inputhilohi,inputhihilo,inputhilolo,
          inputlohihi,inputlolohi,inputlohilo,inputlololo,
          output2hihihi_h,output2hilohi_h,output2hihilo_h,output2hilolo_h,
          output2lohihi_h,output2lolohi_h,output2lohilo_h,output2lololo_h,
          cnvjobs,addjobs,vrb);
      if(vrb) cout << "Computing on the device ..." << endl;
      GPU_dbl8_poly_evaldiff
         (deg+1,dim,nbr,deg,nvr,idx,
          csthihihi,csthilohi,csthihilo,csthilolo,
          cstlohihi,cstlolohi,cstlohilo,cstlololo,
          cffhihihi,cffhilohi,cffhihilo,cffhilolo,
          cfflohihi,cfflolohi,cfflohilo,cfflololo,
          inputhihihi,inputhilohi,inputhihilo,inputhilolo,
          inputlohihi,inputlolohi,inputlohilo,inputlololo,
          outputhihihi_d,outputhilohi_d,outputhihilo_d,outputhilolo_d,
          outputlohihi_d,outputlolohi_d,outputlohilo_d,outputlololo_d,
          cnvjobs,addjobs,vrb);

      double err = 0.0;

      if(verbose > 0) cout << "The value of the polynomial :" << endl;
      for(int i=0; i<=deg; i++)
      {
         if(verbose > 0)
         {
            cout << output1hihihi_h[dim][i] << "  "
                 << output1hilohi_h[dim][i] << endl
                 << output1hihilo_h[dim][i] << "  "
                 << output1hilolo_h[dim][i] << endl;
            cout << output1lohihi_h[dim][i] << "  "
                 << output1lolohi_h[dim][i] << endl
                 << output1lohilo_h[dim][i] << "  "
                 << output1lololo_h[dim][i] << endl;
            cout << output2hihihi_h[dim][i] << "  "
                 << output2hilohi_h[dim][i] << endl
                 << output2hihilo_h[dim][i] << "  "
                 << output2hilolo_h[dim][i] << endl;
            cout << output2lohihi_h[dim][i] << "  "
                 << output2lolohi_h[dim][i] << endl
                 << output2lohilo_h[dim][i] << "  "
                 << output2lololo_h[dim][i] << endl;
            cout << outputhihihi_d[dim][i] << "  "
                 << outputhilohi_d[dim][i] << endl
                 << outputhihilo_d[dim][i] << "  "
                 << outputhilolo_d[dim][i] << endl;
            cout << outputlohihi_d[dim][i] << "  "
                 << outputlolohi_d[dim][i] << endl
                 << outputlohilo_d[dim][i] << "  "
                 << outputlololo_d[dim][i] << endl;
         }
         err = err + abs(output1hihihi_h[dim][i] - output2hihihi_h[dim][i])
                   + abs(output1hilohi_h[dim][i] - output2hilohi_h[dim][i])
                   + abs(output1hihilo_h[dim][i] - output2hihilo_h[dim][i])
                   + abs(output1hilolo_h[dim][i] - output2hilolo_h[dim][i])
                   + abs(output1lohihi_h[dim][i] - output2lohihi_h[dim][i])
                   + abs(output1lolohi_h[dim][i] - output2lolohi_h[dim][i])
                   + abs(output1lohilo_h[dim][i] - output2lohilo_h[dim][i])
                   + abs(output1lololo_h[dim][i] - output2lololo_h[dim][i])
                   + abs(output1hihihi_h[dim][i] - outputhihihi_d[dim][i])
                   + abs(output1hilohi_h[dim][i] - outputhilohi_d[dim][i])
                   + abs(output1hihilo_h[dim][i] - outputhihilo_d[dim][i])
                   + abs(output1hilolo_h[dim][i] - outputhilolo_d[dim][i])
                   + abs(output1lohihi_h[dim][i] - outputlohihi_d[dim][i])
                   + abs(output1lolohi_h[dim][i] - outputlolohi_d[dim][i])
                   + abs(output1lohilo_h[dim][i] - outputlohilo_d[dim][i])
                   + abs(output1lololo_h[dim][i] - outputlololo_d[dim][i]);
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
               cout << output1hihihi_h[k][i] << "  "
                    << output1hilohi_h[k][i] << endl
                    << output1hihilo_h[k][i] << "  "
                    << output1hilolo_h[k][i] << endl;
               cout << output1lohihi_h[k][i] << "  "
                    << output1lolohi_h[k][i] << endl
                    << output1lohilo_h[k][i] << "  "
                    << output1lololo_h[k][i] << endl;
               cout << output2hihihi_h[k][i] << "  "
                    << output2hilohi_h[k][i] << endl
                    << output2hihilo_h[k][i] << "  "
                    << output2hilolo_h[k][i] << endl;
               cout << output2lohihi_h[k][i] << "  "
                    << output2lolohi_h[k][i] << endl
                    << output2lohilo_h[k][i] << "  "
                    << output2lololo_h[k][i] << endl;
               cout << outputhihihi_d[k][i] << "  "
                    << outputhilohi_d[k][i] << endl
                    << outputhihilo_d[k][i] << "  "
                    << outputhilolo_d[k][i] << endl;
               cout << outputlohihi_d[k][i] << "  "
                    << outputlolohi_d[k][i] << endl
                    << outputlohilo_d[k][i] << "  "
                    << outputlololo_d[k][i] << endl;
            }
            err = err + abs(output1hihihi_h[k][i] - output2hihihi_h[k][i])
                      + abs(output1hilohi_h[k][i] - output2hilohi_h[k][i])
                      + abs(output1hihilo_h[k][i] - output2hihilo_h[k][i])
                      + abs(output1hilolo_h[k][i] - output2hilolo_h[k][i])
                      + abs(output1lohihi_h[k][i] - output2lohihi_h[k][i])
                      + abs(output1lolohi_h[k][i] - output2lolohi_h[k][i])
                      + abs(output1lohilo_h[k][i] - output2lohilo_h[k][i])
                      + abs(output1lololo_h[k][i] - output2lololo_h[k][i])
                      + abs(output1hihihi_h[k][i] - outputhihihi_d[k][i])
                      + abs(output1hilohi_h[k][i] - outputhilohi_d[k][i])
                      + abs(output1hihilo_h[k][i] - outputhihilo_d[k][i])
                      + abs(output1hilolo_h[k][i] - outputhilolo_d[k][i])
                      + abs(output1lohihi_h[k][i] - outputlohihi_d[k][i])
                      + abs(output1lolohi_h[k][i] - outputlolohi_d[k][i])
                      + abs(output1lohilo_h[k][i] - outputlohilo_d[k][i])
                      + abs(output1lololo_h[k][i] - outputlololo_d[k][i]);
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
   }
}
