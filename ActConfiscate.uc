class ActConfiscate extends AdminCommand
	abstract;
	
static function Perform(string CommandString, AdminRecord Sender)
{
	local string Targ1,Targ2;
	local int sum,confsum;
	local array<Controller> Targets1,Targets2;
	local string Answer;
	local int i,n;
	local float Diff;
	
	Targ1 = GetStringParam(CommandString);
	Targ2 = GetStringParam(CommandString);
	sum = GetIntParam(CommandString);
	
	if ( Targ2 == "" )
	{
		Targ2 = "all";
	}
	
	Targets1 = SelectTargets(Sender,Targ1);
	Targets2 = SelectTargets(Sender,Targ2,true);
	
	n = Targets1.Length;
	
	if ( sum == 0 )
	{
		for(i=0; i<n; i++)
		{
			confsum += Targets1[i].PlayerReplicationInfo.Score;
			Targets1[i].PlayerReplicationInfo.Score = 0;
		}
	}
	else
	{
		for(i=0; i<n; i++)
		{
			confsum += Targets1[i].PlayerReplicationInfo.Score;
		}
		
		Diff = float(sum) / float(confsum);
		
		if ( Diff > 1.00 || sum == 0 )
		{
			for(i=0; i<n; i++)
			{
				Targets1[i].PlayerReplicationInfo.Score = 0;
			}
		}
		else
		{
			for(i=0; i<n; i++)
			{
				Targets1[i].PlayerReplicationInfo.Score = Targets1[i].PlayerReplicationInfo.Score * (1.00 - Diff);
			}
		}
	}
	
	n = Targets2.Length;
	
	if ( n <= 0 )
	{
		return;
	}
	
	confsum /= n;
	
	for(i=0; i<n; i++)
	{
		Targets2[i].PlayerReplicationInfo.Score += confsum;
	}
	
	Answer = Sender.Controller.PlayerReplicationInfo.PlayerName $ " confiscated " $ GetTargetsNames(Sender,Targ1) $ "'s money and has given it to " $ GetTargetsNames(Sender,Targ2) $ ".";
	CommandMessage(Sender,Answer);
}

defaultproperties
{
     Index=4
     HelpString(0)="confiscate player1 player2 sum - Gives sum money from player1 to player2. Alias - CONF."
     CommandName(0)="confiscate"
     CommandName(1)="CONF"
}
