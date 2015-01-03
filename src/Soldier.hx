package;
import aze.display.TileGroup;
import nape.dynamics.InteractionFilter;
import nape.geom.Ray;
import nape.geom.RayResult;
import nape.phys.Body;
import nape.geom.Vec2;
import aze.display.TileClip;
import nape.phys.BodyList;
import nape.shape.Circle;
import openfl.Assets;
import openfl.geom.Point;
import openfl.media.Sound;
import particles.ParticlesEm;

class Soldier extends LifeObject
{
	
	var go:TileClip;
	var shoot:TileClip;
	var stay:TileClip;
	var direction:Int;
	var dmgRadius:UInt;
	var target:Body;
	var velocity:Float;
	var damageForce:Float;
	var skin:TileGroup;
	var retreatPoint:Float;
	var raiderUderAttackEmitter:ParticlesEm;
	
	var s_f:Sound;
	var sT:UInt = 0;
	
	public function new(life:Int)
	{
		super(life, new Body());
		s_f = Game.game.soldatus;
		
		retreatPoint = -1000;
		
		var tXml = Assets.getText("xml/riderUnderAttack.xml");
		raiderUderAttackEmitter = new ParticlesEm(Game.game.layerAdd, tXml, "f_shell", Game.game.layerAdd);
		Game.game.emitters.push(raiderUderAttackEmitter);
		
		shoot = new TileClip(Game.game.layer, "zshoot", 44);
		shoot.offset = new Point(-14, 0);
		go = new TileClip(Game.game.layer, "zrun");
		stay = new TileClip(Game.game.layer, "zstay");
		skin = new TileGroup(Game.game.layer);
		skin.addChild(go);
		Game.game.layer.addChild(skin);
		skin.y = -8;
		
		body.group = Game.game.defendersGroup;
		body.cbTypes.add(Game.game.cbCannon);
		body.cbTypes.add(Game.game.cbSoldiers);
		body.shapes.add(new Circle(12));
		body.position = new Vec2(1030, 550);
		body.space = Game.game.space;
		body.userData.graphic = skin;
		
		Game.game.activeSoldiers++;
		
		dmgRadius = 70 + Math.round(Math.random() * 100);
		velocity = 17 - Math.random() * 3;
		damageForce = .002 * 25;
		
		targetCheck();
		init(true);
	}
	
	override public function destruction() 
	{
		if (body == null) return;
		Game.game.playS(Game.game.s_aaa);
		if(Game.game.shopItems[2] > 1)Game.game.shopItems[2]--;
		super.destruction();
	}
	
	function turn(dir:Int)
	{
		go.scaleX = shoot.scaleX = stay.scaleX = dir;
		
	}
	
	function skinManage(activeSkin:TileClip)
	{
		skin.removeAllChildren();
		skin.addChild(activeSkin);
	}
	
	function stop()
	{
		body.angularVel = body.velocity.x = 0;
	}
	
	function walk()
	{
		var filter:InteractionFilter = new InteractionFilter(1, 3, 1, 3);
		var rayRes:RayResult = null;
		var step = -80;
		
		while (rayRes == null && step != 0)
		{
			var ray:Ray = new Ray(new Vec2(body.position.x, body.position.y + step), new Vec2(direction, 0));
			ray.maxDistance = 100;
			rayRes = Game.game.space.rayCast(ray, false, filter);
			step += 20;
		}
		
		if (rayRes != null && rayRes.shape.body != target && rayRes.shape.body != Game.game.b0Body) 
		{
			target = rayRes.shape.body;
			skinManage(stay);
			stop();
			if (retreatPoint != -1000 && (retreatPoint < body.position.x && target.position.x > body.position.x) || 
			(retreatPoint > body.position.x && target.position.x < body.position.x)) { }
			else return;
		}
		
		if (go.scaleX != direction) turn(direction);
		body.angularVel = velocity * direction;
	}
	
