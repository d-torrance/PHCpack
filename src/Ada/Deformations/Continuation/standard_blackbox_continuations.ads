with text_io;                            use text_io;
with Standard_Integer_Numbers;           use Standard_Integer_Numbers;
with Standard_Complex_Numbers;           use Standard_Complex_Numbers;
with Standard_Complex_Poly_Systems;      use Standard_Complex_Poly_Systems;
with Standard_Complex_Laur_Systems;      use Standard_Complex_Laur_Systems;
with Standard_Complex_Solutions;         use Standard_Complex_Solutions;

package Standard_BlackBox_Continuations is

-- DESCRIPTION :
--   This package provides two procedure for performing polynomial
--   continuation in blackbox mode.  They mainly differ by the fact
--   that the homotopy might be already provided in the input parameter.
--   Calculations are performed in standard hardware double arithmetic.

-- ALL INPUT IS SCANNED FROM FILES :

  procedure Black_Box_Polynomial_Continuation
               ( infile,outfile : in file_type; 
                 deflate : in boolean; pocotime : out duration;
                 verbose : in integer32 := 0 );
  procedure Black_Box_Polynomial_Continuation
               ( targetfile,startfile,outfile : in file_type;
                 deflate : in boolean; pocotime : out duration;
                 verbose : in integer32 := 0 );

  -- DESCRIPTION :
  --   Scans the targetfile for the target system,
  --   scans the startfile for start system and start solutions,
  --   and then does the path tracking, writing results to outfile.
  --   If deflate is false, then deflation will not be applied.
  --   The verbose is the verbose level value.

-- STABLE POLYOMIAL CONTINUATION :

  procedure Black_Box_Stable_Poly_Continuation
               ( deflate : in boolean;
                 p,q : in Poly_Sys; gamma : in Complex_Number;
                 sols : in out Solution_List;
                 pocotime : out duration; verbose : in integer32 := 0 );
  procedure Black_Box_Stable_Poly_Continuation
               ( file : file_type; deflate : in boolean;
                 p,q : in Poly_Sys; gamma : in Complex_Number;
                 sols : in out Solution_List;
                 pocotime : out duration; verbose : in integer32 := 0 );

  -- DESCRIPTION :
  --   Given a solution list where all solutions have at least one
  --   zero components, first these zero components will be removed
  --   before applying homotopy continuation with the default settings.

  -- ON ENTRY :
  --   file      to write intermediate output and diagnostics;
  --   deflate   if not deflate, then no deflation will be applied;
  --   p         target system;
  --   q         start system;
  --   gamma     a random constant;
  --   sols      solutions of the start system q,
  --             every solution has at least one zero component;
  --   verbose   the verbose level.

  -- ON RETURN :
  --   sols      solutions at the end of the paths;
  --   pocotime  user cpu time for the polynomial continuation.

