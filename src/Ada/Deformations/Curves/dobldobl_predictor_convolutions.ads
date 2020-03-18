with text_io;                            use text_io;
with Standard_Integer_Numbers;           use Standard_Integer_Numbers;
with Standard_Floating_Numbers;          use Standard_Floating_Numbers;
with Double_Double_Numbers;              use Double_Double_Numbers;
with DoblDobl_Complex_Numbers;           use DoblDobl_Complex_Numbers;
with Standard_Integer_Vectors;
with DoblDobl_Complex_Vectors;
with DoblDobl_Complex_VecVecs;
with DoblDobl_Complex_Matrices;          use DoblDobl_Complex_Matrices;
with DoblDobl_Speelpenning_Convolutions; use DoblDobl_Speelpenning_Convolutions;

package DoblDobl_Predictor_Convolutions is

-- DESCRIPTION :
--   Exports data structures and procedures to construct a rational prediction
--   for the next solution on a path defined by a polynomial homotopy,
--   represented by convolution circuits, in double double precision.

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
    sol : DoblDobl_Complex_VecVecs.VecVec(1..dim);        -- degree deg series
    wrk : DoblDobl_Complex_Vectors.Link_to_Vector;        -- Newton work space
    numcff : DoblDobl_Complex_VecVecs.VecVec(1..dim);     -- numerator coeffs
    dencff : DoblDobl_Complex_VecVecs.VecVec(1..dim);     -- denominator coeffs
    newtpiv : Standard_Integer_Vectors.Vector(1..dim);    -- pivots for Newton
    padepiv : Standard_Integer_Vectors.Vector(1..dendeg); -- pivots for Pade
    mat : Matrix(1..dendeg,1..dendeg); -- matrix for rational approximation
    rhs : DoblDobl_Complex_Vectors.Vector(1..dendeg);
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
    sol : DoblDobl_Complex_VecVecs.VecVec(1..dim);        -- degree deg series
    wrk : DoblDobl_Complex_Vectors.Link_to_Vector;        -- of range 1..neq
    dx : DoblDobl_Complex_VecVecs.VecVec(1..dim);         -- vector of series
    xd : DoblDobl_Complex_VecVecs.VecVec(0..deg);         -- series of vectors
    svl : DoblDobl_Complex_Vectors.Vector(1..dim1);       -- singular values
    U : DoblDobl_Complex_Matrices.Matrix(1..neq,1..neq);  -- U in SVD
    V : DoblDobl_Complex_Matrices.Matrix(1..dim,1..dim);  -- V in SVD
    ewrk : DoblDobl_Complex_Vectors.Link_to_Vector;       -- of range 1..dim
    numcff : DoblDobl_Complex_VecVecs.VecVec(1..dim);     -- numerator coeffs
    dencff : DoblDobl_Complex_VecVecs.VecVec(1..dim);     -- denominator coeffs
    padepiv : Standard_Integer_Vectors.Vector(1..dendeg); -- pivots for Pade
    mat : Matrix(1..dendeg,1..dendeg); -- matrix for the rational approximation
    rhs : DoblDobl_Complex_Vectors.Vector(1..dendeg); -- right hand side
  end record;
  type Link_to_SVD_Predictor is access SVD_Predictor;

