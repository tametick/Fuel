package parts;
import data.Registry;
import world.Actor;

class CollectibleTriggerablePart extends TriggerablePart{

	public function new(actor:Actor) {
		this.actor = actor;
		super(false);
	}
	
	// collect ice crystal or monopole
	override public function onBump(agent:Actor) {
		if (agent == Registry.player) {
			if(actor.type == ICE) {
				agent.stats.ice++;
			} else if (actor.type == MONOPOLE) {
				agent.stats.monopoles++;
			} else {
				throw "Invalid collectible type: " + actor.type;
			}
		}
		Registry.level.removeActor(actor);
	}
}