-- GENERAL POLYNOMIAL CONTINUATION :

  procedure Black_Box_Polynomial_Continuation
               ( deflate : in boolean;
                 p,q : in Poly_Sys; sols : in out Solution_List;
                 pocotime : out duration; verbose : in integer32 := 0 );
  procedure Black_Box_Polynomial_Continuation
               ( deflate : in boolean; nt : in integer32;
                 p,q : in Poly_Sys; sols : in out Solution_List;
                 pocotime : out duration; verbose : in integer32 := 0 );
  procedure Black_Box_Polynomial_Continuation
               ( file : in file_type; deflate : in boolean;
                 p,q : in Poly_Sys; sols : in out Solution_List;
                 pocotime : out duration; verbose : in integer32 := 0 );
  procedure Black_Box_Polynomial_Continuation
               ( file : in file_type; deflate : in boolean;
                 nt : in integer32;
                 p,q : in Poly_Sys; sols : in out Solution_List;
                 pocotime : out duration; verbose : in integer32 := 0 );
  procedure Black_Box_Polynomial_Continuation
               ( deflate : in boolean;
                 p,q : in Poly_Sys; gamma : in Complex_Number;
                 sols : in out Solution_List;
                 pocotime : out duration; verbose : in integer32 := 0 );
  procedure Black_Box_Polynomial_Continuation
               ( deflate : in boolean; nt : in integer32;
                 p,q : in Poly_Sys; gamma : in Complex_Number;
                 sols : in out Solution_List;
                 pocotime : out duration; verbose : in integer32 := 0 );
  procedure Black_Box_Polynomial_Continuation
               ( file : in file_type; deflate : in boolean;
                 p,q : in Poly_Sys; gamma : in Complex_Number;
                 sols : in out Solution_List;
                 pocotime : out duration; verbose : in integer32 := 0 );
  procedure Black_Box_Polynomial_Continuation
               ( file : in file_type; deflate : in boolean;
                 nt : in integer32;
                 p,q : in Poly_Sys; gamma : in Complex_Number;
                 sols : in out Solution_List;
                 pocotime : out duration; verbose : in integer32 := 0 );

  -- DESCRIPTION :
  --   Performs polynomial continuation with default settings
  --   to compute general solutions, starting from solutions
  --   where all components are different from zero.

  -- REQUIRED :  file must be opened for output.

  -- ON ENTRY :
  --   file      file to write the results on;
  --   deflate   if not deflate, then no deflation will be applied;
  --   nt        number of tasks, must be larger than zero to have effect;
  --   p         target polynomial system;
  --   q         a start system for solving p;
  --   gamma     constant to multiply q with in the homotopy,
  --             if not provided, a will be generated;
  --   sols      solutions of q, without zero components;
  --   verbose   the verbose level.

  -- ON RETURN :
  --   sols      solutions of p, obtained from sols;
  --   pocotime  elapsed user cpu time for polyhedral continuation.

-- GENERAL AND STABLE CONTINUATION :

  procedure Black_Box_Polynomial_Continuation
               ( deflate : in boolean;
                 p,q : in Poly_Sys; sols,sols0 : in out Solution_List;
                 pocotime : out duration; verbose : in integer32 := 0 );
  procedure Black_Box_Polynomial_Continuation
               ( deflate : in boolean; nt : in integer32;
                 p,q : in Poly_Sys; sols,sols0 : in out Solution_List;
                 pocotime : out duration; verbose : in integer32 := 0 );
  procedure Black_Box_Polynomial_Continuation
               ( file : in file_type; deflate : in boolean;
                 p,q : in Poly_Sys; sols,sols0 : in out Solution_List;
                 pocotime : out duration; verbose : in integer32 := 0 );
  procedure Black_Box_Polynomial_Continuation
               ( file : in file_type; deflate : in boolean;
                 nt : in integer32;
                 p,q : in Poly_Sys; sols,sols0 : in out Solution_List;
                 pocotime : out duration; verbose : in integer32 := 0 );
  procedure Black_Box_Polynomial_Continuation
               ( deflate : in boolean;
                 p,q : in Poly_Sys; gamma : in Complex_Number;
                 sols,sols0 : in out Solution_List;
                 pocotime : out duration; verbose : in integer32 := 0 );
  procedure Black_Box_Polynomial_Continuation
               ( deflate : in boolean; nt : in integer32;
                 p,q : in Poly_Sys; gamma : in Complex_Number;
                 sols,sols0 : in out Solution_List;
                 pocotime : out duration; verbose : in integer32 := 0 );
  procedure Black_Box_Polynomial_Continuation
               ( file : in file_type; deflate : in boolean;
                 p,q : in Poly_Sys; gamma : in Complex_Number;
                 sols,sols0 : in out Solution_List;
                 pocotime : out duration; verbose : in integer32 := 0 );
  procedure Black_Box_Polynomial_Continuation
               ( file : in file_type; deflate : in boolean;
                 nt : in integer32;
                 p,q : in Poly_Sys; gamma : in Complex_Number;
                 sols,sols0 : in out Solution_List;
                 pocotime : out duration; verbose : in integer32 := 0 );

  -- DESCRIPTION :
  --   Performs polynomial continuation with default settings,
  --   for both general solutions and solutions with zero components.

  -- REQUIRED : file must be opened for output.

  -- ON ENTRY :
  --   file      file to write the results on;
  --   deflate   if not deflate, then deflation will not be applied;
  --   nt        number of tasks, must be larger than zero to have effect;
  --   p         target polynomial system;
  --   q         a start system for solving p;
  --   gamma     constant to multiply q with in the homotopy,
  --             if not provided, a will be generated;
  --   sols      solutions of q, without zero components;
  --   sols0     solutions of q with zero components;
  --   verbose   the verbose level.

  -- ON RETURN :
  --   sols      solutions of p, obtained from sols;
  --   sols0     solutions with zero components;
  --   pocotime  elapsed user cpu time for polyhedral continuation.

