package
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.Security;
	import flash.utils.ByteArray;

	/**
	 * GamePerLoader is special gameScene.
	 * this class have two function .
	 * 1) this is the portal for the all game load , it's response for load the main game swf file.
	 * 2) the is also include an loading animation , when load main scene complate , it will pass the animation to main game.
	 */
	[SWF(width="640",height="700",backgroundColor="#FFFFFF",frameRate="24")]
	public class GamePerLoader extends Sprite implements IPerLoader
	{
		private var main:IMain;
		
		private var configLoader:URLLoader;
		private var configXml:XML;
		
		private var screenLoader:Loader
		private var mainLoader:Loader;

		private var loadingAnimation:MovieClip; // loading Screen UI animation.
		
		//=================
		//== Load MainGameJob
		//==================
		public function GamePerLoader()
		{
			//get the configXml form game parameters. muse define one game parameters in html template named configPath
			configLoader = new URLLoader();
			configLoader.load( new URLRequest(loaderInfo.parameters["configPath"]) );
			configLoader.dataFormat = URLLoaderDataFormat.BINARY;
			configLoader.addEventListener(Event.COMPLETE,loadConfigComplate,false,0,true);

			Security.allowDomain("*");
			super();
		}

		public function destory() : void
		{
			loadingAnimation.parent.removeChild(loadingAnimation);
			this.parent.removeChild(this);

			loadingAnimation = null;
			main = null;
			screenLoader = null;
			mainLoader = null;
		}

		public function get container() : DisplayObjectContainer
		{
			return this;
		}
		
		private function loadConfigComplate(e:Event):void
		{
			var byteArray : ByteArray = configLoader.data as ByteArray;
			byteArray.uncompress();
			configXml = new XML(byteArray);
			
			configLoader.close();
			configLoader = null;
			
			trace(configXml.main.file.(@name =="Main").@path);
			mainLoader = new Loader();
			mainLoader.load( new URLRequest(configXml.main.file.(@name =="Main").@path) );
			mainLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadMainComplate,false,0,true);	
			
			trace(configXml.main.file.(@name == "LoadingAnimation").@path)
			screenLoader = new Loader();
			screenLoader.load( new URLRequest(configXml.main.file.(@name == "LoadingAnimation").@path));
			screenLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadComplate,false,0,true);
		}
		
		
		private function loadComplate(e:Event) : void
		{
			var resDomain:ApplicationDomain = e.currentTarget.applicationDomain;
			var resClass:Class = resDomain.getDefinition("EmptyLoader") as Class;
			loadingAnimation = new  resClass() as MovieClip;
			this.addChild(loadingAnimation);

			screenLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,loadComplate);
			screenLoader.unloadAndStop();

			screenLoader = null;
			resClass = null;
			resDomain = null;
		}

		private function loadMainComplate(e:Event) : void
		{
			main = e.target.loader.content as IMain;
			main.initialize(this,this.stage,configXml);

			mainLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,loadMainComplate);
			mainLoader.unload();
			mainLoader = null;
			configXml = null;
		}

	}
}