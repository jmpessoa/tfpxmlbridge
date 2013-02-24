{
TFPXMLBridge - Version 0.1 - 01/2013;

Author: Jose Marques Pessoa : jmpessoa__hotmail_com
[1]Warning: at the moment this code is just a *proof-of-concept*

::revision 02 - 23/February/2013

	NEW Add suport for read/write Attributes
	NEW function GetAttrs(query: string): string;	
	NEW function GetAttrValueByName(query: string; attrName: string)
	NEW procedure SetAttribute(query: string)
	NEW Add    AppDemo3


::revision 01 - 09/February/2013

	NEW Sintaxe GetValue/SetValue by Node Index.
	NEW procedure SetCurrentNode(query: string).

	NEW change AppDemo1    (remove option "new documment")
	NEW Add    AppDemo2    (here is the option "new documment")
	NEW Tips..

[2]Tokens "Language" :
	Warning: change this tokens if necessary... or Application will crash!

	NamespaceSeparatorToken:  .
	BridgeLateBindingToken:  *    //default attribute=0 in late binding
	NameValueSeparatorToken:  #  //... equal
	AssignmentToken:  $          //... Assignment
	ConcatenationToken:  |
	AttributeNameValueStartToken:  (
	AttributeNameValueEndToken:  )
	AttributesSeparatorToken:   ;
	IndexStartToken:  [
	IndexEndToken:    ]

[3] Sintaxe Example:

3.1.0

    //take library as the root node:

    <?xml version="1.0" encoding="utf-8"?>
    <library>
    </library>

    Now, after the commands:

    InsertNode('library$book(id#100)')  //create node <book id="100">
    InsertNode('library$book(id#200)')  //create node <book id="200">

    the documment is:

    <?xml version="1.0" encoding="utf-8"?>
    <library>
         <book id="100">
         </book>
         <book id="200">
         </book>
    </library>

3.1.1    Insert item in library.book(100)           //library is root node

	library.book(100)$item(id#1;name#lazarus guide)  //sintaxe
	library.book(100)                 :namespace where some book attribute=100
	$item                           :insert new node item
	(id#1;name#lazarus guide)       :with attributes: name1#value1;name2#value2

3.1  Insert item in library.book

	library.book$item()out of print    //sintaxe
	library.book          :namespace base - first book child
	$item                 :insert new node item
	()                    :empty open/closed parenthesis: no attribute at all!
	out of print          :inner/content text!

3.2  Set value in item(lazarus guide)

	library.book(100).item(lazarus guide)$in stock    //sintaxe
	library.book(100)          :namespace base
	$in stock            :set item text inner/content/value =in stock

:TIP 1 InsertNode: The path to the left of the token "$" must already exist!
:TIP 2 InsertNode: If the right path of the token "$" not exists will be fully created!

3.3  Set value in author

	library.book(100).item(lazarus guide)author$Mattias Gartner        //sintaxe
	library.book(100).item(lazarus guide)      :namespace base
	(                         :open token - attribute
	lazarus guide             :item selected by attribute lazarus guide
	)                         :close token - attribute
	author$Mattias Gartner    :set author text content/inner/value = Mattias Gartner

:TIP 3 SetValue: Note that the symbol/token "$" is always placed at the end of the path
                 where you need/want to Set the value!

3.4  Generic Insert example: Insert nodes movie and item... then insert coauthor, publisher...

	library$movie(id#121).item(id#11;name#2001 A Space Odyssey).author()Stanley Kubrick //sintaxe
	library.movie(121).item(11)$coauthor()Arthur C Clarke   //sintaxe
	library.movie(121).item(2001 A Space Odyssey)$publisher()Metro Goldwyn Mayer //sintaxe

3.5  Generic Get example: Get value by some attribute

	library.book(200).item(InstallOverdom help).publisher(B)
	library.book(200)            :select book where some attribute=2
	item(InstallOverdom help)  :select item where some attribute=InstallOverdom help
	publisher(B)               :select publisher where some attribute=B

3.6 Generic GetValue by nodeIndex:

        //library is root node

        InsertNode('library$stationery') //create node <stationery>

        InsertNode('library.stationery$item()pencil') //create node <item>pencil</item>
        InsertNode('library.stationery$item()pen') //create node <item>pen</item>
        InsertNode('library.stationery$item()eraser') //create node <item>eraser</item>
        InsertNode('library.stationery$item()notebook') //create node <item>notebook</item>

        //this code read each item value...by index!

        query:='library.stationery';
        count:= FPXMLBridge1.CountElementNodeChildren(FPXMLBridge1.GetNode(query));
        for i:=0 to count-1 do
        begin;
          query:= 'library.stationery.item['+intToStr(i)+']';
          ShowMessage(FPXMLBridge1.GetValue(query));
        end;

3.7 Generic SetValue by node index:

        //this code (re)write each item value...by index!

        query:='library.stationery';
        count:= FPXMLBridge1.CountElementNodeChildren(FPXMLBridge1.GetNode(query));
        for i:=0 to count-1 do
        begin;
          query:= 'library.stationery.item['+intToStr(i)+']'+'$'+intToStr(i*100);
          FPXMLBridge1.SetValue(query);
          FPXMLBridge1.SaveToFile(FPXMLBridge1.XMLDocumentPath);
        end;

3.8 Select path to go "on the fly": Get value by attribute index late binding - handled by OnBuildingBridge

	library.book(*).item(*).publisher(*)        :select attribute index = [0] to all {default}
	library.book([0]).item([0]).publisher([1])  :select attribute index = [1] only to publisher...


3.9 Get all Attributes node... and attribute value by attribute name...

	query:= 'project.beams.beam(1).spans.span[1].loadp[0]';
	if FPXMLBridge1.GetNode(query).HasAttributes then
	begin
	   ShowMessage(FPXMLBridge1.GetAttrList(query));
	   ShowMessage(FPXMLBridge1.GetAttrValueByName(query, 'p'));
	end;
    
4.0 Set Attribute value....change attribute value or create new attribute

	//this code (re)write attribute...

	query:= 'project.beams.beam(1).spans.span[0]$(id#1)';
	FPXMLBridge1.SetAttribute(query);

	query:= 'project.beams.beam(1).spans.span[0].loadp[0]$(p#444)';
	FPXMLBridge1.SetAttribute(query);

[4]Have fun!

}