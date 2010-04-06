package copyengine.ui.tabbar.animation
{
	import com.greensock.TweenLite;
	
	import copyengine.ui.tabbar.CETabBar;
	import copyengine.utils.GeneralUtils;
	import copyengine.utils.ResUtlis;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	public class CEScrollTabbarAnimation implements ICETabBarAnimation
	{
		private var scrollThumb:Sprite;

		private var target:CETabBar;

		public function CEScrollTabbarAnimation()
		{
		}

		public function setTarget(_val:CETabBar) : void
		{
			target = _val;
			scrollThumb = ResUtlis.getSprite("Tabbar_Scroll_Thumb",ResUtlis.FILE_ISOHAX);
			GeneralUtils.addTargetToParent(scrollThumb,target,GeneralUtils.ADD_TARGET_TO_PARENT_ADJUST_ORDER_TYPE_LAST);
		}

		public function changeSelected(_selectedUniqueName:String) : void
		{
			var child:DisplayObject = target.getChildByName(_selectedUniqueName);
			TweenLite.to(scrollThumb,0.3,{x:child.x - (child.width>>1) , y:child.y - (child.height>>1)});
		}

		public function dispose() : void
		{
			TweenLite.killTweensOf(target);
			GeneralUtils.removeTargetFromParent(scrollThumb);
			target = null;
			scrollThumb = null;
		}
	}
}