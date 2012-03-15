package states;

import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Linear;
import nme.text.TextField;
import org.flixel.FlxCamera;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxRect;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxU;
import org.flixel.plugin.photonstorm.FlxGridOverlay;
import data.Library;
import data.Registry;
import sprites.HudSprite;
import sprites.LightingSprite;
import world.Level;
import world.LevelFactory;

class GameState extends FlxState {
	public static var lightingLayer:LightingSprite;
	
	public static var hudLayer:HudSprite;
	var iceCounter:TextField;
	var monopoleCounter:TextField;
	
	override public function create() {
		Registry.gameState = this;
		
		Actuate.defaultEase = Linear.easeNone;
		
		newLevel();
		var tileMap = Registry.level.mapSprite;
		
		FlxG.camera.follow(Registry.player.sprite, FlxCamera.STYLE_TOPDOWN_TIGHT);
		FlxG.camera.setBounds(0, 0, tileMap.width, tileMap.height);
		
		hudLayer.init();
		iceCounter = hudLayer.newText("ice: 0", 0, 0, Registry.iceColor);
		monopoleCounter = hudLayer.newText("monopoles: 0",0, 8,Registry.monopoleColor);
		
		lightingLayer.visible = true;
		hudLayer.visible = true;
	}
	
	override public function destroy() {
		super.destroy();
		
		Registry.level = null;
		Registry.player = null;
		lightingLayer.visible = false;
		hudLayer.visible = false;
	}
	
	public function newLevel() {
		var currentLevel = 0;
		if (Registry.level != null) {
			currentLevel = Registry.level.index;
			Registry.level.levelOver();
		}
		
		currentLevel++;
		
		// remove old
		removeAllGameSprites();
		
		// add new
		Registry.level = LevelFactory.newLevel(currentLevel);
		addLevelSprites(Registry.level);
		
		Registry.player.sprite.revive();
		
		// draw fov around player's starting position
		Registry.level.updateFov(Registry.player.tilePoint);
	}
	
	function removeAllGameSprites() {
		for (sprite in members) {
			remove(sprite);
		}
	}
	
	function addLevelSprites(level:Level) {
		for (sprite in level.sprites) {
			add(sprite);
		}
		
		for (mob in level.mobs) {
			add(mob.sprite.suitBar);
			add(mob.sprite.beltBar);
			add(mob.sprite.gunBar);
		}
	}
	
	override public function draw():Void {
		super.draw();
		lightingLayer.updatePosition();
	}
	
	override public function update():Void {
		FlxG.worldBounds.x = Registry.player.sprite.x  - FlxG.width;
		FlxG.worldBounds.width = 2 * FlxG.width;
		FlxG.worldBounds.y = Registry.player.sprite.y  - FlxG.height;
		FlxG.worldBounds.height = 2 * FlxG.height;
		
		super.update();
	}
}