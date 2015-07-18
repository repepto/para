package;
import aze.display.TileClip;
import aze.display.TileSprite;
import haxe.Timer;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.shape.Circle;
import openfl.Assets;
import particles.ParticlesEm;

class Fragment extends ControlledObject
{
	var emitter:ParticlesEm;
	var force:Int;
	var angle:Float;
	var arr:Array<Dynamic>;
	var fName:String;
	
	public function new(frc:UInt=10, n:String="fragment")
	{
		super(new Body());
		
		fName = n;
		
		body.shapes.add(new Circle(4));
		body.userData.graphic = graphic;
		body.shapes.at(0).sensorEnabled = true;
		
		body.shapes.at(0).filter.collisionGroup = 8;
		
		force = Math.round(frc + Math.random() * 3 * frc);
		angle  = -Math.random() * Math.PI;
		
		arr = Game.game.fragments;
		
		initFrag();
	}
	
	function initFrag()
	{
		if(fName == "fragment") if (Math.random() < .5) fName = "f_frag";
		
		if (fName != "enemyBig1_p" && fName != "enemyBig_p" && fName != "enemyBig_p1") 
		{
			graphic = new TileClip(Game.game.layer, fName, 25);
			graphic.scale = .3 + Math.random() * .7;
		}
		else graphic = new TileSprite(Game.game.layer, fName);
		
		graphic.rotation = Math.random() * Math.PI;
		body.userData.graphic = graphic;
		
		#if !flash
		var sm = "xml/smoke_black.xml";
		if (graphic.scale < .4) sm = "xml/smoke_black_small.xml";
		
		var tXml = Assets.getText(sm);
		emitter = new ParticlesEm(Game.game.layer, tXml, "smoke_black", Game.game.layer);
		#end
	}
	
	public function init_(position:Vec2)
	{
		body.position = position;
		body.space = Game.game.space;
		body.velocity.setxy(0, 0);
		body.force.setxy(0,0);
		body.applyImpulse(new Vec2(Math.cos(angle) * force, Math.sin(angle) * force));
		arr.remove(this);
		Game.game.controlledObj.push(this);
		#if !flash
		emitter.toRemove = false;
		if (Game.game.emitters.lastIndexOf(emitter) == -1) Game.game.emitters.push(emitter);
		#end
		
		Game.game.layer.addChild(graphic);
	}
	
	override public function run() 
	{
		if (body.position.y > 610)
		{
			clear();
			return;
		}
		#if !flash
		emitter.emitStart(body.position.x, body.position.y, 1);
		#end
		super.run();
	}
	
	
	
	override public function clear() 
	{
		if (body.space == null) return;
		#if !flash
		emitter.toRemove = true;
		#end
		Game.game.layer.removeChild(graphic);
		body.space = null;
		if (fName != "enemyBig1_p" && fName != "enemyBig_p" && fName != "enemyBig_p1") arr.push(this);
		Game.game.controlledObj.remove(this);
	}
}