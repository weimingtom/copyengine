package copyengine.ui.component.tabbar.animation
{
	import copyengine.ui.component.tabbar.CETabBar;

	public interface ICETabBarAnimation
	{
		function setTarget(_val:CETabBar):void;
		function changeSelected(_selectedUniqueName:String):void;
		function dispose():void;
	}
}