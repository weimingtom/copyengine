package game.scene.testIso.dragdrop.source.functionalroom
{
	import copyengine.dragdrop.IDragDropTarget;

	public class DragFromInsideIsoFunctionalRoomDragDropSource extends IsoFunctionalRoomDragDropSourceBasic
	{
		public function DragFromInsideIsoFunctionalRoomDragDropSource()
		{
			super();
		}

		override public function onDropConfim(_target:IDragDropTarget, _isAccepted:Boolean) : void
		{
			dragDropEngine.terminateDragDrop();
		}
	}
}