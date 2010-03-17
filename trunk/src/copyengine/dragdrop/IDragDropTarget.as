package copyengine.dragdrop
{

	public interface IDragDropTarget
	{
		function onEnter(_source:IDragDropSource) : void;
		function onLeave(_source:IDragDropSource) : void;
		function onMove(_source:IDragDropSource) : void;
		function onDrop(_source:IDragDropSource) : void;
		function onDrapDropEnd();
		
		function bindEntity(entity:Object , _x: Number, _y: Number): void;
		function getEntity():Object;
	}
}