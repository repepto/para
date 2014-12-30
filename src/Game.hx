package;
import aze.display.SparrowTilesheet;
import aze.display.TileClip;
import aze.display.TileGroup;
import aze.display.TileLayer;
import aze.display.TileSprite;


import particles.Particle;
//#if cpp import cpp.vm.Gc;#end
import haxe.xml.Fast;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.constraint.Constraint;
import nape.constraint.ConstraintList;
import nape.dynamics.CollisionArbiter;
import nape.geom.AABB;
import nape.shape.Shape;
import openfl.display.Sprite;
//import flash.display.Sprite;
//import flash.events.Event;
import openfl.events.Event;
//import flash.events.MouseEvent;
import openfl.events.MouseEvent;
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
//import flash.events.TouchEvent;
import openfl.events.TouchEvent;
import openfl.geom.Point;
//import flash.geom.Point;
import openfl.geom.Rectangle;
//import flash.geom.Rectangle;
import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.media.SoundTransform;
import openfl.net.SharedObject;
//import flash.net.SharedObject;
import openfl.net.SharedObjectFlushStatus;
//import flash.net.SharedObjectFlushStatus;
import openfl.Lib;
//import flash.Lib;

import haxe.Timer;
import openfl.Assets;
import openfl.events.TouchEvent;

//import flash.events.KeyboardEvent;
//import flash.ui.Keyboard;

//import openfl.display.Stage;

import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;

//import haxe.ds.Vector.Vector;

import motion.Actuate;
import motion.easing.Quad;
import motion.easing.Bounce;
import motion.easing.Linear;

import particles.ParticlesEm;
import mut.Mut;

