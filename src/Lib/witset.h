/* The file witset.h contains prototypes of functions on witness sets.
 * By default, compilation with gcc is assumed.
 * To compile with a C++ compiler such as g++, the flag compilewgpp must
 * be defined as "g++ -Dcompilewgpp=1." */

#ifndef __WITSET_H__
#define __WITSET_H__

#ifdef compilewgpp
extern "C" void adainit( void );
extern "C" int _ada_use_c2phc ( int task, int *a, int *b, double *c );
extern "C" void adafinal( void );
#else
extern void adainit( void );
extern int _ada_use_c2phc ( int task, int *a, int *b, double *c );
extern void adafinal( void );
#endif

/* some basic OPERATIONS on witness sets */

int embed_system ( int d, int precision );
/*
 * DESCRIPTION :
 *   Replaces the system in the container with its embedding of 
 *   dimension d in double, double double, or quad double precision,
 *   depending whether precision equals 0, 1, or 2. */

int embed_standard_system ( int d );
/*
 * DESCRIPTION :
 *   Replaces the system in the container for systems in standard double
 *   precision with its embedding of dimension d. */

int embed_dobldobl_system ( int d );
/*
 * DESCRIPTION :
 *   Replaces the system in the container for systems in double double
 *   precision with its embedding of dimension d. */

int embed_quaddobl_system ( int d );
/*
 * DESCRIPTION :
 *   Replaces the system in the container for systems in quad double
 *   precision with its embedding of dimension d. */

int read_witness_set ( int *n, int *dim, int *deg );
/*
 * DESCRIPTION :
 *   The user is prompted to give an embedded system with solutions,
 *   which will be parsed into standard double precision.
 *   If all goes well, on return, the standard systems container
 *   holds an embedded system with corresponding solutions in the
 *   standard solutions container.
 *
 * ON RETURN :
 *   n        ambient dimension, i.e.: total number of variables;
 *   dim      dimension of the solution set;
 *   deg      degree of the solution set.  */

int read_dobldobl_witness_set ( int *n, int *dim, int *deg );
/*
 * DESCRIPTION :
 *   The user is prompted to give an embedded system with solutions,
 *   which will be parsed into double double precision.
 *   If all goes well, on return, the dobldobl systems container
 *   holds an embedded system with corresponding solutions in the
 *   dobldobl solutions container.
 *
 * ON RETURN :
 *   n        ambient dimension, i.e.: total number of variables;
 *   dim      dimension of the solution set;
 *   deg      degree of the solution set.  */

int read_quaddobl_witness_set ( int *n, int *dim, int *deg );
/*
 * DESCRIPTION :
 *   The user is prompted to give an embedded system with solutions,
 *   which will be parsed into quad double precision.
 *   If all goes well, on return, the quaddobl systems container
 *   holds an embedded system with corresponding solutions in the
 *   quaddobl solutions container.
 *
 * ON RETURN :
 *   n        ambient dimension, i.e.: total number of variables;
 *   dim      dimension of the solution set;
 *   deg      degree of the solution set.  */

int read_witness_set_from_file ( int m, char *s, int *n, int *dim, int *deg );
/*
 * DESCRIPTION :
 *   Reads a witness set from file, stores the witness set in the
 *   standard double precision systems container and solutions container.
 *
 * ON ENTRY :
 *   m        number of characters in the string s;
 *   s        name of the file where the witness set is stored.
 *
 * ON RETURN :
 *   n        ambient dimension, i.e.: total number of variables;
 *   dim      dimension of the solution set;
 *   deg      degree of the solution set. */

int read_dobldobl_witness_set_from_file
 ( int m, char *s, int *n, int *dim, int *deg );
/*
 * DESCRIPTION :
 *   Reads a witness set from file, stores the witness set in the
 *   double double precision systems container and solutions container.
 *
 * ON ENTRY :
 *   m        number of characters in the string s;
 *   s        name of the file where the witness set is stored.
 *
 * ON RETURN :
 *   n        ambient dimension, i.e.: total number of variables;
 *   dim      dimension of the solution set;
 *   deg      degree of the solution set. */

int read_quaddobl_witness_set_from_file
 ( int m, char *s, int *n, int *dim, int *deg );
