class ActGod extends AdminCommand
	abstract;
	
static function Perform(string CommandString, AdminRecord Sender)
{
	local string Targ,spec;
	local array<Controller>	Targets;
	local string Answer;
	local bool bGodOn;
	
	Spec = GetStringParam(CommandString);
	Targ = GetStringParam(CommandString);
	
	Targets = SelectTargets(Sender,Targ);
	
	if ( Spec ~= "on" )
	{
		bGodon = true;
	}
	else if ( Spec ~= "off" )
	{
		bGodon = false;
	}
	else
	{
		return;
	}
	
	while ( Targets.Length > 0 )
	{
		Targets[0].bGodMode = bGodOn;
		Targets[0].Pawn.PlayTeleportEffect(true, true);
		Targets.Remove(0,1);
	}
	
	Answer = Sender.Controller.PlayerReplicationInfo.PlayerName $ " has turned godmode " $ Spec $ " to " $ GetTargetsNames(Sender,Targ) $ ".";
	CommandMessage(Sender,Answer);
}

defaultproperties
{
     Index=19
     HelpString(0)="god on player / god off player - Enable/disable invulnerability on player."
     CommandName(0)="god"
}
