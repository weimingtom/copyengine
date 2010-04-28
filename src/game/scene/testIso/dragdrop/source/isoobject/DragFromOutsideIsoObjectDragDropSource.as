package game.scene.testIso.dragdrop.source.isoobject
{
	import copyengine.dragdrop.IDragDropTarget;

	public class DragFromOutsideIsoObjectDragDropSource extends IsoObjectDragDropSourceBasic
	{
		public function DragFromOutsideIsoObjectDragDropSource()
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