//--------------------------------------------------------------------------//
//                          Version 1 General Utilities                     //
//--------------------------------------------------------------------------//


//////////////////////////////////////////////////////////////////////////////

//                          Misc Utilities                                  //


<<<<<<< HEAD
/ Set up a dictionary without a specified type
=======
/ create generically-typed version of a given dictionary
>>>>>>> 6a144ce7df097ede9b48eae78c06115aa895e6ca
/ @param dict (Dict) Dictionary
/ @return (Dict) Dictionary of non-specified type
.misc.makeDictGenType:{[dict]
  (enlist[`]!enlist(::)),dict
 };

/ Index into list columns of a table
/ @param columns (SymbolList) Columns
/ @param booleans (BooleanList) Nested Boolean lists
/ @return (SymbolList) Columns
// example: t:0!select side,v by id from([]id:5?`k`l`n;side:5?`b`s;v:5?100)
//          select id,.ut.indexListColumns[v;side=`b]from t
.misc.indexListColumns:{[columns;booleans]
  columns@'where each booleans
 };

/ Get count of sym file
/ @param sym (Symbol) Path to sym file
/ @return (Int) Count of sym file
.misc.getSymCount:{[sym]
  sum 0x00=8_read1 sym
 };
