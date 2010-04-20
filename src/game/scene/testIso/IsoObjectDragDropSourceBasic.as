package game.scene.testIso
{
	import copyengine.dragdrop.IDragDropTarget;
	import copyengine.dragdrop.impl.CEDragDropSourceCore;
	import copyengine.scenes.isometric.IsoObjectDisplayManger;
	import copyengine.scenes.isometric.IsoTileVoManger;
	import copyengine.utils.GeneralUtils;
	
	import flash.display.DisplayObject;

	public class IsoObjectDragDropSourceBasic extends CEDragDropSourceCore
	{

		protected var dragDropIcon:DisplayObject;

		public function IsoObjectDragDropSourceBasic()
		{
			super();
		}
		
		override public function onDragDropBegin(_target:IDragDropTarget, _x:Number, _y:Number):void
		{
			onMove(_target,_x,_y_);
		}
		
		override public function onMove(_target:IDragDropTarget, _x:Number, _y:Number) : void
		{
			if (_target == null || !(_target is ViewPortDragDropTargetBasic))
			{
				dragDropIconContainer.x = _x;
				dragDropIconContainer.y = _y;
			}
		}

		override public function onEnterTarget(_target:IDragDropTarget) : void
		{
			if (_target is ViewPortDragDropTargetBasic)
			{
				//avoide onEnterTarget/onLeaveTarget function not call absolute order
				//maybe user change the webBrowser can change back.
				GeneralUtils.removeTargetFromParent(dragIcon);
			}
		}

		override public function onLeaveTarget(_target:IDragDropTarget) : void
		{
			if (_target is ViewPortDragDropTargetBasic)
			{
				dragDropIconContainer.addChild(boxIcon);
			}
		}
		
		//child class need to override this function
		override protected function initializeDragDropIcon() : void
		{
			boxIcon = ResUtlis.getSprite("Tile_Red" ,ResUtlis.FILE_ISOHAX);
			dragDropIconContainer.addChild(boxIcon);
		}

		override public function onDragDropTerminate() : void
		{
			GeneralUtils.removeTargetFromParent(dragDropIcon);
		}

	}
}