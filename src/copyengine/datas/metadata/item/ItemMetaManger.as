package copyengine.datas.metadata.item
{
	import copyengine.utils.ResUtlis;
	import copyengine.utils.debug.DebugLog;

	import flash.utils.Dictionary;

	public class ItemMetaManger
	{
		private static var _instance:ItemMetaManger;

		public static function get instance() : ItemMetaManger
		{
			if (_instance == null)
			{
				_instance = new ItemMetaManger();
			}
			return _instance;
		}

		private var itemMetaList:Vector.<ItemMeta>;
		private var itemMetaListLength:int;

		public function ItemMetaManger()
		{
		}

		public function initialize() : void
		{
			itemMetaList = new Vector.<ItemMeta>();
			var itemConfig:XML = ResUtlis.getXML("ItemConfig");
			for each (var itemNode : XML in itemConfig.item)
			{
				var item:ItemMeta = new ItemMeta();
				item.id = itemNode.@id;
				item.iconSymbolName = itemNode.@iconSymbolName;
				item.iconFileName = itemNode.@iconFileName;
				item.symbolName = itemNode.@symbolName;
				item.fileName = itemNode.@fileName;
				item.maxCol = itemNode.@maxCol;
				item.maxRow = itemNode.@maxRow;
				item.maxHeight = itemNode.@maxHeight;
				
				itemMetaList.push(item);
			}
			itemMetaListLength = itemMetaList.length;
			ResUtlis.disposeFile("ItemConfig");
		}

		public function getItemMetaByID(_id:int) : ItemMeta
		{
			for (var i:int = 0 ; i < itemMetaListLength ; i++)
			{
				if (_id == itemMetaList[i].id)
				{
					return itemMetaList[i];
				}
			}
			DebugLog.instance.log("Can't Find ItemMeta with id : " + _id , DebugLog.LOG_TYPE_ERROR);
			return null;
		}


	}
}