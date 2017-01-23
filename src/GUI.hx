package;
import aze.display.TileClip;
import aze.display.TileGroup;
import aze.display.TileSprite;
import haxe.Timer;
import motion.Actuate;
import nape.geom.Vec2;
import openfl.geom.Rectangle;
import motion.easing.Elastic;
import motion.easing.Cubic;

class GUI extends TileGroup
{
	
	var s20:TileSprite;
	var cn = new TileSprite(Game.game.layerGUI, "cn");
	
	var share_fb:TileSprite = new TileSprite(Game.game.layerGUI, "share_fb");
	var share_tw:TileSprite = new TileSprite(Game.game.layerGUI, "share_tw");
	
	//#if mobile
	public var iap:IAPB;
	public var iapTm:Fnt;
	//#end
	
	var rank:TileSprite;
	var rankS:Fnt;
	
	public var rect_fb:Rectangle;
	public var rect_tw:Rectangle;
	public var rect_ia:Rectangle;
	
	var luA:Bool = true;
	
	var goNext:Fnt;
	var goShop:Fnt;
	var goNextRings:TechnoRings;
	var goShopRings:TechnoRings;
	var goMessage:Fnt;
	
	var goNewRing:TechnoRings;
	var goReset:Fnt;
	
	var but0:Fnt;
	var but1:Fnt;
	
	//var onOffMusic:Fnt;
	var onOffFx:Fnt;
	
	var money:Fnt;
	var f_ready:Fnt;
	
	var upgradeRingBig:TechnoRings;
	var upgradeRing:TechnoRings;
	
	public var ub0:UpgradeButton;
	public var ub1:UpgradeButton;
	public var ub2:UpgradeButton;
	public var ub3:UpgradeButton;
	public var ub4:UpgradeButton;
	
	public var bb0:BuyButton;
	public var bb1:BuyButton;
	public var bb2:BuyButton;
	
	var line:TileSprite;
	var marker:TileSprite;
	
	public var rectUpgrade:Rectangle;
	public var rectBuy:Rectangle;
	
	public var rectMusic:Rectangle;
	public var rectFx:Rectangle;
	
	public var rectUpgrade0:Rectangle;
	public var rectUpgrade1:Rectangle;
	public var rectUpgrade2:Rectangle;
	public var rectUpgrade3:Rectangle;
	public var rectUpgrade4:Rectangle;
	
	public var rectShop0:Rectangle;
	public var rectShop1:Rectangle;
	public var rectShop2:Rectangle;
	public var rectShop3:Rectangle;
	
	public var noClick:Bool;
	public var confirmation:Bool;
	
	public var currenSection:UInt;
	
	var blackout:TileSprite;
	var blackout1:TileSprite;
	
	var endBattleFirstTimeAppearence:Bool;
	
	public function clear()
	{
		goNext = null;
		goShop = null;
		goNextRings = null;
		goShopRings = null;
		goMessage = null;
		
		goNewRing = null;
		goReset = null;
		
		but0 = null;
		but1 = null;
		
		onOffFx = null;
		
		money = null;
		f_ready = null;
		
		upgradeRingBig = null;
		upgradeRing = null;
		
		ub0 = null;
		ub1 = null;
		ub2 = null;
		ub3 = null;
		ub4 = null;
		
		bb0 = null;
		bb1 = null;
		bb2 = null;
		
		line = null;
		marker = null;
		
		removeAllChildren();
		
		if (parent != null) parent.removeChild(this);
	}
	
	
	public function setNoClick(tm:UInt = 1500)
	{
		noClick = true;
		Timer.delay(function() { noClick = false; }, tm);
	}
	
	function markerMover(x:UInt)
	{
		Actuate.tween(marker, 1, { x:x } );
	}
	
	
	
	public function onOffFxClick(p:Bool=false)
	{
		Game.game.musicFlag = !Game.game.musicFlag;
		Game.game.musicOnOff();
		onOffFx.deactivate();
		var pos:Int = 820;
		if (Game.game.lang == "ru") pos = 800;
		var pos1:Int = 820;
		if (Game.game.lang == "ru") pos1 = 780;
		var str = "sound off";
		if (Game.game.lang == "ru") str = "dsrk.xbnm pder";
		if (Game.game.fxFlag) 
		{
			if (Game.game.lang == "ru") str = "drk.xbnm pder"
			else str = "sound on";
		}
		Game.game.fxFlag = !Game.game.fxFlag;
		Timer.delay(function()
		{
			if (!p) onOffFx = new Fnt(pos, 34, str, Game.game.layerGUI, 1, .7, true)
			else onOffFx = new Fnt(pos1, 100, str, Game.game.layerGUI, 1, .7, true);
			addChild(onOffFx);
		},300);
	}
	
	public function pauseDeactivate()
	{
		goNext.deactivate();
		goShop.deactivate();
		goMessage.deactivate();
		goNextRings.deactivate();
		goShopRings.deactivate();
		
		Actuate.tween(blackout, .4, { alpha:0 } ).onComplete(function():Dynamic
		{
			clear();
			Game.game.pause = false;
			return null;
		});
	}
	
	public function pause()
	{
		addChild(blackout);
		blackout.alpha = 0;
		Actuate.tween(blackout, 3, { alpha:.8 } );
		
		var message = "pause";
		if (Game.game.lang == "ru") message = "gfepf";
		goNextRings = new TechnoRings(800, 500, 1, .5);
		goShopRings = new TechnoRings(200, 500, 1, .5);
		
		goMessage = new Fnt(500, 300, message, Game.game.layerGUI, 1, 1, true);
		if (Game.game.lang == "ru") goNext = new Fnt(800, 500, "buhfnm", Game.game.layerGUI, 0, .7, true)
		else goNext = new Fnt(800, 500, "resume", Game.game.layerGUI, 0, .7, true);
		if (Game.game.lang == "ru") goShop = new Fnt(200, 500, "yf ,fpe", Game.game.layerGUI, 0, .7, true)
		else goShop = new Fnt(200, 500, "go to base", Game.game.layerGUI, 0, .7, true);
		
		addChild(goNextRings);
		addChild(goShopRings);
		addChild(goNext);
		addChild(goShop);
		addChild(goMessage);
	}
	
