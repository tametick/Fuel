package sprites;

import com.eclecticdesignstudio.motion.Actuate;
import org.flixel.plugin.photonstorm.FlxBar;
import org.flixel.FlxG;
import org.flixel.FlxPoint;
import org.flixel.FlxSprite;
import org.flixel.FlxObject;
import data.Registry;
import data.Library;
import utils.Direction;
import utils.Utils;
import world.Actor;
import parts.WeaponPart;

class ActorSprite extends FlxSprite {
	public var owner:Actor;
	public var direction:Direction;
	
	public var suitBar:FlxBar;
	public var beltBar:FlxBar;
	public var gunBar:FlxBar;
	public var explosionEmitter:EmitterSprite;
	public var bloodEmitter:EmitterSprite;
	
	var isMoving:Bool;
	var weaponSprite(getWeaponSprite, null):WeaponSprite;

	public function new(owner:Actor, image:Image, ?x:Float = 0, ?y:Float = 0, ?isImmovable:Bool = false) {
		super(x, y);

		this.owner = owner;
		loadGraphic(Library.getFilename(image), true, true, Registry.tileSize, Registry.tileSize);
		updateTileSheet();

		if (isImmovable) {
			immovable = true;
		}
				
		faceRight();
		
		if (owner.stats != null) {
			explosionEmitter = new EmitterSprite(Registry.explosionColor);
			bloodEmitter = new EmitterSprite(Registry.bloodColor);
		}
	}
	
	public function getSuitCharge():Float { return owner.stats.suitCharge; }
	public function getBeltCharge():Float { return owner.stats.beltCharge; }
	public function getGunCharge():Float { return owner.stats.gunCharge; }
	
	
	public function initBars() {
		if (owner.stats.maxSuitCharge > 0) {
			suitBar = new FlxBar(0, 0, FlxBar.FILL_LEFT_TO_RIGHT, Registry.tileSize-1, 1, this, getSuitCharge);
			suitBar.createFilledBar(0xff005100, 0xff00F400);
			suitBar.trackParent(0, Registry.tileSize-1);
			suitBar.setRange(0, owner.stats.maxSuitCharge);
			suitBar.killOnEmpty = true;
			suitBar.updateTileSheet();
			suitBar.alpha = 0.5;
		}
		
		if (owner.stats.maxBeltCharge> 0) {
			beltBar = new FlxBar(0, 0, FlxBar.FILL_LEFT_TO_RIGHT, Registry.tileSize-1, 1, this, getBeltCharge);
			beltBar.createFilledBar(0xff000051, 0xff0000F4);
			beltBar.trackParent(0, Registry.tileSize-2);
			beltBar.setRange(0, owner.stats.maxBeltCharge);
			beltBar.updateTileSheet();
			beltBar.alpha = 0.5;
		}
		
		if (owner.stats.maxGunCharge > 0) {
			gunBar = new FlxBar(0, 0, FlxBar.FILL_LEFT_TO_RIGHT, Registry.tileSize-1, 1, this, getGunCharge);
			gunBar.createFilledBar(0xff510000, 0xffF40000);
			gunBar.trackParent(0, Registry.tileSize-3);
			gunBar.setRange(0, owner.stats.maxGunCharge);
			gunBar.updateTileSheet();
			gunBar.alpha = 0.5;
		}
	}

	function getWeaponSprite():WeaponSprite {
		return owner.weapon.sprite;
	}
	
	
	function startMoving(dx:Int, dy:Int) {
		isMoving = true;
		if(owner.isOnGround(dx,dy) || owner.stats.beltCharge<=0)
			play("run");
		else
			play("fly");
			
		var duration = 1 / (Registry.walkingSpeed);
		var nextPixelX = Utils.getPositionSnappedToGrid(this.x + dx * Registry.tileSize);
		var nextPixelY = Utils.getPositionSnappedToGrid(this.y + dy * Registry.tileSize);
		var nextTileX = nextPixelX / Registry.tileSize;
		var nextTileY = nextPixelY / Registry.tileSize;
		
		// move
		Actuate.tween(this, duration, {x: nextPixelX, y: nextPixelY}).onComplete(stopped);
		// update fov
		if(owner.isPlayer) {
			Registry.level.updateFov(new FlxPoint(nextTileX, nextTileY));
		}
	}
			
	override public function update() {
		if (FlxG.state != Registry.gameState)
			return;
				
		super.update();
		
		if(owner.weapon!=null) {
			owner.weapon.sprite.setBulletBounds(FlxG.worldBounds);
		}
		
		if (owner == Registry.player) {
			
			if(!isMoving) {
				if (FlxG.keys.pressed(Registry.movementKeys[0])) {
					faceRight();
					if(Registry.level.isWalkable(owner.tileX+1,owner.tileY)) {
						startMoving(1,0);
					}
				} else if (FlxG.keys.pressed(Registry.movementKeys[1])) {
					faceLeft();
					if(Registry.level.isWalkable(owner.tileX-1,owner.tileY)) {
						startMoving(-1,0);
					}
				} else if (FlxG.keys.pressed(Registry.movementKeys[2])) {
					faceDown();
					if(Registry.level.isWalkable(owner.tileX,owner.tileY+1)) {
						startMoving(0,1);
					}
				} else if (FlxG.keys.pressed(Registry.movementKeys[3])) {
					faceUp();
					if(Registry.level.isWalkable(owner.tileX,owner.tileY-1)) {
						startMoving(0,-1);
					}
				}
			}
			
			if (FlxG.keys.justPressed(Registry.attackKey[0])) {
				owner.weapon.fire();
			}
			
		} else {
			// enemy movement
		}
	}
	
	public function stopped() {
		if(owner.isOnGround()) {
			play("idle");
		} else {
			if(owner.stats.beltCharge>0) {
				play("fly");
				owner.stats.beltCharge-= 0.1;
			} else {
				play("fall");
			}
		}
		
		isMoving = false;
		x = Utils.getPositionSnappedToGrid(x);
		y = Utils.getPositionSnappedToGrid(y);
		
		var mapSprite = Registry.level.mapSprite;
		FlxG.overlap(this, mapSprite.itemSprites, mapSprite.overlapItem);
	}
	
	function faceRight() {
		facing = FlxObject.RIGHT;
		direction = E;
		if(owner.weapon!=null) {
			weaponSprite.setBulletDirection(WeaponSprite.RIGHT, Math.round(Registry.bulletSpeed));
		}
	}
	
	function faceLeft() {
		facing = FlxObject.LEFT;
		direction = W;
		if (owner.weapon != null) {
			weaponSprite.setBulletDirection(WeaponSprite.LEFT, Math.round(Registry.bulletSpeed));
		}
	}
	
	function faceDown()	{
		direction = S;
		if (owner.weapon != null) {
			weaponSprite.setBulletDirection(WeaponSprite.DOWN, Math.round(Registry.bulletSpeed));
		}
	}
	
	function faceUp() {
		direction = N;
		if (owner.weapon != null) {
			weaponSprite.setBulletDirection(WeaponSprite.UP, Math.round(Registry.bulletSpeed));
		}
	}
}