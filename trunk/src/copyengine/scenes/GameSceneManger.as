package copyengine.scenes
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

	import game.scene.IsoHexScene;

	public class GameSceneManger
	{
		private static var _instance:GameSceneManger;

		public static function get instance() : GameSceneManger
		{
			if (_instance == null)
			{
				_instance = new GameSceneManger();
			}
			return _instance;
		}

		private var sceneContainer:Sprite;

		public function GameSceneManger()
		{
			sceneContainer = new Sprite();
		}

		public function init(_parent:DisplayObjectContainer) : void
		{
			_parent.addChild(sceneContainer);
		}

		public function changeScene(_name:String) : void
		{
			var gameScene:IsoHexScene = new IsoHexScene();
			sceneContainer.addChild( gameScene );
			gameScene.init();
		}
	}
}