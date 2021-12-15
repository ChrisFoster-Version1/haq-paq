//--------------------------------------------------------------------------//
//                          Version1 General Utilities                      //
//--------------------------------------------------------------------------//


//////////////////////////////////////////////////////////////////////////////

//                          Misc Utilities                                  //


// Setting up a dictionary without a specified type
.ut.makeDictGenType:{[dict]
  (enlist[`]!enlist(::)),dict
 }

// Takes a list column and a boolean column as inputs (list of lists)
// example: t:0!select side,v by id from([]id:5?`k`l`n;side:5?`b`s;v:5?100)
//          select id,.ut.indexListCl[v;side=`b]from t
.ut.indexListCl:{[cl_list;bool_list]
  cl_list@'where each bool_list
 }
