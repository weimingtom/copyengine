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
		private var dragDropReceiverList:Vector.<IDragDropReceiver>;

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
					dragDropTargetList[0].onDragDropTerminate();
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
			currentSource.onDragDropBegin(_x,_y);

			move(_x,_y);
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
			GlobalTick.instance.callLaterAfterTickCount(doEndDragDrop);
		}

		public function terminateDragDrop() : void
		{
			currentSource.onDragDropTerminate();

			while (dragDropTargetList.length > 0)
			{
				dragDropTargetList.pop().onDragDropTerminate();
			}

			// dragDropReceiverList can be null 
			// beacuse it will  add/remove dynamic
			if (dragDropReceiverList != null)
			{
				while (dragDropReceiverList.length > 0)
				{
					dragDropReceiverList.pop().onDragDropTerminate();
				}
			}

			currentTarget = null;
			currentSource = null;
			dragDropTargetList = null;
			dragDropReceiverList = null;
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

		private function doEndDragDrop() : void
		{
			currentSource.onDragDropEnd();

			for (var i:int = 0 ; i < dragDropTargetList.length ; i++)
			{
				dragDropTargetList[i].onDragDropEnd();
			}
			// dragDropReceiverList can be null 
			// beacuse it will  add/remove dynamic
			if (dragDropReceiverList != null)
			{
				while (dragDropReceiverList.length > 0)
				{
					dragDropReceiverList.pop().onDragDropTerminate();
				}
			}
			dragDropManger.endDragDrop();
		}

	}
}