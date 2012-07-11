package states;
import com.eclecticdesignstudio.motion.Actuate;
import data.Library;
import org.flixel.FlxG;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxText;
import org.flixel.plugin.photonstorm.FlxSpecialFX;
import org.flixel.plugin.photonstorm.fx.StarfieldFX;

class MenuState extends FlxState {
	static var wasShownHelp:Bool;
	var starfield:StarfieldFX;
	var stars:FlxSprite;
	var bg:FlxSprite;
	var text:FlxText;

	override public function create():Void {
		FlxG.fade(0, 1, true, null, true);
		FlxG.playMusic(Library.getMusic(MENU));
		
		if (FlxG.getPlugin(FlxSpecialFX) == null) {
			FlxG.addPlugin(new FlxSpecialFX());
		}
			
		starfield = FlxSpecialFX.starfield();
		starfield.setStarSpeed( -0.5, 0);
		stars = starfield.create(0, 0, FlxG.width, FlxG.height);
		
		add(stars);
		
		bg = new FlxSprite();
		bg.loadGraphic(Library.getFilename(SPLASH));
		add(bg);
		
		var w = 70;
		text = new FlxText(FlxG.width/2-w/2, FlxG.height / 2 - 20, w, "Ctrl+Shift to Start");
		text.setFont(Library.getFont().fontName);
		add(text);
		
		toggleText();
	}
	
	function toggleText() {
		if (members == null)
			return;
		
		if (text.alpha == 0)
			text.alpha = 1;
		else
			text.alpha = 0;

		Actuate.timer(0.5).onComplete(toggleText);
	}
	
	override public function update():Void {
		super.update();
		
		if (FlxG.keys.CONTROL && FlxG.keys.SHIFT && active) {
			active = false;
			FlxG.fade(0);
			if (wasShownHelp) {
				Actuate.timer(1).onComplete(FlxG.switchState, [new GameState()]);
			} else {
				wasShownHelp = true;
				Actuate.timer(1).onComplete(FlxG.switchState, [new HelpState()]);
			}
		}
	}
	
	override public function destroy():Void {
		super.destroy();
		
		starfield.destroy();
		stars.destroy();
		bg.destroy();
		text.destroy();
	}
}