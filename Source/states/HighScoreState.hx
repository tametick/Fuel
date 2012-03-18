package states;
import com.eclecticdesignstudio.motion.Actuate;
import data.Library;
import data.Registry;
import org.flixel.FlxG;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxText;
import utils.Utils;

class HighScoreState extends FlxState {
	var bg:FlxSprite;
	var text1:FlxText;
	var text2:FlxText;

	override public function create():Void {
		GameState.lightingLayer.visible = false;
		GameState.hudLayer.visible = false;
		
		FlxG.fade(0, 1, true, null, true);
		FlxG.playMusic(Library.getMusic(VICTORY));
		
		bg = new FlxSprite(0, 0);
		bg.loadGraphic(Library.getFilename(END), true, false, 240, 160);
		bg.addAnimation("idle", Utils.range(0, 8), 8);
		bg.play("idle");
		add(bg);
		
		var dy = 32;
		var w = 150;
		text1 = new FlxText(110, 10, w, "Success!");
		text1.setFont(Library.getFont().fontName);
		text1.setSize(24);
		text1.setColor(0xffffffff);
		
		text2 = new FlxText(80, text1.y+dy, w, "After your long and arduous journey, you come back to the surface with your bounty of monopoles to fuel your ship.\n\nYou charge the depleted micro fusion drive and turn on the navigational computer.\n\nIt worked! The engine is fueled and ready to go. You set a course back to Ceres base and take off.");
		text2.setFont(Library.getFont().fontName);
		text2.setSize(8);
		text2.setColor(0xffffffff);
		
		add(text1);
		add(text2);
	}
	
	override public function update():Void {
		super.update();
		
		if (FlxG.keys.CONTROL && FlxG.keys.SHIFT && active) {
			active = false;
			FlxG.fade(0);
			Actuate.timer(1).onComplete(FlxG.switchState, [new MenuState()]);
		}
	}
	
	override public function destroy():Void {
		super.destroy();
		
		bg.destroy();
		text1.destroy();
		text2.destroy();
		
		Registry.player = null;
		Registry.gameState = null;
		Registry.level = null;
	}
}