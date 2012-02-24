package states;

import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Linear;
import nme.Lib;
import nme.text.TextField;
import org.flixel.FlxCamera;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxState;
import org.flixel.plugin.photonstorm.FlxGridOverlay;
import data.Library;
import data.Registry;
import sprites.LightingSprite;
import world.Level;
import world.LevelFactory;

class GameState extends FlxState {
	public static var lightingLayer:LightingSprite;
	
	var guiText:TextField;
	var currentLevel:Int;
	
	override public function create() {
		currentLevel = 0;
		guiText = Registry.textLayer.newText("",0,0, 0x408080);
		Registry.gameState = this;
		
		Actuate.defaultEase = Linear.easeNone;
		
		add(FlxGridOverlay.create(Std.int(Registry.tileSize / 2), Std.int(Registry.tileSize / 2), -1, -1, false, true, 0xff000000, 0xff5E5E5E));
		newLevel();	
		
		lightingLayer.visible = true;
	}
	
	override public function destroy() {
		super.destroy();
		Registry.textLayer.removeChild(guiText);
		
		Registry.level = null;
		Registry.player = null;
		lightingLayer.visible = false;
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
		}
		// shift everything half a tile up & left,
		// because the map is 1 tile bigger than screen.
		FlxG.camera.scroll.y = FlxG.camera.scroll.x = Registry.tileSize / 2;
	}
}