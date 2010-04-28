package copyengine.actor.isometric
{
	import copyengine.datas.isometric.FunctionalRoomVo;
	import copyengine.datas.isometric.IsoObjectVo;
	import copyengine.dragdrop.IDragDropSource;
	import copyengine.utils.GeneralUtils;
	import copyengine.utils.ResUtils;

	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	import game.scene.testIso.dragdrop.source.functionalroom.DragFromInsideIsoFunctionalRoomDragDropSource;

	public class IsoFunctionalRoom
	{
		//need stone in metaData later
		public var roomSize:int = 1 ;

		public var container:MovieClip;

		protected var isoFunctionalWall:IsoFunctionalWall;

		protected var functionalRoomVo:FunctionalRoomVo;

		public function IsoFunctionalRoom(_functionalRoomVo:FunctionalRoomVo)
		{
			functionalRoomVo = _functionalRoomVo;
		}

		private function initialize() : void
		{
			container = ResUtils.getMovieClip("IsoWall_Decorate",ResUtils.FILE_ISOHAX);
			doInitialize();
		}

		public final function setIsoFunctionalWall(_wall:IsoFunctionalWall) : void
		{
			isoFunctionalWall = _wall;
		}

		public function clone() : IsoFunctionalRoom
		{
			return new IsoFunctionalRoom(functionalRoomVo.clone() as FunctionalRoomVo);
		}

		protected function doInitialize() : void
		{
		}


	}
}