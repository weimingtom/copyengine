package copyengine.utils.tick.node
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;

	public class TweenEffectTickObjectNode extends AnimationTickObjectNode
	{
		private var tweenTarget:DisplayObject;
		private var tweenMC:MovieClip;
		
		private var tweenTargetOriginalPosX:Number;
		private var tweenTargetOriginalPosY:Number;
		
		private var tweenTargetOriginalMouseEnable:Boolean;
		private var tweenTargetOriginalMouseChildren:Boolean;
		
		public function TweenEffectTickObjectNode(_target:DisplayObject , _tweenMC:MovieClip , _endCallBackFunction:Function , _repeatTime:int)
		{
			super(_tweenMC,_endCallBackFunction,_repeatTime);
			tweenTarget = _target;
			tweenMC = _tweenMC;
			tweenMC.visible = false;
			
			var parent:DisplayObjectContainer = tweenTarget.parent;
			parent.addChild(tweenMC);
			tweenMC.x = tweenTargetOriginalPosX = tweenTarget.x;
			tweenMC.y = tweenTargetOriginalPosY = tweenTarget.y;
			
			if(tweenTarget is DisplayObjectContainer)
			{
				var container:DisplayObjectContainer = tweenTarget as DisplayObjectContainer;
				tweenTargetOriginalMouseEnable = container.mouseEnabled;
				tweenTargetOriginalMouseChildren = container.mouseChildren;
				container.mouseEnabled = container.mouseChildren = false;
				container = null;
			}
		}
		
		override protected function tickLogic() : void
		{
			copyTweenMcPropertyToTarget();
			if (tweenMC.currentFrame == tweenMC.totalFrames)
			{
				--intervalTick;
			}
		}
		
		override public function destory() : void
		{
			if(tweenTarget is DisplayObjectContainer)
			{
				var container:DisplayObjectContainer = tweenTarget as DisplayObjectContainer;
				container.mouseEnabled = tweenTargetOriginalMouseEnable;
				container.mouseChildren = tweenTargetOriginalMouseChildren;
				container = null;
			}
			super.destory();
		}
		
		private function copyTweenMcPropertyToTarget():void
		{
			tweenTarget.x = tweenTargetOriginalPosX + tweenMC.mc.x;
			tweenTarget.y = tweenTargetOriginalPosY + tweenMC.mc.y;
			tweenTarget.rotation = tweenMC.mc.rotation;
			tweenTarget.scaleX = tweenMC.mc.scaleX;
			tweenTarget.scaleY = tweenMC.mc.scaleY;
			tweenTarget.alpha = tweenMC.mc.alpha;
		}
	}
}