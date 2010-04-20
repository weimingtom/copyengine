package game.dragdrop.test
{
	import copyengine.dragdrop.IDragDropTarget;
	import copyengine.dragdrop.impl.CEDragDropSourceCore;
	import copyengine.utils.GeneralUtils;
	import copyengine.utils.ResUtlis;

	import flash.display.Sprite;

	public class DragDropAvtorSource extends CEDragDropSourceCore
	{
		public static const NAME:String = "DragDropAvtorSource";

		private var avtorIcon:Sprite;

		public function DragDropAvtorSource()
		{
			super();
		}

		override public function onMove(_target:IDragDropTarget, _x:Number, _y:Number) : void
		{
			dragDropIconContainer.x = _x;
			dragDropIconContainer.y = _y;
		}
		
		override public function onDragDropEnd() : void
		{
			GeneralUtils.removeTargetFromParent(avtorIcon);
		}

		override protected function initializeDragDropIcon() : void
		{
			avtorIcon = ResUtlis.getSprite("DragDropIcon","IsoHax_asset");
			dragDropIconContainer.addChild(avtorIcon);
		}

	}
}