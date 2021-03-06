class ActRestoreDoors extends AdminCommand
	abstract;
	
static function Perform(string CommandString, AdminRecord Sender)
{
	local KFDoorMover KFDM;

	
	foreach Sender.Controller.AllActors(class'KFDoorMover', KFDM)
	{
		KFDM.RespawnDoor();
	}
	
}

defaultproperties
{
     HelpString(0)="restoredoors - Restores all doors on map. Alias - RD"
     CommandName(0)="restoredoors"
     CommandName(1)="rd"
}
