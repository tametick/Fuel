package sprites;
import data.Registry;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.geom.Rectangle;
import org.flixel.FlxCamera;


class LightingSprite extends Bitmap {
	public function new() {
		super(new BitmapData(Registry.levelWidth, Registry.levelHeight, true, 0));
		
		width = Registry.levelWidth * Registry.tileSize * FlxCamera.defaultZoom;
		height = Registry.levelHeight * Registry.tileSize * FlxCamera.defaultZoom;
		x = -Registry.tileSize * FlxCamera.defaultZoom / 2;
		y = -Registry.tileSize * FlxCamera.defaultZoom / 2;
	}
	
	/** set darkness between 0 (fully lighten) and 0xFF (fully dark) */
	public function setDarknessAtTile(x:Int, y:Int, darkness:Int) {
		bitmapData.setPixel32(x, y, 0x11000000*darkness);
	}
	
	public function setDarkness(darkness:Int) {
		bitmapData.fillRect(new Rectangle(0, 0, Registry.levelWidth, Registry.levelHeight), 0x11000000*darkness);
	}
}