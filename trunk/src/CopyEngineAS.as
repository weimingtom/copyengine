package
{
    import copyengine.ui.panel.CEDialogLayer;
    
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.Event;

    [SWF(width="640",height="700",backgroundColor="#FFFFFF",frameRate="27")]
    public class CopyEngineAS extends Sprite
    {

        private static var _instance:CopyEngineAS;

		/**
		 * Some of Class may need stage to addSomeListener or get some property
		 * but those class are not in stage ,so . it's an convenient way to get the stage.
		 */
        public static function getStage() : Stage
        {
            return _instance.stage;
        }
		
		public static function get gameDialogLayer():DisplayObjectContainer
		{
			return _instance.gameDialogLayer;
		}
		
		public static function get screenLayer():DisplayObjectContainer
		{
			return _instance.screenLayer;
		}
		
		
		//================
		//== Engine
		//================
		public var gamePerLoad:GamePerLoader;
		
		/**
		 *  layer structure
		 */		
		private var gameDialogLayer:DisplayObjectContainer;
		private var screenLayer:DisplayObjectContainer;
		
        public function CopyEngineAS()
        {
            this.addEventListener(Event.ADDED_TO_STAGE , onAddToStage);
        }
		
        private function onAddToStage(e:Event) : void
        {
			screenLayer = new Sprite();
			addChild(screenLayer);
			
			gameDialogLayer = new CEDialogLayer();
			addChild( gameDialogLayer);
			
            _instance = this;
			
            this.removeEventListener(Event.ADDED_TO_STAGE , onAddToStage);
            CopyEngineFacade.instance.startup(this);
        }

    }
}