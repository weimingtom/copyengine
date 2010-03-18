package copyengine.dragdrop.impl
{
	import copyengine.dragdrop.IDragDropEngine;
	import copyengine.dragdrop.IDragDropManger;
	import copyengine.dragdrop.IDragDropReceiver;
	import copyengine.dragdrop.IDragDropSource;
	import copyengine.dragdrop.IDragDropTarget;
	import copyengine.utils.tick.GlobalTick;

	public class CEDragDropEngine implements IDragDropEngine
	{

		private var manger:IDragDropManger

		private var currentSource:IDragDropSource;
		private var currentTarget:IDragDropTarget;

		private var dragDropTargetList:Vector.<IDragDropTarget>;
		private var dragDropReceiverList:Vector.<IDragDropReceiver>;

		public function CEDragDropEngine()
		{
		}

		public function startDragDrop(_source:IDragDropSource, _x:Number, _y:Number, _targets:Vector.<IDragDropTarget>, _manger:IDragDropManger) : void
		{
			currentSource = _source;
			dragDropTargetList = _targets
			manger = _manger;
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
		}

		public function confirmSourceDrop(_isAccepted:Boolean) : void
		{
			currentSource.onDropConfim(currentTarget,_isAccepted);
			endDragDrop();
		}

		public function endDragDrop() : void
		{
			currentSource.onDragDropEnd();
			if (currentTarget != null)
			{
				currentTarget.onDragDropEnd();
			}
		}

		public function terminateDragDrop() : void
		{
			GlobalTick.instance.callLaterAfterTickCount(doTerminateDragDrop);
		}

		public function addDragDropReceiver(_receiver:IDragDropReceiver) : void
		{
		}

		public function removeDragDropReceiver(_receiverName:String) : void
		{
		}

		//===============
		//= protected function
		//===============
		protected function findTargetAtPoint(_x:Number , _y:Number) : IDragDropTarget
		{

		}

		protected function doTerminateDragDrop():void
		{
			currentSource.onDragDropTerminate();
			if (currentTarget != null)
			{
				currentTarget.onDragDropTerminate();
			}
		}


	}
}