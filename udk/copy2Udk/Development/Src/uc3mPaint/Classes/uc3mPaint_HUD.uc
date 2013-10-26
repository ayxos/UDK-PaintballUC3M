class uc3mPaint_HUD extends UTHUD;
 
var const Texture2D CursorTexture;
 
var bool bShowMenu;         // Mostrar menú
 
var bool bMousePressed;     // Ratón pulsado
var bool bMouseReleased;    // Ratón soltado
 
 
var uc3mPaint_HUDMenuScene menu;
 
event DrawHUD()
{
    local uc3mPaint_PlayerInput uc3mPaint_PlayerInput;
 
    Super.DrawHUD();
 
    // Menú
    if(bShowMenu)
    {
        if(PlayerOwner != none)
        {
            uc3mPaint_PlayerInput = uc3mPaint_PlayerInput(PlayerOwner.PlayerInput);
            if(uc3mPaint_PlayerInput == none)
            {
                return;
            }
        }
 
        // Fondo negro
        Canvas.SetPos(0,0);
        Canvas.SetDrawColor(10,10,10,64);
        Canvas.DrawRect(Canvas.SizeX,Canvas.SizeY);
 
        Canvas.DrawColor = WhiteColor;
 
        // Menú
        if(menu == none)
        {
            InitMenu();
        }
        else
        {
            menu.Draw(Canvas,uc3mPaint_PlayerInput.MousePosition, bMousePressed, bMouseReleased);
            // Una vez dibujado el menú y procesado el ratón, se ponen los flags a falso
            bMousePressed = false;
            bMouseReleased = false;
        }
 
        // Cursor
        Canvas.SetPos(uc3mPaint_PlayerInput.MousePosition.X, uc3mPaint_PlayerInput.MousePosition.Y);
        Canvas.DrawColor = WhiteColor;
        Canvas.DrawTile(CursorTexture, CursorTexture.SizeX, CursorTexture.SizeY, 0.f, 0.f, CursorTexture.SizeX, CursorTexture.SizeY,, true);
    }
}
 
event PostRender()
{
    Super.PostRender();
}
 
function InitMenu()
{
    menu = new class'uc3mPaint_HUDMenuScene';
    menu.init(self);
    uc3mPaint_PlayerInput(PlayerOwner.PlayerInput).ResetMousePosition(Canvas.ClipX/2,Canvas.ClipY/2);      //Resetea posición del ratón
}
 
// Llamada al pulsar ESC desde uc3mPaint_Controller. Qué hacer dependerá de cada caso
function PressedESC()
{}
 
// Llamada desde uc3mPaint_PlayerController
function MousePressed()
{
    bMousePressed = true;
}
 
// Llamada desde uc3mPaint_PlayerController
function MouseReleased()
{
    bMouseReleased = true;
}
 
defaultproperties
{
    bShowMenu=false
    CursorTexture=Texture2D'EngineResources.Cursors.Arrow'
}