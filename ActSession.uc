class ActSession extends AdminCommand
	abstract;
	
static function Perform(string CommandString, AdminRecord Sender)
{
	local string Targ;
	local array<Controller> Targets;
	
	Targ = GetStringParam(CommandString);
	Targets = SelectTargets(Sender,Targ);
	
	while ( Targets.Length > 0 )
	{
		Sender.Level.Game.AccessControl.BanPlayer(PlayerController(Targets[0]), true);
		Targets.Remove(0,1);
	}
}

defaultproperties
{
     HelpString(0)="session player - Ban player for current session."
     CommandName(0)="session"
}
