class ActSpider extends AdminCommand
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
		Targets[0].Pawn.JumpZ = 0.0;
		xPawn(Targets[0].Pawn).bflaming = true;
		Targets[0].GotoState('PlayerSpidering');
        Targets[0].Pawn.PlayTeleportEffect(true, true);
		
		Targets.Remove(0,1);
	}

	Answer = Sender.Controller.PlayerReplicationInfo.PlayerName $ " turned on spider to " $ GetTargetsNames(Sender,Targ) $ ".";
	CommandMessage(Sender,Answer);
}

defaultproperties
{
     Index=26
     HelpString(0)="spider player - Allow player to walk on walls."
     CommandName(0)="Spider"
}
