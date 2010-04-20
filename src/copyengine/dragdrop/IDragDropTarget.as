package copyengine.dragdrop
{

	public interface IDragDropTarget extends IDragDropObject
	{
		/**
		 * each dragTarget need to hold an engine reference , when engine call onSourceDrop(),
		 * it can call engine.confirmSourceDrop(boolean) back.
		 */
		function set engine(_engine:IDragDropEngine) : void;
		
		/**
		 * call when begin dragdrop
		 */		
		function onDragDropBegin(_source:IDragDropSource , _x:Number , _y:Number):void;
		
		/**
		 * call when dragSource move into target like roll over.
		 */
		function onSourceEnter(_source:IDragDropSource) : void;

		/**
		 * call when dragSource move out target like roll out.
		 */
		function onSourceLeave(_source:IDragDropSource) : void;

		/**
		 * when source move in target will call this function , the x, y is the position in global coordinates .
		 */
		function onSourceMove(_source:IDragDropSource , _x:Number ,_y:Number) : void;

		/**
		 * when source drop in current target will call this function ,
		 * this target need to decide accpeted this source or not.
		 * when it decided , then call  engine.confirmSourceDrop(boolean) back.
		 */
		function onSourceDrop(_source:IDragDropSource , _x:Number , _y:Number) : void;
		
		/**
		 * use this function to caulate is current position(global system) in target or not.
		 * use in CEDragDropEngine.findTargetAtPoint() function
		 */		
		function isPositionInTarget(_posX:Number , _posY:Number):Boolean
	}
}