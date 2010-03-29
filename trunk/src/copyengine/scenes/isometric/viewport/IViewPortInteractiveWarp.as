package copyengine.scenes.isometric.viewport
{
	import flash.display.DisplayObjectContainer;

	/**
	 *IViewPortInteractiveWarp is use to proxy any Player interactive to the viewport
	 * @see more on IsoSceneBasic.initialize();
	 *  
	 * @author Tunied
	 * 
	 */	
	public interface IViewPortInteractiveWarp
	{
		function initialize(_viewPort:IIsoViewPort):void;
		function get container():DisplayObjectContainer;
		function dispose():void;
		function tick():void;
	}
}