package copyengine.dragdrop.impl
{
	import copyengine.dragdrop.IDragDropEngine;
	import copyengine.dragdrop.IDragDropManger;
	import copyengine.dragdrop.IDragDropSource;
	import copyengine.dragdrop.IDragDropTarget;
	import copyengine.utils.GeneralUtils;

	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class CEDragDropMangerCore implements IDragDropManger
	{

		private var layer:DisplayObjectContainer;
		private var engine:IDragDropEngine;
		private var dragDropTargetList:Vector.<IDragDropTarget>;

		public function CEDragDropMangerCore()
		{
		}

		public function initialize(_layer:DisplayObjectContainer, _engine:IDragDropEngine) : void
		{
			layer = _layer;
			engine = _engine;
			dragDropTargetList = new Vector.<IDragDropTarget>();
			addListener();
		}

		public function startDragDrop(_source:IDragDropSource , _x:Number , _y:Number) : void
		{
		}

		public function addDragDropTarget(_target:IDragDropTarget) : void
		{
			dragDropTargetList.push(_target);
		}

		public function removeDragDropTarget(_targetName:String) : void
		{
			for (var i:int = 0 ; i < dragDropTargetList.length ; i++)
			{
				if (_targetName == dragDropTargetList[i].uniqueName)
				{
					dragDropTargetList.splice(i,1);
					return;
				}
			}
		}
		
		public function terminateDragDrop() : void
		{
			removeListener();
			dragDropTargetList = null;
		}

		//==============
		//== Protected
		//==============
		protected function onMouseMove(e:Event) : void
		{
		}

		protected function onMouseClick(e:Event) : void
		{
		}

		protected function onMouseDown(e:Event) : void
		{
		}

		protected function onMouseUp(e:Event) : void
		{
		}

		//=============
		//==Private
		//=============
		private function addListener() : void
		{
			GeneralUtils.addTargetEventListener(layer , MouseEvent.CLICK , parentOnMouseClick );
			GeneralUtils.addTargetEventListener(layer , MouseEvent.MOUSE_MOVE , parentOnMouseMove );
			GeneralUtils.addTargetEventListener(layer , MouseEvent.MOUSE_DOWN , parentOnMouseDown );
			GeneralUtils.addTargetEventListener(layer , MouseEvent.MOUSE_UP , parentOnMouseUp );
		}

		private function removeListener() : void
		{
			GeneralUtils.removeTargetEventListener(layer , MouseEvent.CLICK , parentOnMouseClick );
			GeneralUtils.removeTargetEventListener(layer , MouseEvent.MOUSE_MOVE , parentOnMouseMove );
			GeneralUtils.removeTargetEventListener(layer , MouseEvent.MOUSE_DOWN , parentOnMouseDown );
			GeneralUtils.removeTargetEventListener(layer , MouseEvent.MOUSE_UP , parentOnMouseUp );
		}

		private function parentOnMouseDown(e:Event) : void
		{
			stopEvent(e);
			onMouseDown(e);
		}

		private function parentOnMouseUp(e:Event) : void
		{
			stopEvent(e);
			onMouseUp(e);
		}

		private function parentOnMouseClick(e:Event) : void
		{
			stopEvent(e)
			onMouseClick(e);
		}

		private function parentOnMouseMove(e:Event) : void
		{
			stopEvent(e);
			onMouseMove(e);
		}

		private function stopEvent(e:Event) : void
		{
			e.stopImmediatePropagation();
		}

	}
}