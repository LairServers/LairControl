class ActSTT extends AdminCommand
	abstract;
	
static function Perform(string CommandString, AdminRecord Sender)
{
	local int time;
	local string Answer;
	local KFGameType KFGT;
	
	time = GetIntParam(CommandString);

	KFGT = KFGameType(Sender.Level.Game);
	
	if ( !KFGT.bWaveInProgress )
	{
		KFGT.WaveCountDown = time;
	}
	
	Answer = Sender.Controller.PlayerReplicationInfo.PlayerName $ " has set trader time to " $ string(time);
	CommandMessage(Sender,Answer);
}

defaultproperties
{
     Index=8
     HelpString(0)="settradertime sec - Set remaining trader time. Alias - STT"
     CommandName(0)="SetTraderTime"
     CommandName(1)="stt"
}
