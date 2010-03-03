package copyengine.ui.button.animation
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

	public interface ICEButtonAnimation
	{
		function setTarget(_target:DisplayObject):void;
		function dispose():void;
		
		function onMouseUp(e:MouseEvent):void;
		function onMouseDown(e:MouseEvent):void;
		function onMouseRollOver(e:MouseEvent):void;
		function onMouseRollOut(e:MouseEvent):void;
	}
}