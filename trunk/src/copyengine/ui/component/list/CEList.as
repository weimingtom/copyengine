package copyengine.ui.component.list
{
	import copyengine.ui.CESprite;
	import copyengine.ui.component.button.CEButton;
	import copyengine.ui.component.list.dataprovider.CEDataProvider;
	import copyengine.ui.component.list.animation.ICEListAnimation;
	import copyengine.ui.component.scrollbar.CEScrollBarCore;
	import copyengine.ui.component.scrollbar.CEScrollBarCoreEvent;
	import copyengine.utils.GeneralUtils;

	import flash.events.MouseEvent;

	/**
	 * CEList is an list component, it include
	 * 				1) 6 buttons(nextOneBtn,prevOneBtn,nextPageBtn,prevPageBtn,firstOneBtn,lastOneBtn)
	 * 				2) 1 scrollBar
	 *
	 * user can init all or some of the component.
	 *
	 * for now CEList is not provide any events [TBD: maybe change later]
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

		override protected function initialize() : void
		{
			GeneralUtils.addTargetToParent(firstOneBtn,this);
			GeneralUtils.addTargetToParent(lastOneBtn,this);
			GeneralUtils.addTargetToParent(nextOneBtn,this);
			GeneralUtils.addTargetToParent(nextPageBtn,this);
			GeneralUtils.addTargetToParent(prevOneBtn,this);
			GeneralUtils.addTargetToParent(prevPageBtn,this);
			GeneralUtils.addTargetToParent(ceListCore,this);
			GeneralUtils.addTargetToParent(ceScrollBarCore,this);

			addListener();
		}

		override protected function dispose() : void
		{
			removeListener();
		}

		private function addListener() : void
		{
			GeneralUtils.addTargetEventListener(firstOneBtn,MouseEvent.CLICK,onFirstOneBtnClick);
			GeneralUtils.addTargetEventListener(lastOneBtn,MouseEvent.CLICK,onLastOneBtnClick);
			GeneralUtils.addTargetEventListener(nextOneBtn,MouseEvent.CLICK,onNextOneBtnClick);
			GeneralUtils.addTargetEventListener(nextPageBtn,MouseEvent.CLICK,onNextPageBtnClick);
			GeneralUtils.addTargetEventListener(prevOneBtn,MouseEvent.CLICK,onPrevOneBtnClick);
			GeneralUtils.addTargetEventListener(prevPageBtn,MouseEvent.CLICK,onPrevPageBtnClick);
			GeneralUtils.addTargetEventListener(ceListCore,CEListCoreEvent.SCROLL_START,ceListCoreOnScroll);
			GeneralUtils.addTargetEventListener(ceScrollBarCore,CEScrollBarCoreEvent.SCROLL,ceScrollBarCoreOnScroll);

		}

		private function removeListener() : void
		{
			GeneralUtils.removeTargetEventListener(firstOneBtn,MouseEvent.CLICK,onFirstOneBtnClick);
			GeneralUtils.removeTargetEventListener(lastOneBtn,MouseEvent.CLICK,onLastOneBtnClick);
			GeneralUtils.removeTargetEventListener(nextOneBtn,MouseEvent.CLICK,onNextOneBtnClick);
			GeneralUtils.removeTargetEventListener(nextPageBtn,MouseEvent.CLICK,onNextPageBtnClick);
			GeneralUtils.removeTargetEventListener(prevOneBtn,MouseEvent.CLICK,onPrevOneBtnClick);
			GeneralUtils.removeTargetEventListener(prevPageBtn,MouseEvent.CLICK,onPrevPageBtnClick);
			GeneralUtils.removeTargetEventListener(ceListCore,CEListCoreEvent.SCROLL_START,ceListCoreOnScroll);
			GeneralUtils.removeTargetEventListener(ceScrollBarCore,CEScrollBarCoreEvent.SCROLL,ceScrollBarCoreOnScroll);
		}

		public function initializeCEList(_dataProvider:CEDataProvider , _cellRenderInstanceClass:Class,_listInteraction:ICEListAnimation) : void
		{
			ceListCore.initializeCEListCore(_dataProvider,_cellRenderInstanceClass,_listInteraction);
			if (ceScrollBarCore != null)
			{
				ceScrollBarCore.initializeScrollBar(ceListCore.getLineScrollSize(),
					ceListCore.getPageScrollSize(),
					ceListCore.getMinScrollValue(),
					ceListCore.getMaxScrollValue());
			}
		}

		/**
		 * @see ceListCore.refreshDataProvider()
		 */
		public function refreshDataProvider(_dataProvider:CEDataProvider = null) : void
		{
			ceListCore.refreshDataProvider(_dataProvider);
			if (ceScrollBarCore != null)
			{
				ceScrollBarCore.refreshScrollBar(ceListCore.getLineScrollSize(),
					ceListCore.getPageScrollSize(),
					ceListCore.getMinScrollValue(),
					ceListCore.getMaxScrollValue(),0);
			}
		}

		//================
		//== Event Listener
		//================
		private function onFirstOneBtnClick(e:MouseEvent) : void
		{

		}

		private function onLastOneBtnClick(e:MouseEvent) : void
		{

		}

		private function onNextOneBtnClick(e:MouseEvent) : void
		{
			ceListCore.scrollNext();
		}

		private function onNextPageBtnClick(e:MouseEvent) : void
		{
			ceListCore.scrollNextPage();
		}

		private function onPrevOneBtnClick(e:MouseEvent) : void
		{
			ceListCore.scrollPrev();
		}

		private function onPrevPageBtnClick(e:MouseEvent) : void
		{
			ceListCore.scrollPrevPage();
		}

		private function ceListCoreOnScroll(e:CEListCoreEvent) : void
		{
			ceScrollBarCore.scrollPosition = e.expectScrollPositon;
		}

		private function ceScrollBarCoreOnScroll(e:CEScrollBarCoreEvent) : void
		{
			ceListCore.scrollPosition = e.scrollPosition;
		}

	}
}