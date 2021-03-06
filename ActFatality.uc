class ActFatality extends AdminCommand
	abstract;
	
static function Perform(string CommandString, AdminRecord Sender)
{
	local string Targ;
	local array<Controller> Targets;
	local string Answer;
	
	Targ = GetStringParam(CommandString);
	
	Targets = SelectTargets(Sender,Targ);
	
	while ( Targets.Length > 0 )
	{
		Targets[0].Pawn.Controller.bGodMode = false;
        Targets[0].Pawn.TakeDamage(100000,Sender.Controller.Pawn,Vect(0,0,0),Vect(0,0,0),class'Fell');
		
		Targets.Remove(0,1);
	}

	Answer = Sender.Controller.PlayerReplicationInfo.PlayerName $ " turned " $ GetTargetsNames(Sender,Targ) $ " into ashes.";
	CommandMessage(Sender,Answer);
}

defaultproperties
{
     HelpString(0)="fatality player - Kills player."
     CommandName(0)="fatality"
}
