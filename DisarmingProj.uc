class DisarmingProj extends FlameTendril;

var() KFHumanPawn StuckTo;



simulated function PostBeginPlay();

simulated singular function HitWall(vector HitNormal, actor Wall)
{
	Destroy();
}

simulated function Landed( vector HitNormal )
{
	Destroy();
}

simulated function Explode(vector HitLocation,vector HitNormal)
{
	Destroy();
}

simulated function ProcessTouch (Actor Other, vector HitLocation);

simulated function Destroyed();

function Timer()
{
	local KFPlayerReplicationInfo KFPRI;
	local Inventory I;

	if (StuckTo != None)
	{
/*
		if (StuckTo.Health <= 0)
			Destroy();
*/
			
		if (ROLE == ROLE_Authority)
		{
			StuckTo.maxcarryweight = 1.0;
			if ( lifespan <= 1.0 )
			{
				StuckTo.MaxCarryWeight = StuckTo.Default.MaxCarryWeight;
				KFPRI = KFPlayerReplicationInfo(StuckTo.PlayerReplicationInfo);
				if ( KFPRI != none && KFPRI.ClientVeteranSkill != none )
				{
					StuckTo.MaxCarryWeight += KFPRI.ClientVeteranSkill.Static.AddCarryMaxWeight(KFPRI);
				}
				StuckTo.CreateInventoryVeterancy(StuckTo.RequiredEquipment[0], 0);
				StuckTo.CreateInventoryVeterancy(StuckTo.RequiredEquipment[1], 1);
				StuckTo.CreateInventoryVeterancy(StuckTo.RequiredEquipment[2], 0);
				StuckTo.CreateInventoryVeterancy(StuckTo.RequiredEquipment[3], 0);
				StuckTo.CreateInventoryVeterancy(StuckTo.RequiredEquipment[4], 0);
				for(I=StuckTo.Inventory; I != none; I=I.Inventory)
					if ( Frag(I) != none )
						Frag(I).ConsumeAmmo(0,10000,true);
			}
		
		}
	}
}

simulated function Stick(actor HitActor, vector HitLocation)
{
	local name NearestBone;
	local float dist;

	StuckTo=KFHumanPawn(HitActor);
	
	SetPhysics(PHYS_None);

	NearestBone = GetClosestBone(HitLocation, HitLocation, dist , 'CHR_Spine2' , 15 );
	HitActor.AttachToBone(self,NearestBone);
	
	SetTimer(0.5,true);
}

simulated function DestroyTrail()
{
	if ( Trail != none )
	{
		Trail.mRegen=False;
		Trail.SetPhysics(PHYS_None);
	}

	if ( FlameTrail != none )
	{
		FlameTrail.Kill();
		FlameTrail.SetPhysics(PHYS_None);
	}
}

defaultproperties
{
     Speed=1.000000
     MaxSpeed=1.000000
     Damage=15.000000
     DamageRadius=1.000000
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'KF_pickups2_Trip.Supers.MP7_Dart'
     LifeSpan=16.000000
     DrawScale=0.010000
}
