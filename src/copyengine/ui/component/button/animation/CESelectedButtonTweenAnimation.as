package copyengine.ui.component.button.animation
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;

	public class CESelectedButtonTweenAnimation extends CEButtonTweenAnimation implements ICESelectedButtonAnimation
	{
		private static const FRAME_UNSELECTED:String = "unS"; //UnSelected
		private static const FRAME_SELECTED:String = "s"			//selected
		
		public function CESelectedButtonTweenAnimation()
		{
			super();
		}
		
		override public function setTarget(_target:DisplayObject):void
		{
			super.setTarget(_target);
			(target as MovieClip).gotoAndStop(FRAME_UNSELECTED);
		}
		
		public function onSelectedChange(isSelected:Boolean):void
		{
			var frame:String
			isSelected == true ? frame = FRAME_SELECTED : frame = FRAME_UNSELECTED;
			(target as MovieClip).gotoAndStop(frame);
		}
	}
}