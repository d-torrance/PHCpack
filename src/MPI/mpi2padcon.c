/* mpi2padcon.c defines an interactive message passing parallel program
 * to track all solution paths in a dynamic load balancing scheme with
 * Pade approximants as predictor.
 * The user is prompted for the precision, can adjust all parameters,
 * and is asked to provide the file names for the target, start system,
 * and start solutions.  All output is written to file.  */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "mpi.h"
#include "syscon.h"
#include "phcpack.h"
#include "jump_track.h"
#include "parallel_phcpack.h"
#include "padcon.h"

extern void adainit ( void );
extern void adafinal ( void );

int prompt_for_precision ( void );
/*
 * DESCRIPTION :
 *   Prompts the user for the working precision,
 *   which is either double, double double, or quad double,
 *   and returns 0, 1, or 2 respectively. */

int parameters_broadcast ( int myid, int nbrp, int verbose );
/*
 * DESCRIPTION :
 *   After tuning the parameters for Pade continuation,
 *   the root node broadcasts all values for the parameters
 *   to all nbrp processes.
 *   If verbose, then extra data is written to screen for testing. */

int standard_run ( int myid, int nbrp, char* outfile, int verbose );
/*
 * DESCRIPTION :
 *   Prompts the user for a target system, start system with solutions,
 *   allows then to tune the parameters interactive, and then runs
 *   the Pade continuation in standard double precision.
 *    
 * ON ENTRY :
 *   myid     identification number of the current process;
 *   nbrp     number of processes;
 *   outfile  is the name for the output file, only valid if myid == 0;
 *   verbose  if zero, then the run will be silent,
 *            otherwise extra message will be written to screen. */

int dobldobl_run ( int myid, int nbrp, char* outfile, int verbose );
/*
 * DESCRIPTION :
 *   Prompts the user for a target system, start system with solutions,
 *   allows then to tune the parameters interactive, and then runs
 *   the Pade continuation in double double precision.
 *    
 * ON ENTRY :
 *   myid     identification number of the current process;
 *   nbrp     number of processes;
 *   outfile  is the name for the output file, only valid if myid == 0;
 *   verbose  if zero, then the run will be silent,
 *            otherwise extra message will be written to screen. */

int quaddobl_run ( int myid, int nbrp, char* outfile, int verbose );
/*
 * DESCRIPTION :
 *   Prompts the user for a target system, start system with solutions,
 *   allows then to tune the parameters interactive, and then runs
 *   the Pade continuation in quad double precision.
 *    
 * ON ENTRY :
 *   myid     identification number of the current process;
 *   nbrp     number of processes;
 *   outfile  is the name for the output file, only valid if myid == 0;
 *   verbose  if zero, then the run will be silent,
 *            otherwise extra message will be written to screen. */

int main ( int argc, char *argv[] )
{
   const int verbose = 1;
   int myid,numprocs,precision,fail;
   char* filename;
 
   adainit();
   MPI_Init(&argc,&argv);
   MPI_Comm_size(MPI_COMM_WORLD,&numprocs);
   MPI_Comm_rank(MPI_COMM_WORLD,&myid);

   if(verbose > 0)
   {
       printf("\nHello from process %d!\n", myid);
       MPI_Barrier(MPI_COMM_WORLD);
   }
   if(myid == 0) precision = prompt_for_precision();

   MPI_Bcast(&precision,1,MPI_INT,0,MPI_COMM_WORLD);
   if(verbose > 0)
       printf("\nProcess %d has %d as precision.\n", myid, precision);

   MPI_Barrier(MPI_COMM_WORLD);

   if(myid == 0)
   {
      filename = (char*)calloc(80,sizeof(char));
      char nl;
      int ns;

      printf("\nReading the name of the output file ...");
      printf("\nGive a string of characters : "); scanf("%s",filename);
      scanf("%c",&nl); /* skip newline symbol for next reading ...*/
      if(verbose > 0) printf("\nThe output file is \"%s\".\n", filename);
      ns = strlen(filename);
      fail = define_output_file_with_string(ns,filename);
   }

   MPI_Barrier(MPI_COMM_WORLD);

   switch(precision)
   {
      case 0: fail = standard_run(myid,numprocs,filename,verbose); break;
      case 1: fail = dobldobl_run(myid,numprocs,filename,verbose); break;
      case 2: fail = quaddobl_run(myid,numprocs,filename,verbose); break;
      default: printf("Invalid choice of precision.\n");
   }

   MPI_Finalize();
   adafinal();

   return 0;
}

