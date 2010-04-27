package copyengine.datas.isometric
{
	import flash.utils.ByteArray;

	public interface ICEVo
	{
		function clone() : ICEVo;
		function encode() : ByteArray;
		function decode(_btyeArray:ByteArray) : void;
	}
}