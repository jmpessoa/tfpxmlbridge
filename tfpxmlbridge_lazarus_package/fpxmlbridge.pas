unit FPXMLBridge;

{$mode objfpc}{$H+}

{

TFPXMLBridge - Version 0.1 - 01/2013');
Author: Jose Marques Pessoa : jmpessoa__hotmail_com
[1]Warning: at the moment this code is just a *proof-of-concept*

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
library.book(*).item(*).publisher(*)        :attribute index [0] to all * = default
library.book([0]).item([0]).publisher([1])  :attribute index [1] only to publisher


[4]Have fun!

}

interface

uses
  Classes, SysUtils, LResources,DOM, XMLWrite, XMLRead, TypInfo;

type

  TBuildingBridge = procedure(currentNodeName, attrList: string; out attrBridge: string) of Object;
  TUpdateXMLDocument = procedure(nodeName, value: string) of object;
  TSaveXMLDocument = procedure(pathFileName: string) of object;

  TReadManyTextContent = procedure(nodeName, value: string) of object;

  TFPXMLBridge = class(TComponent)
    private
      { private declarations }
      FXMLDocument: TXMLDocument;
      FRootNode: TDOMNode;
      FCurrentNode: TDOMNode;
      FXMLDocumentPath:string;
     // FIndexLocation: integer;

      FLocation:string;

      FOnBuildingBridge: TBuildingBridge;

      FOnUpdateXMLDocument: TUpdateXMLDocument;
      FOnSaveXMLDocument: TSaveXMLDocument;

      FOnReadManyTextContent: TReadManyTextContent;

      FWhenManyTextContentShowNodeName: boolean;

      FNamespaceSeparatorToken: char;
      FNameValueSeparatorToken: char;
      FAssignmentToken: char;
      FAttributeNameValueStartToken: char;
      FAttributeNameValueEndToken: char;
      FAttributesSeparatorToken: char;
      FConcatenationToken: char;
      FIndexStartToken: char;
      FIndexEndToken: char;
      FBridgeLateBindingToken: char;

      function GetDOMNodeReference(rootNode:TDOMNode; query: string):TDOMNode;
      function GetDOMSubNodeRerefence(refNode: TDOMNode; query: string): TDOMNode;
      function GetCurrentNode: TDOMNode;

      procedure DoBuildingBridge(currentNodeName, attrList: string;  out attrBridge: string);

      procedure DoUpdateXMLDocument(nodeName, value: string);
      procedure DoSaveXMLDocument(pathFileName: string);

      procedure DoReadManyTextContent(nodeName, value: string); //many inner text content from multiples nodes..

      procedure SetLocation(value: string);
      procedure SetXMLDocumentPath(value: string);
      function GetXMLDocumentPath: string;
      procedure SetFXMLDocument(value: TXMLDocument);

      function GetFFXMLDocument: TXMLDocument;
      function GetRootNode: TDOMNode;

      function GetTextContent(refNode: TDOMNode): string; //inner text content
      function CreateNode(refNode: TDOMNode; query: string): TDOMNode;
      procedure RemoveNode(refNode: TDOMNode);
      procedure SetTextContent(refNode: TDOMNode; value: string);
    public
      {public declarations }
      Active: boolean;
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;

      constructor CreateXMLDocument(pathXMLFileName: string; rootName: string);
      procedure LoadFromFile(pathXMLFileName: string);
      procedure SaveToFile(pathXMLFileName: string);

      function GetValue(query: string): string;
      function GetNode(query: string): TDOMNode;
      procedure SetValue(query: string);
      function InsertNode(query: string): TDOMNode;
      procedure RemoveNode(query: string);

      function GetValueFromNodeRerence(pathNode:TDOMNode; query: string): string;
      function GetNodeFromNodeRerence(pathNode:TDOMNode; query: string): TDOMNode;
      procedure SetValueFromNodeRerence(pathNode:TDOMNode; query: string);
      function InsertNodeFromNodeRerence(pathNode:TDOMNode; query: string): TDOMNode;
      procedure RemoveNodeFromNodeRerence(pathNode:TDOMNode; query: string);

      function CountElementNodeChildren(referenceNode: TDOMNode ): integer;
      function GetChildByIndex(referenceNode: TDOMNode; indexchi: integer): TDOMNode;
      function GetChildByName(referenceNode: TDOMNode; AName: string): TDOMNode;
      function GetChildNodeByNameAndAttribute(refNode:TDOMNode; nodeName, attrValue:string): TDOMNode;

      function GetValueFromChildByName(referenceNode: TDOMNode; AName: string): string;
      function GetValueFromChildByIndex(referenceNode: TDOMNode; indexchi: integer): string;

      property RootNode: TDOMNode Read  GetRootNode;
      property CurrentNode: TDOMNode Read  GetCurrentNode;

  published
    property NamespaceSeparatorToken: char read FNamespaceSeparatorToken write FNamespaceSeparatorToken;
    property NameValueSeparatorToken: char read FNameValueSeparatorToken write FNameValueSeparatorToken;
    property AssignmentToken: char read FAssignmentToken write FAssignmentToken;
    property AttributeNameValueStartToken: char read FAttributeNameValueStartToken write FAttributeNameValueStartToken;
    property AttributeNameValueEndToken: char read FAttributeNameValueEndToken write FAttributeNameValueEndToken;
    property AttributesSeparatorToken: char read FAttributesSeparatorToken write FAttributesSeparatorToken;
    property ConcatenationToken: char read FConcatenationToken write FConcatenationToken;
    property IndexStartToken: char read FIndexStartToken write FIndexStartToken;
    property IndexEndToken: char read FIndexEndToken write FIndexEndToken;
    property BridgeLateBindingToken: char read FBridgeLateBindingToken write FBridgeLateBindingToken;
    property WhenManyTextContentShowNodeName: boolean read FWhenManyTextContentShowNodeName write FWhenManyTextContentShowNodeName;

    property XMLDocumentPath: string read GetXMLDocumentPath write SetXMLDocumentPath;
    property OnBuildingBridge: TBuildingBridge Read FOnBuildingBridge write FOnBuildingBridge;
    property OnUpdateXMLDocument: TUpdateXMLDocument Read FOnUpdateXMLDocument write FOnUpdateXMLDocument;
    property OnSaveXMLDocument: TSaveXMLDocument read FOnSaveXMLDocument write FOnSaveXMLDocument;
    property OnReadManyTextContent: TReadManyTextContent Read FOnReadManyTextContent write FOnReadManyTextContent;
  end;

  function SplitStr(var theString : string; delimiter : string) : string;
  function TrimChar(query: string; delimiter: char): string;
  function ReplaceChar(query:string; oldchar, newchar: char):string;
  function CountChar(query: string; delimiter: char): Integer;

