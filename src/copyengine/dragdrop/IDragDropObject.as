package copyengine.dragdrop
{
	public interface IDragDropObject
	{
		/**
		 * each type dragdrop object will have there own uniqueName , so that other dragDrop target can know it's type.
		 */		
		function get uniqueName():String;
		
		/**
		 * call when current dragdrop end.
		 */		
		function onDragDropEnd():void;
		
		/**
		 * call when dragdrop system terminate
		 */		
		function onDragDropTerminate():void;
		
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