package world;

import org.flixel.FlxPath;
import org.flixel.FlxPoint;
import addons.FlxCaveGenerator;
import data.Registry;
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
		level.player.tileX = level.start.x-1;
		level.player.tileY = level.start.y;
		//level.finish = new FlxPoint(level.width - 2, getExitY(level));
		

		//addExit(level);
		
		addEntryDoor(level);
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
		} while (level.getActorAtPoint(freeTile.x - 1, freeTile.y) != null && level.getActorAtPoint(freeTile.x + 1, freeTile.y) != null);
		level.enemies.push(ActorFactory.newActor(type, freeTile.x, freeTile.y));
	}
	
	static function addSpike(level:Level, isFloor:Bool) {
		var freeTile = level.getFreeTileOnWall(isFloor);
		var type = isFloor?FLOOR_SPIKE:CEILING_SPIKE;
		level.enemies.push(ActorFactory.newActor(type, freeTile.x, freeTile.y));
	}
	
	static function addMineralNode(level:Level) {
		var freeTile = level.getFreeTileOnWall(true);
		level.enemies.push(ActorFactory.newActor(MINERAL, freeTile.x, freeTile.y));
	}
	
	static function addMonopole(level:Level) {
		var freeTile = level.getFreeTileOnWall(true);
		level.items.push(ActorFactory.newActor(MONOPOLE, freeTile.x, freeTile.y));
	}
		
	static private function addExit(level:Level) {
		level.set(level.finish.x + 1, level.finish.y, 0);
		//var exitDoor = ActorFactory.newActor(DOOR, level.finish.x + 1, level.finish.y);
		//level.items.push(exitDoor);
		//level.mapSprite.exitDoorSprite = exitDoor.sprite;
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
			} while (level.get(x, startY) == 1 && attempts < 10);
			
			// found a valid start point!
			if(level.get(x, startY) == 0)
				break;
		}
		level.start = new FlxPoint(startX, startY);
		
	}
	
	static private function getExitY(level:Level) {
		var greatestDist = 0;
		var yOfGreatestDist = 0;
		var finish = new FlxPoint(level.width-2, 0);
		for (y in 1...level.height - 1) {
			finish.y = y;
			var path = level.mapSprite.findTilePath(level.start, finish);
			if (path!=null && path.nodes.length>greatestDist) {
				greatestDist = path.nodes.length;
				yOfGreatestDist = y;
			}
		}
		return yOfGreatestDist;
	}
	
	static private function addEntryDoor(level:Level) {
		// add closed entry door
		level.set(level.start.x - 1, level.start.y, 0);
		//var entryDoor = ActorFactory.newActor(DOOR, level.start.x - 1, level.start.y);
		//level.items.push(entryDoor);
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