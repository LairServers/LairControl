class ActFly extends AdminCommand
	abstract;
	
static function Perform(string CommandString, AdminRecord Sender)
{
	local string Targ;
	local array<Controller>	Targets;
	local string Answer;

	Targ = GetStringParam(CommandString);
	
	Targets = SelectTargets(Sender,Targ);
	
	while ( Targets.Length > 0 )
	{
		Targets[0].Pawn.bAmbientCreature=false;
		Targets[0].Pawn.UnderWaterTime = Targets[0].Pawn.Default.UnderWaterTime;
		Targets[0].Pawn.SetCollision(true, true , true);
		Targets[0].Pawn.bCollideWorld = true;
		Targets[0].GotoState('PlayerFlying');
       	Targets[0].Pawn.PlayTeleportEffect(true, true);
		
		Targets.Remove(0,1);
	}

	Answer = Sender.Controller.PlayerReplicationInfo.PlayerName $ " turned on fly to " $ GetTargetsNames(Sender,Targ) $ ".";
	CommandMessage(Sender,Answer);
}

defaultproperties
{
     Index=25
     HelpString(0)="fly player - Turns fly on player."
     CommandName(0)="fly"
}
