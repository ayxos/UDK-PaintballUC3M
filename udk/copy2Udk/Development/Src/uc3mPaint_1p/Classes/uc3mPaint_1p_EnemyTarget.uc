class uc3mPaint_1p_EnemyTarget extends Actor
placeable;
 
// Cilindro que abarca toda la zona objetivo
var() editconst const CylinderComponent CylinderComponent;

defaultproperties
{
    // Cilindro que define la zona objetivo
    Begin Object Class=CylinderComponent NAME=CollisionCylinder
        CollideActors=true
        CollisionRadius=+0200.000000
        CollisionHeight=+0040.000000
        bAlwaysRenderIfSelected=true
    End Object
    CollisionComponent=CollisionCylinder
    CylinderComponent=CollisionCylinder
    Components.Add(CollisionCylinder)
 
    /* Sprite para verlo en el editor
    Begin Object Name=Sprite
        Sprite=Texture2D'EditorResources.LookTarget'
        HiddenGame=False
    End Object
    Components.Add(Sprite)
    */

    bCollideActors=true
 
}