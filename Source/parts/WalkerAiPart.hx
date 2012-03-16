package parts;

import org.flixel.FlxObject;
import data.Registry;
import utils.Utils;
import utils.Direction;
import world.Actor;

class WalkerAiPart extends AiPart{
	override public function act() {
		var s = actor.sprite;
		var d = s.direction;
	
		if (canWalkForward()) {
			var dx = d == W? -1:1;
			if (Registry.level.isWalkable(actor.tileX + dx, actor.tileY)) {
				s.startMoving(dx,0);
			}
		} else {
			// turn around
			actor.sprite.direction = Utils.reverseDirection(actor.sprite.direction);
			if (actor.sprite.direction == E)
				actor.sprite.facing = FlxObject.RIGHT;
			else
				actor.sprite.facing = FlxObject.LEFT;
		}
	}
	
	
	function canWalkForward():Bool {
		var l = Registry.level;
		switch (actor.sprite.direction) {
			// fixme - why is this not working?
			case W:
				if (l.isWalkable(actor.tilePoint.x - 1, actor.tilePoint.y) && l.get(actor.tilePoint.x - 1, actor.tilePoint.y+1) == 1) {
					return true;
				}
			case E:
				if (l.isWalkable(actor.tilePoint.x + 1, actor.tilePoint.y) && l.get(actor.tilePoint.x + 1, actor.tilePoint.y+1) == 1) {
					return true;
				}
			default:
				throw "nooooo";
		}
		return false;
	}
}