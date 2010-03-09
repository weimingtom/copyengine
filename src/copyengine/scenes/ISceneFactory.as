package copyengine.scenes
{
	/**
	 *Each Game should create an class to implemetns this interface.
	 * SceneManger use createScene function to get an gameScene.
	 *  
	 * @author Tunied
	 * 
	 */	
	public interface ISceneFactory
	{
		function createScene(_sceneName:String):IScene;
	}
}