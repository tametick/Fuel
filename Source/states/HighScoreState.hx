package states;
import com.eclecticdesignstudio.motion.Actuate;
import data.Library;
import data.Registry;
import org.flixel.FlxG;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxText;
//import org.flixel.plugin.photonstorm.FlxSpecialFX;
//import org.flixel.plugin.photonstorm.fx.StarfieldFX;
import utils.Utils;

class HighScoreState extends FlxState {
	var bg:FlxSprite;
	//var starfield:StarfieldFX;
	//var stars:FlxSprite;

	override public function create():Void {
		GameState.lightingLayer.visible = false;
		GameState.hudLayer.visible = false;
		
		FlxG.fade(0, 1, true, null, true);
		FlxG.playMusic(Library.getMusic(VICTORY));
		
		//if (FlxG.getPlugin(FlxSpecialFX) == null) {
			//FlxG.addPlugin(new FlxSpecialFX());
		//}
			
		//starfield = FlxSpecialFX.starfield();
		//starfield.setStarSpeed( 0, 1);
		//stars = starfield.create(0, 0, FlxG.width, FlxG.height);
		//add(stars);

		
		bg = new FlxSprite(0, 0);
		bg.loadGraphic(Library.getFilename(SUCCESS), true, false, 240, 160);
		bg.addAnimation("idle", Utils.range(0, 2), 2);
		bg.play("idle");
		add(bg);
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
		
		//starfield.destroy();
		//stars.destroy();
		bg.destroy();
		
		Registry.player = null;
		Registry.gameState = null;
		Registry.level = null;
	}
}