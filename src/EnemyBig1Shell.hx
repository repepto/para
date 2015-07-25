package;
import aze.display.TileClip;
import aze.display.TileSprite;
import haxe.Timer;
import nape.dynamics.InteractionFilter;
import nape.geom.Vec2;
import openfl.Assets;
import openfl.media.Sound;
import particles.ParticlesEm;
import mut.Mut;
import nape.phys.BodyType;

class EnemyBig1Shell extends Shell
{
	var vel:UInt = 340;
	var targetAng:Float;
	var vx:Float;
	var vy:Float;
	var s_f:Sound;
	var kv:Float = 1;
	
	var filter:InteractionFilter;
	
	
	public function new(pos:Vec2, tx:UInt = 0)
	{
		
		#if mobile 
		super(pos, 10, 100, 50); 
		#else
		super(pos, 10, 100, 50, new TileSprite(Game.game.layerAdd, "4big1_"));
		#end
		
		if (Game.game.currentLevel > 20) kv = 1.28;
		
		s_f = Game.game.big_boss1_sh;
		
		Game.game.playS(s_f);
		
		body.group = Game.game.enemyGroup;
		body.gravMass = 0;
		
		//body.userData.graphic = new TileSprite(Game.game.layer, "missileE");
		//Game.game.layer.addChild(body.userData.graphic);
		
		flameEmitter = new ParticlesEm(Game.game.layerAdd, Assets.getText("xml/f_f.xml"), "p_part", Game.game.layerAdd);
		Game.game.emitters.push(flameEmitter);
		
		targetAng = Mut.getAng(body.position, new Vec2(tx, 200));
		
		Timer.delay(function()
		{
			if (body == null || Game.game.cannon.body == null) return;
			targetAng = Mut.getAng(body.position, new Vec2(500, 520));
			if (Math.abs(targetAng - body.rotation) > Math.PI) 
			{
				if (targetAng < 0) targetAng += 2 * Math.PI
				else body.rotation += 2 * Math.PI;
			}
			
		}, 1000);
	}
	
	override public function destruction() 
	{
		if (body == null) return;
		Game.game.explode(body.position.x, body.position.y, Game.game.layerAdd, "secondExpl_", 34, .4, 4);
		var tXml = Assets.getText("xml/ricochet1.xml");
		var e1Expl = new ParticlesEm(Game.game.layerAdd, tXml, "f_shell", Game.game.layerAdd);
		e1Expl.toRemove = true;
		e1Expl.emitStart(body.position.x, body.position.y, 4);
		Game.game.emitters.push(e1Expl);
		
		var bodies = Game.game.space.bodiesInCircle(body.position, 70, false, filter);
		
		for(i in bodies)
		{
			if (i == body || i.type == BodyType.STATIC) continue;
			var tp = Type.getClassName(Type.getClass(i.userData.i));
			if (tp == "FragmentFire" || tp == "Fragment") continue;
			var dist = Math.abs(i.position.x - body.position.x);
			if (dist < 140) 
			{
				var d = 140 - dist;
				if (d > Game.game.damageBomb) d = Game.game.damageBomb;
				i.userData.i.damage(d);
			}
		}
		
		super.destruction();
	}
	
	override function clear() 
	{
		if (body == null) return;
		super.clear();
	}
	
	override public function run():Void
	{
		if (body == null) return;
		
		var step = (targetAng - body.rotation) / 10;
		body.rotation += step;
		body.velocity.setxy(kv * 270 * Math.cos(body.rotation), kv * 270 * Math.sin(body.rotation));
		
		#if mobile 
		flameEmitter.emitStart(body.position.x, body.position.y, 7);
		#end
		
		if(body.position.x < 20 || body.position.x > 980) targetAng = Mut.getAng(body.position, new Vec2(500, 520));
		
		if (body.position.y < - 140) 
		{
			clear();
			return;
		}
		super.run();
	}
}