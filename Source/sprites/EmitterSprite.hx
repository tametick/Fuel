package sprites;

import org.flixel.FlxEmitter;
import org.flixel.FlxObject;
import org.flixel.FlxParticle;
import org.flixel.FlxPoint;
import data.Registry;

class EmitterSprite extends FlxEmitter {
	static var maxV = Registry.particlesMaxVelocity;
	public function new(color:Int, x:Int = 0, y:Int = 0, size:Int = Registry.particlesPerEmitter) {
		super(x, y, size);
		
		gravity = Registry.particleGravity;
		lifespan = Registry.particleLifespan;
		
		initParticles(color, size);
	}
	
	function initParticles(color:Int, Quantity:Int):FlxEmitter{
		maxSize = Quantity;
		setRotation( -720, -720);
		var totalFrames:Int = 1;
		var particle:FlxParticle;
		var i:Int = 0;
		while (i < Quantity) {
			particle = new FlxParticle();
			particle.makeGraphic(1, 1, 0xFF000000+color);
			particle.allowCollisions = FlxObject.NONE;
			particle.exists = false;
			particle.maxVelocity = maxV;
			add(particle);
			particle.updateTileSheet();
			i++;
		}
		return this;
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