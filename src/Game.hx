package;
import aze.display.SparrowTilesheet;
import aze.display.TileClip;
import aze.display.TileGroup;
import aze.display.TileLayer;
import aze.display.TileSprite;
import flash.net.URLRequest;
import nape.geom.Ray;
import nape.geom.RayResult;



#if flash
import flash.media.SoundMixer;
#end

import nape.dynamics.InteractionGroup;



import extension.locale.Locale;


//import extension.share.Share;


import particles.Particle;
#if cpp 
import cpp.vm.Gc;
#end
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

//import nape.util.BitmapDebug;

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

//import extension.admob.AdMob;
//import extension.admob.GravityMode;
//import extension.adbuddiz.AdBuddiz;

//import extension.adcolony.AdColony;
//import extension.adcolony.IAdColony;

//import extension.iap.IAP;
//import extension.iap.IAPEvent;
#end

@:final
class Game extends Sprite //#if mobile implements IAdColony #end
{
	
	//var debug:BitmapDebug = new BitmapDebug(1000, 640, 0, true );
	
	public var lastChance:Bool = true;
	var lastChanceWindow:TileSprite;
	public var noDamage:Bool = false;
	
	public var rewardCounter = 0;
	var rewardTimer:Timer;
	
	var rectAccept:Rectangle;
	var rectDecline:Rectangle;
	
	public var rewardedVideoIsEnabled:Bool = false;
	
	public var addFunds:UInt = 800;
	
	public var board0:TileSprite;
	public var board1:TileSprite;
	public var wallPosition:UInt;
	
	public var kX:Float;
	public var kY:Float;
	
	public var dtX:Float;
	public var dtY:Float;
	
	public var boardVerticalOrientation:Bool = true;
	
	#if flash
	var scaleFactor:Float = 1.25;
	#else
	var scaleFactor:Float = 1;
	#end
	
	#if mobile
	var adColonyAvailable:Bool;
	var ID:String = "ca-app-pub-6044124647637374/2602893845";
	var B_ID:String = "ca-app-pub-6044124647637374/4079627041";
	var gID:String = "UA-51825443-11";
	#end
	
	#if android
	public static inline var APP_ID = "app85109d432eb848f2a6";
	//public static inline var ZONE_ID = "vz06e8c32a037749699e7050"; // Interstitial
	public static inline var ZONE_ID = "vz31452df266d74dddb4"; // V4VC
	#elseif ios
	public static inline var APP_ID = "appfd6872a2b90f45438b";
	//public static inline var ZONE_ID = "vzf8fb4670a60e4a139d01b5"; // Interstitial
	public static inline var ZONE_ID = "vz375c9db45ffc467c8d"; // V4VC
	#end
	
	public var efd:UInt = 40;
	
	public var lang:String;
	
	var upS:Sound = Assets.getSound("upgr");
	
	var upG:TileSprite;
	
	public var rank:String;
	
	public var start1:RaiderShip;
	public var start2:RaiderShip;
	var sd:TileSprite;
	var tutorContinue:TileSprite;
	
	var gpTimer:UInt = 0;
	
	var cantFire:Bool;
	
	public var gui:GUI;
	
	public var cShellGroup:InteractionGroup;
	
	var vol = .7;
	
	var showAd:Int = 0;
	var adBlock:Bool = false;
	
	var lensFB:TileSprite;
	var lensF:TileSprite;
	var lensF1:TileSprite;
	var flare:TileSprite;
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
	public var shopItems:Array<UInt> = [0, 0, 1];
	
	//public var shopPrices:Array<UInt> = [8400, 7500, 14000];
	public var shopPrices:Array<UInt> = [1000, 1000, 20000];
	
	public var isRevardEnabled:Bool = true;
	
	#if mobile
	public var unlocked:Bool = false;
	#end
	
	public var earningUp:Float = 1;
	public var upgrades:Array<Array<UInt>>;
	
	public static var game:Game;
	public var noClick:Bool;
	public var so:SharedObject;
	
	var inited:Bool;
	
	public var layer:TileLayer;
	public var layerAdd:TileLayer;
	public var layerAdd1:TileLayer;
	public var layerGUI:TileLayer;
	
	var lFinger:TileSprite;
	var lFingerShadow:TileSprite;
	
	var rFinger:TileSprite;
	var rFingerShadow:TileSprite;
	
	var tutorStep:UInt = 0;
	
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
	
	
	public var controlledObj:Array<Dynamic>;
	var controlledObjPre:Array<Dynamic>;
	
	public var emitters:Array<ParticlesEm>;
	var clouds:ParticlesEm;
	public var smoke:ParticlesEm;
	
	public var cannon:Cannon;
	var b0AlphaStep:Float;
	var b0:TileSprite;
	public var b0Timer:UInt = 0;
	var b0Shield:TileSprite;
	public var b0Body:Body;
	var b1:TileSprite;
	var b1Flag:UInt = 0;
	var fog:ParticlesEm;
	
	public var slower:Bool;
	
	public var cannonRotVel:Float;
	public var cannonEnergyStepAdd:Float;
	public var cannonLife:Int;
	
	public var damageRider:UInt = 10;
	public var damageBomb:UInt = 80;
	public var damageFighter:UInt = 70;
	public var jumpTime = 80;
	public var eRandomFire:Float = .2;
	
	var canDestr:ParticlesEm;
	
	
	public var riderVel:UInt;
	
	public var riderLive:UInt;
	public var riderLim:UInt;
	
	public var ridersOnGround:Array<RaiderShip>;
	
	var totalEnemy:UInt;
	var totalBomber:UInt;
	
	public var enemyLowerLimit:UInt;
	
	var soldierDelay:UInt;
	public var activeSoldiers:UInt;
	
	var touchPointX:Float;
	var touchMoveLength:UInt = 4;
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
	
	public var fe:Sound = Assets.getSound("fe");
	var sh_sh:Sound = Assets.getSound("sh_sh");
	public var s20:Sound = Assets.getSound("20stars");
	public  var attackWarning:Sound = Assets.getSound("attackWarning");
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
	
	var nextSet:TileSprite;
	
	
	//------CANON_S
	
	
	var ex0:Sound = Assets.getSound("ex0");
	var ex1:Sound = Assets.getSound("ex1");
	var ex2:Sound = Assets.getSound("ex2");
	var ex3:Sound = Assets.getSound("ex3");
	var ex4:Sound = Assets.getSound("ex4");
	
	var rico0:Sound = Assets.getSound("rico0");
	var rico1:Sound = Assets.getSound("rico1");
	var rico2:Sound = Assets.getSound("rico2");
	var rico3:Sound = Assets.getSound("rico3");
	var rico4:Sound = Assets.getSound("rico4");
	var rico5:Sound = Assets.getSound("rico5");
	
	var tym0:Sound = Assets.getSound("tym0");
	var tym1:Sound = Assets.getSound("tym1");
	var tym2:Sound = Assets.getSound("tym2");
	var tym3:Sound = Assets.getSound("tym3");
	var tym4:Sound = Assets.getSound("tym4");
	
	public var ufom:Sound = Assets.getSound("ufom");
	
	var nextRico:UInt = 0;
	var nextTym:UInt = 0;
	
	public var sh1:Sound = Assets.getSound("shut1");
	public var sh2:Sound = Assets.getSound("shut2");
	public var sh3:Sound = Assets.getSound("shut3");
	public var sh4:Sound = Assets.getSound("shut4");
	public var sh5:Sound = Assets.getSound("shut5");
	
	public var ready2rider:UInt = 0;
	public var set_ready2rider:UInt = 4900;
	
	//var music:SControll;
	var channel:SoundChannel;
	public var channelR:SoundChannel;
	
	
	var bg:TileSprite;
	
	public var gameStatus:UInt;
	
	var stageW:Float;
	var stageH:Float;
	
	var dtFingerX:Float;
	
	var ray:Ray;
	var rightTapAnimIshown:Bool = false;
	
	//inap billing_______________________________________________________________________________________________________________
	#if android
	var licenseKey:String = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA4+UWt+mRZwbyDRbsmglvYYKS0fBz6lFRdXoBcQzL6oZtu43Prv8sKyN8XiTz1NCThCdnEbK0jS/O7ZFmzPG9zY/hJt6fiSqPTfYN+pppmRbQ8ewqGh+yM1JBlT6DY8Quz/Hga3Ubjnl9czrQmJ3+BwEdmjCObBb/uyCC7iH4IExXXhaTefV+KIFnCSe91nDkWLw+4LURQ3vWfiZZBeIZ+bVfjICI1GIGNekpRXBijBYCzbMZ2/ROcc5wygu6FaMB8o0CRwq1HZWWFnO4oRbkqoVolgGuGJlxoEUWdMubE/VeJ/ij2X8MizHMM2To5JQaODJxpznoCVGjdrA/9sIAYQIDAQAB";
	#else
	var licenseKey:String = "";
	#end
	
	#if mobile
	
	public function onAdColonyAdStarted():Void
	{
		//trace("Started");
	}
	
	public function onAdColonyAdAttemptFinished( shown:Bool, notShown:Bool, skipped:Bool, canceled:Bool, noFill:Bool ):Void
	{
		//trace("Finished,"+shown+","+notShown+","+skipped+","+canceled+","+noFill);
	}
	
	public function onAdColonyAdAvailabilityChange( available:Bool, name:String ):Void
	{
		//trace("Availability," + available + "," + name);
		adColonyAvailable = available;
		
		/*if ( available )
		{
			AdColony.showV4VCAd( ZONE_ID );
		}*/
	}
	
	public function onAdColonyV4VCReward( success:Bool, name:String, amount:Float ):Void
	{
		//trace("Reward," + success + "," + name + "," + amount);
	}
	
	/*function startBilling()
	{
		if (IAP.available) 
		{
			IAP.addEventListener (IAPEvent.PURCHASE_SUCCESS, IAP_onPurchaseSuccess);
			//IAP.addEventListener (IAPEvent.PURCHASE_FAILURE, IAP_onPurchaseFailure);
			//IAP.addEventListener (IAPEvent.PURCHASE_CANCEL, IAP_onPurchaseCancel);
			IAP.purchase ("premium");
		}
	}*/
	
	/*private function IAP_onInitFailure (event:IAPEvent):Void 
	{
		trace ("Could not initailize IAP");
	}*/
	
	/*private function IAP_onInitSuccess (event:IAPEvent):Void
	{
		IAP.addEventListener (IAPEvent.PURCHASE_QUERY_INVENTORY_COMPLETE, onPurchaseQueryInventoryComplete);
		//IAP.addEventListener (IAPEvent.PURCHASE_QUERY_INVENTORY_FAILED, onPurchaseQueryInventoryFailed);
		
		if (IAP.available) 
		{
			var ta:Array<String> = new Array();
			#if ios
			IAP.requestProductData (ta);
			#elseif android
			IAP.queryInventory (true);
			#end
		}
	}*/
	
	/*private function onPurchaseQueryInventoryFailed(e:IAPEvent):Void
	{
		trace("QI fail");
	}*/

	/*private function onPurchaseQueryInventoryComplete(e:IAPEvent):Void
	{
		if (e.productsData != null)
		{
			//if (e.productsData.length != 0) unlocked = true;
			
			
		}
	}*/
	
	/*private function IAP_onPurchaseCancel (event:IAPEvent):Void 
	{
		//trace ("User cancelled purchase");
	}
	
	private function IAP_onPurchaseFailure (event:IAPEvent):Void 
	{
		//trace ("Could not purchase item");
	}*/
	
	/*private function IAP_onPurchaseSuccess (event:IAPEvent):Void
	{
		gui.setNoClick(1400);
		gui.clickCancelIap();
		unlocked = true;
		save();
	}*/
	
	/*private function getStoreDataFromIAP() :Void {
		//trace("getStoreDataFromIAP");
		
		//var orderArr:Array<String> = GameModel.getInstance().data.node.storeItems.att.order.split(",");
		var stored:Array<String> = new Array<String>();
		#if ios
		IAP.requestProductData (stored);
		#elseif android
		IAP.queryInventory (true, stored);
		#end
		
		Timer.delay(function()
		{
			if (stored[0] == "unlock") playS(ex0);
		}, 14000);
	}*/
	#end
	//__________________________________________________________________________________________________________________
	
	
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
	
	function onRewardGranted()
	{
		#if mobile
		Heyzap.rewardedVideoAd(0);
		#end
		
		gui.removeChild(gui.iap);
		
		rewardCounter = 180;
		
		var revardAmount:UInt;
		
		if (checkUpgrades() > 19) revardAmount = 10000;
		else if (checkUpgrades() > 14) revardAmount = 7000;
		else if (checkUpgrades() > 9) revardAmount = 3000;
		else if (checkUpgrades() > 4) revardAmount = 1000;
		else revardAmount = 200;
		
		money += revardAmount;
		gui.setMoney();
	}
	
	
	/*private inline function memU()
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
	}*/
	
	public function wall(vertical:Bool = false)
	{
		if (wallPosition == 0) return;
		
		if (board0 == null)
		{
			board0 = new TileSprite(layerGUI, "wall");
			board1 = new TileSprite(layerGUI, "wall");
			
			wallPos(wallPosition);
		}
		
		if (board0.parent == null)
		{
			layerGUI.addChild(board0);
			layerGUI.addChild(board1);
		}
	}
	
	public function wallPos(pos:UInt)
	{
		switch(pos)
		{
			case 0:
			case 1:
				board0.x = board1.x = board0.width / 2;
				board0.y =-67;
				board0.scaleY =-1;
				board1.y = 667;
			case 2:
				board0.y = board1.y = board0.width / 2;
				board0.x =-67;
				board1.x = 1067;
				board0.rotation = Math.PI / 2;
				board1.rotation = -Math.PI / 2;
		}
	}
	
