package copyengine.ui.tabbar.animation
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Elastic;
	
	import copyengine.ui.tabbar.CETabBar;
	import copyengine.utils.GeneralUtils;
	import copyengine.utils.ResUtlis;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import flashx.textLayout.formats.WhiteSpaceCollapse;

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
			var b:Rectangle = child.getBounds(child);
			TweenLite.to(scrollThumb,0.5,{width:child.x , ease:Elastic.easeOut});
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