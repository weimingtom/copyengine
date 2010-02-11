package copyengine.ui
{
    import copyengine.utils.GeneralUtils;

    import flash.display.Sprite;
    import flash.events.Event;

    /**
     *CESprite is all CopyEngine UI Component root class.
     * all component (Button , List , Panel etc) should extends this class.
	 * <br><br>
	 * this class will provide basic init/destory function, if child class need more operater
	 * then can override initialize/dispose function.
	 * <br><br>
	 * WARNING:
	 * Child class do not need:<br>
	 * 					1) addEventListener for Event.ADDED_TO_STAG/Event.REMOVED_FROM_STAGE<br>
	 * 					2) call GeneralUtils.clearChild(this) to clean child.<br>
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