/*
 * DESCRIPTION :
 *   Reads a witness set from file, stores the witness set in the
 *   quad double precision systems container and solutions container.
 *
 * ON ENTRY :
 *   m        number of characters in the string s;
 *   s        name of the file where the witness set is stored.
 *
 * ON RETURN :
 *   n        ambient dimension, i.e.: total number of variables;
 *   dim      dimension of the solution set;
 *   deg      degree of the solution set. */

int write_witness_set_to_file ( int m, char *s );
/*
 * DESCRIPTION :
 *   Writes the system and solutions in the container in standard
 *   double precision to the file with the given name.
 *
 * REQUIRED : the symbol table is properly arranged.
 *
 * ON ENTRY :
 *   m        number of characters in the string s;
 *   s        name of the output file to write the witness set to. */

int write_dobldobl_witness_set_to_file ( int m, char *s );
/*
 * DESCRIPTION :
 *   Writes the system and solutions in the container in double
 *   double precision to the file with the given name.
 *
 * REQUIRED : the symbol table is properly arranged.
 *
 * ON ENTRY :
 *   m        number of characters in the string s;
 *   s        name of the output file to write the witness set to. */

int write_quaddobl_witness_set_to_file ( int m, char *s );
/*
 * DESCRIPTION :
 *   Writes the system and solutions in the container in quad
 *   double precision to the file with the given name.
 *
 * REQUIRED : the symbol table is properly arranged.
 *
 * ON ENTRY :
 *   m        number of characters in the string s;
 *   s        name of the output file to write the witness set to. */

int read_a_witness_set ( int k, int *n, int *dim, int *deg );
/*
 * DESCRIPTION :
 *   Prompts the user to give the name of the file for witness set k,
 *   for use in a diagonal homotopy.
 *
 * ON ENTRY :
 *   k        indicates first (k=1) or second (k=2) witness set.
 *
 * ON RETURN :
 *   n        ambient dimension, i.e.: total number of variables;
 *   dim      dimension of the solution set;
 *   deg      degree of the solution set.  */

int witness_set_to_system_container ( void );
/*
 * DESCRIPTION :
 *   Copies the embedded system of the witness set from the sampler
 *   to the systems container in standard double precision. */

int dobldobl_witness_set_to_system_container ( void );
/*
 * DESCRIPTION :
 *   Copies the embedded system of the witness set from the sampler
 *   to the systems container in double double precision. */

int quaddobl_witness_set_to_system_container ( void );
/*
 * DESCRIPTION :
 *   Copies the embedded system of the witness set from the sampler
 *   to the systems container in quad double precision. */

int create_cascade_homotopy ( void );
/*
 * DESCRIPTION :
 *   Creates a homotopy using the stored systems to go one level down
 *   the cascade, removing one slice. */

int create_dobldobl_cascade_homotopy ( void );
/*
 * DESCRIPTION :
 *   Creates a homotopy using the stored systems to go one level down
 *   the cascade, removing one slice. */

int create_quaddobl_cascade_homotopy ( void );
/*
 * DESCRIPTION :
 *   Creates a homotopy using the stored systems to go one level down
 *   the cascade, removing one slice. */

/* OPERATIONS to intersect witness sets */

int standard_diagonal_homotopy ( int a, int b );
/*
 * DESCRIPTION :
 *   Creates a diagonal homotopy to intersect two solution sets of
 *   dimensions a and b respectively, where a >= b.
 *   The systems stored as target and start system in the container
 *   in standard double precision define the witness sets for these
 *   two solution sets. */

int dobldobl_diagonal_homotopy ( int a, int b );
/*
 * DESCRIPTION :
 *   Creates a diagonal homotopy to intersect two solution sets of
 *   dimensions a and b respectively, where a >= b.
 *   The systems stored as target and start system in the container
 *   in double double precision define the witness sets for these
 *   two solution sets. */

int quaddobl_diagonal_homotopy ( int a, int b );
/*
 * DESCRIPTION :
 *   Creates a diagonal homotopy to intersect two solution sets of
 *   dimensions a and b respectively, where a >= b.
 *   The systems stored as target and start system in the container
 *   in quad double precision define the witness sets for these
 *   two solution sets. */

int standard_diagonal_cascade_solutions ( int a, int b );
/*
 * DESCRIPTION :
 *   Makes the start solutions to start the cascade homotopy to
 *   intersect two solution sets of dimensions a and b, where a >= b,
 *   in standard double precision.
 *   The systems stored as target and start system in the container
 *   define the witness sets for these two solution sets. */

