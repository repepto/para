package;
import aze.display.TileLayer;
import aze.display.TileLayer.TileBase;
import aze.display.TileSprite;
import nape.phys.Body;

class ControlledObject
{
	public var body:Body;
	var graphic:TileSprite;
	var inited:Bool = false;
	var targetLayer:TileLayer;
	
	public function new(body:Body)
	{
		this.body = body;
		body.userData.i = this;
		if ((Type.getClassName(Type.getClass(this)) == "CannonShell"))
		targetLayer = Game.game.layerAdd
		else targetLayer = Game.game.layer;
	}
	
	public function init(tileGr:Bool = false)
	{
		body.space = Game.game.space;
		Game.game.controlledObj.push(this);
		if (!tileGr) graphic = body.userData.graphic;
		if (body.userData.graphic != null) 
		{
			targetLayer.addChild(body.userData.graphic);
		}
	}
	
	public function run()
	{
		if (body == null) return;
		if (body.position.x < -140 || body.position.x > 1140)
		{
			clear();
			return;
		}
	}
	
	public function destruction() 
	{
		if (body == null) return;
		clear();
	}
	
	public function clear()
	{
		if (body == null) return;
		
		if (body.userData.graphic != null && body.userData.graphic.parent != null) 
		{
			body.userData.graphic.parent.removeChild(body.userData.graphic);
			body.userData.graphic = null;
		}
		
		body.shapes.clear();
		body.cbTypes.clear();
		body.userData.i = null;
		body.space = null;
		body.arbiters.clear();
		body.zpp_inner.clear();
		body = null;
		Game.game.controlledObj.remove(this);
	}
}