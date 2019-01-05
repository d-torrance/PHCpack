with Ada.Calendar;
with text_io;                            use text_io;
with Timing_Package;                     use Timing_Package;
with Communications_with_User;           use Communications_with_User;
with Characters_and_Numbers;
with Standard_Natural_Numbers;           use Standard_Natural_Numbers;
with Standard_Integer_Numbers_io;        use Standard_Integer_Numbers_io;
with Standard_Floating_Numbers;          use Standard_Floating_Numbers;
with Standard_Complex_Numbers;
with DoblDobl_Complex_Numbers;
with DoblDobl_Complex_Numbers_cv;
with QuadDobl_Complex_Numbers;
with QuadDobl_Complex_Numbers_cv;
with Standard_Complex_Poly_Systems;
with Standard_Complex_Poly_Systems_io;   use Standard_Complex_Poly_Systems_io;
with Standard_Complex_Solutions_io;      use Standard_Complex_Solutions_io;
with Standard_System_and_Solutions_io;
with DoblDobl_Complex_Poly_Systems;
with DoblDobl_Complex_Poly_Systems_io;   use DoblDobl_Complex_Poly_Systems_io;
with DoblDobl_Complex_Solutions_io;      use DoblDobl_Complex_Solutions_io;
with DoblDobl_System_and_Solutions_io;
with QuadDobl_Complex_Poly_Systems;
with QuadDobl_Complex_Poly_Systems_io;   use QuadDobl_Complex_Poly_Systems_io;
with QuadDobl_Complex_Solutions_io;      use QuadDobl_Complex_Solutions_io;
with QuadDobl_System_and_Solutions_io;
with Standard_Homotopy;
with DoblDobl_Homotopy;
with QuadDobl_Homotopy;
with Standard_Complex_Series_VecVecs;
with DoblDobl_Complex_Series_VecVecs;
with QuadDobl_Complex_Series_VecVecs;
with Standard_CSeries_Poly_Systems;
with Standard_CSeries_Poly_SysFun;
with Standard_CSeries_Jaco_Matrices;
with DoblDobl_CSeries_Poly_Systems;
with DoblDobl_CSeries_Poly_SysFun;
with DoblDobl_CSeries_Jaco_Matrices;
with QuadDobl_CSeries_Poly_Systems;
with QuadDobl_CSeries_Poly_SysFun;
with QuadDobl_CSeries_Jaco_Matrices;
with Complex_Series_and_Polynomials_io;  use Complex_Series_and_Polynomials_io;
with Series_and_Homotopies;
with Series_and_Trackers;
with Homotopy_Series_Readers;
with Homotopy_Continuation_Parameters;
with Homotopy_Continuation_Parameters_io;
with Drivers_to_Series_Trackers;         use Drivers_to_Series_Trackers;

