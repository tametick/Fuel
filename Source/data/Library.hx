package data;

import nme.Assets;
import nme.media.Sound;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.text.Font;

class Library {
	static var assets:Hash<Dynamic> = new Hash<Dynamic>();
	
	public static function getImage(i:Image):BitmapData {
		// nme already caches images
		return Assets.getBitmapData(Library.getFilename(i));
	}
		
	public static function getFont():Font {
		var name = Registry.font;
		if (!assets.exists(name)){
			assets.set(name, Assets.getFont("assets/"+Registry.font+".ttf"));
		}
		return cast(assets.get(name), Font);
	}
	
	public static function getSound(s:Sound):nme.media.Sound {
		var name = Library.getFilename(s);
		if (!assets.exists(name)){
			assets.set(name, Assets.getSound(name));
		}
		return cast(assets.get(name), nme.media.Sound);
	}
		
	public static function getFilename(i:Dynamic):String {
		var suffix = "";
		if (Type.getEnum(i) == Image) {
			suffix = ".png";
		} else if (Type.getEnum(i) == Sound) {
			suffix = ".wav";
		}
	
		return "assets/" + Type.enumConstructor(i).toLowerCase() + suffix;
	}
	
}

enum Image {
	CHARACTER;
	FLOOR_WALKER;
	LEVEL;
	STALAGMITES;
	MONOPOLE_PARTICLE;
	MINERAL_NODES;
	ICE_CRYSTAL;
	DOOR;
	
	HUD;
	INTERLACE_SMALL;
	INTERLACE_BIG;
}

enum Sound {
	ERROR;
	SHOT;
}