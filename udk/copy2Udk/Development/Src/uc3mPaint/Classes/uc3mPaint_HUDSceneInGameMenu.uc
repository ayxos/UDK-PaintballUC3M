class uc3mPaint_HUDSceneInGameMenu extends uc3mPaint_HUDMenuScene;
 
// Ejecuta una función según el índice de botón
function RunButtonFunction(int id)
{
    if(id == 0)
    {
        // Volver al juego
        uc3mPaint_HUDInGame(myHUD).ToggleMenu();
    }
    else if(id == 1)
    {
        // Volver al menú principal (inicio)
        myHUD.PlayerOwner.ConsoleCommand("Open Game_menu");
    }
}
 
defaultproperties
{
    Begin Object Class=uc3mPaint_HUDButton Name=But1
        texture(0)=Texture2D'ESperoQsi.menu.resume'
        texture(1)=Texture2D'ESperoQsi.menu.resume_hover'
        texture(2)=Texture2D'ESperoQsi.menu.resume_click'
        bUseTextures=true
        XT=400
        YL=200
        centerX=true
        centerY=false
        Width=256
        Height=64
        U=0
        V=0
        UL=1.0
        VL=1.0
    End Object
    Buttons(0)=But1
 
    Begin Object Class=uc3mPaint_HUDButton Name=But2
        texture(0)=Texture2D'ESperoQsi.menu.quit'
        texture(1)=Texture2D'ESperoQsi.menu.quit_hover'
        texture(2)=Texture2D'ESperoQsi.menu.quit_click'
        bUseTextures=true
        XT=400
        YL=350
        centerX=true
        centerY=false
        Width=256 
        Height=64
        U=0
        V=0
        UL=1.0
        VL=1.0
    End Object
    Buttons(1)=But2
}