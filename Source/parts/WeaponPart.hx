package parts;

import parts.Part;
import sprites.WeaponSprite;
import world.Actor;

class WeaponPart extends Part{
	public var type:WeaponType;
	public var sprite:WeaponSprite;
	
	public var range:Float;
	public var damage:Float;
	
	public function new(actor:Actor, type:WeaponType) {
		this.actor = actor;
		this.type = type;
	}
	
	public function fire() {
		sprite.fire();
	}
	
	public function hit(victim:Actor) {
		var victimStats = victim.stats;

		// the hurt function kills the sprite if needed
		victim.sprite.hurt(actor.stats.damage);
		if (victimStats.health <= 0) {
			victim.kill();
		}
	}
}

enum WeaponType {
	UNARMED;
	LASER;
}