	public function addIapB()
	{
		if (iap == null)
		{
			iap = new IAPB();
			iap.x = 200;
		}
		
		if (iap.parent == null)
		{
			addChild(iap);
			iap.y = 644 + Game.game.y / Game.game.scaleY;
			Actuate.tween(iap, 2, { y:556 } ).ease(Elastic.easeOut);
			
			iap.initTimer();
		}
	}
	
	function socialButAppear()
	{
		share_fb.x = -280;
		if(share_fb.parent == null) Game.game.layerGUI.addChild(share_fb);
		Actuate.tween(share_fb, 1, { x:34 } ).ease(Elastic.easeOut);
		
		share_tw.x = -280;
		if(share_tw.parent == null) Game.game.layerGUI.addChild(share_tw);
		Actuate.tween(share_tw, 2, { x:34 } ).ease(Elastic.easeOut);
		
		//#if mobile
		//if (EnhanceOpenFLExtension.isRewardedAdReady ())
		if (Game.game.rewardedVideoIsEnabled)
		{
			if (Game.game.rewardCounter > 2)
			{
				addChild(iapTm);
				return;
			}
			
			addIapB();
		}
		else if (iap != null)
		{
			if (iap.parent != null) removeChild(iap);
		}
		//#end
	}
	
	function buyAppear()
	{
		function c():Bool
		{
			if (currenSection != 1 || Game.game.gameStatus != 0) return true;
			return false;
		}
		
		Timer.delay(function() 
		{
			if (c()) return;
			
			var a0 = 0;
			var a1 = 0;
			var a2 = 1;
			
			if(Game.game.checkUpgrades() > 18)
			{
				a0 = 7;
				a1 = 7;
				a2 = 7;
			}
			else if(Game.game.checkUpgrades() > 16)
			{
				a0 = 4;
				a1 = 4;
				a2 = 2;
			}
			else if(Game.game.checkUpgrades() > 14)
			{
				a0 = 3;
				a1 = 3;
				a2 = 1;
			}
			else if(Game.game.checkUpgrades() > 12)
			{
				a0 = 2;
				a1 = 2;
				a2 = 1;
			}
			else if(Game.game.checkUpgrades() > 10)
			{
				a0 = 2;
				a1 = 1;
				a2 = 1;
			}
			else if(Game.game.checkUpgrades() > 7)
			{
				a0 = 1;
				a1 = 1;
				a2 = 1;
			}
			else if(Game.game.checkUpgrades() > 3)
			{
				a0 = 1;
				a1 = 0;
				a2 = 1;
			}
			
			socialButAppear();
			
			var powS:String = "power shield";
			var homM:String = "homing missile";
			var infM:String = "infantryman";
			
			if (Game.game.lang == "ru")
			{
				powS = "cbkjdjb obn";
				homM = "hfrtnf";
				infM = "gt[jnbytw";
			}
			
			
			bb0 = new BuyButton(210, 140 + 10, powS, "btb0", 5, a0); addChild(bb0);
			Timer.delay(function() { if (c()) return; bb1 = new BuyButton(210, 250 + 10, homM, "btb1", 5, a1); addChild(bb1); }, 200);
			Timer.delay(function() { if (c()) return; bb2 = new BuyButton(210, 360 + 10, infM, "btb2", 5, a2); addChild(bb2); }, 400);
		}, 1200);
		
		if (Game.game.lang == "ru") markerMover(320)
		else markerMover(300);
	}
	
	function upgradeAppear()
	{
		if (Game.game.checkUpgrades() > 24)
		{
			buyAppear();
			currenSection = 1;
			Timer.delay(function() {
				but0.alphaChanger();
				but1.alphaChanger(1);
			},1000);
			return;
		}
		
		function c():Bool
		{
			if (currenSection != 0 || Game.game.gameStatus != 0) return true;
			return false;
		}
		
		addChild(cn);
		cn.x = 250;
		cn.y = 260;
		cn.alpha = 0;
		Actuate.tween(cn, 3, { alpha:1 } ); 
		
		Timer.delay(function() 
		{
			socialButAppear();
			
			
			if (c()) return; 
			if (Game.game.lang == "ru")
			{
				ub0 = new UpgradeButton(430, 130 + 10, "jcyjdyjb cndjk", 0); addChild(ub0);
				Timer.delay(function() { if (c()) return; ub1 = new UpgradeButton(430, 190 + 10, ",jrjdst cndjks", 1); addChild(ub1); }, 100);
				Timer.delay(function() { if (c()) return; ub2 = new UpgradeButton(430, 250 + 10, "dhtvz gthtpfhzlrb", 2); addChild(ub2); }, 200);
				Timer.delay(function() { if (c()) return; ub3 = new UpgradeButton(430, 310 + 10, "ghjxyjcnm ,hjyb", 3); addChild(ub3); }, 400);
				Timer.delay(function() { if (c()) return; ub4 = new UpgradeButton(430, 370 + 10, "crjhjcnm hjnjhf", 4); addChild(ub4); }, 500);
			}
			else
			{
				ub0 = new UpgradeButton(430, 130 + 10, "staple gun", 0); addChild(ub0);
				Timer.delay(function() { if (c()) return; ub1 = new UpgradeButton(430, 190 + 10, "additional guns", 1); addChild(ub1); }, 100);
				Timer.delay(function() { if (c()) return; ub2 = new UpgradeButton(430, 250 + 10, "recharge time", 2); addChild(ub2); }, 200);
				Timer.delay(function() { if (c()) return; ub3 = new UpgradeButton(430, 310 + 10, "armor strength", 3); addChild(ub3); }, 400);
				Timer.delay(function() { if (c()) return; ub4 = new UpgradeButton(430, 370 + 10, "rotor velocity", 4); addChild(ub4); }, 500);
			}
		}, 700);
		
		if (Game.game.lang == "ru") markerMover(180)
		else markerMover(144);
		
		
		
	}
	
