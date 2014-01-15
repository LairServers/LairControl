class ActAbortWave extends AdminCommand
	abstract;
	
static function Perform(string CommandString, AdminRecord Sender)
{
	local string Answer;
	local KFGameType KFGT;
	
	KFGT = KFGameType(Sender.Level.Game);
	
	if ( KFGT.bWaveInProgress )
	{
		KFGT.KillZeds();
		KFGT.NumMonsters = 0;
		KFGT.TotalMaxMonsters = 0;
	}
	
	Answer = Sender.Controller.PlayerReplicationInfo.PlayerName $ " has aborted current wave.";
	CommandMessage(Sender,Answer);
}

defaultproperties
{
     Index=5
     HelpString(0)="abortwave - завершает текущую волну. действует только во время волны. сокращение - ABORT"
     CommandName(0)="abortwave"
     CommandName(1)="abort"
}
