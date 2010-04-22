package copyengine.dragdrop.impl
{
	import copyengine.dragdrop.IDragDropSource;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class CEDragDropMangerDrag extends CEDragDropMangerCore
	{
		public function CEDragDropMangerDrag()
		{
			super();
		}

		override protected function onMouseUp(e:MouseEvent) : void
		{
			engine.dropTarget(e.stageX,e.stageY);
		}

	}
}