package copyengine.actor.isometric
{
	import copyengine.datas.isometric.IsoObjectVo;
	import copyengine.utils.UintAttribute;

	import flash.display.DisplayObject;
	import flash.geom.Utils3D;
	import flash.utils.Dictionary;

	import flashx.textLayout.formats.Direction;

	public class IsoFunctionalWall extends IsoObject
	{
		/**
		 * define the minimum room cost tile size
		 */
		public static const MINIMUM_ROOM_SIZE:int = 3;
		/**
		 *		 *
		 *     		*
		 * 		  	   *
		 */		
		public static const DIR_NW_ES:int = 0;
		/**
		 *			*
		 * 		  *
		 * 		*
		 */		
		public static const DIR_NE_SW:int = 1;

		/**
		 * define the wallDirection (NW-ES / NE-SW)
		 */
		public var direction:int;

		/**
		 * define the space of the wall (how many room can this wall fit in)
		 */
		public var roomSpace:int;

		private var wallAttribute:uint;
		private var roomList:Vector.<IsoFunctionalRoom>;

		public function IsoFunctionalWall(_direction:int , _roomSpace:int , _isoObjectVo:IsoObjectVo)
		{
			direction = _direction;
			roomSpace = _roomSpace;
			super(_isoObjectVo);
		}

		override protected function doInitialize() : void
		{
		}

		public function isCanAddFunctionRoomTo(_col:int , _row:int , _room:IsoFunctionalRoom) : Boolean
		{
			return true;
//			var startPosition:int = getPositionByTileID(_col,_row);
//			if (startPosition + _room.roomSize > roomSpace + 1)
//			{
//				return false;
//			}
//			else
//			{
//				for (var pos:int = startPosition ; pos < startPosition + _room.roomSize ; pos++)
//				{
//					if (UintAttribute.hasAttribute(wallAttribute,pos))
//					{
//						return false;
//					}
//				}
//				return true;
//			}
		}

		private function getPositionByTileID(_col:int , _row:int) : int
		{
			if (direction == DIR_NE_SW)
			{
				return (_row - isoObjectVo.row)/MINIMUM_ROOM_SIZE;
			}
			else
			{
				return (_col - isoObjectVo.col)/MINIMUM_ROOM_SIZE;
			}
		}
		
		override public function clone() : IsoObject
		{
			return new IsoFunctionalWall(direction , roomSpace , isoObjectVo.clone());
		}

	}
}