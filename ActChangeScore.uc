class ActChangeScore extends AdminCommand
	abstract;
	
static function Perform(string CommandString, AdminRecord Sender)
{
	local string Targ;
	local int NewScore;
	local array<Controller>	Targets;
	local string Answer;
	
	Targ = GetStringParam(CommandString);
	NewScore = GetIntParam(CommandString);
	
	Targets = SelectTargets(Sender,Targ);
	Answer = GetTargetsNames(Sender,Targ);
	
	while ( Targets.Length > 0 )
	{
		Targets[0].PlayerReplicationInfo.Score = NewScore;
		Targets.Remove(0,1);
	}
	
	Answer = Sender.Controller.PlayerReplicationInfo.PlayerName $ " has changed score of " $ Answer $ " to " $ string(NewScore);
	CommandMessage(Sender,Answer);
}

defaultproperties
{
     Index=20
     HelpString(0)="ChangeScore player score - Set player total cash."
     CommandName(0)="ChangeScore"
}
