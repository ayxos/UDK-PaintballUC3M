class uc3mPaint_gun1 extends uc3mPaint_Weapon;
 
defaultproperties
{
    // Mesh
    Begin Object Class=SkeletalMeshComponent Name=GunMesh
        SkeletalMesh=SkeletalMesh'WP_LinkGun.Mesh.SK_WP_Linkgun_3P'
        HiddenGame=FALSE
        HiddenEditor=FALSE
        Scale=2.0
    End Object
    Mesh=GunMesh
    Components.Add(GunMesh)
 
    // Configuración del arma
    FiringStatesArray(0)=WeaponFiring       // Estado de disparo para el modo de disparo 0
    WeaponFireTypes(0)=EWFT_InstantHit      // Tipo de disparo para el modo de disparo 0
    FireInterval(0)=0.1                     // Intervalo entre disparos
    Spread(0)=0.05                          // Dispersion de los disparos
    InstantHitDamage(0)=20                  // Daño de Instant Hit
    InstantHitMomentum(0)=50000             // Inercia de Instant Hit
 
    // Beam
    BeamTemplate=particlesystem'WP_ShockRifle.Particles.P_WP_ShockRifle_Beam'
 
    // Decal
    ExplosionDecal=MaterialInstanceTimeVarying'WP_RocketLauncher.Decals.MITV_WP_RocketLauncher_Impact_Decal01'
    DecalWidth=128.0
    DecalHeight=128.0
    DurationOfDecal=24.0
    DecalDissolveParamName="DissolveAmount"

    // Tipo de postura
    //WeaponType=PWT_AimRight
 
    // Grupo de inventario
    InventoryGroup=1
}