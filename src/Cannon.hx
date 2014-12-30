package;
import aze.display.TileClip;
import aze.display.TileLayer;
import aze.display.TileLayer.TileBase;
import aze.display.TileSprite;
import nape.callbacks.CbType;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.shape.Circle;
import nape.shape.Polygon;
import nape.phys.BodyType;
import motion.Actuate;
import motion.easing.Cubic;
import openfl.Assets;
import openfl.geom.Point;
import openfl.media.Sound;
import particles.ParticlesEm;
import openfl.media.SoundTransform;

class Cannon extends LifeObject
{
	var rotVel:Float;
	var rebound:Int;
	var flame:TileClip;
	var flameEmitter:ParticlesEm;
	var highlight:TileSprite;
	var energyBar:TileSprite;
	var addBarrel:TileSprite;
	var percent:Int; 
	var lifeBar:TileSprite;
	
	var attFlag:Bool = false;
	
	//var rotSound:CyclingS;
	
	var subMoney:UInt = 1;
	
	var isRotate:Bool = false;
	
	var shCur:Sound;
	
	public var direction:Int = 0;
	
	public function new(body:Body, flame:TileClip, highlight:TileSprite, flameEmitter:ParticlesEm = null, life:Int = 1000, rotVel:Float = .7, rebound = 20):Void
	{
		super(life, body);
		
		//rotSound = new CyclingS(Game.game.rotSound);
		
		var type = 0;
		
		switch(Game.game.upgradesProgress[0])
		{
			case 1: type = 1; subMoney = 2;
			case 2: type = 2; subMoney = 5;
			case 3: type = 3; subMoney = 10;
			case 4: type = 4; subMoney = 14;
			case 5: type = 5; subMoney = 20;
		}
		
		switch(Game.game.upgradesProgress[1])
		{
			case 1: subMoney += 2;
			case 2: if(type < 2) type = 2; subMoney += 5;
			case 3: if(type < 3) type = 3; subMoney += 10;
			case 4: if(type < 4) type = 4; subMoney += 14;
			case 5: if(type < 5) type = 5; subMoney += 20;
		}
		
		switch(type)
		{
			case 1: shCur = Game.game.sh1;
			case 2: shCur = Game.game.sh2;
			case 3: shCur = Game.game.sh3;
			case 4: shCur = Game.game.sh4;
			case 5: shCur = Game.game.sh5;
		}
		
		lifeBar = new TileSprite(Game.game.layer, "lb");
		lifeBar.x = 500;
		lifeBar.y = 1;
		Game.game.layer.addChild(lifeBar);
		
		energyBar = new TileSprite(Game.game.layer, "cannon_e");
		energyBar.offset = new Point(-35, 0);
		energyBar.x = 500 - 35;
		energyBar.y = 568;
		energyBar.scaleX = 0;
		Actuate.tween(energyBar, 1, { scaleX:1 } );
		Game.game.layer.addChild(energyBar);
		
		percent = life;
		
		body.group = Game.game.defendersGroup;
		body.shapes.at(0).filter.collisionGroup = 4;
		body.shapes.at(1).filter.collisionGroup = 4;
		
		this.rotVel = rotVel;
		this.rebound = rebound;
		this.flame = flame;
		this.flameEmitter = flameEmitter;
		this.highlight = highlight;
		if (highlight != null) 
		{
			highlight.alpha = 0;
		}
		
		if (Game.game.upgradesProgress[1] > 0) 
		{
			addBarrel = new TileSprite(Game.game.layer, "cannon_add_" + Game.game.upgradesProgress[1]);
			Game.game.layer.addChild(addBarrel);
		}
		
		
		init();
	}
	
	override public function damage(force:Float) 
	{
		if (Game.game.b0Timer != 0) return;
		super.damage(force);
		lifeBar.scaleX = life / percent;
		if (life < 70 && life > 0 && !attFlag) 
		{
			Game.game.playS(Game.game.attetionlpl);
			attFlag = true;
		}
	}
	
	override public function init(tileGr:Bool = false) 
	{
		super.init();
		Game.game.emitters.push(flameEmitter);
	}
	
