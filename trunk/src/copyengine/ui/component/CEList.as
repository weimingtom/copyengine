package copyengine.ui.component
{
    import copyengine.ui.CESprite;
    import copyengine.ui.button.CEButton;
    import copyengine.ui.list.CEDataProvider;
    import copyengine.ui.list.CEListCore;
    import copyengine.ui.scrollbar.CEScrollBarCore;

    /**
     * CEList is an list component, it include
     * 				1) 6 buttons(nextOneBtn,prevOneBtn,nextPageBtn,prevPageBtn,firstOneBtn,lastOneBtn)
     * 				2) 1 scrollBar
     *
     * user can init all or some of the component.
     *
     * @author Tunied
     *
     */
    public class CEList extends CESprite
    {
		/**
		 * turn to first/last element 
		 */		
		private var firstOneBtn:CEButton;
		private var lastOneBtn:CEButton;
		
		/**
		 * turn to next one/page element 
		 */		
		private var nextOneBtn:CEButton;
		private var nextPageBtn:CEButton;
		
		/**
		 *turn to prev one/page element. 
		 */		
		private var prevOneBtn:CEButton;
		private var prevPageBtn:CEButton;
		
		/**
		 * List 
		 */		
		private var ceListCore:CEListCore;
		
		/**
		 * ScrollBar 
		 */		
		private var ceScrollBarCore:CEScrollBarCore;
		
        public function CEList(_ceListCore:CEListCore , _ceScrollBarCore:CEScrollBarCore,
                               _nextOneBtn:CEButton,_nextPageBtn:CEButton,
                               _prevOneBtn:CEButton , _prevPageBtn:CEButton,
							   _firstOneBtn:CEButton , _lastOneBtn:CEButton
                               )
        {
			firstOneBtn = _firstOneBtn;
			lastOneBtn = _lastOneBtn;
			
			nextOneBtn = _nextOneBtn;
			nextPageBtn = _nextPageBtn;
			
			prevOneBtn = _prevOneBtn;
			prevPageBtn = _prevPageBtn;
			
			ceScrollBarCore = _ceScrollBarCore;
			ceListCore = _ceListCore;
			
            super();
        }
		
		/**
		 *can only call once when it initalize (will change later.)
		 *  
		 * @param _dataProvider
		 * 
		 */		
		public function setDataProvider(_dataProvider:CEDataProvider):void
		{
			
		}

    }
}