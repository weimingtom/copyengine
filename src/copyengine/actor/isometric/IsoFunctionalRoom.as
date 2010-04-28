package copyengine.actor.isometric
{
	import copyengine.datas.isometric.FunctionalRoomVo;
	import copyengine.datas.isometric.IsoObjectVo;
	import copyengine.utils.ResUtils;
	
	import flash.display.MovieClip;

	public class IsoFunctionalRoom
	{
		//need stone in metaData later
		public var roomSize:int = 1 ;
		
		public var container:MovieClip;
		
		private var functionalRoomVo:FunctionalRoomVo;

		public function IsoFunctionalRoom(_functionalRoomVo:FunctionalRoomVo)
		{
			functionalRoomVo = _functionalRoomVo;
			container = ResUtils.getMovieClip("IsoWall_Decorate",ResUtils.FILE_ISOHAX);
		}
		
		public function clone():IsoFunctionalRoom
		{
			return new IsoFunctionalRoom(functionalRoomVo.clone() as FunctionalRoomVo);
		}
		
		
	}
}