int dobldobl_diagonal_cascade_solutions ( int a, int b );
/*
 * DESCRIPTION :
 *   Makes the start solutions to start the cascade homotopy to
 *   intersect two solution sets of dimensions a and b, where a >= b,
 *   in double double precision.
 *   The systems stored as target and start system in the container
 *   define the witness sets for these two solution sets. */

int quaddobl_diagonal_cascade_solutions ( int a, int b );
/*
 * DESCRIPTION :
 *   Makes the start solutions to start the cascade homotopy to
 *   intersect two solution sets of dimensions a and b, where a >= b,
 *   in quad double precision.
 *   The systems stored as target and start system in the container
 *   define the witness sets for these two solution sets. */

int extrinsic_top_diagonal_dimension
      ( int n1, int n2, int a, int b, int *d );
/*
 * DESCRIPTION :
 *   Returns in d the dimension of the start and target system to
 *   start the extrinsic cascade to intersect two witness sets,
 *   respectively of dimensions a and b, with ambient dimensions
 *   respectively equal to n1 and n2. */

int hypersurface_witness_set ( int k, int n, char *s );
/*
 * DESCRIPTION :
 *   Computes a witness set for the k-th polynomial in the container.
 *   The witness set will be written on file.
 *
 * REQUIRED : the systems container must contain at least k polynomials.
 *
 * ON ENTRY :
 *   k       the index to a polynomial in the container;
 *   n       number of characters in the string s;
 *   s       name of the output file. */

int standard_witset_of_hypersurface ( int nv, int nc, char *p );
/*
 * DESCRIPTION :
 *   Given in the string p of nc characters a polynomial in nv variables,
 *   terminated by a semicolon, the systems and solutions container in
 *   standard double precision on return contain a witness set for the
 *   hypersurface defined by p.
 *
 * ON ENTRY :
 *   nv      the number of variables of the polynomials;
 *   nc      the number of characters in the string p;
 *   p       string representation of a polynomials, terminates with ';'. */

int dobldobl_witset_of_hypersurface ( int nv, int nc, char *p );
/*
 * DESCRIPTION :
 *   Given in the string p of nc characters a polynomial in nv variables,
 *   terminated by a semicolon, the systems and solutions container in
 *   double double precision on return contain a witness set for the
 *   hypersurface defined by p.
 *
 * ON ENTRY :
 *   nv      the number of variables of the polynomials;
 *   nc      the number of characters in the string p;
 *   p       string representation of a polynomials, terminates with ';'. */

int quaddobl_witset_of_hypersurface ( int nv, int nc, char *p );
/*
 * DESCRIPTION :
 *   Given in the string p of nc characters a polynomial in nv variables,
 *   terminated by a semicolon, the systems and solutions container in
 *   quad double precision on return contain a witness set for the
 *   hypersurface defined by p.
 *
 * ON ENTRY :
 *   nv      the number of variables of the polynomials;
 *   nc      the number of characters in the string p;
 *   p       string representation of a polynomials, terminates with ';'. */

int diagonal_symbols_doubler ( int n, int d, int nc, char *s );
/*
 * DESCRIPTION :
 *   Doubles the number of symbols in the symbol table to enable the
 *   writing of the target system to string properly when starting the
 *   cascade of a diagonal homotopy in extrinsic coordinates.
 *   On input are n, the ambient dimension = #variables before the embedding,
 *   d is the number of slack variables, or the dimension of the first set,
 *   nc contains the number of characters in the string s, 
 *   and in s are the symbols for the first witness set.
 *   This function takes the symbols in s and combines those symbols with
 *   those in the current symbol table for the second witness set stored
 *   in the standard systems container.  On return, the symbol table
 *   contains then all symbols to write the top system in the cascade
 *   to start the diagonal homotopy. */

int standard_collapse_diagonal ( int k, int d );
/*
 * DESCRIPTION :
 *   Eliminates the extrinsic diagonal for the system and solutions
 *   in the containers for standard double precision.
 *
 * ON ENTRY :
 *   k        current number of slack variables in the embedding;
 *   d        number of slack variables to add to the final embedding.
 * 
 * ON RETURN :
 *   The system in the container has its diagonal eliminated and is
 *   embedded with k+d slack variables.  The solutions corresponding
 *   to this system are in the solutions container. */

