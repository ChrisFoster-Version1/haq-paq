//--------------------------------------------------------------------------//
//                          Version1 Genernal Utilities                     //
//--------------------------------------------------------------------------//


//////////////////////////////////////////////////////////////////////////////

//                          Table Utilities                                 //


// Takes a table or sym as input
.tbl.resolve:{[tblOrSym]
  $[-11h=tyoe tblOrSym;value;]tblOrSym
 };
 
// Takes a table or sym as input
.tbl.denum:{[tblOrSym]
  enumCols:where (type each flip res:0!.tbl.resolve tblOrSym)within 20 76h;
  keys[tblOrSym]xkey ![res;();0b;enumCols!value ,/:enumCols]
 };

// similar to above
// .tbl.denumerate:{keys[x]xkey@[0!x;where type'[flip 0!x]within 20 76h;get]}  

// Pivot table creation dynamic
// t=table | g = group column (row in pivot) | c=column to be the column | v= column to be the values between g+c
// example tbl:([]cl:1 2 2 1 2;n:`b`k`b`k`l;f:5?5f) | .tbl.createPivot[tbl;`cl;`n;`f]
.tbl.createPivot:{[t;g;c;v]
  s:asc?[t;();();(distinct;c)];
  ?[t;();enlist[g]!enlist g;](#;enlist s;(!;c;v))
 };
// Multi pivot?
// t=table | g = group column (row in pivot) | c=column to be the column | vl= list of columns to be the values between g+c
// example:.tbl.createMultiPivot[tbl;`cl;`n;`f`g]
// tbl:([]cl:1 2 2 1 2;n:`b`k`b`k`l;f:5?5f;g:5?10f)
.tbl.createMultiPivot:{[t;g;c;vl]
  raze{[t;g;c;v](`ky,g) xkey update ky:v from .tbl.createPivot[t;g;c;v]}[t;g;c]each vl
 };

// Convert from a pivot table to a normal kdb table
// t=pivot table | g = group column (row in pivot) | c=column to be the column | v= column to be the values between g+c
//example tbl:([]cl:1 2 2 1 2;n:`b`k`b`k`l;f:5?5f) 
//        res:.tbl.createPivot[tbl;`cl;`n;`f]
//        .tbl.convertFromPivot[res;`cl;`n;`f] 
// technically should remove nulls too
.tbl.convertFromPivot:{[t;g;c;v]
  cls:cols[t]except g;
  flip (g;c;v)!raze each(count[cls]#enlist ?[t;();();g];count[t]#/:cls;t cls)
 };

// Create a link between a table of data and x other tables
// Example: Order:([uuid:10?`5];id:10?`vod`ms`fd`orc;qty:10?50)
//          Product:([id:`vod`ms`fd];dsc:`$("VOD";"Morgan";"First Deriv"))
//          Market:([id:`fd`vod`ms];price:3?10f)
//          .tbl.llink[Order;`Product`Market]
.tbl.llink:{x lj k xkey?[y;();0b;](k,lower y)!(k:keys y),enlist(!;enlist y;`i)}/

// Relinking data to a table which has a link and the static (ish) table has been updated
// Input : data= the update of the link reference table
//         gt=global table (Order)
//         lt=linked table (Market) 
// example upsert an orc row in data for llink reference then 
.tbl.relink:{[data;gt;lt]
  ky:keys data;
  tbl:?[gt;;0b;()]enlist(in;(flip;(!;enlist ky;enlist,ky));key data);
  gt upsert .tbl.llink[tbl;lt]
 }

// Compare 2 tables for a specific check
// tab1 = table | tab2 = table | check = symbol describing a check like `count
.tbl.tabCompare:{[tab1;tab2;check]
  if[check~`identical;:(~).-8!/:(tab1;tab2)];
  if[check~`count;:count[tab1]~count tab2];
  if[check~`subset;:0=count tab2 except tab1]
 };

// Haven't dealt with this situation before so I'm not sure what the appropriate setup is. 
// This function assumes that any column-values missing have been cut off from the end of the column files. 
// Then, it resaves down the table, with all columns truncated to the length of the shortest one.
// dir = splayed table file handle 
.tbl.fixSplayCnt:{[dir]
  m:min count each c:get each `$(string[dir],"/"),/:string cols dir;
  (hsym  `$string[dir],"/") set flip cols[dir]!m#/:c
 };

// outputs csv as table of strings, without dev counting number of columns
// file = CSV file handle
.tbl.loadCsvWithStrings:{[file]n:1+sum ","=first c:read0 file;(n#"*";enlist",")0:c};

// outputs csv as table of types matching an input schema
// file = CSV file handle | tab = table or table name
// quote:([]time: `timestamp$();sym: `$();bid: `float$();ask: `float$();size: `long$())
// {(upper (0!meta y) `t;enlist",")0:x}[ `:test.csv; `quote]
// test.csv:
// time,sym,bid,ask,size
// 2021.10.10D01:00,AAPL,27,27.1,100
// 2021.11.12D01:02,GOOG,102,102,50
.tbl.loadCsvWithSchema:{[file;tab](upper (0!meta tab)`t;enlist",")0:file};

// See example in .tbl.llink
// .tbl.isLinked`Market
.tbl.isLinked:{where tables[]!{x in fkeys y}[x]each tables`}

// Example tables for the comparisons
//tbl1:([]id:`k`h`j`l`j`p;qty:10 40 40 30 15 0);
//tbl2:([]id:`k`h`j`l`j;qty:10 10 40 30 90);
//tk1:([id:`p`m`n];qty:5 10 15);
//tk2:([id:`o`p`m];qty:10 7 10);
// 
.tbl.isKeyed:{[t]not keys[t]~`symbol$()};
.tbl.comparison:{[f;t1;t2]
  b1:.tbl.isKeyed t1;
  b2:.tbl.isKeyed t2; 
  cls:$[b1 and b2;
    keys[t1]inter keys t2;
	b1;
	keys[t1]inter cols t2;
	b2;
    cols[t1]inter keys t2;
    cols[t1]inter cols t2
   ];
  (f). ?[;();0b;cls!cls]each(t1;t2)
 };
// Runs a comparison between 2 tables for the columns in those tables
// If the table is keyed will only consider the keyed columns 
.tbl.compExcept:.tbl.comparison[except];
.tbl.compInter:.tbl.comparison[inter];

// x=dictionary to rename cols
// y=table 
// example : .tbl.rnc[`sym`src!`SYM`SRC;([]time:3#.z.p;sym:3#`AAPL;src:3#`CITI)]
.tbl.rnc:{{y^x y}[x;cols y] xcol y}

// Set a schema in q like so then a function to create it (didnt add the attr but not hard to do)
.schema.Alert:`kcol`ktype`kkey`kattr!/:
 ((`id     ; "s" ; 0b ; ` );
  (`time   ; "t" ; 0b ; ` );
  (`signal ; "s" ; 0b ; ` );
  (`msg    ; ""  ; 0b ; ` );
  (`part   ; "j" ; 0b ; ` ));
.tbl.createTbl:{x set exec (kcol where kkey)xkey flip kcol!ktype$\:()from .schema x};

// Adding an int partition db 


// Could change it to take a 2nd input for the db path
// It is also assumed the int partition has a sym file to track what each int represents called intMap
// tname = the table on disk name - otherwise will duplicate the count but could look into resolving this in a different way
// For tracking the size of the db partition
.tbl.getIntDBSize:{[tname]
  name:"*",tname,"*";
  res1:system"du | awk '{ print $1\"|\"$2}'";
  tbl:update name:intMap int from
        0!select first"J"$num_size by int:"I"$partition inter\: .Q.n from`num_size`partition!/:"|"vs/:res1 where not partition like name,not partition~\:enlist"*";
  res2:system"ls -la | awk '{ print $5\"|\"$9}'";
  tbl:tbl,0!select first"J"$num_size by`$name,int:0ni from(update name:name except\:(.Q.n,".")from`num_size`partition!/:"|"vs/:res2)where not name ~\:"";
  `name`int xkey update total:sum num_size from tbl
 }
 
// Same as above function but for date partitions
// TODO - Note no input using a hacky way to 
// Same thing as the above testing 
.tbl.getDateDBSize:{[]
  res1:system"du | awk '{ print $1\"|\"$2}'";
  tbl:update name:` from 0!select first"J"$num_size by date:"D"$2_/:partition from`num_size`partition!/:"|"vs/:res1 where 1=count each group'[partition]@\:"/";
  res2:system"ls -la | awk '{ print $5\"|\"$9}'";
  tbl:tbl,0!select first"J"$num_size by`$name,date:0nd from(update name:name except\:(.Q.n,".")from`num_size`partition!/:"|"vs/:res2)where not name ~\:"";
  `name`date xkey update total:sum num_size from tbl
 }

// Should this be in tables? (uj/)?
// Example:
// n:10000 / number of rows
// tbl:([]c1:n?100f;c2:n?100i;c3:n?100j;c4:n?.z.d;c5:n?.z.t) / create a random table
// \t:10 tblVersions,:enlist ?[-3;cols tbl]#tbl / from tbl, create 10 different tables of random schema
// Comparison
// tblCopies:100?tblVersions / take 100 copies of tblVersion - which will give a list of tables of repeating mixed schemas
// \ts a:(uj/) tblCopies
// 257 92799808
// \ts b:(uj/) .tbl.optimalUnionOver tblCopies 
// 73 119803712
// (~) . (cols[a] xasc a;cols[b] xasc b)
// 1b
// (uj/) is useful if you have a list of mixed key dictionaries, and you want to convert it to a table. 
// (uj/) is pretty expensive the bigger the list gets 
// group all common schemas together first before running uj over
.tbl.optimalUnionOver:{[tbls]
  (uj/) raze each tbls group cols each tbls
 }

// Creating an integer partition db
// Example: d:`path`pname`tname!(".";`test1;`HistData)
// d[`pname]:first 1?`9;.tbl.saveAsIntPart[d;([]date:.z.d-til 5;name:5?`3;val:5?5)]
.tbl.saveAsIntPart:{[d;data] // d=`path`pname`tname!("path";`part name;`table name) | data=table
  .Q.ens[p:hsym`$d`path;;`intMap]([]id:(),d`pname);
  hsym[`$d[`path],"/",string[intMap?d`pname],"/",string[d`tname],"/"]set .Q.en[p;data]
 }
