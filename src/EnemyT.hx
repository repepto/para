package;
import aze.display.TileClip;
import aze.display.TileSprite;
import motion.Actuate;
import mut.Mut;
import nape.geom.Vec2;
import nape.phys.Body;
import openfl.Assets;
import particles.ParticlesEm;

class EnemyT extends Enemy
{
	var targetPos:Vec2;
	var nextJump:UInt = 0;
	
	public function new(body)
	{
		super(body, 400);
		
		body.group = Game.game.enemyGroup;
		randomFire = 30;
		
		targetPos = new Vec2();
		
		body.gravMass = 0;
		
		s_f = Game.game.air4;
	}
	
	override function destructionExposion() 
	{
		Game.game.bomber_e.emitStart(body.position.x, body.position.y, 7);
		super.destructionExposion();
	}
	
	override function controll() 
	{
		if (body == null || Game.game.cannon.body == null) return;
		
		if (nextJump == 0)
		{
			Game.game.playS(Game.game.ufom);
			
			do
			{
				targetPos.x = 70 + Math.random() * 870;
				targetPos.y = 40 + Math.random() * 330;
			}
			while (Mut.dist(targetPos.x, targetPos.y, body.position.x, body.position.y) < 300 || Game.game.space.bodiesInCircle(targetPos, 140).length == 1);
			
			nextJump = Game.game.jumpTime + Std.random(Game.game.jumpTime);
			if (Game.game.currentLevel > 11) nextJump = Math.ceil(nextJump / 1.4)
			else if (Game.game.currentLevel > 16) nextJump = Math.ceil(nextJump / 2);
			randomFire = 30;
			Actuate.tween(body.position, 1, { x:targetPos.x, y:targetPos.y } );
		}
		else nextJump--;
		
		if (Mut.dist(targetPos.x, targetPos.y, body.position.x, body.position.y) > 50)
		{
			var gr:TileSprite = new TileSprite(Game.game.layer, "enemy_t_b");
			Game.game.layer.addChild(gr);
			gr.x = body.position.x;
			gr.y = body.position.y;
			gr.alpha = .3;
			Actuate.tween(gr, 2, { alpha:0, scale:.4 } ).onComplete(function():Dynamic
			{
				Game.game.layer.removeChild(gr);
				return null;
			});
		}
		else fire();
	}
	
	override function fire() 
	{
		if (Game.game.cannon.body == null) return;
		
		if (randomFire > 0)
		{
			randomFire--;
			return;
		}
		
		randomFire = 50 + Std.random(30);
		
		var a = Mut.getAng(body.position, Game.game.cannon.body.position);
		
		var vl = 420;
		if (Game.game.currentLevel > 12) vl = 570
		else if (Game.game.currentLevel > 18) vl = 700;
		
		#if !flash
		var tXml = Assets.getText("xml/y_flame_s.xml");
		var em = new ParticlesEm(Game.game.layerAdd, tXml, "fem0040", Game.game.layerAdd, 0);
		Game.game.emitters.push(em);
		
		var tXml = Assets.getText("xml/y_flame1.xml");
		var emm = new ParticlesEm(Game.game.layerAdd, tXml, "fem0040", Game.game.layerAdd, 0);
		Game.game.emitters.push(emm);
		emm.emitStart(body.position.x, body.position.y + 17, 2);
		emm.toRemove = true;
		
		new FighterShell(new Vec2(body.position.x, body.position.y + 17), 25, 100, a, vl, 30, null, 0, em);
		#else
		new FighterShell(new Vec2(body.position.x, body.position.y + 17), 25, 100, a, vl, 30, new TileSprite(Game.game.layerAdd, "4t"));
		#end
		Game.game.playS(s_f);
		//var gr = new TileClip(Game.game.layerAdd, "fem");
		//new FighterShell(new Vec2(body.position.x, body.position.y + 17), 20, 1, a, 300, 30, gr);
	}
}