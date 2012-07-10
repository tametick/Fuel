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
				
		face(Direction.E);
		
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
	
	public function startMoving(?d:Direction) {
		if (d == null) d = direction;
		
		var dx = d.dx;
		var dy = d.dy;
		
		if (!Registry.level.isWalkable(owner.tileX + dx, owner.tileY + dy)) {
			return;
		}
		
		if (d.dy == -1 && !owner.isFlying) {
			return;
		}
		
		isMoving = true;
		if (owner.isOnGround(dx, dy) && !owner.isFlying && alive) {
			play("run");
			
			if (owner == Registry.player) {
				owner.stats.beltCharge += Registry.beltChargeRate;
				owner.stats.beltCharge = Math.min(owner.stats.maxBeltCharge, owner.stats.beltCharge);
			}
		} else if(owner.stats !=null && owner.stats.beltCharge>0 && owner.isFlying && alive) {
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
		if (owner.isPlayer) {
			Registry.level.updateFov(new FlxPoint(nextTileX, nextTileY));
		}
	}
			
	override public function update() {
		if (FlxG.state != Registry.gameState)
			return;
				
		super.update();
		
		if(owner.weapon!=null) {
			owner.weapon.sprite.update();
		}
		
		if (owner == Registry.player) {
			actOnKeyboardInput();
		}
	}
	
	function actOnKeyboardInput() {
		if (!alive)
			return;
	
		if (!isMoving) {
			if (FlxG.mouse.justPressed()) {
				if (FlxG.mouse.x < x) startMoving(Direction.W);
				else startMoving(Direction.E);
			}
			if (!FlxG.keys.CONTROL) {
				for(moveKeys in Registry.movementKeys) {
					if (FlxG.keys.pressed(moveKeys[0])) {
						face(Direction.W);
						startMoving();
					} else if (FlxG.keys.pressed(moveKeys[1])) {
						face(Direction.E);
						startMoving();
					} else if (FlxG.keys.pressed(moveKeys[2])) {
						face(Direction.S);
						if (owner.isFlying) {
							startMoving();
						}
					} else if (FlxG.keys.pressed(moveKeys[3])) {
						face(Direction.N);
						if (owner.isFlying) {
							startMoving();
						}
					}
				}
			}
			for(beltKey in Registry.beltKey) {
				if (FlxG.keys.justPressed(beltKey[0])) {
					if (owner.isFlying) {
						owner.isFlying = false;
						if (!owner.isOnGround()) {
							fall();
						} else {
							if(alive) {
								play("idle");
							}
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
		}
		
		for(attackKey in Registry.attackKey) {
			if (FlxG.keys.justReleased(attackKey[0])) {
				owner.weapon.fire();
			}
		}

	}
	
	public function aquireOverlappingItems() {
		var mapSprite:MapSprite = Registry.level.mapSprite;
		
		FlxG.overlap(this, mapSprite.itemSprites, mapSprite.overlapItem);
	}
	
	public function fall() {
		falling++;
		play("fall");
		startMoving(Direction.S);
	}
	
	public function stopped() {
		// if you are dead but the corpse is still visible, let it fall to the ground
		if (!alive && exists) {
			if (!owner.isOnGround()) {
				fall();
				play("dying");
			}
			return;
		}
	
		// stuff to do right after the player too their turn
		if (Registry.player == owner) {
			// move enemies
			Registry.level.passTurn();
			
			// open exit door
			if (FlxU.getDistance(owner.tilePoint, Registry.level.exitDoor.tilePoint) <= 2)
				Registry.level.exitDoor.sprite.play("open");
		}
	
		// falling
		if (owner.isOnGround() && !owner.isFlying  && falling > 0) {
			// if you are ceiling spike, or the other is floor spike
			var deadlySpikes = (owner.type == CEILING_SPIKE);
			
			var actors = Registry.level.getActorAtPoint(owner.tilePoint.x, owner.tilePoint.y);
			
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
			
			if (owner.type != ActorType.CLIMBER) {
				if(falling >1)
					hurt(falling / 10);
			}
			falling = 0;
		}
	
		// flying
		if(owner.isOnGround() && !owner.isFlying) {
			if(alive) {
				play("idle");
			}
			isMoving = false;
		} else {
			isMoving = false;
			if(owner.stats !=null && owner.stats.beltCharge>0 && owner.isFlying) {
				play("fly");
				owner.stats.beltCharge-=Registry.beltDischargeRate;
			} else if (Registry.player == owner) {
				owner.isFlying = false;
				
				if(!owner.isOnGround()){
					fall();
				} else {
					if(alive) {
						play("idle");
					}
				}
			}
		}
		
		x = Utils.getPositionSnappedToGrid(x);
		y = Utils.getPositionSnappedToGrid(y);
		
		// get items
		aquireOverlappingItems();
	}
	
	public function face(d:Direction) {
		direction = d;
		facing = d.flxFacing;
		
		if(owner.weapon!=null) {
			weaponSprite.setBulletDirection(weaponSprite.getFacing(d), Math.round(Registry.bulletSpeed));
		}
	}
}