	function socialButD()
	{
		Actuate.tween(share_fb, .4, { x: -280 } ).ease(Cubic.easeOut);
		Actuate.tween(share_tw, .8, { x: -280 } ).ease(Cubic.easeOut);
		#if mobile
		if (iap.visible)
		{
			Actuate.tween(iap, .8, { y: 644 + Game.game.y / Game.game.scaleY} ).ease(Cubic.easeOut);
		}
		#end
	}
	
	function upgradeDeactivate()
	{
		if(ub0 != null) ub0.deactivate();
		Timer.delay(function() { if (ub1 == null) return; ub1.deactivate(); }, 200);
		Timer.delay(function() { if (ub2 == null) return; ub2.deactivate(); }, 400);
		Timer.delay(function() { if (ub3 == null) return; ub3.deactivate(); }, 600);
		Timer.delay(function() { if (ub4 == null) return; ub4.deactivate(); }, 800);
		
		addChild(cn);
		cn.x = 250;
		cn.y = 260;
		cn.alpha = 0;
		Actuate.tween(cn, 3, { alpha:0 } ).onComplete(function():Dynamic { removeChild(cn); return null; } );
		
		socialButD();
	}
	
	function buyDeactivate()
	{
		if(bb0 != null) bb0.deactivate();
		Timer.delay(function() { if (bb1 == null) return; bb1.deactivate(); }, 200);
		Timer.delay(function() { if (bb2 == null) return; bb2.deactivate(); }, 400);
		
		socialButD();
	}
	
	public function switchSection(section:UInt)
	{
		switch(currenSection)
		{
			case 0: upgradeDeactivate(); but0.alphaChanger();
			case 1: buyDeactivate(); but1.alphaChanger();
		}
		
		switch(section)
		{
			case 0: upgradeAppear(); but0.alphaChanger(1);
			case 1: buyAppear(); but1.alphaChanger(1);
		}
		
		currenSection = section;
	}
	
	public function lock()
	{
		if (s20.parent != null) return;
		Game.game.playS(Game.game.s20);
		
		addChild(s20);
		s20.alpha = 0;
		if (Game.game.lang == "ru") s20.x = 500
		else s20.x = 454;
		s20.y = 35;
		var to = 414;
		if (Game.game.lang == "ru") to = 460;
		Game.game.layerGUI.render();
		Actuate.tween(s20, .4, { alpha:1, x:to } ).ease(Cubic.easeInOut);
		Timer.delay(function() {
			Actuate.tween(s20, .4, { alpha:0, x:500 } ).ease(Cubic.easeOut).onComplete(function():Dynamic
			{
				removeChild(s20);
				return null;
			});
		}, 4000);
	}
	
	public function lockU()
	{
		if (!luA) return;
		if (s20.parent != null) return;
		Game.game.playS(Game.game.fe);
		
		luA = false;
		Timer.delay(function() { luA = true; }, 4000);
	}
	
	public function new()
	{
		super(Game.game.layerGUI);
		
		iapTm = new Fnt(200, 540, "000", Game.game.layerGUI, 0, .7, true);
		
		Game.game.wall();
		
		if (Game.game.lang == "ru") s20 = new TileSprite(Game.game.layerGUI, "20stars_ru")
		else s20 = new TileSprite(Game.game.layerGUI, "20stars");
		
		if (Game.game.lang == "ru") rank = new TileSprite(Game.game.layerGUI, "rank_ru");
		else rank = new TileSprite(Game.game.layerGUI, "rank");
		
		rect_fb = new Rectangle(5, 210, 60, 60);
		rect_tw = new Rectangle(5, 270, 60, 60);
		rect_ia = new Rectangle(100, 534, 207, 44);
		
		
		share_fb.y = 240;
		share_tw.y = 300;
		setNoClick();
		
		blackout = new TileSprite(Game.game.layerGUI, "black_bg");
		blackout1 = new TileSprite(Game.game.layerGUI, "black_bg");
		blackout1.x = blackout.x = 500;
		blackout1.y = blackout.y = 300;
		blackout1.scaleX = blackout.scaleX = 10000;
		blackout1.scaleY = blackout.scaleY = 6000;
		addChild(blackout);
		#if mobile
		blackout.alpha = .8;
		#else
		blackout.alpha = .8;
		#end
		
		
		
		if (Game.game.currentLevel == 1) 
		{
			appearReady();
			Game.game.gameStatus = 1;
		}
		else
		{
			shopActivate();
			Game.game.gameStatus = 0;
		}
		
		Game.game.layerGUI.addChild(this);
	}
	
