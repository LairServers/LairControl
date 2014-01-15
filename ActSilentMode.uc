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
     HelpString(0)="silentmode on/off - выключить/включить оповещение игроков о выполнении команд"
     CommandName(0)="silentmode"
}
