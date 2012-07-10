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
				if (Registry.level.isWalkable(actor.tileX + d.dx, actor.tileY)) {
					s.startMoving(d);
				}
			} else {
				s.direction = d.flip;
			}
		}
	}
}