	override public function run() 
	{
		
		if (body == null) return;
		lookUp();
		
		if (retreatPoint != -1000)
		{
			if (go.parent == null)
			{
				skinManage(go);
			}
			direction = Math.round((retreatPoint - body.position.x) / Math.abs(retreatPoint - body.position.x));
			turn(direction);
			walk();
			if (Math.abs(retreatPoint - body.position.x) < 4) retreatPoint = -1000;
			return;
		}
		
		if (target != null && target.space != null)
		{
			if (Math.abs(body.position.x - target.position.x) > dmgRadius) 
			{
				if (go.parent == null)
				{
					skinManage(go);
				}
				walk();
				targetCheck();
			}
			else
			{
				if (target.position.y > 530)
				{
					if (shoot.parent == null)
					{
						skinManage(shoot);
						stop();
					}
					var dtY = 20 - Math.random() * 40;
					raiderUderAttackEmitter.emitStart(target.position.x - 10 * direction, target.position.y + dtY, 1);
					if (sT == 0)
					{
						if(Game.game.cannon.body != null) Game.game.playS(s_f);
						sT = 5;
					}
					else sT--;
				}
				else 
				{
					if (stay.parent == null)
					{
						skinManage(stay);
						stop();
					}
				}
				
				if ((body.position.x > target.position.x && shoot.scaleX == 1) || (body.position.x < target.position.x && shoot.scaleX == -1)) shoot.scaleX *= -1;
				
				if(Game.game.cannon.life > 0) target.userData.i.damage(damageForce);
				stop();
			}
		}
		else 
		{
			walk();
			targetCheck();
		}
		
		
		super.run();
	}
	
	function checkRetreat(dir:Int):Float
	{
		var filter:InteractionFilter = new InteractionFilter(1, 3, 1, 3);
		var rayRes:RayResult;
		var ray:Ray = new Ray(body.position, new Vec2(dir, 0));
		ray.maxDistance = 21;
		rayRes = Game.game.space.rayCast(ray, false, filter);
		
		
		
		if (rayRes == null) 
		{
			return body.position.x + 17 * dir;
		}
		else 
		{
			return -1000;
		}
	}
	
	function lookUp()
	{
		var ridersTop:BodyList = Game.game.space.bodiesInCircle(new Vec2(body.position.x, body.position.y - 40), 12);
		
		var rayRes:RayResult = null;
		var step = -12;
		var filter:InteractionFilter = new InteractionFilter(1, 3, 1, 3);
		
		while (rayRes == null && step != 24)
		{
			var ray:Ray = new Ray(new Vec2(body.position.x + step, body.position.y), new Vec2(0, -1));
			ray.maxDistance = 80;
			rayRes = Game.game.space.rayCast(ray, false, filter);
			step += 12;
		}
		
		if (rayRes != null && Type.getClassName(Type.getClass(rayRes.shape.body.userData.i)) == "RaiderShip")
		{
			target = rayRes.shape.body;
			
			if (rayRes.shape.body.position.x > body.position.x)
			{
				retreatPoint = checkRetreat(-1);
				if (retreatPoint == -1000) retreatPoint = checkRetreat(1);
			}
			else
			{
				retreatPoint = checkRetreat(1);
				if (retreatPoint == -1000) retreatPoint = checkRetreat(-1);
			}
		}
	}
	
	function targetCheck()
	{
		if (Game.game.ridersOnGround.length == 0)
		{
			target = null;
			direction = 1;
			if (go.parent == null)
			{
				skinManage(go);
				turn(direction);
			}
			return;
		}
		
		var target:Body = Game.game.ridersOnGround[0].body;
		if (target == null || body == null) return;
		for (i in Game.game.ridersOnGround)
		{
			if (Math.abs(body.position.x - target.position.x) > Math.abs(body.position.x - i.body.position.x)) target = i.body;	
		}
		this.target = target;
		
		direction = Math.round((target.position.x - body.position.x) / Math.abs(target.position.x - body.position.x));
		turn(direction);
	}
	override public function clear() 
	{
		if (body == null) return;
		Game.game.activeSoldiers--;
		skin.removeAllChildren();
		if(skin.parent != null) skin.parent.removeChild(skin);
		raiderUderAttackEmitter.toRemove = true;
		super.clear();
	}
}