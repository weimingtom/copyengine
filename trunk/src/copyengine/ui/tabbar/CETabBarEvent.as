package copyengine.ui.tabbar
{
	import flash.events.Event;
	
	public class CETabBarEvent extends Event
	{
		/**
		 * When user click one of the subbutton , will trigger this event.
		 */		
		public static const CHANGE_SELECTED:String = "CETabBarEvent_ChangeSelected";
		
		//TODO:
		// we also can dispathch event when change tabBar animation start and end, CHANGE_SELECTED event is dispathch
		// when animation start ,and also changed subBtn selected property at that time . 
		//if have an requirement later :: need to do some logic when animation finished , then just dispatch END_CHANGE_SELECTED at that time.
//		public static const START_CHANGE_SELECTED:String;
//		public static const END_CHANGE_SELECTED:String;
		
		public var selectedBtnUniqueName:String;
		public function CETabBarEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}