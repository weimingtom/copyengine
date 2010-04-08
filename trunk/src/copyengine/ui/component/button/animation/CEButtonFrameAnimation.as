package copyengine.ui.component.button.animation
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class CEButtonFrameAnimation implements ICEButtonAnimation
	{
		protected static const FRAME_ON:String = "on";
		protected static const FRAME_DOWN:String = "down";
		protected static const FRAME_OVER:String = "over";

		protected var target:MovieClip;
		
		/**
		 * use an property to record current btn frma lable.
		 */		
		protected var currentFrameLable:String = FRAME_ON;

		public function CEButtonFrameAnimation()
		{
		}

		public function setTarget(_target:DisplayObject) : void
		{
			target = _target as MovieClip;
			target.gotoAndStop(FRAME_ON);
		}

		public function dispose() : void
		{
			target.stop();
			target = null;
		}

		public function onMouseUp(e:MouseEvent) : void
		{
			changeToFrame(FRAME_OVER);
		}

		public function onMouseDown(e:MouseEvent) : void
		{
			changeToFrame(FRAME_DOWN);
		}

		public function onMouseRollOver(e:MouseEvent) : void
		{
			changeToFrame(FRAME_OVER);
		}

		public function onMouseRollOut(e:MouseEvent) : void
		{
			changeToFrame(FRAME_ON);
		}

		protected final function changeToFrame(_frameLable:String) : void
		{
			currentFrameLable = _frameLable;
			refreshBtn();
		}

		protected final function refreshBtn() : void
		{
			// even target can't contain such frame it also not throw error.
			// it only will stop in first frame.
			target.gotoAndStop(currentFrameLable);
		}
	}
}