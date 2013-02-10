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
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem18: TMenuItem;
    MenuItem19: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem20: TMenuItem;
    MenuItem21: TMenuItem;
    MenuItem22: TMenuItem;
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

procedure TForm1.PopupMenu1Close(Sender: TObject);
var
   sText: string;
   query, textContent, fileName: string;
begin
    sText:= (Sender as TMenuItem).Caption;
    if CompareText(sText, 'Open') = 0  then
    begin
        fileName:= 'hydexon_library.xml';
        InputQuery('Open','Open File', fileName);
        if not FileExists(fileName) then
           FPXMLBridge1.CreateXMLDocument('hydexon_library_2.xml', 'library' {root node})
        else
           FPXMLBridge1.LoadFromFile(fileName);

        FPXMLBridge1.SaveToFile(fileName)
    end
    else if CompareText(sText, 'Get Value by Attributes Path') = 0 then
    begin
       //just path: get by attributes...
       query:='library.book(200).item(InstallOverdom help).publisher(B)';
       InputQuery('Get Value by Atributes Path: ','Path:', query);
       ShowMessage(FPXMLBridge1.GetValue(query));
    end
    else if CompareText(sText, 'Get Value by Node Index Path') = 0 then
    begin
       //just path: get by node index...
       query:='library.book[1].item[2].publisher[1]';
       InputQuery('Get publisher Value by Node Index: ','Path:', query);
       ShowMessage(FPXMLBridge1.GetValue(query));
    end
    else if CompareText(sText, 'Get Value by "on the fly" Selected Attributes Index Path') = 0 then
    begin
       //just path: get value by attribute index selected "on the fly" ...

       //select where to go by attribute index.....event driver
       //query:='library.book(*).item(*).publisher(*)';     //* = [0]
       query:='library.book([0]).item(*).publisher([1])';   //* = [0]
       InputQuery('Get publisher Value by attribute index selected "on the fly" Path: ','Dynamic Path:', query);
       ShowMessage(FPXMLBridge1.GetValue(query));
    end
    else if CompareText(sText, 'Get Value by Mix Path') = 0 then
    begin
       //just path: get by mix attributes and node index...

       query:='library.book(200).item[2].publisher(B)';
       InputQuery('Get publisher Value by Mix Path: ','Mix Path:', query);
       ShowMessage(FPXMLBridge1.GetValue(query));
    end
    else if CompareText(sText, 'Set Value by Attributes Path') = 0 then
    begin
       {:TIP 3 {SetValue}: Note that the symbol "$" is always placed at the end of the path
                   where you need/want to Set the value!}
       textContent:= 'ubuntu one';      //... pay attention to the token $ location
       query:='library.book(200).item(InstallOverdom help).publisher(B)'+'$'+textContent;
       InputQuery('Set publisher Value by Attributes Path: ','Path:', query);
       FPXMLBridge1.SetValue(query);
       FPXMLBridge1.SaveToFile(FPXMLBridge1.XMLDocumentPath);    //just for call Form1 event handler...
    end
    else if CompareText(sText, 'Set Value by Node Index Path') = 0 then
    begin
       {:TIP 3 {SetValue}: Note that the symbol "$" is always placed at the end of the path
                           where you need/want to Set the value!}

       textContent:= 'dropbox';      //... pay attention to the token $  location
       query:='library.book[1].item[2].publisher[1]'+'$'+textContent; ;
       InputQuery('Set publisher Value by Node Index Path: ','Path:', query);
       FPXMLBridge1.SetValue(query);
       FPXMLBridge1.SaveToFile(FPXMLBridge1.XMLDocumentPath);    //just for call Form1 event handler...
    end
    else if CompareText(sText, 'Set Value by "on the fly" Selected Attributes Index Path') = 0 then
    begin
       //Set value by attribute index selected "on the fly" ...

       //select where to go by attribute index.....event driver
       //query:='library.book(*).item(*).publisher(*)';     //* = [0]

       {:TIP 3 {SetValue}: Note that the symbol "$" is always placed at the end of the path
                           where you need/want to Set the value!}

       textContent:= 'opendrive';      //... pay attention to the token $ location
       query:='library.book([0]).item(*).publisher([1])'+'$'+textContent;   //* = [0] :attribute index 0

       InputQuery('Set publisher by Attributes Index selected "on the fly" Path: ','Dynamic Path:', query);
       FPXMLBridge1.SetValue(query);
       FPXMLBridge1.SaveToFile(FPXMLBridge1.XMLDocumentPath);    //just for call Form1 event handler...
    end
    else if CompareText(sText, 'Set Value by Mix Path') = 0 then
    begin
       //Set by mix attributes and node index...
       textContent:= 'sourceforge';      //... pay attention to the token $
       query:='library.book(200).item[2].publisher(B)'+'$'+textContent;
       InputQuery('Set publisher by Mix path: ','Mix Path:', query);
       FPXMLBridge1.SetValue(query);
       FPXMLBridge1.SaveToFile(FPXMLBridge1.XMLDocumentPath);    //just for call Form1 event handler...
    end
    else if CompareText(sText, 'Remove Node by Attributes Path') = 0 then
    begin
      //just path: Remove by attributes...
      query:='library.book(200).item(InstallOverdom help).publisher(C)';   //ok
      InputQuery('Remove node publisher by Attributes  Path: ','Path:', query);
      FPXMLBridge1.RemoveNode(query);
      FPXMLBridge1.SaveToFile(FPXMLBridge1.XMLDocumentPath);    //just for call Form1 event handler...
    end
    else if CompareText(sText, 'Remove Node by Node Index Path') = 0 then
    begin
      //just path: Remove by node index...
      query:='library.book[1].item[2].publisher[0]';  //ok
      InputQuery('Remove node publisher by Node Index Path: ','Path:', query);
      FPXMLBridge1.RemoveNode(query);
      FPXMLBridge1.SaveToFile(FPXMLBridge1.XMLDocumentPath);    //just for call Form1 event handler...
    end
    else if CompareText(sText, 'Remove Node by "on the fly" Selected Attributes Index Path') = 0 then
    begin
       //just path: Remove node by attribute index selected "on the fly" ...

       //select where to go by attribute index.....event driver
       //query:='library.book(*).item(*).publisher(*)';     //* = [0]
       query:='library.book([0]).item(*).publisher([1])';   //* = [0]       //ok
       InputQuery('Remove node publisher by Attributes Index Path: ','Path:', query);
       FPXMLBridge1.RemoveNode(query);
       FPXMLBridge1.SaveToFile(FPXMLBridge1.XMLDocumentPath);    //just for call Form1 event handler...
    end
    else if CompareText(sText, 'Remove Node by Mix Path') = 0 then
    begin
       //just path: remove node by mix attributes and node index path...
       query:='library.book(200).item[2].publisher(D)';     //ok
       InputQuery('Remove node publisher by Mix Path: ','Mix Path:', query);
       FPXMLBridge1.RemoveNode(query);
       FPXMLBridge1.SaveToFile(FPXMLBridge1.XMLDocumentPath);    //just for call Form1 event handler...
    end
    else if CompareText(sText, '(Re)Insert Node by Attributes Path') = 0 then
    begin
      //:TIP 1 {InsertNode}: The path to the left of the token "$" must already exist!

      textContent:= 'github';
      query:='library.book(200).item(InstallOverdom help)'+'$'+'publisher(id#A;name#git hub)'+textContent;
      InputQuery('(Re)Insert node publisher by Attributes  Path: ','Path:', query);
      FPXMLBridge1.InsertNode(query);
      FPXMLBridge1.SaveToFile(FPXMLBridge1.XMLDocumentPath);    //just for call Form1 event handler...
    end
    else if CompareText(sText, '(Re)Insert Node by Node Index Path') = 0 then
    begin
      //:TIP 1 {InsertNode}: The path to the left of the token "$" must already exist!

      textContent:= 'google';
      query:='library.book[1].item[2]'+'$'+'publisher(id#B;name#google code)'+textContent;
      InputQuery('(Re)Insert node publisher by Node Index Path: ','Path:', query);
      FPXMLBridge1.InsertNode(query);
      FPXMLBridge1.SaveToFile(FPXMLBridge1.XMLDocumentPath);    //just for call Form1 event handler...
    end
    else if CompareText(sText, '(Re)Insert Node by "on the fly" Selected Attributes Index Path') = 0 then
    begin
       //:TIP 1 {InsertNode}: The path to the left of the token "$" must already exist!

       //select where to go by attribute index.....event driver
       //query:='library.book(*).item(*).publisher(*)';     //* = [0]
       textContent:= 'media fire';
       query:='library.book([0]).item(*)'+'$'+'publisher(id#C;name#media fire)'+textContent;
       InputQuery('Remove node publisher by Attributes Index Path: ','Path:', query);
       FPXMLBridge1.InsertNode(query);
       FPXMLBridge1.SaveToFile(FPXMLBridge1.XMLDocumentPath);    //just for call Form1 event handler...
    end
    else if CompareText(sText, '(Re)Insert Node by Mix Path') = 0 then
    begin
       //:TIP 1 {InsertNode}: The path to the left of the token "$" must already exist!

       textContent:= 'open drive';
       query:='library.book(200).item[2]'+'$'+'publisher(id#D;name#opendrive)'+textContent;
       InputQuery('(Re)Insert node publisher by Mix Path: ','Mix Path:', query);
       FPXMLBridge1.InsertNode(query);
       FPXMLBridge1.SaveToFile(FPXMLBridge1.XMLDocumentPath);    //just for call Form1 event handler...
    end
    else if CompareText(sText, 'Generic Insert Nodes') = 0 then
    begin
      {:TIP 1 {InsertNode}: The path to the left of the token "$" must already exist!
       :TIP 2 {InsertNode}: If the right path of the token "$" not exists will be fully created!}

      //create on library the nodes: book and item ... pay attention where is the token $ location
      query:= 'library$book(id#300).item(name#InstallOverdom help).author()Hydexon';
      FPXMLBridge1.InsertNode(query);

      //now insert node coauthor in item... pay attention where is the token $ location
      query:= 'library.book(300).item(InstallOverdom help)$coauthor()others users';
      FPXMLBridge1.InsertNode(query);

      query:= 'library.book(300).item(InstallOverdom help)$publisher(id#A;name#git hub)github';
      FPXMLBridge1.InsertNode(query);
      query:= 'library.book(300).item(InstallOverdom help)$publisher(id#B;name#google)google code';
      FPXMLBridge1.InsertNode(query);
      query:= 'library.book(300).item(InstallOverdom help)$publisher(id#C;name#media fire)media fire';
      FPXMLBridge1.InsertNode(query);

      //create on library the nodes: movie and item ... pay attention to the token $
      query:= 'library$movie(id#133).item(id#66;name#2001 A Space Odyssey).author()Stanley Kubrick';
      FPXMLBridge1.InsertNode(query);

      //now insert node coauthor in item... pay attention to the token $
      query:= 'library.movie(133).item(66)$coauthor()Arthur C Clarke';
      FPXMLBridge1.InsertNode(query);

      //now insert node publisher in item... pay attention to the token $
      query:= 'library.movie(133).item(2001 A Space Odyssey)$publisher()Metro Goldwyn Mayer';
      FPXMLBridge1.InsertNode(query);

      //Hydexon Text....
      query:= 'library$installoverdomproject.installationdata.applicationdata.appname()MyApp';
      FPXMLBridge1.InsertNode(query);

      FPXMLBridge1.SaveToFile(FPXMLBridge1.XMLDocumentPath);   //just for call Form1 event handler...
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

