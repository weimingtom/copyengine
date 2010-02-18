package copyengine.ui.button
{
    import com.greensock.TweenLite;

    import copyengine.ui.CESprite;

    import flash.display.DisplayObject;
    import flash.events.MouseEvent;

    /**
     * CEButton is button component root.
     * child class will deal with how the button changing it skin(ex:CEButtonFram , CEButtonTween)
     * other class should only use CEButton , not it child class directly.
     * ex:
     * 		var button:CEButton = new CEButtonTween();
     *
     * @author Tunied
     */
    public class CEButton extends CESprite
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
         * if this button need to be cache then use this class as a key to get the bitmap form CacheSystem.
         * else then use it to create the movieClipe
         */
        protected var buttonSkinClass:Class;

        /**
         * if this button contain an labelField then use this key to initialize the textField .
         * we use labelKey rather than an real text , because we also need that key to embed font.
         */
        protected var labelTextKey:String;

        /**
         * define is show ToolTips on current button or not.
         */
        protected var isUseToolTips:Boolean;

        /**
         * button skin maybe scaled  so need an value to remember the button initial value .
         */
        private var normalScaleX:Number;
        private var normalScaleY:Number;

        public function CEButton(_buttonSkin:Class , _labelTextKey:String = null , _isUseToolTips:Boolean = false)
        {
            super();
            buttonSkinClass = _buttonSkin;
            labelTextKey = _labelTextKey;
            isUseToolTips = _isUseToolTips;
        }

        override protected function initialize() : void
        {
            var buttonBg:DisplayObject = new buttonSkinClass() as DisplayObject;
            addChild(buttonBg);

            normalScaleX = buttonBg.scaleX;
            normalScaleY = buttonBg.scaleY;

            addListener();
        }

        override protected function dispose() : void
        {
            TweenLite.killTweensOf(this);
            removeListener();
        }

        private function addListener() : void
        {
            this.addEventListener(MouseEvent.MOUSE_UP,onMouseUp,false,0,true);
            this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown,false,0,true);
            this.addEventListener(MouseEvent.ROLL_OVER,onMouseRollOver,false,0,true);
            this.addEventListener(MouseEvent.ROLL_OUT,onMouseRollOut,false,0,true);
        }

        private function removeListener() : void
        {
            this.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
            this.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
            this.removeEventListener(MouseEvent.ROLL_OVER,onMouseRollOver);
            this.removeEventListener(MouseEvent.ROLL_OUT,onMouseRollOut);
        }

        protected function onMouseRollOver(e:MouseEvent) : void
        {
            TweenLite.killTweensOf(this,true);
            TweenLite.to(this,TWEEN_TIME,{scaleX:normalScaleX * ROLL_OVER_SCAL_PERCENT ,scaleY :normalScaleY * ROLL_OVER_SCAL_PERCENT});
        }

        protected function onMouseRollOut(e:MouseEvent) : void
        {
            TweenLite.killTweensOf(this,true);
            TweenLite.to(this,TWEEN_TIME,{scaleX:normalScaleX  ,scaleY :normalScaleY });
        }

        protected function onMouseUp(e:MouseEvent) : void
        {
            TweenLite.killTweensOf(this,true);
            TweenLite.to(this,TWEEN_TIME,{scaleX:normalScaleX*ROLL_OVER_SCAL_PERCENT  ,scaleY :normalScaleY*ROLL_OVER_SCAL_PERCENT });
        }

        protected function onMouseDown(e:MouseEvent) : void
        {
            TweenLite.killTweensOf(this,true);
            TweenLite.to(this,TWEEN_TIME,{scaleX:normalScaleX * CLICK_SCAL_PERCENT ,scaleY :normalScaleY * CLICK_SCAL_PERCENT});
        }
    }
}