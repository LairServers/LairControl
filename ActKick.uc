class ActKick extends AdminCommand
	abstract;
	
static function Perform(string CommandString, AdminRecord Sender)
{
	local string Targ;
	local array<Controller> Targets;
	
	Targ = GetStringParam(CommandString);
	Targets = SelectTargets(Sender,Targ);
	
	while ( Targets.Length > 0 )
	{
		Sender.Level.Game.AccessControl.KickPlayer(PlayerController(Targets[0]));
		Targets.Remove(0,1);
	}
}

defaultproperties
{
     Index=0
     HelpString(0)="kick player - Kick player for remaining session."
     CommandName(0)="kick"
}
