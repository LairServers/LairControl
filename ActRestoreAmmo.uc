class ActRestoreAmmo extends AdminCommand
	abstract;
	
static function Perform(string CommandString, AdminRecord Sender)
{
	local string Targ;
	local array<Controller> Targets;
	local string Answer;
	
	Targ = GetStringParam(CommandString);
	
	Targets = SelectTargets(Sender,Targ);
	
	while ( Targets.Length > 0 )
	{
		FullAmmo(Targets[0].Pawn);
		Targets.Remove(0,1);
	}

	Answer = "Admin has restored ammo to " $ GetTargetsNames(Sender,Targ) $ ".";
	CommandMessage(Sender,Answer);
}

static function FullAmmo (Pawn P)
{
	local Inventory Inv;
	
	for( Inv=P.Inventory; Inv!=None; Inv=Inv.Inventory )
	if ( Weapon(Inv)!=None )
	{
		Weapon(Inv).MaxOutAmmo();
	}
}

defaultproperties
{
     Index=10
     HelpString(0)="restoreammo player - Restore player ammo to all weapons. Alias - RESA"
     CommandName(0)="restoreammo"
     CommandName(1)="RESA"
}
