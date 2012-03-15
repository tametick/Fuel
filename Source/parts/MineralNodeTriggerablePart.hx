package parts;
import data.Registry;
import world.Actor;


class MineralNodeTriggerablePart extends TriggerablePart {
	public function new(actor:Actor) {
		this.actor = actor;
		super(false);
	}
	
	// shooting pops out ice crystal
	override public function onMechanism(source:Actor, agent:Actor) {
		Registry.level.addIceCrystal(actor.tilePoint.x, actor.tilePoint.y);
		actor.kill();
	}
}