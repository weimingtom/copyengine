package copyengine.dragdrop.impl
{
	import copyengine.dragdrop.IDragDropEngine;
	import copyengine.dragdrop.IDragDropManger;
	import copyengine.dragdrop.IDragDropSource;
	import copyengine.dragdrop.IDragDropTarget;
	import copyengine.utils.GeneralUtils;
	import copyengine.utils.Random;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class CEDragDropMangerCore implements IDragDropManger
	{
		protected var layer:DisplayObjectContainer;
		protected var engine:IDragDropEngine;

		protected var dragdropSourceIcon:DisplayObjectContainer

		public function CEDragDropMangerCore()
		{
		}

		final public function initialize(_layer:DisplayObjectContainer, _engine:IDragDropEngine) : void
		{
			layer = _layer;
			layer.mouseChildren = false; // layer child can not respond mouse event
			
			engine = _engine;
			engine.manger = this;
			
			var g:Graphics = (layer as Sprite).graphics;
			g.beginFill(0,0);
			g.drawRect(0,0,layer.stage.stageWidth, layer.stage.stageHeight);
			g.endFill();

			layer.visible = false;
		}

		final public function startDragDrop(_source:IDragDropSource,_x:Number , _y:Number) : void
		{
			layer.visible = true;

			addListener();

			//manger only put this icon on stage ,not respond for it move.
			dragdropSourceIcon = _source.createDragIcon();
			if (dragdropSourceIcon != null)
			{
				layer.addChild(dragdropSourceIcon);
			}
			doStartDragDrop(_source,_x,_y);
		}
		
		final public function onEndDragDrop() : void
		{
		}
		
		final public function onTerminateDragDrop() : void
		{
			layer.visible = false;
			removeListener();
			GeneralUtils.removeTargetFromParent(dragdropSourceIcon);
		}
		
		final public function disposeDragDrop():void
		{
			engine.
			(layer as Sprite).graphics.clear();
			engine = null;
			layer = null;
			dragdropSourceIcon = null;
		}
		
		final public function setDragDropTargets(_targetList:Vector.<IDragDropTarget>) : void
		{
			engine.setDragDropTargets(_targetList);
		}
		
		//==============
		//== Protected
		//==============
		protected function doStartDragDrop(_source:IDragDropSource ,_x:Number , _y:Number) : void
		{
			engine.startDragDrop(_source,_x,_y);
		}

		protected function onMouseMove(e:MouseEvent) : void
		{
			engine.move(e.stageX,e.stageY);
		}

		protected function onMouseClick(e:MouseEvent) : void
		{
		}

		protected function onMouseDown(e:MouseEvent) : void
		{
		}

		protected function onMouseUp(e:MouseEvent) : void
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

		private function parentOnMouseDown(e:MouseEvent) : void
		{
			stopEvent(e);
			onMouseDown(e);
		}

		private function parentOnMouseUp(e:MouseEvent) : void
		{
			stopEvent(e);
			onMouseUp(e);
		}

		private function parentOnMouseClick(e:MouseEvent) : void
		{
			stopEvent(e)
			onMouseClick(e);
		}

		private function parentOnMouseMove(e:MouseEvent) : void
		{
			stopEvent(e);
			onMouseMove(e);
		}

		private function stopEvent(e:MouseEvent) : void
		{
			e.stopImmediatePropagation();
		}

	}
}