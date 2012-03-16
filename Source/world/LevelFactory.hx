package world;

import org.flixel.FlxPath;
import org.flixel.FlxPoint;
import addons.FlxCaveGenerator;
import data.Registry;
import org.flixel.FlxU;
import parts.ButtonTriggerablePart;
import states.GameState;
import world.Actor;
import utils.Utils;
import world.generators.CellularAutomata;

class LevelFactory {
	public static function newLevel(index:Int):Level {
		var caveGenerator = new CellularAutomata(Registry.levelWidth, Registry.levelHeight);
		var mat = caveGenerator.getCaveMap();
		var tilesIndex = Utils.convertMatrixToArray(mat);
		
		var level = new Level(index, tilesIndex);
		
		if (Registry.player == null) {
			Registry.player = level.player =  ActorFactory.newActor(ActorType.SPACE_MINER);
		} else {
			level.player = Registry.player;
		}
		
		level.init();
		level.mapSprite.setColor(Registry.floorColor);
		
		setStart(level);
		setExit(level);
		level.player.tileX = level.start.x-1;
		level.player.tileY = level.start.y;
		
		level.entryDoor = addEntryDoor(level);
		level.exitDoor = addExitDoor(level);
		addEnemies(level);
		addSpikes(level);
		addMineralNodes(level);
		addMonopole(level);
		
		// add all actor sprites to map
		level.mapSprite.addAllActors();
		
		return level;
	}
	
	static function addEnemy(level:Level, type:ActorType) {
		var freeTile:FlxPoint;
		do {
			freeTile = level.getFreeTileOnWall(true);
		} while (level.getActorAtPoint(freeTile.x - 1, freeTile.y).length > 0 &&
				 level.getActorAtPoint(freeTile.x + 1, freeTile.y).length > 0 &&
				 FlxU.getDistance(freeTile, level.start) > 3
				);
		level.enemies.push(ActorFactory.newActor(type, freeTile.x, freeTile.y));
	}
	
	static function addSpike(level:Level, isFloor:Bool) {
		var freeTile = level.getFreeTileOnWall(isFloor);
		var type = isFloor?FLOOR_SPIKE:CEILING_SPIKE;
		var spike = ActorFactory.newActor(type, freeTile.x, freeTile.y);
		level.enemies.push(spike);
		
		// add falling trigger on the floor
		
		if (type == CEILING_SPIKE) {
			var floor = level.goDownTillFloor(freeTile);
			var trigger = ActorFactory.newActor(TRIGGER, floor.x, floor.y);
			level.items.push(trigger);
			cast(trigger.triggerable, ButtonTriggerablePart).target = spike;
		}
	}
	
	static function addMineralNode(level:Level) {
		var freeTile = level.getFreeTileOnWall(true);
		level.enemies.push(ActorFactory.newActor(MINERAL, freeTile.x, freeTile.y));
	}
	
	static function addMonopole(level:Level) {
		var freeTile = level.getFreeTileOnWall(true);
		level.items.push(ActorFactory.newActor(MONOPOLE, freeTile.x, freeTile.y));
	}
	
	static private function setStart(level:Level) {
		var startY = 1;
		var startX =1;
		for (x in 1...level.width - 1) {
			startX = x;
			var attempts = 0;
			do {
				startY = Utils.randomIntInRange(x, level.height - 2);
				attempts++;
			} while (level.get(x, startY) == 1 && level.get(x, startY+1) == 0 && attempts < level.height);
			
			// found a valid start point!
			if(level.get(x, startY) == 0)
				break;
		}
		level.start = new FlxPoint(startX, startY);
	}
	
	static private function setExit(level:Level) {
		var exitY = level.height - 2;
		var exitX = level.width - 1;
		
		var x = level.width - 1;
		while(x>1) {
			exitX = x;
			var attempts = 0;
			do {
				exitY = Utils.randomIntInRange(1, level.height - 1);
				attempts++;
			} while (level.get(exitX, exitY) == 1 && level.get(exitX, exitY+1) == 0 && attempts < level.height);
			
			// found a valid exit point!
			if(level.get(exitX, exitY) == 0)
				break;
				
			x--;
		}
		level.exit = new FlxPoint(exitX, exitY);
	}
	
	static private function addEntryDoor(level:Level) {
		level.set(level.start.x - 1, level.start.y, 0);
		level.set(level.start.x -1, level.start.y+1, 1);
		level.set(level.start.x, level.start.y+1, 1);
		var entryDoor = ActorFactory.newActor(ENTRY_DOOR, level.start.x - 1, level.start.y);
		level.items.push(entryDoor);
		return entryDoor;
	}
	
	static private function addExitDoor(level:Level) {
		level.set(level.exit.x + 1, level.exit.y, 0);
		level.set(level.exit.x +1, level.exit.y+1, 1);
		level.set(level.exit.x, level.exit.y+1, 1);
		var exitDoor = ActorFactory.newActor(EXIT_DOOR, level.exit.x + 1, level.exit.y);
		level.items.push(exitDoor);
		return exitDoor;
	}
	
	static function addEnemies(level:Level) {
		for (e in 0...Registry.enemiesPerLevel) {
			addEnemy(level, WALKER);
		}
	}
	static function addSpikes(level:Level) {
		for (s in 0...Registry.spikesPerLevel) {
			addSpike(level, Math.random()<0.4);
		}
	}
	static function addMineralNodes(level:Level) {
		for (s in 0...Registry.mineralNodesPerLevel) {
			addMineralNode(level);
		}
	}
	static function addMonopoles(level:Level) {
		if(Math.random()<Registry.monopoleChancePerLevel){
			addMonopole(level);
		}
	}
}