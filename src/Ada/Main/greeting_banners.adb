package body Greeting_Banners is

  function Version return string is

    res : constant string := "PHCv2.4.14 released 2016-03-25";

  begin
    return res;
  end Version;

end Greeting_Banners;
