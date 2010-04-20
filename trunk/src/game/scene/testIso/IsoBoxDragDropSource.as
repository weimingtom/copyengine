package game.scene.testIso
{
	import copyengine.dragdrop.IDragDropTarget;
	import copyengine.dragdrop.impl.CEDragDropSourceCore;
	import copyengine.utils.GeneralUtils;
	import copyengine.utils.ResUtlis;
	
	import flash.display.Sprite;

	public class IsoBoxDragDropSource extends CEDragDropSourceCore
	{
		private static const NAME:String = "IsoBoxDragDropSource";

		private var boxIcon:Sprite;


		public function IsoBoxDragDropSource()
		{
			super();
		}

		override public function onMove(_target:IDragDropTarget, _x:Number, _y:Number) : void
		{
//			if(_target == null)
//			{
				dragDropIconContainer.x = _x;
				dragDropIconContainer.y = _y;
//			}
		}

		override public function onEnterTarget(_target:IDragDropTarget) : void
		{
			if(_target is IsoViewPortDragDropTarget)
			{
				dragDropIconContainer.removeChild(boxIcon);
			}
		}

		override public function onLeaveTarget(_target:IDragDropTarget) : void
		{
			if(_target is IsoViewPortDragDropTarget)
			{
				dragDropIconContainer.addChild(boxIcon);
			}
		}

		override protected function initializeDragDropIcon() : void
		{
			boxIcon = ResUtlis.getSprite("Tile_Red" ,ResUtlis.FILE_ISOHAX);
			dragDropIconContainer.addChild(boxIcon);
		}
		
		override public function onDragDropEnd():void
		{
//			dragDropEngine.terminateDragDrop();
		}
		
		override public function onDragDropCancel():void
		{
			dragDropEngine.terminateDragDrop();
		}
		
		override public function onDragDropTerminate():void
		{
			GeneralUtils.removeTargetFromParent(boxIcon);
		}
		
	}
}