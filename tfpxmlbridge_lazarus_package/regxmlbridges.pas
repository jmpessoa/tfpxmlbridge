unit regxmlbridges;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  FPXMLBridge,TreeViewXMLBridge, LResources;

Procedure Register;

implementation

Procedure Register;

begin
  {$I fpxmlbridge_icon.lrs}
  {$I treeviewxmlbridge_icon.lrs}
  RegisterComponents('Bridges',[TFPXMLBridge, TTreeViewXMLBridge]);
end;

initialization

end.

end;
