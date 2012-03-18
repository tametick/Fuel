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
	
	public static function getMusic(s:Music):nme.media.Sound {
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
		} else if (Type.getEnum(i) == Music) {
			suffix = ".mp3";
		}
	
		return "assets/" + Type.enumConstructor(i).toLowerCase() + suffix;
	}
	
}

enum Image {
	CHARACTER;
	FLOOR_WALKER;
	WALL_CRAWLER;
	FLYER;
	LEVEL;
	STALAGMITES;
	MONOPOLE_PARTICLE;
	MINERAL_NODES;
	ICE_CRYSTAL;
	DOOR;
	
	HUD;
	TOPHUD;
	INTERLACE_SMALL;
	INTERLACE_BIG;
	LIFT;
	SPLASH;
	
	BELT_RECHARGE;
	BELT_RECHARGE_CLICK;
	BELT_RECHARGE_ONFOCUS;
	GUN_RECHARGE;
	GUN_RECHARGE_CLICK;
	GUN_RECHARGE_ONFOCUS;
	SUIT_RECHARGE;
	SUIT_RECHARGE_CLICK;
	SUIT_RECHARGE_ONFOCUS;
}

enum Sound {
	ERROR;
	SHOT;
	PICKUP_ICE;
	PICKUP_MONOPOLE;
	TOGGLE_BELT;
	
	WALKER_DEATH;
	CLIMBER_DEATH;
	FLYER_DEATH;
	DESTROY_WALL;
	DESTROY_MINERAL;
}

enum Music {
	GAMEPLAY;
	DEATH;
	RECHARGE;
	MENU;
}