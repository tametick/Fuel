package world;

import org.flixel.FlxPath;
import org.flixel.FlxPoint;
import data.Registry;
import states.GameState;
import world.Actor;
import utils.Utils;

class LevelFactory {
	public static function newLevel(index:Int):Level {
		var mazeGenerator = new MazeGenerator(Registry.levelWidth, Registry.levelHeight);
		mazeGenerator.initMaze();
		mazeGenerator.createMaze();
		
		var tilesIndex = [];
		for (y in 0...Registry.levelHeight) {
			for (x in 0...Registry.levelWidth) {
				tilesIndex.push(mazeGenerator.maze[x][y]?1:0);
			}
		}
		
		var level = new Level(index, tilesIndex);
		
		if (Registry.player == null) {
			Registry.player = level.player =  ActorFactory.newActor(ActorType.ARCHER);
		} else {
			level.player = Registry.player;
		}
		
		level.init();
		
		setStart(level);
		level.player.tileX = level.start.x;
		level.player.tileY = level.start.y;
		level.finish = new FlxPoint(level.width - 2, getExitY(level));
		
		// exit must be added before we add lever.
		addExit(level);
		
		addEntryDoor(level);
		addEnemies(level);
		
		// add all actor sprites to map
		level.mapSprite.addAllActors();
		
		return level;
	}
	
	static function addEnemy(level:Level, type:ActorType) {
		var freeTile = level.getFreeTile();
		level.enemies.push(ActorFactory.newActor(type, freeTile.x, freeTile.y));
	}
		
	static private function addExit(level:Level) {
		level.set(level.finish.x + 1, level.finish.y, 0);
		var exitDoor = ActorFactory.newActor(DOOR, level.finish.x + 1, level.finish.y);
		level.items.push(exitDoor);
		level.mapSprite.exitDoorSprite = exitDoor.sprite;
	}
	
	static private function setStart(level:Level) {
		var startY:Int;
		do {
			startY = Utils.randomIntInRange(1, level.height - 2);
		} while (level.get(1, startY) == 1);
		
		level.start = new FlxPoint(1, startY);
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
		var entryDoor = ActorFactory.newActor(DOOR, level.start.x - 1, level.start.y);
		level.items.push(entryDoor);
	}
	
	static function addEnemies(level:Level) {
		for (e in 0...Registry.enemiesPerLevel) {
			addEnemy(level, SPEAR_DUDE);
		}
	}
}