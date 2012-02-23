package data;

import org.flixel.FlxPoint;
import sprites.TextSprite;
import states.GameState;
import world.Actor;
import world.Level;

class Registry {
	public static inline var screenWidth = 96;
	public static inline var screenHeight = 64;
	public static inline var levelWidth = 13;
	public static inline var levelHeight = 9;
	public static inline var tileSize = 8;
	public static inline var fontSize = 32;
	
	public static inline var playerHitboxOffset = 2;

	public static inline var maxVelocity = new FlxPoint(50, 50);
	public static inline var drag = new FlxPoint(200, 200);
	public static inline var playerAcceleration = 10;
	public static inline var bulletSpeed = 50;
	public static inline var bulletsPerWeapon = 20;
	
	public static inline var rangeShort = 1;
	public static inline var rangeLong = 10;
	
	public static inline var particleLifespan = 0.25;
	public static inline var particleGravity = 200;
	public static inline var particlesPerEmitter = 20;
	public static inline var particlesMaxVelocity = new FlxPoint(25, 25);
	
	public static inline var explosionColor = 0xFFFFFF;
	
	
	public static inline var font = "eight2empire";
	public static var textLayer:TextSprite;
	
	public static var gameState:GameState;
	public static var level:Level;
	public static var player:Actor;
}