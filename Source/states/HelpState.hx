package states;

import com.eclecticdesignstudio.motion.Actuate;
import data.Library;
import nme.Assets;
import org.flixel.FlxG;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxText;
import utils.Utils;

class HelpState extends FlxState{
	var bg1:FlxSprite;
	var bg2:FlxSprite;

	override public function create():Void {
		FlxG.fade(0, 1, true, null, true);
		
		bg1 = new FlxSprite();
		bg1.loadGraphic("assets/help.png", true, false,  FlxG.width, FlxG.height);
		bg1.addAnimation("idle", Utils.range(1, 8), 8);
		add(bg1);
		bg1.play("idle");
		
		bg2 = new FlxSprite();
		bg2.loadGraphic("assets/help2.png", true, false, FlxG.width, FlxG.height);
		bg2.addAnimation("idle", Utils.range(1, 10), 8);
		add(bg2);
		bg2.play("idle");
		
		bg2.visible = false;
	}
	
	override public function update():Void {
		super.update();

		if (active) {
			if (FlxG.keys.CONTROL && FlxG.keys.SHIFT && (FlxG.keys.justPressed("CONTROL") || FlxG.keys.justPressed("SHIFT"))) {
				if (bg1.visible) {
					bg1.visible = false;
					bg2.visible = true;
				} else if (bg2.visible) {
					active = false;
					FlxG.fade(0);
					Actuate.timer(1).onComplete(FlxG.switchState, [new GameState()]);
				}
			}
		}
	}
	
	override public function destroy():Void {
		super.destroy();
		
		bg1.destroy();
	}
}
	