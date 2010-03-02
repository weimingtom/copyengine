package copyengine.utils.tick.node
{
	import copyengine.utils.GeneralUtils;
	
	import flash.display.MovieClip;

	public class AnimationTickObjectNode extends TickObjectNode
	{
		private var target:MovieClip;

		public function AnimationTickObjectNode(_target:MovieClip,_callBackFunction:Function ,_repeatTime:int)
		{
			super(_callBackFunction,1,0,0);
			target = _target;
		}

		override protected function tickLogic() : void
		{
			if (target.currentFrame < target.totalFrames)
			{
				target.gotoAndPlay(target.currentFrame+1);
			}
			else
			{
				target.gotoAndPlay(1);
				--intervalTick;
			}
		}

		override public function destory() : void
		{
			super.destory();
			GeneralUtils.removeTargetFromParent(target);
		}
	}
}