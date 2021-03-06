class ActConfigurableSummon extends AdminCommand
	abstract;
	
static function Perform(string CommandString, AdminRecord Sender)
{
	local string ClassName,Targ;
	local int hitpoints,headhitpoints,speed,meleedamage,screamdamage,bleedoutdur;
	local array<Controller> Targets;
	local class<actor> NewClass;
	local vector SpawnLoc;
	local Actor A;
	local KFMonster Mon;
	
	ClassName = GetStringParam(CommandString);
	Targ = GetStringParam(CommandString);
	hitpoints = GetIntParam(CommandString);
	headhitpoints = GetIntParam(CommandString);
	speed = GetIntParam(CommandString);
	meleedamage = GetIntParam(CommandString);
	screamdamage = GetIntParam(CommandString);
	bleedoutdur = GetIntParam(CommandString);
	
	if ( Targ == "" )
	{
		Targ = "self";
	}
	
	Targets = SelectTargets(Sender,Targ);
	NewClass = class<actor>( DynamicLoadObject( ClassName, class'Class' ) );
	
	if( NewClass == None )
	{
		return;
	}
	
	while ( Targets.Length > 0 )
	{
		if ( Targets[0].Pawn != none )
		{
			SpawnLoc = Targets[0].Pawn.Location;
		}
		else
		{
			SpawnLoc = Targets[0].Location;
		}
		A = Targets[0].Spawn( NewClass,,,SpawnLoc + 72 * Vector(Targets[0].rotation) + vect(0,0,1) * 15 );
		if ( KFMonster(A) != none )
		{
			Mon = KFMonster(A);
			if ( HitPoints > 0 )
			{
				Mon.health = HitPoints;
				Mon.healthmax = HitPoints;
			}
			if ( HeadHitPoints > 0 )
				Mon.headhealth = HeadHitPoints;
			if ( Speed > 0 )
			{
				Mon.GroundSpeed = float(Speed);
				Mon.WaterSpeed = float(Speed);
				Mon.AirSpeed = float(Speed);
			}
			if ( MeleeDamage > 0 )
				Mon.MeleeDamage = MeleeDamage;
			if ( ScreamDamage > 0 )
				Mon.ScreamDamage = ScreamDamage;
			if ( BleedOutDur > 0 )
				Mon.BleedOutDuration = BleedOutDur;
		}
		
		Targets.Remove(0,1);
	}
}

defaultproperties
{
     Index=9
     HelpString(0)="configurablesummon classname <player> <hp> <headhp> <speed> <meleedamage> <screamdamage> <bleeldoutdur>"
     CommandName(0)="configurablesummon"
     CommandName(1)="CS"
}
