unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, SynMemo, SynHighlighterXML, Forms, Controls,
  Graphics, Dialogs, StdCtrls, ComCtrls, ExtCtrls, FPXMLBridge;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    FPXMLBridge1: TFPXMLBridge;
    Panel1: TPanel;
    RadioGroup1: TRadioGroup;
    StatusBar1: TStatusBar;
    SynMemo1: TSynMemo;
    SynXMLSyn1: TSynXMLSyn;
    procedure Button1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var
  strXML: TStringList;
  query, strResult: string;
begin
   if RadioGroup1.ItemIndex = 0 then   //loadFromFile
   begin
       SynMemo1.Lines.LoadFromFile('rave.xml');
       FPXMLBridge1.LoadFromFile('rave.xml');
       query:= 'rootnode.path.to.node';
       strResult:= FPXMLBridge1.GetAttrValueByName(query, 'attribute');
       ShowMessage(strResult);  //Show "LOL!"
   end
   else  //loadFromString
   begin
      strXML:= TStringList.Create;
      strXML.Add('<?xml version="1.0" encoding="utf-8"?>');
              strXML.Add('<rootnode>');
                strXML.Add('<path>');
                  strXML.Add('<to>');
                    strXML.Add('<node id="1" attribute="LOL1!" />');
                    strXML.Add('<node id="2" attribute="LOL2!" />');
                  strXML.Add('</to>');
                strXML.Add('</path>');
              strXML.Add('</rootnode>');

       SynMemo1.Lines.Text:=strXML.Text;

       FPXMLBridge1.LoadFromString(strXML.Text);

       query:= 'rootnode.path.to.node(1)';
       strResult:= FPXMLBridge1.GetAttrValueByName(query, 'attribute');
       ShowMessage(strResult);  //Show "LOL1!"

       query:= 'rootnode.path.to.node(2)';
       strResult:= FPXMLBridge1.GetAttrValueByName(query, 'attribute');
       ShowMessage(strResult);  //Show "LOL2!"

       query:= 'rootnode.path.to.node(1)';
       strResult:= FPXMLBridge1.GetAttrValueByName(query, 'id');
       ShowMessage(strResult); //Show "1!"

       query:= 'rootnode.path.to.node(2)';
       strResult:= FPXMLBridge1.GetAttrValueByName(query, 'id');
       ShowMessage(strResult); //Show "2!"

       strXML.Free;
   end;
end;

end.

