package;
import aze.display.TileClip;
import aze.display.TileSprite;
import mut.Mut;
import nape.dynamics.InteractionFilter;
import nape.geom.Ray;
import nape.geom.Vec2;
import nape.phys.Body;
import openfl.Assets;
import particles.ParticlesEm;

class EnemyFighter extends Enemy
{
	
	var retreat:Bool;
	var targetAng:Float = 0;
	var em:ParticlesEm;
	
	var addShellVel:UInt = 0;
	
	var rf:UInt = 70;
	
	
	public function new(body:Body, life:Int, velocity:Int)
	{
		super(body, life, velocity, 0);
		retreat = false;
		fireDelay = 0;
		if (Game.game.currentLevel > 7 && Game.game.currentLevel < 12) velocity += 80
		else if (Game.game.currentLevel >= 12) velocity += 140;
		
		var tXml = Assets.getText("xml/green_flame.xml");
		em = new ParticlesEm(Game.game.layerAdd, tXml, "part_green", Game.game.layerAdd, 0);
		
		if (body.position.x > 500) body.rotation = -Math.PI
		else body.rotation = 0;
		
		cast(body.userData.graphic, TileSprite).scaleX = 1;
		
		body.rotation = Mut.getAng(body.position, new Vec2(500, 520));
		
		s_f = Game.game.air5;
		
		randomFire = 70;
		
		if (Game.game.currentLevel > 7 && Game.game.currentLevel < 10) 
		{
			addShellVel = 140;
			rf = 40;
		}
		else if (Game.game.currentLevel >= 10) 
		{
			addShellVel = 220;
			rf = 20;
		}
	}
	
	override function controll() 
	{
		if (body == null) return;
		
		if (body.position.y < -200) { clear(); return; }
		
		if (Game.game.emitters.lastIndexOf(em) == -1) Game.game.emitters.push(em);
		em.emitStart(body.position.x - 30 * Math.cos(body.rotation), body.position.y - 30 * Math.sin(body.rotation), 1);
		
		if (!retreat && body.position.y > 340) 
		{
			retreat = true;
			targetAng = -Math.random() * Math.PI;
		}
		
		
		if (!retreat) targetAng = Mut.getAng(body.position, new Vec2(500, 520));
		var step = (targetAng - body.rotation) / 30;
		
		body.rotation += step;
		body.velocity.setxy(velocity * Math.cos(body.rotation), velocity * Math.sin(body.rotation));
		
		var ray:Ray = new Ray(new Vec2(body.position.x, body.position.y), new Vec2(Math.cos(body.rotation), Math.sin(body.rotation)));
		ray.maxDistance = 400;
		
		var rayRes = Game.game.space.rayCast(ray);
		
		if (rayRes != null && rayRes.shape.body == Game.game.cannon.body) fire();
	}
	
	override function fire()
	{
		if (Game.game.cannon.body == null) return;
		if (fireDelay > 0)
		{
			fireDelay--;
			return;
		}
		
		fireDelay = rf + Std.random(rf);
		
		//var gr = new TileSprite(Game.game.layer, "fire");
		//Game.game.layer.addChild(gr);
		
		var smoke:ParticlesEm = null;
		
		smoke = new ParticlesEm(Game.game.layerAdd, Assets.getText("xml/plazma.xml"), "p_part", Game.game.layerAdd);
		Game.game.emitters.push(smoke);
		
		var pos = new Vec2(body.position.x + 20 * Math.cos(body.rotation), body.position.y + 20 * Math.sin(body.rotation));
		var vel = 270;
		
		new FighterShell(pos, 10, 10, body.rotation, vel + addShellVel, Game.game.damageFighter, null, 10, smoke);
		if (s_f != null) Game.game.playS(s_f);
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
	
	override public function clear() 
	{
		if (body == null) return;
		em.toRemove = true;
		super.clear();
	}
	
	override function destructionExposion() 
	{
		if (body == null) return;
		Game.game.explode(body.position.x, body.position.y, Game.game.layerAdd1, "exp_sh_", 25, 1.14, Math.random() * Math.PI * 2, 1);
		//else Game.game.explode(body.position.x, body.position.y, Game.game.layerAdd, "firstExpl_", 25, 1, Math.random() * Math.PI * 2);
		Game.game.explode(body.position.x, body.position.y, Game.game.layerAdd, "secondExpl_", 32, 3, Math.random() * Math.PI * 2, .3);
		Game.game.explode(body.position.x, body.position.y, Game.game.layer, "firstFog_", 25, 1, Math.random() * Math.PI * 2);
		Game.game.fighter_e.emitStart(body.position.x, body.position.y, 4);
	}
}