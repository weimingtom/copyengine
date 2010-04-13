package copyengine.actor.isometric
{
	import copyengine.utils.GeneralUtils;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class IsoBox implements IIsoObject
	{
		private var isoBoxCol:int;
		private var isoBoxRow:int;
		private var isoBoxHeight:int;

		private var isoBoxMaxCols:int;
		private var isoBoxMaxRows:int;

		private var isoBoxSkin:DisplayObjectContainer;

		public function IsoBox(_skin:DisplayObjectContainer , 
			_col:int , _row:int , _height:int , 
			_maxCols:int , _maxRows:int)
		{
			isoBoxSkin = _skin;
			isoBoxCol = _col;
			isoBoxRow = _row;
			isoBoxHeight = _height;
			isoBoxMaxCols = _maxCols;
			isoBoxMaxRows = _maxRows;
			
			addListener();
		}

		public function get col() : int
		{
			return isoBoxCol;
		}

		public function get row() : int
		{
			return isoBoxRow;
		}
		
		public function get height():int
		{
			return isoBoxHeight;
		}
		
		public function get maxCols() : int
		{
			return isoBoxMaxCols;
		}

		public function get maxRows() : int
		{
			return isoBoxMaxRows;
		}

		public function get container() : DisplayObjectContainer
		{
			return isoBoxSkin;
		}
		
		private function addListener():void
		{
			GeneralUtils.addTargetEventListener(isoBoxSkin,MouseEvent.ROLL_OVER,onRollOver);
			GeneralUtils.addTargetEventListener(isoBoxSkin,MouseEvent.ROLL_OUT,onRollOut);
		}
		
		private function removeListener():void
		{
			GeneralUtils.removeTargetEventListener(isoBoxSkin,MouseEvent.ROLL_OVER,onRollOver);
			GeneralUtils.removeTargetEventListener(isoBoxSkin,MouseEvent.ROLL_OUT,onRollOut);
		}
		
		private function onRollOver(e:Event):void
		{
			isoBoxSkin.alpha = 0.7;
		}
		
		private function onRollOut(e:Event):void
		{
			isoBoxSkin.alpha = 1;
		}
		
	}
}