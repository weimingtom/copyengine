package copyengine.ui.component.button
{
	import copyengine.ui.CESprite;
	import copyengine.ui.component.button.animation.ICEButtonAnimation;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * CEButton is button component root.
	 * child class will deal with how the button changing it skin(ex:CEButtonFram , CEButtonTween)
	 * other class should only use CEButton , not it child class directly.
	 * ex:
	 * 		var button:CEButton = new CEButtonTween();
	 *
	 * @author Tunied
	 */
	public class CEButton extends CESprite
	{
		/**
		 * the background for the button
		 */
		protected var buttonBg:DisplayObject;

		/**
		 * if this button contain an labelField then use this key to initialize the labelField,
		 * this labelField should be an textField draw in buttonBg, and it should also named as "lable"
		 * 
		 * we use labelKey rather than an real text , because we also need that key to 
		 * embed font. or determine how to show tooltips
		 */
		protected var labelTextKey:String;


		protected var interaction:ICEButtonAnimation;

		public function CEButton(_buttonBg:DisplayObject ,_interaction:ICEButtonAnimation = null , 
								 _labelTextKey:String = null ,_uniqueName:String = null)
		{
			super(true,_uniqueName);
			buttonBg = _buttonBg;
			labelTextKey = _labelTextKey;
			interaction = _interaction;
			if (interaction != null)
			{
				interaction.setTarget( buttonBg );
			}
			
			if(labelTextKey != null)
			{
				var lable:TextField = buttonBg["lable"];
			}
			//need to add buttonSkin when create this button.
			//ex:
			//   var button:CEButton = new CEButton();
			//    button.width = 100; 
			// in this case can't set width right now , beacuse CEButton have no child , the widht always 0
			addChild(buttonBg);
		}

		override protected function initialize() : void
		{
			addListener();
		}

		override protected function dispose() : void
		{
			interaction.dispose();
			removeListener();
			interaction = null;
			buttonBg = null;
		}

		private function addListener() : void
		{
			this.addEventListener(MouseEvent.MOUSE_UP,onMouseUp,false,0,true);
			this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown,false,0,true);
			this.addEventListener(MouseEvent.ROLL_OVER,onMouseRollOver,false,0,true);
			this.addEventListener(MouseEvent.ROLL_OUT,onMouseRollOut,false,0,true);
		}

		private function removeListener() : void
		{
			this.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			this.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			this.removeEventListener(MouseEvent.ROLL_OVER,onMouseRollOver);
			this.removeEventListener(MouseEvent.ROLL_OUT,onMouseRollOut);
		}

		protected function onMouseRollOver(e:MouseEvent) : void
		{
			if (interaction != null)
			{
				interaction.onMouseRollOver(e);
			}
		}

		protected function onMouseRollOut(e:MouseEvent) : void
		{
			if (interaction != null)
			{
				interaction.onMouseRollOut(e);
			}
		}

		protected function onMouseUp(e:MouseEvent) : void
		{
			if (interaction != null)
			{
				interaction.onMouseUp(e);
			}
		}

		protected function onMouseDown(e:MouseEvent) : void
		{
			if (interaction != null)
			{
				interaction.onMouseDown(e);
			}
		}

	}
}