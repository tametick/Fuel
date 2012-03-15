package sprites;
import data.Library;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.Sprite;
import org.flixel.FlxCamera;
import org.flixel.FlxG;

class HudSprite extends Sprite {
	var suitBar:Bitmap;
	var beltBar:Bitmap;
	var gunBar:Bitmap;

	public function init() {
		var hudBg = new Bitmap(Library.getImage(HUD));
		hudBg.width *= FlxCamera.defaultZoom;
		hudBg.height *= FlxCamera.defaultZoom;
		hudBg.y = FlxG.camera.height*FlxCamera.defaultZoom - hudBg.height;
		
		suitBar = new Bitmap(new BitmapData(1, Std.int(4*FlxCamera.defaultZoom), true, 0xFFD6122A));
		suitBar.x = hudBg.x + 13*FlxCamera.defaultZoom;
		suitBar.y = hudBg.y + 3*FlxCamera.defaultZoom;
		addChild(suitBar);
		
		beltBar = new Bitmap(new BitmapData(1, Std.int(4*FlxCamera.defaultZoom), true, 0xFF0B8FCD));
		beltBar.x = hudBg.x + 93*FlxCamera.defaultZoom;
		beltBar.y = hudBg.y + 3*FlxCamera.defaultZoom;
		addChild(beltBar);
		
		gunBar = new Bitmap(new BitmapData(1, Std.int(4*FlxCamera.defaultZoom), true, 0xFF32D01C));
		gunBar.x = hudBg.x + 173*FlxCamera.defaultZoom;
		gunBar.y = hudBg.y + 3*FlxCamera.defaultZoom;
		addChild(gunBar);
		
		setSuitBarWidth(64);
		setGunBarWidth(64);
		setBeltBarWidth(64);
		
		addChild(hudBg);
	}
	
	public function setSuitBarWidth(w) {
		suitBar.width = Std.int(w * FlxCamera.defaultZoom);
	}
	public function setBeltBarWidth(w) {
		beltBar.width = Std.int(w * FlxCamera.defaultZoom);
	}
	public function setGunBarWidth(w) {
		gunBar.width = Std.int(w * FlxCamera.defaultZoom);
	}
}