with Standard_Natural_Numbers;          use Standard_Natural_Numbers;
with Standard_Integer_Numbers;          use Standard_Integer_Numbers;
with C_Integer_Arrays;                  use C_Integer_Arrays;

package Symbol_Table_Interface is

  function Symbol_Table_Size
             ( a : C_intarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32;

  -- DESCRIPTION :
  --   Returns the number of symbols in the symbol table.

  -- ON ENTRY :
  --   vrblvl  the verbose level.

  -- ON RETURN :
  --   a       the number of symbols.

  function Symbol_Table_Write
             ( vrblvl : integer32 := 0 ) return integer32;

  -- DESCRIPTION :
  --   Writes the symbols stored in the table to screen.

  function Characters_of_Symbol ( i : natural32 ) return string;

  -- DESCRIPTION :
  --   Returns the non-blank characters of the i-th symbol.

  function String_of_Symbols ( i : natural32 ) return string;

  -- DESCRIPTION :
  --   Returns a string of all symbols in the symbol table,
  --   separated by one space.

  function Symbol_Table_String
             ( a : C_intarrs.Pointer;
               b : C_intarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32;

  -- DESCRIPTION :
  --   Returns the string that contains all symbols in the table.

  -- ON ENTRY :
  --   vrblvl  the verbose level.

  -- ON RETURN :
  --   a       the number of characters in b;
  --   b       the string of symbols,
  --           symbols are separated by one space.

  function Symbol_Table_Sort_Embedded 
             ( a : C_intarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32;

  -- DESCRIPTION :
  --   Sorts the symbols added in the embedding,
  --   also in the system stored in double precision.
 
  -- ON ENTRY :
  --   vrblvl the verbose level.

  -- ON RETURN :
  --   a       number of embedded symbols sorted.

  function Symbol_Table_Remove_by_Index
             ( a : C_intarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32;

  -- DESCRIPTION :
  --   Removes a symbol from the table,
  --   the symbol is defined by its given index.

  -- ON ENTRY :
  --   a       index of the symbol that will be removed;
  --   vrblvl  the verbose level.

  function Symbol_Table_Remove_by_Name
             ( a : C_intarrs.Pointer;
               b : C_intarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32;

  -- DESCRIPTION :
  --   Removes a symbol from the table,
  --   the symbol is defined by its given name.

  -- ON ENTRY :
  --   a       number of characters in b;
  --   b       the name of the symbol that will be removed;
  --   vrblvl  the verbose level.

end Symbol_Table_Interface;
