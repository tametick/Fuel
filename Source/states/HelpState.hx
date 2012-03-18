package states;

import com.eclecticdesignstudio.motion.Actuate;
import data.Library;
import org.flixel.FlxG;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxText;
import utils.Utils;

class HelpState extends FlxState{
	var bg:FlxSprite;
	var text1:FlxText;
	var text2:FlxText;
	var text3:FlxText;

	override public function create():Void {
		FlxG.fade(0, 1, true, null, true);
		
		bg = new FlxSprite();
		bg.loadGraphic(Library.getFilename(HELP), true,false,FlxG.width, FlxG.height);
		bg.addAnimation("idle", Utils.range(1, 8), 8);
		add(bg);
		bg.play("idle");
		
		var dy = 40;
		var w = 140;
		text1 = new FlxText(100, 42-8, w, "Arrows to move. Also aims your gun while Ctrl is pressed.");
		text1.setFont(Library.getFont().fontName);
		text1.setColor(0);
		
		text2 = new FlxText(100, text1.y+dy, w, "Ctrl to shoot. Shoot mineral nodes to aquire ice crystals!");
		text2.setFont(Library.getFont().fontName);
		text2.setColor(0);
		
		text3 = new FlxText(100, text2.y+dy+10, w, "Shift to activate grav-belt.");
		text3.setFont(Library.getFont().fontName);
		text3.setColor(0);
		
		add(text1);
		add(text2);
		add(text3);
	}
	
	override public function update():Void {
		super.update();
		
		if (FlxG.keys.CONTROL && FlxG.keys.SHIFT && (FlxG.keys.justPressed("CONTROL") || FlxG.keys.justPressed("SHIFT")) && active) {
			active = false;
			FlxG.fade(0);
			Actuate.timer(1).onComplete(FlxG.switchState, [new GameState()]);
		}
	}
	
	override public function destroy():Void {
		super.destroy();
		
		bg.destroy();
		text1.destroy();
		text2.destroy();
		text3.destroy();
	}
}
	