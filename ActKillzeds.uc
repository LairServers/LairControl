class ActKillzeds extends AdminCommand
	abstract;
	
static function Perform(string CommandString, AdminRecord Sender)
{
	local string Answer;

	KFGameType(Sender.Level.Game).KillZeds();
	Answer = "Admin killed zeds.";
	CommandMessage(Sender,Answer);
}

defaultproperties
{
     Index=3
     HelpString(0)="killzeds - Kills all specimen currently on map. Alias - KZ"
     CommandName(0)="killzeds"
     CommandName(1)="KZ"
}
