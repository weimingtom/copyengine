package copyengine.datas.metadata.item.type
{
	public class ItemMetaFunctionalRoom extends ItemMetaBasic
	{
		public var roomSize:int;
		public var iconSymbolName:String;
		public var iconFileName:String;
		
		public function ItemMetaFunctionalRoom()
		{
			super();
		}
		
		override public function initialize(_node:XML):void
		{
			roomSize = _node.@roomSize;
			iconSymbolName = _node.@iconSymbolName;
			iconFileName = _node.@iconFileName;
			super.initialize(_node);
		}
		
	}
}