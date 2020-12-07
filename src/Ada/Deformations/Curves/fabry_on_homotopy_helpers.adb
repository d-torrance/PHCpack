with Communications_with_User;           use Communications_with_User;
with Standard_Integer_Numbers_io;        use Standard_Integer_Numbers_io;
with Standard_Floating_Numbers_io;       use Standard_Floating_Numbers_io;
with Double_Double_Numbers_io;           use Double_Double_Numbers_io;
with Triple_Double_Numbers_io;           use Triple_Double_Numbers_io;
with Quad_Double_Numbers_io;             use Quad_Double_Numbers_io;
with Penta_Double_Numbers_io;            use Penta_Double_Numbers_io;
with Octo_Double_Numbers_io;             use Octo_Double_Numbers_io;
with Deca_Double_Numbers_io;             use Deca_Double_Numbers_io;
with Standard_Complex_Numbers_io;        use Standard_Complex_Numbers_io;
with DoblDobl_Complex_Numbers_io;        use DoblDobl_Complex_Numbers_io;
with TripDobl_Complex_Numbers_io;        use TripDobl_Complex_Numbers_io;
with QuadDobl_Complex_Numbers_io;        use QuadDobl_Complex_Numbers_io;
with PentDobl_Complex_Numbers_io;        use PentDobl_Complex_Numbers_io;
with OctoDobl_Complex_Numbers_io;        use OctoDobl_Complex_Numbers_io;
with DecaDobl_Complex_Numbers_io;        use DecaDobl_Complex_Numbers_io;

package body Fabry_on_Homotopy_Helpers is

  procedure Prompt_for_Parameters
              ( maxit : in out integer32; tol : in out double_float;
                verbose : out boolean ) is

    ans : character;

  begin
    loop
      put("Maximum number of iterations : "); put(maxit,1);
      put(".  Change this number ? (y/n) "); Ask_Yes_or_No(ans);
      exit when (ans /= 'y');
      put("Give the new maximum number of iterations : "); get(maxit);
    end loop;
    loop
      put("Tolerance for the accuracy : "); put(tol,3);
      put(".  Change this tolerance ? (y/n) "); Ask_Yes_or_No(ans);
      exit when (ans /= 'y');
      put("Give the new tolerance for the accuracy : "); get(tol);
    end loop;
    put("Output during the Newton steps ? (y/n) "); Ask_Yes_or_No(ans);
    verbose := (ans = 'y');
  end Prompt_for_Parameters;

  procedure Write_Report
              ( file : in file_type; rad,err : in double_float;
                zpt : in Standard_Complex_Numbers.Complex_Number;
                fail : in boolean ) is
  begin
    put(file,"the convergence radius : "); put(file,rad,3);
    put(file,"   error estimate : "); put(file,err,3); new_line(file);
    put(file,zpt); put_line(file,"  estimates nearest singularity");
    if fail
     then put_line(file,"Reported failure.");
     else put_line(file,"Reported success.");
    end if;
  end Write_Report;

  procedure Write_Report
              ( file : in file_type; rad,err : in double_double;
                zpt : in DoblDobl_Complex_Numbers.Complex_Number;
                fail : in boolean ) is
  begin
    put(file,"the convergence radius : "); put(file,rad,3);
    put(file,"   error estimate : "); put(file,err,3); new_line(file);
    put(file,zpt); put_line(file,"  estimates nearest singularity");
    if fail
     then put_line(file,"Reported failure.");
     else put_line(file,"Reported success.");
    end if;
  end Write_Report;

  procedure Write_Report
              ( file : in file_type; rad,err : in triple_double;
                zpt : in TripDobl_Complex_Numbers.Complex_Number;
                fail : in boolean ) is
  begin
    put(file,"the convergence radius : "); put(file,rad,3);
    put(file,"   error estimate : "); put(file,err,3); new_line(file);
    put(file,zpt); put_line(file,"  estimates nearest singularity");
    if fail
     then put_line(file,"Reported failure.");
     else put_line(file,"Reported success.");
    end if;
  end Write_Report;

  procedure Write_Report
              ( file : in file_type; rad,err : in quad_double;
                zpt : in QuadDobl_Complex_Numbers.Complex_Number;
                fail : in boolean ) is
  begin
    put(file,"the convergence radius : "); put(file,rad,3);
    put(file,"   error estimate : "); put(file,err,3); new_line(file);
    put(file,zpt); put_line(file,"  estimates nearest singularity");
    if fail
     then put_line(file,"Reported failure.");
     else put_line(file,"Reported success.");
    end if;
  end Write_Report;

  procedure Write_Report
              ( file : in file_type; rad,err : in penta_double;
                zpt : in PentDobl_Complex_Numbers.Complex_Number;
                fail : in boolean ) is
  begin
    put(file,"the convergence radius : "); put(file,rad,3);
    put(file,"   error estimate : "); put(file,err,3); new_line(file);
    put(file,zpt); put_line(file,"  estimates nearest singularity");
    if fail
     then put_line(file,"Reported failure.");
     else put_line(file,"Reported success.");
    end if;
  end Write_Report;

  procedure Write_Report
              ( file : in file_type; rad,err : in octo_double;
                zpt : in OctoDobl_Complex_Numbers.Complex_Number;
                fail : in boolean ) is
  begin
    put(file,"the convergence radius : "); put(file,rad,3);
    put(file,"   error estimate : "); put(file,err,3); new_line(file);
    put(file,zpt); put_line(file,"  estimates nearest singularity");
    if fail
     then put_line(file,"Reported failure.");
     else put_line(file,"Reported success.");
    end if;
  end Write_Report;

  procedure Write_Report
              ( file : in file_type; rad,err : in deca_double;
                zpt : in DecaDobl_Complex_Numbers.Complex_Number;
                fail : in boolean ) is
  begin
    put(file,"the convergence radius : "); put(file,rad,3);
    put(file,"   error estimate : "); put(file,err,3); new_line(file);
    put(file,zpt); put_line(file,"  estimates nearest singularity");
    if fail
     then put_line(file,"Reported failure.");
     else put_line(file,"Reported success.");
    end if;
  end Write_Report;

end Fabry_on_Homotopy_Helpers;
