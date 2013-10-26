//class uc3mPaint_Game extends UTDeathMatch;
class uc3mPaint_1p_Game extends UDKGame;


var uc3mPaint_EnemySpawner enemySpawner;
var int TotalEnemiesAlive;  // Número total de enemigos que hay vivos
var bool bInWaveGeneration; // Determina si estamos generando enemigos de la ola

 
simulated function PostBeginPlay()
{
    local uc3mPaint_EnemySpawner ES;
 
    super.PostBeginPlay();
 
    //Se busca el enemySpawner
    foreach DynamicActors(class'uc3mPaint_EnemySpawner',ES)
        enemySpawner = ES;
}

function EnemyKilled()
{
    TotalEnemiesAlive--;
 
    // Fin de la ronda
    if(TotalEnemiesAlive <= 0 && !bInWaveGeneration)
    {
        TriggerGlobalEventClass(class'uc3mPaint_1p_SeqEvent_waveComplete', self);
    }
}
 
function EnemyCreated()
{
    TotalEnemiesAlive++;
    bInWaveGeneration = true;      // Si se crean enemigos se activa
}
 
// LLamado desde la acción de generación de enemigos cuando se genera el último enemigo
function FinishWave()
{
    bInWaveGeneration = false;  // La ola se ha generado
}
 
exec function SpawnEnemies(int num)
{
    enemySpawner.Spawnuc3mPaint_Enemies(num);
}
 
exec function SpawnEnemy()
{
    enemySpawner.Spawnuc3mPaint_Enemies(1);
}

defaultproperties
{
    TotalEnemiesAlive=0;
    //acronym = "UC3M1"
    //Se especifica el Pawn por defecto
    DefaultPawnClass=class'uc3mPaint_1p.uc3mPaint_1p_Pawn'
    //Se especifica el controlador
    PlayerControllerClass=class'uc3mPaint_1p.uc3mPaint_1p_PlayerController'
    //DefaultInventory(1)=class'uc3mPaint_1p.uc3mPaint_1p_Paintgun'

    //definemy own custom HUD
    HUDType=class'uc3mPaint_1p.uc3mPaint_1p_CustomHUD'

    //to tell UDK that we re not going to use default HUD (only if you heritage FROM UTGAME!!!!!)
    //bUseClassicHUD=true

    bDelayedStart=false;
    bRestartLevel=false;
    Name="Default__uc3mPaint_1p"
}


/*
function StartMatch()
{
    super(UTGame).StartMatch();
    `log("HUD testing");
}

static event class<GameInfo> SetGameType(string MapName, string Options, string Portal)
{
    return default.class;
}
*/