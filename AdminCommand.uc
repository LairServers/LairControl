//========================================
//
// Класс для обеспечения функционала админской команды
//
//========================================

class AdminCommand extends Info
	abstract;
	
var int Index;
var array<string> HelpString;
var array<string> CommandName;

static function Perform(string CommandString, AdminRecord Sender)
{
}

static function string GetStringParam(out string CommandString)
{
	local string ret;
	local int i;
	
	i = InStr(CommandString," ");

	if ( i == -1 )
	{
		ret = CommandString;
		CommandString = "";
	}
	else
	{
		ret = Left(CommandString,i);
		CommandString = Mid(CommandString,i+1);
	}
	
	return ret;
}

static function int GetIntParam(out string CommandString)
{
	local string StringParam;
	
	StringParam = GetStringParam(CommandString);
	
	if ( StringParam == "" )
	{
		return 0;
	}
	
	return int(StringParam);
}

static function float GetFloatParam(out string CommandString)
{
	local string StringParam;
	
	StringParam = GetStringParam(CommandString);
	
	if ( StringParam == "" )
	{
		return 0.00;
	}
	
	return float(StringParam);
}

static function array<Controller> SelectTargets(AdminRecord Sender, string TargetString, optional bool bNotIncludeSelf)
{
	local int i;
	local bool bNeedContinue;
	local Controller C;
	local array<Controller> Ret,Addit;
	local array<string> Targs;

	if ( ( TargetString == "" || TargetString ~= "target" ) && Sender.CurrentTarget != "" )
	{
		TargetString = Sender.CurrentTarget;
	}
	
	if ( InStr(TargetString,"all") == 0 )
	{
		if ( InStr(TargetString,"!") > -1 )
		{
			while ( true )
			{
				TargetString = Mid(TargetString,InStr(TargetString,"!")+1);
				Targs.Insert(0,1);

				if ( InStr(TargetString,"!") > -1 )
				{
					Targs[0] = Left(TargetString,InStr(TargetString,"!"));
				}
				else
				{
					Targs[0] = TargetString;
					break;
				}
			}
			
			while ( Targs.Length > 0 )
			{
				C = VerifyTarget(Sender,Targs[0]);
				
				if ( C != none )
				{
					Addit.Insert(0,1);
					Addit[0] = C;
				}
				
				Targs.Remove(0,1);
			}
		}
		
		for(C=Sender.Level.ControllerList; C!=none; C=C.NextController)
		{
			if ( PlayerController(C) != none && ( !bNotIncludeSelf || PlayerController(C) != Sender.Controller ) )
			{
				bNeedContinue = false;
				
				for(i=0; i<Addit.Length; i++)
				{
					if ( C == Addit[i] )
					{
						bNeedContinue = true;
						break;
					}
				}
				
				if ( bNeedContinue )
				{
					continue;
				}
				
				Ret.Insert(0,1);
				Ret[0] = C;
			}
		}
		
		return Ret;
	}
	
	while ( true )
	{
		Targs.Insert(0,1);
		
		if ( InStr(TargetString,",") > -1 )
		{
			Targs[0] = Left(TargetString,InStr(TargetString,","));
		}
		else
		{
			Targs[0] = TargetString;
			break;
		}
		
		TargetString = Mid(TargetString,InStr(TargetString,",")+1);
	}
	
	while ( Targs.Length > 0 )
	{
		C = VerifyTarget(Sender,Targs[0]);
			
		if ( C != none )
		{
			Ret.Insert(0,1);
			Ret[0] = C;
		}
		
		Targs.Remove(0,1);
	}

	return Ret;
}

static function string GetTargetsNames(AdminRecord Sender, string TargetString)
{
	local array<Controller> Targets;

	if ( TargetString ~= "all" )
	{
		return "all players";
	}
	
	Targets = SelectTargets(Sender, TargetString);
	
	return Targets[0].PlayerReplicationInfo.PlayerName;
}

static function Controller VerifyTarget(AdminRecord Sender, string TargetString)
{
	local Controller Ret;
	
	if ( TargetString ~= "self" )
	{
		return Sender.Controller;
	}
	
	Ret = FindPlayerByName(Sender,TargetString);
	
	if ( Ret == none )
	{
		Sender.Controller.ClientMessage(TargetString $" is not currently in the game.");
	}
	
	return Ret;
}

static function Controller FindPlayerByName(AdminRecord Sender, string TargetString)
{
	local Controller C;
   	local int namematch;
	
	if ( TargetString == "" )
	{
		return none;
	}
	
	if ( len(TargetString) <= 2 )
	{
		for( C = Sender.Level.ControllerList; C != None; C = C.nextController )
		{ 
			if( PlayerController(C) != none ) 
			{
				if ( TargetString == string(PlayerController(C).PlayerReplicationInfo.PlayerID) )
				{
					TargetString = C.PlayerReplicationInfo.PlayerName;
					return C;
				}
			}
		}
		
		return none;
	}
	
	for( C = Sender.Level.ControllerList; C != None; C = C.nextController )
	{ 
    	if( PlayerController(C) != none ) 
		{
           	namematch = InStr( Caps(C.PlayerReplicationInfo.PlayerName), Caps(TargetString)); 
            if ( namematch >= 0 )
			{ 
                return C; 
           	}
     	}
    }
	
	return none;
}

static function CommandMessage(AdminRecord Sender, string Mess, optional Controller Target)
{
	local Controller C;

	if ( Target == none )
	{
		for( C = Sender.Level.ControllerList; C != None; C = C.nextController )
		{ 
			if( PlayerController(C) != none && ( PlayerController(C) == Sender.Controller || !Sender.bSilentMode ) ) 
			{
				PlayerController(C).ClientMessage(Mess);
			}
		}
	}
	else if ( PlayerController(Target) == Sender.Controller || !Sender.bSilentMode )
	{
		PlayerController(Target).ClientMessage(Mess);
	}
}

static function HelpMessage(AdminRecord Sender)
{
	local int i,n;

	n = default.HelpString.Length;

	for(i=0; i<n; i++)
	{
		Sender.Controller.ClientMessage(default.HelpString[i]);
	}
}

defaultproperties
{
     Index=-1
}