	override public function destruction() 
	{
		if (body == null || lifeBar.parent == null) return;
		//super.destruction();
		life = 0;
		Game.game.layer.removeChild(lifeBar);
		
		Game.game.explode(body.position.x, body.position.y - 120, Game.game.layer, "swcondFog");
		Game.game.explode(body.position.x, body.position.y, Game.game.layerAdd, "secondExpl_", 32, 2, Math.random() * Math.PI * 2, .7);
		Game.game.explode(body.position.x, body.position.y, Game.game.layer, "firstFog_", 44, .5, Math.random() * Math.PI * 2);
		Game.game.explode(body.position.x, body.position.y, Game.game.layerAdd, "secondExpl_", 25, .5, Math.random() * Math.PI * 2);
		
		Game.game.prepareCannonToDeactivate();
	}
	
	override public function run():Void
	{
		if (body == null) return;
		if (addBarrel != null)
		{
			addBarrel.x = body.userData.graphic.x;
			addBarrel.y = body.userData.graphic.y;
			addBarrel.rotation = cast(body.userData.graphic, TileSprite).rotation;
		}
		
		if (Game.game.gameStatus == 4) return;
		
		if (Game.game.gameStatus == 3) 
		{
			body.angularVel = direction * rotVel;
			Game.game.gui.setNoClick(7000);
			
			if (Math.abs(body.rotation) <= .1) 
			{
				
				body.rotation = 0;
				if (Game.game.gameStatus != 4) 
				{
					Game.game.gameStatus = 4;
					Game.game.endBattle();
				}
				direction = 0;
				return;
			}
			if (!isRotate)
			{
				//rotSound.start(.2);
				Game.game.channelR.soundTransform = new SoundTransform(1);
				isRotate = true;
			}
			return;
		}
		
		if (energyBar.scaleX < 1)
		{
			energyBar.scaleX += Game.game.cannonEnergyStepAdd;
			if (energyBar.scaleX > 1) energyBar.scaleX = 1;
		}
		
		if (direction == 0)
		{
			if (body.allowRotation) 
			{
				body.allowRotation = false;
				body.angularVel = 0;
			}
			
			if (isRotate)
			{
				//rotSound.stop(.2, Game.game.rotStop);
				Game.game.rotStop.play();
				Game.game.channelR.soundTransform = new SoundTransform(0);
				isRotate = false;
			}
		}
		else
		{
			if (body.rotation > - 1.32 && body.rotation < 1.32)
			{
				if (!body.allowRotation) body.allowRotation = true;
				body.angularVel = direction * rotVel;
			}
			else 
			{
				if (body.rotation < - 1.32) body.rotation = -1.31
				else body.rotation = 1.31;
				direction = 0;
			}	
			
			if (!isRotate)
			{
				Game.game.channelR.soundTransform = new SoundTransform(1);
				isRotate = true;
			}
		}
		
	}
	
	override public function clear()
	{
		if (body == null) return;
		super.clear();
		if (flame != null && flame.parent != null) Game.game.layerAdd.removeChild(flame);
		if(flameEmitter != null) flameEmitter.toRemove = true;
		if (highlight != null && highlight.parent != null) highlight.parent.removeChild(highlight);
		if (addBarrel != null) Game.game.layer.removeChild(addBarrel);
		Game.game.layer.removeChild(energyBar);
		Game.game.channelR.soundTransform = new SoundTransform(0);
	}
	
	function shell(pos:Vec2, gr:TileBase, radius, offst:Float, xmlName:String = null, partName:String = null, vel:UInt = 200, dmg:UInt = 100)
	{
		var smoke:ParticlesEm = null;
		
		if (partName != null)
		{
			smoke = new ParticlesEm(Game.game.layerAdd, Assets.getText("xml/" + xmlName + ".xml"), partName, Game.game.layerAdd);
			Game.game.emitters.push(smoke);
		}
		
		var s = new CannonShell(pos, radius, 10, body.rotation - Math.PI / 2, vel, dmg, gr, 10, smoke);
		s.body.shapes.at(0).filter.collisionGroup = 14;
	}
	
