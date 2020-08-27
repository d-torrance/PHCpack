with Standard_Natural_Numbers;           use Standard_Natural_Numbers;
with Standard_Integer_Numbers;           use Standard_Integer_Numbers;
with Standard_Floating_Numbers;          use Standard_Floating_Numbers;

package Octo_Double_Numbers is

-- DESCRIPTION :
--   This package defines octo double numbers and the arithmetic
--   to obtain 8 times the precision of the (standard hardware) doubles.

-- ACKNOWLEDGEMENTS :
--   The code is based on QD-2.3.9 (Y. Hida, X.S. Li, and D.H. Bailey),
--   for the parallels with double double and quad double arithmetic.
--   Definitions are based on the code generated by the CAMPARY library.
--   CAMPARY is the CudA Multiple Precision ARithmetic librarY,
--   by Mioara Joldes, Olivier Marty, Jean-Michel Muller,
--   Valentina Popescu and Warwick Tucker. 

  type octo_double is private;

-- CONSTRUCTORS :

  function create ( i : integer ) return octo_double;

  -- DECRIPTION :
  --   Returns the octo double representation of the standard integer i.

  function create ( n : natural32 ) return octo_double;
  function create ( n : natural64 ) return octo_double;

  -- DESCRIPTION :
  --   Returns the octo double representation of the 32-bit or 64-bit
  --   machine natural number n.

  function create ( i : integer32 ) return octo_double;
  function create ( i : integer64 ) return octo_double;

  -- DESCRIPTION :
  --   Returns the octo double representation of the 32-bit or 64-bit
  --   machine integer number i.

  function create ( x : double_float ) return octo_double;

  -- DESCRIPTION :
  --   The highest word in the octo double on return is x.

  function create ( hihihi,lohihi,hilohi,lolohi : double_float;
                    hihilo,lohilo,hilolo,lololo : double_float )
                  return octo_double;

  -- DESCRIPTION :
  --   Returns an octo double with the doubles in the given order.
  --   The highest, most significant part is given in hihihi.
  --   The lowest, least significant part is given in lololo.

  function "abs" ( x : octo_double ) return octo_double;

  -- DESCRIPTION :
  --   Returns the absolute value of x.

  function AbsVal ( x : octo_double ) return octo_double; -- same as abs

  function floor ( x : octo_double ) return octo_double;

  -- DESCRIPTION :
  --   Returns nearest lower integer to x.

-- SELECTORS :

  function hihihi_part ( x : octo_double ) return double_float;

  -- DESCRIPTION :
  --   Returns the most significant part of x.

  function lohihi_part ( x : octo_double ) return double_float;

  -- DESCRIPTION :
  --   Returns the second most significant part of x.

  function hilohi_part ( x : octo_double ) return double_float;

  -- DESCRIPTION :
  --   Returns the third most significant part of x.

  function lolohi_part ( x : octo_double ) return double_float;

  -- DESCRIPTION :
  --   Returns the fourth most significant part of x.

  function hihilo_part ( x : octo_double ) return double_float;

  -- DESCRIPTION :
  --   Returns the fourth least significant part of x.

  function lohilo_part ( x : octo_double ) return double_float;

  -- DESCRIPTION :
  --   Returns the third least significant part of x.

  function hilolo_part ( x : octo_double ) return double_float;

  -- DESCRIPTION :
  --   Returns the second least significant part of x.

  function lololo_part ( x : octo_double ) return double_float;

  -- DESCRIPTION :
  --   Returns the least significant part of x.

-- TYPE CASTS :

  function to_int ( x : octo_double ) return integer32;

  -- DESCRIPTION :
  --   Converts the highest word into a 32-bit integer;

  function to_double ( x : octo_double ) return double_float;

  -- DESCRIPTION :
  --   Returns hihihi_part(x).

