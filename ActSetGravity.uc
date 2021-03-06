class ActSetGravity extends AdminCommand
	abstract;
	
static function Perform(string CommandString, AdminRecord Sender)
{
	local float NewGravity;
	local string Answer;

	NewGravity = GetFloatParam(CommandString);
	
	Sender.Controller.PhysicsVolume.Gravity.Z = NewGravity;

	Answer = Sender.Controller.PlayerReplicationInfo.PlayerName $ " has set gravity to " $ string(NewGravity) $ ".";
	CommandMessage(Sender,"Use 'SetGrav -950' to return to normal",Sender.Controller);
	CommandMessage(Sender,Answer);
}

defaultproperties
{
     Index=22
     HelpString(0)="SetGravity gravity - Change gravity (-950 = default)."
     CommandName(0)="SetGravity"
}
