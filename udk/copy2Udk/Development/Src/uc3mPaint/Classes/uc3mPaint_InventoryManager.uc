class uc3mPaint_InventoryManager extends InventoryManager;
 
// Devuelve el primer arma que se encuente que coincida con el grupo de inventario
function uc3mPaint_Weapon GetWeaponByGroup(byte InventoryGroup)
{
    local uc3mPaint_Weapon Weap;
 
    ForEach InventoryActors(class'uc3mPaint_Weapon', Weap)
    {
        if(Weap.InventoryGroup == InventoryGroup)
        {
            return Weap;
        }
    }
    return none;
}
 
// Cambia de arma. Llamado desde uc3mPaint_Pawn
simulated function SwitchWeapon(byte NewGroup)
{
    local uc3mPaint_Weapon NewWeapon;
 
    NewWeapon = GetWeaponByGroup(NewGroup);
 
    if(NewGroup == 10)   // Sin armas (el 10 es el grupo de la tecla 0)
    {
        SetCurrentWeapon(None);         // Sin arma
        uc3mPaint_Pawn(Instigator).SetDefaultWeaponType(); // Postura por defecto sin arma
        return;
    }
 
    NewWeapon = GetWeaponByGroup(NewGroup);
 
    if(NewWeapon != none)
    {
        SetCurrentWeapon(NewWeapon);
    }
}
 
defaultproperties
{
    // Se añade una entrada al array PendingFire del InventoryManager por cada tipo de disparo
    PendingFire(0)=0
    PendingFire(1)=0
}