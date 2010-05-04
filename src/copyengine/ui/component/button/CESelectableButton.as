package copyengine.ui.component.button
{

	import copyengine.ui.component.button.animation.ICESelectedButtonAnimation;

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.text.TextField;

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

		public function CESelectableButton(_buttonBg:DisplayObject, _lableFiled:TextField = null ,_labelTextKey:String=null ,
			_interaction:ICESelectedButtonAnimation=null, _uniqueName:String = null,_isClickToSelected:Boolean = true)
		{
			super(_buttonBg,_lableFiled,_labelTextKey, _interaction,_uniqueName);
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