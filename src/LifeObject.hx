package;
import nape.phys.Body;
import nape.geom.Vec2;
import aze.display.TileClip;
import openfl.Assets;
import particles.ParticlesEm;

class LifeObject extends ControlledObject
{
	public var life:Float;
	var offset:Vec2;
	
	public function new(life:Int, body:Body)
	{
		super(body);
		offset = body.userData.graphicOffset;
		this.life = life;
	}
	
	public function damage(force:Float)
	{
		if (body == null || force <= 0) return;
		
		life-= force;
		if (life <= 0)
		{
			life = 0;
			destruction();
		}
	}
	
	function frag()
	{
		if (body == null) return;
		var f = Game.game.fragments;
		if (f.length > 0) f[Std.random(f.length - 1)].init_(body.position);
	}
}