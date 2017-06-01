unit Fenetre_Principale;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, XPMan, StdCtrls, Buttons, ExtCtrls, API, Utilisation_API, Convertion_Unites,
  ComCtrls, TeeProcs, TeEngine, Chart, Series;

type
  TForm1 = class(TForm)
    Grp_Interfaces: TGroupBox;
    Cmb_Lst_Interfaces: TComboBox;
    Grp_Info_Interface: TGroupBox;
    XPManifest1: TXPManifest;
    Label1: TLabel;
    Image1: TImage;
    Panel2: TPanel;
    Edt_MTU: TEdit;
    Panel3: TPanel;
    Edt_Vitesse: TEdit;
    Panel4: TPanel;
    Edt_MAC: TEdit;
    Panel5: TPanel;
    Edt_Recu: TEdit;
    Panel6: TPanel;
    Edt_Envoye: TEdit;
    Grp_Tx_Transfert: TGroupBox;
    StatusBar1: TStatusBar;
    Graph_Download: TChart;
    Graph_Upload: TChart;
    Progress_Download: TProgressBar;
    Progress_Upload: TProgressBar;
    Pnl_Tx_Download: TPanel;
    Pnl_Tx_Upload: TPanel;
    Series2: TLineSeries;
    Series1: TLineSeries;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Cmb_Lst_InterfacesChange(Sender: TObject);
    function CalculerAdresseMAC:string;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ActualiserStats;
    procedure Timer1Timer(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;
  PtrInterface                  : PMIB_IFROW;
  PrecedentRecu,ActuelRecu      : LongWord;
  PrecedentEnvoye,ActuelEnvoye  : LongWord;
  PositionX                     : Double;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
  PtrTable        : PMIB_IFTABLE;
  NumeroInterface : byte;
begin
  // On va chercher la liste des interfaces
  PtrTable:=ListerInterfaces;
  // On reserve le pointeur vers notre interface
  GetMem(PtrInterface,SizeOf(MIB_IFROW));
  Cmb_Lst_Interfaces.Items.Clear;
  for NumeroInterface:=1 to PtrTable^.dwNumEntries do
  begin
    // On initialise dwIndex avec la valeur de l'index de l'interface à chercher
    PtrInterface^.dwIndex:=NumeroInterface;
    // On cherche l'interface
    GetIfEntry(PtrInterface);
    // On ajoute sa description à la liste
    Cmb_Lst_Interfaces.Items.Add(PtrInterface^.bDescr);
  end;
  Cmb_Lst_Interfaces.ItemIndex:=0;
  Cmb_Lst_InterfacesChange(Form1);
  FreeMem(PtrTable,SizeOf(PtrTable^));
end;

procedure TForm1.Cmb_Lst_InterfacesChange(Sender: TObject);
begin
  // L'interface courante à changé, il faut chercher les informations de la nouvelle interface
  PtrInterface^.dwIndex:=Cmb_Lst_Interfaces.ItemIndex+1;
  GetIfEntry(PtrInterface);
  Edt_MTU.Text:=IntToStr(PtrInterface^.dwMtu);
  Edt_Vitesse.Text:=Convertir_Bits(PtrInterface^.dwSpeed);
  Edt_MAC.Text:=CalculerAdresseMAC;
  Edt_Recu.Text:=Convertir_Octets(PtrInterface^.dwInOctets,True);
  Edt_Envoye.Text:=Convertir_Octets(PtrInterface^.dwOutOctets,True);
  // On initialise toutes les variables de travail pour cette nouvelle interface
  PrecedentRecu:=PtrInterface^.dwInOctets;
  PrecedentEnvoye:=PtrInterface^.dwOutOctets;
  ActuelRecu:=0;
  ActuelEnvoye:=0;
  // On remets à zéro les graphiques et barre-graphs
  Progress_Download.Max:=0;
  Progress_Upload.Max:=0;
  Graph_Download.Series[0].Clear;
  Graph_Upload.Series[0].Clear;
  Graph_Download.BottomAxis.Maximum:=60;
  Graph_Download.BottomAxis.Minimum:=0;
  Graph_Download.LeftAxis.Maximum:=0;
  Graph_Download.LeftAxis.Minimum:=0;
  Graph_Upload.BottomAxis.Maximum:=60;
  Graph_Upload.BottomAxis.Minimum:=0;
  Graph_Upload.LeftAxis.Maximum:=0;
  Graph_Upload.LeftAxis.Minimum:=0;
  PositionX:=0;
  ActualiserStats;
end;

function TForm1.CalculerAdresseMAC:string;
var
  IndexAdresse  : byte;
  AdresseMACTemp: string;
begin
  // L'adresse MAC est donnée sous la forme d'un tableau de byte, il ne reste plus
  // qu'à covertir chaque élément en Hexadécimal pour avoir une adresse MAC standard
  for IndexAdresse:=1 to PtrInterface^.dwPhysAddrLen do
  begin
    AdresseMACTemp:=AdresseMACTemp+IntToHex(PtrInterface^.bPhysAddr[IndexAdresse],2);
    if IndexAdresse<PtrInterface^.dwPhysAddrLen then
      AdresseMACTemp:=AdresseMACTemp+'-';
  end;
  if AdresseMACTemp='' then
    Result:='N/A'
  else
    Result:=AdresseMACTemp;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // On libère le pointeur de travail
  FreeMem(PtrInterface,SizeOf(PtrInterface^));
end;

procedure TForm1.ActualiserStats;
var
  PtrTable        : PMIB_IFTABLE;
begin
  // On réactualise les variables de l'interface
  PtrTable:=ListerInterfaces;
  PtrInterface^.dwIndex:=Cmb_Lst_Interfaces.ItemIndex+1;
  GetIfEntry(PtrInterface);
  FreeMem(PtrTable,SizeOf(PtrTable^));
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  DebitUpload,DebitDownload:LongWord;
begin
  // On actualise les variables de l'interfaces
  ActualiserStats;
  // On calcul les débits
  ActuelRecu:=PtrInterface^.dwInOctets;
  ActuelEnvoye:=PtrInterface^.dwOutOctets;
  DebitDownload:=ActuelRecu-PrecedentRecu;
  DebitUpload:=ActuelEnvoye-PrecedentEnvoye;
  // On affiche les barre-graph correspondants au repoussant les limites de ceux-ci
  // si nécéssaire
  if DebitDownLoad>=(Progress_Download.Max+0.0) then
    Progress_Download.Max:=DebitDownload;
  Progress_Download.Position:=DebitDownload;
  if DebitUpload>=(Progress_Upload.Max+0.0) then
    Progress_Upload.Max:=DebitUpload;
  Progress_Upload.Position:=DebitUpload;
  // On affiche les débits
  Pnl_Tx_Download.Caption:=Convertir_Octets(DebitDownload,True)+'/s';
  Pnl_Tx_Upload.Caption:=Convertir_Octets(DebitUpload,True)+'/s';
  // On trace les graphiques de débits
  Graph_Download.Series[0].AddXY(PositionX,DebitDownload);
  Graph_Upload.Series[0].AddXY(PositionX,DebitUpload);
  PositionX:=PositionX+1;
  // On fait défiler les deux graphiques vers la gauche si necéssaire
  if PositionX>Graph_Download.BottomAxis.Maximum then
  begin
    Graph_Download.BottomAxis.Maximum:=Graph_Download.BottomAxis.Maximum+1;
    Graph_Download.BottomAxis.Minimum:=Graph_Download.BottomAxis.Minimum+1;
    Graph_Upload.BottomAxis.Maximum:=Graph_Upload.BottomAxis.Maximum+1;
    Graph_Upload.BottomAxis.Minimum:=Graph_Upload.BottomAxis.Minimum+1;
  end;
  PrecedentRecu:=ActuelRecu;
  PrecedentEnvoye:=ActuelEnvoye;
end;

end.
