package copyengine.scenes
{
	import game.scene.CEDragDropScreen;
	import game.scene.CEUICompoentTestScene;
	import game.scene.PerLoaderScene;

    public class SceneFactory implements ISceneFactory
    {
		public static const SCENE_PERLOADER:String = "SceneFactory_Scenen_PerLoader";
		public static const SCENE_CEUICOMPONENT_TEST_SCENE:String = "SceneFactory_Scenen_CEUICompoent_Test_Scene";
		public static const SCENE_DRAGDROP:String = "SceneFactory_Scenen_DragDrop"
		public static const SCENE_EMPTY:String = "SceneFactory_Empty";
		
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
				case SCENE_EMPTY:
					return new SceneBasic();
					break;
				case SCENE_DRAGDROP:
					return new CEDragDropScreen();
					break;
            }
			return null;
        }
    }
}