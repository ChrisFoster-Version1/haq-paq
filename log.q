//--------------------------------------------------------------------------//
//                          Version1 General Utilities                      //
//--------------------------------------------------------------------------//


//////////////////////////////////////////////////////////////////////////////

//                          Log Utilities                                   //


// Kyle miro
// Format memstats to write to log
.log.getMemStats:{[]
  "|" sv "=" sv/: string key[w],'value w:.Q.w[]
 }

// Chris miro
// Basic loggers
// Could add a true/false flag to stop updating into the table for errors
.log.Error:flip`time`message!"ps"$\:()
.log.info:{[msg]
  1 "INFO ",.log.getMemStats[]," ",msg;
 }
 
.log.error:{[msg]
  2 "INFO ",.log.getMemStats[]," ",msg;`.log.Error upsert (.z.p;`$msg)
 }