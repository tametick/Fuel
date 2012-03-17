package states;
import com.eclecticdesignstudio.motion.Actuate;
import data.Library;
import org.flixel.FlxG;
import org.flixel.FlxPoint;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import parts.StatsPart;
import sprites.HudSprite;
import utils.Utils;

class LevelEndState extends FlxState {
	var suit:FlxSprite;
	var belt:FlxSprite;
	var gun:FlxSprite;
	
	var suitFocus:FlxSprite;
	var beltFocus:FlxSprite;
	var gunFocus:FlxSprite;
	
	var suitClick:FlxSprite;
	var beltClick:FlxSprite;
	var gunClick:FlxSprite;

	override public function create():Void {
		FlxG.mouse.show();
	
		//tmp
		var stats = new StatsPart(null,{
			maxSuitCharge:1,
			maxGunCharge:1,
			maxBeltCharge:1,
			ice:5,
			monopoles:0
		});
				
		GameState.hudLayer.init();
		GameState.hudLayer.setIceCounter(stats.ice);
		GameState.hudLayer.setMonopoleCounter(stats.monopoles);
		
		GameState.hudLayer.visible = true;
		//end tmp
	
		suit = new FlxSprite(FlxG.width - 74, FlxG.height / 2 - 1.5 * 18);
		suitFocus = new FlxSprite(suit.x, suit.y);
		suitClick = new FlxSprite(suit.x, suit.y);
		belt = new FlxSprite(FlxG.width - 74, suit.y + 18);
		beltFocus = new FlxSprite(belt.x, belt.y);
		beltClick = new FlxSprite(belt.x, belt.y);
		gun = new FlxSprite(FlxG.width - 74, belt.y + 18);
		gunFocus = new FlxSprite(gun.x, gun.y);
		gunClick = new FlxSprite(gun.x, gun.y);
		
		suit.loadGraphic(Library.getFilename(SUIT_RECHARGE));
		belt.loadGraphic(Library.getFilename(BELT_RECHARGE));
		gun.loadGraphic(Library.getFilename(GUN_RECHARGE));
		
		suitFocus.loadGraphic(Library.getFilename(SUIT_RECHARGE_ONFOCUS),true,false,74,18);
		beltFocus.loadGraphic(Library.getFilename(BELT_RECHARGE_ONFOCUS),true,false,74,18);
		gunFocus.loadGraphic(Library.getFilename(GUN_RECHARGE_ONFOCUS),true,false,74,18);
		suitFocus.addAnimation("idle", Utils.range(0, 30), 20);
		beltFocus.addAnimation("idle", Utils.range(0, 30), 20);
		gunFocus.addAnimation("idle", Utils.range(0, 30), 20);
		
		suitClick.loadGraphic(Library.getFilename(SUIT_RECHARGE_CLICK),true,false,74,18);
		beltClick.loadGraphic(Library.getFilename(BELT_RECHARGE_CLICK),true,false,74,18);
		gunClick.loadGraphic(Library.getFilename(GUN_RECHARGE_CLICK),true,false,74,18);
		suitClick.addAnimation("idle", Utils.range(0, 17), 17, false);
		beltClick.addAnimation("idle", Utils.range(0, 17), 17, false);
		gunClick.addAnimation("idle", Utils.range(0, 17), 17, false);
		
		resetButtons();
		
		add(suit);
		add(belt);
		add(gun);
		add(suitFocus);
		add(suitClick);
		add(beltFocus);
		add(beltClick);
		add(gunFocus);
		add(gunClick);
		
		suitClick.visible = false;
		beltClick.visible = false;
		gunClick.visible = false;
		
		GameState.hudLayer.setSuitBarWidth(0.5);
		GameState.hudLayer.setBeltBarWidth(0.5);
		GameState.hudLayer.setGunBarWidth(0.5);
	}
	
	static private var _point = new FlxPoint();
	override public function update():Void {
		if (suit.overlapsPoint(FlxG.mouse)) {
			if(!suitFocus.visible && !suitClick.visible) {
				resetButtons();
				suit.visible = false;
				suitFocus.visible = true;
				suitFocus.play("idle",true);
			}
		} else if (belt.overlapsPoint(FlxG.mouse)) {
			if(!beltFocus.visible && !beltClick.visible) {
				resetButtons();
				belt.visible = false;
				beltFocus.visible = true;
				beltFocus.play("idle",true);
			}
		} else if (gun.overlapsPoint(FlxG.mouse)) {
			if(!gunFocus.visible && !gunClick.visible) {
				resetButtons();
				gun.visible = false;
				gunFocus.visible = true;
				gunFocus.play("idle",true);
			}
		}
		
		if (FlxG.mouse.justPressed()) {
			if (suitFocus.visible) {
				suitFocus.visible = false;
				suitClick.visible = true;
				suitClick.play("idle",true);
				Actuate.timer(1).onComplete(chrageSuit);
			} else if (beltFocus.visible) {
				beltFocus.visible = false;
				beltClick.visible = true;
				beltClick.play("idle",true);
				Actuate.timer(1).onComplete(chrageBelt);
			} else if (gunFocus.visible) {
				gunFocus.visible = false;
				gunClick.visible = true;
				gunClick.play("idle",true);
				Actuate.timer(1).onComplete(chrageGun);
			}
		}
		
		super.update();
	}
	
	function chrageSuit() {
		suitClick.visible = false;
		suit.visible = true;
		//GameState.hudLayer.setSuitBarWidth()
	}
	function chrageBelt() {
		beltClick.visible = false;
		belt.visible = true;
	}
	function chrageGun() {
		gunClick.visible = false;
		gun.visible = true;
	}
	
	override public function destroy():Void {
		super.destroy();
		
		FlxG.mouse.hide();
		
		suit.destroy();
		suitFocus.destroy();
		suitClick.destroy();
		belt.destroy();
		beltFocus.destroy();
		beltClick.destroy();
		gun.destroy();
		gunFocus.destroy();
		gunClick.destroy();
	}
	
	private inline function resetButtons() {
		suit.visible = true;
		belt.visible = true;
		gun.visible = true;
		suitFocus.visible = false;
		beltFocus.visible = false;
		gunFocus.visible = false;
	}
}