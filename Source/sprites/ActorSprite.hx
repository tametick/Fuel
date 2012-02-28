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
import world.Weapon;
import world.Kind;
import world.StatsPart;

class ActorSprite extends FlxSprite {
	public var owner:Actor;
	public var direction:Direction;
	
	public var healthBar:FlxBar;
	public var attackEffect:AttackSprite;
	public var explosionEmitter:EmitterSprite;
	public var bloodEmitter:EmitterSprite;
	
	
	var isMoving:Bool;
	var isDodging:Bool;
	
	var dodgeDir:Direction;
	var dodgeCounter:Float;
	
	var bobCounter:Float;
	var bobCounterInc:Float;
	var bobMult:Float;
	
	var weaponSprite(getWeaponSprite, null):WeaponSprite;

	public function new(owner:Actor, image:Images, spriteIndex:Int, ?x:Float = 0, ?y:Float = 0, ?isImmovable:Bool = false) {
		super(x, y);
		this.owner = owner;
		attackEffect = new AttackSprite();

		loadGraphic(Library.getImage(image), true, true, Registry.tileSize, Registry.tileSize);
		setIndex(spriteIndex);

		if (isImmovable) {
			immovable = true;
		}
		
		faceRight();
		
		explosionEmitter = new EmitterSprite(Registry.explosionColor);
		bloodEmitter = new EmitterSprite(Registry.bloodColor);
		
		healthBar = new FlxBar(0, 0, FlxBar.FILL_LEFT_TO_RIGHT, 7, 1, this, "health");
		healthBar.trackParent(0, 7);
		var maxHealth = owner.stats != null ? owner.stats.maxHealth : 1.0;
		healthBar.setRange(0, maxHealth);
		healthBar.killOnEmpty = true;
		
		bobCounter = 1.0;
		bobCounterInc = 0.04;
		bobMult = 0.75;
		
		offset.y = 1;
	}

	public function setIndex(index:Int) {
		addAnimation("idle", [index]);
		play("idle");
	}

	function getWeaponSprite():WeaponSprite {
		return owner.weapon.sprite;
	}
	
	function startMoving(dx:Int, dy:Int) {
		isMoving = true;
		bobCounter = -1.0;
		var walkingSpeed = owner.stats != null ? owner.stats.walkingSpeed : 1.0;
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
	
	public function showDodge(Dir:Direction) {
		isDodging = true;
		dodgeCounter = 0;
		dodgeDir = Dir;
	}
	
	override public function draw():Void {
		var oldX:Float = x;
		var oldY:Float = y;
		if(alive && health>0 && !FlxG.paused) {
			if ( isMoving ) {
				var offset:Float = Math.sin(bobCounter)*bobMult;
				y -= offset;
				bobCounter += bobCounterInc;
			} else if ( isDodging ) {
				var offset:Float = dodgeCounter;
				if ( offset > 10 ) 
					offset = 10 - (dodgeCounter - 10);
				if ( offset < 0 ) 
					offset = 0;
				switch (dodgeDir) {
					case S:
						y += offset/2;
					case W:
						x -= offset/2;
					case N:
						y -= offset/2;
					case E:
						x += offset/2;
				}
			}
		} else {
			bobCounter = -1.0;
		}
		
		super.draw();
		if (isDodging ) {
			x = oldX;
			y = oldY;
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
		
		
		if ( isDodging ) {
			dodgeCounter += 2;
			if ( dodgeCounter >= 20 ) isDodging = false;
		}
		
		super.update();
		
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
			attackEffect.facing = FlxObject.LEFT;
		}
	}
	
	function faceUp() {
		direction = N;
		if (owner.weapon != null) {
			weaponSprite.setBulletDirection(WeaponSprite.UP, Math.round(Registry.bulletSpeed));
			attackEffect.facing = FlxObject.RIGHT;
		}
	}
}