-- COMPARISON and COPYING :

  function is_zero ( x : octo_double ) return boolean;

  -- DESCRIPTION :
  --   Returns true if x is zero, returns false otherwise.

  function is_one ( x : octo_double ) return boolean;

  -- DESCRIPTION :
  --   Returns true if x is one, returns false otherwise.

  function is_positive ( x : octo_double ) return boolean;

  -- DESCRIPTION : 
  --   Returns true if x is positive, returns false otherwise.

  function is_negative ( x : octo_double ) return boolean;

  -- DESCRIPTION : 
  --   Returns true if x is negative, returns false otherwise.

  function equal ( x,y : octo_double ) return boolean;
  function equal ( x : octo_double; y : double_float ) return boolean;

  function "<" ( x,y : octo_double ) return boolean;
  function "<" ( x : octo_double; y : double_float ) return boolean;
  function "<" ( x : double_float; y : octo_double ) return boolean;
  function "<=" ( x,y : octo_double ) return boolean;
  function "<=" ( x : octo_double; y : double_float ) return boolean;
  function "<=" ( x : double_float; y : octo_double ) return boolean;

  function ">" ( x,y : octo_double ) return boolean;
  function ">" ( x : octo_double; y : double_float ) return boolean;
  function ">" ( x : double_float; y : octo_double ) return boolean;
  function ">=" ( x,y : octo_double ) return boolean;
  function ">=" ( x : octo_double; y : double_float ) return boolean;
  function ">=" ( x : double_float; y : octo_double ) return boolean;

  procedure copy ( x : in octo_double; y : in out octo_double );

-- ARITHMETICAL OPERATIONS :

  function "+" ( x,y : octo_double ) return octo_double;   -- returns x+y
  function "+" ( x : octo_double; y : double_float ) return octo_double;
  function "+" ( x : double_float; y : octo_double ) return octo_double;
  function "+" ( x : octo_double ) return octo_double;     -- returns copy

  function "-" ( x : octo_double ) return octo_double;     -- returns -x
  function "-" ( x,y : octo_double ) return octo_double;   -- returns x-y
  function "-" ( x : octo_double; y : double_float ) return octo_double;

  function "*" ( x,y : octo_double ) return octo_double;   -- returns x*y
  function "*" ( x : octo_double; y : double_float ) return octo_double;
  function "*" ( x : double_float; y : octo_double ) return octo_double;

  function Mul_pwr2 ( x : octo_double; y : double_float ) -- y = 2^k
                    return octo_double;
  procedure Mul_pwr2 ( x : in out octo_double; y : in double_float );
  -- multiplies x with y, where y is a power of 2

  function "/" ( x,y : octo_double ) return octo_double;   -- returns x/y
  function "/" ( x : octo_double; y : double_float ) return octo_double;
  function "/" ( x : double_float; y : octo_double ) return octo_double;

  function "**" ( x : octo_double; n : integer ) return octo_double; -- x^n

  function ldexp ( x : octo_double; n : integer ) return octo_double;
  -- returns (2^n)*x

  function exp ( x : octo_double ) return octo_double;   -- returns exp(x)
  function log ( x : octo_double ) return octo_double;   -- natural log
  function log10 ( x : octo_double ) return octo_double; -- decimal log

-- ARITHMETICAL OPERATIONS AS PROCEDURES :

  procedure Add ( x : in out octo_double; y : in octo_double ); -- x := x+y
  procedure Sub ( x : in out octo_double; y : in octo_double ); -- x := x-y
  procedure Min ( x : in out octo_double );                     -- x:= -x
  procedure Mul ( x : in out octo_double; y : in octo_double ); -- x := x*y
  procedure Div ( x : in out octo_double; y : in octo_double ); -- x := x/y

-- DESTRUCTOR :

  procedure clear ( x : in out octo_double ); -- sets x to zero

private

-- DATA STRUCTURE :
--   An octo double could be viewed as a double quad double number,
--   or a quad double double number.  The naming of the parts of an
--   octo double is consistent with replacing the four doubles of a
--   quad double (called hihi, lohi, hilo, and lolo) by double doubles,
--   each with a high and low part.  The high and low part are used to
--   prefix the new names, so the lohi has parts hilohi and lolohi.
--   The first four highest parts all have hi as suffix,
--   the first four lowest parts all have lo as suffix.
--   The eight parts of an octo double are eight doubles in a record.
--   In a corresponding array data type they would be named 
--   x0, x1, x2, x3, x4, x5, x6, x7 in order of significance.

  type octo_double is record
    hihihi : double_float; -- highest word, most significant part
    lohihi : double_float; -- second highest word
    hilohi : double_float; -- third highest word
    lolohi : double_float; -- fourth highest word
    hihilo : double_float; -- fourth lowest word
    lohilo : double_float; -- third lowest word
    hilolo : double_float; -- second lowest word
    lololo : double_float; -- lowest word, least significant part
  end record;

end Octo_Double_Numbers;