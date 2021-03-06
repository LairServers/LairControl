class ActSetTarget extends AdminCommand
	abstract;
	
static function Perform(string CommandString, AdminRecord Sender)
{
	local string Targ;
	local string Answer;
	
	Targ = GetStringParam(CommandString);
	
	Sender.CurrentTarget = Targ;
	
	Answer = "Target has been set to " $ Targ $ ".";

	CommandMessage(Sender,Answer,Sender.Controller);
}

defaultproperties
{
     HelpString(0)="settarget player - Set player as default target for following commands. Alias - ST"
     CommandName(0)="settarget"
     CommandName(1)="st"
}
