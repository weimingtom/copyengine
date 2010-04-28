package copyengine.dragdrop
{

	/**
	 *DragDropEngine is dragdrop system kernel class , it contain the flow of an drag-drop event.
	 *
	 * 1` this calss is mediator of IDragDropSource & IDragDropTarget Class
	 * 2` the class job is make sure IDragDropSource & IDragDropTarget call at right order.
	 * 3` this class not contain any interact part work , those shoud care by IDragManger,this class will
	 * 		direct call by that class.
	 *
	 * @author Tunied
	 *
	 */
	public interface IDragDropEngine
	{
		/**
		 *  hold an reference of current dragDropManger
		 *
		 * should call before startDragDrop;
		 */
		function set manger(_manger:IDragDropManger) : void;
		
		/**
		 *add one target to current dragdrop system. if current system already have one target with the same targetType
		 * will automatic remove the old target, and add the new target in.
		 */		
		function addDragDropTarget(_target:IDragDropTarget):void;
		
		/**
		 * remove target from current dragdrop system by targetType
		 * WARNINIG::
		 * 		DO NOT need to call this function before call addDragDropTarget();
		 */		
		function removeDragDropTargetsByType(_type:String):void;
		
		/**
		 * Start drag-drop
		 * will call by IDragDropManger , before that , it need to create an dropSource
		 *
		 * @param _source          current target
		 * @param _x				   define where the drag begine (global point)
		 * @param _y				   define where the drag begine (global point)
		 */
		function startDragDrop(_source:IDragDropSource , _x:Number , _y:Number) : void;

		/**
		 * move dropSource
		 * call by IDragDropManger , this class need to care
		 * why the dropSource move (maybe user move the mouse , or maybe user click the keyboard etc), those things shoud care
		 * by IDragDropManger.
		 * it call only need to deal the logic during  the dropSource Move
		 */
		function move(_x:Number , _y:Number) : void;

		/**
		 * drop target at current position
		 */
		function dropTarget(_x:Number , _y:Number) : void;

		/**
		 * @private
		 * call by dragdrop target , when target confirm has been droped , normally this will call immediately
		 * but in some special condition , it will call later(ex: need to popup an panel to ask user , is confirm or not).
		 */
		function confirmSourceDrop(_isAccepted:Boolean) : void;

		/**
		 * call by IDragDropSource/IDragDropTarget when dragDrop finished.
		 */
		function endDragDrop() : void;

		/**
		 * call by dragDropSource/dragDropTarget  to terminate the dragdrop system.
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
		 * call by IDragDropManger to dispose dragdrop system.
		 */
		function onDragDropDispose() : void;


	}
}