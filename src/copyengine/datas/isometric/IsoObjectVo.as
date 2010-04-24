package copyengine.datas.isometric
{
	import copyengine.actor.isometric.IsoObject;

	public class IsoObjectVo
	{
		public var id:int;
		public var col:int;
		public var row:int;
		public var height:int;
		
		public function IsoObjectVo()
		{
		}
		
		public function clone():IsoObjectVo
		{
			var vo:IsoObjectVo = new IsoObjectVo();
			vo.id = this.id;
			vo.col = this.col;
			vo.row = this.row;
			vo.height = this.height;
			return vo;
		}
		
	}
}