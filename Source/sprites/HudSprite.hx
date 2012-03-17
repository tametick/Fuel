package sprites;

import data.Registry;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.Sprite;
import nme.Lib;
import nme.text.TextField;
import nme.text.TextFormat;
import com.eclecticdesignstudio.motion.Actuate;
import org.flixel.FlxCamera;
import org.flixel.FlxG;
import data.Library;
import states.GameState;


class HudSprite extends Sprite {
	var suitBar:Bitmap;
	var beltBar:Bitmap;
	var gunBar:Bitmap;
	
	public var textLine:TextField;
	var iceCounter:TextField;
	var monopoleCounter:TextField;

	
	static var format:TextFormat;

	public function init() {
		var topHudBg = new Bitmap(Library.getImage(TOPHUD));
		topHudBg.width *= FlxCamera.defaultZoom;
		topHudBg.height *= FlxCamera.defaultZoom;
	
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
		
		setSuitBarWidth(1);
		setGunBarWidth(1);
		setBeltBarWidth(1);
		
		addChild(hudBg);
		addChild(topHudBg);
		
		//...
		
		textLine = newText("I am shit out of luck, looks like I'll die in this pit.", 5, 2, 0);
		iceCounter = newText("", 200, 2, 0);
		monopoleCounter = newText("", 222, 2, 0);
		setIceCounter(0);
		setMonopoleCounter(0);
	}

	public function newText(text:String,x:Float,y:Float, color:Int):TextField {
		var txt = new TextField();
		var font = Library.getFont();
		
		if (format == null) {
			format = new TextFormat(font.fontName, Registry.fontSize*FlxCamera.defaultZoom, 0);
		}
		
		txt.width = Lib.current.width;
		txt.embedFonts = true;
		txt.wordWrap = true;
		txt.defaultTextFormat = format;
		
		txt.text = text;
		txt.x = x * FlxCamera.defaultZoom;
		txt.y = y * FlxCamera.defaultZoom;
		txt.mouseEnabled = false;
		
		txt.textColor = color;
		
		addChild(txt);
		return txt;
	}
	
	public function setSuitBarWidth(w:Float) {
		var w = Std.int(w * 64 * FlxCamera.defaultZoom);
		var dw = Math.abs(suitBar.width - w);
		Actuate.tween(suitBar, dw/150, { width:w } );
	}
	public function setBeltBarWidth(w:Float) {
		var w = Std.int(w * 64 * FlxCamera.defaultZoom);
		var dw = Math.abs(beltBar.width - w);
		Actuate.tween(beltBar, dw/150, { width:w } );
	}
	public function setGunBarWidth(w:Float) {
		var w = Std.int(w * 64 * FlxCamera.defaultZoom);
		var dw = Math.abs(gunBar.width - w);
		Actuate.tween(gunBar, dw/150, { width:w } );
	}
	
	public function setIceCounter(i:Int) {
		iceCounter.text = "" + i;
	}
	public function setMonopoleCounter(m:Int) {
		monopoleCounter.text = "" + m;
	}
}