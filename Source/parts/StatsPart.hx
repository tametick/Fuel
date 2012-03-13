package parts;

import world.Actor;

class StatsPart extends Part {
	// base stats
	public var maxSuitCharge:Float;
	public var maxGunCharge:Float;
	public var maxBeltCharge:Float;
	
	// energy stats
	public var suitCharge(getSuitCharge, setSuitCharge):Float;
	public var gunCharge:Float;
	public var beltCharge:Float;

	// derived stats
	public var damage(getDamage, never):Float;

	function getDamage():Float {
		return actor.weapon.damage;
	}

	function setSuitCharge(h:Float):Float {
		return actor.sprite.health = h;
	}
	function getSuitCharge():Float {
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