int prompt_for_precision ( void )
{
   int answer;

   printf("\nMENU for the working precision :\n");
   printf("  0. double precision :\n");
   printf("  1. double double precision :\n");
   printf("  2. quad double precision :\n");
   printf("Type 0, 1, or 2 to select the precision : ");
   scanf("%d", &answer);

   return answer;
}

int parameters_broadcast ( int myid, int nbrp, int verbose )
{
   int fail;
   double fltval,minstep,maxstep,beta1,beta2,alpha,epsilon,tolzero;
   double gamma[2];
   int numdeg,dendeg,maxiter,maxsteps;

   if(myid == 0)
   {
      fail = padcon_set_default_parameters();
      padcon_tune_homotopy_continuation_parameters();
      fail = padcon_get_homotopy_continuation_parameter(1,gamma);
      fail = padcon_get_homotopy_continuation_parameter(2,&fltval);
      numdeg = (int) fltval;
      fail = padcon_get_homotopy_continuation_parameter(3,&fltval);
      dendeg = (int) fltval;
      fail = padcon_get_homotopy_continuation_parameter(4,&maxstep);
      fail = padcon_get_homotopy_continuation_parameter(5,&minstep);
      fail = padcon_get_homotopy_continuation_parameter(6,&beta1);
      fail = padcon_get_homotopy_continuation_parameter(7,&beta2);
      fail = padcon_get_homotopy_continuation_parameter(8,&alpha);
      fail = padcon_get_homotopy_continuation_parameter(9,&epsilon);
      fail = padcon_get_homotopy_continuation_parameter(10,&tolzero);
      fail = padcon_get_homotopy_continuation_parameter(11,&fltval);
      maxiter = (int) fltval;
      fail = padcon_get_homotopy_continuation_parameter(12,&fltval);
      maxsteps = (int) fltval;
   }
   MPI_Bcast(gamma,2,MPI_DOUBLE,0,MPI_COMM_WORLD); 
   MPI_Bcast(&numdeg,1,MPI_INT,0,MPI_COMM_WORLD);
   MPI_Bcast(&dendeg,1,MPI_INT,0,MPI_COMM_WORLD);
   MPI_Bcast(&maxstep,1,MPI_DOUBLE,0,MPI_COMM_WORLD); 
   MPI_Bcast(&minstep,1,MPI_DOUBLE,0,MPI_COMM_WORLD); 
   MPI_Bcast(&beta1,1,MPI_DOUBLE,0,MPI_COMM_WORLD); 
   MPI_Bcast(&beta2,1,MPI_DOUBLE,0,MPI_COMM_WORLD); 
   MPI_Bcast(&alpha,1,MPI_DOUBLE,0,MPI_COMM_WORLD); 
   MPI_Bcast(&epsilon,1,MPI_DOUBLE,0,MPI_COMM_WORLD); 
   MPI_Bcast(&tolzero,1,MPI_DOUBLE,0,MPI_COMM_WORLD); 
   MPI_Bcast(&maxiter,1,MPI_INT,0,MPI_COMM_WORLD);
   MPI_Bcast(&maxsteps,1,MPI_INT,0,MPI_COMM_WORLD);
   if(myid != 0)
   {
      fail = padcon_set_homotopy_continuation_parameter(1,gamma);
      fltval = (double) numdeg;
      fail = padcon_set_homotopy_continuation_parameter(2,&fltval);
      fltval = (double) dendeg;
      fail = padcon_set_homotopy_continuation_parameter(3,&fltval);
      fail = padcon_set_homotopy_continuation_parameter(4,&maxstep);
      fail = padcon_set_homotopy_continuation_parameter(5,&minstep);
      fail = padcon_set_homotopy_continuation_parameter(6,&beta1);
      fail = padcon_set_homotopy_continuation_parameter(7,&beta2);
      fail = padcon_set_homotopy_continuation_parameter(8,&alpha);
      fail = padcon_set_homotopy_continuation_parameter(9,&epsilon);
      fail = padcon_set_homotopy_continuation_parameter(10,&tolzero);
      fltval = (double) maxiter;
      fail = padcon_set_homotopy_continuation_parameter(11,&fltval);
      fltval = (double) maxsteps;
      fail = padcon_set_homotopy_continuation_parameter(12,&fltval);
   }
   if(verbose > 0)
      if(myid == 1) padcon_write_homotopy_continuation_parameters();
}

