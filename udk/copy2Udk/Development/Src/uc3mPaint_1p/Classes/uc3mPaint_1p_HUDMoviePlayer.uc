class uc3mPaint_1p_HUDMoviePlayer extends GFxMoviePlayer;

//Create a Health Cache variable
var float LastHealthpc;
var int LastAmmoCount;
var UTWeapon LastWeapon;

//Create variables to hold references to the Flash MovieClips and Text Fields that will be modified
var GFxObject HealthMC, HealthBarMC, HealthTF;
var GFxObject AmmoMC, AmmoBarMC, AmmoTF;
var GFxObject WeaponMC, WeaponBack;

//  Function to round a float value to an int
function int roundNum(float NumIn)
{
    local int iNum;
    local float fNum;

    fNum = NumIn;
    iNum = int(fNum);
    fNum -= iNum;
    if (fNum >= 0.5f) {
        return (iNum + 1);
    }
    else {
        return iNum;
    }
}

//  Function to return a percentage from a value and a maximum
function int getpercentage(int val, int max) 
{
    return roundNum((float(val) / float(max)) * 100.0f);
}

//Called from STHUD'd PostBeginPlay()
function Init(optional LocalPlayer PC)
{
    //Start and load the SWF Movie
    Start();
    Advance(0.f);

    //Set the cahce value so that it will get updated on the first Tick
    LastHealthpc = -201;
    LastAmmoCount = -201;
    LastWeapon = none;

    //Load the references with pointers to the movieClips and text fields in the .swf
    HealthMC = GetVariableObject("_root.Health");
    HealthBarMC = GetVariableObject("_root.Health.Bar");
    HealthTF = GetVariableObject("_root.Health.Value");

    AmmoMC = GetVariableObject("_root.Ammo");
    AmmoBarMC = GetVariableObject("_root.Ammo.Bar");
    AmmoTF = GetVariableObject("_root.Ammo.Value");

    WeaponMC = GetVariableObject("_root.Weapon");

    super.Init(PC);
}

//Called every update Tick
function TickHUD()
{
    local UTPawn UTP;

    //We need to talk to the Pawn, so create a reference and check the Pawn exists
    UTP = UTPawn(GetPC().Pawn);
    if (UTP == None) {
        return;
    }

    //If the cached value for Health percentage isn't equal to the current...
    if (LastHealthpc != getpercentage(UTP.Health, UTP.HealthMax)) 
    {
        //...Make it so...
        LastHealthpc = getpercentage(UTP.Health, UTP.HealthMax);
        //...Update the bar's xscale (but don't let it go over 100)...
        HealthBarMC.SetFloat("_xscale", (LastHealthpc > 100) ? 100.0f : LastHealthpc);
        //...and update the text field
        HealthTF.SetString("text", roundNum(LastHealthpc)$"%");
    }

    if (LastAmmoCount != UTWeapon(UTP.Weapon).AmmoCount) 
    {
        //...Make it so...
        LastAmmoCount = UTWeapon(UTP.Weapon).AmmoCount;

        AmmoTF.SetString("text", string(LastAmmoCount));
        AmmoBarMC.GotoAndstopI( (LastAmmoCount > 10) ? 10 : LastAmmoCount );
    }

    if (LastWeapon != UTWeapon(UTP.Weapon))
    {
        LastWeapon = UTWeapon(UTP.Weapon);
        switch(LastWeapon.InventoryGroup)
        {
            case 1:
                WeaponMC.GotoAndstopI(1);
                break;
            case 8:
                WeaponMC.GotoAndstopI(2);
                break;
            default:
                WeaponMC.GotoAndstopI(3);
                break;

        }
    }
}

DefaultProperties
{
    //this is the HUD. If the HUD is off, then this should be off
    bDisplayWithHudOff=false
    //The path to the swf asset we will create later
    MovieInfo=SwfMovie'PFC.custom_hud'
    //Just put it in...
    //bGammaCorrection = false
}