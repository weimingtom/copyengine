package copyengine.ui.panel.dialog
{
	import copyengine.ui.CESprite;
	
	/**
	 *CEPanelCore is a group component. it's pay attention to group behavior.
	 * like in gameScreen . the buttom will have a group component
	 * like have an tabbar , a list , three or four btns. when user click on of the btns. the group componet
	 * will all dispose or move down a little bit.
	 * CEPanelCore is those component parent's container.
	 * CEDialogCore is an special case of CEPanelCore. it will more fouce on the panel initialze/dispoese.
	 *  
	 * @author Tunied
	 * 
	 */	
	public class CEPanelCore extends CESprite
	{
		private static const STATE_DISPOSE:String = "CEPanelCore_State_Dispose";
		
		public function CEPanelCore(_uniqueName:String=null)
		{
			super(false, _uniqueName);
		}
		
		public function getComponentByUniqueName(_uniqueName:String):CESprite
		{
			return null;
		}
		
		public final function changeStateTo(_newState:String):void
		{
			if(_newState == STATE_DISPOSE)
			{
				if(animation != null)
				{
					animation.playanimation("disopose" , dispose);
				}
				else
				{
					dispose();
				}
			}
		}
		
	}
}