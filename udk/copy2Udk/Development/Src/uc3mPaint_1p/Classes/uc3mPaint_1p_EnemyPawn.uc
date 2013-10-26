class uc3mPaint_1p_EnemyPawn extends UDKPawn
placeable;

// Efectos de destrucci�n
var ParticleSystem DestructionExplosion;
var SoundCue ExplosionSound;
var float DestructionDamage;    //Da�o de destrucci�n
var float DestructionDamageRadius;  //Radio del da�o de destrucci�n
var SoundCue ArmedSound;        //Sonido previo a autodestrucci�n
 
event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
    Super.Touch(Other,OtherComp,HitLocation,HitNormal);
    if(uc3mPaint_1p_EnemyTarget(Other) != None)
    {
        uc3mPaint_1p_EnemyController(Controller).NotifyTouchTarget(uc3mPaint_1p_EnemyTarget(Other));
    }
}
 
state SelfDestroy
{
    Begin:
    PlaySound(ArmedSound, true);
    Sleep(0.5);
    GoToState('Dying');
}
 
function InitSelfDestroy()
{
    GoToState('SelfDestroy');
}
 


state Dying
{
    event BeginState(Name PreviousStateName)
    {
        Super.BeginState(PreviousStateName);
    }
 
    Begin:
    // Efectos de destrucci�n
    SpawnDestructionEffects();
    // Da�o radial
    HurtRadius(DestructionDamage,DestructionDamageRadius,class'UTDmgType_Rocket',50000,Location);
    // Destrucci�n
    Destroy();
}
 
// Activa los efectos de destrucci�n
function SpawnDestructionEffects()
{
    // Particulas de explosi�n
    if(DestructionExplosion != None)
    {
        WorldInfo.MyEmitterPool.SpawnEmitter(DestructionExplosion, Location, rotator(vect(0.0,0.0,1.0)));
    }
    // Sonido de destrucci�n
    if (ExplosionSound != None)
    {
        PlaySound(ExplosionSound, true);
    }
}
 
defaultproperties
{
    // Iluminaci�n de entorno del Pawn
    Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
        bSynthesizeSHLight=TRUE
        bIsCharacterLightEnvironment=TRUE
        bUseBooleanEnvironmentShadowing=FALSE
        InvisibleUpdateTime=1
        MinTimeBetweenFullUpdates=.2
    End Object
    Components.Add(MyLightEnvironment)
 
    // SkeletalMesh
    Begin Object Class=SkeletalMeshComponent Name=EnemyMesh
        SkeletalMesh=SkeletalMesh'StormTrooper.StormTrooper'
        AnimSets(0)=AnimSet'StormTrooper.AnimSet.Storm_amimset'
        AnimTreeTemplate=AnimTree'StormTrooper.AnimTree.Storm_tree'
        LightEnvironment=MyLightEnvironment
        bEnableSoftBodySimulation=True
        bSoftBodyAwakeOnStartup=True
        bAcceptsLights=True
    End Object
    Mesh=EnemyMesh
    Components.Add(EnemyMesh)
 
    // Cilindro de colisi�n
    Begin Object Name=CollisionCylinder
        CollisionRadius=40.0
        CollisionHeight=25.0
        BlockNonZeroExtent=true
        BlockZeroExtent=true
        BlockActors=true
        CollideActors=true
    End Object
    CollisionComponent=CollisionCylinder
    Components.Add(CollisionCylinder)
 
    // Se especifica el controlador
    ControllerClass=class'uc3mPaint_1p.uc3mPaint_1p_EnemyController'
 
    // Efectos de destrucci�n
    DestructionExplosion=ParticleSystem'WP_RocketLauncher.Effects.P_WP_RocketLauncher_RocketExplosion'
    ExplosionSound=SoundCue'A_Character_BodyImpacts.BodyImpacts.A_Character_RobotImpact_BodyExplosion_Cue'
    DestructionDamage=10
    DestructionDamageRadius=60
 
    GroundSpeed=400.0           //Velocidad m�xima en suelo
    RotationRate=(Pitch=40000,Yaw=40000,Roll=40000)     // Ratio de rotaci�n
    SightRadius=+05000.000000                           // Max distancia de vista
}