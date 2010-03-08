package copyengine.scenes
{
	import flash.display.DisplayObjectContainer;

	/**
	 * all CopyEngine Scene should implements this interface. 
	 * from one scene change to another should follow those step:
	 * 
	 * --> SceneManger.instace.ChangeSceneTo(S2);
	 * --> S1.startLoadNextScene();
	 * --> S2.startPerloadScene();
	 * 									--> SceneManger.instance.scenePerloadComplate();
	 * 									--> SceneManger.instance.addChild(S2.container);
	 * --> S2.addToStage();
	 * --> S1.nextSceneLoadComplate();
	 * --> S1.cleanScene();
	 * 							--> SceneManger.instance.sceneCleanComplate();
	 * 							--> Scenemanger.instance.removeChild(S1.container);
	 * --> S1.removeFromStage();
	 * --> S2.perSceneCleanComplate();
	 * 
	 * 
	 * @author Tunied
	 * 
	 */	
	public interface IScene
	{
		function startPerloadScene():void;
		function addToStage():void;
		function perSceneCleanComplate():void;
		
		function startLoadNextScene():void;
		function nextSceneLoadComplate():void;
		function cleanScene():void;
		function removeFromStage():void;
		
		function get container():DisplayObjectContainer;
		function tick():void;
	}
}