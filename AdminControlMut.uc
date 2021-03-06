//================================================
// LairControl - Admin Control Mutator
// 
// Allows the use of extended admin commands and setup privileges to use this commands to admins
//
// Original Authors (AdminControlv2): Dr. Killjoy and Dave Scream
// Modified By: PotentiaLeaena
//================================================

class AdminControlMut extends Mutator
	config(LairControlV1);

var AdminRecord AdminsList;

var array<AdminSettings> Admins;
var array<AdminGroup> Groups;

var config int DisarmDuration;
var config array< class<AdminCommand> > Commands;

var config bool bDebug;

var array<string> MSG_Help;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	
	InitInfo();
}

function InitInfo()
{
	local array<string> Names;
	local int i,n;
	local AdminRecord TempAdmin;
	
	Names = class'AdminSettings'.Static.GetNames();
	
	while ( Names.Length > 0 )
	{
		Admins.Insert(0,1);
		Admins[0] = new (None,Names[0]) class'AdminSettings';
		Names.Remove(0,1);
	}

	Names = class'AdminGroup'.Static.GetNames();
	
	while ( Names.Length > 0 )
	{
		Groups.Insert(0,1);
		Groups[0] = new (None,Names[0]) class'AdminGroup';
		Names.Remove(0,1);
	}
	
	n = Admins.Length;
	
	if ( n <= 0 )
	{
		return;
	}
	
	AdminsList = new (None) class'AdminRecord';
	AdminsList.AdminGroup = FindAdminGroup(Admins[0].AdminGroup);
	AdminsList.PostInit(Self,Admins[0]);
	
	for ( i=1; i<n; i++ )
	{
		TempAdmin = new (None) class'AdminRecord';
		TempAdmin.NextAdmin = AdminsList;
		AdminsList = TempAdmin;
		AdminsList.AdminGroup = FindAdminGroup(Admins[i].AdminGroup);
		AdminsList.PostInit(Self,Admins[i]);
	}
}

function AdminGroup FindAdminGroup(string GroupName)
{
	local int i,n;
	
	class'AdminControlMut'.Static.DebugMessage(Self,"FindAdminGroup entry.");
	
	n = Groups.Length;
	class'AdminControlMut'.Static.DebugMessage(Self,"GroupName = " $ GroupName);
	for ( i = 0; i < n; i++ )
	{
		class'AdminControlMut'.Static.DebugMessage(Self,"Groups[i].Name = " $ Groups[i].Name);
		if ( string(Groups[i].Name) == GroupName )
		{
			class'AdminControlMut'.Static.DebugMessage(Self,"string(Groups[i].Name) == GroupName");
			return Groups[i];
		}
	}
	
	return none;
}

function AdminRecord FindAdminRecord(PlayerController PC)
{
	local AdminRecord AR;
	
	class'AdminControlMut'.Static.DebugMessage(PC,"FindAdminRecord entry.");
	
	class'AdminControlMut'.Static.DebugMessage(PC,"Player ID = " $ PC.GetPlayerIDHash());
	
	for( AR = AdminsList; AR != none; AR = AR.NextAdmin )
	{
		class'AdminControlMut'.Static.DebugMessage(PC,"Admin ID = " $ AR.AdminID);
		class'AdminControlMut'.Static.DebugMessage(PC,"Admin Group = " $ AR.AdminGroup);
		class'AdminControlMut'.Static.DebugMessage(PC,"Admin Controller = " $ AR.Controller);

		if ( AR.AdminID == PC.GetPlayerIDHash() )
		{
			class'AdminControlMut'.Static.DebugMessage(PC,"Admin ID = Player ID");
			AR.Controller = PC;
			return AR;
		}
	}
	
	return none;
}