	public function fire():Void
	{
		if (body == null || energyBar.scaleX < 1)
		{
			return;
		}
		energyBar.scaleX = 0;
		
		Game.game.playS(shCur);
		
		var offst = graphic.height / 2 + flame.height / 2;
		var pos = new Vec2(graphic.x + (offst - rebound - 10) * Math.cos(body.rotation - Math.PI / 2), graphic.y + (offst - rebound - 10) * Math.sin(body.rotation - Math.PI / 2));
		
		var gr:TileBase = null;
		var xmlName:String = null;
		var partName:String = null;
		var radius = 5;
		var dmg = 100;
		var vel = 200;
		
		switch(Game.game.upgradesProgress[0])
		{
			case 1: 
				xmlName = "smoke_f1";
				partName = "f_part";
				radius = 5;
				gr = new TileSprite(Game.game.layer, "cS");
				vel = 200;
			case 2: 
				radius = 7;
				xmlName = "smoke_f1";
				partName = "smoke";
				gr = new TileSprite(Game.game.layerAdd, "f_shel_base");
				dmg = 120;
				vel = 300;
				
			case 3: 
				radius = 10;
				gr = new TileClip(Game.game.layerAdd, "cShellF1_00008_", 25);
				dmg = 140;
				vel = 400;
			case 4: 
				radius = 10;
				gr = new TileClip(Game.game.layerAdd, "cShellF2_", 25);
				dmg = 160;
				vel = 500;
			case 5: 
				radius = 10;
				gr = new TileClip(Game.game.layerAdd, "cShellF3", 25);
				dmg = 200;
				vel = 700;
		}
		
		
		if (Game.game.money >= subMoney) 
		{
			Game.game.money -= subMoney;
			Game.game.moneyGr.newValue("" + Game.game.money, true);
		}
		shell(pos, gr, radius, offst, xmlName, partName, vel, dmg);
		
		var gr1:TileBase = null;
		if (Game.game.upgradesProgress[1] > 0)
		{
			switch(Game.game.upgradesProgress[1])
			{
				case 1: 
					gr = new TileSprite(Game.game.layer, "cS");
					gr1 = new TileSprite(Game.game.layer, "cS");
					xmlName = null;
					partName = null;
					radius = 2;
					vel = 200;
					dmg = 40;
				case 2: 
					gr = new TileSprite(Game.game.layerAdd, "f_shel_base");
					gr1 = new TileSprite(Game.game.layerAdd, "f_shel_base");
					xmlName = null;
					partName = null;
					radius = 4;
					vel = 300;
					dmg = 70;
				case 3: 
					gr = new TileClip(Game.game.layerAdd, "cShellF1_00008_", 25);
					gr1 = new TileClip(Game.game.layerAdd, "cShellF1_00008_", 25);
					xmlName = null;
					partName = null;
					radius = 8;
					vel = 400;
					dmg = 100;
				case 4: 
					gr = new TileClip(Game.game.layerAdd, "cShellF2_", 25);
					gr1 = new TileClip(Game.game.layerAdd, "cShellF2_", 25);
					xmlName = null;
					partName = null;
					radius = 10;
					vel = 500;
					dmg = 120;
				case 5: 
					gr = new TileSprite(Game.game.layer, "cShellF3");
					gr1 = new TileClip(Game.game.layerAdd, "cShellF3", 25);
					xmlName = null;
					partName = null;
					radius = 10;
					vel = 700;
					dmg = 140;
			}
			
			shell(new Vec2(pos.x + 22 * Math.cos(body.rotation), pos.y + 30 * Math.sin(body.rotation)), gr1, radius, offst, null, null, vel, dmg);
			shell(new Vec2(pos.x - 22 * Math.cos(body.rotation), pos.y - 30 * Math.sin(body.rotation)), gr, radius, offst, null, null, vel, dmg);
		}
		
		body.rotation -= 0.0000001;
		body.rotation += 0.0000001;
		body.userData.graphicOffset.setxy(0, 0);
		Actuate.tween(offset, .3, { y: offset.y - rebound } ).ease(Cubic.easeOut);
		
		
		
		if (flame != null)
		{
			if (flame.parent == null) Game.game.layerAdd.addChild(flame);
			flame.rotation = body.rotation;
			flame.x = pos.x;
			flame.y = pos.y;
			flame.play();
		}
		
		if (flameEmitter != null) flameEmitter.emitStart(graphic.x + (offst - rebound - 40) * Math.cos(body.rotation - Math.PI / 2),
		graphic.y + (offst - rebound - 40) * Math.sin(body.rotation - Math.PI / 2), 1);
		
		if (highlight != null) 
		{
			Game.game.layerAdd.addChild(highlight);
			highlight.x = graphic.x;
			highlight.y = graphic.y;
			highlight.alpha = 1;
			Actuate.tween(highlight, 1, { alpha: 0 } ).ease(Cubic.easeOut).onComplete(function():Dynamic
			{
				if(highlight.parent != null) highlight.parent.removeChild(highlight);
				return null;
			});
		}
	}
}