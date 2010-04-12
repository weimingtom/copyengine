package copyengine.scenes.isometric.viewport
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

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
		 */
		function initializeIsoViewPort(_viewPortWidth:int , _viewPortHeight:int , _screenWidth:int , _screenHeight:int) : void;
		
		/**
		 *  call this function to statr viewPort function 
		 */		
		function viewPortStart(_viewPortX:int , _viewPortY:int):void;
		
		/**
		 * viewport will be addChild to BaiseSceen.
		 * (in one CEScreen , not only need to show viewport, but also need to add other container ex: UIContainer)
		 */
		function get container() :DisplayObjectContainer;
		
		function get currentViewPortX():int;
		function get currentViewPortY():int;
		
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
		 * move the view port to new position
		 */		
		function moveTo(_viewPortX:int , _viewPortY:int):void;
		
//		/**
//		 * current math is hard to support move like moveUpLeft()
//		 * for the  isometric scene is diamond shape , when the viewport at the edge, can't do that kind move.
//		 * but maybe support that kind move later [TBD]
//		 */
//		function moveUp() : void;
//		function moveDown() : void;
//		function moveLeft() : void;
//		function moveRight() : void;
	}
}