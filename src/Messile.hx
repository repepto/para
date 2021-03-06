package;
import aze.display.TileLayer.TileBase;
import aze.display.TileSprite;
import haxe.Timer;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.shape.Circle;
import openfl.Assets;
import particles.ParticlesEm;
import mut.Mut;
import motion.Actuate;
import motion.easing.Quad;

class Messile extends Shell
{	
	var target:Body;
	var targetAng:Float;
	var vel = 490;
	var step:Float = 0;
	
	public function new(pos:Vec2)
	{
		super(pos, 14, 100, 2500);
		
		body.userData.graphic = new TileSprite(Game.game.layer, "missileE");
		Game.game.layer.addChild(body.userData.graphic);
		
		body.group = Game.game.cShellGroup;
		
		body.shapes.at(0).sensorEnabled = true;
		Timer.delay(function() { if (body == null) return; body.shapes.at(0).sensorEnabled = false; }, 400);
		
		flameEmitter = new ParticlesEm(Game.game.layerAdd, Assets.getText("xml/smoke_big.xml"), "smoke", Game.game.layerAdd);
		Game.game.emitters.push(flameEmitter);
		
		checkTar();
	}
	
	override public function destruction() 
	{
		Game.game.s_s.emitStart(500, 500, 4);
		Game.game.explode(body.position.x, body.position.y, Game.game.layerAdd, "secondExpl_", 32, 2, Math.random() * Math.PI * 2, .7);
		super.destruction();
	}
	
	function checkTar()
	{
		target = null;
		
		for (i in Game.game.controlledObj)
		{
			var bdy:Body = i.body;
			
			if (bdy.space == null || bdy.userData.shell != null || bdy.userData.fragment != null || bdy.position.y > 470) continue;
			
			target = bdy;
			return;
		}
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
		
		var tarPos:Vec2;
		
		if (target == null || target.space == null) checkTar();
		
		if (target == null || target.space == null) tarPos = new Vec2(500, -200);
		else tarPos = target.position;
		
		targetAng = Mut.getAng(body.position, tarPos);
		
		body.rotation = targetAng;
		body.velocity.setxy(vel * Math.cos(body.rotation), vel * Math.sin(body.rotation));
		super.run();
	}
}