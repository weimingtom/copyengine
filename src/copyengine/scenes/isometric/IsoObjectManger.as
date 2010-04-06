package copyengine.scenes.isometric
{
	import copyengine.actor.isometric.IIsoObject;
	import copyengine.scenes.isometric.viewport.IViewPortListener;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Vector3D;
	
	import game.scene.IsoMath;

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
		
		public function initialize(_isoObjs:Vector.<IIsoObject>):void
		{
			isoObjectMangerContainer = new Sprite();
			for(var i:int = 0 ; i < _isoObjs.length ; i++)
			{
				isoObjectMangerContainer.addChild(_isoObjs[i].container);
				var isoPos:Vector3D = new Vector3D(_isoObjs[i].row*GeneralConfig.ISO_TILE_WIDTH,_isoObjs[i].col*GeneralConfig.ISO_TILE_WIDTH,0);
				IsoMath.isoToScreen(isoPos);
				_isoObjs[i].container.x = isoPos.x;
				_isoObjs[i].container.y = isoPos.y;
			}
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
		
		public function viewPortMoveToUpdate(_viewPortX:int ,_viewPortY:int , _preViewPortX:int , _preViewPortY:int) : void
		{
			isoObjectMangerContainer.x = -_viewPortX;
			isoObjectMangerContainer.y = -_viewPortY;
		}
		
		public function viewPortInitialzeComplate(_viewPortX:int , _viewPortY:int):void
		{
			isoObjectMangerContainer.x = -_viewPortX;
			isoObjectMangerContainer.y = -_viewPortY;
		}
		
		public function viewPortNoMoveUpdate(_viewPortX:int , _viewPortY:int) : void
		{
		}
		
	}
}