package copyengine.ui.button.animation
{
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	public class CEButtonTweenAnimation implements ICEButtonAnimation
	{
		/**
		 * define how long the tween is.
		 */
		private static const TWEEN_TIME:Number = 0.2;
		
		/**
		 * rolloverScal = normalScale * ROLL_OVER_SCAL_PERCENT;
		 * clickScal = normalScale * CLICK_SCAL_PERCENT;
		 */
		private static const ROLL_OVER_SCAL_PERCENT:Number = 1.1;
		private static const CLICK_SCAL_PERCENT:Number = 1;
		
		/**
		 * button skin maybe scaled  so need an value to remember the button initial value .
		 */
		private var normalScaleX:Number;
		private var normalScaleY:Number;
		
		private var target:DisplayObject;
		
		public function CEButtonTweenAnimation()
		{
		}
		
		public function setTarget(_target:DisplayObject):void
		{
			target = _target;
			normalScaleX = target.scaleX;
			normalScaleY = target.scaleY;
		}
		
		public function dispose():void
		{
			TweenLite.killTweensOf(target);
			target = null;
		}
		
		public function onMouseUp(e:MouseEvent):void
		{
			TweenLite.killTweensOf(target,true);
			TweenLite.to(target,TWEEN_TIME,{scaleX:normalScaleX * ROLL_OVER_SCAL_PERCENT ,scaleY :normalScaleY * ROLL_OVER_SCAL_PERCENT});
		}
		
		public function onMouseDown(e:MouseEvent):void
		{
			TweenLite.killTweensOf(target,true);
			TweenLite.to(target,TWEEN_TIME,{scaleX:normalScaleX  ,scaleY :normalScaleY });
		}
		
		public function onMouseRollOver(e:MouseEvent):void
		{
			TweenLite.killTweensOf(target,true);
			TweenLite.to(target,TWEEN_TIME,{scaleX:normalScaleX*ROLL_OVER_SCAL_PERCENT  ,scaleY :normalScaleY*ROLL_OVER_SCAL_PERCENT });
		}
		
		public function onMouseRollOut(e:MouseEvent):void
		{
			TweenLite.killTweensOf(target,true);
			TweenLite.to(target,TWEEN_TIME,{scaleX:normalScaleX * CLICK_SCAL_PERCENT ,scaleY :normalScaleY * CLICK_SCAL_PERCENT});
		}
	}
}