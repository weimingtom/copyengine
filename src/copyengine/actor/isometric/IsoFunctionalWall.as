package copyengine.actor.isometric
{
	import copyengine.datas.isometric.IsoObjectVo;
	
	import flash.display.DisplayObject;
	
	public class IsoFunctionalWall extends IsoObject
	{
		public function IsoFunctionalWall(_isoObjectVo:IsoObjectVo)
		{
			super(_isoObjectVo);
		}
		
		override protected function doInitialize():void
		{
		}
		
		public function isCanAddFunctionRoomTo(_col:int , _row:int):Boolean
		{
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
			return new IsoFunctionalWall(isoObjectVo.clone());
		}
	}
}