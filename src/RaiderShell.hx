package;
import aze.display.TileSprite;
import nape.geom.Vec2;
import nape.phys.Body;
import openfl.Assets;
import particles.ParticlesEm;

class RaiderShell extends Shell
{
	public function new(pos:Vec2, radius:Int, damage:Int = 1, graphic:TileSprite, flameEmitter:ParticlesEm = null)
	{
		super(pos, 7, 1000, damage, graphic, 0, flameEmitter);
		
		
		body.group = Game.game.enemyGroup;
		
		var angle = -Math.PI / 4;
		if (body.position.x < 500) angle *= -1;
		angle -= Math.PI / 2;
		
		var distance = Math.abs(body.position.x - Game.game.cannon.body.position.x);
		
		var force = 3 * distance / Math.sqrt(distance) * 1.4;
		
		body.applyImpulse(new Vec2(force * Math.cos(angle), force * Math.sin(angle)));
		body.shapes.at(0).sensorEnabled = true;
		body.cbTypes.add(Game.game.cbRaiderShell);
	}
	
	override public function destruction() 
	{
		if (body == null) return;
		
		var offst = body.velocity.x / Math.abs(body.velocity.x) * 10;
		//Game.game.explode(body.position.x, body.position.y, Game.game.layerAdd1, "blueExpl_", 34);
		var tXml = Assets.getText("xml/ricochet.xml");
		var e1Expl = new ParticlesEm(Game.game.layerAdd, tXml, "f_shell", Game.game.layerAdd);
		e1Expl.toRemove = true;
		e1Expl.emitStart(body.position.x + offst, body.position.y, 4);
		Game.game.emitters.push(e1Expl);
		
		tXml = Assets.getText("xml/expl_blue.xml");
		e1Expl = new ParticlesEm(Game.game.layerAdd, tXml, "f_part", Game.game.layerAdd);
		e1Expl.toRemove = true;
		e1Expl.emitStart(body.position.x + offst, body.position.y, 4);
		Game.game.emitters.push(e1Expl);
		
		super.destruction();
	}
}