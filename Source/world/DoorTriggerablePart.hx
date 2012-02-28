package world;

import data.Registry;

class DoorTriggerablePart extends TriggerablePart {
	var closedIndex:Int;
	var openIndex:Int;

	public function new(closedIndex:Int, openIndex:Int) {
		super(true);
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

	public override function onBump(agent:Actor) {
		if (agent == Registry.player && !isBlocking)
			Registry.gameState.newLevel();
	}
}