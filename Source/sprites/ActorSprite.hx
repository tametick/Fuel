package sprites;

import org.flixel.FlxG;
import org.flixel.FlxPoint;
import org.flixel.FlxSprite;
import org.flixel.FlxObject;
import data.Registry;
import data.Library;
import org.flixel.plugin.photonstorm.FlxWeapon;
import world.Actor;
import utils.Direction;


class ActorSprite extends FlxSprite {
	public var owner:Actor;
	public var direction:Direction;
	public var directionIndicator:IndicatorSprite;
	public var explosionEmitter:ExplosionEmitter;

	public function new(owner:Actor, image:Images, spriteIndex:Int, ?x:Float = 0, ?y:Float = 0, ?isImmovable:Bool = false) {
		super(x, y);
		this.owner = owner;
		if (owner.type == PLAYER) {
			directionIndicator = new IndicatorSprite();
		}
		
		maxVelocity = Registry.maxVelocity;
		drag = Registry.drag;
		
		loadGraphic(Library.getImage(image), true, true, 8, 8);
		addAnimation("idle", [spriteIndex]);
		play("idle");
		
		if (isImmovable) {
			immovable = true;
		}
		
		if (owner.type == PLAYER) {
			// make the player's hitbox a bit smaller to ease navigation
			width -= Registry.playerHitboxOffset;
			centerOffsets();
			height -= Registry.playerHitboxOffset;
			offset.y += Registry.playerHitboxOffset;
			faceRight();
		}
		
		if (owner.weapon != null) {
			owner.weapon.setParent(this, "x", "y");
			owner.weapon.makePixelBullet(20);
			owner.weapon.setBulletOffset(Math.round(width/2)-1, Math.round(height/2)-1);
			
			// fixme - calculate from dext
			owner.weapon.setFireRate(300);
			
			// fixme - calculate from range
			owner.weapon.setBulletLifeSpan(500);
		}
		
		explosionEmitter = new ExplosionEmitter();
	}
	
	override public function update() {
		super.update();
		
		if (owner == Registry.player) {
			// show the attack direction
			directionIndicator.play(Type.enumConstructor(direction));
			switch (direction) {
				case N:
					directionIndicator.x = x;
					directionIndicator.y = y - Registry.tileSize - 2;
				case E:
					directionIndicator.x = x + Registry.tileSize;
					directionIndicator.y = y - 1;
				case S:
					directionIndicator.x = x;
					directionIndicator.y = y + Registry.tileSize;
				case W:
					directionIndicator.x = x - Registry.tileSize - 1;
					directionIndicator.y = y - 1;
			}
			
			
			// fixme - use tweening for full-tile movement
			if (FlxG.keys.RIGHT) {
				velocity.x += Registry.playerAcceleration;
				faceRight();
			}
			if (FlxG.keys.LEFT) {
				velocity.x -= Registry.playerAcceleration;
				faceLeft();
			}
			if (FlxG.keys.DOWN) {
				velocity.y += Registry.playerAcceleration;
				faceDown();
			}
			if (FlxG.keys.UP) {
				velocity.y -= Registry.playerAcceleration;
				faceUp();
			}
			if (FlxG.keys.SPACE) {
				owner.weapon.fire();
			}
			
		} else {
			// enemy movement
		}
	}
	
	function faceRight() {
		facing = FlxObject.RIGHT;
		direction = E;
		owner.weapon.setBulletDirection(FlxWeapon.BULLET_RIGHT, Math.round(Registry.bulletSpeed+velocity.x));
	}
	
	function faceLeft() {
		facing = FlxObject.LEFT;
		direction = W;
		owner.weapon.setBulletDirection(FlxWeapon.BULLET_LEFT, Math.round(Registry.bulletSpeed-velocity.x));
	}
	
	function faceDown()	{
		direction = S;
		owner.weapon.setBulletDirection(FlxWeapon.BULLET_DOWN, Math.round(Registry.bulletSpeed+velocity.y));
	}
	
	function faceUp() {
		direction = N;
		owner.weapon.setBulletDirection(FlxWeapon.BULLET_UP, Math.round(Registry.bulletSpeed-velocity.y));
	}
}