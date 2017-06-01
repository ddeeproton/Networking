// Titi From France
// Traduction Delphi des API Microsoft pour obtenir des statistiques d'un r�seau
// Ces API font partie du fichier "IPHLPAPI.DLL"
// Commenc� le 27/06/2006
// Termin� le 01/07/2006
// Toutes les informations concernants les API sont disponibles en ligne
// � cette adresse -> http://msdn.microsoft.com/library/default.asp?url=/library/en-us/iphlp/iphlp/ip_helper_start_page.asp

unit API;

interface

uses Windows;

const
  MAX_INTERFACE_NAME_LEN = 256;
  MAXLEN_PHYSADDR        = 8;
  MAXLEN_IFDESCR         = 256;

// Cette structure contient les informations relatives � une interface r�seau
// --------------------------------------------------------------------------

type MIB_IFROW=record
  wszName           :  array[1..MAX_INTERFACE_NAME_LEN] of WCHAR;        // Nom de l'interface
  dwIndex           :  DWORD;                                            // Index de l'interface
  dwType            :  DWORD;                                            // Type de l'interface (7 valeurs possibles)
  dwMtu             :  DWORD;                                            // Valeur de la MTU
  dwSpeed           :  DWORD;                                            // Vitesse de la liaison en bits/secondes
  dwPhysAddrLen     :  DWORD;                                            // Longueur de l'adresse physique (MAC) de l'interface
  bPhysAddr         :  array[1..MAXLEN_PHYSADDR] of byte;                // Adresse physique de l'interface
  dwAdminStatus     :  DWORD;                                            // Interface active ou non
  dwOperStatus      :  DWORD;                                            // Status de l'interface (6 valeurs possibles)
  dwLastChange      :  DWORD;                                            // Dernier changement de status de l'interface
  dwInOctets        :  DWORD;                                            // Nombre d'octets re�us par l'interface
  dwInUcastPkts     :  DWORD;                                            // Nombre de paquets unicast re�us par l'interface
  dwInNUcastPkts    :  DWORD;                                            // Nombre de paquets non unicasts re�us par l'interface
  dwInDiscards      :  DWORD;                                            // Nombre de paquets ignor�s (en entr�e)
  dwInErrors        :  DWORD;                                            // Nombre de paquets ignor�s contenants des erreurs (en entr�e)
  dwInUnknownProtos :  DWORD;                                            // Nombre de paquets ignor�s (protocole inconnue en entr�e)
  dwOutOctets       :  DWORD;                                            // Nombre d'octest �mis pas l'interface
  dwOutUcastPkts    :  DWORD;                                            // Nombre de paquets unicasts �mis par l'interface
  dwOutNUcastPkts   :  DWORD;                                            // Nombre de paquets non unicasts �mis par l'interface
  dwOutDiscards     :  DWORD;                                            // Nombre de paquets ignor�s (en sortie)
  dwOutErrors       :  DWORD;                                            // Nombre de paquets ignor�s contenants des erreurs (en sortie)
  dwOutQLen         :  DWORD;                                            // Longueur de la file de sortie
  dwDescrLen        :  DWORD;                                            // Longueur de la description de l'interface
  bDescr            :  array[1..MAXLEN_IFDESCR] of char;                 // Description de l'interface
end;

{
 Diff�rents type d'interface :
  * MIB_IF_TYPE_OTHER          = type inconnue
  * MIB_IF_TYPE_ETHERNET       = ethernet
  * MIB_IF_TYPE_TOKENRING      = anneau � jeton
  * MIB_IF_TYPE_FDDI           = ?
  * MIB_IF_TYPE_PPP            = point par point
  * MIB_IF_TYPE_LOOPBACK       = loopback sur l'adresse locale (127.0.0.1)
  * MIB_IF_TYPE_SLIP           = ?
}

{
 Diff�rents status de l'interface
  * MIB_IF_OPER_STATUS_NON_OPERATIONAL 	  Interface d�sactiv�e
  * MIB_IF_OPER_STATUS_UNREACHABLE 	      Interface non connect�e
  * MIB_IF_OPER_STATUS_DISCONNECTED 	    Interface d�connect�
  * MIB_IF_OPER_STATUS_CONNECTING 	      Interface en cours de connexion
  * MIB_IF_OPER_STATUS_CONNECTED 	        Interface connect�
  * MIB_IF_OPER_STATUS_OPERATIONAL        Interface fonctionnelle (status par defaut)
}

PMIB_IFROW=^MIB_IFROW;

// Cette structure contient la liste de toutes les interfaces r�seau (limit� � 8 ici)
// ----------------------------------------------------------------------------------

type MIB_IFTABLE=record
  dwNumEntries  : DWORD;                                  // Nombre d'interface
  table         : array[1..8] of MIB_IFROW;               // Table contenant toutes les interfaces
end;

PMIB_IFTABLE=^MIB_IFTABLE;

// Extraction des informations propres � une interface
function GetIfEntry(PMib_IfRow:PMIB_IFROW):DWORD ; stdcall ; external 'IPHLPAPI.DLL';

// Extraction de la liste des interfaces
function GetIfTable(pIfTable:PMIB_IFTABLE;pdwSize:PULONG;bOrder:boolean):DWORD ; stdcall ; external 'IPHLPAPI.DLL';

implementation

end.
