package parts;

import data.Registry;
import world.Actor;

class ButtonTriggerablePart extends TriggerablePart {
	var isOff:Bool;
	public var target:Actor;

	public function new(actor:Actor) {
		super(false);
		isOff = true;
		this.actor = actor;
	}

	public override function onBump(agent:Actor) {
		// only the player triggers
		if (agent != Registry.player) {
			return;
		}
	
		// Only turn on once.
		if (!isOff) {
			return;
		}
		
		if (target != null && target.triggerable != null) {
			target.triggerable.onMechanism(actor, agent);
		}
		isOff = false;
	}
}