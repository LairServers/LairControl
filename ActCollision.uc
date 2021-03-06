class ActCollision extends AdminCommand
	abstract;
	
static function Perform(string CommandString, AdminRecord Sender)
{
	local string Targ,OffCol;
	local array<Controller> Targets;
	local string Answer;
	local bool bOnCollision;
	
	Targ = GetStringParam(CommandString);
	OffCol = GetStringParam(CommandString);
	
	Targets = SelectTargets(Sender,Targ);
	
	if ( OffCol ~= "off" )
	{
		bOnCollision = false;
	}
	else
	{
		bOnCollision = true;
	}
	
	
	
	Answer = "Admin has turned ";
	
	if ( bOnCollision )
	{
		Answer = Answer $ "on ";
	}
	else
	{
		Answer = Answer $ "off ";
	}
	
	Answer = Answer $ "collision to " $ GetTargetsNames(Sender,Targ) $ ".";
	
	while ( Targets.Length > 0 )
	{
		Targets[0].Pawn.bBlockActors = bOnCollision;
		Targets.Remove(0,1);
	}
	
	CommandMessage(Sender,Answer);
}

defaultproperties
{
     Index=11
     HelpString(0)="collision player - Turn off player collision. Alias - COL"
     HelpString(1)="collision player off - Turn player collision on."
     CommandName(0)="collision"
     CommandName(1)="COL"
}
