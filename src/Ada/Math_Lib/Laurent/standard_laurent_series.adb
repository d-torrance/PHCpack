with text_io;                           use text_io;
with Standard_Integer_Numbers_io;       use Standard_Integer_Numbers_io;
with Standard_Complex_Numbers;          use Standard_Complex_Numbers;
with Standard_Complex_Numbers_io;       use Standard_Complex_Numbers_io;

package body Standard_Laurent_Series is

  procedure Write ( e : in integer32;
                    c : in Standard_Complex_Vectors.Vector ) is
  begin
    for i in c'range loop
      if i > c'first
       then put(" + (");
       else put("   (");
      end if;
      put(c(i)); put(")*t^"); put(e+i,1); new_line;
    end loop;
  end Write;

  procedure Multiply ( d,xe,ye : in integer32;
                       xc,yc : in Standard_Complex_Vectors.Vector;
                       ze : out integer32;
                       zc : out Standard_Complex_Vectors.Vector ) is
  begin
    ze := xe + ye;
    for i in 0..d loop
       zc(i) := xc(0)*yc(i);
       for j in 1..i loop
         zc(i) := zc(i) + xc(j)*yc(i-j);
       end loop;
    end loop;
  end Multiply;

  procedure Inverse ( d,xe : in integer32;
                      xc : in Standard_Complex_Vectors.Vector;
                      ye : out integer32;
                      yc : out Standard_Complex_Vectors.Vector ) is
  begin
    ye := -xe;
    yc(0) := 1.0/xc(0);
    for i in 1..d loop
      yc(i) := -xc(1)*yc(i-1);
      for j in 2..i loop
        yc(i) := yc(i) - xc(j)*yc(i-j);
      end loop;
      yc(i) := yc(i)/xc(0);
    end loop;
  end Inverse;

  procedure Divide ( d,xe,ye : in integer32;
                     xc,yc : in Standard_Complex_Vectors.Vector;
                     ze : out integer32;
                     zc : out Standard_Complex_Vectors.Vector;
                     iyc : out Standard_Complex_Vectors.Vector ) is

    iye : integer32;

  begin
    Inverse(d,ye,yc,iye,iyc);
    Multiply(d,xe,iye,xc,iyc,ze,zc);
  end Divide;

  procedure Normalize ( d : in integer32; e : in out integer32;
                        c : in out Standard_Complex_Vectors.Vector;
                        tol : in double_float := 1.0E-15 ) is

    allzero : boolean := true;

  begin
    for i in 0..d loop
      if (AbsVal(c(0)) > tol)
       then allzero := false; exit;
      end if;
      e := e + 1;
      for k in 1..d-i loop -- shift the coefficients
        c(k-1) := c(k);
      end loop;
    end loop;
    if allzero
     then e := 0;
    end if;
  end Normalize;

  procedure Add ( d,xe,ye : in integer32;
                  xc,yc : in Standard_Complex_Vectors.Vector;
                  ze : out integer32;
                  zc : out Standard_Complex_Vectors.Vector;
                  tol : in double_float := 1.0E-15 ) is

    gap : integer32; -- gap between the leading coefficients

  begin
    if xe < ye then
      ze := xe;
      gap := abs(ye - xe);
      for i in 0..gap-1 loop
        exit when (i > zc'last);
        zc(i) := xc(i);
      end loop;
      for i in gap..d loop
        zc(i) := xc(i) + yc(i-gap);
      end loop;
    elsif xe > ye then
      ze := ye;
      gap := abs(xe - ye);
      for i in 0..gap-1 loop
        exit when (i > zc'last);
        zc(i) := yc(i);
      end loop;
      for i in gap..d loop
        zc(i) := yc(i) + xc(i-gap);
      end loop;
    else -- xe = ye
      ze := xe;
      for i in 0..d loop
        zc(i) := xc(i) + yc(i);
      end loop;
      Normalize(d,ze,zc,tol);
    end if;
  end Add;

  procedure Subtract ( d,xe,ye : in integer32;
                       xc,yc : in Standard_Complex_Vectors.Vector;
                       ze : out integer32;
                       zc : out Standard_Complex_Vectors.Vector;
                       tol : in double_float := 1.0E-15 ) is

    gap : integer32; -- gap between the leading coefficients

  begin
    if xe < ye then
      ze := xe;
      gap := abs(ye - xe);
      for i in 0..gap-1 loop
        exit when (i > zc'last);
        zc(i) := xc(i);
      end loop;
      for i in gap..d loop
        zc(i) := xc(i) - yc(i-gap);
      end loop;
    elsif xe > ye then
      ze := ye;
      gap := abs(xe - ye);
      for i in 0..gap-1 loop
        exit when (i > zc'last);
        zc(i) := -yc(i);
      end loop;
      for i in gap..d loop
        zc(i) := xc(i-gap) - yc(i);
      end loop;
    else -- xe = ye
      ze := xe;
      for i in 0..d loop
        zc(i) := xc(i) - yc(i);
      end loop;
      Normalize(d,ze,zc,tol);
    end if;
  end Subtract;

end Standard_Laurent_Series;