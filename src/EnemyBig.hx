package;
import aze.display.TileClip;
import aze.display.TileSprite;
import motion.Actuate;
import mut.Mut;
import nape.dynamics.InteractionFilter;
import nape.geom.Ray;
import nape.geom.RayResult;
import nape.geom.Vec2;
import nape.phys.Body;
import openfl.Assets;
import openfl.media.Sound;
import particles.ParticlesEm;

class EnemyBig extends Enemy
{
	var targetAng:Float;
	var targetPos:Vec2;
	var nextPos:UInt = 0;
	var step:Float = 0;
	var vel:UInt = 350;
	var flameEmitter:ParticlesEm;
	var smokeEmitter:ParticlesEm;
	
	public function new(body)
	{
		super(body, 2700);
		
		body.group = Game.game.enemyGroup;
		randomFire = 30;
		
		targetPos = new Vec2();
		
		body.gravMass = 0;
		
		targetPos.set(body.position);
		targetPos.setxy(400, 240);
		
		targeting();
		targetAng = Mut.getAng(body.position, targetPos);
		
		body.rotation = targetAng;
		
		s_f = Game.game.s_fEnemyBig;
		
	}
	
	override public function init(tileGr:Bool = false) 
	{
		super.init(tileGr);
		var tXml = Assets.getText("xml/flame.xml");
		flameEmitter = new ParticlesEm(Game.game.layerAdd, tXml, "f_part", Game.game.layerAdd);
		Game.game.emitters.push(flameEmitter);
		
		tXml = Assets.getText("xml/smoke_big.xml");
		smokeEmitter = new ParticlesEm(Game.game.layerAdd, tXml, "smoke", Game.game.layerAdd);
		Game.game.emitters.push(smokeEmitter);
	}
	
	function targeting()
	{
		
		if(targetPos.y < 40) targetPos.setxy(500, 540)
		else do
		{
			targetPos.x = 100 + Math.random() * 800;
			targetPos.y = 20;
		}
		while (Mut.dist(targetPos.x, targetPos.y, body.position.x, body.position.y) < 300);
		
	}
	
	override function controll() 
	{
		if (body == null) return;
		
		targetAng = Mut.getAng(body.position, targetPos);
		
		if (Math.abs(targetAng - body.rotation) > Math.PI) 
		{
			if (targetAng < 0) targetAng += 2 * Math.PI
			else body.rotation += 2 * Math.PI;
		}
		
		if ((body.position.y < 100 && targetPos.y != 540) || (body.position.y > 240 && targetPos.y == 540)) targeting();
		
		step = (targetAng - body.rotation) / 30;
		
		step = .05 * Math.abs(step) / step;
		if (Math.abs(targetAng - body.rotation) > step) body.rotation += step;
		
		if (nextPos > 0) nextPos--;
		
		body.velocity.setxy(vel * Math.cos(body.rotation), vel * Math.sin(body.rotation));
		flameEmitter.emitStart(body.position.x - 50 * Math.cos(body.rotation), body.position.y - 50 * Math.sin(body.rotation), 1);
		smokeEmitter.emitStart(body.position.x - 50 * Math.cos(body.rotation), body.position.y - 50 * Math.sin(body.rotation), 1);
		
		fire();
	}
	
	override public function clear() 
	{
		if (Body == null) return;
		
		flameEmitter.toRemove = true;
		smokeEmitter.toRemove = true;
		
		super.clear();
	}
	
	override public function destruction() 
	{
		if (body == null) return;
		for (i in 0...14)
		{
			frag();
		}
		
		var f = new Fragment(4 + Std.random(4), "enemyBig_p");
		f.init_(body.position);
		do f.body.angularVel = 21 - 42 * Math.random() while (Math.abs(f.body.angularVel) < 7);
		
		if (Math.random() > .4)
		{
			f = new Fragment(4 + Std.random(4), "enemyBig_p1");
			f.init_(body.position);
			do f.body.angularVel = 21 - 42 * Math.random() while (Math.abs(f.body.angularVel) < 7);
		}
		
		
		
		Game.game.explode(body.position.x, body.position.y, Game.game.layerAdd1, "exp_sh_", 20, 1.2, Math.random() * Math.PI * 2, 1);
		//Game.game.explode(body.position.x - 20, body.position.y, Game.game.layerAdd, "firstExpl_", 25, 3, Math.random() * Math.PI * 2, .2);
		#if mobile Game.game.explode(body.position.x - 20, body.position.y, Game.game.layer, "firstFog_", 25, 1, Math.random() * Math.PI * 2); #end
		//Game.game.explode(body.position.x - 20, body.position.y, Game.game.layerAdd, "firstExpl_", 25, 1, Math.random() * Math.PI * 2);
		
		//Game.game.explode(body.position.x + 20, body.position.y, Game.game.layerAdd, "secondExpl_", 44, 5, Math.random() * Math.PI * 2, .3);
		
		super.destruction();
	}
	
	override function fire() 
	{
		if (Game.game.cannon.body == null || nextPos > 0) return;
		
		var rayRes:RayResult = null;
		var ray:Ray = new Ray(new Vec2(body.position.x, body.position.y), new Vec2(Math.cos(body.rotation), Math.sin(body.rotation)));
		ray.maxDistance = 600;
		rayRes = Game.game.space.rayCast(ray);
		
		if (rayRes == null || rayRes.shape.body != Game.game.cannon.body) return;
		
		nextPos = 120;
		
		var a = Mut.getAng(body.position, Game.game.cannon.body.position);
		
		var vlst = 700;
		if (Game.game.currentLevel > 14) vlst = 1200;
		
		#if mobile
		var tXml = Assets.getText("xml/y_flame_.xml");
		var em = new ParticlesEm(Game.game.layerAdd, tXml, "fem0040", Game.game.layerAdd, 0);
		Game.game.emitters.push(em);
		new FighterShell(new Vec2(body.position.x + 50 * Math.cos(body.rotation - .6), body.position.y + 50 * Math.sin(body.rotation - .6)), 25, 100, a, vlst, 30, null, 0, em);
		
		tXml = Assets.getText("xml/y_flame_.xml");
		em = new ParticlesEm(Game.game.layerAdd, tXml, "fem0040", Game.game.layerAdd, 0);
		Game.game.emitters.push(em);
		new FighterShell(new Vec2(body.position.x + 50 * Math.cos(body.rotation + .6), body.position.y + 50 * Math.sin(body.rotation + .6)), 25, 100, a, vlst, 30, null, 0, em);
		if (s_f != null) Game.game.playS(s_f);
		#else
		new FighterShell(new Vec2(body.position.x + 50 * Math.cos(body.rotation - .6), body.position.y + 50 * Math.sin(body.rotation - .6)), 25, 100, a, vlst, 50,  new TileSprite(Game.game.layerAdd, "4big"));
		new FighterShell(new Vec2(body.position.x + 50 * Math.cos(body.rotation + .6), body.position.y + 50 * Math.sin(body.rotation + .6)), 25, 100, a, vlst, 50,  new TileSprite(Game.game.layerAdd, "4big"));
		#end
	}
}