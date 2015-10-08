{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit ttreeviewxmlbridge_pack;

interface

uses
  regtreeviexmlbridges, TreeViewXMLBridge, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('regtreeviexmlbridges', @regtreeviexmlbridges.Register);
end;

initialization
  RegisterPackage('ttreeviewxmlbridge_pack', @Register);
end.
