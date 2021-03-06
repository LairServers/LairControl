class ActTeleport extends AdminCommand
	abstract;
	
static function Perform(string CommandString, AdminRecord Sender)
{
	local actor HitActor;
	local vector HitNormal, HitLocation;
	
	HitActor = Sender.Controller.Trace(HitLocation, HitNormal, Sender.Controller.ViewTarget.Location + 10000 * vector(Sender.Controller.Rotation),Sender.Controller.ViewTarget.Location, true);
	
	if ( HitActor == None )
	{
		HitLocation = Sender.Controller.ViewTarget.Location + 10000 * vector(Sender.Controller.Rotation);
	}
	else
	{
		HitLocation = HitLocation + Sender.Controller.ViewTarget.CollisionRadius * HitNormal;
	}
	
	Sender.Controller.ViewTarget.SetLocation(HitLocation);
	Sender.Controller.ViewTarget.PlayTeleportEffect(false,true);
}

defaultproperties
{
     Index=29
     HelpString(0)="teleport - Teleport to surface in current view."
     CommandName(0)="teleport"
}
