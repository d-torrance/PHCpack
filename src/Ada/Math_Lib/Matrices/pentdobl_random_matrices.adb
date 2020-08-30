with Standard_Integer_Numbers;           use Standard_Integer_Numbers;
with PentDobl_Random_Numbers;

package body PentDobl_Random_Matrices is

  function Random_Matrix ( n,m : natural32 )
                         return Penta_Double_Matrices.Matrix is

    res : Penta_Double_Matrices.Matrix(1..integer32(n),1..integer32(m));

  begin
    for i in res'range(1) loop
      for j in res'range(2) loop
        res(i,j) := PentDobl_Random_Numbers.Random;
      end loop;
    end loop;
    return res;
  end Random_Matrix;

  function Random_Matrix ( n,m : natural32 )
                         return PentDobl_Complex_Matrices.Matrix is

    res : PentDobl_Complex_Matrices.Matrix(1..integer32(n),1..integer32(m));

  begin
    for i in res'range(1) loop
      for j in res'range(2) loop
        res(i,j) := PentDobl_Random_Numbers.Random;
      end loop;
    end loop;
    return res;
  end Random_Matrix;

end PentDobl_Random_Matrices;
