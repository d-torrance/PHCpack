with Standard_Random_Numbers;

package body Homotopy_Continuation_Parameters is

  function Default_Values return Parameters is

    res : Parameters;

  begin
    res.alpha := 1.0E-5;
    res.beta := 0.5;
    res.gamma := Standard_Random_Numbers.Random1;
    res.numdeg := 4;
    res.dendeg := 4;
    res.maxsize := 0.01;
    res.minsize := 1.0E-6;
    res.tolcff := 1.0E-12;
    res.corsteps := 4;
    res.maxsteps := 500;
    return res;
  end Default_Values;

end Homotopy_Continuation_Parameters;
