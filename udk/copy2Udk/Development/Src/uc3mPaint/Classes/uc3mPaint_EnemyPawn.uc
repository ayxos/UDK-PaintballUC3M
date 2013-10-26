class uc3mPaint_EnemyPawn extends UDKPawn
placeable;

state Dying
{
    event BeginState(Name PreviousStateName)
    {
        Super.BeginState(PreviousStateName);
        Destroy();
    }
}
 
defaultproperties
{
    // Iluminación de entorno del Pawn
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
 
    // Cilindro de colisión
    Begin Object Name=CollisionCylinder
        CollisionRadius=50.0
        CollisionHeight=25.0
        BlockNonZeroExtent=true
        BlockZeroExtent=true
        BlockActors=true
        CollideActors=true
    End Object
    CollisionComponent=CollisionCylinder
    Components.Add(CollisionCylinder)
 
    // Se especifica el controlador
    ControllerClass=class'uc3mPaint.uc3mPaint_EnemyController'
 
    GroundSpeed=400.0           //Velocidad máxima en suelo
    bCanBeBaseForPawns=true     //Permite que se le suban encima otros pawns
}