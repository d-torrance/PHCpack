with text_io;                            use text_io;
with Communications_with_User;           use Communications_with_User;
with Standard_Fabry_on_Homotopy;
with DoblDobl_Fabry_on_Homotopy;
with TripDobl_Fabry_on_Homotopy;
with QuadDobl_Fabry_on_Homotopy;
with PentDobl_Fabry_on_Homotopy;
with OctoDobl_Fabry_on_Homotopy;
with DecaDobl_Fabry_on_Homotopy;

procedure ts_fabryhom is

-- DESCRIPTION :
--   Tests the Newton-Fabry convergence radius computation
--   for artificial or natural-parameter homotopies.

  procedure Main is

  -- DESCRIPTION :
  --   Prompts the user for the precision
  --   and then launches the computation in that precision.

    prc : character;

  begin
    new_line;
    put_line("MENU for the working precision :");
    put_line("  1. double precision");
    put_line("  2. double double precision");
    put_line("  3. triple double precision");
    put_line("  4. quad double precision");
    put_line("  5. quad double precision");
    put_line("  6. octo double precision");
    put_line("  7. deca double precision");
    put("Type 1, 2, 3, 4, 5, 6, or 7 to select a precision : ");
    Ask_Alternative(prc,"1234567");
    case prc is
      when '1' => Standard_Fabry_on_Homotopy.Main;
      when '2' => DoblDobl_Fabry_on_Homotopy.Main;
      when '3' => TripDobl_Fabry_on_Homotopy.Main;
      when '4' => QuadDobl_Fabry_on_Homotopy.Main;
      when '5' => PentDobl_Fabry_on_Homotopy.Main;
      when '6' => OctoDobl_Fabry_on_Homotopy.Main;
      when '7' => DecaDobl_Fabry_on_Homotopy.Main;
      when others => null;
    end case;
  end Main;

begin
  Main;
end ts_fabryhom;
