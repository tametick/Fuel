import nme.display.Bitmap;
import nme.display.Sprite;
import nme.display.BitmapData;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.geom.Rectangle;
import nme.Lib;


class Preloader extends NMEPreloader {
	public function new() {
		var w= 480;
		var h = 320;
		
		#if flash
		Lib.current.stage.showDefaultContextMenu = false;
		Lib.current.stage.fullScreenSourceRect = new Rectangle(0, 0, w, h);
		Lib.current.stage.color = 0;
		#end
		Lib.current.stage.scaleMode = StageScaleMode.SHOW_ALL;
		Lib.current.stage.align = StageAlign.TOP;
		
		var bg:Bitmap = new Bitmap(new Bg(120, 80));
		bg.width = w;
		bg.height = h;
		addChild(bg);
		super();
	}
}

@:bitmap("loading.png") class Bg extends BitmapData {}