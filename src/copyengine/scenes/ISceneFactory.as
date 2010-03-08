package copyengine.scenes
{
	public interface ISceneFactory
	{
		function createScene(_sceneName:String):IScene;
	}
}