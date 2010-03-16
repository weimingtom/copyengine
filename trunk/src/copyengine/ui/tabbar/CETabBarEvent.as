package copyengine.ui.tabbar
{
	import flash.events.Event;
	
	public class CETabBarEvent extends Event
	{
		/**
		 * When user click one of the subbutton , will trigger this event.
		 * this event means TabBar start to change the selected.
		 */		
		public static const START_CHANGE_SELECTED:String = "CETabBarEvent_StartChangeSelected";
		
		public function CETabBarEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}