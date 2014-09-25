package;
import aze.display.SparrowTilesheet;
import aze.display.TileClip;
import aze.display.TileGroup;
import aze.display.TileLayer;
import aze.display.TileSprite;
import haxe.xml.Fast;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.constraint.Constraint;
import nape.constraint.ConstraintList;
import nape.dynamics.CollisionArbiter;
import nape.geom.AABB;
import nape.shape.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import nape.callbacks.CbType;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.shape.Circle;
import nape.shape.Polygon;
import nape.space.Space;
import nape.util.BitmapDebug;
import nape.phys.BodyType;
import nape.dynamics.InteractionGroup;
import nape.callbacks.CbEvent;
import nape.callbacks.InteractionType;
import flash.events.TouchEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import flash.net.SharedObject;
import flash.net.SharedObjectFlushStatus;
import flash.Lib;

import haxe.Timer;
import openfl.Assets;
import openfl.events.TouchEvent;

import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import haxe.ds.Vector.Vector;

import motion.Actuate;
import motion.easing.Quad;
import motion.easing.Bounce;

import particles.ParticlesEm;

#if mobile
import googleAnalytics.Stats;
import admob.AD;
#end

@:final
class Game extends Sprite 
{
	#if flash
	var debug:BitmapDebug = new BitmapDebug(1000, 640, 0, true);
	#elseif mobile
	var ID:String = "ca-app-pub-2424644299316860/6027452437";
	var gID:String = "UA-51825443-11";
	#end
	
	public static var ths:Game;
	public var noClick:Bool;
	public var so:SharedObject;
	
	var ln:UInt;
	
	public var layer:TileLayer;
	
	var isGame:Bool;
	var pause:Bool;
	
	public var space:Space;
	
	
	var emitters:Array<ParticlesEm>;
	
	
	public function new()
	{
		super();
		
		#if mobile
		//AD.initInterstitial(ID);
		//Stats.init(gID, 'testing.wuprui.com');
		#end
		
		/*Lib.current.stage.addEventListener (MouseEvent.MOUSE_DOWN, md);
		Lib.current.stage.addEventListener (MouseEvent.MOUSE_UP, mu);
		Lib.current.stage.addEventListener (KeyboardEvent.KEY_UP, keyUp);
		Lib.current.stage.addEventListener (KeyboardEvent.KEY_DOWN, keyDown);*/
		
		Lib.current.stage.addEventListener (TouchEvent.TOUCH_BEGIN, touchBegin);
		Lib.current.stage.addEventListener (TouchEvent.TOUCH_END, touchEnd);
		
		
		
		space = new Space(new Vec2(0, 800));
		
		var sheetData = Assets.getText("ts/texture.xml");
		var tilesheet = new SparrowTilesheet(Assets.getBitmapData("ts/texture.png"), sheetData);
		layer = new TileLayer(tilesheet);
		addChild(layer.view);
		
		var bg = new TileSprite(layer, "bg");
		bg.x = 500;
		bg.y = 300;
		layer.addChild(bg);
		
		layer.render();
		
		
		emitters = new Array();
		
		var tXml:String;
		
		/*tXml = Assets.getText("part/puzirlop.xml");
		var np = 0;
		#if html5
		if (Main.mBrowser && !Main.isGpuEnabled) np = 4;
		#end
		puzirLop = new ParticlesEm(layer, tXml, "plop", gGroup, np);*/
		
		
		//emitters.push(love);
		
		//life = new TileSprite(layer, "life");
		
		
		addEventListener (Event.ENTER_FRAME, this_onEnterFrame);
		
		/*space.listeners.add(new InteractionListener(
                CbEvent.BEGIN,
                InteractionType.COLLISION,
                cbPar,
                cbSamka,
                par_samka
            ));
			
		space.listeners.add(new InteractionListener(
                CbEvent.ONGOING,
                InteractionType.SENSOR,
                cbPar,
                cbPauk,
                par_pauk
            ));
		*/
		
		#if flash
		addChild(debug.display);
		debug.drawConstraints = true;
		#end
		
	}
	
	
	public function save()
	{
		//so.data.demoOs = demoOs;
		
		#if ( cpp || neko || html5)
		var flushStatus:SharedObjectFlushStatus = null;
		#else
		var flushStatus:String = null;
		#end

		try
		{
			flushStatus = so.flush() ;
		}
		catch ( e: Dynamic )
		{
			//trace("couldnt write...");
		}

		if ( flushStatus != null )
		{
			switch( flushStatus )
			{
			case SharedObjectFlushStatus.PENDING:
			//trace('requesting permission to save');
			case SharedObjectFlushStatus.FLUSHED:
			//trace('value saved');
			}
		}
	}
	
	
	
	
	
