\c 500 500
\l qmail.q

masters:delete R1Pos,R2Pos,R3Pos from ("S*JJJJJJJ*J";enlist",")0:`:masters.csv;

add:{BODY,:$[0h=type x;x;enlist x]}

add .mail.heading["2";"The U.S. Masters, 2016"];
add .mail.heading["4";"Final Results"];

masters:flip .mail.string each/: flip masters

//add .mail.table update R1:.mail.bgcolour["red"] each R1 from masters where ("J"$R1)>72;

add .mail.table select Player:.mail.string each Player, R1:.mail.bgcolour'[.mail.color.hex2html each .mail.color.colorize_stereo[`green;`red;63;81;72;R1];R1], R2:.mail.bgcolour'[.mail.color.hex2html each .mail.color.colorize_stereo[`green;`red;63;81;72;R2];R2], R3:.mail.bgcolour'[.mail.color.hex2html each .mail.color.colorize_stereo[`green;`red;63;81;72;R3];R3], R4:.mail.bgcolour'[.mail.color.hex2html each .mail.color.colorize_stereo[`green;`red;63;81;72;R4];R4] from update R1:?[0=R1;0N;R1], R2:?[0=R2;0N;R2], R3:?[0=R3;0N;R3], R4:?[0=R4;0N;R4] from masters

.mail.send["from@doman.com";"to@domain.com";"2016 Masters";BODY];
exit 0
