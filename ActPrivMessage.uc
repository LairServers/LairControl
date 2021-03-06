class ActPrivMessage extends AdminCommand
	abstract;
	
static function Perform(string CommandString, AdminRecord Sender)
{
	local string Targ,Mess;
	local array<Controller> Targets;

	
	Targ = GetStringParam(CommandString);
	Mess = GetStringParam(CommandString);
	
	Targets = SelectTargets(Sender,Targ);
	
	Mess = "Priv message from " $ Sender.Controller.PlayerReplicationInfo.PlayerName $ ":" $ Mess;
	
	while ( Targets.Length > 0 )
	{
		CommandMessage(Sender,Mess,Targets[0]);
		Targets.Remove(0,1);
	}
}

defaultproperties
{
     Index=15
     HelpString(0)="PrivMessage player message - Sends message to player (not working). Alias - PM"
     CommandName(0)="PrivMessage"
     CommandName(1)="PM"
}
