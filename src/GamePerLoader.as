package
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	[SWF(width="640",height="700",backgroundColor="#FFFFFF",frameRate="27")]
	public class GamePerLoader extends Sprite
	{
		private var screenLoader:Loader
		private var loadScreen:MovieClip;
		
		private var main:Object;
		private var mainLoader:Loader;
		
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
		
		public function destory():void
		{
			trace("GamePerLoader destory");
		}
		
		private function loadComplate(e:Event):void
		{
			loadScreen = e.target.loader.content as MovieClip;
			this.addChild(loadScreen);
		}
		
		private function loadMainComplate(e:Event):void
		{
			main = e.target.loader.content;
			main.gamePerLoad = this;
			this.addChild(main as DisplayObject);
		}
		
	}
}