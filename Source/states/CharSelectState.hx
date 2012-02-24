package states;

import nme.text.TextField;
import org.flixel.FlxG;
import org.flixel.FlxState;
import org.flixel.plugin.photonstorm.FlxGridOverlay;
import data.Registry;
import world.Actor;
import world.ActorFactory;

class CharSelectState extends FlxState {
	var heroes:Array<Actor>;
	static var description:TextField;
	public static var selectedHero(default, selectHero):ActorType;
	
	override public function create() {
		FlxG.mouse.show();
		
		add(FlxGridOverlay.create(Registry.tileSize, Registry.tileSize, -1, -1, false, true, 0xff000000, 0xff5E5E5E));
		description = Registry.textLayer.newText("", Registry.tileSize*2.5,Registry.tileSize*5, 0xFFFF00);
		
		selectedHero = GUARD;
		
		var guard = ActorFactory.newActor(GUARD, 2.5, 1);
		var warrior = ActorFactory.newActor(WARRIOR, 4.5, 1);
		var archer = ActorFactory.newActor(ARCHER, 6.5, 1);
		var monk = ActorFactory.newActor(MONK, 8.5, 1);
		heroes = [guard, warrior, archer, monk];
		
		for (hero in heroes) {
			add(hero.sprite);
		}
	}
	
	override public function destroy():Void {
		Registry.textLayer.removeChild(description);
		description = null;
		for (hero in heroes) {
			remove(hero.sprite);
		}
		heroes = null;
		
		super.destroy();
	}
	
	static function selectHero(type:ActorType):ActorType {
		selectedHero = type;
		description.text = Type.enumConstructor(type);
		return type;
	}
	
	override public function update():Void {
		super.update();
		
		if (FlxG.keys.justPressed("ONE")) {
			selectedHero = heroes[0].type;
		} else if (FlxG.keys.justPressed("TWO")) {
			selectedHero = heroes[1].type;
		} else if (FlxG.keys.justPressed("THREE")) {
			selectedHero = heroes[2].type;
		} else if (FlxG.keys.justPressed("FOUR")) {
			selectedHero = heroes[3].type;
		} else if (FlxG.keys.justPressed("SPACE")) {
			FlxG.mouse.hide();
			if (Registry.gameState != null) {
				Registry.gameState.destroy();
			}
			FlxG.switchState(new GameState());
		}
	}
}