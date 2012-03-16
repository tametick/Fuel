package parts;
import data.Registry;
import org.flixel.FlxU;

class FlyerAiPart extends AiPart {
	override public function act() {
		var p  = Registry.player.tilePoint;
	
		var dist = FlxU.getDistance(actor.tilePoint, p);
		if (dist <= 1) {
			if(p.x<actor.tilePoint.x)
				actor.sprite.faceLeft();
			if(p.x>actor.tilePoint.x)
				actor.sprite.faceRight();
			if(p.y<actor.tilePoint.y)
				actor.sprite.faceUp();
			if(p.y>actor.tilePoint.y)
				actor.sprite.faceDown();
			actor.weapon.fire();
		}
	}
}