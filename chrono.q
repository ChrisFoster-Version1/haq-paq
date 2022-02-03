//--------------------------------------------------------------------------//
//                          Version 1 General Utilities                     //
//--------------------------------------------------------------------------//


//////////////////////////////////////////////////////////////////////////////

//                          Chrono Utilities                                //


/ Returns the date at the start of the month
/ @param date (Date) Any date
/ @return (Date) First day of month
.chrono.getMonthStart:{[date]
  `date$`month$date
 };

/ Returns the date at the end of the month
/ @param date (Date) Any date
/ @return (Date) Last day of month
.chrono.getMonthEnd:{[date]
  (`date$1+`month$date)-1
 };

/ Returns the date at the start of the week
/ @param date (Date) Any date
/ @return (Date) First day of week
.chrono.getWeekStart:{[date]
  `week$date
 };

/ Returns the date at the end of the week
/ @param date (Date) Any date
/ @return (Date) Last day of week
.chrono.getWeekEnd:{[date]
  6+`week$date
 };

/ Returns the date at the start of the year
/ @param date (Date) Any date
/ @return (Date) First date of given year
.chrono.getYearStart:{[date]
  "D"$string[`year$date],".01.01"
 };

/ Returns the date at the end of the year
/ @param date (Date) Any date
/ @return (Date) Last date of given year
.chrono.getYearEnd:{[date]
  "D"$string[`year$date],".12.31"
 };

/ Return a list of previous non Saturday/Sunday dates from given date
/ @param date (Date) Return previous weekdays as of this date
/ @param num (Int|Long) Number of dates to return
/ @return (DateList) List of weekdays
.chrono.getWeekDays:{[date;num]
  l:date-til 7*1+num div 5;
  num sublist l where not(l mod 7)in 0 1
 };

/ Convert kdb timestamp to millisecond-based Unix timestamp
/ @param milliseconds (Int) Millisecond-based Unix timestamp
/ @param isTimestamp (Boolean) Whether milliseconds provided is a timestamp or time
/ @return (Timestamp) kdb timestamp
.chrono.unixToQ:{[milliseconds;isTimestamp]
  res:1970.01.01+0D00:00:00.001*milliseconds;
  $[isTimestamp;"t"$res;res]
 };

/ Convert millisecond-based Unix timestamp to kdb timestamp
/ @param timestamp (Timestamp) kdb timestamp
/ @return (Int) Millisecond-based Unix timestamp
.chrono.qToUnix:{[timestamp]
  "j"$(timestamp-1970.01.01D0)%0D00:00:00.001
 };

/ Modifying date format
/ example {@code .chrono.formatDate[`m`y`d;.z.d;"-"]}
/ @param format (SymbolList) Date format to return, accepts {@code `d`m`y`y2}
/ @param date (Date) Any date
/ @param delim (String) Delimiter
.chrono.formatDate:{[format;date;delim]
  d:"0"^-2$k!string(`d`m!`dd`mm)[k:format except`y`y2]$date;
  d:d,(format inter`y`y2)!enlist $[`y2 in format;{-2$string x};string]`year$date;
  delim sv d format
 };

/ Returns most recent weekday
/ @param date (Date) Any date
/ @return (Date) Most recent weekday
.chrono.getLastWeekday:{[date]
  date-m*3>m:1+date mod 7
 };
