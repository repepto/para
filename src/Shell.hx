package;
import aze.display.TileLayer.TileBase;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.shape.Circle;
import particles.ParticlesEm;

class Shell extends LifeObject
{
	var flameEmitter:ParticlesEm;
	public var damageForce:Int;
	
	public function new(pos:Vec2, radius:Int, life:Int = 1, damageForce:Int = 40,
	graphic:TileBase = null, offsetY:Float = 0, flameEmitter:ParticlesEm = null)
	{
		super(life, new Body());
		
		this.flameEmitter = flameEmitter;
		this.damageForce = damageForce;
		
		body.shapes.add(new Circle(radius));
		body.position = pos;
		body.userData.graphic = graphic;
		body.userData.graphicOffset = new Vec2(0, offsetY);
		body.space = Game.game.space;
		body.cbTypes.add(Game.game.cbShell);
		body.shapes.at(0).filter.collisionGroup = 8;
		
		body.userData.shell = true;
		
		init();
	}
	
	override function clear() 
	{
		if (body == null) return;
		if (flameEmitter != null) flameEmitter.toRemove = true;
		super.clear();
	}
	
	override public function run():Void
	{
		if (body == null) return;
		if (flameEmitter != null) flameEmitter.emitStart(body.position.x, body.position.y, 1);
		super.run();
	}
}