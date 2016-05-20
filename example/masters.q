\c 500 500
\l qmail.q

masters:delete R1Pos,R2Pos,R3Pos from ("S*JJJJJJJ*J";enlist",")0:`:masters.csv;

add:{BODY,:$[0h=type x;x;enlist x]}

add .mail.heading["2";"The U.S. Masters, 2016"];
add .mail.heading["4";"Final Results"];


masters:select
  Player,
  Finish,
  R1:.mail.bgcolor'[.mail.color.hex2html each .mail.color.colorize_stereo[`green;`red;min R1;max R1;72;R1];R1],
  R2:.mail.bgcolor'[.mail.color.hex2html each .mail.color.colorize_stereo[`green;`red;min R2;max R2;72;R2];R2],
  R3:.mail.bgcolor'[.mail.color.hex2html each .mail.color.colorize_stereo[`green;`red;min R3;max R3;72;R3];R3],
  R4:.mail.bgcolor'[.mail.color.hex2html each .mail.color.colorize_stereo[`green;`red;min R4;max R4;72;R4];R4],
  TotalScore
  from masters where not Finish like "CUT";

add .mail.table masters;

.mail.sendAtt["from@domain.com";"to@domain.com";"2016 Masters";BODY;`:masters.csv];
exit 0
