package copyengine.ui.tabbar
{
	import flash.events.Event;
	
	public class CETabBarEvent extends Event
	{
		/**
		 * 
		 */		
		public static const START_CHANGE_SELECTED:String = "CETabBarEvent_StartChangeSelected";
		
		public function CETabBarEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}