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
     HelpString(0)="killzeds - убивает всех мобов на карте. сокращение - KZ"
     CommandName(0)="killzeds"
     CommandName(1)="KZ"
}
