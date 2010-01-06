package copyengine.scenes
{
	/**
	 * Each game scene should implements this interface, so that GameSceneManger can handel
	 * it for init/destory.
	 *
	 */
	public interface IGameScene
	{
		
		function initScene() : void;

		function destoryScene() : void;
	}
}