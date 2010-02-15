package copyengine.ui.button
{
    import copyengine.ui.CESprite;

    import flash.display.DisplayObject;
    import flash.events.MouseEvent;

    /**
     * CEButton is button component root
     * it use an movieClip as skin .  the movieClip should only contain one frame as the normal state skin.
     * other state will use TweenLite to scale. child class can override those function.
     *
     * @author Tunied
     */
    public class CEButton extends CESprite
    {
        private static const TWEEN_TIME:Number = 1;

        /**
         * rolloverScal = normalScale * ROLL_OVER_SCAL_PERCENT;
         * clickScal = normalScale * CLICK_SCAL_PERCENT;
         */
        private static const ROLL_OVER_SCAL_PERCENT:Number = 1.2;
        private static const CLICK_SCAL_PERCENT:Number = 0.8;

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
         * is use CacheSystem or not , use cache when will cache currentButton as an bitmap . it maybe become
         * obscure during sacle
         */
        protected var isCache:Boolean;

        /**
         * define is show ToolTips on current button or not.
         */
        protected var isUseToolTips:Boolean;

        /**
         * button skin maybe scaled  so need an value to remember the button initial value .
         */
        private var normalScaleX:Number;
        private var normalScaleY:Number;

        public function CEButton(_buttonSkin:Class , _labelTextKey:String = null ,  _isCache:Boolean = false , _isUseToolTips:Boolean = false)
        {
            super();
            buttonSkinClass = _buttonSkin;
            labelTextKey = _labelTextKey;
            isCache = _isCache;
            isUseToolTips = _isUseToolTips;
        }

        override protected function initialize() : void
        {
            if (isCache)
            {

            }
            else
            {
                var buttonBg:DisplayObject = new buttonSkinClass() as DisplayObject;
                addChild(buttonBg);

                normalScaleX = buttonBg.scaleX;
                normalScaleY = buttonBg.scaleY;
            }
            addListener();
        }

        override protected function dispose() : void
        {
            TweenLite.killTweensOf(this);
            removeListener();
        }

        private function addListener() : void
        {
            this.addEventListener(MouseEvent.CLICK,onMouseDown,false,0,true);
            this.addEventListener(MouseEvent.ROLL_OVER,onMouseRollOver,false,0,true);
            this.addEventListener(MouseEvent.ROLL_OUT,onMouseRollOut,false,0,true);
        }

        private function removeListener() : void
        {
            this.removeEventListener(MouseEvent.CLICK,onMouseDown);
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

        protected function onMouseDown(e:MouseEvent) : void
        {
            TweenLite.killTweensOf(this,true);
            TweenLite.to(this,TWEEN_TIME,{scaleX:normalScaleX * CLICK_SCAL_PERCENT ,scaleY :normalScaleY * CLICK_SCAL_PERCENT});
        }
    }
}