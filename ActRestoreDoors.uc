class ActRestoreDoors extends AdminCommand
	abstract;
	
static function Perform(string CommandString, AdminRecord Sender)
{
	local KFDoorMover KFDM;
	local string Answer;
	
	foreach Sender.Controller.AllActors(class'KFDoorMover', KFDM)
	{
		KFDM.RespawnDoor();
	}
	
}

defaultproperties
{
     HelpString(0)="restoredoors - восстанавливает все двери на карте. сокращение - RD"
     CommandName(0)="restoredoors"
     CommandName(1)="rd"
}
