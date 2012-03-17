package parts;

import data.Registry;
import org.flixel.FlxG;
import world.Actor;

class DoorTriggerablePart extends TriggerablePart {
	public function new(actor:Actor, isOpen:Bool) {
		this.actor = actor;
		super(isOpen);
	}

	// opening and closing
	public override function onMechanism(source:Actor, agent:Actor) {
		if (isBlocking) {
			isBlocking = false;
			actor.sprite.play("open");
		} else {
			isBlocking = true;
			actor.sprite.play("close");
		}
	}

	public override function onBump(agent:Actor) {
		if (agent == Registry.player && actor.type == EXIT_DOOR) {
			FlxG.fade(0, 1, false, Registry.gameState.newLevel);
		}
	}
}