procedure Register;

implementation

procedure Register;
begin
  {$I fpxmlbridge_icon.lrs}
  RegisterComponents('Bridges',[TFPXMLBridge]);
end;

{TFPXMLBridge}

procedure TFPXMLBridge.DoBuildingBridge(currentNodeName, attrList: string;  out attrBridge: string);
begin
   if Assigned(FOnBuildingBridge) then FOnBuildingBridge(currentNodeName,attrList,attrBridge);
end;

procedure TFPXMLBridge.DoUpdateXMLDocument(nodeName, value: string);
begin
   if Assigned(FOnUpdateXMLDocument) then FOnUpdateXMLDocument(nodeName, value);
end;

procedure TFPXMLBridge.DoSaveXMLDocument(pathFileName: string);
begin
    if Assigned(FOnSaveXMLDocument) then FOnSaveXMLDocument(pathFileName);
end;

procedure TFPXMLBridge.DoReadManyTextContent(nodeName, value: string);
begin
   if Assigned(FOnReadManyTextContent) then FOnReadManyTextContent(nodeName, value);
end;
       //TODO: sanity code for location here........
procedure TFPXMLBridge.SetLocation(value: string);
begin
   FLocation:= value;
end;

procedure TFPXMLBridge.SetXMLDocumentPath(value: string);
begin
    FXMLDocumentPath:= value;
