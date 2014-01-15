//================================================
//
// Admin Control мутатор
//
// Позволяет использовать новые админские команды в игре, и настраивать привилегии админам на использование этих команд.
//
// Авторы: Dr. Killjoy (Steklo) и Dave Scream (Тело)
//
// Admin Control Mutator
// 
// Allows to use extended admin commands and setup privileges to use this commands to admins
//
// Authors: Dr. Killjoy (Steklo) and Dave Scream (Telo)
//
//================================================

class AdminControlMut extends Mutator
	config(AdminControlv2);

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
	local int i,n;
	
	for(i=0; i<12; i++)
	{
		Sender.Controller.ClientMessage(MSG_Help[i]);
	}

	for(i=Sender.Allows.Length; i>=0; i--)
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
     Commands(0)=Class'AdminControlv2.ActSession'
     Commands(1)=Class'AdminControlv2.ActBan'
     Commands(2)=Class'AdminControlv2.ActDisarm'
     Commands(3)=Class'AdminControlv2.ActKillzeds'
     Commands(4)=Class'AdminControlv2.ActConfiscate'
     Commands(5)=Class'AdminControlv2.ActAbortWave'
     Commands(6)=Class'AdminControlv2.ActSetNextWave'
     Commands(7)=Class'AdminControlv2.ActAnchor'
     Commands(8)=Class'AdminControlv2.ActSTT'
     Commands(9)=Class'AdminControlv2.ActConfigurableSummon'
     Commands(10)=Class'AdminControlv2.ActRestoreAmmo'
     Commands(11)=Class'AdminControlv2.ActCollision'
     Commands(12)=Class'AdminControlv2.ActRemoveAmmo'
     Commands(13)=Class'AdminControlv2.ActSlap'
     Commands(14)=Class'AdminControlv2.ActChangeName'
     Commands(15)=Class'AdminControlv2.ActPrivMessage'
     Commands(16)=Class'AdminControlv2.ActRespawn'
     Commands(17)=Class'AdminControlv2.ActHeadSize'
     Commands(18)=Class'AdminControlv2.ActPlayerSize'
     Commands(19)=Class'AdminControlv2.ActGod'
     Commands(20)=Class'AdminControlv2.ActChangeScore'
     Commands(21)=Class'AdminControlv2.ActSlomo'
     Commands(22)=Class'AdminControlv2.ActSetGravity'
     Commands(23)=Class'AdminControlv2.ActInvis'
     Commands(24)=Class'AdminControlv2.ActGhost'
     Commands(25)=Class'AdminControlv2.ActFly'
     Commands(26)=Class'AdminControlv2.ActSpider'
     Commands(27)=Class'AdminControlv2.ActWalk'
     Commands(28)=Class'AdminControlv2.ActSummon'
     Commands(29)=Class'AdminControlv2.ActTeleport'
     Commands(30)=Class'AdminControlv2.ActGiveItem'
     Commands(31)=Class'AdminControlv2.ActLoaded'
     Commands(32)=Class'AdminControlv2.ActKick'
     Commands(33)=Class'AdminControlv2.ActSetTarget'
     Commands(34)=Class'AdminControlv2.ActSilentMode'
     Commands(35)=Class'AdminControlv2.ActRestoreDoors'
     Commands(36)=Class'AdminControlv2.ActFatality'
     MSG_Help(0)="Это список доступных вам команд"
     MSG_Help(1)="Всегда ставьте слово mutate перед командой. Например: mutate killzeds"
     MSG_Help(2)="Большинство команд могут быть выполнены к другим игрокам по имени, частичному имени, а также"
     MSG_Help(3)="по игровому айди (состоит из одной-двух цифр, посмотреть игровой айди можно в меню голосования за кик)"
     MSG_Help(4)="Так же можно применять команду ко всем, кроме указанных игроков. Пример: mutate god on all!gena!jora"
     MSG_Help(5)="Можно применять команду к нескольким указанным игрокам. Пример: mutate disarm vasiya,gena,sema"
     MSG_Help(6)="команда SetTarget (или ST) выбирает цель для следующей команды"
     MSG_Help(7)="после применения SetTarget можно вызывать команду без имен игроков, и она будет применена к цели, заданной командой SetTarget"
     MSG_Help(8)="если цель команды - all команда применяется ко всем игрокам, если цель - self применяется к вам"
     MSG_Help(9)="если цель команды - target, команда применяется к игроку выбранному командой settarget"
     MSG_Help(10)="Примеры: mutate Loaded Тело, mutate kick Сенатор, mutate god on All, mutate RestoreAmmo self, mutate da 2, mutate ban target"
     MSG_Help(11)="--------------------------------------------------------------------------------"
     GroupName="KF-AdminControlV2"
     FriendlyName="Admin Control v2"
     Description="Allows to use extended admin commands and setup privileges to use this commands to admins."
     bAlwaysRelevant=True
     RemoteRole=ROLE_SimulatedProxy
}
