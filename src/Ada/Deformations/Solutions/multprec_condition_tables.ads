with text_io;                            use text_io;
with Standard_Natural_Numbers;           use Standard_Natural_Numbers;
with Multprec_Floating_Numbers;          use Multprec_Floating_Numbers;
with Standard_Natural_Vectors;           use Standard_Natural_Vectors;
with Multprec_Complex_Solutions;         use Multprec_Complex_Solutions;

package Multprec_Condition_Tables is

-- DESCRIPTION :
--   A "condition table" is a frequency table with the logarithms of 
--   either 1) the inverse of the corrector magnitude from Newton;
--       or 2) the estimated condition numbers
--       or 3) the inverse of the magnitude of the residual vector;
--   for a list of solutions.

  function Create ( n : natural32 ) return Vector;

  -- DESCRIPTION :
  --   Returns a frequency table as vector of range 0..n.
  --   When updated with condition numbers, we have
  --     t(0) : counts #solutions with -log(rcond) < 1
  --     t(1) : counts #solutions with 1 <= -log(rcond) < 2
  --     t(2) : counts #solutions with 2 <= -log(rcond) < 3
  --     t(k) : counts #solutions with k <= -log(rcond) < k+1
  --     t(n) : counts #solutions with n <= -log(rcond). 
  --   The same legend hold when rcond is replace by the
  --   distance of one solution to all other solutions in the list.
  --   When updated with residuals, we have
  --     t(0) : counts #solutions with log(res) >= 0 or log
  --     t(1) : counts #solutions with 1 < -log(res) <= 2
  --     t(2) : counts #solutions with 2 < -log(res) <= 3
  --     t(k) : counts #solutions with k < -log(res) <= k+1
  --     t(n) : counts #solutions with n < -log(res) 
  --   For corrector terms we following the same as for residuals.
  --   The vector on return is initialized to zero.

  procedure Update_Corrector ( t : in out Vector; e : in Floating_Number );
  procedure Update_Corrector ( t : in out Vector; s : in Solution );
  procedure Update_Condition ( t : in out Vector; c : in Floating_Number );
  procedure Update_Condition ( t : in out Vector; s : in Solution );
  procedure Update_Distance  ( t : in out Vector; d : in Floating_Number );
  procedure Update_Residuals ( t : in out Vector; r : in Floating_Number );
  procedure Update_Residuals ( t : in out Vector; s : in Solution );

  -- DESCRIPTION :
  --   Updates the frequency table t respectively with s.err,
  --   s.rco, the distance d, or with s.res.

  procedure Corrector_Table ( t : in out Vector; s : in Solution_List );
  procedure Condition_Table ( t : in out Vector; s : in Solution_List );
  procedure Distances_Table ( t : in out Vector; s : in Solution_List );
  procedure Residuals_Table ( t : in out Vector; s : in Solution_List );

  -- DESCRIPTION :
  --   Updates the frequency table with all solutions in the list.

  procedure Write_Corrector_Table ( file : in file_type; t : in Vector );
  procedure Write_Condition_Table ( file : in file_type; t : in Vector );
  procedure Write_Distances_Table ( file : in file_type; t : in Vector );
  procedure Write_Residuals_Table ( file : in file_type; t : in Vector );

  -- DESCRIPTION :
  --   Writes the frequency table with the logarithms of
  --   condition numbers on file.

  procedure Write_Tables ( file : in file_type;
                           t_e,t_r,t_c : in Vector );
  procedure Write_Tables ( file : in file_type;
                           t_e,t_r,t_c,t_d : in Vector );

  -- DESCRIPTION :
  --   Writes all four tables in one report.

  -- ON ENTRY :
  --   file       output file;
  --   t_e        frequency table with error correction terms;
  --   t_r        frequency table with residuals;
  --   t_c        frequency table with condition numbers;
  --   t_d        frequency table with distances.

end Multprec_Condition_Tables;
