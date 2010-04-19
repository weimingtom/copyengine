package copyengine.actor.isometric
{
	import copyengine.scenes.isometric.IsoObjectDisplayManger;
	import copyengine.utils.GeneralUtils;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;

	public class DragAbleIsoObject extends IsoObject
	{
		private var isoObjectDisplayManger:IsoObjectDisplayManger;

		public function DragAbleIsoObject(_isoObjectDisplayManger:IsoObjectDisplayManger,
			_skin:DisplayObjectContainer, _col:int, _row:int, _height:int, _maxCols:int, _maxRows:int)
		{
			isoObjectDisplayManger = _isoObjectDisplayManger;
			super(_skin, _col, _row, _height, _maxCols, _maxRows);
			initialize();
		}

		private function initialize() : void
		{
			addListener();
		}

		private function addListener() : void
		{
			GeneralUtils.addTargetEventListener(container,MouseEvent.ROLL_OVER,onRollOver);
			GeneralUtils.addTargetEventListener(container,MouseEvent.ROLL_OUT,onRollOut);
			GeneralUtils.addTargetEventListener(container,MouseEvent.MOUSE_DOWN,onMouseDown);
		}

		private function removeListener() : void
		{
			GeneralUtils.removeTargetEventListener(container,MouseEvent.ROLL_OVER,onRollOver);
			GeneralUtils.removeTargetEventListener(container,MouseEvent.ROLL_OUT,onRollOut);
			GeneralUtils.removeTargetEventListener(container,MouseEvent.MOUSE_DOWN,onMouseDown);
		}

		private function onMouseDown(e:MouseEvent) : void
		{
			isoObjectDisplayManger.removeIsoObject(this);
		}

		private function onRollOver(e:MouseEvent) : void
		{
			container.alpha = 0.7;
		}

		private function onRollOut(e:MouseEvent) : void
		{
			container.alpha = 1;
		}

	}
}