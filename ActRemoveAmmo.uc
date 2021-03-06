class ActRemoveAmmo extends AdminCommand
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
		NullAmmo(Targets[0].Pawn);
		Targets.Remove(0,1);
	}

	Answer = "Admin has removed ammo to " $ GetTargetsNames(Sender,Targ) $ ".";
	CommandMessage(Sender,Answer);
}

static function NullAmmo(Pawn P)
{
	local Inventory Inv;
	
	for( Inv=P.Inventory; Inv!=None; Inv=Inv.Inventory )
	if ( Weapon(Inv)!=None )
	{
		Weapon(Inv).ConsumeAmmo(0,10000,true);
		Weapon(Inv).ConsumeAmmo(1,10000,true);
	}
}

defaultproperties
{
     Index=12
     HelpString(0)="removeammo player - Remove all ammo from player. Alias - REMA"
     CommandName(0)="removeammo"
     CommandName(1)="REMA"
}
