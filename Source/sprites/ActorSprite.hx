package sprites;

import org.flixel.FlxG;
import org.flixel.FlxPoint;
import org.flixel.FlxSprite;
import org.flixel.FlxObject;
import data.Registry;
import data.Library;
import world.Actor;
import utils.Direction;


class ActorSprite extends FlxSprite {
	public var owner:Actor;
	public var direction:Direction;
	public var directionIndicator:IndicatorSprite;
	public var explosionEmitter:EmitterSprite;
	
	var weaponSprite(getWeaponSprite, null):WeaponSprite;

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
		
		// fixme - move to weapon factory
		if (owner.weapon != null) {
			weaponSprite.makePixelBullet(20);
			weaponSprite.setBulletOffset(Math.round(width/2)-1, Math.round(height/2)-1);
			
			// fixme - calculate from dext
			weaponSprite.setFireRate(300);
			
			// fixme - calculate from range
			weaponSprite.setBulletLifeSpan(500);
		}
		
		explosionEmitter = new EmitterSprite(0xFFFFFF);
	}
	
	function getWeaponSprite():WeaponSprite {
		return owner.weapon.sprite;
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
		weaponSprite.setBulletDirection(WeaponSprite.BULLET_RIGHT, Math.round(Registry.bulletSpeed+velocity.x));
	}
	
	function faceLeft() {
		facing = FlxObject.LEFT;
		direction = W;
		weaponSprite.setBulletDirection(WeaponSprite.BULLET_LEFT, Math.round(Registry.bulletSpeed-velocity.x));
	}
	
	function faceDown()	{
		direction = S;
		weaponSprite.setBulletDirection(WeaponSprite.BULLET_DOWN, Math.round(Registry.bulletSpeed+velocity.y));
	}
	
	function faceUp() {
		direction = N;
		weaponSprite.setBulletDirection(WeaponSprite.BULLET_UP, Math.round(Registry.bulletSpeed-velocity.y));
	}
}