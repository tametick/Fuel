package parts;
import world.Actor;


class MineralNodeTriggerablePart extends TriggerablePart {
	public function new(actor:Actor) {
		this.actor = actor;
		super(false);
	}
	
	// shooting pops out ice crystal
	override public function onMechanism(source:Actor, agent:Actor) {
		// todo
		trace("pop ice");
	}
}