package game.scene.testIso.dragdrop.source.isoobject
{
	import copyengine.dragdrop.IDragDropTarget;

	public class DragFromInsideIsoObjectDragDropSource extends IsoObjectDragDropSourceBasic
	{
		public function DragFromInsideIsoObjectDragDropSource()
		{
			super();
		}

		override public function onDropConfim(_target:IDragDropTarget, _isAccepted:Boolean) : void
		{
			dragDropEngine.terminateDragDrop();
		}

	}
}