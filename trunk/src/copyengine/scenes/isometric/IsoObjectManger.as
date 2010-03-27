package copyengine.scenes.isometric
{
	import copyengine.scenes.isometric.viewport.IViewPortListener;

	/**
	 *  IsoObjectManger use to 
	 * 		1` control each object update
	 * 		2` do the frustum culling logic.
	 * 
	 * @author Tunied
	 * 
	 */	
	public final class IsoObjectManger implements IViewPortListener
	{
		private var isoObjectList:Vector.<IIsoObject>;
		
		public function IsoObjectManger()
		{
		}
		
		public function initialize(_isoObjs:Vector.<IIsoObject>, _viewPortWidth:int , _viewPortHeight:int):void
		{
			
		}
		
	}
}