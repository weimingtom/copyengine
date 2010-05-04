package copyengine.ui.component.tabbar.animation
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Elastic;

	import copyengine.ui.component.tabbar.CETabBar;
	import copyengine.utils.GeneralUtils;
	import copyengine.utils.ResUtils;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	import flashx.textLayout.formats.WhiteSpaceCollapse;

	public class CETabbarScaleAnimation implements ICETabBarAnimation
	{
		private var scrollThumb:DisplayObject;
		private var target:CETabBar;

		public function CETabbarScaleAnimation()
		{
		}

		public function setTarget(_val:CETabBar , _thumb:DisplayObject) : void
		{
			target = _val;
			scrollThumb = _thumb;
		}

		public function changeSelected(_selectedUniqueName:String) : void
		{
			var child:DisplayObject = target.getChildByName(_selectedUniqueName);
			TweenLite.to(scrollThumb,0.5,{width:child.x - scrollThumb.x , ease:Elastic.easeOut});
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