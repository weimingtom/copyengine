package copyengine.scenes
{
    import copyengine.debug.DebugLog;
    import copyengine.utils.tick.GlobalTick;

    /**
     * SceneManger is use to management each scene.(scene is like AS's stage.).
     *
     * @author Tunied
     *
     */
    public class SceneManger
    {
        private static var _instance:SceneManger;

        public static function get instance() : SceneManger
        {
            if (_instance == null)
            {
                _instance = new SceneManger();
            }
            return _instance;
        }

        /**
         * each game should own  ISceneFactory , and pass it to SceneManger throw initialize function
         */
        private var sceneFactory:ISceneFactory

        /**
         * hold current screen scene.
         */
        private var currentScene:IScene;

        /**
         * when call changeScene() function , will use this property to hold the sceen which will change later.
         */
        private var nextScene:IScene;

        /**
         * an boolean value to flag current is in changeSceen process or not.
         * if changeSceen process start ,then will not be stoped.
         */
        private var isChangingScreen:Boolean = false;

        public function SceneManger()
        {
        }

        /**
         * Should call this function to initialze SceneManger before use it.
         *
         * @param _sceneFactory    each game need to provide an class implemetns this interface.
         *
         */
        public function initialize(_sceneFactory:ISceneFactory) : void
        {
            sceneFactory = _sceneFactory;
        }

        /**
         *start change current screen to next screen
         *
         * WARNINIG:: is the change progress start then can't be stop.
         *
         * @param _sceneName        will use this as an key and get the screen from sceneFactory
         *
         */
        public function changeScene(_sceneName:String) : void
        {
            if (isChangingScreen)
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

        /**
         * @private
         *
         *  in change screen progress , when next screen perload complate then call this functon
         */
        public function scenePerloadComplate() : void
        {
            CopyEngineAS.screenLayer.addChild(nextScene.container);
            nextScene.addToStage();
            if (currentScene != null)
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

        /**
         * @private
         *
         * in change screen progress when current screen clean complate then call this function.
         *
         */
        public function sceneCleanComplate() : void
        {
            CopyEngineAS.screenLayer.removeChild(currentScene.container);
            currentScene.removeFromStage();
            nextScene.perSceneCleanComplate();
            currentScene = nextScene;
            nextScene = null;
            isChangingScreen = false
        }

        /**
         * when call changeScene() , it will not start change screen immediately.
         * it will wait to next tick then start to change the screen.
         * doing this is to avoid some bugs.
         *
         * ex:
         *
         * var mc:MovieClip = new MovieClip();
         * SceneManger.changeScreen(nextScreen);
         * mc.gotoAndPlay(5);
         *
         * if we change the screen immediately , ScreeeManger will call current dispose();
         * and then go to next line call mc.gotoAndPlay(5) . if we set mc = null in dispose() function.
         * then we will get an error when call mc.gotoAndPlay(5);
         *
         */
        private function doChangeScene() : void
        {
            if (currentScene != null)
            {
                currentScene.startLoadNextScene();
            }
            nextScene.startPerloadScene();
        }

    }
}