with Standard_Integer_Numbers;          use Standard_Integer_Numbers;
with Standard_Floating_Numbers;         use Standard_Floating_Numbers;
with Standard_Complex_Numbers;          use Standard_Complex_Numbers;
with Standard_Integer_Vectors;
with Standard_Complex_Vectors;
with Standard_Complex_VecVecs;
with Standard_Complex_Matrices;

package Standard_Rational_Approximations is

-- DESCRIPTION :
--   Given a power series, computes a rational approximation for
--   the function represented by the series.

  procedure Denominator_System
              ( numdeg,dendeg : in integer32; 
                cff : in Standard_Complex_Vectors.Vector;
                mat : out Standard_Complex_Matrices.Matrix;
                rhs : out Standard_Complex_Vectors.Vector );

  -- DESCRIPTION :
  --   Defines the coefficient matrix and the right hand side vector
  --   for the denominator of a rational approximation.

  -- ON ENTRY :
  --   numdeg   degree of the numerator;
  --   dendeg   degree of the denominator;
  --   cff      coefficients of the series, of range 0..numdeg+dendeg.

  -- ON RETURN :
  --   mat      square coefficient matrix of range 1..dendeg.
  --   rhs      right hand side vector of range 1..dendeg.

  function Numerator_Coefficients
              ( numdeg,dendeg : integer32;
                dencff,sercff : Standard_Complex_Vectors.Vector )
              return Standard_Complex_Vectors.Vector;

  -- DESCRIPTION :
  --   Returns the coefficients of the numerator in the rational
  --   approximation as a vector of range 0..numdeg.

  -- ON ENTRY :
  --   numdeg   degree of the numerator;
  --   dendeg   degree of the denominator;
  --   dencff   coefficients of the denominator;
  --   sercff   coefficients of the power series.

  procedure Assign_Numerator_Coefficients
              ( numdeg,dendeg : in integer32;
                dencff,sercff : in Standard_Complex_Vectors.Vector;
                cff : out Standard_Complex_Vectors.Vector );

  -- DESCRIPTION :
  --   Assigns the coefficients of the numerator in the rational approximation.

  -- ON ENTRY :
  --   numdeg   degree of the numerator;
  --   dendeg   degree of the denominator;
  --   dencff   coefficients of the denominator;
  --   sercff   coefficients of the power series.

  -- ON RETURN :
  --   cff      vector of range 0..numdeg with the coefficients of
  --            the numerator in the rational approximation.

  procedure Pade
              ( numdeg,dendeg : in integer32;
                cff : in Standard_Complex_Vectors.Vector;
                numcff,dencff : out Standard_Complex_Vectors.Vector;
                mat : in out Standard_Complex_Matrices.Matrix;
                rhs : in out Standard_Complex_Vectors.Vector;
                ipvt : in out Standard_Integer_Vectors.Vector;
                info : out integer32; verbose : in boolean := false );
  procedure Pade
              ( numdeg,dendeg : in integer32;
                cff : in Standard_Complex_Vectors.Vector;
                numcff,dencff : out Standard_Complex_Vectors.Vector;
                info : out integer32; verbose : in boolean := false );

  -- DESCRIPTION :
  --   Constructs a Pade approximant in standard floating point arithmetic
  --   for a series with coefficients given in cff.
  --   The simplest textbook definition is applied in the computation.

  -- ON ENTRY :
  --   numdeg   degree of the numerator;
  --   dendeg   degree of the denominator;
  --   cff      coefficients of the power series.
  --   mat      square matrix of dimension dendeg, used as work space;
  --   rhs      right hand side vector, of dimension dendeg;
  --   ipvt     pivoting information vector of the LU factorization;
  --   verbose  if verbose, then the matrices are written to screen.

  -- ON RETURN :
  --   numcff   coefficients of the numerator, if info is nonzero;
  --   dencff   coefficients of the denominator, if info is nonzero;
  --   info     if zero, then the partial pivoting in the LU factorization
  --            worked, otherwise, info indicates a zero column.

  -- REQUIRED : cff'range = 0..numdeg+dendeg.

  procedure Pade_Vector
              ( numdeg,dendeg : in integer32;
                cff : in Standard_Complex_VecVecs.VecVec;
                numcff,dencff : in Standard_Complex_VecVecs.VecVec;
                mat : in out Standard_Complex_Matrices.Matrix;
                rhs : in out Standard_Complex_Vectors.Vector;
                ipvt : in out Standard_Integer_Vectors.Vector;
                info : out integer32; verbose : in boolean := false );

  -- DESCRIPTION :
  --   Computes the coefficients of a vector of rational approximations,
  --   for a given vector of coefficient vectors of power series.

  -- ON ENTRY :
  --   numdeg   degree of the numerator;
  --   dendeg   degree of the denominator;
  --   cff      coefficients of the power series.
  --   numcff   memory allocated for the coefficients of the numerators;
  --   dencff   memory allocated for the coefficients of the denominators;
  --   mat      square matrix of dimension dendeg, used as work space;
  --   rhs      right hand side vector, of dimension dendeg;
  --   ipvt     pivoting information vector of the LU factorization;
  --   verbose  if verbose, then the matrices are written to screen.

  -- ON RETURN :
  --   numcff   coefficients of the numerators, if info is nonzero;
  --   dencff   coefficients of the denominators, if info is nonzero;
  --   info     if zero, then the partial pivoting in the LU factorization
  --            worked, otherwise, info indicates a zero column.

  -- REQUIRED : cff(i)'range = 0..numdeg+dendeg, for i in cff'range.

  function Evaluate
              ( p : Standard_Complex_Vectors.Vector;
                x : Complex_Number ) return Complex_Number;

  -- DESCRIPTION :
  --   Evaluates the polynomial with coefficients in p at x.

  function Evaluate
              ( num,den : Standard_Complex_Vectors.Vector;
                x : double_float ) return Complex_Number;
  function Evaluate
              ( num,den : Standard_Complex_Vectors.Vector;
                x : Complex_Number ) return Complex_Number;

  -- DESCRIPTION :
  --   Given the coefficients of the numerator in num
  --   and the coefficients of the denominator in den,
  --   return the value of the rational approximation at x.

  procedure Evaluate
              ( num,den : in Standard_Complex_VecVecs.VecVec;
                x : in double_float;
                eva : out Standard_Complex_Vectors.Vector );
  procedure Evaluate
              ( num,den : in Standard_Complex_VecVecs.VecVec;
                x : in Complex_Number;
                eva : out Standard_Complex_Vectors.Vector );

  -- DESCRIPTION :
  --   Evaluates the numerator and denominator polynomial defined
  --   by the coefficients in num and den at x.
  --   The result of the evalution is in the vector eva.

  -- REQUIRED : num'range = den'range = eva'range.

end Standard_Rational_Approximations;
