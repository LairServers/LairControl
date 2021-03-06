class ActSlomo extends AdminCommand
	abstract;
	
static function Perform(string CommandString, AdminRecord Sender)
{
	local float SlomoRate;
	local string Answer;

	SlomoRate = GetFloatParam(CommandString);
	
	Sender.Level.Game.SetGameSpeed(SlomoRate);

	Answer = Sender.Controller.PlayerReplicationInfo.PlayerName $ " has set game speed to " $ string(SlomoRate) $ ".";
	CommandMessage(Sender,"Use 'Slomo 1' to return to normal",Sender.Controller);
	CommandMessage(Sender,Answer);
}

defaultproperties
{
     Index=21
     HelpString(0)="slomo speed - Change speed of game to speed."
     CommandName(0)="slomo"
}
