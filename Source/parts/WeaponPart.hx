package parts;

import parts.Part;
import sprites.WeaponSprite;
import world.Actor;

class WeaponPart extends Part{
	public var type:WeaponType;
	public var sprite:WeaponSprite;
	
	public var range:Float;
	public var damage:Float;
	public var attackSpeed:Float;
	public var accuracy:Float;
	public var defense:Float;
	
	public function new(actor:Actor, type:WeaponType) {
		this.actor = actor;
		this.type = type;
	}
	
	public function fire() {
		sprite.fire();
	}
	
	public function hit(victim:Actor):Bool {
		var victimStats = victim.stats;

		var chanceToHit = actor.stats.accuracy / (actor.stats.accuracy + victimStats.dodge);
		var isHit = Math.random() < chanceToHit;

		if (isHit) {
			// the hurt function kills the sprite if needed
			victim.sprite.hurt(actor.stats.damage);
			if (victimStats.health <= 0) {
				victim.kill();
			}
		}
		
		return isHit;
	}
}

enum WeaponType {
	UNARMED;
	SPEAR;
	SWORD;
	BOW;
	STAFF;
}