unit Convertion_Unites;

interface

uses SysUtils;

  function Convertir_Bits(Valeur:LongWord):string;
  function Convertir_Octets(Valeur:LongWord;IndiquerUnites:boolean):string;

implementation

function Convertir_Bits(Valeur:LongWord):string;
begin
  if Valeur>1000000000 then
  begin
    Result:=FloatToStrF(Valeur/1000000000,ffGeneral,3,16)+' GBit/sec';
    exit;
  end;
  if Valeur>1000000 then
  begin
    Result:=FloatToStrF(Valeur/1000000,ffGeneral,3,16)+' MBit/sec';
    exit;
  end;
  if Valeur>1000 then
  begin
    Result:=FloatToStrF(Valeur/1000,ffGeneral,3,16)+' kBit/sec';
    exit;
  end;
  Result:=IntToStr(Valeur)+' Bit/sec';
end;

function Convertir_Octets(Valeur:LongWord;IndiquerUnites:boolean):string;
begin
  if Valeur>1073741824 then
  begin
    if IndiquerUnites then
      Result:=FloatToStrF(Valeur/1073741824,ffGeneral,3,16)+' GO'
    else
      Result:=FloatToStrF(Valeur/1073741824,ffGeneral,3,16);
    exit;
  end;
  if Valeur>1048576 then
  begin
    if IndiquerUnites then
      Result:=FloatToStrF(Valeur/1048576,ffGeneral,3,16)+' MO'
    else
      Result:=FloatToStrF(Valeur/1048576,ffGeneral,3,16);
    exit;
  end;
  if Valeur>1024 then
  begin
    if IndiquerUnites then
      Result:=FloatToStrF(Valeur/1024,ffGeneral,3,16)+' kO'
    else
      Result:=FloatToStrF(Valeur/1024,ffGeneral,3,16);
    exit;
  end;
  if IndiquerUnites then
    Result:=IntToStr(Valeur)+' Octets'
  else
    Result:=IntToStr(Valeur);
end;

end.
