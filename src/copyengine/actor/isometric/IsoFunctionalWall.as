package copyengine.actor.isometric
{
	import game.datas.isometric.IsoObjectVo;
	import copyengine.utils.IsometricUtils;
	import copyengine.utils.UintAttribute;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Point;
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
			roomList = new Vector.<IsoFunctionalRoom>();

			super(_isoObjectVo);
		}

		override protected function doInitialize() : void
		{
		}

		public function isCanAddFunctionalRoomTo(_col:int , _row:int , _room:IsoFunctionalRoom) : Boolean
		{
			var startPosition:int = getPositionByTileID(_col,_row);
			if (startPosition + _room.roomSize > roomSpace + 1)
			{
				return false;
			}
			else
			{
				for (var pos:int = startPosition ; pos < startPosition + _room.roomSize ; pos++)
				{
					if (UintAttribute.hasAttribute(wallAttribute,pos))
					{
						return false;
					}
				}
				return true;
			}
		}

		/**
		 * WARNINIG::
		 * 		should call isCanAddFunctionRoomTo() function first to check.
		 */
		public function addFunctionalRoom(_room:IsoFunctionalRoom , _sceneCol:int , _sceneRow:int) : void
		{
			roomList.push(_room);
			container.addChild(_room.container);
			var startPosition:int = getPositionByTileID(_sceneCol,_sceneRow);
			_room.functionalRoomVo.spaceId = startPosition;
			_room.setIsoFunctionalWall(this);
			for (var pos:int = startPosition ; pos < startPosition + _room.roomSize ; pos++)
			{
				wallAttribute = UintAttribute.setAttribute(wallAttribute,pos);
			}
			stickFunctionalRoomOnTheWall(this,_room.container,_sceneCol,_sceneRow);
		}

		public function removeFunctionalRoom(_room:IsoFunctionalRoom) : void
		{
			for (var i:int = 0 ; i < roomList.length ; i++)
			{
				if (_room == roomList[i])
				{
					roomList.splice(i,1);
					container.removeChild(_room.container);
					var startPosition:int = _room.functionalRoomVo.spaceId;
					for (var pos:int = startPosition ; pos < startPosition + _room.roomSize ; pos++)
					{
						wallAttribute = UintAttribute.removeAttribute(wallAttribute,pos);
					}
					break;
				}
			}
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

		//===================
		//== Utils Function
		//===================
		public static function stickFunctionalRoomOnTheWall(_wall:IsoFunctionalWall , 
			_functionalRoomContainer:MovieClip , _roomSceneCol:int , _roomSceneRow:int) : void
		{
			var offsetCol:int = 0;
			var offsetRow:int = 0;
			if (_wall.direction == DIR_NW_ES)
			{

				offsetCol =(_roomSceneCol - _wall.fastGetValue_Col)/MINIMUM_ROOM_SIZE;
				_functionalRoomContainer.gotoAndStop(3);
			}
			else
			{
				offsetRow = (_roomSceneRow - _wall.fastGetValue_Row)/MINIMUM_ROOM_SIZE;
				_functionalRoomContainer.gotoAndStop(2);
			}
			var scenePos:Point = IsometricUtils.convertIsoPosToScreenPos(offsetCol*MINIMUM_ROOM_SIZE,offsetRow*MINIMUM_ROOM_SIZE,0);
			_functionalRoomContainer.x = scenePos.x;
			_functionalRoomContainer.y = scenePos.y;
			scenePos = null;
		}


	}
}