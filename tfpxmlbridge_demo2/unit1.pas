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

procedure TForm1.PopupMenu1Close(Sender: TObject);
var
   sText: string;
   query, fileName: string;
   i, count: integer;
begin
    sText:= (Sender as TMenuItem).Caption;
    if CompareText(sText, 'New') = 0 then
    begin
        fileName:= 'hydexon_library_2.xml';
        InputQuery('New','New File', fileName);
        FPXMLBridge1.CreateXMLDocument(fileName, 'library' {root node});
        FPXMLBridge1.SaveToFile(fileName);    //just for call Form1 event handler...
    end
    else if CompareText(sText, 'Insert Node') = 0 then
    begin
        //create on library the node stationery... pay attention where is the token $
        query:= 'library$stationery';
        FPXMLBridge1.InsertNode(query);
        //insert node item... pay attention where is the token $
        query:= 'library.stationery$item()pencil';   //value = pencil
        FPXMLBridge1.InsertNode(query);
        query:= 'library.stationery$item()pen';   //value = pen
        FPXMLBridge1.InsertNode(query);
        query:= 'library.stationery$item()eraser';   //value = eraser
        FPXMLBridge1.InsertNode(query);
        query:= 'library.stationery$item()notebook';   //value = notebook
        FPXMLBridge1.InsertNode(query);
        FPXMLBridge1.SaveToFile(FPXMLBridge1.XMLDocumentPath);   //just for call Form1 event handler...
    end
    else if CompareText(sText, 'Get Value') = 0 then
    begin
        //this code read each item value...by index!
        query:='library.stationery';
        count:= FPXMLBridge1.CountElementNodeChildren(FPXMLBridge1.GetNode(query));
        for i:=0 to count-1 do
        begin;
          query:= 'library.stationery.item['+intToStr(i)+']';
          ShowMessage(FPXMLBridge1.GetValue(query));
        end;
    end
    else if CompareText(sText, 'Set Value') = 0 then
    begin
        //this code (re)write each item value...by index!
        query:='library.stationery';
        count:= FPXMLBridge1.CountElementNodeChildren(FPXMLBridge1.GetNode(query));
        for i:=0 to count-1 do
        begin;
          query:= 'library.stationery.item['+intToStr(i)+']'+'$'+intToStr(i*100);
          InputQuery('Set Value','Path:',query);
          FPXMLBridge1.SetValue(query);
          FPXMLBridge1.SaveToFile(FPXMLBridge1.XMLDocumentPath);
        end;
        FPXMLBridge1.SetValue(query);
        FPXMLBridge1.SaveToFile(FPXMLBridge1.XMLDocumentPath);    //call Form1 event handler...
    end
    else if CompareText(sText, 'Remove Node') = 0 then
    begin
        //this code remove item...by index!
        i:=1;
        query:='library.stationery';
        count:= FPXMLBridge1.CountElementNodeChildren(FPXMLBridge1.GetNode(query));
        if i < count then
        begin
          query:= 'library.stationery.item['+intToStr(i)+']';
          FPXMLBridge1.RemoveNode(query);
          ShowMessage('node '+ intToStr(i) + 'removed!');
        end
        else
          ShowMessage('FAIL: i='+intToStr(i) +' > count='+ intToStr(count));
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

//About-Help .........
procedure TForm1.ToolButton2Click(Sender: TObject);
var
  listStr: TStringList;
begin
    listStr:= TStringList.Create;
    listStr.Add('App Demo 2');
    listStr.Add('TFPXMLBridge - Version 0.1 - 01/2013');
    listStr.Add('Revision 01 - 09/Fev/2013');
    listStr.Add('Author: Jose Marques Pessoa : jmpessoa__hotmail_com');
    listStr.Add('[1]Warning: at the moment this code is just a proof-of-concept');
    listStr.Add('Please, reade the README.TXT!');
    listStr.Add('[2]Have fun!');
    ShowMessage(listStr.Text);
    listStr.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin

  //just for test in the same directory of the application...
  if not FileExists('hydexon_library_2.xml') then
     FPXMLBridge1.CreateXMLDocument('hydexon_library_2.xml', 'library')
  else FPXMLBridge1.LoadFromFile('hydexon_library_2.xml');

  SynMemo1.Lines.LoadFromFile(FPXMLBridge1.XMLDocumentPath);

  Application.Title:= Form1.Caption;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  //
end;

end.