	/*function egg_gr(cb:InteractionCallback)
	{
		var b:Body = cb.int1.castBody;
	}*/
	
	
	
	function clear()
	{
		
		while (space.bodies.length > 0)
		{
			var b = space.bodies.pop();
			var cl = b.constraints;
			while (cl.length > 0) cl.pop().space = null;
			b.space = null;
			b = null;
		}
		
		layer.removeAllChildren();
	}
	
	
	public function eol()
	{
		
		
	}
	
	function eog()
	{
		
		
		
	}
	
	public function mu(e:Dynamic)
	{
		e.stopImmediatePropagation();
		
		if (noClick) return;
		
		#if mobile
		var ex = e.localX / scaleX;
		var ey = e.localY / scaleY;
		#else
		var ex = e.localX / 1;
		var ey = e.localY / 1;
		#end
	}
	
	public function touchBegin(e:TouchEvent)
	{
		trace(e.localX);
	}
	
	public function touchEnd(e:TouchEvent)
	{
		trace(e.localX);
	}
	
	public function keyUp(e:KeyboardEvent)
	{
		//trace(e.keyCode);
	}
	
	public function keyDown(e:KeyboardEvent)
	{
		
	}
	
	
	
	function graphicUpdate()
	{
		for (i in 0...space.liveBodies.length) 
		{
			var body:Body = space.liveBodies.at(i);
			
			var graphic:Dynamic = body.userData.graphic;
			if (graphic == null) continue;
			
			var graphicOffset:Vec2 = body.userData.graphicOffset;
			if (graphicOffset == null) graphicOffset = new Vec2();
			var position:Vec2 = new Vec2();
			position = body.localPointToWorld(graphicOffset);
			
			graphic.x = position.x;
			graphic.y = position.y;
			
			if (Type.getClassName(Type.getClass(graphic)) == "aze.display.TileSprite") 
			cast(graphic, TileSprite).rotation = body.rotation;
			position.dispose();
		}
	}
	
	
	function init()
	{
		
	}
	
	
	function xmlParserCh(n:String = "xmls/l0.xml")
	{
		var xml = Xml.parse(Assets.getText(n));
		
		for (i in xml.elements())
		{
			var fast = new Fast(i);
			if (fast.att.className == "Rect")
			{
				/*var b = Nut.makeBody(BodyType.STATIC, 
				new Polygon(Polygon.rect( 0, 0, Std.parseInt(fast.att.width), Std.parseInt(fast.att.height))), 
				new Vec2(Std.parseInt(fast.att.x), Std.parseInt(fast.att.y)), null, cbGr);
				b.rotation = Std.parseInt(fast.att.rotation) * Math.PI / 180;
				b.space = space;*/
			}
			else if (fast.att.className == "Danger")
			{
				
			}
		}
	}
	
	function this_onEnterFrame (event:Event):Void 
	{
		layer.render();
		
		#if flash
		debug.clear(); debug.draw(space); debug.flush();
		#end
		
		var step = 1 / 60;
		
		#if html5
		var dt  = Date.now().getTime();
		step = dt - spaceTime;
		spaceTime = dt;
		step = 1 / (1000 / step);
		#end
		
		space.step(step);
		graphicUpdate();
	}
}