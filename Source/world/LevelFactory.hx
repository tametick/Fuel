package world;

import org.flixel.FlxPath;
import org.flixel.FlxPoint;
import data.Registry;
import parts.LeverTriggerablePart;
import states.CharSelectState;
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
			Registry.player = level.player =  ActorFactory.newActor(CharSelectState.selectedHero);
		} else {
			level.player = Registry.player;
		}
		
		level.init();
		
		setStart(level);
		level.player.tileX = level.start.x;
		level.player.tileY = level.start.y;
		level.finish = new FlxPoint(level.width - 2, getExitY(level));
		
		// Exit must be added before we add lever.
		addExit(level);
		addLever(level);
		addEntryDoor(level);
		
		for (e in 0...Registry.enemiesPerLevel) {
			addEnemy(level, SPEAR_DUDE);
		}
		
		// add all actor sprites to map
		level.mapSprite.addAllActors();
		
		return level;
	}
	
	static function addEnemy(level:Level, type:ActorType) {
		var freeTile = level.getFreeTile();
		level.enemies.push(ActorFactory.newActor(type, freeTile.x, freeTile.y));
	}
	
	static function addLever(level:Level) {
		// get a free tile that is distant from both the start and the finish points
		var freeTile:FlxPoint;
		var pathToStart:FlxPath;
		var pathToFinish:FlxPath;
		var minDist = Math.max(Registry.levelWidth, Registry.levelHeight);
		do {
			freeTile = level.getFreeTile();
			pathToStart = level.mapSprite.findTilePath(level.start, freeTile);
			pathToFinish = level.mapSprite.findTilePath(freeTile, level.finish);
		} while (pathToStart.nodes.length < minDist || pathToFinish.nodes.length < minDist);

		// Bind lever to exit door.
		// XXX: Hacky lookup for the exit door actor.
		var lever = ActorFactory.newActor(LEVER, freeTile.x, freeTile.y);
		cast(lever.triggerable, LeverTriggerablePart).target = level.mapSprite.exitDoorSprite.owner;
		level.items.push(lever);
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
}