package copyengine.ui.component.tabbar
{
	import copyengine.ui.CESprite;
	import copyengine.ui.component.button.CESelectableButton;
	import copyengine.ui.component.tabbar.animation.ICETabBarAnimation;
	import copyengine.utils.GeneralUtils;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

	public class CETabBar extends CESprite
	{
		private var thumb:DisplayObject;
		
		private var bg:DisplayObject;
		
		private var animation:ICETabBarAnimation;

		/**
		 * contain all the subBtns
		 */
		private var subBtnsVector:Vector.<CESelectableButton>

		public function CETabBar(_subBtnsVector:Vector.<CESelectableButton>,_animation:ICETabBarAnimation = null , 
								 _bg:DisplayObject = null , _thumb:DisplayObject = null , _uniqueName:String = null)
		{
			super(true,_uniqueName);
			
			bg = _bg;
			thumb = _thumb;
			
			GeneralUtils.addTargetToParent(bg,this);
			GeneralUtils.addTargetToParent(thumb,this);
			subBtnsVector = _subBtnsVector
				
			animation = _animation;
			if (animation != null)
			{
				animation.setTarget(this,thumb);
			}
		}

		/**
		 * initialze subBtns , if there no animation then when user click the subBtn then will auto selected that btn
		 */
		override protected function initialize() : void
		{
			for each (var btn : CESelectableButton in subBtnsVector)
			{
				GeneralUtils.addTargetToParent(btn,this);
				btn.clickToSelect = false;
				GeneralUtils.addTargetEventListener(btn,MouseEvent.CLICK,onClickSubBtn);
			}
		}

		override protected function dispose() : void
		{
			if (animation != null)
			{
				animation.dispose();
			}
			while (subBtnsVector.length > 0)
			{
				var btn : CESelectableButton = subBtnsVector.pop();
				GeneralUtils.removeTargetEventListener(btn,MouseEvent.CLICK,onClickSubBtn);
				GeneralUtils.removeTargetFromParent(btn);
			}
			subBtnsVector = null;
		}

		private function onClickSubBtn(e:MouseEvent) : void
		{
			var target:CESelectableButton = e.currentTarget as CESelectableButton;
			for each (var btn : CESelectableButton in subBtnsVector)
			{
				if (btn == target)
				{
					btn.selected = true;
				}
				else
				{
					btn.selected = false;
				}
			}
			if (animation != null)
			{
				animation.changeSelected(target.uniqueName);
			}
			dispatchTabBarEvent(CETabBarEvent.CHANGE_SELECTED,target.uniqueName);
		}

		private function dispatchTabBarEvent(_eventType:String , _uniqueName:String) : void
		{
			if (hasEventListener(_eventType))
			{
				var event:CETabBarEvent = new CETabBarEvent(_eventType);
				event.selectedBtnUniqueName = _uniqueName;
				this.dispatchEvent(event);
			}
		}


	}
}