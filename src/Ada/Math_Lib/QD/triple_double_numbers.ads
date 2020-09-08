with Standard_Natural_Numbers;           use Standard_Natural_Numbers;
with Standard_Integer_Numbers;           use Standard_Integer_Numbers;
with Standard_Floating_Numbers;          use Standard_Floating_Numbers;

package Triple_Double_Numbers is

-- DESCRIPTION :
--   This package defines triple double numbers and the arithmetic
--   to triple the precision of the (standard hardware) doubles.

-- ACKNOWLEDGEMENTS :
--   The code is based on QD-2.3.9 (Y. Hida, X.S. Li, and D.H. Bailey),
--   as triple doubles are the middle between double double
--   and quad double arithmetic.  The arithmetical functions are
--   translations of the code generated by the CAMPARY library.
--   CAMPARY is the CudA Multiple Precision ARithmetic librarY,
--   by Mioara Joldes, Olivier Marty, Jean-Michel Muller,
--   Valentina Popescu and Warwick Tucker. 

  type triple_double is private;

-- CONSTRUCTORS :

  function create ( i : integer ) return triple_double;

  -- DECRIPTION :
  --   Returns the triple double representation of the standard integer i.

  function create ( n : natural32 ) return triple_double;
  function create ( n : natural64 ) return triple_double;

  -- DESCRIPTION :
  --   Returns the triple double representation of the 32-bit or 64-bit
  --   machine natural number n.

  function create ( i : integer32 ) return triple_double;
  function create ( i : integer64 ) return triple_double;

  -- DESCRIPTION :
  --   Returns the triple double representation of the 32-bit or 64-bit
  --   machine integer number i.

  function create ( x : double_float ) return triple_double;

  -- DESCRIPTION :
  --   The highest word in the triple double on return is x.

  function create ( hi,mi,lo : double_float ) return triple_double;

  -- DESCRIPTION :
  --   Returns a triple double with highest part equal to hi,
  --   middle part equal to mi, and lowest part equal to lo.

  function "abs" ( x : triple_double ) return triple_double;

  -- DESCRIPTION :
  --   Returns the absolute value of x.

  function AbsVal ( x : triple_double ) return triple_double; -- same as abs

  function floor ( x : triple_double ) return triple_double;

  -- DESCRIPTION :
  --   Returns nearest lower integer to x.

-- SELECTORS :

  function hi_part ( x : triple_double ) return double_float;

  -- DESCRIPTION :
  --   Returns the highest word, the most significant part of x.

  function mi_part ( x : triple_double ) return double_float;

  -- DESCRIPTION :
  --   Returns the middle word, the second most significant part of x.

  function lo_part ( x : triple_double ) return double_float;

  -- DESCRIPTION :
  --   Returns the lowest word, the least significant part of x.

-- TYPE CASTS :

  function to_int ( x : triple_double ) return integer32;

  -- DESCRIPTION :
  --   Converts the highest word into a 32-bit integer;

  function to_double ( x : triple_double ) return double_float;

  -- DESCRIPTION :
  --   Returns hi_part(x).

-- COMPARISON and COPYING :

  function is_zero ( x : triple_double ) return boolean;

  -- DESCRIPTION :
  --   Returns true if x is zero, returns false otherwise.

  function is_one ( x : triple_double ) return boolean;

  -- DESCRIPTION :
  --   Returns true if x is one, returns false otherwise.

  function is_positive ( x : triple_double ) return boolean;

  -- DESCRIPTION : 
  --   Returns true if q is positive, returns false otherwise.

  function is_negative ( x : triple_double ) return boolean;

  -- DESCRIPTION : 
  --   Returns true if x is negative, returns false otherwise.

  function equal ( x,y : triple_double ) return boolean;
  function equal ( x : triple_double; y : double_float ) return boolean;

  function "<" ( x,y : triple_double ) return boolean;
  function "<" ( x : triple_double; y : double_float ) return boolean;
  function "<" ( x : double_float; y : triple_double ) return boolean;
  function "<=" ( x,y : triple_double ) return boolean;
  function "<=" ( x : triple_double; y : double_float ) return boolean;
  function "<=" ( x : double_float; y : triple_double ) return boolean;

  function ">" ( x,y : triple_double ) return boolean;
  function ">" ( x : triple_double; y : double_float ) return boolean;
  function ">" ( x : double_float; y : triple_double ) return boolean;
  function ">=" ( x,y : triple_double ) return boolean;
  function ">=" ( x : triple_double; y : double_float ) return boolean;
  function ">=" ( x : double_float; y : triple_double ) return boolean;

  procedure copy ( x : in triple_double; y : in out triple_double );

-- ARITHMETICAL OPERATIONS :

  function "+" ( x,y : triple_double ) return triple_double; -- returns x+y
  function "+" ( x : triple_double; y : double_float ) return triple_double;
  function "+" ( x : double_float; y : triple_double ) return triple_double;
  function "+" ( x : triple_double ) return triple_double; -- returns copy

  function "-" ( x : triple_double ) return triple_double; -- returns -x

  function "-" ( x,y : triple_double ) return triple_double; -- returns x-y
  function "-" ( x : triple_double; y : double_float ) return triple_double;
  function "-" ( x : double_float; y : triple_double ) return triple_double;

  function "*" ( x,y : triple_double ) return triple_double; -- returns x*y
  function "*" ( x : triple_double; y : double_float ) return triple_double;
  function "*" ( x : double_float; y : triple_double ) return triple_double;

  function Mul_pwr2 ( x : triple_double; y : double_float ) -- y = 2^k
                    return triple_double;
  procedure Mul_pwr2 ( x : in out triple_double; y : in double_float );
  -- multiplies x with y, where y is a power of 2

  function "/" ( x,y : triple_double ) return triple_double; -- returns x/y
  function "/" ( x : double_float; y : triple_double ) return triple_double;
  function "/" ( x : triple_double; y : double_float ) return triple_double;

  function sqr ( x : triple_double ) return triple_double;   -- returns x*x
  function "**" ( x : triple_double; n : integer ) return triple_double; -- x^n

  function ldexp ( x : triple_double; n : integer ) return triple_double;
  -- returns (2^n)*x
  function "**" ( x,y : triple_double ) return triple_double; -- x^y
  function "**" ( x : triple_double; y : double_float ) return triple_double;

  function exp ( x : triple_double ) return triple_double;   -- returns exp(x)
  function log ( x : triple_double ) return triple_double;   -- natural log
  function log10 ( x : triple_double ) return triple_double; -- decimal log

-- ARITHMETICAL OPERATIONS AS PROCEDURES :

  procedure Add ( x : in out triple_double; y : in triple_double ); -- x := x+y
  procedure Sub ( x : in out triple_double; y : in triple_double ); -- x := x-y
  procedure Min ( x : in out triple_double );                       -- x:= -x
  procedure Mul ( x : in out triple_double; y : in triple_double ); -- x := x*y
  procedure Div ( x : in out triple_double; y : in triple_double ); -- x := x/y

-- DESTRUCTOR :

  procedure clear ( x : in out triple_double ); -- sets x to zero

private

  type triple_double is record
    hi : double_float; -- highest word, most significant part
    mi : double_float; -- middle word, second most significant part
    lo : double_float; -- lowest word, least significant part
  end record;

end Triple_Double_Numbers;