int standard_run ( int myid, int nbrp, char* outfile, int verbose )
{
   int fail,dim;

   if(myid == 0)
   {
      fail = read_target_system_without_solutions();
      fail = copy_target_system_to_container();
      fail = syscon_number_of_standard_polynomials(&dim);
      fail = write_standard_target_system(); // writes to file
   }
   standard_dimensions_broadcast(myid,&dim,&dim);

   if(verbose > 0) printf("Process %d has dimension %d.\n",myid,dim);

   monomials_broadcast(myid,dim); // broadcast target system

   if(myid != 0) fail = copy_container_to_target_system();

   if(verbose > 0)
      if(myid == 1) fail = write_standard_target_system();

   if(myid == 0)
   {
      fail = read_standard_start_system();
      fail = copy_start_system_to_container();
      fail = write_standard_start_system(); // writes to file
      fail = write_start_solutions(); // writes solutions to file
   }
   monomials_broadcast(myid,dim); // broadcast start system

   if(myid != 0) fail = copy_container_to_start_system();

   if(verbose > 0)
      if(myid == 1) fail = write_standard_start_system();

   parameters_broadcast(myid,nbrp,1);

   return 0;
}

int dobldobl_run ( int myid, int nbrp, char* outfile, int verbose )
{
   int fail,dim;

   if(myid == 0)
   {
      fail = read_dobldobl_target_system_without_solutions();
      fail = copy_dobldobl_target_system_to_container();
      fail = syscon_number_of_dobldobl_polynomials(&dim);
      fail = write_dobldobl_target_system();
   }
   dobldobl_dimensions_broadcast(myid,&dim,&dim);

   if(verbose > 0) printf("Process %d has dimension %d.\n",myid,dim);

   dobldobl_monomials_broadcast(myid,dim);

   if(myid != 0) fail = copy_dobldobl_container_to_target_system();

   if(verbose > 0)
      if(myid == 1) fail = write_dobldobl_target_system();

   if(myid == 0)
   {
      fail = read_dobldobl_start_system();
      fail = copy_dobldobl_start_system_to_container();
      fail = write_dobldobl_start_system(); // writes to file
      fail = write_dobldobl_start_solutions(); // writes solutions to file
   }
   monomials_broadcast(myid,dim); // broadcast start system

   if(myid != 0) fail = copy_dobldobl_container_to_start_system();

   if(verbose > 0)
      if(myid == 1) fail = write_dobldobl_start_system();

   parameters_broadcast(myid,nbrp,1);

   return 0;
}

int quaddobl_run ( int myid, int nbrp, char* outfile, int verbose )
{
   int fail,dim;

   if(myid == 0)
   {
      fail = read_quaddobl_target_system_without_solutions();
      fail = copy_quaddobl_target_system_to_container();
      fail = syscon_number_of_quaddobl_polynomials(&dim);
      fail = write_quaddobl_target_system();
   }
   quaddobl_dimensions_broadcast(myid,&dim,&dim);

   if(verbose > 0) printf("Process %d has dimension %d.\n",myid,dim);

   quaddobl_monomials_broadcast(myid,dim);

   if(myid != 0) fail = copy_quaddobl_container_to_target_system();

   if(verbose > 0)
      if(myid == 1) fail = write_quaddobl_target_system();

   if(myid == 0)
   {
      fail = read_quaddobl_start_system();
      fail = copy_quaddobl_start_system_to_container();
      fail = write_quaddobl_start_system(); // writes to file
      fail = write_quaddobl_start_solutions(); // writes solutions to file
   }
   monomials_broadcast(myid,dim); // broadcast start system

   if(myid != 0) fail = copy_quaddobl_container_to_start_system();

   if(verbose > 0)
      if(myid == 1) fail = write_quaddobl_start_system();

   parameters_broadcast(myid,nbrp,1);

   return 0;
}
