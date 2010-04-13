package copyengine.scenes
{
	import game.scene.CEDragDropScreen;
	import game.scene.testUIComponent.CEUICompoentTestScene;
	import game.scene.IsoHexScene;
	import game.scene.testIso.IsoSceneTest;
	import game.scene.PerLoaderScene;
	import game.scene.TestCacheAlphaBitmap;
	import game.scene.TestCacheScene;

	public class SceneFactory implements ISceneFactory
	{
		public static const FIRST_INITIALIZE_SCENE:String = SCENE_ISOSCENE_TEST;
		
		public static const SCENE_PERLOADER:String = "SceneFactory_Scenen_PerLoader";
		public static const SCENE_CEUICOMPONENT_TEST_SCENE:String = "SceneFactory_Scenen_CEUICompoent_Test_Scene";
		public static const SCENE_DRAGDROP:String = "SceneFactory_Scenen_DragDrop"
		public static const SCENE_EMPTY:String = "SceneFactory_Empty";
		public static const SCENE_ISOHEX:String = "SceneFactory_IsoHex";
		public static const SCENE_TEST_CACHE_SCENE:String = "SceneFactory_TestCacheScene"
		public static const SCENE_ISOSCENE_TEST:String = "SceneFactory_IsoSceneTest";
		public static const SCENE_TEST_CACHE_ALPHA_BITMAP:String = "SceneFactory_TestCacheAlphaBitmap";
		
		
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
				case SCENE_ISOHEX:
					return new IsoHexScene()
					break;
				case SCENE_TEST_CACHE_SCENE:
					return new TestCacheScene();
					break;
				case SCENE_ISOSCENE_TEST:
					return new IsoSceneTest();
					break;
				case SCENE_TEST_CACHE_ALPHA_BITMAP:
					return new TestCacheAlphaBitmap();
					break;
			}
			return null;
		}
	}
}