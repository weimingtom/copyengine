package copyengine.ui.button
{
    import com.greensock.TweenLite;

    import flash.display.DisplayObject;
    import flash.events.MouseEvent;

    /**
     * it use an movieClip as skin .  the movieClip should only contain one frame as the normal state skin.
     * other state will use TweenLite to scale. child class can override those function.
     */
    public class CEButtonTween extends CEButton
    {
        /**
         * define how long the tween is.
         */
        private static const TWEEN_TIME:Number = 0.2;

        /**
         * rolloverScal = normalScale * ROLL_OVER_SCAL_PERCENT;
         * clickScal = normalScale * CLICK_SCAL_PERCENT;
         */
        private static const ROLL_OVER_SCAL_PERCENT:Number = 1.1;
        private static const CLICK_SCAL_PERCENT:Number = 1;

        /**
         * button skin maybe scaled  so need an value to remember the button initial value .
         */
        private var normalScaleX:Number;
        private var normalScaleY:Number;

        public function CEButtonTween(_buttonBg:DisplayObject, _labelTextKey:String=null, _isUseToolTips:Boolean=false)
        {
            super(_buttonBg, _labelTextKey, _isUseToolTips);
        }

        override protected function initialize() : void
        {
            super.initialize();

            normalScaleX = buttonBg.scaleX;
            normalScaleY = buttonBg.scaleY;
        }

        override protected function dispose() : void
        {
            super.dispose();
            TweenLite.killTweensOf(this);
        }

        override protected function onMouseRollOver(e:MouseEvent) : void
        {
            TweenLite.killTweensOf(this,true);
            TweenLite.to(this,TWEEN_TIME,{scaleX:normalScaleX * ROLL_OVER_SCAL_PERCENT ,scaleY :normalScaleY * ROLL_OVER_SCAL_PERCENT});
        }

        override protected function onMouseRollOut(e:MouseEvent) : void
        {
            TweenLite.killTweensOf(this,true);
            TweenLite.to(this,TWEEN_TIME,{scaleX:normalScaleX  ,scaleY :normalScaleY });
        }

        override protected function onMouseUp(e:MouseEvent) : void
        {
            TweenLite.killTweensOf(this,true);
            TweenLite.to(this,TWEEN_TIME,{scaleX:normalScaleX*ROLL_OVER_SCAL_PERCENT  ,scaleY :normalScaleY*ROLL_OVER_SCAL_PERCENT });
        }

        override protected function onMouseDown(e:MouseEvent) : void
        {
            TweenLite.killTweensOf(this,true);
            TweenLite.to(this,TWEEN_TIME,{scaleX:normalScaleX * CLICK_SCAL_PERCENT ,scaleY :normalScaleY * CLICK_SCAL_PERCENT});
        }
    }
}