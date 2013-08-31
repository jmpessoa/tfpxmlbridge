unit TreeViewXMLBridge;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,  Controls, Graphics,
  ComCtrls, ExtCtrls, FPXMLBridge, DOM;

type

  TAttributeShowMode = (asChildNameValue, asChildNameChildValue, asListNameValue);

  TTreeViewXMLBridge = class(TTreeView)
    private
        FXMLBridge: TFPXMLBridge;
        FPathXMLDocument:string;
        FAttributeShowMode: TAttributeShowMode;
        FIdentifyAttributeToken: char;
        FActive: boolean;
        procedure XMLToTree(XmlNode: TDOMNode; TreeNode: TTreeNode);
        procedure TreeToXML(treeNode: TTreeNode; refNode : TDOMNode);
        procedure SetXMLBridge(AValue: TFPXMLBridge);
        procedure SetAttributeShowMode(AValue: TAttributeShowMode);
    protected
        procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    public
        constructor Create(AOwner: TComponent); override;
        destructor Destroy; override;
        procedure SaveToFileXML(pathXMLFileName: string);
        procedure LoadFromFileXML(pathXMLFileName: string);
        procedure LoadFromStringXML(xmlString: string);
        procedure UpdateXMLBridge;
        procedure UpdateTreeView;
        property Active: boolean read FActive write FActive;
    published
        property OnClick;
        property OnChange;
        property OnDblClick;
        property OnDragDrop;
        property OnEnter;
        property OnExit;
        property OnKeyDown;
        property OnKeyPress;
        property OnKeyUp;
        property OnMouseDown;
        property OnMouseMove;
        property OnMouseUp;
        property AttributeShowMode: TAttributeShowMode read FAttributeShowMode write SetAttributeShowMode;
        property IdentifyAttributeToken: char read FIdentifyAttributeToken write FIdentifyAttributeToken;
        property XMLBridge: TFPXMLBridge read FXMLBridge write SetXMLBridge;
  end;

  function SplitStr(var theString: string; delimiter: string): string;
  function TrimChar(query: string; delimiter: char): string;
  function ReplaceChar(query: string; oldchar, newchar: char):string;

implementation

procedure TTreeViewXMLBridge.SetAttributeShowMode(AValue: TAttributeShowMode);
begin
    FAttributeShowMode:= AValue;
end;

procedure TTreeViewXMLBridge.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FXMLBridge) then
  begin
    FXMLBridge := nil;
  end;
end;

procedure TTreeViewXMLBridge.SetXMLBridge(AValue: TFPXMLBridge);
begin
  if AValue <> FXMLBridge then
   begin
      if Assigned(FXMLBridge) then
      begin
         FXMLBridge.RemoveFreeNotification(Self); //remove free notification...
      end;
      FXMLBridge:= AValue;
      if AValue <> nil then  //re- add free notification...
      begin
         AValue.FreeNotification(self);
      end;
   end;
end;

procedure TTreeViewXMLBridge.XMLToTree(XmlNode: TDOMNode; TreeNode: TTreeNode);
var
  i: integer;
  NewTreeNode, refTreeNode: TTreeNode;
  NodeText, nodeValue: string;
  AttrNode: TDOMNode;
  attrValue, auxStr: string;
