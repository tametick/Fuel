package parts;

import data.Registry;
import states.GameState;
import world.Actor;

class StatsPart extends Part {
	// base stats
	public var maxSuitCharge:Float;
	public var maxGunCharge:Float;
	public var maxBeltCharge:Float;
	
	// energy stats
	public var suitCharge(getSuitCharge, setSuitCharge):Float;
	public var gunCharge(getGunCharge, setGunCharge):Float;
	public var beltCharge(getBeltCharge, setBeltCharge):Float;

	// derived stats
	public var damage(getDamage, never):Float;

	function getDamage():Float {
		return actor.weapon.damage;
	}

	function setSuitCharge(h:Float):Float {
		if (actor == Registry.player) {
			GameState.hudLayer.setSuitBarWidth(h);
		}
	
		return actor.sprite.health = h;
	}
	function getSuitCharge():Float {
		return actor.sprite.health;
	}
	
	function setGunCharge(g:Float):Float {
		if (actor == Registry.player) {
			GameState.hudLayer.setGunBarWidth(g);
		}
	
		return gunCharge = g;
	}
	function getGunCharge():Float {
		return gunCharge;
	}
	
	function setBeltCharge(b:Float):Float {
		if (actor == Registry.player) {
			GameState.hudLayer.setBeltBarWidth(b);
		}
	
		return beltCharge = b;
	}
	function getBeltCharge():Float {
		return beltCharge;
	}

	public function new(actor:Actor, stats:Dynamic) {
		this.actor = actor;
		
		for (field in Reflect.fields(stats)) {
			if (Reflect.field(this, field)==null)
				throw "Invalid stat field "+field;
			Reflect.setField(this, field, Reflect.field(stats, field));
		}
	}
}
