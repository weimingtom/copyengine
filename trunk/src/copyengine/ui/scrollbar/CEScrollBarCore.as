package copyengine.ui.scrollbar
{
    import copyengine.ui.CESprite;
    import copyengine.ui.button.CEButton;

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
            updateThumb();
            //dispathc event();
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
            stage.addEventListener(MouseEvent.MOUSE_UP,thumbOnMouseUp,false,0,true);
            stage.addEventListener(MouseEvent.MOUSE_MOVE,thumbOnMouseMove,false,0,true);
        }
		
		private function trackOnMouseDown(e:MouseEvent) : void
		{
			
		}
		
		private function thumbOnMouseMove(e:MouseEvent) : void
		{
			if (isOutOfRange(e.stageX,e.stageY))
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

        private function isOutOfRange(_mouseStageX:Number , _mouseStageY:Number) : Boolean
        {
			return false;
        }

    }
}