package world;

import org.flixel.FlxPoint;
import sprites.ActorSprite;
import data.Registry;
import parts.StatsPart;
import parts.TriggerablePart;
import parts.Part;
import parts.Kind;

class Actor {
	public var type:ActorType;
	public var sprite:ActorSprite;
	public var tileX(getX, setX):Float;
	public var tileY(getY, setY):Float;
	public var tilePoint(getPoint, never):FlxPoint;

	// XXX: Macrofy this boilerplate?
	public var stats(getStats, setStats):StatsPart;
	private function getStats():StatsPart {
		return cast(this.as(Kind.Stats), StatsPart);
	}
	private function setStats(part:StatsPart):StatsPart {
		this.addPart(part);
		return part;
	}

	public var triggerable(getTriggerable, setTriggerable):TriggerablePart;
	private function getTriggerable():TriggerablePart {
		return cast(this.as(Kind.Triggerable), TriggerablePart);
	}
	private function setTriggerable(part:TriggerablePart):TriggerablePart {
		this.addPart(part);
		return part;
	}

	public var isPlayer:Bool;
	public var isAwake:Bool;
	public var isBlocking(getIsBlocking, never):Bool;

	public var weapon:Weapon;

	var parts:IntHash<Part>;


	public function new(type:ActorType) {
		this.type = type;
		parts = new IntHash<Part>();
	}

	public function as(kind:Kind):Part {
		return parts.get(Type.enumIndex(kind));
	}

	public function addPart(part:Part) {
		part.actor = this;
		parts.set(Type.enumIndex(part.getKind()), part);
	}

	public function removePart(part:Part) {
		parts.remove(Type.enumIndex(part.getKind()));
		part.actor = null;
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

	LEVER;
	DOOR;
}