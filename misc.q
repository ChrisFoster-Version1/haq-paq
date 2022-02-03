//--------------------------------------------------------------------------//
//                          Version 1 General Utilities                     //
//--------------------------------------------------------------------------//


//////////////////////////////////////////////////////////////////////////////

//                          Misc Utilities                                  //


/ Set up a dictionary without a specified type
/ @param dict (Dict) Dictionary
/ @return (Dict) Dictionary of non-specified type
.ut.makeDictGenType:{[dict]
  (enlist[`]!enlist(::)),dict
 };

/ Index into list columns of a table
/ @param columns (SymbolList) Columns
/ @param booleans (BooleanList) Nested Boolean lists
// example: t:0!select side,v by id from([]id:5?`k`l`n;side:5?`b`s;v:5?100)
//          select id,.ut.indexListColumns[v;side=`b]from t
.ut.indexListColumns:{[columns;booleans]
  columns@'where each booleans
 };
