package;
import aze.display.TileSprite;
import nape.geom.Vec2;
import nape.phys.Body;
import openfl.Assets;
import particles.ParticlesEm;

class RollerShip extends Enemy
{
	public function new(body)
	{
		super(body, 130, 200 + Std.random(120));
		
		if (body.position.x > 500) velocity *= -1;
		
		body.group = Game.game.enemyGroup;
		randomFire = 0;
		
		s_f = Game.game.air1;
	}
	
	override function fire() 
	{
		if (Game.game.cannon.body == null) return;
		if (body.position.x < 250 || body.position.x > 750)return;
		if (randomFire > 0)
		{
			randomFire--;
			return;
		}
		
		randomFire = 40 + Std.random(40);
		
		new RollerShell(new Vec2(body.position.x + 28 * cast(body.userData.graphic, TileSprite).scaleX, body.position.y + 34));
	}
}