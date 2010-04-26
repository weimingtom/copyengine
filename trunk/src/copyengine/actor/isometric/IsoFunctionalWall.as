package copyengine.actor.isometric
{
	import copyengine.datas.isometric.IsoObjectVo;
	
	import flash.display.DisplayObject;
	
	import flashx.textLayout.formats.Direction;
	
	public class IsoFunctionalWall extends IsoObject
	{
		/**
		 * define the minimum room cost tile size 
		 */		
		public static const MINIMUM_ROOM_SIZE:int = 3;
		public static const DIR_NW_ES:int = 0;
		public static const DIR_NE_SW:int = 1;
		
		/**
		 * define the wallDirection (NW-ES / NE-SW) 
		 */		
		private var direction:int;
		
		/**
		 * define the space of the wall (how many room can this wall fit in)
		 */		
		private var roomSpace:int;
		
		private var roomList:Vector.<IsoFunctionalRoom>;
		
		public function IsoFunctionalWall(_direction:int , _roomSpace:int , _isoObjectVo:IsoObjectVo)
		{
			direction = _direction;
			roomSpace = _roomSpace;
			super(_isoObjectVo);
		}
		
		override protected function doInitialize():void
		{
		}
		
		public function isCanAddFunctionRoomTo(_col:int , _row:int):Boolean
		{
			trace(getPositionByTileID(_col,_row) );
			return true;
		}
		
		public function moveFunctionalRoomTo(_col:int , _row:int):void
		{
		}
		
		public function addFunctionalRoomDisplay(_room:IsoFunctionalRoom , _col:int , _row:int):void
		{
		}
		
		public function removeFunctionalRoomDisplay(_room:IsoFunctionalRoom):void
		{
		}
		
		override public function clone():IsoObject
		{
			return new IsoFunctionalWall(direction , roomSpace , isoObjectVo.clone());
		}
		
		private function getPositionByTileID(_col:int , _row:int):int
		{
			if(direction == DIR_NE_SW)
			{
				return (isoObjectVo.row - _row)/MINIMUM_ROOM_SIZE;
			}
			else
			{
				return (isoObjectVo.col - _col)/MINIMUM_ROOM_SIZE;
			}
		}
		
	}
}