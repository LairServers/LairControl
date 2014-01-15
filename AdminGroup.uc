class AdminGroup extends Object
	PerObjectConfig
	Config(AdminControlv2);
	
var string ConfigFile;

var config array<string> Allow;

static function array<string> GetNames()
{
	return GetPerObjectNames(default.ConfigFile);
}

defaultproperties
{
     ConfigFile="AdminControlv2"
}
