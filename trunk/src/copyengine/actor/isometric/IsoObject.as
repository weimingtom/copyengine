package copyengine.actor.isometric
{
	import copyengine.utils.GeneralUtils;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	
	import game.scene.IsoMath;

	public class IsoObject
	{
		public var col:int;
		public var row:int;
		public var height:int;

		public var maxCols:int;
		public var maxRows:int;

		public var container:DisplayObjectContainer;

		public function IsoObject(_skin:DisplayObjectContainer , 
			_col:int , _row:int , _height:int , 
			_maxCols:int , _maxRows:int)
		{
			container = _skin;
			col = _col;
			row = _row;
			height = _height;
			maxCols = _maxCols;
			maxRows = _maxRows;
		}
		
	}
}