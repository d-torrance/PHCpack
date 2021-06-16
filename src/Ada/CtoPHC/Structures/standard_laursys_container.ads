with Standard_Natural_Numbers;          use Standard_Natural_Numbers;
with Standard_Integer_Numbers;          use Standard_Integer_Numbers;
with Standard_Complex_Laurentials;      use Standard_Complex_Laurentials;
with Standard_Complex_Laur_Systems;     use Standard_Complex_Laur_Systems;
with Standard_Complex_Laur_SysFun;      use Standard_Complex_Laur_SysFun;
with Standard_Complex_Laur_JacoMats;    use Standard_Complex_Laur_JacoMats;

package Standard_LaurSys_Container is

-- DESCRIPTION :
--   This package provides a container for a Laurent polynomial system,
--   with coefficients in standard double precision, for the C interface.

-- CREATORS :

  procedure Initialize ( p : in Laur_Sys ); 

  -- DESCRIPTION :
  --   Initializes the container with a polynomial system.

  procedure Initialize ( n : in integer32 );

  -- DESCRIPTION :
  --   Initializes the container with space to hold a system
  --   of dimension n.

  procedure Create_Evaluator;

  -- DESCRIPTION :
  --   An evaluator is created for the system in the container.

  procedure Create_Jacobian_Matrix;

  -- DESCRIPTION :
  --   Creates the Jacobian matrix for the system in the container.

  procedure Create_Jacobian_Evaluator;

  -- DESCRIPTION :
  --   Creates an evaluator for the Jacobian matrix in the container.

-- CONSTRUCTORS :

  procedure Add_Term ( k : in integer32; t : in Term );

  -- DESCRIPTION :
  --   Adds the term t to the k-th polynomial in the system.

  -- REQUIRED : Dimension >= k > 0.

  procedure Add_Poly ( k : in integer32; p : in Poly );

  -- DESCRIPTION :
  --   Adds the polynomial p to the k-th polynomial in the system.

  -- REQUIRED : Dimension >= k > 0.

-- SELECTORS :

  function Dimension return natural32;

  -- DESCRIPTION :
  --   Returns the number of polynomials in the system,
  --   zero if the system is empty.

  function Number_of_Terms ( k : integer32 ) return natural32;

  -- DESCRIPTION :
  --   Returns 0 if the container is empty, otherwise the
  --   number of terms in the k-th polynomial is returned.

  function Retrieve_Term ( k : integer32; i : natural32 ) return Term;

  -- DESCRIPTION :
  --   Returns the i-th term of the k-th polynomial,
  --   if i <= Number_of_Terms(k), otherwise the term
  --   on return has a zero coefficient.

  function Retrieve_Poly ( k : integer32 ) return Poly;

  -- DESCRIPTION :
  --   Returns the k-th polynomial in the system.

  function Retrieve return Link_to_Laur_Sys;

  -- DESCRIPTION :
  --   Returns the polynomial system stored by the container.

  function Evaluator return Link_to_Eval_Laur_Sys;

  -- DESCRIPTION :
  --   Returns the evaluator for the polynomial system
  --   stored in the container.

  function Jacobian_Matrix return Link_to_Jaco_Mat;

  -- DESCRIPTION :
  --   Returns the Jacobian matrix for the polynomial system
  --   stored in the container.

  function Jacobian_Evaluator return Link_to_Eval_Jaco_Mat;

  -- DESCRIPTION :
  --   Returns the evaluator for the Jacobian matrix.

-- DESTRUCTOR :

  procedure Clear;

  -- DESCRIPTION :
  --   Clears the container: its polynomial system and evaluator.

end Standard_LaurSys_Container;
