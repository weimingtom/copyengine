package copyengine.ui.component
{
    import copyengine.ui.CESprite;
    import copyengine.ui.button.CEButton;
    import copyengine.ui.scrollbar.CEScrollBar;
    
    import flash.events.Event;
    import copyengine.ui.list.ICEListInteraction;

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
        private var listInteraction:ICEListInteraction;

        public function CEList(_displayCount:int , _listInteraction:ICEListInteraction,_layoutDiection:String,
                               _nextOneBtn:CEButton,_nextPageBtn:CEButton,
                               _prevOneBtn:CEButton , _prevPageBtn:CEButton,
                               _scrollBar:CEScrollBar)
        {
            super();
        }

        private function updateComponentState() : void
        {
            updateButtonState();
            updateScrollBarState();
        }

        private function updateButtonState() : void
        {
            if (listInteraction.isInFirstPage())
            {

            }
            else if (listInteraction.isInLastPage())
            {

            }
        }
		
		private function onScrollThumbMove(e:Event):void
		{
			listInteraction.scrollPosition = 1;
		}
		
        private function updateScrollBarState() : void
        {
			var a:Number = listInteraction.scrollPosition 
        }

    }
}