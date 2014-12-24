package;
import aze.display.TileLayer.TileBase;
import nape.geom.Vec2;
import openfl.Assets;
import particles.ParticlesEm;

class FighterShell extends Shell
{
	var velocity:Int;
	var angle:Float;
	
	
	public function new(pos:Vec2, radius:Int, life:Int = 10, angle:Float, velocity:Int = 20, damageForce:Int = 40,
	graphic:TileBase = null, offsetY:Float = 0, flameEmitter:ParticlesEm = null)
	{
		
		super(pos, radius, life, damageForce, graphic, offsetY, flameEmitter);
		
		body.rotation = Math.PI / 2;
		
		this.angle = angle;
		this.velocity = velocity;
		body.group = Game.game.enemyGroup;
	}
	
	override public function destruction() 
	{
		if (body == null) return;
		Game.game.explode(body.position.x, body.position.y, Game.game.layerAdd, "secondExpl_", 34, .4, 4);
		var tXml = Assets.getText("xml/ricochet.xml");
		var e1Expl = new ParticlesEm(Game.game.layerAdd, tXml, "f_shell", Game.game.layerAdd);
		e1Expl.toRemove = true;
		e1Expl.emitStart(body.position.x, body.position.y, 4);
		Game.game.emitters.push(e1Expl);
		
		super.destruction();
	}
	
	override public function run():Void
	{
		if (body == null) return;
		body.velocity = new Vec2(velocity * Math.cos(angle), velocity * Math.sin(angle));
		if (body.position.y < - 20) 
		{
			clear();
			return;
		}
		super.run();
	}
}