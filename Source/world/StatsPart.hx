package world;

class StatsPart implements Part {
	public var actor:Actor;

	// energy stats
	public var health(getHealth, setHealth):Float;

	// base stats
	public var strength:Float;
	public var dexterity:Float;
	public var agility:Float;
	public var endurance:Float;

	// derived stats
	public var maxHealth(getMaxHealth, never):Float;
	public var damage(getDamage, never):Float;
	public var attackSpeed(getAttackSpeed, never):Float;
	public var accuracy(getAccuracy, never):Float;
	public var walkingSpeed(getWalkingSpeed, never):Float;
	public var dodge(getDodge, never):Float;

	// buffs can affect energy & derived stats
	var buffs:Dynamic;

	function getDamage():Float {
		return (strength + actor.weapon.damage) / 2 + buffs.damage;
	}
	function getMaxHealth():Float {
		return strength + endurance*2 + buffs.health;
	}
	function getAttackSpeed():Float {
		return (dexterity + actor.weapon.attackSpeed) / 4 + buffs.attackSpeed/2;
	}
	function getAccuracy():Float {
		return (dexterity + actor.weapon.accuracy) / 2 + buffs.accuracy;
	}
	function getWalkingSpeed():Float {
		return agility/2 + buffs.walkingSpeed/2;
	}
	function getDodge():Float {
		return agility+actor.weapon.defense + buffs.dodge;
	}

	/* since we don't want flixel to kill the actorsprite unless
	   its buffed  health <= 0, we apply the buff in the setter */
	function setHealth(h:Float):Float {
		return actor.sprite.health = h + buffs.health;
	}
	function getHealth():Float {
		return actor.sprite.health;
	}

	public function new(stats:Dynamic) {
		buffs = {
			health: 0.0,
			damage: 0.0,
			attackSpeed: 0.0,
			accuracy: 0.0,
			walkingSpeed: 0.0,
			dodge: 0.0,
		};

		// XXX: More idiomatic way to do this?
		for (field in Reflect.fields(stats)) {
			if (!Reflect.hasField(this, field))
				throw "Invalid stat field "+field;
			Reflect.setField(this, field, Reflect.field(stats, field));
		}
	}

	public function getKind():Kind {
		return Kind.Stats;
	}
}