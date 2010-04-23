package copyengine.actor.isometric
{
	import copyengine.datas.isometric.IsoObjectVo;
	import copyengine.utils.GeneralUtils;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	
	import game.scene.IsoMath;
	
	import org.osmf.net.dynamicstreaming.INetStreamMetrics;

	/**
	 *IsoObject is basic isometric display object. it contain
	 * 
	 * 1`DisplayPart:
	 * 2`DataPart : 
	 * 		IsoObjectVo :: contain the data need to upload to server
	 * 		MetaData :: use an id(get from IsoObjectVo)  map some meta data(like maxRows , maxCols)
	 *  
	 * @author Tunied
	 * 
	 */	
	public class IsoObject
	{
		/**
		 * use in setScenePositionByIsoPosition() function.
		 */		
		private static var screenVector:Vector3D = new Vector3D();
		
		public var isoObjectVo:IsoObjectVo;
		public var container:DisplayObjectContainer;
		
		/**
		 * @private
		 * WARNING::
		 * 		col,row,height those three value 
		 */		
		public var col:int;
		public var row:int;
		public var height:int;
		public var maxCol:int;
		public var maxRow:int;
		
		public function IsoObject(_skin:DisplayObjectContainer , _isoObjectVo:IsoObjectVo)
		{
			container = _skin;
			isoObjectVo = _isoObjectVo;
		}
		
		public function setScenePositionByIsoPosition():void
		{
			//caulate the target the screen position
			screenVector.x = isoObjectVo.col * GeneralConfig.ISO_TILE_WIDTH;
			screenVector.y = isoObjectVo.row * GeneralConfig.ISO_TILE_WIDTH;
			screenVector.z = isoObjectVo.height * GeneralConfig.ISO_TILE_WIDTH;
			IsoMath.isoToScreen(screenVector);
			
			//move the objs to the tile
			container.x = screenVector.x;
			container.y = screenVector.y;
		}
		
	}
}