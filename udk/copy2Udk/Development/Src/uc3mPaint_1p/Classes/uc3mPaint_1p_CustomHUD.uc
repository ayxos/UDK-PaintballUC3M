class uc3mPaint_1p_customHUD extends UTHUDBase;

var uc3mPaint_1p_HUDMoviePlayer HudMovie;

singular event Destroyed()
{
    if (HudMovie != none)
    {
        HudMovie.Close(true);
        HudMovie = none;
    }

    super.Destroyed();
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    HudMovie = new class'uc3mPaint_1p_HUDMoviePlayer';
    HudMovie.SetTimingMode(TM_Real);
    HudMovie.Init(LocalPlayer(PlayerOwner.Player));
}

event PostRender()
{
    HudMovie.TickHUD();
}

DefaultProperties
{
    //CursorTexture=Texture2D'PFC.xhair'
    GoldColor=(R=255,G=183,B=11,A=255)
    TextRenderInfo=(bClipText=true)
}