end;

procedure TFPXMLBridge.SetFXMLDocument(value: TXMLDocument);
begin
    FXMLDocument:= value;
end;

function TFPXMLBridge.GetXMLDocumentPath: string;
begin
    Result:= FXMLDocumentPath;
end;

function TFPXMLBridge.GetFFXMLDocument: TXMLDocument;
begin
    Result:= FXMLDocument;
end;

function TFPXMLBridge.GetRootNode: TDOMNode;
begin
   Result:= FRootNode;
end;

function TFPXMLBridge.GetTextContent(refNode: TDOMNode): string;
var
   strValue: string;
   i: integer;
begin
  if refNode <> nil then
  begin
    FCurrentNode:= refNode;
    if refNode.ChildNodes.Count = 1 then strValue:=refNode.TextContent
    else
    begin
       strValue:= '';
       for i:=0 to refNode.ChildNodes.Count-1 do
       begin
          if refNode.ChildNodes.Item[i].ChildNodes.Count = 1 then
          begin
             DoReadManyTextContent(refNode.ChildNodes.Item[i].NodeName, refNode.ChildNodes.Item[i].TextContent);
             if WhenManyTextContentShowNodeName = True then
             begin
                strValue:= strValue + refNode.ChildNodes.Item[i].NodeName+NameValueSeparatorToken+
                           refNode.ChildNodes.Item[i].TextContent + ConcatenationToken
             end
             else
             begin
                strValue:= strValue + refNode.ChildNodes.Item[i].TextContent + ConcatenationToken;
             end;
          end;
       end;
    end;
    Result:= TrimChar(strValue, ConcatenationToken);
  end;
end;
                    //%%%%%%%%%%
function  TFPXMLBridge.GetDOMNodeReference(rootNode:TDOMNode; query: string):TDOMNode;
var
   tokens: TStringList;
   itemNode, refNode: TDOMNode;
   i, j, attrIndex: integer;
   nodeName, attrValue, forwardNodeName, attrList, newAttr: string;
begin
   tokens:= TStringList.Create;
   tokens.Delimiter:= NamespaceSeparatorToken; {'.'}
   tokens.DelimitedText:=ReplaceChar(Trim(query),' ','+');
   refNode:= rootNode;
   if refNode <> nil then
   begin
     for i:= 1 to tokens.Count-1 do
     begin
        attrValue:='';
        nodeName:= tokens.Strings[i];
        if Pos(AttributeNameValueStartToken, nodeName) > 0 then
        begin
           forwardNodeName:= tokens.Strings[i]; //save state...
           nodeName:= SplitStr(forwardNodeName, AttributeNameValueStartToken);
           attrValue:= SplitStr(forwardNodeName, AttributeNameValueEndToken);
           if Pos(NamespaceSeparatorToken, forwardNodeName) > 0 then    //format: node(attr).forwardNode
               forwardNodeName:= TrimChar(forwardNodeName, NamespaceSeparatorToken)
           else forwardNodeName:='';
           if (attrValue = BridgeLateBindingToken) or (Pos(IndexStartToken, attrValue) > 0) then
           begin
              attrList:= '';
              for j:= 0 to refNode.GetChildNodes.Count-1 do
              begin
                 if Pos(nodeName, refNode.GetChildNodes.Item[j].NodeName) > 0 then
                 begin
                     if refNode.GetChildNodes.Item[j].NodeType = ELEMENT_NODE then
                     begin
                        if (attrValue = BridgeLateBindingToken) then   {*}
                        begin
                          if refNode.GetChildNodes.Item[j].Attributes.Item[0] <> nil then
                          begin
                              attrList:= attrList + ConcatenationToken +
                                         refNode.GetChildNodes.Item[j].Attributes.Item[0].TextContent;
                          end;
                        end
                        else    {format: [attributeIndex] }
                        begin
                           attrValue:= ReplaceChar(attrValue,IndexStartToken, ' ');
                           attrValue:= ReplaceChar(attrValue,IndexEndToken, ' ');
                           attrIndex:= strToInt(Trim(attrValue));
                           if refNode.GetChildNodes.Item[j].Attributes.Item[attrIndex] <> nil then
                           begin
                              attrList:= attrList + ConcatenationToken +
                                         refNode.GetChildNodes.Item[j].Attributes.Item[attrIndex].TextContent;
                           end;
                        end;
                     end;
                 end;
              end;
              attrList:= TrimChar(attrList, ConcatenationToken);
              DoBuildingBridge(nodeName, attrList , newAttr);
              attrValue:= newAttr;
           end;
        end;
        itemNode:=GetChildNodeByNameAndAttribute(refNode, nodeName, ReplaceChar(attrValue,'+',' '));
        if forwardNodeName <> '' then
        begin
           itemNode:= GetChildNodeByNameAndAttribute(itemNode, forwardNodeName ,'');
        end;
        if itemNode <> nil then refNode:= itemNode;
     end;
   end;
   tokens.Free;
   FCurrentNode:= refNode;
   result:= refNode;
