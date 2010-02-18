package copyengine.ui.scrollbar
{
    import copyengine.ui.CESprite;
    import copyengine.ui.button.CEButton;
    import copyengine.utils.GeneralUtils;

    import flash.events.MouseEvent;

    public class CEScrollBarCore extends CESprite
    {
        /**
         *define the minimun size of the thumb , the thumb will autoScale by the track size.
         * but thie thumb can't be smaller than this value.
         */
        private static const MINIMUM_THUMB_SIZE:Number = 12;

        /**
         *when user  drage the thumb , it will move with user's mouse. but if mouse.stageX/mouse.stageY
         * is out of this range then scrollBar will stop change automate.
         */
        private static const THUMB_REACT_RANGE:Number = 120;


        public static const LAYOUT_HORIZONTAL:String = "horizontal";
        public static const LAYOUT_VERTICAL:String = "vertical";
        public static const LAYOUT_AUTO:String = "auto";

        /**
         * set the scrollBar layout direction , this property should be one of the three value
         * 1) horizontal
         * 2) vertical
         * 3) auto    auton means the class will detect the layout for the user . the detect rule base on it width/height size.
         */
        private var direction:String;

        /**
         *  scrollBar suport six button to operate
         *
         *  1) scrollToStart , scrollToEnd                  set scrollPosition to minScrollPosition/maxScrollPosition
         *  2) scrollNext , scrollPrev						  set scrollPosition to scrollPositon +/-  lineScrollSize
         *  3) scrollNextPage , scrollPrevPage		  set scrollPosition to scrollPosition +/- pageScrollSize
         *
         * pageScrollSize also will trigger when user click the track
         *
         */
        private var lineScrollSize:Number;
        private var pageScrollSize:Number;

        /**
         *  scrollBar will scroll during minScrollPosition~maxScrollPosition. normally
         * minScrollPosition = 0 and maxScrollPosition = host target maxScrollPosition.
         */
        private var minScrollPosition:Number;
        private var maxScrollPosition:Number;

        /**
         * previous scrollPosition
         */
        private var oldScrollPosition:Number;
        /**
         * current scroll scrollBar scrollPosition
         */
        private var _scrollPosition:Number;

        /**
         * define the thumb skin
         */
        private var thumb:CEButton

        /**
         * define the track skin
         */
        private var track:CEButton;

        /**
         * define the size of scrollBar
         */
        private var scrollBarHeight:Number;
        private var scrollBarWidth:Number;

        /**
         * when user start drag the thumb , the offest between mousePos to top left corner.
         */
        private var thumbScrollOffset:Number;


        public function CEScrollBarCore(_width:Number ,_height:Number , _direction:String = LAYOUT_AUTO)
        {
            scrollBarWidth = _width;
            scrollBarHeight = _height;
            direction = _direction;
            super();
        }

        override protected function initialize() : void
        {
            calculateScrollBarDirection();
            initializeScrollBarSkin();
            addListener();
        }

        override protected function dispose() : void
        {
            removeListener();
        }

        public function get scrollPosition() : Number
        {
            return _scrollPosition;
        }

        public function set scrollPosition(_value:Number) : void
        {
            if (_value != _scrollPosition)
            {
                _scrollPosition = _value;
                updateScrollPosition();
            }
        }

        //================
        //== Private Function
        //================

        /**
         * if scrollBar direction set to LAYOUT_AUTO , this calculate the layout direction
         * by it width/height size , otherwise do nothing.
         */
        private function calculateScrollBarDirection() : void
        {
        }

        /**
         * initialize the scrollBar skin
         */
        private function initializeScrollBarSkin() : void
        {

        }

        private function addListener() : void
        {
            thumb.addEventListener(MouseEvent.MOUSE_DOWN,thumbOnMouseDown,false,0,true);
            track.addEventListener(MouseEvent.MOUSE_DOWN,trackOnMouseDown,false,0,true);
        }

        private function removeListener() : void
        {
            thumb.removeEventListener(MouseEvent.MOUSE_DOWN,thumbOnMouseDown);
            track.removeEventListener(MouseEvent.MOUSE_DOWN,trackOnMouseDown);
            //stage event should be removed in function releaseThumb();
            //in here doing again ,in case the function releaseThumb has not been call.
            stage.removeEventListener(MouseEvent.MOUSE_UP,thumbOnMouseMove);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,thumbOnMouseMove);
        }

        /**
         * when user operate thumb or click track will trigger scrollPosition ,
         * in this case need to send ScrollBarEvent.SCROLL ,
         * otherwise the scrollPostion will change by set scrollPostion function by other CECompoment.
         * then do not need to send ScrollEvent.
         *
         */
        private function updateScrollPosition(_isDispatchEvent:Boolean) : void
        {
            if (_isDispatchEvent)
            {
                this.dispatchEvent(new CEScrollBarCoreEvent(direction,
                                                            _scrollPosition - oldScrollPosition,
                                                            _scrollPosition,CEScrollBarCoreEvent.SCROLL));
            }
            oldScrollPosition = _scrollPosition;
            updateThumb();
        }

        /**
         * update UI thumb position
         */
        private function updateThumb() : void
        {

        }

        //============
        //== Event Listener
        //============

        private function thumbOnMouseDown(e:MouseEvent) : void
        {
            if (direction == LAYOUT_HORIZONTAL)
            {
                thumbScrollOffset = e.localX - thumb.getBounds(thumb).x;
            }
            else // layout == LAYOUT_VERTICAL
            {
                thumbScrollOffset = e.localY - thumb.getBounds(thumb).y;
            }
            stage.addEventListener(MouseEvent.MOUSE_UP,thumbOnMouseUp,false,0,true);
            stage.addEventListener(MouseEvent.MOUSE_MOVE,thumbOnMouseMove,false,0,true);
        }

        private function thumbOnMouseMove(e:MouseEvent) : void
        {
            var pos:Number;
            var posRange:Number;
            if (direction == LAYOUT_HORIZONTAL)
            {
                pos = GeneralUtils.normalizingVlaue(track.mouseX - track.x - thumbScrollOffset,0,track.width);
                _scrollPosition = pos/track.width * (maxScrollPosition - minScrollPosition) + minScrollPosition;

                posRange = Math.abs(e.stageY - track.y);
            }
            else //loyout == LAYOUT_VERTICAL
            {
                pos = GeneralUtils.normalizingVlaue(track.mouseY - track.y - thumbScrollOffset , 0 ,track.height);
                _scrollPosition = pos/track.height * (maxScrollPosition - minScrollPosition) + minScrollPosition;

                posRange = Math.abs(e.stageX - track.x)
            }
            updateScrollPosition(true);
            if (posRange > THUMB_REACT_RANGE)
            {
                releaseThumb();
            }
        }

        private function thumbOnMouseUp(e:MouseEvent) : void
        {
            releaseThumb();
        }

        private function releaseThumb() : void
        {
            stage.removeEventListener(MouseEvent.MOUSE_UP,thumbOnMouseMove);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,thumbOnMouseMove);
        }

        private function trackOnMouseDown(e:MouseEvent) : void
        {
            var mousePosition:Number;
            if (direction == LAYOUT_HORIZONTAL)
            {
                mousePosition = e.localY / track.height * (maxScrollPosition - minScrollPosition) + minScrollPosition;
            }
            else //loyout == LAYOUT_VERTICAL
            {
                mousePosition = e.localX / track.width * (maxScrollPosition - minScrollPosition) + minScrollPosition;
            }

            if (_scrollPosition < mousePosition)
            {
                _scrollPosition = Math.min(mousePosition,_scrollPosition+pageScrollSize);
            }
            else if (_scrollPosition > mousePosition)
            {
                _scrollPosition = Math.max(mousePosition,_scrollPosition-pageScrollSize);
            }
            _scrollPosition = GeneralUtils.normalizingVlaue(_scrollPosition,minScrollPosition,maxScrollPosition);
            updateScrollPosition(true);
        }

    }
}