package body Series_Path_Trackers is

  procedure Standard_Write 
              ( file : in file_type; nq : in natural32;
                sols : in Standard_Complex_Solutions.Solution_List;
                pars : in Homotopy_Continuation_Parameters.Parameters ) is

  -- DESCRIPTION :
  --   Writes target system, start system, start solutions,
  --   and the homotopy continuation parameters in pars to file.
  --   The number of equations is in nq.

  -- REQUIRED : Standard_Homotopy is well defined.

  begin
    put(file,nq,Standard_Homotopy.Target_System);
    new_line(file);
    put_line(file,"THE START SYSTEM :");
    put(file,nq,Standard_Homotopy.Start_System);
    new_line(file);
    put_line(file,"THE START SOLUTIONS :");
    put(file,Standard_Complex_Solutions.Length_Of(sols),
        natural32(Standard_Complex_Solutions.Head_Of(sols).n),sols);
    new_line(file);
    Homotopy_Continuation_Parameters_io.put(file,pars);
    new_line(file); flush(file);
  end Standard_Write;

  procedure DoblDobl_Write 
              ( file : in file_type; nq : in natural32;
                sols : in DoblDobl_Complex_Solutions.Solution_List;
                pars : in Homotopy_Continuation_Parameters.Parameters ) is

  -- DESCRIPTION :
  --   Writes target system, start system, start solutions,
  --   and the homotopy continuation parameters in pars to file.
  --   The number of equations is in nq.

  -- REQUIRED : DoblDobl_Homotopy is well defined.

  begin
    put(file,nq,DoblDobl_Homotopy.Target_System);
    new_line(file);
    put_line(file,"THE START SYSTEM :");
    put(file,nq,DoblDobl_Homotopy.Start_System);
    new_line(file);
    put_line(file,"THE START SOLUTIONS :");
    put(file,DoblDobl_Complex_Solutions.Length_Of(sols),
        natural32(DoblDobl_Complex_Solutions.Head_Of(sols).n),sols);
    new_line(file);
    Homotopy_Continuation_Parameters_io.put(file,pars);
    new_line(file); flush(file);
  end DoblDobl_Write;

  procedure QuadDobl_Write 
              ( file : in file_type; nq : in natural32;
                sols : in QuadDobl_Complex_Solutions.Solution_List;
                pars : in Homotopy_Continuation_Parameters.Parameters ) is

  -- DESCRIPTION :
  --   Writes target system, start system, start solutions,
  --   and the homotopy continuation parameters in pars to file.
  --   The number of equations is in nq.

  -- REQUIRED : QuadDobl_Homotopy is well defined.

  begin
    put(file,nq,QuadDobl_Homotopy.Target_System);
    new_line(file);
    put_line(file,"THE START SYSTEM :");
    put(file,nq,QuadDobl_Homotopy.Start_System);
    new_line(file);
    put_line(file,"THE START SOLUTIONS :");
    put(file,QuadDobl_Complex_Solutions.Length_Of(sols),
        natural32(QuadDobl_Complex_Solutions.Head_Of(sols).n),sols);
    new_line(file);
    Homotopy_Continuation_Parameters_io.put(file,pars);
    new_line(file); flush(file);
  end QuadDobl_Write;

  procedure Standard_Run
              ( nq : in integer32;
                sols : in out Standard_Complex_Solutions.Solution_List ) is

    use Standard_Complex_Solutions;

    h : Standard_Complex_Poly_Systems.Poly_Sys(1..nq);
    s : Standard_CSeries_Poly_Systems.Poly_Sys(1..nq);
    fhm : Standard_CSeries_Poly_SysFun.Eval_Coeff_Poly_Sys(1..nq);
    fcf : Standard_Complex_Series_VecVecs.VecVec(1..nq);
    nvr : constant integer32 := integer32(Head_Of(sols).n);
    ejm : Standard_CSeries_Jaco_Matrices.Eval_Coeff_Jaco_Mat(h'range,1..nvr);
    mlt : Standard_CSeries_Jaco_Matrices.Mult_Factors(h'range,1..nvr);
    p : Homotopy_Continuation_Parameters.Parameters
      := Homotopy_Continuation_Parameters.Default_Values;
    tmp : Solution_List := sols;
    len : constant integer32 := integer32(Length_Of(sols));
    ls : Link_to_Solution;
    ans : character;
    monitor,verbose,tofile : boolean;
    file : file_type;
    timer : Timing_Widget;
    prevgamma : Standard_Complex_Numbers.Complex_Number;
    nbrsteps,minnbrsteps,maxnbrsteps : natural32;
    nbrcorrs,minnbrcorrs,maxnbrcorrs,cntfail : natural32;
    minsize,maxsize,smallest,largest : double_float;
    start_moment : constant Ada.Calendar.Time := Ada.Calendar.Clock;

  begin
   -- put_line("The homotopy system :"); put_line(h);
   -- put_line("The series system :"); put(s,1); new_line;
    p.gamma := Standard_Homotopy.Accessibility_Constant;
    prevgamma := p.gamma;
    Homotopy_Continuation_Parameters_io.Tune(p);
    if not Standard_Complex_Numbers.Equal(p.gamma,prevgamma)
     then Standard_Reset_Gamma(p.gamma);
    end if;
    h := Standard_Homotopy.Homotopy_System;
    s := Series_and_Homotopies.Create(h,nq+1,false);
    fhm := Standard_CSeries_Poly_SysFun.Create(s);
    fcf := Standard_CSeries_Poly_SysFun.Coeff(s);
    Standard_CSeries_Jaco_Matrices.Create(s,ejm,mlt);
    Set_Output(file,monitor,verbose,tofile);
    if tofile
     then Standard_Write(file,natural32(nq),sols,p);
    end if;
    minnbrsteps := p.maxsteps+1; maxnbrsteps := 0;
    minnbrcorrs := (p.maxsteps+1)*p.corsteps+1; maxnbrcorrs := 0;
    smallest := p.maxsize; largest := 0.0;
    tstart(timer);
    for i in 1..len loop
      ls := Head_Of(tmp);
      if monitor
       then put("Tracking path "); put(i,1); put_line(" ...");
      end if;
      if tofile then
        Series_and_Trackers.Track_One_Path
          (file,fhm,fcf,ejm,mlt,ls.all,p,
           nbrsteps,nbrcorrs,cntfail,minsize,maxsize,verbose);
        if verbose then
          Series_and_Trackers.Write_Path_Statistics
            (file,nbrsteps,nbrcorrs,cntfail,minsize,maxsize);
        end if;
        put(file,"Solution "); put(file,i,1); put_line(file," :");
        put(file,ls.all); new_line(file);
      else
        Series_and_Trackers.Track_One_Path
          (standard_output,fhm,fcf,ejm,mlt,ls.all,p,
           nbrsteps,nbrcorrs,cntfail,minsize,maxsize,verbose);
        if verbose then
          Series_and_Trackers.Write_Path_Statistics
            (standard_output,nbrsteps,nbrcorrs,cntfail,minsize,maxsize);
        end if;
        put("Solution "); put(i,1); put_line(" :"); put(ls.all);
        put("Continue to the next path ? (y/n) "); Ask_Yes_or_No(ans);
        exit when (ans /= 'y');
      end if;
      Set_Head(tmp,ls);
      tmp := Tail_Of(tmp);
      Series_and_Trackers.Update_Counters(minnbrsteps,maxnbrsteps,nbrsteps);
      Series_and_Trackers.Update_Counters(minnbrcorrs,maxnbrcorrs,nbrcorrs);
      Series_and_Trackers.Update_MinMax(smallest,largest,minsize,maxsize);
    end loop;
    tstop(timer);
    if tofile then
      Series_and_Trackers.Write_Total_Path_Statistics
        (file,minnbrsteps,maxnbrsteps,minnbrcorrs,maxnbrcorrs,smallest,largest);
      new_line(file);
      put_line(file,"THE SOLUTIONS :");
      put(file,Length_Of(sols),natural32(Head_Of(sols).n),sols);
      Write_Timer(file,p.numdeg,p.dendeg,0,timer);
      Refine_Roots(file,nq,sols);
      Write_Conclusion(file,start_moment);
    else
      Series_and_Trackers.Write_Total_Path_Statistics
        (standard_output,minnbrsteps,maxnbrsteps,minnbrcorrs,maxnbrcorrs,
         smallest,largest);
      new_line;
      put_line("THE SOLUTIONS :");
      put(standard_output,Length_Of(sols),natural32(Head_Of(sols).n),sols);
      Write_Timer(standard_output,p.numdeg,p.dendeg,0,timer);
      Refine_Roots(standard_output,nq,sols);
      Write_Conclusion(standard_output,start_moment);
    end if;
    Standard_Complex_Poly_Systems.Clear(h);
    Standard_CSeries_Poly_Systems.Clear(s);
    Standard_CSeries_Poly_SysFun.Clear(fhm);
    Standard_Complex_Series_VecVecs.Clear(fcf);
    Standard_CSeries_Jaco_Matrices.Clear(ejm);
    Standard_Cseries_Jaco_Matrices.Clear(mlt);
  end Standard_Run;

  procedure DoblDobl_Run
              ( nq : in integer32;
                sols : in out DoblDobl_Complex_Solutions.Solution_List ) is

    use DoblDobl_Complex_Solutions;

    h : DoblDobl_Complex_Poly_Systems.Poly_Sys(1..nq);
    s : DoblDobl_CSeries_Poly_Systems.Poly_Sys(1..nq);
    fhm : DoblDobl_CSeries_Poly_SysFun.Eval_Coeff_Poly_Sys(1..nq);
    fcf : DoblDobl_Complex_Series_VecVecs.VecVec(1..nq);
    nvr : constant integer32 := integer32(Head_Of(sols).n);
    ejm : DoblDobl_CSeries_Jaco_Matrices.Eval_Coeff_Jaco_Mat(h'range,1..nvr);
    mlt : DoblDobl_CSeries_Jaco_Matrices.Mult_Factors(h'range,1..nvr);
    p : Homotopy_Continuation_Parameters.Parameters
      := Homotopy_Continuation_Parameters.Default_Values;
    tmp : Solution_List := sols;
    len : constant integer32 := integer32(Length_Of(sols));
    ls : Link_to_Solution;
    ans : character;
    monitor,verbose,tofile : boolean;
    file : file_type;
    timer : Timing_Widget;
    ddgamma : constant DoblDobl_Complex_Numbers.Complex_Number
            := DoblDobl_Homotopy.Accessibility_Constant;
    gamma : constant Standard_Complex_Numbers.Complex_Number
          := DoblDobl_Complex_Numbers_cv.DoblDobl_Complex_to_Standard(ddgamma);
    prevgamma : Standard_Complex_Numbers.Complex_Number;
    nbrsteps,minnbrsteps,maxnbrsteps : natural32;
    nbrcorrs,minnbrcorrs,maxnbrcorrs,cntfail : natural32;
    minsize,maxsize,smallest,largest : double_float;
    start_moment : constant Ada.Calendar.Time := Ada.Calendar.Clock;

  begin
   -- put_line("The homotopy system :"); put_line(h);
   -- put_line("The series system :"); put(s,1); new_line;
    p.gamma := gamma;
    prevgamma := p.gamma;
    Homotopy_Continuation_Parameters_io.Tune(p);
    if not Standard_Complex_Numbers.Equal(p.gamma,prevgamma)
     then DoblDobl_Reset_Gamma(p.gamma);
    end if;
    h := DoblDobl_Homotopy.Homotopy_System;
    s := Series_and_Homotopies.Create(h,nq+1,false);
    fhm := DoblDobl_CSeries_Poly_SysFun.Create(s);
    fcf := DoblDobl_CSeries_Poly_SysFun.Coeff(s);
    DoblDobl_CSeries_Jaco_Matrices.Create(s,ejm,mlt);
    Set_Output(file,monitor,verbose,tofile);
    if tofile
     then DoblDobl_Write(file,natural32(nq),sols,p);
    end if;
    minnbrsteps := p.maxsteps+1; maxnbrsteps := 0;
    minnbrcorrs := (p.maxsteps+1)*p.corsteps+1; maxnbrcorrs := 0;
    smallest := p.maxsize; largest := 0.0;
    tstart(timer);
    for i in 1..len loop
      ls := Head_Of(tmp);
      if monitor
       then put("Tracking path "); put(i,1); put_line(" ...");
      end if;
      if tofile then
        Series_and_Trackers.Track_One_Path
          (file,fhm,fcf,ejm,mlt,ls.all,p,
           nbrsteps,nbrcorrs,cntfail,minsize,maxsize,verbose);
        if verbose then
          Series_and_Trackers.Write_Path_Statistics
            (file,nbrsteps,nbrcorrs,cntfail,minsize,maxsize);
        end if;
        put(file,"Solution "); put(file,i,1); put_line(file," :");
        put(file,ls.all); new_line(file);
      else
        Series_and_Trackers.Track_One_Path
          (standard_output,fhm,fcf,ejm,mlt,ls.all,p,
           nbrsteps,nbrcorrs,cntfail,minsize,maxsize,verbose);
        if verbose then
          Series_and_Trackers.Write_Path_Statistics
            (standard_output,nbrsteps,nbrcorrs,cntfail,minsize,maxsize);
        end if;
        put("Solution "); put(i,1); put_line(" :"); put(ls.all);
        put("Continue to the next path ? (y/n) ");
        Ask_Yes_or_No(ans);
        exit when (ans /= 'y');
      end if;
      Set_Head(tmp,ls);
      tmp := Tail_Of(tmp);
      Series_and_Trackers.Update_Counters(minnbrsteps,maxnbrsteps,nbrsteps);
      Series_and_Trackers.Update_Counters(minnbrcorrs,maxnbrcorrs,nbrcorrs);
      Series_and_Trackers.Update_MinMax(smallest,largest,minsize,maxsize);
    end loop;
    tstop(timer);
    if tofile then
      Series_and_Trackers.Write_Total_Path_Statistics
        (file,minnbrsteps,maxnbrsteps,minnbrcorrs,maxnbrcorrs,smallest,largest);
      new_line(file);
      put_line(file,"THE SOLUTIONS :");
      put(file,Length_Of(sols),natural32(Head_Of(sols).n),sols);
      Write_Timer(file,p.numdeg,p.dendeg,1,timer);
      Refine_Roots(file,nq,sols);
      Write_Conclusion(file,start_moment);
    else
      Series_and_Trackers.Write_Total_Path_Statistics
        (standard_output,minnbrsteps,maxnbrsteps,minnbrcorrs,maxnbrcorrs,
         smallest,largest);
      new_line;
      put_line("THE SOLUTIONS :");
      put(standard_output,Length_Of(sols),natural32(Head_Of(sols).n),sols);
      Write_Timer(standard_output,p.numdeg,p.dendeg,1,timer);
      Refine_Roots(standard_output,nq,sols);
      Write_Conclusion(standard_output,start_moment);
    end if;
    DoblDobl_Complex_Poly_Systems.Clear(h);
    DoblDobl_CSeries_Poly_Systems.Clear(s);
    DoblDobl_CSeries_Poly_SysFun.Clear(fhm);
    DoblDobl_Complex_Series_VecVecs.Clear(fcf);
    DoblDobl_CSeries_Jaco_Matrices.Clear(ejm);
    DoblDobl_Cseries_Jaco_Matrices.Clear(mlt);
  end DoblDobl_Run;

  procedure QuadDobl_Run
              ( nq : in integer32;
                sols : in out QuadDobl_Complex_Solutions.Solution_List ) is

    use QuadDobl_Complex_Solutions;

    h : QuadDobl_Complex_Poly_Systems.Poly_Sys(1..nq);
    s : QuadDobl_CSeries_Poly_Systems.Poly_Sys(1..nq);
    fhm : QuadDobl_CSeries_Poly_SysFun.Eval_Coeff_Poly_Sys(1..nq);
    fcf : QuadDobl_Complex_Series_VecVecs.VecVec(1..nq);
    nvr : constant integer32 := integer32(Head_Of(sols).n);
    ejm : QuadDobl_CSeries_Jaco_Matrices.Eval_Coeff_Jaco_Mat(h'range,1..nvr);
    mlt : QuadDobl_CSeries_Jaco_Matrices.Mult_Factors(h'range,1..nvr);
    p : Homotopy_Continuation_Parameters.Parameters
      := Homotopy_Continuation_Parameters.Default_Values;
    tmp : Solution_List := sols;
    len : constant integer32 := integer32(Length_Of(sols));
    ls : Link_to_Solution;
    ans : character;
    monitor,verbose,tofile : boolean;
    file : file_type;
    timer : Timing_Widget;
    qdgamma : constant QuadDobl_Complex_Numbers.Complex_Number
            := QuadDobl_Homotopy.Accessibility_Constant;
    gamma : constant Standard_Complex_Numbers.Complex_Number
          := QuadDobl_Complex_Numbers_cv.QuadDobl_Complex_to_Standard(qdgamma);
    prevgamma : Standard_Complex_Numbers.Complex_Number;
    nbrsteps,minnbrsteps,maxnbrsteps : natural32;
    nbrcorrs,minnbrcorrs,maxnbrcorrs,cntfail : natural32;
    minsize,maxsize,smallest,largest : double_float;
    start_moment : constant Ada.Calendar.Time := Ada.Calendar.Clock;

  begin
   -- put_line("The homotopy system :"); put_line(h);
   -- put_line("The series system :"); put(s,1); new_line;
    p.gamma := gamma;
    prevgamma := p.gamma;
    Homotopy_Continuation_Parameters_io.Tune(p);
    if not Standard_Complex_Numbers.Equal(p.gamma,prevgamma)
     then QuadDobl_Reset_Gamma(p.gamma);
    end if;
    h := QuadDobl_Homotopy.Homotopy_System;
    s := Series_and_Homotopies.Create(h,nq+1,false);
    fhm := QuadDobl_CSeries_Poly_SysFun.Create(s);
    fcf := QuadDobl_CSeries_Poly_SysFun.Coeff(s);
    QuadDobl_CSeries_Jaco_Matrices.Create(s,ejm,mlt);
    Set_Output(file,monitor,verbose,tofile);
    if tofile
     then QuadDobl_Write(file,natural32(nq),sols,p);
    end if;
    minnbrsteps := p.maxsteps+1; maxnbrsteps := 0;
    minnbrcorrs := (p.maxsteps+1)*p.corsteps+1; maxnbrcorrs := 0;
    smallest := p.maxsize; largest := 0.0;
    tstart(timer);
    for i in 1..len loop
      ls := Head_Of(tmp);
      if monitor
       then put("Tracking path "); put(i,1); put_line(" ...");
      end if;
      if tofile then
        Series_and_Trackers.Track_One_Path
          (file,fhm,fcf,ejm,mlt,ls.all,p,
           nbrsteps,nbrcorrs,cntfail,minsize,maxsize,verbose);
        if verbose then
          Series_and_Trackers.Write_Path_Statistics
            (file,nbrsteps,nbrcorrs,cntfail,minsize,maxsize);
        end if;
        put(file,"Solution "); put(file,i,1); put_line(file," :");
        put(file,ls.all); new_line(file);
      else
        Series_and_Trackers.Track_One_Path
          (standard_output,fhm,fcf,ejm,mlt,ls.all,p,
           nbrsteps,nbrcorrs,cntfail,minsize,maxsize,verbose);
        if verbose then
          Series_and_Trackers.Write_Path_Statistics
            (standard_output,nbrsteps,nbrcorrs,cntfail,minsize,maxsize);
        end if;
        put("Solution "); put(i,1); put_line(" :"); put(ls.all);
        put("Continue to the next path ? (y/n) "); Ask_Yes_or_No(ans);
        exit when (ans /= 'y');
      end if;
      Set_Head(tmp,ls);
      tmp := Tail_Of(tmp);
      Series_and_Trackers.Update_Counters(minnbrsteps,maxnbrsteps,nbrsteps);
      Series_and_Trackers.Update_Counters(minnbrcorrs,maxnbrcorrs,nbrcorrs);
      Series_and_Trackers.Update_MinMax(smallest,largest,minsize,maxsize);
    end loop;
    tstop(timer);
    if tofile then
      Series_and_Trackers.Write_Total_Path_Statistics
        (file,minnbrsteps,maxnbrsteps,minnbrcorrs,maxnbrcorrs,smallest,largest);
      new_line(file);
      put_line(file,"THE SOLUTIONS :");
      put(file,Length_Of(sols),natural32(Head_Of(sols).n),sols);
      Write_Timer(file,p.numdeg,p.dendeg,2,timer);
      Refine_Roots(file,nq,sols);
      Write_Conclusion(file,start_moment);
    else
      Series_and_Trackers.Write_Total_Path_Statistics
        (standard_output,minnbrsteps,maxnbrsteps,minnbrcorrs,maxnbrcorrs,
         smallest,largest);
      new_line;
      put_line("THE SOLUTIONS :");
      put(standard_output,Length_Of(sols),natural32(Head_Of(sols).n),sols);
      Write_Timer(standard_output,p.numdeg,p.dendeg,2,timer);
      Refine_Roots(standard_output,nq,sols);
      Write_Conclusion(standard_output,start_moment);
    end if;
    QuadDobl_Complex_Poly_Systems.Clear(h);
    QuadDobl_CSeries_Poly_Systems.Clear(s);
    QuadDobl_CSeries_Poly_SysFun.Clear(fhm);
    QuadDobl_Complex_Series_VecVecs.Clear(fcf);
    QuadDobl_CSeries_Jaco_Matrices.Clear(ejm);
    QuadDobl_Cseries_Jaco_Matrices.Clear(mlt);
  end QuadDobl_Run;

  procedure Standard_Main is

    nbeq : integer32;
    sols : Standard_Complex_Solutions.Solution_List;

  begin
    Homotopy_Series_Readers.Standard_Reader(nbeq,sols);
    new_line;
    Standard_Run(nbeq,sols);
  end Standard_Main;

  procedure DoblDobl_Main is

    nbeq : integer32;
    sols : DoblDobl_Complex_Solutions.Solution_List;

  begin
    Homotopy_Series_Readers.DoblDobl_Reader(nbeq,sols);
    new_line;
    DoblDobl_Run(nbeq,sols);
  end DoblDobl_Main;

  procedure QuadDobl_Main is

    nbeq : integer32;
    sols : QuadDobl_Complex_Solutions.Solution_List;

  begin
    Homotopy_Series_Readers.QuadDobl_Reader(nbeq,sols);
    new_line;
    QuadDobl_Run(nbeq,sols);
  end QuadDobl_Main;

end Series_Path_Trackers;