end;

function TFPXMLBridge.GetDOMSubNodeRerefence(refNode: TDOMNode; query: string): TDOMNode;
var
    i,j : integer;
    subtokens1: string;
begin
    Result:=nil;

    subtokens1:= query;
    if Pos(NameValueSeparatorToken, subtokens1) > 0 then
    begin
        SplitStr(subtokens1,NameValueSeparatorToken);
    end;
    if refNode <> nil then
    begin
       //get reference Node by attribute value ...
       for i:= 0 to refNode.GetChildNodes.Count-1 do
       begin
          if refNode.GetChildNodes.Item[i].NodeType = ELEMENT_NODE then
          begin
              if refNode.GetChildNodes.Item[i].Attributes.Item[0] <> nil then
              begin
                 for j:=0 to refNode.GetChildNodes.Item[i].Attributes.Length -1 do
                 begin
                      if CompareText(refNode.GetChildNodes.Item[i].Attributes.Item[j].TextContent,
                                ReplaceChar(subtokens1,'+',' '))= 0 then
                      begin
                          Result:=refNode.GetChildNodes.Item[i];
                          break;
                      end;
                 end;
              end;
          end;
       end;
    end;
    FCurrentNode:= Result;
end;

function TFPXMLBridge.GetCurrentNode: TDOMNode;
begin
    Result:= FCurrentNode;
end;

function TFPXMLBridge.GetValue(query: string): string;
begin
   SetLocation(query);
   Result:= GetValueFromNodeRerence(FRootNode, FLocation);
end;

function TFPXMLBridge.GetNode(query: string): TDOMNode;
begin
   SetLocation(query);
   Result:= GetNodeFromNodeRerence(FRootNode, FLocation);
   FCurrentNode:= Result;
end;

procedure TFPXMLBridge.SetValue(query: string);
var
  refNode: TDOMNode;
  path: string;
begin
   if Pos(AssignmentToken, query) > 0 then
   begin
      path:= SplitStr(query, AssignmentToken);
      SetLocation(path);
      refNode:=GetNode(FLocation);
      if refNode <> nil then SetTextContent(refNode, query);
   end;
end;

procedure TFPXMLBridge.RemoveNode(refNode: TDOMNode);
var
  parentNode: TDOMNode;
  nodeName, nodeValue: string;
begin
   nodeName:= refNode.NodeName;
   nodeValue:= refNode.TextContent;
   parentNode:=refNode.ParentNode;
   parentNode.RemoveChild(refNode);
   //SaveToFile(FXMLDocumentPath);
   FCurrentNode:= parentNode;
   DoUpdateXMLDocument(nodeName, nodeValue);
end;

