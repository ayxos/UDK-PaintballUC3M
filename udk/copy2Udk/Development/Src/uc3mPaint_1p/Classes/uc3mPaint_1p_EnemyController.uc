class uc3mPaint_1p_EnemyController extends AIController;
 
var Actor FinalTarget;
 
var Vector NextDest;      // Siguiente punto del camino (Pathfinding)
 
// Evento llamado cuando el Controlador posee a un Pawn
event Possess(Pawn inPawn, bool bVehicleTransition)
{
    super.Possess(inPawn, bVehicleTransition);
    Pawn.SetMovementPhysics();
}
 
// Estado inicial
auto state Init
{
    local uc3mPaint_1p_EnemyTarget et;
 
Begin:
    foreach DynamicActors(class'uc3mPaint_1p_EnemyTarget', et)
    {
        FinalTarget = et;
    }
 
    if(FinalTarget != none)
    {
        // Objetivo encontrado
        GoToState('GoToFinalTarget');
    }
    else
    {
        // No se encuentra objetivo
        GoToState('Idle');
    }
}
 
state Idle
{
 
}
 
state GoToFinalTarget
{
    // Calcula el camino al objetivo
    function bool FindNavMeshPath()
    {
        // Clear cache and constraints (ignore recycling for the moment)
        NavigationHandle.PathConstraintList = none;
        NavigationHandle.PathGoalList = none;
 
        // Create constraints
        class'NavMeshPath_Toward'.static.TowardGoal( NavigationHandle, FinalTarget );
        class'NavMeshGoal_At'.static.AtActor( NavigationHandle, FinalTarget, 32 );
 
        // Find path
        return NavigationHandle.FindPath();
    }
 
Begin:
    if( NavigationHandle.ActorReachable(FinalTarget))
    {
        // Si se puede llegar directamente hacerlo:
        MoveTo(FinalTarget.Location, FinalTarget, 32);
        GoToState('AtFinalTarget');
    }
    else if (FindNavMeshPath())
    {
        NavigationHandle.SetFinalDestination(FinalTarget.Location);
 
        if(NavigationHandle.GetNextMoveLocation(NextDest, Pawn.GetCollisionRadius()*5))
        {
            // Ir al siguiente punto del camino
            MoveTo(NextDest,none,128.0);
        }
        else
        {
            // No hay punto siguiente
            MoveToward(FinalTarget);
        }
    }
    else
    {
        // No se encuentra camino posible
        MoveToward(FinalTarget);
    }
    goto 'Begin';
}
 
// Cada enemigo hará cosas diferentes
state AtFinalTarget
{
    //para AUTODESTRUIRSEEEEEEEEEE
    Begin:
    SelfDestroy();
}

//funcion SOLO PARA AUTODFESTRUCCION
function SelfDestroy()
{
    uc3mPaint_1p_EnemyPawn(Pawn).InitSelfDestroy();
}
 
// Usada por el Pawn para notificar que se ha colisionado con el Target
function NotifyTouchTarget(uc3mPaint_1p_EnemyTarget target)
{
    if(target == FinalTarget)
    {
        GoToState('AtFinalTarget');
    }
}
 
defaultproperties
{
    MaxMoveTowardPawnTargetTime=1       // Tiempo que MoveToward tarda en hacer return
}