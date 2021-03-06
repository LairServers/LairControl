class ActSummon extends AdminCommand
	abstract;
	
static function Perform(string CommandString, AdminRecord Sender)
{
	local string Targ,ClassName;
	local array<Controller>	Targets;
	local class<actor> NewClass;
	local vector SpawnLoc;

	ClassName = GetStringParam(CommandString);
	Targ = GetStringParam(CommandString);
	
	NewClass = class<actor>( DynamicLoadObject( ClassName, class'Class' ) );
	Targets = SelectTargets(Sender,Targ);
	
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
		
		Targets[0].Spawn( NewClass,,,SpawnLoc + 72 * Vector(Targets[0].rotation) + vect(0,0,1) * 15 );
		
		Targets.Remove(0,1);
	}
}

defaultproperties
{
     Index=28
     HelpString(0)="summon class player - Summon class at player location."
     CommandName(0)="summon"
}
