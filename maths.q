//--------------------------------------------------------------------------//
//                          Version 1 General Utilities                     //
//--------------------------------------------------------------------------//


//////////////////////////////////////////////////////////////////////////////

//                          Mathematics Utilities                           //


// Return average number of entries per date where records for date exist
// Scenario we have a table returned with 30 days we are grouping the data by symbol,side 
// We then want the 5day average count / 10 day averge count / etc 
// This function allows us to specify how many days average we want in a table with x days where the input (y) is y<=x
// ttt:([]date:100?.z.d-1+til 12;syms:100?`ms`orc`gn`fd`jp`vod;nm:100?10)
// select count[date]%count distinct date,avg3:.maths.avgCntForXDays[date;3] by syms from ttt
// vs
// select count[date]%count distinct date by syms from ttt where date in .z.d-til 3
// datecol = date column | num = number of days before today to consider 
.maths.avgCntForXDays:{[datecol;num]
  count[l]%count distinct l:datecol inter .z.d-til num
 };

// Greatest common divisor of 2 integers
.maths.gcd:{[num1;num2]
  $[num2=0;
    abs num1;
    .z.s[num2;num1 mod num2]
   ]
 };

// Lowest common multiple of 2 integers
.maths.lcm:{[num1;num2]
  abs(num1*num2)div .maths.gcd[num1;num2]
 };

// Round num to decplaces decimal place
// example .maths.round[2;10.4534545]
.maths.round:{[decplaces;num]
  %[;dv]`long$num*dv:10 xexp decplaces
 };

// Replicate Python functionality for linspace
// Return num evenly spaces samples, calculated over the interval [start,stop]
// start = number at beginning of range | stop = number at end of range | num = count of range
// Output doesn't include stop
.maths.linspace:{[start;stop;num]
  start+til[num]*(stop-start)%num
 };
// Output includes stop
.maths.linspaceWithY:{[start;stop;num]
  start+til[num]*(stop-start)%num-1
 }; 

// Return the discriminant of ax^2 + bx + c
.maths.getDiscriminant:{[a;b;c]
  (b*b)-4*a*c
 };

// Return the solutions to ax^2 + bx + c = 0 (returns nulls for complex roots)
// a = coefficient of x^2 | b = coefficient of x | c = constant
.maths.solveQuadratic:{[a;b;c]
  (1%a*2)*neg[b]+1 -1*sqrt .maths.getDiscriminant[a;b;c]
 };

// Return the mode of a list
.maths.findListMode:{[list]
  where max[c]=c:count each group list
 };

// Truncating (round towards 0) num to decplaces decimal places
// decplaces = number of decimals | num = number to be truncated
// example .maths.truncate[2;-10.4534545]
.maths.truncate:{[decplaces;num]
  $[decplaces=0;
    $[num<0;ceiling;floor]num;
    $[num<0;-1;1]*%[;dv] floor abs num*dv:10 xexp decplaces
   ]
 };

// Return the factorial of a non-negative integer, num
.maths.factorial:{[num]
  prd 1+til num
 };

// Return the num-th prime number
.maths.nthPrime:{[num] 
  if[num>5;
    :.maths.returnXPrime[num]num-1
  ];
  1 2 3 5 7 11 num
 };

// Returns list of prime numbers to some number x
.maths.returnXPrime:{[num]
  list:2_til ceiling num*log[num]+log log num;
  num sublist {x except 1_x where 0=x mod x y}/[list;til ceiling sqrt num]
 }

// Return all prime numbers less than num
.maths.listPrimes:{[num]
  {x except 1_x where 0=x mod x y}/[2_til num;til num]
 };

// Replicate pandas.DataFrame to some degree
// r=list of rows,c=list of cols,df = pivot table in kdb or ` (to return empty pivot table)
.maths.createPandasDF:{[r;c;df]
  v:enlist count[r]#0f;
  pvt:1!flip(`index,c)!enlist[r],count[c]#v;
  if[df~`;:pvt];
  pvt upsert df
 };