	public function new()
	{
		super();
		
		rewardTimer = new Timer(1000);
		rewardTimer.run = function()
		{
			if (rewardCounter > 0) 
			{
				rewardCounter--; 
				if (gameStatus == 0 && gui != null && gui.iapTm.parent != null)
				{
					if(rewardCounter > 0) gui.iapTm.newValue(Std.string(rewardCounter), true);
					else 
					{
						gui.removeChild(gui.iapTm);
						gui.addIapB();
					}
				}
			}
			
		}
		
		#if mobile
		//Heyzap.init("4bc585b36c9a8361d9512fd604b9ddbd");
		Heyzap.init("f96d9e879f303781f43287b02148a991");
		Heyzap.rewardedVideoAd(0);
		//Heyzap.presentMediationDebug();
		
		Tapdaq.init("585081d3af68dc002eee11b5", "156bd775-ba73-499c-a61b-16ccb8f603f2", 0);
		Tapdaq.showInterstitial();
		
		#end
		lastChanceWindow = new TileSprite(layerGUI, "lastChance");
		lastChanceWindow.x = 500;
		lastChanceWindow.y = 300;
		
		rectAccept = new Rectangle(308, 324, 181, 52);
		rectDecline = new Rectangle(508, 324, 181, 52);
		
		stageW = Lib.current.stage.stageWidth;
		stageH = Lib.current.stage.stageHeight;
		
		#if flash
		SoundMixer.soundTransform = new SoundTransform( .34 );
		#end
		
		game = this;
		
		cShellGroup = new InteractionGroup(true);
		
		lang = Locale.getSmartLangCode();
		//lang = "en";
		
		currentLevel = 1;
		
		so = SharedObject.getLocal("MEGAGUN_30");
		if (so.data.level != null) 
		{
			currentLevel = so.data.level;
			upgradesProgress = so.data.upgradeProgress;
			money = so.data.money;
			shopItems = so.data.shopItems;
			#if mobile
			unlocked = so.data.unlocked;
			#end
		}
		
		#if mobile 
		unlocked = false; 
		#end
		
		if (currentLevel == 1) reset();
		
		/*currentLevel = 16;
		upgradesProgress[0] = 5;
		upgradesProgress[1] = 5;
		upgradesProgress[2] = 5;
		upgradesProgress[3] = 5;
		upgradesProgress[4] = 5;
		money = 100000;
		shopItems[2] = 2;*/
		
		
		//trace('unlo = ' + unlocked);
		
		/*#if mobile
		if (!unlocked)
		{
			AdColony.configure(APP_ID, [ZONE_ID], this);
			
			
			AdMob.enableTestingAds();
			#if android
			//trace("admobinit");
			AdMob.initAndroid(B_ID, ID, GravityMode.TOP);
			
			#elseif ios
			AdMob.initIOS(B_ID, ID, GravityMode.TOP);
			#end
		}
		#end*/
		
		
		#if cpp 
		Gc.enable(true);
		#end
		
		
		gameStatus = 0;
		
		upgrades = 
		[
			/*[700, 2200, 5900, 11400, 17000],
			[700, 2200, 5900, 11400, 17000],
			[500, 1800, 5500, 8400, 12000],
			[420, 1900, 5600, 9700, 14000],
			[500, 1900, 5500, 9000, 12400]
			
			*/
			
			[1000, 3200, 8900, 18400, 27000],
			[1000, 3200, 8900, 18400, 27000],
			[800, 2800, 8500, 15400, 22000],
			[720, 2900, 8600, 16700, 24000],
			[800, 2900, 8500, 16000, 22400]
		];
		
		var sheetData = Assets.getText("ts/texture_gui.xml");
		var tilesheet = new SparrowTilesheet(Assets.getBitmapData("ts/texture_gui.png"), sheetData);
		
		layerGUI = new TileLayer(tilesheet);
		addChild(layerGUI.view);
		
		var appLogo:TileSprite = new TileSprite(layerGUI, "appsolute");
		layerGUI.addChild(appLogo);
		appLogo.x = 500;
		appLogo.y = 300;
		appLogo.alpha = 0;
		Actuate.tween(appLogo, 3, { alpha:1 } ).onComplete(function():Dynamic
		{
			Timer.delay(function() {
				Actuate.tween(appLogo, 4, { alpha:0 } ).onComplete(function():Dynamic
				{
					layerGUI.removeChild(appLogo);
					myLogo();
					return null;
				});
			}, 2000);
			return null;
		});
		
		
		//myLogo();
		
		
		addEventListener (Event.ENTER_FRAME, this_onEnterFrame);
		
		var stmp:Sound = new Sound();
		stmp = Assets.getSound("music");
		channel = stmp.play(0, 999999, new SoundTransform (vol, 0));
	}
	
	function myLogo()
	{
		var logocrush:Sound = Assets.getSound("logocrush");
		
		
		var logo:TileClip = new TileClip(layerGUI, "logo_f", 8);
		logo.x = 500;
		logo.y = 300;
		logo.alpha = 0;
		layerGUI.addChild(logo);
		layerGUI.render();
		
		Actuate.tween(logo, 2, { alpha:1 } ).ease(Quad.easeOut);
		
		var logoB:TileSprite;
		
		Timer.delay(function() {
			layerGUI.removeChild(logo);
			logoB = new TileSprite(layerGUI, "logobr_h");
			logoB.x = 500;
			logoB.y = 300;
			layerGUI.addChild(logoB);
			layerGUI.render();
			logocrush.play();
		}, 3300);
		
		Timer.delay(function() {
			layerGUI.removeChild(logoB);
			logoB = new TileSprite(layerGUI, "logobr");
			logoB.x = 500;
			logoB.y = 300;
			layerGUI.addChild(logoB);
			
			var logoT = new TileSprite(layerGUI, "logotxt");
			logoT.x = 600;
			logoT.y = 277;
			logoT.alpha = 0;
			layerGUI.addChild(logoT);
			Actuate.tween(logoT, .4, { x:557, alpha:1 } ).ease(Quad.easeOut);
			
			layerGUI.render();
			
			Actuate.tween(logoB, .4, { x:400 } ).ease(Quad.easeOut).onComplete(function():Dynamic
			{
				Timer.delay(function() {
					Actuate.tween(logoT, 4, { alpha:0 } ).ease(Quad.easeOut);
					Actuate.tween(logoB, 4, { alpha:0 } ).ease(Quad.easeOut).onComplete(function():Dynamic
					{
						layerGUI.removeAllChildren();
						removeChild(layerGUI.view);
						gInit();
						inited = true;
						return null;
					});
				}, 3400);
				return null;
			});
		}, 4000);
	}
	
	function gInit()
	{
		var stmp = Assets.getSound("cannonR");
		channelR = stmp.play(0, 9999999, new SoundTransform (0, 0));
		
		slower = false;
		
		if (currentLevel < 5) efd = 40
		else if ( currentLevel >= 5 && currentLevel < 11) efd = 30
		else efd = 20;
		
		controlledObjPre = new Array();
		controlledObj = new Array();
		emitters = new Array();
		moneyGr = new Fnt(20, 20, "0", layer, 4);
		
		
		
		#if mobile
		Lib.current.stage.addEventListener (TouchEvent.TOUCH_BEGIN, touchBegin);
		Lib.current.stage.addEventListener (TouchEvent.TOUCH_END, touchEnd);
		Lib.current.stage.addEventListener (TouchEvent.TOUCH_MOVE, touchMove);
		#elseif html5
		Lib.current.stage.addEventListener (TouchEvent.TOUCH_BEGIN, touchBegin);
		Lib.current.stage.addEventListener (TouchEvent.TOUCH_END, touchEnd);
		Lib.current.stage.addEventListener (TouchEvent.TOUCH_MOVE, touchMove);
		Lib.current.stage.addEventListener (KeyboardEvent.KEY_DOWN, keyDown);
		Lib.current.stage.addEventListener (KeyboardEvent.KEY_UP, keyUp);
		Lib.current.stage.addEventListener (MouseEvent.DOUBLE_CLICK, preventDefault);
		Lib.current.stage.addEventListener (MouseEvent.CLICK, preventDefault);
		#else
		Lib.current.stage.addEventListener (KeyboardEvent.KEY_DOWN, keyDown);
		Lib.current.stage.addEventListener (KeyboardEvent.KEY_UP, keyUp);
		#end
		
		Lib.current.stage.addEventListener (MouseEvent.MOUSE_DOWN, md);
		
		
		
		
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
		
		
		
		bp = new TileSprite(layer, "bp");
		bp.x = 970;
		bp.y = 30;
		
		var sheetData = Assets.getText("ts/texture.xml");
		var tilesheet = new SparrowTilesheet(Assets.getBitmapData("ts/texture.png"), sheetData);
		
		layer = new TileLayer(tilesheet);
		addChild(layer.view);
		
		sheetData = Assets.getText("ts/texture_add.xml");
		tilesheet = new SparrowTilesheet(Assets.getBitmapData("ts/texture_add.png"), sheetData);
		
		var add = true;
		layerAdd = new TileLayer(tilesheet, true, add);
		addChild(layerAdd.view);
		
		sheetData = Assets.getText("ts/texture_add1.xml");
		tilesheet = new SparrowTilesheet(Assets.getBitmapData("ts/texture_add1.png"), sheetData);
		
		layerAdd1 = new TileLayer(tilesheet, true, add);
		addChild(layerAdd1.view);
		
		upG = new TileSprite(layerAdd, "upgr");
		upG.x = 500;
		upG.y = 510;
		
		lensF = new TileSprite(layerAdd, "lensF");
		lensF.x = 500;
		lensF.y = 300;
		lensF.alpha = 0;
		layerAdd.addChild(lensF);
		
		lensF1 = new TileSprite(layerAdd1, "flr1");
		lensF1.x = 500;
		lensF1.y = 300;
		lensF1.alpha = 0;
		layerAdd1.addChild(lensF1);
		
		lensFB = lensF1;
		
		flare = new TileSprite(layerAdd, "flare");
		flare.alpha = 0;
		flare.x = 500;
		
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
		
		#if !flash
		var tXml:String;
		tXml = Assets.getText("xml/clouds.xml");
		clouds = new ParticlesEm(layerAdd, tXml, "sky", layerAdd, 0);
		#end
		
		
		
		gui = new GUI();
		
		//new Fnt(200, 200, "centrall cannon", layerGUI);
		//new Fnt(200, 240, "ingeborge dabkunaite", layerGUI);
		
		//addChild(debug.display);
		//debug.drawConstraints = true;
		
		var tXml = Assets.getText("xml/ricochet3.xml");
		sh_sh_e = new ParticlesEm(Game.game.layerAdd, tXml, "f_part", Game.game.layerAdd);
		
		tXml = Assets.getText("xml/bumC.xml");
		canDestr = new ParticlesEm(Game.game.layerAdd, tXml, "shard", Game.game.layer);
		
		tXml = Assets.getText("xml/ricochet2.xml");
		fighter_e = new ParticlesEm(Game.game.layerAdd, tXml, "rico", Game.game.layerAdd);
		
		tXml = Assets.getText("xml/ricochetShellShell.xml");
		s_s = new ParticlesEm(Game.game.layerAdd, tXml, "rico", Game.game.layerAdd);
		
		tXml = Assets.getText("xml/ricochetShellShell1.xml");
		s_s1 = new ParticlesEm(Game.game.layerAdd, tXml, "part_green", Game.game.layerAdd);
		
		tXml = Assets.getText("xml/addExpl.xml");
		add_ex = new ParticlesEm(Game.game.layerAdd, tXml, "part_green", Game.game.layerAdd);
		
		
		
		tXml = Assets.getText("xml/ricochetB.xml");
		bomber_e = new ParticlesEm(Game.game.layerAdd, tXml, "rico", Game.game.layerAdd);
		
		tXml = Assets.getText("xml/ufo_f.xml");
		ufo_f = new ParticlesEm(Game.game.layerAdd, tXml, "ring", Game.game.layerAdd);
		
		var tXml = Assets.getText("xml/smoke_cannon.xml");
		fog = new ParticlesEm(Game.game.layer, tXml, "firstFog_00042", Game.game.layer);
		
		if (currentLevel == 1) nextSetSet();
		
	}
	
	function nextSetSet()
	{
		var nn = "nextset";
		if (lang == "ru") nn = "nextset_ru";
		nextSet = new TileSprite(layer, nn);
		nextSet.x = 500;
		nextSet.y = 270;
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
		
		#if cpp
		Gc.run(true);
		Gc.run(true);
		#end
		
		earningUp = 1.0;
		
		#if mobile
		if (!unlocked)
		//if (unlocked)
		{
			if (checkUpgrades() > 24) earningUp = 2.5
			else if (checkUpgrades() > 19) earningUp = 2.3
			else if (checkUpgrades() > 13) earningUp = 1.7
			else if (checkUpgrades() > 7) earningUp = 1.2;
		}
		else if (currentLevel < 5) earningUp = .8
		else earningUp = 1;
		#else
		if (checkUpgrades() > 22) earningUp = 2.5
		else if (checkUpgrades() > 19) earningUp = 2.3
		else if (checkUpgrades() > 13) earningUp = 1.7
		else if (checkUpgrades() > 7) earningUp = 1.2;
		#end
		
		if (currentLevel > 21) earningUp = 2.7;
		
		fire = false;
		
		if (shopItems[0] > 0)
		{
			if (b0Body == null)
			{
				b0 = new TileSprite(layer, "b0");
				b0.x = 280; b0.y = 550;
				
				b0Body = new Body(BodyType.STATIC, new Vec2(500, 470));
				b0Body.shapes.add(new Circle(142));
				b0Body.cbTypes.add(cbShield);
				b0Body.shapes.at(0).sensorEnabled = true;
			}
		}
		
		if (shopItems[1] > 0)
		{
			if (b1 == null)
			{
				b1 = new TileSprite(layer, "b1");
				b1.x = 720; b1.y = 550;
			}
		}
		ridersOffset = 0;
		
		tutorStep = 0;
		
		rightTapAnimIshown = false;
		
		gpTimer = 0;
		start1 = null;
		start2 = null;
		
		timer = 0;
		enemyBornDelay = 0;
		enemyBornDelayLim = 70;
		soldierDelay = 0;
		activeSoldiers = 0;
		
		set_ready2rider = 128;
		
		
		riderLive = 0;
		ridersOnGround = new Array();
		
		riderVel = 30;
		riderLim = 1;
		
		enemyLowerLimit = 200;
		
		lastChance = true;
		noDamage = false;
		
		Timer.delay(function()
		{
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
				case 16: makeL16();
				case 17: makeL17();
				case 18: makeL18();
				case 19: makeL19();
				case 20: makeL20();
				case 21: makeL21();
				case 22: makeL22();
				case 23: makeL23();
				case 24: makeL24();
				case 25: makeL25();
				case 26: makeL26();
				case 27: makeL27();
				case 28: makeL28();
				case 29: makeL26();
				case 30: makeL27();
				case 31: makeL28();
				case 32: makeL26();
				case 33: makeL27();
				case 34: makeL28();
				case 35: makeL26();
				case 36: makeL27();
				case 37: makeL28();
				case 38: makeL26();
				case 39: makeL27();
				case 40: makeL28();
				case 41: makeL26();
				case 42: makeL27();
				case 43: makeL26();
				case 44: makeL28();
			}
		}, 400);
		/*
		currentLevel = 2;
		upgradesProgress[0] = 1;
		upgradesProgress[1] = 1;
		upgradesProgress[2] = 5;
		upgradesProgress[3] = 5;
		upgradesProgress[4] = 5;*/
		
		
		
		switch(upgradesProgress[4])
		{
			case 0: cannonRotVel = 1;
			case 1: cannonRotVel = 1.3;
			case 2: cannonRotVel = 1.8;
			case 3: cannonRotVel = 2.3;
			case 4: cannonRotVel = 2.8;
			case 5: cannonRotVel = 3.4;
		}
		
		switch(upgradesProgress[2])
		{
			case 0: cannonEnergyStepAdd = .01;
			case 1: cannonEnergyStepAdd = .017;
			case 2: cannonEnergyStepAdd = .024;
			case 3: cannonEnergyStepAdd = .03;
			case 4: cannonEnergyStepAdd = .05;
			case 5: cannonEnergyStepAdd = .07;
		}
		