procedure TFPXMLBridge.RemoveNodeFromNodeRerence(pathNode: TDOMNode; query: string);
var
   refNode: TDOMNode;
   ShortQuery: string;
begin
   ShortQuery:= Trim(query);
   refNode:= GetNodeFromNodeRerence(pathNode, ShortQuery);
   if refNode <> nil then RemoveNode(refNode);
end;

procedure TFPXMLBridge.RemoveNode(query: string);
var
   refNode:TDOMNode;
begin
  refNode:=GetNode(query);
  if refNode <> nil then RemoveNode(refNode);
end;

function TFPXMLBridge.CreateNode(refNode: TDOMNode; query: string): TDOMNode;
var
   newNode: TDOMNode;
   newNodeInfo: TStringList;
   attrList: TStringList;
   attName,attValue: string;
   i: integer;
   localQuery: string;
begin
  Result:= nil;
  localQuery:= query;
  if refNode <> nil then
  begin
    newNodeInfo:= TStringList.Create;
    if Pos({'.'} NamespaceSeparatorToken, localQuery) > 0 then
    begin
        newNodeInfo.Delimiter:= NamespaceSeparatorToken {'.'};
        newNodeInfo.DelimitedText:= ReplaceChar(localQuery, ' ', '+');
        for i:= 0 to newNodeInfo.Count-2 do
        begin
           newNode:=CreateNode(refNode,newNodeInfo.Strings[i]);
           refNode:= newNode;
        end;
        localQuery:= newNodeInfo.Strings[newNodeInfo.Count-1];
    end;
    newNodeInfo.Clear;
    newNodeInfo.Delimiter:=ConcatenationToken;
    newNodeInfo.DelimitedText:= ReplaceChar(ReplaceChar(ReplaceChar(localQuery, AttributeNameValueStartToken, ConcatenationToken),
                                AttributeNameValueEndToken, ConcatenationToken),' ','+');
                                //format: nodename(attrName1#attrValue1;attrName2#attrValue2)textContent or
                                //nodename()textContent or nodename
    if newNodeInfo.Count > 0 then
       newNode:= FXMLDocument.CreateElement(newNodeInfo.Strings[0]);
    if newNode <> nil then
    begin
      if newNodeInfo.Count > 1 then
      begin
        if newNodeInfo.Strings[1] <> '' then
        begin
           if Pos(NameValueSeparatorToken, newNodeInfo.Strings[1]) > 0 then  //has attribute
           begin
             attValue:= newNodeInfo.Strings[1];
             if Pos(AttributesSeparatorToken{';'}, attValue) > 0 then  //more than one attribute
             begin
                attrList:= TStringList.Create;
                attrList.Delimiter:= AttributesSeparatorToken{';'};
                attrList.DelimitedText:= attValue;
                for i:= 0 to attrList.Count-1 do
                begin
                   attValue:= attrList.Strings[i];
                   attName:=SplitStr(attValue,NameValueSeparatorToken);
                   if attName <> '' then TDOMElement(newNode).SetAttribute(attName, ReplaceChar(attValue, '+',' '));

                end;
                attrList.Free;
             end
             else//has only one attribute
             begin
                 attName:=SplitStr(attValue,NameValueSeparatorToken);
                 if attName <> '' then TDOMElement(newNode).SetAttribute(attName, ReplaceChar(attValue, '+',' '));
             end;
           end;
        end;
      end;
      if newNodeInfo.Count > 2 then //has inner/content text
           newNode.Appendchild(FXMLDocument.CreateTextNode(ReplaceChar(newNodeInfo.Strings[2],'+',' ')));
      refNode.Appendchild(newNode);
      Result:= newNode;
      //SaveToFile(FXMLDocumentPath);
      DoUpdateXMLDocument(newNode.NodeName, query);
    end;
    newNodeInfo.Free;
  end;
  FCurrentNode:= Result;
end;

function TFPXMLBridge.InsertNode(query: string): TDOMNode;
var
  refNode:TDOMNode;
  path: string;