-- CONTINUATION for Laurent systems :

  procedure Black_Box_Polynomial_Continuation
               ( p,q : in Laur_Sys; gamma : in Complex_Number;
                 sols : in out Solution_List;
                 pocotime : out duration; verbose : in integer32 := 0 );
  procedure Black_Box_Polynomial_Continuation
               ( p,q : in Laur_Sys; sols : in out Solution_List;
                 pocotime : out duration; verbose : in integer32 := 0 );
  procedure Black_Box_Polynomial_Continuation
               ( nt : in integer32;
                 p,q : in Laur_Sys; gamma : in Complex_Number;
                 sols : in out Solution_List;
                 pocotime : out duration; verbose : in integer32 := 0 );
  procedure Black_Box_Polynomial_Continuation
               ( nt : in integer32;
                 p,q : in Laur_Sys; sols : in out Solution_List;
                 pocotime : out duration; verbose : in integer32 := 0 );
  procedure Black_Box_Polynomial_Continuation
               ( file : in file_type;
                 p,q : in Laur_Sys; gamma : in Complex_Number;
                 sols : in out Solution_List;
                 pocotime : out duration; verbose : in integer32 := 0 );
  procedure Black_Box_Polynomial_Continuation
               ( file : in file_type; 
                 p,q : in Laur_Sys; sols : in out Solution_List;
                 pocotime : out duration; verbose : in integer32 := 0 );
  procedure Black_Box_Polynomial_Continuation
               ( file : in file_type; nt : in integer32;
                 p,q : in Laur_Sys; gamma : in Complex_Number;
                 sols : in out Solution_List;
                 pocotime : out duration; verbose : in integer32 := 0 );
  procedure Black_Box_Polynomial_Continuation
               ( file : in file_type; nt : in integer32;
                 p,q : in Laur_Sys; sols : in out Solution_List;
                 pocotime : out duration; verbose : in integer32 := 0 );

  -- DESCRIPTION :
  --   Performs polynomial continuation with default settings, for
  --   Laurent systems, so solutions with zero components are omitted.

  -- REQUIRED : file must be opened for output.

  -- ON ENTRY :
  --   file      file to write the results on;
  --   nt        number of tasks, must be larger than zero to have effect;
  --   p         target polynomial system;
  --   q         a start system for solving p;
  --   gamma     optional complex gamma constant;
  --   sols      solutions of q, without zero components;
  --   verbose   the verbose level.

  -- ON RETURN :
  --   sols      solutions of p, obtained from sols;
  --   pocotime  elapsed user cpu time for polyhedral continuation.

  procedure Main ( targetname,startname,outfilename : in string;
                   verbose : in integer32 := 0 );

  -- DESCRIPTION :
  --   Defines phc -b -p to track paths in double precision.
  --   If the names of the file do not lead to the proper data,
  --   then the user is prompted to provide file names.

  -- ON INPUT :
  --   targetname      name of the file where the target system is;
  --   startname       name of the file where the start system is;
  --   outfilename     name of the output file;
  --   verbose         the verbose level.

end Standard_BlackBox_Continuations;
