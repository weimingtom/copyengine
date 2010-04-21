package copyengine.dragdrop.impl
{
	import copyengine.dragdrop.IDragDropEngine;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class CEDragDropMangerClick extends CEDragDropMangerCore
	{
		private static var _instance:CEDragDropMangerClick;
		
		public static function get instance():CEDragDropMangerClick
		{
			if(_instance == null)
			{
				_instance = new CEDragDropMangerClick();
			}
			return _instance;
		}
		
		private var dragDropEngine:IDragDropEngine;
		
		public function CEDragDropMangerClick()
		{
			super();
			dragDropEngine = new CEDragDropEngine();
			this.initialize(CopyEngineAS.dragdropLayer , dragDropEngine);
		}

		override protected function onMouseDown(e:Event) : void
		{
			var mouseEvent:MouseEvent = e as MouseEvent;
			engine.dropTarget(mouseEvent.stageX,mouseEvent.stageY);
		}
	}
}