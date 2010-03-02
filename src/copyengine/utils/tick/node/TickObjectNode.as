package copyengine.utils.tick.node
{
	import copyengine.datastructure.DoubleLinkNode;

	public class TickObjectNode extends DoubleLinkNode
	{
		public var tickFinishedCallBackFunction:Function;

		public var isNeedRemove:Boolean = false; // an flage to tell mainTick is this node need to be remove

		protected var intervalTick:int = 0;
		protected var repeatTime:int = 0;

		private var tickCount:int = 0;
		private var delayTick:int = 0;

		public function TickObjectNode(_callBackFunction:Function, _intervalTick:int, _repeatTime:int, _delayTick:int)
		{
			tickFinishedCallBackFunction = _callBackFunction;
			tickCount = intervalTick = _intervalTick;
			repeatTime = _repeatTime;
			delayTick = _delayTick;
		}

		public function tick() : Boolean
		{
			if (delayTick > 0)
			{
				--delayTick;
				return false;
			}
			if (intervalTick > 0)
			{
				tickLogic();
				return false;
			}
			else
			{
				if (tickFinishedCallBackFunction != null)
				{
					tickFinishedCallBackFunction.apply();
				}
				--repeatTime;
				intervalTick = tickCount;
				if (repeatTime < 0)
				{
					destory();
					return true;
				}
				else
				{
					return false;
				}
			}
		}

		protected function tickLogic() : void
		{
			--intervalTick;
		}

		public function destory() : void
		{
			tickFinishedCallBackFunction = null;
		}
	}
}