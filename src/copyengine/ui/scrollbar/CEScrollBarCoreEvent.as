package copyengine.ui.scrollbar
{
    import flash.events.Event;

    public class CEScrollBarCoreEvent extends Event
    {
        /**
         * when scrollBar scrollPosition change by user operate, when dispatch this event.
         * if this change is cause by other CEComponent , then only update the state , not send this event.
         * @see CEScrollBar setScrollPosition function.
         */
        public static const SCROLL:String = "CEScrollBarEvent_Scroll";

        public var direction:String;
        public var delta:Number;
        public var scrollPosition:Number;

        public function CEScrollBarCoreEvent(_direction:String , _delta:Number , _scrollPosition:Number ,
                                             type:String, bubbles:Boolean=false, cancelable:Boolean=false)
        {
			direction = _direction;
			delta = _delta;
			scrollPosition = _scrollPosition;
            super(type, bubbles, cancelable);
        }
    }
}