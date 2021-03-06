class ActHeadSize extends AdminCommand
	abstract;
	
static function Perform(string CommandString, AdminRecord Sender)
{
	local string Targ;
	local float newHeadSize;
	local array<Controller>	Targets;
	local string Answer;
	
	Targ = GetStringParam(CommandString);
	newHeadSize = GetFloatParam(CommandString);
	
	Targets = SelectTargets(Sender,Targ);
	
	while ( Targets.Length > 0 )
	{
		Targets[0].Pawn.HeadScale = newHeadSize;
		Targets[0].Pawn.PlayTeleportEffect(true, true);
		Targets.Remove(0,1);
	}
	
	Answer = Sender.Controller.PlayerReplicationInfo.PlayerName $ " has changed head size of " $ GetTargetsNames(Sender,Targ) $ ".";
	CommandMessage(Sender,Answer);
}

defaultproperties
{
     Index=17
     HelpString(0)="HeadSize player size - Change the size of the player's head (1 = default). Alias - HS"
     CommandName(0)="HeadSize"
     CommandName(1)="HS"
}