begin
  //just ELEMENT_NODE
  if XmlNode.NodeType <> ELEMENT_NODE then Exit; // TODO: fix here! não aceita innerText !!!

  //Add Node to Tree
  NodeText := XmlNode.NodeName;
  nodeValue:='';
  attrValue:='';

  if (XmlNode.ChildNodes.Count = 1) and (XmlNode.ChildNodes[0].NodeValue <> '')  then
  begin
    nodeValue:= Trim(XmlNode.ChildNodes[0].NodeValue);
  end;

  //Add  attributes as string list..
  if FAttributeShowMode = asListNameValue then
  begin
      for i:= 0 to xmlNode.Attributes.Length - 1 do
      begin
        AttrNode := xmlNode.Attributes.Item[i];
        auxStr:= FIdentifyAttributeToken + Trim(AttrNode.NodeName)+'='+ Trim(AttrNode.NodeValue);
        attrValue:= attrValue + auxStr;
      end;
      NodeText:=NodeText+' '+attrValue; //TrimChar(attrValue,FIdentifyAttributeToken);
  end;
  NodeText:= Trim(NodeText);

  NewTreeNode := Self.Items.AddChild(TreeNode, NodeText);
  if nodeValue <> '' then Self.Items.AddChild(NewTreeNode, Trim(nodeValue));

  //add attributes as children parentName/childValue
  if  FAttributeShowMode = asChildNameChildValue then
  begin
     for i:= 0 to xmlNode.Attributes.Length - 1 do
     begin
       AttrNode := xmlNode.Attributes.Item[i];
       refTreeNode:= Self.Items.AddChild(NewTreeNode, Trim(FIdentifyAttributeToken+AttrNode.NodeName));
       Self.Items.AddChild(refTreeNode,Trim(AttrNode.NodeValue));
     end;
  end;

  //Add attributes as child name=value
  if  FAttributeShowMode = asChildNameValue then
  begin
    for i:= 0 to xmlNode.Attributes.Length - 1 do
    begin
      AttrNode := xmlNode.Attributes.Item[i];
      Self.Items.AddChild(NewTreeNode,Trim(AttrNode.NodeName)+'='+Trim(AttrNode.NodeValue));
    end;
  end;
    //Add all children
  if XmlNode.HasChildNodes then
    for i:= 0 to xmlNode.ChildNodes.Count - 1 do
        XMLToTree(xmlNode.ChildNodes.Item[i], NewTreeNode);
end;

procedure TTreeViewXMLBridge.LoadFromFileXML(pathXMLFileName: string);
begin
  FXMLBridge.LoadFromFile(pathXMLFileName);
  UpdateTreeView;
end;

procedure TTreeViewXMLBridge.LoadFromStringXML(xmlString: string);
begin
  FXMLBridge.LoadFromString(xmlString);
  UpdateTreeView;
end;

procedure TTreeViewXMLBridge.UpdateTreeView;
begin
  if FXMLBridge.Active then
  begin
     Self.Items.Clear;
     XMLToTree(FXMLBridge.XMLDocument.DocumentElement, nil);
  end;
end;

procedure TTreeViewXMLBridge.TreeToXML(treeNode: TTreeNode; refNode : TDOMNode);
var
    newNode: TDOMNode;
    auxStr: string;
    NodeName, AttrName, AttrValue: string;
    treeNodeChild: TTreeNode;
    attrList: TStringList;
    i: integer;
