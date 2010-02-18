package copyengine.ui.list
{
    import copyengine.ui.CESprite;
    import copyengine.ui.list.cellrender.ICECellRender;
    import copyengine.ui.list.interaction.ICEListInteraction;
    import copyengine.utils.GeneralUtils;

    import flash.events.MouseEvent;
    import flash.geom.Rectangle;

    /**
     * CEListCore is List component root , you should not use this class directly.
     * this class should use combination with other CEComponent (ICEListAnimation ,Button ,ScrollBar etc).
     *
     * CEList only provide baise get/set scrollPosition , get/set selected
     * other useful function (pageDown,pageUp etc )should provide by child class or the class combination with CEListCore.
     *
     * use this class need to
     * 					1) set an dataProvide					(the list data source)
     * 					2) set layoutDirection 					(either horizontal or vertical)
     * 					3) set displayCount    					(each page display CellRender number)
     * 					4) set cellRender width/height		(the visable cellRender widht/height should all the same)
     * 					5) set contentPadding					(the distance bewteen each cellRender)
     * 					6) set cellRenderInstanceClass      (the cellRender class, this clas should implements ICECellRender)
     *
     * @author Tunied
     *
     */
    public class CEListCore extends CESprite
    {
        public static const LAYOUT_HORIZONTAL:String = "horizontal";
        public static const LAYOUT_VERTICAL:String = "vertical";

        /**
         *  each page display cellRender number
         */
        private var displayCount:int;

        /**
         * should be either horizontal or vertical
         */
        private var layoutDirection:String;

        /**
         * store all CEList data.
         */
        private var dataProvider:CEDataProvider;

        /**
         * each CEList cellRender should have same width and height ,and all equal with
         * eachCellRenderWidth and eachCellRenderHeight property
         */
        private var eachCellRenderWidth:Number;
        private var eachCellRenderHeight:Number;

        /**
         * the cellRender class, this clas should implements ICECellRender
         */
        private var cellRenderInstanceClass:Class;

        /**
         * listInteraction use to deal will list scrolling animation.
         */
        private var listInteraction:ICEListInteraction;

        /**
         * define the padded for each cellRender.
         */
        private var contentPadding:Number;

        /**
         * define the max scrollPosition.
         *
         * WARNINIG:
         * 			calculate by initialize function no need set by user.
         */
        private var maxScrollPosition:Number;

        /**
         *this number should be eachCellRenderWidth/eachCellRenderHeight + contentPadding
         * store this number is use to do the math fast.
         *
         * WARNINIG:
         * 			calculate by initialize function no need set by user.
         */
        private var cellRenderDistance:Number;

        /**
         * hold all visable CellRender , the number should be  displayCount+1;
         *
         * WARNINIG:
         * 			create by initialize function no need set by user.
         */
        private var visableCellRenderVector:Vector.<ICECellRender>;

        /**
         *
         * @param _displayCount							@see displayCount
         * @param _cellRenderInstanceClass		use this class to initialze each visableCellRender(this class should implements ICECellRender)
         * @param _listInteractionClass				@see listInteractionClass
         * @param _layoutDirection						@see layoutDirection
         * @param _dataProvider							@see dataProvider
         * @param _eachCellRenderWidth			@see eachCellRenderWidth
         * @param _eachCellRenderHeight			@see eachCellRenderHeight
         * @param _contentPadding						@see contentPadding
         *
         */
        public function CEListCore(_displayCount:int ,
                                   _cellRenderInstanceClass:Class,
                                   _listInteractionClass:Class,
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
            cellRenderInstanceClass = _cellRenderInstanceClass;

            listInteraction =  new _listInteractionClass() as ICEListInteraction;
            listInteraction.target = this;
        }

        /**
         * @param args[0]  	cellRenderInstanceClass
         */
        override protected function initialize() : void
        {
            _scrollPosition = 0;
            maxScrollPosition = (dataProvider.totalDataCount - displayCount) * (getCellRenderBoundSizeByLayout() + contentPadding);

            cellRenderDistance = getCellRenderBoundSizeByLayout() + contentPadding;

            visableCellRenderVector = new Vector.<ICECellRender>();
            for (var i :int = 0 ; i <= displayCount ; i++)
            {
                var cellRender:ICECellRender = new cellRenderInstanceClass();
                cellRender.initialize();
                cellRender.cellIndex = i;
                cellRender.setData(dataProvider.getDataByIndex(i) );
                addChild(cellRender.container);
                visableCellRenderVector.push(cellRender);
                addCellRenderListener(cellRender);
            }
            cellRenderInstanceClass = null;

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

        override protected function dispose() : void
        {
            listInteraction.dispose();
            for each (var cellRender : ICECellRender in visableCellRenderVector)
            {
                removeCellRenderListener(cellRender)
                GeneralUtils.removeTargetFromParent(cellRender.container);
                cellRender.dispose();
            }
            dataProvider.dispose();

            dataProvider = null;
            visableCellRenderVector = null;
        }

        private function addCellRenderListener(_cellRender:ICECellRender) : void
        {
            _cellRender.container.addEventListener(MouseEvent.CLICK,onCellRenderClick,false,0,true);
        }

        private function removeCellRenderListener(_cellRender:ICECellRender) : void
        {
            _cellRender.container.removeEventListener(MouseEvent.CLICK,onCellRenderClick);
        }

        private function onCellRenderClick(e:MouseEvent) : void
        {

        }


        //================
        //==lnteraction Function
        //================
        public function scrollNext() : void
        {
            var offset:Number = calculateOffsetOfFirstVisableCellRender();
            if (offset > 0)
            {
                scrollPosition = Math.min(_scrollPosition + cellRenderDistance - offset,maxScrollPosition);
            }
            else
            {
                scrollPosition = Math.min( _scrollPosition + cellRenderDistance,maxScrollPosition);
            }
        }

        public function scrollPrev() : void
        {
            var offset:Number = calculateOffsetOfFirstVisableCellRender();
            if (offset > 0)
            {
                scrollPosition = Math.max(0,_scrollPosition - offset);
            }
            else
            {
                scrollPosition = Math.max(0,_scrollPosition - cellRenderDistance);
            }
        }

        private function scrollNextPage() : void
        {
            scrollPosition = Math.min(_scrollPosition + cellRenderDistance*displayCount - contentPadding,maxScrollPosition - calculateOffsetOfFirstVisableCellRender());
        }

        private function scrollPrevPage() : void
        {
            scrollPosition = Math.max(0, _scrollPosition - cellRenderDistance*displayCount - contentPadding + calculateOffsetOfFirstVisableCellRender());
        }

        //=============
        //== Scroll Position
        //=============
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
                listInteraction.scrollPosition = value;
                    // TODO: CEListCore event only dispatch , if this change is cause by user operate,
                    //            otherwise the event will dispatch by CEList
                    //
                    //                if (hasEventListener(CEListCoreEvent.SCROLL_START))
                    //                {
                    //                    var event:CEListCoreEvent = new CEListCoreEvent(CEListCoreEvent.SCROLL_START);
                    //                    event.maxScrollPosition = maxScrollPosition;
                    //                    event.expectScrollPositon = value;
                    //                    event.currentScrollPosition = _scrollPosition;
                    //                    this.dispatchEvent( event);
                    //                    event = null;
                    //                }
            }
        }

        /**
         *	@private
         *
         *  this function should only call by listInteraction when the scrollPosition change,
         *  set scrollPosition(value:Number) will ask listInteraction to change the scrollPositon.
         *  listInteraction will releate to it implement to decide how many pixel it will change each render.
         *  use an set function because it convenience for tweener to change the property.
         */
        public function set reallScrollPosition(value:Number) : void
        {
            oldScrollPosition = _scrollPosition;
            _scrollPosition = GeneralUtils.normalizingVlaue(value,0,maxScrollPosition);
            scrollListPosition();
        }

        public function get reallScrollPosition() : Number
        {
            return _scrollPosition;
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
            var firstVisableIndex:int = calculateFirstVisableCellRenderIndexByScrollPosition(); //fist cellRender
            //scroll to increase cellIndex
            if (_scrollPosition > oldScrollPosition)
            {
                //reuse start index , form reuseIndex~ displayCount those cellRender can use in this render, others need to recycle
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
                // this time is difine the last index from reuseIndex~0 those cellRender can be use in this render ,others are need to recyle
                // also need to pay attention , this time is init from last cellRender
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
            var cellRenderPos:Number = -calculateOffsetOfFirstVisableCellRender();
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

        /**
         *  	               ||00000-00000-00000-00000||-00000   ==> normal
         * offset -> 000||00-00000-00000-00000-00||000        ==> offset is 000
         *
         * offset always >= 0
         *
         */
        private function calculateOffsetOfFirstVisableCellRender() : Number
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