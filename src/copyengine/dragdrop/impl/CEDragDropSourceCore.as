package copyengine.dragdrop.impl
{
	import copyengine.dragdrop.IDragDropEngine;
	import copyengine.dragdrop.IDragDropSource;
	import copyengine.dragdrop.IDragDropTarget;

	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	/**
	 * Should only do onSourceCancel/onDropConfim but accpted logic in CEDragDropSource
	 * the accpeted logic should do in each target
	 *  
	 * @author Tunied
	 * 
	 */	
	public class CEDragDropSourceCore implements IDragDropSource
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
		 * source class should only call
		 * dragDropEngine.terminateDragDrop or dragDropEngine.endDragDrop();
		 */
		protected var dragDropEngine:IDragDropEngine;

		protected var dragDropIconContainer:Sprite;

		public function CEDragDropSourceCore()
		{
		}

		final public function set engine(_engine:IDragDropEngine) : void
		{
			dragDropEngine = _engine;
		}

		final public function createDragIcon() : DisplayObjectContainer
		{
			dragDropIconContainer = new Sprite();
			initializeDragDropIcon();
			return dragDropIconContainer;
		}
		
		final public function get dragIcon():DisplayObjectContainer
		{
			return dragDropIconContainer;
		}

		final public function bindEntity(_entity:Object, _x:Number, _y:Number) : void
		{
			entity = _entity;
			doBindEntity(_x,_y);
		}

		final public function getEntity() : Object
		{
			return entity;
		}

		//======================
		//== Public OverrideAble Function
		//======================
		public function onDragDropBegin(_target:IDragDropTarget , _x:Number , _y:Number) : void
		{
		}

		public function onEnterTarget(_target:IDragDropTarget) : void
		{
		}

		public function onLeaveTarget(_target:IDragDropTarget) : void
		{
		}

		public function onMove(_target:IDragDropTarget, _x:Number, _y:Number) : void
		{
		}

		public function onDrop(_target:IDragDropTarget, _x:Number, _y:Number) : void
		{
		}

		public function onDropConfim(_target:IDragDropTarget, _isAccepted:Boolean) : void
		{
		}
		
		/**
		 * by default , when drapdrop been cancled then terminate current dragdrop
		 * child class need to override this function ,if need do other things. 
		 */		
		public function onDragDropCancel():void
		{
			dragDropEngine.endDragDrop();
			dragDropEngine.terminateDragDrop();
		}
		
		public function onDragDropEnd():void
		{
		}
		
		public function onDragDropTerminate():void
		{
		}
		
		public final function onDragDropDispose():void
		{
			doDragDropDispose();
			dragDropIconContainer = null;
			dragDropEngine = null;
		}
		
		//===============
		//== Protected Function
		//===============
		/**
		 * initialze current source dragdropIcon.
		 */
		protected function initializeDragDropIcon() : void
		{
		}

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