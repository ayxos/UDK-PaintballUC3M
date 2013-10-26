class uc3mPaint_1p_Projectile extends UTProjectile;

defaultproperties
{
	ProjFlightTemplate=ParticleSystem'PaintBall.Effects.directpaintball'
	ProjExplosionTemplate=ParticleSystem'PaintBall.Effects.Paintsplat'
	MaxEffectDistance=7000.0

	Speed=2500
	MaxSpeed=5000
	AccelRate=3000.0

	Damage=70
	DamageRadius=0
	MomentumTransfer=0
	CheckRadius=26.0
	LifeSpan=1.0
	NetCullDistanceSquared=+144000000.0

	bCollideWorld=true
	DrawScale=3

	//ExplosionSound=SoundCue'blaster-e11.Sounds.HitWallS'
}