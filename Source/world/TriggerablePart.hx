package world;


enum Trigger {
	Bump;
	Mechanism;
}


class TriggerablePart implements Part {
	public var actor:Actor;

	public function getKind():Kind {
		return Kind.Triggerable;
	}

	public var isBlocking(default,null):Bool;

	public function onBump(bumper:Actor) {
	}

	// Source is the actor that is the immediate cause on the mechanism trigger,
	// such as a lever, while agent is an intelligent actor that initiated the
	// mechanism action.
	public function onMechanism(source:Actor, agent:Actor) {
	}
}


class DoorTriggerablePart extends TriggerablePart {
	var closedIndex:Int;
	var openIndex:Int;

	public function new(closedIndex:Int, openIndex:Int, isClosed:Bool) {
		isBlocking = isClosed;
		this.closedIndex = closedIndex;
		this.openIndex = openIndex;
	}

	public override function onMechanism(source:Actor, agent:Actor) {
		var spriteIndex:Int;
		if (isBlocking) {
			isBlocking = false;
			spriteIndex = openIndex;
		} else {
			isBlocking = true;
			spriteIndex = closedIndex;
		}
		if (actor != null) {
			actor.sprite.setIndex(spriteIndex);
		}
	}
}