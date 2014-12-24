package;
import aze.display.TileSprite;
import nape.dynamics.InteractionFilter;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import openfl.Assets;
import particles.ParticlesEm;

class BombShell extends Shell
{
	var filter:InteractionFilter;
	
	public function new(pos:Vec2, div:Bool=false)
	{
		super(pos, 14, 1, 20, null, 0);
		
		filter = new InteractionFilter(1, ~8);
		
		var tXml = Assets.getText("xml/flame.xml");
		var pn = "f_part";
		if (Game.game.currentLevel >= 7) pn = "dira";
		flameEmitter = new ParticlesEm(Game.game.layerAdd, tXml, pn, Game.game.layerAdd);
		Game.game.emitters.push(flameEmitter);
		
		body.group = Game.game.enemyGroup;
		
		var gmDiv = 4;
		if (!div)
		{
			if (Game.game.currentLevel >= 7) gmDiv = 1;
			
			body.gravMass /= gmDiv;
			
			var distance = Math.abs(body.position.x - Game.game.cannon.body.position.x);
			var direction = distance / (Game.game.cannon.body.position.x - body.position.x);
			var force = 5 * distance / Math.sqrt(distance) * direction;
			if (Game.game.currentLevel >= 7) force = 9 * distance / Math.sqrt(distance) * direction;
			body.applyImpulse(new Vec2(force, 0));
		}
		else
		{
			body.applyImpulse(new Vec2(-240 + Std.random(481), -Std.random(300)));
		}
	}
	
	override public function destruction() 
	{
		if (body == null) return;
		Game.game.explode(body.position.x, body.position.y - 120, Game.game.layer, "swcondFog");
		Game.game.explode(body.position.x, body.position.y, Game.game.layerAdd, "secondExpl_", 32, 2, Math.random() * Math.PI * 2, .7);
		Game.game.explode(body.position.x, body.position.y, Game.game.layer, "firstFog_", 44, .5, Math.random() * Math.PI * 2);
		Game.game.explode(body.position.x, body.position.y, Game.game.layerAdd, "secondExpl_", 25, .5, Math.random() * Math.PI * 2);
		
		var bodies = Game.game.space.bodiesInCircle(body.position, 140, false, filter);
		
		for(i in bodies)
		{
			if (i == body || i.type == BodyType.STATIC) continue;
			var tp = Type.getClassName(Type.getClass(i.userData.i));
			if (tp != "Cannon" && tp != "Soldier") continue;
			var dist = Math.abs(i.position.x - body.position.x);
			if (dist < 140) 
			{
				var d = 170 - dist;
				if (d > Game.game.damageBomb) d = Game.game.damageBomb;
				i.userData.i.damage(d);
			}
		}
		
		super.destruction();
	}
}