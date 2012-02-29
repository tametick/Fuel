package parts;

import world.Actor;

class LeverTriggerablePart extends TriggerablePart {
	var offIndex:Int;
	var onIndex:Int;
	var isOff:Bool;
	public var target:Actor;

	public function new(offIndex:Int, onIndex:Int, target:Actor) {
		super(false);
		isOff = true;
		this.offIndex = offIndex;
		this.onIndex = onIndex;
		this.target = target;
	}

	public override function onBump(agent:Actor) {
		// Only turn on once.
		if (!isOff)
			return;
		
		if (target != null && target.triggerable != null) {
			target.triggerable.onMechanism(this.actor, agent);
		}
		isOff = false;
		if (actor != null) {
			actor.sprite.frame = onIndex;
		}
	}
}