	function shopActivate()
	{
		currenSection = 0;
		
		Game.game.gameStatus = 0;
		
		rectUpgrade = new Rectangle(70, 0, 160, 74);
		rectBuy = new Rectangle(280, 0, 160, 74);
		
		rectMusic = new Rectangle(582, 0, 187, 74);
		rectFx = new Rectangle(770, 0, 187, 74);
		
		rectUpgrade0 = new Rectangle(388, 117, 440, 60);
		rectUpgrade1 = new Rectangle(388, 177, 440, 60);
		rectUpgrade2 = new Rectangle(388, 237, 440, 60);
		rectUpgrade3 = new Rectangle(388, 297, 440, 60);
		rectUpgrade4 = new Rectangle(388, 357, 440, 60);
		
		rectShop0 = new Rectangle(140, 97, 720, 110);
		rectShop1 = new Rectangle(140, 207, 720, 110);
		rectShop2 = new Rectangle(140, 317, 720, 110);
		
		
		Timer.delay(function() 
		{
			if (Game.game.lang == "ru") but0 = new Fnt(110, 34, "vfcnthcrfz", Game.game.layerGUI, 1, 1)
			else but0 = new Fnt(110, 34, "armory", Game.game.layerGUI, 1, 1);
			addChild(but0);
			
			Timer.delay(function() {
				if (Game.game.lang == "ru") but1 = new Fnt(280, 34, "vfufpby", Game.game.layerGUI, 1)
				else but1 = new Fnt(280, 34, "shop", Game.game.layerGUI, 1);
			addChild(but1); }, 200);
			
			Timer.delay(function() {
				if (Game.game.lang == "ru") onOffFx = new Fnt(800, 34, "dsrk.xbnm pder", Game.game.layerGUI, 1, .7, true)
				else onOffFx = new Fnt(820, 34, "sound off", Game.game.layerGUI, 1, .7, true);
			addChild(onOffFx);}, 600);
		}, 200);
		
		marker = new TileSprite(Game.game.layerGUI, "marker");
		marker.y = 54;
		marker.x = 0;
		addChild(marker);
		
		upgradeAppear();
		//buyAppear();
		
		line = new TileSprite(Game.game.layerGUI, "line");
		line.x = 500;
		line.y = 60;
		addChild(line);
		
		setMoney();
		
		upgradeRing = new TechnoRings(800, 500, 1, .5);
		upgradeRingBig = new TechnoRings(800, 500, 4, .3);
		if (Game.game.lang == "ru") f_ready = new Fnt(800, 500, "ujnjd", Game.game.layerGUI, 1, 1, true)
		else  f_ready = new Fnt(800, 500, "ready", Game.game.layerGUI, 1, 1, true);
		
		if (Game.game.currentLevel > 1) 
		{
			goNewRing = new TechnoRings(540, 500, 1, .5);
			if (Game.game.lang == "ru") goReset = new Fnt(540, 500, "yfxfnm pfyjdj", Game.game.layerGUI, 0, .7, true);
			else goReset = new Fnt(540, 500, "reset progress", Game.game.layerGUI, 0, .7, true);
			addChild(goNewRing);
			addChild(goReset);
		}
		
		addChild(upgradeRing);
		addChild(upgradeRingBig);
		addChild(f_ready);
	}
	
	public function setMoney()
	{
		if (money != null && money.parent != null) removeChild(money);
		if (Game.game.lang == "ru") money = new Fnt(200, 500, "ltymub " + Game.game.money, Game.game.layerGUI, 1, 1, true)
		else money = new Fnt(200, 500, "money " + Game.game.money, Game.game.layerGUI, 1, 1, true);
		addChild(money);
	}
	
	public function endBattle(message:String, messageNext:String, bonMes:String = null)
	{
		Game.game.layerGUI.addChild(this);
		blackout.alpha = 0;
		addChild(blackout);
		
		Timer.delay(function() 
		{ 
			
			var goShopPos:Vec2 = new Vec2(200, 500);
			if (Game.game.currentLevel == 2) goShopPos.x = 500;
			
			
			goShopRings = new TechnoRings(Std.int(goShopPos.x), Std.int(goShopPos.y), 1, .5);
			goMessage = new Fnt(500, 200, message, Game.game.layerGUI, 1, .7, true);
			
			goNextRings = new TechnoRings(800, 500, 1, .5);
			goNext = new Fnt(800, 500, messageNext, Game.game.layerGUI, 0, .7, true);
			
			
			
			if (Game.game.lang == "ru") goShop = new Fnt(Std.int(goShopPos.x), Std.int(goShopPos.y), "yf ,fpe", Game.game.layerGUI, 0, .7, true)
			else goShop = new Fnt(Std.int(goShopPos.x), Std.int(goShopPos.y), "go to base", Game.game.layerGUI, 0, .7, true);
			
			if (Game.game.currentLevel > 2)
			{
				addChild(goNextRings);
				addChild(goNext);
			}
			
			
			addChild(goShopRings);
			addChild(goShop);
			
			addChild(goMessage);
			Actuate.tween(blackout, 3, { alpha:.8 } ); 
			
			
			
			if (Game.game.rank != null)
			{
				Game.game.layerGUI.addChild(blackout1);
				blackout1.alpha = 0;
				Actuate.tween(blackout1, 2, { alpha:.87 } );
				
				Game.game.layerGUI.addChild(rank);
				rank.x = 500;
				rank.y = -240;
				Actuate.tween(rank, 1, { y:300 } ).ease(Elastic.easeOut).onComplete(function():Dynamic
				{
					rankS = new Fnt(500, 240, Game.game.rank, Game.game.layerGUI, 0, .7, true);
					Game.game.layerGUI.addChild(rankS);
					return null;
				});
				Game.game.layerGUI.render();
			}
		}, 7000);
	}
	
	public function rankDis()
	{
		Game.game.rank = null;
		Game.game.layerGUI.removeChild(blackout1);
		Game.game.layerGUI.removeChild(rankS);
		Actuate.tween(rank, 1, { y:-300 } ).ease(Cubic.easeOut).onComplete(function():Dynamic
		{
			Game.game.layerGUI.removeChild(rank);
			return null;
		});
	}
	
	function readyDeactivate()
	{
		goNextRings.deactivate();
		goShopRings.deactivate();
		goNext .deactivate();
		goShop.deactivate();
		if (goReset != null && goReset.parent != null)
		{
			goReset.deactivate();
			goNewRing.deactivate();
		}
		goMessage.deactivate();
	}
	
