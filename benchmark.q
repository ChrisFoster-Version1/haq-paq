//--------------------------------------------------------------------------//
//                          Version 1 General Utilities                     //
//--------------------------------------------------------------------------//


//////////////////////////////////////////////////////////////////////////////

//                          Benchmark Utilities                             //


/ Logging the stats of a functions runtime
/ @param func (Symbol) Function name
/ @param args (List) Function input(s) as a list
.bench.logBench:{[func;args]
  //`BenchRunTime insert
  `.bench.BenchRunTime upsert`runtime`fn`args`time`space!.z.p,func,(`$.Q.s1[args]),first .Q.ts[func;args]
 };
/ For tracking the overall function time
.bench.BenchRunTime:flip`runtime`function`args`time`space!"pssjj"$\:();
/ For tracking each line in a function that was set
.bench.BenchEachStep:flip`function`section`datetime!"ssp"$\:();

/ Basic upsert which records the time when a section of a function was executed
/ @param func (Symbol) Function name
/ @param sect (Symbol) Section of function
.bench.logStep:{[func;sect]
  `.bench.BenchEachStep upsert (func;sect;.z.P)
 };

/ @param func (Symbol) Function name
/ @return (Table) Table containing time taken to execute section
.bench.returnTimeStep:{[func]
  update diff:-':[`time$first datetime;`time$datetime] from select from .bench.BenchEachStep where function=func
 };

// Example function
.bench.testQuery:{[]
  f:.bench.logStep`testQuery;
  f`start;
  do[100;7*8];
  f`multiDone;
  do[1000;til 90000];
  f`listCreation1;
  do[7500;til 75000];
  f`listCreation2;
  k:8;
  f`done
 };
