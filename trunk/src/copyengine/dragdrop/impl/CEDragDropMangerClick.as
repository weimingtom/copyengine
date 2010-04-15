package copyengine.dragdrop.impl
{
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class CEDragDropMangerClick extends CEDragDropMangerCore
	{
		public function CEDragDropMangerClick()
		{
			super();
		}

		override protected function onMouseDown(e:Event) : void
		{
			var mouseEvent:MouseEvent = e as MouseEvent;
			engine.dropTarget(mouseEvent.stageX,mouseEvent.stageY);
		}
	}
}