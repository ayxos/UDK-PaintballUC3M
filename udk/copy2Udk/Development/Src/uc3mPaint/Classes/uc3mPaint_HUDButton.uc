class uc3mPaint_HUDButton extends Object dependson(Canvas);
 
var float XT;   // Posición izquierda del botón
var float YL;   // Posición en altura del botón
 
var bool centerX;   // Centrar en X
var bool centerY;   // Centrar en Y
 
var float Width;    // Ancho del botón
var float Height;   // Altura del botón
 
var Material material[3];   // Materiales para el botón (0 = normal, 1 = hover, 2 = click)
var Texture2D texture[3];   // Texturas para el botón (0 = normal, 1 = hover, 2 = click)
 
var bool bUseTextures;      //Usar texturas o materiales
 
var float U,V,UL,VL;    // Coordenadas de textura
 
var bool bHover;        // Cursor encima del botón
var bool bClick;        // Clicando sobre el botón
 
// Comprueba si el ratón está sobre el botón, devuelve true si se ha clicado sobre él
function bool CheckHoverAndClick(Canvas Canvas, float RatioX, float RatioY,IntPoint MousePosition, bool bMousePressed, bool bMouseReleased)
{
    local float OriX;
    local float OriY;
    local float FinalX;
    local float FinalY;
 
    // Coordenadas reales según el Ratio
    if(centerX)
        OriX = Canvas.ClipX * 0.5 - (Width * RatioX) * 0.5;
    else
        OriX = XT * RatioX;
    if(centerY)
        OriY = Canvas.ClipY * 0.5 - (Width * RatioY) * 0.5;
    else
        OriY = YL * RatioY;
 
    FinalX = OriX + Width * RatioX;
    FinalY = OriY + Height * RatioY;
 
    if(MousePosition.X >= OriX && MousePosition.X <= FinalX &&
        MousePosition.Y >= OriY && MousePosition.Y <= FinalY)
    {
        bHover = true;
        if(bMousePressed)
        {
            bClick = true;
        }
        if(bMouseReleased && bClick)
        {
            bClick = false;
            // Se ha soltado el ratón estando dentro => clicado
            return true;
        }
    }
    else
    {
        bHover = false;
        bClick = false;
    }
    return false;
}
 
// Pinta el botón
function Draw(Canvas Canvas, float RatioX, float RatioY)
{
    local int matId;
    local float OriX;
    local float OriY;
 
    // Coordenadas reales según el Ratio
    if(centerX)
        OriX = Canvas.ClipX * 0.5 - (Width * RatioX) * 0.5;
    else
        OriX = XT * RatioX;
    if(centerY)
        OriY = Canvas.ClipY * 0.5 - (Width * RatioY) * 0.5;
    else
        OriY = YL * RatioY;
 
    // Material
    matId = (bClick ? 2 : (bHover ? 1 : 0));
 
    Canvas.SetPos(OriX, OriY);
 
    if(bUseTextures)
    {
        Canvas.DrawTile(texture[matId], Width*RatioX, Height*RatioY, U,V,Width,Height,,true);
    }
    else
    {
        Canvas.DrawMaterialTile(material[matId], Width*RatioX, Height*RatioY, U,V,UL,VL);
    }
}

 
defaultproperties
{
    material(0)=Material'T_FX.Materials.M_FX_Blood_Splatter_03_new'
    material(1)=DecalMaterial'WP_BioRifle.Materials.Bio_Splat_Decal'
    material(2)=DecalMaterial'WP_BioRifle.Materials.Bio_Splat_Decal_001'
    XT=200
    YL=200
    Width=150
    Height=150
    U=0
    V=0
    UL=1.0
    VL=1.0
}