//OnSaveDocument
procedure TForm1.FPXMLBridge1SaveXMLDocument(pathFileName: string);
begin
   // ShowMessage('Get Update!!!');
   SynMemo1.Lines.Clear;
   SynMemo1.Lines.LoadFromFile(pathFileName);
end;

//OnBuildingBridge

//query:='library.book(*).item(*).publisher(*)';
//query:='library.book(200).item(InstallOverdom help).publisher(B)';
procedure TForm1.FPXMLBridge1BuildingBridge(currentNodeName, attrList: string; out attrBridge: string);
begin
   ShowMessage('You are here: '+ currentNodeName + #13#10+'Select where you want to go by Attributes: '+attrList);
   if CompareText(currentNodeName, 'book') =  0 then attrBridge:='200';
   if CompareText(currentNodeName, 'item') =  0 then attrBridge:='InstallOverdom help';
   if CompareText(currentNodeName, 'publisher') =  0 then attrBridge:='google';
end;

//About-Help .........
procedure TForm1.ToolButton2Click(Sender: TObject);
var
  listStr: TStringList;
begin
   listStr:= TStringList.Create;
   listStr:= TStringList.Create;
   listStr.Add('TFPXMLBridge AppDemo1');
   listStr.Add('TFPXMLBridge - Version 0.1 - Jan/2013');
   listStr.Add('Revision 01 - 09/Fev/2013');
   listStr.Add('Author: Jose Marques Pessoa : jmpessoa__hotmail_com');
   listStr.Add('[1]Warning: at the moment this code is just a proof-of-concept');
   listStr.Add('Please, read the "readme.txt"!');
   listStr.Add('[2]Have fun!');
   ShowMessage(listStr.Text);
   listStr.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  //just for test in the same directory of the application...
  if not FileExists('hydexon_library.xml') then
     FPXMLBridge1.CreateXMLDocument('hydexon_library.xml', 'library')
  else FPXMLBridge1.LoadFromFile('hydexon_library.xml');

  SynMemo1.Lines.LoadFromFile(FPXMLBridge1.XMLDocumentPath);

  Application.Title:= Form1.Caption;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  //
end;


end.

