package copyengine.cache.objectpool
{
	public interface IPoolObject
	{
		function reSetObject():void;
		function cleanObject():void;
		function disposeObject():void;
	}
}