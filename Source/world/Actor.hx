package world;

import sprites.ActorSprite;
import data.Registry;

class Actor {
	public var type:ActorType;
	public var sprite:ActorSprite;
	public var weapon:Weapon;
	
	public var items:Array<Actor>;
	public var tileX(getX, setX):Float;
	public var tileY(getY, setY):Float;

	var parts:IntHash<Part>;

	public function new(type:ActorType) {
		this.type = type;
		items = [];
		parts = new IntHash<Part>();
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
	
	public function has(type:ActorType):Bool {
		for (item in items) {
			if (item.type == type) {
				return true;
			}
		}
		return false;
	}
	
	public function remove(type:ActorType) {
		for (item in items.copy()) {
			if (item.type == type) {
				items.remove(item);
				return;
			}
		}
	}

}

enum ActorType {
	PLAYER;
	LEVER_CLOSE;
	LEVER_OPEN;
	DOOR_CLOSE;
	DOOR_OPEN;
}