#if mobile
//import googleAnalytics.Stats;
//import admob.AD;
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
	
	public var gui:GUI;
	
	var vol = .5;
	
	var lensF:TileSprite;
	var kometa:TileSprite;
	var kx = .0; var ky = .0;
	
	//public var money:UInt = 8000000;
	public var money:UInt = 0;
	
	public var moneyGr:Fnt;
	
	public var currentLevel:UInt;
	
	public var ridersOffset:UInt;
	
	public var fragments:Array<Fragment>;
	public var fragmentsFire:Array<FragmentFire>;
	
	var z_cannon:TileGroup;
	var z_base:TileSprite;
	var z_temp:TileSprite;
	
	public var upgradesProgress:Array<UInt> = [1, 0, 0, 0, 0, 0, 0];
	public var shopItems:Array<UInt> = [0, 0, 1, 0];
	public var shopPrices:Array<UInt> = [4000, 4000, 3000];
	public var upgrades:Array<Array<UInt>>;
	
	public static var game:Game;
	public var noClick:Bool;
	public var so:SharedObject;
	
	public var layer:TileLayer;
	var topLayer:TileLayer;
	public var layerAdd:TileLayer;
	//public var layerAdd1:TileLayer;
	public var layerGUI:TileLayer;
	
	var htp:TileSprite;
	
	public var isGame:Bool;
	public var pause:Bool;
	
	public var musicFlag:Bool = true;
	public var fxFlag:Bool = true;
	
	public var space:Space;
	public var cbCannon:CbType;
	public var cbShell:CbType;
	public var cbShellC:CbType;
	public var cbRaider:CbType;
	public var cbSoldiers:CbType;
	public var cbRaiderShell:CbType;
	var cbShield:CbType;
	var cbGround:CbType;
	
	public var enemyGroup:InteractionGroup;
	public var defendersGroup:InteractionGroup;
	
	
	public var controlledObj:Array<ControlledObject>;
	var controlledObjPre:Array<ControlledObject>;
	
	public var emitters:Array<ParticlesEm>;
	var clouds:ParticlesEm;
	public var smoke:ParticlesEm;
	
	public var cannon:Cannon;
	var b0AlphaStep:Float;
	var b0:TileSprite;
	public var b0Timer:UInt = 0;
	var b0Shield:TileSprite;
	var b0Body:Body;
	var b1:TileSprite;
	var b1Flag:UInt = 0;
	var fog:ParticlesEm;
	
	public var cannonRotVel:Float;
	public var cannonEnergyStepAdd:Float;
	public var cannonLife:Int;
	
	public var damageRider:UInt = 7;
	public var damageBomb:UInt = 80;
	public var damageFighter:UInt = 70;
	public var jumpTime = 80;
	public var eRandomFire:Float = .2;
	
	
	public var riderVel:UInt;
	
	public var riderLive:UInt;
	public var riderLim:UInt;
	
	public var ridersOnGround:Array<RaiderShip>;
	
	var totalEnemy:UInt;
	var totalBomber:UInt;
	
	var enemyLowerLimit:UInt;
	
	var soldierDelay:UInt;
	public var activeSoldiers:UInt;
	
	var touchPointX:Float;
	var touchMoveLength:UInt = 2;
	var fire:Bool;
	var timer:UInt;
	
	var enemyBornDelay:UInt;
	var enemyBornDelayLim:UInt;
	
	var bp:TileSprite;
	
	var sh_sh_e:ParticlesEm;
	public var fighter_e:ParticlesEm;
	public var s_s:ParticlesEm;
	public var add_ex:ParticlesEm;
	public var s_s1:ParticlesEm;
	
	public var bomber_e:ParticlesEm;
	public var ufo_f:ParticlesEm;
	
	var sh_sh:Sound = Assets.getSound("sh_sh");
	var baseisunderattack:Sound = Assets.getSound("baseisunderattack");
	public var attetionlpl:Sound = Assets.getSound("attetionlpl");
	public var cdamaged:Sound = Assets.getSound("cdamaged");
	var siren:Sound = Assets.getSound("siren");
	public var ufo:Sound = Assets.getSound("ufo");
	public var rotStop:Sound = Assets.getSound("cannonS");
	public var s_fEnemy:Sound = Assets.getSound("air7");
	public var s_fEnemyBig:Sound = Assets.getSound("air3");
	public var s_fEnemyBig1:Sound = Assets.getSound("air8");
	public var big_boss1_sh:Sound = Assets.getSound("big_boss1_sh");
	public var air:Sound = Assets.getSound("air");
	public var air5:Sound = Assets.getSound("air5");
	public var air4:Sound = Assets.getSound("air4");
	public var air8:Sound = Assets.getSound("air8");
	public var air1:Sound = Assets.getSound("air1");
	var gtna:Sound = Assets.getSound("gtna"); 
	var reppeled:Sound = Assets.getSound("reppeled"); 
	/*public var s_bg0 = Assets.getSound("bg0");
	public var s_bg1 = Assets.getSound("bg1");
	public var s_bg2 = Assets.getSound("bg2");
	public var s_bg3 = Assets.getSound("bg3");
	public var s_bg4 = Assets.getSound("bg4");
	public var s_p = Assets.getSound("bg_p");*/
	
	public var soldatus = Assets.getSound("soldatus");
	var s_end:Sound = Assets.getSound("end");
	var s_rs:Sound = Assets.getSound("rs");
	
	var s_shield:Sound = Assets.getSound("shield");
	
	var s_shel:Sound = Assets.getSound("rs");
	
	public var s_aaa:Sound = Assets.getSound("aaa");
	
	var s_pip:Sound = Assets.getSound("pip");
	
	var s_roketa:Sound = Assets.getSound("roketa");
	
	var s_ca:Sound = Assets.getSound("cannonA");
	
	
	//------CANON_S
	
	
	var ex0:Sound = Assets.getSound("ex0");
	var ex1:Sound = Assets.getSound("ex1");
	var ex2:Sound = Assets.getSound("ex2");
	var ex3:Sound = Assets.getSound("ex3");
	var ex4:Sound = Assets.getSound("ex4");
	
	public var sh1:Sound = Assets.getSound("shut1");
	public var sh2:Sound = Assets.getSound("shut2");
	public var sh3:Sound = Assets.getSound("shut3");
	public var sh4:Sound = Assets.getSound("shut4");
	public var sh5:Sound = Assets.getSound("shut5");
	
	//var music:SControll;
	var channel:SoundChannel;
	public var channelR:SoundChannel;
	
	
	var bg:TileSprite;
	
	public var gameStatus:UInt;
	
	public function s_expl(ind:Int)
	{
		switch(ind)
		{
			case 0: playS(ex0);
			case 1: playS(ex1);
			case 2: playS(ex2);
			case 3: playS(ex3);
			case 4: playS(ex4);
		}
	}
	
	
	private inline function memU()
	{
		#if cpp
		var bytes = cpp.vm.Gc.memUsage();
		trace("-------------------------------------------------------------------------------------");
		trace("Bytes used " + (bytes) );
		trace("KBytes used " + (bytes>>10) );   //  divide by 1024
		trace("MBytes used " + (bytes>>20) );  
		trace("GBytes used " + (bytes >> 30) );
		trace("-------------------------------------------------------------------------------------");
		#end 
	}
	
	public function new()
	{
		super();
		
		
		//#if cpp Gc.enable(true); #end
		
		var stmp:Sound = new Sound();
		stmp = Assets.getSound("music");
		channel = stmp.play(0, 999999, new SoundTransform (vol, 0));
		
		stmp = Assets.getSound("cannonR");
		channelR = stmp.play(0, 999999, new SoundTransform (0, 0));
		
		currentLevel = 1;
		
		controlledObjPre = new Array();
		controlledObj = new Array();
		emitters = new Array();
		moneyGr = new Fnt(20, 20, "0", layer, 4);
		
		so = SharedObject.getLocal( "new7ne7w787777" );
		if (so.data.level != null) 
		{
			currentLevel = so.data.level;
			upgradesProgress = so.data.upgradeProgress;
			money = so.data.money;
			shopItems = so.data.shopItems;
		}
		
		//currentLevel = 2;
		//upgradesProgress[0] = 1;
		
		gameStatus = 0;
		
		upgrades = 
		[
			[2000, 3000, 4500, 7700, 9500],
			[4000, 3000, 4500, 7700, 9500],
			[1500, 2500, 4000, 5200, 8800],
			[1000, 2000, 3500, 4500, 7700],
			[1200, 2200, 3700, 4100, 8000]
		];
		
		#if mobile
		//AD.initInterstitial(ID);
		//Stats.init(gID, 'testing.wuprui.com');
		#end
		
		/*Lib.current.stage.addEventListener (MouseEvent.MOUSE_DOWN, md);
		Lib.current.stage.addEventListener (MouseEvent.MOUSE_UP, mu);
		Lib.current.stage.addEventListener (KeyboardEvent.KEY_UP, keyUp);*/
		
		
		#if mobile
		Lib.current.stage.addEventListener (TouchEvent.TOUCH_BEGIN, touchBegin);
		Lib.current.stage.addEventListener (TouchEvent.TOUCH_END, touchEnd);
		Lib.current.stage.addEventListener (TouchEvent.TOUCH_MOVE, touchMove);
		#else
		Lib.current.stage.addEventListener (KeyboardEvent.KEY_DOWN, keyDown);
		Lib.current.stage.addEventListener (KeyboardEvent.KEY_UP, keyUp);
		#end
		
		Lib.current.stage.addEventListener (MouseEvent.MOUSE_DOWN, md);
		
		game = this;
		
		space = new Space(new Vec2(0, 700));
		
		
		
		cbCannon = new CbType();
		cbShield = new CbType();
		cbShell = new CbType();
		cbShellC = new CbType();
		cbGround = new CbType();
		cbRaider = new CbType();
		cbRaiderShell = new CbType();
		cbSoldiers = new CbType();
		
		
		enemyGroup = new InteractionGroup(true);
		defendersGroup = new InteractionGroup(true);
		
		var sheetData = Assets.getText("ts/texture.xml");
		var tilesheet = new SparrowTilesheet(Assets.getBitmapData("ts/texture.png"), sheetData);
		layer = new TileLayer(tilesheet);
		addChild(layer.view);
		
		bp = new TileSprite(layer, "bp");
		bp.x = 970;
		bp.y = 30;
		
		topLayer = new TileLayer(tilesheet);
		addChild(topLayer.view);
		
		sheetData = Assets.getText("ts/texture_add.xml");
		tilesheet = new SparrowTilesheet(Assets.getBitmapData("ts/texture_add.png"), sheetData);
		layerAdd = new TileLayer(tilesheet, true, true);
		addChild(layerAdd.view);
		
		lensF = new TileSprite(layerAdd, "lensF");
		lensF.x = 500;
		lensF.y = 300;
		lensF.alpha = 0;
		layerAdd.addChild(lensF);
		
		kometa = new TileSprite(layerAdd, "kometa");
		
		/*sheetData = Assets.getText("ts/texture_add1.xml");
		tilesheet = new SparrowTilesheet(Assets.getBitmapData("ts/texture_add1.png"), sheetData);
		layerAdd1 = new TileLayer(tilesheet, true, true);
		addChild(layerAdd1.view);*/
		
		sheetData = Assets.getText("ts/texture_gui.xml");
		tilesheet = new SparrowTilesheet(Assets.getBitmapData("ts/texture_gui.png"), sheetData);
		layerGUI = new TileLayer(tilesheet);
		addChild(layerGUI.view);
		
		bg = new TileSprite(layer, "bg");
		bg.x = 500;
		bg.y = 300;
		layer.addChild(bg);
		
		fragments = new Array();
		fragmentsFire = new Array();
		
		for (i in 0...21)
		{
			fragments.push(new Fragment());
			fragmentsFire.push(new FragmentFire(4 + Std.random(3)));
		}
		
		var tXml:String;
		tXml = Assets.getText("xml/clouds.xml");
		clouds = new ParticlesEm(layerAdd, tXml, "sky", layerAdd, 0);
		
		addEventListener (Event.ENTER_FRAME, this_onEnterFrame);
		
		gui = new GUI();
		
		//new Fnt(200, 200, "centrall cannon", layerGUI);
		//new Fnt(200, 240, "ingeborge dabkunaite", layerGUI);
		
		#if flash
		addChild(debug.display);
		debug.drawConstraints = true;
		#end
		
		var tXml = Assets.getText("xml/ricochet3.xml");
		sh_sh_e = new ParticlesEm(Game.game.layerAdd, tXml, "f_part", Game.game.layerAdd);
		
		tXml = Assets.getText("xml/ricochet2.xml");
		fighter_e = new ParticlesEm(Game.game.layerAdd, tXml, "rico", Game.game.layerAdd);
		
		tXml = Assets.getText("xml/ricochetShellShell.xml");
		s_s = new ParticlesEm(Game.game.layerAdd, tXml, "rico", Game.game.layerAdd);
		
		tXml = Assets.getText("xml/ricochetShellShell1.xml");
		s_s1 = new ParticlesEm(Game.game.layerAdd, tXml, "part_green", Game.game.layerAdd);
		
		tXml = Assets.getText("xml/addExpl.xml");
		add_ex = new ParticlesEm(Game.game.layerAdd, tXml, "part_green", Game.game.layerAdd);
		
		tXml = Assets.getText("xml/rico_bomber.xml");
		bomber_e = new ParticlesEm(Game.game.layerAdd, tXml, "bomber_part", Game.game.layerAdd);
		
		tXml = Assets.getText("xml/ufo_f.xml");
		ufo_f = new ParticlesEm(Game.game.layerAdd, tXml, "ring", Game.game.layerAdd);
		
		var tXml = Assets.getText("xml/smoke_cannon.xml");
		fog = new ParticlesEm(Game.game.layer, tXml, "firstFog_00042", Game.game.layer);
	}
	
	function spaceCallbacks()
	{
		space.listeners.add(new InteractionListener(
			CbEvent.BEGIN,
			InteractionType.COLLISION,
			cbCannon,
			cbShell,
			cannon_shell
		));
		
		space.listeners.add(new InteractionListener(
			CbEvent.BEGIN,
			InteractionType.SENSOR,
			cbCannon,
			cbRaiderShell,
			cannon_rshell
		));
		
		space.listeners.add(new InteractionListener(
			CbEvent.BEGIN,
			InteractionType.SENSOR,
			cbShield,
			cbShell,
			shield_shell
		));
		
		space.listeners.add(new InteractionListener(
			CbEvent.BEGIN,
			InteractionType.COLLISION,
			cbShellC,
			cbShell,
			shellC_shell
		));
		
		space.listeners.add(new InteractionListener(
			CbEvent.BEGIN,
			InteractionType.COLLISION,
			cbGround,
			cbShell,
			ground_shell
		));
		
		space.listeners.add(new InteractionListener(
			CbEvent.BEGIN,
			InteractionType.COLLISION,
			cbRaider,
			cbGround,
			rider_ground
		));
		
		space.listeners.add(new InteractionListener(
			CbEvent.BEGIN,
			InteractionType.COLLISION,
			cbRaider,
			cbSoldiers,
			rider_soldier
		));
	}
	
	public function init()
	{
		spaceCallbacks();
		
		fire = false;
		
		if (shopItems[0] > 0)
		{
			if (b0Body == null)
			{
				b0 = new TileSprite(layer, "b0");
				b0.x = 240; b0.y = 550;
				
				b0Shield = new TileSprite(layer, "shield");
				b0Shield.x = 500; b0Shield.y = 440;
				
				b0Body = new Body(BodyType.STATIC, new Vec2(500, 470));
				b0Body.shapes.add(new Circle(120));
				b0Body.cbTypes.add(cbShield);
				b0Body.shapes.at(0).sensorEnabled = true;
			}
		}
		
		if (shopItems[1] > 0)
		{
			if (b1 == null)
			{
				b1 = new TileSprite(layer, "b1");
				b1.x = 760; b1.y = 550;
			}
		}
		ridersOffset = 0;
		
		timer = 0;
		enemyBornDelay = 0;
		enemyBornDelayLim = 70;
		soldierDelay = 0;
		activeSoldiers = 0;
		
		
		riderLive = 0;
		ridersOnGround = new Array();
		
		riderVel = 30;
		riderLim = 1;
		
		enemyLowerLimit = 200;
		
		switch(currentLevel)
		{
			case 1: makeL1();
			case 2: makeL2();
			case 3: makeL3();
			case 4: makeL4();
			case 5: makeL5();
			case 6: makeL6();
			case 7: makeL7();
			case 8: makeL8();
			case 9: makeL9();
			case 10: makeL10();
			case 11: makeL11();
			case 12: makeL12();
			case 13: makeL13();
			case 14: makeL14();
			case 15: makeL15();
			case 16: makeL15();
			case 17: makeL15();
			case 18: makeL15();
			case 19: makeL15();
			case 20: makeL15();
			case 21: makeL15();
		}
		/*makeL2();
		currentLevel = 2;
		upgradesProgress[0] = 1;
		upgradesProgress[1] = 1;
		upgradesProgress[2] = 5;
		upgradesProgress[3] = 5;
		upgradesProgress[4] = 5;*/
		
		switch(upgradesProgress[4])
		{
			case 0: cannonRotVel = .6;
			case 1: cannonRotVel = 1;
			case 2: cannonRotVel = 1.4;
			case 3: cannonRotVel = 1.8;
			case 4: cannonRotVel = 2.2;
			case 5: cannonRotVel = 2.7;
		}
		
		switch(upgradesProgress[2])
		{
			case 0: cannonEnergyStepAdd = .01;
			case 1: cannonEnergyStepAdd = .017;
			case 2: cannonEnergyStepAdd = .024;
			case 3: cannonEnergyStepAdd = .03;
			case 4: cannonEnergyStepAdd = .04;
			case 5: cannonEnergyStepAdd = .05;
		}
		
		switch(upgradesProgress[3])
		{
			case 0: cannonLife = 100;
			case 1: cannonLife = 150;
			case 2: cannonLife = 200;
			case 3: cannonLife = 250;
			case 4: cannonLife = 300;
			case 5: cannonLife = 350;
		}
		
		#if !flash
		emitters.push(clouds);
		clouds.emitStart(1520, 100, 777777777);
		#end
		
		emitters.push(sh_sh_e);
		emitters.push(fighter_e);
		emitters.push(s_s);
		emitters.push(add_ex);
		emitters.push(s_s1);
		emitters.push(bomber_e);
		emitters.push(ufo_f);
		
		var bGround = new Body(BodyType.STATIC, new Vec2(0, 570));
		bGround.shapes.add(new Polygon(Polygon.rect( -40, 0, 1080, 60)));
		bGround.cbTypes.add(cbGround);
		bGround.space = space;
		
		
		if (shopItems[0] != 0) 
		{
			layer.addChild(b0);
			b0.scale = 1; b0.alpha = 1;
		}
		if (shopItems[1] != 0) 
		{
			layer.addChild(b1);
			b1.scale = 1; b1.alpha = 1;
		}
		
		startBattle();
		
		layer.addChild(moneyGr);
		moneyGr.newValue("" + money, true);
		
		lensF.alpha = 0;
		layerAdd.addChild(lensF);
		
		/*#if cpp 
		Gc.run(true);
		//memU();
		trace("afterInit");
		trace("numObjBody = " + (Gc.trace(Body, false)));
		#end*/
	}
	
	public function playS(s:Sound, loop:UInt = 0 )
	{
		if (fxFlag) s.play(0, loop);
	}
	
	public function musicOnOff()
	{
		if (!musicFlag)
		{
			channel.soundTransform = new SoundTransform(0);
		}
		else 
		{
			channel.soundTransform = new SoundTransform(vol);
		}
	}
	
	function b0Appear()
	{
		b0Body.space = null;
		
		Actuate.tween(b0Shield, 1, { scale:4, alpha:0 } ).onComplete(function():Dynamic
		{
			layer.removeChild(b0Shield);
			return null;
		});
		
		if (shopItems[0] != 0) Actuate.tween(b0, .4, { scale:1, alpha:1 } )
		else layer.removeChild(b0);
	}
	
	function b0Tap()
	{
		if (shopItems[0] == 0 || b0Timer > 0 || b0Shield.parent != null) return;
		playS(s_shield);
		shopItems[0]--;
		Actuate.tween(b0, .4, { scale:2, alpha:0 } );
		
		
		layer.addChild(b0Shield);
		b0Shield.scale = .1;
		b0Shield.alpha = 0;
		
		Actuate.tween(b0Shield, 1, { scale:1, alpha:1 } ).onComplete(function():Dynamic
		{
			b0Timer = 240;
			return null;
		});
		
		b0Body.space = space;
	}
	
	function b1Tap()
	{
		if (shopItems[1] == 0 || b1Flag != 0) return;
		shopItems[1]--;
		Actuate.tween(b1, .4, { scale:4, alpha:0 } );
		b1Flag = 340;
		
		new Messile(new Vec2(500, 500));
		
		playS(s_roketa);
	}
	
	function startBattle()
	{
		playS(siren);
		Timer.delay(function() { playS(baseisunderattack); }, 4000);
		
		gui.clear();
		if (currentLevel != 1) layerGUI.removeAllChildren();
		
		z_cannon = new TileGroup(layer);
		
		var name = "cannon_add_" + upgradesProgress[1];
		if (upgradesProgress[1] > 0)
		{
			var addBarrel = new TileSprite(Game.game.layer, name);
			z_cannon.addChild(addBarrel);
		}
		
		name = "cannon_" + upgradesProgress[0];
		z_cannon.addChild(new TileSprite(layer, name));
		
		playS(s_ca);
		
		z_base = new TileSprite(layer, "cannon_motor");
		z_temp = new TileSprite(topLayer, "bg_z");
		z_temp.x = 500;
		z_temp.y = 587;
		z_cannon.x = 500;
		z_cannon.y = 670;
		z_base.x = 500;
		z_base.y = 680;
		layer.addChild(z_base);
		layer.addChild(z_cannon);
		topLayer.addChild(z_temp);
		topLayer.render();
		
		Actuate.tween(z_cannon, 4, { y:495 } ).ease(Linear.easeNone);
		Actuate.tween(z_base, 4, { y:538 } ).ease(Linear.easeNone).onComplete(function():Dynamic
		{
			makeCannon();
			layer.removeChild(z_cannon);
			topLayer.removeChild(z_temp);
			//layer.removeChild(b);
			gameStatus = 2;
			graphicUpdate();
			cannon.run();
			layer.render();
			topLayer.render();
			return null;
		});
		
		layer.render();
	}
	
	public function endBattle()
	{
		if (cannon.life != 0) 
		{
			var p = "";if (Game.game.currentLevel == 1) p = "st"
			else if (Game.game.currentLevel == 2) p = "nd"
			else if (Game.game.currentLevel == 3) p = "rd"
			else p = "th";
			gui.endBattle("successfully repulsed the " + currentLevel + p + " wave", "next wave");
			currentLevel++;
			
			save();
		}
		else gui.endBattle();
		
		playS(s_ca);
		layer.addChild(z_cannon);
		topLayer.addChild(z_temp);
		Actuate.tween(z_cannon, 4, { y:670 } ).ease(Linear.easeNone);
		Actuate.tween(z_base, 4, { y:680 } ).ease(Linear.easeNone);
		
		cannon.clear();
		Timer.delay(function() { gameStatus = 5; }, 8000);
		isGame = false;
		
		
		topLayer.render();
		layer.render();
		layerGUI.render();
	}
	
	public function clear()
	{
		/*for (i in controlledObj) i.clear();
		for (i in controlledObjPre) if(i != null) i.clear();*/
		
		while (space.bodies.length > 0)
		{
			var b = space.bodies.pop();
			var cl = b.constraints;
			while (cl.length > 0) cl.pop().space = null;
			b.cbTypes.clear();
			b.userData.graphic = null;
			b.userData.i = null;
			b.shapes.clear();
			b.space = null;
			/*b.arbiters.clear();
			b.zpp_inner.clear();*/
			b = null;
		}
		
		
		/*space.arbiters.clear();
		space.listeners.clear();
		space.zpp_inner.callbacks.clear();
		space.zpp_inner.callbackset_list.clear();
		space.zpp_inner.cbsets.clear();
		space.zpp_inner.f_arbiters.clear();
		space.zpp_inner.listeners.clear();
		space.zpp_inner.outer.clear();
		space.zpp_inner.clear();*/
		
		space.clear();
		
		controlledObjPre = new Array();
		controlledObj = new Array();
		emitters = new Array();
		
		layer.removeAllChildren();
		layerAdd.removeAllChildren();
		topLayer.removeAllChildren();
		layer.addChild(bg);
		
		lensF.alpha = 0;
		
		layer.render();
		
		layerAdd.render();
		topLayer.render();
		
		
		/*#if cpp 
		Gc.run(true);
		trace("");
		trace("");
		trace("afterClear___________________________________________numObjBody = " + (Gc.trace(Body, false)));
		trace("afterClear___________________________________________numObjSound = " + (Gc.trace(Sound, false)));
		trace("afterClear___________________________________________pEm = " + (Gc.trace(ParticlesEm, false)));
		memU();
		trace("");
		trace("");
		trace("afterClear________________________________________________________________________________");
		trace(fragments.length);
		trace(fragmentsFire.length);
		#end*/
	}
	
	/*function gcTrace()
	{
		#if cpp
		trace("|||||||||||||||||||||||||||||||||||||||||||||||");
		trace(Gc.MEM_INFO_CURRENT);
		trace(Gc.MEM_INFO_LARGE);
		trace(Gc.MEM_INFO_RESERVED);
		trace(Gc.MEM_INFO_USAGE);
		trace("___________________________");
		memU();
		trace("___________________________numObj = " + Gc.trace(Body, true));
		
		#end
	}*/
	
	public function save()
	{
		so.data.level = currentLevel;
		so.data.upgradeProgress = upgradesProgress;
		so.data.money = money;
		so.data.shopItems = shopItems;
		
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
	
	function rider_soldier(cb:InteractionCallback)
	{
		var b:Body = cb.int2.castBody;
		b.userData.i.destruction();
	}
	
	function rider_ground(cb:InteractionCallback)
	{
		var b:Body = cb.int1.castBody;
		//var s:Body = cb.int2.castBody;
		
		b.userData.i.landing();
	}
	
	function shellC_shell(cb:InteractionCallback)
	{
		if (cb == null || cb.int1 == null || cb.int2 == null) return;
		
		var s1:Body = cb.int1.castBody;
		var s2:Body = cb.int2.castBody;
		
		if (Type.getClassName(Type.getClass(s2.userData.i)) == "UfoShell")
		{
			s1.userData.i.destruction();
			s2.userData.i.div();
		}
		
		sh_sh_e.emitStart(s1.position.x, s1.position.y, 7);
		if (Math.random() > .6) s_s1.emitStart(s1.position.x, s1.position.y, 4);
		else s_s.emitStart(s1.position.x, s1.position.y, 4);
		
		
		playS(s_shel);
		
		if (s1.userData.i == null) 
		{
			if (s2 != null && s2.userData.i != null)
			{
				s2.userData.i.clear();
			}
			return;
		}
		
		var df:Dynamic = s1.userData.i.damageForce;
		
		if (s2 != null && s2.userData.i != null && df >= s2.userData.i.life) s2.userData.i.clear();
		s1.userData.i.destruction();
	}
	
	function cannon_shell(cb:InteractionCallback)
	{
		if (cb == null || cb.int1 == null || cb.int2 == null) return;
		
		var b:Body = cb.int1.castBody;
		var s:Body = cb.int2.castBody;
		
		if (Type.getClassName(Type.getClass(s.userData.i)) != "RaiderShell")
		s_expl(Std.random(5))
		else 
		{
			if (Math.random() < .47) playS(s_rs)
			else playS(sh_sh);
		}
		
		
		if (s.userData.i == null) return;
		
		if (s.userData.i.damageForce != 0)
		{
			if (b.userData.i == null) 
			{
				if (s.userData.i != null) s.userData.i.clear();
				return;
			}
			if (b.userData.i.life <= s.userData.i.damageForce)
			{
				s.userData.i.clear();
				b.userData.i.destruction();
			}
			else 
			{
				b.userData.i.damage(s.userData.i.damageForce);
				s.userData.i.destruction();
			}
		}
	}
	
	function cannon_rshell(cb:InteractionCallback)
	{
		var s:Body = cb.int2.castBody;
		//if (s.userData.i == null) return;
		
		cannon.damage(s.userData.i.damageForce);
		s.userData.i.destruction();
		s_expl(Std.random(5));
	}
	
	function shield_shell(cb:InteractionCallback)
	{
		var s:Body = cb.int2.castBody;
		//if (s.userData.i == null) return;
		if (Type.getClassName(Type.getClass(s.userData.i)) == "CannonShell") return;
		s.userData.i.destruction();
		
		s_expl(Std.random(5));
	}
	
	
	function ground_shell(cb:InteractionCallback)
	{
		var s:Body = cb.int2.castBody;
		var r = Math.round(Math.random() * 3);
		
		switch(r)
		{
			case 0:born(s.position.x, s.position.y - 70);
			case 1:born(s.position.x, s.position.y - 50, .9);
			case 2:born(s.position.x, s.position.y - 50, .8);
			case 3:born(s.position.x, s.position.y - 42, .7);
		}
		playS(s_rs);
		
		s.userData.i.destruction();
	}
	
	public function reset()
	{
		upgradesProgress = [1, 0, 0, 0, 0, 0, 0];
		shopItems = [0, 0, 0, 0];
		money = 0;
		currentLevel = 1;
		save();
	}
	
	function md(e:MouseEvent)
	{
		
		
		if (gui.noClick || gameStatus == 3 || gameStatus == 4) return;
		
		var setNoClick:Bool = false;
		var ex = e.localX / scaleX;
		var ey = e.localY / scaleY;
		
		if (gameStatus == 2)
		{
			
			if (currentLevel == 1 && htp.parent != null)
			{
				if (htp.y < 370)
				{
					Actuate.tween(htp, 2, { y:1000 } ).onComplete(function():Dynamic
					{
						layerGUI.removeAllChildren();
						return null;
					});
				}
				return;
			}
			
			
			if (!pause)
			{
				if (Mut.dist(ex, ey, 970, 30) < 50)
				{
					pause = true;
					gui.pause();
					layerGUI.addChild(gui);
					playS(s_pip);
				}
			}
			else
			{
				if (Mut.dist(ex, ey, 200, 500) < 100)
				{
					gui.endBattleDeactivateE();
					gameStatus = 1;
					isGame = pause = false;
					playS(s_pip);
				}
				else if (Mut.dist(ex, ey, 800, 500) < 100)
				{
					gui.pauseDeactivate();
					playS(s_pip);
				}
				else if (Mut.dist(ex, ey, 800, 100) < 100)
				{
					gui.onOffFxClick(true);
					playS(s_pip);
				}
				else if (Mut.dist(ex, ey, 200, 100) < 100)
				{
					gui.onOffMusicClick(true);
					playS(s_pip);
				}
			}
			gui.setNoClick(470);
			setNoClick = true;
			return;
		}
		
		if (isGame) return;
		
		if (gameStatus == 5)
		{
			if (Mut.dist(ex, ey, 800, 500) < 100)
			{
				if (!gui.confirmation)
				{
					gui.endBattleDeactivate(false);
				}
				else gui.clickConfirm();
				
				playS(s_pip);
			}
			else if (Mut.dist(ex, ey, 200, 500) < 100)
			{
				if (!gui.confirmation)
				{
					gui.endBattleDeactivate();
				}
				else gui.clickCancel();
				
				playS(s_pip);
			}
			else if (Mut.dist(ex, ey, 500, 500) < 100)
			{
				gui.clickNewGame();
				playS(s_pip);
			}
		}
		else if (gameStatus == 1)
		{
			if (Mut.dist(ex, ey, 800, 500) < 100)
			{
				if (!gui.confirmation)
				{
					if (shopItems[2] == 0)  playS(gtna);
					gui.clickStart();
				} else gui.clickConfirm();
				playS(s_pip);
			}
			else if (Mut.dist(ex, ey, 200, 500) < 100)
			{
				if (!gui.confirmation) gui.backToShop()
				else gui.clickCancel();
				playS(s_pip);
			}
			else if (Mut.dist(ex, ey, 500, 500) < 100)
			{
				gui.clickNewGame();
				playS(s_pip);
			}
		}
		else if (gameStatus == 0)
		{
			if (Mut.dist(ex, ey, 800, 500) < 100)
			{
				gui.clickReady();
				playS(s_pip);
			}
			else if (gui.rectUpgrade.contains(ex, ey)) { gui.switchSection(0); playS(s_pip);}
			else if (gui.rectBuy.contains(ex, ey)) { gui.switchSection(1); playS(s_pip);}
			else if (gui.rectMusic.contains(ex, ey)) { gui.onOffMusicClick(); playS(s_pip); }
			else if (gui.rectFx.contains(ex, ey)) {gui.onOffFxClick(); playS(s_pip);}
			
			else switch(gui.currenSection)
			{
				case 0:
					if (gui.rectUpgrade0.contains(ex, ey)) 
					{
						gui.ub0.buy();
						gui.setMoney(); playS(s_pip);
					}
					else if (gui.rectUpgrade1.contains(ex, ey)) 
					{
						gui.ub1.buy();
						gui.setMoney(); playS(s_pip);
					}
					else if (gui.rectUpgrade2.contains(ex, ey)) 
					{
						gui.ub2.buy();
						gui.setMoney(); playS(s_pip);
					}
					else if (gui.rectUpgrade3.contains(ex, ey)) 
					{
						gui.ub3.buy();
						gui.setMoney(); playS(s_pip);
					}
					else if (gui.rectUpgrade4.contains(ex, ey)) 
					{
						gui.ub4.buy();
						gui.setMoney(); playS(s_pip);
					}
					
					gui.setNoClick(270);
					setNoClick = true;
					
				case 1:
						if (gui.rectShop0.contains(ex, ey)) 
						{
							if (gui.bb0 == null) return;
							gui.bb0.buy();
							gui.setMoney(); playS(s_pip);
						}
						else if (gui.rectShop1.contains(ex, ey)) 
						{
							if (gui.bb1 == null) return;
							gui.bb1.buy();
							gui.setMoney(); playS(s_pip);
						}
						else if (gui.rectShop2.contains(ex, ey)) 
						{
							if (gui.bb2 == null) return;
							gui.bb2.buy();
							gui.setMoney(); playS(s_pip);
						}
					
					gui.setNoClick(270);
					setNoClick = true;
			}
		}
		if (!setNoClick) gui.setNoClick();
	}
	
	#if mobile
	function touchBegin(e:TouchEvent)
	{
		if (gameStatus != 2) return;
		
		var ex = e.localX / scaleX;
		var ey = e.localY / scaleY;
		
		if (shopItems[0] > 0 && Mut.dist(ex, ey, b0.x, b0.y) < 100) 
		{
			b0Tap();
			return;
		}
		else if (shopItems[1] > 0 && Mut.dist(ex, ey, b1.x, b1.y) < 100) 
		{
			b1Tap();
			return;
		}
		
		if (ex < 400) touchPointX = ex
		else fire = true;
		
	}
	
	function touchEnd(e:TouchEvent)
	{
		if (gameStatus != 2) return;
		
		var ex = e.localX / scaleX;
		if (ex < 400) cannon.direction = 0
		else fire = false;
	}
	
	function touchMove(e:TouchEvent)
	{
		if (gameStatus != 2) return;
		
		var ex = e.localX / scaleX;
		var ey = e.localY / scaleY;
		
		if (ex < 400)
		{
			if (Math.abs(touchPointX - ex) > touchMoveLength)
			{
				if (touchPointX > ex) cannon.direction = -1
				else cannon.direction = 1;
			}
			touchPointX = ex;
		}
	}
	
	#else
	function keyUp(e:KeyboardEvent)
	{
		if (gameStatus != 2) return;
		switch(e.keyCode)
		{
			case Keyboard.LEFT, 65:
				if (cannon.direction == -1) cannon.direction = 0;
			case Keyboard.RIGHT, 83:
				if (cannon.direction == 1) cannon.direction = 0;
			case Keyboard.SPACE:
				fire = false;
		}
	}
	
	function keyDown(e:KeyboardEvent)
	{
		if (gameStatus != 2) return;
		switch(e.keyCode)
		{
			case Keyboard.LEFT, 65:
				cannon.direction = -1;
			case Keyboard.RIGHT, 83:
				cannon.direction = 1;
			case Keyboard.SPACE:
				fire = true;
			case 49:
				b0Tap();
			case 50:
				b1Tap();
		}
	}
	#end
	
	
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
			
			if ((Type.getClassName(Type.getClass(graphic)) == "aze.display.TileSprite")
			|| (Type.getClassName(Type.getClass(graphic)) == "aze.display.TileClip") )
			cast(graphic, TileSprite).rotation = body.rotation;
			position.dispose();
			
			/*var graphics:Array<Dynamic> = body.userData.graphics;
			if (graphics == null) continue;
			
			for (i in 0...graphics.length)
			{
				var offset:Vec2 = body.userData.graphicOffsets[i];
				var position = body.localPointToWorld(offset);
				graphics[i].x = position.x;
				graphics[i].y = position.y;
				if (Type.getClassName(Type.getClass(graphics[i])) == "aze.display.TileSprite") 
				cast(graphics[i], TileSprite).rotation = body.rotation
				else if (Type.getClassName(Type.getClass(graphics[i])) == "aze.display.TileClip") 
				cast(graphics[i], TileClip).rotation = body.rotation;
				position.dispose();
			}*/
		}
	}
	
	
	
	function enemySetup(body:Body, x:Int, y:Int, vel:Int, fl:TileClip = null)
	{
		enemyBaseSetup(body, x, y);
		
		var gScale = -Math.abs(vel) / vel;
		cast(body.userData.graphic, TileSprite).scaleX = gScale;
		if(fl != null) fl.rotation = -Math.PI / 2 * gScale;
	}
	
	function enemyBaseSetup(body:Body, x:Int, y:Int)
	{
		body.cbTypes.add(cbCannon);
		body.position = new Vec2(x, y);
		body.group = enemyGroup;
		body.allowRotation = false;
	}
	
	function makeEnemyFighter(x:Int, y:Int, vel:Int):Enemy
	{
		
		var body = new Body();
		body.shapes.add(new Circle(33));
		var gr:TileSprite = new TileSprite(layer, "enemy_fighter");
		body.userData.graphic = gr;
		
		
		enemySetup(body, x, y, vel);
		
		return new EnemyFighter(body, 140, vel);
	}
	
	function makeEnemyT(x:Int, y:Int):Enemy
	{
		
		var body = new Body();
		body.shapes.add(new Polygon(Polygon.rect(-50, -19, 100, 38)));
		var gr:TileSprite = new TileSprite(layer, "enemy_t");
		body.userData.graphic = gr;
		
		enemyBaseSetup(body, x, y);
		
		return new EnemyT(body);
	}
	
	function makeEnemyBig(x:Int, y:Int):Enemy
	{
		
		var body = new Body();
		body.shapes.add(new Circle(52));
		var gr:TileSprite = new TileSprite(layer, "enemyBig");
		body.userData.graphic = gr;
		
		enemyBaseSetup(body, x, y);
		
		return new EnemyBig(body);
	}
	
	function makeEnemyBig1(x:Int, y:Int):Enemy
	{
		
		var body = new Body();
		body.shapes.add(new Polygon(Polygon.rect(-100, -15, 200, 50)));
		var gr:TileSprite = new TileSprite(layer, "enemyBig1");
		body.userData.graphic = gr;
		
		enemyBaseSetup(body, x, y);
		
		return new EnemyBig1(body);
	}
	
	function makeEnemyUfo(x:Int, y:Int):EnemyUfo
	{
		return new EnemyUfo(x, y);
	}
	
	function makeEnemyRoller(x:Int, y:Int, vel:Int):Enemy
	{
		
		var body = new Body();
		body.shapes.add(new Polygon(Polygon.rect(-58, -20, 116, 40)));
		var gr:TileSprite = new TileSprite(layer, "enemy_roll");
		body.userData.graphic = gr;
		var fl = new TileClip(layerAdd, "flame_", 25);
		
		enemySetup(body, x, y, vel, fl);
		
		return new RollerShip(body);
	}
	
	function makeEnemy(x:Int, y:Int, vel:Int):Enemy
	{
		
		var body = new Body();
		body.shapes.add(new Polygon(Polygon.rect(-50, -12, 100, 24)));
		var gr:TileSprite = new TileSprite(layer, "enemy_1");
		body.userData.graphic = gr;
		var fl = new TileClip(layerAdd, "flame_", 25);
		
		enemySetup(body, x, y, vel, fl);
		
		return new Enemy(body, 80, vel, eRandomFire, fl);
	}
	
	function makeEnemyBomber(x:Int, y:Int, vel:Int):EnemyBomber
	{
		var body = new Body();
		body.shapes.add(new Polygon(Polygon.rect(-55, -19, 110, 38)));
		var gr:TileSprite = new TileSprite(layer, "enemy_bomber");
		body.userData.graphic = gr;
		var fl = new TileClip(layerAdd, "flame_", 25);
		
		enemySetup(body, x, y, vel, fl);
		
		return new EnemyBomber(body, 120, vel, .2, fl);
	}
	
	function makeCannon()
	{
		var body = new Body();
		body.cbTypes.add(cbCannon);
		body.shapes.add(new Circle(27)); 
		body.shapes.add(new Polygon(Polygon.rect(-7, -70, 14, 47))); 
		body.position = new Vec2(500, 520);
		body.allowMovement = false;
		var offset = new Vec2(0, -25);
		body.userData.graphicOffset = offset;
		var gr:String = "cannon_" + upgradesProgress[0];
		var g = new TileSprite(Game.game.layer, gr);
		body.userData.graphic = g;
		var flame = new TileClip(layerAdd, "f_flash", 40);
		flame.loop = false;
		
		
		var tXml = Assets.getText("xml/smoke.xml");
		smoke = new ParticlesEm(layer, tXml, "smoke", layerAdd);
		
		var fp = smoke;
		if(upgradesProgress[0] > 2 || upgradesProgress[1] > 2) fp = new ParticlesEm(layer, Assets.getText("xml/starsFl.xml"), "smoke", layerAdd);
		
		var hl = new TileSprite(layerAdd, "f_highlight");
		hl.scaleX = 2;
		cannon = new Cannon(body, flame, hl, smoke, cannonLife, cannonRotVel);
		topLayer.removeAllChildren();
		
		layer.addChild(bp);
		layer.render();
		
		save();
	}
	
	public function prepareCannonToDeactivate()
	{
		cannon.direction = 0;
		gameStatus = 3;
		fire = false;
		
		if (cannon.body.rotation > 0) cannon.direction = -1
		else if (cannon.body.rotation < 0) cannon.direction = 1
		else cannon.direction = 0;
		
		if (cannon.life == 0) destrFog()
		else Timer.delay(function() { playS(reppeled); }, 5000);
		
		
		layer.removeChild(bp);
	}
	
	function enemy_manager()
	{
		if (currentLevel == 1 && htp.parent != null) return;
		
		if (gameStatus == 2) 
		{
			if (enemyBornDelay > 0) { enemyBornDelay--; return; }
			var obj = controlledObjPre.shift();
			if (obj == null) 
			{ 
				if (controlledObjPre.length == 0 && controlledObj.length == 1)
				{
					prepareCannonToDeactivate();
					return;
				}
				enemyBornDelay = 60; 
				return; 
			}
			else obj.init();
			
			enemyBornDelay = enemyBornDelayLim + Std.random(enemyBornDelayLim);
		}
	}
	
	public function born(x:Float, y:Float, scale:Float = 1, time:UInt = 4000)
	{
		var fl:TileClip = new TileClip(layerAdd, "fire_", 25);
		fl.x = x; fl.y = y;
		fl.scale = scale;
		if (Math.random() > .5) fl.scaleX *= -1;
		layerAdd.addChild(fl);
		Timer.delay(function()
		{
			Actuate.tween(fl, 3, { alpha:0 } ).onComplete(function():Dynamic
			{
				layerAdd.removeChild(fl);
				return null;
			});
		}, time);
	}
	
	public function explode(x:Float, y:Float, target:TileLayer, tileName:String, frameRate:UInt = 25, scale:Float = 1, rotation:Float = 0, alpha:Float = 1)
	{
		var exp:TileClip = new TileClip(target, tileName, frameRate);
		exp.loop = false;
		//if (target == layerAdd1) target = layerAdd;
		target.addChild(exp);
		exp.alpha = alpha;
		exp.x = x;
		exp.y = y;
		exp.scale = scale;
		exp.rotation = rotation;
		exp.play();
		exp.onComplete = function(exp)
		{
			exp.parent.removeChild(exp);
		}		
	}
	
	function this_onEnterFrame (event:Event):Void 
	{
		#if flash
		debug.clear(); debug.draw(space); debug.flush();
		#end
		
		if (gameStatus == 0 || gameStatus == 1)
		{
			layerGUI.render();
			layer.render();
			layerAdd.render();
			return;
		}
		
		if (pause)
		{
			layerGUI.render();
			return;
		}
		
		if (Math.random() > 0.97)
		{
			var s = new TileClip(layerAdd, "star", 24);
			layerAdd.addChild(s);
			s.x = 270 + Std.random(720);
			s.y = 10 + Std.random(270);
			s.loop = false;
			s.play();
			s.onComplete = function(s) { layerAdd.removeChild(s); }
		}
		
		
		if (kometa.parent == null)
		{
			if (Math.random() > 0.987)
			{
				layerAdd.addChild(kometa);
				kometa.alpha = 1;
				kometa.x = Std.random(1000);
				kometa.y = -20;
				var tar = new Vec2(Std.random(1001), 100 + Std.random(500));
				var ang = Mut.getAng(new Vec2(kometa.x, kometa.y), tar);
				kx = 27 * Math.cos(ang);
				ky = 27 * Math.sin(ang);
				kometa.rotation = ang;
				Actuate.tween(kometa, .27 + Math.random() / 2, { alpha:0 } ).onComplete(function():Dynamic
				{
					layerAdd.removeChild(kometa); return null;
				});
			}
		}
		else 
		{
			kometa.x += kx;
			kometa.y += ky;
		}
		
		if (b1Flag > 0)
		{
			if (b1Flag == 1)
			{
				if (shopItems[1] != 0) Actuate.tween(b1, .4, { scale:1, alpha:1 } );
				else layer.removeChild(b1);
			}
			
			b1Flag--;
		}
		
		if (b0Timer > 0) 
		{
			if (b0Timer == 1) b0Appear();
			b0Timer--;
			
			if (b0Shield.alpha > .99) 
			{
				b0Shield.alpha = .99;
				b0AlphaStep = -.04;
			}
			else if (b0Shield.alpha < .5) 
			{
				b0Shield.alpha = .5;
				b0AlphaStep = .04;
			}
			b0Shield.alpha += b0AlphaStep;
		}
		
		#if !flash
		if(emitters != null) for (i in emitters)
		{
			if (i.eTimes > 0 || i.particles.length > 0) i.onEnterFrame()
			else if (i.toRemove) emitters.remove(i);
		}
		#end
		
		
		if (fire) cannon.fire();
		
		/*if (space.bodies.length < 14 && Math.random() > .99 && lensF.parent == null)
		{
			layerAdd.addChild(lensF);
			
			Actuate.tween(lensF, .7 + Math.random(), { alpha:1 } ).ease(Linear.easeNone).onComplete(function():Dynamic
			{
				Actuate.tween(lensF, 1 + Math.random() * 2, { alpha:0 } ).ease(Linear.easeNone).onComplete(function():Dynamic
				{
					layerAdd.removeChild(lensF);
					return null;
				});
				return null;
			});
		}*/
		
		if (space.bodies.length < 14 && Math.random() > .99 && lensF.alpha == 0)
		{
			Actuate.tween(lensF, .7 + Math.random(), { alpha:1 } ).ease(Linear.easeNone).onComplete(function():Dynamic
			{
				Actuate.tween(lensF, 1 + Math.random() * 2, { alpha:0 } ).ease(Linear.easeNone);
				return null;
			});
		}
		
		for (i in controlledObj)
		{
			i.run();
		}
		
		enemy_manager();
		
		if (soldierDelay > 0) soldierDelay--
		else if (ridersOnGround.length > 0 && activeSoldiers < shopItems[2])
		{
			if (gameStatus == 2)
			{
				new Soldier(10);
				soldierDelay = 70;
			}
		}
		
		
		space.step(1/60);
		graphicUpdate();
		
		layer.render();
		layerAdd.render();
		if (currentLevel == 1 && htp.parent != null) 
		{
			layerGUI.render();
		}
		//layerAdd1.render();
		
		
		if ((gameStatus == 3  || gameStatus == 4) && cannon.life == 0)
		{
			if (cannon.body != null) 
			{
				fog.emitStart(cannon.body.position.x, cannon.body.position.y, 1);
			}
			else 
			{
				fog.emitStart(z_cannon.x, z_cannon.y, 1);
			}
		}
		if (gameStatus == 5) layerGUI.render();
	}
	
	public function destrFog()
	{
		Game.game.emitters.push(fog);
		playS(s_end);
		Timer.delay(function() { playS(cdamaged); }, 5000);
	}
	
	function makeEnemies(num:UInt, id:UInt)
	{
		for (i in 0...num)
		{
			var z:Int = 0;
			while (z == 0) z = Math.round( -1 + Math.random() * 2); 
			var velocity = Math.round(220 + Math.random() * 140) * z;
			var positionX:Int = 0;
			var positionY:Int = 0;
			
			if (id == 7)
			{
				positionX = 120 + Std.random(770);
				positionY = -70;
			}
			else if (id == 6)
			{
				if (z < 0) positionX = 1100 else positionX = -100;
				positionY = Math.round(40 + Math.random() * enemyLowerLimit);
			}
			else if (id != 2)
			{
				if (z < 0) positionX = 1070 else positionX = -70;
				positionY = Math.round(40 + Math.random() * enemyLowerLimit);
			}
			else
			{
				if (Math.random() > .5)
				{
					if (z < 0) positionX = 1070 else positionX = -70;
					positionY = Math.round(40 + Math.random() * enemyLowerLimit);
				}
				else 
				{
					positionX = Std.random(1070);
					positionY = -70;
				}
			}
			
			
			switch(id)
			{
				case 0:controlledObjPre.push(makeEnemy(positionX, positionY, velocity));
				case 1:controlledObjPre.push(makeEnemyBomber(positionX, positionY, velocity));
				case 2:controlledObjPre.push(makeEnemyFighter(positionX, positionY, velocity));
				case 3:controlledObjPre.push(makeEnemyRoller(positionX, positionY, velocity));
				case 4:controlledObjPre.push(makeEnemyT(positionX, positionY));
				case 5:controlledObjPre.push(makeEnemyBig(positionX, positionY));
				case 6:controlledObjPre.push(makeEnemyBig1(positionX, positionY));
				case 7:controlledObjPre.push(makeEnemyUfo(positionX, positionY));
			}
		}
	}
	
	function ePause(num:UInt)
	{
		for (i in 0...num) controlledObjPre.push(null);
	}
	
	function makeL1()
	{
		gui.setNoClick(7000);
		htp = new TileSprite(layerGUI, "htp");
		htp.x = 500;
		htp.y = 1000;
		layerGUI.addChild(htp);
		Timer.delay(function()
		{
			Actuate.tween(htp, 2, { y:360 } );
		}, 3000);
		layerGUI.render();
		
		riderLim = 0;
		ePause(3);
		makeEnemies(47, 0);
	}
	function makeL2()
	{
		riderLim = 1;
		ridersOffset = 170;
		ePause(3);
		makeEnemies(50, 0);
	}
	function makeL3()
	{
		ridersOffset = 70;
		ePause(3);
		makeEnemies(21, 0);
		ePause(2);
		makeEnemies(1, 1);
		ePause(2);
		makeEnemies(28, 0);
		ePause(1);
		makeEnemies(1, 1);
	}
	function makeL4()
	{
		ePause(3);
		riderVel = 40;
		ridersOffset = 40;
		makeEnemies(30, 0);
		ePause(5);
		makeEnemies(1, 1);
		ePause(3);
		makeEnemies(34, 0);
		ePause(5);
		makeEnemies(2, 1);
		ePause(3);
		makeEnemies(2, 2);
	}
	function makeL5()
	{
		ePause(3);
		
		riderVel = 40;
		
		makeEnemies(14, 0);
		ePause(5);
		makeEnemies(1, 1);
		ePause(2);
		makeEnemies(1, 1);
		ePause(3);
		makeEnemies(40, 0);
		ePause(5);
		makeEnemies(3, 1);
		ePause(2);
		makeEnemies(5, 2);
	}
	function makeL6()
	{
		riderVel = 40;
		eRandomFire = .3;
		ePause(3);
		makeEnemies(14, 0);
		ePause(5);
		makeEnemies(2, 2);
		ePause(2);
		makeEnemies(2, 2);
		ePause(3);
		makeEnemies(40, 0);
		ePause(5);
		makeEnemies(2, 1);
		ePause(5);
		makeEnemies(2, 1);
		ePause(3);
		makeEnemies(7, 2);
		ePause(2);
		makeEnemies(1, 3);
	}
	function makeL7()
	{
		riderVel = 52;
		eRandomFire = .3;
		ePause(3);
		riderLim = 4;
		makeEnemies(7, 2);
		ePause(3);
		makeEnemies(1, 7);
		ePause(2);
		makeEnemies(2, 1);
		ePause(2);
		makeEnemies(2, 1);
		ePause(3);
		makeEnemies(50, 0);
		ePause(5);
		makeEnemies(3, 1);
		ePause(3);
		makeEnemies(1, 3);
		ePause(3);
		makeEnemies(1, 3);
	}
	function makeL8()
	{
		ePause(3);
		eRandomFire = .3;
		riderVel = 60;
		riderLim = 4;
		makeEnemies(3, 1);
		ePause(2);
		makeEnemies(1, 7);
		ePause(1);
		makeEnemies(2, 1);
		ePause(2);
		makeEnemies(2, 1);
		ePause(3);
		makeEnemies(56, 0);
		ePause(3);
		makeEnemies(1, 3);
		ePause(4);
		makeEnemies(1, 4);
		ePause(5);
		makeEnemies(1, 5);
	}
	
	function makeL9()
	{
		ePause(3);
		eRandomFire = .3;
		riderVel = 70;
		riderLim = 4;
		makeEnemies(2, 14);
		makeEnemies(40, 0);
		ePause(2);
		makeEnemies(1, 7);
		ePause(4);
		makeEnemies(4, 1);
		ePause(2);
		makeEnemies(10, 2);
		ePause(3);
		makeEnemies(40, 0);
		ePause(5);
		makeEnemies(1, 6);
	}
	
	function makeL10()
	{
		ePause(3);
		eRandomFire = .4;
		riderVel = 70;
		riderLim = 4;
		makeEnemies(40, 0);
		ePause(2);
		makeEnemies(1, 7);
		ePause(4);
		makeEnemies(1, 5);
		ePause(3);
		makeEnemies(4, 1);
		ePause(2);
		makeEnemies(10, 2);
		ePause(3);
		makeEnemies(40, 0);
		ePause(5);
		makeEnemies(2, 3);
		ePause(3);
		makeEnemies(2, 4);
		ePause(3);
		makeEnemies(1, 6);
	}
	
	function makeL11()
	{
		ePause(3);
		eRandomFire = .5;
		riderVel = 74;
		riderLim = 7;
		makeEnemies(50, 0);
		ePause(3);
		makeEnemies(7, 1);
		ePause(4);
		makeEnemies(2, 4);
		ePause(7);
		makeEnemies(10, 2);
		ePause(2);
		makeEnemies(1, 5);
		ePause(5);
		makeEnemies(4, 3);
		ePause(3);
		makeEnemies(2, 4);
		ePause(7);
		makeEnemies(2, 4);
		ePause(7);
		makeEnemies(1, 6);
	}
	function makeL12()
	{
		ePause(3);
		riderVel = 78;
		eRandomFire = .5;
		riderLim = 7;
		makeEnemies(20, 0);
		ePause(2);
		makeEnemies(12, 1);
		makeEnemies(40, 0);
		makeEnemies(10, 2);
		ePause(5);
		makeEnemies(3, 7);
		ePause(5);
		makeEnemies(4, 3);
		ePause(3);
		makeEnemies(3, 4);
		ePause(7);
		makeEnemies(1, 5);
		ePause(2);
		makeEnemies(1, 5);
	}
	function makeL13()
	{
		ePause(3);
		riderVel = 84;
		eRandomFire = .3;
		riderLim = 7;
		makeEnemies(20, 1);
		ePause(2);
		makeEnemies(20, 0);
		ePause(2);
		makeEnemies(7, 1);
		makeEnemies(40, 0);
		makeEnemies(1, 5);
		ePause(8);
		makeEnemies(4, 3);
		ePause(3);
		makeEnemies(3, 4);
		ePause(7);
		makeEnemies(7, 4);
		ePause(3);
		makeEnemies(1, 5);
		ePause(4);
		makeEnemies(1, 6);
	}
	function makeL14()
	{
		ePause(3);
		riderVel = 87;
		eRandomFire = .5;
		riderLim = 8;
		makeEnemies(20, 1);
		ePause(2);
		makeEnemies(20, 0);
		ePause(2);
		makeEnemies(10, 1);
		makeEnemies(40, 0);
		makeEnemies(2, 5);
		ePause(8);
		makeEnemies(4, 3);
		ePause(3);
		makeEnemies(3, 4);
		ePause(8);
		makeEnemies(7, 4);
		makeEnemies(2, 6);
	}
	
	function makeL15()
	{
		ePause(3);
		riderVel = 90;
		eRandomFire = .5;
		riderLim = 8;
		makeEnemies(20, 1);
		ePause(2);
		makeEnemies(20, 0);
		ePause(2);
		makeEnemies(10, 1);
		makeEnemies(7, 5);
		makeEnemies(40, 0);
		makeEnemies(2, 5);
		ePause(8);
		makeEnemies(4, 3);
		ePause(3);
		makeEnemies(3, 4);
		ePause(7);
		makeEnemies(2, 6);
	}
}