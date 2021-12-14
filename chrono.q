//--------------------------------------------------------------------------//
//                          Version1 General Utilities                      //
//--------------------------------------------------------------------------//


//////////////////////////////////////////////////////////////////////////////

//                          Chrono Utilities                                //


// Takes a date as input and returns the date at the start of the month
.chrono.getMonthStart:{[date]
  `date$`month$date
 };
 
// Takes a date as input and returns the date at the end of the month
.chrono.getMonthEnd:{[date]
  (`date$1+`month$date)-1
 };
 
// Takes a date as input and returns the date at the start of the week
.chrono.getWeekStart:{[date]
  `week$date
 };
 
// Takes a date as input and returns the date at the end of the week
.chrono.getWeekEnd:{[date]
  6+`week$date
 };
 
// Takes a date as input and returns the date at the start of the year
.chrono.getYearStart:{[date]
  "D"$string[`year$date],".01.01"
 };
 
// Takes a date as input and returns the date at the end of the year
.chrono.getYearEnd:{[date]
  "D"$string[`year$date],".12.31"
 };

// Return a list of non saturday/sunday dates
// Takes the number of dates one wants dates for
.chrono.getWeekDays:{[num]
  l:.z.d-til 7*1+num div 5;
  num sublist l where not(l mod 7)in 0 1
 };


// Convert between kdb timestamp and millisecond-based Unix timestamp
.chrono.unixToQ:{[milliseconds]
  1970.01.01+0D00:00:00.001*milliseconds
 };
// Vice versa of the above 
.chrono.toUnix:{[timestamp]
  "j"$(timestamp-1970.01.01D0)%0D00:00:00.001
 };

// Modifying date format
// example .chrono.formatDate[`m`y`d;.z.d;"-"]
.chrono.formatDate:{[format;date;delim]
  delim sv string (`d`m`y!`dd`mm`year)[format]$date
 };

// takes a date and returns the date of the most recent weekday
.chrono.findLastWeekday:{[date]
  $[any 0 1 = date mod 7;.z.s[date-1];date]
 };
