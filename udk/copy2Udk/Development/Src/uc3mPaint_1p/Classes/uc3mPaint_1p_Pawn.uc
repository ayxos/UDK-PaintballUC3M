class uc3mPaint_1p_Pawn extends UTPawn;

/* Iluminación de entorno */

 
/******************************************************************************
Propiedades de Cámara
******************************************************************************/

 
// Sobreescribe una función para que se vea al pawn por defecto
// La llama la Camara cuando este actor se convierte en su ViewTarget
simulated event BecomeViewTarget( PlayerController PC )
{
    //local UTPlayerController UTPC;
 
    // Por defecto esta llamada pone los brazos al Pawn y el arma inicial (y otras cosas)
    Super.BecomeViewTarget(PC);
 
    /*if (LocalPlayer(PC.Player) != None)
    {
        UTPC = UTPlayerController(PC);
        if (UTPC != None)
        {
            // Activa la vista trasera (Poner la camara en tercera persona y hace desaparecer brazos y armas de primera persona
            //UTPC.SetBehindView(true);
            // Esto no es necesario
            //SetMeshVisibility(UTPC.bBehindView);
        }
    }*/
}


defaultproperties
{
    // Iluminación de entorno del Pawn
 
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
    //DrawScale=0.6

    //Para que use nuestro inventoryManager
    //InventoryManagerClass=class'uc3mPaint.uc3mPaint_InventoryManager'
 
    /* Propiedades de cámara
    DesiredCamScale=20.0
    CurrentCamScale=0.0
     
    CameraInterpolationSpeed=12.0              //Velocidad de interpolación de la cámara
     
    CamOffsetDefault=(X=4.0,Y=0.0,Z=-13.0)     // Offset postura default
    CamOffsetAimRight=(X=4.0,Y=40.0,Z=-13.0)    // Offset postura RightAim
    */
 
    //Locomoción
    GroundSpeed=200.0           //Velocidad máxima en suelo
    JumpZ=+0400.000000
    MaxFallSpeed=+1200.0        //Máxima velocidad al caer sin hacerse daño
    AirControl=+0.1             //Control aéreo
    CustomGravityScaling=0.8    //Multiplicador de gravedad personal
}