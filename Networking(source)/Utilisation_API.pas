unit Utilisation_API;

interface

uses Windows, API;

 function ListerInterfaces  : PMIB_IFTABLE;

implementation

function ListerInterfaces : PMIB_IFTABLE;
var
  PMibIfTable : PMIB_IFTABLE;
  dwSize      : DWORD;
begin
  dwSize:=0;
  GetMem(PMibIfTable,SizeOf(MIB_IFTABLE));
  // Premier appel pour avoir la bonne taille de buffer
  if GetIfTable(PMibIfTable,Addr(dwSize),False)=ERROR_INSUFFICIENT_BUFFER then
  begin
   FreeMem(PMibIfTable,SizeOf(MIB_IFTABLE));
   GetMem(PMibIfTable,dwSize);
  end;
  // Second appel avec la bonne taille de buffer
  GetIfTable(PMibIfTable,Addr(dwSize),False);
  Result:=PMibIfTable;
end;

end.
