//--------------------------------------------------------------------------//
//                          Version 1 Genernal Utilities                    //
//--------------------------------------------------------------------------//


//////////////////////////////////////////////////////////////////////////////

//                          Table Utilities                                 //


/ Returns resolved table if a reference to a table is passed
/ @param tblOrSym (Table|Symbol) Table or reference to a table to resolve
/ @return (Table) Resolved table
.tbl.resolve:{[tblOrSym]
  $[-11h=type tblOrSym;value;]tblOrSym
 };

/ Denumerate table or reference to a table
/ @param tblOrSym (Table|Symbol) Table or reference to a table to resolve
/ @return (Table) Denumerated table
/ @see .tbl.resolve
.tbl.denum:{[tblOrSym]
  enumCols:where (type each flip res:0!.tbl.resolve tblOrSym)within 20 76h;
  keys[tblOrSym]xkey ![res;();0b;enumCols!value ,/:enumCols]
 };

/ Creating a pivot table dynamically 
/ @param tbl (Table) table 
/ @param g (Symbol) column to group by
/ @param c (Symbol) column to become the key of pivot table
/ @param v (Symbol) column which becomes the values in the pivot table
/ @return (Table) Pivot table
.tbl.createPivot:{[tbl;g;c;v]
  s:asc?[tbl;();();(distinct;c)];
  ?[tbl;();enlist[g]!enlist g;](#;enlist s;(!;c;v))
 };

/ Multi pivot for x columns
/ @param tbl (Table) table 
/ @param g (Symbol) column to group by
/ @param c (Symbol) column to become the key of pivot table
/ @param vl (SymbolList) column(s) which becomes the values in the pivot table
/ @return (Table) Pivot table
/ @see .tbl.createPivot
.tbl.createMultiPivot:{[tbl;g;c;vl]
  raze{[tbl;g;c;v](`ky,g) xkey update ky:v from .tbl.createPivot[tbl;g;c;v]}[tbl;g;c]each vl
 };

/ Convert from a pivot table to a normal kdb table
/ @param tbl (Table) Pivot table 
/ @param g (Symbol) column which is grouped
/ @param c (Symbol) column which is the key of the pivot table
/ @param v (Symbol) column which becomes the values in the pivot table
/ @return (Table) normal table
.tbl.convertFromPivot:{[tbl;g;c;v]
  tbl:0!tbl;
  cls:cols[tbl]except g;
  flip (g;c;v)!raze each(count[cls]#enlist ?[tbl;();();g];count[tbl]#/:cls;tbl cls)
 };

/ Create link(s) between a table of data and x other tables
/ @param tbl (Table) Table of data to add links
/ @param lnkTbl (SymbolList) Global table names which will be linked to the data
/ @return (Table) The first table input with the links added from the global tables
.tbl.llink:{[tbl;lnkTbl]
  tbl lj k xkey?[lnkTbl;();0b;](k,lower lnkTbl)!(k:keys lnkTbl),enlist(!;enlist lnkTbl;`i)
 }/;

/ Relinking data to a table which has a link and the static (ish) table has been updated
/ @param tbl (Table) the update of the link reference table 
/ @param gt (Symbol) Global table
/ @param lt (Symbol) Linked table
/ @return (Symbol) name of updated table.
/ @see .tbl.llink
.tbl.relink:{[tbl;gt;lt]
  ky:keys tbl;
  tbl:?[gt;;0b;()]enlist(in;(flip;(!;enlist ky;enlist,ky));key tbl);
  gt upsert .tbl.llink[tbl;lt]
 };

/ Checks what tables are linked to the input 
/ @param tblName (Symbol) table name 
/ @return (SymbolList) list of tables that have the input linked to them
.tbl.isLinked:{[tblName]
  where tables[]!{x in fkeys y}[tblName]each tables`
 }

/ Resaves the splay table with all columns truncated to the length of the shortest one
/ <br> As previously columns of the splay had different lengths </br>
/ @param dir (Symbol) Directory where splay table is stored
.tbl.fixSplayCnt:{[dir]
  m:min count each c:get each `$(string[dir],"/"),/:string cols dir;
  (hsym `$string[dir],"/") set flip cols[dir]!m#/:c
 };

/ Outputs csv as a table of strings without user counting number of columns
/ @param file (Symbol) filename
/ @return (Table) table of strings from input CSV, without need to count CSV's number of columns
.tbl.loadCsvWithStrings:{[file]
  n:1+sum ","=first c:read0 file;
  (n#"*";enlist",")0:c
 };

/ Convert a csv file passed of a schema
/ @param file (Symbol) csv file 
/ @param tbl (Table|Symbol) raw table or table name as a symbol 
/ @return (Table) returns a table converted from a csv
.tbl.loadCsvWithSchema:{[file;tbl]
  (upper (0!meta tbl)`t;enlist",")0:file
 };

/ Check if a table is keyed or not
/ @param tab (Table|Symbol) table or table name 
/ @return (Boolean) True/False depending on if it passed
.tbl.isKeyed:{[tbl]
  0<count keys tbl
 };
 
/ Runs a comparison between 2 tables for the columns in those tables
/ <br>If the table is keyed will only consider the keyed columns </br>
/ @param f (Function) function to do comparison inter/except etc
/ @param tbl1 (Table) table 
/ @param tbl2 (Table) table 
/ @return (Table) Subset of data depending on the function
/ @see .tbl.isKeyed
.tbl.comparison:{[f;tbl1;tbl2]
  b1:$[.tbl.isKeyed tbl1;keys;cols] tbl1;
  b2:$[.tbl.isKeyed tbl2;keys;cols] tbl2;
  cls:b1 inter b2;
  (f). ?[;();0b;cls!cls]each(tbl1;tbl2)
 };

/ Projection of comparison for just except
/ @param tbl1 (Table) table 
/ @param tbl2 (Table) table 
/ @return (Table) Subset of data after doing except
/ @see .tbl.comparison
.tbl.compExcept:.tbl.comparison[except];

/ Projection of comparison for just inter
/ @param tbl1 (Table) table 
/ @param tbl2 (Table) table 
/ @return (Table) Subset of data after doing inter 
/ @see .tbl.comparison
.tbl.compInter:.tbl.comparison[inter];

/ Compare 2 tables for a specific check
/ @param tbl1 (Table) table 
/ @param tbl2 (Table) table 
/ @param check (Symbol) 3 types of checks `identical/`count/`subset
/ @return (Boolean) True/False depending if test passes
.tbl.tabCompare:{[tbl1;tbl2;check]
  if[check~`identical;:(~).-8!/:(tbl1;tbl2)];
  if[check~`count;:count[tbl1]~count tbl2];
  if[check~`subset;:0=count tbl2 except tbl1]
 };

