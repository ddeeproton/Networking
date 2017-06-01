program Netstat;

uses
  Forms,
  Fenetre_Principale in 'Fenetre_Principale.pas' {Form1},
  API in 'API.pas',
  Utilisation_API in 'Utilisation_API.pas',
  Convertion_Unites in 'Convertion_Unites.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
