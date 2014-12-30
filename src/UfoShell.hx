package;
import aze.display.TileSprite;
import haxe.Timer;
import nape.dynamics.InteractionFilter;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import openfl.Assets;
import particles.ParticlesEm;

class UfoShell extends Shell
{
	var filter:InteractionFilter;
	
	public function new(pos:Vec2)
	{
		super(pos, 17, 1, 50, new TileSprite(Game.game.layer, "ufoShell"), 0);
		
		filter = new InteractionFilter(1, ~8);
		
		var tXml = Assets.getText("xml/flame.xml");
		var pn = "f_part";
		if (Game.game.currentLevel >= 7) pn = "dira";
		flameEmitter = new ParticlesEm(Game.game.layerAdd, tXml, pn, Game.game.layerAdd);
		Game.game.emitters.push(flameEmitter);
		
		body.angularVel = 7 + Std.random(10);
		
		var gmDiv = 4;
		if (Game.game.currentLevel >= 7) gmDiv = 1;
		body.group = Game.game.enemyGroup;
		body.gravMass /= gmDiv;
		body.group = Game.game.enemyGroup;
	}
	
	function div()
	{
		if (body == null) return;
		
		for (i in 0...3)
		{
			new BombShell(body.position, true);
		}
	}
	
	function expl(x:Float, y:Float)
	{
		Game.game.explode(x, y, Game.game.layerAdd, "secondExpl_", 25, 3, Math.random() * Math.PI * 2, .3);
		Game.game.explode(x, y, Game.game.layerAdd, "firstExpl_", 64, 1, Math.random() * Math.PI * 2);
	}
	
	override public function destruction() 
	{
		if (body == null) return;
		
		Game.game.explode(body.position.x, body.position.y - 120, Game.game.layer, "swcondFog");
		
		for (i in 0...4)
		{
			expl(body.position.x + i * 100, body.position.y);
		}
		
		for (i in 0...4)
		{
			expl(body.position.x - i * 100, body.position.y);
		}
		
		var bodies = Game.game.space.bodiesInCircle(body.position, 2000, false, filter);
		
		for(i in bodies)
		{
			if (i == body || i.type == BodyType.STATIC) continue;
			var tp = Type.getClassName(Type.getClass(i.userData.i));
			if (tp != "Cannon" && tp != "Soldier") continue;
			var dist = Math.abs(i.position.x - body.position.x);
			//if (dist < 140) 
			{
				var d = 400 - dist;
				i.userData.i.damage(d);
			}
		}
		
		super.destruction();
	}
}