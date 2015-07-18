package;
import aze.display.TileSprite;
import nape.geom.Vec2;
import nape.phys.Body;
import openfl.Assets;
import particles.ParticlesEm;
import nape.dynamics.InteractionFilter;
import nape.phys.BodyType;

class RollerShell extends Shell
{
	var filter:InteractionFilter;
	
	public function new(pos:Vec2)
	{
		super(pos, 14, 10, 30, new TileSprite(Game.game.layer, "roll"));
		
		filter = new InteractionFilter(1, ~8);
		
		body.group = Game.game.enemyGroup;
		
		if (Game.game.currentLevel > 9 && Game.game.currentLevel < 12) body.gravMass /= 3.2;
		else if (Game.game.currentLevel >= 12) body.gravMass /= 2;
		else body.gravMass /= 4;
		
		/*if (body.position.x > 500) body.angularVel = -70
		else body.angularVel = 70;*/
		
		body.angularVel = 2 - 4 * Math.random();
		
		var tXml = Assets.getText("xml/abstr.xml");
		flameEmitter = new ParticlesEm(Game.game.layerAdd, tXml, "smoke", Game.game.layerAdd);
		Game.game.emitters.push(flameEmitter);
	}
	
	override public function destruction() 
	{
		if (body == null) return;
		
		#if !flash
		Game.game.explode(body.position.x, body.position.y, Game.game.layerAdd, "secondExpl_", 32, 1, Math.random() * Math.PI * 2, .7);
		#end
		Game.game.explode(body.position.x, body.position.y, Game.game.layer, "firstFog_", 44, .4, Math.random() * Math.PI * 2);
		Game.game.explode(body.position.x, body.position.y, Game.game.layerAdd, "secondExpl_", 25, .4, Math.random() * Math.PI * 2);
		
		var bodies = Game.game.space.bodiesInCircle(body.position, 80, false, filter);
		
		for(i in bodies)
		{
			if (i == body || i.type == BodyType.STATIC) continue;
			var tp = Type.getClassName(Type.getClass(i.userData.i));
			if (tp == "FragmentFire" || tp == "Fragment") continue;
			
			var dist = Math.abs(i.position.x - body.position.x);
			if (dist < 140) 
			{
				var d = (140 - dist) / 2;
				if (d > Game.game.damageBomb) d = Game.game.damageBomb;
				i.userData.i.damage(d);
			}
		}
		
		for (i in 0...3)
		{
			new PartShell(body.position);
		}
		
		super.destruction();
	}
}