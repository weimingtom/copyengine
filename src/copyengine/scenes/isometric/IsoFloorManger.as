package copyengine.scenes.isometric
{
	import copyengine.scenes.isometric.viewport.IViewPortListener;
	
	import flash.display.DisplayObjectContainer;

	/**
	 * IsoFloorManger use to
	 * 		1` control the floor move with viewport
	 * 		2` do the frustum culling logic.
	 * 
	 * WARNINIG:: is one tile have two level (z=1 , z=2), the isoObject only can add to z=2 tile
	 * 					  can't add to z =1 tile
	 * 
	 * @author Tunied
	 * 
	 */	
	public class IsoFloorManger implements IViewPortListener
	{
		private var isoFloor:IsoFloor;
		
		public function IsoFloorManger()
		{
		}
		
		public function initialize(_isoFloor:IsoFloor , _viewPortWidth:int , _viewPortHeight:int):void
		{
			
		}
		
		public function get container():DisplayObjectContainer
		{
			return null;
		}
		
	}
}