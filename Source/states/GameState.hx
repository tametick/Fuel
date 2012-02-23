package states;

import nme.Lib;
import nme.text.TextField;
import org.flixel.FlxGroup;
import org.flixel.FlxState;
import org.flixel.plugin.photonstorm.FlxGridOverlay;
import data.Library;
import data.Registry;
import world.Level;
import world.LevelFactory;

class GameState extends FlxState {
	var guiText:TextField;
	var currentLevel:Int;
	
	override public function create() {
		currentLevel = 0;
		guiText = Registry.textLayer.newText("",0,0);
		guiText.textColor = 0x408080;
		
		if (Registry.gameState != null) {
			Registry.gameState.destroy();
		}
		Registry.gameState = this;
		
		add(FlxGridOverlay.create(Std.int(Registry.tileSize/2), Std.int(Registry.tileSize/2), -1, -1, false, true, 0xff000000, 0xff5E5E5E));
		
		newLevel();
	}
	
	override public function destroy() {
		super.destroy();
		Registry.textLayer.removeChild(guiText);
	}
	
	public function newLevel() {
		currentLevel++;
		guiText.text = "Level " + currentLevel;
		
		if (Registry.level != null) {
			removeLevelSprites(Registry.level);
		}
		Registry.level = LevelFactory.newLevel();
		addLevelSprites(Registry.level);
	}
	
	function removeLevelSprites(level:Level) {
		for (sprite in level.sprites) {
			remove(sprite);
		}
	}
	
	function addLevelSprites(level:Level) {
		for (sprite in level.sprites) {
			add(sprite);
			
			// shift everything half a tile to up & the left,
			// because the map is 1 tile bigger than screen.
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