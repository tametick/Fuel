package world;

import com.eclecticdesignstudio.motion.Actuate;
import data.Library;
import org.flixel.FlxG;
import org.flixel.FlxObject;
import org.flixel.FlxPoint;
import parts.AiPart;
import sprites.ActorSprite;
import data.Registry;
import states.GameState;
import utils.Direction;
import utils.ObjectHash;
import parts.StatsPart;
import parts.TriggerablePart;
import parts.Part;
import parts.WeaponPart;
import utils.Utils;

class Actor {
	public var type:ActorType;
	public var sprite:ActorSprite;
	public var tileX(getX, setX):Float;
	public var tileY(getY, setY):Float;
	public var tilePoint(getPoint, never):FlxPoint;

	public var stats(getStats, null):StatsPart;
	public var triggerable(getTriggerable, null):TriggerablePart;
	public var ai(getAi, null):AiPart;
	public var weapon(getWeapon, null):WeaponPart;
	function getStats():StatsPart { return as(StatsPart); }
	function getTriggerable():TriggerablePart { return as(TriggerablePart); }
	function getAi():AiPart { return as(AiPart); }
	function getWeapon():WeaponPart { return as(WeaponPart); }

	public var isPlayer:Bool;
	public var isAwake:Bool;
	public var isFlying(default, setIsFlying):Bool;
	function setIsFlying(f:Bool):Bool {
		if(this==Registry.player && isFlying != f){
			FlxG.play(Library.getSound(TOGGLE_BELT));
		}
		return isFlying = f;
	}
	
	public var isHung:Bool;
	public var isBlocking(getIsBlocking, never):Bool;
	
	
	var partNameCache:ObjectHash<String>;
	var parts:Hash<Part>;
	
	public function new(type:ActorType) {
		this.type = type;
		parts = new Hash<Part>();
		partNameCache = new ObjectHash<String>();
	}

	public function as(type:Class<Part>):Dynamic {
		var cachedName = partNameCache.get(type);
		if (cachedName != null) {
			return parts.get(cachedName);
		}
	
		if (Type.getSuperClass(type) != Part) {
			throw type + " not a direct extending class of " + Part;
		}
	
		var name = Type.getClassName(type);
		var part = parts.get(name);
		
		// cache class name to avoid reflection next time
		partNameCache.set(type, name);
		
		return part;
	}
	public function addPart(part:Part) {
		part.actor = this;
		parts.set(getPartName(part), part);
	}
	public function removePart(part:Part) {
		parts.remove(getPartName(part));
		part.actor = null;
	}
	function getPartName(part:Part):String {
		var type:Class<Dynamic>= Type.getClass(part);
		while (Type.getSuperClass(type) != Part) {
			type = Type.getSuperClass(type);
		}
		return Type.getClassName(type);
	}

	function getX():Float {
		return sprite.x / Registry.tileSize;
	}
	function getY():Float {
		return sprite.y / Registry.tileSize;
	}
	function setX(x:Float):Float {
		sprite.x = x * Registry.tileSize;
		return getX();
	}
	function setY(y:Float):Float {
		sprite.y = y * Registry.tileSize;
		return getY();
	}
	function getPoint():FlxPoint {
		return new FlxPoint(getX(), getY());
	}

	function getIsBlocking():Bool {
		return triggerable != null && triggerable.isBlocking;
	}

	public function kill() {
		isFlying = false;
		if (this == Registry.player) {
			FlxG.playMusic(Library.getMusic(DEATH),1.0,false);
			GameState.hudLayer.setSuitBarWidth(0);
			GameState.hudLayer.setGunBarWidth(0);
			GameState.hudLayer.setBeltBarWidth(0);
			sprite.play("die");
			sprite.alive = false;
			
			// todo - high score screen
			// todo - game over
			FlxG.fade(0, 3, false, SpaceMiner.restart);
		} else {
			var s:Sound = null;
			switch (type) {
				case WALKER:
					FlxG.play(Library.getSound(WALKER_DEATH));
				case CLIMBER:
					FlxG.play(Library.getSound(CLIMBER_DEATH));
				case FLYER:
					FlxG.play(Library.getSound(FLYER_DEATH));
					
				case CEILING_SPIKE, FLOOR_SPIKE:
					FlxG.play(Library.getSound(DESTROY_WALL));
				default:
			}
			
			Registry.level.removeActor(this);
			sprite.kill();
		}
	}
	
	public function isOnGround(?dx:Int=0,?dy:Int=0):Bool {
		var l = Registry.level;
		if (l == null)
			return false;
		return tileY+dy == l.height - 1  ||  l.get(tileX+dx, tileY+dy+1) != 0;
	}
	
	public function isHungFromCeiling(?dx:Int=0,?dy:Int=0) {
		var l = Registry.level;
		return l.get(tileX+dx, tileY+dy-1) != 0 && isHung;
	}
	
	public function act() {
		if (!isOnGround() && !isHungFromCeiling() && !isFlying) {
			sprite.fall();
		}
		
		if (ai != null)
			ai.act();
	}
}

enum ActorType {
	// player classes
	SPACE_MINER;

	// monsters
	WALKER;
	CLIMBER;
	FLYER;
	
	// map features
	CEILING_SPIKE;
	FLOOR_SPIKE;
	TRIGGER;
	MINERAL;
	ENTRY_DOOR;
	EXIT_DOOR;
	
	// collectibles
	ICE;
	MONOPOLE;
}