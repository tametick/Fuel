package parts;

import data.Library;
import data.Registry;
import org.flixel.FlxG;
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
		if (actor.isOnGround() && actor.stats.gunCharge > 0) {
			if(!Registry.debug) {
				actor.stats.gunCharge -= Registry.gunDischargeRate;
			}
			sprite.fire();
			FlxG.play(Library.getSound(SHOT));
			Registry.level.passTurn();
		} else {
			FlxG.play(Library.getSound(ERROR));
		}
	}
	
	public function hit(victim:Actor) {
		var victimStats = victim.stats;
		var victimTrigger = victim.triggerable;

		// the hurt function kills the sprite if needed
		victim.sprite.hurt(actor.stats.damage);
		
		// trigger mechanism
		if (victimStats != null && victimStats.suitCharge <= 0) {
			victim.kill();
		} else if (victimTrigger != null) {
			victimTrigger.onMechanism(victim, actor);
		}
	}
}

enum WeaponType {
	UNARMED;
	LASER;
}