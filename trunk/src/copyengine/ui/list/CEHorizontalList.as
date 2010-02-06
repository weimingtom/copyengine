package copyengine.ui.list
{
    import copyengine.debug.DebugLog;
    import copyengine.ui.list.cellrender.ICECellRender;
    import copyengine.utils.GeneralUtils;

    import flash.display.Sprite;

    public class CEHorizontalList extends Sprite
    {
        public static const LAYOUT_HORIZONTAL:String = "horizontal";
        public static const LAYOUT_VERTICAL:String = "vertical";

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
         * temp vector should be same size as visableCellRenderVector . use it during
         * scrollPosition change , the goal is to hold one tiny memory to swap ICECellRender,
         * not each time to new an temp Vector.
         */
        private var tempVisableCellRenderVector:Vector.<ICECellRender>;

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

        private var layoutDirection:String;

        public function CEHorizontalList()
        {
            super();
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

        }

        public function scrollToPrevious() : Boolean
        {

        }

        public function scrollToNextPage() : Boolean
        {

        }

        public function scrollToPreviousPage() : Boolean
        {

        }

        /**
         * scrollPosition is use to determine which item will showing in the screen,
         * and where are the item are showing.
         * we can imagine all items are arrange in horizontal/vertical orders . and the
         * List just like an camera, and scrollPosition just define the camera position.
         *
         * all Scrolling function finally always call this function to move the "camera"
         */
        private var _scrollPosition:Number;
        private var oldScrollPosition:Number;

        //        private function get scrollPosition() : Number
        //        {
        //            return _scrollPosition;
        //        }

        private function set scrollPosition(value:Number) : void
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
            var firstIndex:int = calculateFirstVisableCellRenderIndexByScrollPosition();
            var reuseIndex:int;
            //scroll to increase cellIndex
            if (_scrollPosition > oldScrollPosition)
            {
                reuseIndex = firstIndex - visableCellRenderVector[0].cellIndex;
                for (var index:int = 0 ; index <= displayCount ; index++)
                {
                    if (reuseStartIndex < displayCount)
                    {
                        swapICECellRender(index,reuseIndex);
                    }
                    else
                    {
                        recycleCellRenderByCellIndex(index);
                    }
                    reuseIndex++;
                }
            }
            //scroll to decrease cellIndex;
            else
            {
                reuseIndex = firstIndex - visableCellRenderVector[0].cellIndex + displayCount -1;
                for (var index:int = displayCount ; index <= 0 ; index--)
                {
                    if (reuseIndex >= 0)
                    {
                        swapICECellRender(index,reuseIndex);
                    }
                    else
                    {
                        recycleCellRenderByCellIndex(index);
                    }
                    reuseIndex--;
                }
            }
        }

        private function recycleCellRenderByCellIndex(_index:int) : void
        {

        }

        private function swapICECellRender(_index1:int ,_index2:int) : void
        {
            if (_index1 != _index2)
            {
                var swapICECellRender:ICECellRender = visableCellRenderVector[_index1];
                visableCellRenderVector[_index1] = visableCellRenderVector[_index2];
                visableCellRenderVector[_index1] = swapICECellRender;
            }

        }

        private function calculateFirstVisableCellRenderIndexByScrollPosition() : int
        {
            return Math.floor( _scrollPosition / (getCellRenderBoundSizeByLayout() + contentPadding ) );
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
            else if (layoutDirection == LAYOUT_VERTICAL)
            {
                return eachCellRenderHeight
            }
            else
            {
                return 0;
                DebugLog.instance.log("CEListCore can't get the layout , the wrong layout is  :" + layoutDirection ,DebugLog.LOG_TYPE_ERROR);
            }
        }

        /**
         * all cellRender number should be: displayCount + 1;
         * based on current start CellRender Index to arrange those cellRender position.
         */
        private function setVisibleCellRenderByScrollPosition() : void
        {

        }

    }
}