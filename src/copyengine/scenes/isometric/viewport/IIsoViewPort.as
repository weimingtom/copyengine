package copyengine.scenes.isometric.viewport
{
	import flash.display.DisplayObjectContainer;

	/**
	 * IIsoViewPort is use in isometric scene ,
	 * viewport like a window , thorw the window you can see part of the isometric word , but not all.
	 * the object out of the viewport will be frustum culling(@see more on IsoFloorManger , IsoObjectManger).
	 *
	 * and all object display in the viewport will cache as bitmap, for the fast speed.
	 * so basically the screen update need call manually
	 *
	 * @author Tunied
	 *
	 */
	public interface IIsoViewPort
	{
		/**
		 *	call this function initialze IsoViewPort before use it.
		 *
		 * @param _moveSpeed				define each time call move*() function will moved distance.
		 * @param _viewPortWidth			the viewport width size
		 * @param _viewPortHeight			the viewport height size
		 *
		 */
		function initializeIsoViewPort(_moveSpeed:int ,_viewPortWidth:int , _viewPortHeight:int , 
			_screenWidth:int , _screenHeight:int) : void;

		/**
		 * viewport will be addChild to BaiseSceen.
		 * (in one CEScreen , not only need to show viewport, but also need to add other container ex: UIContainer)
		 */
		function get container() : DisplayObjectContainer;

		function getViewPortWidth() : int;
		function getViewPortHeight() : int;

		function dispose() : void;

		/**
		 * update the viewPort listener (update the viewport screen)
		 * beacuse the viewport updtae will relate to the screen display update,
		 * so can't be when user call moveUp then updateListener immediately
		 * @see more in IsoSceneBasic.tick();
		 */
		function updateListener() : void;
		function addListener(_listener:IViewPortListener) : void;
		function removeListener(_listener:IViewPortListener) : void;

		/**
		 * current math is hard to support move like moveUpLeft()
		 * for the  isometric scene is diamond shape , when the viewport at the edge, can't do that kind move.
		 * but maybe support that kind move later [TBD]
		 */
		function moveUp() : void;
		function moveDown() : void;
		function moveLeft() : void;
		function moveRight() : void;
	}
}