package copyengine.ui.tabbar.animation
{
	import copyengine.ui.tabbar.CETabBar;

	public interface ICETabBarAnimation
	{
		function setTarget(_val:CETabBar);
		function changeSelected(_selectedUniqueName:String):void;
		function dispose():void;
	}
}