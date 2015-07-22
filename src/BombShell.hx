package;
import aze.display.TileClip;
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
		#if mobile
		super(pos, 14, 1, 20, null, 0);
		#else
		super(pos, 14, 1, 20, new TileClip(Game.game.layer, "bombab", 25), 0);
		#end
		
		filter = new InteractionFilter(1, ~8);
		
		#if mobile
		var tXml = Assets.getText("xml/flame.xml");
		var pn = "f_part";
		if (Game.game.currentLevel >= 6) pn = "dira";
		flameEmitter = new ParticlesEm(Game.game.layerAdd, tXml, pn, Game.game.layerAdd);
		Game.game.emitters.push(flameEmitter);
		#end
		
		body.group = Game.game.enemyGroup;
		
		var gmDiv = 2.0;
		if (!div)
		{
			if (Game.game.currentLevel >= 6 && Game.game.currentLevel < 10) gmDiv = 1
			else if (Game.game.currentLevel >= 10) gmDiv = .8
			else if (Game.game.currentLevel > 3) gmDiv = 3;
			
			body.gravMass /= gmDiv;
			
			var distance = Math.abs(body.position.x - Game.game.cannon.body.position.x);
			var direction = distance / (Game.game.cannon.body.position.x - body.position.x);
			var force = 5 * distance / Math.sqrt(distance) * direction;
			if (Game.game.currentLevel >= 6 && Game.game.currentLevel < 12) force = 8.7 * distance / Math.sqrt(distance) * direction
			else if (Game.game.currentLevel >= 12) force = 8 * distance / Math.sqrt(distance) * direction;
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
		
		var bodies = Game.game.space.bodiesInCircle(body.position, 220, false, filter);
		
		for(i in bodies)
		{
			if (i == body || i.type == BodyType.STATIC) continue;
			var tp = Type.getClassName(Type.getClass(i.userData.i));
			if (tp != "Cannon" && tp != "Soldier") continue;
			var dist = Math.abs(i.position.x - body.position.x);
			var d = (240 - dist)/2;
			if (d > Game.game.damageBomb) d = Game.game.damageBomb;
			i.userData.i.damage(d);
		}
		
		super.destruction();
	}
}