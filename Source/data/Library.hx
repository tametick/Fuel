package data;

import nme.Assets;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.text.Font;

class Library {
	static var assets:Hash<Dynamic> = new Hash<Dynamic>();
	public static function getFilename(e:Dynamic):String {
		return Type.enumConstructor(e).toLowerCase();
	}
	
	static function getClassname(e:Dynamic):String {
		var n:String = Type.enumConstructor(e).toLowerCase();
		return "data."+n.charAt(0).toUpperCase() + n.substr(1);
	}

	public static function getImage(i:Images):Dynamic {
		var className = getClassname(i)+"Image";
		return Type.resolveClass(className);
	}
	
	public static function getBitmapData(i:Images):Bitmap {
		var name = getFilename(i);
		if (!assets.exists(name)){
			assets.set(name, new LoadedBitmap(i));
		}
		return cast(assets.get(name), Bitmap);
	}
	
	public static function getFont():Font {
		var name = Registry.font;
		if (!assets.exists(name)){
			assets.set(name, Assets.getFont("assets/"+Registry.font+".ttf"));
		}
		return cast(assets.get(name), Font);
	}
}

// images
enum Images {
	ACTORS;
	TILES;
	FURNITURE;
	
	SPLASH;
	INTERLACE;
}
class ActorsImage extends LoadedBitmap { public function new() { super(ACTORS); } }
class TilesImage extends LoadedBitmap { public function new() { super(TILES); } }
class FurnitureImage extends LoadedBitmap { public function new() { super(FURNITURE); } }