package;
import aze.display.TileClip;
import aze.display.TileSprite;
import nape.geom.Vec2;
import nape.phys.Body;
import openfl.Assets;
import particles.ParticlesEm;

class RollerShip extends Enemy
{
	public function new(body:Body, lf:Int, vl:Int, erf:Float, flm:TileClip)
	{
		super(body, lf, vl, erf, flm);
		
		if (body.position.x > 500) velocity *= -1;
		
		body.group = Game.game.enemyGroup;
		randomFire = 0;
		
		if (Game.game.currentLevel > 9 && Game.game.currentLevel < 12) velocity = Math.round(velocity * 1.2);
		else if (Game.game.currentLevel >= 12) velocity = Math.round(velocity * 1.3);
		
		s_f = Game.game.air;
		
		flame.y = body.position.y - 5;
	}
	
	override function flamer() 
	{
		flame.x = body.position.x - 77 * Math.abs(velocity) / velocity;
	}
	
	override function destructionExposion() 
	{
		Game.game.bomber_e.emitStart(body.position.x, body.position.y, 7);
		super.destructionExposion();
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
		
		Game.game.playS(s_f);
		new RollerShell(new Vec2(body.position.x + 28 * cast(body.userData.graphic, TileSprite).scaleX, body.position.y + 34));
	}
}