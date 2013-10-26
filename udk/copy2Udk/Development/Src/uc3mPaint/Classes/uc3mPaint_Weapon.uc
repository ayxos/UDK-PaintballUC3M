class uc3mPaint_Weapon extends UDKWeapon;
 
var byte InventoryGroup;        // Grupo de inventario. Se usa para cambiar de arma
 
// ****************************************************************
// Instant HIT
// ****************************************************************
var ParticleSystem BeamTemplate;    // Sistema de partículas del rayo mostrado en Instant Hit
 
var MaterialInterface ExplosionDecal;       // Decal (calcomanía) que deja en las superficies el Instant Hit
var float DecalWidth, DecalHeight;          // Ancho y altura del decal
var float DurationOfDecal;                  // Duración del decal antes de desaparecer
var name DecalDissolveParamName;            // Nombre del parámetro del MaterialInstance para disolver el material
 
var PawnWeaponType WeaponType;  // Tipo de arma para cambiar la postura de apuntado


// Determina la posición real del arma
simulated event SetPosition(UDKPawn Holder)
{
    local SkeletalMeshComponent compo;
    local SkeletalMeshSocket socket;
    local Vector FinalLocation;
 
    compo = Holder.Mesh;
 
    if (compo != none)
    {
        socket = compo.GetSocketByName('Mano');
        if (socket != none)
        {
            FinalLocation = compo.GetBoneLocation(socket.BoneName);
        }
    }
    SetLocation(FinalLocation);
}
 
// Calcula la posición real desde donde se disparan los proyectiles
simulated event vector GetPhysicalFireStartLoc(optional vector AimDir)
{
    local SkeletalMeshComponent compo;
    local SkeletalMeshSocket socket;
 
    compo = Instigator.Mesh;
 
    if (compo != none)
    {
        socket = compo.GetSocketByName('Mano');
        if (socket != none)
        {
             return compo.GetBoneLocation(socket.BoneName);
        }
    }
}
 
// Sobreescribe la funcion de Weapon. Procesa los impactos instantaneos.
simulated function ProcessInstantHit(byte FiringMode, ImpactInfo Impact, optional int NumHits)
{
    local MaterialInstanceTimeVarying MITV_Decal;
 
    // Calcula el daño total y lo aplica al actor
    Super.ProcessInstantHit(FiringMode, Impact, NumHits);
 
    // Creación del Decal
    MITV_Decal = new(self) class'MaterialInstanceTimeVarying';
    MITV_Decal.SetParent(ExplosionDecal);
    WorldInfo.MyDecalManager.SpawnDecal(MITV_Decal, Impact.HitLocation, rotator(-Impact.HitNormal), DecalWidth, DecalHeight, 10.0, FALSE );
    MITV_Decal.SetScalarStartTime( DecalDissolveParamName, DurationOfDecal );
 
    // Generación del rayo de Instant Hit
    SpawnBeam(GetPhysicalFireStartLoc() + (FireOffset >> Instigator.GetViewRotation()), Impact.HitLocation, false);
}
 
// Se llama al equipar el arma
simulated function TimeWeaponEquipping()
{
    // Se acopla el arma al pawn
    AttachWeaponTo( Instigator.Mesh,'Mano' );
 
    // Se cambia la postura
    uc3mPaint_Pawn(Instigator).SetWeaponType(WeaponType);
 
    super.TimeWeaponEquipping();
}
 
// Acopla el arma a la malla del pawn
simulated function AttachWeaponTo( SkeletalMeshComponent MeshComp, optional Name SocketName )
{
    MeshComp.AttachComponentToSocket(Mesh,SocketName);
    // Se coge la iluminación de entorno del Pawn
    Mesh.SetLightEnvironment(uc3mPaint_Pawn(Instigator).LightEnvironment);
}
 
// Llamado al dejar de usar el arma
simulated function DetachWeapon()
{
    Instigator.Mesh.DetachComponent(Mesh);
    SetBase(None);
    SetHidden(True);
}
 
// Genera el rayo del arma. Extraído de UTAttachment_ShockRifle
simulated function SpawnBeam(vector Start, vector End, bool bFirstPerson)
{
    local ParticleSystemComponent E;
    local actor HitActor;
    local vector HitNormal, HitLocation;
 
    if (End == Vect(0,0,0))
    {
        if (!bFirstPerson || (Instigator.Controller == None))
        {
            return;
        }
        End = Start + vector(Instigator.Controller.Rotation) * class'UTWeap_ShockRifle'.default.WeaponRange;
        HitActor = Instigator.Trace(HitLocation, HitNormal, End, Start, TRUE, vect(0,0,0),, TRACEFLAG_Bullet);
        if ( HitActor != None )
        {
            End = HitLocation;
        }
    }
    E = WorldInfo.MyEmitterPool.SpawnEmitter(BeamTemplate, Start);
    E.SetVectorParameter('ShockBeamEnd', End);
    if (bFirstPerson && !class'Engine'.static.IsSplitScreen())
    {
        E.SetDepthPriorityGroup(SDPG_Foreground);
    }
    else
    {
        E.SetDepthPriorityGroup(SDPG_World);
    }
}
 
defaultproperties
{
    FireOffset=(X=50,Y=0,Z=0)
}