package;
import aze.display.TileSprite;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.shape.Polygon;
import openfl.Assets;
import particles.ParticlesEm;

class EnemyUfo extends LifeObject
{
	var highlight:TileSprite;
	var hStep:Float = -.4;
	var vel:Float = 400;
	var retreatTime:UInt;
	var fireLine:UInt;
	var price:UInt;
	var lifeBar:TileSprite;
	var a:UInt;
	var fired:Bool;
	
	public function new(x:Int, y:Int)
	{
		super(280, new Body());
		
		highlight = new TileSprite(Game.game.layerAdd, "ufoLight");
		highlight.alpha = 0;
		
		
		
		a = 5 + Std.random(5);
		
		retreatTime = 70 + Std.random(100);
		fireLine = 100 + Std.random(170);
		
		body.shapes.add(new Polygon(Polygon.rect( -50, -19, 100, 38)));
		body.position.setxy(x, y);
		body.gravMass = 0;
		body.userData.graphic = new TileSprite(Game.game.layer, "ufo");
		body.cbTypes.add(Game.game.cbCannon);
		body.group = Game.game.enemyGroup;
		body.allowRotation = false;
		highlight.x = body.position.x;
		
		price = 700;
		lifeBar = new TileSprite(Game.game.layer, "eLifeBar");
	}
	override public function init(tileGr:Bool = false) 
	{
		super.init(tileGr);
		Game.game.layerAdd.addChild(highlight);
		Game.game.playS(Game.game.ufo);
	}
	
	function fire()
	{
		new UfoShell(new Vec2(body.position.x, body.position.y + 40));
		Game.game.ufo_f.emitStart(body.position.x, body.position.y + 10, 14);
	}
	
	override public function clear()
	{
		if (body == null) return;
		super.clear();
		
		Game.game.layerAdd.removeChild(highlight);
		if (lifeBar.parent != null) Game.game.layer.removeChild(lifeBar);
	}
	
	override public function run()
	{
		if (body == null) return;
		if (body.position.y < -140)
		{
			clear();
			return;
		}
		if (lifeBar.parent != null) 
		{
			lifeBar.x = body.position.x;
			lifeBar.y = body.position.y - body.bounds.height / 2 - 14;
		}
		super.run();
		
		highlight.alpha += hStep;
		if (highlight.alpha < 0)
		{
			hStep = .1;
			highlight.alpha = 0;
		}
		else if (highlight.alpha > 1)
		{
			hStep = -.1;
			highlight.alpha = 1;
		}
		
		highlight.y = body.position.y;
		
		if (retreatTime > 1)
		{
			if (body.velocity.y != 0)
			{
				vel -= a;
				if (body.velocity.y < 10)
				{
					body.velocity.y = 0;
					vel = 0;
					if (!fired) 
					{
						fire();
						fired = true;
					}
				}
			}
			else
			{
				retreatTime--;
			}
		}
		else if(retreatTime == 1)
		{
			vel = -10;
			retreatTime = 0;
		}
		else vel -= a;
		
		body.velocity.setxy(0, vel);
		
	}
	
	function destructionEmitter()
	{
		if (body == null) return;
		var tXml = Assets.getText("xml/bum.xml");
		var e1Expl = new ParticlesEm(Game.game.layerAdd, tXml, "shard", Game.game.layer);
		e1Expl.toRemove = true;
		e1Expl.emitStart(body.position.x, body.position.y, 3);
		Game.game.emitters.push(e1Expl);
		Game.game.bomber_e.emitStart(body.position.x, body.position.y, 7);
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
		Game.game.money += price;
		Game.game.moneyGr.newValue("" + Game.game.money, true);
		
		var r = Math.round(3 + Math.random() * 4);
		for (i in 0...r)
		{
			frag();
		}
		
		destructionEmitter();
		destructionExposion();
		Game.game.add_ex.emitStart(body.position.x, body.position.y, 4);
		
		super.destruction();
	}
}