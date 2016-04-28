\c 500 500
\l qmail.q

masters:delete R1Pos,R2Pos,R3Pos from ("S*JJJJJJJ*J";enlist",")0:`:masters.csv;

add:{BODY,:$[0h=type x;x;enlist x]}

add .mail.heading["2";"The U.S. Masters, 2016"];
add .mail.heading["4";"Final Results"];

masters:flip .mail.string each/: flip masters

add .mail.table update R1:.mail.bgcolour["red"] each R1 from masters where ("J"$R1)>72;

.mail.send["tom@ubuntumate.com";"tommartin@outlook.com";"2016 Masters";BODY];
exit 0
