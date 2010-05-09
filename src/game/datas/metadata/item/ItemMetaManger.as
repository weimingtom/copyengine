package game.datas.metadata.item
{
	import game.datas.isometric.FunctionalRoomVo;
	import game.datas.metadata.item.type.ItemMetaBasic;
	import game.datas.metadata.item.type.ItemMetaDecorate;
	import game.datas.metadata.item.type.ItemMetaFunctionalRoom;
	import game.datas.metadata.item.type.ItemMetaFunctionalWall;
	import copyengine.utils.ResUtils;
	import copyengine.utils.debug.DebugLog;
	
	import flash.utils.Dictionary;

	public class ItemMetaManger
	{
		public static const TYPE_DECORATE:String = "decorate";
		public static const TYPE_ISO_FUNCTIONAL_WALL:String = "isoFunctionalWall";
		public static const TYPE_ISO_FUNCTIONAL_ROOM:String = "isoFunctionalRoom";
		
		private static var _instance:ItemMetaManger;

		public static function get instance() : ItemMetaManger
		{
			if (_instance == null)
			{
				_instance = new ItemMetaManger();
			}
			return _instance;
		}

		private var itemMetaList:Vector.<ItemMetaBasic>;
		private var itemMetaListLength:int;

		public function ItemMetaManger()
		{
		}

		public function initialize() : void
		{
			itemMetaList = new Vector.<ItemMetaBasic>();
			var itemConfig:XML = ResUtils.getXML("ItemConfig");
			for each (var metaList : XML in itemConfig.elements())
			{
				var type:String = metaList.name().localName;
				for each (var itemNode : XML in metaList.item)
				{
					var itemMetaBasic:ItemMetaBasic = createItemMetaByType(type);
					itemMetaBasic.type = type;
					itemMetaBasic.initialize(itemNode);
					itemMetaList.push(itemMetaBasic);
				}
			}
			itemMetaListLength = itemMetaList.length;
			ResUtils.disposeFile("ItemConfig");
		}

		public function getItemMetaByID(_id:int) : ItemMetaBasic
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

		public function getItemMetaByType(_type:String) : Vector.<ItemMetaBasic>
		{
			var list:Vector.<ItemMetaBasic> = new Vector.<ItemMetaBasic>();
			for (var i:int = 0 ; i < itemMetaListLength ; i++)
			{
				if (itemMetaList[i].type == _type)
				{
					list.push(itemMetaList[i]);
				}
			}
			return list;
		}

		private function createItemMetaByType(_type:String) : ItemMetaBasic
		{
			switch (_type)
			{
				case TYPE_DECORATE:
					return new ItemMetaDecorate();
					break;
				case TYPE_ISO_FUNCTIONAL_WALL:
					return new ItemMetaFunctionalWall();
					break;
				case TYPE_ISO_FUNCTIONAL_ROOM:
					return new ItemMetaFunctionalRoom();
					break;
			}
			DebugLog.instance.log("Can't find MetaType :" + _type , DebugLog.LOG_TYPE_ERROR);
			return null;
		}

	}
}