int dobldobl_collapse_diagonal ( int k, int d );
/*
 * DESCRIPTION :
 *   Eliminates the extrinsic diagonal for the system and solutions
 *   in the containers for double double precision.
 *
 * ON ENTRY :
 *   k        current number of slack variables in the embedding;
 *   d        number of slack variables to add to the final embedding.
 * 
 * ON RETURN :
 *   The system in the container has its diagonal eliminated and is
 *   embedded with k+d slack variables.  The solutions corresponding
 *   to this system are in the solutions container. */

int quaddobl_collapse_diagonal ( int k, int d );
/*
 * DESCRIPTION :
 *   Eliminates the extrinsic diagonal for the system and solutions
 *   in the containers for quad double precision.
 *
 * ON ENTRY :
 *   k        current number of slack variables in the embedding;
 *   d        number of slack variables to add to the final embedding.
 * 
 * ON RETURN :
 *   The system in the container has its diagonal eliminated and is
 *   embedded with k+d slack variables.  The solutions corresponding
 *   to this system are in the solutions container. */

int remove_last_slack ( int k );
/*
 * DESCRIPTION :
 *   Removes the last slack variable from a witness set.
 *   The witness set is stored in system and solution container.
 *
 * ON ENTRY :
 *   k        current number of slack variables in the embedding.
 *
 * ON RETURN :
 *   The system in the container has one slack variable less
 *   and its last equation has been deleted.
 *   Its corresponding solutions in the solution container have
 *   their last component removed. */

/* OPERATIONS needed in the monodromy factorization */

int list2str ( int n, int *d, char *s );
/*
 * DESCRIPTION :
 *   Given in d is an array of n integers,
 *   on return in s is the string representation
 *   of a Python list with the n integers in d.
 *   The function value returned by list2str is
 *   the number of characters written to the string s.
 *
 * REQUIRED :
 *   s has enough space to represent all numbers in d. */

int str2list ( int n, char *s, int *d );
/*
 * DESCRIPTION :
 *   Given in s is a string of n characters,
 *   containing the string representation of a Python list.
 *   On return in d are the numbers in stored in s.
 *   The function value returned by str2list is
 *   the number of integers stored in d. 
 *
 * REQUIRED : 
 *   d has space enough to store all numbers in s. */

int set_state_to_silent ( void );
/*
 * DESCRIPTION :
 *   Sets the state of monodromy permutations in standard double
 *   precision to silent. */

int set_dobldobl_state_to_silent ( void );
/*
 * DESCRIPTION :
 *   Sets the state of monodromy permutations in double double
 *   precision to silent. */

int set_quaddobl_state_to_silent ( void );
/*
 * DESCRIPTION :
 *   Sets the state of monodromy permutations in quad double
 *   precision to silent. */

int set_standard_state_to_verbose ( void );
/*
 * DESCRIPTION :
 *   Sets the state of monodromy permutations in standard double
 *   precision to verbose. */

int set_dobldobl_state_to_verbose ( void );
/*
 * DESCRIPTION :
 *   Sets the state of monodromy permutations in double double
 *   precision to verbose. */

int set_quaddobl_state_to_verbose ( void );
/*
 * DESCRIPTION :
 *   Sets the state of monodromy permutations in quad double
 *   precision to verbose. */

int assign_labels ( int n, int nbsols, int precision );
/* 
 * DESCRIPTION :
 *   Assigns a unique label between 1 and nbsols for each solution in the
 *   solutions container, using the multiplicity field of the solution.
 *   The precision is determined by the value of precision, which is
 *   either 0 for double, 1 for double double, or 2 for quad double. */

int standard_assign_labels ( int n, int nbsols );
/* 
 * DESCRIPTION :
 *   Assigns a unique label between 1 and nbsols to the multiplicity field
 *   for each solution in the standard double solutions container. */

int dobldobl_assign_labels ( int n, int nbsols );
/* 
 * DESCRIPTION :
 *   Assigns a unique label between 1 and nbsols to the multiplicity field
 *   for each solution in the double double solutions container. */

int quaddobl_assign_labels ( int n, int nbsols );
/* 
 * DESCRIPTION :
 *   Assigns a unique label between 1 and nbsols to the multiplicity field
 *   for each solution in the quad double solutions container. */

