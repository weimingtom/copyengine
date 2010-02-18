package copyengine.ui.scrollbar
{
    import flash.events.Event;

    public class CEScrollBarEvent extends Event
    {
        /**
         * when scrollBar scrollPosition change by user operate, when dispatch this event.
         * if this change is cause by other CEComponent , then only update the state , not send this event.
         * @see CEScrollBar setScrollPosition function.
         */
        public static const SCROLL:String = "CEScrollBarEvent_Scroll";

        public var direction:String;
        public var delta:Number;
        public var position:Number;

        public function CEScrollBarEvent(_direction:String , _delta:Number , _position:Number ,
                                         type:String, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
        }
    }
}