begin
  Result:= nil;
  SetLocation(query);
  if Pos(AssignmentToken, query) > 0 then
  begin
    path:= SplitStr(query,AssignmentToken);
    SetLocation(path);
    refNode:=GetNode(FLocation);
    if refNode <> nil then Result:=CreateNode(refNode, query);
  end;
end;

function TFPXMLBridge.InsertNodeFromNodeRerence(pathNode: TDOMNode; query: string): TDOMNode;
var
   refNode:TDOMNode;
   path, ShortQuery: string;
begin
  Result:= nil;
  ShortQuery:= query;
  if Pos(AssignmentToken, ShortQuery) > 0 then
  begin
    path:= SplitStr(ShortQuery, AssignmentToken);
    SetLocation(path);
    refNode:= GetNodeFromNodeRerence(pathNode, FLocation);
    if refNode <> nil then Result:=CreateNode(refNode, ShortQuery);
  end;
end;

procedure TFPXMLBridge.SetTextContent(refNode: TDOMNode; value: string);
begin
  if refNode <> nil then
  begin
    FCurrentNode:=refNode;
    if refNode.ChildNodes.Count = 1 then
    begin
       refNode.TextContent:= value;
       //SaveToFile(FXMLDocumentPath);
       DoUpdateXMLDocument(refNode.NodeName, value);
    end;
  end;
end;

procedure TFPXMLBridge.SetValueFromNodeRerence(pathNode:TDOMNode; query: string);
var
  refNode: TDOMNode;
  path, ShortQuery: string;
begin
  ShortQuery:= query;
  if Pos(AssignmentToken, ShortQuery) > 0 then
  begin
     path:= SplitStr(ShortQuery,AssignmentToken);
     SetLocation(path);
     refNode:= GetNodeFromNodeRerence(pathNode, FLocation);
     if refNode <> nil then SetTextContent(refNode, ShortQuery);
  end;
end;

function TFPXMLBridge.CountElementNodeChildren(referenceNode: TDOMNode): integer;
var
    count,i: integer;
begin
    FCurrentNode:= referenceNode;
    count:=0;
    for i:=0 to referenceNode.GetChildNodes.Count-1 do
    begin
      if referenceNode.GetChildNodes.Item[i].NodeType = ELEMENT_NODE then
         inc(count);
    end;
    Result:= count;
end;

function TFPXMLBridge.GetChildByIndex(referenceNode: TDOMNode; indexchi: integer): TDOMNode;
var
    count: integer;
begin
    Result:=nil;
    count:= referenceNode.GetChildNodes.Count;
    if indexchi < count then
    begin
       Result:= referenceNode.GetChildNodes.Item[indexchi];
    end;
    FCurrentNode:= Result;
end;

function TFPXMLBridge.GetChildByName(referenceNode: TDOMNode; AName: string): TDOMNode;
begin
   Result:=nil;
   if referenceNode.NodeType = ELEMENT_NODE then
   begin
      Result:=getNodeFromNodeRerence(referenceNode, referenceNode.NodeName+ NamespaceSeparatorToken{'.'}+AName)
   end;
   FCurrentNode:= Result;
end;

function TFPXMLBridge.GetValueFromChildByName(referenceNode: TDOMNode; AName: string): string;
begin
   Result:='';
   if referenceNode.NodeType = ELEMENT_NODE then
   begin
      Result:=getValueFromNodeRerence(referenceNode, referenceNode.NodeName+ NamespaceSeparatorToken{'.'}+AName)
   end;
end;

function TFPXMLBridge.GetValueFromChildByIndex(referenceNode: TDOMNode; indexchi: integer): string;
var
   tempNode: TDOMNode;
begin
    Result:= '';
    tempNode:=GetChildByIndex(referenceNode, indexchi);
    if tempNode <> nil then
    begin
       Result:= GetTextContent(tempNode);
    end;
end;

function TFPXMLBridge.GetValueFromNodeRerence(pathNode:TDOMNode; query: string): string;
var
   baseNode: TDOMNode;
   ShortQuery: string;
