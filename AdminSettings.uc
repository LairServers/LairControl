class AdminSettings extends Object
	PerObjectConfig
	Config(LairControlV1);
	
var string ConfigFile;
	
var config string AdminID,AdminName;
var config string AdminGroup;

static function array<string> GetNames()
{
	return GetPerObjectNames(default.ConfigFile);
}

defaultproperties
{
     ConfigFile="LairControlV1"
}
