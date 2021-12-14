//--------------------------------------------------------------------------//
//                          Version1 General Utilities                      //
//--------------------------------------------------------------------------//


//////////////////////////////////////////////////////////////////////////////

//                          Log Utilities                                   //


// Format memstats to write to log
.log.getMemStats:{[]
  "|" sv "=" sv/: string key[w],'value w:.Q.w[]
 };

// Basic loggers
// Could add a true/false flag to stop updating into the table for errors
.log.Error:flip`time`message!"ps"$\:()
.log.publishInfo:{[msg]
  1 "INFO ",.log.getMemStats[]," ",msg;
 };
 
.log.publishError:{[msg]
  2 "ERROR ",.log.getMemStats[]," ",msg;`.log.Error upsert (.z.p;`$msg)
 };
