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

class Messile extends Shell
{	
	var target:Body;
	var targetAng:Float;
	var vel = 420;
	var step:Float = 0;
	
	public function new(pos:Vec2)
	{
		super(pos, 14, 100, 500);
		
		body.userData.graphic = new TileSprite(Game.game.layer, "missileE");
		Game.game.layer.addChild(body.userData.graphic);
		
		body.shapes.at(0).sensorEnabled = true;
		Timer.delay(function() { body.shapes.at(0).sensorEnabled = false; }, 1000);
		
		flameEmitter = new ParticlesEm(Game.game.layerAdd, Assets.getText("xml/smoke_big.xml"), "smoke", Game.game.layerAdd);
		Game.game.emitters.push(flameEmitter);
	}
	
	function checkTar()
	{
		var dist = 2000.0;
		for (i in Game.game.controlledObj)
		{
			if (i.body.userData.shell != null || i.body.position.y > 400) continue;
			
			var td = Mut.distV2(i.body.position, body.position);
			if (td < dist)
			{
				dist = td;
				target = i.body; 
			}
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
		
		var tarPos:Vec2 = null;
		
		if (target == null)
		{
			checkTar();
			tarPos = new Vec2(500, -200);
		}
		else tarPos = target.position;
		
		targetAng = Mut.getAng(body.position, tarPos);
		if (Math.abs(targetAng - body.rotation) > Math.PI) targetAng += 2 * Math.PI;
		
		step = (targetAng - body.rotation) / 30;
		step = .05 * Math.abs(step) / step;
		if (Math.abs(targetAng - body.rotation) > step) body.rotation += step;
		body.velocity.setxy(vel * Math.cos(body.rotation), vel * Math.sin(body.rotation));
		super.run();
	}
}