 qmail

qmail is a library which allows you to send HTML emails from inside kdb+ processes. It uses the linux 'sendmail' utility.

NOTE: all CSS is inline in order to maintain compatibilty with gmail.

## Usage

To send a HTML email, you need to build up strings of HTML code. qmail provides numerous HTML wrapper functions which can be used to convert q structures to HTMLs.

### Headings
`.mail.heading` will create HTML heading objects.

    .mail.heading["1"; "H1"];
    .mail.heading["2"; "H2"];
    .mail.heading["3"; "H3"];
    .mail.heading["4"; "H4"]; 

![alt text](https://raw.githubusercontent.com/t-martin/qmail/master/img/headings.PNG "Headings")


### Text Formatting

#### Bold

    .mail.bold["This text is bold"];

![alt text](https://raw.githubusercontent.com/t-martin/qmail/master/img/bold.PNG "Bold")

#### Italic

    .mail.italic["This is in italics"];

![alt text](https://raw.githubusercontent.com/t-martin/qmail/master/img/italic.PNG "Italic")

#### Colour
There are a number of colourisation functions available.

`.mail.addcolor` simply changes the font colour. It can be a hex code or RGB:

    .mail.addcolor["#FF0000"; "This text is red"];
    .mail.addcolor["rgb(255, 0, 0)"; "This text is also red"];

![alt text](https://raw.githubusercontent.com/t-martin/qmail/master/img/red.PNG "Colour")

`.mail.bgcolor` changes the background colour:

    .mail.bgcolor["#FF0000"; "Red background"];
    .mail.addcolor["rgb(255, 255, 255)";] .mail.bgcolor["#FF0000"; "Red background"];

![alt text](https://raw.githubusercontent.com/t-martin/qmail/master/img/bg.PNG "Background Colour")

Size, colour and background colour can be combined using `.mail.colors`, which takes 4 paramters:
   * colour (hex or rgb string)
   * background colour (hex or rgb string)
   * font size (string)
   * text (string)

    .mail.colors["#FFFFFF";"#FF0000";"15";"Red background, white text, font size 15"];

##### Colour Scales
The library contains functions to help create colour scales, allowing you conditionally colour objects based on their underlying values.

`.mail.color.hex2html` converts a hexadecimal number into a HTML color code

`.mail.color.colorize_mono` will colourise a list of values based on given min/max values

We can combine these two functions to easily create a colour scale, interpolating between the min and max values, ramping from white at the supplied min to orange at the supplied max:

    .mail.bgcolor'[.mail.color.hex2html each .mail.color.colorize_mono[`orange;0;9;til 10]; til 10]

![alt text](https://raw.githubusercontent.com/t-martin/qmail/master/img/mono.PNG "Mono Colour")

Rather than specifing 'orange', you could also just specifiy a hue value (between 0 and 360).

    .mail.bgcolor'[.mail.color.hex2html each .mail.color.colorize_mono[55;0;9;til 10]; til 10]

![alt text](https://raw.githubusercontent.com/t-martin/qmail/master/img/mono2.PNG "Mono Colour")

We can do the same thing using two colours with `.mail.color.colorize_stereo`:

    .mail.bgcolor'[.mail.color.hex2html each .mail.color.colorize_stereo[`red;`green;0;10;5;til 10]; til 10]

![alt text](https://raw.githubusercontent.com/t-martin/qmail/master/img/stereo.PNG "Stereo Colour")

The fourth parameter here is a pivot, which defines the point at which we switch from one colour to another.

These functions could be used on a table of golf scores. Each players score could be shaded from red (worst) to green (best), pivoting around 72 for par.


    masters:delete R1Pos,R2Pos,R3Pos from ("S*JJJJJJJ*J";enlist",")0:`:masters.csv;
    masters:select
        Player,
        Finish,
        R1:.mail.bgcolor'[.mail.color.hex2html each .mail.color.colorize_stereo[`green;`red;min R1;max R1;72;R1];R1],
        R2:.mail.bgcolor'[.mail.color.hex2html each .mail.color.colorize_stereo[`green;`red;min R2;max R2;72;R2];R2],
        R3:.mail.bgcolor'[.mail.color.hex2html each .mail.color.colorize_stereo[`green;`red;min R3;max R3;72;R3];R3],
        R4:.mail.bgcolor'[.mail.color.hex2html each .mail.color.colorize_stereo[`green;`red;min R4;max R4;72;R4];R4],
        TotalScore
      from masters where not Finish like "CUT";

    .mail.table masters;

![alt text](https://raw.githubusercontent.com/t-martin/qmail/master/img/masters.PNG "Masters")


![alt text](https://raw.githubusercontent.com/t-martin/qmail/master/img/bg2.PNG "Background Colour")

#### Size
    .mail.size[;"text in increasing sizes"] each string 15+til 5

![alt text](https://raw.githubusercontent.com/t-martin/qmail/master/img/size.PNG "Font size")

### Hyperlinks
`.mail.setbookmark` sets a bookmark which can be linked to using `.mail.getbookmark`
    
    .mail.setbookmark["topofpage"]; //set bookmark with ID "topofpage"
    // body
    // body
    // body
    .mail.getbookmark["topofpage"; "Return to Top"]; //create hyperlink which takes the user to the top of the email 

### Tables
`.mail.ztable` creates a table with rows of alternating colours. `.mail.table` creates a table with a simple, white background 

    .mail.table ([]a:1 2 3 4;b:4?`4;c:("abc";"def";"feg";"sdd"))
    .mail.ztable ([]a:1 2 3 4;b:4?`4;c:("abc";"def";"feg";"sdd"))
  
![alt text](https://raw.githubusercontent.com/t-martin/qmail/master/img/table.PNG "Table")

### Dictionaries
`.mail.zdict` creates a dictionary with rows of alternating colours. `.mail.dict` creates a dictionary with a simple, white background 

    .mail.dict `a`b`c`d!(`abc;"def";100 200 300; ([]a: 1 2 3))
    .mail.zdict `a`b`c`d!(`abc;"def";100 200 300; ([]a: 1 2 3))

![alt text](https://raw.githubusercontent.com/t-martin/qmail/master/img/dict.PNG "Dict")

### Sending the email

Once the HTML body has been generated, it can be send using `.mail.send`. This takes five parameters:

   * The 'from' address (string)
   * The 'to' address (string containing "," delimited list of recipient email addresses)
   * The subject (string)
   * The email body (list of strings)
   * The attachments (`` ` `` for no attachments, otherwise a `hsym`'d list of **absolute** file-paths of your attachments).
