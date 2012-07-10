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
			if (Registry.level.isWalkable(actor.tileX + d.dx, actor.tileY)) {
				s.startMoving(d);
			}
		} else {
			if(canDig() && Math.random()<Registry.walkerDigChance) {
				actor.weapon.fire();
			} else {
				s.face(d.flip);
			}
		}
	}
	
	function canDig():Bool {
		var l = Registry.level;
		var d = actor.sprite.direction;
		if (d.horizontal) {
			if (l.get(actor.tilePoint.x + d.dx, actor.tilePoint.y) == 1 && l.get(actor.tilePoint.x + d.dx, actor.tilePoint.y+1) == 1) {
				return true;
			}
		}
		return false;
	}
}