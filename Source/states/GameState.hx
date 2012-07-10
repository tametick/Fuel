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
	public var isGoingToLevelEndScreen:Bool;
	public var isComingFromLevelEndScreen:Bool;
	
	
	override public function create() {
		FlxG.bgColor = 0xff100000;
		lightingLayer.visible = true;
		hudLayer.visible = true;
		isGoingToLevelEndScreen = false;

		Registry.gameState = this;
		Actuate.defaultEase = Linear.easeNone;
		
		if (isComingFromLevelEndScreen) {
			isComingFromLevelEndScreen = false;
			newLevel();
		}else {
			newLevel();
			hudLayer.init();
		}
		
		FlxG.camera.follow(Registry.player.sprite, FlxCamera.STYLE_TOPDOWN_TIGHT);
		var tileMap = Registry.level.mapSprite;
		FlxG.camera.setBounds(0, 0, tileMap.width, tileMap.height);
		FlxG.worldBounds.x = 0;
		FlxG.worldBounds.width = Registry.levelWidth * Registry.tileSize;
		FlxG.worldBounds.y = 0;
		FlxG.worldBounds.height = Registry.levelHeight * Registry.tileSize;
		
		FlxG.mouse.show();
	}
	
	override public function destroy() {
		if (isGoingToLevelEndScreen)
			return;
	
		super.destroy();
		
		Registry.level = null;
		Registry.player = null;
		lightingLayer.visible = false;
		hudLayer.visible = false;
	}
	
	public function newLevel() {
		isGoingToLevelEndScreen = false;
		FlxG.fade(0, 1, true,null,true);
	
		//if(!Registry.debug) {
			FlxG.playMusic(Library.getMusic(GAMEPLAY));
		//}
	
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
		
		Registry.level.entryDoor.sprite.play("close");
	}
	
	function removeAllGameSprites() {
		if(members!=null) {
			for (sprite in members) {
				remove(sprite);
			}
		}
	}
	
	function addLevelSprites(level:Level) {
		for (sprite in level.sprites) {
			add(sprite);
		}
		/*
		for (mob in level.mobs) {
			add(mob.sprite.suitBar);
			add(mob.sprite.beltBar);
			add(mob.sprite.gunBar);
		}*/
	}
	
	override public function draw():Void {
		if (members!=null) {
			super.draw();
			lightingLayer.updatePosition();
		} else {
			//...
		}
	}
	
	override public function update():Void {
	/*
		FlxG.worldBounds.x = Registry.player.sprite.x  - FlxG.width;
		FlxG.worldBounds.width = 2 * FlxG.width;
		FlxG.worldBounds.y = Registry.player.sprite.y  - FlxG.height;
		FlxG.worldBounds.height = 2 * FlxG.height;
		*/
		super.update();
	}
}