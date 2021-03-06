class ActGhost extends AdminCommand
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
		Targets[0].Pawn.bAmbientCreature=true;
		Targets[0].Pawn.UnderWaterTime = -1.0;
		Targets[0].Pawn.SetCollision(false, false, false);
		Targets[0].Pawn.bCollideWorld = false;
		Targets[0].GotoState('PlayerFlying');
       	Targets[0].Pawn.PlayTeleportEffect(true, true);
		
		Targets.Remove(0,1);
	}

	Answer = Sender.Controller.PlayerReplicationInfo.PlayerName $ " turned on ghost to " $ GetTargetsNames(Sender,Targ) $ ".";
	CommandMessage(Sender,Answer);
}

defaultproperties
{
     Index=24
     HelpString(0)="ghost player - Allows player to move through walls."
     CommandName(0)="ghost"
}
