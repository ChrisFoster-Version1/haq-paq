//--------------------------------------------------------------------------//
//                          Version1 General Utilities                      //
//--------------------------------------------------------------------------//


//////////////////////////////////////////////////////////////////////////////

//                          Mathematics Utilities                           //


// Chris miro
// Return average number of entries per date where records for date exist
// ttt:([]date:100?.z.d-1+til 12;syms:100?`ms`orc`gn`fd`jp`vod;nm:100?10)
// select count[date]%count distinct date,avg3:.math.avgCntForXDays[date;3] by syms from ttt
// vs
// select count[date]%count distinct date by syms from ttt where date in .z.d-til 3
// datecol = date column | num = number of days before today to consider 
.math.avgCntForXDays:{[datecol;num]count[x]%count distinct x:datecol inter .z.d-til num};

// Kyle miro
// Greatest common divisor of 2 integers
.math.gcd:{[num1;num2]$[num2=0;abs num1;.z.s[num2;num1 mod num2]]};

// Lowest common multiple of 2 integers
.math.lcm:{[num1;num2]abs(num1*num2)div .math.gcd[num1;num2]};

// Kyle/Chris tech chat
// Round num to decplaces decimal place
// example .math.round[2;10.4534545]
.math.round:{[decplaces;num]%[;dv]`long$decplaces*dv:10 xexp num};

// Kyle miro
// Replicate Python functionality for linspace
// Return num evenly spaces samples, calculated over the interval [start,stop]
// start = number at beginning of range | stop = number at end of range | num = count of range
// Output doesn't include stop
.math.linspace:{[start;stop;num]start+til[num]*(stop-start)%num};
// Output includes stop
.math.linspaceWithY:{[start;stop;num]start+til[num]*(stop-start)%num-1}; 

// Kyle miro
// Return the discriminant of ax^2 + bx + c
.math.getDiscriminant:{[a;b;c](b*b)-4*a*c};

// Return the solutions to ax^2 + bx + c = 0 (returns nulls for complex roots)
// a = coefficient of x^2 | b = coefficient of x | c = constant
.math.solveQuadratic:{[a;b;c]
  (1%2*a)*neg[b]+1 -1*sqrt .math.getDiscriminant[a;b;c]
 };

// Kyle miro
// Return the mode of a list
.math.findListMode:{[list]where max[c]=c:count each group x};

// Michal miro
// Truncating (round towards 0) num to decplaces decimal places
// decplaces = number of decimals | num = number to be truncated
// example .math.truncate[2;-10.4534545]
.math.truncate:{[decplaces;num]
  $[decplaces=0;
    $[num<0;ceiling;floor]num;
	$[num<0;-1;1]*%[;dv] floor abs num*dv:10 xexp decplaces
  ]
 };
 
// Kyle miro
// Return the factorial of a non-negative integer, num
.math.factorial:{[num]prd 1+til num};

// Kyle miro
// Return the num-th prime number
.math.nthPrime:{[num] 
  $[num>5;
    [list:2_til ceiling num*log[num]+log log num;
	  {x except 1_x where 0=x mod x y}/[list;til ceiling sqrt num]num-1
	];
	1 2 3 5 7 11 num
  ]
 };

// Kyle miro
// Return all prime numbers less than num
.math.listPrimes:{[num]
  {x except 1_x where 0=x mod x y}/[2_til num;til num]
 };

