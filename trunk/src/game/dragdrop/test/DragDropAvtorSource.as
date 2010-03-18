package game.dragdrop.test
{
	import copyengine.dragdrop.impl.CEDragDropSourceCore;

	public class DragDropAvtorSource extends CEDragDropSourceCore
	{
		public static const NAME:String = "DragDropAvtorSource";

		public function DragDropAvtorSource()
		{
			super();
		}

		override public function get uniqueName() : String
		{
			return NAME;
		}
	}
}