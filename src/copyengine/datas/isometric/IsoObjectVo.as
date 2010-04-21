package copyengine.datas.isometric
{
	import copyengine.actor.isometric.IsoObject;

	public class IsoObjectVo
	{
		public var col:int;
		public var row:int;
		public var height:int;
		
		public var maxCols:int;
		public var maxRows:int;
		
		
		public function IsoObjectVo()
		{
		}
		
		public function clone():IsoObjectVo
		{
			var vo:IsoObjectVo = new IsoObjectVo();
			vo.col = this.col;
			vo.row = this.row;
			vo.height = this.height;
			vo.maxCols = this.maxCols;
			vo.maxRows = this.maxRows;
			
			return vo;
		}
		
	}
}