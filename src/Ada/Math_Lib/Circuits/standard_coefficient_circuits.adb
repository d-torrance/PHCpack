-- with text_io; use text_io;
-- with Standard_Integer_Numbers_io; use Standard_Integer_Numbers_io;
-- with Standard_Floating_Numbers_io; use Standard_Floating_Numbers_io;

with Standard_Integer_Numbers;            use Standard_Integer_Numbers;
with Standard_Floating_Numbers;           use Standard_Floating_Numbers;
with Standard_Complex_Numbers;

package body Standard_Coefficient_Circuits is

  procedure Forward ( x : in Standard_Complex_Vectors.Link_to_Vector;
                      f : in Standard_Complex_Vectors.Link_to_Vector ) is

    use Standard_Complex_Numbers;

  begin
    f(f'first) := x(x'first)*x(x'first+1);
    for k in 2..x'last-1 loop
      f(k) := f(k-1)*x(k+1);
    end loop;
  end Forward;

  procedure Forward ( xr : in Standard_Floating_Vectors.Link_to_Vector;
                      xi : in Standard_Floating_Vectors.Link_to_Vector;
                      fr : in Standard_Floating_Vectors.Link_to_Vector;
                      fi : in Standard_Floating_Vectors.Link_to_Vector ) is

    zr,zi,pr,pi,qr,qi : double_float;
    idx : integer32;
    dim : constant integer32 := xr'last-1;

  begin
   -- f(f'first) := x(x'first)*x(x'first+1);
    pr := xr(1); pi := xi(1);
    idx := xr'first+1;
    qr := xr(idx);  qi := xi(idx);
    zr := pr*qr - pi*qi;
    zi := pr*qi + pi*qr;
    fr(1) := zr; fi(1) := zi;
    for k in 2..dim loop 
     -- f(k) := f(k-1)*x(k+1);
      pr := zr; pi := zi;
      idx := k+1;
      qr := xr(idx); qi := xi(idx);
      zr := pr*qr - pi*qi;
      zi := pr*qi + pi*qr;
      fr(k) := zr; fi(k) := zi;
    end loop;
  end Forward;

  procedure Forward_Backward
              ( x,f,b : in Standard_Complex_Vectors.Link_to_Vector ) is

    use Standard_Complex_Numbers;

  begin
    f(f'first) := x(x'first)*x(x'first+1);
    for k in 2..x'last-1 loop
      f(k) := f(k-1)*x(k+1);
    end loop;
    b(b'first) := x(x'last)*x(x'last-1);
    for k in 2..x'last-2 loop
      b(k) := b(k-1)*x(x'last-k);
    end loop;
  end Forward_Backward;

  procedure Fused_Forward_Backward
              ( x,f,b : in Standard_Complex_Vectors.Link_to_Vector ) is

    use Standard_Complex_Numbers;

  begin
    f(f'first) := x(x'first)*x(x'first+1);
    b(b'first) := x(x'last)*x(x'last-1);
    for k in 2..x'last-2 loop
      f(k) := f(k-1)*x(k+1);
      b(k) := b(k-1)*x(x'last-k);
    end loop;
    if f'last > 1
     then f(f'last) := f(f'last-1)*x(x'last);
    end if;
  end Fused_Forward_Backward;

  procedure Forward_Backward
              ( xr : in Standard_Floating_Vectors.Link_to_Vector;
                xi : in Standard_Floating_Vectors.Link_to_Vector;
                fr : in Standard_Floating_Vectors.Link_to_Vector;
                fi : in Standard_Floating_Vectors.Link_to_Vector;
                br : in Standard_Floating_Vectors.Link_to_Vector;
                bi : in Standard_Floating_Vectors.Link_to_Vector ) is

    zr,zi,pr,pi,qr,qi : double_float;
    idx : integer32;
    dim : constant integer32 := xr'last-1;

  begin
   -- f(f'first) := x(x'first)*x(x'first+1);
    pr := xr(1); pi := xi(1);
    idx := xr'first+1;
    qr := xr(idx);  qi := xi(idx);
    zr := pr*qr - pi*qi;
    zi := pr*qi + pi*qr;
    fr(1) := zr; fi(1) := zi;
    for k in 2..dim loop 
     -- f(k) := f(k-1)*x(k+1);
      pr := zr; pi := zi;
      idx := k+1;
      qr := xr(idx); qi := xi(idx);
      zr := pr*qr - pi*qi;
      zi := pr*qi + pi*qr;
      fr(k) := zr; fi(k) := zi;
    end loop;
   -- b(b'first) := x(x'last)*x(x'last-1);
    pr := xr(xr'last); pi := xi(xr'last);
    idx := xi'last-1;
    qr := xr(idx); qi := xi(idx);
    zr := pr*qr - pi*qi;
    zi := pr*qi + pi*qr;
    br(1) := zr; bi(1) := zi;
    for k in 2..xr'last-2 loop
     -- b(k) := b(k-1)*x(x'last-k);
      pr := zr; pi := zi;
      idx := xr'last-k;
      qr := xr(idx); qi := xi(idx);
      zr := pr*qr - pi*qi;
      zi := pr*qi + pi*qr;
      br(k) := zr; bi(k) := zi;
    end loop;
  end Forward_Backward;

  procedure Fused_Forward_Backward
              ( xr : in Standard_Floating_Vectors.Link_to_Vector;
                xi : in Standard_Floating_Vectors.Link_to_Vector;
                fr : in Standard_Floating_Vectors.Link_to_Vector;
                fi : in Standard_Floating_Vectors.Link_to_Vector;
                br : in Standard_Floating_Vectors.Link_to_Vector;
                bi : in Standard_Floating_Vectors.Link_to_Vector ) is

    zr1,zi1,pr1,pi1,qr1,qi1 : double_float;
    zr2,zi2,pr2,pi2,qr2,qi2 : double_float;
    idx1,idx2 : integer32;
    dim : constant integer32 := xr'last-1;

  begin
   -- f(f'first) := x(x'first)*x(x'first+1);
    pr1 := xr(1); pi1 := xi(1);
    idx1 := xr'first+1;
    qr1 := xr(idx1);  qi1 := xi(idx1);
    zr1 := pr1*qr1 - pi1*qi1;
    zi1 := pr1*qi1 + pi1*qr1;
    fr(1) := zr1; fi(1) := zi1;
   -- b(b'first) := x(x'last)*x(x'last-1);
    pr2 := xr(xr'last); pi2 := xi(xr'last);
    idx2 := xi'last-1;
    qr2 := xr(idx2); qi2 := xi(idx2);
    zr2 := pr2*qr2 - pi2*qi2;
    zi2 := pr2*qi2 + pi2*qr2;
    br(1) := zr2; bi(1) := zi2;
    for k in 2..dim-1 loop 
     -- f(k) := f(k-1)*x(k+1);
      pr1 := zr1; pi1 := zi1;
      idx1 := k+1;
      qr1 := xr(idx1); qi1 := xi(idx1);
      zr1 := pr1*qr1 - pi1*qi1;
      zi1 := pr1*qi1 + pi1*qr1;
      fr(k) := zr1; fi(k) := zi1;
     -- b(k) := b(k-1)*x(x'last-k);
      pr2 := zr2; pi2 := zi2;
      idx2 := xr'last-k;
      qr2 := xr(idx2); qi2 := xi(idx2);
      zr2 := pr2*qr2 - pi2*qi2;
      zi2 := pr2*qi2 + pi2*qr2;
      br(k) := zr2; bi(k) := zi2;
    end loop;
    if dim > 1 then
      pr1 := zr1; pi1 := zi1;
      idx1 := dim+1;
      qr1 := xr(idx1); qi1 := xi(idx1);
      zr1 := pr1*qr1 - pi1*qi1;
      zi1 := pr1*qi1 + pi1*qr1;
      fr(dim) := zr1; fi(dim) := zi1;
    end if;
  end Fused_Forward_Backward;

  procedure Forward_Backward_Cross
              ( x,f,b,c : in Standard_Complex_Vectors.Link_to_Vector ) is

    use Standard_Complex_Numbers;

  begin
    f(f'first) := x(x'first)*x(x'first+1);
    for k in 2..x'last-1 loop
      f(k) := f(k-1)*x(k+1);
    end loop;
    if x'last > 2 then
      b(b'first) := x(x'last)*x(x'last-1);
      for k in 2..x'last-2 loop
        b(k) := b(k-1)*x(x'last-k);
      end loop;
      if x'last = 3 then
        c(1) := x(1)*x(3);
      else
        c(1) := x(1)*b(x'last-3);
        for k in 2..x'last-3 loop
          c(k) := f(k-1)*b(x'last-2-k);
        end loop;
        c(x'last-2) := x(x'last)*f(x'last-3);
      end if;
    end if;
  end Forward_Backward_Cross;

  procedure Forward_Backward_Cross
              ( idx : in Standard_Integer_Vectors.Vector;
                x,f,b,c : in Standard_Complex_Vectors.Link_to_Vector ) is

    use Standard_Complex_Numbers;

  begin
    f(1) := x(idx(1))*x(idx(2));
    for k in 2..idx'last-1 loop
      f(k) := f(k-1)*x(idx(k+1));
    end loop;
    if idx'last > 2 then
      b(b'first) := x(idx(idx'last))*x(idx(idx'last-1));
      for k in 2..idx'last-2 loop
        b(k) := b(k-1)*x(idx(idx'last-k));
      end loop;
      if idx'last = 3 then
        c(1) := x(idx(1))*x(idx(3));
      else
        c(1) := x(idx(1))*b(idx'last-3);
        for k in 2..idx'last-3 loop
          c(k) := f(k-1)*b(idx'last-2-k);
        end loop;
        c(idx'last-2) := x(idx(idx'last))*f(idx'last-3);
      end if;
    end if;
  end Forward_Backward_Cross;

  procedure Fused_Forward_Backward_Cross
              ( x,f,b,c : in Standard_Complex_Vectors.Link_to_Vector ) is

    use Standard_Complex_Numbers;

    firstend,lastend,plusidx,minidx : integer32;

  begin
    if x'last >= 8 then
      if x'last mod 2 = 0 then
        lastend := x'last-4;
        firstend := lastend/2;
        f(f'first) := x(x'first)*x(x'first+1);
        b(b'first) := x(x'last)*x(x'last-1);
        for k in 2..firstend loop
          f(k) := f(k-1)*x(k+1);
          b(k) := b(k-1)*x(x'last-k);
        end loop;
        minidx := firstend+1; plusidx := minidx+1;
        for k in firstend+1..lastend loop
          f(k) := f(k-1)*x(k+1);
          b(k) := b(k-1)*x(x'last-k);
          c(plusidx) := f(plusidx-1)*b(x'last-2-plusidx);
          plusidx := plusidx + 1;
          c(minidx) := f(minidx-1)*b(x'last-2-minidx);
          minidx := minidx - 1;
        end loop;
      else
        lastend := x'last-3;
        firstend := lastend/2;
        f(f'first) := x(x'first)*x(x'first+1);
        b(b'first) := x(x'last)*x(x'last-1);
        for k in 2..firstend loop
          f(k) := f(k-1)*x(k+1);
          b(k) := b(k-1)*x(x'last-k);
        end loop;
        plusidx := firstend+1;
        c(plusidx) := f(plusidx-1)*b(x'last-2-plusidx);
        minidx := plusidx;
        for k in firstend+1..lastend loop
          f(k) := f(k-1)*x(k+1);
          b(k) := b(k-1)*x(x'last-k);
          plusidx := plusidx + 1;
          c(plusidx) := f(plusidx-1)*b(x'last-2-plusidx);
          minidx := minidx - 1;
          c(minidx) := f(minidx-1)*b(x'last-2-minidx);
        end loop;
      end if;
      plusidx := lastend+1;
      f(plusidx) := f(plusidx-1)*x(plusidx+1);
      b(plusidx) := b(plusidx-1)*x(x'last-plusidx);
      plusidx := plusidx+1;
      f(plusidx) := f(plusidx-1)*x(plusidx+1);
      b(plusidx) := b(plusidx-1)*x(x'last-plusidx);
      f(f'last) := f(f'last-1)*x(x'last);
      c(1) := x(1)*b(x'last-3);
      c(x'last-2) := x(x'last)*f(x'last-3);
    else
      f(f'first) := x(x'first)*x(x'first+1);
      b(b'first) := x(x'last)*x(x'last-1);
      for k in 2..x'last-2 loop
        f(k) := f(k-1)*x(k+1);
        b(k) := b(k-1)*x(x'last-k);
      end loop;
      if f'last > 1
       then f(f'last) := f(f'last-1)*x(x'last);
      end if;
      if x'last > 3 then
        c(1) := x(1)*b(x'last-3);
        for k in 2..x'last-3 loop
          c(k) := f(k-1)*b(x'last-2-k);
        end loop;
        c(x'last-2) := x(x'last)*f(x'last-3);
      elsif x'last = 3 then
        c(1) := x(1)*x(3);
      end if;
    end if;
  end Fused_Forward_Backward_Cross;

  procedure Forward_Backward_Cross
              ( xr : in Standard_Floating_Vectors.Link_to_Vector;
                xi : in Standard_Floating_Vectors.Link_to_Vector;
                fr : in Standard_Floating_Vectors.Link_to_Vector;
                fi : in Standard_Floating_Vectors.Link_to_Vector;
                br : in Standard_Floating_Vectors.Link_to_Vector;
                bi : in Standard_Floating_Vectors.Link_to_Vector;
                cr : in Standard_Floating_Vectors.Link_to_Vector;
                ci : in Standard_Floating_Vectors.Link_to_Vector ) is

    zr,zi,pr,pi,qr,qi : double_float;
    idx : integer32;
    dim : constant integer32 := xr'last-1;

  begin
   -- f(f'first) := x(x'first)*x(x'first+1);
    pr := xr(1); pi := xi(1);
    idx := xr'first+1;
    qr := xr(idx);  qi := xi(idx);
    zr := pr*qr - pi*qi;
    zi := pr*qi + pi*qr;
    fr(1) := zr; fi(1) := zi;
    for k in 2..dim loop 
     -- f(k) := f(k-1)*x(k+1);
      pr := zr; pi := zi;
      idx := k+1;
      qr := xr(idx); qi := xi(idx);
      zr := pr*qr - pi*qi;
      zi := pr*qi + pi*qr;
      fr(k) := zr; fi(k) := zi;
    end loop;
   -- b(b'first) := x(x'last)*x(x'last-1);
    pr := xr(xr'last); pi := xi(xr'last);
    idx := xi'last-1;
    qr := xr(idx); qi := xi(idx);
    zr := pr*qr - pi*qi;
    zi := pr*qi + pi*qr;
    br(1) := zr; bi(1) := zi;
    for k in 2..xr'last-2 loop
     -- b(k) := b(k-1)*x(x'last-k);
      pr := zr; pi := zi;
      idx := xr'last-k;
      qr := xr(idx); qi := xi(idx);
      zr := pr*qr - pi*qi;
      zi := pr*qi + pi*qr;
      br(k) := zr; bi(k) := zi;
    end loop;
    if xr'last > 2 then
      if xr'last = 3 then
       -- c(1) := x(1)*x(3)
        pr := xr(1); pi := xi(1);
        qr := xr(3); qi := xi(3);
        zr := pr*qr - pi*qi;
        zi := pr*qi + pi*qr;
        cr(1) := zr; ci(1) := zi;
      else
       -- c(1) := x(1)*b(x'last-3);
        pr := xr(1); pi := xi(1);
        idx := xr'last-3;
        qr := br(idx); qi := bi(idx);
        zr := pr*qr - pi*qi;
        zi := pr*qi + pi*qr;
        cr(1) := zr; ci(1) := zi;
        for k in 2..xr'last-3 loop
         -- c(k) := f(k-1)*b(x'last-2-k);
          idx := k-1;
          pr := fr(idx); pi := fi(idx);
          idx := xr'last-2-k;
          qr := br(idx); qi := bi(idx);
          zr := pr*qr - pi*qi;
          zi := pr*qi + pi*qr;
          cr(k) := zr; ci(k) := zi;
        end loop;
        pr := xr(xr'last); pi := xi(xi'last);
        idx := xr'last-3;
        qr := fr(idx); qi := fi(idx);
        zr := pr*qr - pi*qi;
        zi := pr*qi + pi*qr;
        idx := xr'last-2;
        cr(idx) := zr; ci(idx) := zi;
      end if;
    end if;
  end Forward_Backward_Cross;

  procedure Fused_Forward_Backward_Cross
              ( xr : in Standard_Floating_Vectors.Link_to_Vector;
                xi : in Standard_Floating_Vectors.Link_to_Vector;
                fr : in Standard_Floating_Vectors.Link_to_Vector;
                fi : in Standard_Floating_Vectors.Link_to_Vector;
                br : in Standard_Floating_Vectors.Link_to_Vector;
                bi : in Standard_Floating_Vectors.Link_to_Vector;
                cr : in Standard_Floating_Vectors.Link_to_Vector;
                ci : in Standard_Floating_Vectors.Link_to_Vector ) is

    zr1,zi1,pr1,pi1,qr1,qi1 : double_float;
    zr2,zi2,pr2,pi2,qr2,qi2 : double_float;
    zr3,zi3,pr3,pi3,qr3,qi3 : double_float;
    idx : integer32;
    dim : constant integer32 := xr'last-1;
    firstend,lastend,plusidx,minidx : integer32;

  begin
    if xr'last >= 8 then
      if xr'last mod 2 = 0 then
        lastend := xr'last-4;
        firstend := lastend/2;
       -- f(f'first) := x(x'first)*x(x'first+1);
        pr1 := xr(1); pi1 := xi(1);
        idx := xr'first+1;
        qr1 := xr(idx);  qi1 := xi(idx);
        zr1 := pr1*qr1 - pi1*qi1;
        zi1 := pr1*qi1 + pi1*qr1;
        fr(1) := zr1; fi(1) := zi1;
       -- b(b'first) := x(x'last)*x(x'last-1);
        pr2 := xr(xr'last); pi2 := xi(xr'last);
        idx := xi'last-1;
        qr2 := xr(idx); qi2 := xi(idx);
        zr2 := pr2*qr2 - pi2*qi2;
        zi2 := pr2*qi2 + pi2*qr2;
        br(1) := zr2; bi(1) := zi2;
        for k in 2..firstend loop 
         -- f(k) := f(k-1)*x(k+1);
          pr1 := zr1; pi1 := zi1;
          idx := k+1;
          qr1 := xr(idx); qi1 := xi(idx);
          zr1 := pr1*qr1 - pi1*qi1;
          zi1 := pr1*qi1 + pi1*qr1;
          fr(k) := zr1; fi(k) := zi1;
         -- b(k) := b(k-1)*x(x'last-k);
          pr2 := zr2; pi2 := zi2;
          idx := xr'last-k;
          qr2 := xr(idx); qi2 := xi(idx);
          zr2 := pr2*qr2 - pi2*qi2;
          zi2 := pr2*qi2 + pi2*qr2;
          br(k) := zr2; bi(k) := zi2;
        end loop;
        minidx := firstend+1; plusidx := minidx+1;
        for k in firstend+1..lastend loop
         -- f(k) := f(k-1)*x(k+1);
          pr1 := zr1; pi1 := zi1;
          idx := k+1;
          qr1 := xr(idx); qi1 := xi(idx);
          zr1 := pr1*qr1 - pi1*qi1;
          zi1 := pr1*qi1 + pi1*qr1;
          fr(k) := zr1; fi(k) := zi1;
         -- b(k) := b(k-1)*x(x'last-k);
          pr2 := zr2; pi2 := zi2;
          idx := xr'last-k;
          qr2 := xr(idx); qi2 := xi(idx);
          zr2 := pr2*qr2 - pi2*qi2;
          zi2 := pr2*qi2 + pi2*qr2;
          br(k) := zr2; bi(k) := zi2;
         -- c(plusidx) := f(plusidx-1)*b(x'last-2-plusidx);
          idx := plusidx-1;
          pr3 := fr(idx); pi3 := fi(idx);
          idx := xr'last-2-plusidx;
          qr3 := br(idx); qi3 := bi(idx);
          zr3 := pr3*qr3 - pi3*qi3;
          zi3 := pr3*qi3 + pi3*qr3;
          cr(plusidx) := zr3; ci(plusidx) := zi3;
          plusidx := plusidx + 1;
         -- c(minidx) := f(minidx-1)*b(x'last-2-minidx);
          idx := minidx-1;
          pr3 := fr(idx); pi3 := fi(idx);
          idx := xr'last-2-minidx;
          qr3 := br(idx); qi3 := bi(idx);
          zr3 := pr3*qr3 - pi3*qi3;
          zi3 := pr3*qi3 + pi3*qr3;
          cr(minidx) := zr3; ci(minidx) := zi3;
          minidx := minidx - 1;
        end loop;
        plusidx := lastend+1;
       -- f(plusidx) := f(plusidx-1)*x(plusidx+1);
        pr1 := zr1; pi1 := zi1;
        idx := plusidx+1;
        qr1 := xr(idx); qi1 := xi(idx);
        zr1 := pr1*qr1 - pi1*qi1;
        zi1 := pr1*qi1 + pi1*qr1;
        fr(plusidx) := zr1; fi(plusidx) := zi1;
       -- b(plusidx) := b(plusidx-1)*x(x'last-plusidx);
        pr2 := zr2; pi2 := zi2;
        idx := xr'last-plusidx;
        qr2 := xr(idx); qi2 := xi(idx);
        zr2 := pr2*qr2 - pi2*qi2;
        zi2 := pr2*qi2 + pi2*qr2;
        br(plusidx) := zr2; bi(plusidx) := zi2;
        plusidx := plusidx+1;
       -- f(plusidx) := f(plusidx-1)*x(plusidx+1);
        pr1 := zr1; pi1 := zi1;
        idx := plusidx+1;
        qr1 := xr(idx); qi1 := xi(idx);
        zr1 := pr1*qr1 - pi1*qi1;
        zi1 := pr1*qi1 + pi1*qr1;
        fr(plusidx) := zr1; fi(plusidx) := zi1;
       -- b(plusidx) := b(plusidx-1)*x(x'last-plusidx);
        idx := xr'last-plusidx;
        qr2 := xr(idx); qi2 := xi(idx);
        zr2 := pr2*qr2 - pi2*qi2;
        zi2 := pr2*qi2 + pi2*qr2;
        br(plusidx) := zr2; bi(plusidx) := zi2;
        plusidx := plusidx+1;
       -- f(f'last) := f(f'last-1)*x(x'last);
        pr1 := zr1; pi1 := zi1;
        idx := dim+1;
        qr1 := xr(idx); qi1 := xi(idx);
        zr1 := pr1*qr1 - pi1*qi1;
        zi1 := pr1*qi1 + pi1*qr1;
        fr(dim) := zr1; fi(dim) := zi1;
       -- c(1) := x(1)*b(x'last-3);
        pr3 := xr(1); pi3 := xi(1);
        idx := xr'last-3;
        qr3 := br(idx); qi3 := bi(idx);
        zr3 := pr3*qr3 - pi3*qi3;
        zi3 := pr3*qi3 + pi3*qr3;
        cr(1) := zr3; ci(1) := zi3;
       -- c(x'last-2) := x(x'last)*f(x'last-3);
        pr3 := xr(xr'last); pi3 := xi(xi'last);
        idx := xr'last-3;
        qr3 := fr(idx); qi3 := fi(idx);
        zr3 := pr3*qr3 - pi3*qi3;
        zi3 := pr3*qi3 + pi3*qr3;
        idx := xr'last-2;
        cr(idx) := zr3; ci(idx) := zi3;
      else
        lastend := xr'last-3;
        firstend := lastend/2;
       -- f(f'first) := x(x'first)*x(x'first+1);
        pr1 := xr(1); pi1 := xi(1);
        idx := xr'first+1;
        qr1 := xr(idx);  qi1 := xi(idx);
        zr1 := pr1*qr1 - pi1*qi1;
        zi1 := pr1*qi1 + pi1*qr1;
        fr(1) := zr1; fi(1) := zi1;
       -- b(b'first) := x(x'last)*x(x'last-1);
        pr2 := xr(xr'last); pi2 := xi(xr'last);
        idx := xi'last-1;
        qr2 := xr(idx); qi2 := xi(idx);
        zr2 := pr2*qr2 - pi2*qi2;
        zi2 := pr2*qi2 + pi2*qr2;
        br(1) := zr2; bi(1) := zi2;
        for k in 2..firstend loop 
         -- f(k) := f(k-1)*x(k+1);
          pr1 := zr1; pi1 := zi1;
          idx := k+1;
          qr1 := xr(idx); qi1 := xi(idx);
          zr1 := pr1*qr1 - pi1*qi1;
          zi1 := pr1*qi1 + pi1*qr1;
          fr(k) := zr1; fi(k) := zi1;
         -- b(k) := b(k-1)*x(x'last-k);
          pr2 := zr2; pi2 := zi2;
          idx := xr'last-k;
          qr2 := xr(idx); qi2 := xi(idx);
          zr2 := pr2*qr2 - pi2*qi2;
          zi2 := pr2*qi2 + pi2*qr2;
          br(k) := zr2; bi(k) := zi2;
        end loop;
        plusidx := firstend+1;
       -- c(plusidx) := f(plusidx-1)*b(x'last-2-plusidx);
        idx := plusidx-1;
        pr3 := fr(idx); pi3 := fi(idx);
        idx := xr'last-2-plusidx;
        qr3 := br(idx); qi3 := bi(idx);
        zr3 := pr3*qr3 - pi3*qi3;
        zi3 := pr3*qi3 + pi3*qr3;
        cr(plusidx) := zr3; ci(plusidx) := zi3;
        minidx := plusidx;
        for k in firstend+1..lastend loop
         -- f(k) := f(k-1)*x(k+1);
          pr1 := zr1; pi1 := zi1;
          idx := k+1;
          qr1 := xr(idx); qi1 := xi(idx);
          zr1 := pr1*qr1 - pi1*qi1;
          zi1 := pr1*qi1 + pi1*qr1;
          fr(k) := zr1; fi(k) := zi1;
         -- b(k) := b(k-1)*x(x'last-k);
          pr2 := zr2; pi2 := zi2;
          idx := xr'last-k;
          qr2 := xr(idx); qi2 := xi(idx);
          zr2 := pr2*qr2 - pi2*qi2;
          zi2 := pr2*qi2 + pi2*qr2;
          br(k) := zr2; bi(k) := zi2;
         -- c(plusidx) := f(plusidx-1)*b(x'last-2-plusidx);
          idx := plusidx-1;
          pr3 := fr(idx); pi3 := fi(idx);
          idx := xr'last-2-plusidx;
          qr3 := br(idx); qi3 := bi(idx);
          zr3 := pr3*qr3 - pi3*qi3;
          zi3 := pr3*qi3 + pi3*qr3;
          cr(plusidx) := zr3; ci(plusidx) := zi3;
          plusidx := plusidx + 1;
         -- c(minidx) := f(minidx-1)*b(x'last-2-minidx);
          idx := minidx-1;
          pr3 := fr(idx); pi3 := fi(idx);
          idx := xr'last-2-minidx;
          qr3 := br(idx); qi3 := bi(idx);
          zr3 := pr3*qr3 - pi3*qi3;
          zi3 := pr3*qi3 + pi3*qr3;
          cr(minidx) := zr3; ci(minidx) := zi3;
          minidx := minidx - 1;
        end loop;
        plusidx := lastend+1;
       -- f(plusidx) := f(plusidx-1)*x(plusidx+1);
        pr1 := zr1; pi1 := zi1;
        idx := plusidx+1;
        qr1 := xr(idx); qi1 := xi(idx);
        zr1 := pr1*qr1 - pi1*qi1;
        zi1 := pr1*qi1 + pi1*qr1;
        fr(plusidx) := zr1; fi(plusidx) := zi1;
       -- b(plusidx) := b(plusidx-1)*x(x'last-plusidx);
        pr2 := zr2; pi2 := zi2;
        idx := xr'last-plusidx;
        qr2 := xr(idx); qi2 := xi(idx);
        zr2 := pr2*qr2 - pi2*qi2;
        zi2 := pr2*qi2 + pi2*qr2;
        br(plusidx) := zr2; bi(plusidx) := zi2;
        plusidx := plusidx+1;
       -- f(plusidx) := f(plusidx-1)*x(plusidx+1);
        pr1 := zr1; pi1 := zi1;
        idx := plusidx+1;
        qr1 := xr(idx); qi1 := xi(idx);
        zr1 := pr1*qr1 - pi1*qi1;
        zi1 := pr1*qi1 + pi1*qr1;
        fr(plusidx) := zr1; fi(plusidx) := zi1;
       -- b(plusidx) := b(plusidx-1)*x(x'last-plusidx);
        idx := xr'last-plusidx;
        qr2 := xr(idx); qi2 := xi(idx);
        zr2 := pr2*qr2 - pi2*qi2;
        zi2 := pr2*qi2 + pi2*qr2;
        br(plusidx) := zr2; bi(plusidx) := zi2;
        plusidx := plusidx+1;
       -- f(f'last) := f(f'last-1)*x(x'last);
        pr1 := zr1; pi1 := zi1;
        idx := dim+1;
        qr1 := xr(idx); qi1 := xi(idx);
        zr1 := pr1*qr1 - pi1*qi1;
        zi1 := pr1*qi1 + pi1*qr1;
        fr(dim) := zr1; fi(dim) := zi1;
       -- c(1) := x(1)*b(x'last-3);
        pr3 := xr(1); pi3 := xi(1);
        idx := xr'last-3;
        qr3 := br(idx); qi3 := bi(idx);
        zr3 := pr3*qr3 - pi3*qi3;
        zi3 := pr3*qi3 + pi3*qr3;
        cr(1) := zr3; ci(1) := zi3;
       -- c(x'last-2) := x(x'last)*f(x'last-3);
        pr3 := xr(xr'last); pi3 := xi(xi'last);
        idx := xr'last-3;
        qr3 := fr(idx); qi3 := fi(idx);
        zr3 := pr3*qr3 - pi3*qi3;
        zi3 := pr3*qi3 + pi3*qr3;
        idx := xr'last-2;
        cr(idx) := zr3; ci(idx) := zi3;
      end if;
    else
     -- f(f'first) := x(x'first)*x(x'first+1);
      pr1 := xr(1); pi1 := xi(1);
      idx := xr'first+1;
      qr1 := xr(idx);  qi1 := xi(idx);
      zr1 := pr1*qr1 - pi1*qi1;
      zi1 := pr1*qi1 + pi1*qr1;
      fr(1) := zr1; fi(1) := zi1;
     -- b(b'first) := x(x'last)*x(x'last-1);
      pr2 := xr(xr'last); pi2 := xi(xr'last);
      idx := xi'last-1;
      qr2 := xr(idx); qi2 := xi(idx);
      zr2 := pr2*qr2 - pi2*qi2;
      zi2 := pr2*qi2 + pi2*qr2;
      br(1) := zr2; bi(1) := zi2;
      for k in 2..xr'last-2 loop 
       -- f(k) := f(k-1)*x(k+1);
        pr1 := zr1; pi1 := zi1;
        idx := k+1;
        qr1 := xr(idx); qi1 := xi(idx);
        zr1 := pr1*qr1 - pi1*qi1;
        zi1 := pr1*qi1 + pi1*qr1;
        fr(k) := zr1; fi(k) := zi1;
       -- b(k) := b(k-1)*x(x'last-k);
        pr2 := zr2; pi2 := zi2;
        idx := xr'last-k;
        qr2 := xr(idx); qi2 := xi(idx);
        zr2 := pr2*qr2 - pi2*qi2;
        zi2 := pr2*qi2 + pi2*qr2;
        br(k) := zr2; bi(k) := zi2;
      end loop;
      if dim > 1 then
        pr1 := zr1; pi1 := zi1;
        idx := dim+1;
        qr1 := xr(idx); qi1 := xi(idx);
        zr1 := pr1*qr1 - pi1*qi1;
        zi1 := pr1*qi1 + pi1*qr1;
        fr(dim) := zr1; fi(dim) := zi1;
      end if;
      if xr'last > 2 then
        if xr'last = 3 then
         -- c(1) := x(1)*x(3)
          pr3 := xr(1); pi3 := xi(1);
          qr3 := xr(3); qi3 := xi(3);
          zr3 := pr3*qr3 - pi3*qi3;
          zi3 := pr3*qi3 + pi3*qr3;
          cr(1) := zr3; ci(1) := zi3;
        else
         -- c(1) := x(1)*b(x'last-3);
          pr3 := xr(1); pi3 := xi(1);
          idx := xr'last-3;
          qr3 := br(idx); qi3 := bi(idx);
          zr3 := pr3*qr3 - pi3*qi3;
          zi3 := pr3*qi3 + pi3*qr3;
          cr(1) := zr3; ci(1) := zi3;
          for k in 2..xr'last-3 loop
           -- c(k) := f(k-1)*b(x'last-2-k);
            idx := k-1;
            pr3 := fr(idx); pi3 := fi(idx);
            idx := xr'last-2-k;
            qr3 := br(idx); qi3 := bi(idx);
            zr3 := pr3*qr3 - pi3*qi3;
            zi3 := pr3*qi3 + pi3*qr3;
            cr(k) := zr3; ci(k) := zi3;
          end loop;
          pr3 := xr(xr'last); pi3 := xi(xi'last);
          idx := xr'last-3;
          qr3 := fr(idx); qi3 := fi(idx);
          zr3 := pr3*qr3 - pi3*qi3;
          zi3 := pr3*qi3 + pi3*qr3;
          idx := xr'last-2;
          cr(idx) := zr3; ci(idx) := zi3;
        end if;
      end if;
    end if;
  end Fused_Forward_Backward_Cross;

  procedure Fused_Forward_Backward_Cross
              ( idx : in Standard_Integer_Vectors.Vector;
                xr : in Standard_Floating_Vectors.Link_to_Vector;
                xi : in Standard_Floating_Vectors.Link_to_Vector;
                fr : in Standard_Floating_Vectors.Link_to_Vector;
                fi : in Standard_Floating_Vectors.Link_to_Vector;
                br : in Standard_Floating_Vectors.Link_to_Vector;
                bi : in Standard_Floating_Vectors.Link_to_Vector;
                cr : in Standard_Floating_Vectors.Link_to_Vector;
                ci : in Standard_Floating_Vectors.Link_to_Vector ) is

    zr1,zi1,pr1,pi1,qr1,qi1 : double_float;
    zr2,zi2,pr2,pi2,qr2,qi2 : double_float;
    zr3,zi3,pr3,pi3,qr3,qi3 : double_float;
    ptr : integer32;
    dim : constant integer32 := idx'last-1;
    firstend,lastend,plusidx,minidx : integer32;

  begin
    if idx'last >= 8 then
      if idx'last mod 2 = 0 then
        lastend := idx'last-4;
        firstend := lastend/2;
       -- f(f'first) := x(x'first)*x(x'first+1);
        ptr := idx(1); pr1 := xr(ptr); pi1 := xi(ptr);
        ptr := idx(idx'first+1); qr1 := xr(ptr); qi1 := xi(ptr);
        zr1 := pr1*qr1 - pi1*qi1; zi1 := pr1*qi1 + pi1*qr1;
        fr(1) := zr1; fi(1) := zi1;
       -- b(b'first) := x(x'last)*x(x'last-1);
        ptr := idx(idx'last); pr2 := xr(ptr); pi2 := xi(ptr);
        ptr := idx(idx'last-1); qr2 := xr(ptr); qi2 := xi(ptr);
        zr2 := pr2*qr2 - pi2*qi2; zi2 := pr2*qi2 + pi2*qr2;
        br(1) := zr2; bi(1) := zi2;
        for k in 2..firstend loop 
         -- f(k) := f(k-1)*x(k+1);
          pr1 := zr1; pi1 := zi1;
          ptr := idx(k+1); qr1 := xr(ptr); qi1 := xi(ptr);
          zr1 := pr1*qr1 - pi1*qi1; zi1 := pr1*qi1 + pi1*qr1;
          fr(k) := zr1; fi(k) := zi1;
         -- b(k) := b(k-1)*x(x'last-k);
          pr2 := zr2; pi2 := zi2;
          ptr := idx(idx'last-k); qr2 := xr(ptr); qi2 := xi(ptr);
          zr2 := pr2*qr2 - pi2*qi2; zi2 := pr2*qi2 + pi2*qr2;
          br(k) := zr2; bi(k) := zi2;
        end loop;
        minidx := firstend+1; plusidx := minidx+1;
        for k in firstend+1..lastend loop
         -- f(k) := f(k-1)*x(k+1);
          pr1 := zr1; pi1 := zi1;
          ptr := idx(k+1); qr1 := xr(ptr); qi1 := xi(ptr);
          zr1 := pr1*qr1 - pi1*qi1; zi1 := pr1*qi1 + pi1*qr1;
          fr(k) := zr1; fi(k) := zi1;
         -- b(k) := b(k-1)*x(x'last-k);
          pr2 := zr2; pi2 := zi2;
          ptr := idx(idx'last-k); qr2 := xr(ptr); qi2 := xi(ptr);
          zr2 := pr2*qr2 - pi2*qi2; zi2 := pr2*qi2 + pi2*qr2;
          br(k) := zr2; bi(k) := zi2;
         -- c(plusidx) := f(plusidx-1)*b(x'last-2-plusidx);
          ptr := plusidx-1; pr3 := fr(ptr); pi3 := fi(ptr);
          ptr := idx'last-2-plusidx; qr3 := br(ptr); qi3 := bi(ptr);
          zr3 := pr3*qr3 - pi3*qi3; zi3 := pr3*qi3 + pi3*qr3;
          cr(plusidx) := zr3; ci(plusidx) := zi3;
          plusidx := plusidx + 1;
         -- c(minidx) := f(minidx-1)*b(x'last-2-minidx);
          ptr := minidx-1; pr3 := fr(ptr); pi3 := fi(ptr);
          ptr := idx'last-2-minidx; qr3 := br(ptr); qi3 := bi(ptr);
          zr3 := pr3*qr3 - pi3*qi3; zi3 := pr3*qi3 + pi3*qr3;
          cr(minidx) := zr3; ci(minidx) := zi3;
          minidx := minidx - 1;
        end loop;
        plusidx := lastend+1;
       -- f(plusidx) := f(plusidx-1)*x(plusidx+1);
        pr1 := zr1; pi1 := zi1;
        ptr := idx(plusidx+1); qr1 := xr(ptr); qi1 := xi(ptr);
        zr1 := pr1*qr1 - pi1*qi1; zi1 := pr1*qi1 + pi1*qr1;
        fr(plusidx) := zr1; fi(plusidx) := zi1;
       -- b(plusidx) := b(plusidx-1)*x(x'last-plusidx);
        pr2 := zr2; pi2 := zi2;
        ptr := idx(idx'last-plusidx); qr2 := xr(ptr); qi2 := xi(ptr);
        zr2 := pr2*qr2 - pi2*qi2; zi2 := pr2*qi2 + pi2*qr2;
        br(plusidx) := zr2; bi(plusidx) := zi2;
        plusidx := plusidx+1;
       -- f(plusidx) := f(plusidx-1)*x(plusidx+1);
        pr1 := zr1; pi1 := zi1;
        ptr := idx(plusidx+1); qr1 := xr(ptr); qi1 := xi(ptr);
        zr1 := pr1*qr1 - pi1*qi1; zi1 := pr1*qi1 + pi1*qr1;
        fr(plusidx) := zr1; fi(plusidx) := zi1;
       -- b(plusidx) := b(plusidx-1)*x(x'last-plusidx);
        ptr := idx(idx'last-plusidx); qr2 := xr(ptr); qi2 := xi(ptr);
        zr2 := pr2*qr2 - pi2*qi2; zi2 := pr2*qi2 + pi2*qr2;
        br(plusidx) := zr2; bi(plusidx) := zi2;
        plusidx := plusidx+1;
       -- f(f'last) := f(f'last-1)*x(x'last);
        pr1 := zr1; pi1 := zi1;
        ptr := idx(dim+1); qr1 := xr(ptr); qi1 := xi(ptr);
        zr1 := pr1*qr1 - pi1*qi1; zi1 := pr1*qi1 + pi1*qr1;
        fr(dim) := zr1; fi(dim) := zi1;
       -- c(1) := x(1)*b(x'last-3);
        pr3 := xr(1); pi3 := xi(1);
        ptr := idx'last-3; qr3 := br(ptr); qi3 := bi(ptr);
        zr3 := pr3*qr3 - pi3*qi3; zi3 := pr3*qi3 + pi3*qr3;
        cr(1) := zr3; ci(1) := zi3;
       -- c(x'last-2) := x(x'last)*f(x'last-3);
        ptr := idx(idx'last); pr3 := xr(ptr); pi3 := xi(ptr);
        ptr := idx'last-3; qr3 := fr(ptr); qi3 := fi(ptr);
        zr3 := pr3*qr3 - pi3*qi3; zi3 := pr3*qi3 + pi3*qr3;
        ptr := idx'last-2; cr(ptr) := zr3; ci(ptr) := zi3;
      else
        lastend := idx'last-3;
        firstend := lastend/2;
       -- f(f'first) := x(x'first)*x(x'first+1);
        ptr := idx(1); pr1 := xr(ptr); pi1 := xi(ptr);
        ptr := idx(idx'first+1); qr1 := xr(ptr); qi1 := xi(ptr);
        zr1 := pr1*qr1 - pi1*qi1; zi1 := pr1*qi1 + pi1*qr1;
        fr(1) := zr1; fi(1) := zi1;
       -- b(b'first) := x(x'last)*x(x'last-1);
        ptr := idx(idx'last); pr2 := xr(ptr); pi2 := xi(ptr);
        ptr := idx(idx'last-1); qr2 := xr(ptr); qi2 := xi(ptr);
        zr2 := pr2*qr2 - pi2*qi2; zi2 := pr2*qi2 + pi2*qr2;
        br(1) := zr2; bi(1) := zi2;
        for k in 2..firstend loop 
         -- f(k) := f(k-1)*x(k+1);
          pr1 := zr1; pi1 := zi1;
          ptr := idx(k+1); qr1 := xr(ptr); qi1 := xi(ptr);
          zr1 := pr1*qr1 - pi1*qi1; zi1 := pr1*qi1 + pi1*qr1;
          fr(k) := zr1; fi(k) := zi1;
         -- b(k) := b(k-1)*x(x'last-k);
          pr2 := zr2; pi2 := zi2;
          ptr := idx(idx'last-k); qr2 := xr(ptr); qi2 := xi(ptr);
          zr2 := pr2*qr2 - pi2*qi2; zi2 := pr2*qi2 + pi2*qr2;
          br(k) := zr2; bi(k) := zi2;
        end loop;
        plusidx := firstend+1;
       -- c(plusidx) := f(plusidx-1)*b(x'last-2-plusidx);
        ptr := plusidx-1; pr3 := fr(ptr); pi3 := fi(ptr);
        ptr := idx'last-2-plusidx; qr3 := br(ptr); qi3 := bi(ptr);
        zr3 := pr3*qr3 - pi3*qi3; zi3 := pr3*qi3 + pi3*qr3;
        cr(plusidx) := zr3; ci(plusidx) := zi3;
        minidx := plusidx;
        for k in firstend+1..lastend loop
         -- f(k) := f(k-1)*x(k+1);
          pr1 := zr1; pi1 := zi1;
          ptr := idx(k+1); qr1 := xr(ptr); qi1 := xi(ptr);
          zr1 := pr1*qr1 - pi1*qi1; zi1 := pr1*qi1 + pi1*qr1;
          fr(k) := zr1; fi(k) := zi1;
         -- b(k) := b(k-1)*x(x'last-k);
          pr2 := zr2; pi2 := zi2;
          ptr := idx(idx'last-k); qr2 := xr(ptr); qi2 := xi(ptr);
          zr2 := pr2*qr2 - pi2*qi2; zi2 := pr2*qi2 + pi2*qr2;
          br(k) := zr2; bi(k) := zi2;
         -- c(plusidx) := f(plusidx-1)*b(x'last-2-plusidx);
          ptr := plusidx-1; pr3 := fr(ptr); pi3 := fi(ptr);
          ptr := idx'last-2-plusidx; qr3 := br(ptr); qi3 := bi(ptr);
          zr3 := pr3*qr3 - pi3*qi3; zi3 := pr3*qi3 + pi3*qr3;
          cr(plusidx) := zr3; ci(plusidx) := zi3;
          plusidx := plusidx + 1;
         -- c(minidx) := f(minidx-1)*b(x'last-2-minidx);
          ptr := minidx-1; pr3 := fr(ptr); pi3 := fi(ptr);
          ptr := idx'last-2-minidx; qr3 := br(ptr); qi3 := bi(ptr);
          zr3 := pr3*qr3 - pi3*qi3; zi3 := pr3*qi3 + pi3*qr3;
          cr(minidx) := zr3; ci(minidx) := zi3;
          minidx := minidx - 1;
        end loop;
        plusidx := lastend+1;
       -- f(plusidx) := f(plusidx-1)*x(plusidx+1);
        pr1 := zr1; pi1 := zi1;
        ptr := idx(plusidx+1); qr1 := xr(ptr); qi1 := xi(ptr);
        zr1 := pr1*qr1 - pi1*qi1; zi1 := pr1*qi1 + pi1*qr1;
        fr(plusidx) := zr1; fi(plusidx) := zi1;
       -- b(plusidx) := b(plusidx-1)*x(x'last-plusidx);
        pr2 := zr2; pi2 := zi2;
        ptr := idx(idx'last-plusidx); qr2 := xr(ptr); qi2 := xi(ptr);
        zr2 := pr2*qr2 - pi2*qi2; zi2 := pr2*qi2 + pi2*qr2;
        br(plusidx) := zr2; bi(plusidx) := zi2;
        plusidx := plusidx+1;
       -- f(plusidx) := f(plusidx-1)*x(plusidx+1);
        pr1 := zr1; pi1 := zi1;
        ptr := idx(plusidx+1); qr1 := xr(ptr); qi1 := xi(ptr);
        zr1 := pr1*qr1 - pi1*qi1; zi1 := pr1*qi1 + pi1*qr1;
        fr(plusidx) := zr1; fi(plusidx) := zi1;
       -- b(plusidx) := b(plusidx-1)*x(x'last-plusidx);
        ptr := idx(idx'last-plusidx); qr2 := xr(ptr); qi2 := xi(ptr);
        zr2 := pr2*qr2 - pi2*qi2; zi2 := pr2*qi2 + pi2*qr2;
        br(plusidx) := zr2; bi(plusidx) := zi2;
        plusidx := plusidx+1;
       -- f(f'last) := f(f'last-1)*x(x'last);
        pr1 := zr1; pi1 := zi1;
        ptr := idx(dim+1); qr1 := xr(ptr); qi1 := xi(ptr);
        zr1 := pr1*qr1 - pi1*qi1; zi1 := pr1*qi1 + pi1*qr1;
        fr(dim) := zr1; fi(dim) := zi1;
       -- c(1) := x(1)*b(x'last-3);
        ptr := idx(1); pr3 := xr(ptr); pi3 := xi(ptr);
        ptr := idx'last-3; qr3 := br(ptr); qi3 := bi(ptr);
        zr3 := pr3*qr3 - pi3*qi3; zi3 := pr3*qi3 + pi3*qr3;
        cr(1) := zr3; ci(1) := zi3;
       -- c(x'last-2) := x(x'last)*f(x'last-3);
        ptr := idx(idx'last); pr3 := xr(ptr); pi3 := xi(ptr);
        ptr := idx'last-3; qr3 := fr(ptr); qi3 := fi(ptr);
        zr3 := pr3*qr3 - pi3*qi3; zi3 := pr3*qi3 + pi3*qr3;
        ptr := idx'last-2;
        cr(ptr) := zr3; ci(ptr) := zi3;
      end if;
    else
     -- f(f'first) := x(x'first)*x(x'first+1);
      ptr := idx(1); pr1 := xr(ptr); pi1 := xi(ptr);
      ptr := idx(idx'first+1); qr1 := xr(ptr); qi1 := xi(ptr);
      zr1 := pr1*qr1 - pi1*qi1; zi1 := pr1*qi1 + pi1*qr1;
      fr(1) := zr1; fi(1) := zi1;
      if idx'last > 2 then
       -- b(b'first) := x(x'last)*x(x'last-1);
        ptr := idx(idx'last); pr2 := xr(ptr); pi2 := xi(ptr);
        ptr := idx(idx'last-1); qr2 := xr(ptr); qi2 := xi(ptr);
        zr2 := pr2*qr2 - pi2*qi2; zi2 := pr2*qi2 + pi2*qr2;
        br(1) := zr2; bi(1) := zi2;
        for k in 2..idx'last-2 loop 
         -- f(k) := f(k-1)*x(k+1);
          pr1 := zr1; pi1 := zi1;
          ptr := idx(k+1); qr1 := xr(ptr); qi1 := xi(ptr);
          zr1 := pr1*qr1 - pi1*qi1; zi1 := pr1*qi1 + pi1*qr1;
          fr(k) := zr1; fi(k) := zi1;
         -- b(k) := b(k-1)*x(x'last-k);
          pr2 := zr2; pi2 := zi2;
          ptr := idx(idx'last-k); qr2 := xr(ptr); qi2 := xi(ptr);
          zr2 := pr2*qr2 - pi2*qi2; zi2 := pr2*qi2 + pi2*qr2;
          br(k) := zr2; bi(k) := zi2;
        end loop;
        if dim > 1 then
          pr1 := zr1; pi1 := zi1;
          ptr := idx(dim+1); qr1 := xr(ptr); qi1 := xi(ptr);
          zr1 := pr1*qr1 - pi1*qi1; zi1 := pr1*qi1 + pi1*qr1;
          fr(dim) := zr1; fi(dim) := zi1;
        end if;
        if idx'last = 3 then
         -- c(1) := x(1)*x(3)
          ptr := idx(1); pr3 := xr(ptr); pi3 := xi(ptr);
          ptr := idx(3); qr3 := xr(ptr); qi3 := xi(ptr);
          zr3 := pr3*qr3 - pi3*qi3; zi3 := pr3*qi3 + pi3*qr3;
          cr(1) := zr3; ci(1) := zi3;
        else
         -- c(1) := x(1)*b(x'last-3);
          ptr := idx(1); pr3 := xr(ptr); pi3 := xi(ptr);
          ptr := idx'last-3; qr3 := br(ptr); qi3 := bi(ptr);
          zr3 := pr3*qr3 - pi3*qi3; zi3 := pr3*qi3 + pi3*qr3;
         -- put("Assigning "); put(zr3); put_line(" to cr(1)");
         -- put("Assigning "); put(zi3); put_line(" to ci(1)");
          cr(1) := zr3; ci(1) := zi3;
          for k in 2..idx'last-3 loop
           -- c(k) := f(k-1)*b(x'last-2-k);
            ptr := k-1; pr3 := fr(ptr); pi3 := fi(ptr);
            ptr := idx'last-2-k; qr3 := br(ptr); qi3 := bi(ptr);
            zr3 := pr3*qr3 - pi3*qi3; zi3 := pr3*qi3 + pi3*qr3;
            cr(k) := zr3; ci(k) := zi3;
          end loop;
          ptr := idx(idx'last); pr3 := xr(ptr); pi3 := xi(ptr);
          ptr := idx'last-3; qr3 := fr(ptr); qi3 := fi(ptr);
          zr3 := pr3*qr3 - pi3*qi3; zi3 := pr3*qi3 + pi3*qr3;
          ptr := idx'last-2; cr(ptr) := zr3; ci(ptr) := zi3;
        end if;
      end if;
    end if;
  end Fused_Forward_Backward_Cross;

  function Allocate
             ( mxe : Standard_Integer_Vectors.Vector )
             return Standard_Complex_VecVecs.VecVec is

    res : Standard_Complex_VecVecs.VecVec(mxe'range);
    zero : constant Standard_Complex_Numbers.Complex_Number
         := Standard_Complex_Numbers.Create(0.0);

  begin
    for k in mxe'range loop
      if mxe(k) > 1 then
        res(k) := new Standard_Complex_Vectors.Vector'(1..mxe(k)-1 => zero);
      end if;
    end loop;
    return res;
  end Allocate;

  function Allocate
             ( mxe : Standard_Integer_Vectors.Vector )
             return Standard_Floating_VecVecs.VecVec is

    res : Standard_Floating_VecVecs.VecVec(mxe'range);

  begin
    for k in mxe'range loop
      if mxe(k) > 1 then
        res(k) := new Standard_Floating_Vectors.Vector'(1..mxe(k)-1 => 0.0);
      end if;
    end loop;
    return res;
  end Allocate;

  procedure Power_Table
              ( mxe : in Standard_Integer_Vectors.Vector;
                x : in Standard_Complex_Vectors.Link_to_Vector;
                pwt : in Standard_Complex_VecVecs.VecVec ) is

    lnk : Standard_Complex_Vectors.Link_to_Vector;

    use Standard_Complex_Numbers;

  begin
    for k in x'range loop
      if mxe(k) > 1 then
        lnk := pwt(k);
        lnk(1) := x(k)*x(k);
        for i in 2..mxe(k)-1 loop
          lnk(i) := lnk(i-1)*x(k);
        end loop;
      end if;
    end loop;
  end Power_Table;

  procedure Power_Table
              ( mxe : in Standard_Integer_Vectors.Vector;
                xr : in Standard_Floating_Vectors.Link_to_Vector;
                xi : in Standard_Floating_Vectors.Link_to_Vector;
                rpwt : in Standard_Floating_VecVecs.VecVec;
                ipwt : in Standard_Floating_VecVecs.VecVec ) is

    rlnk : Standard_Floating_Vectors.Link_to_Vector;
    ilnk : Standard_Floating_Vectors.Link_to_Vector;
    zr,zi,yr,yi,xrk,xik : double_float;

  begin
    for k in xr'range loop
      if mxe(k) > 1 then
        rlnk := rpwt(k); ilnk := ipwt(k);
       -- lnk(1) := x(k)*x(k);
        xrk := xr(k); xik := xi(k);
        zr := xrk*xrk - xik*xik;
        zi := 2.0*xrk*xik;
        rlnk(1) := zr; ilnk(1) := zi;
        for i in 2..mxe(k)-1 loop
         -- lnk(i) := lnk(i-1)*x(k);
          yr := zr; yi := zi;
          zr := xrk*yr - xik*yi;
          zi := xrk*yi + xik*yr;
          rlnk(i) := zr; ilnk(i) := zi;
        end loop;
      end if;
    end loop;
  end Power_Table;

end Standard_Coefficient_Circuits;