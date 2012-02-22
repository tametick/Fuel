package sprites;

import org.flixel.FlxG;
import org.flixel.FlxPoint;
import org.flixel.FlxSprite;
import org.flixel.FlxObject;
import data.Registry;
import data.Library;
import world.Actor;
import utils.Direction;


class ActorSprite extends FlxSprite {
	public var owner:Actor;
	public var direction:Direction;
	public var directionIndicator:IndicatorSprite;

	public function new(owner:Actor, image:Images, spriteIndex:Int, ?x:Float = 0, ?y:Float = 0, ?isImmovable:Bool = false) {
		super(x, y);
		this.owner = owner;
		if (owner.type == PLAYER) {
			directionIndicator = new IndicatorSprite();
		}
		
		maxVelocity = Registry.maxVelocity;
		drag = Registry.drag;
		
		
		loadGraphic(Library.getImage(image), true, true, 8, 8);
		addAnimation("idle", [spriteIndex]);
		play("idle");
		direction = W;
		
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
			// right/left facing is switched because flixel assumes the original sprites faced right
			if (FlxG.keys.RIGHT) {
				velocity.x += Registry.playerAcceleration;
				facing = FlxObject.LEFT;
				direction = E;
			}
			if (FlxG.keys.LEFT) {
				velocity.x -= Registry.playerAcceleration;
				facing = FlxObject.RIGHT;
				direction = W;
			}
			if (FlxG.keys.DOWN) {
				velocity.y += Registry.playerAcceleration;
				direction = S;
			}
			if (FlxG.keys.UP) {
				velocity.y -= Registry.playerAcceleration;
				direction = N;
			}
			if (FlxG.keys.SPACE) {
				
			}
			
			
			// show the attack direction
			switch (direction) {
				case N:
					directionIndicator.x = x;
					directionIndicator.y = y - Registry.tileSize;
				case E:
					directionIndicator.x = x + Registry.tileSize;
					directionIndicator.y = y;
				case S:
					directionIndicator.x = x;
					directionIndicator.y = y + Registry.tileSize;
				case W:
					directionIndicator.x = x - Registry.tileSize;
					directionIndicator.y = y;
			}
			
		} else {
			// enemy movement
		}
	}
}