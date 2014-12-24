package;

import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.media.SoundTransform;
import openfl.Assets;

//import flash.events.Event;
import openfl.events.Event;

import motion.Actuate;
import motion.easing.Quad;



@:final
class CyclingS
{
	var channel:SoundChannel;
	var sound:Sound;
	
	public var vol:Float = 1;
	
	public function new(s:Sound)
	{
		sound = s;
		channel = sound.play (0, 999999, new SoundTransform (vol, 0));
		stop();
	}
	
	public function stop (fadeOut:Float = 0, fx:Sound = null):Void {
		
		Actuate.transform (channel, fadeOut).sound (0, 0);
		if (fx != null) Game.game.playS(fx);
		
	}
	
	public function start (fadeOut:Float = 0):Void {
		
		if (Game.game.fxFlag) vol = 1
		else vol = 0;
		Actuate.transform (channel, fadeOut).sound (vol, 0);
	}
}