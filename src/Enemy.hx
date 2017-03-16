package;
import aze.display.TileClip;
import aze.display.TileSprite;
import nape.geom.Vec2;
import nape.phys.Body;
import openfl.Assets;
import openfl.media.Sound;
import particles.ParticlesEm;

class Enemy extends LifeObject
{
	var randomFire:Float;
	var flame:TileClip;
	var velocity:Int;
	public var fireDelay:UInt;
	var price:UInt;
	var lifeBar:TileSprite;
	var fired:Bool;
	var fired1:Bool;
	var checkPoint:UInt;
	
	var s_f:Sound;
	
	public function new(body:Body, life:Int, velocity:Int = 0, randomFire:Float = .1, flame:TileClip = null)
	{
		super(life, body);
		
		fired1 = fired = false;
		
		fireDelay = Math.round(Math.random() * 70);
		
		this.flame = flame;
		this.velocity = velocity;
		this.randomFire = randomFire;
		fireDelay = 0;
		price = life;
		lifeBar = new TileSprite(Game.game.layer, "eLifeBar");
		
		s_f = Game.game.s_fEnemy;
	}
	
	override public function init(tileGr:Bool = false) 
	{
		super.init();
		
		if (Game.game.currentLevel == 1) velocity = 77 + Std.int(Math.random() * 30);
		
		if (flame != null) 
		{
			flame.x = -1000;
			Game.game.layerAdd.addChild(flame);
		}
		if (Type.getClassName(Type.getClass(this)) == "Enemy" ||
		Type.getClassName(Type.getClass(this)) == "EnemyBomber" ||
		Type.getClassName(Type.getClass(this)) == "RollerShip")
		{
			if (Game.game.cannon.body != null && Game.game.cannon.body.rotation > 0)
			{
				velocity = Std.int(Math.abs(velocity));
				if(flame != null) flame.scaleX = graphic.scaleX = -1;
				body.position.x = -70;
				checkPoint = 700 + Math.round(Math.random() * 170);
			}
			else
			{
				velocity = Std.int(-Math.abs(velocity));
				if(flame != null) flame.scaleX = graphic.scaleX = 1;
				body.position.x = 1070;
				checkPoint = 300 - Math.round(Math.random() * 170);
			}
			if(flame != null) flame.rotation = -Math.PI / 2 * graphic.scaleX;
		}
	}
	
	function fire()
	{
		if (Game.game.cannon.body == null) return;
		if (Game.game.currentLevel == 1 && Game.game.controlledObj.length > 10) return;
		if (fireDelay != 0) 
		{
			fireDelay--;
			return;
		}
		
		if (!fired && body.position.x > 300 && body.position.x < 700 && Math.abs(body.position.x - 500) > 90
		&& Game.game.riderLive < Game.game.riderLim)
		{
			if (Math.random() < Game.game.eRandomFire) fr()
			else fired = true;
			return;
		}
		
		if (!fired1)
		{
			if ((velocity < 0 && body.position.x < checkPoint) || (velocity > 0 && body.position.x > checkPoint))
			{
				fired1 = true;
				if (Game.game.riderLive < Game.game.riderLim && Math.random() < Game.game.eRandomFire) 
				{
					fr();
				}
			}
		}
		
		
		if (Game.game.riderLive < Game.game.riderLim && Game.game.ready2rider == 0 && Math.abs(body.position.x - 500) > 90)
		{
			fr();
		}
	}
	
	function fr()
	{
		
		if (body.position.x < 80 + Game.game.ridersOffset || body.position.x > 920 - Game.game.ridersOffset) return;
		
		var vel = Game.game.riderVel + Math.round(Math.random() * Game.game.riderVel);
		
		if (vel > Game.game.riderVel * 1.5 && body.position.y > 40 + Game.game.enemyLowerLimit - 140 
		&& (body.position.x < 170 || body.position.x > 830))
		{
			vel = Math.ceil(Game.game.riderVel * 1.5);
		}
		
		if (Game.game.currentLevel == 1) vel = 42;
		else if (Game.game.slower) vel = Math.ceil(vel / 1.3);
		
		new RaiderShip(body.position, vel);
		if (s_f != null) Game.game.playS(s_f);
		Game.game.ready2rider = Game.game.set_ready2rider - Math.round(Math.random() * Game.game.set_ready2rider / 2);
		fireDelay = Game.game.efd;
		fired = true;
	}
	
	override public function clear()
	{
		if (body == null) return;
		super.clear();
		
		if (flame != null && flame.parent != null) Game.game.layerAdd.removeChild(flame);
		if (lifeBar.parent != null) Game.game.layer.removeChild(lifeBar);
	}
	
	override public function run()
	{
		if (body == null) return;
		if (lifeBar.parent != null) 
		{
			lifeBar.x = body.position.x;
			lifeBar.y = body.position.y - body.bounds.height / 2 - 14;
		}
		super.run();
		controll();
	}
	
	function controll()
	{
		if (body == null) return;
		flamer();
		body.velocity = new Vec2(velocity, -12);
		fire();
	}
	
	function flamer()
	{
		if (flame != null) 
		{
			flame.x = body.position.x - 77 * Math.abs(velocity) / velocity;
			flame.y = body.position.y;
		}
	}
	
	function destructionEmitter()
	{
		//#if !mobile return; #end
		if (body == null) return;
		var tXml = Assets.getText("xml/bum.xml");
		var e1Expl = new ParticlesEm(Game.game.layerAdd, tXml, "shard", Game.game.layer);
		e1Expl.toRemove = true;
		e1Expl.emitStart(body.position.x, body.position.y, 3);
		Game.game.emitters.push(e1Expl);
	}
	
	function destructionExposion()
	{
		#if !flash  
		Game.game.explode(body.position.x, body.position.y, Game.game.layerAdd, "secondExpl_", 32, 3, Math.random() * Math.PI * 2, .42);
		Game.game.explode(body.position.x, body.position.y, Game.game.layer, "firstFog_", 44, 1, Math.random() * Math.PI * 2);
		#end
		Game.game.explode(body.position.x, body.position.y, Game.game.layerAdd, "secondExpl_", 25, 1, Math.random() * Math.PI * 2); 
	}
	
	override function frag() 
	{
		if (body == null) return;
		super.frag();
		
		if (Math.random() < .6) return;
		var f = Game.game.fragmentsFire;
		if (f.length > 0) f[Std.random(f.length - 1)].init_(body.position);
	}
	
	override public function damage(force:Float) 
	{
		if (body == null) return;
		
		if (lifeBar.parent == null) Game.game.layer.addChild(lifeBar);
		
		super.damage(force);
		
		if(life <=0 && lifeBar.parent != null) Game.game.layer.removeChild(lifeBar)
		else lifeBar.scaleX = life / price;
	}
	
	override public function destruction() 
	{
		if (body == null) return;
		
		var r = Math.round(3 + Math.random() * 4);
		for (i in 0...r)
		{
			frag();
		}
		
		destructionEmitter();
		destructionExposion();
		
		super.destruction();
		
		
		
		if (price > 200) price = 200;
		if (Game.game.currentLevel == 1) 
		{
			price = 200;
			
			Game.game.money += Math.ceil(price);
			Game.game.moneyGr.newValue("" + Game.game.money, true);
			return;
		}
		
		Game.game.money += Math.ceil(price * Game.game.earningUp);
		Game.game.moneyGr.newValue("" + Game.game.money, true);
	}
}