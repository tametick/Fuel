package data;
import nme.Assets;
import nme.display.Bitmap;
import data.Library;

class LoadedBitmap extends Bitmap {	
	public function new(img:Images) { 
		super(Assets.getBitmapData("assets/" + Library.getFilename(img) + ".png"));
	}
}