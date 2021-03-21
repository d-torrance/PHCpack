with unchecked_deallocation;
with Standard_Complex_Numbers;
with Standard_Complex_Vectors;

package body Standard_Complex_VecVecVecs is

  procedure Allocate ( v : out Link_to_VecVecVec;
                       d1first,d1last : in integer32;
                       d2first,d2last : in integer32;
                       d3first,d3last : in integer32 ) is

    res : Standard_Complex_VecVecVecs.VecVecVec(d1first..d1last);
    zero : constant Standard_Complex_Numbers.Complex_Number 
         := Standard_Complex_Numbers.Create(0.0);

  begin
    for k in res'range loop
      declare
        vv : Standard_Complex_VecVecs.VecVec(d2first..d2last);
      begin
        for j in vv'range loop
          declare
            vvv : constant Standard_Complex_Vectors.Vector(d3first..d3last)
                := (d3first..d3last => zero);
          begin
            vv(j) := new Standard_Complex_Vectors.Vector'(vvv);
          end;
        end loop;
        res(k) := new Standard_Complex_VecVecs.VecVec'(vv);
      end;
    end loop;
    v := new Standard_Complex_VecVecVecs.VecVecVec'(res);
  end Allocate;

  procedure Copy ( v_from : in Link_to_VecVecVec;
                   v_to : out Link_to_VecVecVec ) is

    use Standard_Complex_VecVecs;

  begin
    Clear(v_to);
    if v_from /= null then
      declare
        pwt : VecVecVec(v_from'range);
      begin
        for k in v_from'range loop
          if v_from(k) /= null then
            declare
              vv : Standard_Complex_VecVecs.VecVec(v_from(k)'range);
            begin
              Standard_Complex_VecVecs.Copy(v_from(k).all,vv);
              pwt(k) := new Standard_Complex_VecVecs.VecVec'(vv);
            end;
          end if;
        end loop;
        v_to := new VecVecVec'(pwt);
      end;
    end if;
  end Copy;

  procedure Clear ( v : in out VecVecVec ) is
  begin
    for k in v'range loop
      Standard_Complex_VecVecs.Deep_Clear(v(k));
    end loop;
  end Clear;

  procedure Clear ( v : in out Link_to_VecVecVec ) is

    procedure free is new unchecked_deallocation(VecVecVec,Link_to_VecVecVec);

  begin
    if v /= null then
      Clear(v.all);
      free(v);
    end if;
  end Clear;

  procedure Clear ( v : in out VecVecVec_Array ) is
  begin
    for k in v'range loop
      Clear(v(k));
    end loop;
  end Clear;

end Standard_Complex_VecVecVecs;
