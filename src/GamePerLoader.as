package
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.Security;

	/**
	 * GamePerLoader is special gameScene.
	 * this class have two function .
	 * 1) this is the portal for the all game load , it's response for load the main game swf file
	 * 2) the is also an gameScene , when the main system is start , it will mangered by GameScene Manger as normal GameScene
	 */
	[SWF(width="640",height="700",backgroundColor="#FFFFFF",frameRate="24")]
	public class GamePerLoader extends Sprite implements IPerLoader
	{
		private var main:IMain;

		private var screenLoader:Loader
		private var mainLoader:Loader;

		private var loadingAnimation:MovieClip; // loading Screen UI animation.

		//=================
		//== Load MainGameJob
		//==================
		public function GamePerLoader()
		{
			screenLoader = new Loader();
			screenLoader.load( new URLRequest("../res/swf/preloader_asset.swf"));
			screenLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadComplate,false,0,true);

			mainLoader = new Loader();
			mainLoader.load( new URLRequest("CopyEngineAS.swf") );
			mainLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadMainComplate,false,0,true);
			
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
			main.initialize(this,this.stage);

			mainLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,loadMainComplate);
			mainLoader.unload();
			mainLoader = null;
		}

	}
}