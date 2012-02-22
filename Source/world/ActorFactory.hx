package world;
import data.Registry;
import data.Library;
import sprites.ActorSprite;
import world.Actor;

class ActorFactory {
	public static function newActor(type:ActorType, ?x:Float=1, ?y:Float=1):Actor {
		var a = new Actor(type);
		var index;
		var sheet:Images;
		var isImmovable = false;
		
		switch (type) {
			case PLAYER:
				sheet = ACTORS;
				index = 1;
			case KEY:
				sheet = ACTORS;
				index = 166;
			case DOOR_CLOSE:
				sheet = FURNITURE;
				index = 207;
				isImmovable = true;
			case DOOR_OPEN:
				sheet = FURNITURE;
				index = 207 + 25;
				isImmovable = true;
		}
		
		a.sprite = new ActorSprite(a, sheet, index, x * Registry.tileSize, y * Registry.tileSize, isImmovable);
		
		return a;
	}	
}