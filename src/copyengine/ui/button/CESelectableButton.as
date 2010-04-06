package copyengine.ui.button
{

	import copyengine.ui.button.animation.ICESelectedButtonAnimation;

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

	public class CESelectableButton extends CEButton
	{
		/**
		 * attribute to record current state is selected or not. 
		 */		
		private var isSelected:Boolean = false;
		
		/**
		 * define 
		 * Is when user click the btn when auto set the btn to selected.
		 */		
		private var isClickToSelected:Boolean;

		public function CESelectableButton(_buttonBg:DisplayObject, _interaction:ICESelectedButtonAnimation=null,
			_isClickToSelected:Boolean = true,_labelTextKey:String=null, _isUseToolTips:Boolean=false,
			_isAutoInitialzeAndRemove:Boolean = true , _uniqueName:String = null)
		{
			super(_buttonBg, _interaction, _labelTextKey, _isUseToolTips,_isAutoInitialzeAndRemove,_uniqueName);
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

		public function get clickToSelect() : Boolean
		{
			return isClickToSelected;
		}

		public function set clickToSelect(_val:Boolean) : void
		{
			isClickToSelected = _val;
		}

		override protected function onMouseDown(e:MouseEvent) : void
		{
			if (isClickToSelected)
			{
				selected = !selected;
			}
			super.onMouseDown(e);
		}

		private function get selectedButtonInteraction() : ICESelectedButtonAnimation
		{
			return interaction as ICESelectedButtonAnimation;
		}

	}
}