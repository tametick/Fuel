package parts;

import world.Actor;

class StatsPart extends Part {
	// base stats
	public var maxHealth:Float;
	public var maxGun:Float;
	public var maxBelt:Float;
	
	// energy stats
	public var health(getHealth, setHealth):Float;
	public var gun:Float;
	public var belt:Float;

	// derived stats
	public var damage(getDamage, never):Float;

	function getDamage():Float {
		return actor.weapon.damage;
	}

	function setHealth(h:Float):Float {
		return actor.sprite.health = h;
	}
	function getHealth():Float {
		return actor.sprite.health;
	}

	public function new(stats:Dynamic) {
		for (field in Reflect.fields(stats)) {
			if (Reflect.field(this, field)==null)
				throw "Invalid stat field "+field;
			Reflect.setField(this, field, Reflect.field(stats, field));
		}
	}
}
