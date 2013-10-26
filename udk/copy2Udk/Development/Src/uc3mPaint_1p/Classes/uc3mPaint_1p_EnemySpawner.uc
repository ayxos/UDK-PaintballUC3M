class uc3mPaint_1p_EnemySpawner extends Actor
placeable;
 
// Cilindro en el que se hará el spawn de los enemigos, editable en el editor
var() editconst const CylinderComponent CylinderComponent;
 
// Enemigos que quedan por "spawnear"
var int enemiesLeft;

// Tiempo entre Spawns
var float timeInterval;
 
auto state Spawning
{
    local Vector newSpawnLocation;
 
    Begin:
    while(true)
    {
        if(enemiesLeft > 0)
        {
            // Cálculo de localización dentro del cilindro
            newSpawnLocation = calculateNewSpawnLocation();
 
            // Se intenta hacer spawn del enemigo
            if(Spawnuc3mPaint_1p_Enemy(newSpawnLocation) != none)
            {
                enemiesLeft--;
                if(uc3mPaint_1p_Game(WorldInfo.Game) != none)
                {
                    uc3mPaint_1p_Game(WorldInfo.Game).EnemyCreated();
                }
            }
        }
        Sleep(timeInterval);
    }
}

// Calcula una posición de Spawn dentro del Cilindro
function Vector calculateNewSpawnLocation()
{
    local Vector newSpawnLocation;
 
    newSpawnLocation = VRand();     //Vector unitario aleatorio
    newSpawnLocation.Z = 0;         //Se elimina la componente Z (vertical)
    Normal(newSpawnLocation);       //Se normaliza el nuevo vector
    newSpawnLocation *= CylinderComponent.CollisionRadius * FRand();  //Se le da una longitud aleatoria
    newSpawnLocation += Location;   //Se suma a la posición del spawner
 
    return newSpawnLocation;
}
 
function Pawn Spawnuc3mPaint_1p_Enemy(Vector spawnLocation)
{
    local AIController EC;
    local Pawn EP;
 
    // Spawn del EnemyPawn
    EP = spawn(class'uc3mPaint_1p_EnemyPawn',self,,spawnLocation);
    if(EP == none)
    {
        // En caso de no haber sido posible hacer el spawn
        return none;
    }
    // Spawn del EnemyController
    EC = spawn(class'uc3mPaint_1p_EnemyController');
    // El EnemyController posee al EnemyPawn
    if(EC != none && EP != none)
    {
        EC.Possess(EP,false);
    }
    return EP;
}
 
function Spawnuc3mPaint_1p_Enemies(int num, optional float newTimeInterval)
{
    enemiesLeft += num;
    timeInterval = newTimeInterval;
}

function bool HasEnemiesLeft()
{
    if(enemiesLeft > 0)
    {
        return true;
    }
    return false;
}
 
defaultproperties
{
    // Cilindro que define el area de spawn
    Begin Object Class=CylinderComponent NAME=CollisionCylinder
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
 
    enemiesLeft=0       // Número de enemigos que aparecen por defecto al inicio
    timeInterval=1      // 1 segundo por defecto
}