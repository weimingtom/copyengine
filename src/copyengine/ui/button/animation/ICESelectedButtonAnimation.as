package copyengine.ui.button.animation
{
	public interface ICESelectedButtonAnimation extends ICEButtonAnimation
	{
		function onSelectedChange(isSelected:Boolean):void;
	}
}