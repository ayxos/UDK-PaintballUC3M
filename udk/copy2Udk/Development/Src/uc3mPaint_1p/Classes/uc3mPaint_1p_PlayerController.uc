class uc3mPaint_1p_PlayerController extends UTPlayerController;

var bool bInMenu;

exec function ShowMenu()
{
    uc3mPaint_1p_PauseHUD(myHUD).PressedESC();
}
 
// Cambios al entrar en menú. Se llamará desde el HUD
function SetInMenu(bool inMenu)
{
    SetPause(inMenu);
    bInMenu = inMenu;
}
// Copiado de PlayerController para evitar que al 'Usar' se salga de pausa
simulated function bool PerformedUseAction()
{
    if ( Pawn == None )
    {
        return true;
    }
 
    // below is only on server
    if( Role < Role_Authority )
    {
        return false;
    }
 
    //SwitchWeapon(10);
 
    // try to interact with triggers
    return TriggerInteracted();
}
// Añadida funcionalidad para girar antes de disparar
exec function StartFire( optional byte FireModeNum )
{
    if ( Pawn != None && !bCinematicMode && !WorldInfo.bPlayersOnly && !IsPaused())
    {
		Pawn.StartFire( FireModeNum );  // se hace.
    }
}
 
exec function StopFire(optional byte FireModeNum)
{
    Super.StopFire(FireModeNum);
}

defaultproperties
{
	bInMenu=false
	bForcebehindView=false;
	Name="Default__uc3mPaint_1p_PlayerController"
}