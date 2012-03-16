package parts;

import org.flixel.FlxU;
import data.Registry;
import utils.Direction;
import utils.Utils;

class ClimberAiPart extends AiPart{
	override public function act() {
		var p = Registry.player.tilePoint;
		var l = Registry.level;
		var s = actor.sprite;
		var d = s.direction;
		
		if (actor.isHung) {
			if (Utils.dist(p.x,actor.tileX)<2 &&
			  l.isInLos(p, actor.tilePoint, 10)) {
				
				actor.isHung = false;
				actor.sprite.play("idle");
			}
		} else if(actor.isOnGround()){
			if (canAttackPlayer()) {
				actor.weapon.fire();
			} else if (canWalkForward()) {
				var dx = d == W? -1:1;
				if (Registry.level.isWalkable(actor.tileX + dx, actor.tileY)) {
					s.startMoving(dx,0);
				}
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
}