int initialize_sampler ( int dim );
/*
 * DESCRIPTION :
 *   Initializes the sampling machine with a witness set,
 *   in standard double precision.
 *
 * ON ENTRY :
 *   dim      dimension of the witness set.  */

int initialize_dobldobl_sampler ( int dim );
/*
 * DESCRIPTION :
 *   Initializes the sampling machine with a witness set,
 *   in double double precision.
 *
 * ON ENTRY :
 *   dim      dimension of the witness set.  */

int initialize_quaddobl_sampler ( int dim );
/*
 * DESCRIPTION :
 *   Initializes the sampling machine with a witness set,
 *   in quad double precision.
 *
 * ON ENTRY :
 *   dim      dimension of the witness set.  */

int initialize_monodromy ( int n, int d, int k );
/* 
 * DESCRIPTION :
 *   Initialize the package Standard_Monodromy_Permutations for n loops,
 *   to factor a k-dimensional solution component of degree d.  */

int initialize_dobldobl_monodromy ( int n, int d, int k );
/* 
 * DESCRIPTION :
 *   Initialize the package DoblDobl_Monodromy_Permutations for n loops,
 *   to factor a k-dimensional solution component of degree d.  */

int initialize_quaddobl_monodromy ( int n, int d, int k );
/* 
 * DESCRIPTION :
 *   Initialize the package QuadDobl_Monodromy_Permutations for n loops,
 *   to factor a k-dimensional solution component of degree d.  */

int trace_grid_diagnostics ( double *err, double *dis );
/*
 * DESCRIPTION :
 *   Returns the maximal error on the samples in the trace grid
 *   and the minimal distance between the samples in the trace grid,
 *   computed in standard double precision.
 *
 * REQUIRED :
 *   The operation "store_solutions()" must have been invoked at
 *   least three times before the numbers on return have a meaning. */

int dobldobl_trace_grid_diagnostics ( double *err, double *dis );
/*
 * DESCRIPTION :
 *   Returns the maximal error on the samples in the trace grid
 *   and the minimal distance between the samples in the trace grid,
 *   computed in double double precision.
 *
 * REQUIRED :
 *   The operation "store_dobldobl_solutions()" must have been invoked at
 *   least three times before the numbers on return have a meaning. */

int quaddobl_trace_grid_diagnostics ( double *err, double *dis );
/*
 * DESCRIPTION :
 *   Returns the maximal error on the samples in the trace grid
 *   and the minimal distance between the samples in the trace grid,
 *   computed in quad double precision.
 *
 * REQUIRED :
 *   The operation "store_quaddobl_solutions()" must have been invoked at
 *   least three times before the numbers on return have a meaning. */

void random_complex ( double *re, double *im );
/* 
 * DESCRIPTION :
 *   Generates a random complex number on the unit circle,
 *   with the C standard math library in standard double precision. */

int random_standard_complex ( double *re, double *im );
/* 
 * DESCRIPTION :
 *   Generates a random complex number on the unit circle,
 *   in standard double precision.
 *   On return is the failure code of the call to the Ada code. */

int random_dobldobl_complex ( double *re, double *im );
/* 
 * DESCRIPTION :
 *   Generates a random complex number on the unit circle,
 *   in double double precision.  The parameters re and im
 *   must have been allocated to hold each two doubles.
 *   The two doubles for re and im store the high and low
 *   part of a double double number.
 *   On return is the failure code of the call to the Ada code. */

int random_quaddobl_complex ( double *re, double *im );
/* 
 * DESCRIPTION :
 *   Generates a random complex number on the unit circle,
 *   in quad double precision.  The parameters re and im
 *   must have been allocated to hold each four doubles.
 *   The four doubles for re and im store the parts of a
 *   quad double number, in the order from high to low.
 *   On return is the failure code of the call to the Ada code. */

int store_standard_gamma ( int n, double *re_gamma, double *im_gamma );
/*
 * DESCRIPTION :
 *   Stores n gamma's, in standard double precision,
 *   gamma = re_gamma + im_gamma*I into the sampler.
 *   The parameters re_gamma and im_gamma point to n doubles. */

