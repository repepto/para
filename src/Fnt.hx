package;
import aze.display.TileClip;
import aze.display.TileGroup;
import aze.display.TileLayer;
import aze.display.TileSprite;
import haxe.Timer;

class Fnt extends TileGroup
{
	var strA:Array<TileSprite>;
	var cursor:TileClip;
	var lineSpacing:UInt;
	var alpha:Float;
	var active:Bool;
	var charWidth:UInt;
	
	public function new(x:Int, y:Int, str:String, layer:TileLayer, effectType: UInt = 0, alpha:Float = .7, centr:Bool=false, lineSpacing:UInt = 3, charWidth:UInt = 14)
	{
		super(layer);
		
		this.charWidth = charWidth;
		
		active = true;
		
		this.lineSpacing = lineSpacing;
		
		if (centr) 
		{
			var wdth = str.length * charWidth;
			this.x = x - wdth / 2 + 8;
		}
		else this.x = x;
		this.y = y;
		this.alpha = alpha;
		
		newValue(str);
		
		switch(effectType)
		{
			case 0:randomizer(strA.copy(), 120);
			case 1:typeWriter(120);
		}
		
	}
	
	public function alphaChanger(alpha:Float = .7)
	{
		for (i in children)
		{
			cast(i, TileSprite).alpha = alpha;
		}
	}
	
	public function clear()
	{
		removeAllChildren();
	}
	
	public function newValue(str:String, add:Bool=false)
	{
		clear();
		
		strA = new Array();
		var nextChar:TileSprite;
		var px:Float = 0;
		
		for (i in 0...str.length)
		{
			var ch = str.charAt(i);
			if (ch == " ") ch = "";
			nextChar = new TileSprite(layer, "f" + ch);
			
			if (charWidth == 0)
			{
				if (i > 0) 
				{
					px = strA[i - 1].x + strA[i - 1].width / 2  + lineSpacing;
				}
				px += nextChar.width / 2;
			}
			else px = charWidth * i;
			
			nextChar.x = px;
			if(add) this.addChild(nextChar);
			strA.push(nextChar);
		}
	}
	
	function randomizer(tempStr:Array<TileSprite>, randomDelay:UInt = 0, tm:UInt = 40, effectTime:UInt = 400)
	{
		if (!active) return;
		
		var char = Std.random(tempStr.length);
		
		Timer.delay(function()
		{
			if (tempStr[char] == null) return;
			var toAdd = tempStr[char];
			tempStr[char].alpha = alpha;
			var tc = new TileClip(Game.game.layerGUI, "f", 32);
			tc.x = tempStr[char].x;
			tc.y = tempStr[char].y;
			addChild(tc);
			tc.alpha = alpha;
			layer.render();
			tempStr.remove(tempStr[char]);
			
			Timer.delay(function() 
			{ 
				removeChild(tc);
				addChild(toAdd);
				layer.render();
			}, effectTime);
			
			
			if (tempStr.length > 0) 
			{
				randomizer(tempStr, randomDelay, tm, effectTime);
			}
			
		}, tm + Std.random(randomDelay));
	}	
	
	function randomizer1(randomDelay:UInt = 0, tm:UInt = 40, effectTime:UInt = 400, char:Int = 0)
	{
		if (!active) return;
		
		Timer.delay(function()
		{
			if (strA[char] == null) return;
			addChild(strA[char]);
			strA[char].alpha = alpha;
			var tc = new TileClip(Game.game.layerGUI, "f", 32);
			tc.x = strA[char].x;
			tc.y = strA[char].y;
			addChild(tc);
			tc.alpha = alpha;
			layer.render();
			
			Timer.delay(function() 
			{ 
				removeChild(tc);
				layer.render();
			}, effectTime);
			
			
			if (char < strA.length - 1) 
			{
				char++;
				randomizer1(randomDelay, tm, effectTime, char);
			}
			
		}, tm + Std.random(randomDelay));
	}
	
	
	public function deactivate(randomDelay:UInt = 0, tm:UInt = 40, effectTime:UInt = 400)
	{
		active = false;
		
		var char = Math.round(Math.random() * (strA.length - 1));
		Timer.delay(function()
		{
			if (strA[char] == null) return;
			if (strA[char].parent != null)
			{
				removeChild(strA[char]);
			
				var tc = new TileClip(Game.game.layerGUI, "f", 32);
				tc.x = strA[char].x;
				tc.y = strA[char].y;
				addChild(tc);
				tc.alpha = alpha;
				layer.render();
				
				Timer.delay(function() 
				{ 
					removeChild(tc);
					layer.render();
				}, effectTime);
			}
			strA.remove(strA[char]);
			
			
			if (strA.length > 0) 
			{
				deactivate(randomDelay, tm, effectTime);
			}
			else 
			{
				removeAllChildren();
				if (this.parent != null) parent.removeChild(this);
			}
			
			
		}, tm + Std.random(randomDelay));
	}
	
	
	function typeWriter(randomDelay:UInt = 0, tm:UInt = 40, char:Int = 0)
	{
		if (!active) return;
		if (cursor == null) cursor = new TileClip(layer, "f_mig", 4);
		if (cursor.parent == null) addChild(cursor);
		
		Timer.delay(function()
		{
			if (strA[char] == null) return;
			addChild(strA[char]);
			strA[char].alpha = alpha;
			
			cursor.x = strA[char].x;
			layer.render();
			if (char < strA.length - 1) 
			{
				char++;
				typeWriter(randomDelay, tm, char);
			}
			else 
			{
				cursor.x += cursor.width + lineSpacing;
				Timer.delay(function() { removeChild(cursor); }, 2200);
			}
		}, tm + Std.random(randomDelay));
	}	
}