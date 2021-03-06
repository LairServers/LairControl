class ActAnchor extends AdminCommand
	abstract;
	
static function Perform(string CommandString, AdminRecord Sender)
{
	local string Targ1,Targ2;
	local string Answer;
	local array<Controller> Targets1,Targets2;
	local int i,n;
	
	
	Targ1 = GetStringParam(CommandString);
	Targ2 = GetStringParam(CommandString);

	if ( Targ2 == "" || Targ2 == "all" )
	{
		Targ2 = "self";
	}
	
	Targets1 = SelectTargets(Sender,Targ1);
	Targets2 = SelectTargets(Sender,Targ2);
	
	n = Targets1.Length;
	
	for(i=0; i<n; i++)
	{
		Targets1[i].Pawn.SetLocation(Targets2[0].Pawn.Location + VRand() * 120);
	}
	
	Answer = Sender.Controller.PlayerReplicationInfo.PlayerName $ " has anchored " $ GetTargetsNames(Sender,Targ1) $ " to " $ Targets2[0].PlayerReplicationInfo.PlayerName $ ".";
	CommandMessage(Sender,Answer);
}

defaultproperties
{
     Index=7
     HelpString(0)="anchor player1 player2 - Teleport player1 to player2."
     CommandName(0)="anchor"
}
