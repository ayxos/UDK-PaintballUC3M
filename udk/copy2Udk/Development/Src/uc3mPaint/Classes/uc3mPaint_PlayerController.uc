class uc3mPaint_PlayerController extends UTPlayerController;

var float RotationSpeed;        // Velocidad de rotación del Pawn
var bool bTurningToFire;        // Flag que indica si el Pawn está girando sobre sí mismo para disparar
var bool bPendingStopFire;      // Flag que indica que durante el giro se dejó de pulsar el disparo.
var byte lastFireModeNum;       // Almacena el modo de disparo para aplicarlo tras el giro.
var bool bInMenu;               // Indica al controlador que se encuentra en un menú.
 
//Extiende el estado PlayerWalking, sobreescribiendo PlayerMove
state PlayerWalking
{
    ignores SeePlayer, HearNoise, Bump;
 
    function PlayerMove( float DeltaTime )
    {
        local vector            X,Y,Z, NewAccel;
        local eDoubleClickDir   DoubleClickMove;
        local rotator           OldRotation;
        local bool              bSaveJump;
 
        if( Pawn == None )
        {
            GotoState('Dead');
        }
        else
        {
            GetAxes(Pawn.Rotation,X,Y,Z);
 
            // La aceleración (y en consecuencia el movimiento) es diferente según el tipo de arma que lleve el Pawn
            if(uc3mPaint_Pawn(Pawn).WeaponType == PWT_Default)
            {
                NewAccel = Abs(PlayerInput.aForward)*X + Abs(PlayerInput.aStrafe)*X;
            }
            else
            {
                NewAccel = PlayerInput.aForward*X + PlayerInput.aStrafe*Y;
            }
 
            NewAccel.Z  = 0;
            NewAccel = Pawn.AccelRate * Normal(NewAccel);
 
            if (IsLocalPlayerController())
            {
                AdjustPlayerWalkingMoveAccel(NewAccel);
            }
 
            DoubleClickMove = PlayerInput.CheckForDoubleClickMove( DeltaTime/WorldInfo.TimeDilation );
 
            // Update rotation.
            OldRotation = Rotation;
            UpdateRotation( DeltaTime );
            bDoubleJump = false;
 
            if( bPressedJump && Pawn.CannotJumpNow() )
            {
                bSaveJump = true;
                bPressedJump = false;
            }
            else
            {
                bSaveJump = false;
            }
 
            if( Role < ROLE_Authority ) // then save this move and replicate it
            {
                ReplicateMove(DeltaTime, NewAccel, DoubleClickMove, OldRotation - Rotation);
            }
            else
            {
                ProcessMove(DeltaTime, NewAccel, DoubleClickMove, OldRotation - Rotation);
            }
            bPressedJump = bSaveJump;
        }
    }
}
 
function UpdateRotation( float DeltaTime )
{
    local Rotator DeltaRot, newRotation, ViewRotation;
    local Rotator CurrentRot;
    local vector X, Y, Z, newRotationVector;
 
    ViewRotation = Rotation;
    if (Pawn!=none)
    {
        Pawn.SetDesiredRotation(ViewRotation);
    }
 
    // Calculate Delta to be applied on ViewRotation
    DeltaRot.Yaw = PlayerInput.aTurn;
    DeltaRot.Pitch = PlayerInput.aLookUp;
 
    ProcessViewRotation( DeltaTime, ViewRotation, DeltaRot );
    SetRotation(ViewRotation);
 
    //Rotación del Pawn
    if ( Pawn != None )
    {
        // Se aplica el giro
        if (bTurningToFire || Pawn.IsFiring())  // si está disparando (o girando para disparar)
        {
            // Pawn mira a donde mira la cámara
            NewRotation = ViewRotation;
            NewRotation.Roll = Rotation.Roll;
            CurrentRot = RLerp(Pawn.Rotation, newRotation, RotationSpeed * DeltaTime, true);
            Pawn.FaceRotation(CurrentRot, deltatime);
 
            if(bTurningToFire)
            {
                CheckIfCanFire(lastFireModeNum);
            }
        }
        else if(PlayerInput.aForward != 0.0 || PlayerInput.aStrafe != 0.0)  // o en movimiento sin disparar
        {
            // Giro solidario con la cámara. Pawn mira a donde mira la cámara
            if(uc3mPaint_Pawn(Pawn).WeaponType != PWT_Default)
            {
                NewRotation = ViewRotation;
                NewRotation.Roll = Rotation.Roll;
                CurrentRot = RLerp(Pawn.Rotation, newRotation, RotationSpeed * DeltaTime, true);
            }
            else    // Giro relativo a la cámara. Pawn se gira hacia su dirección de movimiento
            {
                GetAxes(ViewRotation, X, Y, Z);
                newRotationVector = PlayerInput.aForward * X + PlayerInput.aStrafe * Y;
                newRotationVector.Z = 0;
                NewRotation = rotator(Normal(newRotationVector));
                CurrentRot = RLerp(Pawn.Rotation, NewRotation, RotationSpeed * DeltaTime, true);
            }
            Pawn.FaceRotation(CurrentRot, deltatime);
        }
    }
}
  
