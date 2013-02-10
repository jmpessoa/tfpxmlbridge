{

TFPXMLBridge - Version 0.1 - 01/2013');

Author: Jose Marques Pessoa : jmpessoa__hotmail_com

[1]Warning: at the moment this code is just a *proof of concept*

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

3.1.1    Insert item in library.book
library.book(1)$item(id#1;name#lazarus guide)  //sintaxe
library.book(1)                 :namespace where some book attribute=1
$item                           :insert new node item
(id#1;name#lazarus guide)       :with attributes: name1#value1;name2#value2

3.1  Insert item in library.book

library.book$item()out of print    //sintaxe
library.book          :namespace base - first book child
$item                 :insert new node item
()                    :empty open/closed parenthesis: no attribute at all!
out of print          :inner/content text!

3.2  Set value in item(lazarus guide)

library.book.item(lazarus guide)$in stock    //sintaxe
library.book          :namespace base
$in stock            :set item text inner/content/value =in stock

3.3  Set value in author

library.book.item(lazarus guide)author$Mattias Gartner        //sintaxe
library.book.item(lazarus guide)      :namespace base
(                         :open token - attribute
lazarus guide             :item selected by attribute lazarus guide
)                         :close token - attribute
author$Mattias Gartner    :set author text content/inner/value = Mattias Gartner

3.4  : Insert nodes movie and item, after insert coauthor, publisher...

library$movie(id#121).item(id#11;name#2001 A Space Odyssey).author()Stanley Kubrick //sintaxe
library.movie(121).item(11)$coauthor()Arthur C Clarke   //sintaxe
library.movie(121).item(2001 A Space Odyssey)$publisher()Metro Goldwyn Mayer //sintaxe

3.5  Get value by some attribute

library.book(2).item(InstallOverdom help).publisher(B)
library.book(2)            :select book where some attribute=2
item(InstallOverdom help)  :select item where some attribute=InstallOverdom help
publisher(B)               :select publisher where some attribute=B

3.6  Get value by attribute index late binding - handled by OnBuildingBridge

library.book(*).item(*).publisher(*)        :attribute index [0] to all {* = default}
library.book([0]).item([0]).publisher([1])  :attribute index [1] only to publisher


[4]Have fun!

}