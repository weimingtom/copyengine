package copyengine.ui.list
{
	import flash.events.Event;
	
	/**
	 * CEListCoreEvent event dispathch by CElistCore. the event contain all the list state info.
	 * 
	 * @author Tunied
	 * 
	 */	
	public class CEListCoreEvent extends Event
	{
		
		/**
		 * CEListCore scroll will take some time(releate to listInteraction), so when list start scroll then send this event,
		 * normally this event will interested by listControl  Component (use this event info to update there state.)
		 */		
		public static const SCROLL_START:String = "CEListCoreEvent_Scroll_Start";
		
		/**
		 * when CEListCore scrollPosition change ,then send this event; 
		 */		
//		public static const SCROLL:String = "CEListCoreEvent_Scroll";
		
		/**
		 * when user click one cellRenderItem , then send this event.
		 */		
		public static const ITEM_CLICK:String = "CEListCoreEvent_ItemClick";
		
		
		//===========
		//== Event
		//===========
		
		/**
		 * 
		 */		
		public var expectScrollPositon:Number;
		public var currentScrollPosition:Number;
		public var maxScrollPosition:Number;
		
		public var clickItemIndex:int;
		public var clickItemData:Object;
		
		public function CEListCoreEvent(type:String)
		{
			super(type, false, false);
		}
	}
}