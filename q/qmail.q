// utility for sending HTML emails from kdb+_
// wraps around the linux 'sendmail' utility

// ===========================
// Sendmail wrapper
// ===========================
.mail.send:{[frm;to;sub;body]
  fn:hsym`$first system"mktemp qmail.XXXXXXXXXX";
  mail:.mail.template[frm;to;sub;body];
  fn 0: mail;
  @[system;"sendmail -t < ",1_string fn;{[x;y]hdel y;'"qmail error"}[;fn]];
  //hdel fn;
  };

.mail.template:{[frm;to;sub;body]
  enlist["From: ",frm],
  enlist["To: ",to],
  enlist["Subject: ",sub],
  enlist["Content-Type: text/html"],
  enlist["MIME-Version: 1.0"],
  .mail.header[],
  body,
  .mail.footer
  };

.mail.header:{[]
  raze(enlist "<html>";
  //.mail.ewrap["head";.mail.css];
  enlist "<body style=\"width:100%; marging:0; padding:0;\">")
  };

.mail.footer:("</body>";"</html>");

// =========================
// HTML tag wrappers 
// =========================

.mail.string:{$[10h=abs type x;x;(type[x] in 0 98 99h) or (100h<type x) or 0h<type x;.Q.s1 x;string x]};

.mail.wrap:{"<",x,">",y,"</",(first " "vs (),x),">"};
.mail.ewrap:{enlist["<",x,">"],y,enlist"</",(first " "vs (),x),">"};

.mail.heading:{.mail.wrap[.mail.addstyle["h",x;`body];y]};
.mail.bold:{.mail.wrap[.mail.addstyle["b";`body];.mail.string x]};
.mail.italic:{.mail.wrap[.mail.addstyle["i";`body];.mail.string x]};

.mail.ifins:{$[""~y;y;x,":",y," "]};
.mail.colours:{[colour;bg;size;text] 
  styledict:(`$("color";"background-color";"font-size"))!(colour;bg;size);
  styledict:#[;styledict]where not ""~/:styledict;
  style:.mail.dict2css (`$"font-family") _ .mail.css.body[],styledict;
  .mail.wrap["p style=\"",style,"\"";.mail.string[text]]};

.mail.colour:{.mail.colours[x;"";"";y]};
.mail.size:{.mail.colours["";"";x;y]};
.mail.bgcolour:{.mail.colours["";x;"";y]};

.mail.url:{[url;txt] .mail.wrap[.mail.addstyle["a href=\"",url,"\"";`body];txt]};
.mail.setbookmark:{[id] "<a name=\"",id,"\"></a>"};
.mail.getbookmark:{[id;txt] .mail.url["#",id;txt]};

.mail.row:{.mail.ewrap["tr";.mail.wrap[x]each .mail.string each y]};
.mail.table0:{[t;alt]
  h:.mail.row[.mail.addstyle["th";`table`header];cols t];
  b:raze .mail.row'[.mail.addstyle["td"] each`table`row,/:$[alt;?[1=til[count t]mod 2;`odd;`even];count[t]#`even];flip value flip 0!t];
  .mail.ewrap[.mail.addstyle["table";`table`all];h,b]
  };

.mail.ztable:{.mail.table0[x;1b]};
.mail.table:{.mail.table0[x;0b]};

.mail.dict0:{[d;alt]
  b:raze .mail.row'[.mail.addstyle["td"] each`table`row,/:$[alt;?[1=til[count t]mod 2;`odd;`even];count[t]#`even];flip(key;value)@\:d];   
  .mail.ewrap["table class=\"altrowstable\"";b]
  };

.mail.dict:{.mail.dict0[x;0b]}
.mail.zdict:{.mail.dict0[x;1b]}

// ======================
// Colour ladders
// ======================


// =======================
// CSS
// ========================
//.mail.getandaddstyle:{.mail.addstyle[x;.mail.getstyle y]};
.mail.getstyle:{(.mail.css . (),x)[]}
.mail.addstyle:{x," style=\"",(.mail.dict2css .mail.getstyle[y]),"\""}
.mail.getcustomstyle:{$[99h;$[`qmailstylemeta in key x;x`qmailstylemeta;()!()];()!()]};
.mail.addtext:{.mail.wrap[.mail.addstyle["p";`body];x]}

.mail.css.body:{
  (!) . flip 2 cut(
  `$"font-family";"\"Trebuchet MS\", Helvetica, Sans-Serif";
  `$"font-size";"14px";
  `$"color";"#2f4a5c")
  };
.mail.css.table.all:{
  .mail.css.body[],
  (!) . flip 2 cut(
  `$"font-family";"Verdana, Geneva, Sans-Serif";
  `$"font-size";"11px";
  `margin;"0 ";
  `padding;"3px";
  //`width;"100%";
  `$"line-height";"100%";
  `$"text-align";"left";
  `color;"#069";
  `$"border-width";"2px";
  `$"border-collapse";"collapse";
  `$"background-color";"#ffffff";
  `$"border-color";"#ffffff")
  };
.mail.css.table.header:{
  .mail.css.table.all[],
  (!) . flip 2 cut(
  `$"border-style"; "solid"; 
  `$"background-color";"#5473bf"; 
  `color;"#ffffff";  
  `$"border-color";"#ffffff"; 
  `$"border-width";"2px")
  };
.mail.css.table.row.all:{
  .mail.css.table.all[],
  (!) . flip 2 cut(
  `$"border-style";"solid"; 
  `$"border-width";"2px"; 
  `$"border-color";"#ffffff")
  };
.mail.css.table.row.odd:{
  .mail.css.table.row.all[],
  enlist[`$"background-color"]!enlist "#e6e6ff"
  };
.mail.css.table.row.even:{
  .mail.css.table.row.all[],
  enlist[`$"background-color"]!enlist "#ffffff"
  };

.mail.dict2css:{";"sv":"sv'flip(string@key@;value)@\:x}
