package copyengine.scenes
{
	import copyengine.debug.DebugLog;
	import copyengine.utils.tick.GlobalTick;


    public class SceneManger
    {
        private static var _instance:SceneManger;

        public static function get instance() : SceneManger
        {
            if (_instance == null)
            {
                _instance = new SceneManger();
            }
            return instance;
        }

        private var sceneFactory:ISceneFactory
        private var currentScene:IScene;
        private var nextScene:IScene;
		private var isChangingScreen:Boolean = false;

        public function SceneManger(_sceneFactory:ISceneFactory)
        {
        }

        public function initialize(_sceneFactory:ISceneFactory) : void
        {
            sceneFactory = _sceneFactory;
        }

        public function changeScene(_sceneName:String) : void
        {
			if(isChangingScreen)
			{
				DebugLog.instance.log("Try to Change Another Screen during ScreenChanging" ,DebugLog.LOG_TYPE_ERROR);
				return;
			}
			else
			{
				isChangingScreen = true
				nextScene = sceneFactory.createScene(_sceneName);
				GlobalTick.instance.callLaterAfterTickCount(doChangeScene);
			}
        }

        public function scenePerloadComplate() : void
        {
			CopyEngineAS.screenLayer.addChild(nextScene.container);
			nextScene.addToStage();
			if(currentScene != null)
			{
				currentScene.nextSceneLoadComplate();
				currentScene.cleanScene();
			}
			else
			{
				currentScene = nextScene;
				currentScene.perSceneCleanComplate();
				nextScene = null;
				isChangingScreen = false;
			}
        }

        public function sceneCleanComplate() : void
        {
			CopyEngineAS.screenLayer.removeChild(currentScene);
			currentScene.removeFromStage();
			nextScene.perSceneCleanComplate();
			currentScene = nextScene;
			nextScene = null;
			isChangingScreen = false
        }
		
		private function doChangeScene():void
		{
			if(currentScene != null)
			{
				currentScene.startLoadNextScene();
			}
			nextScene.startPerloadScene();
		}
		
    }
}