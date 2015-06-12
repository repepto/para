package;
import aze.display.TileClip;
import aze.display.TileSprite;
import nape.geom.Vec2;
import nape.phys.Body;
import openfl.Assets;
import particles.ParticlesEm;

class EnemyBomber extends Enemy
{
	
	var time4attack:UInt;
	
	public function new(body:Body, life:Int, velocity:Int, randomFire:Float = .1, flame:TileClip = null)
	{
		super(body, life, velocity, 0, flame);
		time4attack = 30 + Math.round(Math.random() * 80);
		
		if (Game.game.currentLevel >= 6 && Game.game.currentLevel < 10) time4attack = Math.ceil(time4attack / 1.4);
		else if (Game.game.currentLevel >= 12) time4attack = Math.ceil(time4attack / 2);
		
		s_f = Game.game.air;
	}
	
	override function fire()
	{
		if (Game.game.cannon.body == null) return;
		if(Game.game.cannon.body == null || fireDelay > time4attack) return
		else if (fireDelay != time4attack && Math.abs(body.position.x - Game.game.cannon.body.position.x) > 80) 
		{
			fireDelay++;
			return;
		}
		
		new BombShell(new Vec2(body.position.x, body.position.y + 20));
		if (s_f != null) Game.game.playS(s_f);
		fireDelay = time4attack + 1;
	}
	
	override function frag() 
	{
		if (body == null) return;
		super.frag();
		
		if (Math.random() < .4) return;
		var f = Game.game.fragmentsFire;
		if (f.length > 0) f[Std.random(f.length - 1)].init_(body.position);
	}
	
	override function flamer() 
	{
		flame.x = body.position.x - 66 * Math.abs(velocity) / velocity;
		flame.y = body.position.y + 10;
	}
	
	
	override function destructionExposion() 
	{
		if (body == null) return;
		Game.game.explode(body.position.x, body.position.y, Game.game.layerAdd, "secondExpl_", 27, 3, Math.random() * Math.PI * 2, .5);
		Game.game.explode(body.position.x, body.position.y, Game.game.layer, "firstFog_", 25, 1, Math.random() * Math.PI * 2);
		Game.game.explode(body.position.x, body.position.y, Game.game.layerAdd, "firstExpl_", 25, 1, Math.random() * Math.PI * 2);
		Game.game.bomber_e.emitStart(body.position.x, body.position.y, 7);
	}
}