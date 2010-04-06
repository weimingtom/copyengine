package copyengine.ui.button.animation
{
    import flash.events.MouseEvent;

    public class CESelectedButtonFramAnimation extends CEButtonFrameAnimation implements ICESelectedButtonAnimation
    {
        protected static const FRAME_SELECTED_ON:String = "selected_on";
        protected static const FRAME_SELECTED_DOWN:String = "selected_down";
        protected static const FRAME_SELECTED_OVER:String = "selected_over";

        private var isSelected:Boolean = false; // Same as CESelectedButton

        public function CESelectedButtonFramAnimation()
        {
        }

        public function onSelectedChange(_isSelected:Boolean) : void
        {
            isSelected = _isSelected;
			currentFrameLable = "selected_"+currentFrameLable;
			refreshBtn();
        }

        override public function onMouseUp(e:MouseEvent) : void
        {
            if (isSelected)
            {
                changeToFrame(FRAME_SELECTED_OVER);
            }
            else
            {
                changeToFrame(FRAME_OVER);
            }
        }

        override public function onMouseDown(e:MouseEvent) : void
        {
            if (isSelected)
            {
                changeToFrame(FRAME_SELECTED_DOWN);
            }
            else
            {
                changeToFrame(FRAME_DOWN);
            }
        }

        override public function onMouseRollOver(e:MouseEvent) : void
        {
            if (isSelected)
            {
                changeToFrame(FRAME_SELECTED_OVER);
            }
            else
            {
                changeToFrame(FRAME_OVER);
            }
        }

        override public function onMouseRollOut(e:MouseEvent) : void
        {
            if (isSelected)
            {
                changeToFrame(FRAME_SELECTED_ON);
            }
            else
            {
                changeToFrame(FRAME_ON);
            }
        }
    }
}