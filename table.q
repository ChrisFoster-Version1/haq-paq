//--------------------------------------------------------------------------//
//                          Version 1 Genernal Utilities                    //
//--------------------------------------------------------------------------//


//////////////////////////////////////////////////////////////////////////////

//                          Table Utilities                                 //


/ Returns raw data from a tablename or denumerates a list
/ @param tblOrSym (Symbol|SymbolList) Table name or enumerated symbol list to resolve
/ @return (Table|SymbolList) 
.tbl.resolve:{[tblOrSym]
  $[-11h=type tblOrSym;
    value tblOrSym;
    tblOrSym
   ]
 };

/ Denenumerate table or reference to a table
/ @param tblOrSym (Table|Symbol) Table or reference to a table to resolve
/ @return (Table) Denumerated table
/ @see .tbl.resolve
.tbl.denum:{[tblOrSym]
  enumCols:where (type each flip res:0!.tbl.resolve tblOrSym)within 20 76h;
  keys[tblOrSym]xkey ![res;();0b;enumCols!value ,/:enumCols]
 };

/ Creating a pivot table dynamically 
/ @param t (Table) table 
/ @param g (Symbol) column to group by
/ @param c (Symbol) column to become the key of pivot table
/ @param v (Symbol) column which becomes the values in the pivot table
/ @return (Table) Pivot table
.tbl.createPivot:{[t;g;c;v]
  s:asc?[t;();();(distinct;c)];
  ?[t;();enlist[g]!enlist g;](#;enlist s;(!;c;v))
 };

/ Multi pivot for x columns
// t=table | g = group column (row in pivot) | c=column to be the column | vl= list of columns to be the values between g+c
/ @param t (Table) table 
/ @param g (Symbol) column to group by
/ @param c (Symbol) column to become the key of pivot table
/ @param vl (SymbolList) column(s) which becomes the values in the pivot table
/ @return (Table) Pivot table
.tbl.createMultiPivot:{[t;g;c;vl]
  raze{[t;g;c;v](`ky,g) xkey update ky:v from .tbl.createPivot[t;g;c;v]}[t;g;c]each vl
 };

/ Convert from a pivot table to a normal kdb table
/ @param t (Table) Pivot table 
/ @param g (Symbol) column which is grouped
/ @param c (Symbol) column which is the key of the pivot table
/ @param v (Symbol) column which becomes the values in the pivot table
/ @return (Table) normal table
.tbl.convertFromPivot:{[t;g;c;v]
  cls:cols[t]except g;
  flip (g;c;v)!raze each(count[cls]#enlist ?[t;();();g];count[t]#/:cls;t cls)
 };

/ Create link(s) between a table of data and x other tables
/ @param tbl (Table) Table of data to add links
/ @param lnkTbl (SymbolList) Global table names which will be linked to the data
/ @return The first table input with the links added from the global tables
.tbl.llink:{[tbl;lnkTbl]
  tbl lj k xkey?[lnkTbl;();0b;](k,lower lnkTbl)!(k:keys lnkTbl),enlist(!;enlist lnkTbl;`i)
 }/;

/ Relinking data to a table which has a link and the static (ish) table has been updated
/ @param data (Table) the update of the link reference table 
/ @param gt (Symbol) Global table
/ @param lt (Symbol) Linked table
/ @return The first table input with the links added from the global tables
.tbl.relink:{[data;gt;lt]
  ky:keys data;
  tbl:?[gt;;0b;()]enlist(in;(flip;(!;enlist ky;enlist,ky));key data);
  gt upsert .tbl.llink[tbl;lt]
 };

// See example in .tbl.llink
// .tbl.isLinked`Market
/ Checks what tables are linked to the input 
/ @param tname (Symbol) table name 
/ @return (SymbolList) list of tables that have the input linked to them
.tbl.isLinked:{[tname]
  where tables[]!{x in fkeys y}[tname]each tables`
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
/ @param tab (Table|Symbol) raw table or table name as a symbol 
/ @return (Table) returns a table converted from a csv
.tbl.loadCsvWithSchema:{[file;tab]
  (upper (0!meta tab)`t;enlist",")0:file
 };

// Example tables for the comparisons
//tbl1:([]id:`k`h`j`l`j`p;qty:10 40 40 30 15 0);
//tbl2:([]id:`k`h`j`l`j;qty:10 10 40 30 90);
//tk1:([id:`p`m`n];qty:5 10 15);
//tk2:([id:`o`p`m];qty:10 7 10);

/ Check if a table is keyed or not
/ @param tab (Table|Symbol) table or table name 
/ @return (Boolean) True/False depending on if it passed
.tbl.isKeyed:{[tab]
  0<count keys tab
 };
 
/ Runs a comparison between 2 tables for the columns in those tables
/ <br>If the table is keyed will only consider the keyed columns </br>
/ @param f (Function) function to do comparison inter/except etc
/ @param t1 (Table) table 
/ @param t2 (Table) table 
/ @return (Table) Subset of data depending on the function
.tbl.comparison:{[f;t1;t2]
  b1:$[.tbl.isKeyed t1;keys;cols] t1;
  b2:$[.tbl.isKeyed t2;keys;cols] t2;
  cls:b1 inter b2;
  (f). ?[;();0b;cls!cls]each(t1;t2)
 };

/ Projection of comparison for just except
/ @param t1 (Table) table 
/ @param t2 (Table) table 
/ @return (Table) Subset of data after doing except
.tbl.compExcept:.tbl.comparison[except];

/ Projection of comparison for just inter
/ @param t1 (Table) table 
/ @param t2 (Table) table 
/ @return (Table) Subset of data after doing inter 
.tbl.compInter:.tbl.comparison[inter];

/ Compare 2 tables for a specific check
// tab1 = table | tab2 = table | check = symbol describing a check like `count
/ @param tab1 (Table) table
/ @param tab2 (Table) table
/ @param check (Symbol) 3 types of checks `identical/`count/`subset
/ @return (Boolean) True/False depending if test passes
.tbl.tabCompare:{[tab1;tab2;check]
  if[check~`identical;:(~).-8!/:(tab1;tab2)];
  if[check~`count;:count[tab1]~count tab2];
  if[check~`subset;:0=count tab2 except tab1]
 };

