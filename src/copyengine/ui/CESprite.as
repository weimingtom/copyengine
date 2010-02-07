package copyengine.ui
{
    import copyengine.utils.GeneralUtils;

    import flash.display.Sprite;
    import flash.events.Event;

    /**
     *CESprite is all CopyEngine UI Component root class.
     * all component (Button , List , Panel etc) should extends this class.
	 * 
	 * this class will provide basic init/destory function, if child class need more
	 * need to override initialize/dispose function.
	 * 
	 * WARNING:
	 * Child class do not need:
	 * 					1) addEventListener for Event.ADDED_TO_STAG/Event.REMOVED_FROM_STAGE
	 * 					2) call GeneralUtils.clearChild(this) to clean child.
     *
     * @author Tunied
     *
     */
    public class CESprite extends Sprite
    {
        public function CESprite()
        {
            super();
            this.addEventListener(Event.ADDED_TO_STAGE,initCESprite,false,0,true);
            this.addEventListener(Event.REMOVED_FROM_STAGE,disposeCESprite,false,0,true);
        }

        private function initCESprite(e:Event) : void
        {
            this.removeEventListener(Event.ADDED_TO_STAGE,initCESprite);
            initialize();
        }

        private function disposeCESprite(e:Event) : void
        {
            this.removeEventListener(Event.REMOVED_FROM_STAGE,disposeCESprite);
            dispose();
            GeneralUtils.clearChild(this);
        }

        protected function initialize() : void
        {

        }

        protected function dispose() : void
        {

        }

    }
}