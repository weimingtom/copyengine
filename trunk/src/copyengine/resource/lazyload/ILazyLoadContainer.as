package copyengine.resource.lazyload
{
import flash.display.DisplayObject;

/**
 * when requests one displayObject that not loaded yet , then will return one LazyLoadContainer(should be extend sprite)
 * inside of requests target.
 * and when the file has been loaded then will use symbolName/cacheName to determine how to return the value and
 * use onLoadComplate to tell the container the file has been loaded
 */
public interface ILazyLoadContainer
{
	function onLoadComplate (_target:DisplayObject) : void;
	function get symbolName () : String;
	function get cacheName () : String;
	function get targetScaleX () : Number;
	function get targetScaleY () : Number;
}
}