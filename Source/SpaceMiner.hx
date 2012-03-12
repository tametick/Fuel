import nme.display.Bitmap;
import nme.Lib;
import nme.events.Event;
import nme.events.KeyboardEvent;
import org.flixel.FlxGame;
import sprites.LightingSprite;
import sprites.GuiSprite;
import states.CharSelectState;
import states.GameState;
import data.Registry;
import data.Library;
import world.Actor;


class SpaceMiner extends FlxGame {
	var removeMenu:Bool;
	public static function main () {
		Lib.current.addChild (new SpaceMiner());
		
		GameState.lightingLayer = new LightingSprite();
		Lib.current.addChild (GameState.lightingLayer);
		GameState.lightingLayer.visible = false;
		
		Registry.guiLayer = new GuiSprite();
		Lib.current.addChild (Registry.guiLayer);
		
		var interlace = new Bitmap(Library.getImage(INTERLACE));
		interlace.width = Lib.current.width;
		Lib.current.addChild(interlace);
	}

	public function new() {
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;
	
		#if flash
		removeMenu = true;
		// this is only for the projector, becuase of removing the window menu
		stageHeight += 20;
		Lib.current.stage.addEventListener(Event.RESIZE, resizeHandler,false,0,true);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, keyboardHandler, false, 0, true);
		resizeHandler(null);
		#end
		
		var ratioX:Float = stageWidth / Registry.screenWidth;
		var ratioY:Float = stageHeight / Registry.screenHeight;
		var ratio:Float = Math.min(ratioX, ratioY);
		
		if(Registry.debug) {
			CharSelectState.selectedHero = ARCHER;
			super(Math.floor(stageWidth / ratio), Math.floor(stageHeight / ratio), GameState, ratio, 60, 30);
			forceDebugger = true;
		} else {
			super(Math.floor(stageWidth / ratio), Math.floor(stageHeight / ratio), CharSelectState, ratio, 60, 30);
		}
	}
	
	function resizeHandler(event:Event) {
		if (removeMenu) {
			Lib.current.stage.showDefaultContextMenu = true;
			Lib.current.stage.showDefaultContextMenu = false;
		}
	}
	
	function keyboardHandler(event:KeyboardEvent) {
		switch (event.keyCode) {
			// F3
			case 114:
				if(removeMenu){
					Lib.current.stage.showDefaultContextMenu = true;
					Lib.current.stage.showDefaultContextMenu = true;
				} else {
					Lib.current.stage.showDefaultContextMenu = false;
				}
				removeMenu = !removeMenu;
		}
	}
}