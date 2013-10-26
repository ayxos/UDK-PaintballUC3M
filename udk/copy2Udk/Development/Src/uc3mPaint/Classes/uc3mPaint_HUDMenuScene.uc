class uc3mPaint_HUDMenuScene extends Object;
 
var uc3mPaint_HUD myHUD;       // Referencia al HUD
 
var array<uc3mPaint_HUDButton> Buttons;    // Array de botones del menú
 
function init(uc3mPaint_HUD uc3mPaint_HUD)
{
    myHUD = uc3mPaint_HUD;
}
 
// Pinta el menú
function Draw (Canvas Canvas, IntPoint MousePosition, bool bMousePressed, bool bMouseReleased)
{
    local int i, clickedButtonId;
    local float RatioX;
    local float RatioY;
 
    clickedButtonId = -1;   // Inicialmente a -1 => no corresponde a ningún botón
 
    // Se calcula el ratio para mantener la proporción al dibujar el menú
    RatioX = Canvas.ClipX / 1280;
    RatioY = Canvas.ClipY / 720;
 
    //Botones
    for(i=0; i<Buttons.Length; i++)
    {
        if(Buttons[i] != none)
        {
            if(Buttons[i].CheckHoverAndClick(Canvas,RatioX,RatioY,MousePosition,bMousePressed,bMouseReleased))
            {
                clickedButtonId = i;
            }
            Buttons[i].Draw(Canvas,RatioX,RatioY);
        }
    }
 
    // Si se ha clicado un botón
    if(clickedButtonId != -1)
    {
        // Se ejecuta la función asociada
        RunButtonFunction(clickedButtonId);
    }
}
 
// Ejecuta una función según el índice de botón
function RunButtonFunction(int id);
 
defaultproperties
{}