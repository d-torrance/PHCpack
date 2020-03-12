with Standard_Integer_Numbers;           use Standard_Integer_Numbers;
with Standard_Floating_Numbers;          use Standard_Floating_Numbers;
with Standard_Complex_Numbers;           use Standard_Complex_Numbers;
with Standard_Integer_Vectors;
with Standard_Complex_Vectors;
with Standard_Complex_VecVecs;
with Standard_Complex_Matrices;          use Standard_Complex_Matrices;
with Standard_Speelpenning_Convolutions; use Standard_Speelpenning_Convolutions;

package Standard_Predictor_Convolutions is

-- DESCRIPTION :
--   Exports data structures and procedures to construct a rational prediction
--   for the next solution on a path defined by a polynomial homotopy,
--   represented by convolution circuits, in double precision.

-- DATA STRUCTURE :
--   The predictor type stores a solution in a vector of dimension dim,
--   of power series of degree deg, for a rational approximation of degrees
--   numdeg and dendeg, respectively of numerator and denominator.
--   The work space for the pivoting information of the linear system
--   solving of the series computation and the rational approximation.
--   The work space (wrk below) for Newton's method on power series
--   has a dimension equal to the number of equations in the homotopy.

-- REQUIRED : deg >= numdeg + dendeg + 2.

  type LU_Predictor ( dim,deg,numdeg,dendeg : integer32 ) is record
    sol : Standard_Complex_VecVecs.VecVec(1..dim);        -- degree deg series
    wrk : Standard_Complex_Vectors.Link_to_Vector;        -- Newton work space
    numcff : Standard_Complex_VecVecs.VecVec(1..dim);     -- numerator coeffs
    dencff : Standard_Complex_VecVecs.VecVec(1..dim);     -- denominator coeffs
    newtpiv : Standard_Integer_Vectors.Vector(1..dim);    -- pivots for Newton
    padepiv : Standard_Integer_Vectors.Vector(1..dendeg); -- pivots for Pade
    mat : Matrix(1..dendeg,1..dendeg); -- matrix for the rational approximation
    rhs : Standard_Complex_Vectors.Vector(1..dendeg); -- right hand side
  end record;
  type Link_to_LU_Predictor is access LU_Predictor;

-- DATA STRUCTURE FOR SVD :
--   The predictor with the Singular Value Decomposition works for systems
--   that are overdetermined, with more equations than variables.
--   The number of equations is stored in the neq attribute,
--   the number of variables is stored in the dim attribute.
--   The number of variables plus one is the dim1 attribute.
--   The update in Newton's method is stored twice, once as dx,
--   as a vector of power series, and once as xd, in linearized format,
--   as a series with vector coefficients. 

  type SVD_Predictor ( neq,dim,dim1,deg,numdeg,dendeg : integer32 ) is record
    sol : Standard_Complex_VecVecs.VecVec(1..dim);        -- degree deg series
    wrk : Standard_Complex_Vectors.Link_to_Vector;        -- of range 1..neq
    dx : Standard_Complex_VecVecs.VecVec(1..dim);         -- vector of series
    xd : Standard_Complex_VecVecs.VecVec(0..deg);         -- series of vectors
    svl : Standard_Complex_Vectors.Vector(1..dim1);       -- singular values
    U : Standard_Complex_Matrices.Matrix(1..neq,1..neq);  -- U in SVD
    V : Standard_Complex_Matrices.Matrix(1..dim,1..dim);  -- V in SVD
    ewrk : Standard_Complex_Vectors.Link_to_Vector;       -- of range 1..dim
    numcff : Standard_Complex_VecVecs.VecVec(1..dim);     -- numerator coeffs
    dencff : Standard_Complex_VecVecs.VecVec(1..dim);     -- denominator coeffs
    padepiv : Standard_Integer_Vectors.Vector(1..dendeg); -- pivots for Pade
    mat : Matrix(1..dendeg,1..dendeg); -- matrix for the rational approximation
    rhs : Standard_Complex_Vectors.Vector(1..dendeg); -- right hand side
  end record;
  type Link_to_SVD_Predictor is access SVD_Predictor;

