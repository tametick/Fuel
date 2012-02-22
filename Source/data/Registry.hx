package data;

import org.flixel.FlxPoint;
import sprites.TextLayer;
import states.GameState;
import world.Actor;
import world.Level;

class Registry {
	public static inline var screenWidth = 96;
	public static inline var screenHeight = 64;
	public static inline var levelWidth = 13;
	public static inline var levelHeight = 9;
	public static inline var tileSize = 8;
	
	public static inline var playerHitboxOffset = 2;

	public static inline var maxVelocity = new FlxPoint(50, 50);
	public static inline var drag = new FlxPoint(200, 200);
	public static inline var playerAcceleration = 10;
	public static inline var bulletSpeed = 200;
	
	public static inline var font = "eight2empire";
	
	public static var textLayer:TextLayer;
	public static var gameState:GameState;
	
	public static var level:Level;
	public static var player:Actor;
}