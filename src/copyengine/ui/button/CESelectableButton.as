package copyengine.ui.button
{
    
    import copyengine.ui.button.animation.ICESelectedButtonAnimation;
    
    import flash.display.DisplayObject;
    import flash.events.MouseEvent;

    public class CESelectableButton extends CEButton
    {
        private var isSelected:Boolean = false;
		private var isClickToSelected:Boolean;
		
        public function CESelectableButton(_buttonBg:DisplayObject, _interaction:ICESelectedButtonAnimation=null,
                                           _isClickToSelected:Boolean = true,_labelTextKey:String=null, _isUseToolTips:Boolean=false)
        {
            super(_buttonBg, _interaction, _labelTextKey, _isUseToolTips);
			isClickToSelected = _isClickToSelected;
        }

        public function get selected() : Boolean
        {
            return isSelected;
        }

        public function set selected(_val:Boolean) : void
        {
            if (isSelected != _val)
            {
                isSelected = _val;
                selectedButtonInteraction.onSelectedChange(isSelected);
            }
        }
		
		override protected function onMouseDown(e:MouseEvent) : void
		{
			super.onMouseDown(e);
			if(isClickToSelected)
			{
				selected = !selected;
			}
		}
		
        private function get selectedButtonInteraction() : ICESelectedButtonAnimation
        {
            return interaction as ICESelectedButtonAnimation;
        }

    }
}