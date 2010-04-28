package game.scene.testIso.dragdrop.source
{
	import copyengine.dragdrop.IDragDropTarget;
	import copyengine.dragdrop.impl.CEDragDropSourceCore;
	import copyengine.scenes.isometric.IsoObjectDisplayManger;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import game.scene.IsoMath;
	import game.scene.testIso.dragdrop.target.IsoSceneDragDropTargetBasic;

	public class IsoSceneDragDropSourceBasic extends CEDragDropSourceCore
	{
		
		/**
		 * when icon move in IsoScene will show dragInViewPortIcon and not show dragOutViewPortIcon.
		 * WARNINIG::
		 * 		the two variable maybe refrence the same displayobject. so need to first set one visable = false and then another visable = true;
		 * 		this class do not respond for the dragInViewPortIcon/dragOutViewPortIcon dispose, child Class should do this job.
		 */		
		protected var dragInViewPortIcon:DisplayObject;
		protected var dragOutViewPortIcon:DisplayObject;
		
		
		
		public function IsoSceneDragDropSourceBasic()
		{
		}
		
		override public function onDragDropBegin(_target:IDragDropTarget, _x:Number, _y:Number) : void
		{
			if (_target is IsoSceneDragDropTargetBasic)
			{
				dragOutViewPortIcon.visible = false;
				dragInViewPortIcon.visible = true;
				sourceMoveInScene(_x,_y);
			}
			else
			{
				dragInViewPortIcon.visible = false;
				dragOutViewPortIcon.visible = true;
				sourceMoveInOther(_x,_y);
			}
		}
		
		override public function onMove(_target:IDragDropTarget, _x:Number, _y:Number) : void
		{
			if (_target is IsoSceneDragDropTargetBasic)
			{
				sourceMoveInScene(_x,_y);
			}
			else
			{
				sourceMoveInOther(_x,_y);
			}
		}
		
		protected function sourceMoveInScene(_x:Number , _y:Number) : void
		{
		}
		
		/**
		 * call when source not move in isoScene
		 */
		protected function sourceMoveInOther(_x:Number , _y:Number) : void
		{
			dragDropIconContainer.x = _x;
			dragDropIconContainer.y = _y;
		}
		
		override public function onEnterTarget(_target:IDragDropTarget) : void
		{
			if (_target is IsoSceneDragDropTargetBasic)
			{
				dragOutViewPortIcon.visible = false;
				dragInViewPortIcon.visible = true;
			}
		}
		
		override public function onLeaveTarget(_target:IDragDropTarget) : void
		{
			if (_target is IsoSceneDragDropTargetBasic)
			{
				dragInViewPortIcon.visible = false;
				dragOutViewPortIcon.visible = true;
			}
		}

		
	}
}