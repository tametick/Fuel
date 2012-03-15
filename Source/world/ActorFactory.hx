package world;

import parts.ButtonTriggerablePart;
import parts.CollectibleTriggerablePart;
import parts.MineralNodeTriggerablePart;
import parts.SpikeTriggerablePart;
import sprites.ActorSprite;
import data.Registry;
import data.Library;
import parts.DoorTriggerablePart;
import parts.StatsPart;
import parts.TriggerablePart;
import parts.WeaponPart;
import utils.Utils;
import world.Actor;


class ActorFactory {
	public static function newActor(type:ActorType, ?x:Float=1, ?y:Float=1):Actor {
		var a = new Actor(type);
		var isImmovable = false;

		switch (type) {
			case SPACE_MINER:
				a.isPlayer = true;
				a.addPart(new StatsPart(a,{
					maxSuitCharge:1,
					maxGunCharge:1,
					maxBeltCharge:1,
					ice:0,
					monopoles:0
				}));
				a.addPart(WeaponFactory.newWeapon(a, LASER));
				a.addPart(new TriggerablePart(true));
				a.sprite = newSprite(a,CHARACTER,x,y);
				a.sprite.addAnimation("idle", [0, 1], 1);
				a.sprite.addAnimation("run", [2, 3], 10);
				a.sprite.addAnimation("shoot", [8, 9], 10, false);
				a.sprite.addAnimation("fly", [12, 13], 10);
				a.sprite.addAnimation("fall", [14, 15], 10);
				a.weapon.sprite.setPreFireCallback( function() { a.sprite.play("shoot", true); } );
				a.sprite.setColor(Registry.playerColor);


			// monsters
			case WALKER:
				a.addPart(new StatsPart(a,{
					maxSuitCharge:1,
				}));
				a.addPart(WeaponFactory.newWeapon(a, UNARMED));
				a.addPart(new TriggerablePart(true));
				a.sprite = newSprite(a,FLOOR_WALKER,x,y);
				a.sprite.addAnimation("idle", [0, 1,2], 10);
				a.sprite.addAnimation("run", [2, 3, 4], 10);
				a.sprite.setColor(Registry.walkerColor);
			
			case CLIMBER:
				throw "not yet implemented";
			case FLYER:
				throw "not yet implemented";
				
				
			// map features
			case CEILING_SPIKE:
				a.addPart(new SpikeTriggerablePart(a));
				a.sprite = newSprite(a, STALAGMITES, x, y);
				a.sprite.addAnimation("idle", [0]);
				a.sprite.addAnimation("falling", [1,2],4,false);
				a.sprite.setColor(Registry.floorColor);

			case FLOOR_SPIKE:
				a.addPart(new SpikeTriggerablePart(a));
				a.sprite = newSprite(a, STALAGMITES, x, y);
				a.sprite.addAnimation("idle", [3]);
				a.sprite.setColor(Registry.floorColor);
				
			case MINERAL:
				a.addPart(new MineralNodeTriggerablePart(a));
				a.sprite = newSprite(a, MINERAL_NODES, x, y);
				var n = Utils.randomInt(4)*41;
				a.sprite.addAnimation("idle", Utils.range(0+n,41+n),20);
				a.sprite.setColor(Registry.iceColor);
			
			case ENTRY_DOOR:
				a.addPart(new DoorTriggerablePart(a,false));
				a.sprite = newSprite(a, DOOR, x, y);
				a.sprite.addAnimation("close", [5,5,5, 4, 3, 2, 1, 0], 7,false);
				a.sprite.setColor(Registry.doorColor);
			
			case EXIT_DOOR:
				a.addPart(new DoorTriggerablePart(a,false));
				a.sprite = newSprite(a, DOOR, x, y);
				a.sprite.addAnimation("open", [0, 1, 2, 3, 4, 5], 7,false);
				a.sprite.setColor(Registry.doorColor);
				a.sprite.frame = 0;
				
			case TRIGGER:
				a.addPart(new ButtonTriggerablePart(a));
				a.sprite = newSprite(a, null, x, y);

			// collectibles
			case MONOPOLE:
				a.addPart(new CollectibleTriggerablePart(a));
				a.sprite = newSprite(a, MONOPOLE_PARTICLE, x, y);
				a.sprite.addAnimation("idle", Utils.range(0,10),20);
				a.sprite.setColor(Registry.monopoleColor);
				
			case ICE:
				a.addPart(new CollectibleTriggerablePart(a));
				a.sprite = newSprite(a, ICE_CRYSTAL, x, y);
				a.sprite.addAnimation("idle", Utils.range(0,41),20);
				a.sprite.setColor(Registry.iceColor);
		}
		if(a.stats!=null) {
			a.sprite.initBars();
		}
		a.sprite.play("idle");
		
		if(a.weapon!=null) {
			a.weapon.sprite.setParent(a.sprite, "x", "y",Std.int(Registry.tileSize/2-1), Std.int(Registry.tileSize/2-1));
		}

		if(a.stats != null) {
			a.stats.suitCharge = a.stats.maxSuitCharge;
			a.stats.gunCharge= a.stats.maxGunCharge;
			a.stats.beltCharge = a.stats.maxBeltCharge;
		}

		return a;
	}
	
	static function newSprite(a:Actor,sheet:Image, x:Float ,y:Float):ActorSprite {
		return new ActorSprite(a, sheet, x * Registry.tileSize, y * Registry.tileSize, a.isBlocking);
	}
}