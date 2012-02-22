package states;

import data.Library;
import nme.Lib;
import nme.text.TextField;
import org.flixel.FlxBasic;
import org.flixel.FlxGroup;
import org.flixel.FlxState;
import org.flixel.plugin.photonstorm.FlxGridOverlay;
import data.Registry;
import world.LevelFactory;

class GameState extends FlxState {
	var guiText:TextField;
	
	override public function create() {
		add(FlxGridOverlay.create(Std.int(Registry.tileSize/2), Std.int(Registry.tileSize/2)));
		
		newLevel();
		
		guiText = Registry.textLayer.newText("Welcome!",0,0);
		guiText.textColor = 0x408080;
	}
	
	override public function destroy() {
		super.destroy();
		Registry.textLayer.removeChild(guiText);
	}
	
	function newLevel() {
		Registry.level = LevelFactory.newLevel();
		var sprites = [Registry.level.mapSprite, 
					Registry.level.mapSprite.actorSprites, 
					Registry.level.mapSprite.itemSprites];

		for (sprite in sprites) {
			add(sprite);
			if (Std.is(sprite, FlxGroup)) {
				for(member in cast(sprite.members, Array<Dynamic>)) {
					member.x -= Registry.tileSize / 2;
					member.y -= Registry.tileSize / 2;
				}
			} else {
				sprite.x -= Registry.tileSize / 2;
				sprite.y -= Registry.tileSize / 2;
			}
		}
	}
}