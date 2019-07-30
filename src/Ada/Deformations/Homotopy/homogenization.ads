with Standard_Natural_Numbers;           use Standard_Natural_Numbers;
with Standard_Complex_Polynomials;
with Standard_Complex_Poly_Systems;

package Homogenization is

-- DESCRIPTION :
--   This package provides routines for constructing additional
--   equations to a system for projective transformations.
--   There is also a routine that isolates the homogeneous part
--   of a given polynomial system.

  function Homogeneous_Part
             ( p : Standard_Complex_Polynomials.Poly )
             return Standard_Complex_Polynomials.Poly;
  function Homogeneous_Part
             ( p : Standard_Complex_Poly_Systems.Poly_Sys )
             return Standard_Complex_Poly_Systems.Poly_Sys;

  -- DESCRIPTION :
  --   These functions isolate all terms having a degree equal to
  --   the degree of the polynomial.

  function Add_Equations
             ( s1 : Standard_Complex_Poly_Systems.Poly_Sys;
               s2 : Standard_Complex_Poly_Systems.Poly_Sys )
             return Standard_Complex_Poly_Systems.Poly_Sys;

  -- DESCRIPTION :
  --   The resulting polynomial system is the concatenation of s1 and s2.

  function Add_Equation
             ( s : Standard_Complex_Poly_Systems.Poly_Sys;
               p : Standard_Complex_Polynomials.Poly )
             return Standard_Complex_Poly_Systems.Poly_Sys;

  -- DESCRIPTION :
  --   the resulting polynomial system is the concatenation
  --   of the system s and the polynomial p

  function Add_Random_Hyperplanes
             ( s : Standard_Complex_Poly_Systems.Poly_Sys;
               m : natural32; re : boolean )
             return Standard_Complex_Poly_Systems.Poly_Sys;

  -- DESCRIPTION :
  --   To the polynomial system s, m hyperplanes are added with
  --   randomly choosen coefficients;
  --   if re = true 
  --    then the coefficients will be floating point numbers;
  --    else the coefficients will be complex numbers.

  function Add_Standard_Hyperplanes
             ( s : Standard_Complex_Poly_Systems.Poly_Sys; m : natural32 )
             return Standard_Complex_Poly_Systems.Poly_Sys;

  -- DESCRIPTION :
  --   If n = Number_Of_Unknowns(s(i)), for i in s'range,
  --    then m hyperplanes of the form
  --           x_(j+n) - 1 = 0 will be added, for j in 1..m,
  --         to the system s.

end Homogenization;