-- DATA STRUCTURE FOR CURVATURE :
--   The singular values of the Hessians are computed to estimate the
--   distance from the current solution to the nearest path.
--   With the data structure we store the work space and the largest
--   singular values of the Hessians.  At spot zero, we keep the smallest
--   singular value of the Jacobian matrix at the solution.

  type SVD_Hessians ( dim,dim1 : integer32 ) is record   -- dim1 = dim+1
    H : Standard_Complex_Matrices.Matrix(1..dim,1..dim); -- work Hessian
    U : Standard_Complex_Matrices.Matrix(1..dim,1..dim); -- work U of SVD
    V : Standard_Complex_Matrices.Matrix(1..dim,1..dim); -- work V of SVD
    svl : Standard_Complex_Vectors.Vector(1..dim1);      -- work values
    ewrk : Standard_Complex_Vectors.Vector(1..dim);      -- work values
    vals : Standard_Complex_Vectors.Vector(0..dim);      -- singular values
  end record;
  type Link_to_SVD_Hessians is access SVD_Hessians;

  function Create ( sol : Standard_Complex_Vectors.Vector;
	            neq,deg,numdeg,dendeg : integer32 ) return LU_Predictor;
  function Create ( sol : Standard_Complex_Vectors.Vector;
                    neq,deg,numdeg,dendeg : integer32 )
                  return Link_to_LU_Predictor;
  function Create ( sol : Standard_Complex_Vectors.Vector;
	            neq,deg,numdeg,dendeg : integer32 ) return SVD_Predictor;
  function Create ( sol : Standard_Complex_Vectors.Vector;
                    neq,deg,numdeg,dendeg : integer32 )
                  return Link_to_SVD_Predictor;

  -- DESCRIPTION :
  --   Given a solution vector and dimensions,
  --   makes the power series for sol and allocate work space.

  -- ON ENTRY :
  --   sol      a solution vector;
  --   neq      number of equations in the homotopy;
  --   deg      degree of the power series;
  --   numdeg   degree of the numerator of the rational approximation;
  --   dendeg   degree of the denominator of the rational approximation.

  -- ON RETURN :
  --   data allocated to run the Newton-Fabry-Pade predictor.

  procedure Predict
              ( hom : in Link_to_System; prd : in Link_to_LU_Predictor;
                maxit : in integer32; tol : in double_float;
                nbrit : out integer32; absdx : out double_float;
                fail : out boolean; z : out Complex_Number;
                rad,err : out double_float; output : in boolean );

  -- DESCRIPTION :
  --   Runs Newton's method on the power series in prd with LU,
  --   applies Fabry's theorem and constructs Pade approximants
  --   to predict the next solution, in double precision.

  -- ON ENTRY :
  --   hom      homotopy convolution circuit system
  --   prd      predictor data for LU Newton and Pade approximants;
  --   maxit    maximum number of iterations in Newton's method;
  --   tol      tolerance on the correction term;
  --   output   flag to indicate extra output during computations.

  -- ON RETURN :
  --   prd      contains solution series and Pade approximants;
  --   nbrit    number of iterations done;
  --   absdx    absolute value of the last corrector step;
  --   fail     indicates failure status;
  --   z        closest singularity estimated by Fabry's theorem;
  --   rad      estimates radius of convergence of the series;
  --   err      error estimate on the location of z.

  procedure Predict
              ( hom : in Link_to_System; prd : in Link_to_SVD_Predictor;
                maxit : in integer32; tol : in double_float;
                nbrit : out integer32; absdx,rcond : out double_float;
                fail : out boolean; z : out Complex_Number;
                rad,err : out double_float; output : in boolean );

  -- DESCRIPTION :
  --   Runs Newton's method on the power series in prd with SVD,
  --   applies Fabry's theorem and constructs Pade approximants
  --   to predict the next solution, in double precision.

  -- ON ENTRY :
  --   hom      homotopy convolution circuit system
  --   prd      predictor data for LU Newton and Pade approximants;
  --   maxit    maximum number of iterations in Newton's method;
  --   tol      tolerance on the correction term;
  --   output   flag to indicate extra output during computations.

  -- ON RETURN :
  --   prd      contains solution series and Pade approximants;
  --   nbrit    number of iterations done;
  --   absdx    absolute value of the last corrector step;
  --   rcond    estimate for the inverse of the condition number;
  --   fail     indicates failure status;
  --   z        closest singularity estimated by Fabry's theorem;
  --   rad      estimates radius of convergence of the series;
  --   err      error estimate on the location of z.

  procedure Second
              ( hom : in Link_to_System; svh : in Link_to_SVD_Hessians;
                sol : in Standard_Complex_Vectors.Vector );

  -- DESCRIPTION :
  --   Computes the Hessians for the convolution circuits in hom
  --   at the solution sol and stores the results in svh.

  function Standard_Distance
              ( svh : in Standard_Predictor_Convolutions.Link_to_SVD_Hessians )
              return double_float;

  -- DESCRIPTION :
  --   Returns the estimate to the distance to the nearest solution,
  --   based on the singular values in svh.

-- DESTRUCTORS :

  procedure Clear ( p : in out Link_to_LU_Predictor );
  procedure Clear ( p : in out Link_to_SVD_Predictor );

  -- DESCRIPTION :
  --   Deallocates the memory for the series, the work space,
  --   and the rational approximation.

  procedure Clear ( h : in out Link_to_SVD_Hessians );

  -- DESCRIPTION :
  --   Deallocates the memory occupied by h.

end Standard_Predictor_Convolutions;