//--------------------------------------------------------------------------//
//                          Version1 General Utilities                      //
//--------------------------------------------------------------------------//


//////////////////////////////////////////////////////////////////////////////

//                          Formatting Utilities                            //

// Thomas/Michal miro
// Format a number with k/M to denote thousand/million
// decplaces = decimal places | num = number to format
// .ut.formatNum[0;1213000] 
.ut.formatNum:{[decplaces;num]
  dict:(`s#0 4 7!" kM");
  trim ($[decplaces=0;-1_;].Q.f[decplaces;num%10 xexp 3*(c-1)div 3]),dict c:count string floor abs num
 };

// Kyle miro
// Format a number with commas 
.ut.commaSepNum:{[num]
  $[ne;"-",;]$[num=`long$num;;,[;".",last p]]reverse","sv 3 cut reverse first p:"."vs$[ne:num<0;1_;]string num
 };

// Chris tech chat
// Substitute values into a string, mapping using input dictionary
// msg = string including $key1, $key2,... where $key1, $key2,... are keys of dict | dict = dictionary mapping $key1, key2,... to the atomic values to replace them with
// msg:"The count is $cnt, the overall value is $val and the user is $u"
// dict:`cnt`val`u!(10;1500f;`chris)
.format.customSSR:{[msg;dict]
  s:"$",'string k:desc key dict;
  ssr/[msg;s;string dict k]
 };

// Chris tech chat
// Substitute values into a string, mapping using the order of input list
// msg = string including $0, $1,... values to be replaced | list = atomic values to replace $0, $1,... with
// msg:"The count is $0, the overall value is $1 and the user is $2"
// list:(10;1500f;`chris)
.format.customSSRByOrder:{[msg;list]
  s:"$",'string til count list;
  ssr/[msg;s;string list]
 };