	public function clickNewGame()
	{
		//readyDeactivate();
		clickReady(false);
		confirmation = true;
		Timer.delay(function() {  confirm(); }, 300);
	}
	
	public function clickConfirm()
	{
		confirmDeactivation();
		Timer.delay(function() {  shopActivate(); }, 300);
		Game.game.reset();
	}
	public function clickCancel()
	{
		confirmDeactivation();
		Timer.delay(function() {  shopActivate(); }, 300);
	}
	public function clickCancelIap()
	{
		Game.game.gameStatus = 0;
		confirmDeactivation();
		goReset.deactivate();
		Timer.delay(function() {  shopActivate(); }, 300);
	}
	
	function confirmDeactivation()
	{
		confirmation = false;
		goNextRings.deactivate();
		goShopRings.deactivate();
		goNext.deactivate();
		goShop.deactivate();
		goMessage.deactivate();
	}
	
	function confirm()
	{
		var message = "progress will be reset";
		if (Game.game.lang == "ru") message = "dct ljcnb;tybz ,elen elfktys";
		goNextRings = new TechnoRings(800, 500, 1, .5);
		goShopRings = new TechnoRings(200, 500, 1, .5);
		
		goMessage = new Fnt(500, 200, message, Game.game.layerGUI, 1, .7, true);
		if (Game.game.lang == "ru") goNext = new Fnt(800, 500, "gjlndthlbnm", Game.game.layerGUI, 0, .7, true)
		else goNext = new Fnt(800, 500, "confirm", Game.game.layerGUI, 0, .7, true);
		if (Game.game.lang == "ru") goShop = new Fnt(200, 500, "jnvtyf", Game.game.layerGUI, 0, .7, true)
		else goShop = new Fnt(200, 500, "cancel", Game.game.layerGUI, 0, .7, true);
		
		addChild(goNextRings);
		addChild(goShopRings);
		addChild(goNext);
		addChild(goShop);
		addChild(goMessage);
	}
	
	public function backToShop()
	{
		readyDeactivate();
		Timer.delay(function() 
		{ 
			shopActivate();
		}, 300);
	}
	
	function appearIap()
	{
		Timer.delay(function() 
		{ 
			var message:String;
			var message1:String;
			if (Game.game.lang == "ru") 
			{
				message = "pfhj,jnjr ,eltn hfcnb ghjgjhwbjyfkmyj ghjuhtcce";
				message1 = "b ,jkmit ybrfrjb htrkfvs";
			}
			else 
			{
				message = "earnings will increase in proportion to the progress of";
				message1 = "and no more ads";
			}
			
			//delete on production__________________________________________________________________!!!!
			if (Game.game.lang == "ru") 
			{
				message = "jnrk.xftn htrkfve b gjdsiftn lj[jl";
				message1 = "yt hf,jnftn d ntcnjdjb dthcbb";
			}
			else {
				message = "users will be able to disable ads on production";
				message1 = "also earnings will be less to motivate users to buy premium";
			}
			
			
			goNextRings = new TechnoRings(800, 500, 1, .5);
			goShopRings = new TechnoRings(200, 500, 1, .5);
			
			goMessage = new Fnt(500, 200, message, Game.game.layerGUI, 1, .7, true);
			goReset = new Fnt(500, 234, message1, Game.game.layerGUI, 1, .7, true);
			
			if (Game.game.lang == "ru") goNext = new Fnt(800, 500, "=1 regbnm", Game.game.layerGUI, 0, .7, true)
			else goNext = new Fnt(800, 500, "=1 buy", Game.game.layerGUI, 0, .7, true);
			if (Game.game.lang == "ru") goShop = new Fnt(200, 500, "yf ,fpe", Game.game.layerGUI, 0, .7, true);
			else goShop = new Fnt(200, 500, "go to base", Game.game.layerGUI, 0, .7, true);
			
			
			
			addChild(goNextRings);
			addChild(goShopRings);
			addChild(goNext);
			addChild(goShop);
			addChild(goMessage);
			addChild(goReset);
		}, 300);
	}
	
	function appearReady()
	{
		Timer.delay(function() 
		{ 
			var p = "";
			
			if (Game.game.currentLevel == 1) p = "st"
			else if (Game.game.currentLevel == 2) p = "nd"
			else if (Game.game.currentLevel == 3) p = "rd"
			else p = "th";
			
			var message:String;
			if (Game.game.currentLevel == 1)
			{
				if (Game.game.lang == "ru") message = "ghjdthrf jhe;bz"
				else message = "weapons check";
			}
			else 
			{
				if (Game.game.lang == "ru") message = "ghbujnjdmntcm jnhfpbnm " + (Game.game.currentLevel - 1) + "." + " djkye"
				else message = "prepare to repel the " + (Game.game.currentLevel - 1) + p + " wave";
			}
			
			var xx = 800;
			
			if (Game.game.currentLevel == 1) xx = 500;
			
			goNextRings = new TechnoRings(xx, 500, 1, .5);
			goShopRings = new TechnoRings(200, 500, 1, .5);
			
			goMessage = new Fnt(500, 200, message, Game.game.layerGUI, 1, .7, true);
			if (Game.game.lang == "ru") goNext = new Fnt(800, 500, "r ,j.", Game.game.layerGUI, 0, .7, true)
			else goNext = new Fnt(xx, 500, "start", Game.game.layerGUI, 0, .7, true);
			if (Game.game.lang == "ru") goShop = new Fnt(200, 500, "yf ,fpe", Game.game.layerGUI, 0, .7, true);
			else goShop = new Fnt(200, 500, "go to base", Game.game.layerGUI, 0, .7, true);
			
			addChild(goNextRings);
			addChild(goNext);
			
			if (Game.game.currentLevel > 1)
			{
				addChild(goShopRings);
				addChild(goShop);
			}
			
			addChild(goMessage);
		}, 300);
	}
	
