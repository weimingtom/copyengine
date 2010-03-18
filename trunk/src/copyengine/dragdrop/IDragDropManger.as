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
		 * start the dragdrop system .
		 * this will only cause dragdrop system start to managed all inputDevice,
		 * but not mean it will strat the reall dragdrop system immediately.
		 *
		 * @param _source		the source that need to be drag and drop
		 * @param _x				
		 * @param _y			
		 */
		function startDragDrop(_source:IDragDropSource , _x:Number , _y:Number) : void;

		/**
		 *add or remove the DragDropTarget that interest current source.
		 */
		function addDragDropTarget(_target:IDragDropTarget) : void;
		function removeDragDropTarget(_targetName:String) : void;


	}
}