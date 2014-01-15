class ActSilentMode extends AdminCommand
	abstract;
	
static function Perform(string CommandString, AdminRecord Sender)
{
	local string Spec;
	local string Answer;
	
	Spec = GetStringParam(CommandString);
	
	if ( Spec ~= "on" )
	{
		Sender.bSilentMode = true;
	}
	else if ( Spec ~= "off" )
	{
		Sender.bSilentMode = false;
	}
	else
	{
		return;
	}
	
	Answer = "Silent mode " $ Spec $ ".";

	CommandMessage(Sender,Answer,Sender.Controller);
}

defaultproperties
{
     HelpString(0)="silentmode on / off - Turn on/off player alerts of admin commands."
     CommandName(0)="silentmode"
}