function Mutate(string MutateString, PlayerController Sender)
{
	local class<AdminCommand> CurCom;
	local string ComName;
	local AdminRecord CurAdmin;
	local int pos;
	
	class'AdminControlMut'.Static.DebugMessage(Sender,"Mutate entry.");

	if ( NextMutator != None )
		NextMutator.Mutate(MutateString, Sender);
		
	if ( MutateString ~= "saveconfig" )
	{
		SaveConfig();
		return;
	}
		
	if ( MutateString ~= "help" )
	{
		class'AdminControlMut'.Static.DebugMessage(Sender,"Help entry.");
		CurAdmin = FindAdminRecord(Sender);

		if ( CurAdmin == none )
		{
			return;
		}
		
		SendHelpMessage(CurAdmin);
		
		return;
	}

	pos = InStr(MutateString," ");

	if ( pos == -1 )
	{
		ComName = MutateString;
	}
	else
	{
		ComName = Left(MutateString,pos);
	}
	
	CurCom = Static.RecognizeCommand(ComName);
	
	if ( CurCom == none )
	{
		Sender.ClientMessage("Unrecognized command.");
		return;
	}
	
	CurAdmin = FindAdminRecord(Sender);
	
	if ( CurAdmin == none )
	{
		return;
	}
	
	if ( pos != -1 )
	{
		MutateString = Mid(MutateString,pos+1);
	}

	if ( CurAdmin.AllowAction(CurCom) )
	{
		CurCom.Static.Perform(MutateString,CurAdmin);
	}
}

static function class<AdminCommand> RecognizeCommand(string ComName)
{
	local int i,n,j,m;
	
	n = default.Commands.Length;
	
	for(i=0; i<n; i++)
	{
		m = default.Commands[i].default.CommandName.Length;
		
		for(j=0; j<m; j++)
		{
			if ( default.Commands[i].default.CommandName[j] ~= ComName )
			{
				return default.Commands[i];
			}
		}
	}
	
	if ( ComName ~= "kick" || ComName ~= "session" )
	{
		return class'ActSession';
	}
	
	if ( ComName ~= "kickban" || ComName ~= "ban" )
	{
		return class'ActBan';
	}
	
	if ( ComName ~= "disarm" || ComName ~= "da" )
	{
		return class'ActDisarm';
	}
	
	if ( ComName ~= "killzeds" || ComName ~= "kz" )
	{
		return class'ActKillzeds';
	}
	
	if ( ComName ~= "confiscate" || ComName ~= "conf" )
	{
		return class'ActConfiscate';
	}
	
	if ( ComName ~= "abortwave" || ComName ~= "abort" )
	{
		return class'ActAbortWave';
	}
	
	if ( ComName ~= "setnextwave" || ComName ~= "nextw" )
	{
		return class'ActSetNextWave';
	}
	
	if ( ComName ~= "anchor" )
	{
		return class'ActAnchor';
	}
	
	if ( ComName ~= "SetTraderTime" || ComName ~= "stt" )
	{
		return class'ActSTT';
	}
	
	if ( ComName ~= "configurablesummon" || ComName ~= "cs" )
	{
		return class'ActConfigurableSummon';
	}
	
	if ( ComName ~= "restoreammo" || ComName ~= "resa" )
	{
		return class'ActRestoreAmmo';
	}
	
	if ( ComName ~= "collision" || ComName ~= "col" )
	{
		return class'ActCollision';
	}
	
	if ( ComName ~= "removeammo" || ComName ~= "rema" )
	{
		return class'ActRemoveAmmo';
	}
	
	if ( ComName ~= "slap" )
	{
		return class'ActSlap';
	}
	
	if ( ComName ~= "changename" || ComName ~= "cn" )
	{
		return class'ActChangeName';
	}
	
	if ( ComName ~= "PrivMessage" || ComName ~= "pm" )
	{
		return class'ActPrivMessage';
	}
	
	if ( ComName ~= "Respawn" )
	{
		return class'ActRespawn';
	}
	
	if ( ComName ~= "HeadSize" || ComName ~= "hs" )
	{
		return class'ActHeadSize';
	}
	
	if ( ComName ~= "PlayerSize" || ComName ~= "ps" )
	{
		return class'ActPlayerSize';
	}
	
	if ( ComName ~= "God" )
	{
		return class'ActGod';
	}
	
	if ( ComName ~= "ChangeScore" )
	{
		return class'ActChangeScore';
	}
	
	if ( ComName ~= "Slomo" )
	{
		return class'ActSlomo';
	}
	
	if ( ComName ~= "SetGravity" )
	{
		return class'ActSetGravity';
	}
	
	if ( ComName ~= "Invis" )
	{
		return class'ActInvis';
	}
	
	if ( ComName ~= "Ghost" )
	{
		return class'ActGhost';
	}
	
	if ( ComName ~= "Fly" )
	{
		return class'ActFly';
	}
	
	if ( ComName ~= "Spider" )
	{
		return class'ActSpider';
	}
	
	return none;
}

