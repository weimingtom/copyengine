package game.scene
{
	import copyengine.scenes.IScene;
	import copyengine.scenes.SceneManger;
	import copyengine.utils.GeneralUtils;

	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

	public class PerLoaderScene implements IScene
	{
		private var sceneContainer:DisplayObjectContainer;

		public function PerLoaderScene()
		{
		}

		public function startPerloadScene() : void
		{
			sceneContainer = new Sprite();
			CopyEngineFacade.instance.registerMediator( new PerLoadSceneMediator() );
			SceneManger.instance.scenePerloadComplate();
		}

		public function addToStage() : void
		{
			sceneContainer.addChild( CopyEngineAS.perLoaderContainer );
		}

		public function perSceneCleanComplate() : void
		{
		}

		public function startLoadNextScene() : void
		{
		}

		public function nextSceneLoadComplate() : void
		{
		}

		public function cleanScene() : void
		{
			SceneManger.instance.sceneCleanComplate();
		}

		public function removeFromStage() : void
		{
			CopyEngineAS.cleanGamePerLoader();
			CopyEngineFacade.instance.removeMediator( PerLoadSceneMediator.NAME );
			GeneralUtils.removeTargetFromParent(sceneContainer);
			GeneralUtils.clearChild(sceneContainer);
		}

		public function get container() : DisplayObjectContainer
		{
			return sceneContainer;
		}

		public function tick() : void
		{
		}
	}
}