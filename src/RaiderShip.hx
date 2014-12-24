package;
import aze.display.TileClip;
import aze.display.TileSprite;
import motion.Actuate;
import motion.easing.Cubic;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.shape.Circle;
import openfl.Assets;
import openfl.media.Sound;
import particles.ParticlesEm;

class RaiderShip extends LifeObject
{
	var randomFire:Float;
	var flame:TileClip;
	var velocity:Int;
	var landed:Bool;
	var firePause:UInt;
	
	var s_f = Game.game.air8;
	
	public function new(position:Vec2, velocity:Int)
	{
		super(40, new Body());
		
		firePause = 0;
		
		Game.game.riderLive ++;
		
		body = new Body();
		body.cbTypes.add(Game.game.cbCannon);
		body.cbTypes.add(Game.game.cbRaider);
		body.shapes.add(new Circle(20));
		body.position = position;
		body.group = Game.game.enemyGroup;
		body.allowRotation = false;
		var gr:TileSprite = new TileSprite(Game.game.layer, "raiderShip");
		body.userData.graphic = gr;
		body.userData.i = this;
		
		this.velocity = velocity;
		
		gr.alpha = 0;
		Actuate.tween(gr, 1, { alpha: 1 } ).ease(Cubic.easeOut);
		
		flame = new TileClip(Game.game.layerAdd, "flame_", 25);
		Game.game.layerAdd.addChild(flame);
		flame.scaleY = .5;
		
		init();
	}
	
	
	override public function clear()
	{
		if (body == null) return;
		if(!landed) Game.game.riderLive--;
		
		if(flame.parent != null) Game.game.layerAdd.removeChild(flame);
		Game.game.ridersOnGround.remove(this);
		super.clear();
	}
	
	function fire()
	{
		if (Game.game.cannon.life == 0 || !landed || firePause != 0) return;
		
		var tXml = Assets.getText("xml/flame_b.xml");
		var fl = new ParticlesEm(Game.game.layerAdd, tXml, "f_part", Game.game.layerAdd);
		Game.game.emitters.push(fl);
		
		new RaiderShell(new Vec2(body.position.x, body.position.y-7), 7, Game.game.damageRider, null, fl);
		if (s_f != null) Game.game.playS(s_f);
		firePause = 70;
	}
	
	override public function run()
	{
		if (body == null) return;
		super.run();
		
		if (firePause > 0) firePause--;
		fire();
		if (!landed)
		{
			body.velocity.setxy(0, velocity);
			flame.x = body.position.x;
			flame.y = body.position.y + 24;
		}
	}
	
	public function landing()
	{
		Game.game.layerAdd.removeChild(flame);
		Game.game.smoke.emitStart(body.position.x, body.position.y + 20, 3);
		landed = true;
		Game.game.ridersOnGround.push(this);
		Game.game.riderLive--;
	}
	
	override public function destruction() 
	{
		if (body == null) return;
		
		if(landed) Game.game.s_expl(Std.random(5));
		
		if (Game.game.space.bodies.length < 27)
		{
			var r = Math.round(3 + Math.random() * 4);
			for (i in 0...r)
			{
				frag();
			}
		}
		
		Game.game.money += 7;
		Game.game.moneyGr.newValue("" + Game.game.money, true);
		
		var tXml = Assets.getText("xml/bum.xml");
		var e1Expl = new ParticlesEm(Game.game.layerAdd, tXml, "f_part1", Game.game.layerAdd);
		e1Expl.toRemove = true;
		e1Expl.emitStart(body.position.x, body.position.y, 3);
		Game.game.emitters.push(e1Expl);
		
		Game.game.explode(body.position.x, body.position.y, Game.game.layerAdd, "firstExpl_", 25, 1.2, Math.random() * Math.PI * 2, .3);
		Game.game.explode(body.position.x, body.position.y, Game.game.layer, "firstFog_", 32, .6, Math.random() * Math.PI * 2);
		Game.game.explode(body.position.x, body.position.y, Game.game.layerAdd, "firstExpl_", 32, .6, Math.random() * Math.PI * 2);
		
		super.destruction();
	}
}