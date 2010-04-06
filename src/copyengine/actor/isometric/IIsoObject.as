package copyengine.actor.isometric
{
	import flash.display.DisplayObjectContainer;

	public interface IIsoObject
	{
		function get col():int;
		function get row():int;
		function get height():int;
		
		function get maxCols():int;
		function get maxRows():int;
		
		function get container():DisplayObjectContainer;
	}
}