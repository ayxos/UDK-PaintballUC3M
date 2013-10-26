class uc3mPaint_1p_SeqAct_SpawnEnemies extends SeqAct_Latent;
 
var uc3mPaint_1p_EnemySpawner uc3mPaint_1p_EnemySpawner;
var () int NumEnemies;                      // Número de enemigos a generar
var () float TimeInterval;                  // Intervalo de tiempo entre enemigos
var() bool bLastOfWave<autocomment=true>;    // Indica que es el último generador de la ola
 
event Activated()
{
    // Generación de enemigos
    uc3mPaint_1p_EnemySpawner.Spawnuc3mPaint_1p_Enemies(NumEnemies, TimeInterval);
    OutputLinks[0].bHasImpulse = true;  // Se activa la salida Out inmediatamente
}
 
event bool Update(float deltaTime)
{
    if(uc3mPaint_1p_EnemySpawner.HasEnemiesLeft())
    {
        return true;
    }
    else
    {
        // Si no quedan enemigos por generar se activa la salida Finished
        OutputLinks[1].bHasImpulse = true;
        // Si este es el último de la ola, se informa a PFMGame
        if(bLastOfWave && uc3mPaint_1p_Game(GetWorldInfo().Game) != none)
        {
            uc3mPaint_1p_Game(GetWorldInfo().Game).FinishWave();
        }
        return false;
    }
}
 
defaultproperties
{
    ObjName="Spawn Enemies"
    ObjCategory="uc3mPaint_1p"
    bSuppressAutoComment=false
 
    NumEnemies=0
    TimeInterval=0.5
    bLastOfWave=false
 
    VariableLinks.Empty
    VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="PFMEnemySpawner",PropertyName=PFMEnemySpawner,bWriteable=true)
    VariableLinks(1)=(ExpectedType=class'SeqVar_Int',LinkDesc="NumEnemies",PropertyName=NumEnemies,bWriteable=true)
    VariableLinks(2)=(ExpectedType=class'SeqVar_Float',LinkDesc="TimeInterval",PropertyName=TimeInterval,bWriteable=true)
 
    OutputLinks(0)=(LinkDesc="Out")
    OutputLinks(1)=(LinkDesc="Finished")
    bAutoActivateOutputLinks=false
}