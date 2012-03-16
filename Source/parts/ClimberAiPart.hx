package parts;
import data.Registry;
import org.flixel.FlxU;
import utils.Utils;

class ClimberAiPart extends AiPart{
	override public function act() {
		var p = Registry.player.tilePoint;
		var l = Registry.level;
		
		
		if (actor.isHung) {
			if (Utils.dist(p.x,actor.tileX)<2 &&
			  l.isInLos(p, actor.tilePoint, 10)) {
				
				actor.isHung = false;
				actor.sprite.play("idle");
			}
		} else {
		
		}
	}
}