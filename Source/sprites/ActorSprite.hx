package sprites;

import data.Library;
import org.flixel.FlxG;
import org.flixel.FlxPoint;
import org.flixel.FlxSprite;
import org.flixel.FlxObject;
import world.Actor;
import data.Registry;

class ActorSprite extends FlxSprite {
	public var owner:Actor;

	public function new(owner:Actor, image:Images, spriteIndex:Int, ?x:Float = 0, ?y:Float = 0, ?isImmovable:Bool = false) {
		super(x, y);
		this.owner = owner;
		
		maxVelocity = Registry.maxVelocity;
		drag = Registry.drag;
		
		
		loadGraphic(Library.getImage(image), true, false, 8, 8);
		addAnimation("idle", [spriteIndex]);
		play("idle");
		
		if (isImmovable)
			immovable = true;
		
		if (owner.type == PLAYER) {
			// make the player's hitbox a bit smaller to ease navigation
			width -= Registry.playerHitboxOffset;
			centerOffsets();
			height -= Registry.playerHitboxOffset;
			offset.y += Registry.playerHitboxOffset;
		}
	}
	
	override public function update() {
		super.update();
		
		if (owner == Registry.player) {
			// player movement
			if (FlxG.keys.RIGHT) {
				velocity.x += Registry.playerAcceleration;
			}
			if (FlxG.keys.LEFT) {
				velocity.x -= Registry.playerAcceleration;
			}
			if (FlxG.keys.DOWN) {
				velocity.y += Registry.playerAcceleration;
			}
			if (FlxG.keys.UP) {
				velocity.y -= Registry.playerAcceleration;
			}
		} else {
			// enemy movement
		}
	}
}