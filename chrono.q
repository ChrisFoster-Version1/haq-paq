//--------------------------------------------------------------------------//
//                          Version1 General Utilities                      //
//--------------------------------------------------------------------------//


//////////////////////////////////////////////////////////////////////////////

//                          Chrono Utilities                                //


// Chris miro
// Takes a date as input and returns a date
.ut.getMonthStart:{[date]`date$`month$date};
.ut.getMonthEnd:{[date](`date$1+`month$date)-1};
.ut.getWeekStart:{[date]`week$date};
.ut.getWeekEnd:{[date]6+`week$date};
.ut.getYearStart:{[date]"D"$string[`year$date],".01.01"};
.ut.getYearEnd:{[date]"D"$string[`year$date],".12.31"};

// Chris miro
// Return a list of non saturday/sunday dates
// Takes the number of dates one wants dates for
.ut.getWeekDays:{[num]
  l:.z.d-til num+7*num div 7;
  num sublist l where not(l mod 7)in 0 1
 };

// Thomas miro
// Convert between kdb timestamp and millisecond-based Unix timestamp
.ut.toQ:{[milliseconds]
  1970.01.01+0D00:00:00.001*milliseconds
 };

.ut.toUnix:{[timestamp]
  "j"$(timestamp-1970.01.01D0)%0D00:00:00.001
 };

// Kyle miro
// Modifying date format
// example .ut.dateFormat[`m`y`d;.z.d;"-"]
.ut.dateFormat:{[format;date;delim]
  delim sv string (`d`m`y!`dd`mm`year)[format]$date
 };

// Chris Miro
// takes a date and returns the date of the most recent weekday
.ut.lastWeekday:{[date]
  $[any 0 1 = date mod 7;.z.s[date-1];date]
 };



