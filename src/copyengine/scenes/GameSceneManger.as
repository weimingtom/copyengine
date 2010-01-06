package copyengine.scenes
{
	import copyengine.debug.DebugLog;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import game.scene.IsoHexScene;
	
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class GameSceneManger extends Mediator
	{
		public static const GAMESCENE_TEST:String="IsoHexScene";

		private static var _instance:GameSceneManger;

		public static function get instance() : GameSceneManger
		{
			if (_instance == null)
			{
				_instance = new GameSceneManger();
			}
			return _instance;
		}

		private var sceneContainer:Sprite; // all the gameScene should be one of this container child

		private var currentScene:IGameScene;

		private var isChangeToNextGameScene:Boolean = false;

		private var nextSceneName:String = null;

		public function GameSceneManger()
		{
			sceneContainer = new Sprite();
			sceneContainer.addEventListener(Event.ENTER_FRAME,gameSceneMangerTick);
		}

		/**
		 * this function should be call first , before other functions call
		 */
		public function init(_parent:DisplayObjectContainer , _firstScene:IGameScene) : void
		{
			_parent.addChild(sceneContainer);
			
			currentScene = _firstScene;
			sceneContainer.addChild(currentScene.sceneContainer);
		}

		public function changeScene(_name:String) : void
		{
			nextSceneName = _name;
			isChangeToNextGameScene = true;
		}

		private function gameSceneMangerTick(e:Event) : void
		{
			if (isChangeToNextGameScene)
			{
				changeToNextScene();
			}
			else
			{
				if (currentScene != null)
				{
					currentScene.tick();
				}
			}
		}

		private function changeToNextScene() : void
		{
			if (currentScene != null)
			{
				currentScene.destoryScene();
			}
			currentScene = getGameSceneByName(nextSceneName);
			sceneContainer.addChild(currentScene.sceneContainer);
			currentScene.initScene();

			isChangeToNextGameScene = false;
			nextSceneName = null;

		}

		private function getGameSceneByName(_name:String) : IGameScene
		{
			switch (_name)
			{
				case GAMESCENE_TEST:
					return new IsoHexScene();
					break;
			}
			DebugLog.instance.log("Can't Find the gameScene : " + _name +"  " ,DebugLog.LOG_TYPE_ERROR);
			return null;
		}

	}
}