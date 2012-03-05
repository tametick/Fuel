package sprites;

import org.flixel.FlxSprite;
import data.Registry;
import data.Library;

class AttackSprite extends FlxSprite {
	public function new() {
		super();
		loadGraphic(Library.getImage(ATTACKS), true, true, 8, 8);
		updateTileSheet();
		addAnimation("MELEE", [0, 1, 2, 3, 4, 5, 6, 24], 20, false);
		addAnimation("RANGED",[24], 10, false); // ranged attack look better without animations
		addAnimation("HIT", [11, 12, 13, 24], 20, false);
	}
	
	override public function play(animName:String, ?force:Bool = false):Void {
		Registry.gameState.add(this);
		super.play(animName, force);
	}
}