package world;

import org.flixel.FlxPoint;
import sprites.ActorSprite;
import data.Registry;
import utils.ObjectHash;
import parts.StatsPart;
import parts.TriggerablePart;
import parts.Part;

class Actor {
	public var type:ActorType;
	public var sprite:ActorSprite;
	public var tileX(getX, setX):Float;
	public var tileY(getY, setY):Float;
	public var tilePoint(getPoint, never):FlxPoint;

	// fixme: Macrofy this boilerplate?
	public var stats(getStats, setStats):StatsPart;
	private function getStats():StatsPart {
		return as(StatsPart);
	}
	private function setStats(part:StatsPart):StatsPart {
		addPart(part);
		return part;
	}

	public var triggerable(getTriggerable, setTriggerable):TriggerablePart;
	private function getTriggerable():TriggerablePart {
		var part = as(TriggerablePart);
		return part;
	}
	private function setTriggerable(part:TriggerablePart):TriggerablePart {
		addPart(part);
		return part;
	}

	public var isPlayer:Bool;
	public var isAwake:Bool;
	public var isBlocking(getIsBlocking, never):Bool;

	public var weapon:Weapon;
	
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

	public function hit(victim:Actor):Bool {
		var stats = this.stats;
		var victimStats = victim.stats;

		// Unstatted actors can't hit or be hit.
		if (stats == null || victimStats == null)
			return false;

		var chanceToHit = stats.accuracy / (stats.accuracy + victimStats.dodge);
		var isHit = Math.random() < chanceToHit;

		if (isHit) {
			// the hurt function kills the sprite if needed
			victim.sprite.hurt(stats.damage);

			if (victimStats.health <= 0) {
				victim.kill();
			}
		} else {
			if(Math.round(victim.tileX)<Math.round(tileX)) {
				victim.sprite.showDodge(W);
			} else if (Math.round(victim.tileX) > Math.round(tileX)) {
				victim.sprite.showDodge(E);
			} else if(Math.round(victim.tileY)< Math.round(tileY)) {
				victim.sprite.showDodge(N);
			} else if (Math.round(victim.tileY) > Math.round(tileY)) {
				victim.sprite.showDodge(S);
			}
		}

		return isHit;
	}

	public function kill() {
		Registry.level.removeEnemy(this);
	}
}

enum ActorType {
	// player classes
	GUARD;
	WARRIOR;
	ARCHER;
	MONK;

	// monsters
	SPEAR_DUDE;

	// map features
	LEVER;
	DOOR;
}