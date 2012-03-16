import nme.display.Bitmap;
import nme.events.Event;
import nme.Lib;
import org.flixel.FlxG;
import org.flixel.FlxGame;
import sprites.HudSprite;
import sprites.LightingSprite;
import states.GameState;
import data.Registry;
import data.Library;


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
/*			if(w<720)
				interlace = new Bitmap(Library.getImage(INTERLACE_SMALL));
			else
				interlace = new Bitmap(Library.getImage(INTERLACE_BIG));
			interlace.width = Lib.current.width;
			Lib.current.addChild(interlace);*/
		}
	}

	public function new() {
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;
	
		#if flash
		removeMenu = true;
		// this is only for the projector, becuase of removing the window menu
		stageHeight += 20;
		Lib.current.stage.addEventListener(Event.RESIZE, resizeHandler, false, 0, true);
		resizeHandler(null);
		#end
		
		var ratioX:Float = stageWidth / Registry.screenWidth;
		var ratioY:Float = stageHeight / Registry.screenHeight;
		var ratio:Float = Math.min(ratioX, ratioY);
		
		super(Math.floor(stageWidth / ratio), Math.floor(stageHeight / ratio), GameState, ratio);
		
		if(Registry.debug) {
			forceDebugger = true;
		}
	}
	
	public static function restart() {
		Registry.gameState.destroy();
		FlxG.switchState(new GameState());
	}
	
	public function resizeHandler(event:Event) {
		if (removeMenu) {
			Lib.current.stage.showDefaultContextMenu = true;
			Lib.current.stage.showDefaultContextMenu = false;
		}
	}
	override private function update():Void {
		super.update();
		
		if (FlxG.keys.justPressed("F3")) {
			if(removeMenu){
				Lib.current.stage.showDefaultContextMenu = true;
				Lib.current.stage.showDefaultContextMenu = true;
			} else {
				Lib.current.stage.showDefaultContextMenu = false;
			}
			removeMenu = !removeMenu;
		}
		
		if (Registry.debug && FlxG.keys.justPressed("N"))
			SpaceMiner.restart();
	}
}