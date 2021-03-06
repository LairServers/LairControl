class ActRespawn extends AdminCommand
	abstract;
	
static function Perform(string CommandString, AdminRecord Sender)
{
	local string Targ1,Targ2;
	local array<Controller>	Targets1,Targets2;
	local string Answer;
	
	Targ1 = GetStringParam(CommandString);
	Targ2 = GetStringParam(CommandString);
	
	if ( Targ2 ~= "all" )
	{
		Targ2 = "self";
	}
	
	Targets1 = SelectTargets(Sender,Targ1);
	Targets2 = SelectTargets(Sender,Targ2);
	
	while ( Targets1.Length > 0 )
	{
		ReSpawnRoutine(PlayerController(Targets1[0]),Targets2[0]);

		Targets1.Remove(0,1);
	}
	
	Answer = Sender.Controller.PlayerReplicationInfo.PlayerName $ " has respawned" $ GetTargetsNames(Sender,Targ1) $ " around " $ GetTargetsNames(Sender,Targ2) $ ".";
	CommandMessage(Sender,Answer);
}

static function ReSpawnRoutine(PlayerController C, Controller Savior)
{
	local vector SpawnLoc;

	if (C.PlayerReplicationInfo != None && !C.PlayerReplicationInfo.bOnlySpectator && C.PlayerReplicationInfo.bOutOfLives)
	{
		C.Level.Game.Disable('Timer');
		C.PlayerReplicationInfo.bOutOfLives = false;
		C.PlayerReplicationInfo.NumLives = 0;
		C.PlayerReplicationInfo.Score = Max(KFGameType(C.Level.Game).MinRespawnCash, int(C.PlayerReplicationInfo.Score));
		C.GotoState('PlayerWaiting');
		C.SetViewTarget(C);
		C.ClientSetBehindView(false);
		C.bBehindView = False;
		C.ClientSetViewTarget(C.Pawn);
		Invasion(C.Level.Game).bWaveInProgress = false;
		C.ServerReStartPlayer();
		Invasion(C.Level.Game).bWaveInProgress = true;
		C.Level.Game.Enable('Timer');
		SpawnLoc = vect(0,0,0);
		SpawnLoc.X = 80 - FRand() * 160;
		SpawnLoc.Y = 80 - FRand() * 160;
		SpawnLoc = SpawnLoc + Savior.Pawn.Location;
		SpawnLoc.Z += 20;
		C.Pawn.SetLocation(SpawnLoc);
	}
}

defaultproperties
{
     Index=16
     HelpString(0)="respawn target savior - Respawn player at savior position."
     CommandName(0)="respawn"
}
