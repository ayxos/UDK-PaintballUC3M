class uc3mPaint_EnemySpawner extends Actor
placeable;
 
// Cilindro en el que se hará el spawn de los enemigos, editable en el editor
var() editconst const CylinderComponent CylinderComponent;
 
// Enemigos que quedan por "spawnear"
var int enemiesLeft;
 
auto state Spawning
{
    local Vector newSpawnLocation;
 
    Begin:
    while(true)
    {
        if(enemiesLeft > 0)
        {
            // Cálculo de localización dentro del cilindro
            newSpawnLocation = VRand();     //Vector unitario aleatorio
            newSpawnLocation.Z = 0;         //Se elimina la componente Z (vertical)
            Normal(newSpawnLocation);       //Se normaliza el nuevo vector
            newSpawnLocation *= CylinderComponent.CollisionRadius * FRand();  //Se le da una longitud aleatoria
            newSpawnLocation += Location;   //Se suma a la posición del spawner
 
            // Se intenta hacer spawn del enemigo
            if(Spawnuc3mPaint_Enemy(newSpawnLocation) != none)
            {
                enemiesLeft--;
            }
        }
        Sleep(0.1);
    }
}
 
function Pawn Spawnuc3mPaint_Enemy(Vector spawnLocation)
{
    local AIController EC;
    local Pawn EP;
 
    // Spawn del EnemyPawn
    EP = spawn(class'uc3mPaint_EnemyPawn',self,,spawnLocation);
    if(EP == none)
    {
        // En caso de no haber sido posible hacer el spawn
        return none;
    }
    // Spawn del EnemyController
    EC = spawn(class'uc3mPaint_EnemyController');
    // El EnemyController posee al EnemyPawn
    if(EC != none && EP != none)
    {
        EC.Possess(EP,false);
    }
    return EP;
}
 
function Spawnuc3mPaint_Enemies(int num)
{
    enemiesLeft += num;
}
 
defaultproperties
{
    // Cilindro que define el area de spawn
    Begin Object Class=CylinderComponent Name=CollisionCylinder
        CollideActors=true
        CollisionRadius=+0040.000000
        CollisionHeight=+0040.000000
        bAlwaysRenderIfSelected=true
    End Object
    CollisionComponent=CollisionCylinder
    CylinderComponent=CollisionCylinder
    Components.Add(CollisionCylinder)
 
    // Sprite para verlo en el editor
    Begin Object Class=SpriteComponent Name=Sprite
        Sprite=Texture2D'EditorResources.S_Actor'
        HiddenGame=False
    End Object
    Components.Add(Sprite)
 
    enemiesLeft=0
}