int store_dobldobl_gamma ( int n, double *re_gamma, double *im_gamma );
/*
 * DESCRIPTION :
 *   Stores n gamma's, in double double precision,
 *   gamma = re_gamma + im_gamma*I into the sampler.
 *   The parameters re_gamma and im_gamma point to 2*n doubles. */

int store_quaddobl_gamma ( int n, double *re_gamma, double *im_gamma );
/*
 * DESCRIPTION :
 *   Stores n gamma's, in double double precision,
 *   gamma = re_gamma + im_gamma*I into the sampler.
 *   The parameters re_gamma and im_gamma point to 4*n doubles. */

int assign_coefficient_of_slice ( int i, int j, double *r );
/*
 * DESCRIPTION :
 *   Assigns r[0] + r[1]*I as j-th coefficient of slice i. */

int assign_dobldobl_coefficient_of_slice ( int i, int j, double *r );
/*
 * DESCRIPTION :
 *   Assigns (r[0], r[1]) + (r[2], r[3])*I as the j-th coefficient
 *   of the i-th slice, where r contains the real and imaginary
 *   parts of a complex number in double double precision. */

int assign_quaddobl_coefficient_of_slice ( int i, int j, double *r );
/*
 * DESCRIPTION :
 *   Assigns (r[0..3] + r[4..7])*I as j-th coefficient
 *   of the i-th slice, where r contains the real and imaginary
 *   parts of a complex number in quad double precision. */

int initialize_hyperplane_sections ( int m );
/*
 * DESCRIPTION :
 *   Initializes the Sampling_Operations to hold m more slices. */

int store_new_hyperplane_sections ( int m, int k, int n, double *c );
/*
 * DESCRIPTION :
 *   Stores the m coefficients of a new set of k hyperplanes in n-space.
 *
 * ON ENTRY :
 *   m         total number of coefficients;
 *   k         dimension of the solution set, number of hyperplanes;
 *   n         ambient dimension;
 *   c         coefficients, real and imaginary parts, of hyperplanes,
 *             of dimension m. */

int retrieve_hyperplane_sections ( int m, int k, int n, int i, double *c );
/*
 * DESCRIPTION :
 *   Retrieves the coefficients of the i-th set of hyperplanes.
 *
 * ON ENTRY :
 *   m         total number of coefficients;
 *   k         dimension of the solution set, number of hyperplanes;
 *   n         ambient dimension;
 *   i         index to the hyperplane sections.
 *
 * ON RETURN :
 *   c         coefficients, real and imaginary parts, of hyperplanes,
 *             of dimension m. */

int set_target_hyperplane_sections ( int i );
/*
 * DESCRIPTION :
 *   The target slices are set to the i-th hyperplane sections,
 *   which must be previously stored in the sampler. */

int new_slices ( int k, int n );
/*
 * DESCRIPTION :
 *   Generates k random hyperplanes in standard double precision
 *   in n-space. */

int new_dobldobl_slices ( int k, int n );
/*
 * DESCRIPTION :
 *   Generates k random hyperplanes in double double precision
 *   in n-space. */

int new_quaddobl_slices ( int k, int n );
/*
 * DESCRIPTION :
 *   Generates k random hyperplanes in quad double precision
 *   in n-space. */

int swap_slices ( void );
/* 
 * DESCRIPTION :
 *   Swaps the current slices with new slices and takes new solutions
 *   as start to turn back, in standard double precision. */

int swap_dobldobl_slices ( void );
/* 
 * DESCRIPTION :
 *   Swaps the current slices with new slices and takes new solutions
 *   as start to turn back, in double double precision. */

int swap_quaddobl_slices ( void );
/* 
 * DESCRIPTION :
 *   Swaps the current slices with new slices and takes new solutions
 *   as start to turn back, in quad double precision. */

int store_solutions ( void );
/* 
 * DESCRIPTION :
 *   Stores the solutions in the container to the data maintained
 *   by the package Standard_Monodromy_Permutations. */

int store_dobldobl_solutions ( void );
/* 
 * DESCRIPTION :
 *   Stores the solutions in the container to the data maintained
 *   by the package DoblDobl_Monodromy_Permutations. */

int store_quaddobl_solutions ( void );
/* 
 * DESCRIPTION :
 *   Stores the solutions in the container to the data maintained
 *   by the package QuadDobl_Monodromy_Permutations. */

