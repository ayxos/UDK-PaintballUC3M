class uc3mPaint_1p_Paintgun extends UTWeapon;

simulated function PlayFireEffects( byte FireModeNum, optional vector HitLocation )
{
    if (FireModeNum>1)
    {
        Super.PlayFireEffects(0,HitLocation);
    }
    else
    {
        Super.PlayFireEffects(FireModeNum, HitLocation);
    }
}

simulated function AttachWeaponTo(SkeletalMeshComponent MeshCpnt, optional name SocketName)
{
    Super(UTWeapon).AttachWeaponTo(MeshCpnt, SocketName);
}


defaultproperties
{
    // Weapon SkeletalMesh
    Begin Object class=AnimNodeSequence Name=MeshSequenceA
        bCauseActorAnimEnd=true
    End Object

    // Weapon SkeletalMesh
    Begin Object Name=FirstPersonMesh
        SkeletalMesh=SkeletalMesh'PaintBall.Mesh.PaintBall_1p'
        //Rotation=(Roll=16300)
        scale=0.8
        //FOV=60.0
    End Object

    AttachmentClass=class'uc3mPaint_1p_Attachment'

    WeaponFireSnd[0]=SoundCue'PaintBall.Sound.PaintBall_Shoot_Cue'
    MaxDesireability=0.65
    AmmoCount=1000
    LockerAmmoCount=1000
    MaxAmmoCount=1000
        MuzzleFlashSocket=MF
    MuzzleFlashPSCTemplate=ParticleSystem'VH_Manta.Effects.PS_Manta_Gun_MuzzleFlash'
        MuzzleFlashColor=(R=200,G=0,B=0,A=255)
    MuzzleFlashDuration=0.25
    MuzzleFlashLightClass=class'uc3mPaint_1p_MuzzleFlash'
    CrossHairCoordinates=(U=256,V=0,UL=64,VL=64)
    LockerRotation=(Pitch=32768,Roll=16384)
        IconCoordinates=(U=728,V=382,UL=162,VL=45)

    FiringStatesArray(0)=WeaponFiring
    WeaponFireTypes(0)=EWFT_Projectile
    WeaponProjectiles(0)=class'uc3mPaint_1p_Projectile'
    FireInterval(0)=0.1

    InventoryGroup=11
    GroupWeight=0.5

    IconX=400
    IconY=129
    IconWidth=22
    IconHeight=48

    Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformShooting1
        Samples(0)=(LeftAmplitude=90,RightAmplitude=40,LeftFunction=WF_Constant,RightFunction=WF_LinearDecreasing,Duration=0.1200)
    End Object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
}