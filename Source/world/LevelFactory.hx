package world;

import org.flixel.FlxPath;
import org.flixel.FlxPoint;
import data.Registry;
import world.Actor;
import utils.Utils;

class LevelFactory {
	public static function newLevel():Level {
		var mazeGenerator = new MazeGenerator(Registry.levelWidth, Registry.levelHeight);
		mazeGenerator.initMaze();
		mazeGenerator.createMaze();
		
		var tilesIndex = [];
		for (y in 0...Registry.levelHeight) {
			for (x in 0...Registry.levelWidth) {
				tilesIndex.push(mazeGenerator.maze[x][y]?1:0);
			}
		}
		
		var level = new Level(tilesIndex);
		
		if (Registry.player == null) {
			Registry.player = level.player =  ActorFactory.newActor(GUARD);
		} else {
			level.player = Registry.player;
		}
		
		level.init();
		
		var startY:Int;
		do {
			startY = Utils.randomIntInRange(1, level.height - 2);
		} while (level.get(1, startY) == 1);
		
		level.start = new FlxPoint(1, startY);
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
		finish = null;
			
		level.finish = new FlxPoint(level.width - 2, yOfGreatestDist);	
		
		level.player.tileX = level.start.x;
		level.player.tileY = level.start.y;
		
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
		// add lever
		level.items.push(ActorFactory.newActor(LEVER_CLOSE, freeTile.x, freeTile.y));
		
		// add exit
		level.set(Std.int(level.finish.x + 1), Std.int(level.finish.y), 0);
		var exitDoor = ActorFactory.newActor(DOOR_CLOSE, level.finish.x + 1, level.finish.y);
		level.items.push(exitDoor);
		level.mapSprite.exitDoorSprite = exitDoor.sprite;
		
		// add closed entry door
		level.set(Std.int(level.start.x - 1), Std.int(level.start.y), 0);
		var entryDoor = ActorFactory.newActor(DOOR_CLOSE, level.start.x - 1, level.start.y);
		level.items.push(entryDoor);
		
		
		// add all actor sprites to map
		level.mapSprite.addAllActors();
		return level;
	}
}