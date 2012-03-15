package parts;

import data.Registry;
import world.Actor;

class ButtonTriggerablePart extends TriggerablePart {
	var isOff:Bool;
	public var target:Actor;

	public function new(actor:Actor, target:Actor) {
		super(false);
		isOff = true;
		this.actor = actor;
		this.target = target;
	}

	public override function onBump(agent:Actor) {
		// only the player triggers
		if (actor != Registry.player)
			return
	
		// Only turn on once.
		if (!isOff)
			return;
		
		if (target != null && target.triggerable != null) {
			target.triggerable.onMechanism(actor, agent);
		}
		isOff = false;
	}
}