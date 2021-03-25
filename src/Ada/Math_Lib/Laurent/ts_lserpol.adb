with text_io;                           use text_io;
with Communications_with_User;          use Communications_with_User;
with Standard_Integer_Numbers;          use Standard_Integer_Numbers;
with Standard_Integer_Numbers_io;       use Standard_Integer_Numbers_io;
with Standard_Integer_Vectors;
with Standard_Integer_VecVecs;
with Standard_Complex_Vectors;
with Standard_Complex_VecVecs;
with Symbol_Table_io;
with Standard_Complex_Laurentials;      use Standard_Complex_Laurentials;
with Standard_Complex_Laurentials_io;   use Standard_Complex_Laurentials_io;
with Standard_Complex_Laur_Systems;     use Standard_Complex_Laur_Systems;
with Standard_Complex_Laur_Systems_io;  use Standard_Complex_Laur_Systems_io;
with Standard_Complex_Laur_JacoMats;    use Standard_Complex_Laur_JacoMats;
with Standard_Laurent_Series;
with Random_Laurent_Series;             use Random_Laurent_Series;
with Test_Standard_Lseries_Matrices;
with Standard_Lseries_Polynomials;      use Standard_Lseries_Polynomials;

procedure ts_lserpol is

-- DESCRIPTION :
--   Development of the evaluation and differentiation of a polynomial
--   at a sequence of Laurent series.

  procedure Test ( dim,nbr,deg,pwr,low,upp : in integer32 ) is

  -- DESCRIPTION :
  --   Generates random data and runs tests.

  -- ON ENTRY :
  --   dim      the dimension is the number of variables;
  --   nbr      number of monomials in the polynomial;
  --   deg      degree of the series;
  --   pwr      largest power for every variable;
  --   low      lower bound on leading exponents of the series;
  --   upp      upper bound on leading exponents of the series.

    plead : Standard_Integer_Vectors.Vector(1..nbr);
    pcffs : Standard_Complex_VecVecs.Link_to_VecVec;
    pmons : Standard_Integer_VecVecs.VecVec(1..nbr);
    xlead : Standard_Integer_Vectors.Vector(1..dim);
    xcffs : Standard_Complex_VecVecs.Link_to_VecVec;
    ye : integer32;
    yc : Standard_Complex_Vectors.Vector(0..deg);

  begin
    Make_Random_Polynomial(dim,nbr,deg,pwr,low,upp,plead,pcffs,pmons);
    put_line("A random polynomial with Laurent series coefficients :");
    Write(plead,pcffs,pmons);
    Random_Vector(dim,deg,low,upp,xlead,xcffs);
    put_line("A random vector of Laurent series :");
    Test_Standard_Lseries_Matrices.Write(xlead,xcffs,"x");
    Eval(deg,plead,pcffs,pmons,xlead,xcffs,ye,yc);
    put_line("The result of the evaluation :");
    Standard_Laurent_Series.Write(ye,yc);
  end Test;

  procedure Set_Parameters
              ( p : in Link_to_Laur_Sys;
                neq,dim,tdx,deg : out integer32 ) is

  -- DESCRIPTION :
  --   Given a Laurent system, sets the characteristic parameters.

  -- ON RETURN :
  --   neq      number of equations;
  --   dim      number of variables;
  --   tdx      index of the symbol t for the series;
  --   deg      truncation degree of the series.

    ans : character;

  begin
    neq := p'last;
    dim := integer32(Number_of_Unknowns(p(p'first)));
    put("Read "); put(neq,1); put(" polynomials in "); put(dim,1);
    put(" variables :"); Symbol_Table_io.Write; new_line;
    if neq = dim then
      tdx := 0;
    else
      tdx := tsymbol_Index;
      put("-> index of t : "); put(tdx,1); new_line;
    end if;
    if tdx = 0 then
      deg := 0;
      new_line;
      put("Give the degree of the series : "); get(deg);
    else
      deg := Minimum_Laurent_Series_Degree(p.all,tdx);
      put("=> the proposed degree of the series : "); put(deg,1); new_line;
      put("Raise the proposed degree ? (y/n) ");
      Ask_Yes_or_No(ans);
      if ans = 'y' then
        new_line;
        put("Give the degree of the series : "); get(deg);
      end if;
    end if;
  end Set_Parameters;

  procedure Test_Input is

  -- DESCRIPTION :
  --   Prompts for a Laurent polynomial system and then constructs the data
  --   to evaluate the system at a vector of Laurent series.

    p : Link_to_Laur_Sys;
    neq,dim,tdx,deg : integer32 := 0;

  begin
    new_line;
    put_line("Reading a Laurent polynomial system ..."); get(p);
    new_line;
    put_line("-> your system :"); put(p.all);
    new_line;
    Set_Parameters(p,neq,dim,tdx,deg);
    new_line;
    declare
      plead : Standard_Integer_VecVecs.VecVec(p'range);
      pcffs : Standard_Complex_VecVecs.Array_of_VecVecs(p'range);
      pmons : Standard_Integer_VecVecs.Array_of_VecVecs(p'range);
    begin
      if tdx = 0
       then Make_Series_System(p.all,dim,dim,0,deg,plead,pcffs,pmons);
       else Make_Series_System(p.all,dim,dim-1,tdx,deg,plead,pcffs,pmons);
      end if;
      for k in p'range loop
        put("Polynomial "); put(k,1);
        put_line(" with Laurent series coefficients :");
        Write(plead(k).all,pcffs(k),pmons(k).all);
      end loop;
    end;
  end Test_Input;

  procedure Test_Jacobian is

  -- DESCRIPTION :
  --    Prompts for a Laurent polynomial and evaluates its Jacobian matrix.

    p : Link_to_Laur_Sys;
    neq,dim,tdx,deg,nvr : integer32 := 0;

  begin
    new_line;
    put_line("Reading a Laurent polynomial system ..."); get(p);
    new_line;
    put_line("-> your system :"); put(p.all);
    new_line;
    Set_Parameters(p,neq,dim,tdx,deg);
    if tdx = 0
     then nvr := dim;
     else nvr := dim-1;
    end if;
    new_line;
    declare
      tv : constant Table_Vector(neq)
         := Make_Table_Vector(p.all,dim,nvr,tdx,deg);
      jp : constant Jaco_Mat(1..neq,1..dim) := Create(p.all);
      tva : constant Table_Vector_Array(1..neq)
          := Make_Table_Vector_Array(jp,tdx,deg);
    begin
      put_line("The table representation :"); Write(tv);
      put_line("The symbolic Jacobian matrix :");
      for i in 1..neq loop
        for j in 1..dim loop
          put("J("); put(i,1); put(","); put(j,1); put_line(") :");
          put(jp(i,j)); new_line;
        end loop;
      end loop;
      put_line("The table representation of the Jacobian :"); Write(tva);
    end;
  end Test_Jacobian;

  procedure Main is

  -- DESCRIPTION :
  --   Prompts for the parameters of the tests and then runs tests.

    dim,nbr,deg,pwr,low,upp : integer32 := 0;
    ans : character;

  begin
    new_line;
    put("Test the Jacobian matrix ? (y/n) ");
    Ask_Yes_or_No(ans);
    if ans = 'y' then
      Test_Jacobian;
    else
      new_line;
      put("Generate a random polynomial ? (y/n) ");
      Ask_Yes_or_No(ans);
      if ans /= 'y' then
        Test_Input;
      else
        new_line;
        put("Give the number of variables : "); get(dim);
        put("Give the number of monomials : "); get(nbr);
        put("Give the degree of the series : "); get(deg);
        put("Give the largest power of the variables : "); get(pwr);
        put("Give the lower bound on the leading exponents : "); get(low);
        put("Give the upper bound on the leading exponents : "); get(upp);
        Test(dim,nbr,deg,pwr,low,upp);
      end if;
    end if;
  end Main;

begin
  Main;
end ts_lserpol;
