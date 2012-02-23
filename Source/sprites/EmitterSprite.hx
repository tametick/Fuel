package sprites;

import org.flixel.FlxEmitter;
import org.flixel.FlxParticle;
import org.flixel.FlxPoint;

class EmitterSprite extends FlxEmitter {
	static var maxV = new FlxPoint(25, 25);
	public function new(color:Int, x:Int = 0, y:Int = 0, size:Int = 20) {
		super(x, y, size);
		
		gravity = 200;
		lifespan = 0.25;
		
		for (i in 0...size) {
			var particle:FlxParticle = new FlxParticle();
			particle.makeGraphic(1, 1, 0xFF000000 + color);
			particle.maxVelocity = maxV;
			add(particle);
		}
	}
}