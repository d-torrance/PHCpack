with text_io;                           use text_io;
with Communications_with_User;          use Communications_with_User;
with Standard_Natural_Numbers;          use Standard_Natural_Numbers;
with Standard_Integer_Numbers;          use Standard_Integer_Numbers;
with Standard_Integer_Numbers_io;       use Standard_Integer_Numbers_io;
with Standard_Floating_Numbers;         use Standard_Floating_Numbers;
with Standard_Floating_Numbers_io;      use Standard_Floating_Numbers_io;
with Standard_Integer_Vectors;
with Standard_Integer_Vectors_io;       use Standard_Integer_Vectors_io;
with Standard_Integer_Matrices;
with Standard_Integer_Matrices_io;      use Standard_Integer_Matrices_io;
with Standard_Random_Numbers;
with Standard_Complex_Numbers;
with Standard_Complex_Vectors;
with Standard_Complex_VecVecs;
with Standard_Complex_VecVecVecs;
with Standard_Laurent_Series;
with Random_Laurent_Series;             use Random_Laurent_Series;
with Standard_Linear_Laurent_Solvers;   use Standard_Linear_Laurent_Solvers;

procedure ts_laurmat is

-- DESCRIPTION :
--   A matrix of Laurent series is a tuple of
--   1) a matrix of leading exponents, and
--   2) 3-dimensional vector of vector of vectors
--   with the coefficients of the power series.

  procedure Allocate_Series_Coefficients
              ( dim,deg : in integer32;
                cff : out Standard_Complex_VecVecs.Link_to_VecVec ) is

  -- DESCRIPTION :
  --   Returns in cff the coefficients of dim series of degree deg,
  --   all equal to zero.

    res : Standard_Complex_VecVecs.VecVec(1..dim);
    zero : constant Standard_Complex_Numbers.Complex_Number
         := Standard_Complex_Numbers.Create(0.0);

  begin
    for i in 1..dim loop
      declare
        val : constant Standard_Complex_Vectors.Vector(0..deg)
            := (0..deg => zero);
      begin
        res(i) := new Standard_Complex_Vectors.Vector'(val);
      end;
    end loop;
    cff := new Standard_Complex_VecVecs.VecVec'(res);
  end Allocate_Series_Coefficients;

  procedure Write ( e : in Standard_Integer_Matrices.Matrix;
                    c : in Standard_Complex_VecVecVecs.Link_to_VecVecVec;
                    s : in string := "A" ) is

  -- DESCRIPTION :
  --   Writes the matrix of Laurent series, defined by
  --   the leading exponents in e and coefficients in c.

  -- REQUIRED :
  --   e'range(1) = c'range(1) and e'range(2) = c'range(2).

  begin
    for i in e'range(1) loop
      for j in e'range(2) loop
        put(s & "("); put(i,1); put(","); put(j,1); put_line(") :");
        Standard_Laurent_Series.Write(e(i,j),c(i)(j).all);
      end loop;
    end loop;
  end Write;

  procedure Write ( e : in Standard_Integer_Vectors.Vector;
                    c : in Standard_Complex_VecVecs.Link_to_VecVec;
                    s : in string := "v" ) is

  -- DESCRIPTION :
  --   Writes the vector of Laurent series, defined by
  --   the leading exponents in e and coefficients in c.

  -- REQUIRED : e'range = c'range.

  begin
    for i in e'range loop
      put(s & "("); put(i,1); put_line(") :");
      Standard_Laurent_Series.Write(e(i),c(i).all);
    end loop;
  end Write;

  procedure Matrix_Matrix_Product
              ( nrows,ncols,deg : in integer32;
                Alead : in Standard_Integer_Matrices.Matrix;
                Acffs : in Standard_Complex_VecVecVecs.Link_to_VecVecVec;
                Blead : in Standard_Integer_Matrices.Matrix;
                Bcffs : in Standard_Complex_VecVecVecs.Link_to_VecVecVec;
                Clead : out Standard_Integer_Matrices.Matrix;
                Ccffs : out Standard_Complex_VecVecVecs.Link_to_VecVecVec ) is

  -- DESCRIPTION :
  --   Returns the product of two square matrices A and B in C.

  -- ON ENTRY :
  --   nrows    number of rows of all matrices;
  --   ncols    number of columns of all matrices;
  --   deg      degree of the series in all matrices;
  --   Alead    leading exponents of the series in the matrix A;
  --   Acffs    coefficients of the series in the matrix A;
  --   Blead    leading exponents of the series in the matrix B;
  --   Bcffs    coefficients of the series in the matrix B.

  -- ON RETURN :
  --   Clead    leading exponents of the product of A with B;
  --   Ccffs    coefficients of the product of A with B.

    Arow,Brow,Crow : Standard_Complex_VecVecs.Link_to_VecVec;
    Acff,Bcff,Ccff : Standard_Complex_Vectors.Link_to_Vector;
    ze,ewrk,eprd : integer32;
    zc,cwrk,cprd : Standard_Complex_Vectors.Vector(0..deg);

  begin
    for i in 1..nrows loop           -- initialize C to zero
      Crow := Ccffs(i); 
      for j in 1..ncols loop
        Clead(i,j) := 0;
        Ccff := Crow(j);             -- coefficients of C(i,j)
        for k in 0..deg loop
          Ccff(k) := Standard_Complex_Numbers.Create(0.0);
        end loop;
      end loop;
    end loop;
    for i in 1..nrows loop
      Arow := Acffs(i);
      Crow := Ccffs(i);
      for j in 1..ncols loop
        ewrk := 0;              -- accumulates leading exponent of C(i,j)
        for k in 0..deg loop
          cwrk(k) := Standard_Complex_Numbers.Create(0.0);
        end loop;
        for k in 1..ncols loop
          Acff := Arow(k);                   -- Acff is A(i,k)
          Brow := Bcffs(k); Bcff := Brow(j); -- Bcff is B(k,j)
          Standard_Laurent_Series.Multiply
            (deg,Alead(i,k),Blead(k,j),Acff.all,Bcff.all,eprd,cprd);
         -- eprd is the leading exponent of A(i,k)*B(k,j)
         -- cprd has the coefficients of A(i,k)*B(k,j)
          Standard_Laurent_Series.Add(deg,ewrk,eprd,cwrk,cprd,ze,zc);
          ewrk := ze;          -- leading exponent of accumulator 
          for L in 0..deg loop -- copy coefficients of accumulator
            cwrk(L) := zc(L);
          end loop;
        end loop;
        Clead(i,j) := ewrk;
        Ccff := Crow(j);
        for k in 0..deg loop
          Ccff(k) := cwrk(k);
        end loop;
      end loop;
    end loop;
  end Matrix_Matrix_Product;

  procedure Write_Difference
              ( deg : in integer32;
                Alead : in Standard_Integer_Matrices.Matrix;
                Acffs : in Standard_Complex_VecVecVecs.Link_to_VecVecVec;
                Blead : in Standard_Integer_Matrices.Matrix;
                Bcffs : in Standard_Complex_VecVecVecs.Link_to_VecVecVec ) is

  -- DESCRIPTION :
  --   Writes the difference between the matrices A with B.

    Arow,Brow : Standard_Complex_VecVecs.Link_to_VecVec;
    Acff,Bcff : Standard_Complex_Vectors.Link_to_Vector;
    ze : integer32;
    zc : Standard_Complex_Vectors.Vector(0..deg);
    nrm : double_float := 0.0;

  begin
    for i in Alead'range(1) loop
      Arow := Acffs(i);
      Brow := Bcffs(i);
      for j in Alead'range(2) loop
        Acff := Arow(j);
        Bcff := Brow(j);
        Standard_Laurent_Series.Subtract
          (deg,Alead(i,j),Blead(i,j),Acff.all,Bcff.all,ze,zc);
        put("D("); put(i,1); put(","); put(j,1); put_line(") :");
        Standard_Laurent_Series.Write(ze,zc);
        for k in 0..deg loop
          nrm := nrm + Standard_Complex_Numbers.AbsVal(zc(k));
        end loop;
      end loop;
    end loop;
    put("The difference sum : "); put(nrm); new_line;
  end Write_Difference;

  procedure Plain_LU_Factorization
              ( nrows,ncols,deg : in integer32;
                Alead : in Standard_Integer_Matrices.Matrix;
                Acffs : in Standard_Complex_VecVecVecs.Link_to_VecVecVec;
                Llead : out Standard_Integer_Matrices.Matrix;
                Lcffs : in Standard_Complex_VecVecVecs.Link_to_VecVecVec;
                Ulead : out Standard_Integer_Matrices.Matrix;
                Ucffs : in Standard_Complex_VecVecVecs.Link_to_VecVecVec ) is

  -- DESCRIPTION :
  --   Applies the plain LU factorization, plain means without pivoting,
  --   factoring the matrix A as a product of a lower triangular L with
  --   an upper triangular matrix U.  For testing purposes, the matrices
  --   L and U are returned explicitly.

  -- ON ENTRY :
  --   nrows    number of rows of the matrix;
  --   ncols    number of columns of the matrix;
  --   deg      degree of the series in all matrices;
  --   Alead    leading exponents of the series;
  --   Acffs    coefficients of the series.

  -- ON RETURN :
  --   Llead    leading exponents of the lower triangular factor L
  --            that has ones on its diagonal;
  --   Lcffs    coefficients of the lower triangular factor L;
  --   Ulead    leading exponents of the upper triangular factor U;
  --   Ucffs    coefficients of the upper triangular factor U.

    Lrow,Urow,Arow : Standard_Complex_VecVecs.Link_to_VecVec;
    Lcff,Ucff,Acff : Standard_Complex_Vectors.Link_to_Vector;
    ze,ewrk,eprd : integer32;
    zc,cwrk,cprd : Standard_Complex_Vectors.Vector(0..deg);

  begin
    for i in 1..nrows loop -- initialization of L and U
      Urow := Ucffs(i);
      for j in 1..(i-1) loop -- set the lower triangular part of U to zero
        Ulead(i,j) := 0;
        Ucff := Urow(j);     -- coefficients of U(i,j)
        for k in 0..deg loop
          Ucff(k) := Standard_Complex_Numbers.Create(0.0);
        end loop;
      end loop;
      Llead(i,i) := 0;
      Lrow := Lcffs(i);      -- set the diagonal of L to one
      Lcff := Lrow(i);       -- coefficients of L(i,i)
      Lcff(0) := Standard_Complex_Numbers.Create(1.0);
      for k in 1..deg loop
        Lcff(k) := Standard_Complex_Numbers.Create(0.0);
      end loop;
      for j in (i+1)..ncols loop -- make upper triangular part of L zero
        Llead(i,j) := 0;
        Lcff := Lrow(j);     -- coefficients of L(i,j)
        for k in 0..deg loop
          Lcff(k) := Standard_Complex_Numbers.Create(0.0);
        end loop;
      end loop;
    end loop;
    for j in 1..ncols loop
      for i in 1..j loop              -- row reduction assigns to U
        Arow := Acffs(i); Acff := Arow(j);    -- U(i,j) := A(i,j)
        ewrk := Alead(i,j);
        for k in 0..deg loop
          cwrk(k) := Acff(k);                 -- accumulates U(i,j)
        end loop;
        for k in 1..(i-1) loop        -- U(i,j) := U(i,j) - L(i,k)*U(k,j)
          Lrow := Lcffs(i); Lcff := Lrow(k); -- Lcff is L(i,k)
          Urow := Ucffs(k); Ucff := Urow(j); -- Ucff is U(k,j)
          Standard_Laurent_Series.Multiply
            (deg,Llead(i,k),Ulead(k,j),Lcff.all,Ucff.all,eprd,cprd);
         -- eprd is the leading exponent of L(i,k)*U(k,j)
         -- cprd has the coefficients of L(i,k)*U(k,j)
          Standard_Laurent_Series.Subtract(deg,ewrk,eprd,cwrk,cprd,ze,zc);
          ewrk := ze;          -- leading exponent of U(i,j) - L(i,k)*U(k,j)
          for L in 0..deg loop -- copy coefficients of U(i,j) - L(i,k)*U(k,j)
            cwrk(L) := zc(L);
          end loop;
        end loop;
        Ulead(i,j) := ewrk;                -- copy accumulator to U(i,j)
        Urow := Ucffs(i); Ucff := Urow(j); -- Ucff is U(i,j)
        for k in 0..deg loop
          Ucff(k) := cwrk(k);
        end loop;
      end loop;
      for i in j+1..nrows loop   -- row reduction assigns to L
        Arow := Acffs(i); Acff := Arow(j);      -- L(i,j) := A(i,j)
        ewrk := Alead(i,j);
        for k in 0..deg loop
          cwrk(k) := Acff(k);                   -- accumulates L(i,j)
        end loop;
        for k in 1..(j-1) loop -- L(i,j) := L(i,j) - L(i,k)*U(k,j)
          Lrow := Lcffs(i); Lcff := Lrow(k); -- Lcff is L(i,k)
          Urow := Ucffs(k); Ucff := Urow(j); -- Ucff is U(k,j)
          Standard_Laurent_Series.Multiply
            (deg,Llead(i,k),Ulead(k,j),Lcff.all,Ucff.all,eprd,cprd);
         -- eprd is the leading exponent of L(i,k)*U(k,j)
         -- cprd has the coefficients of L(i,k)*U(k,j)
          Standard_Laurent_Series.Subtract(deg,ewrk,eprd,cwrk,cprd,ze,zc);
          ewrk := ze;          -- leading exponent of L(i,j) - L(i,k)*U(k,j)
          for L in 0..deg loop -- copy coefficients of L(i,j) - L(i,k)*U(k,j)
            cwrk(L) := zc(L);
          end loop;
        end loop;
        Llead(i,j) := ewrk;                -- copy accumulator to L(i,j)
        Lrow := Lcffs(i); Lcff := Lrow(j); -- Lcff is L(i,j)
        for k in 0..deg loop
          Lcff(k) := cwrk(k);
        end loop;
        Urow := Ucffs(j); Ucff := Urow(j); -- Ucff is U(j,j) 
        Standard_Laurent_Series.Divide
          (deg,Llead(i,j),Ulead(j,j),Lcff.all,Ucff.all,ze,zc,cwrk);
        Llead(i,j) := ze;    -- leading exponent of L(i,j)/U(j,j)
        for k in 0..deg loop -- copy coefficients of L(i,j)/U(j,j)
          Lcff(k) := zc(k);
        end loop;
      end loop;
    end loop;
  end Plain_LU_Factorization;

  function Pivot_Row
              ( nrows,row : in integer32;
                lead : in Standard_Integer_Matrices.Matrix;
                column : in Standard_Complex_VecVecs.Link_to_VecVec )
              return integer32 is

  -- DESCRIPTION :
  --   Returns the row of the pivot in the current column.
  --   The pivot is determined first by the smallest leading exponent.
  --   If the leading exponents agree, then the largest coefficient
  --   determines the pivot row.

  -- ON ENTRY :
  --   nrows    number of rows;
  --   row      index of the current row;
  --   lead     leading exponents of the series;
  --   column   coefficients of the series in the current column.

    res : integer32 := row;
    leadval : integer32 := lead(row,row);
    cff : Standard_Complex_Vectors.Link_to_Vector := column(row);
    themax : double_float := Standard_Complex_Numbers.AbsVal(cff(0));
    valmax : double_float;

  begin
    for i in (row+1)..nrows loop
      cff := column(i);
      if lead(i,row) > leadval then
        null; -- higher leading exponents cannot be pivots
      else
        valmax := Standard_Complex_Numbers.AbsVal(cff(0));
        if lead(i,row) < leadval then -- lower exponents must be pivots
          themax := valmax;
          leadval := lead(i,row);
          res := i;
        else -- if lead(i,row) = leadval, then compare coefficients
          if valmax > themax then
            themax := valmax;
            res := i;
          end if;
        end if;
      end if;
    end loop;
    return res;
  end Pivot_Row;

  procedure Swap_Rows
              ( ncols,row,pivrow : in integer32;
                lead : in out Standard_Integer_Matrices.Matrix;
                cffs : in Standard_Complex_VecVecVecs.Link_to_VecVecVec;
                pivots : in out Standard_Integer_Vectors.Vector ) is

  -- DESCRIPTION :
  --   Swaps the rows, as defined by the index of the pivot row.

  -- ON ENTRY :
  --   ncols    number of columns;
  --   row      index of the current row;
  --   pivrow   index of the pivot row, different from row;
  --   lead     leading exponents of the series;
  --   cffs     coefficients of the series;
  --   pivots   current values of the pivots.

    itmp : integer32;
    vtmp : Standard_Complex_VecVecs.Link_to_VecVec;
  
  begin
    itmp := pivots(row);
    pivots(row) := pivots(pivrow);
    pivots(pivrow) := itmp;
    vtmp := cffs(row);
    cffs(row) := cffs(pivrow);
    cffs(pivrow) := vtmp;
    for j in 1..ncols loop
      itmp := lead(row,j);
      lead(row,j) := lead(pivrow,j);
      lead(pivrow,j) := itmp;
    end loop;
  end Swap_Rows;

  procedure LU_Factorization
              ( nrows,ncols,deg : in integer32;
                Alead : in out Standard_Integer_Matrices.Matrix;
                Acffs : in Standard_Complex_VecVecVecs.Link_to_VecVecVec;
                pivots : out Standard_Integer_Vectors.Vector ) is

  -- DESCRIPTION :
  --   An inplace LU factorization with pivoting.

  -- ON ENTRY :
  --   nrows    number of rows of the matrix;
  --   ncols    number of columns of the matrix;
  --   deg      degree of the series in the matrix;
  --   Alead    leading exponents of the series;
  --   Acffs    coefficients of the series;
  --   pivots   space for the pivots.

  -- ON RETURN :
  --   Alead    contains the leading exponents of the factors;
  --   Acffs    the coefficients of the factors L and U;
  --   pivots   are the pivots used.

    irow,jrow,Acol : Standard_Complex_VecVecs.Link_to_VecVec;
    icff,jcff : Standard_Complex_Vectors.Link_to_Vector;
    ze,ewrk,eprd,idx : integer32;
    zc,cwrk,cprd : Standard_Complex_Vectors.Vector(0..deg);

  begin
    for i in pivots'range loop
      pivots(i) := i;
    end loop;
    for j in 1..ncols loop
      Acol := Acffs(j);
      idx := Pivot_Row(nrows,j,Alead,Acol);
      if idx /= j
       then Swap_Rows(ncols,j,idx,Alead,Acffs,pivots);
      end if;
      for i in (j+1)..nrows loop
        irow := Acffs(i); icff := irow(j); -- icff is A(i,j)
        jrow := Acffs(j); jcff := jrow(j); -- jcff is A(j,j)
        Standard_Laurent_Series.Divide
          (deg,Alead(i,j),Alead(j,j),icff.all,jcff.all,ze,zc,cwrk);
        Alead(i,j) := ze;    -- leading exponent of A(i,j)/A(j,j)
        for k in 0..deg loop -- zc has coefficients of A(i,j)/A(j,j)
          icff(k) := zc(k);  -- A(i,j) := A(i,j)/A(j,j)
        end loop;
        ewrk := 0;
        for k in 0..deg loop
          cwrk(k) := Standard_Complex_Numbers.Create(0.0);
        end loop;
        for k in (j+1)..ncols loop -- A(i,k) := A(i,k) - A(i,j)*A(j,k)
          irow := Acffs(i); icff := irow(j); -- icff is A(i,j)
          jrow := Acffs(j); jcff := jrow(k); -- jcff is A(j,k)
          Standard_Laurent_Series.Multiply
            (deg,Alead(i,j),Alead(j,k),icff.all,jcff.all,eprd,cprd);
         -- eprd is the leading exponent of A(i,j)*A(j,k)
         -- cprd has the coefficients of A(i,j)*A(j,k)
          icff := irow(k); -- icff is A(i,k)
          ewrk := Alead(i,k);
          for L in 0..deg loop
            cwrk(L) := icff(L);
          end loop;
          Standard_Laurent_Series.Subtract(deg,ewrk,eprd,cwrk,cprd,ze,zc);
          Alead(i,k) := ze;
          for L in 0..deg loop
            icff(L) := zc(L);
          end loop;
        end loop;
      end loop;
    end loop;
  end LU_Factorization;

  procedure Test_Plain_LU_Factorization
              ( nrows,ncols,deg : in integer32;
                Alead : in Standard_Integer_Matrices.Matrix;
                Acffs : in Standard_Complex_VecVecVecs.Link_to_VecVecVec ) is

  -- DESCRIPTION :
  --   Tests the LU factorization on a general, random matrix.

  -- ON ENTRY :
  --   nrows    number of rows of the test matrix;
  --   ncols    number of columns of the test matrix;
  --   deg      degree of the series in the matrix;
  --   Alead    leading exponents of the series;
  --   Acffs    coefficients of the series.

    Llead,Ulead,Plead : Standard_Integer_Matrices.Matrix(1..nrows,1..ncols);
    Lcffs,Ucffs,Pcffs : Standard_Complex_VecVecVecs.Link_to_VecVecVec;

  begin
    Standard_Complex_VecVecVecs.Allocate(Lcffs,1,nrows,1,ncols,0,deg);
    Standard_Complex_VecVecVecs.Allocate(Ucffs,1,nrows,1,ncols,0,deg);
    Standard_Complex_VecVecVecs.Allocate(Pcffs,1,nrows,1,ncols,0,deg);
    put_line("Computing a plain LU factorization ...");
    Plain_LU_Factorization
      (nrows,ncols,deg,Alead,Acffs,Llead,Lcffs,Ulead,Ucffs);
    put_line("Computing the product of L with U ...");
    Matrix_Matrix_Product
      (nrows,ncols,deg,Llead,Lcffs,Ulead,Ucffs,Plead,Pcffs);
    Write(Llead,Lcffs,"L");
    Write(Ulead,Ucffs,"U");
    Write(Plead,Pcffs,"P");
    Write(Alead,Acffs,"A");
    Write_Difference(deg,Alead,Acffs,Plead,Pcffs);
  end Test_Plain_LU_Factorization;

  procedure Lower_Triangular_Part
              ( nrows,ncols,deg : in integer32;
                Alead : in Standard_Integer_Matrices.Matrix;
                Acffs : in Standard_Complex_VecVecVecs.Link_to_VecVecVec;
                Llead : out Standard_Integer_Matrices.Matrix;
                Lcffs : out Standard_Complex_VecVecVecs.Link_to_VecVecVec ) is

  -- DESCRIPTION :
  --   Returns the lower triangular part of A, with ones on the diagonal.

  -- ON ENTRY :
  --   nrows    number of rows of the test matrix;
  --   ncols    number of columns of the test matrix;
  --   deg      degree of the series in the matrix;
  --   Alead    leading exponents of the series;
  --   Acffs    coefficients of the series in the matrix.

  -- ON RETURN :
  --   Llead    leading exponents of the lower triangular part of A;
  --   Lcffs    coefficients of the series in the lower triangular part.

    Lrow,Arow : Standard_Complex_VecVecs.Link_to_VecVec;
    Lcff,Acff : Standard_Complex_Vectors.Link_to_Vector;

  begin
    for i in 1..nrows loop
      Lrow := Lcffs(i);
      Arow := Acffs(i);
      for j in 1..(i-1) loop
        Llead(i,j) := Alead(i,j);
        Lcff := Lrow(j);
        Acff := Arow(j);
        for k in 0..deg loop
          Lcff(k) := Acff(k);
        end loop;
      end loop;
      Llead(i,i) := 0;
      Lcff := Lrow(i);
      Lcff(0) := Standard_Complex_Numbers.Create(1.0);
      for k in 1..deg loop
        Lcff(k) := Standard_Complex_Numbers.Create(0.0);
      end loop;
      for j in (i+1)..ncols loop
        Llead(i,j) := 0;
        Lcff := Lrow(j);
        for k in 0..deg loop
          Lcff(k) := Standard_Complex_Numbers.Create(0.0);
        end loop;
      end loop;
    end loop;
  end Lower_Triangular_Part;

  procedure Upper_Triangular_Part
              ( nrows,ncols,deg : in integer32;
                Alead : in Standard_Integer_Matrices.Matrix;
                Acffs : in Standard_Complex_VecVecVecs.Link_to_VecVecVec;
                Ulead : out Standard_Integer_Matrices.Matrix;
                Ucffs : out Standard_Complex_VecVecVecs.Link_to_VecVecVec ) is

  -- DESCRIPTION :
  --   Returns the upper triangular part of A,
  --   which includes the diagonal.

  -- ON ENTRY :
  --   nrows    number of rows of the test matrix;
  --   ncols    number of columns of the test matrix;
  --   deg      degree of the series in the matrix;
  --   Alead    leading exponents of the series;
  --   Acffs    coefficients of the series in the matrix.

  -- ON RETURN :
  --   Ulead    leading exponents of the upper triangular part of A;
  --   Ucffs    coefficients of the series in the upper triangular part.

    Urow,Arow : Standard_Complex_VecVecs.Link_to_VecVec;
    Ucff,Acff : Standard_Complex_Vectors.Link_to_Vector;

  begin
    for i in 1..nrows loop
      Urow := Ucffs(i);
      for j in 1..(i-1) loop
        Ulead(i,j) := 0;
        Ucff := Urow(j);
        for k in 0..deg loop
          Ucff(k) := Standard_Complex_Numbers.Create(0.0);
        end loop;
      end loop;
      Arow := Acffs(i);
      for j in i..ncols loop
        Ulead(i,j) := Alead(i,j);
        Ucff := Urow(j);
        Acff := Arow(j);
        for k in 0..deg loop
          Ucff(k) := Acff(k);
        end loop;
      end loop;
    end loop;
  end Upper_Triangular_Part;

  procedure Permute
              ( nrows,ncols,deg : in integer32;
                Alead : in Standard_Integer_Matrices.Matrix;
                Acffs : in Standard_Complex_VecVecVecs.Link_to_VecVecVec;
                pivots : in Standard_Integer_Vectors.Vector;
                Blead : out Standard_Integer_Matrices.Matrix;
                Bcffs : out Standard_Complex_VecVecVecs.Link_to_VecVecVec ) is

  -- DESCRIPTION :
  --   Returns in B the pivoting applied to A.

  -- ON ENTRY :
  --   nrows    number of rows of the test matrix;
  --   ncols    number of columns of the test matrix;
  --   deg      degree of the series in the matrix;
  --   Alead    leading exponents of the series;
  --   Acffs    coefficients of the series in the matrix;
  --   pivots   pivots computed by the LU factorization.

  -- ON RETURN :
  --   Blead    leading exponents of the permuted matrix;
  --   Bcffs    coefficients of the matrix A, permuted with pivots.

    Arow,Brow : Standard_Complex_VecVecs.Link_to_VecVec;
    Acff,Bcff : Standard_Complex_Vectors.Link_to_Vector;

  begin
    for i in 1..nrows loop
      Arow := Acffs(pivots(i));
      Brow := Bcffs(i);
      for j in 1..ncols loop
        Acff := Arow(j);
        Bcff := Brow(j);
        for k in 0..deg loop
          Bcff(k) := Acff(k);
        end loop;
        Blead(i,j) := Alead(pivots(i),j);
      end loop;
    end loop;
  end Permute;

  procedure Test_LU_Factorization
              ( nrows,ncols,deg : in integer32;
                Alead : in out Standard_Integer_Matrices.Matrix;
                Acffs : in Standard_Complex_VecVecVecs.Link_to_VecVecVec ) is

  -- DESCRIPTION :
  --   Tests the LU factorization with pivoting.

  -- ON ENTRY :
  --   nrows    number of rows of the test matrix;
  --   ncols    number of columns of the test matrix;
  --   deg      degree of the series in the matrix;
  --   Alead    leading exponents of the series;
  --   Acffs    coefficients of the series in the matrix.

    Llead,Ulead,Plead : Standard_Integer_Matrices.Matrix(1..nrows,1..ncols);
    Lcffs,Ucffs,Pcffs : Standard_Complex_VecVecVecs.Link_to_VecVecVec;
    pivots : Standard_Integer_Vectors.Vector(1..ncols);
    Blead : Standard_Integer_Matrices.Matrix(1..nrows,1..ncols);
    Bcffs : Standard_Complex_VecVecVecs.Link_to_VecVecVec;

  begin
    Standard_Complex_VecVecVecs.Allocate(Lcffs,1,nrows,1,ncols,0,deg);
    Standard_Complex_VecVecVecs.Allocate(Ucffs,1,nrows,1,ncols,0,deg);
    Standard_Complex_VecVecVecs.Allocate(Pcffs,1,nrows,1,ncols,0,deg);
    Standard_Complex_VecVecVecs.Allocate(Bcffs,1,nrows,1,ncols,0,deg);
    put_line("Computing a LU factorization ...");
    LU_Factorization(nrows,ncols,deg,Alead,Acffs,pivots);
    Lower_Triangular_Part(nrows,ncols,deg,Alead,Acffs,Llead,Lcffs);
    Upper_Triangular_Part(nrows,ncols,deg,Alead,Acffs,Ulead,Ucffs);
    put_line("Computing the product of L with U ...");
    Matrix_Matrix_Product
      (nrows,ncols,deg,Llead,Lcffs,Ulead,Ucffs,Plead,Pcffs);
    Write(Llead,Lcffs,"L");
    Write(Ulead,Ucffs,"U");
    Write(Plead,Pcffs,"P");
    put("The pivots : "); put(pivots); new_line;
    Permute(nrows,ncols,deg,Alead,Acffs,pivots,Blead,Bcffs);
    Write(Blead,Bcffs,"permutedA");
    Write_Difference(deg,Blead,Bcffs,Plead,Pcffs);
  end Test_LU_Factorization;

  procedure Test ( nrows,ncols,deg,low,upp : in integer32;
                   lower,upper : in boolean ) is

  -- DESCRIPTION :
  --   Generates a random linear system and runs a test.

  -- ON ENTRY :
  --   nrows    number of rows of the test matrix;
  --   ncols    number of columns of the test matrix;
  --   deg      degree of the series in the matrix;
  --   low      lower bound for the leading exponents;
  --   upp      upper bound for the leading exponents;
  --   lower    true if the test matrix is lower triangular;
  --   upper    true if the test matrix is upper triangular.

    nbrows : constant natural32 := natural32(nrows);
    nbcols : constant natural32 := natural32(ncols);
    Alead : Standard_Integer_Matrices.Matrix(1..nrows,1..ncols);
    xlead : Standard_Integer_Vectors.Vector(1..ncols);
    Acffs : Standard_Complex_VecVecVecs.Link_to_VecVecVec;
    xcffs,ycffs : Standard_Complex_VecVecs.Link_to_VecVec;
    ylead : Standard_Integer_Vectors.Vector(1..ncols);
    blead : Standard_Integer_Vectors.Vector(1..nrows);
    bcffs : Standard_Complex_VecVecs.Link_to_VecVec;
    ans : character;

  begin
    Standard_Complex_VecVecVecs.Allocate(Acffs,1,nrows,1,ncols,0,deg);
    if not lower and not upper then
      Random_Matrix(nbrows,nbcols,low,upp,Alead,Acffs);
    elsif lower then
      Random_Lower_Matrix(nbrows,nbcols,low,upp,Alead,Acffs);
    else -- upper must be true
      Random_Upper_Matrix(nbrows,nbcols,low,upp,Alead,Acffs);
    end if;
    put_line("The matrix of leading exponents :"); put(Alead,1);
    put("A "); put(nrows,1); put("-by-"); put(ncols,1);
    put_line(" matrix of Laurent series : "); Write(Alead,Acffs);
    Random_Vector(ncols,deg,low,upp,xlead,xcffs);
    put("The vector of leading exponents :"); put(xlead,1); new_line;
    put("A "); put(ncols,1); put_line("-vector of Laurent series :");
    Write(xlead,xcffs,"x");
    Allocate_Series_Coefficients(nrows,deg,bcffs);
    Matrix_Vector_Product(deg,Alead,Acffs,xlead,xcffs,blead,bcffs);
    put_line("The product of the matrix with the vector :");
    Write(blead,bcffs,"b");
    Allocate_Series_Coefficients(ncols,deg,ycffs);
    if lower then
      Forward_Substitution(deg,Alead,Acffs,blead,bcffs,ylead,ycffs);
      put_line("The computed solution :");
      Write(ylead,ycffs,"y");
    elsif upper then
      Backward_Substitution(deg,Alead,Acffs,blead,bcffs,ylead,ycffs);
      put_line("The computed solution :");
      Write(ylead,ycffs,"y");
    else
      new_line;
      put("Apply pivoting in the LU factorization ? ");
      Ask_Yes_or_No(ans);
      if ans = 'y'
       then Test_LU_Factorization(nrows,ncols,deg,Alead,Acffs);
       else Test_Plain_LU_Factorization(nrows,ncols,deg,Alead,Acffs);
      end if;
    end if;
  end Test;

  procedure Main is

  -- DESCRIPTION :
  --   Prompts for the dimensions and then generates a random matrix.

    deg,nrows,ncols,low,upp,seed : integer32 := 0;
    ans : character;
    lower,upper : boolean;

  begin
    new_line;
    put("Give the truncation degree : "); get(deg);
    put("Give the lower bound on the leading exponent : "); get(low);
    put("Give the upper bound on the leading exponent : "); get(upp);
    put("Give the number of rows : "); get(nrows);
    put("Give the number of columns : "); get(ncols);
    new_line;
    if nrows /= ncols then
      lower := false;
    else
      put("Lower triangular matrix ? (y/n) "); Ask_Yes_or_No(ans);
      lower := (ans = 'y');
      if lower then
        upper := false;
      else
        put("Upper triangular matrix ? (y/n) "); Ask_Yes_or_No(ans);
        upper := (ans = 'y');
      end if;
    end if;
    new_line;
    put("Fixed seed ? (y/n) "); Ask_Yes_or_No(ans);
    if ans /= 'y' then
      seed := Standard_Random_Numbers.Get_Seed;
    else
      put("Give the seed : "); get(seed);
      Standard_Random_Numbers.Set_Seed(natural32(seed));
    end if;
    Test(nrows,ncols,deg,low,upp,lower,upper);
    new_line;
    put("The seed used : "); put(seed,1); new_line;
  end Main;

begin
  Main;
end ts_laurmat;
