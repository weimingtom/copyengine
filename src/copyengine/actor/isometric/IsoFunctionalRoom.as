package copyengine.actor.isometric
{
	import copyengine.datas.isometric.FunctionalRoomVo;
	import copyengine.datas.isometric.IsoObjectVo;

	public class IsoFunctionalRoom
	{
		//need stone in metaData later
		public var roomSize:int;
		
		private var functionalRoomVo:FunctionalRoomVo;

		public function IsoFunctionalRoom(_functionalRoomVo:FunctionalRoomVo)
		{
			functionalRoomVo = _functionalRoomVo;
		}
		
		public function clone():IsoFunctionalRoom
		{
			return new IsoFunctionalRoom(functionalRoomVo.clone() as FunctionalRoomVo);
		}
		
		
	}
}