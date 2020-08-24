with Standard_Floating_Numbers;          use Standard_Floating_Numbers;

package Fast_Double_Renormalizations is

-- DESCRIPTION :
--   The fast renormalization procedures are defined 
--   with generated code from the CAMPARY library, posted 01.06.17,
--   and based on QD-2.3.9.

  procedure fast_renorm
              ( x0,x1,x2,x3 : in double_float;
                r0,r1,r2 : out double_float );

  -- DESCRIPTION :
  --   The definition is based on the fast_renorm2L<4,3>,
  --   from code of the specRenorm.h, generated by the CAMPARY library,
  --   in an unrolled form (Valentina Popescu, Mioara Joldes), with
  --   double double basics of QD-2.3.9 (Y. Hida, X.S. Li, and D.H. Bialey).

  -- ON ENTRY :
  --   x0       most significant word;
  --   x1       second most significant word;
  --   x2       third most significant word;
  --   x3       least significant word.

  -- ON RETURN :
  --   r0       highest part of a triple double number;
  --   r1       middle part of a triple double number;
  --   r2       lowest part of a triple double number.

end Fast_Double_Renormalizations;
