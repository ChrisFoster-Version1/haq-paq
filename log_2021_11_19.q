//--------------------------------------------------------------------------//
//                          Version1 General Utilities                      //
//--------------------------------------------------------------------------//


//////////////////////////////////////////////////////////////////////////////

//                          Log Utilities                                   //


// Kyle miro
// Format memstats to write to log
.ut.formatMemStats:{[]"|" sv "=" sv/: string key[w],'value w:.Q.w[]}

// Chris miro
// Basic loggers
// Could add a true/false flag to stop updating into the table for errors
Error:flip`time`message!"ps"$\:()
logInfo:{[msg]1 "INFO ",.ut.formatMemStats[]," ",msg;}
errInfo:{[msg]2 "INFO ",.ut.formatMemStats[]," ",msg;`Error upsert (.z.p;`$msg)}