	public function endBattleDeactivate(goShp:Bool = true)
	{
		Game.game.clear();
		goNext.deactivate();
		goShop.deactivate();
		goMessage.deactivate();
		goNextRings.deactivate();
		goShopRings.deactivate();
		if (goShp) Timer.delay(function() { shopActivate(); }, 700 )
		else Timer.delay(function() { clickStart(); }, 700 );
		
		if (goReset != null && goReset.parent != null)
		{
			goReset.deactivate();
			goNewRing.deactivate();
		}
	}
	
	public function endBattleDeactivateE()
	{
		endBattleDeactivate();
	}
	
	function mainDeactivate()
	{
		but0.deactivate();
		but1.deactivate();
		onOffFx.deactivate();
		money.deactivate();
		removeChild(line);
	}
	
	public function clickReady(changeStatus:Bool=true)
	{
		mainDeactivateAll();
		
		if (changeStatus) {
			Timer.delay(function() { appearReady(); }, 700 );
			Game.game.gameStatus = 1;
		}
	}
	
	#if mobile
	public function iapClick()
	{
		/*mainDeactivateAll();
		
		Timer.delay(function() { appearIap(); }, 700 );
		Game.game.gameStatus = 7;*/
		
		if (!iap.visible) return;
		
		//EnhanceOpenFLExtension.showRewardedAd(EnhanceOpenFLExtension.REWARDED_PLACEMENT_NEUTRAL, onRewardGranted, onRewardDeclined, onRewardUnavailable);
		
		
	}
	
	private function onRewardGranted(rewardType:String, rewardAmount:Int):Void 
	{
		//trace('The ad reward is granted! type ' + rewardType + ', amount: ' + rewardAmount);
		
		Game.game.money += Game.game.addFunds;
		setMoney();
	}
	
	private function onRewardDeclined():Void
	{
		//trace('The ad reward is declined');
	}
	
	private function onRewardUnavailable():Void
	{
		//trace('The ad reward is unavailable');
	}
	#end
	
	function mainDeactivateAll()
	{
		mainDeactivate();
		switch(currenSection)
		{
			case 0: upgradeDeactivate(); but0.alphaChanger();
			case 1: buyDeactivate(); but1.alphaChanger();
		}
		removeChild(marker);
		f_ready.deactivate();
		upgradeRingBig.deactivate();
		upgradeRing.deactivate();
		
		if (goNewRing != null && goNewRing.parent != null)
		{
			goNewRing.deactivate();
			goReset.deactivate();
		}
	}
	
	public function clickStart()
	{
		
		Game.game.isGame = true;
		goNext.deactivate();
		goShop.deactivate();
		goMessage.deactivate();
		goNextRings.deactivate();
		goShopRings.deactivate();
		
		if (goReset != null && goReset.parent != null)
		{
			goReset.deactivate();
			goNewRing.deactivate();
		}
		
		addChild(blackout1);
		blackout1.alpha = 0;
		Actuate.tween(blackout1, 2, { alpha:1 } ).onComplete(function():Dynamic
		{
			removeAllChildren();
			addChild(blackout1);
			
			Actuate.tween(blackout1, 2, { alpha:0 } ).onComplete(function():Dynamic
			{
				if(parent != null) parent.removeChild(this);
				return null;
			});
			
			Timer.delay(function() { Game.game.init(); }, 1400);
			Game.game.playS(Game.game.attackWarning);
			return null;
		});
	}
	
	
}

class BuyButton extends TileGroup
{
	
	var name:Fnt;
	var available:TileGroup;
	var price:Fnt;
	var border:TileSprite;
	var ico:TileSprite;
	var icoN:String;
	var lim:UInt;
	var clickEffect:TileSprite;
	var clickEffectR:TileSprite;
	var numOfAvailableItems:UInt = 0;
	
	public function new(x:UInt, y:UInt, n:String, icoN:String = "btb0", lim:UInt = 5, numOfA:UInt = 0)
	{
		super(Game.game.layerGUI);
		
		available = new TileGroup(Game.game.layerGUI);
		this.lim = lim;
		this.icoN = icoN;
		this.x = x + 14;
		this.y = y;
		numOfAvailableItems = numOfA;
		price = new Fnt(0, 0, "" + Game.game.shopPrices[getId()], Game.game.layerGUI);
		price.y = 34;
		price.x = - 20;
		name = new Fnt(0, 0, n, Game.game.layerGUI);
		name.x = 107;
		border = new TileSprite(Game.game.layerGUI, "btborder");
		border.alpha = .7;
		ico = new TileSprite(Game.game.layerGUI, icoN);
		ico.alpha = .7;
		ico.y = -8;
		ico.scale = border.scale = 0;
		Actuate.tween(ico, 1, { scale:1 } ).ease(Elastic.easeOut);
		Actuate.tween(border, 1, { scale:1 } ).ease(Elastic.easeOut);
		
		checkA(0, Game.game.shopItems[getId()]);
		
		clickEffect = new TileSprite(Game.game.layerGUI, "click");
		clickEffect.x = 270;
		
		clickEffectR = new TileSprite(Game.game.layerGUI, "clickR");
		clickEffectR.x = 270;
		
		addChild(name);
		addChild(price);
		addChild(border);
		addChild(ico);
		addChild(available);
	}
	
	function getId():UInt
	{
		return Std.parseInt(icoN.substr(3, 1));
	}
	
	function getPrice():UInt
	{
		return Game.game.shopPrices[getId()];
	}
	
