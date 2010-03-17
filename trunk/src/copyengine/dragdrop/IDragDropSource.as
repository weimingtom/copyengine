package copyengine.dragdrop
{
	public interface IDragDropSource
	{
		function onEnterTarget(_target:IDragDropTarget):void;
		function onLeaveTarget(_target:IDragDropTarget):void;
		function onMove(_target:IDragDropTarget):void;
		function onAccepted(_target:IDragDropTarget):void;
		function onUnAccepted(_target:IDragDropTarget):void;
		function onDragDropEnd();
		
		function bindEntity(entity:Object , _x: Number, _y: Number): void;
		function getEntity():Object;
	}
}