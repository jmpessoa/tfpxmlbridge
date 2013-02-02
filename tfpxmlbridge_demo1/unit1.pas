unit Unit1;

{$mode objfpc}{$H+}

interface

uses
   Classes, SysUtils, FileUtil, SynHighlighterXML, SynMemo, Forms, Controls,
   Graphics, Dialogs, ExtCtrls, ComCtrls, Menus, DOM, XMLRead,
   FPXMLBridge;

type

  { TForm1 }

  TForm1 = class(TForm)
    FPXMLBridge1: TFPXMLBridge;
    ImageList1: TImageList;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    Panel1: TPanel;
    PopupMenu1: TPopupMenu;
    StatusBar1: TStatusBar;
    SynMemo1: TSynMemo;
    SynXMLSyn1: TSynXMLSyn;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FPXMLBridge1BuildingBridge(currentNodeName, attrList: string; out
      attrBridge: string);
    procedure FPXMLBridge1SaveXMLDocument(pathFileName: string);
    procedure PopupMenu1Close(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
  private
    { private declarations }

  public
    { public declarations }
    XMLBridge1: TFPXMLBridge;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin

  //just for test in the same directory of the application...
  if not FileExists('hydexon_library.xml') then
     FPXMLBridge1.CreateXMLDocument('hydexon_library.xml', 'library')
  else FPXMLBridge1.LoadFromFile('hydexon_library.xml');

  SynMemo1.Lines.LoadFromFile(FPXMLBridge1.XMLDocumentPath);

  Application.Title:= Form1.Caption;
end;

procedure TForm1.PopupMenu1Close(Sender: TObject);
var
   sText: string;
   query, textContent, fileName: string;
begin
    sText:= (Sender as TMenuItem).Caption;
    if CompareText(sText, 'New') = 0 then
    begin
        fileName:= 'hydexon_library_2.xml';
        InputQuery('New','New File', fileName);
        FPXMLBridge1.CreateXMLDocument(fileName, 'library' {root node});
        FPXMLBridge1.SaveToFile(fileName);    //just for call Form1 event handler...
    end
    else if CompareText(sText, 'Open') = 0  then
    begin
        fileName:= 'hydexon_library.xml';
        InputQuery('Open','Open File', fileName);
        if not FileExists(fileName) then
           FPXMLBridge1.CreateXMLDocument('hydexon_library_2.xml', 'library' {root node})
        else
           FPXMLBridge1.LoadFromFile(fileName);

        FPXMLBridge1.SaveToFile(fileName)
        //XMLDocumentSaved(fileName); //just for call Form1 event handler...
    end
    else if CompareText(sText, 'Insert Node') = 0 then
    begin

         //just dummy information!

          //create on library the nodes: book and item ... pay attention where is the token $
        query:= 'library$book(id#200).item(name#InstallOverdom help).author()Hydexon';
        FPXMLBridge1.InsertNode(query);

        //insert node coauthor in item... pay attention where is the token $
        query:= 'library.book(200).item(InstallOverdom help)$coauthor()others users';
        FPXMLBridge1.InsertNode(query);

        query:= 'library.book(200).item(InstallOverdom help)$publisher(id#A;name#git hub)github';
        FPXMLBridge1.InsertNode(query);
        query:= 'library.book(200).item(InstallOverdom help)$publisher(id#B;name#google)google code';
        FPXMLBridge1.InsertNode(query);
        query:= 'library.book(200).item(InstallOverdom help)$publisher(id#C;name#media fire)media fire';
        FPXMLBridge1.InsertNode(query);

       //create on library the nodes: movie and item ... pay attention to the token $
       query:= 'library$movie(id#133).item(id#66;name#2001 A Space Odyssey).author()Stanley Kubrick';
       FPXMLBridge1.InsertNode(query);

       //insert node coauthor in item... pay attention to the token $
       query:= 'library.movie(133).item(66)$coauthor()Arthur C Clarke';
       FPXMLBridge1.InsertNode(query);

       //insert node publisher in item... pay attention to the token $
       query:= 'library.movie(133).item(2001 A Space Odyssey)$publisher()Metro Goldwyn Mayer';
       FPXMLBridge1.InsertNode(query);

       //Hydexon Text....
       query:= 'library$installoverdomproject.installationdata.applicationdata.appname()MyApp';
       FPXMLBridge1.InsertNode(query);

       FPXMLBridge1.SaveToFile(FPXMLBridge1.XMLDocumentPath);   //just for call Form1 event handler...
    end
    else if CompareText(sText, 'Get Value') = 0 then
    begin
        //query:='library.book(200).item(InstallOverdom help).publisher(B)';
        //query:='library.book(*).item(*).publisher(*)'; {attribute index: [0] = *}
        query:='library.book([0]).item([0]).publisher([1])';  {attribute index: [1] to get publisher}
        ShowMessage(FPXMLBridge1.GetValue(query));
    end
    else if CompareText(sText, 'Set Value') = 0 then
    begin
        textContent:= 'sourceforge';      //... pay attention to the token $
        query:='library.book(200).item(InstallOverdom help).publisher(C)$'+textContent;
        InputQuery('Set publisher: ','Path:', query);
        FPXMLBridge1.SetValue(query);
        FPXMLBridge1.SaveToFile(FPXMLBridge1.XMLDocumentPath);    //just for call Form1 event handler...
    end
    else if CompareText(sText, 'Remove Node') = 0 then
    begin
        query:='library.book(200).item(InstallOverdom help).publisher(B)';
        InputQuery('Remove publisher: ','Path:', query);
        FPXMLBridge1.RemoveNode(query);
        FPXMLBridge1.SaveToFile(FPXMLBridge1.XMLDocumentPath);    //just for call Form1 event handler...
    end
    else if  CompareText(sText, 'Save') = 0 then
    begin
        FPXMLBridge1.SaveToFile(FPXMLBridge1.XMLDocumentPath);
    end
    else if CompareText(sText, 'Exit') = 0 then
    begin
        Application.Terminate;
    end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  //
end;

//OnBuildingBridge

//query:='library.book(*).item(*).publisher(*)';
//query:='library.book(2).item(InstallOverdom about).publisher(D)';
procedure TForm1.FPXMLBridge1BuildingBridge(currentNodeName, attrList: string; out attrBridge: string);
begin
    ShowMessage('Reference Node= '+ currentNodeName + '  ...  All childreen by attribute='+attrList);
    if CompareText(currentNodeName, 'book') =  0 then attrBridge:='200';
    if CompareText(currentNodeName, 'item') =  0 then attrBridge:='InstallOverdom help';
    if CompareText(currentNodeName, 'publisher') =  0 then attrBridge:='google';
end;


//OnSaveDocument
procedure TForm1.FPXMLBridge1SaveXMLDocument(pathFileName: string);
begin
   // ShowMessage('Get Update!!!');
    SynMemo1.Lines.Clear;
    SynMemo1.Lines.LoadFromFile(pathFileName);
end;

//About-Help .........
procedure TForm1.ToolButton2Click(Sender: TObject);
var
  listStr: TStringList;
begin
    listStr:= TStringList.Create;
    listStr.Add('TFPXMLBridge - Version 0.1 - 01/2013');
    listStr.Add('Author: Jose Marques Pessoa : jmpessoa__hotmail_com');
    listStr.Add('[1]Warning: at the moment this code is just a *proof of concept*');

    listStr.Add('[2]Tokens "Language" :');
    listStr.Add('Warning: change this tokens if necessary... or Application will crash!');

    listStr.Add('NamespaceSeparatorToken:  .');
    listStr.Add('BridgeLateBindingToken:  *');    //default attribute=0 in late binding
    listStr.Add('NameValueSeparatorToken:  #');  //... equal
    listStr.Add('AssignmentToken:  $');          //... Assignment
    listStr.Add('ConcatenationToken:  |');
    listStr.Add('AttributeNameValueStartToken:  (');
    listStr.Add('AttributeNameValueEndToken:  )');
    listStr.Add('AttributesSeparatorToken:   ;');
    listStr.Add('IndexStartToken:  [');
    listStr.Add('IndexEndToken:    ]');

    listStr.Add('[3] Sintaxe Example:');
    listStr.Add('3.1.1    Insert item in library.book');
    listStr.Add('library.book(1)$item(id#1;name#lazarus guide)');  //sintaxe
    listStr.Add('library.book(1)                 :namespace where some book attribute=1');
    listStr.Add('$item                           :insert new node item');
    listStr.Add('(id#1;name#lazarus guide)       :with attributes: name1#value1;name2#value2');

    listStr.Add('3.1  Insert item in library.book');
    listStr.Add('library.book$item()out of print');    //sintaxe
    listStr.Add('library.book          :namespace base - first book child ');
    listStr.Add('$item                 :insert new node item');
    listStr.Add('()                    :empty open/closed parenthesis: no attribute at all!');
    listStr.Add('out of print          :inner/content text!');

    listStr.Add('3.2  Set value in item(lazarus guide)');
    listStr.Add('library.book.item(lazarus guide)$in stock');    //sintaxe
    listStr.Add('library.book          :namespace base');
    listStr.Add('$in stock            :set item text inner/content/value =in stock');

    listStr.Add('3.3  Set value in author');
    listStr.Add('library.book.item(lazarus guide)author$Mattias Gartner');        //sintaxe
    listStr.Add('library.book.item(lazarus guide)      :namespace base');
    listStr.Add('(                         :open token - attribute');
    listStr.Add('lazarus guide             :item selected by attribute lazarus guide');
    listStr.Add(')                         :close token - attribute');
    listStr.Add('author$Mattias Gartner    :set author text content/inner/value = Mattias Gartner');

    listStr.Add('3.4  : Insert nodes movie and item, after insert coauthor, publisher...');
    listStr.Add('library$movie(id#121).item(id#11;name#2001 A Space Odyssey).author()Stanley Kubrick'); //sintaxe
    listStr.Add('library.movie(121).item(11)$coauthor()Arthur C Clarke');   //sintaxe
    listStr.Add('library.movie(121).item(2001 A Space Odyssey)$publisher()Metro Goldwyn Mayer'); //sintaxe

    listStr.Add('3.5  Get value by some attribute');
    listStr.Add('library.book(2).item(InstallOverdom help).publisher(B)');
    listStr.Add('library.book(2)            :select book where some attribute=2');
    listStr.Add('item(InstallOverdom help)  :select item where some attribute=InstallOverdom help');
    listStr.Add('publisher(B)               :select publisher where some attribute=B');

    listStr.Add('3.6  Get value by attribute index late binding - handled by OnBuildingBridge');
    listStr.Add('library.book(*).item(*).publisher(*)        :attribute index [0] to all'); {* = default}
    listStr.Add('library.book([0]).item([0]).publisher([1])  :attribute index [1] only to publisher');


    listStr.Add('[4]Have fun!');

    ShowMessage(listStr.Text);
    listStr.Free;
end;

end.

