package;
import aze.display.TileClip;
import openfl.Assets;
import particles.ParticlesEm;

class FragmentFire extends Fragment
{
	public function new(frc:UInt = 4, n:String = "frag_fire")
	{
		super(frc);
		
		body.userData.fragment = true;
		
		arr = Game.game.fragmentsFire;
		
		body.gravMass /= 2;
	}
	
	override function initFrag()
	{
		graphic = new TileClip(Game.game.layer, fName, 25);
		graphic.scale = .3 + Math.random() * .7;
		graphic.rotation = Math.random() * Math.PI;
		body.userData.graphic = graphic;
		
		var sm = "xml/smoke_black.xml";
		if (graphic.scale < .4) sm = "xml/smoke_black_small.xml";
		
		var tXml = Assets.getText(sm);
		emitter = new ParticlesEm(Game.game.layerAdd, tXml, "f_part", Game.game.layerAdd);
	}
}