// Comprueba si el ángulo del Pawn es el adecuado para disparar. En caso contrario, activa el giro y recuerda el disparo pendiente.
function bool CheckIfCanFire(optional byte FireModeNum)
{
    local float cosAng;     //Coseno de ángulo
 
    // Podrá disparar si Postura es Default
    if(uc3mPaint_Pawn(Pawn).WeaponType == PWT_Default)
    {
        return true;
    }
    // Si la diferencia entre la rotación actual del Pawn y del Controller es inferior a cierto límite, puede disparar
    cosAng = Normal(vector(Rotation) * vect(1.0,1.0,0.0)) dot Normal(vector(Pawn.Rotation));
    if((1 - cosAng) < 0.01)
    {
        if(bTurningToFire)  // Si estábamos girando...
        {
            bTurningToFire=false;           // se desactiva el flag
            Pawn.StartFire(FireModeNum);    // y se inicia el disparo.
            if(bPendingStopFire)            // Si durante el giro se dejó de disparar:
            {
                Pawn.StopFire(FireModeNum); // Se detiene el disparo
                bPendingStopFire = false;   // y se desactiva el flag
            }
        }
        return true;
    }
    else    // En caso contrario se activa el giro para disparar
    {
        bTurningToFire=true;
        return false;
    }
}

// Llamada al pulsar ESC. Informa al HUD
exec function ShowMenu()
{
    uc3mPaint_HUD(myHUD).PressedESC();
}
 
// Cambios al entrar en menú. Se llamará desde el HUD
function SetInMenu(bool inMenu)
{
    SetPause(inMenu);
    bInMenu = inMenu;
}

// Copiado de PlayerController para evitar que al 'Usar' se salga de pausa
simulated function bool PerformedUseAction()
{
    if ( Pawn == None )
    {
        return true;
    }
 
    // below is only on server
    if( Role < Role_Authority )
    {
        return false;
    }
 
    //SwitchWeapon(10);
 
    // try to interact with triggers
    return TriggerInteracted();
}

exec function StartFire( optional byte FireModeNum )
{
    if(bInMenu && FireModeNum == 0)
    {
        uc3mPaint_HUD(myHUD).MousePressed();
    }
    else if ( Pawn != None && !bCinematicMode && !WorldInfo.bPlayersOnly && !IsPaused())
    {
        lastFireModeNum = FireModeNum;      // Se guarda el modo de disparo para los disparos retardados.
        if(CheckIfCanFire(FireModeNum))     // Si se puede disparar directamente:
        {
            Pawn.StartFire( FireModeNum );  // se hace.
        }
    }
}
 
exec function StopFire(optional byte FireModeNum)
{
    if(bInMenu && FireModeNum == 0)
    {
        uc3mPaint_HUD(myHUD).MouseReleased();
    }
    else
    {
        Super.StopFire(FireModeNum);
        if(bTurningToFire)              // Si se ha dejado de pulsar el botón de disparo mientras se gira,
        {
            bPendingStopFire = true;    // se activa el flag para tenerlo en cuenta.
        }
    }
}
 
defaultproperties
{
    RotationSpeed=12
    bInMenu=false   //Inicialmente no estamos en menú
    //InputClass=class'uc3mPaint.uc3mPaint_PlayerInput'
}