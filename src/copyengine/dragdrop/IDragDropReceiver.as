package copyengine.dragdrop
{
	import flash.events.MouseEvent;

	/**
	 * DragDropReceiver is special class use in dragdrop system.
	 *  for DragDropManger will control all inputDevice event
	 *  but some displayObject maybe need reveice event during dragdrop.
	 *  so use this interface warp the displayObject ,send the event to it.
	 *  but this target CAN NOT DO anything to influence drag flow.
	 *	
	 *  WARNING::
	 * 			Not Finished , Will Support Later
	 * 
	 * @author Tunied
	 *
	 */
	public interface IDragDropReceiver extends IDragDropObject
	{
		function onMouseRollOver(e:MouseEvent) : void;
		function onMouseRollOut(e:MouseEvent) : void;
		function onMouseMove(e:MouseEvent) : void;
		function onMouseDown(e:MouseEvent) : void;
		function onMouseUp(e:MouseEvent) : void;
		
		/**
		 * use this function to caulate is current position(global system) in receiver or not.
		 * use in CEDragDropMangerCore.findTargetAtPoint() function
		 */		
		function isPositionInTarget(_posX:Number , _posY:Number):Boolean
		
	}
}