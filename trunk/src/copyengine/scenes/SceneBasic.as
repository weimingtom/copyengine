package copyengine.scenes
{
    import copyengine.utils.tick.GlobalTick;

    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;

    public class SceneBasic implements IScene
    {
        private var sceneContainer:DisplayObjectContainer;

        public function SceneBasic()
        {
            sceneContainer = new Sprite();
        }

        /**
         * if child class need do something before initialze() then need to override this function
         * ( that thing normally happen can't initialze current screen in one tick
         *   ex: need get some data from server and wait for the call back)
         *
         * WARNINIG::
         * 				if override this function need to call SceneManger.instance.scenePerloadComplate() manually
         * 				and can't call super.startPerloadScene();
         *
         */
        public function startPerloadScene() : void
        {
            var f:Function = SceneManger.instance.scenePerloadComplate;
            GlobalTick.instance.callLaterAfterTickCount(f,1);
        }

        /**
         * when ScenenManger call addToStage() function ,then current screen.contianer will be add to the stage.
         * but mean time , perScreenContianer is not been remove from stage right now.
         * when ScenenManger call perSceneCleanComplate(). means perScreen has been remove form screen.
         *
         * if child class need to somethings during that time , need to override this function.
         */
        public function perSceneCleanComplate() : void
        {
        }

        /**
         * when SceneManger start to change next scene , then will call current screen.startLoadNextScene();
         *  in this state nextScenen is doing perLoad things, and current screen is not been remove stage yet.
         *
         *	if child class need to somethings during that time , need to override this function.
         */
        public function startLoadNextScene() : void
        {
        }

        /**
         * when next screen has been add to stage , and finished initialze() then call this function.
         * 	if child class need to somethings during that time , need to override this function.
         */
        public function nextSceneLoadComplate() : void
        {
        }

        /**
         * if child class need do something before dispose() then need to override this function
         * ( that thing normally happen need to add an effect when two scene change
         *   ex: current screen tween alpha 1~0 , in case to show next screen slowly)
         *
         * WARNINIG::
         * 				if override this function need to call SceneManger.instance.sceneCleanComplate() manually
         * 				and can't call super.cleanScene();
         *
         */
        public function cleanScene() : void
        {
            var f:Function = SceneManger.instance.sceneCleanComplate;
            GlobalTick.instance.callLaterAfterTickCount(f,1);
        }

        /**
         * override this function to initialize screen property
         */
        protected function initialize() : void
        {
        }

        /**
         * override this function to dispose current scrren property
         */
        protected function dispose() : void
        {
        }

        /**
         * if current scrren need to tick child objects then override this function.
         */
        public function tick() : void
        {
        }

        /**
         * @private
         *
         * will call by SceneManger, when current scene is add to stage. if child class need to something
         * need to override initialize() function.
         */
        public final function addToStage() : void
        {
            initialize();
        }

        /**
         * @private
         *
         * will call by SceneManger, when current scene is remove to stage.
         * if child class need to something need to override dispose() function.
         *
         */
        public final function removeFromStage() : void
        {
            dispose();
        }

        public final function get container() : DisplayObjectContainer
        {
            return sceneContainer;
        }

    }
}