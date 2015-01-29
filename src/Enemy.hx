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
	
	var s_f:Sound;
	
	public function new(body:Body, life:Int, velocity:Int = 0, randomFire:Float = .1, flame:TileClip = null)
	{
		super(life, body);
		
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
		if (flame != null) 
		{
			flame.x = -1000;
			Game.game.layerAdd.addChild(flame);
		}
	}
	
	function fire()
	{
		if (Game.game.cannon.body == null) return;
		if (fireDelay != 0) 
		{
			fireDelay--;
			return;
		}
		
		
		
		if (randomFire > Math.random() && body.position.x > 50 + Game.game.ridersOffset && body.position.x < 950 - Game.game.ridersOffset && Math.abs(body.position.x - 500) > 77 
		&& Game.game.riderLive < Game.game.riderLim)
		{
			new RaiderShip(body.position, Game.game.riderVel + Math.round(Math.random() * Game.game.riderVel));
			if (s_f != null) Game.game.playS(s_f);
		}
		fireDelay = 40;
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
		if (body == null) return;
		var tXml = Assets.getText("xml/bum.xml");
		var e1Expl = new ParticlesEm(Game.game.layerAdd, tXml, "shard", Game.game.layer);
		e1Expl.toRemove = true;
		e1Expl.emitStart(body.position.x, body.position.y, 3);
		Game.game.emitters.push(e1Expl);
	}
	
	function destructionExposion()
	{
		Game.game.explode(body.position.x, body.position.y, Game.game.layerAdd, "secondExpl_", 32, 3, Math.random() * Math.PI * 2, .3);
		Game.game.explode(body.position.x, body.position.y, Game.game.layer, "firstFog_", 44, 1, Math.random() * Math.PI * 2);
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
		
		if (price > 200) price = 200;
		Game.game.money += (price + Game.game.addMonney);
		Game.game.moneyGr.newValue("" + Game.game.money, true);
		
		var r = Math.round(3 + Math.random() * 4);
		for (i in 0...r)
		{
			frag();
		}
		
		destructionEmitter();
		destructionExposion();
		
		super.destruction();
	}
}