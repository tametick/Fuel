package data;

import nme.Assets;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.text.Font;

class Library {
	static var assets:Hash<Dynamic> = new Hash<Dynamic>();
	
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
	
	public static function getFilename(e:Dynamic):String {
		return Type.enumConstructor(e).toLowerCase();
	}
	
	static function getClassname(e:Dynamic):String {
		var n:String = Type.enumConstructor(e).toLowerCase();
		return "data."+n.charAt(0).toUpperCase() + n.substr(1);
	}
}

// images
enum Images {
	DOORS;
	DUNGEON;
	FLOOR;
	FURNITURE1;
	FURNITURE2;
	FURNITURE3;
	HEROES;
	HUMANS;
	ATTACKS;
	ARROWS;
	
	INTERLACE;
	MENU;
}
class DoorsImage extends LoadedBitmap { public function new() { super(DOORS); } }
class DungeonImage extends LoadedBitmap { public function new() { super(DUNGEON); } }
class FloorImage extends LoadedBitmap { public function new() { super(FLOOR); } }
class Furniture1Image extends LoadedBitmap { public function new() { super(FURNITURE1); } }
class Furniture2Image extends LoadedBitmap { public function new() { super(FURNITURE2); } }
class Furniture3Image extends LoadedBitmap { public function new() { super(FURNITURE3); } }
class HeroesImage extends LoadedBitmap { public function new() { super(HEROES); } }
class HumansImage extends LoadedBitmap { public function new() { super(HUMANS); } }
class AttacksImage extends LoadedBitmap { public function new() { super(ATTACKS); } }
class ArrowsImage extends LoadedBitmap { public function new() { super(ARROWS); } }