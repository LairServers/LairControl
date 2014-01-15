class ActChangeName extends AdminCommand
	abstract;
	
static function Perform(string CommandString, AdminRecord Sender)
{
	local string Targ,NewName;
	local array<Controller> Targets;
	local string Answer;
	
	Targ = GetStringParam(CommandString);
	NewName = GetStringParam(CommandString);
	
	Targets = SelectTargets(Sender,Targ);
	Answer = "Admin changed name of " $ GetTargetsNames(Sender,Targ) $ " to " $ NewName;
	
	while ( Targets.Length > 0 )
	{
		Targets[0].PlayerReplicationInfo.PlayerName = NewName;
		Targets.Remove(0,1);
	}

	CommandMessage(Sender,Answer);
}

defaultproperties
{
     Index=14
     HelpString(0)="ChangeName player new_name - Изменить имя игрока player на new_name. сокращение - CN"
     CommandName(0)="ChangeName"
     CommandName(1)="CN"
}
