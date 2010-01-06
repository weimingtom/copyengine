package copyengine.scenes
{
	import flash.display.DisplayObjectContainer;

	/**
	 * Each game scene should implements this interface, so that GameSceneManger can handel
	 * it for init/destory.
	 *
	 */
	public interface IGameScene
	{
		function tick() : void;

		function get sceneContainer() : DisplayObjectContainer;

		function initScene() : void;

		function destoryScene() : void;
	}
}