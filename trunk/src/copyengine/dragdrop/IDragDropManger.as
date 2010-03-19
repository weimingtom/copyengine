package copyengine.dragdrop
{
	import flash.display.DisplayObjectContainer;

	/**
	 * DragDropManger is use to interact with inputDevice(Mouse/Keyboard),
	 * each type Manger will have there own interact logic , but finally those respond will convert
	 * to DragDropEngine function. so that DragDropEngine can understand how to deal with it.
	 *
	 * @author Tunied
	 *
	 */
	public interface IDragDropManger
	{
		/**
		 * initialize DragDropManger , should call this function before any other function
		 *
		 * @param _layer 			DragDropManger will stop any other inputDevice event ,
		 * 									so need to set system in an independent layer ,
		 * 									and this layer should higer than other IDragDropTarget layer.
		 *
		 * @param _engine
		 */
		function initialize(_layer:DisplayObjectContainer , _engine:IDragDropEngine) : void;
		
		/**
		 * call by dragdropEngine to terminate the dragdrop system.
		 * it will not terminate immediately , it will terminate in next tick ,
		 * so that this function can avoide invocation stack error
		 * (
		 *   call lineA
		 *         -->terminateDragDrop();
		 *   call lineB
		 *
		 *  lineB maybe need to operate some property but already dispose by terminateDragDrop() function.
		 * )
		 */
		function terminateDragDrop() : void;
		
		/**
		 *	set drapDropTarget for current source.
		 * proxy functon of engine.setDragDropTargets();
		 */		
		function setDragDropTargets(_targets:Vector.<IDragDropTarget>):void;
		
		/**
		 * start the dragdrop system .
		 * this will only cause dragdrop system start to managed all inputDevice,
		 * but not mean it will strat the reall dragdrop system immediately.
		 *
		 * @param _source		the source that need to be drag and drop
		 * @param _x
		 * @param _y
		 */
		function startDragDrop(_source:IDragDropSource ,_x:Number , _y:Number) : void;
		
		
		/**
		 * call by IDragDropEngine when it receive current dragDrop finished, can not call directly.
		 */
		function endDragDrop() : void


	}
}