		if (Game.game.currentLevel == 1) cannonLife = 2100
		else switch(upgradesProgress[3])
		{
			case 0: cannonLife = 100;
			case 1: cannonLife = 220;
			case 2: cannonLife = 370;
			case 3: cannonLife = 580;
			case 4: cannonLife = 800;
			case 5: cannonLife = 1200;
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
		emitters.push(canDestr);
		
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
		
		lensF1.alpha = 0;
		layerAdd1.addChild(lensF1);
		
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
		#if !flash
		if (!musicFlag)
		{
			channel.soundTransform = new SoundTransform(0);
		}
		else 
		{
			channel.soundTransform = new SoundTransform(vol);
		}
		#else
		if (!musicFlag)
		{
			SoundMixer.soundTransform = new SoundTransform( 0 );
		}
		else 
		{
			SoundMixer.soundTransform = new SoundTransform( .34 );
		}
		#end
	}
	
	function b0Appear()
	{
		var shieldTemp = b0Shield;
		Actuate.tween(shieldTemp, 1, { scale:4, alpha:0 } ).onComplete(function():Dynamic
		{
			layer.removeChild(shieldTemp);
			Timer.delay(function()
			{
				if(b0Shield == null || b0Shield.parent == null) b0Body.space = null;
			}, 270);
			return null;
		});
		
		if (shopItems[0] != 0) Actuate.tween(b0, .4, { scale:1, alpha:1 } )
		else layer.removeChild(b0);
	}
	
	function b0Tap()
	{
		if (shopItems[0] == 0 || b0Timer > 0) return;
		
		b0Shield = new TileSprite(layer, "shield");
		b0Shield.x = 500; b0Shield.y = 440;
		
		playS(s_shield);
		shopItems[0]--;
		Actuate.tween(b0, .5, { scale:2, alpha:0 } );
		
		
		layer.addChild(b0Shield);
		b0Shield.scale = .1;
		b0Shield.alpha = 0;
		b0Timer = 350;
		
		Actuate.tween(b0Shield, 1, { scale:1, alpha:1 } );
		
		b0Body.space = space;
	}
	
	function b1Tap()
	{
		if (shopItems[1] == 0 || b1Flag != 0 || pause) return;
		shopItems[1]--;
		Actuate.tween(b1, .05, { scale:4, alpha:0 } );
		b1Flag = 21;
		
		new Messile(new Vec2(500, 430));
		
		#if !flash
		s_s.emitStart(500, 500, 8);
		#else
		s_s.emitStart(500, 500, 1);
		#end
		
		playS(s_roketa);
	}
	
	function startBattle()
	{
		playS(siren);
		
		Timer.delay(function() { playS(siren); }, 4000);
		
		gui.clear();
		if (currentLevel != 1) 
		{
			layerGUI.removeAllChildren();
			wall();
		}
		
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
		z_temp = new TileSprite(layer, "bg_z");
		z_temp.x = 500;
		z_temp.y = 587;
		z_cannon.x = 500;
		z_cannon.y = 670;
		z_base.x = 500;
		z_base.y = 680;
		layer.addChild(z_base);
		layer.addChild(z_cannon);
		layer.addChild(z_temp);
		layer.render();
		
		Actuate.tween(z_cannon, 4, { y:495 } ).ease(Linear.easeNone);
		Actuate.tween(z_base, 4, { y:538 } ).ease(Linear.easeNone).onComplete(function():Dynamic
		{
			makeCannon();
			layer.removeChild(z_cannon);
			layer.removeChild(z_temp);
			//layer.removeChild(b);
			gameStatus = 2;
			graphicUpdate();
			cannon.run();
			layer.render();
			layer.render();
			return null;
		});
		
		layer.render();
	}
	
	public function lastCh()
	{
		if (!rewardedVideoIsEnabled) 
		{
			lastChance = false;
			cannon.destruction();
			return;
		}
		
		gameStatus = 3;
		channelR.soundTransform = new SoundTransform(0);
		lastChanceWindow.scale = .01;
		layerGUI.addChild(lastChanceWindow);
		Actuate.tween(lastChanceWindow, .4, {scale:1});
		
		cannon.direction = 0;
	}
	
	public function endBattle()
	{
		//cannon.ray.parent.removeChild(cannon.ray);
		if (currentLevel == 1) 
		{
			var tMoney = money;
			reset();
			money = tMoney;
		}
		if (cannon.life != 0) 
		{
			var p = "";if (Game.game.currentLevel == 1) p = "st"
			else if (Game.game.currentLevel == 2) p = "nd"
			else if (Game.game.currentLevel == 3) p = "rd"
			else p = "th";
			
			if (lang == "ru")
			{
				if (currentLevel == 3) rank = "cth;fyn";
				else if (currentLevel == 5) rank = "ghfgjhobr";
				else if (currentLevel == 7) rank = "vkflibb ktbntyfyn";
				else if (currentLevel == 10) rank = "cnfhibb ktbntyfyn";
				else if (currentLevel == 12) rank = "rfgbnfy";
				else if (currentLevel == 14) rank = "vfbjh";
				else if (currentLevel == 17) rank = "gjlgjkrjdybr";
				else if (currentLevel == 20) rank = "gjkrjdybr";
				else if (currentLevel == 21) rank = "utythfk vfbjh";
			}
			else
			{
				if (currentLevel == 3) rank = "corporal";
				else if (currentLevel == 5) rank = "sergeant";
				else if (currentLevel == 7) rank = "staff sergeant";
				else if (currentLevel == 10) rank = "warrant officer";
				else if (currentLevel == 12) rank = "chief warrant officer";
				else if (currentLevel == 14) rank = "second lieutenant";
				else if (currentLevel == 17) rank = "first lieutenant";
				else if (currentLevel == 20) rank = "captain";
				else if (currentLevel == 21) rank = "colonel";
			}
			
			if (currentLevel != 1) 
			{
				if (lang == "ru") gui.endBattle((currentLevel - 1) + "z" + " djkyf ecgtiyj jnhf;tyf", "djkyf " + currentLevel)
				else gui.endBattle("successfully repulsed the " + (currentLevel - 1) + p + " wave", "wave " + currentLevel);
			}
			else 
			{
				if (lang == "ru") gui.endBattle("nhtybhjdrf pfrjyxtyf ecnfyjdkty ,fpjdsb rjvgktrn djjhe;tybz", "djkyf " + currentLevel)
				else gui.endBattle("weapons check completed base weapon kit has been installed now", "wave " + currentLevel);
			}
			currentLevel++;
			save();
		}
		else 
		{	
			if (lang == "ru") 
			{
				if (currentLevel > 1) gui.endBattle("ytj,[jlbv rfgbnfkmysb htvjyn", "gjdnjhbnm gjgsnre")
				else
				{
					gui.endBattle("nhtybhjdrf pfrjyxtyf ecnfyjdkty ,fpjdsb rjvgktrn djjhe;tybz", "djkyf " + currentLevel);
					currentLevel++;
					save();
				}
			}
			else 
			{
				if (currentLevel > 1) gui.endBattle("cannon requires overhaul", "try again")
				else 
				{
					gui.endBattle("weapons check completed base weapon kit has been installed now", "wave " + currentLevel);
					currentLevel++;
					save();
				}
			}
		}
		
		playS(s_ca);
		layer.addChild(z_cannon);
		layer.addChild(z_temp);
		Actuate.tween(z_cannon, 4, { y:670 } ).ease(Linear.easeNone);
		Actuate.tween(z_base, 4, { y:680 } ).ease(Linear.easeNone);
		
		cannon.clear();
		Timer.delay(function() { 
			gameStatus = 5; 
			
			/*#if mobile
			if (!unlocked)
			{
				if (currentLevel > 3)
				{
					if (currentLevel > 7) adBlock = false;
					if(!adBlock)
					{
						if (showAd == 0) 
						{
							AdMob.showInterstitial(140);
						}
						else if (showAd == 1 && adColonyAvailable )
						{
							//AdColony.showV4VCAd( ZONE_ID );
							AdColony.showAd( ZONE_ID );
						}
						else 
						{
							AdBuddiz.showAd();
							showAd = -1;
						}
						showAd++;
					}
					adBlock = !adBlock;
				}
			}
			#end*/
		}, 8000);
		isGame = false;
		
		layer.render();
		layerGUI.render();
	}
	
	/*#if mobile 
	public function closeBanner()
	{
		if (!unlocked) AdMob.hideBanner();
	}
	#end*/
	
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
		layerAdd1.removeAllChildren();
		layer.addChild(bg);
		
		lensF.alpha = 0;
		lensF1.alpha = 0;
		
		layer.render();
		
		layerAdd.render();
		layerAdd1.render();
		
		
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
		#if mobile
		so.data.unlocked = unlocked;
		#end
		
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
		
		if (b == null || b.userData.i == null) return;
		