function SendHelpMessage(AdminRecord Sender)
{
	local int i;
	
	for(i=0; i<8; i++)
	{
		Sender.Controller.ClientMessage(MSG_Help[i]);
	}

	for(i=Sender.Allows.Length-1; i>=0; i--)
	{
		Sender.Allows[i].Static.HelpMessage(Sender);
	}
}

static function DebugMessage(Actor A, string Mess)
{
	local Controller C;
	
	if ( !default.bDebug )
	{
		return;
	}
	
	for(C=A.Level.ControllerList; C!=none; C=C.NextController)
	{
		if ( PlayerController(C) != none )
		{
			PlayerController(C).ClientMessage(Mess);
		}
	}
}

defaultproperties
{
     DisarmDuration=15
     Commands(0)=Class'LairControlV1.ActSession'
     Commands(1)=Class'LairControlV1.ActBan'
     Commands(2)=Class'LairControlV1.ActDisarm'
     Commands(3)=Class'LairControlV1.ActKillzeds'
     Commands(4)=Class'LairControlV1.ActConfiscate'
     Commands(5)=Class'LairControlV1.ActAbortWave'
     Commands(6)=Class'LairControlV1.ActSetNextWave'
     Commands(7)=Class'LairControlV1.ActAnchor'
     Commands(8)=Class'LairControlV1.ActSTT'
     Commands(9)=Class'LairControlV1.ActConfigurableSummon'
     Commands(10)=Class'LairControlV1.ActRestoreAmmo'
     Commands(11)=Class'LairControlV1.ActCollision'
     Commands(12)=Class'LairControlV1.ActRemoveAmmo'
     Commands(13)=Class'LairControlV1.ActSlap'
     Commands(14)=Class'LairControlV1.ActChangeName'
     Commands(15)=Class'LairControlV1.ActPrivMessage'
     Commands(16)=Class'LairControlV1.ActRespawn'
     Commands(17)=Class'LairControlV1.ActHeadSize'
     Commands(18)=Class'LairControlV1.ActPlayerSize'
     Commands(19)=Class'LairControlV1.ActGod'
     Commands(20)=Class'LairControlV1.ActChangeScore'
     Commands(21)=Class'LairControlV1.ActSlomo'
     Commands(22)=Class'LairControlV1.ActSetGravity'
     Commands(23)=Class'LairControlV1.ActInvis'
     Commands(24)=Class'LairControlV1.ActGhost'
     Commands(25)=Class'LairControlV1.ActFly'
     Commands(26)=Class'LairControlV1.ActSpider'
     Commands(27)=Class'LairControlV1.ActWalk'
     Commands(28)=Class'LairControlV1.ActSummon'
     Commands(29)=Class'LairControlV1.ActTeleport'
     Commands(30)=Class'LairControlV1.ActGiveItem'
     Commands(31)=Class'LairControlV1.ActLoaded'
     Commands(32)=Class'LairControlV1.ActKick'
     Commands(33)=Class'LairControlV1.ActSetTarget'
     Commands(34)=Class'LairControlV1.ActSilentMode'
     Commands(35)=Class'LairControlV1.ActRestoreDoors'
     Commands(36)=Class'LairControlV1.ActFatality'
     MSG_Help(0)="Always put the word mutate before a command. Example: mutate killzeds."
     MSG_Help(1)="Most commands can be used on players by name, partial name, or Player ID."
     MSG_Help(2)="You can find a player's ID in the vote kick menu."
	 MSG_Help(3)="Commands can also be used on multiple players at once. Example: mutate disarm foo, bar"
	 MSG_Help(4)="You can also apply a command to all, excluding certain players. Example: mutate god on all! Gena! Jora"
	 MSG_Help(5)="More information on commands can be found in the LairServers' Admin Handbook."
	 MSG_Help(6)="The following is a list of currently available commands:"
	 MSG_Help(7)="--------------------------------------------------------------------------------"
     GroupName="KF-LairControlV1"
     FriendlyName="LairControl v1"
     Description="Allows for the use of extended admin commands and privilege management."
     bAlwaysRelevant=True
     RemoteRole=ROLE_SimulatedProxy
}