/ Rename columns in a table using a map (for pre3.6 versions of kdb+)
/ @param dict (Dict) dictionary to rename cols
/ @param tbl (Table) table
/ @return (Table) table with renamed columns specified in the dictionary
.tbl.renameColumns:{[dict;tbl]
  {y^x y}[dict;cols tbl] xcol tbl
 };

/ Integer partition database disk space stats
/ @param tblName (Symbol) table name
/ @return (Table) Of stats for disk space used for hdb
.tbl.getIntDBSize:{[tblName]
  name:"*",tblName,"*";
  res1:system"du | awk '{ print $1\"|\"$2}'";
  tbl:update name:intMap int from
        0!select first"J"$num_size by int:"I"$partition inter\: .Q.n from`num_size`partition!/:"|"vs/:res1 where not partition like name,not partition~\:enlist"*";
  res2:system"ls -la | awk '{ print $5\"|\"$9}'";
  tbl:tbl,0!select first"J"$num_size by`$name,int:0ni from(update name:name except\:(.Q.n,".")from`num_size`partition!/:"|"vs/:res2)where not name ~\:"";
  `name`int xkey update total:sum num_size from tbl
 };

/ Date partition database disk space stats
/ @return (Table) Of stats for disk space used for hdb
.tbl.getDateDBSize:{[]
  res1:system"du | awk '{ print $1\"|\"$2}'";
  tbl:update name:` from 0!select first"J"$num_size by date:"D"$2_/:partition from`num_size`partition!/:"|"vs/:res1 where 1=count each group'[partition]@\:"/";
  res2:system"ls -la | awk '{ print $5\"|\"$9}'";
  tbl:tbl,0!select first"J"$num_size by`$name,date:0nd from(update name:name except\:(.Q.n,".")from`num_size`partition!/:"|"vs/:res2)where not name ~\:"";
  `name`date xkey update total:sum num_size from tbl
 };

/ Efficient union join over 
/ @param tabs (List) list of tables to union join together
/ @return (Table) result of using union join on list of tables  
.tbl.optimalUnionOver:{[tabs]
  (uj/) raze each tbls group cols each tabs
 };

/ Saves table to an integer partition db
/ @param path (String) directory path
/ @param partName (Symbol) partition name
/ @param tblName (Symbol) table name
/ @param tbl (Table) table to save to disk
.tbl.saveAsIntPart:{[path;partName;tblName;tbl]
  .Q.ens[p:hsym`$path;;`intMap]([]id:(),partName);
  hsym[`$path,"/",string[intMap?partName],"/",string[tblName],"/"]set .Q.en[p;tbl];
 };

/ Selectively ungroup a table by a subset of columns
/ @param tbl (Table) Unkeyed table to ungroup
/ @param columns (SymbolList) Column(s) to ungroup by
/ @return (Table) Ungrouped table
.tbl.ungroupBy:{[tbl;columns]
  if[0=count columns;:tbl];
  raze{enlist[x]cross ungroup enlist y}'[tbl;((),columns)#tbl]
 };
