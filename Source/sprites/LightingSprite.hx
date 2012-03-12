package sprites;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.geom.Rectangle;
import org.flixel.FlxCamera;
import org.flixel.FlxG;
import data.Registry;
import utils.Utils;

class LightingSprite extends Bitmap {
	var darknessMap:Array<Int>;
	public function new() {
		super(new BitmapData(Registry.levelWidth, Registry.levelHeight, true, 0));
		darknessMap = [];
		for (i in 0...Registry.levelWidth*Registry.levelHeight) {
			darknessMap.push(0);
		}
		width = Registry.levelWidth * Registry.tileSize * FlxCamera.defaultZoom;
		height = Registry.levelHeight * Registry.tileSize * FlxCamera.defaultZoom;
		setDarkness(0xff);
	}
	
	public inline function updatePosition() {
		if (FlxG.camera == null)
			return;
		x = -FlxG.camera.scroll.x * FlxCamera.defaultZoom;
		y = -FlxG.camera.scroll.y * FlxCamera.defaultZoom;
	}
	
	/** set darkness between 0 (fully lighten) and 0xFF (fully dark) */
	public function setDarknessAtTile(x:Float, y:Float, darkness:Int) {
		Utils.set(darknessMap, Registry.levelWidth, x, y, darkness);
		bitmapData.setPixel32(Std.int(x), Std.int(y), darkness << 24);
	}
	
	public function getDarknessAtTile(x:Float, y:Float) {
		return Utils.get(darknessMap, Registry.levelWidth, x, y);
	}
	
	public function setDarkness(darkness:Int) {
		bitmapData.fillRect(new Rectangle(0, 0, Registry.levelWidth, Registry.levelHeight), darkness << 24);
		for (i in 0...Registry.levelWidth*Registry.levelHeight) {
			darknessMap[i] = darkness;
		}
	}
}