package copyengine.actor.isometric
{
	import flash.display.DisplayObjectContainer;

	public interface IIsoObject
	{
		function get col():int;
		function set col(_value:int):void;
		
		function get row():int;
		function set row(_value:int):void;
		
		function get height():int;
		function set height(_value:int):void;
			
		function get maxCols():int;
		function set  maxCols(_value:int):void;
		
		function get maxRows():int;
		function set maxRows(_value:int):void;
		
		function get container():DisplayObjectContainer;
	}
}