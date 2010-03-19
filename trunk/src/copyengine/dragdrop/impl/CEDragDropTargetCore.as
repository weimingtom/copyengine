package copyengine.dragdrop.impl
{
	import copyengine.dragdrop.IDragDropEngine;
	import copyengine.dragdrop.IDragDropSource;
	import copyengine.dragdrop.IDragDropTarget;

	public class CEDragDropTargetCore implements IDragDropTarget
	{
		/**
		 * hold the real object
		 */
		protected var entity:Object;

		/**
		 * hold  reference of dragdorpEngine.
		 *
		 * WARNINIG::
		 *
		 * target class need to call
		 * dragDropEngine.confirmSourceDrop(boolean);
		 * when it confim the source drop.
		 */
		protected var dragDropEngine:IDragDropEngine;

		public function CEDragDropTargetCore()
		{
		}

		final public function set engine(_engine:IDragDropEngine) : void
		{
			dragDropEngine
		}

		final public function bindEntity(_entity:Object, _x:Number, _y:Number) : void
		{
			entity = _entity;
			doBindEntity(_x,_y);
		}

		final public function getEntity() : Object
		{
			return entity
		}

		//======================
		//== Public OverrideAble Function
		//======================
		public function onSourceEnter(_source:IDragDropSource) : void
		{
		}

		public function onSourceLeave(_source:IDragDropSource) : void
		{
		}

		public function onSourceMove(_source:IDragDropSource, _x:Number, _y:Number) : void
		{
		}

		public function onSourceDrop(_source:IDragDropSource, _x:Number, _y:Number) : void
		{
		}

		public function get uniqueName() : String
		{
			return null;
		}

		public function onDragDropEnd():void
		{
		}

		public function onDragDropTerminate():void
		{
			dragDropEngine = null;
		}

		//===============
		//== Protected Function
		//===============
		/**
		 * call when bindEntity , if child class need to some things during that time
		 * should override this function.
		 */
		protected function doBindEntity(_x:Number , _y:Number) : void
		{
		}
	}
}