	public function buy()
	{
		var needUpgrade:TileSprite;
		
		if (Game.game.lang == "ru") needUpgrade = new TileSprite(Game.game.layerGUI, "upgradeAlert_ru")
		else needUpgrade = new TileSprite(Game.game.layerGUI, "upgradeAlert");
		
		needUpgrade.x = 370;
		
		var cost = getPrice();
		if (Game.game.shopItems[getId()] == 5)
		{
			return;
		}
		if (Game.game.money >= cost && Game.game.shopItems[getId()] < numOfAvailableItems)
		{
			Game.game.money -= cost;
			Game.game.shopItems[getId()]++;
			
			addChild(clickEffect);
			clickEffect.alpha = 1;
			clickEffect.scaleY = 20;
			
			Actuate.tween(clickEffect, .5, { scaleY:200, alpha:0 } ).onComplete(function():Dynamic
			{
				removeChild(clickEffect);
				return null;
			});
			
			available.removeAllChildren();
			checkA(0, Game.game.shopItems[getId()]);
		}
		else
		{
			if (Game.game.shopItems[getId()] >= numOfAvailableItems)
			{
				if (needUpgrade.parent == null) addChild(needUpgrade);
				
				needUpgrade.alpha = 0;
				
				Actuate.tween(needUpgrade, .4, {alpha:1}).onComplete(function():Dynamic
				{
					Timer.delay(function() {
						Actuate.tween(needUpgrade, .4, { alpha:0 } ).onComplete(function():Dynamic
						{
							removeChild(needUpgrade);
							return null;
						});
					}, 1000);
					return null;
				});
			}
			
			addChild(clickEffectR);
			clickEffectR.alpha = 1;
			clickEffectR.scaleY = 20;
			
			Actuate.tween(clickEffectR, .5, { scaleY:200, alpha:0 } ).onComplete(function():Dynamic
			{
				removeChild(clickEffectR);
				return null;
			});
		}
	}
	
	public function deactivate()
	{
		price.deactivate();
		name.deactivate();
		aDeactivate();
		
		Actuate.tween(border, 1, { scale:1.4, alpha:0 } ).onComplete(function():Dynamic 
		{
			removeChild(border);
			return null;
		});
		Actuate.tween(ico, 2, { scale:1.8, alpha:0 } ).onComplete(function():Dynamic 
		{
			removeChild(border);
			return null;
		});
		
		Timer.delay(function() { removeAllChildren(); if (parent != null) parent.removeChild(this); }, 3000);
	}
	
	function aDeactivate(ind:UInt = 0)
	{
		Timer.delay(function()
		{
			var starE = available.children[ind];
			if (starE == null) return;
			Actuate.tween(starE, 1, { scale:0 } ).onComplete(function():Dynamic 
			{
				available.removeChild(starE);
				available.children.remove(starE);
				return null;
			});
			
			ind++;
			
			if (ind < lim) aDeactivate(ind)
			else 
			{
				available.parent.removeChild(available);
			}
		}, 100);
	}
	
	public function checkA(step:UInt = 0, full:UInt = 0)
	{
		Timer.delay(function()
		{
			var a:TileSprite;
			
			if (step < numOfAvailableItems) a = new TileSprite(Game.game.layerGUI, icoN)
			else a = new TileSprite(Game.game.layerGUI, "lock");
			
			a.scale = .1;
			a.alpha = 0;
			var sc = 1.0;
			var al = .7;
			
			if (step >= full)  
			{
				al = .4;
				sc = .7;
			}
			Actuate.tween(a, 1, { scale:sc, alpha:al } ).ease(Elastic.easeOut);
			
			a.x = 430 + 47 * step;
			//starE.y = 20;
			available.addChild(a);
			Game.game.layerGUI.render();
			step++;
			if (step < lim) checkA(step, full);
		}, 100);
	}
}

class UpgradeButton extends TileGroup
{
	
	var name:Fnt;
	var stars:TileGroup;
	var price:Fnt;
	var dl:TileSprite;
	var ind:UInt;
	var clickEffect:TileSprite;
	var clickEffectR:TileSprite;
	
	function getPrice():UInt
	{
		return Std.int(Game.game.upgrades[ind][Game.game.upgradesProgress[ind]]);
	}
	
	function setPrice()
	{
		var p = "" + getPrice();
		if (p == "0") 
		{
			if (Game.game.lang == "ru") p = "vfrc"
			else p = "full";
		}
		price = new Fnt(0, 0, "" + p, Game.game.layerGUI);
		price.x = 320;
		addChild(price);
	}
	
	public function buy()
	{
		var cost = getPrice();
		if (Game.game.upgradesProgress[ind] == 5)
		{
			return;
		}
		if (Game.game.money >= cost)
		{
			Game.game.money -= cost;
			removeChild(price);
			Game.game.upgradesProgress[ind]++;
			setPrice();
			
			stars.removeAllChildren();
			checkStars();
			
			addChild(clickEffect);
			clickEffect.alpha = 1;
			clickEffect.scaleY = 20;
			
			Actuate.tween(clickEffect, .5, { scaleY:200, alpha:0 } ).onComplete(function():Dynamic
			{
				removeChild(clickEffect);
				return null;
			});
		}
		else
		{
			addChild(clickEffectR);
			clickEffectR.alpha = 1;
			clickEffectR.scaleY = 20;
			
			Actuate.tween(clickEffectR, .5, { scaleY:200, alpha:0 } ).onComplete(function():Dynamic
			{
				removeChild(clickEffectR);
				return null;
			});
		}
	}
	
	public function new(x:UInt, y:UInt, n:String, ind:UInt)
	{
		super(Game.game.layerGUI);
		this.x = x;
		this.y = y;
		this.ind = ind;
		setPrice();
		name = new Fnt(0, 0, n, Game.game.layerGUI);
		addChild(name);
		stars = new TileGroup(Game.game.layerGUI);
		addChild(stars);
		checkStars();
		
		clickEffect = new TileSprite(Game.game.layerGUI, "click");
		clickEffect.x = 70;
		
		clickEffectR = new TileSprite(Game.game.layerGUI, "clickR");
		clickEffectR.x = 70;
		
		dl = new TileSprite(Game.game.layerGUI, "dottedline");
		dl.x = 234;
		dl.y = 20;
		dl.alpha = 0;
		Actuate.tween(dl, 20, { alpha:.7 } );
		addChild(dl);
	}
	
