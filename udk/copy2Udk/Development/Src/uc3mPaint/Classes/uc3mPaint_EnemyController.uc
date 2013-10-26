class uc3mPaint_EnemyController extends AIController;
 
var Pawn playerPawn;
 
// Evento llamado cuando el Controlador posee a un Pawn
event Possess(Pawn inPawn, bool bVehicleTransition)
{
    super.Possess(inPawn, bVehicleTransition);
    // Se activa la física de movimiento
    Pawn.SetMovementPhysics();
}
 
// Estado de búsqueda
auto state Mirando
{
    // Se ha visto al jugador
    event SeePlayer(Pawn SeenPlayer)
    {
        playerPawn = SeenPlayer;
        GoToState('Persiguiendo');
    }
}
 
// Estado de persecución
state Persiguiendo
{
    Begin:
    while(true)
    {
        //Moverse hacia el jugador
        MoveToward(playerPawn, playerPawn, 100.0f,true);
    }
}
 
defaultproperties
{
}