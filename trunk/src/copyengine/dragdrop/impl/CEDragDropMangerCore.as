package copyengine.dragdrop.impl
{
	import copyengine.dragdrop.IDragDropEngine;
	import copyengine.dragdrop.IDragDropManger;
	import copyengine.dragdrop.IDragDropSource;
	import copyengine.dragdrop.IDragDropTarget;
	import copyengine.utils.GeneralUtils;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class CEDragDropMangerCore implements IDragDropManger
	{
		protected var layer:DisplayObjectContainer;
		protected var engine:IDragDropEngine;
		protected var dragDropTargetList:Vector.<IDragDropTarget>;

		protected var dragdropSourceIcon:DisplayObject

		public function CEDragDropMangerCore()
		{
		}

		final public function initialize(_layer:DisplayObjectContainer, _engine:IDragDropEngine) : void
		{
			layer = _layer;
			engine = _engine;
			dragDropTargetList = new Vector.<IDragDropTarget>();
		}

		final public function startDragDrop(_source:IDragDropSource , _x:Number , _y:Number) : void
		{
			addListener();

			//manger only put this icon on stage ,not respond for it move.
			dragdropSourceIcon = _source.createDragIcon();
			if (dragdropSourceIcon != null)
			{
				layer.addChild(dragdropSourceIcon);
			}
			doStartDragDrop(_source,_x,_y);
		}

		final public function addDragDropTarget(_target:IDragDropTarget) : void
		{
			dragDropTargetList.push(_target);
		}

		final public function removeDragDropTarget(_targetName:String) : void
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

		final public function terminateDragDrop() : void
		{
			removeListener();
			GeneralUtils.removeTargetFromParent(dragdropSourceIcon);
			dragDropTargetList = null;
		}

		//==============
		//== Protected
		//==============
		protected function doStartDragDrop(_source:IDragDropSource , _x:Number , _y:Number) : void
		{
			engine.startDragDrop(_source,_x,_y,dragDropTargetList,this);
		}

		protected function onMouseMove(e:Event) : void
		{
			var mouseEvent:MouseEvent = e as MouseEvent;
			engine.move(mouseEvent.stageX,mouseEvent.stageY);
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