package parts;
import data.Registry;
import world.Actor;

class SpikeTriggerablePart extends TriggerablePart{
	public function new(actor:Actor) {
		this.actor = actor;
		super(true);
	}
	
	// falling from ceiling
	override public function onMechanism(source:Actor, agent:Actor) {
		// remove your trigger
		if(source !=null) {
			Registry.level.removeActor(source);
		}
	
		// fall
		actor.sprite.play("falling");
		actor.sprite.fall();
	}
	
	override public function onBump(a:Actor) {
		a.sprite.bloodEmitter.explode(a.sprite.x+Registry.tileSize/2, a.sprite.y+Registry.tileSize/2);
		a.kill();
	}
}