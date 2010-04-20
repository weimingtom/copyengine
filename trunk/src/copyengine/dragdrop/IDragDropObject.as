package copyengine.dragdrop
{
	public interface IDragDropObject
	{
		/**
		 *  dragDropEnd -- dragDropTerminate -- dragDropDispose
		 * are three end state of dragdrop system.
		 * when CEDragDropEngine.startDragDrop function been called , means the dragdrop has started
		 * 
		 * 1` when CEDragDropEngine.endDragDrop() function beed called , source and allTarget and receiver will
		 * 		call onDragDropEnd function . it means current dragdrop has finished
		 * 		(the dragdrop layer will still here, and send event to source/target).
		 * 
		 * 2` when CEDragDropEngine.terminateDragDrop() function been called , mean the current dragdrop has stoped.
		 * 		dragdrop layer will disappear. and not send event to source/target.
		 *     (drapdrop system still hold in memory , and wait for next time call);
		 * 
		 * 3` when CEDragDropEngine.disposeDragDrop() function been called. will remove all dragdrop system form memory.
		 * 
		 * WARNINIG::
		 * 		when change IDragdropTarget during each time dragdrop also will call IDragDropTarget.onDragDropDispose(); 
		 * 
		 * 
		 */		
		function onDragDropEnd():void;
		function onDragDropTerminate():void;
		function onDragDropDispose():void;
		
		/**
		 * bind an entity to current dragDropObject .
		 * dragdropOjbect only warp the entity , in dragdrop system , on the dragdropObject can respond input device event, other's can't.
		 */		
		function bindEntity(_entity:Object , _x: Number, _y: Number): void;
		
		/**
		 *  get the really entity object
		 */		
		function getEntity():Object;
	}
}