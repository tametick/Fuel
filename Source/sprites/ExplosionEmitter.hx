package sprites;

import org.flixel.FlxEmitter;
import org.flixel.FlxParticle;
import org.flixel.FlxPoint;

class ExplosionEmitter extends FlxEmitter {
	static var maxV = new FlxPoint(25, 25);
	public function new(x:Int = 0, y:Int = 0, size:Int = 20) {
		super(x, y, size);
		
		gravity = 200;
		lifespan = 0.2;
		
		for (i in 0...size) {
			var particle:FlxParticle = new FlxParticle();
			particle.makeGraphic(1, 1, 0xFF000000 + 0xFFFFFF);
			particle.maxVelocity = maxV;
			add(particle);
		}
	}
}