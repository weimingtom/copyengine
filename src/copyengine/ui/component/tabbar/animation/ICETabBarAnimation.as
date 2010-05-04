package copyengine.ui.component.tabbar.animation
{
	import copyengine.ui.component.tabbar.CETabBar;
	
	import flash.display.DisplayObject;

	public interface ICETabBarAnimation
	{
		function setTarget(_val:CETabBar , thumb:DisplayObject):void;
		function changeSelected(_selectedUniqueName:String):void;
		function dispose():void;
	}
}