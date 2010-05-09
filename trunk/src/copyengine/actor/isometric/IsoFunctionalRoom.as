package copyengine.actor.isometric
{
	import game.datas.isometric.FunctionalRoomVo;
	import game.datas.isometric.IsoObjectVo;
	import game.datas.metadata.item.ItemMetaManger;
	import game.datas.metadata.item.type.ItemMetaFunctionalRoom;
	import copyengine.dragdrop.IDragDropSource;
	import copyengine.utils.GeneralUtils;
	import copyengine.utils.ResUtils;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import game.scene.testIso.dragdrop.source.functionalroom.DragFromInsideIsoFunctionalRoomDragDropSource;

	public class IsoFunctionalRoom
	{
		public var roomSize:int;

		public var container:MovieClip;

		protected var isoFunctionalWall:IsoFunctionalWall;

		public var functionalRoomVo:FunctionalRoomVo;

		public function IsoFunctionalRoom(_functionalRoomVo:FunctionalRoomVo)
		{
			functionalRoomVo = _functionalRoomVo;
			initialize();
		}

		private function initialize() : void
		{
			var itemMetaFunctionalRoom:ItemMetaFunctionalRoom = ItemMetaManger.instance.getItemMetaByID(functionalRoomVo.id) as ItemMetaFunctionalRoom;
			container = ResUtils.getMovieClip(itemMetaFunctionalRoom.symbolName,itemMetaFunctionalRoom.fileName);
			roomSize = itemMetaFunctionalRoom.roomSize;
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