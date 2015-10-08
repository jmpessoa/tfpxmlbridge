unit regtreeviexmlbridges;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  TreeViewXMLBridge, LResources;

Procedure Register;

implementation

Procedure Register;
begin
  {$I treeviewxmlbridge_icon.lrs}
  RegisterComponents('Xml Bridges',[TTreeViewXMLBridge]);
end;


end.

