unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, SynMemo, SynHighlighterXML, Forms, Controls,
  Graphics, Dialogs, ExtCtrls, ComCtrls, StdCtrls, TreeViewXMLBridge,
  FPXMLBridge;

type

  { TForm1 }

  TForm1 = class(TForm)
    Bevel1: TBevel;
    Bevel2: TBevel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    FPXMLBridge1: TFPXMLBridge;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    RadioGroup1: TRadioGroup;
    StatusBar1: TStatusBar;
    SynMemo1: TSynMemo;
    SynXMLSyn1: TSynXMLSyn;
    TreeViewXMLBridge1: TTreeViewXMLBridge;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FPXMLBridge1XMLDocumentEdited(AName, AValue: string);
    procedure RadioGroup1SelectionChanged(Sender: TObject);
    procedure SynMemo1Change(Sender: TObject);
    procedure TreeViewXMLBridge1DblClick(Sender: TObject);
    procedure TreeViewXMLBridge1EditingEnd(Sender: TObject; Node: TTreeNode;
      Cancel: Boolean);
  private
    { private declarations }
    FflagXMLExists: boolean;
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

         //load txt
procedure TForm1.Button1Click(Sender: TObject);
begin
  SynMemo1.Lines.Clear;
  TreeViewXMLBridge1.Items.Clear;
  ShowMessage('Loading from txt file...[library.txt]');

  TreeViewXMLBridge1.LoadFromFile('library.txt');

  TreeViewXMLBridge1.FullExpand;

  SynMemo1.Lines.LoadFromFile('library.txt');
end;

     //save txt
procedure TForm1.Button4Click(Sender: TObject);
begin
  SynMemo1.Lines.Clear;
  ShowMessage('Saving to txt file...[library.txt]');
  TreeViewXMLBridge1.SaveToFile('library.txt');
  SynMemo1.Lines.LoadFromFile('library.txt');
end;

    //edition by code
procedure TForm1.Button5Click(Sender: TObject);
var
  query: string;
begin
  if FflagXMLExists then
  begin
    query:='library.book(100).item(tfpxmlbridge help).author$J M Pessoa';
    TreeViewXMLBridge1.XMLBridge.SetValue(query);
  end
  else
    ShowMessage('warning: the "XML" does not exist yet!!');
end;
       //handle event on edition by code
procedure TForm1.FPXMLBridge1XMLDocumentEdited(AName, AValue: string);
begin
    //need this
    TreeViewXMLBridge1.UpdateTreeView;

    //or for this example just this....
    SynMemo1.Lines.Text:= TreeViewXMLBridge1.XMLBridge.GetXMLAsString;
end;
                //load xml
procedure TForm1.Button3Click(Sender: TObject);
begin
   SynMemo1.Lines.Clear;
   TreeViewXMLBridge1.Items.Clear;
   ShowMessage('Loading from xml file...[library.xml]');
   TreeViewXMLBridge1.LoadFromFileXML('library.xml');
   SynMemo1.Lines.LoadFromFile('library.xml');
   FflagXMLExists:= True; //just flag...
end;
                    //save xml
procedure TForm1.Button2Click(Sender: TObject);
begin
   SynMemo1.Lines.Clear;
   ShowMessage('Saving to xml file...[library.xml]');
   TreeViewXMLBridge1.SaveToFileXML('library.xml');
   SynMemo1.Lines.LoadFromFile('library.xml');
   FflagXMLExists:= True; //just flag...
end;

procedure TForm1.RadioGroup1SelectionChanged(Sender: TObject);
begin
   case RadioGroup1.ItemIndex of
     0: TreeViewXMLBridge1.AttributeShowMode:= asListNameValue;
     1: TreeViewXMLBridge1.AttributeShowMode:= asChildNameValue;
     2: TreeViewXMLBridge1.AttributeShowMode:= asChildNameChildValue;
   end;
end;

procedure TForm1.SynMemo1Change(Sender: TObject);
begin
  TreeViewXMLBridge1.LoadFromStringXML(SynMemo1.Lines.Text);
  TreeViewXMLBridge1.FullExpand;
end;
                 //for edit...
procedure TForm1.TreeViewXMLBridge1DblClick(Sender: TObject);
begin
  TreeViewXMLBridge1.ReadOnly:= False;
end;

procedure TForm1.TreeViewXMLBridge1EditingEnd(Sender: TObject; Node: TTreeNode; Cancel: Boolean);
begin
  ShowMessage('Updating XML...');

  TreeViewXMLBridge1.UpdateXMLBridge;
  TreeViewXMLBridge1.ReadOnly:= True;

  SynMemo1.Lines.Clear;
  SynMemo1.Lines.Text:= TreeViewXMLBridge1.XMLBridge.GetXMLAsString;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  FflagXMLExists:= False;
end;

end.
