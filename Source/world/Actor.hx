package world;

import data.Registry;
import sprites.ActorSprite;

class Actor {
	public var type:ActorType;
	public var sprite:ActorSprite;
	
	public var items:Array<Actor>;
	public var tileX(getX, setX):Float;
	public var tileY(getY, setY):Float;
	
	public function new(type:ActorType) {
		this.type = type;
		items = [];
	}
	
	function getX():Float {
		return sprite.x / Registry.tileSize;
	}
	function getY():Float {
		return sprite.y / Registry.tileSize;
	}
	
	function setX(x:Float):Float {
		// fixme - only for player
		sprite.x = x * Registry.tileSize+1;
		return getX();
	}
	function setY(y:Float):Float {
		// fixme - only for player
		sprite.y = y * Registry.tileSize+2;
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
	KEY;
	DOOR_CLOSE;
	DOOR_OPEN;
}