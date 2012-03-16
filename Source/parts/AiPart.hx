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
	
		switch (actor.sprite.direction) {
			case W:
				if (Registry.player.tileX==actor.tilePoint.x - 1 && Registry.player.tileY==actor.tilePoint.y) {
					return true;
				}
			case E:
				if (Registry.player.tileX==actor.tilePoint.x + 1 && Registry.player.tileY==actor.tilePoint.y) {
					return true;
				}
				
			case N:
				if (actor.type == WALKER)
					throw "error!";
			case S:
				if (actor.type == WALKER)
					throw "error!";
		}
		return false;
	}
	
	public function canWalkForward(?isOnlySideWays:Bool=true):Bool {
		var l = Registry.level;
		switch (actor.sprite.direction) {
			case W:
				if (l.isWalkable(actor.tilePoint.x - 1, actor.tilePoint.y) && l.get(actor.tilePoint.x - 1, actor.tilePoint.y+1) == 1) {
					return true;
				}
			case E:
				if (l.isWalkable(actor.tilePoint.x + 1, actor.tilePoint.y) && l.get(actor.tilePoint.x + 1, actor.tilePoint.y+1) == 1) {
					return true;
				}
			
			case N:
				if (actor.type == WALKER)
					throw "error!";
			case S:
				if (actor.type == WALKER)
					throw "error!";
		}
		return false;
	}
}