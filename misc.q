//--------------------------------------------------------------------------//
//                          Version1 General Utilities                      //
//--------------------------------------------------------------------------//


//////////////////////////////////////////////////////////////////////////////

//                          Misc Utilities                                  //

// Thomas miro
// Setting up a dictionary without a specified type
.ut.agnostic:{(enlist[ `]!enlist(::)),x}

// Chris miro
// Takes a list column and a boolean column as inputs (list of lists)
// example: t:0!select side,v by id from([]id:5?`k`l`n;side:5?`b`s;v:5?100)
//          select id,.ut.indexListCl[v;side=`b]from t
.ut.indexListCl:{[c;b]c@'where each b}