int restore_solutions ( void );
/*
 * DESCRIPTION :
 *   Restores first initialized solutions in standard double precision
 *   from sampler to the container. */

int restore_dobldobl_solutions ( void );
/*
 * DESCRIPTION :
 *   Restores first initialized solutions in double double precision
 *   from sampler to the container. */

int restore_quaddobl_solutions ( void );
/*
 * DESCRIPTION :
 *   Restores first initialized solutions in quad double precision
 *   from sampler to the container. */

int retrieve_solutions_on_grid ( int i );
/*
 * DESCRIPTION :
 *   Puts the i-th solution list at the monodromy grid to the container,
 *   for i = 0, 1, and 2, we obtain the solutions at the trace grid. */

int in_slice ( int label, int slice, int *position );
/*
 * DESCRIPTION :
 *   Returns in *position the index of the solution with the given label
 *   for witness set for the given slice number, if such solution exists;
 *   otherwise, *position will be zero on return.
 *   The return value of this function is zero after successful execution,
 *   otherwise an exception has occurred. */

int sample_to_new_slices ( void );
/* 
 * DESCRIPTION :
 *   The sampler computes a new witness set for new slices,
 *   in standard double precision. */

int dobldobl_sample_to_new_slices ( void );
/* 
 * DESCRIPTION :
 *   The sampler computes a new witness set for new slices,
 *   in double double precision. */

int quaddobl_sample_to_new_slices ( void );
/* 
 * DESCRIPTION :
 *   The sampler computes a new witness set for new slices,
 *   in quad double precision. */

int track_paths ( void );
/* 
 * DESCRIPTION :
 *   Tracks as many paths as defined by witness set,
 *   in standard double precision. */

int dobldobl_track_paths ( void );
/* 
 * DESCRIPTION :
 *   Tracks as many paths as defined by witness set,
 *   in double double precision. */

int quaddobl_track_paths ( void );
/* 
 * DESCRIPTION :
 *   Tracks as many paths as defined by witness set,
 *   in quad double precision. */

int sample_loop ( int start_slice, int target_slice,
                  int start_label, int *target_label );
/*
 * DESCRIPTION :
 *   Tracks one path, in standard double precision,
 *   starting at the solution with label start_label,
 *   at hyperplane sections indexed by start_slice,
 *   going to the hyperplane sections index by target_slice. 
 *   On return is in target_label the label of the solution 
 *   on the target slice, matching with the end of the path. */

int dobldobl_sample_loop
 ( int start_slice, int target_slice,
   int start_label, int *target_label );
/*
 * DESCRIPTION :
 *   Tracks one path, in double double precision,
 *   starting at the solution with label start_label,
 *   at hyperplane sections indexed by start_slice,
 *   going to the hyperplane sections index by target_slice. 
 *   On return is in target_label the label of the solution 
 *   on the target slice, matching with the end of the path. */

int quaddobl_sample_loop
 ( int start_slice, int target_slice,
   int start_label, int *target_label );
/*
 * DESCRIPTION :
 *   Tracks one path, in quad double precision,
 *   starting at the solution with label start_label,
 *   at hyperplane sections indexed by start_slice,
 *   going to the hyperplane sections index by target_slice. 
 *   On return is in target_label the label of the solution 
 *   on the target slice, matching with the end of the path. */

int trace_sum_difference ( int n, int *f, double *d );
/*
 * DESCRIPTION :
 *   Returns in d the difference between the actual sum at the samples
 *   defined by the labels to the generic points in f (f is of dimension n),
 *   and the trace sum, in standard double precision. */

int dobldobl_trace_sum_difference ( int n, int *f, double *d );
/*
 * DESCRIPTION :
 *   Returns in d the difference between the actual sum at the samples
 *   defined by the labels to the generic points in f (f is of dimension n),
 *   and the trace sum, in double double precision. */

int quaddobl_trace_sum_difference ( int n, int *f, double *d );
/*
 * DESCRIPTION :
 *   Returns in d the difference between the actual sum at the samples
 *   defined by the labels to the generic points in f (f is of dimension n),
 *   and the trace sum, in quad double precision. */

int number_of_irreducible_factors ( int *nf );
/*
 * DESCRIPTION :
 *   Returns in nf the number of irreducible factors in the standard
 *   double precision decomposition of the witness set. */

