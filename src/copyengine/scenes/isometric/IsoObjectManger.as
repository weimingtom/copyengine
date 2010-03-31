package copyengine.scenes.isometric
{
	import copyengine.scenes.isometric.viewport.IViewPortListener;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

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
		
		private var isoObjectMangerContainer:DisplayObjectContainer
		
		public function IsoObjectManger()
		{
		}
		
		public function initialize(_isoObjs:Vector.<IIsoObject>, _viewPortWidth:int , _viewPortHeight:int):void
		{
			isoObjectMangerContainer = new Sprite();
		}
		
		public function addIsoObject(_obj:IIsoObject):void
		{
			
		}
		
		public function removeIsoObject(_obj:IIsoObject):void
		{
			
		}
		
		
		public function dispose():void
		{
			
		}
		
		public function get container():DisplayObjectContainer
		{
			return isoObjectMangerContainer;
		}
		
		public function noMoveUpdate(_viewPortX:int , _viewPortY:int):void
		{
			
		}
		
		public function moveToUpdate(_viewPortX:int ,_viewPortY:int , _perViewPortX:int , _perViewPortY:int):void
		{
			
		}
		
	}
}