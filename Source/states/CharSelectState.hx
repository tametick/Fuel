package states;

import org.flixel.FlxG;
import org.flixel.FlxState;
import org.flixel.plugin.photonstorm.FlxGridOverlay;
import data.Registry;
import world.Actor;
import world.ActorFactory;

class CharSelectState extends FlxState {
	var heroes:Array<Actor>;
	var guard:Actor;
	var warrior:Actor;
	var archer:Actor;
	var monk:Actor;
	
	override public function create() {
		FlxG.mouse.show();
		
		add(FlxGridOverlay.create(Registry.tileSize, Registry.tileSize, -1, -1, false, true, 0xff000000, 0xff5E5E5E));
		
		guard = ActorFactory.newActor(GUARD, 2.5, 1);
		warrior = ActorFactory.newActor(WARRIOR, 4.5, 1);
		archer = ActorFactory.newActor(ARCHER, 6.5, 1);
		monk = ActorFactory.newActor(MONK, 8.5, 1);
		heroes = [guard, warrior, archer, monk];
		
		for (hero in heroes) {
			add(hero.sprite);
		}
		
	}
	
	override public function update():Void {
		super.update();
		
		if (FlxG.keys.justPressed("ONE")) {
			Registry.player = guard;
		} else if (FlxG.keys.justPressed("TWO")) {
			Registry.player = warrior;
		} else if (FlxG.keys.justPressed("THREE")) {
			Registry.player = archer;
		} else if (FlxG.keys.justPressed("FOUR")) {
			Registry.player = monk;
		} else if (FlxG.keys.justPressed("SPACE")) {
			FlxG.mouse.hide();
			if (Registry.gameState != null) {
				Registry.gameState.destroy();
			}
			FlxG.switchState(new GameState());
		}
	}
}