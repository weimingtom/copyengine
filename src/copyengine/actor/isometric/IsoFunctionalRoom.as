package copyengine.actor.isometric
{
	import copyengine.datas.isometric.IsoObjectVo;
	
	public class IsoFunctionalRoom extends IsoObject
	{
		//need stone in metaData later
		public var roomSize:int;
		
		public function IsoFunctionalRoom(_isoObjectVo:IsoObjectVo)
		{
			super(_isoObjectVo);
		}
		
	}
}