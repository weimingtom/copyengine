package copyengine.ui.component
{
	import copyengine.ui.CESprite;
	import copyengine.ui.button.CEButton;
	import copyengine.ui.list.CEDataProvider;
	import copyengine.ui.list.CEListCore;
	import copyengine.ui.list.CEListCoreEvent;
	import copyengine.ui.list.interaction.ICEListInteraction;
	import copyengine.ui.scrollbar.CEScrollBarCore;
	import copyengine.ui.scrollbar.CEScrollBarCoreEvent;
	import copyengine.utils.GeneralUtils;
	
	import flash.events.MouseEvent;

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
		}
		
		private function addListener():void
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
		
		private function removeListener():void
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
		
		public function initializeCEList(_dataProvider:CEDataProvider , _cellRenderInstanceClass:Class,_listInteraction:ICEListInteraction) : void
		{
			ceListCore.initializeCEListCore(_dataProvider,_cellRenderInstanceClass,_listInteraction);
			ceScrollBarCore.initializeScrollBar(ceListCore.getLineScrollSize(),ceListCore.getPageScrollSize(),ceListCore.getMinScrollValue(),ceListCore.getMaxScrollValue());
		}
		
		//================
		//== Event Listener
		//================
		private function onFirstOneBtnClick(e:MouseEvent):void
		{
			
		}
		
		private function onLastOneBtnClick(e:MouseEvent):void
		{
			
		}
		
		private function onNextOneBtnClick(e:MouseEvent):void
		{
			
		}
		
		private function onNextPageBtnClick(e:MouseEvent):void
		{
			
		}
		
		private function onPrevOneBtnClick(e:MouseEvent):void
		{
			
		}
		
		private function onPrevPageBtnClick(e:MouseEvent):void
		{
			
		}
		
		private function ceListCoreOnScroll(e:CEListCoreEvent):void
		{
			
		}
		
		private function ceScrollBarCoreOnScroll(e:CEScrollBarCoreEvent):void
		{
			
		}
		
	}
}