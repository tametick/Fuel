package world;

import sprites.WeaponSprite;

class Weapon {
	public var owner:Actor;
	public var type:WeaponType;
	public var sprite:WeaponSprite;
	
	public var range:Float;
	public var damage:Float;
	public var attackSpeed:Float;
	public var accuracy:Float;
	public var defense:Float;
	
	public function new(owner:Actor, type:WeaponType) {
		this.owner = owner;
		this.type = type;
	}
	
	public function fire() {
		if(sprite.fire()) {
			owner.sprite.playAttackEffect(type);
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