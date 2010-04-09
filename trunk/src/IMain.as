package
{
	import flash.display.Stage;

	public interface IMain
	{
		function initialize(_perLoader:IPerLoader , _stage:Stage , _config:XML):void;
	}
}