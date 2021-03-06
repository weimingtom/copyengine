package copyengine.ui.component.list.animation
{
	import com.greensock.TweenLite;

	import copyengine.ui.component.list.CEListCore;

	/**
	 * CEListTweenInteraction is use tween animation to set list scrollPosition
	 *
	 * @author Tunied
	 *
	 */
	public class CEListTweenAnimation implements ICEListAnimation
	{
		private static const INVERSE_SPEED:Number = 0.005; // = 1/Speed
		private static const MAX_SCROLL_TIME:Number = 2; // if  caulate scroll time is bigger than that time ,then use this time for current animation.

		/**
		 * the target
		 */
		private var list:CEListCore;

		/**
		 *  because use tween animation , so when user call turnToNextOne(), the
		 *  scrollPosition will not change same time , it will take some time then
		 * 	get to position that user expect it to be.
		 */
		private var expectScrollPosition:Number = 0;

		/**
		 * record previous expectScrollPosition , use in tween function
		 */
		private var prevExpectScrollPosition:Number;

		public function CEListTweenAnimation()
		{
		}

		public function set target(_val:Object) : void
		{
			list = _val as CEListCore;
		}

		public function set scrollPosition(_val:Number) : void
		{
			prevExpectScrollPosition = expectScrollPosition;
			expectScrollPosition = _val;
			tweenToExpectScrollPosition();
		}

		public function dispose() : void
		{
			TweenLite.killTweensOf(list);
			list = null
		}

		public function killAnimation() : void
		{
			TweenLite.killTweensOf(list,true);
		}

		private function tweenToExpectScrollPosition() : void
		{
			TweenLite.killTweensOf(list,true);
			TweenLite.to(list, Math.min(MAX_SCROLL_TIME,INVERSE_SPEED*Math.abs(expectScrollPosition-prevExpectScrollPosition)), {reallScrollPosition : expectScrollPosition});
		}
	}
}