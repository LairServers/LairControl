class ActSetNextWave extends AdminCommand
	abstract;
	
static function Perform(string CommandString, AdminRecord Sender)
{
	local int Num;
	local string Answer;
	local KFGameType KFGT;
	
	num = GetIntParam(CommandString);
	KFGT = KFGameType(Sender.Level.Game);
	
	if ( !KFGT.bWaveInProgress )
	{
		KFGT.WaveNum = Num - 1;
		
	}
	
	Answer = "Admin has set next wave to " $ string(Num) $ ".";
	CommandMessage(Sender,Answer);
}

defaultproperties
{
     Index=6
     HelpString(0)="setnextwave num - Set number of next wave. Valid only during trader. Alias - NEXTW"
     CommandName(0)="setnextwave"
}