begin
   ShortQuery:= query;
   baseNode:= GetNodeFromNodeRerence(pathNode, ShortQuery);
   Result:= GetTextContent(baseNode);
end;

function TFPXMLBridge.GetChildNodeByNameAndAttribute(refNode:TDOMNode; nodeName, attrValue:string): TDOMNode;
var
    j, k, count, leng: integer;
    tempNode: TDOMNode;
    attrContent: string;
begin
    Result:= nil;
    j:= 0;
    count:=refNode.GetChildNodes.Count;
    while j < count  do
    begin
        tempNode:= refNode.GetChildNodes.Item[j];
        if CompareText(tempNode.NodeName, nodeName) = 0 then
        begin
            if attrValue <> '' then
            begin
               k:=0;
               leng:= tempNode.Attributes.Length;
               while k < leng do
               begin
                   if tempNode.Attributes.Item[k] <> nil then
                   begin
                       attrContent:= tempNode.Attributes.Item[k].TextContent;
                       if CompareText(attrContent, attrValue) = 0  then
                       begin
                          Result:= tempNode;
                          break; //exit while inner;
                       end;
                   end;
                   inc(k);
               end;
            end
            else
            begin
                Result:= tempNode;
                break;  //exit while
            end;
        end;
        inc(j);
    end;
end;
             //format: library.book(100).item(lazarus guide).author
function TFPXMLBridge.GetNodeFromNodeRerence(pathNode:TDOMNode; query:string): TDOMNode;
var
  refNode, nodePoint: TDOMNode;
begin
  Result:= nil;
  if pathNode <> nil then
  begin
        refNode:=pathNode;
        SetLocation(query);
        nodePoint:= GetDOMNodeReference(refNode, FLocation);
        result:= nodePoint;
  end;
  FCurrentNode:= Result;
end;

procedure TFPXMLBridge.LoadFromFile(pathXMLFileName: string);
begin
  FXMLDocumentPath:= pathXMLFileName;
  ReadXMLFile(FXMLDocument, FXMLDocumentPath);
  FRootNode:= FXMLDocument.DocumentElement;
  FCurrentNode:= FRootNode;
  Active:= True;
end;

procedure TFPXMLBridge.SaveToFile(pathXMLFileName: string);
begin
   WriteXMLFile(FXMLDocument, pathXMLFileName);
   DoSaveXMLDocument(pathXMLFileName);
end;

constructor TFPXMLBridge.CreateXMLDocument(pathXMLFileName: string; rootName: string);
begin
  FXMLDocumentPath:= pathXMLFileName;
  // Create a document
  if FXMLDocument <> nil then FXMLDocument.Free;

  FXMLDocument := TXMLDocument.Create;
  // Create a root node
  FRootNode := FXMLDocument.CreateElement(rootName);
  FCurrentNode:= FRootNode;
  FXMLDocument.Appendchild(FRootNode);
  //SaveToFile(pathXMLFileName);
  Active:= True;
end;

constructor TFPXMLBridge.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  WhenManyTextContentShowNodeName:= True;
  NamespaceSeparatorToken:= '.';
  NameValueSeparatorToken:= '#';
  AssignmentToken:= '$';
  ConcatenationToken:= '|';
  AttributeNameValueStartToken:= '(';
  AttributeNameValueEndToken:= ')';
  AttributesSeparatorToken:= ';';
  IndexStartToken:= '[';
  IndexEndToken:= ']';
  BridgeLateBindingToken:= '*';
end;

destructor TFPXMLBridge.Destroy;
begin
  FXMLDocument.Free;
  inherited Destroy;
end;

     {Generics Functions}
function CountChar(query: string; delimiter: char): Integer;
var
  i, count: integer;
begin
  Result:=0;
  if query <> '' then
  begin
      count:= 0;
      for i:= 1 to Length(query) do if query[i]= delimiter then count:=count + 1;
      Result:= count;
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
      if count > 2 then
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

end.