begin
    attrList:= TStringList.Create;  //TODO: fix here: create and re-create n times!!!
    if treeNode = nil then Exit;

    auxStr:= treeNode.Text;

    if (Pos(' ', auxStr) > 0) and (Pos(FIdentifyAttributeToken{'='}, auxStr) > 0) then
    begin //atrribute was joined as string list to nodeName [Mode: nodename ~attr1=value1~attr2=value2 ....]
       auxStr:= Trim(auxStr);
       NodeName:= SplitStr(auxStr,' ');
       attrList.Delimiter:= FIdentifyAttributeToken; {'~'}
       attrList.DelimitedText:= TrimChar(ReplaceChar(Trim(auxStr),' ', '+'), FIdentifyAttributeToken);
    end
    else NodeName:= auxStr;
    NodeName:= Trim(NodeName);
    if NodeName <> '' then
    begin
      if (treeNode.getFirstChild <> nil) then
      begin
         if Pos(FIdentifyAttributeToken, NodeName) > 0 then  //child is a attribute [Mode: $attrName]
         begin
           AttrName:= TrimChar(NodeName, FIdentifyAttributeToken);
           treeNodeChild:= treeNode.GetFirstChild;
           TDOMElement(refNode).SetAttribute(Trim(AttrName), Trim(treeNodeChild.Text));
           treeNode:=treeNodeChild;
           newNode:= refNode;
         end
         else
         begin //default
            newNode:= FXMLBridge.XMLDocument.CreateElement(Trim(NodeName));
            refNode.Appendchild(newNode);
            for i:=0 to attrList.Count-1 do
            begin
                attrList.GetNameValue(i, attrName,attrValue);
                TDOMElement(newNode).SetAttribute(Trim(AttrName), Trim(ReplaceChar(AttrValue,'+', ' ')));
            end;
         end;
      end
      else  //treeNode.getFirstChild = nil
      begin
         if Pos('=', NodeName) > 0 then   //child is a attribute [Mode: attrName=attrValue]
         begin
           AttrValue := NodeName;
           AttrName:= SplitStr(AttrValue, '=');
           TDOMElement(refNode).SetAttribute(Trim(AttrName), Trim(AttrValue));
           newNode:= refNode;
         end
         else if attrList.Count > 0 then
         begin
            newNode:= FXMLBridge.XMLDocument.CreateElement(Trim(NodeName));
            refNode.Appendchild(newNode);
            for i:=0 to attrList.Count-1 do
            begin
                attrList.GetNameValue(i, attrName,attrValue);
                TDOMElement(newNode).SetAttribute(Trim(AttrName), Trim(ReplaceChar(AttrValue,'+', ' ')));
            end;
         end
         else
         begin //default....   se não tiver filhos então assume como inner text....
            newNode:= FXMLBridge.XMLDocument.CreateTextNode(Trim(NodeName));
            refNode.Appendchild(newNode);

            {or ... se não tiver filhos então assume como um novo node.....
              newNode:= FXMLBridge.XMLDocument.CreateElement(Trim(NodeName));
              refNode.Appendchild(newNode);}

         end;
      end;
      treeNode := treeNode.getFirstChild;
      while treeNode <> nil do
      begin
        TreeToXML(treeNode, newNode);
        treeNode := treeNode.getNextSibling;
      end;
    end;
    attrList.Free;
end;

procedure TTreeViewXMLBridge.UpdateXMLBridge;
var
  treeNode : TTreeNode;
  refNode : TDOMNode;
  newNode: TDOMNode;
  auxStr: string;
  NodeName, AttrName, AttrValue: string;
  treeNodeChild: TTreeNode;
  attrList: TStringList;
  i: integer;
