class uc3mPaint_Paintgun extends uc3mPaint_Weapon;
 
defaultproperties
{
    // Mesh
    Begin Object Class=SkeletalMeshComponent Name=GunMesh
        SkeletalMesh=SkeletalMesh'PaintBall.Mesh.PaintBall'
        HiddenGame=FALSE
        HiddenEditor=FALSE
        Scale=0.7
    End Object
    Mesh=GunMesh
    Components.Add(GunMesh)

    // Configuración del arma
    //FiringStatesArray(0)=WeaponFiring           // Estado de disparo para el modo de disparo 0
    //WeaponFireTypes(0)=EWFT_Projectile          // Tipo de disparo para el modo de disparo 0
    //WeaponProjectiles(0)=class'UTProj_Rocket'   // Clase del proyectil
    //FireInterval(0)=0.5                         // Intervalo entre disparos
    Spread(0)=0.01                              // Dispersion de los disparos

    // Tipo de postura
    //WeaponType=PWT_AimRight
 
    // Grupo de inventario
    FiringStatesArray(0)=WeaponFiring
    WeaponFireTypes(0)=EWFT_Projectile
    WeaponProjectiles(0)=class'uc3mPaint_Projectile'
    FireInterval(0)=0.1

    InventoryGroup=2
}