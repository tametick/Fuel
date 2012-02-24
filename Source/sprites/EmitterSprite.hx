package sprites;

import org.flixel.FlxEmitter;
import org.flixel.FlxParticle;
import org.flixel.FlxPoint;
import data.Registry;

class EmitterSprite extends FlxEmitter {
	static var maxV = Registry.particlesMaxVelocity;
	public function new(color:Int, x:Int = 0, y:Int = 0, size:Int = Registry.particlesPerEmitter) {
		super(x, y, size);
		
		gravity = Registry.particleGravity;
		lifespan = Registry.particleLifespan;
		
		for (i in 0...size) {
			var particle:FlxParticle = new FlxParticle();
			particle.makeGraphic(1, 1, 0xFF000000 + color);
			particle.maxVelocity = maxV;
			add(particle);
		}
	}
	
	public function explode(pixelX:Float, pixelY:Float) {
		Registry.gameState.add(this);
		x = pixelX;
		y = pixelY;
		for(p in 0...maxSize) {
			emitParticle();
		}
	}
}