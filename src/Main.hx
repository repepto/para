package;

//import flash.display.Sprite;
//import flash.events.Event;
//import flash.Lib;

import openfl.display.Sprite;
import openfl.events.Event;
import openfl.Lib;
import openfl.ui.Multitouch;
import openfl.ui.MultitouchInputMode;

import haxe.Timer;


class Main extends Sprite 
{
	var inited:Bool;
	var game:Game;
	
	#if flash
	function domainIs(domain:String)
	{
		var thisURL = Lib.current.loaderInfo.url;
		if (Lib.current.loaderInfo.url.substr(0, 5) == "file:") return true;
		if (thisURL.indexOf("http://www") > -1) thisURL = thisURL.substr(11,thisURL.length-11)
		else if (thisURL.indexOf("https://www") > -1) thisURL = thisURL.substr(12,thisURL.length-12)
		else thisURL = thisURL.substr(7,thisURL.length-7);
		
		if (thisURL.indexOf("/") > 0)  thisURL = thisURL.substr(0, thisURL.indexOf("/"));
		if (thisURL == domain) return true;
		else return false;
	}
	#end
	
	function resize(width:Float, height:Float) 
	{
		var scX = width / 1000;
		var scY = height / 600;
		
		game.kX = scX;
		game.kY = scY;
		
		var sc:Float;
		
		if (scX > scY)
		{
			sc = scY;
			game.wallPosition = 2;
		}
		else if (scX < scY)
		{
			sc = scX;
			game.wallPosition = 1;
		}
		else
		{
			sc = scX;
			game.wallPosition = 0;
		}
		
		game.scaleX = sc;
		game.scaleY = sc;
		
		game.x = (width - 1000 * sc) / 2;
		game.y = (height - 600 * sc) / 2;
	}
	
	private function stage_onResize (event:Event):Void 
	{
		if (!inited) return;
		resize (stage.stageWidth, stage.stageHeight);
	}
	
	function init() 
	{
		#if flash
		if (domainIs("flashgamelicense.com") || domainIs("tabletcrushers.com")) 
		{
			
		}
		else return;
		#end
		
		if (inited) return;
		inited = true;
		
		game = new Game();
		addChild(game);
		resize(stage.stageWidth, stage.stageHeight);
	}

	public function new() 
	{
		super();
		Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
		addEventListener(Event.ADDED_TO_STAGE, added);
	}

	function added(e) 
	{
		removeEventListener(Event.ADDED_TO_STAGE, added);
		stage.addEventListener(Event.RESIZE, stage_onResize);
		#if ios
		haxe.Timer.delay(init, 100); // iOS 6
		haxe.Timer.delay(function(){ resize (stage.stageWidth, stage.stageHeight); }, 105);
		#else
		init();
		#end
	}
	
	public static function main() 
	{
		// static entry point
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Main());
	}
}