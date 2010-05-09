package game.datas.metadata.item.type
{
	public class ItemMetaFunctionalWall extends ItemMetaBasic
	{
		public var col:int;
		public var row:int;
		public var roomSpace:int;
		public var direction:int;
		
		public function ItemMetaFunctionalWall()
		{
			super();
		}
		
		override public function initialize(_node:XML):void
		{
			col = _node.@col;
			row =  _node.@row;
			roomSpace = _node.@roomSpace;
			direction = _node.@direction;
			super.initialize(_node);
		}
		
	}
}