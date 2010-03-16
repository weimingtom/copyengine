package copyengine.ui.tabbar
{
	import copyengine.ui.CESprite;
	import copyengine.ui.button.CESelectableButton;
	import copyengine.ui.tabbar.animation.ICETabBarAnimation;
	import copyengine.utils.GeneralUtils;

	import flash.utils.Dictionary;

	public class CETabBar extends CESprite
	{

		private var animation:ICETabBarAnimation;

		/**
		 * contain all the subBtns all in current TabBar
		 */
		private var subBtnsMap:Dictionary;

		public function CETabBar(_animation:ICETabBarAnimation = null ,
			_isAutoInitialzeAndRemove:Boolean=true)
		{
			super(_isAutoInitialzeAndRemove);

			animation = _animation;
			if (animation != null)
			{
				animation.setTarget(this);
			}

			subBtnsMap = new Dictionary(true);
		}

		public function addSubBtn(_btn:CESelectableButton , _uniqueName:String) : void
		{
			subBtnsMap[_uniqueName] = _btn;
		}

		override protected function initialize() : void
		{

		}

		override protected function dispose() : void
		{
			if (animation != null)
			{
				animation.dispose();
			}

			for each (var uniqueName : String in subBtnsMap)
			{
				GeneralUtils.removeTargetFromParent( subBtnsMap[uniqueName] );
				delete subBtnsMap[uniqueName];
			}
			subBtnsMap = null;
		}


	}
}