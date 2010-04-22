package copyengine.dragdrop.impl
{
	import copyengine.dragdrop.IDragDropEngine;
	import copyengine.dragdrop.IDragDropManger;
	import copyengine.dragdrop.IDragDropReceiver;
	import copyengine.dragdrop.IDragDropSource;
	import copyengine.dragdrop.IDragDropTarget;
	import copyengine.utils.tick.GlobalTick;

	final public class CEDragDropEngine implements IDragDropEngine
	{
		private var dragDropManger:IDragDropManger

		private var currentSource:IDragDropSource;
		private var currentTarget:IDragDropTarget;

		private var dragDropTargetList:Vector.<IDragDropTarget>;

		public function CEDragDropEngine()
		{
		}

		public function set manger(_manger:IDragDropManger) : void
		{
			dragDropManger = _manger;
		}

		public function setDragDropTargets(_targets:Vector.<IDragDropTarget>) : void
		{
			if (dragDropTargetList != null)
			{
				while (dragDropTargetList.length > 0)
				{
					dragDropTargetList[0].onDragDropDispose();
				}
			}
			dragDropTargetList = _targets;
		}


		public function startDragDrop(_source:IDragDropSource , _x:Number, _y:Number) : void
		{
			currentSource = _source;

			//dragDropTarget initialize
			for (var i:int = 0 ; i < dragDropTargetList.length ; i++)
			{
				dragDropTargetList[i].engine = this;
			}

			//dragdropSource initialize
			currentSource.engine = this;
			var target:IDragDropTarget = findTargetAtPoint(_x,_y);
			currentSource.onDragDropBegin(target , _x , _y);
			if(target != null)
			{
				target.onDragDropBegin(currentSource,_x,_y);
			}
		}

		public function move(_x:Number, _y:Number) : void
		{
			var target:IDragDropTarget = findTargetAtPoint(_x,_y);

			if (currentTarget != target)
			{
				if (currentTarget != null)
				{
					currentSource.onLeaveTarget(currentTarget);
					currentTarget.onSourceLeave(currentSource);
				}
				if (target != null)
				{
					currentSource.onEnterTarget(target);
					target.onSourceEnter(currentSource);
				}
			}
			else
			{
				if (currentTarget != null)
				{
					currentTarget.onSourceMove(currentSource,_x,_y);
				}
			}
			currentTarget = target;
			currentSource.onMove(currentTarget,_x,_y);
		}


		public function dropTarget(_x:Number, _y:Number) : void
		{
			currentSource.onDrop(currentTarget,_x,_y);
			if (currentTarget != null)
			{
				currentTarget.onSourceDrop(currentSource,_x,_y);
			}
			else
			{
				currentSource.onDragDropCancel();
			}
		}

		public function confirmSourceDrop(_isAccepted:Boolean) : void
		{
			currentSource.onDropConfim(currentTarget,_isAccepted);
			endDragDrop();
		}

		public function endDragDrop() : void
		{
			currentSource.onDragDropEnd();
			
			for (var i:int = 0 ; i < dragDropTargetList.length ; i++)
			{
				dragDropTargetList[i].onDragDropEnd();
			}
			
			dragDropManger.onEndDragDrop();
		}

		public function terminateDragDrop() : void
		{
			dragDropManger.onTerminateDragDrop();
			GlobalTick.instance.callLaterAfterTickCount(doTerminateDragDrop);
		}
		
		public function onDragDropDispose():void
		{
			while (dragDropTargetList.length > 0)
			{
				dragDropTargetList.pop().onDragDropDispose();
			}
			
			
			currentTarget = null;
			currentSource = null;
			dragDropTargetList = null;
		}

		public function addDragDropReceiver(_receiver:IDragDropReceiver) : void
		{
		}

		public function removeDragDropReceiver(_receiverName:String) : void
		{
		}

		//===============
		//= praivate function
		//===============
		protected function findTargetAtPoint(_x:Number , _y:Number) : IDragDropTarget
		{
			for each(var target:IDragDropTarget in dragDropTargetList)
			{
				if(target.isPositionInTarget(_x,_y))
				{
					return target;
				}
			}
			return null;
		}
		
		private function doTerminateDragDrop():void
		{
			currentSource.onDragDropTerminate();
			
			for(var i:int = 0 ; i < dragDropTargetList.length ; i++)
			{
				dragDropTargetList[i].onDragDropTerminate();
			}
		}

	}
}