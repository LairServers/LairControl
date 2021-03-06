class ActBan extends AdminCommand
	abstract;
	
static function Perform(string CommandString, AdminRecord Sender)
{
	local string Targ;
	local array<Controller> Targets;
	
	Targ = GetStringParam(CommandString);
	Targets = SelectTargets(Sender,Targ);
	
	while ( Targets.Length > 0 )
	{
		Sender.Level.Game.AccessControl.BanPlayer(PlayerController(Targets[0]));
		Targets.Remove(0,1);
	}
}

defaultproperties
{
     Index=1
     HelpString(0)="kickban player - Ban player from server. Alias - BAN"
     CommandName(0)="ban"
     CommandName(1)="kickban"
}
