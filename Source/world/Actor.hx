package world;

import org.flixel.FlxPoint;
import sprites.ActorSprite;
import data.Registry;

class Actor {
	public var type:ActorType;
	public var sprite:ActorSprite;
	public var tileX(getX, setX):Float;
	public var tileY(getY, setY):Float;
	public var tilePoint(getPoint, never):FlxPoint;
	
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
	
	public var isPlayer:Bool;
	public var isAwake:Bool;
	public var isBlocking:Bool;
	
	public var weapon:Weapon;

	var parts:IntHash<Part>;
	
	function getDamage():Float {
		return (strength + weapon.damage) / 2 + buffs.damage;
	}
	function getMaxHealth():Float {
		return strength + endurance*2 + buffs.health;
	}
	function getAttackSpeed():Float {
		return (dexterity + weapon.attackSpeed) / 4 + buffs.attackSpeed/2;
	}
	function getAccuracy():Float {
		return (accuracy + weapon.accuracy) / 2 + buffs.accuracy;
	}
	function getWalkingSpeed():Float {
		return agility/2 + buffs.walkingSpeed/2;
	}
	function getDodge():Float {
		return agility+weapon.defense + buffs.dodge;
	}
	
	/* since we don't want flixel to kill the actorsprite unless 
	   its buffed  health <= 0, we apply the buff in the setter */ 
	function setHealth(h:Float):Float {
		return sprite.health = h + buffs.health;
	}
	function getHealth():Float {
		return sprite.health;
	}
	
	public function new(type:ActorType) {
		this.type = type;
		parts = new IntHash<Part>();
		
		buffs = { 
			health: 0.0,
			damage: 0.0,
			attackSpeed: 0.0,
			accuracy: 0.0,
			walkingSpeed: 0.0,
			dodge: 0.0,
		};
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
	
	function getPoint():FlxPoint {
		return new FlxPoint(getX(), getY());
	}
	
	public function hit(victim:Actor) {
		var isHit = Math.random() < accuracy/(accuracy+victim.dodge);
		
		if(isHit) {
			victim.health -= damage;
			// emit blood
		} else {
			//victim.sprite.showDodge(dir);
		}
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