package;
import aze.display.TileLayer.TileBase;
import nape.dynamics.InteractionFilter;
import nape.geom.Vec2;
import openfl.Assets;
import particles.ParticlesEm;

class CannonShell extends Shell
{
	var velocity:Int;
	var angle:Float;
	
	
	public function new(pos:Vec2, radius:Int, life:Int = 10, angle:Float, velocity:Int = 20, damageForce:Int = 40,
	graphic:TileBase = null, offsetY:Float = 0, flameEmitter:ParticlesEm = null)
	{
		
		super(pos, radius, life, damageForce, graphic, offsetY, flameEmitter);
		
		body.group = Game.game.cShellGroup;
		
		body.rotation = angle + Math.PI / 2;
		body.cbTypes.push(Game.game.cbShellC);
		
		this.angle = angle;
		this.velocity = velocity;
		
	}
	
	override public function destruction() 
	{
		
		if (body == null) return;
		
		if(Std.random(2) == 0) Game.game.explode(body.position.x, body.position.y, Game.game.layerAdd, "secondExpl_", 34, .4, 4)
		else Game.game.explode(body.position.x, body.position.y, Game.game.layerAdd1, "exp_sh_", 25, .4, Math.random() * Math.PI * 2, 1);
		
		#if !flash
		var tXml = Assets.getText("xml/ricochet.xml");
		var e1Expl = new ParticlesEm(Game.game.layerAdd, tXml, "f_shell", Game.game.layerAdd);
		e1Expl.toRemove = true;
		e1Expl.emitStart(body.position.x, body.position.y, 4);
		Game.game.emitters.push(e1Expl);
		#end
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