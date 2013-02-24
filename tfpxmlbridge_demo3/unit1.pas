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
   query, fileName: string;
begin
    sText:= (Sender as TMenuItem).Caption;
    if CompareText(sText, 'New') = 0 then
    begin
        fileName:= 'projEstructural2.xml';
        InputQuery('New','New File', fileName);
        FPXMLBridge1.CreateXMLDocument(fileName, 'project' {root node});
        FPXMLBridge1.SaveToFile(fileName);    //just for call Form1 event handler...
    end
    else if CompareText(sText, 'Insert Node') = 0 then
    begin

        query:= 'project.beams.beam(1).spans.span[0]$loadp(offset#2,7;p#200)';
        FPXMLBridge1.InsertNode(query);

        query:= 'project.beams.beam(1).spans.span[1]$loadp(offset#3,2;p#400)';
        FPXMLBridge1.InsertNode(query);

        FPXMLBridge1.SaveToFile(FPXMLBridge1.XMLDocumentPath);   //just for call Form1 event handler...
    end
    else if CompareText(sText, 'Get Attribute Value') = 0 then
    begin
        query:= 'project.beams.beam(1).spans.span[0]';
        if FPXMLBridge1.GetNode(query).HasAttributes then
        begin
            ShowMessage(FPXMLBridge1.GetAttrList(query));
            ShowMessage(FPXMLBridge1.GetAttrValueByName(query, 'len'));
        end;

        query:= 'project.beams.beam(1).spans.span[1].loadp[0]';
        if FPXMLBridge1.GetNode(query).HasAttributes then
        begin
            ShowMessage(FPXMLBridge1.GetAttrList(query));
            ShowMessage(FPXMLBridge1.GetAttrValueByName(query, 'p'));
        end;
    end
    else if CompareText(sText, 'Set Attribute') = 0 then
    begin
        //this code (re)write attribute...

        query:= 'project.beams.beam(1).spans.span[0]$(id#1)';
        FPXMLBridge1.SetAttribute(query);

        query:= 'project.beams.beam(1).spans.span[0].loadp[0]$(p#444)';
        FPXMLBridge1.SetAttribute(query);

        FPXMLBridge1.SaveToFile(FPXMLBridge1.XMLDocumentPath);    //call Form1 event handler...
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
    listStr.Add('App Demo 3');
    listStr.Add('TFPXMLBridge - Version 0.1 - 01/2013');
    listStr.Add('Revision 02 - 23/Fev/2013');
    listStr.Add('Author: Jose Marques Pessoa : jmpessoa__hotmail_com');
    listStr.Add('[1]Warning: at the moment this code is just a proof-of-concept');
    listStr.Add('Please, reade the README.TXT!');
    listStr.Add('[2]Have fun!');
    ShowMessage(listStr.Text);
    listStr.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  query: string;
begin

  //just for test in the same directory of the application...
  if not FileExists('projStructural.xml') then
  begin
     FPXMLBridge1.CreateXMLDocument('projStructural.xml', 'project');

     query:= 'project$beams';
     FPXMLBridge1.InsertNode(query);

     query:= 'project.beams$beam(id#1)';
     FPXMLBridge1.InsertNode(query);

     query:= 'project.beams.beam(1)$spans';
     FPXMLBridge1.InsertNode(query);

     query:= 'project.beams.beam(1).spans$span(len#5,5;q#1000)';
     FPXMLBridge1.InsertNode(query);

     query:= 'project.beams.beam(1).spans$span(len#4,5;q#1200)';
     FPXMLBridge1.InsertNode(query);

     query:= 'project.beams.beam(1).spans.span[0]$loadp(offset#3,7;p#500)';
     FPXMLBridge1.InsertNode(query);

     query:= 'project.beams.beam(1).spans.span[1]$loadp(offset#1,2;p#600)';
     FPXMLBridge1.InsertNode(query);


     FPXMLBridge1.SaveToFile('projStructural.xml')
  end
  else FPXMLBridge1.LoadFromFile('projStructural.xml');

  SynMemo1.Lines.LoadFromFile(FPXMLBridge1.XMLDocumentPath);

  Application.Title:= Form1.Caption;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  //
end;

end.



