with text_io;                           use text_io;
with Interfaces.C;
with Standard_Natural_Numbers;          use Standard_Natural_Numbers;
with Standard_Natural_Vectors;
with Symbol_Table;
with DoblDobl_Complex_Polynomials;
with DoblDobl_Complex_Poly_Systems;
with DoblDobl_Complex_Poly_Systems_io;  use DoblDobl_Complex_Poly_Systems_io;
with Assignments_in_Ada_and_C;          use Assignments_in_Ada_and_C;
with PHCpack_Operations;
with DoblDobl_PolySys_Container;

package body DoblDobl_PolySys_Interface is

  function DoblDobl_PolySys_Read
             ( vrblvl : integer32 := 0 ) return integer32 is

    lp : DoblDobl_Complex_Poly_Systems.Link_to_Poly_Sys;

  begin
    if vrblvl > 0 then
      put_line("-> in DoblDobl_PolySys_Interface.DoblDobl_PolySys_Read ...");
    end if;
    new_line;
    put_line("Reading a polynomial system ...");
    get(lp);
    DoblDobl_PolySys_Container.Initialize(lp.all);
    return 0;
  exception
    when others => 
      if vrblvl > 0 then
        put("Exception raised in DoblDobl_PolySys_Interface.");
        put_line("DoblDobl_PolySys_Read.");
      end if;
      return 200;
  end DoblDobl_PolySys_Read;

  function DoblDobl_PolySys_Read_from_File
             ( a : C_intarrs.Pointer;
               b : C_intarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32 is

    v_a : constant C_Integer_Array
        := C_intarrs.Value(a,Interfaces.C.ptrdiff_t(1));
    nc : constant natural := natural(v_a(v_a'first));
    vb : constant C_Integer_Array(0..Interfaces.C.size_t(nc))
       := C_Intarrs.Value(b,Interfaces.C.ptrdiff_t(nc+1));
    sv : constant String(1..nc) := C_Integer_Array_to_String(natural32(nc),vb);

  begin
    if vrblvl > 0 then
      put("-> in DoblDobl_PolySys_Interface.");
      put_line("DoblDobl_PolySys_Read_from_File ...");
    end if;
   -- new_line;
   -- put_line("Opening the file with name " & sv & " ...");
    declare
      file : file_type;
      p : DoblDobl_Complex_Poly_Systems.Link_to_Poly_Sys;
    begin
      Open(file,in_file,sv);
      get(file,p);
      DoblDobl_PolySys_Container.Clear;
      DoblDobl_PolySys_Container.Initialize(p.all);
      exception 
        when NAME_ERROR =>
          put_line("File with name " & sv & " could not be found!");
          return 541;
        when USE_ERROR =>
          put_line("File with name " & sv & " could not be read!");
          return 541;
    end;
    return 0;
  exception
    when others => 
      if vrblvl > 0 then
        put("Exception raised in DoblDobl_PolySys_Interface.");
        put_line("DoblDobl_PolySys_Read_from_File.");
      end if;
      return 541;
  end DoblDobl_PolySys_Read_from_File;

  function DoblDobl_PolySys_Write
             ( vrblvl : in integer32 := 0 ) return integer32 is

    use DoblDobl_Complex_Polynomials;
    use DoblDobl_Complex_Poly_Systems;

    lp : constant Link_to_Poly_Sys := DoblDobl_PolySys_Container.Retrieve;
    nvr : natural32;

  begin
    if vrblvl > 0 then
      put_line("-> in DoblDobl_PolySys_Interface.DoblDobl_PolySys_Write ...");
    end if;
    if lp /= null then
      nvr := Number_of_Unknowns(lp(lp'first));
      if PHCpack_Operations.file_okay then
        if integer32(nvr) = lp'last then
          put(PHCpack_Operations.output_file,natural32(lp'last),lp.all);
        else
          put(PHCpack_Operations.output_file,natural32(lp'last),nvr,lp.all);
        end if;
      elsif integer32(nvr) = lp'last then
        put(standard_output,natural32(lp'last),lp.all);
      else
        put(standard_output,natural32(lp'last),nvr,lp.all);
      end if;
    end if;
    return 0;
  exception
    when others => 
      if vrblvl > 0 then
        put("Exception raised in DoblDobl_PolySys_Interface.");
        put_line("DoblDobl_PolySys_Write.");
      end if;
      return 201;
  end DoblDobl_PolySys_Write;

  function DoblDobl_PolySys_Get_Dimension
             ( a : C_intarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32 is
  begin
    if vrblvl > 0 then
      put("-> in DoblDobl_PolySys_Interface.");
      put_line("DoblDobl_PolySys_Get_Dimension ...");
    end if;
    Assign(integer32(DoblDobl_PolySys_Container.Dimension),a);
    return 0;
  exception
    when others => 
      if vrblvl > 0 then
        put("Exception raised in DoblDobl_PolySys_Interface.");
        put_line("DoblDobl_PolySys_Get_Dimension.");
      end if;
      return 202;
  end DoblDobl_PolySys_Get_Dimension;

  function DoblDobl_PolySys_Set_Dimension
             ( a : C_intarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32 is

    v : constant C_Integer_Array
      := C_intarrs.Value(a,Interfaces.C.ptrdiff_t(1));
    n : constant integer32 := integer32(v(v'first));

  begin
    if vrblvl > 0 then
      put("-> in DoblDobl_PolySys_Interface.");
      put_line("DoblDobl_PolySys_Set_Dimension ...");
    end if;
    DoblDobl_PolySys_Container.Initialize(n);
    Symbol_Table.Init(natural32(n));
    return 0;
  exception
    when others => 
      if vrblvl > 0 then
        put("Exception raised in DoblDobl_PolySys_Interface.");
        put_line("DoblDobl_PolySys_Set_Dimension.");
      end if;
      return 203;
  end DoblDobl_PolySys_Set_Dimension;

  function DoblDobl_PolySys_Size
             ( a : C_intarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32 is

    use Interfaces.C;

    v : constant C_Integer_Array
      := C_intarrs.Value(a,Interfaces.C.ptrdiff_t(2));
    i : constant integer32 := integer32(v(v'first+1));

  begin
    if vrblvl > 0 then
      put_line("-> in DoblDobl_PolySys_Interface.DoblDobl_PolySys_Size ...");
    end if;
    Assign(integer32(DoblDobl_PolySys_Container.Number_of_Terms(i)),a);
    return 0;
  exception
    when others => 
      if vrblvl > 0 then
        put("Exception raised in DoblDobl_PolySys_Interface.");
        put_line("DoblDobl_PolySys_Size");
      end if;
      return 204;
  end DoblDobl_PolySys_Size;

  function DoblDobl_PolySys_Degree
             ( a : C_intarrs.Pointer;
               b : C_intarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32 is

    v_a : constant C_Integer_Array
        := C_intarrs.Value(a,Interfaces.C.ptrdiff_t(1));
    equ : constant integer32 := integer32(v_a(v_a'first));
    deg : constant integer32 := DoblDobl_PolySys_Container.Degree(equ);

  begin
    if vrblvl > 0 then
      put_line("-> in dobldobl_polysys_interface.DoblDobl_PolySys_Degree ...");
    end if;
    Assign(deg,b);
    return 0;
  exception
    when others => 
      if vrblvl > 0 then
        put("Exception raised in dobldobl_polysys_interface.");
        put_line("DoblDobl_PolySys_Degree");
      end if;
      return 209;
  end DoblDobl_PolySys_Degree;

  function DoblDobl_PolySys_Get_Term
             ( a : C_intarrs.Pointer;
               b : C_intarrs.Pointer;
               c : C_dblarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32 is

    v : constant C_Integer_Array(0..2)
      := C_intarrs.Value(a,Interfaces.C.ptrdiff_t(3));
    i : constant integer32 := integer32(v(1));
    j : constant natural32 := natural32(v(2));
    t : constant DoblDobl_Complex_Polynomials.Term
      := DoblDobl_PolySys_Container.Retrieve_Term(i,j);

  begin
    if vrblvl > 0 then
      put("-> in DoblDobl_PolySys_Interface.");
      put_line("DoblDobl_PolySys_Get_Term ...");
    end if;
    Assign(t.cf,c);
    Assign(t.dg.all,b);
    return 0;
  exception
    when others => 
      if vrblvl > 0 then
        put("Exception raised in DoblDobl_PolySys_Interface.");
        put_line("DoblDobl_PolySys_Get_Term");
      end if;
      return 205;
  end DoblDobl_PolySys_Get_Term;

  function DoblDobl_PolySys_Add_Term
             ( a : C_intarrs.Pointer;
               b : C_intarrs.Pointer;
               c : C_dblarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32 is

    v : constant C_Integer_Array(0..1)
      := C_intarrs.Value(a,Interfaces.C.ptrdiff_t(2));
    n : constant integer32 := integer32(v(0));
    i : constant integer32 := integer32(v(1));
    e : Standard_Natural_Vectors.Vector(1..n);
    t : DoblDobl_Complex_Polynomials.Term;

  begin
    if vrblvl > 0 then
      put("-> in DoblDobl_PolySys_Interface.");
      put_line("DoblDobl_PolySys_Add_Term ...");
    end if;
    Assign(c,t.cf);
    Assign(natural32(n),b,e);
    t.dg := new Standard_Natural_Vectors.Vector'(e);
    DoblDobl_PolySys_Container.Add_Term(i,t);
    return 0;
  exception
    when others => 
      if vrblvl > 0 then
        put("Exception raised in DoblDobl_PolySys_Interface.");
        put_line("DoblDobl_PolySys_Add_Term");
      end if;
      return 206;
  end DoblDobl_PolySys_Add_Term;

  function DoblDobl_PolySys_Clear
             ( vrblvl : integer32 := 0 ) return integer32 is
  begin
    if vrblvl > 0 then
      put_line("-> in DoblDobl_PolySys_Interface.DoblDobl_PolySys_Clear ...");
    end if;
    DoblDobl_PolySys_Container.Clear;
    return 0;
  exception
    when others => 
      if vrblvl > 0 then
        put("Exception raised in DoblDobl_PolySys_Interface.");
        put_line("DoblDobl_PolySys_Clear.");
      end if;
      return 207;
  end DoblDobl_PolySys_Clear;

end DoblDobl_PolySys_Interface;