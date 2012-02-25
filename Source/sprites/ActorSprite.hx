package sprites;

import com.eclecticdesignstudio.motion.Actuate;
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


class ActorSprite extends FlxSprite {
	// fixme - move to registry
	static var movementKeys = ["RIGHT", "LEFT", "DOWN", "UP"];
	static var attackKey = ["SPACE"];
	
	public var owner:Actor;
	public var direction:Direction;
	public var directionIndicator:IndicatorSprite;
	public var attackEffect:AttackSprite;
	public var explosionEmitter:EmitterSprite;
	
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
		if (owner.isPlayer) {
			directionIndicator = new IndicatorSprite();
		}
		attackEffect = new AttackSprite();
				
		loadGraphic(Library.getImage(image), true, true, Registry.tileSize, Registry.tileSize);
		addAnimation("idle", [spriteIndex]);
		play("idle");
		
		if (isImmovable) {
			immovable = true;
		}
		
		faceRight();
		
		explosionEmitter = new EmitterSprite(Registry.explosionColor);
		
		bobCounter = 1.0;
		bobCounterInc = 0.04;
		bobMult = 0.75;
	}
	
	function getWeaponSprite():WeaponSprite {
		return owner.weapon.sprite;
	}
	
	function startMoving(dx:Int, dy:Int) {
		isMoving = true;
		bobCounter = -1.0;
		var duration = 1/(owner.walkingSpeed);
		Actuate.tween(this, duration, { x: roundedTilePosition(this.x+dx*Registry.tileSize), y: roundedTilePosition(this.y+dy*Registry.tileSize) } ).onComplete(stopped);
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
						y += offset;
					case W:
						x -= offset;
					case N:
						y -= offset;
					case E:
						x += offset;
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
		directionIndicator.visible = false;
		switch(type) {				
			case UNARMED, SPEAR, SWORD, STAFF:
				attackEffect.play("MELEE", true);
			case BOW:
				attackEffect.play("RANGED", true);
		}
		Actuate.timer(0.5).onComplete(showIndicator);
	}
	
	function showIndicator() {
		directionIndicator.visible = true;
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
			// show the attack direction
			directionIndicator.play(Type.enumConstructor(direction));
			directionIndicator.x = attackEffect.x;
			directionIndicator.y = attackEffect.y;
			
			if(!isMoving) {				
				if (FlxG.keys.pressed(movementKeys[0])) {
					// right
					if(Registry.level.isWalkable(Std.int(owner.tileX)+1,Std.int(owner.tileY))) {
						startMoving(1,0);
						faceRight();
					}
				} else if (FlxG.keys.pressed(movementKeys[1])) {
					// left
					if(Registry.level.isWalkable(Std.int(owner.tileX)-1,Std.int(owner.tileY))) {
						startMoving(-1,0);
						faceLeft();
					}
				} else if (FlxG.keys.pressed(movementKeys[2])) {
					// down
					if(Registry.level.isWalkable(Std.int(owner.tileX),Std.int(owner.tileY+1))) {
						startMoving(0,1);
						faceDown();
					}
				} else if (FlxG.keys.pressed(movementKeys[3])) {
					// up
					if(Registry.level.isWalkable(Std.int(owner.tileX),Std.int(owner.tileY-1))) {
						startMoving(0,-1);
						faceUp();
					}
				}
			}
			
			if (FlxG.keys.justPressed(attackKey[0])) {
				owner.weapon.fire();
			}
			
		} else {
			// enemy movement
		}
	}
	
	inline function roundedTilePosition(p:Float):Int {
		return Math.round(p/Registry.tileSize)*Registry.tileSize;
	}
	
	public function stopped() {
		isMoving = false;
		x = roundedTilePosition(x);
		y = roundedTilePosition(y);
		
		Registry.level.updateFov();
		
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