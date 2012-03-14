package parts;
import world.Actor;

class CollectibleTriggerablePart extends TriggerablePart{

	public function new() {
		super(false);
	}
	
	// collect ice crystal or monopole
	override public function onBump(agent:Actor) {
		// todo
	}
}