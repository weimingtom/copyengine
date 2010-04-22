package copyengine.dragdrop.impl
{
	import copyengine.dragdrop.IDragDropEngine;
	import copyengine.dragdrop.IDragDropManger;
	import copyengine.dragdrop.IDragDropReceiver;
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

		protected var dragDropReceiverList:Vector.<IDragDropReceiver>;
		
		/**
		 * for now only use on attribute to recorder current target .
		 * that is assume at each point only contain one target. if at point have more target 
		 * then change the receiver to vector.
		 */		
		protected var currentReceiver:IDragDropReceiver;
		
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
			if (dragDropReceiverList != null)
			{
				for (var i:int = 0 ; i < dragDropReceiverList.length ; i++)
				{
					dragDropReceiverList[i].onDragDropEnd();
				}
			}
		}

		final public function onTerminateDragDrop() : void
		{
			layer.visible = false;
			removeListener();
			GeneralUtils.removeTargetFromParent(dragdropSourceIcon);
			if (dragDropReceiverList != null)
			{
				for (var i:int = 0 ; i < dragDropReceiverList.length ; i++)
				{
					dragDropReceiverList[i].onDragDropTerminate();
				}
			}
		}

		final public function disposeDragDrop() : void
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

		final public function setDragDropReceiver(_receivers:Vector.<IDragDropReceiver>) : void
		{
			if (dragDropReceiverList != null)
			{
				while (dragDropReceiverList.length > 0)
				{
					dragDropReceiverList.pop().onDragDropDispose();
				}
			}
			dragDropReceiverList = _receivers;
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

		protected function onMouseDown(e:MouseEvent) : void
		{
		}

		protected function onMouseUp(e:MouseEvent) : void
		{
		}

		//=============
		//==Private
		//=============
		
		private function findReceiverAtPoint(_x:Number,_y:Number):IDragDropReceiver
		{
			if(dragDropReceiverList != null)
			{
				for(var i:int = 0 ; i < dragDropReceiverList.length ; i++)
				{
					if( dragDropReceiverList[i].isPositionInTarget(_x,_y) )
					{
						return dragDropReceiverList[i];
					}
				}
			}
			return null;
		}
		
		private function addListener() : void
		{
			GeneralUtils.addTargetEventListener(layer , MouseEvent.MOUSE_MOVE , parentOnMouseMove );
			GeneralUtils.addTargetEventListener(layer , MouseEvent.MOUSE_DOWN , parentOnMouseDown );
			GeneralUtils.addTargetEventListener(layer , MouseEvent.MOUSE_UP , parentOnMouseUp );
		}

		private function removeListener() : void
		{
			GeneralUtils.removeTargetEventListener(layer , MouseEvent.MOUSE_MOVE , parentOnMouseMove );
			GeneralUtils.removeTargetEventListener(layer , MouseEvent.MOUSE_DOWN , parentOnMouseDown );
			GeneralUtils.removeTargetEventListener(layer , MouseEvent.MOUSE_UP , parentOnMouseUp );
		}

		private function parentOnMouseDown(e:MouseEvent) : void
		{
			stopEvent(e);
			if(currentReceiver != null)
			{
				currentReceiver.onMouseDown(e);
			}
			onMouseDown(e);
		}

		private function parentOnMouseUp(e:MouseEvent) : void
		{
			stopEvent(e);
			if(currentReceiver != null)
			{
				currentReceiver.onMouseUp(e);
			}
			onMouseUp(e);
		}

		private function parentOnMouseMove(e:MouseEvent) : void
		{
			stopEvent(e);
			
			var newReceiver:IDragDropReceiver = findReceiverAtPoint(e.stageX,e.stageY);
			if (currentReceiver != newReceiver)
			{
				if (currentReceiver != null)
				{
					currentReceiver.onMouseRollOut(e);
				}
				if (newReceiver != null)
				{
					newReceiver.onMouseRollOver(e);
				}
			}
			else
			{
				if (currentReceiver != null)
				{
					currentReceiver.onMouseMove(e);
				}
			}
			currentReceiver = newReceiver;
			
			onMouseMove(e);
		}

		private function stopEvent(e:MouseEvent) : void
		{
			e.stopImmediatePropagation();
		}

	}
}