package parts;

import org.flixel.FlxObject;
import data.Registry;
import utils.Utils;
import utils.Direction;
import world.Actor;

class WalkerAiPart extends AiPart {
	override public function act() {
		var s = actor.sprite;
		var d = s.direction;
	
		if (canAttackPlayer()) {
			actor.weapon.fire();
		} else if (canWalkForward()) {
			var dx = d == W? -1:1;
			if (Registry.level.isWalkable(actor.tileX + dx, actor.tileY)) {
				s.startMoving(dx,0);
			}
		} else {
			if(canDig() && Math.random()<Registry.walkerDigChance) {
				actor.weapon.fire();
			} else {
				// turn around
				s.direction = Utils.reverseDirection(s.direction);
				if (s.direction == E) {
					s.faceRight();
				} else {
					s.faceLeft();
				}
			}
		}
	}
	
	function canDig():Bool {
		var l = Registry.level;
		switch (actor.sprite.direction) {
			case W:
				if (l.get(actor.tilePoint.x - 1, actor.tilePoint.y) == 1 && l.get(actor.tilePoint.x - 1, actor.tilePoint.y+1) == 1) {
					return true;
				}
			case E:
				if (l.get(actor.tilePoint.x + 1, actor.tilePoint.y) == 1 && l.get(actor.tilePoint.x + 1, actor.tilePoint.y+1) == 1) {
					return true;
				}
			default:
		}
		return false;
	}
}