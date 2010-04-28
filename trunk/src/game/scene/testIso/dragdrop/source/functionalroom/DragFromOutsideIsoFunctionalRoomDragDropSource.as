package game.scene.testIso.dragdrop.source.functionalroom
{
	import copyengine.dragdrop.IDragDropTarget;

	public class DragFromOutsideIsoFunctionalRoomDragDropSource extends IsoFunctionalRoomDragDropSourceBasic
	{
		public function DragFromOutsideIsoFunctionalRoomDragDropSource()
		{
			super();
		}
		
		override public function onDropConfim(_target:IDragDropTarget, _isAccepted:Boolean) : void
		{
			if (_isAccepted == false)
			{
				dragDropEngine.terminateDragDrop();
			}
		}
		
	}
}