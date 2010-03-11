package copyengine.scenes
{
	import game.scene.CEUICompoentTestScene;
	import game.scene.PerLoaderScene;

    public class SceneFactory implements ISceneFactory
    {
		public static const SCENE_PERLOADER:String = "SceneFactory_Scenen_PerLoader";
		public static const SCENE_CEUICOMPONENT_TEST_SCENE:String = "SceneFactory_Scenen_CEUICompoent_Test_Scene";
		
        public function SceneFactory()
        {
        }

        public function createScene(_sceneName:String) : IScene
        {
            switch (_sceneName)
            {
				case SCENE_PERLOADER:
					return new PerLoaderScene();
					break;
				case SCENE_CEUICOMPONENT_TEST_SCENE:
					return new CEUICompoentTestScene();
					break;
            }
			return null;
        }
    }
}