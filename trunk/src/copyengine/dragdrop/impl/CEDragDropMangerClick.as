package copyengine.dragdrop.impl
{
	import copyengine.dragdrop.IDragDropEngine;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class CEDragDropMangerClick extends CEDragDropMangerCore
	{
		private static const CLICK_RESPOND_RANGE:int = 10;

		private static var _instance:CEDragDropMangerClick;

		public static function get instance() : CEDragDropMangerClick
		{
			if (_instance == null)
			{
				_instance = new CEDragDropMangerClick();
			}
			return _instance;
		}

		private var dragDropEngine:IDragDropEngine;
		private var downPoint:Point;

		public function CEDragDropMangerClick()
		{
			super();
			dragDropEngine = new CEDragDropEngine();
			downPoint = new Point();
			this.initialize(CopyEngineAS.dragdropLayer , dragDropEngine);
		}

		override protected function onMouseDown(e:MouseEvent) : void
		{
			downPoint.x = e.stageX;
			downPoint.y = e.stageY;
		}

		override protected function onMouseUp(e:MouseEvent) : void
		{
			if (e.stageX < downPoint.x + CLICK_RESPOND_RANGE 
				&& e.stageX > downPoint.x - CLICK_RESPOND_RANGE
				&& e.stageY < downPoint.y + CLICK_RESPOND_RANGE 
				&& e.stageY > downPoint.y - CLICK_RESPOND_RANGE)
			{
				engine.dropTarget(e.stageX,e.stageY);
				downPoint.x = downPoint.y = 0;
			}
		}

	}
}