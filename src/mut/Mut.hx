package mut;
import nape.geom.Vec2;

/**
 * ...
 * @author serg
 */
@:final
class Mut
{
	public static function getAng2(p1:nape.geom.Vec2, p2:nape.geom.Vec2, p3:nape.geom.Vec2, inRad:Bool = true):Float
	{
		var r:Float;
		if (inRad) r = 1
		else r = 180 / Math.PI;
		var a2 = Math.atan2(p1.x - p2.x, p1.y - p2.y) * r;
		var a3 = Math.atan2(p1.x - p3.x, p1.y - p3.y) * r;
		return (a2 - a3);
	}
	
	public static function getAng(p1:nape.geom.Vec2, p2:nape.geom.Vec2):Float
	{
		var a = - Math.PI / 2 - Math.atan2(p1.x - p2.x, p1.y - p2.y);
		return a;
	}
	
	public static function dist(x1:Float, y1:Float, x2: Float, y2:Float):Float 
	{
		return Math.sqrt((x1 - x2)*(x1 - x2) + (y1 - y2)*(y1 - y2));
	}
	
	public static function distV2(pos1:Vec2, pos2:Vec2):Float 
	{
		return Math.sqrt((pos1.x - pos2.x)*(pos1.x - pos2.x) + (pos1.y - pos2.y)*(pos1.y - pos2.y));
	}
}