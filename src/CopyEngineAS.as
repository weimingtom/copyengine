package
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;

	[SWF(width="640",height="700",backgroundColor="#FFFFFF",frameRate="27")]
	public class CopyEngineAS extends Sprite implements IMain
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

		public static function get gameDialogLayer() : DisplayObjectContainer
		{
			return _instance.gameDialogLayer;
		}

		public static function get screenLayer() : DisplayObjectContainer
		{
			return _instance.screenLayer;
		}

		public static function get perLoaderContainer() : DisplayObjectContainer
		{
			return _instance.gamePerLoader.container;
		}

		public static function cleanGamePerLoader() : void
		{
			_instance.gamePerLoader.destory();
			_instance.gamePerLoader = null;
		}

		//================
		//== Engine
		//================
		public var gamePerLoader:IPerLoader;

		/**
		 *  layer structure
		 */
		private var gameDialogLayer:DisplayObjectContainer;
		private var screenLayer:DisplayObjectContainer;

		public function CopyEngineAS()
		{
			this.addEventListener(Event.ADDED_TO_STAGE , onAddToStage,false,0,true);
		}

		public function initialize(_perLoader:IPerLoader , _stage:Stage) : void
		{
			gamePerLoader = _perLoader
			_stage.addChild(this);
		}

		private function onAddToStage(e:Event) : void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE , onAddToStage);

			screenLayer = new Sprite();
			addChild(screenLayer);

			gameDialogLayer = new Sprite();
			addChild( gameDialogLayer);

			_instance = this;
			CopyEngineFacade.instance.startup(this);
		}

	}
}