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
     HelpString(0)="settarget player - player becomes default target for following commands. abbreviation - ST"
     CommandName(0)="settarget"
     CommandName(1)="st"
}
