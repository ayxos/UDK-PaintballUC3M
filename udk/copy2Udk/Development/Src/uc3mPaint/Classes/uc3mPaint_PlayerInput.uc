class uc3mPaint_PlayerInput extends UDKPlayerInput;
 
var PrivateWrite IntPoint MousePosition;
var bool bInMenu;
 
// Capturamos las coordenadas del ratón sólo cuando estamos en menú
event PlayerInput(float DeltaTime)
{
    if(myHUD != none && bInMenu)
    {
        MousePosition.X = Clamp(MousePosition.X + aMouseX, 0, myHUD.SizeX);
        MousePosition.Y = Clamp(MousePosition.Y - aMouseY, 0, myHUD.SizeY);
    }
 
    Super.PlayerInput(DeltaTime);
}
 
// Función usada para resetear la posición del ratón
function ResetMousePosition(int X, int Y)
{
    MousePosition.X = X;
    MousePosition.Y = Y;
}
 
// Sobreescrita para evitar que se salga de la pausa al saltar
exec function Jump()
{
    if(WorldInfo.Pauser == None)
    {
        bPressedJump = true;
    }
}