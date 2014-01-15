class ActLoaded extends AdminCommand
	abstract;
	
static function Perform(string CommandString, AdminRecord Sender)
{
	local string Targ;
	local array<Controller>	Targets;
	local string Answer;
	local Inventory Inv;

	Targ = GetStringParam(CommandString);
	
	Targets = SelectTargets(Sender,Targ);
	Answer = Sender.Controller.PlayerReplicationInfo.PlayerName $ " has loaded " $ GetTargetsNames(Sender,Targ) $ ".";
	
	while ( Targets.Length > 0 )
	{
		AllWeapons(Targets[0].Pawn);
		AllAmmo(Targets[0].Pawn);
        Targets[0].Pawn.PlayTeleportEffect(true, true);
		
		For ( Inv=Targets[0].Pawn.Inventory; Inv!=None; Inv=Inv.Inventory )
		{
			if ( Weapon(Inv) != None )
			{
				Weapon(Inv).Loaded();
			}
		}
		
		Targets.Remove(0,1);
	}

	CommandMessage(Sender,Answer);
}

static function AllAmmo(Pawn P)
{
	local Inventory Inv;
	for( Inv=P.Inventory; Inv!=None; Inv=Inv.Inventory )
		if ( Weapon(Inv)!=None )
			Weapon(Inv).MaxOutAmmo();

    P.Controller.AwardAdrenaline( 999 );
}

static function AllWeapons(pawn P)
{
	if ((P == None) || (Vehicle(P) != None) )
		return;
	
	P.GiveWeapon("KFMod.Axe");
	P.GiveWeapon("KFMod.Bullpup");
	P.GiveWeapon("KFMod.Chainsaw");
	P.GiveWeapon("KFMod.Crossbow");
	P.GiveWeapon("KFMod.Deagle");
	P.GiveWeapon("KFMod.Single");
	P.GiveWeapon("KFMod.Shotgun");
	P.GiveWeapon("KFMod.Flamethrower");
	P.GiveWeapon("KFMod.Nade");
	P.GiveWeapon("KFMod.Machete");
	P.GiveWeapon("KFMod.Syringe");
	P.GiveWeapon("KFMod.Welder");
	P.GiveWeapon("KFMod.Winchester");
	P.GiveWeapon("KFMod.LAW");
	P.GiveWeapon("KFMod.Knife");
}

defaultproperties
{
     Index=31
     HelpString(0)="Loaded player - Give all weapons to player."
     CommandName(0)="loaded"
}
