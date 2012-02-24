package sprites;

import data.Library;
import data.Registry;
import nme.display.Sprite;
import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFieldAutoSize;
import org.flixel.FlxCamera;

class TextSprite extends Sprite {
	public static var format:TextFormat;
	public function newText(text:String,x:Int,y:Int, color:Int):TextField {
		var txt = new TextField();
		var font = Library.getFont();
		
		if (format == null) {
			format = new TextFormat(font.fontName, Registry.fontSize, 0);
		}
		
		txt.width = Registry.screenWidth*FlxCamera.defaultZoom;
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
	
	public function clear() {
		while (numChildren > 0) {
			removeChildAt(0);
		}
	}
}