import nme.display.Bitmap;
import nme.display.Sprite;
import nme.display.BitmapData;

class Preloader extends NMEPreloader {
	public function new() {
		var bg:Bitmap = new Bitmap(new Bg(120, 80));
		bg.width = 480;
		bg.height = 320;
		addChild(bg);
		super();
	}
}

@:bitmap("bg.png") class Bg extends flash.display.BitmapData {}