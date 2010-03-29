package copyengine.scenes.isometric
{
	import copyengine.scenes.isometric.viewport.IViewPortListener;
	import copyengine.utils.Random;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

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
	public final class IsoFloorManger implements IViewPortListener
	{
		private var isoFloor:IsoFloor;
		
		private var floorMangerContainer:DisplayObjectContainer
		
		private var testSprite:Sprite; //Test User will delete
		
		public function IsoFloorManger()
		{
		}

		public function initialize(_isoFloor:IsoFloor , _viewPortWidth:int , _viewPortHeight:int) : void
		{
			floorMangerContainer = new Sprite();
			
			testSprite = new Sprite();
			floorMangerContainer.addChild(testSprite);
			testSprite.graphics.beginFill(Random.color());
			testSprite.graphics.drawRect(0,0,600,600);
			testSprite.graphics.endFill();
		}

		public function dispose() : void
		{

		}

		public function get container() : DisplayObjectContainer
		{
			return floorMangerContainer;
		}

		public function NoMoveUpdate(_viewPortX:int , _viewPortY:int) : void
		{

		}

		public function MoveToUpdate(_viewPortX:int ,_viewPortY:int , _preViewPortX:int , _preViewPortY:int) : void
		{
			testSprite.x += _viewPortX - _preViewPortX;
			testSprite.y += _viewPortY - _preViewPortY;
		}

	}
}