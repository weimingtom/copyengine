package game.datas.metadata.item.type
{

	public class ItemMetaBasic
	{

		public var id:int;
		public var type:String;
		public var symbolName:String;
		public var fileName:String;
		public var maxCol:int;
		public var maxRow:int;
		public var maxHeight:int;

		public function ItemMetaBasic()
		{
		}

		public function initialize(_node:XML) : void
		{
			id = _node.@id;
			symbolName = _node.@symbolName;
			fileName = _node.@fileName;
			maxCol = _node.@maxCol;
			maxRow = _node.@maxRow;
			maxHeight = _node.@maxHeight;
		}

	}
}