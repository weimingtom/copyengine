package
{
    import flash.display.DisplayObject;
    import flash.display.Loader;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.Event;
    import flash.net.URLRequest;

    /**
     * GamePerLoader is special gameScene.
     * this class have two function .
     * 1) this is the portal for the all game load , it's response for load the main game swf file
     * 2) the is also an gameScene , when the main system is start , it will mangered by GameScene Manger as normal GameScene
     */
    [SWF(width="640",height="700",backgroundColor="#FFFFFF",frameRate="27")]
    public class GamePerLoader extends Sprite
    {
        private var screenLoader:Loader
        private var mainLoader:Loader;

        public var loadSceeenSSSS:MovieClip; // loading Screen UI animation.

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
			
            super();
        }

        private function loadComplate(e:Event) : void
        {
			screenLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,loadComplate);
            loadSceeenSSSS = e.target.loader.content as MovieClip;
            this.addChild(loadSceeenSSSS);
            screenLoader.unload();
            screenLoader = null;
        }

        private function loadMainComplate(e:Event) : void
        {
			mainLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,loadMainComplate);
            var main:Object = e.target.loader.content;
            var mainStage:Stage = this.stage;

            main["gamePerLoader"] = this;
            stage.removeChild(this);

            mainStage.addChild(main as DisplayObject);
            mainStage = null;

            main = null;

            mainLoader.unload();
            mainLoader = null;
        }
		
    }
}