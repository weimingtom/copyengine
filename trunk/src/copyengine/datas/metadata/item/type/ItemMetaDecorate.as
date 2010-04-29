package copyengine.datas.metadata.item.type
{

	public class ItemMetaDecorate extends ItemMetaBasic
	{
		public var iconSymbolName:String;
		public var iconFileName:String;

		public function ItemMetaDecorate()
		{
			super();
		}

		override public function initialize(_node:XML) : void
		{
			iconSymbolName = _node.@iconSymbolName;
			iconFileName = _node.@iconFileName;
			super.initialize(_node);
		}
	}
}