package copyengine.resource.background
{
	import flash.display.MovieClip;
	
	public interface ILoadFileComplateListener
	{
		function onLoadComplate(_target:Object):void;
		function get symbolName():String;
	}
}