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
		
		/**
		 *As3 not really provide mouseClick event . if you mouse down at one point and moveAround(in the same target)
		 *and mouseUp , As3 still think it's mouseClick Event.
		 * so i have to use  CLICK_RESPOND_RANGE to simulate click event
		 */		
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
			}
			downPoint.x = downPoint.y = 0;
		}

	}
}