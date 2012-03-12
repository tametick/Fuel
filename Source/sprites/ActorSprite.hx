package sprites;

import com.eclecticdesignstudio.motion.Actuate;
import org.flixel.plugin.photonstorm.FlxBar;
import org.flixel.FlxG;
import org.flixel.FlxPoint;
import org.flixel.FlxSprite;
import org.flixel.FlxObject;
import data.Registry;
import data.Library;
import utils.Direction;
import utils.Utils;
import world.Actor;
import parts.WeaponPart;

class ActorSprite extends FlxSprite {
	public var owner:Actor;
	public var direction:Direction;
	
	public var healthBar:FlxBar;
	public var attackEffect:AttackSprite;
	public var explosionEmitter:EmitterSprite;
	public var bloodEmitter:EmitterSprite;
	
	var isMoving:Bool;
	var weaponSprite(getWeaponSprite, null):WeaponSprite;

	public function new(owner:Actor, image:Image, spriteIndex:Int, ?x:Float = 0, ?y:Float = 0, ?isImmovable:Bool = false) {
		super(x, y);

		this.owner = owner;
		loadGraphic(Library.getFilename(image), true, true, Registry.tileSize, Registry.tileSize);
		updateTileSheet();
		frame = spriteIndex;

		if (isImmovable) {
			immovable = true;
		}
		
		if (owner.stats != null) {
			attackEffect = new AttackSprite();
			explosionEmitter = new EmitterSprite(Registry.explosionColor);
			bloodEmitter = new EmitterSprite(Registry.bloodColor);

			healthBar = new FlxBar(0, 0, FlxBar.FILL_LEFT_TO_RIGHT, Registry.tileSize-1, 1, this, "health");
			healthBar.trackParent(0, Registry.tileSize-1);
			healthBar.setRange(0, owner.stats.maxHealth);
			healthBar.killOnEmpty = true;
			healthBar.updateTileSheet();

			offset.y = 1;
		}
		
		faceRight();
	}

	function getWeaponSprite():WeaponSprite {
		return owner.weapon.sprite;
	}
	
	function startMoving(dx:Int, dy:Int) {
		isMoving = true;
		var walkingSpeed = owner.stats.walkingSpeed;
		var duration = 1 / (walkingSpeed);
		var nextPixelX = getPositionSnappedToGrid(this.x + dx * Registry.tileSize);
		var nextPixelY = getPositionSnappedToGrid(this.y + dy * Registry.tileSize);
		var nextTileX = nextPixelX / Registry.tileSize;
		var nextTileY = nextPixelY / Registry.tileSize;
		
		// move
		Actuate.tween(this, duration, {x: nextPixelX, y: nextPixelY}).onComplete(stopped);
		// update fov
		if(owner.isPlayer) {
			Registry.level.updateFov(new FlxPoint(nextTileX, nextTileY));
		}
	}
	
	public function playAttackEffect(type:WeaponType) {
		switch(type) {
			case UNARMED, SPEAR, SWORD, STAFF:
				attackEffect.play("MELEE", true);
			case BOW:
				attackEffect.play("RANGED", true);
		}
	}
		
	override public function update() {
		if (FlxG.state != Registry.gameState)
			return;
				
		super.update();
		if(attackEffect!=null) {
			switch (direction) {
				case N:
					attackEffect.x = x;
					attackEffect.y = y - Registry.tileSize;
				case E:
					attackEffect.x = x + Registry.tileSize;
					attackEffect.y = y ;
				case S:
					attackEffect.x = x;
					attackEffect.y = y + Registry.tileSize + 1;
				case W:
					attackEffect.x = x - Registry.tileSize - 1;
					attackEffect.y = y;
			}
		}
		
		if (owner == Registry.player) {
			
			if(!isMoving) {
				if (FlxG.keys.pressed(Registry.movementKeys[0])) {
					faceRight();
					if(Registry.level.isWalkable(owner.tileX+1,owner.tileY)) {
						startMoving(1,0);
					}
				} else if (FlxG.keys.pressed(Registry.movementKeys[1])) {
					faceLeft();
					if(Registry.level.isWalkable(owner.tileX-1,owner.tileY)) {
						startMoving(-1,0);
					}
				} else if (FlxG.keys.pressed(Registry.movementKeys[2])) {
					faceDown();
					if(Registry.level.isWalkable(owner.tileX,owner.tileY+1)) {
						startMoving(0,1);
					}
				} else if (FlxG.keys.pressed(Registry.movementKeys[3])) {
					faceUp();
					if(Registry.level.isWalkable(owner.tileX,owner.tileY-1)) {
						startMoving(0,-1);
					}
				}
			}
			
			if (FlxG.keys.pressed(Registry.attackKey[0])) {
				owner.weapon.fire();
			}
			
		} else {
			// enemy movement
		}
	}
	
	inline function getPositionSnappedToGrid(p:Float):Int {
		return Math.round(p/Registry.tileSize)*Registry.tileSize;
	}
	
	public function stopped() {
		isMoving = false;
		x = getPositionSnappedToGrid(x);
		y = getPositionSnappedToGrid(y);
		
		var mapSprite = Registry.level.mapSprite;
		FlxG.overlap(this, mapSprite.itemSprites, mapSprite.overlapItem);
	}
	
	function faceRight() {
		facing = FlxObject.RIGHT;
		direction = E;
		if(owner.weapon!=null) {
			weaponSprite.setBulletDirection(WeaponSprite.RIGHT, Math.round(Registry.bulletSpeed));
			attackEffect.facing = FlxObject.RIGHT;
		}
	}
	
	function faceLeft() {
		facing = FlxObject.LEFT;
		direction = W;
		if (owner.weapon != null) {
			weaponSprite.setBulletDirection(WeaponSprite.LEFT, Math.round(Registry.bulletSpeed));
			attackEffect.facing = FlxObject.LEFT;
		}
	}
	
	function faceDown()	{
		direction = S;
		if (owner.weapon != null) {
			weaponSprite.setBulletDirection(WeaponSprite.DOWN, Math.round(Registry.bulletSpeed));
		}
	}
	
	function faceUp() {
		direction = N;
		if (owner.weapon != null) {
			weaponSprite.setBulletDirection(WeaponSprite.UP, Math.round(Registry.bulletSpeed));
		}
	}
}