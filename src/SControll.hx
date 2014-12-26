package;

//import haxe.Timer;
//import openfl.media.Sound;
//import openfl.media.SoundChannel;
import openfl.media.SoundTransform;
//import openfl.Assets;

//import flash.events.Event;
//import openfl.events.Event;

//import motion.Actuate;
//import motion.easing.Quad;



@:final
class SControll 
{
	
	
	/*var channel:SoundChannel;
	var position:Float;
	var sound:Sound;
	
	var loop:UInt;
	
	var sCount:Int = 0;
	
	var s_bg0:Sound;
	var s_bg1:Sound;
	var s_bg2:Sound;
	var s_bg3:Sound;
	var s_bg4:Sound;
	var s_p:Sound;*/
	
	
	public var vol:Float = .5;
	
	public function new()
	{
		Game.game.muz.play(0, 999999, new SoundTransform (vol, 0));
		
		/*s_bg0 = Game.game.s_bg0;
		s_bg1 = Game.game.s_bg1;
		s_bg2 = Game.game.s_bg2;
		s_bg3 = Game.game.s_bg3;
		s_bg4 = Game.game.s_bg4;
		s_p = Game.game.s_p;
		
		sound = s_bg0;
		play (0);
		loop = 0;*/
	}
	
	/*private function channel_onSoundComplete (event:Event):Void 
	{
		s_pause();
		switch(sCount)
		{
			case 0: sound = s_bg0; loop = 4; s_p.play();
			case 1: sound = s_bg1; loop = 4; s_p.play();
			case 2: sound = s_bg2; loop = 4; s_p.play();
			case 3: sound = s_bg3; loop = 4; s_p.play();
			case 4: sound = s_bg4; loop = 4; s_p.play(); sCount = 0;
		}
		sCount++;
		play (0);
		position = 0;
		
	}
	
	public function s_pause (fadeOut:Float = 0):Void {
		
		//if (sndAllow) 
		{
			
			//playing = false;
			
			Actuate.transform (channel, fadeOut).sound (0, 0).onComplete (function () {
				position = channel.position;
				channel.removeEventListener (Event.SOUND_COMPLETE, channel_onSoundComplete);
				channel.stop ();
				channel = null;
				
			});
			
		}
		
	}
	
	public function play (fadeIn:Float = .4, fromBegin:Bool = true):Void {
		
		//if (!sndAllow) return;
		
		if (fromBegin) position = 0;
		
		if (fadeIn <= 0) {
			
			channel = sound.play (position, loop, new SoundTransform (vol, 0));
			
		} else {
			
			channel = sound.play (position, loop, new SoundTransform (0, 0));
			Actuate.transform (channel, fadeIn).sound (vol, 0);
			
		}
		
		channel.addEventListener (Event.SOUND_COMPLETE, channel_onSoundComplete);
	}*/
}