-- DATA STRUCTURE FOR CURVATURE :
--   The singular values of the Hessians are computed to estimate the
--   distance from the current solution to the nearest path.
--   With the data structure we store the work space and the largest
--   singular values of the Hessians.  At spot zero, we keep the smallest
--   singular value of the Jacobian matrix at the solution.

  type SVD_Hessians ( dim,dim1 : integer32 ) is record   -- dim1 = dim+1
    H : DoblDobl_Complex_Matrices.Matrix(1..dim,1..dim); -- work Hessian
    U : DoblDobl_Complex_Matrices.Matrix(1..dim,1..dim); -- work U of SVD
    V : DoblDobl_Complex_Matrices.Matrix(1..dim,1..dim); -- work V of SVD
    svl : DoblDobl_Complex_Vectors.Vector(1..dim1);      -- work values
    ewrk : DoblDobl_Complex_Vectors.Vector(1..dim);      -- work values
    vals : DoblDobl_Complex_Vectors.Vector(0..dim);      -- singular values
  end record;
  type Link_to_SVD_Hessians is access SVD_Hessians;

  function Create ( sol : DoblDobl_Complex_Vectors.Vector;
	            neq,deg,numdeg,dendeg : integer32 ) return LU_Predictor;
  function Create ( sol : DoblDobl_Complex_Vectors.Vector;
                    neq,deg,numdeg,dendeg : integer32 )
                  return Link_to_LU_Predictor;
  function Create ( sol : DoblDobl_Complex_Vectors.Vector;
	            neq,deg,numdeg,dendeg : integer32 ) return SVD_Predictor;
  function Create ( sol : DoblDobl_Complex_Vectors.Vector;
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

  procedure Newton_Fabry_Report 
              ( file : in file_type;
                nbrit : in integer32; absdx : in double_double;
                fail : in boolean;
                z : in DoblDobl_Complex_Numbers.Complex_Number;
                r,err,step : in double_double;
                numcff,dencff : in DoblDobl_Complex_VecVecs.VecVec;
                output : in boolean );

  -- DESCRIPTION :
  --   Writes the results of the Newton-Fabry-Pade predictor,
  --   in double double precision.

  -- ON ENTRY :
  --   file     must be opened for output;
  --   nbrit    number of iterations done with Newton's method;
  --   absdx    absolute value of last corrector;
  --   fail     true if required tolerance was not reached;
  --   z        estimate for the closest singularity;
  --   r        radius of z;
  --   err      error on the estimate z;
  --   step     the pole step, equals beta1*r;
  --   numcff   coefficients of the numerator of the Pade approximants;
  --   dencff   coefficients of the denominator of the Pade approximants;
  --   output   if true, then numcff and dencff are written to screen.

  procedure Newton_Fabry
              ( file : in file_type;
                hom : in Link_to_System; prd : in Link_to_LU_Predictor;
                maxit : in integer32; tol : in double_float;
                nbrit : out integer32; absdx : out double_double;
                fail : out boolean; z : out Complex_Number;
                rad,err : out double_double; output : in boolean );

  -- DESCRIPTION :
  --   Runs Newton's method on the power series in prd with LU,
  --   applies Fabry's theorem and constructs Pade approximants
  --   to predict the next solution, in double double precision.

  -- ON ENTRY :
  --   file     for writing data to if output;
  --   hom      homotopy convolution circuit system
  --   prd      predictor data for LU Newton and Pade approximants;
  --   maxit    maximum number of iterations in Newton's method;
  --   tol      tolerance on the correction term;
  --   output   flag to indicate data output during computations.

  -- ON RETURN :
  --   prd      contains solution series and Pade approximants;
  --   nbrit    number of iterations done;
  --   absdx    absolute value of the last corrector step;
  --   fail     indicates failure status;
  --   z        closest singularity estimated by Fabry's theorem;
  --   rad      estimates radius of convergence of the series;
  --   err      error estimate on the location of z.

  procedure Newton_Fabry
              ( file : in file_type;
                hom : in Link_to_System; prd : in Link_to_SVD_Predictor;
                maxit : in integer32; tol : in double_float;
                nbrit : out integer32; absdx,rcond : out double_double;
                fail : out boolean; z : out Complex_Number;
                rad,err : out double_double; output : in boolean );

  -- DESCRIPTION :
  --   Runs Newton's method on the power series in prd with SVD,
  --   applies Fabry's theorem and constructs Pade approximants
  --   to predict the next solution, in double double precision.

  -- ON ENTRY :
  --   file     for writing data to if output;
  --   hom      homotopy convolution circuit system
  --   prd      predictor data for LU Newton and Pade approximants;
  --   maxit    maximum number of iterations in Newton's method;
  --   tol      tolerance on the correction term;
  --   output   flag to indicate data output during computations.

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
                sol : in DoblDobl_Complex_Vectors.Vector );

  -- DESCRIPTION :
  --   Computes the Hessians for the convolution circuits in hom
  --   at the solution sol and stores the results in svh.

  function Distance ( svh : in Link_to_SVD_Hessians ) return double_double;

  -- DESCRIPTION :
  --   Returns the estimate to the distance to the nearest solution,
  --   based on the singular values in svh.

  procedure Hesse_Pade
              ( file : in file_type;
                hom : in DoblDobl_Speelpenning_Convolutions.Link_to_System;
                prd : in DoblDobl_Predictor_Convolutions.Link_to_LU_Predictor;
                svh : in DoblDobl_Predictor_Convolutions.Link_to_SVD_Hessians;
                sol : in DoblDobl_Complex_Vectors.Vector;
                res : out DoblDobl_Complex_Vectors.Vector;
                beta2 : in double_float; eta,nrm,step : out double_double;
                verbose : in boolean := true );

  -- DESCRIPTION :
  --   Computes the singular values of the Hessians and estimates the
  --   distance to the closest path to determine the step size.

  -- ON ENTRY :
  --   file     to write the output to if verbose;
  --   hom      homotopy convolution circuit system
  --   prd      predictor data for LU Newton and Pade approximants;
  --   svh      data for the curvature estimation;
  --   sol      the leading coefficients of the solution series;
  --   beta2    multiplication factor for the curvature step;
  --   verbose  flag for intermediate numerical output.

  -- ON RETURN :
  --   res      solution error estimated by Pade approximants in prd,
  --            the range of res is hom.crc'range;
  --   nrm      2-norm of res;
  --   step     computed curvature step.

  procedure Hesse_Pade
              ( file : in file_type;
                hom : in DoblDobl_Speelpenning_Convolutions.Link_to_System;
                prd : in DoblDobl_Predictor_Convolutions.Link_to_SVD_Predictor;
                svh : in DoblDobl_Predictor_Convolutions.Link_to_SVD_Hessians;
                sol : in DoblDobl_Complex_Vectors.Vector;
                res : out DoblDobl_Complex_Vectors.Vector;
                beta2 : in double_float; eta,nrm,step : out double_double;
                verbose : in boolean := true );

  -- DESCRIPTION :
  --   Computes the singular values of the Hessians and estimates the
  --   distance to the closest path to determine the step size.

  -- ON ENTRY :
  --   file     to write the output to if verbose;
  --   hom      homotopy convolution circuit system
  --   prd      predictor data for SVD Newton and Pade approximants;
  --   svh      data for the curvature estimation;
  --   sol      the leading coefficients of the solution series;
  --   beta2    multiplication factor for the curvature step;
  --   verbose  flag for intermediate numerical output.

  -- ON RETURN :
  --   res      solution error estimated by Pade approximants in prd,
  --            the range of res is hom.crc'range;
  --   nrm      2-norm of res;
  --   step     computed curvature step.

  procedure Predictor_Feedback
              ( file : in file_type;
                hom : in DoblDobl_Speelpenning_Convolutions.Link_to_System;
                abh : in DoblDobl_Speelpenning_Convolutions.Link_to_System;
                numcff,dencff : in DoblDobl_Complex_VecVecs.VecVec;
                step : in out double_double; alpha : in double_float;
                eva,radsol : in out DoblDobl_Complex_Vectors.Vector;
                res,absres : in out DoblDobl_Complex_Vectors.Vector;
                nrm,mixres : out double_double; nbfail : out integer32;
                verbose : in boolean := true );

  -- DESCRIPTION :
  --   Given a step size, runs a predictor feedback loop,
  --   cutting the step size each time in half, until the
  --   mixed residual is less than the tolerance.

  -- ON ENTRY :
  --   file     for writing output to if verbose;
  --   hom      homotopy convolution circuit system
  --   abh      circuits with radii as coeffiecients, for mixed residuals;
  --   numcff   coefficients of the numerator of the Pade approximants;
  --   dencff   coefficients of the denominator of the Pade approximants;
  --   step     current step size;
  --   alpha    tolerance on the mixed predictor residual;
  --   eva      work space of range 1..hom.dim for Pade evaluation;
  --   radsol   work space for the radii of eva;
  --   res      work space of hom.crc'range for evaluation of eva;
  --   absres   work space of abh.crc'range for evaluation of radsol;
  --   verbose  flag for extra output if true.

  -- ON RETURN :
  --   step     shorter step size if nbfail > 0;
  --   eva      predicted solution by evaluation of Pade approximants;
  --   radsol   radii of the predicted solution;
  --   res      evaluation of the predicted solution eva;
  --   absres   evaluation of the radii of the prediction radsol;
  --   nrm      max norm of the components in res;
  --   mixres   mixed residual.

-- DESTRUCTORS :

  procedure Clear ( p : in out Link_to_LU_Predictor );
  procedure Clear ( p : in out Link_to_SVD_Predictor );

  -- DESCRIPTION :
  --   Deallocates the memory for the series, the work space,
  --   and the rational approximation.

  procedure Clear ( h : in out Link_to_SVD_Hessians );

  -- DESCRIPTION :
  --   Deallocates the memory occupied by h.

end DoblDobl_Predictor_Convolutions;
