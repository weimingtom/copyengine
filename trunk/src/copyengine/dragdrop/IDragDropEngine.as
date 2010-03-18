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
		 * Start drag-drop
		 * will call by IDragDropManger , before that , it need to create an dropSource
		 * and also initialize all dropTarget that interested current dropSource.
		 *
		 * @param _source          current target
		 * @param _x				   define where the drag begine (global point)
		 * @param _y				   define where the drag begine (global point)
		 * @param _targets         all dropTargets(dropSource only can drop into dropTarge)
		 * @param _manger		   hold an reference of current dragDropManger
		 */
		function startDragDrop(_source:IDragDropSource ,_x:Number , _y:Number , 
							   _targets:Vector.<IDragDropTarget> ,_manger:IDragDropManger) : void;

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
		 * call by IDragDropManger when dragDrop finished, can not call directly.
		 */
		function endDragDrop() : void;

		/**
		 * call by dragdropManger/dragDropSource/dragDropTarget  to terminate the dragdrop system.
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
		function terminateDragDrop() : void

		/**
		 * call by dragdropSource/dragdropTarget , add or remove an temporary receiver.
		 * @see more on IDragDropReceiver.
		 */
		function addDragDropReceiver(_receiver:IDragDropReceiver) : void;
		function removeDragDropReceiver(_receiverName:String) : void;

	}
}