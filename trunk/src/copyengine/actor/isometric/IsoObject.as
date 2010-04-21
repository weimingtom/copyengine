package copyengine.actor.isometric
{
	import copyengine.datas.isometric.IsoObjectVo;
	import copyengine.utils.GeneralUtils;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	
	import game.scene.IsoMath;

	public class IsoObject
	{
		public var isoObjectVo:IsoObjectVo;
		public var container:DisplayObjectContainer;

		public function IsoObject(_skin:DisplayObjectContainer , _isoObjectVo:IsoObjectVo)
		{
			container = _skin;
			isoObjectVo = _isoObjectVo;
		}
		
	}
}