class ActSlap extends AdminCommand
	abstract;
	
static function Perform(string CommandString, AdminRecord Sender)
{
	local string Targ;
	local array<Controller> Targets;
	local string Answer;
	
	Targ = GetStringParam(CommandString);
	
	Targets = SelectTargets(Sender,Targ);
	
	Answer = Sender.Controller.PlayerReplicationInfo.PlayerName $ " PimpSlaps " $ GetTargetsNames(Sender,Targ) $ " like a bitch!";
	
	while ( Targets.Length > 0 )
	{
		if (Targets[0].Pawn.Health > 1)
		{
           	Targets[0].Pawn.TakeDamage(0,Targets[0].Pawn,Vect(100000,100000,100000),Vect(100000,100000,100000),class'DamageType');
           	Targets[0].Pawn.PlayTeleportEffect(true, true);
        }
		Targets.Remove(0,1);
	}

	CommandMessage(Sender,Answer);
}

defaultproperties
{
     Index=13
     HelpString(0)="Slap player - Slap player."
     CommandName(0)="Slap"
}
