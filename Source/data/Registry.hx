package data;

import org.flixel.FlxPoint;
import states.GameState;
import world.Actor;
import world.Level;

class Registry {
	public static inline var debug = true;
	
	public static inline var movementKeys = ["RIGHT", "LEFT", "DOWN", "UP"];
	public static inline var attackKey = ["CONTROL"];
	public static inline var beltKey = ["SHIFT"];
	
	public static inline var enemiesPerLevel = 10;
	public static inline var spikesPerLevel = 10;
	public static inline var monopoleChancePerLevel = 1.0;
	public static inline var mineralNodesPerLevel = 5;
	
	public static inline var screenWidth = 240;
	public static inline var screenHeight = 160;
	public static inline var levelWidth = 19;
	public static inline var levelHeight = 19;
	public static inline var tileSize = 13;
	public static inline var fontSize = 32;

	public static inline var fovRange = 3;
	public static inline var walkingSpeed = 5;
	
	public static inline var bulletSpeed = 100;
	public static inline var bulletsPerWeapon = 10;
	
	public static inline var rangeShort = 1;
	public static inline var rangeLong = fovRange+2;
	
	public static inline var particleRotation = -720;
	public static inline var particleLifespan = 0.25;
	public static inline var particleGravity = 200;
	public static inline var particlesPerEmitter = 20;
	public static inline var particlesMaxVelocity = new FlxPoint(25, 25);
	
	public static inline var explosionColor = 0x6c2d37;
	public static inline var bloodColor = 0xFF0000;
	
	public static inline var playerColor = 0xb2d47d;
	public static inline var walkerColor = 0x808080;
	public static inline var floorColor = 0x6c2d37;
	
	public static inline var iceColor = 0xaac4ff;
	public static inline var monopoleColor = 0x7400b0;
	
	public static inline var font = "eight2empire";
	
	public static var gameState:GameState;
	public static var level:Level;
	public static var player:Actor;
}