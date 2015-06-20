package;

class Ready2ride extends ControlledObject
{
	
	public var value:UInt;
	public var slower:Bool;
	
	public function new(value:UInt, slower:Bool)
	{
		super(null);
		this.value = value;
		this.slower = slower;
	}
	
	override public function init(tileGr:Bool = false)
	{
		
	}
	
	override public function run()
	{
		
	}
	
	override public function destruction() 
	{
		
	}
	
	override public function clear()
	{
		
	}
}