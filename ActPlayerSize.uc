class ActPlayerSize extends AdminCommand
	abstract;
	
static function Perform(string CommandString, AdminRecord Sender)
{
	local string Targ;
	local float newPlayerSize,oldsize;
	local array<Controller>	Targets;
	local string Answer;
	
	Targ = GetStringParam(CommandString);
	newPlayerSize = GetFloatParam(CommandString);
	
	if ( newPlayerSize == 0 || newPlayerSize > 5 )
	{
		CommandMessage(Sender,"PlayerSize Cannot be 0 or greater than 5, causes game to crash.",Sender.Controller);
		return;
	}
	
	Targets = SelectTargets(Sender,Targ);
	
	while ( Targets.Length > 0 )
	{
		oldsize = Targets[0].Pawn.DrawScale;
		
		if ((newPlayerSize < oldsize) || (oldsize == 0))
		{
			Targets[0].Pawn.SetDrawScale((Targets[0].Pawn.DrawScale * 0) + 1);
		}
		
		if ( Targets[0].Pawn != none )
		{
			Targets[0].Pawn.SetDrawScale(Targets[0].Pawn.DrawScale * newPlayerSize);
			Targets[0].Pawn.SetCollisionSize(Targets[0].Pawn.CollisionRadius * newPlayerSize, Targets[0].Pawn.CollisionHeight * newPlayerSize);
			Targets[0].Pawn.BaseEyeHeight *= newPlayerSize;
			Targets[0].Pawn.EyeHeight     *= newPlayerSize;
			Targets[0].Pawn.PlayTeleportEffect(true, true);
		}
		
		Targets.Remove(0,1);
	}
	
	Answer = Sender.Controller.PlayerReplicationInfo.PlayerName $ " has changed size of" $ GetTargetsNames(Sender,Targ) $ ".";
	CommandMessage(Sender,Answer);
}

defaultproperties
{
     Index=18
     HelpString(0)="PlayerSize player size - Change the size of the player to size (1 = default)."
     CommandName(0)="PlayerSize"
}
