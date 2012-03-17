package parts;
import data.Library;
import data.Registry;
import org.flixel.FlxG;
import world.Actor;


class MineralNodeTriggerablePart extends TriggerablePart {
	public function new(actor:Actor) {
		this.actor = actor;
		super(false);
	}
	
	// shooting pops out ice crystal
	override public function onMechanism(source:Actor, agent:Actor) {
		FlxG.play(Library.getSound(DESTROY_MINERAL));
		Registry.level.addIceCrystal(actor.tilePoint.x, actor.tilePoint.y);
		actor.kill();
		
		// see if the player can get the crystal we just popped out
		Registry.player.sprite.aquireOverlappingItems();
	}
}