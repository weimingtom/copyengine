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

		override protected function onMouseUp(e:Event) : void
		{
			var mouseEvent:MouseEvent = e as MouseEvent;
			engine.dropTarget(mouseEvent.stageX,mouseEvent.stageY);
		}

	}
}