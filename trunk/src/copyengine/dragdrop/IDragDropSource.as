package copyengine.dragdrop
{

	public interface IDragDropSource extends IDragDropObject
	{
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
		function onDropConfim(_target:IDragDropTarget , _isAccepted:Boolean):void

	}
}