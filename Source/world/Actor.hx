package world;

import sprites.ActorSprite;
import data.Registry;

class Actor {
	public var type:ActorType;
	public var sprite:ActorSprite;
	public var tileX(getX, setX):Float;
	public var tileY(getY, setY):Float;
	
	public var health(getHealth, setHealth):Float;
	
	// base stats
	public var strength:Float;
	public var dexterity:Float;
	public var agility:Float;
	public var endurance:Float;
	
	// derived attributes
	public var damage(getDamage, never):Float;
	public var maxHealth(getMaxHealth, never):Float;
	public var attackSpeed(getAttackSpeed, never):Float;
	public var accuracy(getAccuracy, never):Float;
	public var walkingSpeed(getWalkingSpeed, never):Float;
	public var dodge(getDodge, never):Float;
	
	public var isPlayer:Bool;
	
	public var weapon:Weapon;
	var buffs:Hash<Float>;

	var parts:IntHash<Part>;
	
	function getDamage():Float {
		return (strength + weapon.damage) / 2;
	}
	function getMaxHealth():Float {
		return (strength + endurance) * 2;
	}
	function getAttackSpeed():Float {
		// how many attacks per second
		return (dexterity + weapon.attackSpeed) / 4;
	}
	function getAccuracy():Float {
		return (accuracy + weapon.accuracy) / 2;
	}
	function getWalkingSpeed():Float {
		return agility;
	}
	function getDodge():Float {
		return agility+endurance;
	}
	
	function getBuffed(attribute:String):Float {
		var buff = buffs.get(attribute);
		return Reflect.field(this,attribute) + (buff==null?0:buff);
	} 
	
	// we don't want flixel to kill the actorsprite unless its buffed health <= 0
	function setHealth(h:Float):Float {
		var buff = buffs.get("health");
		return sprite.health = h + (buff==null?0:buff);
	}
	// however, we want actor.health to return the unbuffed value
	function getHealth():Float {
		var buff = buffs.get("health");
		return sprite.health - (buff==null?0:buff);
	}
	
	public function new(type:ActorType) {
		this.type = type;
		parts = new IntHash<Part>();
		
		buffs = new Hash<Float>();
	}

	function as(kind:Kind):Part {
		return parts.get(Type.enumIndex(kind));
	}

	function addPart(part:Part) {
		parts.set(Type.enumIndex(part.getKind()), part);
	}

	function removePart(part:Part) {
		parts.remove(Type.enumIndex(part.getKind()));
	}

	function getX():Float {
		return sprite.x / Registry.tileSize;
	}
	function getY():Float {
		return sprite.y / Registry.tileSize;
	}
	
	function setX(x:Float):Float {
		sprite.x = x * Registry.tileSize;
		return getX();
	}
	function setY(y:Float):Float {
		sprite.y = y * Registry.tileSize;
		return getY();
	}
}

enum ActorType {
	GUARD;
	WARRIOR;
	ARCHER;
	MONK;
	
	
	LEVER_CLOSE;
	LEVER_OPEN;
	DOOR_CLOSE;
	DOOR_OPEN;
}