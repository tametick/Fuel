package world;

import sprites.WeaponSprite;

class Weapon {
	public var owner:Actor;
	public var sprite:WeaponSprite;
	public var range:Float;
	
	public function new(owner:Actor) {
		this.owner = owner;
		sprite = new WeaponSprite("spear");
		range = 1;
	}
	
	public function fire() {
		sprite.fire();
	}
}