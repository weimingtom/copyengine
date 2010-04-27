package copyengine.datas.isometric
{
	import flash.utils.ByteArray;

	public final class FunctionalRoomVo implements ICEVo
	{
		/**
		 * FunctionalRoomID ( use to find MetaData)
		 */
		public var id:int;

		/**
		 * define current functionalRoom stick at which wall
		 */
		public var wallId:int;

		/**
		 * define current functionalRoom in which space of the wall
		 */
		public var spaceId:int;

		public function FunctionalRoomVo()
		{
		}

		public function clone() : ICEVo
		{
			var vo:FunctionalRoomVo;
			vo = new FunctionalRoomVo();
			vo.id = this.id;
			vo.wallId = this.wallId;
			vo.spaceId = this.spaceId;
			return vo;
		}

		public function encode() : ByteArray
		{
			return null;
		}

		public function decode(_btyeArray:ByteArray) : void
		{

		}

	}
}