class ActInvis extends AdminCommand
	abstract;
	
static function Perform(string CommandString, AdminRecord Sender)
{
	local string Targ,OnOff;
	local array<Controller>	Targets;
	local string Answer;
	local bool bInvis;

	OnOff = GetStringParam(CommandString);
	Targ = GetStringParam(CommandString);
	
	Targets = SelectTargets(Sender,Targ);
	
	if ( OnOff ~= "on" )
	{
		bInvis = true;
	}
	else if ( OnOff ~= "off" )
	{
		bInvis = false;
	}
	else
	{
		return;
	}
	
	while ( Targets.Length > 0 )
	{
		Targets[0].Pawn.bHidden = bInvis;
		
		Targets.Remove(0,1);
	}

	Answer = Sender.Controller.PlayerReplicationInfo.PlayerName $ " turned invis " $ OnOff $ " to " $ GetTargetsNames(Sender,Targ) $ ".";
	CommandMessage(Sender,Answer);
}

defaultproperties
{
     Index=23
     HelpString(0)="invis on player / invis off player - Enable/disable invisibility on player."
     CommandName(0)="invis"
}
