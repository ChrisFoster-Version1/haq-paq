//--------------------------------------------------------------------------//
//                          Version 1 General Utilities                     //
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

// Return a list of previous non saturday/sunday dates from given date
// @param date (Date) Return previous weekdays as of this date
// @param num (Int|Long) Number of dates to return
// @return (Dates) List of weekdays
.chrono.getWeekDays:{[date;num]
  l:date-til 7*1+num div 5;
  num sublist l where not(l mod 7)in 0 1
 };

// Convert kdb timestamp to millisecond-based Unix timestamp
// @param milliseconds (Int) Millisecond-based Unix timestamp
// @param isTimestamp (Boolean) Whether milliseconds provided is a timestamp or time
// @return (Timestamp) kdb timestamp
.chrono.unixToQ:{[milliseconds;isTimestamp]
  res:1970.01.01+0D00:00:00.001*milliseconds;
  $[isTimestamp;"t"$res;res]
 };

// Convert millisecond-based Unix timestamp to kdb timestamp
// @param timestamp (Timestamp) kdb timestamp
// @return (Int) Millisecond-based Unix timestamp
.chrono.qToUnix:{[timestamp]
  "j"$(timestamp-1970.01.01D0)%0D00:00:00.001
 };

// Modifying date format
// y returns 2001 while y2 returns 01
// example .chrono.formatDate[`m`y`d;.z.d;"-"]
.chrono.formatDate:{[format;date;delim]
  d:"0"^-2$k!string(`d`m!`dd`mm)[k:format except`y`y2]$date;
  d:d,(format inter`y`y2)!enlist $[`y2 in format;{-2$string x};string]`year$date;
  delim sv d format
 };

// Takes a date and returns the date of the most recent weekday
.chrono.getLastWeekday:{[date]
  date-m*3>m:1+date mod 7
 };