	public function deactivate()
	{
		price.deactivate();
		name.deactivate();
		starsDeactivate();
		Actuate.tween(dl, 2, { alpha:0 } ).onComplete(function():Dynamic
		{
			if (dl == null || dl.parent == null) return null;
			dl.parent.removeChild(dl);
			return null;
		});
		Timer.delay(function() { removeAllChildren(); if (parent != null) parent.removeChild(this); }, 3000);
	}
	
	public function checkStars(step:UInt = 0)
	{
		Timer.delay(function()
		{
			var starE:TileSprite;
			if (step < Game.game.upgradesProgress[ind]) starE = new TileSprite(Game.game.layerGUI, "star_full")
			else starE = new TileSprite(Game.game.layerGUI, "star_empty");
			starE.x = 21 + 16 * step;
			starE.y = 20;
			stars.addChild(starE);
			Game.game.layerGUI.render();
			step++;
			if (step < 5) checkStars(step);
		}, 100);
	}
	
	function starsDeactivate(ind = 0)
	{
		Timer.delay(function()
		{
			var starE = stars.children[ind];
			if (starE == null) return;
			Actuate.tween(starE, 1, { scale:0 } ).onComplete(function():Dynamic 
			{
				stars.removeChild(starE);
				stars.children.remove(starE);
				return null;
			});
			
			ind++;
			
			if (ind < 7) starsDeactivate(ind)
			else 
			{
				stars.parent.removeChild(stars);
			}
		}, 100);
	}
}

class TechnoRings extends TileGroup
{
	
	var scale:Float;
	var alpha:Float;
	var sb0:TileSprite;
	var sb1:TileSprite;
	var sb2:TileSprite;
	var sb3:TileSprite;
	var sb4:TileSprite;
	
	public function new(x:UInt, y:UInt, scale:Float = 1, alpha:Float = 1)
	{
		super(Game.game.layerGUI);
		
		this.scale = scale;
		this.alpha = alpha;
		
		this.x = x;
		this.y = y;
		
		sb0 = bMaker(0, 0, "bt0"); rotator(sb0);
		Timer.delay(function() { sb1 = bMaker(0, 0, "bt1"); rotator(sb1); }, 150);
		Timer.delay(function() { sb2 = bMaker(0, 0, "bt2"); rotator(sb2); }, 300);
		Timer.delay(function() { sb3 = bMaker(0, 0, "bt3"); rotator(sb3); }, 450);
		Timer.delay(function() { sb4 = bMaker(0, 0, "bt4"); rotator(sb4); }, 600);
		
	}
	
	public function deactivate()
	{
		Actuate.tween(sb0, 2, { scale:3, alpha:0 } );
		Timer.delay(function() { Actuate.tween(sb1, 2, { scale:3, alpha:0 } ); }, 270);
		Timer.delay(function() { Actuate.tween(sb2, 2, { scale:3, alpha:0 } ); }, 540);
		Timer.delay(function() { Actuate.tween(sb3, 2, { scale:3, alpha:0 } ); }, 810);
		Timer.delay(function() { Actuate.tween(sb4, 2, { scale:3, alpha:0 } ).onComplete(function():Dynamic
		{
			removeAllChildren();
			if (parent != null) parent.removeChild(this);
			return null;
		}); }, 1080);
	}
	
	public function click()
	{
		var r = bMaker(0, 0, "ring");
		r.alpha = 0;
		
		Game.game.layerGUI.render();
			
		Actuate.tween(r, 5, { scale:3 } );
		Actuate.tween(r, .2, { alpha:.4 } ).onComplete(function():Dynamic 
		{ 
			Actuate.tween(r, 4, { alpha:0 } ).onComplete(function():Dynamic 
			{
				removeChild(r);
				return null; 
			});
			return null; 
		} );
	}
	
	function bMaker(x:Float, y:Float, id:String, appearType:UInt = 0):TileSprite
	{
		var obj = new TileSprite(Game.game.layerGUI, id);
		obj.x = x;
		obj.y = y;
		addChild(obj);
		
		switch(appearType)
		{
			case 0:
				obj.scale = 3;
				obj.alpha = 0;
				Actuate.tween(obj, 2, { scale:scale } );
				Actuate.tween(obj, 2, { alpha:alpha } );
		}
		return obj;
	}
	
	function rotator(target:TileSprite)
	{
		if (parent == null) return;
		Actuate.tween(target, 3, { rotation:Math.random() * Math.PI * 2 } );
		var r = Math.round(700 + Math.random() * 300);
		Timer.delay(function()
		{
			rotator(target);
		}, r);
	}
}

//#if mobile
class IAPB extends TileGroup
{
	var iap0:TileSprite;
	var iap1:TileSprite;
	var ladd:String = "";
	public function new()
	{
		super(Game.game.layerGUI);
		if (Game.game.lang == "ru") ladd = "_ru";
		iap1 = new TileSprite(Game.game.layerGUI, "eb" + ladd + "0");
		iap0 = new TileSprite(Game.game.layerGUI, "eb" + ladd + "1");
		addChild(iap1);
		iap0.alpha = 0;
		addChild(iap0);
		
		initTimer();
	}
	public function initTimer()
	{
		if (parent == null) return;
		
		Timer.delay(function()
		{
			Actuate.tween(iap0, .2, { alpha:1 } ).onComplete(function():Dynamic
			{
				Timer.delay(function()
				{
					Actuate.tween(iap0, .2, { alpha:0 } ).onComplete(function():Dynamic
					{
						initTimer();
						return null;
					});
				}, 700);
				return null;
			});
		}, 700);
	}
}
//#end
