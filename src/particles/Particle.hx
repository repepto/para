package particles;

import aze.display.TileLayer;
import aze.display.TileSprite;

@:final
class Particle extends TileSprite
{
	var angle:Float;
	var finishScale:Float;
	var startScale:Float;
	public var isLive:Int;
	var scaleStep1:Float;
	var scaleStep:Float;
	var alphaStep1:Float;
	var alphaStep:Float;
	var middleScale:Float;
	var middleTime:Float;
	var rotationVel:Float;
	var gravX:Float;
	var gravY:Float;
	var vel:Float;
	var gravAY:Float;
	var gravAX:Float;
	var speedUp:Float;
	var allowVelNegative:Bool;
	var alphaIgnore:Bool;
	
	public function new (name:String, v:Float, spUp:Float, a:Float, avn:Int, l:Int, it:Int, ss:Float, ms:Float, fs:Float, rv:Float, sa:Int, ma:Int, fa:Int, gx:Float, gy:Float, ga:Float, gax:Float)
	{
		super(Game.ths.layer, name);
		
		angle = a;
		speedUp = spUp / 10;
		
		if (avn == 1) allowVelNegative = true
		else allowVelNegative = false;
		
		gravX = gx;
		gravY = gy;
		
		gravAY = ga * 10;
		gravAX = gax * 10;
		
		isLive = l;
		vel = v;
		
		scale = ss / 100;
		finishScale = fs / 100;
		middleScale = ms / 100;
		scaleStep = 0;
		
		rotationVel = rv;
		
		middleTime = 0;
		
		if (fa != 0 || sa != 0 || ma != 0)
		{
			alphaIgnore = false;
			alpha = sa / 100;
			alphaStep = alphaStep1 = 0;
		}
		else alphaIgnore = true;
		
		if (it != 0)
		{
			if (middleScale == 0) throw("Middlescale tag is not defined in xml");
			
			middleTime = isLive  * it / 100;
			
			scaleStep = (middleScale - scale) / middleTime;
			scaleStep1 = (finishScale - middleScale) / (isLive - middleTime);
			
			if (!alphaIgnore)
			{
				alphaStep = (ma/100-sa/100) / middleTime;
				alphaStep1 = (fa/100 - ma/100) / (isLive - middleTime);
			}
		}
		else 
		{
			scaleStep = (finishScale - scale) / isLive;
			scaleStep1 = 0;
			if (!alphaIgnore)
			{
				alphaStep = (fa / 100 - sa / 100) / isLive;
				alphaStep1 = 0;
			}
		}
	}
	
	public function live()
	{
		x += vel * Math.cos(angle) + gravX;
		y += vel * Math.sin(angle) + gravY;
		
		if (speedUp != 0) 
		{
			vel += speedUp;
			if (!allowVelNegative && vel < 0) 
			{
				vel = 0;
				speedUp = 0;
			}
		}
		
		
		if (gravAY != 0)
		{
			gravY += gravAY;
		}
		if (gravAX != 0)
		{
			gravX += gravAX;
		}
		
		if (middleTime > 0)
		{
			scale += scaleStep;
			if (!alphaIgnore) alpha += alphaStep;
			middleTime--;
		}
		else 
		{
			if (!alphaIgnore)
			{
				if (alphaStep1 != 0) alpha += alphaStep1
				else alpha += alphaStep;
			}
			
			if (scaleStep1 != 0) scale += scaleStep1
			else scale += scaleStep;
		}
		
		if (rotationVel != 0) rotation += rotationVel;
		
		isLive--;
	}
}