class ActGiveItem extends AdminCommand
	abstract;
	
static function Perform(string CommandString, AdminRecord Sender)
{
	local string Targ,ItemName;
	local array<Controller>	Targets;
	local string Answer;
    local string ItemOnly;
    local int PeriodLoc;
	local Inventory Inv;
	
	ItemName = GetStringParam(CommandString);
	Targ = GetStringParam(CommandString);
	
	Targets = SelectTargets(Sender,Targ);
	
	PeriodLoc = Instr(ItemName, ".");
	ItemOnly = Right(ItemName, PeriodLoc);
	Answer = Sender.Controller.PlayerReplicationInfo.PlayerName $ " has given " $ ItemOnly $ " to you.";
	
	while ( Targets.Length > 0 )
	{
		Targets[0].Pawn.GiveWeapon(ItemName);
        Targets[0].Pawn.PlayTeleportEffect(true, true);
		AllAmmo(Targets[0].Pawn);
		
		For ( Inv=Targets[0].Pawn.Inventory; Inv!=None; Inv=Inv.Inventory )
		{
			if ( Weapon(Inv) != None )
			{
				Weapon(Inv).Loaded();
			}
		}
		
		CommandMessage(Sender,Answer,Targets[0]);
		
		Targets.Remove(0,1);
	}
}

static function AllAmmo(Pawn P)
{
	local Inventory Inv;
	for( Inv=P.Inventory; Inv!=None; Inv=Inv.Inventory )
		if ( Weapon(Inv)!=None )
			Weapon(Inv).MaxOutAmmo();

    P.Controller.AwardAdrenaline( 999 );
}

defaultproperties
{
     Index=30
     HelpString(0)="GiveItem weaponclass player - Gives weapon to player. Alias - GI"
     CommandName(0)="GiveItem"
     CommandName(1)="gi"
}
