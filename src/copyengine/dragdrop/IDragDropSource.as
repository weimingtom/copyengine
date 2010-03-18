package copyengine.dragdrop
{
	import flash.display.DisplayObject;

	public interface IDragDropSource extends IDragDropObject
	{
		
		/**
		 * each dragTarget need to hold an engine reference , when engine call onSourceDrop(),
		 * it can call engine.confirmSourceDrop(boolean) back.
		 */
		function set engine(_engine:IDragDropEngine) : void;
		
		/**
		 * call when the dragdrop system begin.
		 */
		function onDragDropBegin(_x:Number , _y:Number) : void;
		
		/**
		 * this dragIcon will display in dragMangerLayer, and remove automatic when dragDrop system terminate.
		 * this function only call once when the the dragdrop begin(it will call before onDragDropBegin funtion.)
		 */
		function createDragIcon() : DisplayObject;
		
		/**
		 * call when enter an dragdrop target like mouseRollOver
		 */
		function onEnterTarget(_target:IDragDropTarget) : void;

		/**
		 * call when leave an dragdrop target like mouseRollOut
		 */
		function onLeaveTarget(_target:IDragDropTarget) : void;

		/**
		 * call when source move , if source not move in dropTraget ,then the _target property is null
		 */
		function onMove(_target:IDragDropTarget , _x:Number , _y:Number) : void;

		/**
		 * it will call in DragEngine.dropTarget() function .
		 * but should not do any logic in this function/beacuse at that time this source is not been accepted or unAccpted.
		 * if _target property is emptey means, drop with no target.
		 *
		 */
		function onDrop(_target:IDragDropTarget , _x:Number , _y:Number) : void;

		/**
		 * call by dragDropTarget when this source has been accepted/unaccepted (drop successed).
		 */
		function onDropConfim(_target:IDragDropTarget , _isAccepted:Boolean) : void

	}
}