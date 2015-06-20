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
import particles.ParticlesEm;

class EnemyBig1 extends Enemy
{
	var vel:UInt = 240;
	var flameEmitter0:ParticlesEm;
	var flameEmitter1:ParticlesEm;
	var ang:Float;
	var vx:Float;
	var vy:Float;
	var targetPoint:Vec2;
	var tx:UInt = 0;
	
	
	public function new(body)
	{
		super(body, 7000);
		body.gravMass = 0;
		
		s_f = Game.game.s_fEnemyBig1;
	}
	
	override public function init(tileGr:Bool = false) 
	{
		super.init(tileGr);
		var tXml = Assets.getText("xml/flameB.xml");
		flameEmitter0 = new ParticlesEm(Game.game.layerAdd, tXml, "f_part", Game.game.layerAdd);
		Game.game.emitters.push(flameEmitter0);
		
		tXml = Assets.getText("xml/flameB.xml");
		flameEmitter1 = new ParticlesEm(Game.game.layerAdd, tXml, "f_part", Game.game.layerAdd);
		Game.game.emitters.push(flameEmitter1);
		
		targetPoint = new Vec2();
		getAng();
		
		fireDelay = 80;
	}
	
	function getAng()
	{
		do
		{
			targetPoint.setxy(Math.random() * 1000, 20 + Math.random() * 300);
		}
		while (Mut.distV2(targetPoint, body.position) < 200);
		
		ang = Mut.getAng(body.position, targetPoint);
		vx = Math.cos(ang) * vel;
		vy = Math.sin(ang) * vel;
	}
	
	override function controll() 
	{
		if (body == null || Game.game.cannon.body == null) return;
		
		var velx = (vx - body.velocity.x) / Math.abs(vx - body.velocity.x);
		if (Math.abs(vx - body.velocity.x) <= 7) velx = vx
		else body.velocity.x += velx * 7;
		
		var vely = (vy - body.velocity.y) / Math.abs(vy - body.velocity.y);
		if (Math.abs(vy - body.velocity.y) <= 7) vely = vy
		else body.velocity.y += vely * 7;
		
		if (Mut.distV2(body.position, targetPoint) < 200)
		{
			getAng();
		}
		
		//body.velocity.setxy(vx, vy);
		flameEmitter0.emitStart(body.position.x - 80, body.position.y + 45, 1);
		flameEmitter1.emitStart(body.position.x + 80, body.position.y + 45, 1);
		
		fire();
	}
	
	override public function clear() 
	{
		if (Body == null) return;
		super.clear();
		flameEmitter0.toRemove = true;
		flameEmitter1.toRemove = true;
	}
	
	override public function destruction() 
	{
		if (body == null) return;
		
		for (i in 0...14)
		{
			frag();
		}
		
		var f = new Fragment(4 + Std.random(4), "enemyBig1_p");
		f.init_(body.position);
		do f.body.angularVel = 21 - 42 * Math.random() while (Math.abs(f.body.angularVel) < 7);
		
		if (Math.random() > .5)
		{
			f = new Fragment(4 + Std.random(4), "enemyBig1_p");
			f.init_(body.position);
			do f.body.angularVel = 21 - 42 * Math.random() while (Math.abs(f.body.angularVel) < 7);
		}
		
		Game.game.explode(body.position.x, body.position.y, Game.game.layerAdd1, "exp_sh_", 20, 1.5, Math.random() * Math.PI * 2, 1);
		//Game.game.explode(body.position.x + 20, body.position.y, Game.game.layerAdd, "secondExpl_", 44, 7, Math.random() * Math.PI * 2, .4);
		
		super.destruction();
	}
	
	override function fire() 
	{
		if (fireDelay > 0)
		{
			fireDelay--;
			return;
		}
		
		var pos = new Vec2(body.position.x - 30 + 60 * Math.random(), body.position.y - 44);
		
		if (tx == 0) tx = 1000
		else tx = 0;
		new EnemyBig1Shell(pos, tx);
		if (s_f != null) Game.game.playS(s_f);
		fireDelay = 80;
	}
}