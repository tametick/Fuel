import data.Library;
import nme.Lib;
import org.flixel.FlxGame;
import sprites.TextLayer;
import states.GameState;
import data.Registry;

class Fungeon extends FlxGame {
	public static function main () {
		
		Lib.current.addChild (new Fungeon());
		
		Registry.textLayer = new TextLayer();
		Lib.current.addChild (Registry.textLayer);
		
		var interlace = Library.getBitmapData(INTERLACE);
		Lib.current.addChild(interlace);
	}

	public function new() {
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;
		var ratioX:Float = stageWidth / Registry.screenWidth;
		var ratioY:Float = stageHeight / Registry.screenHeight;
		var ratio:Float = Math.min(ratioX, ratioY);
		
		super(Math.floor(stageWidth / ratio), Math.floor(stageHeight / ratio), GameState, ratio, 60, 30);
		forceDebugger = true;
	}
}