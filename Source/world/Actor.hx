package world;

import org.flixel.FlxPoint;
import sprites.ActorSprite;
import data.Registry;
import utils.ObjectHash;
import parts.StatsPart;
import parts.TriggerablePart;
import parts.Part;
import parts.WeaponPart;

class Actor {
	public var type:ActorType;
	public var sprite:ActorSprite;
	public var tileX(getX, setX):Float;
	public var tileY(getY, setY):Float;
	public var tilePoint(getPoint, never):FlxPoint;

	public var stats(getStats, null):StatsPart;
	public var triggerable(getTriggerable, null):TriggerablePart;
	public var weapon(getWeapon, null):WeaponPart;
	function getStats():StatsPart { return as(StatsPart); }
	function getTriggerable():TriggerablePart { return as(TriggerablePart); }
	function getWeapon():WeaponPart { return as(WeaponPart); }

	public var isPlayer:Bool;
	public var isAwake:Bool;
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
		Registry.level.removeEnemy(this);
	}
	
	public function isOnGround() {
		var l = Registry.level;
		return tileY == l.height - 1  ||  l.get(tileX, tileY+1) != 0;
	}
}

enum ActorType {
	// player classes
	SPACE_MINER;

	// monsters
	WALKER;
}