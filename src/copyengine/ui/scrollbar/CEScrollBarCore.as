package copyengine.ui.scrollbar
{
    import copyengine.ui.CESprite;
    import copyengine.ui.button.CEButton;
    import copyengine.utils.GeneralUtils;
    import copyengine.utils.GlobalTick;

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
        private static const THUMB_REACT_RANGE:Number = 300;


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
        private var lineScrollSize:Number = 0;
        private var pageScrollSize:Number = 0;

        /**
         *  scrollBar will scroll during minScrollPosition~maxScrollPosition. normally
         * minScrollPosition = 0 and maxScrollPosition = host target maxScrollPosition.
         */
        private var minScrollPosition:Number = 0;
        private var maxScrollPosition:Number = 0;

        /**
         * previous scrollPosition
         */
        private var oldScrollPosition:Number = 0;
        /**
         * current scroll scrollBar scrollPosition
         */
        private var _scrollPosition:Number = 0;

        /**
         * define the thumb skin
         */
        private var thumb:CEButton

        /**
         * define the track skin
         */
        private var track:CEButton;

        /**
         * when user start drag the thumb , the offest between mousePos to top left corner.
         */
        private var thumbScrollOffset:Number = 0;


        public function CEScrollBarCore(_thumb:CEButton , _track:CEButton,
                                        _width:Number ,_height:Number , _direction:String = LAYOUT_AUTO)
        {
            thumb = _thumb;
            track = _track;

            track.width = _width;
            track.height = _height;

            direction = _direction;

            super();
        }
		
		public function initializeScrollBar(  _lineScrollSize:Number , _pageScrollSize:Number ,
											  _minScrollPosition:Number , _maxScrollPosition:Number):void
		{
			lineScrollSize = _lineScrollSize;
			pageScrollSize = _pageScrollSize;
			
			minScrollPosition = _minScrollPosition;
			maxScrollPosition = _maxScrollPosition;
			
			calculateScrollBarDirection();
			calculateThumbSize();
			initializeScrollBarSkin();
			addListener();
		}

        override protected function dispose() : void
        {
            removeListener();
            releaseThumb();
            releaseTrack();
        }

        public function get scrollPosition() : Number
        {
            return _scrollPosition;
        }

        public function set scrollPosition(_value:Number) : void
        {
            if (_value != _scrollPosition)
            {
                updateScrollPosition(false , _value);
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
            if (direction == LAYOUT_AUTO)
            {
                if (track.width > track.height)
                {
                    direction = LAYOUT_HORIZONTAL;
                }
                else
                {
                    direction = LAYOUT_VERTICAL;
                }
            }
        }

        /**
         * calculate the thumb size base on scroll property
         */
        private function calculateThumbSize() : void
        {
            if (direction == LAYOUT_HORIZONTAL)
            {
                thumb.width = Math.max(MINIMUM_THUMB_SIZE,track.width - maxScrollPosition + minScrollPosition);
            }
            else // layout == LAYOUT_VERTICAL
            {
                thumb.height = Math.max(MINIMUM_THUMB_SIZE,track.width - maxScrollPosition + minScrollPosition);
            }
        }

        /**
         * initialize the scrollBar skin
         */
        private function initializeScrollBarSkin() : void
        {
            this.addChild(track);
            track.addChild(thumb);

            if (direction == LAYOUT_HORIZONTAL)
            {
                thumb.y = (track.height - thumb.height) >> 1;
            }
            else // layout == LAYOUT_VERTICAL
            {
                thumb.x = (track.width - thumb.width) >> 1;
            }
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

            stage.removeEventListener(MouseEvent.MOUSE_UP,trackOnMouseUp);
        }

        /**
         * when user operate thumb or click track will trigger scrollPosition ,
         * in this case need to send ScrollBarEvent.SCROLL ,
         * otherwise the scrollPostion will change by set scrollPostion function by other CECompoment.
         * then do not need to send ScrollEvent.
         *
         */
        private function updateScrollPosition(_isDispatchEvent:Boolean ,_newScrollPosition :Number , _thumbPosition:Number = NaN) : void
        {
            oldScrollPosition = _scrollPosition;
            _scrollPosition = _newScrollPosition;
            if (isNaN(_thumbPosition))
            {
                updateThumb( getThumbPositionByScrollPosition() );
            }
            else
            {
                updateThumb(_thumbPosition);
            }
            if (_isDispatchEvent && hasEventListener(CEScrollBarCoreEvent.SCROLL))
            {
                this.dispatchEvent(new CEScrollBarCoreEvent(direction,
                                                            _scrollPosition - oldScrollPosition,
                                                            _scrollPosition,CEScrollBarCoreEvent.SCROLL));
            }

        }

        /**
         * update UI thumb position
         */
        private function updateThumb(_thumbPosition:Number) : void
        {
            if (direction == LAYOUT_HORIZONTAL)
            {
                thumb.x = GeneralUtils.normalizingVlaue(_thumbPosition ,0 ,track.width - thumb.width);
            }
            else
            {
                thumb.y = GeneralUtils.normalizingVlaue(_thumbPosition ,0 ,track.height - thumb.height);
            }
        }

        private function getThumbPositionByScrollPosition() : Number
        {
            if (direction == LAYOUT_HORIZONTAL)
            {
                return (_scrollPosition - minScrollPosition) /(maxScrollPosition - minScrollPosition) * (track.width - thumb.width);
            }
            else // layout == LAYOUT_VERTICAL
            {
                return (_scrollPosition - minScrollPosition) /(maxScrollPosition - minScrollPosition) * (track.height - thumb.height);
            }
        }

        //============
        //== Event Listener
        //============

        //=========
        //==Thumb
        //=========
        private function thumbOnMouseDown(e:MouseEvent) : void
        {
            e.stopImmediatePropagation();
            if (direction == LAYOUT_HORIZONTAL)
            {
                thumbScrollOffset = e.localX * thumb.scaleX;
            }
            else // layout == LAYOUT_VERTICAL
            {
                thumbScrollOffset = e.localY * thumb.scaleY;
            }
            stage.addEventListener(MouseEvent.MOUSE_UP,thumbOnMouseUp,false,0,true);
            stage.addEventListener(MouseEvent.MOUSE_MOVE,thumbOnMouseMove,false,0,true);
        }

        /**
         * when user drage thumb to move , it will check is user mouse out of the range.
         * if so , when will stop move action.
         */
        private function thumbOnMouseMove(e:MouseEvent) : void
        {
            var pos:Number;
            var posRange:Number;
            var newScrollPosition:Number;
            if (direction == LAYOUT_HORIZONTAL)
            {
                pos = GeneralUtils.normalizingVlaue(track.mouseX - track.x - thumbScrollOffset,0,track.width - thumb.width);
                newScrollPosition = pos/(track.width - thumb.width) * (maxScrollPosition - minScrollPosition) + minScrollPosition;

                posRange = Math.abs(e.stageY - track.y);
            }
            else //loyout == LAYOUT_VERTICAL
            {
                pos = GeneralUtils.normalizingVlaue(track.mouseY - track.y - thumbScrollOffset , 0 ,track.height - thumb.height);
                newScrollPosition = pos/(track.height - thumb.height) * (maxScrollPosition - minScrollPosition) + minScrollPosition;

                posRange = Math.abs(e.stageX - track.x)
            }
            updateScrollPosition(true,newScrollPosition,pos);
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

        //========
        //== Track
        //========
        private var isTrackMoveLeftUP:Boolean // use to judgement the move direction

        private function trackOnMouseDown(e:MouseEvent) : void
        {
            if (direction == LAYOUT_HORIZONTAL)
            {
                isTrackMoveLeftUP = track.mouseX - thumb.x < 0;
            }
            else //loyout == LAYOUT_VERTICAL
            {
                isTrackMoveLeftUP = track.mouseY - thumb.y < 0;
            }
			// move the thumb once when user click the track,
			// then delay an time count then autoRepeat call moveByClickTrack() function
			// until checkIsReleaseTrack function return false, or OnMouseUpFunction call.
			moveByClickTrack();
            GlobalTick.instance.callLaterAfterTimerCount( moveByClickTrack ,
                                                          0.1, Math.floor((maxScrollPosition - minScrollPosition)/pageScrollSize),
                                                          0.5);
			
            stage.addEventListener(MouseEvent.MOUSE_UP,trackOnMouseUp,false,0,true);
        }

		/**
		 * call this function to move scrollPosition ,each time move pageScrollSize(or small that one.)
		 */		
        private function moveByClickTrack() : void
        {
            var mousePosition:Number;
            var newScrollPosition:Number;
            if (direction == LAYOUT_HORIZONTAL)
            {
                mousePosition = track.mouseX / (track.width - thumb.width) * (maxScrollPosition - minScrollPosition) + minScrollPosition;
            }
            else //loyout == LAYOUT_VERTICAL
            {
                mousePosition = track.mouseY / (track.height - thumb.height) * (maxScrollPosition - minScrollPosition) + minScrollPosition;
            }

            if (_scrollPosition < mousePosition)
            {
                newScrollPosition = Math.min(mousePosition,_scrollPosition+pageScrollSize);
            }
            else if (_scrollPosition > mousePosition)
            {
                newScrollPosition = Math.max(mousePosition,_scrollPosition-pageScrollSize);
            }
            else
            {
                releaseTrack();
                return;
            }
            newScrollPosition = GeneralUtils.normalizingVlaue(newScrollPosition,minScrollPosition,maxScrollPosition);
            if (!checkIsReleaseTrack(newScrollPosition))
            {
                updateScrollPosition(true , newScrollPosition);
            }
        }
		
		/**
		 * check is can move to newScrollPostion
		 * 1` if user Mouse is RollOut Track
		 * 2` if thumb already under userMouse(means current scrollPosition will change the direction)
		 * during those situation , can't move the scrollPosition and stop Track move state.
		 */		
        private function checkIsReleaseTrack(_newScrollPosition:Number) : Boolean
        {
            if (track.mouseX < track.x || track.mouseX > (track.x +track.width )
                || track.mouseY < track.y || track.mouseY > (track.y + track.height))
            {
                releaseTrack();
                return true;
            }
            if (isTrackMoveLeftUP)
            {
                if ((direction == LAYOUT_HORIZONTAL && track.mouseX > thumb.x) 
                    ||(direction == LAYOUT_VERTICAL && track.mouseY > thumb.y))
                {
                    releaseTrack();
                    return true;
                }
            }
            else
            {
                if ((direction == LAYOUT_HORIZONTAL && track.mouseX < thumb.x + thumb.width) 
                    ||(direction == LAYOUT_VERTICAL && track.mouseY < thumb.y + thumb.height))
                {
                    releaseTrack();
                    return true;
                }
            }
            return false;
        }

        private function trackOnMouseUp(e:MouseEvent) : void
        {
            releaseTrack();
        }

        private function releaseTrack() : void
        {
            stage.removeEventListener(MouseEvent.MOUSE_UP,trackOnMouseUp);
            GlobalTick.instance.removeTickNodeByFunction( moveByClickTrack );
        }

    }
}