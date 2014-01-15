class AdminRecord extends Object;

var AdminRecord NextAdmin;

var PlayerController Controller;
var AdminGroup AdminGroup;
var string AdminID,AdminName;

CONST PrivsLength=15;
var array<byte> Privs[PrivsLength];
var array< class<AdminCommand> > Allows;

var string CurrentTarget;
var bool bSilentMode;

var LevelInfo Level;

var int DisarmDuration;

function bool AllowAction(class<AdminCommand> ActionClass)
{
	local int i,n;
	
	n = Allows.Length;

	for(i=0; i<n; i++)
	{
		if ( Allows[i] == ActionClass )
		{
			return true;
		}
	}
	
	return false;
}

function PostInit(AdminControlMut MyMut, AdminSettings InitAdm)
{
	local int i,n;
	local class<AdminCommand> CurPriv;
	
	Level = MyMut.Level;
	
	DisarmDuration = MyMut.DisarmDuration;
	
	AdminID = InitAdm.AdminID;
	AdminName = InitAdm.AdminName;
	
	/*
	for(i=0; i<PrivsLength; i++)
	{
		Privs[i] = 0;
	}
	*/
	
	n = AdminGroup.Allow.Length;
	
	for(i=0; i<n; i++)
	{
		CurPriv = class'AdminControlMut'.Static.RecognizeCommand(AdminGroup.Allow[i]);
		Allows.Insert(0,1);
		Allows[0] = CurPriv;
		/*
		if ( CurPriv != none )
		{
			Privs[CurPriv.default.Index] = 1;
		}*/
	}
}

defaultproperties
{
}