		b.userData.i.landing();
	}
	
	function shellC_shell(cb:InteractionCallback)
	{
		if (cb == null || cb.int1 == null || cb.int2 == null) return;
		
		var s1:Body = cb.int1.castBody;
		var s2:Body = cb.int2.castBody;
		
		if (s1.userData.i == null || s2.userData.i == null) 
		{
			
			if (s1.userData.i != null) s1.userData.i.destruction();
			if (s2.userData.i != null) 
			{
				#if html5 
				if (s2.userData.i != null) 
				#end
				if (Type.getClassName(Type.getClass(s2.userData.i)) == "UfoShell")
				{
					//s2.userData.i.div();
					return;
				}
				s2.userData.i.destruction();
			}
			return;
		}
		#if html5 
		if (s2.userData.i != null) 
		#end
		if (Type.getClassName(Type.getClass(s2.userData.i)) == "UfoShell")
		{
			s1.userData.i.destruction();
			s2.userData.i.div();
		}
		
		#if !flash
		sh_sh_e.emitStart(s1.position.x, s1.position.y, 7);
		if (Math.random() > .6) s_s1.emitStart(s1.position.x, s1.position.y, 4);
		else s_s.emitStart(s1.position.x, s1.position.y, 4);
		#else
		sh_sh_e.emitStart(s1.position.x, s1.position.y, 1);
		if (Math.random() > .6) s_s1.emitStart(s1.position.x, s1.position.y, 1);
		else s_s.emitStart(s1.position.x, s1.position.y, 1);
		#end
		
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
	
	function ricoPlay()
	{
		switch(nextRico)
		{
			case 0: playS(rico0);
			case 1: playS(rico1);
			case 2: playS(rico2);
			case 3: playS(rico3);
			case 4: playS(rico4);
			case 5: playS(rico5);
		}
		nextRico++;
		if (nextRico > 5) nextRico = 0;
	}
	
	function tymPlay()
	{
		switch(nextTym)
		{
			case 0: playS(tym0);
			case 1: playS(tym1);
			case 2: playS(tym2);
			case 3: playS(tym3);
			case 4: playS(tym4);
		}
		nextTym++;
		if (nextTym > 4) nextTym = 0;
	}
	
	function cannon_shell(cb:InteractionCallback)
	{
		if (cb == null || cb.int1 == null || cb.int2 == null) return;
		
		var b:Body = cb.int1.castBody;
		var s:Body = cb.int2.castBody;
		#if html5 
		if (b.userData.i != null) 
		#end
		if (Type.getClassName(Type.getClass(b.userData.i)) == "Soldier")
		{
			shellExplode(s);
			if (b != null && b.userData.i != null) b.userData.i.clear();
		}
		
		#if html5 
		if (b.userData.i != null) 
		#end
		if (Type.getClassName(Type.getClass(b.userData.i)) == "Cannon")
		{
			if (b.userData.i.life <= 0 && s.userData.i != null) 
			{
				s.userData.i.destruction();
				return;
			}
			#if !flash
			Game.game.bomber_e.emitStart(s.position.x, s.position.y, 7);
			#else
			Game.game.bomber_e.emitStart(s.position.x, s.position.y, 1);
			#end
		}
		
		if (s.userData.i == null || b.userData.i == null) 
		{
			
			if (s.userData.i != null) s.userData.i.destruction();
			if (b.userData.i != null) b.userData.i.destruction();
			return;
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
				
				if (Math.random() > .7) tymPlay();
				s.userData.i.clear();
				b.userData.i.destruction();
				s_expl(Std.random(5));
				
				
				#if html5 
				if (b.userData.i != null) 
				#end
				if(Type.getClassName(Type.getClass(b.userData.i)) != "Cannon" && Math.random() > .3) Timer.delay(function()
				{
					ricoPlay();
				}, 300);
			}
			else 
			{
				tymPlay();
				Timer.delay(function()
				{
					ricoPlay();
				}, 70);
				b.userData.i.damage(s.userData.i.damageForce);
				s.userData.i.destruction();
				#if !flash
				s_s.emitStart(s.position.x, s.position.y, 4);
				//#else
				//s_s.emitStart(s.position.x, s.position.y, 1);
				#end
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
		Game.game.explode(s.position.x, s.position.y, layerAdd1, "exp_sh_", 25, .4, Math.random() * Math.PI * 2, 1);
	}
	
	function shield_shell(cb:InteractionCallback)
	{
		var s:Body = cb.int2.castBody;
		if (s == null || s.userData.i == null) return;
		#if html5 
		if (s.userData.i != null) 
		#end
		if (Type.getClassName(Type.getClass(s.userData.i)) == "CannonShell" ||
		Type.getClassName(Type.getClass(s.userData.i)) == "Messile") return;
		s.userData.i.destruction();
		
		s_expl(Std.random(5));
	}
	
	function shellExplode(s:Body)
	{
		var r = Math.round(Math.random() * 3);
		
		#if flash
		if (s.userData.i != null) if (Type.getClassName(Type.getClass(s.userData.i)) != "PartShell" &&
		Type.getClassName(Type.getClass(s.userData.i)) != "RollerShell")
		#end
		switch(r)
		{
			case 0:born(s.position.x, s.position.y - 70);
			case 1:born(s.position.x, s.position.y - 50, .9);
			case 2:born(s.position.x, s.position.y - 50, .8);
			case 3:born(s.position.x, s.position.y - 42, .7);
		}
		s_expl(Std.random(5));
		
		if (s == null || s.userData.i == null) return;
		
		s.userData.i.destruction();
	}
	
	function ground_shell(cb:InteractionCallback)
	{
		shellExplode(cb.int2.castBody);
	}
	
	public function reset()
	{
		upgradesProgress = [1, 0, 0, 0, 0, 0, 0];
		shopItems = [0, 0, 1];
		money = 0;
		currentLevel = 1;
		gpTimer = 0;
		save();
	}
	
	function acceptedChance()
	{
		Timer.delay(function()
		{
			cannon.life = 28;
			cannon.damage(0);
			
			noDamage = true;
			
			while (ridersOnGround.length > 0)
			{
				ridersOnGround.pop().destruction();
			}
			
			for (r in controlledObj)
			{
				if (Type.getClassName(Type.getClass(r)) == "RaiderShip")
				{
					r.destruction();
				}
			}
			
			gameStatus = 2;
			lastChance = false;
		}, 2000);
		
		Timer.delay(function()
		{
			noDamage = false;
		}, 4000);
		
		//closeLastChanceWindow();
		#if mobile
		Heyzap.rewardedVideoAd(0);
		#end
	}
	
	function closeLastChanceWindow()
	{
		Actuate.tween(lastChanceWindow, .4, {scale:.01}).onComplete(function():Dynamic
		{
			
			cannon.damage(1);
			
			layerGUI.removeChild(lastChanceWindow);
			
			return null;
		});
	}
	
	function md(e:MouseEvent)
	{
		var ex = e.stageX / this.scaleX - this.x / this.scaleX;
		var ey = e.stageY / this.scaleY - this.y / this.scaleY;
		
		if (gameStatus == 3)
		{
			if (lastChanceWindow.parent != null)
			{
				if (rectAccept.contains(ex, ey))
				{
					#if mobile
					Heyzap.rewardedVideoAd(1);
					#end
					
					closeLastChanceWindow();
				}
				else if (rectDecline.contains(ex, ey))
				{
					gameStatus = 2;
					lastChance = false;
					closeLastChanceWindow();
				}
			}
			return;
		}
		
		if (gui.noClick || gameStatus == 3 || gameStatus == 4) return;
		
		var setNoClick:Bool = false;
		
		
		if (gameStatus == 2)
		{
			if (currentLevel == 1 && tutorStep == 0)
			{
				
				if (tutorContinue != null && tutorContinue.parent != null && Mut.dist(ex, ey, 500, 300) < 75)
				{
					removeFingers();
					
					gui.setNoClick(2100);
				}
				
				return;
			}
			
			if (!pause)
			{
				if (Mut.dist(ex, ey, 970, 30) < 50)
				{
					gui.setNoClick(1400);
					pause = true;
					gui.pause();
					layerGUI.addChild(gui);
					playS(s_pip);
					
					/*#if mobile
					if (!unlocked) 
					{
						AdMob.showBanner();
					}
					#end*/
				}
			}
			else
			{
				if (Mut.dist(ex, ey, 200, 500) < 84)
				{
					gui.setNoClick(2100);
					gui.endBattleDeactivateE();
					gameStatus = 1;
					isGame = pause = false;
					if (currentLevel == 1) 
					{
						reset();
					}
					playS(s_pip);
					/*#if mobile 
					closeBanner(); 
					#end*/
				}
				else if (Mut.dist(ex, ey, 800, 500) < 84)
				{
					gui.setNoClick(700);
					gui.pauseDeactivate();
					playS(s_pip);
					/*#if mobile 
					closeBanner(); 
					#end*/
				}
				/*else if (Mut.dist(ex, ey, 800, 100) < 100)
				{
					gui.onOffFxClick(true);
					playS(s_pip);
				}
				else if (Mut.dist(ex, ey, 200, 100) < 100)
				{
					gui.onOffMusicClick(true);
					playS(s_pip);
				}*/
			}
			
			
			setNoClick = true;
			return;
		}
		
		if (isGame) return;
		
		
		
		if (gameStatus == 5)
		{
			if (rank != null)
			{
				if (lang == "ru")
				{
					switch(rank)
					{
						case "cth;fyn": rank = "сержант";
						case "ghfgjhobr": rank = "прапорщик";
						case "vkflibb ktbntyfyn": rank = "младший лейтенант";
						case "cnfhibb ktbntyfyn": rank = "старший лейтенант";
						case "rfgbnfy": rank = "капитан";
						case "vfbjh": rank = "майор";
						case "gjlgjkrjdybr": rank = "подполковник";
						case "gjkrjdybr": rank = "полковник";
						case "utythfk vfbjh": rank = "генрал-майор";
					}
				}
				if (Mut.dist(ex, ey, 425, 360) < 35) 
				{
					//if (lang == "ru") Lib.getURL(new URLRequest ("https://www.facebook.com/dialog/feed?app_id=1374861652839164&redirect_uri=http://tabletcrushers.com/megagun/&link=http://tabletcrushers.com/megagun/&description=Мне присвоено звание " + rank));
					//else Lib.getURL(new URLRequest ("https://www.facebook.com/dialog/feed?app_id=1374861652839164&redirect_uri=http://tabletcrushers.com/megagun&link=http://tabletcrushers.com/megagun/&description=I was awarded the rank of " + rank));
					
					Lib.getURL(new URLRequest ("http://tabletcrushers.com/megagun/"));
					
					gui.rankDis();
				}
				else if (Mut.dist(ex, ey, 572, 360) < 35) 
				{
					//if (lang == "ru") Lib.getURL(new URLRequest ("https://twitter.com/intent/tweet?text=Мне присвоено звание " + rank + "&url=http://tabletcrushers.com/megagun/"));
					//else Lib.getURL(new URLRequest ("https://twitter.com/intent/tweet?text=I was awarded the rank of " + rank + "&url=http://tabletcrushers.com/megagun/"));
					
					Lib.getURL(new URLRequest ("http://tabletcrushers.com/megagun/"));
					
					gui.rankDis();
				}
				else if (Mut.dist(ex, ey, 686, 183) < 35) 
				{
					gui.rankDis();
				}
				return;
			}
			
			if (currentLevel > 2)
			{
				if (Mut.dist(ex, ey, 800, 500) < 84)
				{
					gui.setNoClick(1400);
					gui.endBattleDeactivate(false);
					playS(s_pip);
				}
				else if (Mut.dist(ex, ey, 200, 500) < 84)
				{
					gui.setNoClick(1400);
					gui.endBattleDeactivate();
					playS(s_pip);
				}
			}
			else
			{
				if (Mut.dist(ex, ey, 500, 500) < 84)
				{
					gui.setNoClick(1400);
					gui.endBattleDeactivate();
					playS(s_pip);
				}
			}
		}
		else if (gameStatus == 1)
		{
			if (currentLevel > 1)
			{
				if (Mut.dist(ex, ey, 800, 500) < 84)
				{
					gui.setNoClick(1400);
					gui.clickStart();
					playS(s_pip);
				}
				else if (Mut.dist(ex, ey, 200, 500) < 84)
				{
					gui.setNoClick(1400);
					gui.backToShop();
					playS(s_pip);
				}
			}
			else
			{
				if (Mut.dist(ex, ey, 500, 500) < 84)
				{
					gui.setNoClick(1400);
					gui.clickStart();
					playS(s_pip);
				}
			}
		}
		else if (gameStatus == 0)
		{
			
			if (Mut.dist(ex, ey, 800, 500) < 77)
			{
				gui.setNoClick(1400);
				
				if (!gui.confirmation)
				{
					gui.clickReady();
				}
				else gui.clickConfirm();
				
				playS(s_pip);
			}
			else if (Mut.dist(ex, ey, 540, 500) < 84 && !gui.confirmation)
			{
				gui.setNoClick(1400);
				gui.clickNewGame();
				playS(s_pip);
			}
			else if (Mut.dist(ex, ey, 200, 500) < 84 && gui.confirmation)
			{
				gui.setNoClick(1400);
				gui.clickCancel();
				playS(s_pip);
			}
			
			
			if (!gui.confirmation) if (gui.rect_fb.contains(ex, ey)) 
			{
				//if (lang == "ru") Lib.getURL(new URLRequest ("http://www.facebook.com/sharer/sharer.php?u=http://tabletcrushers.com/megagun/"))
				//else Lib.getURL(new URLRequest ("http://www.facebook.com/sharer/sharer.php?u=http://tabletcrushers.com/megagun/"));
				
				
				
				Lib.getURL(new URLRequest ("http://tabletcrushers.com/megagun/"));
				
				
			}
			else if (gui.rect_tw.contains(ex, ey)) 
			{
				//if (lang == "ru") Lib.getURL(new URLRequest ("https://twitter.com/intent/tweet?text=MEGAGUN: защити планету&url=http://tabletcrushers.com/megagun/));
				//else Lib.getURL(new URLRequest ("https://twitter.com/intent/tweet?text=MEGAGUN: defend the planet&url=http://tabletcrushers.com/megagun/"));
				
				
				Lib.getURL(new URLRequest ("http://tabletcrushers.com/megagun/"));
				
				
			}
			//#if mobile
			else if (gui.rect_ia.contains(ex, ey) && gui.iap != null && gui.iap.parent != null) 
			{
				gui.setNoClick(1400);
				//gui.iapClick();
				#if mobile
				Heyzap.rewardedVideoAd(1);
				#end
				
				playS(s_pip);
				
				//onRewardGranted();
			}
			//#end
			else if (gui.rectUpgrade.contains(ex, ey)) { if (checkUpgrades() < 25) { gui.switchSection(0); gui.setNoClick(1400); } else gui.lockU(); playS(s_pip); }
			//else if (gui.rectBuy.contains(ex, ey)) { if (checkUpgrades() > 19) { gui.switchSection(1); gui.setNoClick(1400); } else gui.lock(); playS(s_pip); }
			if (gui.rectBuy.contains(ex, ey)) { if (currentLevel > 1) { gui.switchSection(1); gui.setNoClick(1400); } else gui.lock(); playS(s_pip); }
			else if (gui.rectFx.contains(ex, ey)) {gui.onOffFxClick(); playS(s_pip); gui.setNoClick(400);}
			else switch(gui.currenSection)
			{
				case 0:
					if (gui.rectUpgrade0.contains(ex, ey)) 
					{
						gui.ub0.buy();
						gui.setMoney(); playS(s_pip);
						gui.setNoClick(400);
					}
					else if (gui.rectUpgrade1.contains(ex, ey)) 
					{
						gui.ub1.buy();
						gui.setMoney(); playS(s_pip);
						gui.setNoClick(400);
					}
					else if (gui.rectUpgrade2.contains(ex, ey)) 
					{
						gui.ub2.buy();
						gui.setMoney(); playS(s_pip);
						gui.setNoClick(400);
					}
					else if (gui.rectUpgrade3.contains(ex, ey)) 
					{
						gui.ub3.buy();
						gui.setMoney(); playS(s_pip);
						gui.setNoClick(400);
					}
					else if (gui.rectUpgrade4.contains(ex, ey)) 
					{
						gui.ub4.buy();
						gui.setMoney(); playS(s_pip);
						gui.setNoClick(400);
					}
					
					
				case 1:
						if (gui.rectShop0.contains(ex, ey)) 
						{
							if (gui.bb0 == null) return;
							gui.bb0.buy();
							gui.setMoney(); playS(s_pip);
							gui.setNoClick(400);
						}
						else if (gui.rectShop1.contains(ex, ey)) 
						{
							if (gui.bb1 == null) return;
							gui.bb1.buy();
							gui.setMoney(); playS(s_pip);
							gui.setNoClick(400);
						}
						else if (gui.rectShop2.contains(ex, ey)) 
						{
							if (gui.bb2 == null) return;
							gui.bb2.buy();
							gui.setMoney(); playS(s_pip);
							gui.setNoClick(400);
						}
					
			}
		}
		#if mobile
		else if (gameStatus == 7)
		{
			if (Mut.dist(ex, ey, 800, 500) < 84)
			{
				//startBilling();
				gui.setNoClick(700);
				playS(s_pip);
			}
			else if (Mut.dist(ex, ey, 200, 500) < 84)
			{
				gui.setNoClick(1400);
				gui.clickCancelIap();
				playS(s_pip);
			}
		}
		#end
	}
	
	public function checkUpgrades():UInt
	{
		var num = 0;
		for (i in upgradesProgress) 
		{
			num += i;
		}
		return num;
	}
	
	#if !flash
	function touchBegin(e:TouchEvent)
	{
		//e.preventDefault();
		//e.stopPropagation();
		
		if (gameStatus != 2 || cantFire) return;
		
		var ex = e.stageX / this.scaleX - this.x / this.scaleX;
		var ey = e.stageY / this.scaleY - this.y / this.scaleY;
		
		if (shopItems[0] > 0 && Mut.dist(ex, ey, b0.x, b0.y) < 70) 
		{
			b0Tap();
			return;
		}
		else if (shopItems[1] > 0 && Mut.dist(ex, ey, b1.x, b1.y) < 70) 
		{
			b1Tap();
			return;
		}
		
		if (ex < 400) touchPointX = ex
		else fire = true;
		
	}
	
	function touchEnd(e:TouchEvent)
	{
		//e.preventDefault();
		//e.stopPropagation();
		
		if (gameStatus != 2 || cantFire) return;
		
		var ex = e.stageX / this.scaleX - this.x / this.scaleX;
		
		if (ex < 400) cannon.direction = 0
		else fire = false;
	}
	
	function touchMove(e:TouchEvent)
	{
		//e.preventDefault();
		//e.stopPropagation();
		
		if (gameStatus != 2 || cantFire) return;
		
		var ex = e.stageX / this.scaleX - this.x / this.scaleX;
		var ey = e.stageY / this.scaleY - this.y / this.scaleY;
		
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
	
	function preventDefault(e:MouseEvent)
	{
		//e.preventDefault();
		//e.stopPropagation();
	}
	#end
	
	#if !mobile
	function keyUp(e:KeyboardEvent)
	{
		if (gameStatus != 2  || cantFire) return;
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
		if (gameStatus != 2 || cantFire) return;
		//trace(e.keyCode);
		//trace(cannon.body.rotation);
		switch(e.keyCode)
		{
			case Keyboard.LEFT, 65:
				cannon.direction = -1;
			case Keyboard.RIGHT, 68:
				cannon.direction = 1;
			case Keyboard.SPACE:
				fire = true;
			case 38, 87:
				b1Tap();
			case 40, 83:
				b0Tap();
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
		}
	}
	
	
	
	function enemySetup(body:Body, x:Int, y:Int, vel:Int, fl:TileClip = null)
	{
		enemyBaseSetup(body, x, y);
		
		var gScale = -Math.abs(vel) / vel;
		cast(body.userData.graphic, TileSprite).scaleX = gScale;
		//if(fl != null) fl.rotation = -Math.PI / 2 * gScale;
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
		
		return new RollerShip(body, 130, 200 + Std.random(120), .1, fl);
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
	
	function changeCannon(tp:String)
	{
		var gr:String = tp;
		var g = new TileSprite(Game.game.layer, gr);
		
		g.x = cannon.body.userData.graphic.x;
		g.y = cannon.body.userData.graphic.y;
		graphicUpdate();
		
		var r = cast(cannon.body.userData.graphic, TileSprite).rotation;
		
		layer.removeChild(cannon.body.userData.graphic);
		
		cannon.body.userData.graphic = g;
		cast(cannon.body.userData.graphic, TileSprite).rotation = r;
		
		layer.addChild(cannon.body.userData.graphic);
		layer.render();
	}
	
	function makeCannon()
	{
		if (currentLevel == 1) upgradesProgress = [1, 0, 0, 0, 0, 0, 0];
		
		//playS(attackWarning);
		
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
		
		
		if(currentLevel > 1) layer.addChild(bp);
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
		
		if (cannon.life == 0) 
		{
			destrFog();
			#if !flash
			canDestr.emitStart(cannon.body.position.x, cannon.body.position.y, 5);
			#else
			canDestr.emitStart(cannon.body.position.x, cannon.body.position.y, 1);
			#end
		}
		else Timer.delay(function() { playS(reppeled); }, 5000);
		
		
		layer.removeChild(bp);
	}
	
	function checkWin():Bool
	{
		for (i in controlledObj)
		{
			if (Type.getClassName(Type.getClass(i)) != "Soldier" && 
			Type.getClassName(Type.getClass(i)) != "Cannon" && 
			Type.getClassName(Type.getClass(i)) != "CannonShell" &&
			Type.getClassName(Type.getClass(i)) != "Messile") return false;
		}
		return true;
	}
	
	function upB()
	{
		layerAdd.addChild(upG);
		upG.alpha = 0;
		upG.rotation = 0;
		
		Actuate.tween(upG, .2 + Math.random(), { alpha:1, rotation:4 } ).ease(Linear.easeNone).onComplete(function():Dynamic
		{
			Actuate.tween(upG, 2, { alpha:0, rotation:10 } ).ease(Linear.easeNone).onComplete(function():Dynamic
			{
				layerAdd.removeChild(upG);
				return null;
			});
			return null;
		});
	}
	
	function enemy_manager()
	{
		if (gameStatus != 2) return;
		
		if (currentLevel == 1 && tutorStep < 2)
		{
			if (tutorStep == 0) return;
			
			if (start1.body == null && start2.body == null)
			{
				layer.removeChild(sd);
				sd = null;
				
				tutorStep = 2;
			}
			else return;
		}
		
		if (enemyBornDelay > 0) 
		{ 
			enemyBornDelay--; 
			return; 
		}
		
		var obj = controlledObjPre.shift();
		if (obj == null) 
		{ 
			if (controlledObjPre.length == 0 && checkWin())
			{
				if (currentLevel == 28)
				{
					makeL28();
					return;
				}
				prepareCannonToDeactivate();
				return;
			}
			enemyBornDelay = 60; 
			return; 
		}
		else 
		{
			if (Type.getClassName(Type.getClass(obj)) == "Ready2ride")
			{
				set_ready2rider = obj.value;
				slower = obj.slower;
				return;
			}
			#if cpp
			else if (Type.getClassName(Type.getClass(obj)) == "GcRun")
			{
				Gc.run(true);
				return;
			}
			#end
			
			if (currentLevel == 1 || currentLevel > 8)
			{
				if (Type.getClassName(Type.getClass(obj)) == "EnemyFighter")
				{
					if (currentLevel < 10) {if (enemyBornDelayLim > 50) enemyBornDelayLim = 50;}
					else if (currentLevel < 14) { if (enemyBornDelayLim > 40) enemyBornDelayLim = 40; }
					else if (currentLevel < 18)
					{
						if (currentLevel == 1 || enemyBornDelayLim > 30) enemyBornDelayLim = 30;
					}
					else enemyBornDelayLim = 20;
				}
				else if (enemyBornDelayLim < 70) enemyBornDelayLim = 70;
			}
			obj.init();
		}
		
		enemyBornDelay = enemyBornDelayLim + Std.random(enemyBornDelayLim);
		
		if (currentLevel > 18) 
		{
			enemyBornDelay = Math.round(enemyBornDelay / 1.3);
			if (enemyBornDelay < 44) enemyBornDelay = 44;
		}
		else if (currentLevel > 24) 
		{
			enemyBornDelay = Math.round(enemyBornDelay / 2);
			if (enemyBornDelay < 34) enemyBornDelay = 34;
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
	
	function nextShow()
	{
		if (nextSet == null) nextSetSet();
		layer.addChild(nextSet);
		nextSet.alpha = 0;
		Actuate.tween(nextSet, .7, { alpha:1 } ).onComplete(function():Dynamic
		{
			Timer.delay(function()
			{
				Actuate.tween(nextSet, .7, { alpha:0 } ).onComplete(function():Dynamic
				{
					layer.removeChild(nextSet);
					return null;
				});
			}, 2400);
			return null;
		});
	}
	
	function this_onEnterFrame (event:Event):Void 
	{
		//debug.clear(); debug.draw(space); debug.flush();
		
		
		
		#if mobile
		if (!rewardedVideoIsEnabled)
		{
			if (Heyzap.getRewardedVideoInfo(0)) rewardedVideoIsEnabled = true;
		}
		else if (gameStatus == 3 && cannon.life <= 0 && lastChance && currentLevel > 1 && rewardedVideoIsEnabled)
		{
			if (Heyzap.getRewardedVideoInfo(5) || Heyzap.getRewardedVideoInfo(3) || Heyzap.getRewardedVideoInfo(6))
			{
				acceptedChance();
				
				save();
			}
			
			layerGUI.render();
			return;
		}
		else if (gameStatus == 0 &&  (Heyzap.getRewardedVideoInfo(5) || Heyzap.getRewardedVideoInfo(3) || Heyzap.getRewardedVideoInfo(6)))
		{
			onRewardGranted();
			
			save();
			
			gui.addChild(gui.iapTm);
		}
		#end
		
		if (gameStatus == 0 || gameStatus == 1 || gameStatus == 7)
		{
			if (inited)
			{
				layerGUI.render();
				layerAdd.render();
				layerAdd1.render();
			}
			
			layerGUI.render();
			if (layer != null) layer.render();
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
				if (shopItems[1] != 0) Actuate.tween(b1, .05, { scale:1, alpha:1 } );
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
		
		
		//if (fire && !cantFire) cannon.fire();
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
		
		//#if !flash
		if (space.bodies.length < 14)
		{
			
			if (Math.random() > .99 && lensFB.alpha == 0)
			{
				if (Math.random() > .499999) lensFB = lensF1
				else lensFB = lensF;
				
				Actuate.tween(lensFB, .7 + Math.random(), { alpha:1 } ).ease(Linear.easeNone).onComplete(function():Dynamic
				{
					Actuate.tween(lensFB, 1 + Math.random() * 2, { alpha:0 } ).ease(Linear.easeNone);
					return null;
				});
			}
			
			if (Math.random() > .97 && flare.alpha == 0)
			{
				layerAdd.addChild(flare);
				flare.y = Math.random() * 140 + 70;
				var posTo = flare.y + Math.random() * 140 + 70;
				var time = 2 + Math.random() * 2;
				
				Actuate.tween(flare, time/2, { alpha:1 } ).onComplete(function():Dynamic
				{
					Actuate.tween(flare, time/2, { alpha:0 } );
					return null;
				});
				
				Actuate.tween(flare, time, { y:posTo } ).ease(Linear.easeNone).onComplete(function():Dynamic
				{
					layerAdd.removeChild(flare);
					return null;
				});
			}
			
		}
		//#end
		
		for (i in controlledObj)
		{
			i.run();
		}
		
		if (ready2rider > 0) ready2rider--;
		
		enemy_manager();
		
		if (currentLevel == 1 && start1 != null)
		//if (currentLevel == 1)
		{
			if (start1.body == null && start2.body == null)
			{
				if (money > 800) controlledObjPre = new Array();
				
				gpTimer++;
				if(gpTimer == 140)
				{
					upB();
					playS(upS);
					upgradesProgress[0] = 1;
					upgradesProgress[1] = 2;
					
					
					
					cannonEnergyStepAdd = .017;
					cannon.rotVel = 1.4;
					
					changeCannon("cannon_2");
					cannon.addBrl("cannon_add_1");
					cannon.shCur = sh2;
					
					riderVel = 70;
					eRandomFire = .34;
					
					riderLim = 0;
					
					nextShow();
				}
					
				else if(gpTimer == 350)
				{
					upB();
					playS(upS);
					
					set_ready2rider = 80;
					
					upgradesProgress[0] = 2;
					upgradesProgress[1] = 3;
					
					cannon.rotVel = 1.8;
					cannonEnergyStepAdd = .024;
					cannon.shCur = sh3;
					
					changeCannon("cannon_3");
					cannon.addBrl("cannon_add_2");
					
					riderVel = 90;
					eRandomFire = .44;
					riderLim = 1;
					
					nextShow();
				}
				
				else if(gpTimer == 700)
				{
					upB();
					playS(upS);
					
					set_ready2rider = 50;
					
					upgradesProgress[0] = 3;
					upgradesProgress[1] = 4;
					
					cannon.rotVel = 2.2;
					cannonEnergyStepAdd = .04;
					cannon.shCur = sh4;
					
					changeCannon("cannon_4");
					cannon.addBrl("cannon_add_3");
					
					riderVel = 110;
					eRandomFire = .44;
					riderLim = 1;
					
					nextShow();
				}
				
				else if(gpTimer == 1100)
				{
					upB();
					playS(upS);
					
					upgradesProgress[0] = 4;
					upgradesProgress[1] = 5;
					
					cannon.rotVel = 3;
					cannonEnergyStepAdd = .05;
					cannon.shCur = sh5;
					
					changeCannon("cannon_5");
					cannon.addBrl("cannon_add_4");
					
					riderVel = 120;
					eRandomFire = .5;
					riderLim = 1;
					
					nextShow();
				}
				
				else if(gpTimer == 1400)
				{
					upB();
					playS(upS);
					
					upgradesProgress[0] = 5;
					upgradesProgress[1] = 5;
					
					changeCannon("cannon_5");
					cannon.addBrl("cannon_add_5");
					
					nextShow();
				}
			}
			else if (!rightTapAnimIshown && start1.body != null && start2.body != null && rFinger.parent == null)
			{
				if (ray == null)
				{
					ray = new Ray(cannon.body.position, start1.body.position);
					ray.maxDistance = 4000;
				}
				
				ray.origin = new Vec2(500 + 100 * Math.cos(cannon.body.rotation - Math.PI / 2), 520 + 100 * Math.sin(cannon.body.rotation - Math.PI / 2));
				
				ray.direction = new Vec2(Math.cos(cannon.body.rotation - Math.PI / 2), Math.sin(cannon.body.rotation - Math.PI / 2));
				var rr:RayResult = space.rayCast(ray);
				
				if (rr != null && (rr.shape.body == start1.body || rr.shape.body == start2.body))
				{
					rightTapAnim();
					
					rightTapAnimIshown = true;
					
					cannon.direction = 0;
					cantFire = true;
					fire = false;
				}
			}
		}
		
		//trace(ridersOnGround.length);
		//trace(activeSoldiers);
		//trace(" ");
		
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
		layerAdd1.render();
		if (currentLevel == 1 && tutorStep != 3) 
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
		if(currentLevel > 1) Timer.delay(function() { playS(cdamaged); }, 5000);
	}
	
	function makeEnemies(num:UInt, id:UInt, val:UInt = 0, slw:Bool = false)
	{
		if (id == 14) 
		{
			controlledObjPre.push(new Ready2ride(val, slw));
			return;
		}
		#if cpp
		else if (id == 210)
		{
			controlledObjPre.push(new GcRun());
			return;
		}
		#end
		
		for (i in 0...num)
		{
			var z:Int = 0;
			while (z == 0) z = Math.round( -1 + Math.random() * 2); 
			var velocity = Math.round(280 + Math.random() * 140) * z;
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
				case 2:controlledObjPre.push(makeEnemyFighter(positionX, positionY, 120));
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
	
	function leaveTutor()
	{
		layerGUI.addChild(tutorContinue);
		tutorContinue.x = 500;
		tutorContinue.y = 300;
		tutorContinue.scale = .01;
		Actuate.tween(tutorContinue, .4, {scale:1});
		
		function fadeIn()
		{
			if (tutorContinue == null) return;
			var tar = .0;
			if (tutorContinue.alpha < 1) tar = 1
			else tar = .4;
			Actuate.tween(tutorContinue, .2, { alpha:tar } ).ease(Linear.easeNone).onComplete(function():Dynamic
			{
				fadeIn();
				return null;
			});
		}
		
		tutorContinue.alpha = 0;
		fadeIn();
		
		layerGUI.render();
	}
	
	function removeFingers()
	{
		fire = false;
		
		Actuate.stop(lFinger);
		Actuate.stop(lFingerShadow);
		Actuate.stop(rFinger);
		Actuate.stop(rFingerShadow);
		Actuate.stop(cannon.body);
		
		Actuate.tween(lFinger, 1, {x: -300 - dtFingerX});
		Actuate.tween(lFingerShadow, 1, {x: -300 - dtFingerX});
		Actuate.tween(rFinger, 1, {x: 1300 + dtFingerX});
		Actuate.tween(rFingerShadow, 1, {x: 1300 + dtFingerX});
		Actuate.tween(cannon.body, .4, {rotation:0});
		
		tutorStep = 1;
		start1 = new RaiderShip(new Vec2(242, -40), 200);
		start2 = new RaiderShip(new Vec2(755, -40), 200);
		
		Actuate.tween(tutorContinue, 1, { scale:.01 } ).ease(Quad.easeIn).onComplete(function():Dynamic
		{
			layerGUI.removeAllChildren();
			wall();
			
			cantFire = false;
			
			tutorStep = 1;
			
			var sdName = "sd";
			
			if (lang == "ru") sdName = "sd_ru";
			
			sd = new TileSprite(layer, sdName);
			sd.x = 500;
			sd.y = 220;
			
			sd.alpha = 0;
			layer.addChild(sd);
			Actuate.tween(sd, 1, { alpha:1 } );
			
			layer.addChild(bp);
			
			layer.render();
			layerGUI.render();
			
			return null;
		});
	}
	
	function rightTapAnim()
	{
		rFinger.x = 1280 + dtFingerX;
		rFingerShadow.x = 1280 + dtFingerX;
		
		layerGUI.addChild(rFingerShadow);
		layerGUI.addChild(rFinger);
		
		Actuate.tween(rFinger, 1, {x: 1020 + dtFingerX}).ease(Quad.easeInOut);
		Actuate.tween(rFingerShadow, 1, {x: 998 + dtFingerX}).ease(Quad.easeInOut).onComplete(function()
		{
			Timer.delay(function()
			{
				Actuate.tween(rFinger, .2, {rotation: 0, scaleX: -1, scaleY: 1, x:1000 + dtFingerX}).ease(Quad.easeInOut).onComplete(function()
				{
					Actuate.tween(rFinger, .2, {rotation: .1, scaleX: -1.1, scaleY: 1.1, x:1020 + dtFingerX}).ease(Quad.easeInOut).onComplete(function()
					{
						Timer.delay(function()
						{
							Actuate.tween(rFinger, 1, {x: 1300 + dtFingerX});
							Actuate.tween(rFingerShadow, 1, {x: 1300 + dtFingerX}).onComplete(function()
							{
								cantFire = false;
								layerGUI.removeAllChildren();
								wall();
								
								return null;
							});
						}, 200);
						return null;
					});
					return null;
				});
			}, 400);
			return null;
		});
	}
	
	function leftFingerAnimation()
	{
		if (tutorStep != 0) return;
		
		Actuate.tween(lFinger, .5, {rotation: 0, scale: 1, x: -dtFingerX}).ease(Quad.easeInOut).onComplete(function()
		{
			if (tutorStep != 0) return;
			
			Actuate.tween(cannon.body, 2.4, {rotation: -1.1}).ease(Linear.easeNone);
			
			Actuate.tween(lFinger, 1, {x: -100 - dtFingerX}).ease(Quad.easeInOut);
			Actuate.tween(lFingerShadow, 1, {x: -98 - dtFingerX}).ease(Quad.easeInOut).onComplete(function()
			{
				if (tutorStep != 0) return;
				
				Timer.delay(function()
				{
					if (tutorStep != 0) return;
					
					Actuate.tween(cannon.body, 1.7, {rotation: 0}).ease(Linear.easeNone);
					
					Actuate.tween(lFinger, .5, {x: 0 - dtFingerX}).ease(Quad.easeInOut);
					Actuate.tween(lFingerShadow, .5, {x: 2 - dtFingerX}).ease(Quad.easeInOut).onComplete(function()
					{
						
						if (tutorStep != 0) return;
						
						Timer.delay(function()
						{
							if (tutorStep != 0) return;
							
							Actuate.tween(lFinger, .4, {rotation: -.1, scale: 1.1, x:-20 - dtFingerX}).ease(Quad.easeInOut).onComplete(function()
							{
								
								if (tutorStep != 0) return;
								
								Timer.delay(function()
								{
									if (tutorStep != 0) return;
									
									Actuate.tween(rFinger, .2, {rotation: 0, scaleX: -1, scaleY: 1, x:1000 + dtFingerX}).ease(Quad.easeInOut).onComplete(function()
									{
										if (tutorStep != 0) return;
										
										fire = true;
										
										Timer.delay(function()
										{
											if (tutorStep != 0) return;
											
											Actuate.tween(rFinger, .2, {rotation: .1, scaleX: -1.1, scaleY: 1.1, x:1020 + dtFingerX}).ease(Quad.easeInOut).onComplete(function()
											{
												if (tutorStep != 0) return;
												
												fire = false;
												
												if (tutorStep == 0)
												{
													Timer.delay(function()
													{
														if (tutorStep != 0) return;
														
														leftFingerAnimation();
														
														Timer.delay(function()
														{
															if(tutorContinue.parent == null) leaveTutor();
														}, 1000);
													}, 2000);
												}
											});
										}, 4000);
									});
								}, 1000);
							});
						}, 1000);
					});
				}, 1400);
			});
		});
	}
	
	
	function initFingers()
	{
		
		var dtY:Float = (600 * kY - 600 * this.scaleY) / 2 / this.scaleY;
		dtFingerX = (1000 * kX - 1000 * this.scaleX) / 2 / this.scaleX;
		
		
		lFinger = new TileSprite(layer, "finger");
		lFinger.x = -280 - dtFingerX;
		lFinger.y = 670 + dtY;
		lFingerShadow = new TileSprite(layer, "finger_shadow");
		lFingerShadow.x = -280 - dtFingerX;
		lFingerShadow.y = 675 + dtY;
		
		lFinger.offset = new Point( -70, 140);
		lFingerShadow.offset = new Point( -70, 140);
		lFinger.scale = 1.1;
		lFinger.rotation = -.1;
		
		rFinger = new TileSprite(layer, "finger");
		rFinger.x = 1280 + dtFingerX;
		rFinger.y = 670 + dtY;
		rFingerShadow = new TileSprite(layer, "finger_shadow");
		rFingerShadow.x = 1280 + dtFingerX;
		rFingerShadow.y = 675 + dtY;
		
		rFinger.offset = new Point( -70, 140);
		rFingerShadow.offset = new Point( -70, 140);
		rFinger.scaleX =-1.1;
		rFinger.rotation = .1;
		rFingerShadow.scaleX =-1;
		
		layerGUI.addChild(lFingerShadow);
		layerGUI.addChild(lFinger);
		layerGUI.addChild(rFingerShadow);
		layerGUI.addChild(rFinger);
		
		Actuate.tween(lFinger, 1.4, {x: -20 - dtFingerX}).ease(Quad.easeInOut);
		Actuate.tween(lFingerShadow, 1.4, {x: 2 - dtFingerX}).ease(Quad.easeInOut);
		
		Actuate.tween(rFinger, 1.4, {x: 1020 + dtFingerX}).ease(Quad.easeInOut);
		Actuate.tween(rFingerShadow, 1.4, {x: 998 + dtFingerX}).ease(Quad.easeInOut).onComplete(function()
		{
			Timer.delay(function()
			{
				leftFingerAnimation();
			}, 1200);
		});
		
		layerGUI.render();
	}
	
	function makeL1()
	{
		
		Timer.delay(function()
		{
			initFingers();
		}, 4000);
		
		
		if (lang == "ru") 
		{
			tutorContinue = new TileSprite(layer, "tutorContinue_ru");
		}
		else 
		{
			tutorContinue = new TileSprite(layer, "tutorContinue");
		}
		tutorContinue.x = 500;
		tutorContinue.y = 530 + this.y / this.scaleY;
		
		
		cantFire = true;
		
		gui.setNoClick(2000);
		
		
		layerGUI.render();
		
		set_ready2rider = 2;
		
		riderLim = 1;
		
		makeEnemies(0, 210);
		ePause(2);
		
		makeEnemies(1, 0);
		//makeEnemies(2, 1);
		ePause(2);makeEnemies(0, 210);ePause(1);
		makeEnemies(1, 0);
		ePause(2);
		makeEnemies(1, 0);
		ePause(4);
		makeEnemies(1, 4);
		ePause(2);
		makeEnemies(1, 4);
		ePause(2); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 0);
		ePause(1); makeEnemies(0, 210); ePause(3);
		makeEnemies(2, 0);
		ePause(1);
		makeEnemies(2, 0);
		ePause(1);
		makeEnemies(2, 4);
		ePause(2); makeEnemies(0, 210); ePause(1);
		makeEnemies(7, 0);
		makeEnemies(7, 0);
		makeEnemies(7, 1);
		makeEnemies(2, 0);
		makeEnemies(2, 1);
		makeEnemies(2, 0);
		makeEnemies(2, 1);
		ePause(2); makeEnemies(0, 210); ePause(1);
		makeEnemies(4, 0);
		makeEnemies(2, 1);
		makeEnemies(4, 0);
		makeEnemies(2, 1);
		ePause(2); makeEnemies(0, 210); ePause(1);
		makeEnemies(77, 0);
	}
	function makeL2()
	{
		set_ready2rider = 448;
		eRandomFire = .31;
		riderLim = 1;
		riderVel = 44;
		ridersOffset = 170;
		makeEnemies(0, 210);
		ePause(2);
		
		makeEnemies(50, 0);
	}
	function makeL3()
	{
		set_ready2rider = 400;
		eRandomFire = .32;
		ridersOffset = 80;
		riderVel = 52;
		makeEnemies(0, 210);
		ePause(2);
		
		makeEnemies(21, 0);
		ePause(2);makeEnemies(0, 210);ePause(1);
		makeEnemies(1, 1);
		ePause(2);
		makeEnemies(28, 0);
		ePause(2);makeEnemies(0, 210);ePause(1);
		makeEnemies(2, 1);
	}
	function makeL4()
	{
		set_ready2rider = 320;
		makeEnemies(0, 210);
		ePause(2);
		riderVel = 70;
		eRandomFire = .34;
		ridersOffset = 40;
		makeEnemies(30, 0);
		ePause(2);makeEnemies(0, 210);ePause(1);
		makeEnemies(2, 1);
		ePause(3);
		makeEnemies(24, 0);
		ePause(2);makeEnemies(0, 210);ePause(1);
		makeEnemies(2, 1);
		ePause(3);
		makeEnemies(1, 2);
		ePause(1);
		makeEnemies(1, 2);
		ePause(1);
		makeEnemies(1, 2);
		ePause(1);makeEnemies(0, 210);ePause(1);
		makeEnemies(10, 0);
		ePause(1);makeEnemies(0, 210);ePause(1);
		makeEnemies(1, 2);
		ePause(1);
		makeEnemies(1, 2);
		ePause(1);
	}
	function makeL5()
	{
		makeEnemies(0, 210);
		set_ready2rider = 300;
		riderLim = 2;
		ePause(2);
		riderVel = 77;
		eRandomFire = .4;
		ridersOffset = 40;
		makeEnemies(5, 2);
		makeEnemies(20, 0);
		makeEnemies(1, 14, 110, true);
		makeEnemies(10, 0);
		makeEnemies(1, 14, 240);
		ePause(2);makeEnemies(0, 210);ePause(1);
		makeEnemies(4, 1);
		ePause(3);
		makeEnemies(12, 0);
		makeEnemies(1, 14, 110, true);
		makeEnemies(7, 0);
		makeEnemies(1, 14, 240);
		makeEnemies(14, 0);
		
		makeEnemies(5, 1);
	}
	function makeL6()
	{
		makeEnemies(0, 210);
		set_ready2rider = 270;
		
		ePause(2);
		riderLim = 2;
		
		eRandomFire = .44;
		
		riderVel = 80;
		
		
		makeEnemies(4, 0);
		makeEnemies(1, 14, 110, true);
		makeEnemies(10, 0);
		makeEnemies(1, 14, 240);
		ePause(1);makeEnemies(0, 210);ePause(1);
		makeEnemies(2, 1);
		ePause(2);
		makeEnemies(2, 1);
		ePause(2);makeEnemies(0, 210);ePause(1);
		makeEnemies(22, 0);
		makeEnemies(1, 14, 100, true);
		makeEnemies(18, 0);
		makeEnemies(1, 14, 240);
		ePause(2);makeEnemies(0, 210);ePause(1);
		makeEnemies(5, 1);
		ePause(1);makeEnemies(0, 210);ePause(1);
		makeEnemies(11, 2);
		ePause(2);makeEnemies(0, 210);ePause(1);
		makeEnemies(7, 2);
		ePause(2);makeEnemies(0, 210);ePause(1);
		makeEnemies(2, 3);
	}
	function makeL7()
	{
		makeEnemies(0, 210);
		
		set_ready2rider = 240;
		riderLim = 3;
		riderVel = 85;
		eRandomFire = .55;
		ePause(2);
		makeEnemies(1, 14, 100, true);
		makeEnemies(14, 0);
		makeEnemies(1, 14, 240);
		makeEnemies(7, 0);
		
		ePause(1);makeEnemies(0, 210);
		makeEnemies(4, 2);
		ePause(1);
		makeEnemies(4, 2);
		ePause(1);makeEnemies(0, 210);ePause(1);
		makeEnemies(27, 0);
		makeEnemies(1, 14, 100, true);
		makeEnemies(14, 0);
		makeEnemies(1, 14, 220);
		ePause(1);makeEnemies(0, 210);ePause(1);
		makeEnemies(5, 1);
		ePause(1);makeEnemies(0, 210);ePause(1);
		makeEnemies(2, 1);
		ePause(1);
		makeEnemies(4, 2);
		ePause(2);makeEnemies(0, 210);ePause(1);
		makeEnemies(1, 4);
	}
	function makeL8()
	{
		makeEnemies(0, 210);
		set_ready2rider = 220;
		riderVel = 90;
		eRandomFire = .37;
		ePause(2);
		riderLim = 3;
		makeEnemies(5, 2);
		ePause(1);makeEnemies(0, 210);ePause(1);
		makeEnemies(1, 7);
		ePause(2);
		makeEnemies(2, 1);
		ePause(2);
		makeEnemies(2, 1);
		ePause(1);makeEnemies(0, 210);ePause(1);
		makeEnemies(17, 0);
		makeEnemies(1, 14, 100, true);
		makeEnemies(8, 0);
		makeEnemies(1, 14, 220);
		makeEnemies(17, 0);
		makeEnemies(1, 14, 100, true);
		makeEnemies(8, 0);
		ePause(2);makeEnemies(0, 210);ePause(1);
		makeEnemies(5, 1);
		ePause(1);makeEnemies(0, 210);ePause(1);
		makeEnemies(2, 3);
		ePause(1);makeEnemies(0, 210);ePause(1);
		makeEnemies(2, 4);
	}
	function makeL9()
	{
		makeEnemies(0, 210);
		set_ready2rider = 200;
		
		ePause(2);
		eRandomFire = .37;
		riderVel = 95;
		riderLim = 3;
		makeEnemies(3, 1);
		ePause(2);
		makeEnemies(1, 7);
		ePause(1);makeEnemies(0, 210);ePause(1);
		makeEnemies(4, 1);
		ePause(2);
		makeEnemies(3, 1);
		ePause(2);makeEnemies(0, 210);ePause(1);
		makeEnemies(22, 0);
		makeEnemies(1, 14, 90, true);
		makeEnemies(8, 0);
		makeEnemies(1, 14, 200);
		makeEnemies(18, 0);
		makeEnemies(1, 14, 90, true);
		makeEnemies(8, 0);
		ePause(2);makeEnemies(0, 210);ePause(1);
		makeEnemies(1, 4);
		ePause(4);makeEnemies(0, 210);ePause(1);
		makeEnemies(1, 5);
	}
	
	function makeL10()
	{
		makeEnemies(0, 210);
		
		set_ready2rider = 180;
		ePause(2);
		eRandomFire = .38;
		riderVel = 100;
		riderLim = 3;
		
		makeEnemies(5, 0);
		makeEnemies(2, 2);
		makeEnemies(5, 0);
		makeEnemies(2, 1);
		makeEnemies(1, 14, 90, true);
		makeEnemies(5, 0);
		makeEnemies(1, 2);
		ePause(1); makeEnemies(0, 210);
		makeEnemies(1, 14, 180);
		makeEnemies(8, 0);
		makeEnemies(1, 14, 90, true);
		makeEnemies(7, 0);
		makeEnemies(1, 14, 180);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 7);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 5);
		ePause(8); makeEnemies(0, 210); ePause(1);
		makeEnemies(4, 1);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(4, 2);
		makeEnemies(2, 1);
		makeEnemies(4, 2);
		ePause(2); makeEnemies(0, 210); ePause(1);
		makeEnemies(4, 0);
		makeEnemies(1, 2);
		makeEnemies(3, 0);
		makeEnemies(1, 2);
		makeEnemies(7, 0);
		makeEnemies(1, 2);
		makeEnemies(1, 14, 90, true);
		makeEnemies(7, 0);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 6);
	}
	
	function makeL11()
	{
		makeEnemies(0, 210);
		
		set_ready2rider = 180;
		ePause(2);
		eRandomFire = .38;
		riderVel = 114;
		riderLim = 3;
		
		makeEnemies(20, 0);
		makeEnemies(1, 14, 90, true);
		makeEnemies(14, 0);
		makeEnemies(1, 14, 180);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 7);
		ePause(3); makeEnemies(0, 210); ePause(1);
		makeEnemies(4, 1);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(7, 2);
		ePause(2); makeEnemies(0, 210); ePause(1);
		makeEnemies(10, 0);
		makeEnemies(1, 1);
		makeEnemies(12, 0);
		makeEnemies(1, 14, 90, true);
		makeEnemies(10, 0);
		makeEnemies(1, 14, 140);
		makeEnemies(5, 1);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(2, 3);
		ePause(2); makeEnemies(0, 210); ePause(1);
		makeEnemies(2, 4);
		ePause(4); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 6);
	}
	
	function makeL12()
	{
		makeEnemies(0, 210);
		
		set_ready2rider = 180;
		
		ePause(2);
		
		eRandomFire = .39;
		riderVel = 121;
		riderLim = 7;
		makeEnemies(30, 0);
		makeEnemies(1, 14, 80, true);
		makeEnemies(20, 0);
		makeEnemies(1, 14, 180);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(11, 1);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(3, 4);
		ePause(5); makeEnemies(0, 210); ePause(1);
		makeEnemies(17, 2);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 5);
		ePause(4); makeEnemies(0, 210); ePause(1);
		makeEnemies(4, 3);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(2, 4);
		ePause(4); makeEnemies(0, 210); ePause(1);
		makeEnemies(2, 4);
		ePause(4); makeEnemies(0, 210); ePause(1);
		makeEnemies(3, 7);
		ePause(4); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 6);
	}
	function makeL13()
	{
		makeEnemies(0, 210);
		set_ready2rider = 180;
		
		ePause(2);
		riderVel = 122;
		eRandomFire = .4;
		riderLim = 7;
		makeEnemies(20, 0);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 14, 90, true);
		makeEnemies(14, 0);
		makeEnemies(1, 14, 180);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(14, 1);
		ePause(1); makeEnemies(0, 210);
		makeEnemies(35, 0);
		makeEnemies(1, 14, 90, true);
		makeEnemies(14, 0);
		makeEnemies(1, 14, 180);
		makeEnemies(21, 2);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(3, 7);
		ePause(2); makeEnemies(0, 210); ePause(1);
		makeEnemies(4, 3);
		ePause(2); makeEnemies(0, 210); ePause(1);
		makeEnemies(3, 4);
		ePause(5); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 5);
		ePause(3);
		makeEnemies(1, 5);
	}
	function makeL14()
	{
		makeEnemies(0, 210);
		set_ready2rider = 180;
		riderVel = 135;
		eRandomFire = .45;
		riderLim = 3;
		ePause(2);
		makeEnemies(10, 2);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(2, 1);
		makeEnemies(10, 2);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(14, 0);
		makeEnemies(1, 14, 90, true);
		makeEnemies(14, 0);
		makeEnemies(1, 14, 180);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(12, 1);
		makeEnemies(10, 0);
		makeEnemies(1, 14, 90, true);
		makeEnemies(10, 0);
		ePause(1); makeEnemies(0, 210);
		makeEnemies(8, 2);
		ePause(1); makeEnemies(0, 210);
		makeEnemies(20, 0);
		makeEnemies(8, 2);
		ePause(2); makeEnemies(0, 210); ePause(1);
		makeEnemies(4, 7);
		ePause(4); makeEnemies(0, 210); ePause(1);
		makeEnemies(4, 3);
		ePause(2); makeEnemies(0, 210); ePause(1);
		makeEnemies(3, 4);
		ePause(3); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 6);
		ePause(10); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 5);
		ePause(3); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 5);
	}
	function makeL15()
	{
		makeEnemies(0, 210);
		set_ready2rider = 200;
		ePause(2);
		riderVel = 140;
		eRandomFire = .5;
		riderLim = 3;
		makeEnemies(20, 1);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(30, 0);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(10, 1);
		makeEnemies(10, 0);
		makeEnemies(2, 2);
		makeEnemies(1, 14, 90, true);
		makeEnemies(4, 0);
		makeEnemies(1, 2);
		makeEnemies(7, 0);
		makeEnemies(1, 14, 200);
		makeEnemies(2, 1);
		makeEnemies(10, 0);
		makeEnemies(1, 14, 90, true);
		makeEnemies(3, 0);
		makeEnemies(1, 1);
		makeEnemies(7, 0);
		makeEnemies(1, 14, 180);
		makeEnemies(2, 5);
		ePause(3); makeEnemies(0, 210); ePause(2);
		makeEnemies(4, 3);
		ePause(2); makeEnemies(0, 210); ePause(1);
		makeEnemies(3, 4);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(7, 4);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 5);
		ePause(4); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 6);
	}
	
	function makeL16()
	{
		makeEnemies(0, 210);
		set_ready2rider = 140;
		
		ePause(2);
		riderVel = 142;
		eRandomFire = .5;
		riderLim = 3;
		makeEnemies(10, 2);
		makeEnemies(2, 2);
		makeEnemies(10, 2);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(10, 2);
		makeEnemies(1, 2);
		makeEnemies(10, 2);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(10, 0);
		makeEnemies(1, 14, 80, true);
		makeEnemies(7, 0);
		makeEnemies(1, 1);
		makeEnemies(7, 0);
		makeEnemies(1, 14, 180);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(10, 1);
		makeEnemies(7, 4);
		makeEnemies(8, 4);
		makeEnemies(10, 0);
		makeEnemies(2, 2);
		makeEnemies(10, 0);
		makeEnemies(2, 2);
		makeEnemies(1, 14, 80, true);
		makeEnemies(14, 0);
		makeEnemies(1, 14, 180);
		makeEnemies(2, 1);
		makeEnemies(10, 0);
		makeEnemies(2, 5);
		ePause(6); makeEnemies(0, 210); ePause(1);
		makeEnemies(8, 3);
		ePause(2); makeEnemies(0, 210); ePause(1);
		makeEnemies(5, 4);
		ePause(6); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 6);
		ePause(7); makeEnemies(0, 210); ePause(1);
		makeEnemies(2, 5);
	}
	function makeL17()
	{
		makeEnemies(0, 210);
		set_ready2rider = 120;
		
		ePause(2);
		riderVel = 142;
		eRandomFire = .52;
		riderLim = 4;
		makeEnemies(14, 4);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(30, 1);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 14, 70, true);
		makeEnemies(14, 0);
		makeEnemies(2, 2);
		makeEnemies(7, 0);
		ePause(1); makeEnemies(0, 210);
		makeEnemies(1, 14, 170);
		makeEnemies(2, 1);
		makeEnemies(10, 0);
		makeEnemies(2, 2);
		makeEnemies(10, 0);
		makeEnemies(2, 1);
		makeEnemies(10, 0);
		makeEnemies(2, 5);
		ePause(3); makeEnemies(0, 210); ePause(2);
		makeEnemies(20, 2);
		makeEnemies(14, 3);
		makeEnemies(10, 0);
		ePause(1); makeEnemies(0, 210);
		makeEnemies(1, 14, 70, true);
		makeEnemies(10, 0);
		makeEnemies(1, 14, 170);
		makeEnemies(2, 3);
		makeEnemies(10, 0);
		makeEnemies(2, 3);
		makeEnemies(10, 0);
		makeEnemies(1, 6);
		ePause(5); makeEnemies(0, 210); ePause(1);
		makeEnemies(10, 4);
		ePause(2); makeEnemies(0, 210); ePause(1);
		makeEnemies(3, 4);
		ePause(2); makeEnemies(0, 210); ePause(1);
		makeEnemies(10, 4);
		ePause(5); makeEnemies(0, 210); ePause(1);
		makeEnemies(2, 5);
	}
	function makeL18()
	{
		makeEnemies(0, 210);
		set_ready2rider = 120;
		ePause(2);
		riderVel = 142;
		eRandomFire = .54;
		riderLim = 4;
		makeEnemies(14, 4);
		ePause(1);
		makeEnemies(30, 1);
		makeEnemies(27, 0);
		makeEnemies(1, 14, 70, true);
		makeEnemies(14, 0);
		makeEnemies(2, 2);
		makeEnemies(1, 1);
		makeEnemies(10, 0);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 14, 160);
		makeEnemies(7, 4);
		makeEnemies(2, 5);
		ePause(8); makeEnemies(0, 210); ePause(1);
		makeEnemies(20, 3);
		makeEnemies(14, 4);
		makeEnemies(10, 0);
		makeEnemies(1, 4);
		makeEnemies(10, 0);
		makeEnemies(3, 2);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 14, 80, true);
		makeEnemies(7, 0);
		makeEnemies(1, 2);
		makeEnemies(7, 0);
		makeEnemies(1, 14, 160);
		makeEnemies(1, 4);
		makeEnemies(10, 0);
		makeEnemies(1, 6);
		ePause(7); makeEnemies(0, 210); ePause(1);
		makeEnemies(10, 4);
		ePause(3); makeEnemies(0, 210); ePause(1);
		makeEnemies(10, 4);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(7, 2);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(2, 5);
		ePause(4); makeEnemies(0, 210); ePause(1);
		makeEnemies(4, 7);
		ePause(1);
		makeEnemies(1, 6);
	}
	function makeL19()
	{
		makeEnemies(0, 210);
		set_ready2rider = 100;
		ePause(2);
		riderVel = 142;
		eRandomFire = .55;
		riderLim = 4;
		makeEnemies(14, 3);
		ePause(1); makeEnemies(0, 210);
		makeEnemies(14, 1);
		makeEnemies(4, 2);
		makeEnemies(14, 1);
		ePause(2); makeEnemies(0, 210);
		makeEnemies(10, 0);
		makeEnemies(1, 4);
		makeEnemies(10, 0);
		makeEnemies(3, 2);
		makeEnemies(10, 0);
		makeEnemies(1, 4);
		makeEnemies(10, 0);
		makeEnemies(1, 6);
		ePause(8); makeEnemies(0, 210); ePause(1);
		makeEnemies(14, 3);
		makeEnemies(14, 4);
		makeEnemies(20, 0);
		makeEnemies(4, 2);
		makeEnemies(20, 0);
		ePause(1); makeEnemies(0, 210);
		makeEnemies(1, 6);
		ePause(5); makeEnemies(0, 210); ePause(1);
		makeEnemies(10, 4);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(8, 4);
		ePause(2); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 6);
		ePause(5); makeEnemies(0, 210); ePause(1);
		makeEnemies(2, 5);
	}
	
	function makeL20()
	{
		makeEnemies(0, 210);
		set_ready2rider = 100;
		ePause(2);
		riderVel = 142;
		eRandomFire = .55;
		riderLim = 8;
		makeEnemies(20, 1);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(30, 0);
		makeEnemies(10, 0);
		makeEnemies(1, 4);
		makeEnemies(10, 0);
		makeEnemies(3, 2);
		makeEnemies(10, 0);
		makeEnemies(1, 4);
		makeEnemies(10, 0);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(10, 1);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(11, 4);
		ePause(3); makeEnemies(0, 210); ePause(1);
		makeEnemies(11, 7);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(2, 5);
		ePause(1); makeEnemies(0, 210); ePause(8);
		makeEnemies(14, 3);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(14, 4);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(7, 4);
		ePause(3); makeEnemies(0, 210); ePause(1);
		makeEnemies(2, 6);
		ePause(10); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 5);
	}
	
	function makeL21()
	{
		makeEnemies(0, 210);
		set_ready2rider = 100;
		ePause(2);
		riderVel = 144;
		eRandomFire = .55;
		riderLim = 8;
		makeEnemies(10, 7);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 6);
		ePause(8); makeEnemies(0, 210); ePause(1);
		makeEnemies(20, 3);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(10, 0);
		makeEnemies(3, 2);
		makeEnemies(10, 0);
		makeEnemies(1, 4);
		makeEnemies(10, 0);
		makeEnemies(3, 2);
		makeEnemies(10, 0);
		makeEnemies(1, 4);
		makeEnemies(10, 0);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 6);
		ePause(7); makeEnemies(0, 210); ePause(1);
		makeEnemies(30, 1);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(8, 4);
		ePause(7); makeEnemies(0, 210); ePause(1);
		makeEnemies(11, 2);
		makeEnemies(2, 5);
		ePause(7); makeEnemies(0, 210); ePause(1);
		makeEnemies(40, 2);
		makeEnemies(4, 0);
		makeEnemies(40, 2);
		ePause(2); makeEnemies(0, 210); ePause(1);
		makeEnemies(7, 3);
		ePause(2); makeEnemies(0, 210); ePause(1);
		makeEnemies(4, 4);
		ePause(3); makeEnemies(0, 210); ePause(1);
		makeEnemies(7, 4);
		ePause(5); makeEnemies(0, 210); ePause(1);
		makeEnemies(7, 7);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(2, 6);
	}
	
	function makeL22()
	{
		makeEnemies(0, 210);
		set_ready2rider = 100;
		ePause(2);
		riderVel = 144;
		eRandomFire = .55;
		riderLim = 8;
		
		makeEnemies(1, 6);
		ePause(7); makeEnemies(0, 210); ePause(1);
		makeEnemies(30, 1);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(8, 4);
		ePause(7); makeEnemies(0, 210); ePause(1);
		makeEnemies(14, 2);
		makeEnemies(2, 5);
		ePause(7); makeEnemies(0, 210); ePause(1);
		makeEnemies(10, 7);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 6);
		ePause(8); makeEnemies(0, 210); ePause(1);
		makeEnemies(20, 3);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(10, 0);
		makeEnemies(3, 2);
		makeEnemies(10, 0);
		makeEnemies(1, 4);
		makeEnemies(10, 0);
		makeEnemies(3, 2);
		makeEnemies(10, 0);
		makeEnemies(1, 4);
		makeEnemies(10, 0);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(20, 2);
		makeEnemies(7, 1);
		makeEnemies(20, 2);
		makeEnemies(4, 0);
		makeEnemies(40, 2);
		ePause(2); makeEnemies(0, 210); ePause(1);
		makeEnemies(7, 3);
		ePause(2); makeEnemies(0, 210); ePause(1);
		makeEnemies(4, 4);
		ePause(3); makeEnemies(0, 210); ePause(1);
		makeEnemies(7, 4);
		ePause(5); makeEnemies(0, 210); ePause(1);
		makeEnemies(7, 7);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(2, 6);
		ePause(7); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 5);
	}
	
	function makeL23()
	{
		makeEnemies(0, 210);
		set_ready2rider = 90;
		ePause(2);
		riderVel = 144;
		eRandomFire = .55;
		riderLim = 8;
		
		makeEnemies(2, 5);
		ePause(7); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 6);
		ePause(7); makeEnemies(0, 210); ePause(1);
		makeEnemies(30, 1);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(8, 4);
		ePause(7); makeEnemies(0, 210); ePause(1);
		makeEnemies(11, 1);
		makeEnemies(2, 5);
		ePause(7); makeEnemies(0, 210); ePause(1);
		makeEnemies(10, 7);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 6);
		ePause(8); makeEnemies(0, 210); ePause(1);
		makeEnemies(20, 3);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(10, 0);
		makeEnemies(7, 2);
		makeEnemies(10, 0);
		makeEnemies(7, 4);
		ePause(5); makeEnemies(0, 210); ePause(1);
		makeEnemies(7, 7);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 4);
		makeEnemies(10, 0);
		makeEnemies(3, 2);
		makeEnemies(10, 0);
		makeEnemies(1, 4);
		makeEnemies(10, 0);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(20, 2);
		makeEnemies(7, 1);
		makeEnemies(20, 2);
		makeEnemies(4, 0);
		makeEnemies(40, 2);
		ePause(2); makeEnemies(0, 210); ePause(1);
		makeEnemies(7, 3);
		ePause(2); makeEnemies(0, 210); ePause(1);
		makeEnemies(4, 4);
		ePause(3); makeEnemies(0, 210); ePause(1);
		makeEnemies(2, 5);
		ePause(7); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 6);
		ePause(4); makeEnemies(0, 210); ePause(1);
		makeEnemies(20, 4);
	}
	
	function makeL24()
	{
		makeEnemies(0, 210);
		set_ready2rider = 90;
		ePause(2);
		riderVel = 149;
		eRandomFire = .55;
		riderLim = 8;
		
		makeEnemies(10, 0);
		makeEnemies(7, 2);
		makeEnemies(10, 0);
		makeEnemies(7, 4);
		ePause(4); makeEnemies(0, 210); ePause(1);
		makeEnemies(2, 5);
		ePause(5); makeEnemies(0, 210); ePause(1);
		makeEnemies(10, 0);
		makeEnemies(7, 2);
		makeEnemies(2, 7);
		makeEnemies(10, 0);
		ePause(2); makeEnemies(0, 210); ePause(1);
		makeEnemies(30, 1);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(8, 4);
		ePause(4); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 6);
		ePause(5); makeEnemies(0, 210); ePause(1);
		makeEnemies(11, 1);
		makeEnemies(2, 5);
		ePause(7); makeEnemies(0, 210); ePause(1);
		makeEnemies(10, 7);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 6);
		ePause(8); makeEnemies(0, 210); ePause(1);
		makeEnemies(20, 3);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(10, 0);
		makeEnemies(7, 2);
		makeEnemies(10, 0);
		makeEnemies(7, 4);
		ePause(5); makeEnemies(0, 210); ePause(1);
		makeEnemies(7, 7);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 4);
		makeEnemies(10, 0);
		makeEnemies(3, 2);
		makeEnemies(10, 0);
		makeEnemies(1, 4);
		makeEnemies(10, 0);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(20, 2);
		makeEnemies(7, 1);
		makeEnemies(20, 2);
		makeEnemies(4, 0);
		makeEnemies(40, 2);
		ePause(2); makeEnemies(0, 210); ePause(1);
		makeEnemies(7, 3);
		ePause(2); makeEnemies(0, 210); ePause(1);
		makeEnemies(4, 4);
		ePause(3); makeEnemies(0, 210); ePause(1);
		makeEnemies(2, 5);
		ePause(7); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 5);
		ePause(2); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 5);
		ePause(2); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 5);
		ePause(2); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 5);
		ePause(2); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 5);
	}
	
	function makeL25()
	{
		makeEnemies(0, 210);
		set_ready2rider = 90;
		ePause(2);
		riderVel = 149;
		eRandomFire = .55;
		riderLim = 8;
		
		makeEnemies(10, 7);
		makeEnemies(7, 2);
		makeEnemies(10, 0);
		makeEnemies(7, 4);
		ePause(4); makeEnemies(0, 210); 
		ePause(1);
		makeEnemies(1, 6);
		ePause(5); makeEnemies(0, 210); 
		ePause(1);
		makeEnemies(11, 1);
		makeEnemies(2, 5);
		ePause(7); makeEnemies(0, 210); 
		ePause(1);
		makeEnemies(10, 7);
		ePause(1); makeEnemies(0, 210); 
		ePause(1);
		makeEnemies(1, 6);
		ePause(8); makeEnemies(0, 210); 
		ePause(1);
		makeEnemies(20, 3);
		ePause(1); makeEnemies(0, 210); 
		ePause(1);
		makeEnemies(10, 0);
		makeEnemies(7, 2);
		makeEnemies(2, 5);
		ePause(5); makeEnemies(0, 210); 
		ePause(1);
		makeEnemies(10, 0);
		makeEnemies(7, 2);
		makeEnemies(2, 7);
		makeEnemies(10, 0);
		ePause(2); makeEnemies(0, 210); 
		ePause(1);
		makeEnemies(30, 1);
		ePause(1); makeEnemies(0, 210); 
		ePause(1);
		makeEnemies(8, 4);
		ePause(2); makeEnemies(0, 210); 
		ePause(1);
		makeEnemies(10, 0);
		makeEnemies(7, 4);
		makeEnemies(2, 7);
		makeEnemies(10, 0);
		ePause(1); makeEnemies(0, 210); 
		ePause(1);
		makeEnemies(7, 7);
		ePause(1); makeEnemies(0, 210); 
		ePause(1);
		makeEnemies(1, 4);
		makeEnemies(10, 0);
		makeEnemies(3, 2);
		makeEnemies(10, 0);
		makeEnemies(1, 4);
		makeEnemies(10, 0);
		ePause(1); makeEnemies(0, 210); 
		ePause(1);
		makeEnemies(20, 2);
		makeEnemies(7, 1);
		makeEnemies(20, 2);
		makeEnemies(4, 0);
		makeEnemies(20, 2);
		makeEnemies(4, 7);
		makeEnemies(20, 2);
		ePause(2); makeEnemies(0, 210);
		ePause(1);
		makeEnemies(7, 3);
		ePause(2); makeEnemies(0, 210);
		ePause(1);
		makeEnemies(4, 4);
		ePause(2);makeEnemies(0, 210);
		ePause(1);
		makeEnemies(4, 7);
		ePause(1); makeEnemies(0, 210);
		ePause(1);
		makeEnemies(1, 6);
		ePause(4); makeEnemies(0, 210); 
		ePause(1);
		makeEnemies(1, 6);
		ePause(4); makeEnemies(0, 210); 
		ePause(1);
		makeEnemies(1, 5);
		ePause(2); makeEnemies(0, 210);
		ePause(1);
		makeEnemies(1, 6);
		ePause(3); makeEnemies(0, 210); 
		ePause(1);
		makeEnemies(1, 6);
		ePause(3); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 6);
	}
	
	function makeL26()
	{
		makeEnemies(0, 210);
		set_ready2rider = 80;
		ePause(2);
		riderVel = 149;
		eRandomFire = .6;
		riderLim = 8;
		
		makeEnemies(1, 5);
		ePause(2); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 6);
		ePause(3); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 6);
		ePause(3); makeEnemies(0, 210); ePause(1);
		
		makeEnemies(10, 0);
		makeEnemies(10, 7);
		makeEnemies(7, 2);
		makeEnemies(10, 0);
		makeEnemies(7, 4);
		ePause(2); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 5);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(7, 1);
		makeEnemies(1, 6);
		ePause(4); makeEnemies(0, 210); ePause(1);
		makeEnemies(10, 2);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 6);
		ePause(8); makeEnemies(0, 210); ePause(1);
		makeEnemies(20, 3);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(10, 0);
		makeEnemies(7, 1);
		makeEnemies(2, 5);
		ePause(4); makeEnemies(0, 210); ePause(1);
		makeEnemies(10, 0);
		makeEnemies(7, 2);
		makeEnemies(2, 7);
		makeEnemies(10, 0);
		ePause(2); makeEnemies(0, 210); ePause(1);
		makeEnemies(30, 1);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(8, 4);
		ePause(2); makeEnemies(0, 210); ePause(1);
		makeEnemies(10, 0);
		makeEnemies(7, 4);
		makeEnemies(2, 7);
		makeEnemies(10, 0);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(7, 7);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 4);
		makeEnemies(10, 0);
		makeEnemies(3, 2);
		makeEnemies(10, 0);
		makeEnemies(1, 4);
		makeEnemies(10, 0);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(20, 2);
		makeEnemies(7, 1);
		makeEnemies(20, 2);
		makeEnemies(4, 0);
		makeEnemies(20, 2);
		makeEnemies(4, 7);
		makeEnemies(20, 2);
		ePause(2); makeEnemies(0, 210); ePause(1);
		makeEnemies(7, 3);
		ePause(2); makeEnemies(0, 210); ePause(1);
		makeEnemies(4, 4);
		ePause(2); makeEnemies(0, 210); ePause(1);
		makeEnemies(4, 7);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 6);
		ePause(4); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 6);
		ePause(4); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 6);
		ePause(4); makeEnemies(0, 210); ePause(1);
		makeEnemies(10, 0);
		makeEnemies(10, 7);
		makeEnemies(7, 2);
		makeEnemies(10, 0);
		makeEnemies(7, 4);
		ePause(2); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 5);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(7, 1);
		makeEnemies(1, 6);
		makeEnemies(7, 7);
		makeEnemies(21, 0);
		makeEnemies(7, 2);
		makeEnemies(7, 0);
		makeEnemies(1, 6);
	}
	
	function makeL27()
	{
		makeEnemies(0, 210);
		set_ready2rider = 80;
		ePause(2);
		riderVel = 150;
		eRandomFire = .7;
		riderLim = 8;
		
		makeEnemies(7, 3);
		ePause(2); makeEnemies(0, 210); ePause(1);
		makeEnemies(4, 4);
		ePause(2); makeEnemies(0, 210); ePause(1);
		makeEnemies(4, 7);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 6);
		ePause(4); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 6);
		ePause(4); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 6);
		ePause(4); makeEnemies(0, 210); ePause(1);
		makeEnemies(10, 0);
		makeEnemies(10, 7);
		makeEnemies(7, 2);
		makeEnemies(10, 0);
		makeEnemies(7, 4);
		ePause(2); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 5);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(7, 1);
		makeEnemies(1, 6);
		makeEnemies(7, 7);
		makeEnemies(21, 0);
		makeEnemies(7, 2);
		makeEnemies(7, 0);
		makeEnemies(1, 6);
		
		makeEnemies(1, 5);
		ePause(2); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 6);
		ePause(3); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 6);
		ePause(3); makeEnemies(0, 210); ePause(1);
		
		makeEnemies(10, 0);
		makeEnemies(10, 7);
		makeEnemies(7, 2);
		makeEnemies(10, 0);
		makeEnemies(7, 4);
		ePause(2); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 5);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(7, 1);
		makeEnemies(1, 6);
		ePause(4); makeEnemies(0, 210); ePause(1);
		makeEnemies(10, 2);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 6);
		ePause(8); makeEnemies(0, 210); ePause(1);
		makeEnemies(20, 3);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(10, 0);
		makeEnemies(7, 1);
		makeEnemies(2, 5);
		ePause(4); makeEnemies(0, 210); ePause(1);
		makeEnemies(10, 0);
		makeEnemies(7, 2);
		makeEnemies(2, 7);
		makeEnemies(10, 0);
		ePause(2); makeEnemies(0, 210); ePause(1);
		makeEnemies(30, 1);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(8, 4);
		ePause(2); makeEnemies(0, 210); ePause(1);
		makeEnemies(10, 0);
		makeEnemies(7, 4);
		makeEnemies(2, 7);
		makeEnemies(10, 0);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(7, 7);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 4);
		makeEnemies(10, 0);
		makeEnemies(3, 2);
		makeEnemies(10, 0);
		makeEnemies(1, 4);
		makeEnemies(10, 0);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(20, 2);
		makeEnemies(7, 1);
		makeEnemies(20, 2);
		makeEnemies(4, 0);
		makeEnemies(20, 2);
		makeEnemies(4, 7);
		makeEnemies(20, 2);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(4, 7);
		makeEnemies(4, 0);
		makeEnemies(2, 2);
		makeEnemies(7, 0);
		makeEnemies(1, 7);
		makeEnemies(4, 0);
		makeEnemies(4, 1);
		makeEnemies(4, 0);
		makeEnemies(2, 6);
		makeEnemies(1, 5);
	}
	
	function makeL28()
	{
		makeEnemies(0, 210);
		set_ready2rider = 70;
		ePause(2);
		riderVel = 160;
		eRandomFire = 1;
		riderLim = 8;
		
		makeEnemies(1, 5);
		ePause(2); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 6);
		ePause(3); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 6);
		ePause(2); makeEnemies(0, 210); ePause(1);
		
		makeEnemies(10, 0);
		makeEnemies(10, 7);
		makeEnemies(7, 2);
		makeEnemies(10, 0);
		makeEnemies(7, 4);
		ePause(2); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 5);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(7, 1);
		makeEnemies(1, 6);
		ePause(4); makeEnemies(0, 210); ePause(1);
		makeEnemies(10, 2);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 6);
		ePause(8); makeEnemies(0, 210); ePause(1);
		makeEnemies(20, 3);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(10, 0);
		makeEnemies(7, 1);
		makeEnemies(2, 5);
		ePause(4); makeEnemies(0, 210); ePause(1);
		makeEnemies(10, 0);
		makeEnemies(7, 2);
		makeEnemies(2, 7);
		makeEnemies(10, 0);
		ePause(2); makeEnemies(0, 210); ePause(1);
		makeEnemies(30, 1);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(8, 4);
		ePause(2); makeEnemies(0, 210); ePause(1);
		makeEnemies(10, 0);
		makeEnemies(7, 4);
		makeEnemies(2, 7);
		makeEnemies(10, 0);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(7, 7);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 4);
		makeEnemies(10, 0);
		makeEnemies(3, 2);
		makeEnemies(10, 0);
		makeEnemies(1, 4);
		makeEnemies(10, 0);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(20, 2);
		makeEnemies(7, 1);
		makeEnemies(20, 2);
		makeEnemies(4, 0);
		makeEnemies(20, 2);
		makeEnemies(4, 7);
		makeEnemies(20, 2);
		ePause(2); makeEnemies(0, 210); ePause(1);
		makeEnemies(7, 3);
		ePause(2); makeEnemies(0, 210); ePause(1);
		makeEnemies(4, 4);
		ePause(2); makeEnemies(0, 210); ePause(1);
		makeEnemies(4, 7);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 6);
		ePause(4); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 6);
		ePause(4); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 6);
		ePause(4); makeEnemies(0, 210); ePause(1);
		makeEnemies(10, 0);
		makeEnemies(10, 7);
		makeEnemies(7, 2);
		makeEnemies(10, 0);
		makeEnemies(7, 4);
		ePause(2); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 5);
		ePause(1); makeEnemies(0, 210); ePause(1);
		makeEnemies(7, 1);
		makeEnemies(1, 6);
		makeEnemies(7, 7);
		makeEnemies(21, 0);
		makeEnemies(7, 2);
		makeEnemies(7, 0);
		makeEnemies(1, 6);
		makeEnemies(1, 5);
		ePause(2); makeEnemies(0, 210); ePause(1);
		makeEnemies(1, 6);
		ePause(3);
		makeEnemies(1, 6);
		ePause(3);
		makeEnemies(1, 6);
		ePause(3);
		makeEnemies(2, 5);
		ePause(3);
		makeEnemies(2, 5);
	}
}