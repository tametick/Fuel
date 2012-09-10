import nme.display.Bitmap;
import nme.events.Event;
import nme.Lib;
import org.flixel.FlxG;
import org.flixel.FlxGame;
import sprites.HudSprite;
import sprites.LightingSprite;
import data.Registry;
import data.Library;
import states.GameState;
import states.HighScoreState;
import states.MenuState;


class SpaceMiner extends FlxGame {
	var removeMenu:Bool;
	public static function main () {
		Lib.current.addChild (new SpaceMiner());
		
		GameState.lightingLayer = new LightingSprite();
		Lib.current.addChild (GameState.lightingLayer);
		GameState.lightingLayer.visible = false;
		
		GameState.hudLayer= new HudSprite();
		Lib.current.addChild (GameState.hudLayer);
		GameState.hudLayer.visible = false;
				
		if(!Registry.debug) {
			var interlace:Bitmap = null;
			var w = Lib.current.width;
		}
	}

	public function new() {
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;
	
		#if flash
		if(Registry.noMenu) {
			removeMenu = true;
			// this is only for the projector, becuase of removing the window menu
			stageHeight += 20;
			Lib.current.stage.addEventListener(Event.RESIZE, resizeHandler, false, 0, true);
			resizeHandler(null);
		}
		#end
		
		var ratioX:Float = stageWidth / Registry.screenWidth;
		var ratioY:Float = stageHeight / Registry.screenHeight;
		var ratio:Float = Math.floor(Math.min(ratioX, ratioY) + .025);
		
		if (Registry.debug) {
			super(Registry.screenWidth, Registry.screenHeight, GameState, ratio);
		} else {
			super(Registry.screenWidth, Registry.screenHeight, MenuState, ratio);
		}
		
		if(Registry.debug) {
			forceDebugger = true;
		}
	}
	
	public static function restart() {
		Registry.gameState.destroy();
		if (Registry.debug) {
			FlxG.switchState(new GameState());
		} else {
			FlxG.switchState(new MenuState());
		}
	}
	
	public function resizeHandler(event:Event) {
		if (removeMenu && Registry.noMenu) {
			#if flash
			Lib.current.stage.showDefaultContextMenu = true;
			Lib.current.stage.showDefaultContextMenu = false;
			#end
		}
	}
	override private function update():Void {
		super.update();
		
		if (FlxG.keys.justPressed("F3") && Registry.noMenu) {
			#if flash
			if(removeMenu){
				Lib.current.stage.showDefaultContextMenu = true;
				Lib.current.stage.showDefaultContextMenu = true;
			} else {
				Lib.current.stage.showDefaultContextMenu = false;
			}
			#end
			removeMenu = !removeMenu;
		}
		
		if (Registry.debug && FlxG.keys.justPressed("N"))
			SpaceMiner.restart();
	}
}