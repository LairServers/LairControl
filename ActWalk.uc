class ActWalk extends AdminCommand
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
		Targets[0].Pawn.SetPhysics(PHYS_Walking);
		Targets[0].Pawn.bCollideWorld = true;
		Targets[0].Pawn.bCanJump = true;
		Targets[0].GotoState('PlayerWalking');
		
		Targets.Remove(0,1);
	}

	Answer = Sender.Controller.PlayerReplicationInfo.PlayerName $ " turned on walk mode to " $ GetTargetsNames(Sender,Targ) $ ".";
	CommandMessage(Sender,Answer);
}

defaultproperties
{
     Index=27
     HelpString(0)="walk player - Return player to walking mode."
     CommandName(0)="Walk"
}
