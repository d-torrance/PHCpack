with text_io;                            use text_io;
with Standard_Natural_Numbers;           use Standard_Natural_Numbers;
with Standard_Integer_Numbers;           use Standard_Integer_Numbers;
with Standard_Integer_Numbers_io;        use Standard_Integer_Numbers_io;
with Communications_with_User;           use Communications_with_User;
with File_Scanning;                      use File_Scanning;
with QuadDobl_Complex_Polynomials;
with QuadDobl_Complex_Poly_Systems;      use QuadDobl_Complex_Poly_Systems;
with QuadDobl_Complex_Poly_Systems_io;   use QuadDobl_Complex_Poly_Systems_io;
with QuadDobl_Complex_Solutions;         use QuadDobl_Complex_Solutions;
with QuadDobl_Complex_Solutions_io;      use QuadDobl_Complex_Solutions_io;
with Black_Box_Root_Refiners;

procedure bablvali4 ( infilename,outfilename : in string ) is

  procedure Read_System
              ( file : in out file_type; filename : in string;
                lp : out Link_to_Poly_Sys; sysonfile : out boolean ) is

  -- DESCRIPTION :
  --   If the filename is not empty, then the file is opened
  --   and a system is read from file.

  -- ON ENTRY :
  --   filename is the name of a file, typically infilename.

  -- ON RETURN :
  --   file     opened for input is filename is not empty,
  --            may contain also the solutions of the system;
  --   lp       null if there was no system on file with filename,
  --            otherwise points to the system on file;
  --   sysonfile is false if the reading of a system did not work,
  --            otherwise sysonfile is true.

  begin
    if filename /= "" then
      Open(file,in_file,filename);
      get(file,lp);
      sysonfile := true;
    else
      sysonfile := false;
    end if;
  exception
    when others => put_line("Something is wrong with argument file...");
                   sysonfile := false;
                   lp := null; return;
  end Read_System;

  procedure Prompt_for_System
              ( file : in out file_type; lp : out Link_to_Poly_Sys;
                sysonfile : out boolean ) is

  -- DESCRIPTION :
  --   Prompts the user for a file name and reads the system.

  -- ON RETURN :
  --   file     will be opened for input if the reading was okay;
  --   lp       points to a polynomial system if reading was okay,
  --            otherwise lp remains null;
  --   sysonfile is true if the system was read from file;
  --            otherwise if the system was typed in.

    ans : character;
    n : integer32 := 0;

  begin
    new_line;
    put("Is the system on file ? (y/n) ");
    Ask_Yes_or_No(ans);
    if ans = 'y' then
      put_line("Reading the name of the input file.");
      Read_Name_and_Open_File(file);
      get(file,lp);
      sysonfile := true;
    else
      put("Give the dimension : "); get(n);
      lp := new Poly_Sys(1..n);
      put("Give "); put(n,1); put(" "); put(n,1); 
      put_line("-variate polynomials :");
     -- get(natural32(n),lp.all);
      get(standard_input,lp.all);
      skip_line;
      sysonfile := false;
    end if;
  end Prompt_for_System;

  procedure Refine ( file : in out file_type; lp : in Link_to_Poly_Sys;
                     sysonfile : in boolean ) is

  -- DESCRIPTION :
  --   Calls the root refiner on the system lp,
  --   reading the solutions from file if sysonfile.

    outfile : file_type;
    sols : Solution_List;
    found : boolean;
    nbvar : constant natural32
          := QuadDobl_Complex_Polynomials.Number_of_Unknowns(lp(lp'first));

  begin
    Create_Output_File(outfile,outfilename);
    if lp'last = integer32(nbvar)
     then put(outfile,natural32(lp'last),lp.all);
     else put(outfile,natural32(lp'last),nbvar,lp.all);
    end if;
    if sysonfile then
      Scan_and_Skip(file,"THE SOLUTIONS",found);
      if found
       then get(file,sols);
      end if;
      Close(file);
    else
      found := false;
    end if;
    if not found
     then new_line; Read(sols);
    end if;
    Black_Box_Root_Refiners.Refine_Roots(outfile,lp.all,sols);
  end Refine;

  procedure Main is

  -- DESCRIPTION :
  --   Reads the system, the solutions,
  --   and then calls the black box root refiner.

    infile : file_type;
    lp : Link_to_Poly_Sys;
    sysonfile : boolean;

  begin
    Read_System(infile,infilename,lp,sysonfile);
    if lp = null
     then Prompt_for_System(infile,lp,sysonfile);
    end if;
    if lp /= null
     then Refine(infile,lp,sysonfile);
    end if;
  end Main;

begin
  Main;
end bablvali4;
