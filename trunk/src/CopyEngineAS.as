package
{
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.Event;

    [SWF(width="640",height="700",backgroundColor="#FFFFFF",frameRate="27")]
    public class CopyEngineAS extends Sprite
    {
        /**
         * Some of Class may need stage to addSomeListener or get some property
         * but those class are not in stage ,so . it's an convenient way to get the stage.
         */
        private static var _instance:CopyEngineAS;

        public static function getStage() : Stage
        {
            return _instance.stage;
        }

        public var gamePerLoad:GamePerLoader;

        public function CopyEngineAS()
        {
            this.addEventListener(Event.ADDED_TO_STAGE , onAddToStage);
        }

        private function onAddToStage(e:Event) : void
        {
            _instance = this;
            this.removeEventListener(Event.ADDED_TO_STAGE , onAddToStage);
            CopyEngineFacade.instance.startup(this);
        }

    }
}