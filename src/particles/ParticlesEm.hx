package particles;
import aze.display.TileGroup;
import aze.display.TileLayer;

@:final
class ParticlesEm
{
	public var toRemove:Bool;
	
	var rStartX:Int = 0;
	var rStartY:Int = 0;
	var startRadius:Int = 0;
	
	var numParticles:Int = 0;
	var life:Int = 0;
	var randomLife:Int = 0;
	
	var interTime:Int = 0;
	var randomInterTime:Int = 0;
	
	var vel:Int = 0;
	var randomVel:Int = 0;
	var speedUp:Int = 0;
	var allowVelNegative:Int = 0;
	
	var angle:Float = 0;
	var spreadAngle:Float = 0;
	
	var sScale:Int = 0;
	var randomScaleStart:Int = 0;
	var mScale:Int = 0;
	var randomScaleInt:Int = 0;
	var fScale:Int = 0;
	var randomScaleFinish:Int = 0;
	
	var rotV:Float = 0;
	var randomRotDir:Int = 0;
	var randomRot:Float = 0;
	var randomRotStart:Int = 0;
	var setRotByDir:Int = 0;
	
	var sa:Int = 0;
	var ma:Int = 0;
	var fa:Int = 0;
	
	var randomGravY:Float = 0;
	
	var gravY:Float = 0;
	var gravX:Float = 0;
	var gravA:Float = 0;
	var gravAX:Float = 0;
	
	var delay:Int = 0;
	var del:Int = 0;
	
	
	
	
	public var particles:Array<Particle>;
	public var pName:String;
	public var eTimes:Int = 0;
	var x:Float = 0;
	var y:Float = 0;
	
	var parent:TileLayer;
	
	var layer:TileLayer;
	
	
	public function new (tileL:TileLayer, xmlS:String, name:String, prnt:TileLayer, numPar:UInt = 0)
	{
		pName = name;
		
		layer = tileL;
		
		parent = prnt;
		
		particles = new Array();
		
		var xml = Xml.parse(xmlS);
		for ( elt in xml.elements() ) 
		{
			var value:Int = Std.parseInt(elt.firstChild().toString());
			switch(elt.nodeName)
			{
				case "RandomStartX": rStartX = value;
				case "RandomStartY": rStartY = value;
				case "StartRadius": startRadius = value;
				case "ParticlesPerIteration": numParticles = value;
				case "Life": life = value;
				case "RandomLife": randomLife = value;
				case "IntermediateTime": interTime = value;
				case "RandomInterTime": randomInterTime = value;
				case "Velocity": vel = value;
				case "RandomizeVelocity": randomVel = value;
				case "SpeedUp": speedUp = value;
				case "AllowVelNegative": allowVelNegative = value;
				case "Direction": angle = value * Math.PI / 180;
				case "SpreadDirection": spreadAngle = value * Math.PI / 180;
				case "StartScale": sScale = value;
				case "RandomScaleStart": randomScaleStart = value;
				case "IntermediateScale": mScale = value;
				case "RandomScaleIntermediate": randomScaleInt = value;
				case "FinishScale": fScale = value;
				case "RandomScaleFinish": randomScaleFinish = value;
				case "RotationVel": rotV = value / 200;
				case "RandomRotDir": randomRotDir = value;
				case "RandomizeRotVel": randomRot = value / 200;
				case "RandomRotStart": randomRotStart = value;
				case "SetRotByDir":setRotByDir = value;
				case "StartAlpha": sa = value;
				case "IntermediateAlpha": ma = value;
				case "FinishAlpha": fa = value;
				case "RandomGravY": randomGravY = value / 10;
				case "GravityY": gravY = value / 10;
				case "GravityX": gravX = value / 10;
				case "GravityA": gravA = value / 10;
				case "GravityAX": gravAX = value / 10;
				case "Delay": delay = value;
			}
		}
		
		if (delay != 0) del = 1;
		
		if (numPar != 0) numParticles = numPar;
	}
	public function emitStart(x:Float, y:Float, times:Int)
	{
		this.x = x;
		this.y = y;
		eTimes = times;
		if (times <= delay) throw(" class: ParticlesEm; function: emitStart >>> times should be > delay tag value defined in xml. TileSkin = " + pName);
	}
	
	public function emitStop()
	{
		eTimes = 0;
	}
	
	public function emit(x:Float, y:Float)
	{
		if (eTimes == 0) return;
		if (eTimes < 7777777) eTimes--;
		if (delay != 0)
		{
			if (del != 0) 
			{
				del --;
				return;
			}
			else del = delay;
		}
		var rotZnak = 1;
		
		for (i in 0...numParticles)
		{
			
			
			if (randomRotDir != 0) rotZnak *= -1;
			
			var pLife = Math.ceil(life + randomLife * Math.random());
			var a = angle + spreadAngle - 2 * Math.random() * spreadAngle;
			var v = vel/20 + randomVel * Math.random() / 20;
			var rv = rotV * rotZnak + randomRot - 2 * Math.random() * randomRot;
			
			if (interTime + randomInterTime > 99) throw(" emit 145: interTime + randomInterTime should be < 100");
			
			var it = interTime + Math.ceil(randomInterTime * Math.random());
			
			var particle = new Particle(layer, pName, v, speedUp, a, allowVelNegative, pLife, it, sScale + randomScaleStart * Math.random(), 
			mScale + randomScaleInt * Math.random(), fScale + randomScaleFinish * Math.random(),
			rv, sa, ma, fa, gravX / 100, (gravY + randomGravY / 2 - randomGravY * Math.random()) / 100, gravA / 100, gravAX / 100);
			
			particle.x = x + rStartX - rStartX * 2 * Math.random() + Math.cos(a) * startRadius;
			particle.y = y + rStartY - rStartY * 2 * Math.random() + Math.sin(a) * startRadius;
			if (randomRotStart != 0 && setRotByDir != 0) throw(" emit 139: randomRotStart, setRotByDir - one of them should be 0");
			if (randomRotStart != 0) particle.rotation = Math.random() * randomRotStart * Math.PI / 180
			else if (setRotByDir != 0) { particle.rotation = a;}
			parent.addChild(particle);
			particles.push(particle);
		}
	}
	
	public function onEnterFrame()
	{
		if (eTimes != 0)
		{
			emit(x, y);
		}
		
		for (i in 0...particles.length)
		{
			var p:Particle = particles[i];
			
			if (p != null)
			{
				
				if (p.isLive < 1) 
				{
					particles.remove(p);
					parent.removeChild(p);
					
					continue;
				}
				p.live();
			}
		}
	}
}