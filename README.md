# qmail

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
`.mail.ztable` creates a dictionary with rows of alternating colours. `.mail.table` creates a dictionary with a simple, white background 

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
