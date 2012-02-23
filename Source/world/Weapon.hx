package world;

import sprites.WeaponSprite;

class Weapon {
	public var owner:Actor;
	public var type:WeaponType;
	public var sprite:WeaponSprite;
	public var range:Float;
	
	public function new(owner:Actor, type:WeaponType) {
		this.owner = owner;
		this.type = type;
		
		// fixme = weapon factory
		sprite = new WeaponSprite(Type.enumConstructor(type));
		range = 1;
	}
	
	public function fire() {
		sprite.fire();
	}
}

enum WeaponType {
	SPEAR;
}