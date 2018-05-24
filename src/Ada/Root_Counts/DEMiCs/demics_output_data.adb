with text_io;
with Standard_Floating_Vectors;
with Lists_of_Floating_Vectors;
with Arrays_of_Floating_Vector_Lists;   use Arrays_of_Floating_Vector_Lists;

package body DEMiCs_Output_Data is

-- DATA STRUCTURES :

  lifting : Standard_Floating_VecVecs.Link_to_VecVec := null;
  first,last,cellptr : Lists_of_Strings.List;
  cells,cells_last,allcellptr : Mixed_Subdivision;
  dimension : integer32 := -1;
  mixture : Standard_Integer_Vectors.Link_to_Vector;
  setcellptr : boolean;

-- CONSTRUCTORS :

  procedure Initialize_Lifting
              ( crdsup : in Standard_Integer_Vectors.Vector ) is

    use Standard_Floating_VecVecs;

  begin
    if lifting /= null
     then Clear_Lifting;
    end if;
    lifting := new Standard_Floating_VecVecs.VecVec(crdsup'range);
    for i in crdsup'range loop
      declare
        zeros : Standard_Floating_Vectors.Vector(1..crdsup(i));
      begin
        zeros := (zeros'range => 0.0);
        lifting(i) := new Standard_Floating_Vectors.Vector'(zeros);
      end;
    end loop;
  end Initialize_Lifting;

  procedure Assign_Lifting 
              ( idxsup,idxpnt : in integer32; val : in double_float ) is
  begin
    lifting(idxsup)(idxpnt) := val;
  end Assign_Lifting;

  procedure Store_Dimension_and_Mixture
              ( dim : in integer32;
                mix : in Standard_Integer_Vectors.Link_to_Vector ) is
  begin
    dimension := dim;
    mixture := mix;
  end Store_Dimension_and_Mixture;

  procedure Allocate_Mixed_Cell is

    mic : Mixed_Cell;
    zeros : constant Standard_Floating_Vectors.Vector(1..dimension+1)
          := (1..dimension+1 => 0.0);
    last : Lists_of_Floating_Vectors.List;

  begin
    mic.nor := new Standard_Floating_Vectors.Vector'(1..dimension+1 => 0.0);
    mic.pts := new Array_of_Lists(mixture'range);
    for i in mic.pts'range loop
      last := mic.pts(i);
      for j in 1..mixture(i)+1 loop
        Lists_of_Floating_Vectors.Append(mic.pts(i),last,zeros);
      end loop; 
    end loop;
    mic.sub := null;
    Append(cells,cells_last,mic);
  end Allocate_Mixed_Cell;

  procedure Add_Cell_Indices ( strcell : in string ) is

    link2strcell : constant String_Splitters.Link_to_String
                 := new string'(strcell);
   -- start : constant boolean := Lists_of_Strings.Is_Null(first);

  begin
    Lists_of_Strings.Append(first,last,link2strcell);
   -- if start
   --  then cellptr := first;
   -- end if;
    if monitor
     then text_io.put_line(strcell);
    end if;
    if allocate 
     then Allocate_Mixed_Cell;
    end if;
  end Add_Cell_Indices;

  procedure Initialize_Cell_Indices_Pointer is
  begin
    cellptr := first;
  end Initialize_Cell_Indices_Pointer;

  procedure Initialize_Allocated_Cell_Pointer is
  begin
    allcellptr := cells;
  end Initialize_Allocated_Cell_Pointer;

-- SELECTORS :

  function Retrieve_Lifting
             ( idxsup,idxpnt : integer32) return double_float is
  begin
    return lifting(idxsup)(idxpnt);
  end Retrieve_Lifting;

  function Lifting_Values return Standard_Floating_VecVecs.Link_to_VecVec is
  begin
    return lifting;
  end Lifting_Values;

  function Number_of_Cell_Indices return natural32 is
  begin
    return Lists_of_Strings.Length_Of(first);
  end Number_of_Cell_Indices;

  function Get_Cell_Indices
             ( index : integer32 ) return String_Splitters.Link_to_String is

    res : String_Splitters.Link_to_String := null;
    tmp : Lists_of_Strings.List := first;
    cnt : integer32 := 0;

  begin
    while not Lists_of_Strings.Is_Null(tmp) loop
      cnt := cnt + 1;
      if cnt = index then
        res := Lists_of_Strings.Head_Of(tmp);
        return res;
      end if;
      tmp := Lists_of_Strings.Tail_Of(tmp);
    end loop;
    return res;
  end Get_Cell_Indices;

  function Retrieve_Cell_Indices return Lists_of_Strings.List is
  begin
    return first;
  end Retrieve_Cell_Indices;

  function Get_Next_Cell_Indices return String_Splitters.Link_to_String is

    res : String_Splitters.Link_to_String := null;
    tailofcellptr : Lists_of_Strings.List;

  begin
    if Lists_of_Strings.Is_Null(cellptr) then
      if not setcellptr then
        if not Lists_of_Strings.Is_Null(first) then
          res := Lists_of_Strings.Head_Of(first);
          cellptr := first;
          setcellptr := true;
        end if;
      end if;
    else
      tailofcellptr := Lists_of_Strings.Tail_Of(cellptr);
      if not Lists_of_Strings.Is_Null(tailofcellptr) then
        res := Lists_of_Strings.Head_Of(tailofcellptr);
        cellptr := tailofcellptr;
      end if;
    end if;
    return res;
  end Get_Next_Cell_Indices;

  function Get_Allocated_Cells return Mixed_Subdivision is
  begin
    return cells;
  end Get_Allocated_Cells;
  
  function Get_Next_Allocated_Cell return Mixed_Subdivision is

    res : Mixed_Subdivision;

  begin
    if not Is_Null(allcellptr) then
      res := allcellptr;
      allcellptr := Tail_Of(allcellptr);
    elsif not Is_Null(cells) then
      res := cells;
      allcellptr := Tail_Of(cells);
    end if;
    return res;
  end Get_Next_Allocated_Cell;

-- DESTRUCTORS :

  procedure Clear_Lifting is
  begin
    Standard_Floating_VecVecs.Deep_Clear(lifting);
  end Clear_Lifting;

  procedure Clear_Cell_Indices is

    tmp : Lists_of_Strings.List := first;
    ls : String_Splitters.Link_to_String;

  begin
    while not Lists_of_Strings.Is_Null(tmp) loop
      ls := Lists_of_Strings.Head_Of(tmp);
      String_Splitters.Clear(ls);
      tmp := Lists_of_Strings.Tail_Of(tmp);
    end loop;
    Lists_of_Strings.Clear(first);
    last := first;
  end Clear_Cell_Indices;

  procedure Clear_Allocated_Cells is
  begin
    Clear(cells);
  end Clear_Allocated_Cells;

begin
  setcellptr := false;
end DEMiCs_Output_Data;
