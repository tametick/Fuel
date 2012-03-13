package data;

import nme.Assets;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.text.Font;

class Library {
	static var assets:Hash<Dynamic> = new Hash<Dynamic>();
	
	public static function getImage(i:Image):BitmapData {
		return Assets.getBitmapData(Library.getFilename(i));
	}
		
	public static function getFont():Font {
		var name = Registry.font;
		if (!assets.exists(name)){
			assets.set(name, Assets.getFont("assets/"+Registry.font+".ttf"));
		}
		return cast(assets.get(name), Font);
	}
		
	public static function getFilename(i:Image):String {
		return "assets/" + Type.enumConstructor(i).toLowerCase() + ".png";
	}
	
}

enum Image {
	CHARACTER;
	FLOOR_WALKER;
	LEVEL;
	
	INTERLACE_SMALL;
	INTERLACE_BIG;
}