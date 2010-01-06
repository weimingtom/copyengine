package
{
	import copyengine.scenes.IGameScene;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;

	/**
	 * GamePerLoader is special gameScene.
	 * this class have two function .
	 * 1) this is the portal for the all game load , it's response for load the main game swf file
	 * 2) the is also an gameScene , when the main system is start , it will mangered by GameScene Manger
	 */
	[SWF(width="640",height="700",backgroundColor="#FFFFFF",frameRate="27")]
	public class GamePerLoader extends Sprite implements IGameScene
	{
		private var screenLoader:Loader
		private var mainLoader:Loader;

		private var loadScreen:MovieClip; // loading Screen UI animation.

		public function GamePerLoader()
		{
			screenLoader = new Loader();
			screenLoader.load( new URLRequest("../res/swf/preloader_asset.swf"));
			screenLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadComplate);

			mainLoader = new Loader();
			mainLoader.load( new URLRequest("CopyEngineAS.swf") );
			mainLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadMainComplate);

			super();
		}

		public function destory() : void
		{
		}

		private function loadComplate(e:Event) : void
		{
			loadScreen = e.target.loader.content as MovieClip;
			this.addChild(loadScreen);
			screenLoader.unload();
			screenLoader = null;
		}

		private function loadMainComplate(e:Event) : void
		{
			var main:Object = e.target.loader.content;
			main["gamePerLoad"] = this;
			stage.addChild(main as DisplayObject);
		}

		public function initScene() : void
		{
			//nothing need to do here
		}

		public function destoryScene() : void
		{
			this.parent.removeChild(this);
			trace("GamePerLoader destory");
		}

		public function get sceneContainer() : DisplayObjectContainer
		{
			return this;
		}

		public function tick() : void
		{
			//do nothing
		}


	}
}