class ActDisarm extends AdminCommand
	abstract;
	
static function Perform(string CommandString, AdminRecord Sender)
{
	local string Targ;
	local int Dur;
	local array<Controller> Targets;
	local string Answer;
	
	Targ = GetStringParam(CommandString);
	Dur = GetIntParam(CommandString);

	Targets = SelectTargets(Sender,Targ);

	if ( Dur <= 0 )
	{
		Dur = Sender.DisarmDuration;
	}
	
	Answer = Sender.Controller.PlayerReplicationInfo.PlayerName $ " disarmed " $ GetTargetsNames(Sender,Targ) $ " for " $ string(Dur) $ " seconds.";
	CommandMessage(Sender,Answer);

	while ( Targets.Length > 0 )
	{
		DropAllDroppable(Targets[0],Dur);
		CommandMessage(Sender,"You've been disarmed.",Targets[0]);
		Targets.Remove(0,1);
	}
}

static function DropAllDroppable(Controller Target, int Dur)
{
	local Inventory I;
	local int j;
	local DisarmingProj Proj;
	local Pawn P;
	
	P = Target.Pawn;
	
	if ( P == none )
	{
		return;
	}
	
	KFHumanPawn(P).MaxCarryWeight=1;
	for(j=0; j<20; j++)
		for ( I = P.Inventory; I != none; I = I.Inventory )
		{
			if ( KFWeapon(I) != none && !KFWeapon(I).bKFNeverThrow )
			{
				I.Velocity = P.Velocity;
				I.DropFrom(P.Location + VRand() * 1);
			}
			if ( KFWeapon(I) != none && KFWeapon(I).bKFNeverThrow )
			{
				if ( Weapon(I) == P.Weapon )
				{
					I.DetachFromPawn(P);
				}
				P.DeleteInventory(I);
			}
		}
	Proj = Target.Spawn(class'DisarmingProj');
	Proj.Stick(P,P.Location);
	Proj.lifespan = Dur + 1.0;
}

defaultproperties
{
     Index=2
     HelpString(0)="disarm player dur - Disarms player for dur seconds. Alias - DA"
     CommandName(0)="disarm"
     CommandName(1)="DA"
}
