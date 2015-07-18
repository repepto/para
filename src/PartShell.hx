package;
import aze.display.TileSprite;
import nape.dynamics.InteractionFilter;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import openfl.Assets;
import particles.ParticlesEm;

class PartShell extends Shell
{
	var filter:InteractionFilter;
	
	public function new(pos:Vec2)
	{
		super(pos, 4, 1, 14, new TileSprite(Game.game.layer, "roll"), 0);
		
		filter = new InteractionFilter(1, ~8);
		
		var tXml = Assets.getText("xml/smoke_f1.xml");
		flameEmitter = new ParticlesEm(Game.game.layerAdd, tXml, "smoke", Game.game.layerAdd);
		Game.game.emitters.push(flameEmitter);
		
		cast(body.userData.graphic, TileSprite).scale /= 2;
		
		
		body.group = Game.game.enemyGroup;
		body.gravMass /= 2;
		
		var distance = .0;
		var direction = -1.0;
		
		if (Game.game.cannon.body != null) 
		{
			distance = Math.abs(body.position.x - Game.game.cannon.body.position.x);
			direction =  distance / (Game.game.cannon.body.position.x - body.position.x);
		}
		else 
		{
			distance = 70;
			direction = -1 + 2 * Math.random();
		}
		
		var force = (Math.random() * 4 + 4) * distance / (Math.sqrt(distance) * direction * 8);
		
		body.applyImpulse(new Vec2(force, -7 - Math.random() * 7));
	}
	
	override public function destruction() 
	{
		if (body == null) return;
		Game.game.explode(body.position.x, body.position.y, Game.game.layerAdd, "secondExpl_", 25, .4, Math.random() * Math.PI * 2);
		#if !flash
		Game.game.explode(body.position.x, body.position.y, Game.game.layerAdd, "secondExpl_", 32, .8, Math.random() * Math.PI * 2, .7);
		Game.game.explode(body.position.x, body.position.y, Game.game.layer, "firstFog_", 44, .4, Math.random() * Math.PI * 2);
		#end
		
		Game.game.cannon.damage(10);
		super.destruction();
	}
}