import nme.Lib;
import org.flixel.FlxGame;
import sprites.LightingSprite;
import sprites.TextSprite;
import states.CharSelectState;
import states.GameState;
import data.Registry;
import data.Library;
import world.Actor;


class Fungeon extends FlxGame {
	public static function main () {
		Lib.current.addChild (new Fungeon());
		
		GameState.lightingLayer = new LightingSprite();
		Lib.current.addChild (GameState.lightingLayer);
		GameState.lightingLayer.visible = false;
		
		Registry.textLayer = new TextSprite();
		Lib.current.addChild (Registry.textLayer);
		
		var interlace = Library.getBitmapData(INTERLACE);
		interlace.width = Lib.current.width;
		Lib.current.addChild(interlace);
	}

	public function new() {
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;
		var ratioX:Float = stageWidth / Registry.screenWidth;
		var ratioY:Float = stageHeight / Registry.screenHeight;
		var ratio:Float = Math.min(ratioX, ratioY);
		
		if(Registry.debug) {
			CharSelectState.selectedHero = GUARD;
			super(Math.floor(stageWidth / ratio), Math.floor(stageHeight / ratio), GameState, ratio, 60, 30);
			forceDebugger = true;
		} else {
			super(Math.floor(stageWidth / ratio), Math.floor(stageHeight / ratio), CharSelectState, ratio, 60, 30);
		}
		
	}
}