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
		if(sprite.fire()) {
			actor.sprite.playAttackEffect(type);
		}
	}
}

enum WeaponType {
	UNARMED;
	SPEAR;
	SWORD;
	BOW;
	STAFF;
}