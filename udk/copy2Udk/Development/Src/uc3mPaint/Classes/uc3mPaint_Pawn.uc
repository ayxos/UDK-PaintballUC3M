class uc3mPaint_Pawn extends UDKPawn;

/* Iluminación de entorno */
var DynamicLightEnvironmentComponent LightEnvironment;

// Posturas para disparo y aiming:
enum PawnWeaponType
{
    PWT_Default,
    PWT_AimRight
};
 
var PawnWeaponType WeaponType;      // Postura actual


 

 
/******************************************************************************
Propiedades de Camara
******************************************************************************/
var vector DesiredCamStartLocation; // Posición deseada desde la que se hace el offset (Posición del Pawn)
var vector DesiredCamOffset;        // Offset deseado de la cámara
var float DesiredCamScale;          // CameraScale deseado
var float DesiredCamZOffset;        // Offset en z de la cámara (añadido al offset de cámara)
 
var vector CurrentCamStartLocation; // Posición actual desde la que se hace el offset
var vector CurrentCamOffset;        // Offset actual interpolado de la cámara
var float CurrentCamScale;          // Se usa para interpolar entre distintos CameraScales
var float CurrentCamZOffset;        // Usado para interpolar el offset en z de la cámara
 
var vector CamOffsetDefault;    // Offset de postura Default
var vector CamOffsetAimRight;   // Offset de postura AimRight
 
var float CameraInterpolationSpeed;     //Velocidad de interpolación

 
// Sobreescribe una función para que se vea al pawn por defecto
// La llama la Camara cuando este actor se convierte en su ViewTarget
simulated event BecomeViewTarget( PlayerController PC )
{
    //local UTPlayerController UTPC;
 
    // Por defecto esta llamada pone los brazos al Pawn y el arma inicial (y otras cosas)
    Super.BecomeViewTarget(PC);
 
   /* if (LocalPlayer(PC.Player) != None)
    {
        UTPC = UTPlayerController(PC);
        if (UTPC != None)
        {
            // Activa la vista trasera (Poner la camara en tercera persona y hace desaparecer brazos y armas de primera persona
            UTPC.SetBehindView(true);
            // Esto no es necesario
            //SetMeshVisibility(UTPC.bBehindView);
        }
    }
    */
}
 
// Función que calcula la posición de la cámara
// Es un ripoff de la función CalcThirdPersonCam de UTPawn, quitando los casos de DebugCam o cuado se gana la partida
simulated function bool CalcCamera( float fDeltaTime, out vector out_CamLoc,
out rotator out_CamRot, out float out_FOV )
{
    local vector HitLocation, HitNormal, CamDirX, CamDirY, CamDirZ;
 
    // Valores deseados:
    DesiredCamStartLocation = Location;  // El punto inicial de la cámara es la posición del Pawn

    DesiredCamOffset = CamOffsetDefault;

    DesiredCamZOffset = (Health > 0) ? 1.0 * GetCollisionHeight() + Mesh.Translation.Z : 0.f;
 
    // Valores interpolados:
    CurrentCamStartLocation = VLerp(CurrentCamStartLocation, DesiredCamStartLocation, CameraInterpolationSpeed*fDeltaTime);
    CurrentCamOffset = VLerp(CurrentCamOffset, DesiredCamOffset, CameraInterpolationSpeed*fDeltaTime);
    CurrentCamScale = Lerp(CurrentCamScale, DesiredCamScale, CameraInterpolationSpeed*fDeltaTime);
    CurrentCamZOffset = Lerp(CurrentCamZOffset, DesiredCamZOffset, CameraInterpolationSpeed*fDeltaTime);
 
    if ( Health <= 0 )
    {
        CurrentCamOffset = vect(0,0,0);
        CurrentCamOffset.X = GetCollisionRadius();
    }
 
    // Se extraen los ejes de la rotación de la cámara
    GetAxes(out_CamRot, CamDirX, CamDirY, CamDirZ);
    // Escala de la camara (zoom)
    CamDirX *= CurrentCamScale;
 
    if ( (Health <= 0) || bFeigningDeath )
    {
        // adjust camera position to make sure it's not clipping into world
        // @todo fixmesteve.  Note that you can still get clipping if FindSpot fails (happens rarely)
        FindSpot(GetCollisionExtent(),CurrentCamStartLocation);
    }
 
    // Cálculo de la posición final de la cámara
    out_CamLoc = (CurrentCamStartLocation + vect(0.0,0.0,1.0) * CurrentCamZOffset) - CamDirX*CurrentCamOffset.X + CurrentCamOffset.Y*CamDirY + CurrentCamOffset.Z*CamDirZ;
 
    // Se traza un rayo para calcular posibles colisiones con la geometría
    if (Trace(HitLocation, HitNormal, out_CamLoc, CurrentCamStartLocation, false, vect(12,12,12)) != None)
    {
        out_CamLoc = HitLocation;
    }
 
    return true;
}

