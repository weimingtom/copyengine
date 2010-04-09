package
{
	import com.flashdynamix.utils.SWFProfiler;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.system.Security;

	[SWF(width="640",height="700",backgroundColor="#FFFFFF",frameRate="24")]
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

		public static function get dragdropLayer() : DisplayObjectContainer
		{
			return _instance.dragdropLayer;
		}

		public static function get perLoaderContainer() : DisplayObjectContainer
		{
			return _instance.gamePerLoader.container;
		}

		public static function get panelLayer() : DisplayObjectContainer
		{
			return _instance.panelLayer;
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
		 * configXML use in GameResManger initialize .
		 * when ths initialize finished then will set the property to null 
		 */		
		public var configXML:XML;

		/**
		 *  layer structure
		 */
		private var gameDialogLayer:DisplayObjectContainer;
		private var dragdropLayer:DisplayObjectContainer;
		private var panelLayer:DisplayObjectContainer;
		private var screenLayer:DisplayObjectContainer;


		public function CopyEngineAS()
		{
			this.addEventListener(Event.ADDED_TO_STAGE , onAddToStage,false,0,true);
		}

		public function initialize(_perLoader:IPerLoader , _stage:Stage ,  _config:XML) : void
		{
			configXML = _config;
			gamePerLoader = _perLoader
			
			//if not add this line will cause Security Sandbox error when mouse roll over an textField
			Security.allowDomain("*");
			
			//this function will trigger onAddToStage event, so need to call at the end
			_stage.addChild(this);
		}

		private function onAddToStage(e:Event) : void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE , onAddToStage);

			screenLayer = new Sprite();
			addChild(screenLayer);

			panelLayer = new Sprite();
			addChild(panelLayer);

			dragdropLayer = new Sprite();
			addChild(dragdropLayer);

			gameDialogLayer = new Sprite();
			addChild( gameDialogLayer);

			SWFProfiler.init(stage,this);

			_instance = this;
			CopyEngineFacade.instance.startup(this);
		}

	}
}