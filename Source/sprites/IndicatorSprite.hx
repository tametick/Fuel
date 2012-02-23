package sprites;
import data.Library;
import org.flixel.FlxSprite;


class IndicatorSprite extends FlxSprite {
	public function new() {
		super();
		loadGraphic(Library.getImage(ARROWS), true,false,8,8);
		addAnimation("N", [0]);
		addAnimation("S", [1]);
		addAnimation("W", [2]);
		addAnimation("E", [3]);
	}
}