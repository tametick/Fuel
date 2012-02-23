package sprites;

import com.eclecticdesignstudio.motion.Actuate;
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
	
	var isMoving:Bool;
	
	var weaponSprite(getWeaponSprite, null):WeaponSprite;

	public function new(owner:Actor, image:Images, spriteIndex:Int, ?x:Float = 0, ?y:Float = 0, ?isImmovable:Bool = false) {
		super(x, y);
		this.owner = owner;
		if (owner.type == PLAYER) {
			directionIndicator = new IndicatorSprite();
		}
		
		maxVelocity = Registry.maxVelocity;
		drag = Registry.drag;
		
		loadGraphic(Library.getImage(image), true, true, Registry.tileSize, Registry.tileSize);
		addAnimation("idle", [spriteIndex]);
		play("idle");
		
		if (isImmovable) {
			immovable = true;
		}
		
		if (owner.type == PLAYER) {
			faceRight();
		}
		
		explosionEmitter = new EmitterSprite(Registry.explosionColor);
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
			if(!isMoving) {
				if (FlxG.keys.RIGHT) {
					if(Registry.level.get(Std.int(owner.tileX+0.5)+1,Std.int(owner.tileY+0.5))==0) {
						isMoving = true;
						Actuate.tween(this, 0.2, { x: roundedTilePosition(this.x+Registry.tileSize) } ).onComplete(stopped);
						faceRight();
					}
				} else if (FlxG.keys.LEFT) {
					if(Registry.level.get(Std.int(owner.tileX+0.5)-1,Std.int(owner.tileY+0.5))==0) {
						isMoving = true;
						Actuate.tween(this, 0.2, { x: roundedTilePosition(this.x-Registry.tileSize) } ).onComplete(stopped);
						faceLeft();
					}
				} else if (FlxG.keys.DOWN) {
					if(Registry.level.get(Std.int(owner.tileX+0.5),Std.int(owner.tileY+0.5)+1)==0) {
						isMoving = true;
						Actuate.tween(this, 0.2, { y: roundedTilePosition(this.y+Registry.tileSize) } ).onComplete(stopped);
						faceDown();
					}
				} else if (FlxG.keys.UP) {
					if(Registry.level.get(Std.int(owner.tileX+0.5),Std.int(owner.tileY+0.5)-1)==0) {
						isMoving = true;
						Actuate.tween(this, 0.2, { y: roundedTilePosition(this.y-Registry.tileSize) } ).onComplete(stopped);
						faceUp();
					}
				}
			}
			if (FlxG.keys.SPACE) {
				owner.weapon.fire();
			}
			
		} else {
			// enemy movement
		}
	}
	
	inline function roundedTilePosition(p:Float):Int {
		return Math.round(p/Registry.tileSize-0.5)*Registry.tileSize + Std.int(Registry.tileSize/2);
	}
	
	public function stopped() {
		isMoving = false;
		x = roundedTilePosition(x);
		y = roundedTilePosition(y);
	}
	
	function faceRight() {
		facing = FlxObject.RIGHT;
		direction = E;
		weaponSprite.setBulletDirection(WeaponSprite.BULLET_RIGHT, Math.round(Registry.bulletSpeed));
	}
	
	function faceLeft() {
		facing = FlxObject.LEFT;
		direction = W;
		weaponSprite.setBulletDirection(WeaponSprite.BULLET_LEFT, Math.round(Registry.bulletSpeed));
	}
	
	function faceDown()	{
		direction = S;
		weaponSprite.setBulletDirection(WeaponSprite.BULLET_DOWN, Math.round(Registry.bulletSpeed));
	}
	
	function faceUp() {
		direction = N;
		weaponSprite.setBulletDirection(WeaponSprite.BULLET_UP, Math.round(Registry.bulletSpeed));
	}
}