import nme.display.Bitmap;
import nme.display.Sprite;
import nme.display.BitmapData;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.geom.Rectangle;
import nme.Lib;
import nme.ui.Mouse;
import nme.events.Event;
import nme.events.KeyboardEvent;

class Preloader extends NMEPreloader {
	var removeMenu:Bool;

	public function new() {
		removeMenu = true;
		var w= 480;
		var h = 320;
		
		#if flash
		Lib.fscommand("showmenu", "false");
		Lib.fscommand("allowscale", "true");
		Lib.current.stage.showDefaultContextMenu = false;
		Lib.current.stage.fullScreenSourceRect = new Rectangle(0, 0, w, h);
		Lib.current.stage.color = 0;
		Lib.current.stage.addEventListener(Event.RESIZE, resizeHandler);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, keyboardHandler);
		#end
		Lib.current.stage.scaleMode = StageScaleMode.SHOW_ALL;
		Lib.current.stage.align = StageAlign.TOP;
		Mouse.hide();
		
		var bg:Bitmap = new Bitmap(new Bg(120, 80));
		bg.width = w;
		bg.height = h;
		addChild(bg);
		super();
	}
	
	function resizeHandler(event:Event) {
		if(removeMenu)
			Lib.fscommand("showmenu", "false");
	}
	
	function keyboardHandler(event:KeyboardEvent) {
		// F3
		if (event.keyCode == 114) {
			if(removeMenu)
				Lib.fscommand("showmenu", "true");
			else
				Lib.fscommand("showmenu", "false");
			removeMenu = !removeMenu;
		}
	}
}

@:bitmap("loading.png") class Bg extends BitmapData {}