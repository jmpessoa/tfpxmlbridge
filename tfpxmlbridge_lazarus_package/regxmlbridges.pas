unit regxmlbridges;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  FPXMLBridge, LResources;

Procedure Register;

implementation

Procedure Register;

begin
  {$I fpxmlbridge_icon.lrs}
  RegisterComponents('Xml Bridges',[TFPXMLBridge]);
end;

initialization

end.

end;
