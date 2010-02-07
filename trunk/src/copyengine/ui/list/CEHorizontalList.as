package copyengine.ui.list
{
    import copyengine.ui.list.cellrender.ICECellRender;
    import copyengine.utils.GeneralUtils;
    
    import flash.display.Sprite;
    import flash.geom.Rectangle;

    public class CEHorizontalList extends Sprite
    {
        public static const LAYOUT_HORIZONTAL:String = "horizontal";
        public static const LAYOUT_VERTICAL:String = "vertical";

        /**
         * should be either horizontal or vertical
         */
        private var layoutDirection:String;

        /**
         * store all CEList data.
         */
        private var dataProvider:CEDataProvider;

        /**
         *  each page display cellRender number
         */
        private var displayCount:int;

        /**
         * hold all visable CellRender , the number should be  displayCount+1;
         */
        private var visableCellRenderVector:Vector.<ICECellRender>;

        /**
         * each CEList cellRender should have same width and height ,and all equal with
         * eachCellRenderWidth and eachCellRenderHeight property
         */
        private var eachCellRenderWidth:Number;
        private var eachCellRenderHeight:Number;

        /**
         * define the padded for each cellRender.
         */
        private var contentPadding:Number;
        /**
         * define the max scrollPosition.
         */
        private var maxScrollPosition:Number;

        public function CEHorizontalList(_displayCount:int ,
                                         _cellRenderInstanceClass:Class,
                                         _layoutDirection:String,
                                         _dataProvider:CEDataProvider, 
                                         _eachCellRenderWidth:Number ,
                                         _eachCellRenderHeight:Number ,
                                         _contentPadding:Number)
        {
            super();
            displayCount = _displayCount;
            layoutDirection = _layoutDirection;
            dataProvider = _dataProvider;
            eachCellRenderWidth = _eachCellRenderWidth;
            eachCellRenderHeight = _eachCellRenderHeight;
            contentPadding = _contentPadding;

            initialize(_cellRenderInstanceClass);
        }

        private function initialize(_cellRenderInstanceClass:Class) : void
        {
            _scrollPosition = 0;
            maxScrollPosition = (dataProvider.totalDataCount - displayCount) * (getCellRenderBoundSizeByLayout() + contentPadding);

            visableCellRenderVector = new Vector.<ICECellRender>();
            for (var i :int = 0 ; i <= displayCount ; i++)
            {
                var cellRender:ICECellRender = new _cellRenderInstanceClass();
                cellRender.initialize();
                cellRender.cellIndex = i;
                cellRender.setData(dataProvider.getDataByIndex(i) );
                addChild(cellRender.container);
                visableCellRenderVector.push(cellRender);
            }

            setVisibleCellRenderByScrollPosition();

            if (layoutDirection == LAYOUT_HORIZONTAL)
            {
                this.scrollRect = new Rectangle(0,0,displayCount*(eachCellRenderWidth+contentPadding) - contentPadding,eachCellRenderHeight);
            }
            else // layout == LAYOUT_VERTICAL
            {
                this.scrollRect = new Rectangle(0,0,eachCellRenderWidth,displayCount*(eachCellRenderHeight+contentPadding) - contentPadding);
            }
        }

        private function dispose() : void
        {
            removeListener();

            for each (var cellRender : ICECellRender in visableCellRenderVector)
            {
                GeneralUtils.removeTargetFromParent(cellRender.container);
                cellRender.dispose();
            }
            dataProvider.dispose();
            GeneralUtils.clearChild(this);

            dataProvider = null;
            visableCellRenderVector = null;
        }

        private function addListener() : void
        {

        }

        private function removeListener() : void
        {

        }

        //===========
        //=Scroll Function
        //===========
        /**
         * the four function if can execute(not return by check already turn to end/top) then will return true
         *
         * For
         * scrollToNext() , scrollToPrevious() function if the last/top visible cellRender are not fullly been see
         * then will scroll to let the cellRender fullly be see. if already did that then will scroll to next or previous one.
         *
         * For
         * scrollToNextPage() , scrollToPreviousPage() function , if the last/top visible cellRender are not fullly been see
         * then we scroll pageNumber -1 item numbers, else we scroll pageNumbers.
         *
         */
        public function scrollToNext() : Boolean
        {
            return false;
        }

        public function scrollToPrevious() : Boolean
        {
            return false;
        }

        public function scrollToNextPage() : Boolean
        {
            return false;
        }

        public function scrollToPreviousPage() : Boolean
        {
            return false;
        }

        /**
         * scrollPosition is use to determine which item will showing in the screen,
         * and where are the item are showing.
         * we can imagine all items are arrange in horizontal/vertical orders . and the
         * List just like an camera, and scrollPosition just define the camera position.
         *
         * all Scrolling function finally always call this function to move the "camera"
         */
        private var _scrollPosition:Number = 0;
        private var oldScrollPosition:Number = 0;

        public function get scrollPosition() : Number
        {
            return _scrollPosition;
        }

        public function set scrollPosition(value:Number) : void
        {
            if (value == _scrollPosition)
            {
                return;
            }
            else
            {
                oldScrollPosition = _scrollPosition;
                _scrollPosition = GeneralUtils.normalizingVlaue(value,0,maxScrollPosition);
                scrollListPosition();
            }
        }

        private function scrollListPosition() : void
        {
            recycleCellRender();
            setVisibleCellRenderByScrollPosition();
        }

        /**
         * if the scrollDelta more than one cellRenderWidth/cellRenderHeight then
         * we can sure that cellRender has been scroll out of the screen ,and we can reuse it.
         *
         * this function goal is to initialize all visable cellRender,reuse that cellRender which already
         * out of screen. others are just keep it.
         *
         */
        private function recycleCellRender() : void
        {
            var currentCellIndex:int;
            var reuseIndex:int;
			var firstVisableIndex:int = calculateFirstVisableCellRenderIndexByScrollPosition();
            //scroll to increase cellIndex
            if (_scrollPosition > oldScrollPosition)
            {
                reuseIndex = firstVisableIndex - visableCellRenderVector[0].cellIndex;
				currentCellIndex  = firstVisableIndex;
                for (var cellRenderIndex:int = 0 ; cellRenderIndex <= displayCount ; cellRenderIndex++)
                {
                    if (reuseIndex <= displayCount)
                    {
                        swapICECellRender(cellRenderIndex,reuseIndex);
                    }
                    else
                    {
                        recycleCellRenderByCellIndex(cellRenderIndex,currentCellIndex);
                    }
                    reuseIndex++;
                    currentCellIndex++;
                }
            }
            //scroll to decrease cellIndex;
            else
            {
                reuseIndex = firstVisableIndex - visableCellRenderVector[0].cellIndex + displayCount;
				currentCellIndex  = firstVisableIndex + displayCount;
                for (var cellRenderIndex2:int = displayCount ; cellRenderIndex2 >= 0 ; cellRenderIndex2--)
                {
                    if (reuseIndex >= 0)
                    {
                        swapICECellRender(cellRenderIndex2,reuseIndex);
                    }
                    else
                    {
                        recycleCellRenderByCellIndex(cellRenderIndex2,currentCellIndex);
                    }
                    reuseIndex--;
                    currentCellIndex--;
                }
            }
        }

        private function recycleCellRenderByCellIndex(_cellRenderIndex:int , _cellIndex:int) : void
        {
            var cellRender:ICECellRender = visableCellRenderVector[_cellRenderIndex];
            cellRender.recycle();
            cellRender.cellIndex = _cellIndex;
            GeneralUtils.removeTargetFromParent(cellRender.container);
			
			// if the scrollPosition is maxScrollPosition ,then the last cellRender is empty cellRender
            var data:Object = dataProvider.getDataByIndex(_cellIndex);
            if (data != null)
            {
                cellRender.setData(data);
            }
        }

        private function swapICECellRender(_index1:int ,_index2:int) : void
        {
            if (_index1 != _index2)
            {
                var swapICECellRender:ICECellRender = visableCellRenderVector[_index1];
                visableCellRenderVector[_index1] = visableCellRenderVector[_index2];
                visableCellRenderVector[_index2] = swapICECellRender;
            }
        }

        /**
         * all cellRender number should be: displayCount + 1;
         * based on current start CellRender Index to arrange those cellRender position.
         */
        private function setVisibleCellRenderByScrollPosition() : void
        {
            var cellRenderPos:Number = -calculateOffsetOfFirstVisableCellRenderByScrollPosition();
            for (var i:int = 0 ; i<= displayCount ; i++)
            {
                var cellRender:ICECellRender = visableCellRenderVector[i];
                addChild(cellRender.container);
                if (layoutDirection == LAYOUT_HORIZONTAL)
                {
                    cellRender.container.x = cellRenderPos;
                    cellRenderPos += (eachCellRenderWidth + contentPadding);
                }
                else // layoutDirection == LAYOUT_VERTICAL
                {
                    cellRender.container.y = cellRenderPos;
                    cellRenderPos += (eachCellRenderHeight + contentPadding);
                }
                cellRender.drawNow();
            }
        }

        /**
         * CEList will create (displayCount+1) cellRenders , this function will return the first
         * one of them cellIndex.
         */
        private function calculateFirstVisableCellRenderIndexByScrollPosition() : int
        {
            return Math.floor( _scrollPosition / (getCellRenderBoundSizeByLayout() + contentPadding ) );
        }

        private function calculateOffsetOfFirstVisableCellRenderByScrollPosition() : Number
        {
            return _scrollPosition - Math.floor(_scrollPosition/(getCellRenderBoundSizeByLayout()+contentPadding))*(getCellRenderBoundSizeByLayout()+contentPadding);
        }


        /**
         * with different layout will return different bound.
         * LAYOUT_HORIZONTAL --> eachCellRenderWidth
         * LAYOUT_VERTICAL -->       eachCellRenderHeight
         */
        private function getCellRenderBoundSizeByLayout() : Number
        {
            if (layoutDirection == LAYOUT_HORIZONTAL)
            {
                return eachCellRenderWidth;
            }
            else // layoutDirection == LAYOUT_VERTICAL
            {
                return eachCellRenderHeight
            }
        }

    }
}