package copyengine.dragdrop
{

	/**
	 * DragDropReceiver is special class use in dragdrop system.
	 *  for DragDropManger will control all inputDevice event
	 *  but some displayObject maybe need reveice event during dragdrop.
	 *  so use this interface warp the displayObject ,send the event to it.
	 *  but this target can not do anything to influence drag flow.
	 *	
	 *  WARNING::
	 * 
	 * @author Tunied
	 *
	 */
	public interface IDragDropReceiver extends IDragDropObject
	{
		function onMouseRollOver() : void;
		function onMouseRollOut() : void;
		function onMouseMove(_x:Number , _y:Number) : void;
		function onMouseClick() : void;
		function onMouseDown() : void;
		function onMouseUp() : void;
	}
}