begin
  attrList:= TStringList.Create;
  treeNode := Self.TopItem;

  auxStr:= treeNode.Text;

 // ShowMessage(':'+auxStr+':');

  if (Pos(' ', auxStr) > 0) and (Pos(FIdentifyAttributeToken, auxStr) > 0) then
  begin //atrribute was joined as string list to nodeName [Mode: nodename attr1=value1;attr2=value2 ....]
   //  ShowMessage('1-');
     auxStr:= Trim(auxStr);
     NodeName:= SplitStr(auxStr,' ');
     attrList.Delimiter:= FIdentifyAttributeToken; {'~'}
     attrList.DelimitedText:= TrimChar(ReplaceChar(Trim(auxStr),' ', '+'), FIdentifyAttributeToken);
    // ShowMessage('2-');
  end
  else NodeName:= auxStr;
  NodeName:= Trim(NodeName);
  if NodeName <> '' then
  begin
    FXMLBridge.CreateXMLDocument(FPathXMLDocument, Trim(NodeName));
    refNode := FXMLBridge.RootNode;
    if (treeNode.getFirstChild <> nil) then
    begin
       if Pos(FIdentifyAttributeToken, NodeName) > 0 then  //child is a attribute [Mode: *attrName]
       begin
         AttrName:= TrimChar(NodeName, FIdentifyAttributeToken);
         treeNodeChild:= treeNode.GetFirstChild;
      //   ShowMessage('2.3:');
         TDOMElement(refNode).SetAttribute(Trim(AttrName), Trim(treeNodeChild.Text));
         treeNode:=treeNodeChild;
         newNode:= refNode;
        // ShowMessage('2.4:');
       end
       else
       begin //default
          newNode:= refNode;
          for i:= 0 to attrList.Count-1 do
          begin
              attrList.GetNameValue(i,attrName, attrValue);
              TDOMElement(newNode).SetAttribute(Trim(AttrName), Trim(ReplaceChar(AttrValue,'+', ' ')));
          end;
       end;
    end
    else  //treeNode.getFirstChild = nil
    begin
       if Pos('=', NodeName) > 0 then   //child is a attribute [Mode: attrName=attrValue]
       begin
         AttrValue:= NodeName;
         AttrName:= SplitStr(AttrValue, '=');
         TDOMElement(refNode).SetAttribute(Trim(AttrName), Trim(AttrValue));
         newNode:= refNode;
       end
       else if attrList.Count > 0 then
       begin
          newNode:= FXMLBridge.XMLDocument.CreateElement(Trim(NodeName));
          refNode.Appendchild(newNode);
          for i:= 0 to attrList.Count-1 do
          begin
              attrList.GetNameValue(i, attrName,attrValue);
              TDOMElement(newNode).SetAttribute(Trim(AttrName), Trim(ReplaceChar(AttrValue,'+', ' ')));
          end;
       end
       else
       begin //default.... se não tiver filhos então assume como inner text....
          newNode:= FXMLBridge.XMLDocument.CreateTextNode(Trim(NodeName));
          refNode.Appendchild(newNode);

          {or ... se não tiver filhos então assume como um novo node.....
            newNode:= FXMLBridge.XMLDocument.CreateElement(Trim(NodeName));
            refNode.Appendchild(newNode)}
       end;
    end;
  end;
  attrList.Free;
  treeNode:= treeNode.GetFirstChild;
  while treeNode <> nil do
  begin
    TreeToXML(treeNode, newNode);
    treeNode := treeNode.getNextSibling;
  end;
end;

procedure TTreeViewXMLBridge.SaveToFileXML(pathXMLFileName: string);
begin
   UpdateXMLBridge;   {call TreeToXML...}
   FPathXMLDocument:= pathXMLFileName;
   FXMLBridge.SaveToFile(pathXMLFileName);
end;

constructor TTreeViewXMLBridge.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);

     FActive:= False;
     FIdentifyAttributeToken:= '*';
     //or FAttributeShowMode:= asListNameValue;
     FAttributeShowMode:= asChildNameValue;
     //or FAttributeShowMode:= asChildAndChild;

end;

destructor TTreeViewXMLBridge.Destroy;
begin
   inherited Destroy;
end;

function SplitStr(var theString: string; delimiter: string): string;
var
  i: integer;
begin
  Result:= '';
  if theString <> '' then
  begin
    i:= Pos(delimiter, theString);
    if i > 0 then
    begin
       Result:= Copy(theString, 1, i-1);
       theString:= Copy(theString, i+Length(delimiter), maxLongInt);
    end
    else
    begin
       Result := theString;
       theString := '';
    end;
  end;
end;

function TrimChar(query: string; delimiter: char): string;
var
  auxStr: string;
  count: integer;
  newchar: char;
begin
  newchar:=' ';
  if query <> '' then
  begin
      auxStr:= Trim(query);
      count:= Length(auxStr);
      if count >= 2 then
      begin
         if auxStr[1] = delimiter then  auxStr[1] := newchar;
         if auxStr[count] = delimiter then  auxStr[count] := newchar;
      end;
      Result:= Trim(auxStr);
  end;
end;

function ReplaceChar(query: string; oldchar, newchar: char):string;
begin
  if query <> '' then
  begin
     while Pos(oldchar,query) > 0 do query[pos(oldchar,query)]:= newchar;
     Result:= query;
  end;
end;

end.

