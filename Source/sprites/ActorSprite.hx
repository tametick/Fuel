package sprites;

import com.eclecticdesignstudio.motion.Actuate;
import org.flixel.FlxU;
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
	
/*	public var suitBar:FlxBar;
	public var beltBar:FlxBar;
	public var gunBar:FlxBar;*/
	public var explosionEmitter:EmitterSprite;
	public var bloodEmitter:EmitterSprite;
	
	var isMoving:Bool;
	var falling:Int;
	var weaponSprite(getWeaponSprite, null):WeaponSprite;

	public function new(owner:Actor, image:Image, ?x:Float = 0, ?y:Float = 0, ?isImmovable:Bool = false) {
		super(x, y);

		this.owner = owner;
		if (image == null) {
			makeGraphic(Registry.tileSize, Registry.tileSize, 0);
		} else {
			loadGraphic(Library.getFilename(image), true, true, Registry.tileSize, Registry.tileSize);
		}
		updateTileSheet();

		if (isImmovable) {
			immovable = true;
		}
				
		faceRight();
		
		if (owner.stats != null) {
			explosionEmitter = new EmitterSprite(Registry.explosionColor);
			bloodEmitter = new EmitterSprite(Registry.bloodColor);
		} else {
			// todo - wall color
			bloodEmitter = new EmitterSprite(0x6c2d37);
		}
	}
	
	public function getSuitCharge():Float { return owner.stats.suitCharge; }
	public function getBeltCharge():Float { return owner.stats.beltCharge; }
	public function getGunCharge():Float { return owner.stats.gunCharge; }
	
	
/*	public function initBars() {
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
	}*/

	function getWeaponSprite():WeaponSprite {
		return owner.weapon.sprite;
	}
	
	override public function hurt(damage:Float):Void {
		if (owner.stats == null) {
			health -= damage;
		} else {
			// this updates health
			owner.stats.suitCharge -= damage;
		}
		
		if (health <= 0) {
			owner.kill();
		}
	}
	
	public function startMoving(dx:Int, dy:Int) {
		if (!alive)
			return;
	
		isMoving = true;
		if(owner.isOnGround(dx,dy) && !owner.isFlying ) {
			play("run");
			
			if (owner == Registry.player) {
				owner.stats.beltCharge += Registry.beltChargeRate;
				owner.stats.beltCharge = Math.min(owner.stats.maxBeltCharge, owner.stats.beltCharge);
			}
			
			if (falling > 0) {
				// if you are ceiling spike, or the other is floor spike
				var deadlySpikes = (owner.type == CEILING_SPIKE);
				
				var actors = Registry.level.getActorAtPoint(owner.tilePoint.x + dx, owner.tilePoint.y + dy);
				
				for (actor in actors) {
					if (actor == owner) {
						continue;
					}
					if (actor.type == FLOOR_SPIKE) {
						deadlySpikes = true;
					}
				}
				
				if (deadlySpikes) {
					for (actor in actors) {
						actor.sprite.hurt(1.0);
					}
					hurt(1.0);
				}
				
				hurt(falling / 10);
				falling = 0;
			}
		} else if(owner.stats !=null && owner.stats.beltCharge>0 && owner.isFlying) {
			play("fly");
		}
			
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
			Registry.level.passTurn();
		}
	}
			
	override public function update() {
		if (FlxG.state != Registry.gameState)
			return;
				
		super.update();
		
		if(owner.weapon!=null) {
			owner.weapon.sprite.setBulletBounds(FlxG.worldBounds);
			owner.weapon.sprite.update();
		}
		
		if (owner == Registry.player) {
			actOnKeyboardInput();
		}
	}
	
	function actOnKeyboardInput() {
		if (!alive)
			return;
	
		if(!isMoving) {
			if (FlxG.keys.pressed(Registry.movementKeys[0])) {
				faceRight();
				if(Registry.level.isWalkable(owner.tileX+1,owner.tileY) && !FlxG.keys.CONTROL) {
					startMoving(1,0);
				}
			} else if (FlxG.keys.pressed(Registry.movementKeys[1])) {
				faceLeft();
				if(Registry.level.isWalkable(owner.tileX-1,owner.tileY) && !FlxG.keys.CONTROL) {
					startMoving(-1,0);
				}
			} else if (FlxG.keys.pressed(Registry.movementKeys[2])) {
				faceDown();
				if(Registry.level.isWalkable(owner.tileX,owner.tileY+1)  && !FlxG.keys.CONTROL && owner.isFlying) {
					startMoving(0,1);
				}
			} else if (FlxG.keys.pressed(Registry.movementKeys[3])) {
				faceUp();
				if(Registry.level.isWalkable(owner.tileX,owner.tileY-1)  && !FlxG.keys.CONTROL && owner.isFlying) {
					startMoving(0,-1);
				}
			}
						
			if (FlxG.keys.justPressed(Registry.beltKey[0])) {
				if (owner.isFlying) {
					owner.isFlying = false;
					if (!owner.isOnGround()) {
						fall();
					} else {
						play("idle");
					}
				} else {
					if (owner.stats.beltCharge > 0) {
						owner.isFlying = true;
						play("fly");
					} else {
						FlxG.play(Library.getSound(ERROR));
					}
				}
			}
		}
		
		if (FlxG.keys.justReleased(Registry.attackKey[0])) {
			owner.weapon.fire();
		}
		

	}
	
	public function fall() {
		falling++;
		play("fall");
		startMoving(0, 1);
	}
	
	public function stopped() {
		if (!alive)
			return;
	
		// open exit door
		if (Registry.player == owner) {
			if (FlxU.getDistance(owner.tilePoint, Registry.level.exitDoor.tilePoint) <= 2)
				Registry.level.exitDoor.sprite.play("open");
		}
	
		if(owner.isOnGround() && !owner.isFlying) {
			play("idle");
			isMoving = false;
		} else {
			if(owner.stats !=null && owner.stats.beltCharge>0 && owner.isFlying) {
				play("fly");
				if(!Registry.debug) {
					owner.stats.beltCharge-=Registry.beltDischargeRate;
				}
				isMoving = false;
			} else if (Registry.player == owner) {
				owner.isFlying = false;
				fall();
			}
		}
		
		x = Utils.getPositionSnappedToGrid(x);
		y = Utils.getPositionSnappedToGrid(y);
		
		var mapSprite = Registry.level.mapSprite;
		
		FlxG.overlap(this, mapSprite.itemSprites, mapSprite.overlapItem);
	}
	
	public function faceRight() {
		facing = FlxObject.RIGHT;
		direction = E;
		if(owner.weapon!=null) {
			weaponSprite.setBulletDirection(WeaponSprite.RIGHT, Math.round(Registry.bulletSpeed));
		}
	}
	
	public function faceLeft() {
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