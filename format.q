//--------------------------------------------------------------------------//
//                          Version 1 General Utilities                     //
//--------------------------------------------------------------------------//


//////////////////////////////////////////////////////////////////////////////

//                          Formatting Utilities                            //


// Format a number with k/M to denote thousand/million
// decplaces = decimal places | num = number to format
// .format.formatNum[0;1213000]
.format.formatNum:{[decplaces;num]
  dict:(`s#0 4 7 10!" kMB");
  trim ($[decplaces=0;-1_;].Q.f[decplaces;num%10 xexp 3*(c-1)div 3]),dict c:count string floor abs num
 };

// Format a number with commas
// Inputs: num is some number to format
//         incDec - whether to include the decimal value like 2.35 or just 2
.format.commaSepNum:{[num;incDec]
  res:reverse","sv 3 cut reverse $[ne:num<0;1_;]string`long$num;
  if[incDec;res:res,".",last "."vs string num];
  $[ne;"-",;]res
 };

// Substitute values into a string, mapping using input dictionary
// The reason for the desc is to avoid a bug when having keys like `a`u`user where it would try search and replace the $u before $user causing $user never to be replaced
// msg = string including $key1, $key2,... where $key1, $key2,... are keys of dict | dict = dictionary mapping $key1, key2,... to the atomic values to replace them with
// msg:"The count is $cnt, the overall value is $val and the user is $u"
// dict:`cnt`val`u!(10;1500f;`chris)
.format.customSSR:{[msg;dict]
  s:"$",'string k:desc key dict;
  ssr/[msg;s;string dict k]
 };

// Substitute values into a string, mapping using the order of input list
// msg = string including $0, $1,... values to be replaced | list = atomic values to replace $0, $1,... with
// msg:"The count is $0, the overall value is $1 and the user is $2"
// list:(10;1500f;`chris)
.format.customSSRByOrder:{[msg;list]
  s:"$",'string til count list;
  ssr/[msg;s;string list]
 };
