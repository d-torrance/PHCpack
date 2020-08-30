with text_io;                            use text_io;
with Communications_with_User;           use Communications_with_User;
with Standard_Natural_Numbers;           use Standard_Natural_Numbers;
with Standard_Natural_Numbers_io;        use Standard_Natural_Numbers_io;
with Standard_Integer_Numbers;           use Standard_Integer_Numbers;
with Standard_Floating_Matrices;
with Standard_Floating_Matrices_io;
with Standard_Floating_VecMats;
with Standard_Floating_VecMats_io;
with Multprec_Floating_Matrices;
with Multprec_Floating_Matrices_io;

package body Test_Floating_Matrices is

  procedure Test_Standard_io is

    use Standard_Floating_Matrices;
    use Standard_Floating_Matrices_io;

    n,m : natural32 := 0;

  begin
    put("Give the number of rows : "); get(n);
    put("Give the number of columns : "); get(m);
    declare
      mat : Matrix(1..integer32(n),1..integer32(m));
    begin
      put("Give "); put(n,1); put("x"); put(m,1);
      put_line(" floating matrix : "); get(mat);
      put_line("Your matrix : "); put(mat); new_line;
    end;
  end Test_Standard_io;

  procedure Test_Standard_VecMat_io is

    use Standard_Floating_VecMats;
    use Standard_Floating_VecMats_io;

    n,n1,n2 : natural32 := 0;
    lv : Link_to_VecMat;

  begin
    put("Give the number of matrices : "); get(n);
    put("Give #rows : "); get(n1);
    put("Give #columns : "); get(n2);
    put("Give "); put(n,1); put(" "); put(n1,1); put("-by-"); put(n2,1);
    put_line(" floating matrices : ");
    get(n,n1,n2,lv);
    put_line("The vector of matrices :"); put(lv);
  end Test_Standard_VecMat_io;

  procedure Test_Multprec_io is

    use Multprec_Floating_Matrices;
    use Multprec_Floating_Matrices_io;

    n,m : natural32 := 0;

  begin
    put("Give the number of rows : "); get(n);
    put("Give the number of columns : "); get(m);
    declare
      mat : Matrix(1..integer32(n),1..integer32(m));
    begin
      put("Give "); put(n,1); put("x"); put(m,1);
      put_line(" floating matrix : "); get(mat);
      put_line("Your matrix : "); put(mat); new_line;
    end;
  end Test_Multprec_io;

  procedure Main is

    ans : character;

  begin
    new_line;
    put_line("Interactive testing of matrices of floating numbers");
    loop
      new_line;
      put_line("Choose one of the following : ");
      put_line("  0. exit this program.");
      put_line("  1. io of matrices of standard numbers.");
      put_line("  2. io of vectors of matrices of standard numbers.");
      put_line("  3. io of matrices of multi-precision numbers.");
      put("Enter 0, 1, 2, or 3 to make your choice : ");
      Ask_Alternative(ans,"0123");
      exit when ans = '0';
      case ans is
        when '1' => Test_Standard_io;
        when '2' => Test_Standard_VecMat_io;
        when '3' => Test_Multprec_io;
        when others => null;
      end case;
    end loop;
  end Main;

end Test_Floating_Matrices;
