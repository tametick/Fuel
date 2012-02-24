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
		
		bobCounter = -1.0;
		bobCounterInc = 0.04;
		bobMult = 1;
	}
	
	function getWeaponSprite():WeaponSprite {
		return owner.weapon.sprite;
	}
	
	function startMoving(dx:Int, dy:Int) {
		isMoving = true;
		bobCounter = -1.0;
		var duration = 1/(owner.walkingSpeed*2);
		Actuate.tween(this, duration, { x: roundedTilePosition(this.x+dx*Registry.tileSize), y: roundedTilePosition(this.y+dy*Registry.tileSize) } ).onComplete(stopped);
	}
	
	override public function draw():Void {
		var oldX:Float = x;
		var oldY:Float = y;
		if(alive && health>0 && !FlxG.paused) {
			if ( isMoving ) {
				var offset:Float = Math.sin(bobCounter) * bobMult;
				y -= offset;
				bobCounter += bobCounterInc;
			}/* else if ( isDodging ) {
				var offset:Float = dodgeCounter;
				if ( offset > 10 ) 
					offset = 10 - (dodgeCounter - 10);
				if ( offset < 0 ) 
					offset = 0;
				switch (dodgeDir) {
					case 0:
						y += offset;
					case 1:
						x -= offset;
					case 2:
						y -= offset;
					case 3:
						x += offset;
				}
			}*/
		} else {
			bobCounter = -1.0;
		}
		
		super.draw();
	/*	if (isDodging ) {
			x = oldX;
			y = oldY;
		}*/
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
					if(Registry.level.get(Std.int(owner.tileX+0.5)+1,Std.int(owner.tileY+0.5))==0) {
						startMoving(1,0);
						faceRight();
					}
				} else if (FlxG.keys.pressed(movementKeys[1])) {
					// left
					if(Registry.level.get(Std.int(owner.tileX+0.5)-1,Std.int(owner.tileY+0.5))==0) {
						startMoving(-1,0);
						faceLeft();
					}
				} else if (FlxG.keys.pressed(movementKeys[2])) {
					// down
					if(Registry.level.get(Std.int(owner.tileX+0.5),Std.int(owner.tileY+0.5)+1)==0) {
						startMoving(0,1);
						faceDown();
					}
				} else if (FlxG.keys.pressed(movementKeys[3])) {
					// up
					if(Registry.level.get(Std.int(owner.tileX+0.5),Std.int(owner.tileY+0.5)-1)==0) {
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