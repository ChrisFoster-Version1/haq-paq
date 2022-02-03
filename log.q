//--------------------------------------------------------------------------//
//                          Version 1 General Utilities                     //
//--------------------------------------------------------------------------//


//////////////////////////////////////////////////////////////////////////////

//                          Log Utilities                                   //


/ Format memstats to write to log
/ @return (String) Pipe separated memory stats
.log.getMemStats:{[]
  "|" sv "=" sv/: string key[w],'value w:.Q.w[]
 };

// Basic loggers
// Could add a true/false flag to stop updating into the table for errors
/ Table storing error messages
.log.Error:flip`time`message!"ps"$\:()
/ Publish to stdout
/ @param msg (String) Log message
.log.publishInfo:{[msg]
  1 "INFO ",.log.getMemStats[]," ",msg;
 };

/ Publish to stderr
/ @param msg (String) Log message
.log.publishError:{[msg]
  2 "ERROR ",.log.getMemStats[]," ",msg;`.log.Error upsert (.z.p;`$msg)
 };
