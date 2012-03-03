package parts;

import world.Actor;

class TriggerablePart extends Part {
	public var isBlocking(default,null):Bool;

	public function onBump(agent:Actor) {
	}

	/*
	 * Source is the actor that is the immediate cause on the mechanism trigger,
	 * such as a lever, while agent is an intelligent actor that initiated the
	 * mechanism action.
	 */
	public function onMechanism(source:Actor, agent:Actor) {
	}

	public function new(isBlocking:Bool) {
		this.isBlocking = isBlocking;
	}
}