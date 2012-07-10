package parts;
import data.Registry;
import org.flixel.FlxU;
import utils.Direction;
import utils.Utils;

class FlyerAiPart extends AiPart {
	override public function act() {
		var p = Registry.player.tilePoint;
		var s = actor.sprite;
	
		var dist = FlxU.getDistance(actor.tilePoint, p);
		if (dist <= 1) {
			var d:Direction = null;
			if (p.x < actor.tilePoint.x) d = Direction.W;
			if (p.x > actor.tilePoint.x) d = Direction.E;
			if (p.y < actor.tilePoint.y) d = Direction.N;
			if (p.y > actor.tilePoint.y) d = Direction.S;
			
			actor.sprite.face(d);
			actor.sprite.startMoving();
			actor.weapon.fire();
		} else {
			var d = Utils.randomElement(Registry.level.getFreeNeighbors(actor.tilePoint));
			if(d != null)
				s.startMoving (d);
		}
	}
}