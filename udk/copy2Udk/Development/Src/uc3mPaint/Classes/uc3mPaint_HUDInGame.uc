class uc3mPaint_HUDInGame extends uc3mPaint_HUD;
 
var const Texture2D CrosshairTexture;
 
var bool bShowInGameHUD;    // Mostrar HUD ingame
 
event DrawHUD()
{
    Super.DrawHUD();
 
    // Se pinta el HUD ingame
    if(bShowInGameHUD)
    {
        if(PlayerOwner != none && PlayerOwner.Pawn != none)
        {

            // Salud
            Canvas.DrawColor.B = 250;
            Canvas.Font = class'Engine'.Static.GetLargeFont();
            Canvas.SetPos(Canvas.ClipX * 0.01, Canvas.ClipY * 0.85);
            Canvas.DrawText("HEALTH:"@PlayerOwner.Pawn.Health);
 
            // Mirilla
            Canvas.SetPos(Canvas.ClipX * 0.5 - CrosshairTexture.SizeX/2, Canvas.ClipY * 0.5 - CrosshairTexture.SizeY/2);
            Canvas.DrawColor.B = 250;
            Canvas.DrawTile(CrosshairTexture, CrosshairTexture.SizeX, CrosshairTexture.SizeY, 0.0f, 0.0f, CrosshairTexture.SizeX, CrosshairTexture.SizeY,, true);
        }
    }
}
 
function InitMenu()
{
    menu = new class'uc3mPaint_HUDSceneInGameMenu';
    menu.init(self);
    uc3mPaint_PlayerInput(PlayerOwner.PlayerInput).ResetMousePosition(Canvas.ClipX/2,Canvas.ClipY/2);      //Resetea posición del ratón
}
 
// Activa/Desactiva el menú Ingame
function ToggleMenu()
{
    bShowMenu = !bShowMenu;             //Activa/Desactiva Menu
    bShowInGameHUD = !bShowMenu;        //Activa/Desactiva HUD
    uc3mPaint_PlayerController(PlayerOwner).SetInMenu(bShowMenu);  //Informa a PlayerController
    //uc3mPaint_PlayerInput(PlayerOwner.PlayerInput).ResetMousePosition(Canvas.ClipX/2,Canvas.ClipY/2);      //Resetea posición del ratón
}
 
// Llamada al pulsar ESC desde uc3mPaint_Controller. Qué hacer dependerá de cada caso
function PressedESC()
{
    // De momento se activa el menu
    ToggleMenu();
}
 
defaultproperties
{
    bShowInGameHUD=false
    CrosshairTexture=Texture2D'ESperoQsi.menu.crosshair'
}