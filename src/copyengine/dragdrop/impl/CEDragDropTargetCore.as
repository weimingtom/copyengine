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
			dragDropEngine = _engine;
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
		
		final public function onDragDropDispose():void
		{
			doDragDropDispose();
			dragDropEngine = null;
			entity = null;
		}

		//======================
		//== Public OverrideAble Function
		//======================
		public function onDragDropBegin(_source:IDragDropSource , _x:Number , _y:Number):void
		{
		}
		
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

		public function onDragDropEnd():void
		{
		}

		public function onDragDropTerminate():void
		{
		}
		
		public function isPositionInTarget(_posX:Number , _posY:Number):Boolean
		{
			return false;
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
		
		protected function doDragDropDispose():void
		{
		}
		
	}
}