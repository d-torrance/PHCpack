with Standard_Integer_Numbers;           use Standard_Integer_Numbers;
with Standard_Integer_Vectors;
with Arrays_of_Integer_Vector_Lists;
with Arrays_of_Floating_Vector_Lists;
with Standard_Complex_Poly_Systems;      use Standard_Complex_Poly_Systems;
with Standard_Complex_Laur_Systems;      use Standard_Complex_Laur_Systems;
with Floating_Mixed_Subdivisions;        use Floating_Mixed_Subdivisions;
with C_Integer_Arrays;                   use C_Integer_Arrays;

package DEMiCs_Algorithm is

-- DESCRIPTION :
--   This package provides an interface to DEMiCs,
--   to compute all mixed cells by dynamic enumeration.
--   DEMiCs was developed by Tomohiko Mizutani, Akiko Takeda, and
--   Masakazu Kojima and licensed under GNU GPL Version 2 or higher.

  function Mixture_Type
             ( mix : Standard_Integer_Vectors.Vector )
             return C_Integer_Array;

  -- DESCRIPTION :
  --   Returns the type of mixture as an array suitable to pass to C.

  function Cardinalities
             ( sup : Arrays_of_Integer_Vector_Lists.Array_of_Lists )
             return C_Integer_Array;

  -- DESCRIPTION :
  --   Returns the length of each support list in sup
  --   as an array suitable to pass to C.

  function Number_of_Points
             ( mix : Standard_Integer_Vectors.Vector;
               sup : Arrays_of_Integer_Vector_Lists.Array_of_Lists )
             return integer32;

  -- DESCRIPTION :
  --   Returns the total number of points in the supports sup.

  function Coordinates
             ( nbr : integer32;
               mix : Standard_Integer_Vectors.Vector;
               sup : Arrays_of_Integer_Vector_Lists.Array_of_Lists )
             return C_Integer_Array;

  -- DESCRIPTION :
  --   Returns the length of each support list in sup
  --   as an array suitable to pass to C.
  --
  function run_demics
             ( v,d,r : integer32; mtp,crd,pts : C_Integer_Array )
             return integer32;
  pragma import(C, run_demics, "demicsrun");

  -- DESCRIPTION :
  --   Interface to the C++ function demicsrun.

  -- ON ENTRY :
  --   v       0 or 1 whether silent or verbose;
  --   d       dimension;
  --   r       number of distinct support sets;
  --   mtp     mixture type;
  --   crd     cardinalities of each support set;
  --   pts     coordinates of the points in the each support.

  procedure Extract_Supports 
               ( p : in Poly_Sys;
                 mix : out Standard_Integer_Vectors.Link_to_Vector;
                 supports : out Arrays_of_Integer_Vector_Lists.Array_of_Lists;
                 verbose : in boolean := true );
  procedure Extract_Supports 
               ( p : in Laur_Sys;
                 mix : out Standard_Integer_Vectors.Link_to_Vector;
                 supports : out Arrays_of_Integer_Vector_Lists.Array_of_Lists;
                 verbose : in boolean := true );

  -- DESCRIPTION :
  --   Extracts the supports and computes the type of mixture.

  procedure Call_DEMiCs
              ( mix : in Standard_Integer_Vectors.Link_to_Vector;
                supports : in Arrays_of_Integer_Vector_Lists.Array_of_Lists;
                verbose : in boolean := true );

  -- DESCRIPTION :
  --   Calls DEMiCs on the given supports.

  procedure Show_Output;

  -- DESCRIPITON :
  --   Shows the output stored in DEMiCs_Output_Data.

  function Extract_Indices ( s : string ) return string;

  -- DESCRIPTION :
  --   Scans s to the first colon and then returns the rest of s,
  --   all characters of s after the first colon.

  procedure Process_Output
              ( dim : in integer32;
                mix : in Standard_Integer_Vectors.Link_to_Vector;
                sup : in Arrays_of_Integer_Vector_Lists.Array_of_Lists;
                lif : out Arrays_of_Floating_Vector_Lists.Array_of_Lists;
                mcc : out Mixed_Subdivision;
                verbose : in boolean := true );

  -- DESCRIPTION :
  --   Converts the data computed by DEMiCs to lifted supports
  --   and a mixed cell configuration.

  -- ON ENTRY :
  --   dim      dimension of the points before lifting;
  --   mix      type of mixture;
  --   sup      supports of a polynomial system;
  --   verbose  flag to indicate if extra output is wanted.

  -- ON RETURN :
  --   lif      lifted support sets;
  --   mcc      a regular mixed-cell configuration.

end DEMiCs_Algorithm;