// Sobreescribe la funcion de Pawn
function AddDefaultInventory()
{
    // Se le da al Pawn el arma al comenzar
    InvManager.CreateInventory(class'uc3mPaint.uc3mPaint_Paintgun'); // No activar por defecto
    InvManager.CreateInventory(class'uc3mPaint.uc3mPaint_gun1', true);
}
 
// Cambio de arma, llamado desde uc3mPaint_PlayerController
simulated function SwitchWeapon(byte NewGroup)
{
    if (uc3mPaint_InventoryManager(InvManager) != None)
    {
        // Se le indica al Manager del Inventario que cambie de arma
        uc3mPaint_InventoryManager(InvManager).SwitchWeapon(NewGroup);
    }
}

// Cambia el tipo de Weapon, cambiando así la postura
function SetWeaponType(PawnWeaponType NewWeaponType)
{
    WeaponType = NewWeaponType;
}
 
// Cambia al arma por defecto
function SetDefaultWeaponType()
{
    SetWeaponType(PWT_Default);
}
 
defaultproperties
{
    // Iluminación de entorno del Pawn
    Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
        bSynthesizeSHLight=false
        bIsCharacterLightEnvironment=false
        bUseBooleanEnvironmentShadowing=FALSE
        InvisibleUpdateTime=1
        MinTimeBetweenFullUpdates=.2
    End Object
    Components.Add(MyLightEnvironment)
    LightEnvironment=MyLightEnvironment
 
    // Componente SkeletalMesh para el robot
    Begin Object Class=SkeletalMeshComponent Name=SkeletalMeshComponentRobot
		SkeletalMesh=SkeletalMesh'StormTrooper.estudianteMEN'
        //AnimSets(0)=AnimSet'CH_AnimHuman.Anims.K_AnimHuman_BaseMale'
        //AnimTreeTemplate=AnimTree'CH_AnimHuman_Tree.AT_CH_Human'
        //SkeletalMesh=SkeletalMesh'StormTrooper.StormTrooper'
        AnimSets(0)=AnimSet'StormTrooper.AnimSet.Storm_amimset'
        AnimTreeTemplate=AnimTree'StormTrooper.AnimTree.Storm_tree'
			
        LightEnvironment=MyLightEnvironment
        bEnableSoftBodySimulation=True
        bSoftBodyAwakeOnStartup=True
        bAcceptsLights=True
    End Object
    Mesh=SkeletalMeshComponentRobot
    Components.Add(SkeletalMeshComponentRobot)
 
    // Se hace más pequeño el cilindro de colisión
    Begin Object Name=CollisionCylinder
        CollisionRadius=+0021.000000
        CollisionHeight=+0044.000000
    End Object
    CylinderComponent=CollisionCylinder
 
    //El robot es un poco grande
    DrawScale=0.6

    //Para que use nuestro inventoryManager
    InventoryManagerClass=class'uc3mPaint.uc3mPaint_InventoryManager'
 
    // Propiedades de cámara
    DesiredCamScale=20.0
    CurrentCamScale=0.0
     
    CameraInterpolationSpeed=12.0              //Velocidad de interpolación de la cámara
     
    CamOffsetDefault=(X=4.0,Y=0.0,Z=-13.0)     // Offset postura default
    CamOffsetAimRight=(X=4.0,Y=40.0,Z=-13.0)    // Offset postura RightAim
    
 
    //Locomoción
    JumpZ=+0700.000000
    MaxFallSpeed=+1200.0        //Máxima velocidad al caer sin hacerse daño
    AirControl=+0.1             //Control aéreo
    CustomGravityScaling=1.3    //Multiplicador de gravedad personal
}