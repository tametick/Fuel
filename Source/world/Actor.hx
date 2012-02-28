package world;

import org.flixel.FlxPoint;
import sprites.ActorSprite;
import data.Registry;

class Actor {
	public var type:ActorType;
	public var sprite:ActorSprite;
	public var tileX(getX, setX):Float;
	public var tileY(getY, setY):Float;
	public var tilePoint(getPoint, never):FlxPoint;

	public var isPlayer:Bool;
	public var isAwake:Bool;
	public var isBlocking:Bool;

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

	public function hit(victim:Actor):Bool {
		var stats = cast(as(Kind.Stats), StatsPart);
		var victimStats = cast(victim.as(Kind.Stats), StatsPart);

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

	LEVER_CLOSE;
	LEVER_OPEN;
	DOOR_CLOSE;
	DOOR_OPEN;
}