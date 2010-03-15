package copyengine.scenes
{
	public class SceneMessage
	{
		
		/**
		 * when finished change scene fome A to B (after B.perSceneCleanComplate() see in SceneManger.sceneCleanComplate)
		 * then send this notification.
		 */		
		public static const CHANGE_SCENE_COMPLATE:String = "SceneMessage_ChangeSceneComplate";
		
		public function SceneMessage()
		{
		}
	}
}