/ Rename columns in a table using a map (for pre3.6 versions of kdb+)
/ @param dict (Dict) dictionary to rename cols
/ @param tab (Table) table
/ @return (Table) table with renamed columns specified in the dictionary
.tbl.renameColumns:{[dict;tab]
  {y^x y}[dict;cols tab] xcol tab
 };

/
// example schema
.schema.Alert:`kcol`ktype`kkey`kattr!/:
 ((`id     ; "s" ; 0b ; ` );
  (`time   ; "t" ; 0b ; ` );
  (`signal ; "s" ; 0b ; ` );
  (`msg    ; ""  ; 0b ; ` );
  (`part   ; "j" ; 0b ; ` ));
\

/ Created a global table from some predefined schema
/ @param tname (Symbol) table name
/ @return (Symbol) Name of created global table
.tbl.createTbl:{[tname]
  x set exec (kcol where kkey)xkey flip kcol!ktype$\:()from .schema x
 };

/ Integer partition database disk space stats
/ @param tname (Symbol) table name
/ @return (Table) Of stats for disk space used for hdb
.tbl.getIntDBSize:{[tname]
  name:"*",tname,"*";
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
/ @param (TableList) list of tables to union join together
/ @return (Table) result of using union join on list of tables 
.tbl.optimalUnionOver:{[tabs]
  (uj/) raze each tbls group cols each tabs
 };

/ Saves data to an integer partition db
/ @param path (String) directory path
/ @param pname (Symbol) partition name
/ @param tname (Symbol) table name
/ @param data (Table) table to save to disk
.tbl.saveAsIntPart:{[path;pname;tname;data]
  .Q.ens[p:hsym`$path;;`intMap]([]id:(),pname);
  hsym[`$path,"/",string[intMap?pname],"/",string[tname],"/"]set .Q.en[p;data];
 };

/ Selectively ungroup a table by a subset of columns
/ @param tab (Table) Table to ungroup
/ @param columns (SymbolList) Column(s) to ungroup by
/ @return (Table) Ungrouped table
.tbl.ungroupBy:{[tab;columns]
  if[0=count columns;:tab];
  raze{enlist[x]cross ungroup enlist y}'[tab;((),columns)#tab]
 };
