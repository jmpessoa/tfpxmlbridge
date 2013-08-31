{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit tfpxmlbridge_pack;

interface

uses
  regxmlbridges, FPXMLBridge, TreeViewXMLBridge, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('regxmlbridges', @regxmlbridges.Register);
end;

initialization
  RegisterPackage('tfpxmlbridge_pack', @Register);
end.
