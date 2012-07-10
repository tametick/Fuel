package parts;

import data.Registry;
import world.Actor;

class AiPart extends Part{
	public function new(actor:Actor) {
		this.actor = actor;
	}
	
	public function act() {	}
	
	public function canAttackPlayer():Bool {
		if (Registry.player.tileX==actor.tilePoint.x && Registry.player.tileY==actor.tilePoint.y) {
			return true;
		}
	
		if (actor.sprite.direction.horizontal) {
			if (Registry.player.tileX == actor.tilePoint.x + actor.sprite.direction.dx && Registry.player.tileY==actor.tilePoint.y) {
				return true;
			}
		}
		
		return false;
	}
	
	public function canWalkForward(?isOnlySideWays:Bool=true):Bool {
		var l = Registry.level;
		
		if (actor.sprite.direction.horizontal) {
			if (l.isWalkable(actor.tilePoint.x + actor.sprite.direction.dx, actor.tilePoint.y) && l.get(actor.tilePoint.x - 1, actor.tilePoint.y+1) == 1) {
				return true;
			}
		}
		
		return false;
	}
}