int number_of_dobldobl_factors ( int *nf );
/*
 * DESCRIPTION :
 *   Returns in nf the number of irreducible factors in the double
 *   double precision decomposition of the witness set. */

int number_of_quaddobl_factors ( int *nf );
/*
 * DESCRIPTION :
 *   Returns in nf the number of irreducible factors in the quad
 *   double precision decomposition of the witness set. */

int witness_points_of_irreducible_factor ( int k, int *d, int *w );
/*
 * DESCRIPTION :
 *   Given in k an index of an irreducible component,
 *   computed in standard double precision,
 *   returns in d the degree of that component and in w 
 *   d labels of witness points that span the component. */

int witness_points_of_dobldobl_factor ( int k, int *d, int *w );
/*
 * DESCRIPTION :
 *   Given in k an index of an irreducible component,
 *   computed in double double precision,
 *   returns in d the degree of that component and in w 
 *   d labels of witness points that span the component. */

int witness_points_of_quaddobl_factor ( int k, int *d, int *w );
/*
 * DESCRIPTION :
 *   Given in k an index of an irreducible component,
 *   computed in quad double precision,
 *   returns in d the degree of that component and in w 
 *   d labels of witness points that span the component. */

int permutation_after_loop ( int d, int *permutation );
/*
 * DESCRIPTION :
 *   For a set of degree d, computes the permutation using the solutions
 *   most recently stored, after a loop in standard double precision.
 *   The permutation is an array of d integers,
 *   returned in the variable permutation. */

int permutation_after_dobldobl_loop ( int d, int *permutation );
/*
 * DESCRIPTION :
 *   For a set of degree d, computes the permutation using the solutions
 *   most recently stored, after a loop in double double precision.
 *   The permutation is an array of d integers,
 *   returned in the variable permutation. */

int permutation_after_quaddobl_loop ( int d, int *permutation );
/*
 * DESCRIPTION :
 *   For a set of degree d, computes the permutation using the solutions
 *   most recently stored, after a loop in quad double precision.
 *   The permutation is an array of d integers,
 *   returned in the variable permutation. */

int update_decomposition ( int d, int *permutation, int *nf, int *done );
/*
 * DESCRIPTION :
 *   Updates the decomposition with the given permutation of d elements,
 *   computed in standard double precision.
 *   On return in nf are the previous number of factors in nf[0]
 *   and the current number of factors in nf[1].
 *   If the current decomposition is certified, then done == 1 on return,
 *   otherwise done == 0. */

int update_dobldobl_decomposition
 ( int d, int *permutation, int *nf, int *done );
/*
 * DESCRIPTION :
 *   Updates the decomposition with the given permutation of d elements,
 *   computed in double double precision.
 *   On return in nf are the previous number of factors in nf[0]
 *   and the current number of factors in nf[1].
 *   If the current decomposition is certified, then done == 1 on return,
 *   otherwise done == 0. */

int update_quaddobl_decomposition
 ( int d, int *permutation, int *nf, int *done );
/*
 * DESCRIPTION :
 *   Updates the decomposition with the given permutation of d elements,
 *   computed in quad double precision.
 *   On return in nf are the previous number of factors in nf[0]
 *   and the current number of factors in nf[1].
 *   If the current decomposition is certified, then done == 1 on return,
 *   otherwise done == 0. */

int monodromy_permutation ( int d, int *done );
/*
 * DESCRIPTION :
 *   Computes the permutation by last stored solution,
 *   computed in standard double precision, where
 *   d is the number of solutions or the degree of the set,
 *   if *done == 1 on return, then the linear trace test has certified
 *   the current monodromy breakup, otherwise we are not done yet. */

int dobldobl_monodromy_permutation ( int d, int *done );
/*
 * DESCRIPTION :
 *   Computes the permutation by last stored solution,
 *   computed in double double precision, where
 *   d is the number of solutions or the degree of the set,
 *   if *done == 1 on return, then the linear trace test has certified
 *   the current monodromy breakup, otherwise we are not done yet. */

int quaddobl_monodromy_permutation ( int d, int *done );
/*
 * DESCRIPTION :
 *   Computes the permutation by last stored solution,
 *   computed in quad double precision, where
 *   d is the number of solutions or the degree of the set,
 *   if *done == 1 on return, then the linear trace test has certified
 *   the current monodromy breakup, otherwise we are not done yet. */

#endif
