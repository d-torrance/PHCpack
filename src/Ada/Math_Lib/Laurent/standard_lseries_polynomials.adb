with text_io;                           use text_io;
with Standard_Natural_Numbers;          use Standard_Natural_Numbers;
with Standard_Integer_Numbers_io;       use Standard_Integer_Numbers_io;
with Standard_Complex_Numbers;
with Standard_Integer_Vectors_io;       use Standard_Integer_Vectors_io;
with Standard_Random_Vectors;
with Symbol_Table;
with Standard_Laurent_Series;
with Random_Laurent_Series;             use Random_Laurent_Series;

package body Standard_Lseries_Polynomials is

  procedure Write ( plead : in Standard_Integer_Vectors.Vector;
                    pcffs : in Standard_Complex_VecVecs.Link_to_VecVec;
                    pmons : in Standard_Integer_VecVecs.VecVec;
                    s : in string := "p" ) is
  begin
    for k in plead'range loop
      put(s & "("); put(k,1); put(") :"); put(pmons(k)); new_line;
      Standard_Laurent_Series.Write(plead(k),pcffs(k).all);
    end loop;
  end Write;

  procedure Make_Random_Polynomial
              ( dim,nbr,deg,pwr,low,upp : in integer32;
                lead : out Standard_Integer_Vectors.Vector;
                cffs : out Standard_Complex_VecVecs.Link_to_VecVec;
                mons : out Standard_Integer_VecVecs.VecVec ) is
  begin
    for k in 1..nbr loop
      declare
        mon : constant Standard_Integer_Vectors.Vector(1..dim)
            := Standard_Random_Vectors.Random_Vector(1,dim,0,pwr);
      begin
        mons(k) := new Standard_Integer_Vectors.Vector'(mon);
      end;
    end loop;
    Random_Vector(nbr,deg,low,upp,lead,cffs);
  end Make_Random_Polynomial;

  procedure Eval ( deg,mlead : in integer32;
                   cff : in Standard_Complex_Vectors.Link_to_Vector;
                   mon : in Standard_Integer_Vectors.Link_to_Vector;
                   xlead : in Standard_Integer_Vectors.Vector;
                   xcffs : in Standard_Complex_VecVecs.Link_to_VecVec;
                   ye : out integer32;
                   yc : out Standard_Complex_Vectors.Vector ) is

    ze : integer32;
    zc : Standard_Complex_Vectors.Vector(0..deg);

  begin
    ye := mlead;
    for k in 0..deg loop -- initialize result with monomial coefficient
      yc(k) := cff(k);
    end loop;
    for i in mon'range loop -- mon(i) is the power of the i-th variable
      if mon(i) > 0 then
        ye := ye + xlead(i)*mon(i);
        for j in 1..mon(i) loop
          Standard_Laurent_Series.Multiply
            (deg,ye,xlead(i),yc,xcffs(i).all,ze,zc);
          ye := ze;
          for k in 0..deg loop
            yc(k) := zc(k);
          end loop;
        end loop;
      end if;
    end loop;
  end Eval;

  procedure Eval ( deg : in integer32;
                   plead : in Standard_Integer_Vectors.Vector;
                   pcffs : in Standard_Complex_VecVecs.Link_to_VecVec;
                   pmons : in Standard_Integer_VecVecs.VecVec;
                   xlead : in Standard_Integer_Vectors.Vector;
                   xcffs : in Standard_Complex_VecVecs.Link_to_VecVec;
                   ye : out integer32;
                   yc : out Standard_Complex_Vectors.Vector ) is

    ze,ewrk : integer32;
    zc,cwrk : Standard_Complex_Vectors.Vector(0..deg);

  begin
    Eval(deg,plead(1),pcffs(1),pmons(1),xlead,xcffs,ye,yc);
    for i in 2..plead'last loop
      Eval(deg,plead(i),pcffs(i),pmons(i),xlead,xcffs,ze,zc);
      Standard_Laurent_Series.Add(deg,ye,ze,yc,zc,ewrk,cwrk);
      ye := ewrk;
      for k in 0..deg loop
        yc(k) := cwrk(k);
      end loop;
    end loop;
  end Eval;

  function tsymbol_index return integer32 is

    res : integer32 := 0;
    nbr : constant natural32 := Symbol_Table.Number;

  begin
    for k in 1..nbr loop
      declare
        sb : constant Symbol_Table.Symbol := Symbol_Table.get(k);
      begin
        if sb(1) = 't'
         then res := integer32(k); exit;
        end if;
      end;
    end loop;
    return res;
  end tsymbol_index;

  function Index_of_Degrees
             ( mons : Standard_Integer_VecVecs.VecVec;
               idx : integer32;
               degs : Standard_Integer_Vectors.Vector ) return integer32 is

    monexp : Standard_Integer_Vectors.Link_to_Vector;
    allequal : boolean;

  begin
    for k in mons'first..(idx-1) loop
      monexp := mons(k);
      allequal := true;
      for i in monexp'range loop
        allequal := (monexp(i) = degs(i));
        exit when not allequal;
      end loop;
      if allequal
       then return k;
      end if;
    end loop;
    return idx;
  end Index_of_Degrees;

  function Minimum_Laurent_Series_Degree
             ( p : Poly; tdx : integer32 ) return integer32 is

    maxdegt : constant integer32 := Maximal_Degree(p,tdx);
    mindegt : constant integer32 := Minimal_Degree(p,tdx);

  begin
    return (maxdegt - mindegt - 1);
  end Minimum_Laurent_Series_Degree;

  function Minimum_Laurent_Series_Degree
             ( p : Laur_Sys; tdx : integer32 ) return integer32 is

    res : integer32 := Minimum_Laurent_Series_Degree(p(p'first),tdx);
    deg : integer32;

  begin
    for k in p'first+1..p'last loop
      deg := Minimum_Laurent_Series_Degree(p(k),tdx);
      if deg > res
       then res := deg;
      end if;
    end loop;
    return res;
  end Minimum_Laurent_Series_Degree;

  procedure Make_Series_Polynomial
              ( p : in Poly; dim,nvr,tdx,deg : in integer32;
                lead : out Standard_Integer_Vectors.Link_to_Vector;
                cffs : out Standard_Complex_VecVecs.Link_to_VecVec;
                mons : out Standard_Integer_VecVecs.Link_to_VecVec ) is

    nbr : constant integer32 := integer32(Number_of_Terms(p));
    plead : Standard_Integer_Vectors.Vector(1..nbr);
    wcffs : Standard_Complex_VecVecs.VecVec(1..nbr);
    pmons : Standard_Integer_VecVecs.VecVec(1..nbr);
    cnt : integer32 := 0;

    procedure Visit_Term ( t : in Term; continue : out boolean ) is

    -- DESCRIPTION :
    --   If tdx is zero, then the monomial is just copied,
    --   otherwise the terms in the Laurent series need to be
    --   collected from the expanded form.

      mon : Standard_Integer_Vectors.Vector(1..nvr);
      cff : Standard_Complex_Vectors.Vector(0..deg);
      located,newlead,gap : integer32;
      cfflocated : Standard_Complex_Vectors.Link_to_Vector;

    begin
      cnt := cnt + 1; 
      if tdx = 0 then          -- constant Laurent series
        plead(cnt) := 0;
        for k in 1..dim loop
          mon(k) := integer32(t.dg(k));
        end loop;
        pmons(cnt) := new Standard_Integer_Vectors.Vector'(mon);
        cff(0) := t.cf;
        for k in 1..deg loop
          cff(k) := Standard_Complex_Numbers.Create(0.0);
        end loop;
        wcffs(cnt) := new Standard_Complex_Vectors.Vector'(cff);
      else
        for k in 1..(tdx-1) loop
          mon(k) := integer32(t.dg(k));
        end loop;
        for k in (tdx+1)..dim loop
          mon(k-1) := integer32(t.dg(k));
        end loop;
        located := Index_of_Degrees(pmons,cnt,mon);
        if located = cnt then                        --  a new monomial
          plead(cnt) := integer32(t.dg(tdx));
          pmons(cnt) := new Standard_Integer_Vectors.Vector'(mon);
          cff(0) := t.cf;
          for k in 1..deg loop
            cff(k) := Standard_Complex_Numbers.Create(0.0);
          end loop;
          wcffs(cnt) := new Standard_Complex_Vectors.Vector'(cff);
        else
          cnt := cnt-1;                              -- no new monomial
          newlead := integer32(t.dg(tdx));
          cfflocated := wcffs(located);            -- fit in new t-term
          if newlead = plead(located) then
            Standard_Complex_Numbers.Add(cfflocated(0),t.cf);
          elsif newlead > plead(located) then
            gap := newlead - plead(located);   -- keep leading exponent
            if gap <= deg then
              Standard_Complex_Numbers.Add(cfflocated(gap),t.cf);
            -- else the new coefficient will be ignored ...
            end if;
          else -- newlead < plead(located) 
            gap := plead(located) - newlead; -- leading exponent changes!
            for k in reverse 0..deg-gap loop        -- shift coefficients
              cfflocated(gap+k) := cfflocated(k);
            end loop;
            for k in 1..(gap-1) loop
              cfflocated(k) := Standard_Complex_Numbers.Create(0.0);
            end loop;
            cfflocated(0) := t.cf;
            plead(located) := newlead;
          end if;
        end if;
      end if;
      continue := true;
    end Visit_Term;
    procedure Visit_Terms is new Visiting_Iterator(Visit_Term);

  begin
    Visit_Terms(p);
    lead := new Standard_Integer_Vectors.Vector'(plead(1..cnt));
    cffs := new Standard_Complex_VecVecs.VecVec'(wcffs(1..cnt));
    mons := new Standard_Integer_VecVecs.VecVec'(pmons(1..cnt));
  end Make_Series_Polynomial;

  procedure Make_Series_System
              ( p : in Laur_Sys; dim,nvr,tdx,deg : in integer32;
                lead : out Standard_Integer_VecVecs.VecVec;
                cffs : out Standard_Complex_VecVecs.Array_of_VecVecs;
                mons : out Standard_Integer_VecVecs.Array_of_VecVecs ) is
  begin
    for k in p'range loop
      Make_Series_Polynomial(p(k),dim,nvr,tdx,deg,lead(k),cffs(k),mons(k));
    end loop;
  end Make_Series_System;

end Standard_Lseries_Polynomials;
