// Titi From France
// Traduction Delphi des API Microsoft pour obtenir des statistiques d'un réseau
// Ces API font partie du fichier "IPHLPAPI.DLL"
// Commencé le 27/06/2006
// Terminé le 01/07/2006
// Toutes les informations concernants les API sont disponibles en ligne
// à cette adresse -> http://msdn.microsoft.com/library/default.asp?url=/library/en-us/iphlp/iphlp/ip_helper_start_page.asp

unit API;

interface

uses Windows;

const
  MAX_INTERFACE_NAME_LEN = 256;
  MAXLEN_PHYSADDR        = 8;
  MAXLEN_IFDESCR         = 256;

// Cette structure contient les informations relatives à une interface réseau
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
  dwInOctets        :  DWORD;                                            // Nombre d'octets reçus par l'interface
  dwInUcastPkts     :  DWORD;                                            // Nombre de paquets unicast reçus par l'interface
  dwInNUcastPkts    :  DWORD;                                            // Nombre de paquets non unicasts reçus par l'interface
  dwInDiscards      :  DWORD;                                            // Nombre de paquets ignorés (en entrée)
  dwInErrors        :  DWORD;                                            // Nombre de paquets ignorés contenants des erreurs (en entrée)
  dwInUnknownProtos :  DWORD;                                            // Nombre de paquets ignorés (protocole inconnue en entrée)
  dwOutOctets       :  DWORD;                                            // Nombre d'octest émis pas l'interface
  dwOutUcastPkts    :  DWORD;                                            // Nombre de paquets unicasts émis par l'interface
  dwOutNUcastPkts   :  DWORD;                                            // Nombre de paquets non unicasts émis par l'interface
  dwOutDiscards     :  DWORD;                                            // Nombre de paquets ignorés (en sortie)
  dwOutErrors       :  DWORD;                                            // Nombre de paquets ignorés contenants des erreurs (en sortie)
  dwOutQLen         :  DWORD;                                            // Longueur de la file de sortie
  dwDescrLen        :  DWORD;                                            // Longueur de la description de l'interface
  bDescr            :  array[1..MAXLEN_IFDESCR] of char;                 // Description de l'interface
end;

{
 Différents type d'interface :
  * MIB_IF_TYPE_OTHER          = type inconnue
  * MIB_IF_TYPE_ETHERNET       = ethernet
  * MIB_IF_TYPE_TOKENRING      = anneau à jeton
  * MIB_IF_TYPE_FDDI           = ?
  * MIB_IF_TYPE_PPP            = point par point
  * MIB_IF_TYPE_LOOPBACK       = loopback sur l'adresse locale (127.0.0.1)
  * MIB_IF_TYPE_SLIP           = ?
}

{
 Différents status de l'interface
  * MIB_IF_OPER_STATUS_NON_OPERATIONAL 	  Interface désactivée
  * MIB_IF_OPER_STATUS_UNREACHABLE 	      Interface non connectée
  * MIB_IF_OPER_STATUS_DISCONNECTED 	    Interface déconnecté
  * MIB_IF_OPER_STATUS_CONNECTING 	      Interface en cours de connexion
  * MIB_IF_OPER_STATUS_CONNECTED 	        Interface connecté
  * MIB_IF_OPER_STATUS_OPERATIONAL        Interface fonctionnelle (status par defaut)
}

PMIB_IFROW=^MIB_IFROW;

// Cette structure contient la liste de toutes les interfaces réseau (limité à 8 ici)
// ----------------------------------------------------------------------------------

type MIB_IFTABLE=record
  dwNumEntries  : DWORD;                                  // Nombre d'interface
  table         : array[1..8] of MIB_IFROW;               // Table contenant toutes les interfaces
end;

PMIB_IFTABLE=^MIB_IFTABLE;

// Extraction des informations propres à une interface
function GetIfEntry(PMib_IfRow:PMIB_IFROW):DWORD ; stdcall ; external 'IPHLPAPI.DLL';

// Extraction de la liste des interfaces
function GetIfTable(pIfTable:PMIB_IFTABLE;pdwSize:PULONG;bOrder:boolean):DWORD ; stdcall ; external 'IPHLPAPI.DLL';

implementation

end.
