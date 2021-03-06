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
	
	P.GiveWeapon("ScrnBalanceSrv.MP7MPickup"); 
	P.GiveWeapon("ScrnBalanceSrv.ScrnMP5MPickup");
	P.GiveWeapon("ScrnBalanceSrv.ScrnKrissMPickup");
	P.GiveWeapon("ScrnBalanceSrv.ScrnM7A3MPickup");	
	P.GiveWeapon("ScrnBalanceSrv.ScrnM79MPickup");	
	P.GiveWeapon("ScrnBalanceSrv.ScrnM4203MPickup");	
	P.GiveWeapon("KFMod.BlowerThrowerPickup");	
	P.GiveWeapon("ScrnBalanceSrv.ScrnShotgunPickup");	
	P.GiveWeapon("ScrnBalanceSrv.ScrnBoomStickPickup");
	P.GiveWeapon("ScrnBalanceSrv.ScrnNailGunPickup");
	P.GiveWeapon("ScrnBalanceSrv.ScrnKSGPickup");
	P.GiveWeapon("ScrnBalanceSrv.ScrnBenelliPickup");
	P.GiveWeapon("ScrnBalanceSrv.ScrnAA12Pickup");
	P.GiveWeapon("KFMod.SPShotgunPickup");
	P.GiveWeapon("ScrnBalanceSrv.ScrnSinglePickup");
	P.GiveWeapon("ScrnBalanceSrv.ScrnMagnum44Pickup");
	P.GiveWeapon("ScrnBalanceSrv.ScrnMK23Pickup");
	P.GiveWeapon("ScrnBalanceSrv.ScrnDeaglePickup");
	P.GiveWeapon("ScrnBalanceSrv.ScrnWinchesterPickup");
	P.GiveWeapon("KFMod.CrossbowPickup");
	P.GiveWeapon("ScrnBalanceSrv.ScrnSPSniperPickup");
	P.GiveWeapon("ScrnBalanceSrv.ScrnM14EBRPickup");
	P.GiveWeapon("ScrnBalanceSrv.ScrnM99Pickup");
	P.GiveWeapon("ScrnBalanceSrv.ScrnBullpupPickup");
	P.GiveWeapon("ScrnBalanceSrv.ScrnAK47Pickup");	
	P.GiveWeapon("KFMod.MKb42Pickup");	
	P.GiveWeapon("ScrnBalanceSrv.ScrnM4Pickup");	
	P.GiveWeapon("ScrnBalanceSrv.ScrnSPThompsonPickup");	
	P.GiveWeapon("ScrnBalanceSrv.ScrnThompsonDrumPickup");
	P.GiveWeapon("ScrnBalanceSrv.ScrnSCARMK17Pickup");
	P.GiveWeapon("ScrnBalanceSrv.ScrnFNFAL_ACOG_Pickup");
	P.GiveWeapon("ScrnBalanceSrv.ScrnMachetePickup");
	P.GiveWeapon("ScrnBalanceSrv.ScrnAxePickup");
	P.GiveWeapon("KFMod.DwarfAxePickup");
	P.GiveWeapon("ScrnBalanceSrv.ScrnChainsawPickup");
	P.GiveWeapon("ScrnBalanceSrv.ScrnKatanaPickup");
	P.GiveWeapon("ScrnBalanceSrv.ScrnScythePickup");
	P.GiveWeapon("ScrnBalanceSrv.ScrnClaymoreSwordPickup");
	P.GiveWeapon("ScrnBalanceSrv.ScrnCrossbuzzsawPickup");
	P.GiveWeapon("ScrnBalanceSrv.ScrnMAC10Pickup");
	P.GiveWeapon("ScrnBalanceSrv.ScrnThompsonIncPickup");
	P.GiveWeapon("ScrnBalanceSrv.ScrnFlareRevolverPickup");
	P.GiveWeapon("ScrnBalanceSrv.ScrnFlameThrowerPickup");
	P.GiveWeapon("ScrnBalanceSrv.ScrnTrenchgunPickup");
	P.GiveWeapon("ScrnBalanceSrv.ScrnM79IncPickup");
	P.GiveWeapon("ScrnBalanceSrv.ScrnHuskGunPickup");
	P.GiveWeapon("");
	P.GiveWeapon("");
	P.GiveWeapon("");
	
	
}

defaultproperties
{
     Index=31
     HelpString(0)="Loaded player - Gives entire trader inventory to player."
     CommandName(0)="loaded"
}
