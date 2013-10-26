class uc3mPaint_1p_PauseHUD extends UDKHUD;
 
var const Texture2D CrosshairTexture;
 
var bool bShowMenu;         // Mostrar menú
var bool bShowInGameHUD;    // Mostrar HUD ingame
 
event DrawHUD()
{
    Super.DrawHUD();
 
    // Se pinta el HUD ingame
    if(bShowInGameHUD)
    {
        if(PlayerOwner != none && PlayerOwner.Pawn != none)
        { 
            // Mirilla
            Canvas.SetPos(Canvas.ClipX * 0.5 - CrosshairTexture.SizeX/2, Canvas.ClipY * 0.5 - CrosshairTexture.SizeY/2);
            Canvas.DrawColor = WhiteColor;
            Canvas.DrawTile(CrosshairTexture, CrosshairTexture.SizeX, CrosshairTexture.SizeY, 0.0f, 0.0f, CrosshairTexture.SizeX, CrosshairTexture.SizeY,, true);
        }
    }
 
    // Menú de pausa
    if(bShowMenu)
    {
        // Fondo negro
        Canvas.SetPos(0,0);
        Canvas.SetDrawColor(10,10,10,64);
        Canvas.DrawRect(Canvas.SizeX,Canvas.SizeY);
    }
}
 
event PostRender()
{
    Super.PostRender();
}
 
// Activa/Desactiva el menú Ingame
function ToggleMenu()
{
    bShowMenu = !bShowMenu;             //Activa/Desactiva Menu
    bShowInGameHUD = !bShowMenu;        //Activa/Desactiva HUD
    uc3mPaint_1p_PlayerController(PlayerOwner).SetInMenu(bShowMenu);  //Informa a PlayerController
    //PFMPlayerInput(PlayerOwner.PlayerInput).ResetMousePosition(0,0);      //Resetea posición del ratón
}
 
// Llamada al pulsar ESC desde PFMController. Qué hacer dependerá de cada caso
function PressedESC()
{
    // De momento se activa el menu
    ToggleMenu();
}
 
defaultproperties
{
    bShowMenu=false
    bShowInGameHUD=true
 
    CrosshairTexture=Texture2D'ESperoQsi.menu.crosshair'
}