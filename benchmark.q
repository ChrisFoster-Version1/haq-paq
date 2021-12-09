//--------------------------------------------------------------------------//
//                          Version1 General Utilities                      //
//--------------------------------------------------------------------------//


//////////////////////////////////////////////////////////////////////////////

//                          Benchmark Utilities                             //


// Logging the stats of a functions runetime
// func = function name | args = function input(s) as a list
.bench.logBench:{[func;args] //`BenchRunTime insert
   `.bench.BenchRunTime upsert`runtime`fn`args`time`space!.z.p,func,(`$.Q.s1[args]),first .Q.ts[func;args]
 };
// For tracking the overall function time
.bench.BenchRunTime:flip`runetime`fn`args`time`space!"pssjj"$\:();
// For tracking each line in a function that was set
.bench.BenchEachStep:flip`fn`section`time!"sst"$\:();

// Basic upsert which takes a function name(fn) and a section in the function(symbol name) as inputs
.bench.logStep:{[fn;sect]
  `.bench.BenchEachStep upsert (fn;sect;.z.t)
 }

.bench.returnTimeStep:{[fn1;sect1]
  update diff:-':[first time;time] from select from .bench.BenchEachStep where fn=fn1,sect=sect1
 }

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
 }
