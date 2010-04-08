package copyengine.ui.component.button.animation
{
	public interface ICESelectedButtonAnimation extends ICEButtonAnimation
	{
		function onSelectedChange(isSelected:Boolean):void;
	}
}